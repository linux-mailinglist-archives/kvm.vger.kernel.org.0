Return-Path: <kvm+bounces-50731-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C4994AE89BD
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 18:26:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D19E63A4488
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 16:25:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE1372C375A;
	Wed, 25 Jun 2025 16:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eKZX3aco"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5771A1D5AD4;
	Wed, 25 Jun 2025 16:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750868768; cv=fail; b=AUS0P0yPF/AVSltNKN21Qu/4iQSFR21T+Ldi0grfipR/4X6WUo3UGr+eO4AcQt/y+ifIVcThitSX6E42XOIgQX803SU4goY8sonCBgNrm3XmZLR5X6a8ULH0jQkXkpM0Mw29bl9B9D8wPCBPzo6Nabz+GWkHcBCyMzconJ+GL+0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750868768; c=relaxed/simple;
	bh=2fw5TVwyNTMJZohTLrGwIFiZ2gljwKN3MZXko6pq+6Y=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lfIC/kd5CrA+2oNtBujJPrqy87ofcjlHuWWDsspKoX8pRoUmb+Kj2+YiP+VUPEK5V4SEGhlFPYPCHjU4/ZeRx2oHArLEHMAyQpEPTpugaqzMS99zqEidusd2gCelmo5+mQb4loAO0wYv7dPkZWvkZVv/zIweXw2l7o9X5zU/tTU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eKZX3aco; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750868766; x=1782404766;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2fw5TVwyNTMJZohTLrGwIFiZ2gljwKN3MZXko6pq+6Y=;
  b=eKZX3aco2hCcUpY9A8MR988qk2PTZNSFvTYrjTTOQ+eafGPoyWF0T0DR
   +z6/sZ30pdDD8aBzvegVi6kTybUSPNE4xb6HkKcwwNaQ46vQlry2LopCS
   kVK5GGpT8lNaylG8bUUwmmRM9k055kn2Uamc/B9P6PDeNDAbS4L6GpS01
   ZnkvZiyOE37wUgxNXQHlj+4DaXBVtDFvyl0RiRq5SFegfAV7FsRLXXCgz
   lR3vj+6oQ9v6B5TvNRoEe0oWdoXRs5n3znnzzDeWgxrOd1q7OcZuw41mW
   NW78Rzj7c3XRpfQAO2T7lU37/mCTZ8NH0m6q9YfDyOx00TsamYM5r0BBV
   A==;
X-CSE-ConnectionGUID: G8R4vyJ8TiKNNk3qkfsQxQ==
X-CSE-MsgGUID: 2BiDtHVpS2yA/kxc6WabJA==
X-IronPort-AV: E=McAfee;i="6800,10657,11475"; a="56947739"
X-IronPort-AV: E=Sophos;i="6.16,265,1744095600"; 
   d="scan'208";a="56947739"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 09:26:05 -0700
X-CSE-ConnectionGUID: NFSoWNlKRNaMHHpZXd/eug==
X-CSE-MsgGUID: RbNIIgzoTp+8e8ZRxhtRKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,265,1744095600"; 
   d="scan'208";a="152036137"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 09:26:05 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 09:26:04 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 25 Jun 2025 09:26:04 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.69) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 09:26:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cp/FZFDq6NbeCxyAVg6pjcRp/+0KGnnsMdQq4UGl4CngMgho3xkNvWAVNK6QCH1nIqrboj9MEivLDP2gdxpIC+M+eydOmhPtbI6SX5RD6tDKWBjB50RRShWVKqrouAXaF8NA0KGU560QLB2mRPULFxvRuJXwz2IWMFMW5OPA211CF3iaLcTPSj8WkzSW9f3IhoBld81g/cPuPOOjuk+UR+gfJTwEso73EnZOFTB/g2I44OGHbhdij1NFqBkqUL6DweY2HH43kU4o+2P38myykkzt84wC/vlrfhVUBf3jzyMAqshBncOf7IiYmCxTBQeJdh3HNECrvtCsiwL/66b1aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hmnt9ENspMmgoM8C2YGC6OTSS5Itm4LH8NKLwjjtu80=;
 b=XcMZR/HQfrETyo4oTy5v4cBd9LzFwFNSl8udt3Ijyow32UNV0UayRxgO5wlGacQA5BA+HtX3/+30UDYlXJBguTu1q7gwRVPmO1eo/Bdn5AJZfFk0CIo1VespAY4eOskr8QNCOjZ9FLcUrwqEEnZbQdUl+FzjKKuoTraGz1ZxYA9XN+BinfJicZ1P96RqBHaToDs2tC+EM3bj8j1Xs9G+SW1KdondKLzYDg54hL+aTYD6TFsQbeRcz52HNEocTtcXQlUxkIfmrlJiKiMeiQuOgb6CGVYxd7ZxYgasTfmK8VE5IUUjeHSeJjr6oZNo4c8x0lkdcFhfA52lzRvx0k6pAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BN7PR11MB2708.namprd11.prod.outlook.com (2603:10b6:406:a9::11)
 by DS0PR11MB8206.namprd11.prod.outlook.com (2603:10b6:8:166::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.28; Wed, 25 Jun
 2025 16:25:48 +0000
Received: from BN7PR11MB2708.namprd11.prod.outlook.com
 ([fe80::6790:e12f:b391:837d]) by BN7PR11MB2708.namprd11.prod.outlook.com
 ([fe80::6790:e12f:b391:837d%5]) with mapi id 15.20.8857.026; Wed, 25 Jun 2025
 16:25:48 +0000
Message-ID: <bc492cb2-1d30-4a30-9eb9-d48b09cd29a9@intel.com>
Date: Wed, 25 Jun 2025 19:25:39 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] KVM: TDX: Do not clear poisoned pages
To: Vishal Annapurve <vannapurve@google.com>
CC: Tony Luck <tony.luck@intel.com>, <pbonzini@redhat.com>,
	<seanjc@google.com>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, H Peter Anvin
	<hpa@zytor.com>, <linux-edac@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <kirill.shutemov@linux.intel.com>,
	<kai.huang@intel.com>, <reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@linux.intel.com>, <binbin.wu@linux.intel.com>,
	<isaku.yamahata@intel.com>, <yan.y.zhao@intel.com>, <chao.gao@intel.com>,
	Dave Hansen <dave.hansen@intel.com>
References: <20250618120806.113884-1-adrian.hunter@intel.com>
 <20250618120806.113884-3-adrian.hunter@intel.com>
 <68938275-3f6a-46fc-9b38-2c916fdec3d6@intel.com>
 <CAGtprH_cVwWhfXFkM-=rVzQZ0CpY_zcnkF=q5x1n_9Bzm1xKfw@mail.gmail.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park,
 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 -
 4, Domiciled in Helsinki
In-Reply-To: <CAGtprH_cVwWhfXFkM-=rVzQZ0CpY_zcnkF=q5x1n_9Bzm1xKfw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DU7PR01CA0032.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:50e::8) To BN7PR11MB2708.namprd11.prod.outlook.com
 (2603:10b6:406:a9::11)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN7PR11MB2708:EE_|DS0PR11MB8206:EE_
X-MS-Office365-Filtering-Correlation-Id: 308add13-7b98-4ee8-f521-08ddb404f091
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TFlLT25BWVkvWkpBanFCR0FLUURFSkZlaWJLUm9kT0ovNWZiWUJFeWxmVm9o?=
 =?utf-8?B?ZU8zZUdtYmRCOWM3YjF0R3dtK1FydXpGUm5EVWRVdWlWNm9sQTF3TndnaTh1?=
 =?utf-8?B?Z2ZUb3hkMkxnSGNhL0JjdmtETFppeHZIajR5MUZ4M090OWJLNlhpcklaeFV0?=
 =?utf-8?B?b1JiOUZxSUtndTBMYUpDYWdlVk1yenhyS0VWbUJvdjA1L0ZBSVpUUStyM2No?=
 =?utf-8?B?bGVZOXIyZWVsemVGSnlTMlN2WUlQYktnQVRoMUNPSEovdnZnZHJBUHNWVkU1?=
 =?utf-8?B?YTFjZ1VRSElBOFV1VGd5c2FTSlEva0V6NVBuNFRDMWhqcDJBOGF0RFpxTW52?=
 =?utf-8?B?MVRuMEplV0djVkwySWhJSVkxSzM4ZXhJb0tBejh1T0FuT3NyUitJa3J4dEFy?=
 =?utf-8?B?a0VocytUVmVJdTJmcVFUdHd2bjJkMTU1dExSdUNZNU1xbHhvVzd1NjZOZnR2?=
 =?utf-8?B?U1lRdVZJN0JlODhoOXNHL3pBaDNSWHJFL21aMWNNVkJNZU4xV0RZYzFZM09u?=
 =?utf-8?B?T2RWalNIWnNHMDFKejRZMVQ0WStZZXAwNjFYTXFJMGZXZnc1b01mRlM5bko5?=
 =?utf-8?B?dCtMTHBaMU9sL3F5TGl2dVJmZG1BZi9VcUlxQTVpajhyOTh6eS9wTy84ZTdQ?=
 =?utf-8?B?NnhSRGllbkRTNVFDTzEwMHJpWUJhdjVmcVRFWGh2bkZ5YzFybnBoMW9qbUtO?=
 =?utf-8?B?dU4vRTVBTWdjL1VGdlB1TlBkRnZaYXdyMVlUL3ZLd0pCM2FNVlpodjNwdExO?=
 =?utf-8?B?dFdvb1l5Q3YxbUs5SW1hemowblVYMmRyUnF5eGNXQlE0WCtoS3RLTGx3NjRI?=
 =?utf-8?B?TGZveVpEN0ZrZytDL0tXcHVzTWtwRmlYZWNsUldMV0VFdVBCOTErV2Z4NkF4?=
 =?utf-8?B?L0N4SXcyUzM5cEpmMU5lV1RndGpvY011VjVBalk1OWFuWE9URzVKNjdacllp?=
 =?utf-8?B?VFo3eEJrdDg0bGI1S3NSUUJxYzd0RlJhL3MyV244bHloZDlOWDgzNTdyWktF?=
 =?utf-8?B?OTFzOEk2MjJRZDh2WS9FUlo2Vkh1WmswWlRMYjVaMEtHU2tmZWtjQW1GWU1k?=
 =?utf-8?B?cm5qY242c0xKcjZPNjZiWUp2ek9aVkNSSnk0SytndXdOdUVjeVJkNWZJSmgr?=
 =?utf-8?B?NWpuMk5OUUNEazNkR2twcW5SMjM4d0NhV3YybFJxTlZOYXg0a2hscWFCOUdF?=
 =?utf-8?B?S0tXR0JOMjk0L0UwbUplcEJmQ2dwckpPK05XVFA4MXJpeFArNjljdVJ5M004?=
 =?utf-8?B?T01CdXhLOENmZGs1T1RESDZEWW5pOC9NMWJLVEpVV29rZzU4cVdYTWk2M0M3?=
 =?utf-8?B?YXUxNmZCVVVKMG9sekxRMUFldWVNb0VRV3VkL3JLRTJBdUpWaVMvaWhFK1Jh?=
 =?utf-8?B?cmJzOEQ5d3d3NzhlZHVNWFFiYXJHeGUyeENmV0dCdGVydnJYWUdCRzduWk83?=
 =?utf-8?B?MHRIbmRnbVhseXRYMWVURFRXYWVaNUU3RFVRQlJxamdEOWR6VDJuYlVsRm5X?=
 =?utf-8?B?eFpzWmRHTUs2NHByckhpTGdBQWRLT3k4ZWwra2pEQ3N2TFVkNHVTMkd1QkRW?=
 =?utf-8?B?RzNrM0p6L2Zmc3BkRXpORStaeWZXalQ0RytZc2ZSeVNiY0VTM2QyYy90SUwr?=
 =?utf-8?B?MGJrblgyYmZ6UjV4aG5iQnJ2RjRFSGFEYXd2U2xFSXA2em0zdWkyZ3U3eFFt?=
 =?utf-8?B?ZXlDTVdqR1Zxeit2NVp0TFBEcTVDd0ZEMDJzQnlXYkxqM2pVSFhMRTJYd2p6?=
 =?utf-8?B?VitybUE0aC9uUHVWWVhQcWJtSlNjTlZIWmtvdDBBTHRQelhzSUJJbm8wRGE1?=
 =?utf-8?B?ZmRST0xqWFhYdm5mNXdzOW9QUW1OUUFjdXNueUloRkRGQXhLTzU0c3pHUHhu?=
 =?utf-8?B?cEtSK3AwMzh4bENBOUVYb2JPcFh0ejYzOUZ6OUtmUnJVd042YmRIMGZySlRQ?=
 =?utf-8?Q?ljLnaFjuNLw=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR11MB2708.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OFJFT0FsMkwyQ0MzLzJzNG1wMUZUb1NXU1lsQVh2SXlvVGNvOGh3cFd4ZUdE?=
 =?utf-8?B?QVAzR2E5MXFYNHIycHFSblpLbEVjNnVNbEVFN1hOc0FwK3VpM2E3L1liTTU0?=
 =?utf-8?B?eXl3MGFBUkhBdnpnU3AwblVjUyt6U2ZBcjBkRGJ3NE5pV1h4NHp3V1VnZUpY?=
 =?utf-8?B?N1FSd3hiMWRoUDNtZTlyUVpjcUpLSVN3Qlkwd1B6V3lRVzQzZHJjZndwUUIw?=
 =?utf-8?B?Q2NJMWZsODE5TlBEaktWZk1rVW1IdnNPYlBiU1IxLzZBWmhzTDhnb25mMDJT?=
 =?utf-8?B?N3Z3dE55bHpkNjk1dWJ6c1B0RUdWYjJ4N3NOZTk4UFluWG1Fdm8rSCtTd3RF?=
 =?utf-8?B?U21xemZiOWVwaW5DMUZSUUtSeUlQQ09nQnU1VmhBS2FTQWN0aGhTQjlTRFN3?=
 =?utf-8?B?QVlUQkwwbmI3aGRZTzE0aHpYWUVENFJUbHdXU0hxQkJkM0lLYm1uUzdMaUtG?=
 =?utf-8?B?WFRVdDI1d0k3SXlCU3FaQ1NTbTk4UTlwK2NBbVlERVM1cGpMeWJIcG9DVmZH?=
 =?utf-8?B?L2NqQjdCNlQ5Q0M4VmlEWWJicE9QbWE5TDluTmExNkdDcmtiUENOR1lnWHNv?=
 =?utf-8?B?aTVyN0JOYkcwRno3UDhrZDlYVjQ5QWdQc2RYZFlvK2lPWGFGb2RDM05XNG93?=
 =?utf-8?B?R0orcnhwd0Q3SUpUS2hVQ24zeHVwc0NyYTdtWjJjd1lHL0NRY2orNE8vanRp?=
 =?utf-8?B?bDg2WXhLaFBCV3E0b3dOTjVwRTdpK0lCcWk2Rjk5d0FhWjRmRkJhRG1ESkhL?=
 =?utf-8?B?ZkZ5VGgxN2tuRit0blJ4bHJsSkxrZ0puSUdTQXczYmVxRmwxT1Z2Q05McUpP?=
 =?utf-8?B?dTIvdUMwQmdGbXJBbVBzSldaM1NxN1ZkQUxjdVVDMEJaMCs1RUZHdElTU0E1?=
 =?utf-8?B?YXRqemZUbnV2cWhkUFZGTW1CQTF5Q3VGK3NsTTJ0ZzJRaGVpSWM4VlpZTVNO?=
 =?utf-8?B?V1lBWWJZUEZtNHZsSlc5bUttWUE4U29xcFJTZ1JNVXl2Y01ZYTNac0piMkx2?=
 =?utf-8?B?TEFJSmw5YWRSc0dHMSsxczV6a0h1UnJodzYrVWpGdTJRL1dGazVMMFdtU3FO?=
 =?utf-8?B?Mk93L05qc1dlMU54dU9pbXd0MUxPdjZxZW8rUmhCYkhBNHBqby9pNEFyZTNB?=
 =?utf-8?B?bnltOFpnWW1ZcnJxZFEyOWJ1bDg1aWFsc2wwUjFNbHcyVFpWdXljajRrR0xI?=
 =?utf-8?B?VzcwOUU0RFREc0U2QzZJMXRxOXRBNDhmTnNZTVd0TG16cElkdGtPdS9MclFm?=
 =?utf-8?B?NU1GejZROHFwZWxtV1pYVUJNeHhjUHpTSGlrZDliTWNpUXlyUlhHdUpzZHQ5?=
 =?utf-8?B?UXB2RW11ZC9maytlL1FMZ09BWFFUOXlhUytmdHRSSk9RRElGU1pGaVlDU0xq?=
 =?utf-8?B?aUtJLzF2WVZCQzl6RlFNMmJZaTBDVnRNb3JQcTZjWnd3OUxiOFh6clN1UnZz?=
 =?utf-8?B?Y3J5bmplRlNzRlZueWZJb1UvVGhHSURXK1NoVXBad2wyQjFWWmR5SFhNM0tF?=
 =?utf-8?B?VzJsQmQxcG1qODRvN0syVDBZa0lPbkpCSEhmYkNHNDc2T3NjcXRabjEzdFkz?=
 =?utf-8?B?QUdUclo5bEpmVWtLQ0tSQjAyMXdXaS9lU2xyV3BUV1NyQS9DRjJaN3VObm53?=
 =?utf-8?B?dDYrZVl3TWYwekhXSkJuTkZ6ZEhhL05KZU1zRFZHRmdHVkZ2ZkM3Z0h2enlP?=
 =?utf-8?B?WG52ZWRBRzlqMmZJcWZXTlk5RTA0cXFLckdTbW4vemlmU3ZIU1ErYWdVL3d2?=
 =?utf-8?B?eW92UENMeFExcHRPL3M4NzNaQUh5SzBZMGxScVdUOWUrN1hLUXh3cmhlSDZy?=
 =?utf-8?B?ZUFpUUR1Tkd2S3hxVVJaQlVkUUZKMW16c0ZjVTVUcE1nTDIrUDNvQmtrNjRM?=
 =?utf-8?B?ZUY2aXkrQWcrY3h2R1BxbDYreTRabDc3cEczUHZKeGJkZS9Ia013cG55OHc2?=
 =?utf-8?B?ZFdOVGpJWlUxZXhIQ2Z2UHFMTVNQRW43c2R2ZFpiOGFLSUFIZXhGdjh1U3g4?=
 =?utf-8?B?SGY3VkN5elZicUtJTzFIYTZIQW5jWE01RDhVMGdlQ1FtYS9LOElJdm45bHpM?=
 =?utf-8?B?ZC91NlZmMTBIbXdDbDVnajAySklpODlwckwvL0Q1OVpQaXNFdDh6Q2FITTRj?=
 =?utf-8?B?d3JhVXNvdzMwY2FGd0VmMUI1enZVNkc1UW9ycDZINTdMOEhPV2s0K0RLK2kx?=
 =?utf-8?B?ZHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 308add13-7b98-4ee8-f521-08ddb404f091
X-MS-Exchange-CrossTenant-AuthSource: BN7PR11MB2708.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2025 16:25:48.2257
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nXEpMQQ2ihVrjYsuRN3O7W7QOyTlmkSuV1hpGolCHF4d2lrrrBrSDgNlIN1uw0InLpo+CxXqSVCQlOhZTIXAkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8206
X-OriginatorOrg: intel.com

On 25/06/2025 17:33, Vishal Annapurve wrote:
> On Wed, Jun 18, 2025 at 7:58 AM Dave Hansen <dave.hansen@intel.com> wrote:
>>
>> On 6/18/25 05:08, Adrian Hunter wrote:
>>> --- a/arch/x86/kvm/vmx/tdx.c
>>> +++ b/arch/x86/kvm/vmx/tdx.c
>>> @@ -282,10 +282,10 @@ static void tdx_clear_page(struct page *page)
>>>       void *dest = page_to_virt(page);
>>>       unsigned long i;
>>>
>>> -     /*
>>> -      * The page could have been poisoned.  MOVDIR64B also clears
>>> -      * the poison bit so the kernel can safely use the page again.
>>> -      */
>>> +     /* Machine check handler may have poisoned the page */
>>> +     if (PageHWPoison(page))
>>> +             return;
> 
> IIUC, even if movdir64b stores contents on hwpoisoned pages, it's not
> going to cause any trouble.

No.  PageHWPoison(page) means the page should not be touched.  It must
be freed back to the allocator where it will never be allocated again.

> 
> This check should be (unlikely(PageHWPoison(page)) and even better

'unlikely' would be fine

> probably should be omitted altogether if there are no side effects of
> direct store to hwpoisoned pages.
> 
>>
>> I think the old comment needs to stay in some form.
>>
>> There are two kinds of poisons here: One from an integrity mismatch and
>> the other because the hardware decided the memory is bad. MOVDIR64B
>> clears the integrity one, but not the hardware one obviously.
> 
> To ensure I understand correctly, Am I correct in saying: movdir64b
> clearing the integrity poison is just hardware clearing the poison
> bit, software will still treat that page as poisoned?

Typically an integrity violation would have caused a machine check
and the machine check handler would have marked the page
SetPageHWPoison(page).

So we really end up with only 2 cases:
1. page is fine and PageHWPoison(page) is false
2. page may have had an integrity violation or a hardware error
(we can't tell which), and PageHWPoison(page) is true


