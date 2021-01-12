Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 423F72F2600
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 03:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730698AbhALCCO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 21:02:14 -0500
Received: from mga05.intel.com ([192.55.52.43]:52876 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbhALCCO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 21:02:14 -0500
IronPort-SDR: t9D6lpQ6nUHTfyFTm+VxEprXkonhwn/PMKuQyxXKTCoBSj58zcQpAyHIEWD1oe2npEmv8xxv56
 ekgQAHUVE3Mw==
X-IronPort-AV: E=McAfee;i="6000,8403,9861"; a="262750343"
X-IronPort-AV: E=Sophos;i="5.79,340,1602572400"; 
   d="scan'208";a="262750343"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2021 18:01:33 -0800
IronPort-SDR: JYEz5bZOwdfofiKQ/gV99rASb25mWVcDiaV+6VR6exIikmnNwHMyZzECcuaQY7rPAFJZwdVUPn
 YrnibN7Zhnwg==
X-IronPort-AV: E=Sophos;i="5.79,340,1602572400"; 
   d="scan'208";a="423992984"
Received: from tpotnis-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.76.146])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2021 18:01:30 -0800
Date:   Tue, 12 Jan 2021 15:01:28 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, jarkko@kernel.org,
        luto@kernel.org, haitao.huang@intel.com, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH 04/23] x86/cpufeatures: Add SGX1 and SGX2
 sub-features
Message-Id: <20210112150128.1e0d621e053bbbf210bcb946@intel.com>
In-Reply-To: <X/yk6zcJTLXJwIrJ@google.com>
References: <20210107120946.ef5bae4961d0be91eff56d6b@intel.com>
        <20210107064125.GB14697@zn.tnic>
        <20210108150018.7a8c2e2fb442c9c68b0aa624@intel.com>
        <a0f75623-b0ce-bf19-4678-0f3e94a3a828@intel.com>
        <20210108200350.7ba93b8cd19978fe27da74af@intel.com>
        <20210108071722.GA4042@zn.tnic>
        <X/jxCOLG+HUO4QlZ@google.com>
        <20210109011939.GL4042@zn.tnic>
        <X/yQyUx4+veuSO0e@google.com>
        <20210111190901.GG25645@zn.tnic>
        <X/yk6zcJTLXJwIrJ@google.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 11 Jan 2021 11:20:11 -0800 Sean Christopherson wrote:
> On Mon, Jan 11, 2021, Borislav Petkov wrote:
> > On Mon, Jan 11, 2021 at 09:54:17AM -0800, Sean Christopherson wrote:
> > > It would be possible for KVM to break the dependency on X86_FEATURE_* bit
> > > offsets by defining a translation layer, but I strongly feel that adding manual
> > > translations will do more harm than good as it increases the odds of us botching
> > > a translation or using the wrong feature flag, creates potential namespace
> > > conflicts, etc...
> > 
> > Ok, lemme see if we might encounter more issues down the road...
> > 
> > +enum kvm_only_cpuid_leafs {
> > +       CPUID_12_EAX     = NCAPINTS,
> > +       NR_KVM_CPU_CAPS,
> > +
> > +       NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
> > +};
> > +
> > 
> > What happens when we decide to allocate a separate leaf for CPUID_12_EAX
> > down the road?
> 
> Well, mechanically, that would generate a build failure if the kernel does the
> obvious things and names the 'enum cpuid_leafs' entry CPUID_12_EAX.  That would
> be an obvious clue that KVM should be updated.
> 
> If the kernel named the enum entry something different, and we botched the code
> review, KVM would continue to work, but would unnecessarily copy the bits it
> cares about to its own word.   E.g. the boot_cpu_has() checks and translation to
> __X86_FEATURE_* would still be valid.  As far as failure modes go, that's not
> terrible.

Should we add a dedicated, i.e. kvm_scattered_cpu_caps[], instead of using
existing kvm_cpu_cap[NCAPINTS]? If so this issue can be avoided??

> 
> > You do it already here
> > 
> > Subject: [PATCH 04/13] x86/cpufeatures: Assign dedicated feature word for AMD mem encryption
> > 
> > for the AMD leaf.
> > 
> > I'm thinking this way around - from scattered to a hw one - should be ok
> > because that should work easily. The other way around, taking a hw leaf
> > and scattering it around x86_capability[] array elems would probably be
> > nasty but with your change that should work too.
> > 
> > Yah, I'm just hypothesizing here - I don't think this "other way around"
> > will ever happen...
> > 
> > Hmm, yap, I can cautiously say that with your change we should be ok...
> > 
> > Thx.
> > 
> > -- 
> > Regards/Gruss,
> >     Boris.
> > 
> > https://people.kernel.org/tglx/notes-about-netiquette
