Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 781C9D189F
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 21:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731948AbfJITRA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 15:17:00 -0400
Received: from mga06.intel.com ([134.134.136.31]:23362 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729535AbfJITRA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 15:17:00 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Oct 2019 12:16:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,277,1566889200"; 
   d="scan'208";a="198105041"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga006.jf.intel.com with ESMTP; 09 Oct 2019 12:16:59 -0700
Date:   Wed, 9 Oct 2019 12:16:59 -0700
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
Message-ID: <20191009191659.GE19952@linux.intel.com>
References: <20191004215615.5479-1-sean.j.christopherson@intel.com>
 <20191004215615.5479-12-sean.j.christopherson@intel.com>
 <55f45459-47bf-df37-a12b-17c4c5c6c19a@redhat.com>
 <20191007195638.GG18016@linux.intel.com>
 <bd2cffea-6427-b3cc-7098-a881e3d4522d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd2cffea-6427-b3cc-7098-a881e3d4522d@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 08, 2019 at 08:57:30AM +0200, Paolo Bonzini wrote:
> On 07/10/19 21:56, Sean Christopherson wrote:
> > On Mon, Oct 07, 2019 at 07:12:37PM +0200, Paolo Bonzini wrote:
> >> On 04/10/19 23:56, Sean Christopherson wrote:
> >>> diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
> >>> index cb2e49810d68..4eec8889b0ff 100644
> >>> --- a/arch/x86/kernel/cpu/proc.c
> >>> +++ b/arch/x86/kernel/cpu/proc.c
> >>> @@ -7,6 +7,10 @@
> >>>  
> >>>  #include "cpu.h"
> >>>  
> >>> +#ifdef CONFIG_X86_VMX_FEATURE_NAMES
> >>> +extern const char * const x86_vmx_flags[NVMXINTS*32];
> >>> +#endif
> >>> +
> >>>  /*
> >>>   *	Get CPU information for use by the procfs.
> >>>   */
> >>> @@ -102,6 +106,17 @@ static int show_cpuinfo(struct seq_file *m, void *v)
> >>>  		if (cpu_has(c, i) && x86_cap_flags[i] != NULL)
> >>>  			seq_printf(m, " %s", x86_cap_flags[i]);
> >>
> >> I'm afraid this is going to break some scripts in the wild.  I would
> >> simply remove the seq_puts below.
> > 
> > Can you elaborate?  I'm having trouble connecting the dots...
> 
> Somebody is bound to have scripts doing "grep ^flags.*ept /proc/cpuinfo"
> or checking for VMX flags under some kind of "if (/^flags/)", so it's
> safer not to separate VMX and non-VMX flags.

Are the names of the flags considered ABI?  If so, then the rename of
"vnmi" to "virtual_nmis" also needs to be dropped.  :-(
