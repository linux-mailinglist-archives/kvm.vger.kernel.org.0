Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75924288CB4
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 17:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389344AbgJIPbD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Oct 2020 11:31:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:18325 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389338AbgJIPa5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Oct 2020 11:30:57 -0400
IronPort-SDR: l0xFZVnpm6KTvg5QgAcBsFnPICCjjzj7JBqHesiE+KomvUrZCFZwnldIM17DJl32yrI0pwhaXQ
 MBEgDcfZOmuA==
X-IronPort-AV: E=McAfee;i="6000,8403,9769"; a="162037706"
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="162037706"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 08:30:56 -0700
IronPort-SDR: JmvrfZj2ui+ugzIgHxksMvKTgMJfteFSAMvlceYoMtmFxdAwUVwKXsKCyyFdj0wX4brrG3er/d
 WOTo2X+tLqxg==
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="462228629"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 08:30:56 -0700
Date:   Fri, 9 Oct 2020 08:30:55 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     stsp <stsp2@yandex.ru>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] KVM: x86: KVM_SET_SREGS.CR4 bug fixes and cleanup
Message-ID: <20201009153053.GA16234@linux.intel.com>
References: <20201007014417.29276-1-sean.j.christopherson@intel.com>
 <99334de1-ba3d-dfac-0730-e637d39b948f@yandex.ru>
 <20201008175951.GA9267@linux.intel.com>
 <7efe1398-24c0-139f-29fa-3d89b6013f34@yandex.ru>
 <20201009040453.GA10744@linux.intel.com>
 <5dfa55f3-ecdf-9f8d-2d45-d2e6e54f2daa@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5dfa55f3-ecdf-9f8d-2d45-d2e6e54f2daa@yandex.ru>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 09, 2020 at 05:11:51PM +0300, stsp wrote:
> 09.10.2020 07:04, Sean Christopherson пишет:
> >>Hmm. But at least it was lying
> >>similarly on AMD and Intel CPUs. :)
> >>So I was able to reproduce the problems
> >>myself.
> >>Do you mean, any AMD tests are now useless, and we need to proceed with Intel
> >>tests only?
> >For anything VMXE related, yes.
> 
> What would be the expected behaviour on Intel, if it is set? Any difference
> with AMD?

On Intel, userspace should be able to stuff CR4.VMXE=1 via KVM_SET_SREGS if
the 'nested' module param is 1, e.g. if 'modprobe kvm_intel nested=1'.  Note,
'nested' is enabled by default on kernel 5.0 and later.

With AMD, setting CR4.VMXE=1 is never allowed as AMD doesn't support VMX,
AMD's virtualization solution is called SVM (Secure Virtual Machine).  KVM
doesn't support nesting VMX within SVM and vice versa.

> >>Then additional question.
> >>On old Intel CPUs we needed to set VMXE in guest to make it to work in
> >>nested-guest mode.
> >>Is it still needed even with your patches?
> >>Or the nested-guest mode will work now even on older Intel CPUs and KVM will
> >>set VMXE for us itself, when needed?
> >I'm struggling to even come up with a theory as to how setting VMXE from
> >userspace would have impacted KVM with unrestricted_guest=n, let alone fixed
> >anything.
> >
> >CR4.VMXE must always be 1 in _hardware_ when VMX is on, including when running
> >the guest.  But KVM forces vmcs.GUEST_CR4.VMXE=1 at all times, regardless of
> >the guest's actual value (the guest sees a shadow value when it reads CR4).
> >
> >And unless I grossly misunderstand dosemu2, it's not doing anything related to
> >nested virtualization, i.e. the stuffing VMXE=1 for the guest's shadow value
> >should have absolutely zero impact.
> >
> >More than likely, VMXE was a red herring.
> 
> Yes, it was. :( (as you can see from the end of the github thread)
> 
> 
> >   Given that the reporter is also
> >seeing the same bug on bare metal after moving to kernel 5.4, odds are good
> >the issue is related to unrestricted_guest=n and has nothing to do with nVMX.
> 
> But we do not use unrestricted guest.
> We use v86 under KVM.

Unrestricted guest can kick in even if CR0.PG=1 && CR0.PE=1, e.g. there are
segmentation checks that apply if and only if unrestricted_guest=0.  Long story
short, without a deep audit, it's basically impossible to rule out a dependency
on unrestricted guest since you're playing around with v86.
 
> The only other effect of setting VMXE was clearing VME. Which shouldn't
> affect anything either, right?

Hmm, clearing VME would mean that exceptions/interrupts within the guest would
trigger a switch out of v86 and into vanilla protected mode.  v86 and PM have
different consistency checks, particularly for segmentation, so it's plausible
that clearing CR4.VME inadvertantly worked around the bug by avoiding invalid
guest state for v86.
