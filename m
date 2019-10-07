Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EEA0CED06
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2019 21:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729005AbfJGTyY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Oct 2019 15:54:24 -0400
Received: from mga14.intel.com ([192.55.52.115]:57605 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728187AbfJGTyY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Oct 2019 15:54:24 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Oct 2019 12:54:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,269,1566889200"; 
   d="scan'208";a="199612480"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by FMSMGA003.fm.intel.com with ESMTP; 07 Oct 2019 12:54:22 -0700
Date:   Mon, 7 Oct 2019 12:54:22 -0700
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
Subject: Re: [PATCH 10/16] x86/cpu: Detect VMX features on Intel, Centaur and
 Zhaoxin CPUs
Message-ID: <20191007195422.GF18016@linux.intel.com>
References: <20191004215615.5479-1-sean.j.christopherson@intel.com>
 <20191004215615.5479-11-sean.j.christopherson@intel.com>
 <f26580de-d423-3369-42f4-682824dd592d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f26580de-d423-3369-42f4-682824dd592d@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 07, 2019 at 07:11:24PM +0200, Paolo Bonzini wrote:
> On 04/10/19 23:56, Sean Christopherson wrote:
> > +	/*
> > +	 * The high bits contain the allowed-1 settings, i.e. features that can
> > +	 * be turned on.  The low bits contain the allowed-0 settings, i.e.
> > +	 * features that can be turned off.  Ignore the allowed-0 settings,
> > +	 * if a feature can be turned on then it's supported.
> > +	 */
> > +	rdmsr(MSR_IA32_VMX_PINBASED_CTLS, ign, supported);
> 
> For QEMU, we're defining a feature as supported if a feature can be
> turned both on and off.  Since msr_low and msr_high can be defined
> respectively as must-be-one and can-be-one, the features become
> "msr_high & ~msr_low".

That makes sense for Qemu, but I don't think it's appropriate for this
type of reporting.  E.g. if EPT and Unrestricted Guest are must-be-one on
a hypothetical (virtual) CPU, it'd be odd to not list them as a supported
feature.

For actual hardware (well, Intel hardware), as proposed it's a moot point.
The only features that are must-be-one (even without "true" MSRs) and are
documented in the SDM are CR3_LOAD_EXITING, CR3_STORE_EXITING,
SAVE_DEBUG_CONTROLS, and LOAD_DEBUG_CONTROLS, none of which are reported
in /proc/cpuinfo.

> Also, shouldn't this use the "true" feature availability MSRs if available?

Only if incorporating the "& ~msr_low" can-be-one logic.  If a feature is
considered supported if it must-be-one or can-be-one then the true MSR and
vanilla MSR will yield the same feature set.

> 
> Paolo
