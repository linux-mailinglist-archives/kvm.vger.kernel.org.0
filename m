Return-Path: <kvm+bounces-29404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EBD989AA2EA
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 15:21:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 182B31C22306
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 13:21:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2B3219DFA2;
	Tue, 22 Oct 2024 13:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ltBTq9i7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C7D199FC1
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 13:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729603265; cv=fail; b=hy+CA19hUN5tjCGb2OYIguUVmA7lDXFSkzPfKxl6c3EIbdVGTgjrO7AKyPyL67M+wm1p0sZGEpMANfNlR0mJm2yGqxniIQHQ3G+NIq+AhqHI1+VPgWluHTIOGOsAPuVBf7CFF0ULTtjd86mSl1VJW3QAJopLiCWRz0QvGLMm9y8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729603265; c=relaxed/simple;
	bh=tSGYn2OfYtQFS4xZh0t/3AF/bn1MgVJTY0jBp59QIhI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Oy7p1Bp0kZiDSGSnHa8ABF+rOvzwn43KdspD3ABRjTag3pvuowLvLwu86HP4/sYbYYMBvMXqzRrRSAWMQyqH3REHgWMPdd37h10R7xcGKapmGcTgnu9qdXDpWz0wyc5dilRdsTwp8PM80TWvhlHG8ft6GqAfKpNv+RlrGqxmH10=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ltBTq9i7; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729603263; x=1761139263;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tSGYn2OfYtQFS4xZh0t/3AF/bn1MgVJTY0jBp59QIhI=;
  b=ltBTq9i7Qra27KUCcQR1JrMDgH71FP2YS2Sbevt22a/81CqEebOIusvH
   oZcz7pKd1VLhMQ8W2pk+Jb1kjjAPtDQZBuBFWXSbW9DSoBcR9WSzTbmch
   JDTeBU4WqS4F9pvYjlLxvYVotNnzLTl5AeLXWPPdryYkLJDu5yKF/gz3e
   NTeQSMb7TkJMmQ6OgvKWrx8X/2slOL1KmMiK1jfy/yOQiRUjcNbDzq7+G
   Ih2OobH/YFXP2wAIYUnQhSeSMSnJfA6MGC/a6uwR/30izP9A97ea3lW28
   WkoFMeVykPW4kDl7OxEvu2nUAfHIyq8Pg0UpwkzA2FhUSISEiUymDOt+q
   Q==;
X-CSE-ConnectionGUID: koI/pQNvTCWIG6VgMPLnVA==
X-CSE-MsgGUID: Qc7jXDyASOuGwadDK4QSwA==
X-IronPort-AV: E=McAfee;i="6700,10204,11233"; a="16764600"
X-IronPort-AV: E=Sophos;i="6.11,223,1725346800"; 
   d="scan'208";a="16764600"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2024 06:21:03 -0700
X-CSE-ConnectionGUID: aRq+5osISjiXby+jnJAy2A==
X-CSE-MsgGUID: 8yn7H8aoRxyJOj0hmzJDiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="84689799"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Oct 2024 06:21:02 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 22 Oct 2024 06:21:01 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 22 Oct 2024 06:21:01 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 22 Oct 2024 06:21:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ULrTmTtx6FszG1s21DhENU95npXVAusMt8RAYxmzY0YQu2hhyfTAozu21rBz+hnXpdmMWqAgzs6rcJeiuBaxqW3V/fTipPFJFlrUx2T/duLK3smkJLzIY6CO0VXHZQ6D6e3cTQtOLAb82Ow3QyFASmoNo+fN+wfsICihKcS/jqtPx4Q5qR/q7sFyq+EhXcsb5nl+nrPmQBTRLrN+e7G8pEb3aoE7rUg7oMGWBf3hdC5p51GKImM1zglu6GBLr/OCFcK65/67EcI54RHyDeTHNBlHNFvaB8UqoD1oopkpQPSuAcMA56mmJBMYGehX/of1SEr1ZrQXblap3DUnEPCsYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1WFHU88mbBz8mSRvCKrDLQONgNJKhzN4J8TM+n/LOFo=;
 b=jkM95nYk1EQjdOLZJl/FZ83dZEXTjzQMnL6ds5AG85ILd2rzyfIDF9pff1dT+fHZ404rhAsQ4tmcW8I9bj8va0dZmEbZpMOCa4CHgS+9lmad6Z5rwqMqKCqS7L+hLv6ft1OlxbzWQ4HAvIH+id5QxV66HDyIob/gpfcf3R3OfAx5tWfNyZeiQAhMufrfl5IOpG0/wAnBSO7mE65hllgkzrs8pVrNtWhllFJCWUtcSOTeHr0H0gX/DscpEGC6m2UhGw8Ei6/PE96r+RSfs6Zty/lK9vd9aIeaFquuhVqRvG4KIqr43N3Q8ijA1QitblBt1BgduiGzny1kmLg9HYkqRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CO1PR11MB4994.namprd11.prod.outlook.com (2603:10b6:303:91::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.16; Tue, 22 Oct
 2024 13:20:58 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.8069.027; Tue, 22 Oct 2024
 13:20:57 +0000
Message-ID: <2f83a298-8212-4d7b-8fa8-b03c939e054b@intel.com>
Date: Tue, 22 Oct 2024 21:25:33 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/9] iommu/vt-d: Let intel_pasid_tear_down_entry()
 return pasid entry
To: Baolu Lu <baolu.lu@linux.intel.com>, <joro@8bytes.org>, <jgg@nvidia.com>,
	<kevin.tian@intel.com>, <will@kernel.org>
CC: <alex.williamson@redhat.com>, <eric.auger@redhat.com>,
	<nicolinc@nvidia.com>, <kvm@vger.kernel.org>, <chao.p.peng@linux.intel.com>,
	<iommu@lists.linux.dev>, <zhenzhong.duan@intel.com>, <vasant.hegde@amd.com>
References: <20241018055402.23277-1-yi.l.liu@intel.com>
 <20241018055402.23277-4-yi.l.liu@intel.com>
 <e5cd1de4-37f7-4d55-aa28-f37d49d46ac6@linux.intel.com>
 <521b4f3e-1979-46f5-bfad-87951db2b6ed@intel.com>
 <ce78d006-53d8-4194-ae9d-249ab38c1d6d@linux.intel.com>
 <bab356e9-de34-41bb-9942-de639ee7d3de@intel.com>
 <9d726285-730a-400d-8d45-f494b2c62205@linux.intel.com>
 <fe88f071-0d06-4838-9ce6-a5bcccf10163@intel.com>
 <965fe7e8-9a23-48a7-a84d-819f0c330cde@linux.intel.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <965fe7e8-9a23-48a7-a84d-819f0c330cde@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR01CA0198.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::7) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|CO1PR11MB4994:EE_
X-MS-Office365-Filtering-Correlation-Id: 900bdbee-462b-47e1-4e9f-08dcf29c5d7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YVd4TGxJZzhPR0lhNVE3V29OYW5scTNjUmU4RnM4TzJPVFVUVDFpbk40RHF0?=
 =?utf-8?B?ZVE3L2Jkbm12QkI3dXJHcnhYQ0xrQ0ZVRjRXRm1Fc29Cak1MVTRTSnFsazc1?=
 =?utf-8?B?VmwySE9RVWtxVlUybTNIc3lDYUNrMjNHWjV6Y25RNnBGc1lQcEhUSngxczEv?=
 =?utf-8?B?UXd3dXlZaWlOU3c0NXBTZ1NPdVc4Z0doMzRBR3QvUFhqWjdCU0s4Q2JjYU1q?=
 =?utf-8?B?Y2poR1JwbnZYQk5HeXNteHFEcGlwKzljb0NJeEphYUQ3RFJIck5LVGg3Ykwz?=
 =?utf-8?B?bksxN3hlOHN6NEM1RWNXakxnc0Myekp1dHJkb2VSWXc3QzRIc3hWN3hWM1Jj?=
 =?utf-8?B?OHBJK0lDbHBJb1ppSXZSeDMyVmpPSVJINm0xMUdWRnVNT3R4N2kxU0llSDBp?=
 =?utf-8?B?S0M1cUM1TFFpdS9YbUdxTnlwZEhJVlYxM2xDOHltZEVhRElZMXZlTzc0UW1E?=
 =?utf-8?B?NFJhU1l4d3VrdnJlZmxLYVpLTGE0ZDhicDRzckNRUnVLb1dJTmRnbVF6bHlR?=
 =?utf-8?B?dTZ2MS9sbDQvYlF1NW1IclU1QUZDd3NpT0I3S1cxQWc2NHJDNEpRdXY0SGJC?=
 =?utf-8?B?MzU4SjRDclhhL3RuSndzRjVwZUdYNWtiYzIrTzNqSmFubENMZ3BuQmZkM0Nh?=
 =?utf-8?B?MEoyejNTM1FaSjVNV21qeVFoNGtmUElxV1NtSEFhbm1WaXhSaTYvNE9UZmxK?=
 =?utf-8?B?WmQzbFA1eVN3enhFeGdvRkxoRjFxV1NiNFBtUEVhSHc1WEx1TXZmNFJ0WEt4?=
 =?utf-8?B?a2krT1NhZ3BFaXNQZ3dhUytQeHF1ZHBrWVc2WE9QVWM4QWg1eXRLb0FzNmpt?=
 =?utf-8?B?cXhORFVHc1ZYeFNRZ0tGRG5wQVh0SEw1eEtxNlllNkthKzlTTHRGRUlBNWdj?=
 =?utf-8?B?RjdyRC9wYzZtOXE1aCticUFNL1Y2OHBwYWU2VnZYMDdXZHFXNjNLeHpBSjhl?=
 =?utf-8?B?NWdRNUpGZStzbjJLa0FCNFBWVEZBRjZraTZaaFdwdzNTS2ZVajdtdkhBTVpV?=
 =?utf-8?B?VzFnWUZ6RXJ3V2VlL3ducXRNVGEzRThBM29vQ0tFYjMrV3prOUdDL21oNUR5?=
 =?utf-8?B?T3AxOVRyZllsb3dhVHFraUthV2VRa3hRWUhwNk9UOUdCZlRVN1BGNWd1Kzdv?=
 =?utf-8?B?dldXOWFSSzZ1ZnFreDVEeEhCUTdJNVZNdXYxUGdxT2k5aHlOMzZOMUJtWDh2?=
 =?utf-8?B?YjYrM3MvNDdNU2IzTTB5WUZvMnNERXVKSzdNSHh0Y0MwenRWZk5YenVodWJu?=
 =?utf-8?B?QTlNbE9nbG55WUVrZjlFa3BhWkNYYjlPZkNaM2l2Q2VkQzNSbkx1Y0NKUG5T?=
 =?utf-8?B?Yitxd1RycDYvTXpxMUw5cks0alhiclBYb0xFdzE1VUplbjM0d1BqQ0xaY25O?=
 =?utf-8?B?YjJIRGtIS2QvS0FPQmJvZFg4Vy8xNmVJSmlvcVRDVGpoa3RoUmZUMnB2OFkz?=
 =?utf-8?B?ZjZuOGQwR1kxTFhSb3hDdHRJTFFaOElTOTFPelhwVFBPNkk3eVpVREo1alBq?=
 =?utf-8?B?Z29Sa2FPUXhadnJWTTNuNVl0bHpGU0xKM3pBYlNVT1Z3cTh0VGdVL2ozNmtH?=
 =?utf-8?B?VXIrbWkxaTJVSU5GY3c3RFlNWENtTHh2SGRJU01wQ3JpaGJlaUpSMzkyM3pX?=
 =?utf-8?B?cStFenlNdFFiQ2NhQ0d6WU9rN3VBRWdER3h2N2xHZ1JWM0cwdGVBaDY2SzVE?=
 =?utf-8?B?dmdDNjdkY2czbFl6QStrNEJCYWNOcVphVitWZTh6M3Y4K0tjSWdHa1RBMFRh?=
 =?utf-8?Q?Zdmbj8CFpEJt99AN/Q=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WlpScHREbmVUODJVbThiWGg0Wjc2dG55WjVQNHNnN3NtbFRlZTF5L1BWY21k?=
 =?utf-8?B?UGRZeHpkZnBtNkEyZWZleXZOMzlFcG9QZUVJVk1PenE0Nld0SGVlVkVBWVFS?=
 =?utf-8?B?STVnQU9QN1d5MlY2dlVIemRaK0NaMDNMRzJQY1NINi9VRVJNODNZdEhKRFRu?=
 =?utf-8?B?eUw0MmFVbHpUbndWbVQ5SE9uUk9RZmU0ZzA1bXVkZ0h5QzJ1bVZ3VFZxM0c5?=
 =?utf-8?B?Z2RNS1Fla1M3UTB1cHBOZ1MrSU9DSGgyUUZuMjZTQlBSYmlZVk5vYkc5QnJo?=
 =?utf-8?B?ZVR4WUlZdnh5R2pVWlJ0K0RRdXlhbnkreFk5UFpkVkRhWXhnQlFHS2hSNk16?=
 =?utf-8?B?ZGFZZzJDWnZqTXZjU24zdEJsUVNEK2hWS2IxODhPaXV0WXFaUStncitQV2xS?=
 =?utf-8?B?VnB6OUhQUHl1b0RTSElMemM5NjBRZE5QQ2JjQ0pOTmRncHdOd2syNklXNWdB?=
 =?utf-8?B?RXlnVGRZWnc4YkdJRVgzc2JudnVZeTRqbWhaWnRaSDdwdUV4TlFXVFNRczFJ?=
 =?utf-8?B?cGJ3NnpQWFNRbjhDbm1pUGwxamhrS1FJa3Njd3NlbTBVUWdtTnpCaDhzL05q?=
 =?utf-8?B?dGs2WjNIeE1mZk4zc0htUnhWV1orWE1DNU9QNTdwMDJzTVYrQUFPV3RVMmRX?=
 =?utf-8?B?SDhPWXpUV21JVlJUK2c0Ykd2bGdYbm1PNm9TdG1oZlB2V25xaGhNZ3RyS25Y?=
 =?utf-8?B?OFl3ay9CbEZ5ZHplVi9QVXI0dFY2dXcwU2lock9GYWc3NmNDc2Z1dWkvSWpY?=
 =?utf-8?B?VnB5ZTkxSUs2bjJ6R0lIdWRUb3NpMHNWS1oxVE9Vc3VJcmtDeENaU3pFRk1i?=
 =?utf-8?B?eGNtUU9NSk1Iay9HNFlMdk9ROCthRTBuL2JycGQ2YVVtbDluR2dscjJyWDJV?=
 =?utf-8?B?VE5SOXRrQkRZelROQjVXYXhUWWhNcjFOZ25Ma2FuYmhFS3RMaHNjamdZYjk2?=
 =?utf-8?B?UVlqM1VJS3Jsb3E3VldaMGZ5ZmttWm92OU52cXRhTmpCLytaYmpNOVF2cW94?=
 =?utf-8?B?aUQ3aE14U2Z6dFNPSWQyb0NnWVJ3amE2YkVKZzAxdTh2a0ExTDhwTTNSYVdo?=
 =?utf-8?B?Wk1jakdLZE1BdVpySmtpZnVrSU5HWlVFcXI3QXRmRXBHS2Z4d2dlZ3EzaENX?=
 =?utf-8?B?bkVKYWk0ZmhPelJHK0tlbndsOG0vNFlpeStHT1RKVUNzUzJONnIvWTF2Qmdk?=
 =?utf-8?B?ZXYxb2FvWU9XL1Jwc2k5dkJJZGVFbVprMW5qYlR6VVdGUGc0c1hrUS9UUEwx?=
 =?utf-8?B?cDRCaERjSU1rejJRdHljM3BDWXZwRDhFNjNSNThhbkI0M2VMMHV5aUJiejRP?=
 =?utf-8?B?UlF5aktHdS91dk1UVTFETmhEdXQwNy82ZUlMVEYraTN2cmh3UWs3T3QwRVFv?=
 =?utf-8?B?cFk3WlZYS3JGSkg2VEFwY0NXeERiMGdyRmpyaVgwWUcrSkhCeTgxMzZYWGxv?=
 =?utf-8?B?WmxJZWI2N21CM2p5MzJVYUlNY1crRUxUWW0wUXl3NUZ0TVUwNHJtT2p1RERF?=
 =?utf-8?B?RW5YZ0c2Y2xjSlV0b2lPbkI0RUFaQi8yMXNpcFlvekE0eTBPM1ZmNFgxREhD?=
 =?utf-8?B?Lzl2MGFSZzNjSUFBTytxMFVGcEZMYUwwYlFSTUNpcDdFcnkzbUg0UVdZRGxI?=
 =?utf-8?B?U2FYcE1BN1RVcjNwSmlkMGFFM25wVFdZVGZDWDFKUEtLTzZJZ2FrRlB0WVVz?=
 =?utf-8?B?cHpwUzZ4VXE1eDYvYnVNRUYydjJER2F6NDR6cXo3TlBUaXJweURMUUJKdXRl?=
 =?utf-8?B?dE9DeG83QnhVTXRHOEJUK0pLbldNZ2h6VFFEc0d1amRWd2JEVkxaMlYweHhD?=
 =?utf-8?B?RllUamFucllRd0MrdHNKMDJpNFRWdHQyWU1VS20rcVlSS1VoazcvbkhvWGpV?=
 =?utf-8?B?VkpmbXZLMm1rQ2t2djhVMlhsWmpWYzB0TGJMRGlPNFpOUkVzTmR5K0o3UW8z?=
 =?utf-8?B?N3c1UDJKRUZuQ1gyelV1YXJGMDE1dkkxZ0RBMDVtQXlqV3ZGZWlRbGYxUFhD?=
 =?utf-8?B?QlFLWm1DQ1RTenV2TkZZOUJrcVp2RVl2bDVqVEN1eGo3cEE4L205OHdGRHA3?=
 =?utf-8?B?eVZiOGpvWHl0VzN0bU1GbGJYbDgvLzdFRjFoSThiVlNtRVRJV3BQQnN5UkRT?=
 =?utf-8?Q?KgL/mwFUzzo5BGYaqgdwcqW63?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 900bdbee-462b-47e1-4e9f-08dcf29c5d7e
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2024 13:20:57.8773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K4rvS14Q4HYs52VDLB7rQ8K5lsmYhgX33ivPVOBOiKNapAgLkA50y2tGLnWqGbRiNK1ogTPR1HhUsC3Hp0qBXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4994
X-OriginatorOrg: intel.com

On 2024/10/22 19:23, Baolu Lu wrote:
> On 2024/10/22 17:38, Yi Liu wrote:
>> On 2024/10/22 17:23, Baolu Lu wrote:
>>> On 2024/10/21 15:24, Yi Liu wrote:
>>>> On 2024/10/21 14:59, Baolu Lu wrote:
>>>>> On 2024/10/21 14:35, Yi Liu wrote:
>>>>>> On 2024/10/21 14:13, Baolu Lu wrote:
>>>>>>> On 2024/10/18 13:53, Yi Liu wrote:
>>>>>>>> intel_pasid_tear_down_entry() finds the pasid entry and tears it down.
>>>>>>>> There are paths that need to get the pasid entry, tear it down and
>>>>>>>> re-configure it. Letting intel_pasid_tear_down_entry() return the 
>>>>>>>> pasid
>>>>>>>> entry can avoid duplicate codes to get the pasid entry. No functional
>>>>>>>> change is intended.
>>>>>>>>
>>>>>>>> Signed-off-by: Yi Liu<yi.l.liu@intel.com>
>>>>>>>> ---
>>>>>>>>   drivers/iommu/intel/pasid.c | 11 ++++++++---
>>>>>>>>   drivers/iommu/intel/pasid.h |  5 +++--
>>>>>>>>   2 files changed, 11 insertions(+), 5 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/ 
>>>>>>>> pasid.c
>>>>>>>> index 2898e7af2cf4..336f9425214c 100644
>>>>>>>> --- a/drivers/iommu/intel/pasid.c
>>>>>>>> +++ b/drivers/iommu/intel/pasid.c
>>>>>>>> @@ -239,9 +239,12 @@ devtlb_invalidation_with_pasid(struct 
>>>>>>>> intel_iommu *iommu,
>>>>>>>>   /*
>>>>>>>>    * Caller can request to drain PRQ in this helper if it hasn't 
>>>>>>>> done so,
>>>>>>>>    * e.g. in a path which doesn't follow remove_dev_pasid().
>>>>>>>> + * Return the pasid entry pointer if the entry is found or NULL if no
>>>>>>>> + * entry found.
>>>>>>>>    */
>>>>>>>> -void intel_pasid_tear_down_entry(struct intel_iommu *iommu, struct 
>>>>>>>> device *dev,
>>>>>>>> -                 u32 pasid, u32 flags)
>>>>>>>> +struct pasid_entry *
>>>>>>>> +intel_pasid_tear_down_entry(struct intel_iommu *iommu, struct 
>>>>>>>> device *dev,
>>>>>>>> +                u32 pasid, u32 flags)
>>>>>>>>   {
>>>>>>>>       struct pasid_entry *pte;
>>>>>>>>       u16 did, pgtt;
>>>>>>>> @@ -250,7 +253,7 @@ void intel_pasid_tear_down_entry(struct 
>>>>>>>> intel_iommu *iommu, struct device *dev,
>>>>>>>>       pte = intel_pasid_get_entry(dev, pasid);
>>>>>>>>       if (WARN_ON(!pte) || !pasid_pte_is_present(pte)) {
>>>>>>>>           spin_unlock(&iommu->lock);
>>>>>>>> -        return;
>>>>>>>> +        goto out;
>>>>>>>
>>>>>>> The pasid table entry is protected by iommu->lock. It's  not reasonable
>>>>>>> to return the pte pointer which is beyond the lock protected range.
>>>>>>
>>>>>> Per my understanding, the iommu->lock protects the content of the entry,
>>>>>> so the modifications to the entry need to hold it. While, it looks not
>>>>>> necessary to protect the pasid entry pointer itself. The pasid table 
>>>>>> should
>>>>>> exist during device probe and release. is it?
>>>>>
>>>>> The pattern of the code that modifies a pasid table entry is,
>>>>>
>>>>>      spin_lock(&iommu->lock);
>>>>>      pte = intel_pasid_get_entry(dev, pasid);
>>>>>      ... modify the pasid table entry ...
>>>>>      spin_unlock(&iommu->lock);
>>>>>
>>>>> Returning the pte pointer to the caller introduces a potential race
>>>>> condition. If the caller subsequently modifies the pte without re-
>>>>> acquiring the spin lock, there's a risk of data corruption or
>>>>> inconsistencies.
>>>>
>>>> it appears that we are on the same page about if pte pointer needs to be
>>>> protected or not. And I agree the modifications to the pte should be
>>>> protected by iommu->lock. If so, will documenting that the caller must 
>>>> hold
>>>> iommu->lock if is tries to modify the content of pte work? Also, it might
>>>> be helpful to add lockdep to make sure all the modifications of pte entry
>>>> are under protection.
>>>
>>> People will soon forget about this lock and may modify the returned pte
>>> pointer without locking, introducing a race condition silently.
>>>
>>>> Or any suggestion from you given a path that needs to get pte first, check
>>>> if it exists and then call intel_pasid_tear_down_entry(). For example the
>>>> intel_pasid_setup_first_level() [1], in my series, I need to call the
>>>> unlock iommu->lock and call intel_pasid_tear_down_entry() and then lock
>>>> iommu->lock and do more modifications on the pasid entry. It would invoke
>>>> the intel_pasid_get_entry() twice if no change to
>>>> intel_pasid_tear_down_entry().
>>>
>>> There is no need to check the present of a pte entry before calling into
>>> intel_pasid_tear_down_entry(). The helper will return directly if the
>>> pte is not present:
>>>
>>>          spin_lock(&iommu->lock);
>>>          pte = intel_pasid_get_entry(dev, pasid);
>>>          if (WARN_ON(!pte) || !pasid_pte_is_present(pte)) {
>>>                  spin_unlock(&iommu->lock);
>>>                  return;
>>>          }
>>>
>>> Does it work for you?
>>
>> This is not I'm talking about. My intention is to avoid duplicated
>> intel_pasid_get_entry() call when calling intel_pasid_tear_down_entry() in
>> intel_pasid_setup_first_level(). Both the two functions call the
>> intel_pasid_get_entry() to get pte pointer. So I think it might be good to
>> save one of them.
> 
> Then, perhaps you can add a pasid_entry_tear_down() helper which asserts
> iommu->lock and call it in both intel_pasid_tear_down_entry() and
> intel_pasid_setup_first_level()?

hmmm. I still have a doubt. Only part of the intel_pasid_tear_down_entry()
holds the iommu->lock. I'm afraid it's uneasy to split the
intel_pasid_tear_down_entry() without letting the cache flush code under
the iommu->lock. But it seems unnecessary to do cache flush under the
iommu->lock. What about your thought? or am I getting you correctly?
Also, I suppose this split allows the caller of the new 
pasid_entry_tear_down() helper to pass in the pte pointer. is it?

void intel_pasid_tear_down_entry(struct intel_iommu *iommu, struct device *dev,
				 u32 pasid, bool fault_ignore)
{
	struct pasid_entry *pte;
	u16 did, pgtt;

	spin_lock(&iommu->lock);
	pte = intel_pasid_get_entry(dev, pasid);
	if (WARN_ON(!pte) || !pasid_pte_is_present(pte)) {
		spin_unlock(&iommu->lock);
		return;
	}

	did = pasid_get_domain_id(pte);
	pgtt = pasid_pte_get_pgtt(pte);
	intel_pasid_clear_entry(dev, pasid, fault_ignore);
	spin_unlock(&iommu->lock);

	if (!ecap_coherent(iommu->ecap))
		clflush_cache_range(pte, sizeof(*pte));

	pasid_cache_invalidation_with_pasid(iommu, did, pasid);

	if (pgtt == PASID_ENTRY_PGTT_PT || pgtt == PASID_ENTRY_PGTT_FL_ONLY)
		qi_flush_piotlb(iommu, did, pasid, 0, -1, 0);
	else
		iommu->flush.flush_iotlb(iommu, did, 0, 0, DMA_TLB_DSI_FLUSH);

	devtlb_invalidation_with_pasid(iommu, dev, pasid);
}

-- 
Regards,
Yi Liu

