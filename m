Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75E23275E94
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 19:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgIWR0s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 13:26:48 -0400
Received: from mga14.intel.com ([192.55.52.115]:2454 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726413AbgIWR0s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 13:26:48 -0400
IronPort-SDR: VH9o6JVYXgLsEneQCkF8j1STLfjAz9xDIjfwFHV4QbB/pm9erjKyXWO5lQG6Wvisqfb6pt0DoC
 8GfkS8qieCNw==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="160251105"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="160251105"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 10:26:47 -0700
IronPort-SDR: ey9SEz/jSNaz0OtMzWULGxth9YBvWEynGLnavUxHtQq2r16MsoeDfOaVHdAf9zM8fjL9NTqBRV
 uvqiUNKNCA6g==
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="486522044"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 10:26:47 -0700
Date:   Wed, 23 Sep 2020 10:26:46 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Cfir Cohen <cfir@google.com>,
        "kvm @ vger . kernel . org" <kvm@vger.kernel.org>,
        Lendacky Thomas <thomas.lendacky@amd.com>,
        Singh Brijesh <brijesh.singh@amd.com>,
        Grimm Jon <Jon.Grimm@amd.com>,
        David Rientjes <rientjes@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: SVM: Mark SEV launch secret pages as dirty.
Message-ID: <20200923172646.GB32044@linux.intel.com>
References: <20200807012303.3769170-1-cfir@google.com>
 <20200919045505.GC21189@sjchrist-ice>
 <5ac77c46-88b4-df45-4f02-72adfb096262@redhat.com>
 <20200923170444.GA20076@linux.intel.com>
 <548b7b73-7a13-8267-414e-2b9e1569c7f7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <548b7b73-7a13-8267-414e-2b9e1569c7f7@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 23, 2020 at 07:16:08PM +0200, Paolo Bonzini wrote:
> On 23/09/20 19:04, Sean Christopherson wrote:
> >> Two of the three instances are a bit different though.  What about this
> >> which at least shortens the comment to 2 fewer lines:
> > Any objection to changing those to "Flush (on non-coherent CPUs)"?  I agree
> > it would be helpful to call out the details, especially for DBG_*, but I
> > don't like that it reads as if the flush is unconditional.
> 
> Hmm... It's already fairly long lines so that would wrap to 3 lines, and

Dang, I was hoping it would squeeze into 2.

> the reference to the conditional flush wasn't there before either.

Well, the flush wasn't conditional before (ignoring the NULL check).
 
> sev_clflush_pages could be a better place to mention that (or perhaps
> it's self-explanatory).

I agree, but with

	/*
	 * Flush before LAUNCH_UPDATE encrypts pages in place, in case the cache
	 * contains the data that was written unencrypted.
 	 */
 	sev_clflush_pages(inpages, npages);

there's nothing in the comment or code that even suggests sev_clflush_pages() is
conditional, i.e. no reason for the reader to peek at the implemenation.

What about:

	/*
	 * Flush (on non-coherent CPUs) before LAUNCH_UPDATE encrypts pages in
	 * place, the cache may contain data that was written unencrypted.
	 */
