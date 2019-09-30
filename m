Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8619CC28D0
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2019 23:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730042AbfI3Vaq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 17:30:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43976 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729482AbfI3Vap (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 17:30:45 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A6ADC3066FD9;
        Mon, 30 Sep 2019 17:54:50 +0000 (UTC)
Received: from localhost (ovpn-116-88.gru2.redhat.com [10.97.116.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3954F5D9C9;
        Mon, 30 Sep 2019 17:54:50 +0000 (UTC)
Date:   Mon, 30 Sep 2019 14:54:49 -0300
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Robert Hoo <robert.hu@linux.intel.com>,
        kvm list <kvm@vger.kernel.org>,
        Robert Hu <robert.hu@intel.com>, qemu-devel@nongnu.org
Subject: Re: [PATCH] x86: Add CPUID KVM support for new instruction WBNOINVD
Message-ID: <20190930175449.GB4084@habkost.net>
References: <1545227503-214403-1-git-send-email-robert.hu@linux.intel.com>
 <CALMp9eRZCoZbeyttZdvaCUpOFKygTNVF_x7+TWh6MktmF-ZK9A@mail.gmail.com>
 <263d31d9-b21e-ceb9-b47c-008e30bbd94f@redhat.com>
 <CALMp9eRFWq+F1Dwb8NcBd-Bo-YbT6KMOLo8DoinQQfK9hEi5Qg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eRFWq+F1Dwb8NcBd-Bo-YbT6KMOLo8DoinQQfK9hEi5Qg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Mon, 30 Sep 2019 17:54:50 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CCing qemu-devel.

On Tue, Sep 24, 2019 at 01:30:04PM -0700, Jim Mattson wrote:
> On Wed, Dec 19, 2018 at 1:02 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > On 19/12/18 18:39, Jim Mattson wrote:
> > > Is this an instruction that kvm has to be able to emulate before it
> > > can enumerate its existence?
> >
> > It doesn't have any operands, so no.
> >
> > Paolo
> >
> > > On Wed, Dec 19, 2018 at 5:51 AM Robert Hoo <robert.hu@linux.intel.com> wrote:
> > >>
> > >> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> > >> ---
> > >>  arch/x86/include/asm/cpufeatures.h | 1 +
> > >>  arch/x86/kvm/cpuid.c               | 2 +-
> > >>  2 files changed, 2 insertions(+), 1 deletion(-)
> > >>
> > >> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> > >> index 28c4a50..932b19f 100644
> > >> --- a/arch/x86/include/asm/cpufeatures.h
> > >> +++ b/arch/x86/include/asm/cpufeatures.h
> > >> @@ -280,6 +280,7 @@
> > >>  /* AMD-defined CPU features, CPUID level 0x80000008 (EBX), word 13 */
> > >>  #define X86_FEATURE_CLZERO             (13*32+ 0) /* CLZERO instruction */
> > >>  #define X86_FEATURE_IRPERF             (13*32+ 1) /* Instructions Retired Count */
> > >> +#define X86_FEATURE_WBNOINVD           (13*32+ 9) /* Writeback and Don't invalid cache */
> > >>  #define X86_FEATURE_XSAVEERPTR         (13*32+ 2) /* Always save/restore FP error pointers */
> > >>  #define X86_FEATURE_AMD_IBPB           (13*32+12) /* "" Indirect Branch Prediction Barrier */
> > >>  #define X86_FEATURE_AMD_IBRS           (13*32+14) /* "" Indirect Branch Restricted Speculation */
> > >> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > >> index cc6dd65..763e115 100644
> > >> --- a/arch/x86/kvm/cpuid.c
> > >> +++ b/arch/x86/kvm/cpuid.c
> > >> @@ -380,7 +380,7 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
> > >>
> > >>         /* cpuid 0x80000008.ebx */
> > >>         const u32 kvm_cpuid_8000_0008_ebx_x86_features =
> > >> -               F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_SSBD) |
> > >> +               F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_SSBD) |
> > >>                 F(AMD_SSB_NO) | F(AMD_STIBP);
> > >>
> > >>         /* cpuid 0xC0000001.edx */
> > >> --
> > >> 1.8.3.1
> > >>
> 
> What is the point of enumerating support for WBNOINVD if kvm is going
> to implement it as WBINVD?

I expect GET_SUPPORTED_CPUID to return WBNOINVD, because it
indicates to userspace what is supported by KVM.  Are there any
expectations that GET_SUPPORTED_CPUID will also dictate what is
enabled by default in some cases?

In either case, your question applies to QEMU: why do we want
WBNOINVD to be enabled by "-cpu host" by default and be part of
QEMU's Icelake-* CPU model definitions?

-- 
Eduardo
