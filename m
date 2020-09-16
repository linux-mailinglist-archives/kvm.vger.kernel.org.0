Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01FF526CA90
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 22:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbgIPUIO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 16:08:14 -0400
Received: from mga07.intel.com ([134.134.136.100]:43751 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727037AbgIPReW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Sep 2020 13:34:22 -0400
IronPort-SDR: wJvEjC+BjzhFI8uWUyngRvUsZ/dLjEp244qng/Ngxn0O1Jz89Cquei7UC5Wey+wFm8PSus9LHB
 BP0P0p9mr/5Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9746"; a="223711134"
X-IronPort-AV: E=Sophos;i="5.76,433,1592895600"; 
   d="scan'208";a="223711134"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2020 10:34:17 -0700
IronPort-SDR: Q+U/SATVDiLIBJs3zIb4Ef+MRh0rDH2zZzmKDKEebVhRIscqceOFOXY4n1YErS49/cyV/tFoPO
 dCMhoJ6y1G3w==
X-IronPort-AV: E=Sophos;i="5.76,433,1592895600"; 
   d="scan'208";a="451946401"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2020 10:34:17 -0700
Date:   Wed, 16 Sep 2020 10:34:16 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH] KVM: x86: Add kvm_x86_ops hook to short circuit emulation
Message-ID: <20200916173416.GF10227@sjchrist-ice>
References: <20200915232702.15945-1-sean.j.christopherson@intel.com>
 <CANRm+Cx85NBnL76VoFV+DNrShp_2o+c4dgQCwNARzrAcmX1KAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANRm+Cx85NBnL76VoFV+DNrShp_2o+c4dgQCwNARzrAcmX1KAw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 16, 2020 at 09:31:22AM +0800, Wanpeng Li wrote:
> On Wed, 16 Sep 2020 at 07:29, Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > Replace the existing kvm_x86_ops.need_emulation_on_page_fault() with a
> > more generic is_emulatable(), and unconditionally call the new function
> > in x86_emulate_instruction().
> >
> > KVM will use the generic hook to support multiple security related
> > technologies that prevent emulation in one way or another.  Similar to
> > the existing AMD #NPF case where emulation of the current instruction is
> > not possible due to lack of information, AMD's SEV-ES and Intel's SGX
> > and TDX will introduce scenarios where emulation is impossible due to
> > the guest's register state being inaccessible.  And again similar to the
> > existing #NPF case, emulation can be initiated by kvm_mmu_page_fault(),
> > i.e. outside of the control of vendor-specific code.
> >
> > While the cause and architecturally visible behavior of the various
> > cases are different, e.g. SGX will inject a #UD, AMD #NPF is a clean
> > resume or complete shutdown, and SEV-ES and TDX "return" an error, the
> > impact on the common emulation code is identical: KVM must stop
> > emulation immediately and resume the guest.
> >
> > Query is_emulatable() in handle_ud() as well so that the
> > force_emulation_prefix code doesn't incorrectly modify RIP before
> > calling emulate_instruction() in the absurdly unlikely scenario that
> > KVM encounters forced emulation in conjunction with "do not emulate".

...

> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 539ea1cd6020..5208217049d9 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -5707,6 +5707,9 @@ int handle_ud(struct kvm_vcpu *vcpu)
> >         char sig[5]; /* ud2; .ascii "kvm" */
> >         struct x86_exception e;
> >
> > +       if (unlikely(!kvm_x86_ops.is_emulatable(vcpu, NULL, 0)))
> > +               return 1;
> > +
> 
> Both VMX and SVM scenarios always fail this check.

Ah, right.  This patch was extracted from my SGX series, in which case there
would be a follow-up patch to add a VMX scenario where is_emulated() could
return false.

The intent of posting the patch standalone is so that SGX, SEV-ES, and/or TDX
have "ready to go" support in upstream, i.e. can change only the VMX/SVM
implementation of is_emulated().  I'm a-ok dropping the handle_ud() change,
or even the whole patch, until one of the above three is actually ready for
inclusion.
