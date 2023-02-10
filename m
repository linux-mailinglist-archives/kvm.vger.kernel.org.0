Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93F26691FB1
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 14:23:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231923AbjBJNXm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 08:23:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231733AbjBJNXl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 08:23:41 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F0A55E79;
        Fri, 10 Feb 2023 05:23:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676035420; x=1707571420;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nMiwTlUb2dZYquuv5q+Pm4KMCujCAj49zyBCfvgnR3Q=;
  b=QZ5LY7F+k38iBMKsFefXJhxgFk/o5E3dfhmr+ullycR0g/aMUsPmUPDJ
   kzfSw6peLeERXwwlyVVew5cmvA4bN3ECJHFiLHLgwbppFkuB7REZ3EGyu
   N8sJZLxbTA2VGTUu/5psgGCsfPmt4qsinwwwbv7vhssRB1jsdbwPraFy6
   wb0ClxOpiAbESMi7IODMhAJ16Nm36MaTVqlYS9rWem3XjJZ1o6iMRkq7i
   XbmeaLOoTca5lecTt+/AiD3PLUXVkJvmd0mxaBoo2ONTJhtyqOb7B8Lat
   mTMpIT//bf6gTePqqjX4/ydp5KCJsYgMb+kN0BC/BbS9p4R6GEzCfIp6o
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="357816481"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="357816481"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 05:23:40 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="776920844"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="776920844"
Received: from linheidx-mobl1.ccr.corp.intel.com (HELO localhost) ([10.249.175.125])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 05:23:37 -0800
Date:   Fri, 10 Feb 2023 21:23:35 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Aaron Lewis <aaronlewis@google.com>,
        Weijiang Yang <weijiang.yang@intel.com>,
        Like Xu <likexu@tencent.com>
Subject: Re: [PATCH 3/6] KVM: x86/pmu: Use separate array for defining "PMU
 MSRs to save"
Message-ID: <20230210132335.nrahzzhv62vegey4@linux.intel.com>
References: <20230124234905.3774678-1-seanjc@google.com>
 <20230124234905.3774678-4-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230124234905.3774678-4-seanjc@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 24, 2023 at 11:49:02PM +0000, Sean Christopherson wrote:
> Move all potential to-be-saved PMU MSRs into a separate array so that a
> future patch can easily omit all PMU MSRs from the list when the PMU is
> disabled.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/x86.c | 153 ++++++++++++++++++++++++---------------------
>  1 file changed, 82 insertions(+), 71 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d4a610ffe2b8..9b6e1af63531 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1419,7 +1419,7 @@ EXPORT_SYMBOL_GPL(kvm_emulate_rdpmc);
>   * may depend on host virtualization features rather than host cpu features.
>   */
>  
> -static const u32 msrs_to_save_all[] = {
> +static const u32 msrs_to_save_base[] = {

I guess the comments relating to msr_to_save_all should be updated as well. :)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 186cb6a81643..4bce96cd615e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1413,7 +1413,7 @@ EXPORT_SYMBOL_GPL(kvm_emulate_rdpmc);
  *
  * The three MSR lists(msrs_to_save, emulated_msrs, msr_based_features)
  * extract the supported MSRs from the related const lists.
- * msrs_to_save is selected from the msrs_to_save_all to reflect the
+ * msrs_to_save is selected from the msrs_to_save_base to reflect the
  * capabilities of the host cpu. This capabilities test skips MSRs that are
  * kvm-specific. Those are put in emulated_msrs_all; filtering of emulated_msrs
  * may depend on host virtualization features rather than host cpu features.
@@ -1516,7 +1516,7 @@ static const u32 emulated_msrs_all[] = {
         * by arch/x86/kvm/vmx/nested.c based on CPUID or other MSRs.
         * We always support the "true" VMX control MSRs, even if the host
         * processor does not, so I am putting these registers here rather
-        * than in msrs_to_save_all.
+        * than in msrs_to_save_base.
         */
        MSR_IA32_VMX_BASIC,
        MSR_IA32_VMX_TRUE_PINBASED_CTLS,

For the comments of emulated_msrs_all, after renaming msrs_to_save_all to
msrs_to_save_base, maybe we do not need to take pains to explain that? 

B.R.
Yu
