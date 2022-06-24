Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3A00558CE9
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 03:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbiFXBli (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 21:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiFXBlh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 21:41:37 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B5AD56C17;
        Thu, 23 Jun 2022 18:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656034896; x=1687570896;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pHZ6e8v+fa1nH+kBXHgGT2nmDCcLtFBwLhaHNFSRyw0=;
  b=eUD9ett603m+kcnJ4GtaawknJa9TbQfdHLwgkuJjtf3bmW2Q2BTMa0sc
   VXAZk06d1aykShqT53ENN4DneIt8AAfrPeAn/fqJgsf39IsabuBqk69eP
   b4BJWdrc3df7oc9LnSWO0xDjFKrs+k+jDYr2meZWfV5Bq+klIso+fHHSD
   FDRj38BDXjEioU4ZSRJ83CPnJPHPDoneOc21acLWoXskAwTIq/anjHTiE
   wSho3b7X0L2A/HVM3tExPdfsfzsw6lDk6Jzbx6AIQGHgUgercaSADvTxg
   /RY4bcypo8xMrcq3U5MVIJIfpRx/aW+YvA3rChBkH+m1bocqa7oeLNiBA
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10387"; a="342580074"
X-IronPort-AV: E=Sophos;i="5.92,217,1650956400"; 
   d="scan'208";a="342580074"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 18:41:35 -0700
X-IronPort-AV: E=Sophos;i="5.92,217,1650956400"; 
   d="scan'208";a="645041375"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.23])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 18:41:31 -0700
Date:   Fri, 24 Jun 2022 09:41:17 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, thomas.lendacky@amd.com,
        Tianyu.Lan@microsoft.com
Subject: Re: [PATCH v5 04/22] x86/virt/tdx: Prevent ACPI CPU hotplug and ACPI
 memory hotplug
Message-ID: <20220624014112.GA15566@gao-cwp>
References: <cover.1655894131.git.kai.huang@intel.com>
 <3a1c9807d8c140bdd550cd5736664f86782cca64.1655894131.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a1c9807d8c140bdd550cd5736664f86782cca64.1655894131.git.kai.huang@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 22, 2022 at 11:16:07PM +1200, Kai Huang wrote:
>-static bool intel_cc_platform_has(enum cc_attr attr)
>+#ifdef CONFIG_INTEL_TDX_GUEST
>+static bool intel_tdx_guest_has(enum cc_attr attr)
> {
> 	switch (attr) {
> 	case CC_ATTR_GUEST_UNROLL_STRING_IO:
>@@ -28,6 +31,33 @@ static bool intel_cc_platform_has(enum cc_attr attr)
> 		return false;
> 	}
> }
>+#endif
>+
>+#ifdef CONFIG_INTEL_TDX_HOST
>+static bool intel_tdx_host_has(enum cc_attr attr)
>+{
>+	switch (attr) {
>+	case CC_ATTR_ACPI_CPU_HOTPLUG_DISABLED:
>+	case CC_ATTR_ACPI_MEMORY_HOTPLUG_DISABLED:
>+		return true;
>+	default:
>+		return false;
>+	}
>+}
>+#endif
>+
>+static bool intel_cc_platform_has(enum cc_attr attr)
>+{
>+#ifdef CONFIG_INTEL_TDX_GUEST
>+	if (boot_cpu_has(X86_FEATURE_TDX_GUEST))
>+		return intel_tdx_guest_has(attr);
>+#endif
>+#ifdef CONFIG_INTEL_TDX_HOST
>+	if (platform_tdx_enabled())
>+		return intel_tdx_host_has(attr);
>+#endif
>+	return false;
>+}

how about:

static bool intel_cc_platform_has(enum cc_attr attr)
{
	switch (attr) {
	/* attributes applied to TDX guest only */
	case CC_ATTR_GUEST_UNROLL_STRING_IO:
	...
		return boot_cpu_has(X86_FEATURE_TDX_GUEST);

	/* attributes applied to TDX host only */
	case CC_ATTR_ACPI_CPU_HOTPLUG_DISABLED:
	case CC_ATTR_ACPI_MEMORY_HOTPLUG_DISABLED:
		return platform_tdx_enabled();

	default:
		return false;
	}
}

so that we can get rid of #ifdef/endif.
