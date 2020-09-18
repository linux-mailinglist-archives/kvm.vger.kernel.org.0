Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAFC26F75E
	for <lists+kvm@lfdr.de>; Fri, 18 Sep 2020 09:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgIRHuv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Sep 2020 03:50:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47988 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726192AbgIRHut (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Sep 2020 03:50:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600415448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1/cmhRd1IcV5cBU/89mNL7deEGSS2dukfQx9yWJhGmM=;
        b=Hv9QsWODmW3w3Y0KuCzU+YFw25eO1VM1cVLEMTPAJlY9K1omorBv2bX0Ze/Y+Wg7gzdg8O
        rP/stf/cFrDoG9GFY2XS47BzXf7kc9wF3FtnDRZSWDt65u8QeHzOa6H3VHLFRo7/yLZjxJ
        FJTBC9WxTSY5sqHDawFzgQNhIIj0Y4U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-433-uBxPGBpjMWuwkZ9QL6d_Lw-1; Fri, 18 Sep 2020 03:50:46 -0400
X-MC-Unique: uBxPGBpjMWuwkZ9QL6d_Lw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A2A0C81CAFB;
        Fri, 18 Sep 2020 07:50:44 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.125])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A9ACE73660;
        Fri, 18 Sep 2020 07:50:42 +0000 (UTC)
Date:   Fri, 18 Sep 2020 09:50:39 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Peng Liang <liangpeng10@huawei.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, maz@kernel.org,
        will@kernel.org, zhang.zhanghailiang@huawei.com,
        xiexiangyou@huawei.com
Subject: Re: [RFC v2 6/7] kvm: arm64: make ID registers configurable
Message-ID: <20200918075039.36eezfwbsiearq3h@kamzik.brq.redhat.com>
References: <20200917120101.3438389-1-liangpeng10@huawei.com>
 <20200917120101.3438389-7-liangpeng10@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917120101.3438389-7-liangpeng10@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 17, 2020 at 08:01:00PM +0800, Peng Liang wrote:
> It's time to make ID registers configurable.  When userspace (but not
> guest) want to set the values of ID registers, save the value in
> sysreg file so that guest can read the modified values.
> 
> Signed-off-by: zhanghailiang <zhang.zhanghailiang@huawei.com>
> Signed-off-by: Peng Liang <liangpeng10@huawei.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index a642ecfebe0a..881b66494524 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1263,10 +1263,6 @@ static int set_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
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
> @@ -1290,9 +1286,15 @@ static int __set_id_reg(struct kvm_vcpu *vcpu,
>  	if (err)
>  		return err;
>  
> -	/* This is what we mean by invariant: you can't change it. */
> -	if (val != read_id_reg(vcpu, rd, raz))
> -		return -EINVAL;
> +	if (raz) {
> +		if (val != read_id_reg(vcpu, rd, raz))

val != 0 ?

> +			return -EINVAL;
> +	} else {
> +		u32 reg_id = sys_reg((u32)rd->Op0, (u32)rd->Op1, (u32)rd->CRn,
> +				     (u32)rd->CRm, (u32)rd->Op2);
> +		/* val should be checked in check_user */

It really doesn't make sense to share this trivial set_user function and
have different check functions. Just don't share the set_user function.

> +		__vcpu_sys_reg(vcpu, ID_REG_INDEX(reg_id)) = val;
> +	}
>  
>  	return 0;
>  }
> -- 
> 2.26.2
> 

Thanks,
drew

