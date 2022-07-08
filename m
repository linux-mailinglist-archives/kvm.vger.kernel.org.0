Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C688756C37B
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 01:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238874AbiGHTfj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 15:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238121AbiGHTfi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 15:35:38 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 200FB57245
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 12:35:38 -0700 (PDT)
Date:   Fri, 8 Jul 2022 12:35:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1657308932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3Ycz7xdndecdoawfzbIyPAd3t3ebJtVTm3UIiAKwNFg=;
        b=olzZ+ookEIfsTd28pXfJRmRAuF2JhpMmJkZGekjmDkJWrRfcTMaB4oKdkxiZnMiKk1m9pp
        0qjzQzyC4BkzeXkoddp7UEhYYP3FV7I+XT8g4sLVkvS8MLL+lToUNsChah6E3OfBHQcqtD
        EWKCDcynDRaXTRZgGSXVaFl8j2Z0eN4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Schspa Shi <schspa@gmail.com>, kernel-team@android.com
Subject: Re: [PATCH 06/19] KVM: arm64: Get rid of reg_from/to_user()
Message-ID: <YsiG/ylMObDiDE91@google.com>
References: <20220706164304.1582687-1-maz@kernel.org>
 <20220706164304.1582687-7-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220706164304.1582687-7-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 06, 2022 at 05:42:51PM +0100, Marc Zyngier wrote:
> These helpers are only used by the invariant stuff now, and while
> they pretend to support non-64bit registers, this only serves as
> a way to scare the casual reviewer...
> 
> Replace these helpers with our good friends get/put_user(), and
> don't look back.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

> ---
>  arch/arm64/kvm/sys_regs.c | 33 +++++++++------------------------
>  1 file changed, 9 insertions(+), 24 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 1ce439eed3d8..b66be9df7a02 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -44,8 +44,6 @@
>   * 64bit interface.
>   */
>  
> -static int reg_from_user(u64 *val, const void __user *uaddr, u64 id);
> -static int reg_to_user(void __user *uaddr, const u64 *val, u64 id);
>  static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
>  
>  static bool read_from_write_only(struct kvm_vcpu *vcpu,
> @@ -2661,21 +2659,7 @@ static struct sys_reg_desc invariant_sys_regs[] = {
>  	{ SYS_DESC(SYS_CTR_EL0), NULL, get_ctr_el0 },
>  };
>  
> -static int reg_from_user(u64 *val, const void __user *uaddr, u64 id)
> -{
> -	if (copy_from_user(val, uaddr, KVM_REG_SIZE(id)) != 0)
> -		return -EFAULT;
> -	return 0;
> -}
> -
> -static int reg_to_user(void __user *uaddr, const u64 *val, u64 id)
> -{
> -	if (copy_to_user(uaddr, val, KVM_REG_SIZE(id)) != 0)
> -		return -EFAULT;
> -	return 0;
> -}
> -
> -static int get_invariant_sys_reg(u64 id, void __user *uaddr)
> +static int get_invariant_sys_reg(u64 id, u64 __user *uaddr)
>  {
>  	const struct sys_reg_desc *r;
>  
> @@ -2684,23 +2668,24 @@ static int get_invariant_sys_reg(u64 id, void __user *uaddr)
>  	if (!r)
>  		return -ENOENT;
>  
> -	return reg_to_user(uaddr, &r->val, id);
> +	if (put_user(r->val, uaddr))
> +		return -EFAULT;
> +
> +	return 0;
>  }
>  
> -static int set_invariant_sys_reg(u64 id, void __user *uaddr)
> +static int set_invariant_sys_reg(u64 id, u64 __user *uaddr)
>  {
>  	const struct sys_reg_desc *r;
> -	int err;
> -	u64 val = 0; /* Make sure high bits are 0 for 32-bit regs */
> +	u64 val;
>  
>  	r = get_reg_by_id(id, invariant_sys_regs,
>  			  ARRAY_SIZE(invariant_sys_regs));
>  	if (!r)
>  		return -ENOENT;
>  
> -	err = reg_from_user(&val, uaddr, id);
> -	if (err)
> -		return err;
> +	if (get_user(val, uaddr))
> +		return -EFAULT;
>  
>  	/* This is what we mean by invariant: you can't change it. */
>  	if (r->val != val)
> -- 
> 2.34.1
> 
