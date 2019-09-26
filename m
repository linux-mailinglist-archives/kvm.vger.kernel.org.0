Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D271BF949
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 20:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728410AbfIZSiC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 14:38:02 -0400
Received: from mga14.intel.com ([192.55.52.115]:44107 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726029AbfIZSiC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 14:38:02 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Sep 2019 11:38:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,552,1559545200"; 
   d="scan'208";a="341348893"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga004.jf.intel.com with ESMTP; 26 Sep 2019 11:38:01 -0700
Date:   Thu, 26 Sep 2019 11:38:01 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Reto Buerki <reet@codelabs.ch>
Cc:     kvm@vger.kernel.org
Subject: Re: [RFC PATCH] KVM: VMX: Always sync CR3 to VMCS in
 nested_vmx_load_cr3
Message-ID: <20190926183800.GB4738@linux.intel.com>
References: <20190926140541.15453-1-reet@codelabs.ch>
 <20190926140541.15453-2-reet@codelabs.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190926140541.15453-2-reet@codelabs.ch>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 26, 2019 at 04:05:41PM +0200, Reto Buerki wrote:
> Required to make a Muen system work on KVM nested.
> 
> Signed-off-by: Reto Buerki <reet@codelabs.ch>
> ---
>  arch/x86/kvm/vmx/nested.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 41abc62c9a8a..101b2c0c8480 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -1008,6 +1008,8 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool ne
>  		}
>  	}
>  
> +	vmcs_writel(GUEST_CR3, cr3);

This isn't wrong, but it's not the most precise fix.  I've figured out
what's going awry, in the process of determining how best to fix the issue.

> +
>  	if (!nested_ept)
>  		kvm_mmu_new_cr3(vcpu, cr3, false);
>  
> -- 
> 2.20.1
> 
