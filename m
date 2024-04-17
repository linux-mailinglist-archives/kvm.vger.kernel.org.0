Return-Path: <kvm+bounces-14934-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 241A68A7CBA
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 09:05:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 50C151C21093
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 07:04:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B58C6A343;
	Wed, 17 Apr 2024 07:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f5BysKlT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9F36A337;
	Wed, 17 Apr 2024 07:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713337484; cv=fail; b=q4qDi0EEzb3/ueYH0XX3FFlYbRtmV2pAfEPERNuscsHTRkjR0MqiXlJVX7LJ1sWiH4odpvpUCBVL+IQBmXOyWXwtx5l7KLkfdDwziTVdgKjlzeOLKcKO7Og7K8Rnd66X59C+o7P+zwRk6PIMpWtmxOwO+LmwVOJCP1L3FeXeyCA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713337484; c=relaxed/simple;
	bh=J9TwtDh8gsFi8Zy7V7NvxLnBevGvf7a3KGnGYd4K7hI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=X+szXCQy6JvL2YusDGuTyfxpTbIWSGBVk5R0Ql2YumNuozGjn9sjZG4bvY7dI/WfeMFyvSNKWC/lhYZQXnRkAkfW9OGK9ggUDvKgqXAi1YXyN/Q8XOpBExT2ilZI8tVe5bk5kXgCJmxgcp4fums5DXImb1KD3dH4cjm+/zyIH7k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f5BysKlT; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713337480; x=1744873480;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=J9TwtDh8gsFi8Zy7V7NvxLnBevGvf7a3KGnGYd4K7hI=;
  b=f5BysKlTAT4T2+oEZ9K0h2jmmN6uWuQIqah+Mc56oBp6vndUW8YbHv05
   A4fZZNxokBTwNsr0BAGRDiWgQ/5jfF7J0hVfczq19CEPPjrSu11l8jxB0
   ipldP/GvUpOkmFpytyzL2POPqK5rmX338jM4tojy0NdU+sDkeMtykcPEc
   CV3MQPCb1tJTyx0Alek49aRhKU8lkKVUQNLpQ2oST63F85meMJkrcU41C
   nnJcG3XvWshcYHmSWiYyevAKAv1VcyK+E9QdbbCs8JRlxAFqGQvMuGgpu
   wzl6BhXIUM3v7uh6PVFVN2LAuCkaq2lbd2R5OzuhMPPOaVzK1mOeXZ/54
   A==;
X-CSE-ConnectionGUID: ynbErGcLS/2QrcBWy2wBQA==
X-CSE-MsgGUID: sasJHOp1T2edw9xtaPge1g==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="20233818"
X-IronPort-AV: E=Sophos;i="6.07,208,1708416000"; 
   d="scan'208";a="20233818"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 00:04:34 -0700
X-CSE-ConnectionGUID: P18VlQHFQfm1/st8qg070Q==
X-CSE-MsgGUID: UOCYhHPsR5G/xln+Khb+vQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,208,1708416000"; 
   d="scan'208";a="53495767"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Apr 2024 00:04:33 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Apr 2024 00:04:31 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Apr 2024 00:04:30 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 17 Apr 2024 00:04:30 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 17 Apr 2024 00:04:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XkN3M4aTZZTRwp+ao5zeRk+cLgYDLBOkMqHEJcAbzYFLaAHNl5rs4HCUK/wLeJW2Zx3v+x4hcMG/dc7JK/kLJ8IwFHMbEfNRDjQC0sDx+96PUhMTMZZUc7gzD3zGlgZIXxbiZ3bNj7b0CO2Sl5RrKqzmorPiBK81JZJbCTF0zWpGiYLyhHEAgGJSpxc8NJP18rsqfLMQ2uJg9kEytKIOtaLKVfU86rRcfT7ZAxGLMXyhxRiy99MjQXyunInq8imR5k5VM6T113B0eLBGfPpUyntkD0Jw1MbZp6HCFWW1D/e/K+4sp1fucvhhxLXmlpBvH/f6jBaAbTJcfZFF/mlUpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sBvoV+IZRFFGVAM0AT/ecXvLvaXAU9yy+W3oXU1fVRg=;
 b=LzZ1TEvtYcU7XOZy8qwu1mbmzNiPu4vn9Us6ct4zeASpMOxdMQKYpSvyCRes0mHMOHNbf4KM2AyZIReB0lWmXWh9m+/beC5UCN8ZOtkPSed8fq95h7bdPP5Q2z4kb7zMYSi0QC3Hr3u8oQ/H9zqC28Ob2FiND8zTISmvt53SWh4bEaeOPwtuY4v51UkVVrW0Fp+0hZi3fghZPtXmpwa+6cAmvVcGdJSWb5bKrJyfaMD/3igiKikDGAkdd+EFTZh+Lfe813fHGjrqkp0z84EnYidyrvzvdMMVrA/2o2LolhspDgtE3mPfI4Mq2dyXvVPtvFY11wMEXl1QQgg1LdumYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH0PR11MB5078.namprd11.prod.outlook.com (2603:10b6:510:3e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.26; Wed, 17 Apr
 2024 07:04:18 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7452.049; Wed, 17 Apr 2024
 07:04:17 +0000
Date: Wed, 17 Apr 2024 15:04:08 +0800
From: Chao Gao <chao.gao@intel.com>
To: <isaku.yamahata@intel.com>
CC: <kvm@vger.kernel.org>, <isaku.yamahata@gmail.com>,
	<linux-kernel@vger.kernel.org>, Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Michael Roth <michael.roth@amd.com>,
	David Matlack <dmatlack@google.com>, Federico Parola
	<federico.parola@polito.it>, Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH v2 05/10] KVM: x86/mmu: Introduce kvm_tdp_map_page() to
 populate guest memory
Message-ID: <Zh90aFh2xr+nEcCQ@chao-email>
References: <cover.1712785629.git.isaku.yamahata@intel.com>
 <9b866a0ae7147f96571c439e75429a03dcb659b6.1712785629.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <9b866a0ae7147f96571c439e75429a03dcb659b6.1712785629.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SG2PR02CA0024.apcprd02.prod.outlook.com
 (2603:1096:3:17::36) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH0PR11MB5078:EE_
X-MS-Office365-Filtering-Correlation-Id: 438b110a-fd77-49d2-f965-08dc5eac9936
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m4EIcE7R/FmVqOy2BA7bjMQa5mgvWV1OCdAVYslF2g0wOAvvKK3Ln+txBPuYYFppYE/ZA9a+wByc60X2lu4cgXZaDAKIYefzBjKYHiHM1+sxADNQE+Wy4LO1hcXRSN3uQUXmd8WGUQBbuYWdiUmX3a7hV12TlSWfY1bbX8wPkfXbKUHJUtqSJSvA0PxBkMKJ1tQ7Gw9HQx/rDsIl5gzAoGSCm5PI5Om6KE7GC+vJamNaVpRddOsJh4vwQf74HYAzN2rZfXDQL2C5R1OnrfAq+AwIMh/s4gJVB09lRVDHaJSCAqs9k91kIrBXlSo+TDa3IJNi0QvH7HU0eW9jTkKIUBgy3kK/B8aK+zHQ7KLJmWWFHA/nszPL1c8Zu7FsdR9O1d4YA1azyAhIk71purxgUcurapJcRi4KTmVkW5AmaE6Psm5O5alqzapuUxN8eI6N64+tJSn85AhdGsyf9GU7AH36Zrk3MbTPSr/Bi+Pjc0ijVtCqaQ7sVuFuy1iotHiRxDQqXL1Jc++0BZDZorl8fqc8FHuI5d5D8e0Uufoq3npiy/mwITFKysbg2cWp5WfdhbCbOAeNjfC0Re6XmtaNxGRvku9U0F9SlB+FEV39ZXvlNONd09yQsBaiiFq494vQbEinfOnk1h+v1aH5n7RdTg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QCrlPFD27o0uiS7ee+phpz5p2GljC8u5JmqlYCu/IYR31RfC0HpyF3zNnXqE?=
 =?us-ascii?Q?qJMbt2aY2EHlCQeLZJVKB2Zu+SVc4QbsUEhvzBKXYymx+C+Bk9Q/f5KRDYna?=
 =?us-ascii?Q?svjMnSUGg6NaeNq05lb80uzrTNsPJXg3InnjR20h/47/6aLscY7F83WtqDH9?=
 =?us-ascii?Q?wPolT9vQcxBYaE8benrKo5rLhm9SJ+ykDnj8W0pmX73Qv2LEs5yZ/dIVrXJw?=
 =?us-ascii?Q?4yx3lZgQ1YA71yvKnwiiHxqqPZ/WTn9KaU18k/Fi8UhfbUC07O6qOJKDvv2k?=
 =?us-ascii?Q?T86cEbZZGM6XwvmQbA0m/1mjKIQBrC0iP0BVQi4uxYRy0k+G2Uv7kxp0arSs?=
 =?us-ascii?Q?O2qN4ETtRcmNg6yPaW0PM+oz0OHB1lsLLcb72+H/17hxBeQivdcEUx3mKZ9K?=
 =?us-ascii?Q?qXt+Y/3Y6VHvKgjFK4rDxhmPlcAcnMF4QgSNEBs+oJ/x/1oNrSwCfQmb3n7l?=
 =?us-ascii?Q?uGYTJ6G5IfSCJ/HhFNraPfTfgTIYCbre7TjWNvxjcFZAAPhkrRxz3I007Sd0?=
 =?us-ascii?Q?UP15kWXFGvdNh4AFxepkNlGiQfUh50TQB19d+NLZ9Xxk89B9MZQ2ngsR/mI7?=
 =?us-ascii?Q?FZuCoBG8FY7CHTGwS8jEibY00T0m0nrlxTiTHkbjLkGMIU+Eua+wN8ft9aXK?=
 =?us-ascii?Q?LHFL7vHjOMCJ3qTaKfzztHEUfOsZkQ/OzaeARjastLNIkyr7XYtkuX9R3d+b?=
 =?us-ascii?Q?v2c8vrMFXmeo/37LVJ6pC8V/eGg4a9Ns8hgD+McQoQMkDLgfXkInNEOZ7PDy?=
 =?us-ascii?Q?WlWS6AllPLywLDfwGtgsfWABnG5zjiLNtibC4WfYh/dfw+pa2htOFJuNRMmn?=
 =?us-ascii?Q?d3uO+4hhdEovtfe+ccnv9BcuJmmmt2AXNuZtsGIk6f/djhDg9t5RajMRDRuz?=
 =?us-ascii?Q?jq4ZWYZPPzR4Q9o8mKxFjosvAk9HlMIL16QsYsiT70owbQHpRbU4RTG8P0yP?=
 =?us-ascii?Q?vkO3877+n+j+CJgca7HVyM7sXVuSG793pDdvoYJLLrMUyJ/4IZratpdhVh6d?=
 =?us-ascii?Q?FsQrMq4fFPa67x4gk2yraqNRTWPFyjgtKIaQpML0ZtfyUNe+K9WYgCnpFEVx?=
 =?us-ascii?Q?AvI8ra/922Vcy5nUO9jIByXeKZhztbejZ0Vj27UdTMdRGbskBGMG7z6FZXZS?=
 =?us-ascii?Q?99GOT683gFDyAO0um0QiOSS2J6xqbg+rlcjEVD6ED2zGyNjmNblFcz1Hy9F7?=
 =?us-ascii?Q?CShCY6CKEkom6hthaZIsT3KoYaV7uwwjsJCr/yth1FlfV1rkNnaIgTd3qVod?=
 =?us-ascii?Q?NJ4BwXfQopEH/CBwQiEXy/JGbYS/CZ66XY0IQ+URUCyk/geVBG7VUqPl0yb4?=
 =?us-ascii?Q?7kuANjgM1uUFcXX4prep0olRY/VGEy3azKpTyXAYxbM6GbGMjIFwVRYmt36m?=
 =?us-ascii?Q?jo97KpFVihVCHUD5WCBoA1gC4i0q4kIZ7Brk/TQketJmEU5tHj8xfi1IoN9L?=
 =?us-ascii?Q?4DT//ALst5gYViMTTSRjurlhl10pQHVfyRAgNn4u4UAISRB353J1DbiFXcfG?=
 =?us-ascii?Q?5b92gOIHixPHuF2GgsiEiLWtLbtqJBYTT9EycHqH3b7Q+gn0XBmIB5jGFZRt?=
 =?us-ascii?Q?2/sgquEXoP8X1k0+EINn9C3+f1fhEQ/mjCFkfD4M?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 438b110a-fd77-49d2-f965-08dc5eac9936
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2024 07:04:17.8997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eQuoygMToiYShLSSHtoNoeizZOVLDDG6V77qJfGP2JRbRoszCvlRK+3quqmS+wwd9KNisK9I7WKAMU+wFn/Beg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5078
X-OriginatorOrg: intel.com

On Wed, Apr 10, 2024 at 03:07:31PM -0700, isaku.yamahata@intel.com wrote:
>From: Isaku Yamahata <isaku.yamahata@intel.com>
>
>Introduce a helper function to call the KVM fault handler.  It allows a new
>ioctl to invoke the KVM fault handler to populate without seeing RET_PF_*
>enums or other KVM MMU internal definitions because RET_PF_* are internal
>to x86 KVM MMU.  The implementation is restricted to two-dimensional paging
>for simplicity.  The shadow paging uses GVA for faulting instead of L1 GPA.
>It makes the API difficult to use.
>
>Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>---
>v2:
>- Make the helper function two-dimensional paging specific. (David)
>- Return error when vcpu is in guest mode. (David)
>- Rename goal_level to level in kvm_tdp_mmu_map_page(). (Sean)
>- Update return code conversion. Don't check pfn.
>  RET_PF_EMULATE => EINVAL, RET_PF_CONTINUE => EIO (Sean)
>- Add WARN_ON_ONCE on RET_PF_CONTINUE and RET_PF_INVALID. (Sean)
>- Drop unnecessary EXPORT_SYMBOL_GPL(). (Sean)
>---
> arch/x86/kvm/mmu.h     |  3 +++
> arch/x86/kvm/mmu/mmu.c | 32 ++++++++++++++++++++++++++++++++
> 2 files changed, 35 insertions(+)
>
>diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
>index e8b620a85627..51ff4f67e115 100644
>--- a/arch/x86/kvm/mmu.h
>+++ b/arch/x86/kvm/mmu.h
>@@ -183,6 +183,9 @@ static inline void kvm_mmu_refresh_passthrough_bits(struct kvm_vcpu *vcpu,
> 	__kvm_mmu_refresh_passthrough_bits(vcpu, mmu);
> }
> 
>+int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
>+		     u8 *level);
>+
> /*
>  * Check if a given access (described through the I/D, W/R and U/S bits of a
>  * page fault error code pfec) causes a permission fault with the given PTE
>diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>index 91dd4c44b7d8..a34f4af44cbd 100644
>--- a/arch/x86/kvm/mmu/mmu.c
>+++ b/arch/x86/kvm/mmu/mmu.c
>@@ -4687,6 +4687,38 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> 	return direct_page_fault(vcpu, fault);
> }
> 
>+int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
>+		     u8 *level)
>+{
>+	int r;
>+
>+	/* Restrict to TDP page fault. */

need to explain why. (just as you do in the changelog)

>+	if (vcpu->arch.mmu->page_fault != kvm_tdp_page_fault)

page fault handlers (i.e., vcpu->arch.mmu->page_fault()) will be called
finally. why not let page fault handlers reject the request to get rid of
this ad-hoc check? We just need to plumb a flag indicating this is a
pre-population request into the handlers. I think this way is clearer.

What do you think?

