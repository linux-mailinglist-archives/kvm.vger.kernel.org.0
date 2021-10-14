Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5C942E14C
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 20:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbhJNSds (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 14:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231309AbhJNSdq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 14:33:46 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 720B4C061753
        for <kvm@vger.kernel.org>; Thu, 14 Oct 2021 11:31:41 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id qe4-20020a17090b4f8400b0019f663cfcd1so7577099pjb.1
        for <kvm@vger.kernel.org>; Thu, 14 Oct 2021 11:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZOtoUVJrO4cNBuAtSKrwYDvg+7jgQsiUmd1c9X90gTI=;
        b=cKhphWfr8pcChoAYpqsqwwmSDmFee5Gfbw2C5LhTh0T//9b8U6M0NX69RIZnvvank5
         F7FEnaAteZ+7wFDe3VaCzlq5iOCrGm0DG7XSKJFCeLQMAM6Gy8LmelPjU00DkXxPbu7j
         tPnogHSHJLh+AFRKIg9RJNfjJ5NO4PM4AtmysEW6NdOa1o9sZKYsvijMRDOegENdTKlx
         BfjxjT42ddPVzsU3OpXcBVlS0aWw9SkmmWuh+iVEcSzSeCQRciUK98GJRCUJkRhUgpvQ
         Q8PAUwyGSMJa4DD5hv9/K7EDb+Yf4sV97Jno5HT1vbSeQaz0riPHqtwjZB4DsvrjTIVN
         yk8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZOtoUVJrO4cNBuAtSKrwYDvg+7jgQsiUmd1c9X90gTI=;
        b=nKGTi+g1X0LVnRpAQY5NkOZcyw0ktHd+FXPmwgIXehAqPLnS55JKiPvmKiEp9BtD4s
         Bstd+rzo2nZ6sKPI/40ILnbaoIQy99EHT8WCJ4uPwJzWbyK/T1CUxxKkZmbzIudcPv44
         5fS/7Dh2OcZO743HnJTGmaiJJcngGaviriT/LX+s5yG11dfJKllhHtZ1xAU7TPlLqRts
         3KhycJTbjNi9exDz5cT/DhTLyuLk2fZc+OVZfRp9bQQdnX2+KFlM3TVKAiYOE41bMbDt
         Snppa7rlUOgCshOPYb+v+kLAj1oQCDfOruphg4vcW3nyYHLxbYlFa61jZ009jYiqJth5
         GRkg==
X-Gm-Message-State: AOAM532k/8qwn/pCM1HEsQ2wQNM78V+5ol4O8APOFCwgSWml8aGrWIIe
        NzTFyzv+f8MBTPdNdMiIXri2wQ==
X-Google-Smtp-Source: ABdhPJx/195vVGDLtpTTDyd8ezSob21GI2+YOc4x+wbtS2Gkb/xiCHDczCRmurz/Vb9GHMVdBR9NZQ==
X-Received: by 2002:a17:902:9882:b0:13e:1749:daae with SMTP id s2-20020a170902988200b0013e1749daaemr6523086plp.60.1634236300729;
        Thu, 14 Oct 2021 11:31:40 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 60sm9304804pjz.11.2021.10.14.11.31.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 11:31:40 -0700 (PDT)
Date:   Thu, 14 Oct 2021 18:31:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Jim Mattson <jmattson@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, torvic9@mailbox.org,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "bp@alien8.de" <bp@alien8.de>
Subject: Re: [BUG] [5.15] Compilation error in arch/x86/kvm/mmu/spte.h with
 clang-14
Message-ID: <YWh3iBoitI9UNmqV@google.com>
References: <1446878298.170497.1633338512925@office.mailbox.org>
 <b6abc5a3-39ea-b463-9df5-f50bdcb16d08@redhat.com>
 <936688112.157288.1633339838738@office.mailbox.org>
 <c4773ecc-053f-9bc6-03af-5039397a4531@redhat.com>
 <CAKwvOd=rrM4fGdGMkD5+kdA49a6K+JcUiR4K2-go=MMt++ukPA@mail.gmail.com>
 <CALMp9eRzadC50n=d=NFm7osVgKr+=UG7r2cWV2nOCfoPN41vvQ@mail.gmail.com>
 <YWht7v/1RuAiHIvC@archlinux-ax161>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YWht7v/1RuAiHIvC@archlinux-ax161>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 14, 2021, Nathan Chancellor wrote:
> On Mon, Oct 04, 2021 at 10:12:33AM -0700, Jim Mattson wrote:
> > On Mon, Oct 4, 2021 at 9:13 AM Nick Desaulniers <ndesaulniers@google.com> wrote:
> > >
> > > On Mon, Oct 4, 2021 at 2:49 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> > > >
> > > > On 04/10/21 11:30, torvic9@mailbox.org wrote:
> > > > >
> > > > >> Paolo Bonzini <pbonzini@redhat.com> hat am 04.10.2021 11:26 geschrieben:
> > > > >>
> > > > >>
> > > > >> On 04/10/21 11:08, torvic9@mailbox.org wrote:
> > > > >>> I encounter the following issue when compiling 5.15-rc4 with clang-14:
> > > > >>>
> > > > >>> In file included from arch/x86/kvm/mmu/mmu.c:27:
> > > > >>> arch/x86/kvm/mmu/spte.h:318:9: error: use of bitwise '|' with boolean operands [-Werror,-Wbitwise-instead-of-logical]
> > > > >>>           return __is_bad_mt_xwr(rsvd_check, spte) |
> > > > >>>                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > > >>>                                                    ||
> > > > >>> arch/x86/kvm/mmu/spte.h:318:9: note: cast one or both operands to int to silence this warning
> > > > >>
> > > > >> The warning is wrong, as mentioned in the line right above:
> > 
> > Casting the bool to an int doesn't seem that onerous.
> 
> Alternatively, could we just change both of the functions to return u64?
> I understand that they are being used in boolean contexts only but it
> seems like this would make it clear that a boolean or bitwise operator
> on them is acceptable.

If we want to fix this, my vote is for casting to an int and updating the comment
in is_rsvd_spte().  I think I'd vote to fix this?  IIRC KVM has had bitwise goofs
in the past that manifested as real bugs, it would be nice to turn this on.

Or maybe add a macro to handle this?  E.g.

diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 7c0b09461349..38aeb4b21925 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -307,6 +307,12 @@ static inline bool __is_bad_mt_xwr(struct rsvd_bits_validate *rsvd_check,
        return rsvd_check->bad_mt_xwr & BIT_ULL(pte & 0x3f);
 }

+/*
+ * Macro for intentional bitwise-OR of two booleans, which requires casting at
+ * least one of the results to an int to suppress -Wbitwise-instead-of-logical.
+ */
+#define BITWISE_BOOLEAN_OR(a, b) (!!((int)(a) | (int)(b)))
+
 static __always_inline bool is_rsvd_spte(struct rsvd_bits_validate *rsvd_check,
                                         u64 spte, int level)
 {
@@ -315,8 +321,8 @@ static __always_inline bool is_rsvd_spte(struct rsvd_bits_validate *rsvd_check,
         * bits and EPT's invalid memtype/XWR checks to avoid an extra Jcc
         * (this is extremely unlikely to be short-circuited as true).
         */
-       return __is_bad_mt_xwr(rsvd_check, spte) |
-              __is_rsvd_bits_set(rsvd_check, spte, level);
+       return BITWISE_BOOLEAN_OR(__is_bad_mt_xwr(rsvd_check, spte),
+                                 __is_rsvd_bits_set(rsvd_check, spte, level));
 }

 static inline bool spte_can_locklessly_be_made_writable(u64 spte)
