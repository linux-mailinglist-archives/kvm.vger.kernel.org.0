Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA0CA24382C
	for <lists+kvm@lfdr.de>; Thu, 13 Aug 2020 12:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbgHMKCM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 06:02:12 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:51481 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726048AbgHMKCM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Aug 2020 06:02:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597312930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LAmNs7awLCcJvmqLqwwle6epyVXP/zCr5CsKuUbDEUQ=;
        b=XAKKPMg08ZO66ZwoVpCTIGGcnvZf42fwiZw/3qXOfIhFvQ9lDZwjVmXA5v8OB86svC0i63
        szTXcEFMiSXsyni4ImbladKCx0orqef/f8YpH9/R2TSrnzNs/Ag6lS0B4d11INW9rmRjjq
        5B+tPydn2AS5sbew/XngU4DG6IPBv2o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-565-QyOU0JmCMU-9ahwrLdjeOw-1; Thu, 13 Aug 2020 06:02:08 -0400
X-MC-Unique: QyOU0JmCMU-9ahwrLdjeOw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 882F0800465;
        Thu, 13 Aug 2020 10:02:06 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.72])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 393FB5DA76;
        Thu, 13 Aug 2020 10:02:03 +0000 (UTC)
Date:   Thu, 13 Aug 2020 12:02:00 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Peng Liang <liangpeng10@huawei.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, maz@kernel.org,
        will@kernel.org, zhang.zhanghailiang@huawei.com,
        xiexiangyou@huawei.com
Subject: Re: [RFC 2/4] kvm: arm64: emulate the ID registers
Message-ID: <20200813100200.mvcumaeifnqezelm@kamzik.brq.redhat.com>
References: <20200813060517.2360048-1-liangpeng10@huawei.com>
 <20200813060517.2360048-3-liangpeng10@huawei.com>
 <20200813090558.3eqwoxp7m6jmknft@kamzik.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200813090558.3eqwoxp7m6jmknft@kamzik.brq.redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 13, 2020 at 11:05:58AM +0200, Andrew Jones wrote:
> On Thu, Aug 13, 2020 at 02:05:15PM +0800, Peng Liang wrote:
> > To emulate the ID registers, we need a place to storage the values of
> > the ID regsiters.  Maybe putting in kvm_arch_vcpu is a good idea.
> > 
> > This commit has no functional changes but only code refactor.  When
> > initializing a vcpu, get the values of the ID registers from
> > arm64_ftr_regs and storage them in kvm_arch_vcpu.  And we just read
> > the value from kvm_arch_vcpu when getting/setting the value of the ID
> > regs.
> > 
> > Signed-off-by: zhanghailiang <zhang.zhanghailiang@huawei.com>
> > Signed-off-by: Peng Liang <liangpeng10@huawei.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  2 ++
> >  arch/arm64/kvm/arm.c              | 20 ++++++++++++++++++++
> >  arch/arm64/kvm/sys_regs.c         | 27 +++++++++++++++++++++++----
> >  include/uapi/linux/kvm.h          | 11 +++++++++++
> >  4 files changed, 56 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index f81151ad3d3c..7f7bd36702f7 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -336,6 +336,8 @@ struct kvm_vcpu_arch {
> >  		u64 last_steal;
> >  		gpa_t base;
> >  	} steal;
> > +
> > +	struct id_registers idregs;
> >  };
> >  
> >  /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 73e12869afe3..18ebbe1c64ee 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -262,6 +262,24 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
> >  	return 0;
> >  }
> >  
> > +static int get_cpu_ftr(u32 id, u64 val, void *argp)
> > +{
> > +	struct id_registers *idregs = argp;
> > +
> > +	/*
> > +	 * (Op0, Op1, CRn, CRm, Op2) of ID registers is (3, 0, 0, crm, op2),
> > +	 * where 1<=crm<8, 0<=op2<8.
> > +	 */
> > +	if (sys_reg_Op0(id) == 3 && sys_reg_Op1(id) == 0 &&
> > +	    sys_reg_CRn(id) == 0 && sys_reg_CRm(id) > 0) {
> > +		idregs->regs[idregs->num].sys_id = id;
> > +		idregs->regs[idregs->num].sys_val = val;
> > +		idregs->num++;
> 
> This num++ means we should ensure get_cpu_ftr() is only used once per
> VCPU, but we don't need 'num'. The index can be derived: (crm<<3)|op2
> 
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >  int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> >  {
> >  	int err;
> > @@ -285,6 +303,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> >  	if (err)
> >  		return err;
> >  
> > +	arm64_cpu_ftr_regs_traverse(get_cpu_ftr, &vcpu->arch.idregs);
> > +
> >  	return create_hyp_mappings(vcpu, vcpu + 1, PAGE_HYP);
> >  }
> >  
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 138961d7ebe3..776c2757a01e 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -1092,13 +1092,32 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
> >  	return true;
> >  }
> >  
> > +static struct id_reg_info *kvm_id_reg(struct kvm_vcpu *vcpu, u64 id)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < vcpu->arch.idregs.num; ++i) {
> > +		if (vcpu->arch.idregs.regs[i].sys_id == id)
> > +			return &vcpu->arch.idregs.regs[i];
> 
> With a derived index we don't need to search. Just do
> 
>  if (sys_reg_Op0(id) != 3 || sys_reg_Op1(id) != 0 ||
>      sys_reg_CRn(id) != 0 || sys_reg_CRm(id) == 0)
>       return NULL;
> 
>  return &vcpu->arch.idregs.regs[(sys_reg_CRm(id)<<3) | sys_reg_Op2(id)]; 
>  
> 
> > +	}
> > +	return NULL;
> > +}
> > +
> > +static u64 kvm_get_id_reg(struct kvm_vcpu *vcpu, u64 id)
> > +{
> > +	struct id_reg_info *ri = kvm_id_reg(vcpu, id);
> > +
> > +	BUG_ON(!ri);
> > +	return ri->sys_val;
> > +}
> > +
> >  /* Read a sanitised cpufeature ID register by sys_reg_desc */
> > -static u64 read_id_reg(const struct kvm_vcpu *vcpu,
> > +static u64 read_id_reg(struct kvm_vcpu *vcpu,
> >  		struct sys_reg_desc const *r, bool raz)
> >  {
> >  	u32 id = sys_reg((u32)r->Op0, (u32)r->Op1,
> >  			 (u32)r->CRn, (u32)r->CRm, (u32)r->Op2);
> > -	u64 val = raz ? 0 : read_sanitised_ftr_reg(id);
> > +	u64 val = raz ? 0 : kvm_get_id_reg(vcpu, id);
> >  
> >  	if (id == SYS_ID_AA64PFR0_EL1) {
> >  		if (!vcpu_has_sve(vcpu))
> > @@ -1238,7 +1257,7 @@ static int set_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
> >   * are stored, and for set_id_reg() we don't allow the effective value
> >   * to be changed.
> >   */
> > -static int __get_id_reg(const struct kvm_vcpu *vcpu,
> > +static int __get_id_reg(struct kvm_vcpu *vcpu,
> >  			const struct sys_reg_desc *rd, void __user *uaddr,
> >  			bool raz)
> >  {
> > @@ -1248,7 +1267,7 @@ static int __get_id_reg(const struct kvm_vcpu *vcpu,
> >  	return reg_to_user(uaddr, &val, id);
> >  }
> >  
> > -static int __set_id_reg(const struct kvm_vcpu *vcpu,
> > +static int __set_id_reg(struct kvm_vcpu *vcpu,
> >  			const struct sys_reg_desc *rd, void __user *uaddr,
> >  			bool raz)
> >  {
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index f6d86033c4fa..1029444d04aa 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -1272,6 +1272,17 @@ struct kvm_vfio_spapr_tce {
> >  	__s32	tablefd;
> >  };
> >  
> > +#define ID_REG_MAX_NUMS 64
> > +struct id_reg_info {
> > +	uint64_t sys_id;
> > +	uint64_t sys_val;
> 
> I'm not sure the 'sys_' prefix is necessary.
> 
> > +};
> > +
> > +struct id_registers {
> > +	struct id_reg_info regs[ID_REG_MAX_NUMS];
> > +	uint64_t num;
> > +};
> > +
> 
> This is arch specific, so there should be ARMv8 in the names.

Also, why are id_reg_info and id_registers UAPI?

Thanks,
drew

> 
> >  /*
> >   * ioctls for VM fds
> >   */
> > -- 
> > 2.18.4
> > 
> 

