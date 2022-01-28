Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 179C249F337
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 07:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346267AbiA1GCL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 01:02:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235654AbiA1GCJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jan 2022 01:02:09 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80446C061714
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 22:02:09 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id o16-20020a17090aac1000b001b62f629953so2601534pjq.3
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 22:02:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XeHkYZa5PTrCwG1dKwJzGQIj4Lp9pI6vxZfdnFNDN9M=;
        b=b7A1JbpUmyD2Qj87MNnFL4MJ4n+zL31GUo429W6VZh5Cb4hFM9zZ7S6MHuQrl7THZW
         ktujJDZBFGv3QIKK/RWq5Ld67wCYl1Jq68T0nKLo1q6JJQHEWm2axn+c3bwr7s1tg02T
         zOK7jBQxyoJTZfxpBe5IbDWVBT/+QS3chWXDayMaS/dpnEG16Xu5i0vYwl/E0H+XukIM
         FLTubDO35H2wnM539u1uLABlqvNB4yr+B/wDav8ipn2DIC4eyeIUOHopy+LgPcf7MCPs
         YrECJMSUj34U7vlF29w0oVkIpMOz0Hy+zg5PUg74T5Z8uYq1fsLRe7C0bSNvR6uTRhH1
         79UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XeHkYZa5PTrCwG1dKwJzGQIj4Lp9pI6vxZfdnFNDN9M=;
        b=2RFlCpD89rmXpqKVIvCMVDiRRQca0vubgpODEJD+OmZLVJt2urOJTfPP/IsrT6nkgb
         HDtNCwnez2RDgpMbmVSckMKsg/30kxRgGzzo3vg6HYaengJlPGTgFU6ZLqvi7DuRV1dV
         IC3o5s23mb83jcfmb3MC1wuxdkASKnLRqcX0/wedeoTBqYJeve+hIwldMU89gBoCNDpi
         nAm80gFmkLlCkHpqTl/zCX1q/erJVyc++lbVdn26bC8Z8NF7KwznHbKbDPyDUeCUYDuP
         qdJzFlmx7YJGSbM/1zdfjQFf+Z4Kc0MA4hM2cmAbPLObLtvj0rks35AXO++RTK7objNH
         SBgg==
X-Gm-Message-State: AOAM530mBI6t71KD8HMkWffTtViwh0LYZfRzyc9Wt8y+p7CjrSE2QZop
        WmfACj6p9VKkgRsZs7h49N4sVyTGUCvIutXFltT0GA==
X-Google-Smtp-Source: ABdhPJztxxz9zZE6+8Dc7jFC+lY0fyCC4ASZUj/lCPBP3diH5uJCjwFcJrnwPdI1OyC5LPqvuhlIzY7jZIx8UsUiCCI=
X-Received: by 2002:a17:902:d109:: with SMTP id w9mr6935085plw.138.1643349728810;
 Thu, 27 Jan 2022 22:02:08 -0800 (PST)
MIME-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com> <20220106042708.2869332-2-reijiw@google.com>
 <YfDOaMrj3/M8g+7z@google.com>
In-Reply-To: <YfDOaMrj3/M8g+7z@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Thu, 27 Jan 2022 22:01:52 -0800
Message-ID: <CAAeT=FwSg=uj9XvRnOWBp+V5n9yvs3WQub+oCtbGcOWFY2LFkw@mail.gmail.com>
Subject: Re: [RFC PATCH v4 01/26] KVM: arm64: Introduce a validation function
 for an ID register
To:     Ricardo Koller <ricarkol@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo,

On Tue, Jan 25, 2022 at 8:30 PM Ricardo Koller <ricarkol@google.com> wrote:
>
> Hey Reiji,
>
> On Wed, Jan 05, 2022 at 08:26:43PM -0800, Reiji Watanabe wrote:
> > Introduce arm64_check_features(), which does a basic validity checking
> > of an ID register value against the register's limit value, which is
> > generally the host's sanitized value.
> >
> > This function will be used by the following patches to check if an ID
> > register value that userspace tries to set for a guest can be supported
> > on the host.
> >
> > The validation is done using arm64_ftr_bits_kvm, which is created from
> > arm64_ftr_regs, with some entries overwritten by entries from
> > arm64_ftr_bits_kvm_override.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/include/asm/cpufeature.h |   1 +
> >  arch/arm64/kernel/cpufeature.c      | 228 ++++++++++++++++++++++++++++
> >  2 files changed, 229 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> > index ef6be92b1921..eda7ddbed8cf 100644
> > --- a/arch/arm64/include/asm/cpufeature.h
> > +++ b/arch/arm64/include/asm/cpufeature.h
> > @@ -631,6 +631,7 @@ void check_local_cpu_capabilities(void);
> >
> >  u64 read_sanitised_ftr_reg(u32 id);
> >  u64 __read_sysreg_by_encoding(u32 sys_id);
> > +int arm64_check_features(u32 sys_reg, u64 val, u64 limit);
> >
> >  static inline bool cpu_supports_mixed_endian_el0(void)
> >  {
> > diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> > index 6f3e677d88f1..48dff8b101d9 100644
> > --- a/arch/arm64/kernel/cpufeature.c
> > +++ b/arch/arm64/kernel/cpufeature.c
> > @@ -3140,3 +3140,231 @@ ssize_t cpu_show_meltdown(struct device *dev, struct device_attribute *attr,
> >               return sprintf(buf, "Vulnerable\n");
> >       }
> >  }
> > +
> > +#ifdef CONFIG_KVM
> > +/*
> > + * arm64_ftr_bits_kvm[] is used for KVM to check if features that are
> > + * indicated in an ID register value for the guest are available on the host.
> > + * arm64_ftr_bits_kvm[] is created based on arm64_ftr_regs[].  But, for
> > + * registers for which arm64_ftr_bits_kvm_override[] has a corresponding
> > + * entry, replace arm64_ftr_bits entries in arm64_ftr_bits_kvm[] with the
> > + * ones in arm64_ftr_bits_kvm_override[].
> > + */
> > +static struct __ftr_reg_bits_entry *arm64_ftr_bits_kvm;
> > +static size_t arm64_ftr_bits_kvm_nentries;
>
> I don't think this is really needed, as arm64_ftr_bits_kvm_override has
> to have the same size as arm64_ftr_bits_kvm. You could use
> ARRAY_SIZE(arm64_ftr_regs) like in get_arm64_ftr_reg_nowarn().

Thanks for the review!
Yes, you are right. I will remove arm64_ftr_bits_kvm_nentries,
and use ARRAY_SIZE(arm64_ftr_regs) instead.

> > +static DEFINE_MUTEX(arm64_ftr_bits_kvm_lock);
> > +
> > +/*
> > + * Number of arm64_ftr_bits entries for each register.
> > + * (Number of 4 bits fields in 64 bit register + 1 entry for ARM64_FTR_END)
> > + */
> > +#define      MAX_FTR_BITS_LEN        17
> > +
> > +/* Use FTR_LOWER_SAFE for AA64DFR0_EL1.PMUVER and AA64DFR0_EL1.DEBUGVER. */
> > +static struct arm64_ftr_bits ftr_id_aa64dfr0_kvm[MAX_FTR_BITS_LEN] = {
> > +     S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR0_PMUVER_SHIFT, 4, 0),
> > +     ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR0_DEBUGVER_SHIFT, 4, 0x6),
> > +     ARM64_FTR_END,
> > +};
> > +
> > +#define      ARM64_FTR_REG_BITS(id, table)   {       \
> > +     .sys_id = id,                           \
> > +     .ftr_bits = &((table)[0]),              \
> > +}
> > +
> > +struct __ftr_reg_bits_entry {
> > +     u32     sys_id;
> > +     struct arm64_ftr_bits   *ftr_bits;
> > +};
> > +
> > +/*
> > + * All entries in arm64_ftr_bits_kvm_override[] are used to override
> > + * the corresponding entries in arm64_ftr_bits_kvm[].
> > + */
> > +static struct __ftr_reg_bits_entry arm64_ftr_bits_kvm_override[] = {
> > +     ARM64_FTR_REG_BITS(SYS_ID_AA64DFR0_EL1, ftr_id_aa64dfr0_kvm),
> > +};
> > +
> > +/*
> > + * Override entries in @orig_ftrp with the ones in @new_ftrp when their shift
> > + * fields match.  The last entry of @orig_ftrp and @new_ftrp must be
> > + * ARM64_FTR_END (.width == 0).
> > + */
> > +static void arm64_ftr_reg_bits_overrite(struct arm64_ftr_bits *orig_ftrp,
> > +                                     struct arm64_ftr_bits *new_ftrp)
> > +{
> > +     struct arm64_ftr_bits *o_ftrp, *n_ftrp;
> > +
> > +     for (n_ftrp = new_ftrp; n_ftrp->width; n_ftrp++) {
> > +             for (o_ftrp = orig_ftrp; o_ftrp->width; o_ftrp++) {
> > +                     if (o_ftrp->shift == n_ftrp->shift) {
> > +                             *o_ftrp = *n_ftrp;
> > +                             break;
> > +                     }
> > +             }
> > +     }
> > +}
> > +
> > +/*
> > + * Copy arm64_ftr_bits entries from @src_ftrp to @dst_ftrp.  The last entries
> > + * of @dst_ftrp and @src_ftrp must be ARM64_FTR_END (.width == 0).
> > + */
> > +static void copy_arm64_ftr_bits(struct arm64_ftr_bits *dst_ftrp,
> > +                             const struct arm64_ftr_bits *src_ftrp)
> > +{
> > +     int i = 0;
> > +
> > +     for (; src_ftrp[i].width; i++) {
> > +             if (WARN_ON_ONCE(i >= (MAX_FTR_BITS_LEN - 1)))
> > +                     break;
> > +
> > +             dst_ftrp[i] = src_ftrp[i];
> > +     }
> > +
> > +     dst_ftrp[i].width = 0;
> > +}
> > +
> > +/*
> > + * Initialize arm64_ftr_bits_kvm.  Copy arm64_ftr_bits for each ID register
> > + * from arm64_ftr_regs to arm64_ftr_bits_kvm, and then override entries in
> > + * arm64_ftr_bits_kvm with ones in arm64_ftr_bits_kvm_override.
> > + */
> > +static int init_arm64_ftr_bits_kvm(void)
> > +{
> > +     struct arm64_ftr_bits ftr_temp[MAX_FTR_BITS_LEN];
> > +     static struct __ftr_reg_bits_entry *reg_bits_array, *bits, *o_bits;
> > +     int i, j, nent, ret;
> > +
> > +     mutex_lock(&arm64_ftr_bits_kvm_lock);
>
> This is initialized lazily, whenever KVM calls arm64_check_features(). I
> guess that's why it needs the lock (and possibly a barrier as you
> mentoin in your reply). Would it be possible to simplify things by
> initializing arm64_ftr_bits_kvm somewhere at boot time (in
> init_cpu_features maybe?)?

I agree that it could simplify the code.
I will look into initializing that earlier.


>
> > +     if (arm64_ftr_bits_kvm) {
> > +             /* Already initialized */
> > +             ret = 0;
> > +             goto unlock_exit;
> > +     }
> > +
> > +     nent = ARRAY_SIZE(arm64_ftr_regs);
> > +     reg_bits_array = kcalloc(nent, sizeof(struct __ftr_reg_bits_entry),
> > +                              GFP_KERNEL);
> > +     if (!reg_bits_array) {
> > +             ret = ENOMEM;
> > +             goto unlock_exit;
> > +     }
> > +
> > +     /* Copy entries from arm64_ftr_regs to reg_bits_array */
> > +     for (i = 0; i < nent; i++) {
> > +             bits = &reg_bits_array[i];
> > +             bits->sys_id = arm64_ftr_regs[i].sys_id;
> > +             bits->ftr_bits = (struct arm64_ftr_bits *)arm64_ftr_regs[i].reg->ftr_bits;
> > +     };
> > +
> > +     /*
> > +      * Override the entries in reg_bits_array with the ones in
> > +      * arm64_ftr_bits_kvm_override.
> > +      */
> > +     for (i = 0; i < ARRAY_SIZE(arm64_ftr_bits_kvm_override); i++) {
> > +             o_bits = &arm64_ftr_bits_kvm_override[i];
> > +             for (j = 0; j < nent; j++) {
> > +                     bits = &reg_bits_array[j];
> > +                     if (bits->sys_id != o_bits->sys_id)
> > +                             continue;
> > +
> > +                     memset(ftr_temp, 0, sizeof(ftr_temp));
> > +
> > +                     /*
> > +                      * Temporary save all entries in o_bits->ftr_bits
> > +                      * to ftr_temp.
> > +                      */
> > +                     copy_arm64_ftr_bits(ftr_temp, o_bits->ftr_bits);
> > +
> > +                     /*
> > +                      * Copy entries from bits->ftr_bits to o_bits->ftr_bits.
> > +                      */
> > +                     copy_arm64_ftr_bits(o_bits->ftr_bits, bits->ftr_bits);
> > +
> > +                     /*
> > +                      * Override entries in o_bits->ftr_bits with the
> > +                      * saved ones, and update bits->ftr_bits with
> > +                      * o_bits->ftr_bits.
> > +                      */
> > +                     arm64_ftr_reg_bits_overrite(o_bits->ftr_bits, ftr_temp);
> > +                     bits->ftr_bits = o_bits->ftr_bits;
> > +                     break;
> > +             }
> > +     }
> > +
> > +     arm64_ftr_bits_kvm_nentries = nent;
> > +     arm64_ftr_bits_kvm = reg_bits_array;
> > +     ret = 0;
> > +
> > +unlock_exit:
> > +     mutex_unlock(&arm64_ftr_bits_kvm_lock);
> > +     return ret;
> > +}
> > +
> > +static int search_cmp_ftr_reg_bits(const void *id, const void *regp)
> > +{
> > +     return ((int)(unsigned long)id -
> > +             (int)((const struct __ftr_reg_bits_entry *)regp)->sys_id);
> > +}
> > +
> > +static const struct arm64_ftr_bits *get_arm64_ftr_bits_kvm(u32 sys_id)
> > +{
> > +     const struct __ftr_reg_bits_entry *ret;
> > +     int err;
> > +
> > +     if (!arm64_ftr_bits_kvm) {
> > +             /* arm64_ftr_bits_kvm is not initialized yet. */
> > +             err = init_arm64_ftr_bits_kvm();
> > +             if (err)
> > +                     return NULL;
> > +     }
> > +
> > +     ret = bsearch((const void *)(unsigned long)sys_id,
> > +                   arm64_ftr_bits_kvm,
> > +                   arm64_ftr_bits_kvm_nentries,
> > +                   sizeof(arm64_ftr_bits_kvm[0]),
> > +                   search_cmp_ftr_reg_bits);
> > +     if (ret)
> > +             return ret->ftr_bits;
> > +
> > +     return NULL;
> > +}
> > +
> > +/*
> > + * Check if features (or levels of features) that are indicated in the ID
> > + * register value @val are also indicated in @limit.
> > + * This function is for KVM to check if features that are indicated in @val,
> > + * which will be used as the ID register value for its guest, are supported
> > + * on the host.
> > + * For AA64MMFR0_EL1.TGranX_2 fields, which don't follow the standard ID
> > + * scheme, the function checks if values of the fields in @val are the same
> > + * as the ones in @limit.
> > + */
> > +int arm64_check_features(u32 sys_reg, u64 val, u64 limit)
> > +{
> > +     const struct arm64_ftr_bits *ftrp = get_arm64_ftr_bits_kvm(sys_reg);
>
> Given that this is to be used only by KVM (and it's inside CONFIG_KVM),
> it might be better to have "kvm" somewhere in its name.

Yes, that might be better. I will change the name.

Thanks,
Reiji
