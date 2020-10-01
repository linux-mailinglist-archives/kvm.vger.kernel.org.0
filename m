Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F98327F6AE
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 02:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731337AbgJAA1F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 20:27:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:55815 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730715AbgJAA1E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 20:27:04 -0400
IronPort-SDR: tWic1MtgXCVMRQjZFA9/oI3z4BVAHDOHe2mfjJ4P/jBmhnvyYeA5Fjs/MoEKLtJMf03fefKO6A
 JTFGxTmW4www==
X-IronPort-AV: E=McAfee;i="6000,8403,9760"; a="163439634"
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="163439634"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 17:26:59 -0700
IronPort-SDR: ZLXrQUQsWI6x9aob7bMXSHgC89t677ZCK4fGSzl9R5b9Q4fbL1Z6om5AptXUtgKBNIRVvUgrJy
 +dKNMr6su64g==
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="350860999"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 17:26:58 -0700
Date:   Wed, 30 Sep 2020 17:26:57 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH v6 4/4] KVM: nSVM: implement on demand allocation of the
 nested state
Message-ID: <20201001002657.GD2988@linux.intel.com>
References: <20200922211025.175547-1-mlevitsk@redhat.com>
 <20200922211025.175547-5-mlevitsk@redhat.com>
 <20200929051526.GD353@linux.intel.com>
 <0518490df933d0b12b6dc4b0df2234091cd95ce7.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0518490df933d0b12b6dc4b0df2234091cd95ce7.camel@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 30, 2020 at 06:35:40PM +0300, Maxim Levitsky wrote:
> On Mon, 2020-09-28 at 22:15 -0700, Sean Christopherson wrote:
> > Side topic, do we actually need 'initialized'?  Wouldn't checking for a
> > valid nested.msrpm or nested.hsave suffice?
> 
> It a matter of taste - I prefer to have a single variable controlling this,
> rather than two. 
> a WARN_ON(svm->nested.initialized && !svm->nested.msrpm || !svm->nested.hsave))
> would probably be nice to have. IMHO I rather leave this like it is if you
> don't object.

I don't have a strong preference.  I wouldn't bother with the second WARN_ON.
Unless you take action, e.g. bail early, a NULL pointer will likely provide a
stack trace soon enough :-).
