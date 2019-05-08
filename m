Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6405817F2E
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 19:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729013AbfEHRgY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 13:36:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:23109 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728735AbfEHRgY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 13:36:24 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 10:36:23 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga001.fm.intel.com with ESMTP; 08 May 2019 10:36:23 -0700
Date:   Wed, 8 May 2019 10:36:23 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        David Hill <hilld@binarystorm.net>,
        Saar Amar <saaramar@microsoft.com>,
        Mihai Carabas <mihai.carabas@oracle.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: Re: [PATCH] Revert "KVM: nVMX: Expose RDPMC-exiting only when guest
 supports PMU"
Message-ID: <20190508173623.GC19656@linux.intel.com>
References: <20190508160819.19603-1-sean.j.christopherson@intel.com>
 <CALMp9eSrpi=Pagdt_3UhcWpDpHcVc6c2t0HAszZz105kN+ehsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eSrpi=Pagdt_3UhcWpDpHcVc6c2t0HAszZz105kN+ehsA@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 08, 2019 at 09:57:11AM -0700, Jim Mattson wrote:
> On Wed, May 8, 2019 at 9:08 AM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > The RDPMC-exiting control is dependent on the existence of the RDPMC
> > instruction itself, i.e. is not tied to the "Architectural Performance
> > Monitoring" feature.  For all intents and purposes, the control exists
> > on all CPUs with VMX support since RDPMC also exists on all VCPUs with
> > VMX supported.  Per Intel's SDM:
> >
> >   The RDPMC instruction was introduced into the IA-32 Architecture in
> >   the Pentium Pro processor and the Pentium processor with MMX technology.
> >   The earlier Pentium processors have performance-monitoring counters, but
> >   they must be read with the RDMSR instruction.
> >
> > Because RDPMC-exiting always exists, KVM requires the control and refuses
> > to load if it's not available.  As a result, hiding the PMU from a guest
> > breaks nested virtualization if the guest attemts to use KVM.
> 
> Is it true that the existence of instruction <X> implies the
> availaibility of the VM-execution control <X>-exiting (if such a
> VM-execution control exists)? What about WBINVD? That instruction has
> certainly been around forever, but there were VMX-capable processors
> that did not support WBINVD-exiting.

Technically no, but 99% of the time yes.  It's kind of similar to KVM's
live migration requirements: new features with "dangerous" instructions
need an associated VMCS control, but there are some legacy cases where
a VMCS control was added after the fact, WBINVD being the obvious example.

> Having said that, I think our hands are tied by the assumptions made
> by existing hypervisors, whether or not those assumptions are true.
> (VMware's VMM, for instance, requires MONITOR-exiting and
> MWAIT-exiting even when MONITOR/MWAIT are not enumerated by CPUID.)

I'd say it's more of a requirement than an assumption, e.g. KVM
*requires* RDPMC-exiting so that the guest can't glean info about the
host.  I guess technically KVM is assuming RDPMC itself exists, but
it's existence is effectively guaranteed by the SDM.

I can't speak to the VMWare behavior, e.g. it might be nothing more
than a simple oversight that isn't worth fixing, or maybe it's paranoid
and really wants to ensure the guest can't execute MONITOR/MWAIT :-)

> > While it's not explicitly stated in the RDPMC pseudocode, the VM-Exit
> > check for RDPMC-exiting follows standard fault vs. VM-Exit prioritization
> > for privileged instructions, e.g. occurs after the CPL/CR0.PE/CR4.PCE
> > checks, but before the counter referenced in ECX is checked for validity.
> >
> > In other words, the original KVM behavior of injecting a #GP was correct,
> > and the KVM unit test needs to be adjusted accordingly, e.g. eat the #GP
> > when the unit test guest (L3 in this case) executes RDPMC without
> > RDPMC-exiting set in the unit test host (L2).
> >
> > This reverts commit e51bfdb68725dc052d16241ace40ea3140f938aa.
> >
> > Fixes: e51bfdb68725 ("KVM: nVMX: Expose RDPMC-exiting only when guest supports PMU")
> > Reported-by: David Hill <hilld@binarystorm.net>
> > Cc: Saar Amar <saaramar@microsoft.com>
> > Cc: Mihai Carabas <mihai.carabas@oracle.com>
> > Cc: Jim Mattson <jmattson@google.com>
> > Cc: Liran Alon <liran.alon@oracle.com>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
