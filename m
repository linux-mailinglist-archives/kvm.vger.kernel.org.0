Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A46A153493
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 16:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbgBEPtF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 10:49:05 -0500
Received: from mga18.intel.com ([134.134.136.126]:20773 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726534AbgBEPtF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 10:49:05 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Feb 2020 07:49:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,406,1574150400"; 
   d="scan'208";a="225870747"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga008.fm.intel.com with ESMTP; 05 Feb 2020 07:49:04 -0800
Date:   Wed, 5 Feb 2020 07:49:04 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, vkuznets@redhat.com
Subject: Re: [PATCH kvm-unit-tests] x86: provide enabled and disabled
 variation of the PCID test
Message-ID: <20200205154904.GF4877@linux.intel.com>
References: <1580916580-4098-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1580916580-4098-1-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 05, 2020 at 04:29:40PM +0100, Paolo Bonzini wrote:
> The PCID test checks for exceptions when PCID=0 or INVPCID=0 in
> CPUID.  Cover that by adding a separate testcase with different
> CPUID.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  x86/unittests.cfg | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index aae1523..f2401eb 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -228,7 +228,12 @@ extra_params = --append "10000000 `date +%s`"
>  
>  [pcid]
>  file = pcid.flat
> -extra_params = -cpu qemu64,+pcid
> +extra_params = -cpu qemu64,+pcid,+invpcid
> +arch = x86_64
> +
> +[pcid-disabled]
> +file = pcid.flat
> +extra_params = -cpu qemu64,-pcid,-invpcid
>  arch = x86_64

Hrm, but "-cpu qemu64,-pcid,+invpcid" is arguably the more interesting test
from a KVM perspective because of the logic in KVM to hide invpcid if pcid
isn't supported.

And +pcid,-invpcid is also interesting.

Is there an easy-ish change that can be made to allow iterating over
multiple CPU configurations for single test case?
