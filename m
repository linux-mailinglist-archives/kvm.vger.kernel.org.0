Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2248B1EE3B5
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 13:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728024AbgFDLyQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 07:54:16 -0400
Received: from 8bytes.org ([81.169.241.247]:46274 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbgFDLyP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 07:54:15 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 744CC26F; Thu,  4 Jun 2020 13:54:14 +0200 (CEST)
Date:   Thu, 4 Jun 2020 13:54:13 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Borislav Petkov <bp@alien8.de>
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
Subject: Re: [PATCH v3 40/75] x86/sev-es: Compile early handler code into
 kernel image
Message-ID: <20200604115413.GB30945@8bytes.org>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-41-joro@8bytes.org>
 <20200520091415.GC1457@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520091415.GC1457@zn.tnic>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 20, 2020 at 11:14:15AM +0200, Borislav Petkov wrote:
> On Tue, Apr 28, 2020 at 05:16:50PM +0200, Joerg Roedel wrote:
> > +static inline u64 sev_es_rd_ghcb_msr(void)
> > +{
> > +	return native_read_msr(MSR_AMD64_SEV_ES_GHCB);
> > +}
> > +
> > +static inline void sev_es_wr_ghcb_msr(u64 val)
> > +{
> > +	u32 low, high;
> > +
> > +	low  = (u32)(val);
> > +	high = (u32)(val >> 32);
> > +
> > +	native_write_msr(MSR_AMD64_SEV_ES_GHCB, low, high);
> > +}
> 
> Instead of duplicating those two, you can lift the ones in the
> compressed image into sev-es.h and use them here. I don't care one bit
> about the MSR tracepoints in native_*_msr().

It is not only the trace-point, this would also eliminate exception
handling in case the MSR access triggers a #GP. The "Unhandled MSR
read/write" messages would turn into a "General Protection Fault"
message.


	Joerg
