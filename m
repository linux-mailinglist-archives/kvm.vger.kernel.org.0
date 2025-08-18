Return-Path: <kvm+bounces-54874-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D8C5CB29B6D
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 09:58:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 88AEA7A172A
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 07:57:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAEA529BDA3;
	Mon, 18 Aug 2025 07:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e+OuBqFh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854D5274B23;
	Mon, 18 Aug 2025 07:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755503904; cv=fail; b=nbtwBk4Brih/bXGubLrN5VrmA8PDtQ5x5b5dTeQVdBcIiTmNPzJy3Lh1pFOi+nF+d6QhrFrAA3uUeqWK7jkofczv2C+Y94lvBhmNkaPSwLOYyO42XSCzwV0fU3MQA/N/t7/0Ab9OopkoaclBOWyJXBSxEBzNp6yMpX1M0nOujgw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755503904; c=relaxed/simple;
	bh=h2f8mwfkotGciqUHd2+ClEzHh9ZTfZ0UhsNALKYnrm4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=r75+cEGHENusQ6Gd8OpB0Tml/jCMQuGfXu5+55CaECNLuxtVxwyr0wVU5VqRMf0tdxJDtz5mXlMysMF4NqkJY7MOX4nwzShX71p4y3ibO+Cagp0ELzrtPUP5McLaFHw110kzWicz6i3aNZmnQDZtLvkJo0JndPUJf0HDZUnTqQw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e+OuBqFh; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755503902; x=1787039902;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=h2f8mwfkotGciqUHd2+ClEzHh9ZTfZ0UhsNALKYnrm4=;
  b=e+OuBqFh1l5h56mlOgXcP7k4p/CsUcXn+CmgDgAEQGj2oKYZOk+c8nnp
   XO0nJXp7zPthqaloFxkJ88YjB2DcpYbvN/8rB20E9eZYKoHazSnIi4oB+
   1Tl3hHY272n8ihi1u/zveeGhgJKxSr+hjuSfyEYaCZQgWu0M4+3mg5w2K
   O4FSXPHCds5d++bdIM9TC2MlD3eusY7FwmrxmY2YEKdQzk2RmQOco1Rdg
   zKFH7tvLxVksACJjyUxrdym3hGI1+ycWDeQCdspLDN4EH2MKGifjGdGsM
   uLLt0AcYkOVyoEe2MIeSa/w46aVCdo3XniX37q/ecY22VEtKjxHSOJWu3
   g==;
X-CSE-ConnectionGUID: ybj3N+aWTOWANBZloEWY9g==
X-CSE-MsgGUID: Zk5ALMm1Rqe5/dl1iH+46g==
X-IronPort-AV: E=McAfee;i="6800,10657,11524"; a="57436518"
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="57436518"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2025 00:57:50 -0700
X-CSE-ConnectionGUID: utZs3dVtQsmLH4mzDPvFxA==
X-CSE-MsgGUID: 9AYbZ0b3RiuyflvugvXhMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="167011614"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2025 00:57:43 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 18 Aug 2025 00:57:38 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Mon, 18 Aug 2025 00:57:38 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.43)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 18 Aug 2025 00:57:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=skIZlraqqQ19zksI7ukUlE2Ybui8kxOPMJ/Lr65Xdctgoj3Z5Ygy265d4DWwKTaTC7EtBWySx28s4oLT/HeHc11i+tJ1yzl6Zyl2ccSujExsFiFOso5j125YB830myyw9gDUE/jExWkN1V1vQ/gJ4grn9UlxPSlZFaCjg727aLmViadm5liJFcAUyZAtij+B4Ci/S6BWrH6myKgXI05vPYAFlSWyiTwIforgqLqpcuxgZZ0zPY4Ofc8Pihb1IMsnIt2jX6OSGCfW3jj7Ig/6rV2oI/4Ho5TvUZ3M+lx/vqQpw3aHMcInWYApoEk+UIaNLYwhyF59UvXKjwVvjHWw5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ItPhaVblf729mzA2eLlUsMYY5oY8HL2DmIAr8W5DoCs=;
 b=GHXwECxuDMdSiyPYgT73WVV2qiNCke9txnsmWSmtkGMloPKrOqiDdcOTlc53NTldPfK40UCE6SKqxgXvqvZLJ4fUiIY6uaEfw2oi5ZjUN8bZo7wzk30Isn8T5BUWGf+CJc+qbfTDZ6Q3WR9EWB4dEa621XH0b7Cets5ooAcUrXQXwJ5GVDglqcj0x4oveMeqv76wN+tfSjcE8K9iHaOzlbJsxYea3o379UlNL8L69f3I8+ogesx1yTLf0Xv7SkX0X9CTzcYjA5G3M9gnajm5JwSk5amvfwn0c16GJ4jW+m6Rp5f4VduPLsoPS/UxUgWruu9ewzYJfByAaX8+9/HntA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH3PPFEC5C0F28D.namprd11.prod.outlook.com (2603:10b6:518:1::d5c) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.23; Mon, 18 Aug
 2025 07:57:31 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9031.021; Mon, 18 Aug 2025
 07:57:31 +0000
Date: Mon, 18 Aug 2025 15:57:20 +0800
From: Chao Gao <chao.gao@intel.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <mlevitsk@redhat.com>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <xin@zytor.com>, Sean Christopherson
	<seanjc@google.com>, Mathias Krause <minipli@grsecurity.net>, John Allen
	<john.allen@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v12 18/24] KVM: VMX: Set host constant supervisor states
 to VMCS fields
Message-ID: <aKLc4BpUm++xjv7q@intel.com>
References: <20250812025606.74625-1-chao.gao@intel.com>
 <20250812025606.74625-19-chao.gao@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250812025606.74625-19-chao.gao@intel.com>
X-ClientProxiedBy: SI2PR01CA0028.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::21) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH3PPFEC5C0F28D:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b14d8a1-301d-462a-dcfa-08ddde2ce239
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?dsy/Aopd0MLQPqGXzWpJK305fIOc2jyRmEtIiBSjikBRszz+R6TvTumKZj4X?=
 =?us-ascii?Q?9VXFNYh7tviViNeUMShUVOgXuL79ERXCrWsajgpWfi1802z2a7xscHSnTNB+?=
 =?us-ascii?Q?CyN77hxvjY7nRzdynmOOlZFWSbCPosy1lkSv23ZF0MHEoBLBMqBkq7MaSj4q?=
 =?us-ascii?Q?TMyxQ3MD5wWwoiNv/dkumVBwTMMn5CP1Ddyr6vv5FTI66GCUDbss9tSXscvr?=
 =?us-ascii?Q?2mXCQjOU5f86nVGYMAuLnErkzxqm+i6+yvedAR3L/liu5CV9NmQ/7WOP24FH?=
 =?us-ascii?Q?9mhxlUh2fGZKZENn/amEslchO5+qAJvKHr0tUkEpBnuLgS8UPGbLalYpu6V5?=
 =?us-ascii?Q?rZ+TrCmux+3L46ErAdKrln4R+vCa8/eHOEUmfND/A7ls5OiNBBJpYcqDpMOq?=
 =?us-ascii?Q?tNLGCLCADtZoXXvAM+1MPDDTQpPnssjBzPiqaI7F9DdP/BwLkPefsk6WnBjD?=
 =?us-ascii?Q?d8UKyqsPh/j66C+OD2kr50MHsWAUfadUf4g68+lDv92i1G5DvgXxRHcU3Ohw?=
 =?us-ascii?Q?rR+IILE+mMmgrDSZy02uLokEGH3uT8MyiAKr21wUi47Tp9IMPf026mNv9MiR?=
 =?us-ascii?Q?8RbE6BaWqJvcal3M6GjtAdOFvISNS5yQa/bmkoUTeoBSmqppyILxdjT7C+c8?=
 =?us-ascii?Q?IMLdZQBOPmFaAyoCoRFTaLKz7VpfH/e+AHHqKHLckwd/gkijwkNr7ooInCfl?=
 =?us-ascii?Q?3gtB2blsiaalNugOjzIgo07FNQOUYbyyzTk8n9TWvRRTtKeasTUV/JqC+w6I?=
 =?us-ascii?Q?qNPrcprKQdB74RhRTYd97aJcYvRQMJEP5YNB5DnHoxPNHcHhqZ+PBPQ3GWXm?=
 =?us-ascii?Q?rvk4FHD4KBI2cpBNKahF5cCtdV6dQPld4OmyER0OrDoClDyPayL8TwWSa+Hl?=
 =?us-ascii?Q?MUTlxerCbdHnoZHuev9Gi/1V6t2dHrmr2BUFg8Itq+aZZM8NnxpHYgRVqdOq?=
 =?us-ascii?Q?ZGwWxk5NwRh8y5zJCJBS32kYRhtRt+qk/bH8CMIp0jdJzeM7Q/JJggi1KO29?=
 =?us-ascii?Q?s+IEKGba/P+S2g3KJ2EOLgidXLpS/Uo3IuSWcgwVaBIlPCcXDDH5HkCGqDsy?=
 =?us-ascii?Q?2qe7fxVweFaaVm8rW708UNVEg09O+5CISql75wQlLgdDGHvQFaJTa4Bc93hM?=
 =?us-ascii?Q?X3txoTL8Q3uABVBPEOfbUClhH5OK1SXAxxqdy39nLHZkOxtV9yjMbyJ9jtxW?=
 =?us-ascii?Q?yIa15IP7l2ieg37nauWeozXeIiYh7jDrEjgWNhJRtBSHVkVVjeu2JuLEUZ+2?=
 =?us-ascii?Q?gCNRaLzhF9MhI353nOUOcKi/gNseXGp0qrLAzoTVHgjQpAz0L3ybQmZsx4zH?=
 =?us-ascii?Q?8fJtHoY5jjLmlAvYJ9R+zRXHVHD5/aLhLbz/Smrg23TTfhNwQ2MohUpJ7hTV?=
 =?us-ascii?Q?BhPFEd1IuI2r+vI3DEQ8oQMGsuZH6QTwWLtXBDcOo2XPpf5Tpw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QHRFxEYfi277xzQLMNBBSnk6W/0DeRxInsh9xRSNFcXg6EWFzGebv+hSAWUZ?=
 =?us-ascii?Q?Hzae3r4bdM8FGXug+Q8Xfo2GoJPncW7YvediM/V7q3ucejYmFDTZiYWuEyY9?=
 =?us-ascii?Q?6YhreECdJ1m06F/vr26EtoGQ0SFbvFcQVEV587pMX72dY6HhkmyPlNRIH7kx?=
 =?us-ascii?Q?oaWyzSzuTzwb1zWUHZ3ZT8tyfwAP/Bqofl4ztsGr0bsa9NpNReSX0WjyEzgr?=
 =?us-ascii?Q?AW9LN4g+9uPSIwEkWk55ANgBNaENP/yqqH5LqFto9qZ0AXQVLT201o3PJxv/?=
 =?us-ascii?Q?4L6TR6p+KwQbEoBeWTym3LV9+aDQVqlAz5Q+nreT5dMCJ2S2zFuKZfDYuR3U?=
 =?us-ascii?Q?ukDAX1i6yXbVdsWjji64xuikc6uFbyXOme8IydHUYFKRZ9ST8MislLF8th88?=
 =?us-ascii?Q?tRKOGZOxn47dWUboM+lmvMAJ8g1C2u9Q/NglS/9BwlY2u0ipHZOmPFCYvof8?=
 =?us-ascii?Q?Evrd2vSUVWRLe6aUxisarbIdKgjImR6+PlfEPuT7QqOnoAe2m52lWfckzP18?=
 =?us-ascii?Q?56OwvQJJvDxMIwkHfmw9DIVRH+Nr5H8zyT/oWCZfNeQBxR+Q4tECJeimxwd1?=
 =?us-ascii?Q?D0cLAiAiwDZNIFRmplyNKRE+KZ46J2FHA1rg6Nkp54lEj2v8w4CK3KPMXUpt?=
 =?us-ascii?Q?zpppISCYZInrbKy4UhuyC2JV4t+oo65IsaCAhAy47HC+5zS7sNs+RmgiW+x1?=
 =?us-ascii?Q?gnU0gmQfg0+f263e4toiZrxrdiYuHfYI9+3tVGyk70JZzNhaLoyvm6D4SbPD?=
 =?us-ascii?Q?phRFkqAs87ZmOVFiRpmZQsnO50i237g7KwW5x+flO026LHa70EbVKyt9oNkE?=
 =?us-ascii?Q?6AaFBMoEhQUCws2WNM7QPI+0kY9gmLgEHIDuvnc0iNgJ5JA1gplvdY1vw8qL?=
 =?us-ascii?Q?qltcdsZJkaPsgO7O8A6PEAv8WQQBssXlnBVSFPb106lult6koaPQ5TXPFfam?=
 =?us-ascii?Q?P+IQzINYsAjYR5EW3/Nv8GTejoYCROlZEebBbiHSZpQsi29B4wjB9mF0xYY7?=
 =?us-ascii?Q?bDYVY+OaI/vi9eG1VBLy/p9vUG3vr7nMjhnVrXCQLO48myWMXlE4wGsbaH9e?=
 =?us-ascii?Q?kYXI1aMeIjKTw3KQV307kKShZc1nDVsrQxY1hPewjXrbv5VDuY8HAJCZFHsU?=
 =?us-ascii?Q?KJpXSW3OB9+9+q0HpmUaG6LRLQ0BbpY4ecjeY26Wdqa5ShVi2epQoOXl4BF2?=
 =?us-ascii?Q?BzIvIPsza785Qeakwe0KOCl4YdDf9Pcd8fvrLUDxTBA2Uhnk3dmdI50LYM/7?=
 =?us-ascii?Q?g3aPqRXz1dnSQ28ogMh9Q/NOTZnCVg0zJJMX+7Avybncq5VoWR/ai/1FBQ3v?=
 =?us-ascii?Q?nmzGvFm4SyXQl9tS4a9U1GpRwZPjlw+DXYDggJ91qgU6NU082l7pOyFsDMm/?=
 =?us-ascii?Q?7kOJ4ZJqjZNdRXjfzuy3HioXtstd6SbgtASKXFoLdVwZ+SYXCrXS1Cjs9ZLy?=
 =?us-ascii?Q?vIfcz9QEWTIgyDldOxPedJ+Gj2OBOVaYW1Hdm5MwgvcLsexR0hp0nWj3Uo8U?=
 =?us-ascii?Q?Jdsqi+iD+f7aCJdUYRfYy3rEou/rI1SLWUqC9Q5C1ct5KChQ8Nutn14kI8Cm?=
 =?us-ascii?Q?iYeqSx+9oTEyFA4nrX2jm6Xs14Lnb38mey4cpkJP?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b14d8a1-301d-462a-dcfa-08ddde2ce239
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2025 07:57:31.4037
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0LwBUzYHBih6Rp5wsjgw5amovmJbLH0nTDU/zYD6jpgXERH3RS5bP1QLb6XVFlRHeAgClin6UcXfGC7U3VFRaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFEC5C0F28D
X-OriginatorOrg: intel.com

> void set_cr4_guest_host_mask(struct vcpu_vmx *vmx)
>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>index cc39ace47262..91e78c506105 100644
>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -9845,6 +9845,18 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
> 		return -EIO;
> 	}
> 
>+	if (boot_cpu_has(X86_FEATURE_SHSTK)) {
>+		rdmsrl(MSR_IA32_S_CET, kvm_host.s_cet);

This should be rdmsrq for consistency with other call sites in this file.

>+		/*
>+		 * Linux doesn't yet support supervisor shadow stacks (SSS), so
>+		 * KVM doesn't save/restore the associated MSRs, i.e. KVM may
>+		 * clobber the host values.  Yell and refuse to load if SSS is
>+		 * unexpectedly enabled, e.g. to avoid crashing the host.
>+		 */
>+		if (WARN_ON_ONCE(kvm_host.s_cet & CET_SHSTK_EN))
>+			return -EIO;
>+	}
>+
> 	memset(&kvm_caps, 0, sizeof(kvm_caps));
> 
> 	x86_emulator_cache = kvm_alloc_emulator_cache();
>diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
>index d5b039addd11..d612ddcae247 100644
>--- a/arch/x86/kvm/x86.h
>+++ b/arch/x86/kvm/x86.h
>@@ -50,6 +50,7 @@ struct kvm_host_values {
> 	u64 efer;
> 	u64 xcr0;
> 	u64 xss;
>+	u64 s_cet;
> 	u64 arch_capabilities;
> };
> 
>-- 
>2.47.1
>

