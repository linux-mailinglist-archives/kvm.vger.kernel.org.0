Return-Path: <kvm+bounces-51493-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CCBFAF77C6
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 16:40:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 951DD1682FF
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 14:40:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E6CF2ED869;
	Thu,  3 Jul 2025 14:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TxoJEXyh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CBD32D9EEA;
	Thu,  3 Jul 2025 14:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751553589; cv=fail; b=QboA16WeuhUOVRoaaqTcMGvjvaQfxy9ekg5ktoxa/QI8z2SUVueemKTvgQAFymoVd7AeYDqxeMYgtHYQu9jZjUW6WWaeSzMwbUzoLyVDS0d5yNHtO/HZCp7A2dqwYtoWR+FdGkSwQn7rSb88R9L98pVc9Ylkm6ta3nv0Bk+0cJo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751553589; c=relaxed/simple;
	bh=Ri6DSQUYL3CZ0xhg2gOiptb2tyyxTa+F2COyxH+ZrVU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JLDLqbszzHNPoe0xT+6L6peqs6Jig4MaMvLKEfRPXveSEMPsh1stQMSPXbJa9J5rIUFw5tyXa7fwcigc30bCFj5gWd3j8keOT/mcxp9ymcj4iTbnxS3aD96rM7KjktDPx11ULTPl3w5/Jh8P1ppKP0MqagOwa3dUdHF49+xe8y8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TxoJEXyh; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751553588; x=1783089588;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ri6DSQUYL3CZ0xhg2gOiptb2tyyxTa+F2COyxH+ZrVU=;
  b=TxoJEXyhmZlXRvsF4BkKrMFiJXp736UeU2zebQFBjPGtKk/ad8MwLu43
   08DBlLsWTBhwkCe2KykV1idE2eqybleAbhTJKyP6PAg11DJhsswunXyDq
   oeC+02u8T496A5WWQ1AkpyxSzVCCGzv7noKrypjlW1CnNNrpJSfhXh0LP
   XhPeWkxzAx+asjaJbnmB1zbMvz7JcIx6hQ9dc76bV62O4TvEfT1Bpd5vW
   g4Fgg5BWrhwuntRpmHNooVmF7p58GEAubHP6HxzeEhnw+TekawgC2rFsH
   4jK4P14yQlIPcRQlsoMuPvkjYxaRtCBy/azqLqkw0+14DqV1vgVAIqFbC
   A==;
X-CSE-ConnectionGUID: q9Z2ssGuRnOeySk26A/pSg==
X-CSE-MsgGUID: ltE27+Z0RzGGukCm4Xgn3w==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="53749127"
X-IronPort-AV: E=Sophos;i="6.16,284,1744095600"; 
   d="scan'208";a="53749127"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 07:39:47 -0700
X-CSE-ConnectionGUID: /i6FWWZhTAq3aTi+c4eAhw==
X-CSE-MsgGUID: cfg6EEiYQl6E9f4xg14ATA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,284,1744095600"; 
   d="scan'208";a="191564469"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 07:39:46 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 3 Jul 2025 07:39:45 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 3 Jul 2025 07:39:45 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.79)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 3 Jul 2025 07:39:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iTgvovJMV0ASaaG5+tHpvjyvxalAg/mNMnqv0yDn3OhHV2TjYGtcWMC2oOX2jjrX831odtw8XpPndY9O6cU5gTPo5jyVQ5Ojn3I7tlJNmDWdIUBeM8PAVvUkmZurJ2P2B2/L56j0/NHpihi83uvhrEZHj6pm3Ndic29eMBRiCvE3+kPRHYkk5r5YEe36zYGkQwoVyza9ijcs3syRJL55gsqKMjrk679ZEiHwrGdsrE0bgTAfkSRuPZyf2GmmFET0HgdLWePeerBXBnPpisepXp42PKw4+ji3aedzmB4BfhGWMHGJ/VpvxkmH56BnpYFm9HWSpavxeYXIm1RXcwGivQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uUzwvDUcJeV5WNrjZofA3qGfVyzG9mmE3J+i1UMJFws=;
 b=mg9yF4RnJFALwALQpWtrmwyF3aR9G8Y1Frs0qesxP+qAGDDBK2UfxrhbZIfH8JicFJSZCiRV5bhvPmVXiOvAPwejxoDnHt4u/HLUKenc16SJzAkgb9/twqdi3DCJAW+HK1SKVqtCqNVHrO4GJfxkt9UxmuNK9xHqfbM/+LL07b35nEfPqpM57CDM+pW2MB6i91csutK1iaTk7CZ9wOQ23yeTJ6MsjCFOwWjC802Ji9S689VnPbjtoax3iG5BKbqHWeclWoOe2+kqavYg6IiAvFux60u7sZEmpQa1EKmgggiAgpX4UxyI9yALO8o9D4k2oZocITSQTsDDwdpMGagV4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BN7PR11MB2708.namprd11.prod.outlook.com (2603:10b6:406:a9::11)
 by IA1PR11MB6098.namprd11.prod.outlook.com (2603:10b6:208:3d6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.29; Thu, 3 Jul
 2025 14:39:27 +0000
Received: from BN7PR11MB2708.namprd11.prod.outlook.com
 ([fe80::6790:e12f:b391:837d]) by BN7PR11MB2708.namprd11.prod.outlook.com
 ([fe80::6790:e12f:b391:837d%5]) with mapi id 15.20.8901.018; Thu, 3 Jul 2025
 14:39:27 +0000
Message-ID: <09770a46-3d66-4256-a4b1-39d468daca65@intel.com>
Date: Thu, 3 Jul 2025 17:39:20 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] x86/tdx: Eliminate duplicate code in tdx_clear_page()
To: Dave Hansen <dave.hansen@intel.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vannapurve@google.com>
CC: Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>, "Thomas
 Gleixner" <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	<x86@kernel.org>, H Peter Anvin <hpa@zytor.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <kirill.shutemov@linux.intel.com>,
	<kai.huang@intel.com>, <reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@linux.intel.com>, <binbin.wu@linux.intel.com>,
	<isaku.yamahata@intel.com>, <yan.y.zhao@intel.com>, <chao.gao@intel.com>
References: <20250703114038.99270-1-adrian.hunter@intel.com>
 <20250703114038.99270-2-adrian.hunter@intel.com>
 <a0d5b60d-ea40-4f99-aed7-003102517248@intel.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park,
 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 -
 4, Domiciled in Helsinki
In-Reply-To: <a0d5b60d-ea40-4f99-aed7-003102517248@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0695.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:37b::20) To BN7PR11MB2708.namprd11.prod.outlook.com
 (2603:10b6:406:a9::11)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN7PR11MB2708:EE_|IA1PR11MB6098:EE_
X-MS-Office365-Filtering-Correlation-Id: 6af59483-aa0c-47e9-469c-08ddba3f6934
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QXd3MEJ1VFNlRkNNZDg1c3BvNWZPVFV2R1VOYUpwRnBUT1VaMk10N0UxanRZ?=
 =?utf-8?B?Rnd1K0hidXBzRWN4Z3lHUE42WTIxTTBUdkllSGVoeFBUamRaYWNIZTh4M0Fr?=
 =?utf-8?B?Vmoyc0s3c0JYeE9DWW84TVhFRk40M2V6dGxxV3VRQ1Y2SkVrRUY3KzR3OTlI?=
 =?utf-8?B?amVqb2ZjR3BGbTdLMzU3YWdBTjN1TzhzSmFKbmdEOFg0bmpHdWYwQkdlU1c1?=
 =?utf-8?B?U3phUVpsd2k0eU5FUzFzaUt5czlEMDNwQmtIK0VqMURWOUNBc1JSLy9YWk9E?=
 =?utf-8?B?VE4rUXJYTHU2UklQc0tXRHIvNkpXa0l1bks0M1pzb0cySEQxem12cTNkOWZW?=
 =?utf-8?B?dTNGc1U1Z2txa0wxMkp3eWF0VkZWZXlidmw1RVlHYUVvNE9vY0Z6ZTQwNzkz?=
 =?utf-8?B?Q053NHlUQUVrcEFHQ0IzUjNJcmtINGVHd0RuOGw3YlZaWDR5bGp3dmkrLzdH?=
 =?utf-8?B?ZXM0anNubisrNFBTNWFNVXk2Z3lmZW5PK1hGblNOQzNkNkNKZUdnSmZxcVRt?=
 =?utf-8?B?N3pJQW9zd1RpWFA4SW5MNEk1TVR0N0ZzV2U0c0N6bTh6YllYcVFZcmU1c1E4?=
 =?utf-8?B?QW81UVhBMVlPRGloN3BmS3A4ZVV4aXVWL0Vwdk1vaW52VVBRUlFPc1pRZWkz?=
 =?utf-8?B?VWY5RWVKdVdRYm5KSTJhZURnZ3UrOUM3R1FscXcxVkRTSWVxSGhLOXZLMnZG?=
 =?utf-8?B?V0ZRQ3pGZkIrckJNM2dKdVRjaklmb2ljQjdQQnZJOHJlU2ZlYVNJeVZwN0Jt?=
 =?utf-8?B?M1IwM2prZkVWUE5HT0N2NE1YajBOZ1c2SjFMbW9YQVdia1c3Y0JhTXdyYU8y?=
 =?utf-8?B?aTFUUFRoWGVaS2ZmT2pVVnAxVVMrSlc3SVh5aFRXdGE2ZGpUNTNMQmtka3BV?=
 =?utf-8?B?YStaMWxORWllMzNwd0hmUGpFWUVTcGJyM1IvZjJURno5dEx1Ui9Ob2VsbUt1?=
 =?utf-8?B?aHFJOGFlTmU0ZDNyanNzaUdXeXV3RnV0ZEFFbUV3U1B0QzZzRmovUWpBQ0ky?=
 =?utf-8?B?Mm9BVFNta0RhRm1VaGtxWWZvTWp1bnVBWVk3aG8xc0Q4blJFcG9oTVZkeXBY?=
 =?utf-8?B?dlMxMmZ4VXB1MFVXejRmOHd6bmZ0UE1nR28xTndLTFBsVjd1NktBbEdpeVA4?=
 =?utf-8?B?dEJFWDc0MTJ2alo4Tk9kSjNsRURPbEMyUnBBQUlBVk1vcEJpYnJYbkF0eVJQ?=
 =?utf-8?B?amp6RlRMRnJGdkZBdzVGUHJRZmFLZWJycUdjakpCZ1paSEh1N0JOUWEvcEtW?=
 =?utf-8?B?T1VvNFpYNzRrV1RNQmRYaGVTTk1kYVo4OTN0MktEaWtSUE9CUFgzcjh3SHJB?=
 =?utf-8?B?WmlZbElKTHZPbkxvMGc2bENnYlJEaEtWMTJRT2k3bURmY3Z6NEIxM3UyUFhC?=
 =?utf-8?B?RUlBTUJGZmRRTXRTaW4rTDNjVGg0M3paa2ZldlZjQ2Q5eWtPbEd0MjN0ZFJV?=
 =?utf-8?B?S1ozYlZCTmFISUYyTzRHa0t4a2xLTzQzZGFhZEZVODdwdDVDL2l2RlpHMVZ1?=
 =?utf-8?B?SEpYcDZDMVJ1anBHWGthT0dDMkt5QmIrWlRCVjRESnRUZk5JTm5CTDRyamNs?=
 =?utf-8?B?VnE4TVNWVW9jeEdESVVqbHJ1Z0kvVHFZSE00UEhVZjVGQiswUTQwWk9FdDM1?=
 =?utf-8?B?ODJhOGtmZnJsOEI3S2t4RzdDMTBaNmxEckJ6MTR4bG5zUG9wUnd4YmRjU1Ro?=
 =?utf-8?B?bHZxMEFIUmFvNDhnMmdscTNEZ1lUWFlBSXZmVWgwWm5RdXI0aXBMeFFwT0Nz?=
 =?utf-8?B?TWRqcnhMbDdjd1o2QkR5LzYxeGxrNVhIaHdxYWJGTmVhdTM1dlhmOXlrVXlJ?=
 =?utf-8?B?blkwNXFYbGs4enhrOEhmNVZwZWIwTjNyelRGdlg0d0ZvNXd3YlExT2JqN2xj?=
 =?utf-8?B?QVBtR01JR3hlSmh0U0Z0TE5Bb0d3VmxqUldYc3BDa3YxaG4vaGtNMEpnajVq?=
 =?utf-8?Q?ahNIfRPAIV0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR11MB2708.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MU11V3JhN2E5bG1aS2FydlNUeGVtcFp2b2pZUXFtaFJLTXZtTDdONUpXek9U?=
 =?utf-8?B?dm5XZ3d4dXhxUXVlSm81bnBVTkVrZFZEWklLSmIxeWo0bTJNZHY1aVhkQUYr?=
 =?utf-8?B?WjhQTkV5Snp1bFprVUFNTHhZSHlxMFFJdlBMenRLV1JXQTNsYU1HamQ0VmNB?=
 =?utf-8?B?c3pHUVBqb0dwSnR1OFpYVTdrWHFjZzI2Sm9kZDhjNThQRTNZQnkxVVhMbTJq?=
 =?utf-8?B?M21zamNicTdpeXYwQ1NpdnN5cDVndFUwT0lkUkUrVEhjTC9XU3VDSFVLczF1?=
 =?utf-8?B?WEszbUhFRXh4T0tFZXdOd1RnbkQ2NTF3Tkp2V3QwZXhocFEvMXBVZEt0SU83?=
 =?utf-8?B?L2F0dkFEWUFXN3NKalEvdU9ieU5SQzltRUM3ZytWdVVCVUVWU3FpemFaYW5S?=
 =?utf-8?B?Sk5EWXd1S3JKM1FxdGIyUVRjeWIzZlFMSVA5RWFBU3BGbHkwQzRzSFIveUpr?=
 =?utf-8?B?NDlTUHp6eFVOSzZKbEwrSGthYWdOYkpUZlNqd1hmVS9JTWcyZGI0bWVYUWVT?=
 =?utf-8?B?d0Rhbk9vSU9NSFdteVliNWt1WFVCWjkyOUN0em9hUnhIUTBneVQwZkNqU0I3?=
 =?utf-8?B?Q2dqUjVsSHEvQTVOMEo5MHBUOWlkcUVIRm5FUFFLL0poQUN2azlTb3F3OU80?=
 =?utf-8?B?MG03VzFHK3ZCSW1wSXd6U1E3Kzl0eUMyV3NxM1JYZHQ2ZktCZk53UzNUcjRv?=
 =?utf-8?B?cjh4TU1hUHJxT0JFVmhGeHlrMEFqNHRMVHNRNVFxaGpsOXRpdFVRZHZ2QzNE?=
 =?utf-8?B?OU92N3FnN016NStaRks4dGwyZTJqUVY4MzFLQWRlQjVxL3NiWkRQTDFCZzJM?=
 =?utf-8?B?N090aXNCbnAvelpqWmgyZzllN2dtMDE1b2grODZpN2o1R2lMWlBVSDZEVlJM?=
 =?utf-8?B?dlJTYzZLTzNvNDdMRFN4RDMvd2NQTTVNVmlMejRFRUtneUl2Ni9VUlMwTXNJ?=
 =?utf-8?B?dTFZZmNjUkgwajFWeU1ja1AvSlVQSnJONWpVL1VOSk5FbGh1VGxKc014T1Q4?=
 =?utf-8?B?MkRRQ2MwUXFEYzU4NURmTWhacTRaWmdGMmw0dkZBUkxUQ1BCNyszNGxOOEpO?=
 =?utf-8?B?Zzk0SDVxaENaeThKbEprdlBkdmJrSkplSld5dkpnbXVZWFJoejk1WC9idElt?=
 =?utf-8?B?L0QyMFZjS0lIVkV6VFh1Q1hPcHAyL2tEbnQvNWcweDJ6T2VzcFBMSE1mMi9w?=
 =?utf-8?B?K2owdzJ5VncwdnFKUUh6WDBJYy9yNXJIZFltbjliUjZtalhRNGpxL2ZqU3Ax?=
 =?utf-8?B?eUcvQTlBeUZqWEhaL1lrTElFdURRY0s2TEE2bDlEM2RCSzZJajROcU5STklL?=
 =?utf-8?B?RUU2Kzh3WndnL1VLVi9nOGREenZXSHNPejVVTmlDM050a3cySG9PNTI4a1Za?=
 =?utf-8?B?empTTjd2RFZVNWdjeFRuVGowSG1iWmJBT1kwMjlvakxPQWxXR09tVytOUThR?=
 =?utf-8?B?eXNDUWQvUTlCVFNCZTBLQkxSaDZRL1lVUnhBOFJQMG1sK3NQZVhGTXdRejEv?=
 =?utf-8?B?WlQ3VjF1bURONkxqSG1BRlROR3lJZWlDdEhia21YTlF0eWpFUmVoeCtOTFZw?=
 =?utf-8?B?KzcxdzVNY2laZGUrUUFpVkJoTTBySTBybWc0RVZrRStaUi94aHBUUDFqcWIx?=
 =?utf-8?B?Mnh2akVEcSttbnVIQU9IZWNidnAySTdGN1I3TWt1aGtXekpYdG1NaVhZNG15?=
 =?utf-8?B?R2ZmUkU3N0NaemNiQ0o3ckNBWU1WaVBQSTR5NlNnbEh2SlUwRXpDd29qQ1dO?=
 =?utf-8?B?SDhlVG9PWEs4bzkzQ1NrZDE0YmdQUTN4SkhheVRyazNXZEozT1JmbWY0bnIx?=
 =?utf-8?B?dm5pZWcwVkNLQzdtRGNoK3graE9sNUNCbDY2TUNhN0cvdkYrMlZDQ2VzTjFt?=
 =?utf-8?B?Mm93YW1VVVJWTnQ0bFRWdGZJTDhEblBjc1pzb0p0OU9zYjBINkdXOUhIVmhD?=
 =?utf-8?B?eU11d0NNRThJQ2tydUQ4eVdLaWxjYXFuR1VaNkN1bFZXVFVpakg4OHFVK0lz?=
 =?utf-8?B?M0hIRmc2YzhRenlzSWgxTE5wZHN5NDRTN3FvUHZpWi8zQlV3dkVidzg1Zkt5?=
 =?utf-8?B?NkdSNlJMemhXb3RhdjdEMVFEanVXK3NTN29jV3NDcm5WRnhzVVJJVFlqaXRH?=
 =?utf-8?B?bDdKeVdWb21pbHpTbFJ2V1B0dENlMktkckJTZVIycnRHajZlNnFJQ2w2ZUZ2?=
 =?utf-8?B?eGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6af59483-aa0c-47e9-469c-08ddba3f6934
X-MS-Exchange-CrossTenant-AuthSource: BN7PR11MB2708.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2025 14:39:26.9967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vf+cm9Hty2PX6HGVR5u0JquwUjJya3z1E2SGa0nw8Bih79WENFBGpCtre52OR+phmY74RD2o6MM/I+0JFUGy/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6098
X-OriginatorOrg: intel.com

On 03/07/2025 17:14, Dave Hansen wrote:
> On 7/3/25 04:40, Adrian Hunter wrote:
>> tdx_clear_page() and reset_tdx_pages() duplicate the TDX page clearing
>> logic.  Keep the tdx_clear_page() prototype but call reset_tdx_pages() for
>> the implementation.
> 
> Why keep the old prototype?

What prototype would you prefer?


