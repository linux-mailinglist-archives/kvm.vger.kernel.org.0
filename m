Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5DE127BBCB
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 06:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725554AbgI2EIx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 00:08:53 -0400
Received: from mga05.intel.com ([192.55.52.43]:59717 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgI2EIx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Sep 2020 00:08:53 -0400
IronPort-SDR: 5QukWZxve5ecHL8N7r+WDOMqXMRCC0GdO38hFuqLqHLVFq4bCbpLtlrs3a9Cs0vt3SslEcK7KP
 OsrwOzX/PIng==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="246847244"
X-IronPort-AV: E=Sophos;i="5.77,317,1596524400"; 
   d="scan'208";a="246847244"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 21:08:53 -0700
IronPort-SDR: 9/lqPWIKpxzy8/gS/sXhO3UCBs8INbatRgMZDOkjh5VsDA4yAB02AKmukpGRteJDRzEXJHqgBX
 O3sJAQIZCNAw==
X-IronPort-AV: E=Sophos;i="5.77,317,1596524400"; 
   d="scan'208";a="312073844"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 21:08:52 -0700
Date:   Mon, 28 Sep 2020 21:08:51 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, jmattson@google.com, pbonzini@redhat.com,
        vkuznets@redhat.com, qemu-devel@nongnu.org
Subject: Re: [PATCH 4/6 v3] KVM: VMX: Fill in conforming vmx_x86_ops via macro
Message-ID: <20200929040851.GK31514@linux.intel.com>
References: <1595895050-105504-1-git-send-email-krish.sadhukhan@oracle.com>
 <1595895050-105504-5-git-send-email-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1595895050-105504-5-git-send-email-krish.sadhukhan@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 28, 2020 at 12:10:48AM +0000, Krish Sadhukhan wrote:
> The names of some of the vmx_x86_ops functions do not have a corresponding
> 'vmx_' prefix. Generate the names using a macro so that the names are
> conformant. Fixing the naming will help in better readability and
> maintenance of the code.
> 
> Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> ---
>  arch/x86/kvm/vmx/nested.c |   2 +-
>  arch/x86/kvm/vmx/vmx.c    | 234 +++++++++++++++++++++++-----------------------
>  arch/x86/kvm/vmx/vmx.h    |   2 +-
>  3 files changed, 120 insertions(+), 118 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index d1af20b..a898b53 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3016,7 +3016,7 @@ static int nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
>  
>  	preempt_disable();
>  
> -	vmx_prepare_switch_to_guest(vcpu);
> +	vmx_prepare_guest_switch(vcpu);

I very strongly prefer the VMX version, i.e. rename kvm_x86_ops.prepare_guest_switch()
instead of renamed vmx_prepare_switch_to_guest().  prepare_guest_switch() can be
misinterpreted as switching to a different guest, and vmx_prepare_switch_to_guest()
explicitly pairs with vmx_prepare_switch_to_host().

>  
>  	/*
>  	 * Induce a consistency check VMExit by clearing bit 1 in GUEST_RFLAGS,
