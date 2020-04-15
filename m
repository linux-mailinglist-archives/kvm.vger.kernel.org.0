Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A33AF1AB374
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 23:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729076AbgDOVnY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 17:43:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:9571 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727857AbgDOVnV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 17:43:21 -0400
IronPort-SDR: I4LH1FEHBptE5b8N46LWHcWLxgUiTllkEr0LvlG9gZe8Qt3dD+01ROkf7Y7sVvZJwxanWjbKIP
 StzjQCBw6d0Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2020 14:43:19 -0700
IronPort-SDR: kx6QiFpOyjGzocJB/ShKm3geMyUxKR01fZFLb3v5KAWCylDDv9K6QNIEbeliIV3Zt+gFwsYllu
 K8jnOVZWs72A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,388,1580803200"; 
   d="scan'208";a="245797253"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga008.fm.intel.com with ESMTP; 15 Apr 2020 14:43:18 -0700
Date:   Wed, 15 Apr 2020 14:43:18 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>
Subject: Re: [PATCH v8 4/4] kvm: vmx: virtualize split lock detection
Message-ID: <20200415214318.GH30627@linux.intel.com>
References: <20200414063129.133630-5-xiaoyao.li@intel.com>
 <871rooodad.fsf@nanos.tec.linutronix.de>
 <20200415191802.GE30627@linux.intel.com>
 <87tv1kmol8.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tv1kmol8.fsf@nanos.tec.linutronix.de>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 15, 2020 at 11:22:11PM +0200, Thomas Gleixner wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> > I don't see any way to avoid having KVM differentiate between sld_warn and
> > sld_fatal.  Even if KVM is able to virtualize SLD in sld_fatal mode, e.g.
> > by telling the guest it must not try to disable SLD, KVM would still need
> > to know the kernel is sld_fatal so that it can forward that information to
> > the guest.
> 
> Huch? There is absolutely zero code like that. The only place where
> sld_state is used is:
> 
> + static inline void vmx_update_sld(struct kvm_vcpu *vcpu, bool on)
> + {
> +	if (sld_state == sld_warn && guest_cpu_has_feature_sld(vcpu) &&
> +	    on == test_thread_flag(TIF_SLD)) {
> +		    sld_update_msr(on);
> +		    update_thread_flag(TIF_SLD, !on);
> +	}
> 
> You might have some faint memories from the previous trainwrecks :)

Yeah, I was thinking SLD was only being exposed if the host is sld_warn.
I'll work with Xiaoyao to figure out a cleaner interface for this code.

> The fatal mode emulation which is used in this patch set is simply that
> the guest can 'write' to the MSR but it's not propagated to the real
> MSR. It's just stored in the guest state. There is no way that you can
> tell the guest that the MSR is there but fake.
>
> The alternative solution is to prevent the exposure of SLD to the guest
> in fatal mode. But that does not buy anything.
> 
> The detection is anyway incomplete. If the SLD #AC is raised in guest's
> user mode and the guest has user #AC enabled then the exception is
> injected into the guest unconditionally and independent of the host's
> and guest's SLD state. That's entirely correct because a SLD #AC in user
> mode is also a user mode alignment violation; it's not distinguishable.
> 
> You could of course analyse the offending instruction and check for a
> lock prefix and a cache line overlap, but that still does not prevent
> false positives. When the guest is non-malicious and has proper user #AC
> handling in place then it would be wrong or at least very surprising to
> kill it just because the detection code decided that it is a dangerous
> split lock attempt.
> 
> So we can go with the proposed mode of allowing the write but not
> propagating it. If the resulting split lock #AC originates from CPL != 3
> then the guest will be killed with SIGBUS. If it originates from CPL ==
> 3 and the guest has user #AC disabled then it will be killed as well.

An idea that's been floated around to avoid killing the guest on a CPL==3
split-lock #AC is to add a STICKY bit to MSR_TEST_CTRL that KVM can
virtualize to tell the guest that attempting to disable SLD is futile,
e.g. so that the guest can kill its misbehaving userspace apps instead of
trying to disable SLD and getting killed by the host.

I've discussed it with a few folks internally and it sounds like getting
such a bit added to the SDM would be doable, even if Intel never ships
hardware that supports the bit.  The thought is that getting the STICKY
bit architecturally defined would give KVM/Linux leverage to persuade guest
kernels to add support for the bit.  But anything that touches the SDM
doesn't exactly happen quickly :-/.
