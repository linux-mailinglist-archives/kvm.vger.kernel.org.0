Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D08E403A30
	for <lists+kvm@lfdr.de>; Wed,  8 Sep 2021 15:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348808AbhIHNDA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 09:03:00 -0400
Received: from mga18.intel.com ([134.134.136.126]:27500 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232097AbhIHNC7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Sep 2021 09:02:59 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10100"; a="207588630"
X-IronPort-AV: E=Sophos;i="5.85,278,1624345200"; 
   d="scan'208";a="207588630"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2021 06:01:51 -0700
X-IronPort-AV: E=Sophos;i="5.85,278,1624345200"; 
   d="scan'208";a="538726756"
Received: from rhe-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.169.176])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2021 06:01:48 -0700
Date:   Wed, 8 Sep 2021 21:01:45 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org
Subject: Re: [PATCH] KVM: nVMX: fix comments of handle_vmon()
Message-ID: <20210908130145.3uwmywgjaahyb6iw@linux.intel.com>
References: <20210908171731.18885-1-yu.c.zhang@linux.intel.com>
 <87lf474ci8.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lf474ci8.fsf@vitty.brq.redhat.com>
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 08, 2021 at 11:55:59AM +0200, Vitaly Kuznetsov wrote:
> Indeed,
> 
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> On a slightly related note: we don't seem to reset
> 'vmx->nested.vmxon_ptr' upon VMXOFF emulation; this is not a problem per
> se as we never access it when !vmx->nested.vmxon but I'd still suggest
> we do something like
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index bc6327950657..8beb41d02d21 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -290,6 +290,7 @@ static void free_nested(struct kvm_vcpu *vcpu)
>  
>         vmx->nested.vmxon = false;
>         vmx->nested.smm.vmxon = false;
> +       vmx->nested.vmxon_ptr = -1ull;
>         free_vpid(vmx->nested.vpid02);
>         vmx->nested.posted_intr_nv = -1;
>         vmx->nested.current_vmptr = -1ull;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d7c5257eb5c0..2214e6bd4713 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6884,6 +6884,7 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
>  
>         vcpu_setup_sgx_lepubkeyhash(vcpu);
>  
> +       vmx->nested.vmxon_ptr = -1ull;
>         vmx->nested.posted_intr_nv = -1;
>         vmx->nested.current_vmptr = -1ull;
>         vmx->nested.hv_evmcs_vmptr = EVMPTR_INVALID;
> 
> to avoid issues in the future.
> 
Thanks, Vitaly. And above suggestion sounds reasonable to me. :)

I can add this in V2 later, if no one objects. 

B.R.
Yu
