Return-Path: <kvm+bounces-60484-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B1A9BEFBFF
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 09:55:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C4CAE189CD57
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 07:56:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 181CC2E2822;
	Mon, 20 Oct 2025 07:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FIL0PcC5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56BA32D7D2E;
	Mon, 20 Oct 2025 07:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760946930; cv=fail; b=Gy4WUBmrBZeY1iH/TTTDqyvCEpO73YttgUUsoGEu3ormgP1JJWg4fkNcRWeS7yOY6NCwA61A4kSCkAheHT7Ci4FabqptGi5UL8d1fX5iIxeY76YWyzyCdvaixThNsD8JgZggyPmzZdM686dOPrmb92bRIPIyuEcBumZQgMcJ+/U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760946930; c=relaxed/simple;
	bh=X5AWX43RMm1OZKI/GrjkeMTeZDOhvpy7WAigpZQ++9E=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qLtVTvXV1gsK7Y7pwpcxOAlgESSfiExKDHyIbnQN7a6g77Fu29cJzGsHy9c3VLeBRGOBmdmk08lCqhxXo1qwvobOZo4oRjVITGXu2HshjdEYJO9B2p1XY2pXDR3TH0yPI5E3UgShTXTPtQH6CaOyCIABKk5b6EUckpN+YkPxIv0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FIL0PcC5; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760946928; x=1792482928;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=X5AWX43RMm1OZKI/GrjkeMTeZDOhvpy7WAigpZQ++9E=;
  b=FIL0PcC5WcHDJgHT0ud0kiCUnUnfnyZRqeJ4RXZbtunfQoByNim+NaWq
   aCx1Nqr3w0EwyJPhd6mkltarI8OnSdoE3GPrk4/8Lg/DAaewC/SsGg1iI
   U/Xfd/oKJA38gnNhREA+Hw15116tHka/EhVLBM1m17oZcHg9UgGbC1N6X
   xnhFoHB0hPZB+5rGJbsTszHxjZJwO66Y5yJFD7CB1YRi1g+/RVW+NGOUF
   yLmhyiG+1JbRPEfCdRPbghqKl7FzoE6kJ4mgtlRL7eXQSfeS5el3BFg2J
   6VZjgDWaqKehFk3X04Ph3Ng1XDpEDBAXZ3494FwmhRl23KjWrToh4QmN6
   A==;
X-CSE-ConnectionGUID: STeO77WrQ0u9hhnvb7LX1Q==
X-CSE-MsgGUID: TKTzAkfoTieyNrBvKADCjw==
X-IronPort-AV: E=McAfee;i="6800,10657,11587"; a="80499266"
X-IronPort-AV: E=Sophos;i="6.19,242,1754982000"; 
   d="scan'208";a="80499266"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2025 00:55:27 -0700
X-CSE-ConnectionGUID: 7z0Mz9FSTBek1T5haN2FNw==
X-CSE-MsgGUID: gGTGvplSRgCmdIBJHMDN3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,242,1754982000"; 
   d="scan'208";a="183752584"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2025 00:55:27 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 20 Oct 2025 00:55:27 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 20 Oct 2025 00:55:27 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.4) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 20 Oct 2025 00:55:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cNODvXP+rvF0/N2M4smOlp8Trw45lO7ry+mKV6zPa+NwIDWqQrWc3jH0pXy2hbT0k0cHFPWzPiDUkw63baY/m8ydD8DAl90dGNwyDlj9rbiquLcvkCBlWiSEDZ1gRiegEG9KRzRtYorO3/OkJBCIWZ37pNvOQKSn1QaZaAk5gyZUAkhft4nOgJ8BJ3tTWebsj2592cICucncl4qVmri96FpDXzPqRbMcdWX28TiPuxUaaMlOqchIvZmx8xeI48FiPNd4kXpl0LeCCraGJtQOeofpyHygH4AsT3FGBs7e3b3JNQYU+tHJT5qpGpG7Q9Zq7s7MTzTiefTfjIaQ7uVAaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a/doL4dcYE5CVj1cGtB1wHTzy24qaUl/dBgqIZZejAo=;
 b=a6ZNGcMcxfnewBFQJoxzxT85D3gNBpIe6DNERISU1EZfGy8YHPX3joeKuhbiO/6LTeBVt9oJWvRabtKvI2vw2M17g5NFEQRqy/0fV0J0QtnHtpoYcUyTIMdROngC+xsjOu09VXUEiBuG8aj/Obnixy33PKet1wbaq+dIDXIRTXAv5LWFM3WDjnyPxOlNdowpbKHpRIDDwu2z3jz2ifqIhMX2ti4XI56g98wdfG2QN1Qhr17xdxqJP//+EM+OEvUdR2WKfOunTy/DA1FOg/Qx38BzZ6bnaCUNX+rczWhb+gC9OAT9YJGT47U+rs8k3acfsNjYtxiTRyFtKx1pvFUv4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM3PPF1CFCD9AEC.namprd11.prod.outlook.com (2603:10b6:f:fc00::f11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Mon, 20 Oct
 2025 07:55:24 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9228.015; Mon, 20 Oct 2025
 07:55:23 +0000
Date: Mon, 20 Oct 2025 15:53:34 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Hou Wenlong <houwenlong.hwl@antgroup.com>, Paolo Bonzini
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Xiaoyao Li <xiaoyao.li@intel.com>, Rick Edgecombe
	<rick.p.edgecombe@intel.com>
Subject: Re: [PATCH] KVM: x86: Drop "cache" from user return MSR setter that
 skips WRMSR
Message-ID: <aPXqfvFtT7CchfN+@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250919214259.1584273-1-seanjc@google.com>
 <aNvLkRZCZ1ckPhFa@yzhao56-desk.sh.intel.com>
 <aNvT8s01Q5Cr3wAq@yzhao56-desk.sh.intel.com>
 <aNwFTLM3yt6AGAzd@google.com>
 <aNwGjIoNRGZL3_Qr@google.com>
 <aO7w+GwftVK5yLfy@yzhao56-desk.sh.intel.com>
 <aO_JdH3WhfWr2BKr@google.com>
 <aPCzqQO7LE/cNiMA@yzhao56-desk.sh.intel.com>
 <20251016132738.GB95606@k08j02272.eu95sqa>
 <aPD173WPjul0qC0P@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aPD173WPjul0qC0P@google.com>
X-ClientProxiedBy: PS2PR03CA0007.apcprd03.prod.outlook.com
 (2603:1096:300:5b::19) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM3PPF1CFCD9AEC:EE_
X-MS-Office365-Filtering-Correlation-Id: b5227d32-e3b4-48ce-62ab-08de0fae062b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?bjUNdmyKlQJD5+WRtbgIQ6UjxJBmZ9xdX6SgaJCDoQfFhb0E/b8qk8Rqe9WF?=
 =?us-ascii?Q?r84O7kWM/oOGDjnttNziFDsmrm9eop5gH0eSn40VEWsULt5iQmFq+8UjrEA7?=
 =?us-ascii?Q?U6mt9Qel/xP6IQySZ260us6kxRhVtudAXP55bs+jqI0oCwl5fZf+wCwHMy0Z?=
 =?us-ascii?Q?HdrGygUYtgdIjGO2cHabSdc1ymDhR26KELJG1sEhamhfNcKkKCy8qOcHqE01?=
 =?us-ascii?Q?DDwGmtshT+slz+KsUdZEyuPJE+GwSvu/A0dCE3z3AdgtHJzSkvyV1MzPPFYs?=
 =?us-ascii?Q?epGctWdwq0Ros77fIT+rXc55uqzBnRRtd1TBnEA8CIgdlf6VkLcoMW9P1LfZ?=
 =?us-ascii?Q?9CatjA+D/vxw3QrvON5eHbU18gGozGmIMX/wlQbdU+7mBEPUfkVtUr/PhkPl?=
 =?us-ascii?Q?4Hd4ne2jYhFYXSekcgK9mxkzwb9o3U0q/dLfabAZnHLp42HmmRcjEOa5Soo5?=
 =?us-ascii?Q?g9twcYQPdSruNoNNuYKogKn9Ukaapsb+iL3fqTWXGf4ene01ENsnU17lZZjK?=
 =?us-ascii?Q?aEjV2s6cU7SXC84kXYUCu06OYOLeMyygktS6HujVpvVJbO4sX6bJyJTPSvIf?=
 =?us-ascii?Q?VbXKBoPYJo7b7pEduHlucHlOiyevzmRPiO7R2N85BelGiWkLCeuHtOg6fJjQ?=
 =?us-ascii?Q?Ah9fJCiMJX0HlX3fjidcyBHIjwwDkoisx7EGsagtlT+NCqYQhLKYvz2nG3Rg?=
 =?us-ascii?Q?idNsBjI8QDUAD1BP/hFetDZ0QoTj0TlNWlZWwQ1IfGliVoYeQ/fbwI35wVGr?=
 =?us-ascii?Q?e45qpjevev6mbf5y/IyxKgt+XDM76wh5P/BqINs9IMmqPe/mSQwYuRvZaRqb?=
 =?us-ascii?Q?FQucINjItfyHrxoedtBehAqg80yLtYwesiMMOlayfAyvz1d7tsI5u5qlnhib?=
 =?us-ascii?Q?2f0r0s/j/PpY+QoKSvvn31bDe7p05DYZh1ngANh5JqNsU4Iizd1GIxmlu7jF?=
 =?us-ascii?Q?yumVLjQqDO3xkF1aEQ8m8g3j3iaS7svZuQl/R+8YY9Y358eQVcap+KBN6Tkf?=
 =?us-ascii?Q?Rww/ByIE8hCVUzqSVH8T7baAfFBO6R4SPzkOx6VdWqzr9UsO0IO+pRPE9sVY?=
 =?us-ascii?Q?NXFdsdfKUGxLKO3MRVCMz4Ic7z2dywXjXGKoIfxG4F5zCpihGzoQTxO0OGXv?=
 =?us-ascii?Q?NPOLZEWDt9h7vOoZAU+iQCjlCPAISngneSfISFVxvRE9UP7YkfKrg6EuwxSN?=
 =?us-ascii?Q?blOxL04kS1N2wb3BSjKtQVTNvL/iMTyijfE7BDhha8vHAP4Qaf9URbcENxsK?=
 =?us-ascii?Q?+YJyn1DeTCk1Q5y5cVxbYYPv+zt4ekYx0icHGt9Oo7d/ORBXTPTCx6Blv1WU?=
 =?us-ascii?Q?l7MhTgbosA0edFaWjv3TJrqf2NVURkAiE34iW6W1uKBBxHYYLrKOkiYBIMZv?=
 =?us-ascii?Q?6BjzHa6RRk14MtROMqyx9scGt7Qubn6di/etxNdzPNa2VvfZ4odGsrrYOUrc?=
 =?us-ascii?Q?QoqDfEk5epGiaaEIfVzG8TNpFO/AI37cZSWle5xloYMF7WnoVLJFbg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XwryZEbv5MzijmQ9n6435OeoOQSdcoxaHxMEEiZ1FXNXy/o160X+cr+E6kcc?=
 =?us-ascii?Q?OlOWrIs0jZ7dF86JsbQIDDj7APZTYSEN/aLWFL1G/Vt/X4YWd2A05KHTC33D?=
 =?us-ascii?Q?2HHQSHe7uoEJbzkSKFXEOL4YMts9DgmPA6RRVJrOc2Nc2pyuTQfnlqGZr8Io?=
 =?us-ascii?Q?Y0Ss3dagz8Jd2ey4/fLE/P3iwahgWgbeJbcXfTEp6ieBzdGDq1EmiFBeCyWH?=
 =?us-ascii?Q?N5q3wHa41ZVYOrkOYcvqWYjVm1hw4ytPIkdTfkIWDlU+2fIPa1BjQeumxKyD?=
 =?us-ascii?Q?kjOiCwBKM41eXjabN7f2vg3040b89wjm/koQCm6iZwE1tv5XRMm8hVK2i48d?=
 =?us-ascii?Q?GnhtaieBXssZARvuxnzpFnnRA9vSMBDp1oOYHC4KYPMWp1KrehESchqALnvs?=
 =?us-ascii?Q?ZUn0xFiabObiFmmZR+h3GYlJwG/21oIM1igMk9pFa3A4mTDRBbw0FTqg4uhZ?=
 =?us-ascii?Q?sLKsoXNJACW9t+6sfkPU62uMjHoFXOj2jzDrO+YmhZxQLT+r/kPWel6dGmut?=
 =?us-ascii?Q?C73b1uqQzOG+dNAbfV5kNKjZtMB5EnGTP4++ZfYmuijMZ3t9iaw8ycMQ3keX?=
 =?us-ascii?Q?3beo10/xcphv0gBHmfflaqbONQStASauJ89TzpK1PB5MRBih+qsUU3Abgake?=
 =?us-ascii?Q?bTKEgR+EIypRbFSYjnB5L3nkA1qA16UzkpArxox1Oz3Bg9MPA/EnD4sfXWzC?=
 =?us-ascii?Q?AhGWvtUDan2Df3BEd9TzWN/3zoUxZmkZm5coo4dRraZpMCYsQl/poFWhEAN1?=
 =?us-ascii?Q?U0PTvB0mib1DGv/8Awx/IdfahV3JDzOm2bold+JZMIOV/GBBGT0m8LvkIxop?=
 =?us-ascii?Q?XgV/vI8ac1P+Q0zwb44r/A8haRKZ+aL7XFAJ/0U3++GdXggZje8x99axiMr0?=
 =?us-ascii?Q?9wqZYDPtdAso82JGd7SQg4j1ZVa/W1NL0wvT841EHDyGHCAt6p+YmEl34OqS?=
 =?us-ascii?Q?BRNke/qwc0wnuqYc491+Zj2cQCQOUQ5L8u9iTj2kxXMJS8b1As6bcRJHyhAe?=
 =?us-ascii?Q?u3sthBAuqqJ2gtAyR3ZFyZshO7/bpXsGg7eNiBgyOuFEcpInaV/K/oPY6Yr5?=
 =?us-ascii?Q?5vEFyaWCi+mrHZYPwyKQ7zCL785GDOuCj8eQkJJkbKM7uTsvNKPCt/oW9Nz1?=
 =?us-ascii?Q?hJu2SkFZzQ/sJLrUd/qJre4D83UgmFImrCPKQzCGwv5Nxv3F/bQ/wnxLQTuc?=
 =?us-ascii?Q?rpH7gw9v6DiqDmHnCtDo05+HRed0rYG5UsFN5DfI8A7YyVVkNvHRrcNZH2mT?=
 =?us-ascii?Q?4kiYLD5BazKEHiiW2EK2VKy6FC9ufntLu1c/zzQn0guUUQzhas0nFwmu2JdA?=
 =?us-ascii?Q?XqT93s0j8Mm1Ntxm+gccTyC117ZiygOxL3C6+PT8B55uq9RTGH+frjS0dWx0?=
 =?us-ascii?Q?iCQ/dIN957FtpgHCBXnpy73R/8eGENkOpwv8LrBfeXppsGNanUw9IX7sIgMl?=
 =?us-ascii?Q?1thw592wJjnNfTzTA3XmUQrrR4iDv939y4uHI9v41+B7ZNNSBadaj8JBorUR?=
 =?us-ascii?Q?f1u/6rNUo28eQJ+9pYbtXOXD4WCbB+sWqBt+jAEwKJid0ySORlLFqQaWTYy1?=
 =?us-ascii?Q?1ItF86gDWzsxUyuqyKpTJKqIxA9jUMsia500LRyx?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b5227d32-e3b4-48ce-62ab-08de0fae062b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2025 07:55:23.8424
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bW3RxxqfPTKfc8jSnfiNqS+4om28vTJmqmT2xdxvZZoar/TKccO7PzTeM9AdayszUvhH6dODvtuHuqcDTd9Ocg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF1CFCD9AEC
X-OriginatorOrg: intel.com

On Thu, Oct 16, 2025 at 06:41:03AM -0700, Sean Christopherson wrote:
> On Thu, Oct 16, 2025, Hou Wenlong wrote:
> > On Thu, Oct 16, 2025 at 04:58:17PM +0800, Yan Zhao wrote:
> > > On Wed, Oct 15, 2025 at 09:19:00AM -0700, Sean Christopherson wrote:
> > > > +	/*
> > > > +	 * Leave the user-return notifiers as-is when disabling virtualization
> > > > +	 * for reboot, i.e. when disabling via IPI function call, and instead
> > > > +	 * pin kvm.ko (if it's a module) to defend against use-after-free (in
> > > > +	 * the *very* unlikely scenario module unload is racing with reboot).
> > > > +	 * On a forced reboot, tasks aren't frozen before shutdown, and so KVM
> > > > +	 * could be actively modifying user-return MSR state when the IPI to
> > > > +	 * disable virtualization arrives.  Handle the extreme edge case here
> > > > +	 * instead of trying to account for it in the normal flows.
> > > > +	 */
> > > > +	if (in_task() || WARN_ON_ONCE(!kvm_rebooting))
> > > kvm_offline_cpu() may be invoked when irq is enabled.
> > > So does it depend on [1]?
> > > 
> > > [1] https://lore.kernel.org/kvm/aMirvo9Xly5fVmbY@google.com/
> > >
> > 
> > Actually, kvm_offline_cpu() can't be interrupted by kvm_shutdown().
> > syscore_shutdown() is always called after
> > migrate_to_reboot_cpu(), which internally waits for currently running
> > CPU hotplug to complete, as described in [*].
Got it. Thanks!

> > [*] https://lore.kernel.org/kvm/dd4b8286774df98d58b5048e380b10d4de5836af.camel@intel.com
> > 
> > 
> > > > +		drop_user_return_notifiers();
> > > > +	else
> > > > +		__module_get(THIS_MODULE);
> > > Since vm_vm_fops holds ref of module kvm_intel, and drop_user_return_notifiers()
> > > is called in kvm_destroy_vm() or kvm_exit():
> > > 
> > > kvm_destroy_vm/kvm_exit
> > >   kvm_disable_virtualization
> > >     kvm_offline_cpu
> > >       kvm_disable_virtualization_cpu
> > >         drop_user_return_notifiers
> > > 
> > > also since fire_user_return_notifiers() executes with irq disabled, is it
> > > necessary to pin kvm.ko?
> 
> Pinning kvm.ko is necessary because kvm_disable_virtualization_cpu() will bail
> early due to virtualization_enabled being false (it will have been cleared by
> the IPI call from kvm_shutdown()).  We could try figuring out a way around that,
> but I don't see an easy solution, and in practice I can't think of any meaningful
> downside to pinning kvm.ko.
You are right!

> I don't want to leave virtualization_enabled set because that's completely wrong
> for everything except x86's user-return MSRs, which aren't even strictly related
> to enabling virtualization.
> 
> I considered calling drop_user_return_notifiers() directly from kvm_exit(), but
> that would require more special-case code, and it would mean blasting an IPI to
> all CPUs, which seems like a bad idea when we know the system is trying to reboot.
Agreed. Thanks for the explanation!

