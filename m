Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5577D558D41
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 04:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbiFXCjl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 22:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiFXCjk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 22:39:40 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D595563AE;
        Thu, 23 Jun 2022 19:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656038379; x=1687574379;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tTlaQaW7c0kd3/JZPP+CUTPrmaNJ7s23LxQHSlHLTuU=;
  b=JYG3y3/1nDCqCd2mF8MSUAkLNd8AiTLzOLtOPxE3aTPuV2BIJ8Sq2AN5
   f/Tq1AP9JUF4w5Y4breDrKsTyiAWn7nDayblLoCxt6MFO2Eu9utb3/z6b
   GSHz+U8r1A79BY0KoiSaZBkV3pXflwKz0QYNzheOiaYiExC+sLKsPk6zL
   EIRHAMpZFSPGNNLNFMsR7tuQR/uLkowXvIs2n0dYf9e1hMDPZF9R8fJa3
   8KJwj6pgBAigoCAMshdnhKOAJQkO+gtmCdBhWaKmP9sWrHX1btXkzYBQu
   GQn/bw2eCZIKe/R18FStPUaUY89zlyFDupp3xWOJdNOUlO/iFLn/k1kAt
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10387"; a="306368966"
X-IronPort-AV: E=Sophos;i="5.92,217,1650956400"; 
   d="scan'208";a="306368966"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 19:39:39 -0700
X-IronPort-AV: E=Sophos;i="5.92,217,1650956400"; 
   d="scan'208";a="593012859"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.23])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 19:39:35 -0700
Date:   Fri, 24 Jun 2022 10:39:21 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
Subject: Re: [PATCH v5 06/22] x86/virt/tdx: Add skeleton to initialize TDX on
 demand
Message-ID: <20220624023916.GC15566@gao-cwp>
References: <cover.1655894131.git.kai.huang@intel.com>
 <c751d1ce046ccc139a8bb34e04d70b1d6bc34a8d.1655894131.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c751d1ce046ccc139a8bb34e04d70b1d6bc34a8d.1655894131.git.kai.huang@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 22, 2022 at 11:16:29PM +1200, Kai Huang wrote:
>Before the TDX module can be used to create and run TD guests, it must
>be loaded into the isolated region pointed by the SEAMRR and properly
>initialized.  The TDX module is expected to be loaded by BIOS before
>booting to the kernel, and the kernel is expected to detect and
>initialize it.
>
>The TDX module can be initialized only once in its lifetime.  Instead
>of always initializing it at boot time, this implementation chooses an
>on-demand approach to initialize TDX until there is a real need (e.g
>when requested by KVM).  This avoids consuming the memory that must be
>allocated by kernel and given to the TDX module as metadata (~1/256th of
>the TDX-usable memory), and also saves the time of initializing the TDX
>module (and the metadata) when TDX is not used at all.  Initializing the
>TDX module at runtime on-demand also is more flexible to support TDX
>module runtime updating in the future (after updating the TDX module, it
>needs to be initialized again).
>
>Add a placeholder tdx_init() to detect and initialize the TDX module on
>demand, with a state machine protected by mutex to support concurrent
>calls from multiple callers.
>
>The TDX module will be initialized in multi-steps defined by the TDX
>architecture:
>
>  1) Global initialization;
>  2) Logical-CPU scope initialization;
>  3) Enumerate the TDX module capabilities and platform configuration;
>  4) Configure the TDX module about usable memory ranges and global
>     KeyID information;
>  5) Package-scope configuration for the global KeyID;
>  6) Initialize usable memory ranges based on 4).
>
>The TDX module can also be shut down at any time during its lifetime.
>In case of any error during the initialization process, shut down the
>module.  It's pointless to leave the module in any intermediate state
>during the initialization.
>
>Signed-off-by: Kai Huang <kai.huang@intel.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

One nit below:

>+static int __tdx_init(void)
>+{
>+	int ret;
>+
>+	/*
>+	 * Initializing the TDX module requires running some code on
>+	 * all MADT-enabled CPUs.  If not all MADT-enabled CPUs are
>+	 * online, it's not possible to initialize the TDX module.
>+	 *
>+	 * For simplicity temporarily disable CPU hotplug to prevent
>+	 * any CPU from going offline during the initialization.
>+	 */
>+	cpus_read_lock();
>+
>+	/*
>+	 * Check whether all MADT-enabled CPUs are online and return
>+	 * early with an explicit message so the user can be aware.
>+	 *
>+	 * Note ACPI CPU hotplug is prevented when TDX is enabled, so
>+	 * num_processors always reflects all present MADT-enabled
>+	 * CPUs during boot when disabled_cpus is 0.
>+	 */
>+	if (disabled_cpus || num_online_cpus() != num_processors) {
>+		pr_err("Unable to initialize the TDX module when there's offline CPU(s).\n");
>+		ret = -EINVAL;
>+		goto out;
>+	}
>+
>+	ret = init_tdx_module();
>+	if (ret == -ENODEV) {
>+		pr_info("TDX module is not loaded.\n");

tdx_module_status should be set to TDX_MODULE_NONE here.

>+		goto out;
>+	}
