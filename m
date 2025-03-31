Return-Path: <kvm+bounces-42248-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 15191A762CC
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 10:55:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 48AEB7A4987
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 08:54:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7C0A1D6DC5;
	Mon, 31 Mar 2025 08:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jtaw+czQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC2C13D8A4
	for <kvm@vger.kernel.org>; Mon, 31 Mar 2025 08:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743411348; cv=fail; b=sMqJVtJPN6uCG4Z1JLex8nlGc7VnkOQHOSET2pgAxei93tn5+P2k+/9uJPOYsz837X+8IbWC/4y2BWyZ39YLs2HwYtDKx4AyO+a9kjJBTtX5SnHwiZDwSZcBuAIFvpMlYSaL1R6fOzFGnGsXIgslL8Ua/MzaZTvfCPHWtZ51buk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743411348; c=relaxed/simple;
	bh=gf84vJs1iDy91J5wIxuqNO6DeWjOoNrVUA/Iu2QAQeE=;
	h=Message-ID:Date:Subject:From:To:CC:References:In-Reply-To:
	 Content-Type:MIME-Version; b=u+REsF8IxukGPYx0a4nfDOj/mJqexi4vSU7PQcdG2F+kbR3ZylGI7rt9De9icxl+wIgJdaLWVopoi1q5nzrjoirc/YAw6AfkIM1fr8e0lJRi0akO7EkCHLa2YEi2OVH+YeLedzuCS5fsCk1Cl2feFNgSNVj4v2AWa8kxTo/DPC4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jtaw+czQ; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743411345; x=1774947345;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gf84vJs1iDy91J5wIxuqNO6DeWjOoNrVUA/Iu2QAQeE=;
  b=jtaw+czQ6QzNhZp94njuc+FSNQ+xDnynL6EChWWdAgDzLSkM9ZD2mcHx
   YVs9JGGOjFoP5ulaQUC4utR/7GyhcWogMgduvlR8c7ulJG2LU7y8E4qNq
   lhgxHZzfIC6aja6lJDrKGTk2Z3Do+RofCBpsaNkiBjyEDrwrbDlg+oeCC
   Nd6x0jzk3pMmh7sb0wKnw95kUwDkZfa7n63hozoSJwq9LsYIsQAAYQY6f
   vFyRbpO/6i3PcmDSDKd3zX03PIN1dDTjLGTXyS5bZV3bnfDivKskrdYYX
   e8ZQPoLgPLi+nvOYDZUcRBaM/tcbinJWiDrU5HVt49pY/BPKuqq6zN9FZ
   Q==;
X-CSE-ConnectionGUID: sIXOMdEBTkulI1JbyOmrOw==
X-CSE-MsgGUID: ISOhBx9+RbOx5BngFHLmqw==
X-IronPort-AV: E=McAfee;i="6700,10204,11389"; a="55352768"
X-IronPort-AV: E=Sophos;i="6.14,290,1736841600"; 
   d="scan'208";a="55352768"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2025 01:55:45 -0700
X-CSE-ConnectionGUID: fM2UlNSdT82Fy4zEIOsPBA==
X-CSE-MsgGUID: 6sd49o9yT/+jMmY1vhohFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,290,1736841600"; 
   d="scan'208";a="130743862"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 31 Mar 2025 01:55:44 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 31 Mar 2025 01:55:44 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 31 Mar 2025 01:55:44 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 31 Mar 2025 01:55:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V4gfZ/y7kd4WVxBRwaBmaU3DsHgqP3RGOvzZsnnaGyW3rN1lR6ZaRpYn6J91zF7B4P1Sy/XoaFBSi+4HA02nTj5HOu1OHzOB4UcYYchFBhP1GydJ/4Ogn6EQqD2WO8XVDNPpyPFO4JSHCaJzdFqZ+3QSg2fo/cS89xu7TZibyhFL3PDNt4V984v10r4CR7Z3ET4dPsSt/OAXvA1bVZjm817IAN0GUo9eQFy5No5MQyJo4ZizRu3ECy418IQTML/hu5Tczw+jyRreP3WAMxWPc5JZMibqE9AVVzvKUKL6aMIIEs8uBZ2/ihW0kEEEUTS/mwOpYkcx/PUlFMhneQNeCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QprhM2PmYKKy2vQmwtV6FsVsxDvtkIJjq9HeFSjbLg8=;
 b=ssa7RBe83lG+eSuRwymwO+IFqBioRXkDbGGzl0Qu6Lc3Xc+3nxlXkXUZx9nzmX1LcSCoTRPDMYI34vfpZo3AcaPlM79ZarKk83YQOPNKFuVwS+dOWo0k+4EscNuMiLwmjAmQ082V0gvJ8RN8dJ5mHCTDAD/iJkecJDHyFC2QDjST1wFO6aAYlfESwqao+yCAx8rVbgb3Lgoz6njksGJbhDQotwl+E9nU6X9kSaprZHUozktAg7JY1xWIHb5sHaKzY3kgrFrNqQMqhsnJH07kksAj/jWTXVWTpKG///CwpLEOwSKf4CDvIFwWMgCIf4wV/MS/lsO/yimNybJSDw8i+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 PH0PR11MB4791.namprd11.prod.outlook.com (2603:10b6:510:43::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.47; Mon, 31 Mar 2025 08:55:40 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%7]) with mapi id 15.20.8534.048; Mon, 31 Mar 2025
 08:55:40 +0000
Message-ID: <d4789fbd-c58a-4a1c-b99a-1b1cf9e3d056@intel.com>
Date: Mon, 31 Mar 2025 16:55:31 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/7] memory: Attach MemoryAttributeManager to
 guest_memfd-backed RAMBlocks
From: Chenyi Qiang <chenyi.qiang@intel.com>
To: David Hildenbrand <david@redhat.com>, Alexey Kardashevskiy <aik@amd.com>,
	Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Michael Roth
	<michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Peng Chao P <chao.p.peng@intel.com>, Gao Chao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao
	<xiaoyao.li@intel.com>
References: <20250310081837.13123-1-chenyi.qiang@intel.com>
 <20250310081837.13123-7-chenyi.qiang@intel.com>
 <8d9ff645-cfc2-4789-9c13-9275103fbd8c@intel.com>
 <11d40705-60d8-4ad6-8134-86b393bfae8f@redhat.com>
 <192a8ed9-fecb-4faa-b179-ed6f9ef18ac8@intel.com>
 <af80216e-7a09-48a3-97b8-5b19cc3ded28@redhat.com>
 <b9d809c0-92c3-4bf4-b49e-c97383924e06@intel.com>
Content-Language: en-US
In-Reply-To: <b9d809c0-92c3-4bf4-b49e-c97383924e06@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI1PR02CA0055.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::16) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|PH0PR11MB4791:EE_
X-MS-Office365-Filtering-Correlation-Id: 270ef5c4-e0b4-42b0-af9e-08dd7031cfcf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cUdDYmRseER6NUFEaHZCTWdZWU1OMVJYTndqbFNqakgvTjFJMGhxSHFKeFZQ?=
 =?utf-8?B?Wm50blBRMXhMdGlLNFUwWS92K1JqTUdDcHYvcjFWbTRMd05GQXJXUGlyRGdX?=
 =?utf-8?B?SEZPek1GZ0tqanQ4S3NZTVVzanZacTZZTWdQVEoxQ2NnQVhQY3JvdEpmeUNW?=
 =?utf-8?B?b1J2RytZNWpKckp3TEpFVlZTMjBWT3d5U2xxREFDakxoTWpOaldEblc2V3ov?=
 =?utf-8?B?NjhuL1htVk14MnVQSEdNNzBsSmVBMXdteHVHckpHaU40N0l5TjVqbUJCcnF0?=
 =?utf-8?B?YkZMWUJ4K1IxZE5aMTFKRW9ncUo5ZnBtWFYwU2pYaG5UR1A4UFFhTmM2RE5w?=
 =?utf-8?B?bWg3anJBWnpDYVZqTjNQVTJQRWkrNXZYRXNBL0tnSnNKL1J4M0xaRkUvSUFa?=
 =?utf-8?B?RW5yK3FDN3pIQ0I4dFl3SWlwOGhENDNVY2NsMWRxNnNQRVBUcTNpQnZ5OUZt?=
 =?utf-8?B?b2phR2FzYTNrNUVXem9MUFRoU0xxb2FlT0RDd0QxL01rTVhUTkl4dmtCbWFw?=
 =?utf-8?B?VGFRS0p3MGFrWlovNEFMeS9tb0JDZHB3Z3QvWjF0dTB1MStabFRNWlJDZmZT?=
 =?utf-8?B?d0NqVEc5Tk5CWG9taUxXUjFRMXVTWXdpZmZweWI0VG9ZVmJGdXlJMjBRZnBj?=
 =?utf-8?B?RVYwL0ZoMnUrTjM5MDd1RTZFbG5MZHBMeGQzc3FHRmE1YWtuU3p0MUp6V3dD?=
 =?utf-8?B?NXBNUHpPWVRKV3hoYjQxL0N1dHJaaWk3R2xFc01SczVjcmh1OWJQL2l2RTk0?=
 =?utf-8?B?OHIzRVUvalMvaG9SYitjSnlWazNDaTFUd0JYamtRREtxU2kvNlJwNHEwcFZG?=
 =?utf-8?B?WUs3QXR2aWNwZmJMbG5XVkdPbXRWSEpSSDI2dU4vTFJFVTRlN0hzQXNnV0kx?=
 =?utf-8?B?ZkI5QzRndjhCS1RmVG9JazlTK2dOOGZ3VFNCT2huUStKS0Z6VjZtWElGUXQ5?=
 =?utf-8?B?MFF4YkVhcGEwVVVoVHhvbWRzbnNPaWhkZ25zZFBVamFuVm11d3BOSVdkdE9h?=
 =?utf-8?B?VG5BTmlMSjBmVEFpRXJaT0VkWGZib0hCeEMxSEpnRHZpMjd3MlRQd1VUNzBq?=
 =?utf-8?B?RmdWbmcycjVpVHlrUTNhQW5Ta1kwbmVoeER3cWc2WlFUWGh0REM5S0JleGd0?=
 =?utf-8?B?YWpFQjlRaVFJdjE3N2ovQnpoNzVrZUFuVWNKREgrc2MreXU3VlJxZjdFSllx?=
 =?utf-8?B?RmhvaGlISGlTelMwZm1tVzRrNUVHaVNHOHZxLzFQN2ZUMU9zZTFYemhNaHZJ?=
 =?utf-8?B?cXhpb2IxOUZvL1M0eTdYbEZubE9oQnM1WFpxTkJoRkpCZFRhbTVHV1g0dUdW?=
 =?utf-8?B?Zm5yY1JQNFd2UU10NE9ZR0Q0SkprV0dFbEhFVG5uMGJNWjhyaW1hamlUb0hk?=
 =?utf-8?B?dnp1bHNJK3FlQWZSbnVteFlKOGtLd2Y0WnArR1E0OW5FOEIrS0JGNXg1Q2l0?=
 =?utf-8?B?MHFQMzR6Zzg3aWpzR3pTWmhOajBkQml6QU1qNWxOOGNsYXM5WFlQdnhNK1pU?=
 =?utf-8?B?aC84ZUJYd29jVDkrbkluemhwQ0x1RFBrNlIrVnlIN2M1TnRzZlNiSVIrN0tR?=
 =?utf-8?B?VTdkcm16b0NIY1g5OFl4c2JCeUFzZGRha1l2SXhTS3NaZlNZT1NFaEdBTTN5?=
 =?utf-8?B?YjQrMTJieERiYndrMTZJMGpvMFFlU2JUWmI0NFQzZUJOZFk5MG41emJIaUdq?=
 =?utf-8?B?eEVxWmtDZFRBVk9zKzFhaktpa0E3WG5DM05xU0YwZ0J2QUpwOHpsZFB6djFZ?=
 =?utf-8?B?M2lYUXc4TkRGQkVVL0F2R1dzV2FQU2xWNFBKT1duODN4cG1oRGpnazNySk9o?=
 =?utf-8?B?OTlkdGN0a1pPaFRtZkRGVGZCNzdNWEFsMlE2WmRDYjAxTXlKalZkODRNaFM3?=
 =?utf-8?Q?SBorD7/6D9mng?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?REh1ZUpVd2luSml1TW9JNmxjNUIvbmVJYVhuTzRmbzIzRXU1UHMvN0pSRjRs?=
 =?utf-8?B?UFhXY09RbThHV3RrRVJMU3V3algyZU93ZG9xTFJCUW5pN3dXbVZORUZlNkIy?=
 =?utf-8?B?RXM3S2s1ajVNUjlyM3RtZWppbnAzQ1ZZSERFQ3F1dEprZ3FtTno4WVFaQk9H?=
 =?utf-8?B?cC9VQnkrL2ROa3p6WTBaT2ZrZWFZREJ4R1VhcldaNUFITUxHZEpuenZyUEY0?=
 =?utf-8?B?NGZOK1VFZFhtUDVNcDdVcTV6OWtTNnoyWjVqYzhkOTk5ZVF4b1V3d3Bkb1NX?=
 =?utf-8?B?bFYrUmRWYTljYlRuSkVOTVdjeGo2RWo0NTJ4OWlibWNVSEZxYTU3ZWlsMGdP?=
 =?utf-8?B?dW5ISnRBdjZUSFBEdXZFVFdrZzJtWCt0ZVdxQ1pac2szdzZsUDJhNHcwL3J6?=
 =?utf-8?B?MVVoLzIydmFYNzdQNWFLanhzcnVuWFJrbE4zYVNGVkJaNlFQaEFYZ29NaStN?=
 =?utf-8?B?L2hhelJuOFFZWmp4azczWEI2YlY0bEI5TitpMVJxSTFUQ25ndDdRdTZyYWJa?=
 =?utf-8?B?YWovTzdGSDRBVzVCemRLU1FVcUhXOWE3dlBWbllxVG45VDZvcXRyRlIrcHhx?=
 =?utf-8?B?bWlaNk9Xb1FaVmRyZHhZeEJSTVVJNlVzWDd3UFZGUTJLblpSR3gwa09WUXIy?=
 =?utf-8?B?Ty9xQk42d0lPYi9HeWpGYis5MDNrMEE3VEMzcWMyYms3Z1lsZnNXL2FLdzR4?=
 =?utf-8?B?YTd0aVEzemkvWXhIQVhLWnJNQmZuZ1JMK0x2b1owQjhITW9qMVBCNHFhVHFC?=
 =?utf-8?B?ZVBoUmtiUFNUNzNPMk1lODBJb25MQzkxNkE1VzFjd3JMc0M3YVhtRC9VSUFU?=
 =?utf-8?B?VjRsMEp1OXJQSGZIYk5IYmszN3FZVlJQbHpJbHNPc0ZEd25zUWpkWXQyakw0?=
 =?utf-8?B?c05wYXpic3I0NHlOTHJyc3FQWXJFbEJmNDdtMTlGbWg5N09tSStDUmI5eWdI?=
 =?utf-8?B?enRXanNqVTNidVBES3lhU0FORkovTUNFMVNjUitTV3dnMCtCSnNhVUxhYzBK?=
 =?utf-8?B?NlV0SGoyVms0NCtmdnJtTUcyMGtCSkFtQnZkWE9SSDgwRVRuVDhnOWZSaVNY?=
 =?utf-8?B?V2hPT1VySmh5bzYrYTF1cExGR1BEMG81RXdvc0N5cGMzODZTSU03UHdqNHIz?=
 =?utf-8?B?YjYwdTcxZ3hpRnIrRE9Yck8vS3VhQmJOUjlXSURKbTY2UURKQkNrWlRmdjhV?=
 =?utf-8?B?N0hSVUQ5cWlTdlZScjJaOXNUdUVhRS9PVzNqVDNteEJtT1BWZVpjMWFUNGZi?=
 =?utf-8?B?Nk1LblNSajBqZG5HT3o5QWdxeWxWSnBqSTZaVk5YY2JzZTUvUitsNkdGeUZa?=
 =?utf-8?B?YUp6RzhpWmFtd0JXVU1ldE9oL3ZGdWtBMVp6VC8zT3lwaXNKempTLys3L3Vq?=
 =?utf-8?B?K2hyVU10NElPWmttVjFvclhRVWN4a3dldFNrWWMxNGRXNmt2MFBERVVjNVpr?=
 =?utf-8?B?Y2JNZkZ2TXJDREdzSVVlQWdzZjlGL3R2TE9OVlVmMFFFN0ZNSm1CZ1o5THQw?=
 =?utf-8?B?aHBLOEdkZU0zUnAydDR6a1pzbmVpRVB3ZllPUjBmbEhlWWxyN3VNRXJSS3cz?=
 =?utf-8?B?MFBUdEVUN1VjdE1aNUhUTkM3aE5HaXNLSDhwdEx2Sm11YUp3bkI3NTludmVa?=
 =?utf-8?B?NnVCVkZjT0VyQnIwc1NMc3lNTUhCaUJzRmFFMXBUOGxvTTFyTE9nTEFMYm1h?=
 =?utf-8?B?dzV3WmVDYVVMa1pxSmdQYTE1SGJ5R1lwaFNwS3lnYmpaNitFL3FDR1U3ODJ0?=
 =?utf-8?B?ei9mbjdhNnhRbmZ3SEkwSUI4blJ1KzliSTJ3SUVwT1BxQUtOQjlHQnhJUzFv?=
 =?utf-8?B?MW04a2d1ZVI1WlN1aEZTdk01WFdxZC9YcFY2ZG9CWGd3RTRPaVRwRitpTWZk?=
 =?utf-8?B?dEdwK3lQUmk5NUJXVmEwTW5ZOGE3U2pSeVI4ZGRHMS9ERzdJQ21RQ0pWZ1VI?=
 =?utf-8?B?MmlzZjlObW1Qa0JWRmlNZTNlcGVxaW5EZ28vQzZlSnVKREpneXZSRmJnZTJn?=
 =?utf-8?B?Z2gzT3lkSUJ6akd6RXBoaEJoakNVV2IwQlcwRUVLVzZIeDh3MFRHZmU5aFB6?=
 =?utf-8?B?STBEM2hyUVNjbkd1M2FDUGJwRW1QV3lTN3BrSUtnbEJGNnZDOFVIYS80NVhY?=
 =?utf-8?B?L2xTTE1aWG1oOGhqem0wNy9GQmhXTlY4T01XWU9DK2Y0NE43d2d5RjZaM2FZ?=
 =?utf-8?B?YXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 270ef5c4-e0b4-42b0-af9e-08dd7031cfcf
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2025 08:55:40.2106
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sqsCOPYl/cJFwZEXYLGyLgQlXcOABxKpX56i3NyyapUiOVnzMeTyQnOPUBoXhwcs3RmM6hcbbsk1agA/Nq0RaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4791
X-OriginatorOrg: intel.com



On 3/14/2025 6:23 PM, Chenyi Qiang wrote:
> 
> 
> On 3/14/2025 5:50 PM, David Hildenbrand wrote:
>> On 14.03.25 10:30, Chenyi Qiang wrote:
>>>
>>>
>>> On 3/14/2025 5:00 PM, David Hildenbrand wrote:
>>>> On 14.03.25 09:21, Chenyi Qiang wrote:
>>>>> Hi David & Alexey,
>>>>
>>>> Hi,
>>>>
>>>>>
>>>>> To keep the bitmap aligned, I add the undo operation for
>>>>> set_memory_attributes() and use the bitmap + replay callback to do
>>>>> set_memory_attributes(). Does this change make sense?
>>>>
>>>> I assume you mean this hunk:
>>>>
>>>> +    ret =
>>>> memory_attribute_manager_state_change(MEMORY_ATTRIBUTE_MANAGER(mr->rdm),
>>>> +                                                offset, size,
>>>> to_private);
>>>> +    if (ret) {
>>>> +        warn_report("Failed to notify the listener the state change
>>>> of "
>>>> +                    "(0x%"HWADDR_PRIx" + 0x%"HWADDR_PRIx") to %s",
>>>> +                    start, size, to_private ? "private" : "shared");
>>>> +        args.to_private = !to_private;
>>>> +        if (to_private) {
>>>> +            ret = ram_discard_manager_replay_populated(mr->rdm,
>>>> &section,
>>>> +
>>>> kvm_set_memory_attributes_cb,
>>>> +                                                       &args);
>>>> +        } else {
>>>> +            ret = ram_discard_manager_replay_discarded(mr->rdm,
>>>> &section,
>>>> +
>>>> kvm_set_memory_attributes_cb,
>>>> +                                                       &args);
>>>> +        }
>>>> +        if (ret) {
>>>> +            goto out_unref;
>>>> +        }
>>>>
>>
>> We should probably document that memory_attribute_state_change() cannot
>> fail with "to_private", so you can simplify it to only handle the "to
>> shared" case.
> 
> Yes, "to_private" branch is unnecessary.
> 
>>
>>>>
>>>> Why is that undo necessary? The bitmap + listeners should be held in
>>>> sync inside of
>>>> memory_attribute_manager_state_change(). Handling this in the caller
>>>> looks wrong.
>>>
>>> state_change() handles the listener, i.e. VFIO/IOMMU. And the caller
>>> handles the core mm side (guest_memfd set_attribute()) undo if
>>> state_change() failed. Just want to keep the attribute consistent with
>>> the bitmap on both side. Do we need this? If not, the bitmap can only
>>> represent the status of listeners.
>>
>> Ah, so you meant that you effectively want to undo the attribute change,
>> because the state effectively cannot change, and we want to revert the
>> attribute change.
>>
>> That makes sense when we are converting private->shared.
>>
>>
>> BTW, I'm thinking if the orders should be the following (with in-place
>> conversion in mind where we would mmap guest_memfd for the shared memory
>> parts).
>>
>> On private -> shared conversion:
>>
>> (1) change_attribute()
>> (2) state_change(): IOMMU pins shared memory
>> (3) restore_attribute() if it failed
>>
>> On shared -> private conversion
>> (1) state_change(): IOMMU unpins shared memory
>> (2) change_attribute(): can convert in-place because there are not pins
>>
>> I'm wondering if the whole attribute change could actually be a
>> listener, invoked by the memory_attribute_manager_state_change() call
>> itself in the right order.
>>
>> We'd probably need listener priorities, and invoke them in reverse order
>> on shared -> private conversion. Just an idea to get rid of the manual
>> ram_discard_manager_replay_discarded() call in your code.
> 
> Good idea. I think listener priorities can make it more elegant with
> in-place conversion. And the change_attribute() listener can be given a
> highest or lowest priority. Maybe we can add this change in advance
> before in-place conversion available.

Hi David,

To add the change_attribute() listener priorities changes, I can think
of several steps:

1) change the *NotifyRamDiscard() to return the result, because change
attribute to private could return failure.
2) Add a list in confidential_guest_support structure (or some other
place) to save the wrapped the listener like VFIORamDiscardListener. And
add related listener_register/unregister() in kvm_region_add/del()
3) Add priority in listener and related handling to follow the listener
expected sequence.

Regarding the step 1), with change_attribute() listener, the to_private
path could also fail. The tricky part is still the error handling. If we
simply assume it couldn't fail, maybe add a g_assert() to avoid expected
case. Or we also need to add the undo operation for to_private case.

> 
>>
> 


