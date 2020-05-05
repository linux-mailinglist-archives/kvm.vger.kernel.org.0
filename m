Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E190F1C4C7E
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 05:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728194AbgEEDHi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 23:07:38 -0400
Received: from mga05.intel.com ([192.55.52.43]:59066 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726286AbgEEDHh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 23:07:37 -0400
IronPort-SDR: lBwvHkb6E58fXMTWZA+wEINjQ5bzZV8qOIWrlLnBbL/JnRYV70W+CmK9qOWMrp32x8r6jw42Dq
 lYsf8h9FVk/w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2020 20:07:36 -0700
IronPort-SDR: SwhgkA8cwK89qvG3vWnOmOVOnFq6YT9L7YT83Qy8wMgzgXxlnIBVfG/BQSI0J13II96ttct2XF
 UgSBjsCQ/mZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,354,1583222400"; 
   d="scan'208";a="263014770"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga006.jf.intel.com with ESMTP; 04 May 2020 20:07:36 -0700
Date:   Mon, 4 May 2020 20:07:36 -0700
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
Message-ID: <20200505030736.GA20916@linux.intel.com>
References: <20200414063129.133630-5-xiaoyao.li@intel.com>
 <871rooodad.fsf@nanos.tec.linutronix.de>
 <20200415191802.GE30627@linux.intel.com>
 <87tv1kmol8.fsf@nanos.tec.linutronix.de>
 <20200415214318.GH30627@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200415214318.GH30627@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 15, 2020 at 02:43:18PM -0700, Sean Christopherson wrote:
> On Wed, Apr 15, 2020 at 11:22:11PM +0200, Thomas Gleixner wrote:
> > Sean Christopherson <sean.j.christopherson@intel.com> writes:
> > > I don't see any way to avoid having KVM differentiate between sld_warn and
> > > sld_fatal.  Even if KVM is able to virtualize SLD in sld_fatal mode, e.g.
> > > by telling the guest it must not try to disable SLD, KVM would still need
> > > to know the kernel is sld_fatal so that it can forward that information to
> > > the guest.
> > 
> > Huch? There is absolutely zero code like that. The only place where
> > sld_state is used is:
> > 
> > + static inline void vmx_update_sld(struct kvm_vcpu *vcpu, bool on)
> > + {
> > +	if (sld_state == sld_warn && guest_cpu_has_feature_sld(vcpu) &&
> > +	    on == test_thread_flag(TIF_SLD)) {
> > +		    sld_update_msr(on);
> > +		    update_thread_flag(TIF_SLD, !on);
> > +	}
> > 
> > You might have some faint memories from the previous trainwrecks :)
> 
> Yeah, I was thinking SLD was only being exposed if the host is sld_warn.
> I'll work with Xiaoyao to figure out a cleaner interface for this code.

...

> > So we can go with the proposed mode of allowing the write but not
> > propagating it. If the resulting split lock #AC originates from CPL != 3
> > then the guest will be killed with SIGBUS. If it originates from CPL ==
> > 3 and the guest has user #AC disabled then it will be killed as well.
> 
> An idea that's been floated around to avoid killing the guest on a CPL==3
> split-lock #AC is to add a STICKY bit to MSR_TEST_CTRL that KVM can
> virtualize to tell the guest that attempting to disable SLD is futile,
> e.g. so that the guest can kill its misbehaving userspace apps instead of
> trying to disable SLD and getting killed by the host.

Circling back to this.  KVM needs access to sld_state in one form or another
if we want to add a KVM hint when the host is in fatal mode.  Three options
I've come up with:

  1. Bite the bullet and export sld_state.  

  2. Add an is_split_fatal_wrapper().  Ugly since it needs to be non-inline
     to avoid triggering (1).

  3. Add a synthetic feature flag, e.g. X86_FEATURE_SLD_FATAL, and drop
     sld_state altogether.

I like (3) because it requires the least amount of code when all is said
and done, doesn't require more exports, and as a bonus it'd probably be nice
for userspace to see sld_fatal in /proc/cpuinfo.

Thoughts?
