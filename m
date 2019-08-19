Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3EB95085
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2019 00:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728358AbfHSWLC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Aug 2019 18:11:02 -0400
Received: from mga04.intel.com ([192.55.52.120]:38245 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728136AbfHSWLC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Aug 2019 18:11:02 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Aug 2019 15:11:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,406,1559545200"; 
   d="scan'208";a="353378355"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga005.jf.intel.com with ESMTP; 19 Aug 2019 15:11:01 -0700
Date:   Mon, 19 Aug 2019 15:11:01 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Nikita Leshenko <nikita.leshchenko@oracle.com>
Cc:     kvm@vger.kernel.org, Liran Alon <liran.alon@oracle.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: Re: [PATCH 1/2] KVM: nVMX: Always indicate HLT activity support in
 VMX_MISC MSR
Message-ID: <20190819221101.GF1916@linux.intel.com>
References: <20190819214650.41991-1-nikita.leshchenko@oracle.com>
 <20190819214650.41991-2-nikita.leshchenko@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190819214650.41991-2-nikita.leshchenko@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 20, 2019 at 12:46:49AM +0300, Nikita Leshenko wrote:
> Before this commit, userspace could disable the GUEST_ACTIVITY_HLT bit in
> VMX_MISC yet KVM would happily accept GUEST_ACTIVITY_HLT activity state in
> VMCS12. We can fix it by either failing VM entries with HLT activity state when
> it's not supported or by disallowing clearing this bit.
> 
> The latter is preferable. If we go with the former, to disable
> GUEST_ACTIVITY_HLT userspace also has to make CPU_BASED_HLT_EXITING a "must be
> 1" control, otherwise KVM will be presenting a bogus model to L1.
> 
> Don't fail writes that disable GUEST_ACTIVITY_HLT to maintain backwards
> compatibility.

Paolo, do we actually need to maintain backwards compatibility in this
case?  This seems like a good candidate for "fix the bug and see who yells".

> Reviewed-by: Liran Alon <liran.alon@oracle.com>
> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Signed-off-by: Nikita Leshenko <nikita.leshchenko@oracle.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 46af3a5e9209..24734946ec75 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -1102,6 +1102,14 @@ static int vmx_restore_vmx_misc(struct vcpu_vmx *vmx, u64 data)
>  	if (vmx_misc_mseg_revid(data) != vmx_misc_mseg_revid(vmx_misc))
>  		return -EINVAL;
>  
> +	/*
> +	 * We always support HLT activity state. In the past it was possible to
> +	 * turn HLT bit off (without actually turning off HLT activity state
> +	 * support) so we don't fail vmx_restore_vmx_misc if this bit is turned
> +	 * off.
> +	 */
> +	data |= VMX_MISC_ACTIVITY_HLT;
> +
>  	vmx->nested.msrs.misc_low = data;
>  	vmx->nested.msrs.misc_high = data >> 32;
>  
> -- 
> 2.20.1
> 
