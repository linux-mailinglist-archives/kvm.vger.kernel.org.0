Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A70E8CEA3D
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2019 19:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728941AbfJGRKP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Oct 2019 13:10:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:15254 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728048AbfJGRKO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Oct 2019 13:10:14 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Oct 2019 10:10:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,268,1566889200"; 
   d="scan'208";a="368177334"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga005.jf.intel.com with ESMTP; 07 Oct 2019 10:10:13 -0700
Date:   Mon, 7 Oct 2019 10:10:13 -0700
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
Subject: Re: [PATCH 01/16] x86/intel: Initialize IA32_FEATURE_CONTROL MSR at
 boot
Message-ID: <20191007171013.GD18016@linux.intel.com>
References: <20191004215615.5479-1-sean.j.christopherson@intel.com>
 <20191004215615.5479-2-sean.j.christopherson@intel.com>
 <afd37a28-d135-7c34-bd63-7c11099998bc@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afd37a28-d135-7c34-bd63-7c11099998bc@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 07, 2019 at 07:05:32PM +0200, Paolo Bonzini wrote:
> On 04/10/19 23:56, Sean Christopherson wrote:
> > Always lock IA32_FEATURE_CONTROL if it exists, even if the CPU doesn't
> > support VMX, so that other existing and future kernel code that queries
> > IA32_FEATURE_CONTROL can assume it's locked.
> 
> Possibly stupid question: why bother locking it?  It makes sense to lock
> the MSR bits to _off_ in the firmware, but if the BIOS hasn't locked it,
> why should the OS?
> 
> It seems to me that locking introduces a lot of complication.

None of the enable bits take effect until the MSR is locked.  If I had to
guess, ucode likely goes and pokes the enabled features during the WRMSR
with the lock bit set, as opposed to the relevant features querying the
MSR value as needed (querying the MSR is likely slow).
