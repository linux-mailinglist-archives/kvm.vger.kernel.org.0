Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54140CED0A
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2019 21:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728680AbfJGT4k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Oct 2019 15:56:40 -0400
Received: from mga04.intel.com ([192.55.52.120]:27834 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728212AbfJGT4k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Oct 2019 15:56:40 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Oct 2019 12:56:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,269,1566889200"; 
   d="scan'208";a="223020250"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga002.fm.intel.com with ESMTP; 07 Oct 2019 12:56:38 -0700
Date:   Mon, 7 Oct 2019 12:56:38 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-edac@vger.kernel.org,
        Borislav Petkov <bp@suse.de>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH 11/16] x86/cpu: Print VMX features as separate line item
 in /proc/cpuinfo
Message-ID: <20191007195638.GG18016@linux.intel.com>
References: <20191004215615.5479-1-sean.j.christopherson@intel.com>
 <20191004215615.5479-12-sean.j.christopherson@intel.com>
 <55f45459-47bf-df37-a12b-17c4c5c6c19a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55f45459-47bf-df37-a12b-17c4c5c6c19a@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 07, 2019 at 07:12:37PM +0200, Paolo Bonzini wrote:
> On 04/10/19 23:56, Sean Christopherson wrote:
> > diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
> > index cb2e49810d68..4eec8889b0ff 100644
> > --- a/arch/x86/kernel/cpu/proc.c
> > +++ b/arch/x86/kernel/cpu/proc.c
> > @@ -7,6 +7,10 @@
> >  
> >  #include "cpu.h"
> >  
> > +#ifdef CONFIG_X86_VMX_FEATURE_NAMES
> > +extern const char * const x86_vmx_flags[NVMXINTS*32];
> > +#endif
> > +
> >  /*
> >   *	Get CPU information for use by the procfs.
> >   */
> > @@ -102,6 +106,17 @@ static int show_cpuinfo(struct seq_file *m, void *v)
> >  		if (cpu_has(c, i) && x86_cap_flags[i] != NULL)
> >  			seq_printf(m, " %s", x86_cap_flags[i]);
> 
> I'm afraid this is going to break some scripts in the wild.  I would
> simply remove the seq_puts below.

Can you elaborate?  I'm having trouble connecting the dots...

> Paolo
> 
> > +#ifdef CONFIG_X86_VMX_FEATURE_NAMES
> > +	if (cpu_has(c, X86_FEATURE_VMX) && c->vmx_capability[0]) {
> > +		seq_puts(m, "\nvmx flags\t:");
> > +		for (i = 0; i < 32*NVMXINTS; i++) {
> > +			if (test_bit(i, (unsigned long *)c->vmx_capability) &&
> > +			    x86_vmx_flags[i] != NULL)
> > +				seq_printf(m, " %s", x86_vmx_flags[i]);
> > +		}
> > +	}
> > +#endif
> > +
> >  	seq_puts(m, "\nbugs\t\t:");
> >  	for (i = 0; i < 32*NBUGINTS; i++) {
> >  		unsigned int bug_bit = 32*NCAPINTS + i;
