Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55FB32880F9
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 06:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbgJIEE5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Oct 2020 00:04:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:31807 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725900AbgJIEE5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Oct 2020 00:04:57 -0400
IronPort-SDR: N6d1oaqBDdJR82SBxv4S6iv8wBwbLFbvGWZDl8l1TdSmCAzKH8+uFmu7iP/wBTRn2cX1RhpJVX
 rYKaqQNYWFWA==
X-IronPort-AV: E=McAfee;i="6000,8403,9768"; a="161978532"
X-IronPort-AV: E=Sophos;i="5.77,353,1596524400"; 
   d="scan'208";a="161978532"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2020 21:04:56 -0700
IronPort-SDR: oEHWgLjGrJmd0ZI6degJEsCEK+TtMZkw848BowrzsJucExZ1FWxdrzFdkKCPvkVTH7DD52LC0n
 mH8ZjVE/4rKg==
X-IronPort-AV: E=Sophos;i="5.77,353,1596524400"; 
   d="scan'208";a="462048992"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2020 21:04:55 -0700
Date:   Thu, 8 Oct 2020 21:04:54 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     stsp <stsp2@yandex.ru>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] KVM: x86: KVM_SET_SREGS.CR4 bug fixes and cleanup
Message-ID: <20201009040453.GA10744@linux.intel.com>
References: <20201007014417.29276-1-sean.j.christopherson@intel.com>
 <99334de1-ba3d-dfac-0730-e637d39b948f@yandex.ru>
 <20201008175951.GA9267@linux.intel.com>
 <7efe1398-24c0-139f-29fa-3d89b6013f34@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7efe1398-24c0-139f-29fa-3d89b6013f34@yandex.ru>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 08, 2020 at 09:18:18PM +0300, stsp wrote:
> 08.10.2020 20:59, Sean Christopherson пишет:
> >On Thu, Oct 08, 2020 at 07:00:13PM +0300, stsp wrote:
> >>07.10.2020 04:44, Sean Christopherson пишет:
> >>>Two bug fixes to handle KVM_SET_SREGS without a preceding KVM_SET_CPUID2.
> >>Hi Sean & KVM devs.
> >>
> >>I tested the patches, and wherever I
> >>set VMXE in CR4, I now get
> >>KVM: KVM_SET_SREGS: Invalid argument
> >>Before the patch I was able (with many
> >>problems, but still) to set VMXE sometimes.
> >>
> >>So its a NAK so far, waiting for an update. :)
> >IIRC, you said you were going to test on AMD?  Assuming that's correct,
> 
> Yes, that is true.
> 
> 
> >  -EINVAL
> >is the expected behavior.  KVM was essentially lying before; it never actually
> >set CR4.VMXE in hardware, it just didn't properply detect the error and so VMXE
> >was set in KVM's shadow of the guest's CR4.
> 
> Hmm. But at least it was lying
> similarly on AMD and Intel CPUs. :)
> So I was able to reproduce the problems
> myself.
> Do you mean, any AMD tests are now useless, and we need to proceed with Intel
> tests only?

For anything VMXE related, yes.

> Then additional question.
> On old Intel CPUs we needed to set VMXE in guest to make it to work in
> nested-guest mode.
> Is it still needed even with your patches?
> Or the nested-guest mode will work now even on older Intel CPUs and KVM will
> set VMXE for us itself, when needed?

I'm struggling to even come up with a theory as to how setting VMXE from
userspace would have impacted KVM with unrestricted_guest=n, let alone fixed
anything.

CR4.VMXE must always be 1 in _hardware_ when VMX is on, including when running
the guest.  But KVM forces vmcs.GUEST_CR4.VMXE=1 at all times, regardless of
the guest's actual value (the guest sees a shadow value when it reads CR4).

And unless I grossly misunderstand dosemu2, it's not doing anything related to
nested virtualization, i.e. the stuffing VMXE=1 for the guest's shadow value
should have absolutely zero impact.

More than likely, VMXE was a red herring.  Given that the reporter is also
seeing the same bug on bare metal after moving to kernel 5.4, odds are good
the issue is related to unrestricted_guest=n and has nothing to do with nVMX.
