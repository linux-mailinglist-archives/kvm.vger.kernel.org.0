Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71940288DD3
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 18:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389599AbgJIQLh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Oct 2020 12:11:37 -0400
Received: from mga06.intel.com ([134.134.136.31]:47375 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388882AbgJIQLh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Oct 2020 12:11:37 -0400
IronPort-SDR: l0oa+VIBgcLrPR+HnGTLBGs5PX7DUycs+0I03Ov6gGfOEe7lflZFtRbzmho8m24CQbebutI9gD
 zR3IlICCmFFw==
X-IronPort-AV: E=McAfee;i="6000,8403,9769"; a="227152850"
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="227152850"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 09:11:35 -0700
IronPort-SDR: bsFMhdrIf0qWvQzdN1jIBDkd7A6O35ARwW4FggGWDxvCPRz/BVKn1BTZI0VH0Okpcg5gOx4lON
 PEZ0k4N+fxbw==
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="528984520"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 09:11:35 -0700
Date:   Fri, 9 Oct 2020 09:11:34 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     stsp <stsp2@yandex.ru>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] KVM: x86: KVM_SET_SREGS.CR4 bug fixes and cleanup
Message-ID: <20201009161134.GB16234@linux.intel.com>
References: <20201007014417.29276-1-sean.j.christopherson@intel.com>
 <99334de1-ba3d-dfac-0730-e637d39b948f@yandex.ru>
 <20201008175951.GA9267@linux.intel.com>
 <7efe1398-24c0-139f-29fa-3d89b6013f34@yandex.ru>
 <20201009040453.GA10744@linux.intel.com>
 <5dfa55f3-ecdf-9f8d-2d45-d2e6e54f2daa@yandex.ru>
 <20201009153053.GA16234@linux.intel.com>
 <5bf99bdf-b16f-8caf-ba61-860457606b8e@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5bf99bdf-b16f-8caf-ba61-860457606b8e@yandex.ru>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 09, 2020 at 06:48:21PM +0300, stsp wrote:
> 09.10.2020 18:30, Sean Christopherson пишет:
> >On Fri, Oct 09, 2020 at 05:11:51PM +0300, stsp wrote:
> >>09.10.2020 07:04, Sean Christopherson пишет:
> >>>>Hmm. But at least it was lying
> >>>>similarly on AMD and Intel CPUs. :)
> >>>>So I was able to reproduce the problems
> >>>>myself.
> >>>>Do you mean, any AMD tests are now useless, and we need to proceed with Intel
> >>>>tests only?
> >>>For anything VMXE related, yes.
> >>What would be the expected behaviour on Intel, if it is set? Any difference
> >>with AMD?
> >On Intel, userspace should be able to stuff CR4.VMXE=1 via KVM_SET_SREGS if
> >the 'nested' module param is 1, e.g. if 'modprobe kvm_intel nested=1'.  Note,
> >'nested' is enabled by default on kernel 5.0 and later.
> 
> So if I understand you correctly, we
> need to test that:
> - with nested=0 VMXE gives EINVAL
> - with nested=1 VMXE changes nothing
> visible, except probably to allow guest
> to read that value (we won't test guest
> reading though).
> 
> Is this correct?

Yep, exactly!
 
> >With AMD, setting CR4.VMXE=1 is never allowed as AMD doesn't support VMX,
> 
> OK, for that I can give you a
> Tested-by: Stas Sergeev <stsp@users.sourceforge.net>
> 
> because I confirm that on AMD it now consistently returns EINVAL, whereas
> without your patches it did random crap, depending on whether it is a first
> call to KVM_SET_SREGS, or not first.
> 
> 
> >>But we do not use unrestricted guest.
> >>We use v86 under KVM.
> >Unrestricted guest can kick in even if CR0.PG=1 && CR0.PE=1, e.g. there are
> >segmentation checks that apply if and only if unrestricted_guest=0.  Long story
> >short, without a deep audit, it's basically impossible to rule out a dependency
> >on unrestricted guest since you're playing around with v86.
> 
> You mean "unrestricted_guest" as a module parameter, rather than the similar
> named CPU feature, right? So we may depend on unrestricted_guest parameter,
> but not on a hardware feature, correct?

The unrestricted_guest module param is tied directly to the hardware feature,
i.e. if kvm_intel.unrestricted_guest=0 then KVM will run guests with
unrestricted guest disabled.  That doesn't necessarily mean any of the
behavior that is allowed by unrestricted guest will be encountered, but if
it is encountered, then it will be handled by the CPU instead of causing a
VM-Exit and requiring KVM emulation.

The reported is using an old CPU that doesn't support unrestricted guest,
so both the hardware feature and the module param will be off/0.

> >>The only other effect of setting VMXE was clearing VME. Which shouldn't
> >>affect anything either, right?
> >Hmm, clearing VME would mean that exceptions/interrupts within the guest would
> >trigger a switch out of v86 and into vanilla protected mode.  v86 and PM have
> >different consistency checks, particularly for segmentation, so it's plausible
> >that clearing CR4.VME inadvertantly worked around the bug by avoiding invalid
> >guest state for v86.
> 
> Lets assume that was the case.  With those github guys its not possible to do
> any consistent checks. :(

K.  If this is ever a problem in the future, having a way relatively simple
reproducer, e.g. something we can run without having to build/install a
variety of tools, would make it easier to debug.  In theory, the bug should be
reproducible even on modern hardware by loading KVM with unrestricted_guest=0.
