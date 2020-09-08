Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2436261B13
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 20:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728264AbgIHSnb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 14:43:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:45334 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731306AbgIHSmj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Sep 2020 14:42:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E4510AD39;
        Tue,  8 Sep 2020 18:42:38 +0000 (UTC)
Date:   Tue, 8 Sep 2020 20:42:34 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Joerg Roedel <joro@8bytes.org>, x86@kernel.org, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
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
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v7 67/72] x86/smpboot: Load TSS and getcpu GDT entry
 before loading IDT
Message-ID: <20200908184234.GE23826@suse.de>
References: <20200907131613.12703-1-joro@8bytes.org>
 <20200907131613.12703-68-joro@8bytes.org>
 <20200908172042.GF25236@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200908172042.GF25236@zn.tnic>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 08, 2020 at 07:20:42PM +0200, Borislav Petkov wrote:
> On Mon, Sep 07, 2020 at 03:16:08PM +0200, Joerg Roedel wrote:
> > +void cpu_init_exception_handling(void)
> > +{
> > +	struct tss_struct *tss = this_cpu_ptr(&cpu_tss_rw);
> > +	int cpu = raw_smp_processor_id();
> > +
> > +	/* paranoid_entry() gets the CPU number from the GDT */
> > +	setup_getcpu(cpu);
> > +
> > +	/* IST vectors need TSS to be set up. */
> > +	tss_setup_ist(tss);
> > +	tss_setup_io_bitmap(tss);
> > +	set_tss_desc(cpu, &get_cpu_entry_area(cpu)->tss.x86_tss);
> > +
> > +	load_TR_desc();
> 
> Aha, this is what you mean here in your 0th message. I'm guessing it is
> ok to do those things twice in start_secondary...

Yes, I think its best to do it twice, so that cpu_init() stays the CPU
state barrier it should be, independent of what happens before.


	Joerg
