Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA6842FC441
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 23:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728922AbhASW4K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 17:56:10 -0500
Received: from mga01.intel.com ([192.55.52.88]:64050 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726565AbhASWzv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jan 2021 17:55:51 -0500
IronPort-SDR: vGqezXVmmgaS2r+jLtYwjTnmMAoE9NOu8xV3eJnhAryEHc6SZBK0aPfUjH2Tw0CmEx9gMzcPdK
 V+oMxu1PiIeA==
X-IronPort-AV: E=McAfee;i="6000,8403,9869"; a="197725578"
X-IronPort-AV: E=Sophos;i="5.79,359,1602572400"; 
   d="scan'208";a="197725578"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2021 14:55:06 -0800
IronPort-SDR: ISRlo4oXc3016jbQSwvjScWvCd4UnZD2W/fKx7ptO68O2aQh+LrTeGIVBF/XHGpZraVjiVF0ak
 0qXkETLK0tQA==
X-IronPort-AV: E=Sophos;i="5.79,359,1602572400"; 
   d="scan'208";a="355810086"
Received: from hzhan36-mobl.amr.corp.intel.com ([10.251.22.237])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2021 14:55:02 -0800
Message-ID: <973a42cd008fb28a3b76aeefc3231091e24a0724.camel@intel.com>
Subject: Re: [RFC PATCH v2 01/26] x86/cpufeatures: Add SGX1 and SGX2
 sub-features
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        jarkko@kernel.org, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Date:   Wed, 20 Jan 2021 11:54:59 +1300
In-Reply-To: <YAce4r4QhGzJqd4y@google.com>
References: <cover.1610935432.git.kai.huang@intel.com>
         <87385f646120a3b5b34dc20480dbce77b8005acd.1610935432.git.kai.huang@intel.com>
         <20210119161925.GN27433@zn.tnic> <YAce4r4QhGzJqd4y@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-01-19 at 10:03 -0800, Sean Christopherson wrote:
> On Tue, Jan 19, 2021, Borislav Petkov wrote:
> > On Mon, Jan 18, 2021 at 04:26:49PM +1300, Kai Huang wrote:
> > > diff --git a/arch/x86/kernel/cpu/feat_ctl.c b/arch/x86/kernel/cpu/feat_ctl.c
> > > index 3b1b01f2b248..7937a315f8cf 100644
> > > --- a/arch/x86/kernel/cpu/feat_ctl.c
> > > +++ b/arch/x86/kernel/cpu/feat_ctl.c
> > > @@ -96,7 +96,6 @@ static void init_vmx_capabilities(struct cpuinfo_x86 *c)
> > >  static void clear_sgx_caps(void)
> > >  {
> > >  	setup_clear_cpu_cap(X86_FEATURE_SGX);
> > > -	setup_clear_cpu_cap(X86_FEATURE_SGX_LC);
> > 
> > Why is that line being removed here?
> > 
> > Shouldn't this add SGX1 and SGX2 here instead as this function is
> > supposed to, well, *clear* sgx caps on feat_ctl setup failures or
> > "nosgx" cmdline?
> 
> Doesn't adding making the SGX sub-features depend on X86_FEATURE_SGX have the
> same net effect?  Or am I misreading do_clear_cpu_cap()?

On my testing machine with SGX, SGX_LC, and SGX1. I just double tested that clearing
X86_FEATURE_SGX also clears SGX1 and SGX_LC bits.

> 
> Though if we use the cpuid_deps table, I'd vote to get rid of clear_sgx_caps()
> and call setup_clear_cpu_cap(X86_FEATURE_SGX) directly. 
> 

Yes I can do that.

>  And probably change the
> existing SGX_LC behavior and drop clear_sgx_caps() in a separate patch instead
> of squeezing it into this one.

To double confirm, you want:

1) This patch to introduce SGX1, SGX2, and also put SGX1 and SGX2 in to CPUID
dependency table; 
2) A separate patch to put SGX_LC to CPUID dependency table too, and also git rid of
clear_sgx_caps()

Correct?

Btw, in your original patch, both SGX1 and SGX2 depends on SGX, but I changed to make
SGX2 depend on SGX1. However I still make SGX_LC depend on SGX, but not SGX1. Does
this make sense to you?




