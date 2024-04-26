Return-Path: <kvm+bounces-16030-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D73F98B3359
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 10:52:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 63D181F22EBD
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 08:52:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7210213C9DE;
	Fri, 26 Apr 2024 08:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kKiz7J6J"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E232AF02;
	Fri, 26 Apr 2024 08:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714121535; cv=fail; b=ClCXR3rL+LUB68rHjcg5BgyjTXHTTNUXpDI1LlTqHlyrSG4PcY2NG83dGej1tHWYb/Fa1f+GwnckdP4gQbSVz5aClTwVNia+Vcn665L2G7TXo9ockV43DhMjatZzGH04pYUp6ayrdnXP9fS4zN/ZbGxGolNdZFsD2rSk5orSoxs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714121535; c=relaxed/simple;
	bh=xgHUUbrdOCR9lT1e2NzNbK3bMQ2blYmmGiM3uboIr5Y=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FkuvLwSSu5+lJ9bq0ptgnZere6+dd5CPgE5oubIsO14MkN9wFw57ZzHOTBB0UFUS43LxHDiwgqcWxLhJ9ZZp0RWrpE/9gI/NUDK8xeqKu7ERK3wQVHJlmVwy92x78YCb/TdnDoE81PDFiFv0am5vTbi5v+cuU5XIsEH0Eth7Nng=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kKiz7J6J; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714121534; x=1745657534;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=xgHUUbrdOCR9lT1e2NzNbK3bMQ2blYmmGiM3uboIr5Y=;
  b=kKiz7J6JLXhQ3tXh9NLaVBLx8Wl9e6DqbDGfHCba6fxLQe5UtHcsPpwA
   i45h/7crF7+bpcpP+kJ34N+tCAB4iIPkf/7r4idlZrfne1YvBipIxmfzL
   LzbOiMKHDCgB7JfgZuXQwywPwEf0DvqY7k7z6he2OuXShWuXYIhNRz/o3
   SCou/pbt3cJtBQcYYCOrECHl6LUzUAhNekkfMl9Dab3GoimIM1XxOs7Kx
   oAzaJfVxtzFCaLUcR3pPjD2z9lr6k0YaEIGJTvptfzms9H5gu88v7jusf
   vflYHLcPUE4BZY1uMFV78qGJhXTIsSaPz7Cm1//5GHMhFosK/MZUBVcr/
   Q==;
X-CSE-ConnectionGUID: 58L4fXj2R92wiAMjmXogNQ==
X-CSE-MsgGUID: gtkO9f18RTKgSDLh6xc9rw==
X-IronPort-AV: E=McAfee;i="6600,9927,11055"; a="10065085"
X-IronPort-AV: E=Sophos;i="6.07,232,1708416000"; 
   d="scan'208";a="10065085"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2024 01:52:13 -0700
X-CSE-ConnectionGUID: oxPQXM1oQ+eMfZMsRUx6JA==
X-CSE-MsgGUID: rNlIp1jdSQaf6HOG2zTWRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,232,1708416000"; 
   d="scan'208";a="25364995"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Apr 2024 01:52:13 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 26 Apr 2024 01:52:12 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 26 Apr 2024 01:52:12 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 26 Apr 2024 01:52:12 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 26 Apr 2024 01:52:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gYsgee1k6Mz/87jHi63FRAJWIV0JAcsNRL6BVaFnDPchx5sfGaVrWoa9g79USdclaqQpxN4BKpoPX2TCu8qK46eQiWQj5d14oL7O9Oc+piGmBb3jZczae3TeYTzYpnQTc2XejGdHoe+luXvamV/JrUwnWlTDzZKa7rqIJW9w7Fwo6ERKyv9djDCYaaclQBb/jwnTvRs9hv7IvT4niHmmD6d2GWV4dYYgWBO8bFDvYE6l7p2AkcoKdY3wSXF1mHSpYMV8A5IAgSv4fiIR32x4gmyr8BBobx3265aTF8V2Y0J0WXj7EmLG6YAeJGt+nteUQYnrpJdR0AYqvI92Xlp0AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PENDNBNTYCzPWhj3+btT4LKBoY0znxC4kUtThYKufsE=;
 b=PtA2gGg3r7Sh+inAvc/goRRsD908JZcfQauK+cT+ujTWHtyq9GVUTHITbxDvRwR8Yk3ErDsAgNiVQotYkGI9EyUXKGH8RrqWWjJDEuJ12B4pJ/3+OsYpAJASvhdQNdYO2fh7SMUZAZZv2O24Pi+triCogEigy3hUHo4bZ6DqP+fcZDDozKkrKbzc0XpDwteWIcvOvSTrIyP8PFpM4XGyriNY7yjCRB1gJYTTA6+q6rErX+NqEduFS9ZEkwCiNHxfeQ8jlfWHF1qeIgz3cc1H/Ct8f1sApLl90QMcixh5/trftzqbXngoPy/rBYC92UReTTT2UTnB+2L7x+1qChgLrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by MW5PR11MB5787.namprd11.prod.outlook.com (2603:10b6:303:192::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.22; Fri, 26 Apr
 2024 08:52:07 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7519.030; Fri, 26 Apr 2024
 08:52:07 +0000
Date: Fri, 26 Apr 2024 16:52:00 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] KVM: x86: Register emergency virt callback in common
 code, via kvm_x86_ops
Message-ID: <ZitrMAplXSCKrypD@chao-email>
References: <20240425233951.3344485-1-seanjc@google.com>
 <20240425233951.3344485-3-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240425233951.3344485-3-seanjc@google.com>
X-ClientProxiedBy: SI2P153CA0012.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::15) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|MW5PR11MB5787:EE_
X-MS-Office365-Filtering-Correlation-Id: cb71c5bd-e8c5-42a1-5774-08dc65ce2730
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?2GcPvLk6OvRdIXQP3h07txmwHizSBoI56ZMlxjqCD9owyLgumepgBySMgUlw?=
 =?us-ascii?Q?EBGQN7pOsE0k6hnzZDRwsUZBLVXyrshSrOEkKlgxvEbYz8gvRWBEF2+6G4iJ?=
 =?us-ascii?Q?zFjOcvE7/kSLe3qy+X4PnAB36sSnu2lVonQlVpKRe9xZSnoQrYDcplIJTFLB?=
 =?us-ascii?Q?dCxaX/XthlooD/rKQwkGTLMesGsiS8eaVZVnoYK1uxwoP7IFgdXY36fcgaEi?=
 =?us-ascii?Q?L3f3PFjaPaI145WjBftxth62e5KvdQ/sTygOCRgnT1AyBzg5aRjxvL0Tywm4?=
 =?us-ascii?Q?uaPktwS0xxUWBHcAH0lBHdopuuBhYg699p4nJ4OyFg/jD+T4JZZcRpuP4WLm?=
 =?us-ascii?Q?RDlJCrWyYfu6f2V3nKfaaIGYriZmh9Dq70o9LdRCtDw+7fCXCEcKWW9lSCCb?=
 =?us-ascii?Q?0Cr/9/Dl4bZfpz8MSsdClOU/JPFmdlrCiKaTmnDXVTby6yrjPom456efLGFR?=
 =?us-ascii?Q?L18Jd1fGj58t9J4eCsoZNn+FRvuml50OTaOdC4nku+UTQ84DvFd8XxBofBlG?=
 =?us-ascii?Q?LoPLWOaV3x1a/iaJ+a/TYeJK/c/UrrQZVn5hsjuCK6MruhXtpmz+8aCyLWW/?=
 =?us-ascii?Q?I+QQglmkrMRDGQdOEtX7Pdwv4cozRB4eDXNHF9w/GlroWvjmkAih15gsc/sV?=
 =?us-ascii?Q?AS5IE8b72PaxntA9pgo+BD44Z4ZAZeUFWRRy2XNCmVuPe8aPuKYWetwp/cKj?=
 =?us-ascii?Q?7cQALhtaVuBD4rcDtu+KGumtPa7WsWKTYzd5HzYz+274q0TALrdqi6Vrw30s?=
 =?us-ascii?Q?n7/bxEu5d8H2/5+EddrpwA05yuKQNVbQuzOr5LkCo9S6e9TfQDkeCWEi0zLW?=
 =?us-ascii?Q?oCQr76FInnZlqTWR1qiw0th9xx8jlsY8l4g6yaB5es2dU1XURHWgI9UJWreG?=
 =?us-ascii?Q?ur2W614jOyPnax5MqG0Vc2TnqRe77RjotBN2A/OREh6+Lia4wVCjuen153/2?=
 =?us-ascii?Q?vgQO7FX0eO/ybIMe7fUVXEwCh37yp+C1k6ehpSiY9h+PuM6pcV7NV6JuIlM6?=
 =?us-ascii?Q?6dt+ZDP5tnQZM6CuOE1eajUf63Df5jMscdxP2BbQpmHA4oakSHk5jFxFUMdD?=
 =?us-ascii?Q?CZTYuvx+4qT60m5go+1QQI+NUPLxks+66eylztlAZY+mfGCHEZAyOHvqsjsC?=
 =?us-ascii?Q?aBGfJhusmwg62YNcXte5I8PWOsy07YRP3boUxuFouk70rLX+WOV6QWdHOWe9?=
 =?us-ascii?Q?MiIPLBifBe31ZDEGTO5HRgjT18e3v3zUim62umFzt+8lsMpXwkpJKsFalAI?=
 =?us-ascii?Q?=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MR5iYfpn7PRec/lFI0qQPNANHPENa+h2kexeMNLptiDg+qajehqQpUVWNqan?=
 =?us-ascii?Q?lCVie+2HCy/m8oEmOnJMP2F0cWLDLEhDbvhbtWQbGGYZl4KgAWMOvaxd91DX?=
 =?us-ascii?Q?h2QcV9gc7h/9zrByvskuYFuUryp3MG9lOfmsGeIRSaq1CTPI9TDSS/mzJLoZ?=
 =?us-ascii?Q?uIDPrZsijxiOV79tRY3ywD1pUGQaBrA9uszifrEyZuOXMu/OyA/mCDGhK3GG?=
 =?us-ascii?Q?kNFKVg2ow3nzxAPTH9UaGu1AdaLFL8e9Y/3LhJ0lVGB7WhDUajEvXPagcKgX?=
 =?us-ascii?Q?KYYQNMm8EhXUPAzKKapvI1SXnRH981MV/wdYzbkAx60XGyv7pkua51R0pK90?=
 =?us-ascii?Q?k0YgC04Yxk6JwI8ZAcDaqJZt1S6lsmeNDfa1IEsrl3V9Qu3Y1duOc8/0VCFa?=
 =?us-ascii?Q?AvjUOUkdnnHwGbLzDn0V0aLWrYDSCSwiCQ2A9z82RXq1o8BYs3FmBQfhMwOi?=
 =?us-ascii?Q?VmINlv6pLNY/tRzSO2FONar4C+cmS4PnVK8HZMEwYnP9txywbKDnwg4NE1bH?=
 =?us-ascii?Q?M4ltsqHB/XI6vbj76PVTXm6n4cDt2f36b3ae3NT7qAPAVxqmFpNLGuv5S9E2?=
 =?us-ascii?Q?5PhRPcixf4IJBruAAHddCO5TiGcl8ncoJauECOnYPZ8B/YeRUH0CkJAsD2LK?=
 =?us-ascii?Q?7ykVFWj/2tSUWLH6CZcZc0XPsmU2LU4hpphk0jFIFQlEI19PeKYMG52uxa12?=
 =?us-ascii?Q?4kb84n477lglWsI54qdoh8jGyco/jmPjnmKI96GN80k0wP0tenpP0vwknpjF?=
 =?us-ascii?Q?YiySKZGfO+oYBFQC4Z1Qs71TrUpHTvWTjYSuqqQpsBAX4Brk7UJeB6IHoGCE?=
 =?us-ascii?Q?hiRdvQIqh9i4C+LD3d3LYDhmhpPtCukmEkqe1MnanvgrU19T/gzYYoopVM02?=
 =?us-ascii?Q?y58p9Vb1bm7E3seav5ORmwWJPb+R6VsdxW17ecrmhzk0NHysUH77NY/Tc+Pl?=
 =?us-ascii?Q?jiEA/wgRE6O9EU2yhcG+h44I2hmS8i5SS8LcBn68LizX+2/Jr/46bNCgj2+e?=
 =?us-ascii?Q?1SN1di6qJi8o4DC79jmlHPLjjR4RgctetV+GdKM5uLZt3mXiBdkT1vGM6cgt?=
 =?us-ascii?Q?7dkwmLrzietkjsMJnoC7gZUZDXE1BKXbWY6MLLPwIPAD7idVpp+MmcUWFoXG?=
 =?us-ascii?Q?4dJ5pqM9N49aoKePYKgT5mk9W/kmy8sdu/O4r/ln+2r2PVFELnoOi2WzsH7D?=
 =?us-ascii?Q?KpRQYPKQ7Wo2/jkS5HtY6u55jm0KLAZXmeXD955V4z68l5DZlopFPv2Hrq11?=
 =?us-ascii?Q?iMMUOTn9nYXLzd+3fvfpxhkkYw/yAN0yfDvRAUsVvXkfXdSkvmaY6uaVjFgY?=
 =?us-ascii?Q?+Mlx9dMsX97yWsrW/I3+UxuEmGfdgXtKFs9emzbbJ3MSPVF8hqbW1JS7o7nt?=
 =?us-ascii?Q?mvWOhuhLT3+qgRrt5pBU+eMDUIBnNjr/4rZMnR/glTOtXkycxkXtmpaWO7Fx?=
 =?us-ascii?Q?vNz9XuC5p87HaMIyMi/sm86O/fN3ZqgBYzShO4t017FSU6e6ac73jaHLscRU?=
 =?us-ascii?Q?ALo2OJCVhNGOByfzyQ8zcgALbCs5LPZsljJFO3CKMVZ4NtTv3+B9oTi08Kk4?=
 =?us-ascii?Q?0jjx0QUH5LCm9hD5eF9aXThWFvEpnoei2VwHgWKd?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cb71c5bd-e8c5-42a1-5774-08dc65ce2730
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2024 08:52:07.5724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yWk6tLUQt/3p93qqvbFEUVgK0vafvQMmeCRmOhkZrsax0CqLO8h9tui0IMbHPBXyTlQ6qeYowTVO4ry3GTk2Eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5787
X-OriginatorOrg: intel.com

>diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
>index 502704596c83..afddfe3747dd 100644
>--- a/arch/x86/kvm/vmx/x86_ops.h
>+++ b/arch/x86/kvm/vmx/x86_ops.h
>@@ -15,6 +15,7 @@ void vmx_hardware_unsetup(void);
> int vmx_check_processor_compat(void);
> int vmx_hardware_enable(void);
> void vmx_hardware_disable(void);
>+void vmx_emergency_disable(void);
> int vmx_vm_init(struct kvm *kvm);
> void vmx_vm_destroy(struct kvm *kvm);
> int vmx_vcpu_precreate(struct kvm *kvm);
>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>index e9ef1fa4b90b..12e88aa2cca2 100644
>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -9797,6 +9797,8 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
> 
> 	kvm_ops_update(ops);
> 
>+	cpu_emergency_register_virt_callback(kvm_x86_ops.emergency_disable);
>+

vmx_emergency_disable() accesses loaded_vmcss_on_cpu but now it may be called
before loaded_vmcss_on_cpu is initialized. This may be not a problem for now
given the check for X86_CR4_VMXE  in vmx_emergency_disable(). But relying on
that check is fragile. I think it is better to apply the patch below from Isaku
before this patch.

https://lore.kernel.org/kvm/c1b7f0e5c2476f9f565acda5c1e746b8d181499b.1708933498.git.isaku.yamahata@intel.com/

> 	for_each_online_cpu(cpu) {
> 		smp_call_function_single(cpu, kvm_x86_check_cpu_compat, &r, 1);
> 		if (r < 0)
>@@ -9847,6 +9849,7 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
> 	return 0;
> 
> out_unwind_ops:
>+	cpu_emergency_unregister_virt_callback(kvm_x86_ops.emergency_disable);
> 	kvm_x86_ops.hardware_enable = NULL;
> 	static_call(kvm_x86_hardware_unsetup)();
> out_mmu_exit:
>@@ -9887,6 +9890,8 @@ void kvm_x86_vendor_exit(void)
> 	static_key_deferred_flush(&kvm_xen_enabled);
> 	WARN_ON(static_branch_unlikely(&kvm_xen_enabled.key));
> #endif
>+	cpu_emergency_unregister_virt_callback(kvm_x86_ops.emergency_disable);
>+
> 	mutex_lock(&vendor_module_lock);
> 	kvm_x86_ops.hardware_enable = NULL;
> 	mutex_unlock(&vendor_module_lock);
>-- 
>2.44.0.769.g3c40516874-goog
>
>

