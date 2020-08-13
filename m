Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72B4B24374E
	for <lists+kvm@lfdr.de>; Thu, 13 Aug 2020 11:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgHMJJh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 05:09:37 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23752 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726053AbgHMJJg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Aug 2020 05:09:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597309775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=huCoVCoxH7DGOX1gt2J0Q8XYRcnSSnTcRRYMzxvz/ZQ=;
        b=d2YMDOEriSop8yL3mq/vpn/7MJsioeFs0emfLO/1dyCfbvO+5FVD8HftPhET1mSA9QD0NJ
        X/Agkh+zFhnoxz4v8U14K8vKZO13tHgtpZ8qMQc63+bCvnh0HiluJpjDzX46NyAlln4IVM
        b/OLMn3KT2faVoxSWt2TzTqT/iWnlk0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-457-gEA45nlrMSC5q-0uUalZsQ-1; Thu, 13 Aug 2020 05:09:34 -0400
X-MC-Unique: gEA45nlrMSC5q-0uUalZsQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8CCFE79EC1;
        Thu, 13 Aug 2020 09:09:32 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.72])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 82C6117150;
        Thu, 13 Aug 2020 09:09:30 +0000 (UTC)
Date:   Thu, 13 Aug 2020 11:09:27 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Peng Liang <liangpeng10@huawei.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, maz@kernel.org,
        will@kernel.org, zhang.zhanghailiang@huawei.com,
        xiexiangyou@huawei.com
Subject: Re: [RFC 3/4] kvm: arm64: make ID registers configurable
Message-ID: <20200813090927.busuifugzatw5sem@kamzik.brq.redhat.com>
References: <20200813060517.2360048-1-liangpeng10@huawei.com>
 <20200813060517.2360048-4-liangpeng10@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200813060517.2360048-4-liangpeng10@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 13, 2020 at 02:05:16PM +0800, Peng Liang wrote:
> It's time to make ID registers configurable.  When userspace (but not
> guest) want to set the values of ID registers, save the value in
> kvm_arch_vcpu so that guest can read the modified values.
> 
> Signed-off-by: zhanghailiang <zhang.zhanghailiang@huawei.com>
> Signed-off-by: Peng Liang <liangpeng10@huawei.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 23 ++++++++++++++++-------
>  1 file changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 776c2757a01e..f98635489966 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1111,6 +1111,14 @@ static u64 kvm_get_id_reg(struct kvm_vcpu *vcpu, u64 id)
>  	return ri->sys_val;
>  }
>  
> +static void kvm_set_id_reg(struct kvm_vcpu *vcpu, u64 id, u64 value)
> +{
> +	struct id_reg_info *ri = kvm_id_reg(vcpu, id);
> +
> +	BUG_ON(!ri);
> +	ri->sys_val = value;
> +}
> +
>  /* Read a sanitised cpufeature ID register by sys_reg_desc */
>  static u64 read_id_reg(struct kvm_vcpu *vcpu,
>  		struct sys_reg_desc const *r, bool raz)
> @@ -1252,10 +1260,6 @@ static int set_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
>  
>  /*
>   * cpufeature ID register user accessors
> - *
> - * For now, these registers are immutable for userspace, so no values
> - * are stored, and for set_id_reg() we don't allow the effective value
> - * to be changed.
>   */
>  static int __get_id_reg(struct kvm_vcpu *vcpu,
>  			const struct sys_reg_desc *rd, void __user *uaddr,
> @@ -1279,9 +1283,14 @@ static int __set_id_reg(struct kvm_vcpu *vcpu,
>  	if (err)
>  		return err;
>  
> -	/* This is what we mean by invariant: you can't change it. */
> -	if (val != read_id_reg(vcpu, rd, raz))
> -		return -EINVAL;
> +	if (raz) {
> +		if (val != read_id_reg(vcpu, rd, raz))
> +			return -EINVAL;
> +	} else {
> +		u32 reg_id = sys_reg((u32)rd->Op0, (u32)rd->Op1, (u32)rd->CRn,
> +				     (u32)rd->CRm, (u32)rd->Op2);
> +		kvm_set_id_reg(vcpu, reg_id, val);

So userspace can set the ID registers to whatever they want? I think each
register should have its own sanity checks applied before accepting the
input.

Thanks,
drew

> +	}
>  
>  	return 0;
>  }
> -- 
> 2.18.4
> 

