Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 447CE14F31A
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 21:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbgAaUSY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jan 2020 15:18:24 -0500
Received: from mga17.intel.com ([192.55.52.151]:24198 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726086AbgAaUSY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jan 2020 15:18:24 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Jan 2020 12:18:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,387,1574150400"; 
   d="scan'208";a="233556708"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 31 Jan 2020 12:18:23 -0800
Date:   Fri, 31 Jan 2020 12:17:43 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: VMX: Extend VMX's #AC handding
Message-ID: <20200131201743.GE18946@linux.intel.com>
References: <3499ee3f-e734-50fd-1b50-f6923d1f4f76@intel.com>
 <5D1CAD6E-7D40-48C6-8D21-203BDC3D0B63@amacapital.net>
 <df8f7580-9e7d-bc49-30c0-eca517f8db44@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <df8f7580-9e7d-bc49-30c0-eca517f8db44@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Feb 01, 2020 at 01:47:10AM +0800, Xiaoyao Li wrote:
> On 1/31/2020 11:37 PM, Andy Lutomirski wrote:
> >
> >>On Jan 30, 2020, at 11:22 PM, Xiaoyao Li <xiaoyao.li@intel.com> wrote:
> >>
> >> On 1/31/2020 1:16 AM, Andy Lutomirski wrote:

...

> >>>Can we get a credible description of how this would work? I suggest: Intel
> >>>adds and documents a new CPUID bit or core capability bit that means
> >>>“split lock detection is forced on”.  If this bit is set, the MSR bit
> >>>controlling split lock detection is still writable, but split lock
> >>>detection is on regardless of the value.  Operating systems are expected
> >>>to set the bit to 1 to indicate to a hypervisor, if present, that they
> >>>understand that split lock detection is on.  This would be an SDM-only
> >>>change, but it would also be a commitment to certain behavior for future
> >>>CPUs that don’t implement split locks.
> >>
> >>It sounds a PV solution for virtualization that it doesn't need to be
> >>defined in Intel-SDM but in KVM document.
> >>
> >>As you suggested, we can define new bit in KVM_CPUID_FEATURES (0x40000001)
> >>as KVM_FEATURE_SLD_FORCED and reuse MSR_TEST_CTL or use a new virtualized
> >>MSR for guest to tell hypervisor it understand split lock detection is
> >>forced on.
> >
> >Of course KVM can do this. But this missed the point. Intel added a new CPU
> >feature, complete with an enumeration mechanism, that cannot be correctly
> >used if a hypervisor is present.
> 
> Why it cannot be correctly used if a hypervisor is present? Because it needs
> to disable split lock detection when running a vcpu for guest as this patch
> wants to do?

Because SMT.  Unless vCPUs are pinned 1:1 with pCPUs, and the guest is
given an accurate topology, disabling/enabling split-lock #AC may (or may
not) also disable/enable split-lock #AC on a random vCPU in the guest.

> >As it stands, without specific hypervisor and guest support of a non-Intel
> >interface, it is *impossible* to give architecturally correct behavior to a
> >guest. If KVM implements your suggestion, *Windows* guests will still
> >malfunction on Linux.
> 
> Actually, KVM don't need to implement my suggestion. It can just virtualize
> and expose this feature (MSR_IA32_CORE_CAPABILITIES and MSR_TEST_CTRL) to
> guest, (but it may have some requirement that HT is disabled and host is
> sld_off) then guest can use it architecturally.

This is essentially what I proposed a while back.  KVM would allow enabling
split-lock #AC in the guest if and only if SMT is disabled or the enable bit
is per-thread, *or* the host is in "warn" mode (can live with split-lock #AC
being randomly disabled/enabled) and userspace has communicated to KVM that
it is pinning vCPUs.
