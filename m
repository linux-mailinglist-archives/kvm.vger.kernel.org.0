Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC02127876
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 10:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbfLTJvG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 04:51:06 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:30684 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727167AbfLTJvD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Dec 2019 04:51:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576835461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=99eauVFberJXv2fQAwZtixMy3egbUdn3Of2y1/7QSBo=;
        b=IVln0UOQ+zyEwEHp55eUIZiZy/FvqttwaBseZUpaEi7qW2GKRk21WB3vBefLls1NXRIba7
        mTZBO7WsPcULlQ8CaX2KBHZHTnf2YOwlQPFXXXyOPKD/UeoA8CHkVQQ21Cdub+kB1Vagr4
        EjLD6zOjQX+oe7DSP6lxjcGM4VP2kJo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-KSOnSj7mOiGqSWdMbp1wmw-1; Fri, 20 Dec 2019 04:51:00 -0500
X-MC-Unique: KSOnSj7mOiGqSWdMbp1wmw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 04477189CD00;
        Fri, 20 Dec 2019 09:50:58 +0000 (UTC)
Received: from gondolin (dhcp-192-245.str.redhat.com [10.33.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B0B7C26FC4;
        Fri, 20 Dec 2019 09:50:51 +0000 (UTC)
Date:   Fri, 20 Dec 2019 10:50:49 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kurz <groug@kaod.org>
Subject: Re: [PATCH v2 32/45] KVM: Move initialization of preempt notifier
 to kvm_vcpu_init()
Message-ID: <20191220105049.3fbdbbcc.cohuck@redhat.com>
In-Reply-To: <20191218215530.2280-33-sean.j.christopherson@intel.com>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
        <20191218215530.2280-33-sean.j.christopherson@intel.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 18 Dec 2019 13:55:17 -0800
Sean Christopherson <sean.j.christopherson@intel.com> wrote:

> Initialize the preempt notifier immediately in kvm_vcpu_init() to pave
> the way for removing kvm_arch_vcpu_setup(), i.e. to allow arch specific
> code to call vcpu_load() during kvm_arch_vcpu_create().
> 
> Back when preemption support was added, the location of the call to init
> the preempt notifier was perfectly sane.  The overall vCPU creation flow
> featured a single arch specific hook and the preempt notifer was used
> immediately after its initialization (by vcpu_load()).  E.g.:
> 
>         vcpu = kvm_arch_ops->vcpu_create(kvm, n);
>         if (IS_ERR(vcpu))
>                 return PTR_ERR(vcpu);
> 
>         preempt_notifier_init(&vcpu->preempt_notifier, &kvm_preempt_ops);
> 
>         vcpu_load(vcpu);
>         r = kvm_mmu_setup(vcpu);
>         vcpu_put(vcpu);
>         if (r < 0)
>                 goto free_vcpu;
> 
> Today, the call to preempt_notifier_init() is sandwiched between two
> arch specific calls, kvm_arch_vcpu_create() and kvm_arch_vcpu_setup(),
> which needlessly forces x86 (and possibly others?) to split its vCPU
> creation flow.  Init the preempt notifier prior to any arch specific
> call so that each arch can independently decide how best to organize
> its creation flow.
> 
> Acked-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  virt/kvm/kvm_main.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

