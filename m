Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99A9C606E23
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 05:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbiJUDJB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 23:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiJUDI6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 23:08:58 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40A5C1A9107
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 20:08:57 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id 3so1364261pfw.4
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 20:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=STonhZa8jZ6LYPO+oZNXkj44XREGON6Gf/DGBneiwkI=;
        b=mLeHnZKp8upCwFqULQ0WMsqVOAbfbjOQeLJ/nW2iaAyeinSRhh8HAdhBVMc2hZC2MX
         mQDwpF7KgDOJy6VPpLQkBrQG4qjXwF9j09ULkxTWNjgtmtNtm7XgkCAvblMM0jjlCkfg
         b19oD36OcL6UjnuNhEke5dCLUexEqGVYYgCuZK0dh5Daun1nBAjzGzoGqIqqB93ReHNE
         GVV+TM99H1zUChwBizTwqff/WWEWhdTIe7Wm9dr7DdVbHdlRScsplxOlxDnO9VMhf9um
         WwuXBLxA5P3k0oKgXjQvQk9mlirHU/Qooc7HjJyACOBCf/wI4FKUVviHhuFlsthGYri1
         E/PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=STonhZa8jZ6LYPO+oZNXkj44XREGON6Gf/DGBneiwkI=;
        b=tYYzQUhAWxEsKnjjnvaJSy//NHSyzSJGHeU+7wM6gk3/gpEe+Mso+H9GTjo7SG/kUT
         Q3ciwDaWhLBmx0W7dr5RJy96mXPhe2fwqRmnxOAeZ/r6G6tsN0+OkBn3L89b6azPL0Fj
         o1UILW+YuNk5MKnA2Ax7wtMvMAVVaQekCriG4DKY7gShH33uTzBP9RcvrLTny+3MO/9i
         VH3g69lAYIT1c3Vb3P3TkYGUIoNyKlK/LdQPQK/8dj+Em6M1LSIKe+J+odDtqN3doL9x
         goVPQtZwJj1Rs4fwqoivDn0qGhZ+9LemNx73ERim7rra0pLcl240LMMxl1Y7nHvc9LtK
         hHZg==
X-Gm-Message-State: ACrzQf35umEYEhVoNlwjxblaL1kGfyaIUVGgV3DgUYBCMhyfbndfbtxq
        1YQczDhr9OkhoASVuSqhEJNFdUD59nzgtWf/uoS/WA==
X-Google-Smtp-Source: AMsMyM6UAgYi+jIUzbgjfQW+SHmEryO+206C9MR8xI73umNRvQecApqvBt9nb0UdbJXU+6CAYcSM5JP4dIs3jf7w0TE=
X-Received: by 2002:a63:db58:0:b0:443:575e:d1ed with SMTP id
 x24-20020a63db58000000b00443575ed1edmr14173692pgi.468.1666321736503; Thu, 20
 Oct 2022 20:08:56 -0700 (PDT)
MIME-Version: 1.0
References: <20221020054202.2119018-1-reijiw@google.com> <20221020054202.2119018-2-reijiw@google.com>
 <Y1GckDU/gCNQ6tAS@google.com>
In-Reply-To: <Y1GckDU/gCNQ6tAS@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Thu, 20 Oct 2022 20:08:39 -0700
Message-ID: <CAAeT=FyOEGQE3pZtz4eft8N9vaD3ESEQ3i0R5X4OZb+5isSBAg@mail.gmail.com>
Subject: Re: [PATCH v2 1/9] KVM: arm64: selftests: Use FIELD_GET() to extract
 ID register fields
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

On Thu, Oct 20, 2022 at 12:08 PM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> On Wed, Oct 19, 2022 at 10:41:54PM -0700, Reiji Watanabe wrote:
> > Use FIELD_GET() macro to extract ID register fields for existing
> > aarch64 selftests code. No functional change intended.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c  | 3 ++-
> >  tools/testing/selftests/kvm/aarch64/debug-exceptions.c | 3 ++-
> >  tools/testing/selftests/kvm/lib/aarch64/processor.c    | 7 ++++---
> >  3 files changed, 8 insertions(+), 5 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c b/tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c
> > index 6f9c1f19c7f6..b6a5e8861b35 100644
> > --- a/tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c
> > +++ b/tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c
> > @@ -13,6 +13,7 @@
> >  #include "kvm_util.h"
> >  #include "processor.h"
> >  #include "test_util.h"
> > +#include <linux/bitfield.h>
> >
> >  #define BAD_ID_REG_VAL       0x1badc0deul
> >
> > @@ -145,7 +146,7 @@ static bool vcpu_aarch64_only(struct kvm_vcpu *vcpu)
> >
> >       vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1), &val);
> >
> > -     el0 = (val & ARM64_FEATURE_MASK(ID_AA64PFR0_EL0)) >> ID_AA64PFR0_EL0_SHIFT;
> > +     el0 = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL0), val);
> >       return el0 == ID_AA64PFR0_ELx_64BIT_ONLY;
> >  }
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> > index 947bd201435c..3808d3d75055 100644
> > --- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> > +++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> > @@ -2,6 +2,7 @@
> >  #include <test_util.h>
> >  #include <kvm_util.h>
> >  #include <processor.h>
> > +#include <linux/bitfield.h>
> >
> >  #define MDSCR_KDE    (1 << 13)
> >  #define MDSCR_MDE    (1 << 15)
> > @@ -284,7 +285,7 @@ static int debug_version(struct kvm_vcpu *vcpu)
> >       uint64_t id_aa64dfr0;
> >
> >       vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &id_aa64dfr0);
> > -     return id_aa64dfr0 & 0xf;
> > +     return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER), id_aa64dfr0);
> >  }
> >
> >  static void test_guest_debug_exceptions(void)
> > diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > index 6f5551368944..7c96b931edd5 100644
> > --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > @@ -11,6 +11,7 @@
> >  #include "guest_modes.h"
> >  #include "kvm_util.h"
> >  #include "processor.h"
> > +#include <linux/bitfield.h>
> >
> >  #define DEFAULT_ARM64_GUEST_STACK_VADDR_MIN  0xac0000
> >
> > @@ -486,9 +487,9 @@ void aarch64_get_supported_page_sizes(uint32_t ipa,
> >       err = ioctl(vcpu_fd, KVM_GET_ONE_REG, &reg);
> >       TEST_ASSERT(err == 0, KVM_IOCTL_ERROR(KVM_GET_ONE_REG, vcpu_fd));
> >
> > -     *ps4k = ((val >> 28) & 0xf) != 0xf;
> > -     *ps64k = ((val >> 24) & 0xf) == 0;
> > -     *ps16k = ((val >> 20) & 0xf) != 0;
> > +     *ps4k = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_TGRAN4), val) != 0xf;
> > +     *ps64k = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_TGRAN64), val) == 0;
> > +     *ps16k = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_TGRAN16), val) != 0;
>
> Not your code, but since we're here...
>
> Should we change the field values to use the #define's? Also, the test

I agree that would be better.

> for TGRAN64 looks wrong. We should test != ID_AA64MMFR0_TGRAN64_NI. A
> value greater than 0 would indicate an extension of the feature.

Yes, I thought about that, too.

I assumed the intention of the code was only 0x0 is defined as
64KB granule supported as of today unlike for other granule sizes,
which has more than one value that indicates the granule support.
But, considering principles of the ID scheme for fields in ID registers,
I think ">= ID_AA64MMFR0_TGRAN{4,16,64}_SUPPORTED_MIN" would be more
appropriate way of doing those check, although then TGRAN4 and TGRAN64
fields should be handled as signed fields (or we could do
"<= ID_AA64MMFR0_TGRAN{4,16,64}_SUPPORTED_MAX").

I can fix those if I have a chance to work on v3.

> But for this exact change:
>
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

Thank you for the review!

Thanks,
Reiji
