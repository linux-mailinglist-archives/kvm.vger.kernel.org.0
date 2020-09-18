Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC37826F748
	for <lists+kvm@lfdr.de>; Fri, 18 Sep 2020 09:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgIRHqX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Sep 2020 03:46:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27428 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726185AbgIRHqX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Sep 2020 03:46:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600415180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7SPP98mjBeSNrPvhF/bKPjdmORLsuk1qZly96ZOJlVo=;
        b=HD6wBmQUTVq7unhZ7Vr/4NfCR0KwDq6ljGkSWURrw9DAD0NPpw+DXlYgvjF9g5yQCeQqK1
        HtMJZt/7jt84he8OBvL3JD9LJhH3Ctbrn4yNWMk2db+J6n0ftrfOfj2iwRMWCCVCTWFj/6
        cj8l2WtVLc8PkxGJWqUwezFiNbP6glA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-583-fXvmJl0bP0uCjEuPExtktg-1; Fri, 18 Sep 2020 03:46:16 -0400
X-MC-Unique: fXvmJl0bP0uCjEuPExtktg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F054557083;
        Fri, 18 Sep 2020 07:46:14 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.125])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D485A68879;
        Fri, 18 Sep 2020 07:46:12 +0000 (UTC)
Date:   Fri, 18 Sep 2020 09:46:09 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Peng Liang <liangpeng10@huawei.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, maz@kernel.org,
        will@kernel.org, zhang.zhanghailiang@huawei.com,
        xiexiangyou@huawei.com
Subject: Re: [RFC v2 5/7] kvm: arm64: implement check_user for ID registers
Message-ID: <20200918074609.tet63j5x7i7n4wp7@kamzik.brq.redhat.com>
References: <20200917120101.3438389-1-liangpeng10@huawei.com>
 <20200917120101.3438389-6-liangpeng10@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917120101.3438389-6-liangpeng10@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 17, 2020 at 08:00:59PM +0800, Peng Liang wrote:
> For most ID registers, only neeed to check each field defined by user
> space is no more than that in host and only the fields we want to
> exposed to guest is set.  For some ID registers, the relationship
> between some fields need to be check or we'd better to keep the same
> value as host for some fields.
> 
> Signed-off-by: zhanghailiang <zhang.zhanghailiang@huawei.com>
> Signed-off-by: Peng Liang <liangpeng10@huawei.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 425 +++++++++++++++++++++++++++++++++++++-
>  1 file changed, 424 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 86ebb8093c3c..a642ecfebe0a 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1385,12 +1385,433 @@ static bool access_ccsidr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  	return true;
>  }
>  
> +#define ID_CHECKER(reg) __check_ ##reg
> +
> +static int __general_id_checker(struct kvm_vcpu *vcpu,
> +				const struct sys_reg_desc *rd,
> +				const struct kvm_one_reg *reg,
> +				void __user *uaddr)
> +{
> +	u32 reg_id = sys_reg((u32)rd->Op0, (u32)rd->Op1, (u32)rd->CRn,
> +			     (u32)rd->CRm, (u32)rd->Op2);
> +	int err;
> +	u64 val;
> +
> +	err = reg_from_user(&val, uaddr, sys_reg_to_index(rd));
> +	if (err)
> +		return err;
> +
> +	return check_features(reg_id, val);
> +}
> +
> +static int ID_CHECKER(ID_PFR0_EL1)(struct kvm_vcpu *vcpu,
> +				const struct sys_reg_desc *rd,
> +				const struct kvm_one_reg *reg,
> +				void __user *uaddr)
> +{
> +	return __general_id_checker(vcpu, rd, reg, uaddr);
> +}
> +
> +static int ID_CHECKER(ID_PFR1_EL1)(struct kvm_vcpu *vcpu,
> +				const struct sys_reg_desc *rd,
> +				const struct kvm_one_reg *reg,
> +				void __user *uaddr)
> +{
> +	return __general_id_checker(vcpu, rd, reg, uaddr);
> +}
> +
> +static int ID_CHECKER(ID_PFR2_EL1)(struct kvm_vcpu *vcpu,
> +				const struct sys_reg_desc *rd,
> +				const struct kvm_one_reg *reg,
> +				void __user *uaddr)
> +{
> +	return __general_id_checker(vcpu, rd, reg, uaddr);
> +}
> +
> +static int ID_CHECKER(ID_DFR0_EL1)(struct kvm_vcpu *vcpu,
> +				const struct sys_reg_desc *rd,
> +				const struct kvm_one_reg *reg,
> +				void __user *uaddr)
> +{
> +	u32 reg_id = sys_reg((u32)rd->Op0, (u32)rd->Op1, (u32)rd->CRn,
> +			     (u32)rd->CRm, (u32)rd->Op2);
> +	int err;
> +	u64 val, host_val;
> +	u64 mask = ((0xfUL << ID_DFR0_PERFMON_SHIFT) |
> +		    (0xfUL << ID_DFR0_MMAPDBG_SHIFT) |
> +		    (0xfUL << ID_DFR0_COPDBG_SHIFT) |
> +		    (0xfUL << ID_DFR0_COPDBG_SHIFT));
> +
> +	err = reg_from_user(&val, uaddr, sys_reg_to_index(rd));
> +	if (err)
> +		return err;
> +	err = check_features(reg_id, val);
> +	if (err)
> +		return err;
> +
> +	host_val = read_sanitised_ftr_reg(reg_id);
> +	return (val & mask) == (host_val & mask) ? 0 : -EINVAL;
> +}
> +
> +static int ID_CHECKER(ID_MMFR0_EL1)(struct kvm_vcpu *vcpu,
> +				const struct sys_reg_desc *rd,
> +				const struct kvm_one_reg *reg,
> +				void __user *uaddr)
> +{
> +	return __general_id_checker(vcpu, rd, reg, uaddr);
> +}
> +
> +static int ID_CHECKER(ID_MMFR1_EL1)(struct kvm_vcpu *vcpu,
> +				const struct sys_reg_desc *rd,
> +				const struct kvm_one_reg *reg,
> +				void __user *uaddr)
> +{
> +	return __general_id_checker(vcpu, rd, reg, uaddr);
> +}
> +
> +static int ID_CHECKER(ID_MMFR2_EL1)(struct kvm_vcpu *vcpu,
> +				const struct sys_reg_desc *rd,
> +				const struct kvm_one_reg *reg,
> +				void __user *uaddr)
> +{
> +	return __general_id_checker(vcpu, rd, reg, uaddr);
> +}
> +
> +static int ID_CHECKER(ID_MMFR3_EL1)(struct kvm_vcpu *vcpu,
> +				const struct sys_reg_desc *rd,
> +				const struct kvm_one_reg *reg,
> +				void __user *uaddr)
> +{
> +	return __general_id_checker(vcpu, rd, reg, uaddr);
> +}
> +
> +static int ID_CHECKER(ID_MMFR4_EL1)(struct kvm_vcpu *vcpu,
> +				const struct sys_reg_desc *rd,
> +				const struct kvm_one_reg *reg,
> +				void __user *uaddr)
> +{
> +	return __general_id_checker(vcpu, rd, reg, uaddr);
> +}
> +
> +static int ID_CHECKER(ID_MMFR5_EL1)(struct kvm_vcpu *vcpu,
> +				const struct sys_reg_desc *rd,
> +				const struct kvm_one_reg *reg,
> +				void __user *uaddr)
> +{
> +	return __general_id_checker(vcpu, rd, reg, uaddr);
> +}
> +
> +static int ID_CHECKER(ID_ISAR0_EL1)(struct kvm_vcpu *vcpu,
> +				const struct sys_reg_desc *rd,
> +				const struct kvm_one_reg *reg,
> +				void __user *uaddr)
> +{
> +	return __general_id_checker(vcpu, rd, reg, uaddr);
> +}
> +
> +static int ID_CHECKER(ID_ISAR1_EL1)(struct kvm_vcpu *vcpu,
> +				const struct sys_reg_desc *rd,
> +				const struct kvm_one_reg *reg,
> +				void __user *uaddr)
> +{
> +	return __general_id_checker(vcpu, rd, reg, uaddr);
> +}
> +
> +static int ID_CHECKER(ID_ISAR2_EL1)(struct kvm_vcpu *vcpu,
> +				const struct sys_reg_desc *rd,
> +				const struct kvm_one_reg *reg,
> +				void __user *uaddr)
> +{
> +	return __general_id_checker(vcpu, rd, reg, uaddr);
> +}
> +
> +static int ID_CHECKER(ID_ISAR3_EL1)(struct kvm_vcpu *vcpu,
> +				const struct sys_reg_desc *rd,
> +				const struct kvm_one_reg *reg,
> +				void __user *uaddr)
> +{
> +	return __general_id_checker(vcpu, rd, reg, uaddr);
> +}
> +
> +static int ID_CHECKER(ID_ISAR4_EL1)(struct kvm_vcpu *vcpu,
> +				const struct sys_reg_desc *rd,
> +				const struct kvm_one_reg *reg,
> +				void __user *uaddr)
> +{
> +	return __general_id_checker(vcpu, rd, reg, uaddr);
> +}
> +
> +static int ID_CHECKER(ID_ISAR5_EL1)(struct kvm_vcpu *vcpu,
> +				const struct sys_reg_desc *rd,
> +				const struct kvm_one_reg *reg,
> +				void __user *uaddr)
> +{
> +	return __general_id_checker(vcpu, rd, reg, uaddr);
> +}
> +
> +static int ID_CHECKER(ID_ISAR6_EL1)(struct kvm_vcpu *vcpu,
> +				const struct sys_reg_desc *rd,
> +				const struct kvm_one_reg *reg,
> +				void __user *uaddr)
> +{
> +	return __general_id_checker(vcpu, rd, reg, uaddr);
> +}
> +
> +static int ID_CHECKER(MVFR0_EL1)(struct kvm_vcpu *vcpu,
> +				const struct sys_reg_desc *rd,
> +				const struct kvm_one_reg *reg,
> +				void __user *uaddr)
> +{
> +	return __general_id_checker(vcpu, rd, reg, uaddr);
> +}

There has to be a better way to handle all these redundant functions...

> +
> +static int ID_CHECKER(MVFR1_EL1)(struct kvm_vcpu *vcpu,
> +				const struct sys_reg_desc *rd,
> +				const struct kvm_one_reg *reg,
> +				void __user *uaddr)
> +{
> +	u32 reg_id = sys_reg((u32)rd->Op0, (u32)rd->Op1, (u32)rd->CRn,
> +			     (u32)rd->CRm, (u32)rd->Op2);
> +	int err;
> +	u64 val;
> +	unsigned int fphp, simdhp;
> +
> +	err = reg_from_user(&val, uaddr, sys_reg_to_index(rd));
> +	if (err)
> +		return err;
> +	err = check_features(reg_id, val);
> +	if (err)
> +		return err;
> +
> +	fphp = cpuid_feature_extract_signed_field(val, MVFR1_FPHP_SHIFT);
> +	simdhp = cpuid_feature_extract_signed_field(val, MVFR1_SIMDHP_SHIFT);
> +	return ((fphp == 0 && simdhp == 0) || (fphp == 2 && simdhp == 1) ||
> +		(fphp == 3 && simdhp == 2)) ? 0 : -EINVAL;
> +}
> +
> +static int ID_CHECKER(MVFR2_EL1)(struct kvm_vcpu *vcpu,
> +				const struct sys_reg_desc *rd,
> +				const struct kvm_one_reg *reg,
> +				void __user *uaddr)
> +{
> +	return __general_id_checker(vcpu, rd, reg, uaddr);
> +}
> +
> +static int ID_CHECKER(ID_AA64PFR0_EL1)(struct kvm_vcpu *vcpu,
> +				const struct sys_reg_desc *rd,
> +				const struct kvm_one_reg *reg,
> +				void __user *uaddr)
> +{
> +	u32 reg_id = sys_reg((u32)rd->Op0, (u32)rd->Op1, (u32)rd->CRn,
> +			     (u32)rd->CRm, (u32)rd->Op2);
> +	int err;
> +	u64 val;
> +	unsigned int fp, asimd;
> +
> +	err = reg_from_user(&val, uaddr, sys_reg_to_index(rd));
> +	if (err)
> +		return err;
> +	err = check_features(reg_id, val);
> +	if (err)
> +		return err;
> +
> +	fp = cpuid_feature_extract_signed_field(val, ID_AA64PFR0_FP_SHIFT);
> +	asimd = cpuid_feature_extract_signed_field(val, ID_AA64PFR0_ASIMD_SHIFT);
> +	return fp == asimd ? 0 : -EINVAL;
> +}
> +
> +static int ID_CHECKER(ID_AA64PFR1_EL1)(struct kvm_vcpu *vcpu,
> +				const struct sys_reg_desc *rd,
> +				const struct kvm_one_reg *reg,
> +				void __user *uaddr)
> +{
> +	return __general_id_checker(vcpu, rd, reg, uaddr);
> +}
> +
> +static int ID_CHECKER(ID_AA64DFR0_EL1)(struct kvm_vcpu *vcpu,
> +				const struct sys_reg_desc *rd,
> +				const struct kvm_one_reg *reg,
> +				void __user *uaddr)
> +{
> +	u32 reg_id = sys_reg((u32)rd->Op0, (u32)rd->Op1, (u32)rd->CRn,
> +			     (u32)rd->CRm, (u32)rd->Op2);
> +	int err;
> +	u64 val, host_val;
> +	u64 mask = ((0xfUL << ID_AA64DFR0_PMUVER_SHIFT) |
> +		    (0xfUL << ID_AA64DFR0_DEBUGVER_SHIFT) |
> +		    (0xfUL << ID_AA64DFR0_CTX_CMPS_SHIFT) |
> +		    (0xfUL << ID_AA64DFR0_WRPS_SHIFT) |
> +		    (0xfUL << ID_AA64DFR0_BRPS_SHIFT));
> +
> +	err = reg_from_user(&val, uaddr, sys_reg_to_index(rd));
> +	if (err)
> +		return err;
> +	err = check_features(reg_id, val);
> +	if (err)
> +		return err;
> +
> +	host_val = read_sanitised_ftr_reg(reg_id);
> +	return (val & mask) == (host_val & mask) ? 0 : -EINVAL;
> +}
> +
> +static int ID_CHECKER(ID_AA64DFR1_EL1)(struct kvm_vcpu *vcpu,
> +				const struct sys_reg_desc *rd,
> +				const struct kvm_one_reg *reg,
> +				void __user *uaddr)
> +{
> +	return __general_id_checker(vcpu, rd, reg, uaddr);
> +}
> +
> +static int ID_CHECKER(ID_AA64ISAR0_EL1)(struct kvm_vcpu *vcpu,
> +				const struct sys_reg_desc *rd,
> +				const struct kvm_one_reg *reg,
> +				void __user *uaddr)
> +{
> +	u32 reg_id = sys_reg((u32)rd->Op0, (u32)rd->Op1, (u32)rd->CRn,
> +			     (u32)rd->CRm, (u32)rd->Op2);
> +	int err;
> +	u64 val;
> +	unsigned int sm3, sm4, sha1, sha2, sha3;
> +
> +	err = reg_from_user(&val, uaddr, sys_reg_to_index(rd));
> +	if (err)
> +		return err;
> +	err = check_features(reg_id, val);
> +	if (err)
> +		return err;
> +
> +	sm3 = cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR0_SM3_SHIFT);
> +	sm4 = cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR0_SM4_SHIFT);
> +	/*
> +	 * ID_AA64ISAR0_EL1.SM3 and ID_AA64ISAR0_EL1.SM4 must have the same
> +	 * value.
> +	 */
> +	if (sm3 != sm4)
> +		return -EINVAL;
> +
> +	sha1 = cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR0_SHA1_SHIFT);
> +	sha2 = cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR0_SHA2_SHIFT);
> +	sha3 = cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR0_SHA3_SHIFT);
> +	/*
> +	 * 1. If the value of ID_AA64ISAR0_EL1.SHA1 is 0, then
> +	 *    ID_AA64ISAR0_EL1.SHA2 must have the value 0, and vice versa;
> +	 * 2. If the value of ID_AA64ISAR0_EL1.SHA2 is 2, then
> +	 *    ID_AA64ISAR0_EL1.SHA3 must have the value 1, and vice versa;
> +	 * 3. If the value of ID_AA64ISAR0_EL1.SHA1 is 0, then
> +	 *    ID_AA64ISAR0_EL1.SHA3 must have the value 0;
> +	 */
> +	if ((sha1 ^ sha2) || ((sha2 == 2) ^ (sha3 == 1)) || (!sha1 && sha3))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static int ID_CHECKER(ID_AA64ISAR1_EL1)(struct kvm_vcpu *vcpu,
> +				const struct sys_reg_desc *rd,
> +				const struct kvm_one_reg *reg,
> +				void __user *uaddr)
> +{
> +	u32 reg_id = sys_reg((u32)rd->Op0, (u32)rd->Op1, (u32)rd->CRn,
> +			     (u32)rd->CRm, (u32)rd->Op2);
> +	int err;
> +	u64 val;
> +	unsigned int gpi, gpa, api, apa;
> +
> +	err = reg_from_user(&val, uaddr, sys_reg_to_index(rd));
> +	if (err)
> +		return err;
> +	err = check_features(reg_id, val);
> +	if (err)
> +		return err;
> +
> +	gpi = cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR1_GPI_SHIFT);
> +	gpa = cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR1_GPA_SHIFT);
> +	api = cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR1_API_SHIFT);
> +	apa = cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR1_APA_SHIFT);
> +	/*
> +	 * 1. If the value of ID_AA64ISAR1_EL1.GPA is non-zero, then
> +	 *    ID_AA64ISAR1_EL1.GPI must have the value 0;
> +	 * 2. If the value of ID_AA64ISAR1_EL1.GPI is non-zero, then
> +	 *    ID_AA64ISAR1_EL1.GPA must have the value 0;
> +	 * 3. If the value of ID_AA64ISAR1_EL1.APA is non-zero, then
> +	 *    ID_AA64ISAR1_EL1.API must have the value 0;
> +	 * 4. If the value of ID_AA64ISAR1_EL1.API is non-zero, then
> +	 *    ID_AA64ISAR1_EL1.APA must have the value 0;
> +	 */
> +	if ((gpi && gpa) || (api && apa))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static int ID_CHECKER(ID_AA64MMFR0_EL1)(struct kvm_vcpu *vcpu,
> +				const struct sys_reg_desc *rd,
> +				const struct kvm_one_reg *reg,
> +				void __user *uaddr)
> +{
> +	u32 reg_id = sys_reg((u32)rd->Op0, (u32)rd->Op1, (u32)rd->CRn,
> +			     (u32)rd->CRm, (u32)rd->Op2);
> +	int err;
> +	u64 val, host_val;
> +	u64 mask = ((0xfUL << ID_AA64MMFR0_TGRAN4_2_SHIFT) |
> +		    (0xfUL << ID_AA64MMFR0_TGRAN64_2_SHIFT) |
> +		    (0xfUL << ID_AA64MMFR0_TGRAN16_2_SHIFT) |
> +		    (0xfUL << ID_AA64MMFR0_TGRAN4_SHIFT) |
> +		    (0xfUL << ID_AA64MMFR0_TGRAN64_SHIFT) |
> +		    (0xfUL << ID_AA64MMFR0_TGRAN16_SHIFT) |
> +		    (0xfUL << ID_AA64MMFR0_ASID_SHIFT) |
> +		    (0xfUL << ID_AA64MMFR0_PARANGE_SHIFT));
> +
> +	err = reg_from_user(&val, uaddr, sys_reg_to_index(rd));
> +	if (err)
> +		return err;
> +	err = check_features(reg_id, val);
> +	if (err)
> +		return err;
> +
> +	host_val = read_sanitised_ftr_reg(reg_id);
> +	return (val & mask) == (host_val & mask) ? 0 : -EINVAL;
> +}
> +
> +static int ID_CHECKER(ID_AA64MMFR1_EL1)(struct kvm_vcpu *vcpu,
> +				const struct sys_reg_desc *rd,
> +				const struct kvm_one_reg *reg,
> +				void __user *uaddr)
> +{
> +	u32 reg_id = sys_reg((u32)rd->Op0, (u32)rd->Op1, (u32)rd->CRn,
> +			     (u32)rd->CRm, (u32)rd->Op2);
> +	int err;
> +	u64 val, host_val;
> +	unsigned int vmidbits, host_vmidbits;
> +
> +	err = reg_from_user(&val, uaddr, sys_reg_to_index(rd));
> +	if (err)
> +		return err;
> +	err = check_features(reg_id, val);
> +	if (err)
> +		return err;
> +
> +	vmidbits = cpuid_feature_extract_unsigned_field(val, ID_AA64MMFR1_VMIDBITS_SHIFT);
> +	host_val = read_sanitised_ftr_reg(reg_id);
> +	host_vmidbits = cpuid_feature_extract_signed_field(host_val, ID_AA64MMFR1_VMIDBITS_SHIFT);
> +	return vmidbits == host_vmidbits ? 0 : -EINVAL;
> +}
> +
> +static int ID_CHECKER(ID_AA64MMFR2_EL1)(struct kvm_vcpu *vcpu,
> +				const struct sys_reg_desc *rd,
> +				const struct kvm_one_reg *reg,
> +				void __user *uaddr)
> +{
> +	return __general_id_checker(vcpu, rd, reg, uaddr);
> +}
> +
>  /* sys_reg_desc initialiser for known cpufeature ID registers */
>  #define ID_SANITISED(name) {			\
>  	SYS_DESC(SYS_##name),			\
>  	.access	= access_id_reg,		\
>  	.get_user = get_id_reg,			\
>  	.set_user = set_id_reg,			\
> +	.check_user = ID_CHECKER(name),		\

This patch makes it clear that continuing to use ID_SANITISED() for all ID
registers makes no sense.

>  }
>  
>  /*
> @@ -1512,7 +1933,9 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	ID_SANITISED(ID_AA64PFR1_EL1),
>  	ID_UNALLOCATED(4,2),
>  	ID_UNALLOCATED(4,3),
> -	{ SYS_DESC(SYS_ID_AA64ZFR0_EL1), access_id_aa64zfr0_el1, .get_user = get_id_aa64zfr0_el1, .set_user = set_id_aa64zfr0_el1, .visibility = sve_id_visibility },
> +	{ SYS_DESC(SYS_ID_AA64ZFR0_EL1), access_id_aa64zfr0_el1,
> +	  .get_user = get_id_aa64zfr0_el1, .set_user = set_id_aa64zfr0_el1,
> +	  .check_user = __general_id_checker, .visibility = sve_id_visibility },
>  	ID_UNALLOCATED(4,5),
>  	ID_UNALLOCATED(4,6),
>  	ID_UNALLOCATED(4,7),
> -- 
> 2.26.2
>

Thanks,
drew 

