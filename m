Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A453268F0C
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 17:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726003AbgINPHC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 11:07:02 -0400
Received: from mga14.intel.com ([192.55.52.115]:6600 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725984AbgINPGl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 11:06:41 -0400
IronPort-SDR: a3JYADAw7dOZHm9xLUiMF60otfoKHpVWw5nrJVl/k4gmREwadLusNQybSghal663kAQJzDmEkz
 qggkoXAWMlcw==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="158374193"
X-IronPort-AV: E=Sophos;i="5.76,426,1592895600"; 
   d="scan'208";a="158374193"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 08:06:29 -0700
IronPort-SDR: Y2MzUY6ahfLD+0dsKg6BuoomGip1QVLnYOd1Gwoq7dZ/ctJ55jXmoc89muI81al/sm0NaC89JR
 ovnObFpHvL/w==
X-IronPort-AV: E=Sophos;i="5.76,426,1592895600"; 
   d="scan'208";a="287648567"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 08:06:29 -0700
Date:   Mon, 14 Sep 2020 08:06:27 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Babu Moger <babu.moger@amd.com>, vkuznets@redhat.com,
        jmattson@google.com, wanpengli@tencent.com, kvm@vger.kernel.org,
        joro@8bytes.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, tglx@linutronix.de
Subject: Re: [PATCH v6 04/12] KVM: SVM: Modify intercept_exceptions to
 generic intercepts
Message-ID: <20200914150627.GB6855@sjchrist-ice>
References: <159985237526.11252.1516487214307300610.stgit@bmoger-ubuntu>
 <159985250037.11252.1361972528657052410.stgit@bmoger-ubuntu>
 <1654dd89-2f15-62b6-d3a7-53f3ec422dd0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1654dd89-2f15-62b6-d3a7-53f3ec422dd0@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Sep 12, 2020 at 06:52:20PM +0200, Paolo Bonzini wrote:
> On 11/09/20 21:28, Babu Moger wrote:
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 1a5f3908b388..11892e86cb39 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -1003,11 +1003,11 @@ static void init_vmcb(struct vcpu_svm *svm)
> >  
> >  	set_dr_intercepts(svm);
> >  
> > -	set_exception_intercept(svm, PF_VECTOR);
> > -	set_exception_intercept(svm, UD_VECTOR);
> > -	set_exception_intercept(svm, MC_VECTOR);
> > -	set_exception_intercept(svm, AC_VECTOR);
> > -	set_exception_intercept(svm, DB_VECTOR);
> > +	set_exception_intercept(svm, INTERCEPT_PF_VECTOR);
> > +	set_exception_intercept(svm, INTERCEPT_UD_VECTOR);
> > +	set_exception_intercept(svm, INTERCEPT_MC_VECTOR);
> > +	set_exception_intercept(svm, INTERCEPT_AC_VECTOR);
> > +	set_exception_intercept(svm, INTERCEPT_DB_VECTOR);
> 
> I think these should take a vector instead, and add 64 in the functions.

And "s/int bit/u32 vector" + BUILD_BUG_ON(vector > 32)?
