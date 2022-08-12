Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A911B590A1B
	for <lists+kvm@lfdr.de>; Fri, 12 Aug 2022 04:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236635AbiHLCCq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Aug 2022 22:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236614AbiHLCCp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Aug 2022 22:02:45 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C99B9C21F;
        Thu, 11 Aug 2022 19:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660269764; x=1691805764;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=jzUh3WcMPF6XtJtmnicjiBzD0RJFVxhx/BSRc0ilpp8=;
  b=F3YO3yCI9jcJXT5wbdLMyZLejLJZf2PFtmA3o42WsoKn3GVYH3gGtZJm
   Ms8eDuMSfAT68uLzjasP0f+FEFOdS5FNV6DgS3ENE05verrNYmILd9IV3
   jSAW6V+7UJUN3+zS9mSGKjMiJ7pu1y6N5nfXz0G0yCsKsmtb4e96LJl24
   SEPWuftkDxE8u2oTyOf/U5H1WDBUSJUYL3aNAHocHWe3ywfSJNHC1U9g8
   c+WzeYDYUcP372FZO/1mte75wjiIts7xNvq1T5iVCcUEJKJudbOz6/LsF
   vLQKe4QJIusX15lJmvozic8s8FemqC4bGgyuDc0VUKKYI7P18ccPHHoyY
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10436"; a="377794323"
X-IronPort-AV: E=Sophos;i="5.93,231,1654585200"; 
   d="scan'208";a="377794323"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2022 19:02:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,231,1654585200"; 
   d="scan'208";a="673924697"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga004.fm.intel.com with ESMTP; 11 Aug 2022 19:02:06 -0700
Date:   Fri, 12 Aug 2022 10:02:06 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Yuan Yao <yuan.yao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Jon Cargille <jcargill@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>
Subject: Re: [PATCH 1/1] kvm: nVMX: Checks "VMCS shadowing" with VMCS link
 pointer for non-root mode VM{READ,WRITE}
Message-ID: <20220812020206.foknky4hghgsadby@yy-desk-7060>
References: <20220812014706.43409-1-yuan.yao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220812014706.43409-1-yuan.yao@intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 12, 2022 at 09:47:06AM +0800, Yuan Yao wrote:
> Add checking to VMCS12's "VMCS shadowing", make sure the checking of
> VMCS12's vmcs_link_pointer for non-root mode VM{READ,WRITE} happens
> only if VMCS12's "VMCS shadowing" is 1.
>
> SDM says that for non-root mode the VMCS's "VMCS shadowing" must be 1
> (and the corresponding bits in VMREAD/VMWRITE bitmap must be 0) when
> condition checking of [B] is reached(please refer [A]), which means
> checking to VMCS link pointer for non-root mode VM{READ,WRITE} should
> happen only when "VMCS shadowing" = 1.
>
> Description from SDM Vol3(April 2022) Chapter 30.3 VMREAD/VMWRITE:
>
> IF (not in VMX operation)
>    or (CR0.PE = 0)
>    or (RFLAGS.VM = 1)
>    or (IA32_EFER.LMA = 1 and CS.L = 0)
> THEN #UD;
> ELSIF in VMX non-root operation
>       AND (“VMCS shadowing” is 0 OR
>            source operand sets bits in range 63:15 OR
>            VMREAD bit corresponding to bits 14:0 of source
>            operand is 1)  <------[A]
> THEN VMexit;
> ELSIF CPL > 0
> THEN #GP(0);
> ELSIF (in VMX root operation AND current-VMCS pointer is not valid) OR
>       (in VMX non-root operation AND VMCS link pointer is not valid)
> THEN VMfailInvalid;  <------ [B]
> ...
>
> Fixes: dd2d6042b7f4 ("kvm: nVMX: VMWRITE checks VMCS-link pointer before VMCS field")
> Signed-off-by: Yuan Yao <yuan.yao@intel.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index ddd4367d4826..30685be54c5d 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -5123,6 +5123,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
>  		 */
>  		if (vmx->nested.current_vmptr == INVALID_GPA ||
>  		    (is_guest_mode(vcpu) &&
> +		     nested_cpu_has_shadow_vmcs(vcpu) &&

Oops, should be "nested_cpu_has_shadow_vmcs(get_vmcs12(vcpu))".

>  		     get_vmcs12(vcpu)->vmcs_link_pointer == INVALID_GPA))
>  			return nested_vmx_failInvalid(vcpu);
>
> @@ -5233,6 +5234,7 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
>  	 */
>  	if (vmx->nested.current_vmptr == INVALID_GPA ||
>  	    (is_guest_mode(vcpu) &&
> +	     nested_cpu_has_shadow_vmcs(vcpu) &&

Ditto.

>  	     get_vmcs12(vcpu)->vmcs_link_pointer == INVALID_GPA))
>  		return nested_vmx_failInvalid(vcpu);
>
> --
> 2.27.0
>
