Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9C713B713
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2019 16:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390748AbfFJORV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jun 2019 10:17:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38290 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390501AbfFJORV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jun 2019 10:17:21 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BEA6C61980;
        Mon, 10 Jun 2019 14:17:20 +0000 (UTC)
Received: from flask (unknown [10.43.2.83])
        by smtp.corp.redhat.com (Postfix) with SMTP id 9A42819C59;
        Mon, 10 Jun 2019 14:17:18 +0000 (UTC)
Received: by flask (sSMTP sendmail emulation); Mon, 10 Jun 2019 16:17:17 +0200
Date:   Mon, 10 Jun 2019 16:17:17 +0200
From:   Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: Re: [PATCH v3 2/3] KVM: X86: Implement PV sched yield hypercall
Message-ID: <20190610141717.GA6604@flask>
References: <1559178307-6835-1-git-send-email-wanpengli@tencent.com>
 <1559178307-6835-3-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1559178307-6835-3-git-send-email-wanpengli@tencent.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Mon, 10 Jun 2019 14:17:20 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

2019-05-30 09:05+0800, Wanpeng Li:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> The target vCPUs are in runnable state after vcpu_kick and suitable 
> as a yield target. This patch implements the sched yield hypercall.
> 
> 17% performance increasement of ebizzy benchmark can be observed in an 
> over-subscribe environment. (w/ kvm-pv-tlb disabled, testing TLB flush 
> call-function IPI-many since call-function is not easy to be trigged 
> by userspace workload).
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Cc: Liran Alon <liran.alon@oracle.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> @@ -7172,6 +7172,28 @@ void kvm_vcpu_deactivate_apicv(struct kvm_vcpu *vcpu)
>  	kvm_x86_ops->refresh_apicv_exec_ctrl(vcpu);
>  }
>  
> +static void kvm_sched_yield(struct kvm *kvm, unsigned long dest_id)
> +{
> +	struct kvm_vcpu *target = NULL;
> +	struct kvm_apic_map *map = NULL;
> +
> +	rcu_read_lock();
> +	map = rcu_dereference(kvm->arch.apic_map);
> +
> +	if (unlikely(!map) || dest_id > map->max_apic_id)
> +		goto out;
> +
> +	if (map->phys_map[dest_id]->vcpu) {

This should check for map->phys_map[dest_id].

> +		target = map->phys_map[dest_id]->vcpu;
> +		rcu_read_unlock();
> +		kvm_vcpu_yield_to(target);
> +	}
> +
> +out:
> +	if (!target)
> +		rcu_read_unlock();

Also, I find the following logic clearer

  {
  	struct kvm_vcpu *target = NULL;
  	struct kvm_apic_map *map;
  	
  	rcu_read_lock();
  	map = rcu_dereference(kvm->arch.apic_map);
  	
  	if (likely(map) && dest_id <= map->max_apic_id && map->phys_map[dest_id])
  		target = map->phys_map[dest_id]->vcpu;
  	
  	rcu_read_unlock();
  	
  	if (target)
  		kvm_vcpu_yield_to(target);
  }

thanks.
