Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5C964E4C86
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 07:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232627AbiCWGIM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 02:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231919AbiCWGIM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 02:08:12 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 235716E8DB
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 23:06:43 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id o8so332845pgf.9
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 23:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TMWiPpce5uJfh5LzsvNs4pu3d9Ouof0td3tYTU99XWs=;
        b=IIhYlZ7oqlN50w8829NZbQWoQVTXirqX5nU75Rn4DIelpKnnabo4vhfhTRghOT3Lsy
         IHS+m3wOF6J+qKDaQAd0SecMGmCZNy3MO63+dq/jihkgpo7zqYXQu+lM8ZlRttU6Quxn
         vf+FBSUGMA6AsqhR9YijSmZdTf5yC2XkYYWWFbweimamoEGui2N8zVtPwu8HQlIl6oX6
         16AtwxQIPCm0IrPx2W6BHLEJOwnnRQ4Xi+oxTnWCyINyEa5fbbUoVhjaom50a+yOKA0A
         7qLGKTTz5eMooPmo4owBQ66yUfdeNy9nq+KAnb0GS0Kb/Gdmk5UXvdRszu3xGdXA9s1K
         f4qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TMWiPpce5uJfh5LzsvNs4pu3d9Ouof0td3tYTU99XWs=;
        b=ybAE5V2fjcv78t/BrrpwNVcIkzzx7putLsS0FmZwVpxTaNfPcUou+MAQE32vGGTKK6
         hTY8U9A8LoL2rW26l/I/5rjS4Lp0Sx0BYD8Zmd6uHBxN6iJ9CKPe15WxEUrOm1HmdOst
         2MzE8yAvcdykR2ylqydCrfJ6Zit+9QoCofnWJODbdC6ipRdFNUhehrv6CXxDQj5fyMH7
         Kt2rmRNbGW1l1pZwDfq3aphTSLGNv3OaVX0LZpXj1Yoqom/U5N0eqFx76jl20Sz+Oaer
         74KNTawlP0z4sC0dDYV2UuZe4IsFWo7CwCVENSE44QfWL3XJcox+ZLVfmrcHhAmRhAds
         h/mA==
X-Gm-Message-State: AOAM531YhWj+X7DvBjWSEyGqT+mwzQ1U2aeHf5KG6eRwCHczCI4UewZ+
        P8qpYSc4cotQ9JV9IdFq8pXblM0qOAtCxGD+Rv18+g==
X-Google-Smtp-Source: ABdhPJwNbKfJfwy5ZfdKLw8GsZcf5H537Ft+zyRd4ak95P8c0qpFksGdD+XpYydsR28b0ysDQ/QKtSB9iVawGVPv9ko=
X-Received: by 2002:a05:6a00:2355:b0:4fa:9cae:b3c9 with SMTP id
 j21-20020a056a00235500b004fa9caeb3c9mr14907772pfj.82.1648015602442; Tue, 22
 Mar 2022 23:06:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220311044811.1980336-1-reijiw@google.com> <20220311044811.1980336-2-reijiw@google.com>
 <Yjl96UQ7lUovKBWD@google.com>
In-Reply-To: <Yjl96UQ7lUovKBWD@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 22 Mar 2022 23:06:26 -0700
Message-ID: <CAAeT=FzELqXZiWjZ9aRNqYRbX0zx6LdhETiZUS+CMvax2vLRQw@mail.gmail.com>
Subject: Re: [PATCH v6 01/25] KVM: arm64: Introduce a validation function for
 an ID register
To:     Oliver Upton <oupton@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Fuad Tabba <tabba@google.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

> On Thu, Mar 10, 2022 at 08:47:47PM -0800, Reiji Watanabe wrote:
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
>
> I have some concerns regarding the API between cpufeature and KVM that's
> being proposed here. It would appear that we are adding some of KVM's
> implementation details into the cpufeature code. In particular, I see
> that KVM's limitations on AA64DFR0 are being copied here.

I assume "KVM's limitation details" you meant is about
ftr_id_aa64dfr0_kvm.
Entries in arm64_ftr_bits_kvm_override shouldn't be added based
on KVM's implementation.  When cpufeature.c doesn't handle lower level
of (or fewer) features as the "safe" value for fields, the field should
be added to arm64_ftr_bits_kvm_override.  As PMUVER and DEBUGVER are not
treated as LOWER_SAFE, they were added in arm64_ftr_bits_kvm_override.
Having said that, although ftr_id_aa64dfr0 has PMUVER as signed field,
I didn't fix that in ftr_id_aa64dfr0_kvm, and the code abused that....
I should make PMUVER unsigned field, and fix cpufeature.c to validate
the field based on its special ID scheme for cleaner abstraction.
(And KVM should skip the cpufeature.c's PMUVER validation using
 id_reg_desc's ignore_mask and have KVM validate it locally based on
 the KVM's special requirement)


> Additionally, I think it would be preferable to expose this in a manner
> that does not require CONFIG_KVM guards in other parts of the kernel.
>
> WDYT about having KVM keep its set of feature overrides and otherwise
> rely on the kernel's feature tables? I messed around with the idea a
> bit until I could get something workable (attached). I only compile
> tested this :)

Thanks for the proposal!
But, providing the overrides to arm64_ftr_reg_valid() means that its
consumer knows implementation details of cpufeture.c (values of entries
in arm64_ftr_regs[]), which is a similar abstraction problem I want to
avoid (the default validation by cpufeature.c should be purely based on
ID schemes even with this option).

Another option that I considered earlier was having a full set of
arm64_ftr_bits in KVM for its validation. At the time, I thought
statically) having a full set of arm64_ftr_bits in KVM is not good in
terms of maintenance.  But, considering that again, since most of
fields are unsigned and lower safe fields, and KVM doesn't necessarily
have to statically have a full set of arm64_ftr_bits (can dynamically
generate during KVM's initialization), it may not be that bad.
So, I am thinking of exploring this option.

More specifically, changes in cpufeature.c from patch-1 will be below
and remove all other newly added codes from cpufeature.c.
(Need more changes in KVM)

---
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -3357,9 +3357,9 @@ static const struct arm64_ftr_bits
*get_arm64_ftr_bits_kvm(u32 sys_id)
  * scheme, the function checks if values of the fields in @val are the same
  * as the ones in @limit.
  */
-int arm64_check_features_kvm(u32 sys_reg, u64 val, u64 limit)
+int arm64_check_features(u32 sys_reg, const struct arm64_ftr_bits *ftrp,
+                            u64 val, u64 limit)
 {
-       const struct arm64_ftr_bits *ftrp = get_arm64_ftr_bits_kvm(sys_reg);
        u64 exposed_mask = 0;

        if (!ftrp)
---

Thanks,
Reiji
