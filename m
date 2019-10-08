Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32055CF548
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2019 10:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730036AbfJHIsw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 04:48:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:11201 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729949AbfJHIsw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Oct 2019 04:48:52 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Oct 2019 01:48:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,270,1566889200"; 
   d="scan'208";a="223175721"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by fmsmga002.fm.intel.com with ESMTP; 08 Oct 2019 01:48:50 -0700
Date:   Tue, 8 Oct 2019 16:50:49 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH v7 0/7] Introduce support for Guest CET feature
Message-ID: <20191008085049.GA21631@local-michael-cet-test>
References: <20190927021927.23057-1-weijiang.yang@intel.com>
 <CALMp9eQ13Lve+9+61qCF1-7mQkeLLnhDufd-geKtz=34+YJdEg@mail.gmail.com>
 <20191003130145.GA25798@local-michael-cet-test.sh.intel.com>
 <CALMp9eQUiLNmF6oF5uEuT-VhRnzp3S9rsnAE0jpK+=38LQBHQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eQUiLNmF6oF5uEuT-VhRnzp3S9rsnAE0jpK+=38LQBHQA@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 03, 2019 at 09:33:45AM -0700, Jim Mattson wrote:
> On Thu, Oct 3, 2019 at 5:59 AM Yang Weijiang <weijiang.yang@intel.com> wrote:
> >
> > On Wed, Oct 02, 2019 at 03:40:20PM -0700, Jim Mattson wrote:
> > > On Thu, Sep 26, 2019 at 7:17 PM Yang Weijiang <weijiang.yang@intel.com> wrote:
> > > >
> > > > Control-flow Enforcement Technology (CET) provides protection against
> > > > Return/Jump-Oriented Programming (ROP/JOP) attack. It includes two
> > > > sub-features: Shadow Stack (SHSTK) and Indirect Branch Tracking (IBT).
> > > >
> > > > KVM modification is required to support Guest CET feature.
> > > > This patch serial implemented CET related CPUID/XSAVES enumeration, MSRs
> > > > and VMEntry configuration etc.so that Guest kernel can setup CET
> > > > runtime infrastructure based on them. Some MSRs and related feature
> > > > flags used in the patches reference the definitions in kernel patch.
> > >
> > > I am still trying to make my way through the 358 page (!) spec for
> > > this feature, but I already have some questions/comments about this
> > > series:
> > >
> > > 1. Does CET "just work" with shadow paging? Shadow paging knows
> > > nothing about "shadow-stack pages," and it's not clear to me how
> > > shadow-stack pages will interact with dirty tracking.
> > > 2. I see non-trivial changes to task switch under CET. Does
> > > emulator_do_task_switch need to be updated?
> > > 3. What about all of the emulator routines that emulate control
> > > transfers (e.g. em_jmp_{far,abs}, em_call_(near_abs,far},
> > > em_ret_{far,far_imm,near_imm}, etc)? Don't these have to be modified
> > > to work correctly when CR4.CET is set?
> > > 4. You don't use the new "enable supervisor shadow stack control" bit
> > > in the EPTP. I assume that this is entirely optional, right?
> > > 5. I think the easiest way to handle the nested issue (rather than
> > > your explicit check for vmxon when setting CR4.CET when the vCPU is in
> > > VMX operation) is just to leave CR4.CET out of IA32_VMX_CR4_FIXED1
> > > (which is already the case).
> > > 6. The function, exception_class(), in x86.c, should be updated to
> > > categorize #CP as contributory.
> > > 7. The function, x86_exception_has_error_code(), in x86.h, should be
> > > updated to include #CP.
> > > 8. There appear to be multiple changes to SMM that you haven't
> > > implemented (e.g saving/restoring the SSP registers in/from SMRAM.
> > >
> > > CET is quite complex. Without any tests, I don't see how you can have
> > > any confidence in the correctness of this patch series.
> > Thanks Jim for the detailed comments.
> >
> > I missed adding test platform and
> > result introduction in cover letter. This serial of patch has passed CET
> > test in guest on Intel x86 emulator platform and develop machine.
> > Some feature mentioned in the spec. has not been implemented yet. e.g.,
> > "supervisor shadow stack control".
> 
> What I should have said is that I'd like to see kvm-unit-tests to
> exercise the new functionality, even if no one outside Intel can run
> them yet.
>
OK, let me figure out how to test it either in unit-test or selftest.
Thank you!
> > CET feature itself is complex, most of the enabling work is
> > inside kernel, the role of KVM is to expose CET related CPUID and MSRs
> > etc. to guest, and make guest take over control of the MSRs directly so that
> > CET can work efficiently for guest. There're QEMU patches for CET too.
> >
> > I'll review your comments carefully, thank you again!
