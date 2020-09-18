Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E469126F72D
	for <lists+kvm@lfdr.de>; Fri, 18 Sep 2020 09:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbgIRHlr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Sep 2020 03:41:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25793 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726344AbgIRHlr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Sep 2020 03:41:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600414905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jdlxnptKdLwu7IhJP9GgNsbTEOt9CXKptumM3YEZlQI=;
        b=Xpvilb03j4bHvI1HO4aT/5Vu+Pp3p1FRLX586ba4nu7Ba2MfrrNuLPnkmg3rcbiqqzAXl0
        3m+GWMsL0HabX3hfg9wPrhhcgPyoeskQKou7oxXymWMRkggsDuiMmJcsFgxWBuySCdet90
        Sno/XKZlbI4yabZq5/uELUQVZT98I54=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-443-RGVfUhXXNUmZhezWJWVxZQ-1; Fri, 18 Sep 2020 03:41:43 -0400
X-MC-Unique: RGVfUhXXNUmZhezWJWVxZQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CE453873088;
        Fri, 18 Sep 2020 07:41:41 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.125])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 063265DA30;
        Fri, 18 Sep 2020 07:41:38 +0000 (UTC)
Date:   Fri, 18 Sep 2020 09:41:35 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Peng Liang <liangpeng10@huawei.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, maz@kernel.org,
        will@kernel.org, zhang.zhanghailiang@huawei.com,
        xiexiangyou@huawei.com
Subject: Re: [RFC v2 4/7] kvm: arm64: introduce check_user
Message-ID: <20200918074135.67ahnd6rlh7db3is@kamzik.brq.redhat.com>
References: <20200917120101.3438389-1-liangpeng10@huawei.com>
 <20200917120101.3438389-5-liangpeng10@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917120101.3438389-5-liangpeng10@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 17, 2020 at 08:00:58PM +0800, Peng Liang wrote:
> Currently, if we need to check the value of the register defined by user
> space, we should check it in set_user.  However, some system registers
> may use the same set_user (for example, almost all ID registers), which
> make it difficult to validate the value defined by user space.

If sharing set_user no longer makes sense for ID registers, then we need
to rework the code so it's no longer shared. As I keep saying, we need
to address this problem one ID register at a time. So, IMO, the approach
should be to change one ID register at a time from using ID_SANITISED()
to having its own table entry with its own set/get_user code. There may
still be opportunity to share code among the ID registers, in which case
refactoring can be done as needed too.

Thanks,
drew

> 
> Introduce check_user to solve the problem.  And apply check_user before
> set_user to make sure that the value of register is valid.
> 
> Signed-off-by: zhanghailiang <zhang.zhanghailiang@huawei.com>
> Signed-off-by: Peng Liang <liangpeng10@huawei.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 7 +++++++
>  arch/arm64/kvm/sys_regs.h | 6 ++++++
>  2 files changed, 13 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 2b0fa8d5ac62..86ebb8093c3c 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2684,6 +2684,7 @@ int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
>  {
>  	const struct sys_reg_desc *r;
>  	void __user *uaddr = (void __user *)(unsigned long)reg->addr;
> +	int err;
>  
>  	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_DEMUX)
>  		return demux_c15_set(reg->id, uaddr);
> @@ -2699,6 +2700,12 @@ int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
>  	if (sysreg_hidden_from_user(vcpu, r))
>  		return -ENOENT;
>  
> +	if (r->check_user) {
> +		err = (r->check_user)(vcpu, r, reg, uaddr);
> +		if (err)
> +			return err;
> +	}
> +
>  	if (r->set_user)
>  		return (r->set_user)(vcpu, r, reg, uaddr);
>  
> diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> index 5a6fc30f5989..9bce5e9a3490 100644
> --- a/arch/arm64/kvm/sys_regs.h
> +++ b/arch/arm64/kvm/sys_regs.h
> @@ -53,6 +53,12 @@ struct sys_reg_desc {
>  			const struct kvm_one_reg *reg, void __user *uaddr);
>  	int (*set_user)(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>  			const struct kvm_one_reg *reg, void __user *uaddr);
> +	/*
> +	 * Check the value userspace passed.  It should return 0 on success and
> +	 * otherwise on failure.
> +	 */
> +	int (*check_user)(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> +			  const struct kvm_one_reg *reg, void __user *uaddr);
>  
>  	/* Return mask of REG_* runtime visibility overrides */
>  	unsigned int (*visibility)(const struct kvm_vcpu *vcpu,
> -- 
> 2.26.2
> 

