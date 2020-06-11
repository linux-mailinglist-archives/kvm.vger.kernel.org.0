Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5007B1F6CA7
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 19:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgFKRNJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 13:13:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:32446 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726706AbgFKRNG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jun 2020 13:13:06 -0400
IronPort-SDR: fFV/p75+fKUzqj6GVauaKbinxcL4Ye3v980/NCgSgdk0ZUa4h6CRp3bN3hbpZ+KA2svvPT3W9Q
 I8WppaaDsh0A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2020 10:13:06 -0700
IronPort-SDR: UZoHgxH1K0kmvbsR3quVSUfb5dJ2vORoRNzZEJplCkiftUSWTB6T7ceZFD8nPxuEoI/m555enE
 L9gf56ueCkOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,500,1583222400"; 
   d="scan'208";a="380448734"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga001.fm.intel.com with ESMTP; 11 Jun 2020 10:13:05 -0700
Date:   Thu, 11 Jun 2020 10:13:05 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Joerg Roedel <jroedel@suse.de>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v3 59/75] x86/sev-es: Handle MONITOR/MONITORX Events
Message-ID: <20200611171305.GJ29918@linux.intel.com>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-60-joro@8bytes.org>
 <20200520063845.GC17090@linux.intel.com>
 <20200611131045.GE11924@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200611131045.GE11924@8bytes.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 11, 2020 at 03:10:45PM +0200, Joerg Roedel wrote:
> On Tue, May 19, 2020 at 11:38:45PM -0700, Sean Christopherson wrote:
> > On Tue, Apr 28, 2020 at 05:17:09PM +0200, Joerg Roedel wrote:
> > > +static enum es_result vc_handle_monitor(struct ghcb *ghcb,
> > > +					struct es_em_ctxt *ctxt)
> > > +{
> > > +	phys_addr_t monitor_pa;
> > > +	pgd_t *pgd;
> > > +
> > > +	pgd = __va(read_cr3_pa());
> > > +	monitor_pa = vc_slow_virt_to_phys(ghcb, ctxt->regs->ax);
> > > +
> > > +	ghcb_set_rax(ghcb, monitor_pa);
> > > +	ghcb_set_rcx(ghcb, ctxt->regs->cx);
> > > +	ghcb_set_rdx(ghcb, ctxt->regs->dx);
> > > +
> > > +	return sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_MONITOR, 0, 0);
> > 
> > Why?  If SVM has the same behavior as VMX, the MONITOR will be disarmed on
> > VM-Enter, i.e. the VMM can't do anything useful for MONITOR/MWAIT.  I
> > assume that's the case given that KVM emulates MONITOR/MWAIT as NOPs on
> > SVM.
> 
> Not sure if it is disarmed on VMRUN, but the MONITOR/MWAIT instructions
> are part of the GHCB spec, so they are implemented here.

Even if MONITOR/MWAIT somehow works across VMRUN I'm not sure it's something
the guest should enable by default as it leaks GPAs to the untrusted host,
with no benefit to the guest except in specific configurations.  Yeah, the
VMM can muck with page tables to trace guest to the some extent, but the
guest shouldn't be unnecessarily volunteering information to the host.

If MONITOR/MWAIT is effectively a NOP then removing this code is a no
brainer.

Can someone from AMD chime in?
