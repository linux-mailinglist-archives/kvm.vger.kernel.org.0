Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5905E77DBC3
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 10:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242751AbjHPIIU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 04:08:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242745AbjHPIHx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 04:07:53 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A5B26A8;
        Wed, 16 Aug 2023 01:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692173261; x=1723709261;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KPdktamhAah4Tzj7A9dDY419aZKIxpABZHLmlpCy7rc=;
  b=egU2Q6ylIsbGSRYAyZ4F3iXkDaeJLNvpumBuQ3sSohXnpB+84Jxmnf0k
   BzgzlQm1hoDy3YgkTpp50RAYACLA4nPdpW0G4sWKafkcV7qFb51S6rGyE
   vHo6rmZ/dal8BQ+PSCL7v8PzvShx5kzqgF46nrrlw/9OLMMz+YchR9JVq
   a1FiwBlXAQed0UJvILVe0XqTp0/+FxHxERX8gkineyPn1LrSAzID/dYNX
   yNxi/a5yYC7G/zFp2BdTo0V7nhMbswQCtXggcGXrqxV90Qy4WpiZkegt6
   Yb+UQ5v1gnbw2nglbanMoMbIQemM6xp/yKWHgILKDwwKmhQt43WJHdmqx
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="371379215"
X-IronPort-AV: E=Sophos;i="6.01,176,1684825200"; 
   d="scan'208";a="371379215"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2023 01:07:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="804115129"
X-IronPort-AV: E=Sophos;i="6.01,176,1684825200"; 
   d="scan'208";a="804115129"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga004.fm.intel.com with ESMTP; 16 Aug 2023 01:07:38 -0700
Date:   Wed, 16 Aug 2023 16:07:38 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeng Guang <guang.zeng@intel.com>,
        Yuan Yao <yuan.yao@intel.com>
Subject: Re: [PATCH v3 04/15] KVM: VMX: Check KVM CPU caps, not just VMX MSR
 support, for XSAVE enabling
Message-ID: <20230816080737.zmqfdrlifedjqmw6@yy-desk-7060>
References: <20230815203653.519297-1-seanjc@google.com>
 <20230815203653.519297-5-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230815203653.519297-5-seanjc@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 15, 2023 at 01:36:42PM -0700, Sean Christopherson wrote:
> Check KVM CPU capabilities instead of raw VMX support for XSAVES when
> determining whether or not XSAVER can/should be exposed to the guest.
> Practically speaking, it's nonsensical/impossible for a CPU to support
> "enable XSAVES" without XSAVES being supported natively.  The real
> motivation for checking kvm_cpu_cap_has() is to allow using the governed
> feature's standard check-and-set logic.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Yuan Yao <yuan.yao@intel.com>

> ---
>  arch/x86/kvm/vmx/vmx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 1bf85bd53416..78f292b7e2c5 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7745,7 +7745,7 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	 * to the guest.  XSAVES depends on CR4.OSXSAVE, and CR4.OSXSAVE can be
>  	 * set if and only if XSAVE is supported.
>  	 */
> -	vcpu->arch.xsaves_enabled = cpu_has_vmx_xsaves() &&
> +	vcpu->arch.xsaves_enabled = kvm_cpu_cap_has(X86_FEATURE_XSAVES) &&
>  				    boot_cpu_has(X86_FEATURE_XSAVE) &&
>  				    guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
>  				    guest_cpuid_has(vcpu, X86_FEATURE_XSAVES);
> --
> 2.41.0.694.ge786442a9b-goog
>
