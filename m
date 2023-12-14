Return-Path: <kvm+bounces-4504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AC368813247
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 14:56:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4F3111F21135
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 13:56:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDF77584CF;
	Thu, 14 Dec 2023 13:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KCxd4wLd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 922A2A7
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 05:56:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702562173; x=1734098173;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6jOefrFXMRwcNHeUiKiN3C8daWx8ytPCTnAf310Jdx4=;
  b=KCxd4wLdruAdgy/fLaRIXXv9KSy58GkOXa4j0MSWaiWKbkpamLvo1vfb
   QT9waxVS/wfP+yL+8ydXMDPELbKEQh7Px9mxQX1OhOcF3j7i9PVCgBU1o
   qpDUDifJQHaH00XCXFAQHGKVgcTQCZZOxF1ktCW96PmyX8uOg48RTSY6C
   3LydJ5HK2hUwImiGp693R8L0znseqzX7FcXJCUudZLHUye9DBvS+GJrR7
   c9+BUYTk9/kLhmH7EiLc5ydw6mY1Wl9RxGeJxytQ5R3HggsiDwzH9blfo
   bDgHJ/j22QMx7kzY4KqC3Le1MKjxw49dm58gUanDVTHpOpj4YE1bK7Luz
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10924"; a="1972634"
X-IronPort-AV: E=Sophos;i="6.04,275,1695711600"; 
   d="scan'208";a="1972634"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2023 05:56:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10924"; a="840289972"
X-IronPort-AV: E=Sophos;i="6.04,275,1695711600"; 
   d="scan'208";a="840289972"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmsmga008.fm.intel.com with ESMTP; 14 Dec 2023 05:56:10 -0800
Date: Thu, 14 Dec 2023 22:08:34 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Babu Moger <babu.moger@amd.com>
Cc: pbonzini@redhat.com, richard.henderson@linaro.org, eduardo@habkost.net,
	mst@redhat.com, marcel.apfelbaum@gmail.com, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Michael.Roth@amd.com, nikunj.dadhania@amd.com
Subject: Re: [PATCH] target/i386: Fix CPUID encoding of Fn8000001E_ECX
Message-ID: <ZXsMYtEg+p86tawB@intel.com>
References: <20231110170806.70962-1-babu.moger@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231110170806.70962-1-babu.moger@amd.com>

On Fri, Nov 10, 2023 at 11:08:06AM -0600, Babu Moger wrote:
> Date: Fri, 10 Nov 2023 11:08:06 -0600
> From: Babu Moger <babu.moger@amd.com>
> Subject: [PATCH] target/i386: Fix CPUID encoding of Fn8000001E_ECX
> X-Mailer: git-send-email 2.34.1
> 
> Observed the following failure while booting the SEV-SNP guest and the
> guest fails to boot with the smp parameters:
> "-smp 192,sockets=1,dies=12,cores=8,threads=2".
> 
> qemu-system-x86_64: sev_snp_launch_update: SNP_LAUNCH_UPDATE ret=-5 fw_error=22 'Invalid parameter'
> qemu-system-x86_64: SEV-SNP: CPUID validation failed for function 0x8000001e, index: 0x0.
> provided: eax:0x00000000, ebx: 0x00000100, ecx: 0x00000b00, edx: 0x00000000
> expected: eax:0x00000000, ebx: 0x00000100, ecx: 0x00000300, edx: 0x00000000
> qemu-system-x86_64: SEV-SNP: failed update CPUID page
> 
> Reason for the failure is due to overflowing of bits used for "Node per
> processor" in CPUID Fn8000001E_ECX. This field's width is 3 bits wide and
> can hold maximum value 0x7. With dies=12 (0xB), it overflows and spills
> over into the reserved bits. In the case of SEV-SNP, this causes CPUID
> enforcement failure and guest fails to boot.
> 
> The PPR documentation for CPUID_Fn8000001E_ECX [Node Identifiers]
> =================================================================
> Bits    Description
> 31:11   Reserved.
> 
> 10:8    NodesPerProcessor: Node per processor. Read-only.
>         ValidValues:
>         Value   Description
>         0h      1 node per processor.
>         7h-1h   Reserved.
> 
> 7:0     NodeId: Node ID. Read-only. Reset: Fixed,XXh.
> =================================================================
> 
> As in the spec, the valid value for "node per processor" is 0 and rest
> are reserved.
> 
> Looking back at the history of decoding of CPUID_Fn8000001E_ECX, noticed
> that there were cases where "node per processor" can be more than 1. It
> is valid only for pre-F17h (pre-EPYC) architectures. For EPYC or later
> CPUs, the linux kernel does not use this information to build the L3
> topology.
> 
> Also noted that the CPUID Function 0x8000001E_ECX is available only when
> TOPOEXT feature is enabled. 

One additional query, such dependency relationship is not reflected in
encode_topo_cpuid8000001e(), should TOPOEXT be checked in
encode_topo_cpuid8000001e()?

> This feature is enabled only for EPYC(F17h)
> or later processors. So, previous generation of processors do not not
> enumerate 0x8000001E_ECX leaf.
> 
> There could be some corner cases where the older guests could enable the
> TOPOEXT feature by running with -cpu host, in which case legacy guests
> might notice the topology change. To address those cases introduced a
> new CPU property "legacy-multi-node". It will be true for older machine
> types to maintain compatibility. By default, it will be false, so new
> decoding will be used going forward.
> 
> The documentation is taken from Preliminary Processor Programming
> Reference (PPR) for AMD Family 19h Model 11h, Revision B1 Processors 55901
> Rev 0.25 - Oct 6, 2022.
> 
> Cc: qemu-stable@nongnu.org
> Fixes: 31ada106d891 ("Simplify CPUID_8000_001E for AMD")
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> ---

[snip]

> +++ b/target/i386/cpu.h
> @@ -1988,6 +1988,7 @@ struct ArchCPU {
>       * If true present the old cache topology information
>       */
>      bool legacy_cache;
> +    bool legacy_multi_node;

This property deserves a comment, as does legacy_cache above.

>  
>      /* Compatibility bits for old machine types: */
>      bool enable_cpuid_0xb;
> -- 
> 2.34.1
> 

Just the above nit, otherwise,
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


