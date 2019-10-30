Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 756D4E9E00
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2019 15:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfJ3OzW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Oct 2019 10:55:22 -0400
Received: from mga04.intel.com ([192.55.52.120]:52070 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726175AbfJ3OzW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Oct 2019 10:55:22 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Oct 2019 07:55:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,247,1569308400"; 
   d="scan'208";a="198698715"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 30 Oct 2019 07:55:20 -0700
Date:   Wed, 30 Oct 2019 07:55:20 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc:     "keescook@chromium.org" <keescook@chromium.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Dock, Deneen T" <deneen.t.dock@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kristen@linux.intel.com" <kristen@linux.intel.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Hansen, Dave" <dave.hansen@intel.com>
Subject: Re: [RFC PATCH 09/13] x86/cpufeature: Add detection of KVM XO
Message-ID: <20191030145520.GA14391@linux.intel.com>
References: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
 <20191003212400.31130-10-rick.p.edgecombe@intel.com>
 <201910291633.927254B10@keescook>
 <40cb4ea3b351c25074cf47ae92a189eec12161fb.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40cb4ea3b351c25074cf47ae92a189eec12161fb.camel@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 29, 2019 at 04:52:08PM -0700, Edgecombe, Rick P wrote:
> On Tue, 2019-10-29 at 16:33 -0700, Kees Cook wrote:
> > On Thu, Oct 03, 2019 at 02:23:56PM -0700, Rick Edgecombe wrote:
> > > Add a new CPUID leaf to hold the contents of CPUID 0x40000030 EAX to
> > > detect KVM defined generic VMM features.
> > >
> > > The leaf was proposed to allow KVM to communicate features that are
> > > defined by KVM, but available for any VMM to implement.

This doesn't necessarily work the way you intend, KVM's base CPUID isn't
guaranteed to be 0x40000000.  E.g. KVM supports advertising itself as
HyperV *and* KVM, in which case KVM's CPUID base will be 0x40000100.

I think you're better off just making this a standard KVM CPUID feature.
If a different hypervisor wants to reuse guest support as is, it can
advertise KVM support at a lower priority.

Note, querying guest CPUID isn't straightforward in either case.  But,
KVM doesn't support disabling its other CPUID-base paravirt features, e.g.
KVM emulates the kvm_clock MSRs regardless of what userspace advertises to
the guest.  Depending on what changes are required in KVM's MMU, this may
also need to be a KVM-wide feature, i.e. controlled via a module param.

> > > Add cpu_feature_enabled() support for features in this leaf (KVM XO), and
> > > a pgtable_kvmxo_enabled() helper similar to pgtable_l5_enabled() so that
> > > pgtable_kvmxo_enabled() can be used in early code that includes
> > > arch/x86/include/asm/sparsemem.h.
> > >
> > > Lastly, in head64.c detect and this feature and perform necessary
> > > adjustments to physical_mask.
> >
> > Can this be exposed to /proc/cpuinfo so a guest userspace can determine
> > if this feature is enabled?
> >
> > -Kees
>
> Is there a good place to expose the information that the PROT_EXEC and
> !PROT_READ combo creates execute-only memory? This way apps can check one place
> for the support and not worry about the implementation whether it's this, x86
> pkeys, arm or other.

I don't think so?  Assuming there's no common method, it can be displayed
in /proc/cpuinfo by adding a synthetic bit, e.g. in Linux-defined word 8
(virtualization) instead of a dedicated word.  The bit can then be
set if the features exists and is enabled (by the guest).

I'd also name the feature EXEC_ONLY.  XO is unnecessarily terse IMO, and
including "KVM" in the name may be misconstrued as a host KVM feature and
will be flat out wrong if hardware ever supports XO natively.
