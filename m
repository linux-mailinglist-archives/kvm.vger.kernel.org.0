Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4431F42E087
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 19:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233693AbhJNRws (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 13:52:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:33664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231434AbhJNRws (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 13:52:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 499F4610D2;
        Thu, 14 Oct 2021 17:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634233843;
        bh=PpVTtERMzg3uEkiu6bflhUrV/MBFiW06oSNoFah347E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OFgOPTRBVPbnQ7y26Qb9+4d33mPIgg41Y6lvkK7UM+5Z0+tqOWNzfa5RuvghEEHyO
         oi+6CUXOlo/6kYlCRRwr23j1fjFIKBTWV3vhtrdE82F4kFoNhAlDf4Apo1maBCGbjB
         MOiOnu0KWvSYbyNn+VjaRJxtwQu7VakaDUtsIVSlUFODiwBvG2Y4W1ofre8stqp/cI
         DbV4uQz4gCipOsnDWSBFI+9J1FnNghLy+3OGyXq65g8E1rE9GGw8rbtiDLc0wFEvbR
         uniXSq0rXWFUnM8ofWGsAaaoRoqQferSKWE5xbs0PUacrgH90xQHhQLzIbNZqQvukU
         GOLtPxoupwcpQ==
Date:   Thu, 14 Oct 2021 10:50:38 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Jim Mattson <jmattson@google.com>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, torvic9@mailbox.org,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "bp@alien8.de" <bp@alien8.de>
Subject: Re: [BUG] [5.15] Compilation error in arch/x86/kvm/mmu/spte.h with
 clang-14
Message-ID: <YWht7v/1RuAiHIvC@archlinux-ax161>
References: <1446878298.170497.1633338512925@office.mailbox.org>
 <b6abc5a3-39ea-b463-9df5-f50bdcb16d08@redhat.com>
 <936688112.157288.1633339838738@office.mailbox.org>
 <c4773ecc-053f-9bc6-03af-5039397a4531@redhat.com>
 <CAKwvOd=rrM4fGdGMkD5+kdA49a6K+JcUiR4K2-go=MMt++ukPA@mail.gmail.com>
 <CALMp9eRzadC50n=d=NFm7osVgKr+=UG7r2cWV2nOCfoPN41vvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eRzadC50n=d=NFm7osVgKr+=UG7r2cWV2nOCfoPN41vvQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 04, 2021 at 10:12:33AM -0700, Jim Mattson wrote:
> On Mon, Oct 4, 2021 at 9:13 AM Nick Desaulniers <ndesaulniers@google.com> wrote:
> >
> > On Mon, Oct 4, 2021 at 2:49 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> > >
> > > On 04/10/21 11:30, torvic9@mailbox.org wrote:
> > > >
> > > >> Paolo Bonzini <pbonzini@redhat.com> hat am 04.10.2021 11:26 geschrieben:
> > > >>
> > > >>
> > > >> On 04/10/21 11:08, torvic9@mailbox.org wrote:
> > > >>> I encounter the following issue when compiling 5.15-rc4 with clang-14:
> > > >>>
> > > >>> In file included from arch/x86/kvm/mmu/mmu.c:27:
> > > >>> arch/x86/kvm/mmu/spte.h:318:9: error: use of bitwise '|' with boolean operands [-Werror,-Wbitwise-instead-of-logical]
> > > >>>           return __is_bad_mt_xwr(rsvd_check, spte) |
> > > >>>                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > >>>                                                    ||
> > > >>> arch/x86/kvm/mmu/spte.h:318:9: note: cast one or both operands to int to silence this warning
> > > >>
> > > >> The warning is wrong, as mentioned in the line right above:
> 
> Casting the bool to an int doesn't seem that onerous.

Alternatively, could we just change both of the functions to return u64?
I understand that they are being used in boolean contexts only but it
seems like this would make it clear that a boolean or bitwise operator
on them is acceptable.

diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index eb7b227fc6cf..0ca215bfe3a3 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -295,14 +295,14 @@ static inline u64 get_rsvd_bits(struct rsvd_bits_validate *rsvd_check, u64 pte,
 	return rsvd_check->rsvd_bits_mask[bit7][level-1];
 }
 
-static inline bool __is_rsvd_bits_set(struct rsvd_bits_validate *rsvd_check,
-				      u64 pte, int level)
+static inline u64 __is_rsvd_bits_set(struct rsvd_bits_validate *rsvd_check,
+				     u64 pte, int level)
 {
 	return pte & get_rsvd_bits(rsvd_check, pte, level);
 }
 
-static inline bool __is_bad_mt_xwr(struct rsvd_bits_validate *rsvd_check,
-				   u64 pte)
+static inline u64 __is_bad_mt_xwr(struct rsvd_bits_validate *rsvd_check,
+				  u64 pte)
 {
 	return rsvd_check->bad_mt_xwr & BIT_ULL(pte & 0x3f);
 }

> > > > So it's an issue with clang-14 then?
> > > > (I add Nick and Nathan)
> > >
> > > My clang here doesn't have the option, so I'm going to ask---are you
> > > using W=1?  I can see why clang is warning for KVM's code, but in my
> > > opinion such a check should only be in -Wextra.
> >
> > This is a newly added warning in top of tree clang.
> >
> > >
> > > Paolo
> > >
> > > >>
> > > >>           /*
> > > >>            * Use a bitwise-OR instead of a logical-OR to aggregate the reserved
> > > >>            * bits and EPT's invalid memtype/XWR checks to avoid an extra Jcc
> > > >>            * (this is extremely unlikely to be short-circuited as true).
> > > >>            */
> > > >>
> > > >> Paolo
> > > >
> > >
> >
> >
> > --
> > Thanks,
> > ~Nick Desaulniers
> 
