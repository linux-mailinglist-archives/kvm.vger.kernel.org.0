Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 443A3172D71
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 01:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730250AbgB1AgP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Feb 2020 19:36:15 -0500
Received: from mga05.intel.com ([192.55.52.43]:56620 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729984AbgB1AgO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Feb 2020 19:36:14 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Feb 2020 16:36:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,493,1574150400"; 
   d="scan'208";a="232062493"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga008.jf.intel.com with ESMTP; 27 Feb 2020 16:36:13 -0800
Date:   Thu, 27 Feb 2020 16:36:14 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 39/61] KVM: SVM: Convert feature updates from CPUID to
 KVM cpu caps
Message-ID: <20200228003613.GC30452@linux.intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
 <20200201185218.24473-40-sean.j.christopherson@intel.com>
 <0f21b023-000d-9d78-b9b4-b9d377840385@redhat.com>
 <20200228002833.GB30452@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200228002833.GB30452@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 27, 2020 at 04:28:33PM -0800, Sean Christopherson wrote:
> On Tue, Feb 25, 2020 at 04:10:18PM +0100, Paolo Bonzini wrote:
> > On 01/02/20 19:51, Sean Christopherson wrote:
> > > +	/* CPUID 0x8000000A */
> > > +	/* Support next_rip if host supports it */
> > > +	if (boot_cpu_has(X86_FEATURE_NRIPS))
> > > +		kvm_cpu_cap_set(X86_FEATURE_NRIPS);
> > 
> > Should this also be conditional on "nested"?
> 
> I think that makes sense?  AFAICT it should probably be conditional on
> "nrips" as well.  X86_FEATURE_NPT should also be conditional on "nested".
> I'll tack on a patch to make those changes, the cleanup is easier without
> the things spread across different case statements, e.g. wrap the entire
> SVM feature leaf in "if (nested)".

Regarding NRIPS, the original commit added the "Support next_rip if host
supports it" comment, but I can't tell is "host supports" means "supported
in hardware" or "supported by KVM".  In other words, should I make the cap
dependent "nrips" or leave it as is?
