Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0209B405B2B
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 18:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238377AbhIIQrq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 12:47:46 -0400
Received: from mga05.intel.com ([192.55.52.43]:45068 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230144AbhIIQrp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 12:47:45 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10102"; a="306413823"
X-IronPort-AV: E=Sophos;i="5.85,280,1624345200"; 
   d="scan'208";a="306413823"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2021 09:46:35 -0700
X-IronPort-AV: E=Sophos;i="5.85,280,1624345200"; 
   d="scan'208";a="470170226"
Received: from gchen28-mobl2.ccr.corp.intel.com (HELO localhost) ([10.255.31.74])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2021 09:46:32 -0700
Date:   Fri, 10 Sep 2021 00:46:29 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org
Subject: Re: [PATCH] KVM: nVMX: Reset vmxon_ptr upon VMXOFF emulation.
Message-ID: <20210909164629.7fufaejlpj6bl6vk@linux.intel.com>
References: <20210909124846.13854-1-yu.c.zhang@linux.intel.com>
 <YTo0U0ae3shRbUYC@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTo0U0ae3shRbUYC@google.com>
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 09, 2021 at 04:20:35PM +0000, Sean Christopherson wrote:
> On Thu, Sep 09, 2021, Yu Zhang wrote:
> > From: Vitaly Kuznetsov <vkuznets@redhat.com>
> > 
> > Currently, 'vmx->nested.vmxon_ptr' is not reset upon VMXOFF
> > emulation. This is not a problem per se as we never access
> > it when !vmx->nested.vmxon. But this should be done to avoid
> > any issue in the future.
> > 
> > Also, initialize the vmxon_ptr when vcpu is created.
> > 
> > Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> > Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
> > ---
> >  arch/x86/kvm/vmx/nested.c | 1 +
> >  arch/x86/kvm/vmx/vmx.c    | 1 +
> >  2 files changed, 2 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 90f34f12f883..e4260f67caac 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -289,6 +289,7 @@ static void free_nested(struct kvm_vcpu *vcpu)
> >  	kvm_clear_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
> >  
> >  	vmx->nested.vmxon = false;
> > +	vmx->nested.vmxon_ptr = -1ull;
> 
> Looks like the "-1ull" comes from current_vmptr and friends, but using INVALID_GPA
> is more appropriate.  It's the same value, but less arbitrary.  The other usage of
> -1ull for guest physical addresses should really be cleaned up, too.
> 

Indeed. I guess many "-1ull"s will be replaced in nested.c.

We need another cleanup patch for this cleanup patch, which comes from my
first cleanup patch to just clean some comments.. :-) Anyway, thanks!

B.R.
Yu

