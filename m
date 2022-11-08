Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08F41620D21
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 11:21:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233907AbiKHKV2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 05:21:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233841AbiKHKV0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 05:21:26 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6718E14D13;
        Tue,  8 Nov 2022 02:21:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667902885; x=1699438885;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=c+lMi5TLW44CIVNMGAR0QpVGssYLNZmbLqtwnbDV/Cw=;
  b=mHSWlzMWMUJLzOYEiAgQGIR4EO23ptEMpCGwOWkBCrcoofByNIHOrlFo
   pPN2ivxFOOuwsgzInssh5YDTfxlKp0VKvVF7EiCokoG4xPvZt3ZsgfQel
   pfaJy9AhsBLVlxEMlCbnappL5U+GxsYXp2cMASbCaZ1D9TvZIrH4UIuKi
   5NPVrfYKg9cOWqYNMhnLrxpjK41LrrpkaVcoiMIqrRcSfd0ZunL5CXiHb
   Lpuf5eEHrx3Ic8DXstKn4RDd+IEUzT0F61q8ZqTCT/VwyRQRsrDY6xA7Z
   MlNxI7qdLN4lsEEafczYSS95A5TCnNzl+iT/iHPmltUG4mf/vjzpxaUEI
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="309369613"
X-IronPort-AV: E=Sophos;i="5.96,147,1665471600"; 
   d="scan'208";a="309369613"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 02:21:24 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="614229830"
X-IronPort-AV: E=Sophos;i="5.96,147,1665471600"; 
   d="scan'208";a="614229830"
Received: from wanglin4-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.173.199])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 02:21:20 -0800
Date:   Tue, 8 Nov 2022 18:21:20 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Li <ercli@ucdavis.edu>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Liu Jingqi <jingqi.liu@intel.com>
Subject: Re: [PATCH v5 05/15] KVM: nVMX: Let userspace set nVMX MSR to any
 _host_ supported value
Message-ID: <20221108102120.qdlgqlgvdi6wi22u@linux.intel.com>
References: <20220607213604.3346000-1-seanjc@google.com>
 <20220607213604.3346000-6-seanjc@google.com>
 <20221031163907.w64vyg5twzvv2nho@linux.intel.com>
 <Y2ABrnRzg729ZZNI@google.com>
 <20221101101801.zxcjswoesg2gltri@linux.intel.com>
 <Y2FePYteNrEfZ7D5@google.com>
 <20221102085414.fk2xss74jvtzs6mr@linux.intel.com>
 <Y2Px90RQydMUoiRH@google.com>
 <20221107082714.fq3sw7qii4unlcn2@linux.intel.com>
 <Y2kfCz02tQSUkMKS@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2kfCz02tQSUkMKS@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 07, 2022 at 03:06:51PM +0000, Sean Christopherson wrote:
> On Mon, Nov 07, 2022, Yu Zhang wrote:
> > On Thu, Nov 03, 2022 at 04:53:11PM +0000, Sean Christopherson wrote:
> > > Ideally, KVM should NEVER manipulate VMX MSRs in response to guest CPUID changes.
> > > That's what I was referring to earlier by commits:
> 
> ...
> 
> > Thanks Sean. Let me try to rephrase my understandings of your statement(
> > and pls feel free to correct me):
> > 
> > 1> For now, what vmx_adjust_secondary_exec_control() does, is to enable/
> > disable a feature in VMX MSR(and nVMX MSR) based on cpuid changes.
> > 2> What makes sense is, if a feature is 
> > 	a. disabled by guest CPUID, it shall not be exposed in guest VMX MSR;
> > 	b. enabled by guest CPUID, it could be either exposed or hidden in
> > 	guest VMX MSR.
> > 3> So your previous change is to guarantee 2.a, and userspace VMM can choose
> > to follow follow either choices in 2.b(depending on whether it believes this
> > feature is correctly supported by KVM in nested). 
> > 
> > Is above understanding correct? 
> 
> Not quite.  Again, in an ideal world, KVM would not modify the VMX MSRs based on
> guest CPUID.  But it's possible userspace is relying on KVM to hide a feature from
> L2 if it's hidden from L1, so to avoid breaking an otherwise valide userspace config,
> it's worth enforcing that in KVM.
> 

Sorry, maybe I should understand this way:

In theroy, KVM shall not modify guest VMX MSRs in response to the guest CPUID
updates. Therefore we shall not enforce the exposure of a feature in guest VMX
MSR, just because it is enabled in guest CPUID (e.g., userspace VMM can choose
to hide such feature so long as it believes KVM can not provide correct nested
support for this feature). 

But in reverse, it is not reasonable for userspace VMM to expose a feature in
guest VMX MSR settings, if such feature is disabled in this guest's CPUID. So
KVM shall help to make sure such feature is hidden when guest CPUID changes.


BTW, I found my previous understanding of what vmx_adjust_secondary_exec_control()
currently does was also wrong. It could also be used for EXITING controls. And
for such flags(e.g., SECONDARY_EXEC_RDRAND_EXITING), values for the nested settings
(vmx->nested.msrs.secondary_ctls_high) and for the L1 execution controls(*exec_control)
could be opposite. So the statement:
	"1> For now, what vmx_adjust_secondary_exec_control() does, is to enable/
	 disable a feature in VMX MSR(and nVMX MSR) based on cpuid changes."
is wrong.

Hopefully we are gonna change vmx_adjust_secondary_exec_control() soon...

B.R.
Yu
