Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3450ECEA5A
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2019 19:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728796AbfJGRNg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Oct 2019 13:13:36 -0400
Received: from mga03.intel.com ([134.134.136.65]:19108 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728028AbfJGRNg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Oct 2019 13:13:36 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Oct 2019 10:13:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,268,1566889200"; 
   d="scan'208";a="206457829"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 07 Oct 2019 10:13:34 -0700
Date:   Mon, 7 Oct 2019 10:13:33 -0700
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
Subject: Re: [PATCH 09/16] x86/vmx: Introduce VMX_FEATURES_*
Message-ID: <20191007171333.GE18016@linux.intel.com>
References: <20191004215615.5479-1-sean.j.christopherson@intel.com>
 <20191004215615.5479-10-sean.j.christopherson@intel.com>
 <149d4422-b955-9118-e7df-e135075ad490@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <149d4422-b955-9118-e7df-e135075ad490@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 07, 2019 at 07:08:28PM +0200, Paolo Bonzini wrote:
> On 04/10/19 23:56, Sean Christopherson wrote:
> > +#define VMX_FEATURE_RDSEED_EXITING	( 2*32+ 16) /* "" VM-Exit on RDSEED */
> > +#define VMX_FEATURE_PAGE_MOD_LOGGING	( 2*32+ 17) /* "pml" Log dirty pages into buffer */
> > +#define VMX_FEATURE_EPT_VIOLATION_VE	( 2*32+ 18) /* "" Conditionally reflect EPT violations as #VE exceptions */
> > +#define VMX_FEATURE_PT_CONCEAL_VMX	( 2*32+ 19) /* "" Suppress VMX indicators in Processor Trace */
> > +#define VMX_FEATURE_XSAVES		( 2*32+ 20) /* "" Enable XSAVES and XRSTORS in guest */
> > +#define VMX_FEATURE_RESERVED_PIN_21	( 2*32+ 21) /* "" Reserved */
> > +#define VMX_FEATURE_MODE_BASED_EPT_EXEC	( 2*32+ 22) /* Enable separate EPT EXEC bits for supervisor vs. user */
> > +#define VMX_FEATURE_RESERVED_PIN_23	( 2*32+ 23) /* "" Reserved */
> > +#define VMX_FEATURE_PT_USE_GPA		( 2*32+ 24) /* "" Processor Trace logs GPAs */
> > +#define VMX_FEATURE_TSC_SCALING		( 2*32+ 25) /* Scale hardware TSC when read in guest */
> > +#define VMX_FEATURE_RESERVED_PIN_26	( 2*32+ 26) /* "" Reserved */
> > +#define VMX_FEATURE_RESERVED_PIN_27	( 2*32+ 27) /* "" Reserved */
> > +#define VMX_FEATURE_ENCLV_EXITING	( 2*32+ 28) /* "" VM-Exit on ENCLV (leaf dependent) */
> > +#define VMX_FEATURE_RESERVED_PIN_29	( 2*32+ 29) /* "" Reserved */
> > +#define VMX_FEATURE_RESERVED_PIN_30	( 2*32+ 30) /* "" Reserved */
> > +#define VMX_FEATURE_RESERVED_PIN_31	( 2*32+ 31) /* "" Reserved */
> 
> Pasto on the reserved bit names, but in general why is it useful to
> define them?

Doh.  It was mostly so that I could more easily cross-reference the SDM
and visually see that I wasn't skipping bits.  No argument from me if it'd
be preferably to omit them.
