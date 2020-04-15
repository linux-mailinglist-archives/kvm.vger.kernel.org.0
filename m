Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD901AB1BC
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 21:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436618AbgDOTaY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 15:30:24 -0400
Received: from mga05.intel.com ([192.55.52.43]:37882 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441787AbgDOTaV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 15:30:21 -0400
IronPort-SDR: oxGrBlR6WLgoUrqBLEuL57btbJ1mfJ5H6/s1DbJJVG8M9pmFfTOQjpaF9a5Bc8bXpn1g1dcW9s
 FpHTYty8S54Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2020 12:30:17 -0700
IronPort-SDR: OkZ32SNPTGFVIZ18TPD4ylkdfMrVb46BKLOfr+nbmG4Ydc1e2N+o0uJFbi14eaKO3TnhO+AxRD
 7LfP0i1aK/mw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,388,1580803200"; 
   d="scan'208";a="242404064"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 15 Apr 2020 12:30:16 -0700
Date:   Wed, 15 Apr 2020 12:30:16 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH 1/2 v2] KVM: nVMX: KVM needs to unset "unrestricted
 guest" VM-execution control in vmcs02 if vmcs12 doesn't set it
Message-ID: <20200415193016.GF30627@linux.intel.com>
References: <20200415183047.11493-1-krish.sadhukhan@oracle.com>
 <20200415183047.11493-2-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200415183047.11493-2-krish.sadhukhan@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 15, 2020 at 02:30:46PM -0400, Krish Sadhukhan wrote:
> Currently, prepare_vmcs02_early() does not check if the "unrestricted guest"
> VM-execution control in vmcs12 is turned off and leaves the corresponding
> bit on in vmcs02. Due to this setting, vmentry checks which are supposed to
> render the nested guest state as invalid when this VM-execution control is
> not set, are passing in hardware.
> 
> This patch turns off the "unrestricted guest" VM-execution control in vmcs02
> if vmcs12 has turned it off.
> 
> Suggested-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index cbc9ea2de28f..4fa5f8b51c82 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2224,6 +2224,9 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
>  			vmcs_write16(GUEST_INTR_STATUS,
>  				vmcs12->guest_intr_status);
>  
> +		if (!nested_cpu_has2(vmcs12, SECONDARY_EXEC_UNRESTRICTED_GUEST))
> +			exec_control &= ~SECONDARY_EXEC_UNRESTRICTED_GUEST;

Has anyone worked through all the flows to verify this won't break any
assumptions with respect to enable_unrestricted_guest?  I would be
(pleasantly) surprised if this was sufficient to run L2 without
unrestricted guest when it's enabled for L1, e.g. vmx_set_cr0() looks
suspect.

> +
>  		secondary_exec_controls_set(vmx, exec_control);
>  	}
>  
> -- 
> 2.20.1
> 
