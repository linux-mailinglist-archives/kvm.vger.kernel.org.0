Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D60A2437FD
	for <lists+kvm@lfdr.de>; Thu, 13 Aug 2020 11:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgHMJwQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 05:52:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:34810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726048AbgHMJwQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Aug 2020 05:52:16 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8007E2074D;
        Thu, 13 Aug 2020 09:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597312335;
        bh=giRbKmVntSvhX0nekqsc2yIFsJh4IIaldkUru1ENsns=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bOr02JwIBVdUa8K5PnV6OvNBmNQeTBwVv2R41g7G+wFneiPUkpse7fn9GEhD697Fb
         YyK6vUOhi3h4jH+YifCYKpUu675MuCOZpLy8yZTYvSqwE/a9KN/opFWXYG7VkZWE6O
         llMX/Np1Wl4h5mYcY0gbk4k4uXrMY71HQyVag5HE=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k69u9-001kVc-Mc; Thu, 13 Aug 2020 10:52:13 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 13 Aug 2020 10:52:13 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Peng Liang <liangpeng10@huawei.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, will@kernel.org,
        zhang.zhanghailiang@huawei.com, xiexiangyou@huawei.com
Subject: Re: [RFC 3/4] kvm: arm64: make ID registers configurable
In-Reply-To: <20200813060517.2360048-4-liangpeng10@huawei.com>
References: <20200813060517.2360048-1-liangpeng10@huawei.com>
 <20200813060517.2360048-4-liangpeng10@huawei.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <73a299dd67053f094498dd98a65fbc71@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: liangpeng10@huawei.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, will@kernel.org, zhang.zhanghailiang@huawei.com, xiexiangyou@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-08-13 07:05, Peng Liang wrote:
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
> @@ -1111,6 +1111,14 @@ static u64 kvm_get_id_reg(struct kvm_vcpu *vcpu, 
> u64 id)
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
> @@ -1252,10 +1260,6 @@ static int set_id_aa64zfr0_el1(struct kvm_vcpu 
> *vcpu,
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
> +	}
> 
>  	return 0;
>  }

This cannot work. If userspace can override an idreg, it cannot
conflict with anything the HW is capable of. It also cannot
conflict with features that the host doesn't want to expose
to the guest.

Another thing is that you now have features that do not
match the MIDR (you can describe an A57 with SVE, for example).
This will trigger issues in guests, as the combination isn't expected.

And then there is the eternal story about errata workarounds.
If you can override the ID regs, how can the guest mitigate
errata that you are now hiding from it?

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
