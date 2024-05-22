Return-Path: <kvm+bounces-17939-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 271868CBD26
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 10:41:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D2B24282C21
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 08:41:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AA097FBBE;
	Wed, 22 May 2024 08:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K4pXuuMh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B36E1CD3F;
	Wed, 22 May 2024 08:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716367308; cv=fail; b=Y0Zasx+CDNVyjP+f7kTRsIyn4MZQKPvuqSjJwfocroR0k75Rno5+ykmr4PbFM5xxpJPXjXV13rDXKnExhihRA/4XknTslXlfV9n7bIudC12EzPW4+MeR81gGwjuUWmcFx8zIlG8YqohhVOeE5zukNHxppPIANTVJTZwML3CrlV0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716367308; c=relaxed/simple;
	bh=Vc/kH/O/obzFeMuq9hvZLvwcPGg+XlssWQLZII8vMoU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Z3d+drFE7QHM3BbBUJVutV11heFahqtTIxoU1ZW2oarascPW2MnIgovtBCq3ueRv4i3Aql0sxvdfAWryc3gP+WLVoEI56htkVvTylfdidDEgYkxgImix8feQ1ylxpg8CVjQfwDncnClSt1j1eefQSSLJu5AcNVgthBhpv0O6Sis=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K4pXuuMh; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716367307; x=1747903307;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Vc/kH/O/obzFeMuq9hvZLvwcPGg+XlssWQLZII8vMoU=;
  b=K4pXuuMhohGW5iTM4YpTCQ2YhobEbDkgNu2XPfUZxa86ml8/+S9t3VB6
   mEO1zvP67wF2X+TLCDygcK5fyH5nKw8vcdV2K+YAdChpMDhbWeXnXa9NY
   pjgoeUpU/OJHRNCmpdmoIEkywVQFiuKOB5pVgdcrekcN1bVSrUu83jOcW
   3WvnANY+ctjh6wVBiJHt3LbgYvrB+FkVL9eQEhhnyy1f/NME+ImK3VfwM
   R43HnqMIzPcO9azHDJoXCDMEY/9yCA5vnNlfQlanwY5Wro+27nym3KbZO
   pEtjYiJoW2N4BjkQ5f1r+mAQnh4dZcsXdvHxLbjgtLjWct2KZQlLl3Fru
   w==;
X-CSE-ConnectionGUID: s596cqkARHq3sL7s0poqhg==
X-CSE-MsgGUID: ImzyRmQZTD6OSb0mhKdgtg==
X-IronPort-AV: E=McAfee;i="6600,9927,11079"; a="12722050"
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="12722050"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 01:41:46 -0700
X-CSE-ConnectionGUID: UT6DSrAgSnOupGie2x0HeQ==
X-CSE-MsgGUID: 0xDs3HNXRLacdF9ZDbvkAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="38166258"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 May 2024 01:41:45 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 22 May 2024 01:41:45 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 22 May 2024 01:41:45 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 22 May 2024 01:41:45 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 22 May 2024 01:41:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SWb58dUVQ9NfvaUDM5LktljSorq/ebTtQxSatTSRG6qVthOf+l4O7F9oKr+CXoXJOuePjcw980QVddEyoi3ko1Q7VNHWZRirq59qvMLG7U+usvbJTY9AzELu4XawN5IC/ldJuFKnsoa9utXVzY4IuRNeyWqu99wbH3mlk97ZLT+CVkIAuZneMgiB9J42+zswdjTv/iUdBuOQfC/7Zftjn+lU3CqWhQHOs5hhVjndnGmtyGobuDqowLtTCuXXGdddIa2pIdNi4L6b32aQzlp6HeJmOb8GKE7zDdG5GDlyk75OBAbcJ0/t5fPWY7wUysjX3w9/Xo5tgeMfBVV8kVJKAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wb4r/vjvbKr/JofniuZWkN1st8t9phytPlD2Cl50o3A=;
 b=k7Xcb7znUQPrpiw0985lytLNtNSrIAXQPh6CezGeAjxgPpB98OTRxut9j8TzJpPan46LYGEigcYgHPxw7g0SHNqFGOQuGn4bvUhCXNDXLRO41OUtFqQvhEWPVxuYXFKua3uCFyWd1sXZ1Vjr49G+fnqSjBN/AlV1m3sTYQxMVYmdXFJ/B0wgmSJFO6K44PgOzgTa9kBu1CYrEtqADbzsRMgr8bSmjSFenA/fbfiERfK11iutpLmQD3TnCtSV99vPEbSW0sfBZuAUKI6io70+Nn77+KMXf4qK+BtemKb7eBBl7/yckUwEf4I+euWo5DVTp7mwmVLf+BbkiU+g1pNcTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by PH0PR11MB4983.namprd11.prod.outlook.com (2603:10b6:510:40::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.36; Wed, 22 May
 2024 08:41:43 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4%7]) with mapi id 15.20.7611.016; Wed, 22 May 2024
 08:41:43 +0000
Message-ID: <07fc9f6f-721a-4b89-baa5-986664ad5430@intel.com>
Date: Wed, 22 May 2024 16:41:35 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 24/27] KVM: x86: Enable CET virtualization for VMX and
 advertise to userspace
To: Sean Christopherson <seanjc@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>, <rick.p.edgecombe@intel.com>,
	<pbonzini@redhat.com>, <dave.hansen@intel.com>, <x86@kernel.org>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<peterz@infradead.org>, <chao.gao@intel.com>, <mlevitsk@redhat.com>,
	<john.allen@amd.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
 <20240219074733.122080-25-weijiang.yang@intel.com>
 <ZjLNEPwXwPFJ5HJ3@google.com>
 <39b95ac6-f163-4461-93f3-eaa653ab1355@intel.com>
 <ZkYauRJBhaw9P1A_@google.com> <87r0e0ke8w.ffs@tglx>
 <ZkdpKiSyOwB3NwRD@google.com>
 <a170e420-efc3-47f9-b825-43229c999c0d@intel.com>
 <ZkuD1uglu5WFSoxR@google.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZkuD1uglu5WFSoxR@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TYCPR01CA0099.jpnprd01.prod.outlook.com
 (2603:1096:405:4::15) To SA2PR11MB4972.namprd11.prod.outlook.com
 (2603:10b6:806:fb::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|PH0PR11MB4983:EE_
X-MS-Office365-Filtering-Correlation-Id: 450f1c82-6452-4ec3-e16c-08dc7a3b0160
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WnR1RWpjWStxK01wR3NOOGUySHJKMFo1OGI2eCtYTW1ucUcrM3RiMXZ4TE9u?=
 =?utf-8?B?eCtmd2hxTUF5SGx1MFg1YWNjY1lrQi92TUJtT05lWFVkM2ZEaVN3SDU0cXY2?=
 =?utf-8?B?R3lGcWR3b0syZ0xJUXBXQ2lyQ0pqZ1JQR1ZTR00rMVlVUDF3Y29JdTBXL1FI?=
 =?utf-8?B?Rmo3SHRneXdLQWdCb1ZZYWxkM1lNM2RRSGFMRmQvS0c5WDJHc1Nhb2lMTmRV?=
 =?utf-8?B?SnlPcDRqL212MExwYzZaZTJjZkJ2VHJxSW9pUnU2NDl0SmRaYktlcFpLd0ho?=
 =?utf-8?B?Rkp5ek1DQVl1WDBvemRLZUxqUjQzMzExS0k2aTAvWWdaZW9adnltUGttNzZa?=
 =?utf-8?B?NEszekgvdFhpUFJENDFISnBjelYvYmwzdDZwakExSnhvRzREa215K3dtYklE?=
 =?utf-8?B?Rkc5ZityRmR6TTJxOFl6MjYwTjI4QnFUUjV2Mno4U24wNkNRNjRIUTR0ODAx?=
 =?utf-8?B?TEwzVXhzMEpMcUQvVlM4L25xK1BnY3FWcXlwNUpuc2pCRXBoWFd4MkFWaXl1?=
 =?utf-8?B?ejB4MG1sMzQxdE4yMXU0ei9rdHJTL1Fad0FFU25FOFNKTmZONjNSNXhhd3pm?=
 =?utf-8?B?WmxLTmpLTUhLRHBuMW5jd09wOGdCYjgvWHEwQmJQUmptaWx3MmNkQzNJQ3R1?=
 =?utf-8?B?RG5WbzJGSGp4UUV5ZnFSZVlBQVVpV0w5MmRKcVZMbUlBYitRQVh6WnFpeDVU?=
 =?utf-8?B?dnhqaHdUMW5KRzF4eU1lYm0wdVlUZEluMGRhK2tzNS9NdDFIeUVWaXBUZXFa?=
 =?utf-8?B?c2NJbkppZzNaKzVaVlNsbDlEMitXeHdPTnc2NTNlSTRTZWZiOU1OSTVEZ1d1?=
 =?utf-8?B?aGVrVmdNZTRCMlNjT3dUa1N3RTUvcnYvMzRHdmVGd3c5SHBZNlVLSTRGVmVr?=
 =?utf-8?B?ZVVBUktBbzlzbk1QNFNxbFA3QmtDcnI3anZXbGQrU2tCd2g4NUpDVzNZUEVp?=
 =?utf-8?B?S2QvZjJUMlFnUmJPMWFCeVBaNTdhNnRiLzNjRERXN0l2dGJFczVRYnhySnh6?=
 =?utf-8?B?RzhrbHlyL3lhZEJNTlJYcUgrNkowV2xMWWZQNitTaHBHSkZWV2VoMWlzY2RG?=
 =?utf-8?B?MmhrbjJWb29DbnhSZUZNOHhPQWNPOTdwejNJaU5IdWZoWlVZWTdSTnFwSDBt?=
 =?utf-8?B?bDFJRk11R1RkbkJweVh3MHkzTW40bkJKb0ZWQVFzcFhobTc5T1pHMmhKZVBj?=
 =?utf-8?B?cDk1N08yUGRyYzZMY1ZBbDJPbG11QUt1NFZQK3NvejYrR1k5YzlUcnc5bHlh?=
 =?utf-8?B?amp2TWRBeFExbUlzcFg2WVVJN0M5ckVuNFhubkhCR01GVTFFZmo2WWR4ek1H?=
 =?utf-8?B?R0pKNndNNzhwN1FIWDlxc0FadjZVS3RkOEI0V1E5V0VqNk5lN2VuUWd1cWFn?=
 =?utf-8?B?MUc3UEJKcmpBQ0pSSU5GTWNsVXR3OUttNTFadDI5ejNzUHhoODI1N01aNGxU?=
 =?utf-8?B?TXVkM0xmZUhsd0ZSbkFDTVlZUDYvSWtmQUVwT3pWZzZOSEROd0cyWURraCtj?=
 =?utf-8?B?MDB1OVlJSldneXMxQ0pldjYvYzFaWUJqejVQOFBEZFZwb280VnF2TE8vMkZB?=
 =?utf-8?B?b1NaMVAzczIzM0Racm9kSFhmU3NpTXkrbGMwU0RBeEZQMVpWZmZBOW9SRDBI?=
 =?utf-8?Q?1+V+EQwFmoQk8f5VUcVxK/kiP9GqdmvzsDY3TCf8H51E=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U0ZtdFJzam1yRjM5YXRHS1dYYmxPMU10UkJFRG0xRmk3dEdKRFh3M3l5R2xr?=
 =?utf-8?B?V2xRZEh3azh3R3JFVGMrTWo4T2IrK0MrWWNPRUtCMVVuK3VqMStJVk02L1dN?=
 =?utf-8?B?a3EvTkVrNU40RjJVUDhYNTNEOEtzSlJVYWZmRmtmVXZ0UTE0em01ZGs4c2JC?=
 =?utf-8?B?RkZheS9ETkwzOVM1Vzc0ZlowYkhDcVUwQXluOHczZzR1Z1NtQ2RoM1M5eVJo?=
 =?utf-8?B?R3hwUXcrOXhNVlc4ZFJLUzk4MUVrdk11RGIrRFVJU09JTDJxZlFMY2RIZFNt?=
 =?utf-8?B?VEVta1p6ckpDb3ppbmpraStnTXRHWG4rQ2pFVnZBR0o1Sk1sMGFCOU0rbGV5?=
 =?utf-8?B?Q3BWWDZJUEJXdHRkR3JkMWh0NGN2Z0hoUjM0L05FUEpsWHNqcCtFc2dZOUYx?=
 =?utf-8?B?UE5WS1lWU3FtL3E4L2lFQVY5aDZSbDF1SzdNNXhvQi9LOGRTOG5Gb0hDMVZH?=
 =?utf-8?B?TEFUb0JaOVY2eTJla0hwQi9WYTJWa2lVWExWMmk4azJkdTlObnROT0U5cTBt?=
 =?utf-8?B?cjRBV01odGljOFV2TitwV2toWkpaZ2Joa1ovSThSNERvZnY5QnhJdUhlMUUr?=
 =?utf-8?B?Nm1McFMweUpYNnVrMTN4Q20xNzF6amNRWE0zNC9XU2FjSnhUeEpaM0NIR29O?=
 =?utf-8?B?eHpPUVZqcHZvekI4ZE5JNWhNZ1BaaE5tc051Q0dmR093Qm5TOUNIWVNVbWoz?=
 =?utf-8?B?MW9DektQTS9jZmZZQTZNS0tCK1p3Q2F2NENPb0VZRmJQYmxlZHM1b0lrbVJM?=
 =?utf-8?B?TjNzeWZJYzEyNXVFMCtHdjhOZDdKWHovTkU5TWVaWldDZlNBTmdqVnJrNVpD?=
 =?utf-8?B?NVptMlhmcVBWY01lbXRUZU83enJiRzZHYWZoN0dlSEVTbzFRSU9VVXF2OC92?=
 =?utf-8?B?d3oxRUF0L3NoMm92aGxObG9OZWxmREs2QWs1WmdETXFhK3ozZnZrNi9RS1Y4?=
 =?utf-8?B?WStwanBkblhMeExxcUppeWZXVFUvWjBtUGIxa0h1aHRmc3Z2aTFObHpESVUy?=
 =?utf-8?B?MnF5VnM5QWJydWJSQzFmVFNPY3J1a2twTXNSRVY4U1VWdjN0b1hKejV0UFRU?=
 =?utf-8?B?NXgxUzVVQnZsdGVuMVNXb3ZucVJoVC9TQVhBaUZYeFV2L3RKTWgxZEJXL0Zw?=
 =?utf-8?B?WUdFajhZUmptQ1NQTHd4YW9kRkRCL3FqUStyNDB1WDVDQmtGTldEUGFUQXlO?=
 =?utf-8?B?R0JnbENYUFNWNnBkUWRnYkJ6Z1VsdCsrcEhwTXRuSGlCRVhZa2xyeVRzbDNz?=
 =?utf-8?B?NDFFT2p3eHhyM1loSldVUkhTajVZOEplRlVHdmI2ODBBK3k0TmUvS0NDNVFm?=
 =?utf-8?B?Y2c1U1VqVTZ3ZHJyVFZmOTZjUGtqTnFwNFI3QVZFTHhjSDBOYS9pUnJQTW0r?=
 =?utf-8?B?amhLR1ZKelJzNkJudXFDSFd5UHVHOE5TVitoRXBsU1M0dkhyKzBDS3UwMG5z?=
 =?utf-8?B?QkM2NmhMaGJHYjMzVmkweXJhaTQ4NGZ3TlBSYmpUUDduOHZnSE9aT3c3S0kv?=
 =?utf-8?B?QjUrb0ZwYWhLMnFTcUEweE9SemJmTVJrN0dCdnNZQlQ1blRnQUppTjJtRy96?=
 =?utf-8?B?RkZZcERZc2M3d0pNWWMzcUdOdmNhL2JFMkJUMmtCUTVZUGRYQWZOemlIOFNx?=
 =?utf-8?B?eGpCK2U5REpoZkd5ajl4VEE4RGJIZzJZUG1XMUk1VlhRdWdid09qLytGNklD?=
 =?utf-8?B?QU9NbDlYeDFoV244T3JrV245MGNqN1k3aWZ0bVN1RjBZOEtaeXJOeWhrSkx5?=
 =?utf-8?B?TkYrUEtxVFZkMVVEU0kyVktINEFldGxKdmdyb0FjVWhTSG9sS21OSFJKTXpY?=
 =?utf-8?B?NHp3b2d4RVpZUVdtME1HY3VQUzNMSzgvZmNHa2dzdzI0eTVabkpGVW5QT2NY?=
 =?utf-8?B?Y2hscXVtRGxMYWdOR0F6bFFpa3M1K0RGOE9oSDFRSkNKUmY4ajhRYmN1YldL?=
 =?utf-8?B?UHVvRkJ2WExLTVA3Z3g0TmtsQi9INk1PK0U3bTdzMU5FWGZjV1FzbTF3Z3pC?=
 =?utf-8?B?TTRlL29FRXNSWUNrZnpyUGhGNjJ5bU1zOHdaRmYrM3U0M3VsNFVJT1Q0ZmxT?=
 =?utf-8?B?a3NSYjh6UEFkcGNkTVA3N3hpR05VMS8zak16OWgwdWJQS1JTbFRieHFMRnJW?=
 =?utf-8?B?d0E1MFZOVmxRejNVaTR4K3ZQUy9wWXJvbXliUXlycHExQVJHd3EvbjhGWVBj?=
 =?utf-8?B?S3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 450f1c82-6452-4ec3-e16c-08dc7a3b0160
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB4972.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2024 08:41:43.2488
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: doBewC2Kf8/KvzOCvXU+4WX7P9HoN19F6Qa40sULqKfxcIWBw0pvpKvV1dhDKBTI4g5M9jY1O6cI8m++pYmfdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4983
X-OriginatorOrg: intel.com

On 5/21/2024 1:09 AM, Sean Christopherson wrote:
> On Mon, May 20, 2024, Weijiang Yang wrote:
>> On 5/17/2024 10:26 PM, Sean Christopherson wrote:
>>> On Fri, May 17, 2024, Thomas Gleixner wrote:
>>>> On Thu, May 16 2024 at 07:39, Sean Christopherson wrote:
>>>>> On Thu, May 16, 2024, Weijiang Yang wrote:
>>>>>> We synced the issue internally, and got conclusion that KVM should honor host
>>>>>> IBT config.  In this case IBT bit in boot_cpu_data should be honored.  With
>>>>>> this policy, it can avoid CPUID confusion to guest side due to host ibt=off
>>>>>> config.
>>>>> What was the reasoning?  CPUID confusion is a weak justification, e.g. it's not
>>>>> like the guest has visibility into the host kernel, and raw CPUID will still show
>>>>> IBT support in the host.
>>>>>
>>>>> On the other hand, I can definitely see folks wanting to expose IBT to guests
>>>>> when running non-complaint host kernels, especially when live migration is in
>>>>> play, i.e. when hiding IBT from the guest will actively cause problems.
>>>> I have to disagree here violently.
>>>>
>>>> If the exposure of a CPUID bit to a guest requires host side support,
>>>> e.g. in xstate handling, then exposing it to a guest is simply not
>>>> possible.
>>> Ya, I don't disagree, I just didn't realize that CET_USER would be cleared in the
>>> supported xfeatures mask.
>> For host side support, fortunately,  this patch already has some checks for
>> that. But for userspace CPUID config, it allows IBT to be exposed alone.
>>
>> IIUC, this series tries to tie IBT to SHSTK feature, i.e., IBT cannot be
>> exposed as an independent feature to guest without exposing SHSTK at the same
>> time. If it is, then below patch is not needed anymore:
>> https://lore.kernel.org/all/20240219074733.122080-3-weijiang.yang@intel.com/
> That's a question for the x86 maintainers.  Specifically, do they want to allow
> enabling XFEATURE_CET_USER even if userspace shadow stack support is disabled.
>
> I don't think it impacts KVM, at least not directly.  Regardless of what decision
> the kernel makes, KVM needs to disable IBT and SHSTK if CET_USER _or_ CET_KERNEL
> is missing, which KVM already does via:
>
> 	if ((kvm_caps.supported_xss & (XFEATURE_MASK_CET_USER |
> 	     XFEATURE_MASK_CET_KERNEL)) !=
> 	    (XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL)) {
> 		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
> 		kvm_cpu_cap_clear(X86_FEATURE_IBT);
> 		kvm_caps.supported_xss &= ~(XFEATURE_MASK_CET_USER |
> 					    XFEATURE_MASK_CET_KERNEL);
> 	}
>
>> I'd check and clear IBT bit from CPUID when userspace enables only IBT via
>> KVM_SET_CPUID2.
> No.  It is userspace's responsibility to provide a sane CPUID model for the guest.
> KVM needs to ensure that *KVM* doesn't treat IBT as supported if the kernel doesn't
> allow XFEATURE_CET_USER, but userspace can advertise whatever it wants to the guest
> (and gets to keep the pieces if it does something funky).

OK, I think we can go ahead to keep KVM patches as-is given the fact user IBT is not enabled in Linux.
I only hope other OSes can enforce both SHSTK and IBT dependency on XFEATURE_CET_USER so
that user IBT can work well there.

Then IBT can be exposed to guest alone because guest *kernel* IBT only relies on S_CET MSR  which is
VMCS auto-saved/restored.

What's your thoughts?



