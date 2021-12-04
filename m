Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6013146823F
	for <lists+kvm@lfdr.de>; Sat,  4 Dec 2021 05:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239621AbhLDEiy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 23:38:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231192AbhLDEix (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Dec 2021 23:38:53 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B296DC061751
        for <kvm@vger.kernel.org>; Fri,  3 Dec 2021 20:35:28 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id k4so3441795plx.8
        for <kvm@vger.kernel.org>; Fri, 03 Dec 2021 20:35:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p+rPr7XIjjwvjYiHeBShUBv79Kxgl9YRLiKJd4X5MRw=;
        b=kGVlNYxU8zT2Lququ5VgSBP0nQ45wZTEGEgvuyU4OVZsVO1lwA9lagkzOpUA4g/EQ7
         TXaXsO+mkVN573fITVcPytDhHzg8qRpgW56/PErvxV9/tpZB5asKku3QwTDqHf32Eg6G
         eHm/01DIYGdDiGmt36KUpgpxd9MJHrtJmN5nyRLjgf6NcVEItuim35WYBTbbTxdsSejz
         JQz3Aj7uHfygPIdJzEItt3OW4v1aqeyroZYDMqYVJxPqLhuFcnftcjWJbtx/nKyTOaiu
         hUeNAy0yv2MJqajFSkqND6KwyeZl9eMtXRfhfObjFu/aCifWRKeUJozGeUt52pqfaqiP
         cH1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p+rPr7XIjjwvjYiHeBShUBv79Kxgl9YRLiKJd4X5MRw=;
        b=fQYRvPSbXCFTTgs6tRjWAEIhnETjcrgI+vwAGigjv8gH/GmWhtpWd2pJ1Kz3ShhhwL
         AVzZ3pxwJsHF7tnNUvokIGvE5ntImR56e3PnrQgMf/I/ZvRxt8w9WU8jQWWvZrBH/ODs
         dfZHnK2D9UBzNU20GU9vKfV5Dq3nRUmAJFrp6Uy1vN1fGYz/bcMP6OW4fkbGQN2ygEgs
         ALFMMU+j+03iByExwzfzbKzheo5+VXgyMFTay0oDwZR+AQsjEcSoGBC+Xqzo3mymZ3eZ
         luxKuFWcWzPfMCw9WYCta2etFXwadQ5slPHFspOirLHAslnpfdip2eHbjabZ1d+NQ+aF
         RtPw==
X-Gm-Message-State: AOAM531c1jqQyGYiIUc1nldWenWQgsTym4So/l1ROYWVqOdKZi0qYGCa
        piy46jyTrR2KsQPmqS8QTym4lpQ5xTUNHqBzuiKg4lNzz9wyIA==
X-Google-Smtp-Source: ABdhPJzCG4DFgxCKBZ/sAMV1Fc1BhJOLsH6djfvGO/LrhKBAeyqV2cIP3G8zKthT11vht/hjbxPoewAGf0Qv/JdUG7w=
X-Received: by 2002:a17:902:d703:b0:144:e012:d550 with SMTP id
 w3-20020a170902d70300b00144e012d550mr27390851ply.38.1638592527674; Fri, 03
 Dec 2021 20:35:27 -0800 (PST)
MIME-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com> <20211117064359.2362060-4-reijiw@google.com>
 <e480d851-2d88-6f79-daf4-22c4841f88a4@redhat.com>
In-Reply-To: <e480d851-2d88-6f79-daf4-22c4841f88a4@redhat.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Fri, 3 Dec 2021 20:35:11 -0800
Message-ID: <CAAeT=FwEbJrK5afynLFfgFU199iHd093UvbkWRzxJ_j6fssB2g@mail.gmail.com>
Subject: Re: [RFC PATCH v3 03/29] KVM: arm64: Introduce struct id_reg_info
To:     Eric Auger <eauger@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On Thu, Dec 2, 2021 at 4:51 AM Eric Auger <eauger@redhat.com> wrote:
>
> Hi Reiji,
>
> On 11/17/21 7:43 AM, Reiji Watanabe wrote:
> > This patch lays the groundwork to make ID registers writable.
> >
> > Introduce struct id_reg_info for an ID register to manage the
> > register specific control of its value for the guest, and provide set
> > of functions commonly used for ID registers to make them writable.
> >
> > The id_reg_info is used to do register specific initialization,
> > validation of the ID register and etc.  Not all ID registers must
> > have the id_reg_info. ID registers that don't have the id_reg_info
> > are handled in a common way that is applied to all ID registers.
> >
> > At present, changing an ID register from userspace is allowed only
> > if the ID register has the id_reg_info, but that will be changed
> > by the following patches.
> >
> > No ID register has the structure yet and the following patches
> > will add the id_reg_info for some ID registers.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/include/asm/sysreg.h |   1 +
> >  arch/arm64/kvm/sys_regs.c       | 226 ++++++++++++++++++++++++++++++--
> >  2 files changed, 218 insertions(+), 9 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> > index 16b3f1a1d468..597609f26331 100644
> > --- a/arch/arm64/include/asm/sysreg.h
> > +++ b/arch/arm64/include/asm/sysreg.h
> > @@ -1197,6 +1197,7 @@
> >  #define ICH_VTR_TDS_MASK     (1 << ICH_VTR_TDS_SHIFT)
> >
> >  #define ARM64_FEATURE_FIELD_BITS     4
> > +#define ARM64_FEATURE_FIELD_MASK     ((1ull << ARM64_FEATURE_FIELD_BITS) - 1)
> >
> >  /* Create a mask for the feature bits of the specified feature. */
> >  #define ARM64_FEATURE_MASK(x)        (GENMASK_ULL(x##_SHIFT + ARM64_FEATURE_FIELD_BITS - 1, x##_SHIFT))
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 5608d3410660..1552cd5581b7 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -265,6 +265,181 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
> >               return read_zero(vcpu, p);
> >  }
> >
> > +/*
> > + * A value for FCT_LOWER_SAFE must be zero and changing that will affect
> > + * ftr_check_types of id_reg_info.
> > + */
> > +enum feature_check_type {
> > +     FCT_LOWER_SAFE = 0,
> > +     FCT_HIGHER_SAFE,
> > +     FCT_HIGHER_OR_ZERO_SAFE,
> > +     FCT_EXACT,
> > +     FCT_EXACT_OR_ZERO_SAFE,
> > +     FCT_IGNORE,     /* Don't check (any value is fine) */
> > +};
> > +
> > +static int arm64_check_feature_one(enum feature_check_type type, int val,
> > +                                int limit)
> > +{
> > +     bool is_safe = false;
> > +
> > +     if (val == limit)
> > +             return 0;
> > +
> > +     switch (type) {
> > +     case FCT_LOWER_SAFE:
> > +             is_safe = (val <= limit);
> > +             break;
> > +     case FCT_HIGHER_OR_ZERO_SAFE:
> > +             if (val == 0) {
> > +                     is_safe = true;
> > +                     break;
> > +             }
> > +             fallthrough;
> > +     case FCT_HIGHER_SAFE:
> > +             is_safe = (val >= limit);
> > +             break;
> > +     case FCT_EXACT:
> > +             break;
> > +     case FCT_EXACT_OR_ZERO_SAFE:
> > +             is_safe = (val == 0);
> > +             break;
> > +     case FCT_IGNORE:
> > +             is_safe = true;
> > +             break;
> > +     default:
> > +             WARN_ONCE(1, "Unexpected feature_check_type (%d)\n", type);
> > +             break;
> > +     }
> > +
> > +     return is_safe ? 0 : -1;
> > +}
> > +
> > +#define      FCT_TYPE_MASK           0x7
> > +#define      FCT_TYPE_SHIFT          1
> > +#define      FCT_SIGN_MASK           0x1
> > +#define      FCT_SIGN_SHIFT          0
> > +#define      FCT_TYPE(val)   ((val >> FCT_TYPE_SHIFT) & FCT_TYPE_MASK)
> > +#define      FCT_SIGN(val)   ((val >> FCT_SIGN_SHIFT) & FCT_SIGN_MASK)
> > +
> > +#define      MAKE_FCT(shift, type, sign)                             \
> > +     ((u64)((((type) & FCT_TYPE_MASK) << FCT_TYPE_SHIFT) |   \
> > +            (((sign) & FCT_SIGN_MASK) << FCT_SIGN_SHIFT)) << (shift))
> > +
> > +/* For signed field */
> > +#define      S_FCT(shift, type)      MAKE_FCT(shift, type, 1)
> > +/* For unigned field */
> > +#define      U_FCT(shift, type)      MAKE_FCT(shift, type, 0)
> > +
> > +/*
> > + * @val and @lim are both a value of the ID register. The function checks
> > + * if all features indicated in @val can be supported for guests on the host,
> > + * which supports features indicated in @lim. @check_types indicates how
> > + * features in the ID register needs to be checked.
> > + * See comments for id_reg_info's ftr_check_types field for more detail.
> > + */
> > +static int arm64_check_features(u64 check_types, u64 val, u64 lim)
> > +{
> > +     int i;
> > +
> > +     for (i = 0; i < 64; i += ARM64_FEATURE_FIELD_BITS) {
> > +             u8 ftr_check = (check_types >> i) & ARM64_FEATURE_FIELD_MASK;
> > +             bool is_sign = FCT_SIGN(ftr_check);
> > +             enum feature_check_type fctype = FCT_TYPE(ftr_check);
> > +             int fval, flim, ret;
> > +
> > +             fval = cpuid_feature_extract_field(val, i, is_sign);
> > +             flim = cpuid_feature_extract_field(lim, i, is_sign);
> > +
> > +             ret = arm64_check_feature_one(fctype, fval, flim);
> > +             if (ret)
> > +                     return -E2BIG;
> > +     }
> > +     return 0;
> > +}
> > +
> > +struct id_reg_info {
> > +     u32     sys_reg;        /* Register ID */
> > +
> > +     /*
> > +      * Limit value of the register for a vcpu. The value is the sanitized
> > +      * system value with bits cleared for unsupported features for the
> > +      * guest.
> > +      */
> > +     u64     vcpu_limit_val;
> > +
> > +     /*
> > +      * The ftr_check_types is comprised of a set of 4 bits fields.
> > +      * Each 4 bits field is for a feature indicated by the same bits
> > +      * field of the ID register and indicates how the feature support
> > +      * for guests needs to be checked.
> > +      * The bit 0 indicates that the corresponding ID register field
> > +      * is signed(1) or unsigned(0).
> > +      * The bits [3:1] hold feature_check_type for the field.
> > +      * If all zero, all features in the ID register are treated as unsigned
> > +      * fields and checked based on Principles of the ID scheme for fields
> > +      * in ID registers (FCT_LOWER_SAFE of feature_check_type).
> > +      */
> > +     u64     ftr_check_types;
> > +
> > +     /* Initialization function of the id_reg_info */
> > +     void (*init)(struct id_reg_info *id_reg);
> > +
> > +     /* Register specific validation function */
> > +     int (*validate)(struct kvm_vcpu *vcpu, const struct id_reg_info *id_reg,
> > +                     u64 val);
> > +
> > +     /* Return the reset value of the register for the vCPU */
> > +     u64 (*get_reset_val)(struct kvm_vcpu *vcpu,
> > +                          const struct id_reg_info *id_reg);
> It is unclear to me why we need 2 different callbacks, ie. init and
> get_reset_val. ID_REGS can only be accessed from user space after the
> vcpu reset, right? So couldn't we have a single cb instead of this
> overwrite mechanism?

Thank you for the comment.

What the init() does needs to be done just once.
It initializes the id_reg_info itself (not for the ID register of vCPU).
And the data initialized by the init() is used not just for the
overwrite mechanism at the vcpu reset but for other purposes as well.

What the get_reset_val does needs to be done for every initial vCPU reset.
It provides the initial value for the vCPU, which depends on its feature
configuration that is configured by KVM_ARM_VCPU_INIT (or other APIs).

Of course there are other ways to achieve the same, and it's entirely
possible to have a single function though.  I just chose to use a
separate function for each of those two different purposes.

Thanks,
Reiji
