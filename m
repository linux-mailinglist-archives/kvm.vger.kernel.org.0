Return-Path: <kvm+bounces-70113-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2O7pF8aKgmlfWAMAu9opvQ
	(envelope-from <kvm+bounces-70113-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 00:54:46 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B9DEDDFDCC
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 00:54:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DACA230484FF
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 23:54:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FCAE35CB9C;
	Tue,  3 Feb 2026 23:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iyh9tHTq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77074320CBE;
	Tue,  3 Feb 2026 23:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770162867; cv=fail; b=RfqSW19kVR4v6ck8QcTlpge7t0JrqOM42J/44vuwut+nuFueS6ppUPrecJKofZifUs8109/kHQ5s7ZtCJ3b0jCwDgC14HeiD8Hg3Noa1Lixj9b0UYJzw+rx3tGwAV+RFGdNYl514wOu6fxYyRA4rfbm0laUrwz9MafFxM75jPYg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770162867; c=relaxed/simple;
	bh=DziiSCPMh3l+yF609v1Gc2zuDyRDyMUWb1VtG7EFGEc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=aFqdftKrcyWsN1pEmTj5EeQPnOZTovRDdeMppstekDsFbc92emrDkALsPjkleESw5gRAqVIFGR89FJ7kbqBWCPPk9tvhNUoscNMrSq2FIQ4+cogpPI9MlHgXqCNiLR44O8rvfXbTePddayzcjoV93A/4TgKvKq4prdwZmb3jYY8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iyh9tHTq; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770162867; x=1801698867;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=DziiSCPMh3l+yF609v1Gc2zuDyRDyMUWb1VtG7EFGEc=;
  b=iyh9tHTqU/WTIHzANGBTgvOEO8zQcDbEy+KldJZTkiy0jwp2UReXnFsX
   q0OhJj5SlqR/ctbSfqsXcad0SdyvZ3ts7EutiEUhd4R1PigGauCOTgEtm
   o0ZsXyQFg6n36zwcJFGLYEdMXHF9mjLf6FtTTq9WNZ86w99q0RasUT5eE
   FFjMQK8EDx36lpoOCUgWD0EsbK3BiDa2d5O34oYKO9PIUd1zJjNJ9BkaF
   VrZsIJbVoYkujmbvuwgWJ3M0Th0g8v2qShvsM/XgHoYmxQWXGdsZv36ru
   28Og8lUHeAbJ+AT3BvTLhUHkVp+ZxJBHXE33aCavOUpe2VyKFZmVg6/qq
   w==;
X-CSE-ConnectionGUID: OvaeSjetTzO5qpVxllIBBA==
X-CSE-MsgGUID: DYaoytOzRiiyrbnC17ueUg==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="82456511"
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="82456511"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 15:54:26 -0800
X-CSE-ConnectionGUID: RyAOJx1rTRKMdKeGtA8vcQ==
X-CSE-MsgGUID: yZNya76lTUOOJyvmxf9yUw==
X-ExtLoop1: 1
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 15:54:26 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 3 Feb 2026 15:54:24 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 3 Feb 2026 15:54:24 -0800
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.32) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 3 Feb 2026 15:54:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sabmjAVDQAR0K4ENRu4Ey6EKEqqhyoGrZSZLu9/R1KCEhNw3BPnSJw4FoYIg15jmoUaVGUp5fslfjCYC9tyuljhuTqsXm+gPIPDLTPGK8EA1iNfc8cUjG+WWcb6dlq+PkJW8xUm5+yG8/9Df/Vg0lpP5iTyosVTkhJSdDuA8LVkfZcu7ePLMc+J1j319BSL0jQkqqSsB0GgQU9Rvj3gqJu0ix8zYjVHio4FSNi/fEYLQ1Yvrm6ftxXwP5FuceW50AJOehYK0QlbSuP4Y5bMu9XjU/0hsdb8HqYd0zuWg6BYQkzxPgDnyDjSufJvSw+dA9J9ZD5ecUGF5kQJfrtnxHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QNpCi7I/zKNpOEWso6nS/0wQYidzktBSzk4QQ/sD5Jo=;
 b=vSxaAtpov0u7wBwdgwmzHrettzlLcYJRkrQuM+u8PV+pwnTrMDpGtKHKMqpmuKQm5/givR/yGyGmixUlKBLvt+diwDn/KhH1s2WErM7gVTbcXY1xNP/GUaVK2ITlg2ZkPMnzk/9YtSBOch/hP8qME0dBX3OzBT0QNYj94Ud5hsUC2eS4Yg9Hw/7gzSsEEgWZpIdNhPGKjyvlIi7b0g/PtYzcoGDTbfL0c2A+q/RU1pzoWbLqLJj26FT0rVVp3gslbSEBBBwp+hq94Ee9MwpUWv3pqJH06JYv/uah0/VURz3BBPDd8SCL1H0cfnXBOFskD7KdMV1AY7JZVNM8ujZVxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB8665.namprd11.prod.outlook.com (2603:10b6:8:1b8::6) by
 CY8PR11MB7845.namprd11.prod.outlook.com (2603:10b6:930:72::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.16; Tue, 3 Feb 2026 23:54:20 +0000
Received: from DS0PR11MB8665.namprd11.prod.outlook.com
 ([fe80::fde4:21d1:4d61:92eb]) by DS0PR11MB8665.namprd11.prod.outlook.com
 ([fe80::fde4:21d1:4d61:92eb%5]) with mapi id 15.20.9564.006; Tue, 3 Feb 2026
 23:54:20 +0000
Date: Wed, 4 Feb 2026 07:54:05 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Dave Hansen <dave.hansen@intel.com>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<reinette.chatre@intel.com>, <ira.weiny@intel.com>, <kai.huang@intel.com>,
	<dan.j.williams@intel.com>, <yilun.xu@linux.intel.com>, <sagis@google.com>,
	<vannapurve@google.com>, <paulmck@kernel.org>, <nik.borisov@suse.com>,
	<zhenzhong.duan@intel.com>, <rick.p.edgecombe@intel.com>, <kas@kernel.org>,
	<dave.hansen@linux.intel.com>, <vishal.l.verma@intel.com>, Farrah Chen
	<farrah.chen@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin"
	<hpa@zytor.com>
Subject: Re: [PATCH v3 07/26] x86/virt/seamldr: Introduce a wrapper for
 P-SEAMLDR SEAMCALLs
Message-ID: <aYKKnf7K3lRdUcxl@intel.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-8-chao.gao@intel.com>
 <301f8156-bafe-440a-8628-3bf8fae74464@intel.com>
 <aXywVcqbXodADg4a@intel.com>
 <fedb3192-e68c-423c-93b2-a4dc2f964148@intel.com>
 <aYHmUCLRYL+JX1ga@intel.com>
 <aYIXFmT-676oN6j0@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aYIXFmT-676oN6j0@google.com>
X-ClientProxiedBy: SG2PR03CA0115.apcprd03.prod.outlook.com
 (2603:1096:4:91::19) To DS0PR11MB8665.namprd11.prod.outlook.com
 (2603:10b6:8:1b8::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB8665:EE_|CY8PR11MB7845:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e9038cf-b86c-4965-73c3-08de637f8c45
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aEtJZjhMYlRKTC9pd3RmZzZxNmVIRmd4b1NNZmRIZXk1ZkV0bzBLcFg4eW5S?=
 =?utf-8?B?bEVlUFRZQ3BwVkU5ajJPeUovU1E1bFQrb0htQ2ZJTFpncUlqTEkxaWJsZXhk?=
 =?utf-8?B?bFkvei8xTSt4Z3BtT0tWaTgzM3hmZ0k1NmhKcTJmbWVmVGFrNlpsOTB1YUlR?=
 =?utf-8?B?bHo2RGh1eU1ZaWZ1cmZhQmw1aUw3aVpmYW1BOTU1ek53S3BaNzBucWd0Sm95?=
 =?utf-8?B?eFZOY21icjJ6MmVuZTk0TUpjQ0JNVzhwQjhpV0lWcmtDZUJLYnhKSXpOdHBj?=
 =?utf-8?B?MHdyd0RrbVk1YWMxUkQ0Rm1rQmRrT0VBdFFzS0NtbmQ4cVlqOU12K2hzWHhI?=
 =?utf-8?B?Z2U1WWc3M2hoVi9NTExMTENqOC9nbHVGOVdrb1dySVhUeC8vOExScEsrQ3Ja?=
 =?utf-8?B?Rjk3L2ZUVmx6NHVyVjVqTDAvU09pWks1Q1ZwYXU0eEIwb0pjdFlSWktvdExE?=
 =?utf-8?B?Mmh2VXFubGFxWVk2OGpvb21Jb1hhMENFVjJISFluWnp2ekVrRzBFU3FKRXo2?=
 =?utf-8?B?Y1BTdU1na0gvaVorVVBpMXBLNWx1TzgxYWtDMnNZR0R6Q0hISWhYa2RDNzBB?=
 =?utf-8?B?S1FHVmU4TWVQS3BWRWYyQmViQm02OXppNGZjUU9sSXExbS82ajREbjROdFRK?=
 =?utf-8?B?K2drbWtjZFVXdXBjY1IrRlErZTE1MHZyNS8rQVdyZGF5RndvZ1hzdWpvSVFs?=
 =?utf-8?B?RjVLWXp2dUVnd3BQSzVLOXk4c3ZmLytqTnkwZW5jd0RjTE1hNGRja2JFSDZK?=
 =?utf-8?B?SzBRbEtjK09mcjJFSDdYc2tianh2ZVhPQ1Y2N3Jkc3k2MnR5U05XVWRRUzhT?=
 =?utf-8?B?bVhNdmVJQW5RVWZvbjgvWFNmTGs1UmozU3lxRjh2SzdOWDBUOHBhQmdESHdI?=
 =?utf-8?B?R3Q3Sm9PaDdUcXFNZW9leXlpQm1wZUN1UzZ5K1MwRVJza3BtaWVxMHlGRUMw?=
 =?utf-8?B?WStDZHE4QVRjQXQ4OW1OZ1hpRTFXMnY1YjluYXdyWVR2SEY0TCthZENzWlNK?=
 =?utf-8?B?VjQxLy83M0s5ZitwZEx6U1JPbUZKY3pETWVQVWlyRUFvS3RFckZLcGdQUnlm?=
 =?utf-8?B?SmVOSktKdXphVjhEeVJLaFVnWk8wZkV4SE5qZDFPK2ZVSWhiTnJDcHgzSi9C?=
 =?utf-8?B?bDFIS01OV0JQV0VVR3ozWDlqWkRDWnFjZmRTRzcvNnNNanZYVzhCZmlUUW1V?=
 =?utf-8?B?L0FHR2Q4RG9ZdlZSc0NDcDRybWxpaE1KbjJGbWZ2Z3AvYitVdDhYMVdLRWNQ?=
 =?utf-8?B?WXM1eGVNU0JxWFpyOFZ6MUZBY29Od0pCSnNiMTg1NzlTblU5Ulk0UWFHVDhu?=
 =?utf-8?B?Q1lQNUNqcFZxUU8raGZ5eCtrYVNIaHB2TnR2T2pLUkdVMmZzRDZsVEJBMHdz?=
 =?utf-8?B?N1RlRlZ6SGxLcXVJQXdxL3ZzNmp6VFdHbTdxU0ovRFhOQURhRGw4TEtucHRr?=
 =?utf-8?B?c2I5Wk9JQTNSdmREV3Q5QTlaWFZuUlR0OGF0WGdLQ2NvYk85Z0gzQWl6Nkc3?=
 =?utf-8?B?OWJnSGJ4VDJCb0IvRzNtMWErWGxCV2F1Z2R6TWFrd1NEWndVd1luZGhkTUd5?=
 =?utf-8?B?TVA0YkxYWVpRaXZQUVZqS0dqTGFCS2F3SDBPeDFMaUl3c3ExQ1EycWlXa3Ey?=
 =?utf-8?B?TVg4WTk2ZkpKWjRrNU5NSE1MYy9JMkRBdGRBbUl1eDVVVjlEUGlxcXE4ZDVR?=
 =?utf-8?B?SXhyemRnMTRwYkQ3bTVxc21uQUNXRTJ6MFIvQlBqOEF1dm9ZRk9SM2hweHQ3?=
 =?utf-8?B?ZDU2eE9HdDRDVkZudWZ6WE5EM2xyQzJTNUllL0dpNDVkTzViTnExU0xYYXNk?=
 =?utf-8?B?MTBCS241aC9OQkFjczlzUVVSSDJ3aGhLUGpzK0dBMlFyNzk3MnVrd1VKaTB0?=
 =?utf-8?B?dUtLdkZWbmp0YlRXc0dISTk1T2o0N2dTRVovNWNGTnZqV3hUdHVUREVCUENO?=
 =?utf-8?B?V2RvTFB3K0xRbm9VYUd0OVVkRXVwNE9rQzJscGc5dWpNQ25PcmdqQVJ1aVBm?=
 =?utf-8?B?a21pU3NEYzhqRGtIYUVHbGxqdnZHRXlZV2NXRGVoaWVNK2NSVzRObmgwbjFI?=
 =?utf-8?B?bEJOU3BDZ2VlSWZ4cFdWbFZWamhEblNNQVdwYytoazdDckh2alRnaVVuMERZ?=
 =?utf-8?Q?cIt8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB8665.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NU10MVVrWUtmRTIxSlUvQ0ExN3pFUWFQbFhyVFQ4NHZmYmIrNm1IWUt0ZWp4?=
 =?utf-8?B?d1pVQ2l2SE92dmFKT09ld3lPcHYzL2ZMa1RvRzhXRlBYOXJCa2pWb3BsNkQ0?=
 =?utf-8?B?d0tGcHA5U3lZb2xMRTFkc1o0VEZJZC85c3pzdFoyZmZaZTRoNk9aMERzWmRM?=
 =?utf-8?B?MUJRNXd5ZlRYdE8yVGc5V2gvYVFRZlAvTUszZWhZeUhVVmpFTk9JalRmY3Fz?=
 =?utf-8?B?YTBIVFJST3F6YzlGendTRm9yZkZrRjJyNWlSZDZTZHI1NWJtRXpmWUl3MWxw?=
 =?utf-8?B?VElmaW9XQnlKUVoxcVkwSllJTU5iK0Vra205RXYxVmVkVDN3ZFUwdmtOU0g4?=
 =?utf-8?B?SC9BS1V5cFpFejdLMjhlL29oSDhMOFJCRWdwSE0yV3pOa2pONEM5cHA3OHdC?=
 =?utf-8?B?dmVMRlR0UEZXQ25ua2JpZGlNdGU5OC9tNVRMT0FPT3d4VGt6TzFNeEd4VG0z?=
 =?utf-8?B?RGhnQVpHcWhvY29sQlA0V1cvd3Y2eTVUVHB2ZHY4b3o1RG1mZHlCWTJDWVBa?=
 =?utf-8?B?RG9PZUhEM0Iza2djRi9oQmRpcTFUZmJXeis5VWc1ZUJJSWw1OGRSMmVqTUZv?=
 =?utf-8?B?d1RodVQ0NzMrSW9zdGEvL1hIb2hUZk40SU5CaTdVZVBlRDlxcGxhK0NJQ2tk?=
 =?utf-8?B?b3RvSWY2bUNBTVJJdnh5c05ucTY1M3Q5d1FzbXhyZjdRbU9mY0thVE1UZkMw?=
 =?utf-8?B?R3JQM293YzIrZkkvdkZqdCswNDhEaE9qK2tFNm9XUCs2UzJtemxMRHJKNDho?=
 =?utf-8?B?OW4xQ3FIenJmK3JWRnQ5Mk9ac1VqbjJIY3FqcU44Y3NOMnNPdkpZbEJwTmdl?=
 =?utf-8?B?Y3FOWjUrRS9RMURpYVYxWmZiVzhPbzZKanZnM1BRc3FXUHovYm5MeVNvQm94?=
 =?utf-8?B?MkxMNTVKRXFSbXl5c0pZZmRUTjI1eCtMTi8wUS9mR2FvL0tkTnZ4OHVlbTU3?=
 =?utf-8?B?UUZ3Tlp0NTRINzFMandUMm1jbm5FdUNSWFJ2aytrUHNZVDEyaWdtR1krd0lF?=
 =?utf-8?B?cVNEdCtTU0FsUGZVM1U1Qzl3M01NTnlPUEV6T2E3bFcySE9tY05Ja3JvQkg5?=
 =?utf-8?B?NGJDcEk4cGJFbVp1WnN5bU9zcFprbE9lNmtXRjM0SEFON3hLaENrcHVxOGNh?=
 =?utf-8?B?YkJ4MnBwZkE0d21YYUkzOVlOTUpMR0lzZ09lZ2pCayswVDVvdVZLM0RsdExD?=
 =?utf-8?B?QmEzcW1WQWhEOVgydU9XNkhkY3BYUHNNUnVJYVhkb1VCY3VEbnYyYkFpSjUr?=
 =?utf-8?B?VnJCWktPaGZyWjR1cTFDMm0xOHppNHJiUzVXajIyMFllTGI4bHdSeXBQSnJ6?=
 =?utf-8?B?SGFNSEE2OUgvYmRoYzZkYndtbXVuVHUrcGxPV3MyZjhyTEtFbUZ1TjJLbHhl?=
 =?utf-8?B?UE44cDhNRGhnM3gwMWk5MTdTTEtxNDZsd05vclJ0UEdnbnRrRVBYakhoVjN4?=
 =?utf-8?B?MHU1aCt2UEFCSUhEZkhJbkIyeDRjSyttNDBSb3BUUlNZTTV1RWF2SjFRVnZa?=
 =?utf-8?B?YzdPWjl5emZ5YVRyVDYvQitmczRYMkRZaS92QWhWTVowSFhoNCtITC9zUHlX?=
 =?utf-8?B?TmlIL3BBWWttS2tUMHBLM0RtY2dleGZOK1Y3RktvTERlZkUwWm1Wbzg2UW5R?=
 =?utf-8?B?cVlLVW53YjQ2Sk5EaUJVMkhoREhjNXhzYmdNME1va3ZFSjR4aTBGaG9RNHRE?=
 =?utf-8?B?QTRGT1ZVcHdqaGR0ZHpOeVpsY3UzaE5LUmQ5bkJQSWZrM1l4OWh1cnJmQytN?=
 =?utf-8?B?L3kzeUwycHBrUGpqaHhoL1c1TW5IUG9JMksvMkFpZjZkVVVaclFWazdYd3pF?=
 =?utf-8?B?cmNxVndhMTBzdHZraWY3OHB6NTVCVElyeklDdy9qMkh0V2U3SVpRVklpMVI1?=
 =?utf-8?B?MFlrUnA1WkxUNlZkdDdVeEUwdm9XTTJCM2lpaVcyRG42MFBORzNDWGxyNkFD?=
 =?utf-8?B?Wk03cGlPYVorVjMxaUtDYURmVndWZWNkUXFrOXdhZUJWbStyRzV6VW44M0oz?=
 =?utf-8?B?a0JEbEEzNUM5LzdmRERIVVVWdkF1QnkwRlRjSEgvNnVvcTVlUFRiNVFQRUFi?=
 =?utf-8?B?U2kybHdVbXppOUFBdlEvZDRDUHgxaC9Ecnkwa3k5RXlHcW11RldMTEsrYWRk?=
 =?utf-8?B?S1JLV2duUEdiUitMUnFUK1hzaVBsNDJzdWZGSFhXM2Nhc2tvWTFBUE5EM0JB?=
 =?utf-8?B?dXVRMTY4TDFBV0NxTlRSUE44Ykc0YjRzbTBXY3grTjIvZEd4c0RFcnd4YkQx?=
 =?utf-8?B?alZYSnc0b3JicDJBdGNEQTdnZ04rbVQxdVVtVzNxZXNjMTd2bkhNQlNMRE5P?=
 =?utf-8?B?TGZoNEp4SlV1QVgrUVdiZFdLeW1EcURibklKSVB6OEg3b1pXbHJhQT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e9038cf-b86c-4965-73c3-08de637f8c45
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB8665.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2026 23:54:20.2359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S1Ko5+Iqp58d7tEgfShkPlX1lZ9KRM7ST/BK6fgT1FZa7rzgCX2N2l5rsGgurgaivShmfbIP/NUHL8tyKNKEJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7845
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70113-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,intel.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[25];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: B9DEDDFDCC
X-Rspamd-Action: no action

>On Fri, Jan 30, 2026 at 8:23 AM Dave Hansen <dave.hansen@intel.com> wrote:
>> On 1/30/26 00:08, Chao Gao wrote:
>> > AFAIK, this is a CPU implementation issue. The actual requirement is to
>> > evict (flush and invalidate) all VMCSs __cached in SEAM mode__, but big
>> > cores implement this by evicting the __entire__ VMCS cache. So, the
>> > current VMCS is invalidated and cleared.
>>
>> But why is this a P-SEAMLDR thing and not a TDX module thing?
>
>My guess is that it's because the P-SEAMLDR code loads and prepares the new TDX-
>Module by constructing the VMCS used for SEAMCALL using direct writes to memory
>(unless that TDX behavior has changed in the last few years).  And so it needs
>to ensure that in-memory representation is synchronized with the VMCS cache.
>
>Hmm, but that doesn't make sense _if_ it really truly is SEAMRET that does the VMCS
>cache invalidation, because flushing the VMCS cache would ovewrite the in-memory
>state.

My understanding is:

1. SEAMCALL/SEAMRET use VMCSs.

2. P-SEAMLDR is single-threaded (likely for simplicity). So, it uses a _single_
   global VMCS and only one CPU can call P-SEAMLDR calls at a time.

3. After SEAMRET from P-SEAMLDR, _if_ the global VMCS isn't flushed, other CPUs
   cannot enter P-SEAMLDR because the global VMCS would be corrupted. (note the
   global VMCS is cached by the original CPU).

4. To make P-SEAMLDR callable on all CPUs, SEAMRET instruction flush VMCSs.
   The flush cannot be performed by the host VMM since the global VMCS is not
   visible to it. P-SEAMLDR cannot do it either because SEAMRET is its final
   instruction and requires a valid VMCS.

The TDX Module has per-CPU VMCSs, so it doesn't has this problem.

I'll check if SEAM ISA architects can join to explain this in more detail.

>
>> It seems like a bug, or at least a P-SEAMLDR implementation issue the
>> needs to get fixed.
>
>Yeah, 'tis odd behavior.  IMO, that's all the more reason the TDX subsystem should
>hide the quirk from the rest of the kernel.
>
>[*] https://lore.kernel.org/all/20251010220403.987927-1-seanjc@google.com

