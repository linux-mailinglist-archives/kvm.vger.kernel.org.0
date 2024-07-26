Return-Path: <kvm+bounces-22312-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B010E93D161
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 12:56:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6622C2824B1
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 10:56:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2C6317836D;
	Fri, 26 Jul 2024 10:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BDDtNL4Q"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6897E7F8
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 10:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721991379; cv=fail; b=V71vq227KXbnwC0FYgefFDl7PIrP9vWbOt5eOUjI8XrWFSfM2z8dAHPCTRbdYFiNaG+i4et29l4dGO2icXUiWwDdVRm7jCLUad3r4LcOFaoS/YHAGzUdj8NsqOKhK+49rrWTKejEVi3gBmNuTCDOxmHEh1sle5Q5mUaubnkzMUU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721991379; c=relaxed/simple;
	bh=PmS6NAtf0wl660TwEq7XDy9HZ1HPVJF1v6EMegNyk1g=;
	h=Message-ID:Date:From:Subject:To:CC:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aQcGEBLNn5ZHx1KfiGeg/u6A3DdIh9hYzhChRWFynPpR/ZIh4J1Yv+WVp3MjwWO3gHAszGo1AU6KgU66yWQrNU69mrBsPGI78NZTIhsl9SEZdNfPi1Kfh7Yiw4KQdeyzLNIv+9OUd+D5e6lCl3o5Z6wdLvmqAk/R/G/xFWGt2Lo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BDDtNL4Q; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721991376; x=1753527376;
  h=message-id:date:from:subject:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PmS6NAtf0wl660TwEq7XDy9HZ1HPVJF1v6EMegNyk1g=;
  b=BDDtNL4QZDtGesKWdlofPRfQi+FqNijhSsDSqMdCethPAo4GisdECDBu
   ucROu4vpEc9lvd/ebxYvCoGvITu0f47614LADVoXtZPHfxEf/dEMdYIFw
   NZ+3L2LyUdlQc4I/aCeDOAYXAZvdynYtHJGUgsVRN99u6gV/Kief95Hcq
   wZJQkc2bVTi5zSA6Snb6ABaEx7sEwzBQ4Hq4Olel3La2mzqz54y9jkBBh
   OI5TutUrA6oWoBL2xxd2pIPJ7xPpTYIqRm2FT/c+B9BZkJTZm2sZzgNKV
   WtWwKWBuaQrAxdyYSHPnjwL4KcsX1sa7g1asHuBtlBZUQHakEFEz5Ghkf
   g==;
X-CSE-ConnectionGUID: 5bPVNYzUSEmWgSInbTtR2Q==
X-CSE-MsgGUID: 1oRfw74RQxuF/WJF4sF7nQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11144"; a="19966485"
X-IronPort-AV: E=Sophos;i="6.09,238,1716274800"; 
   d="scan'208";a="19966485"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2024 03:56:16 -0700
X-CSE-ConnectionGUID: cJsckgKIQWWGkPfEGgG8hw==
X-CSE-MsgGUID: 02O7L9ZvRhul90FuQgANEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,238,1716274800"; 
   d="scan'208";a="76457407"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Jul 2024 03:56:15 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 26 Jul 2024 03:56:15 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 26 Jul 2024 03:56:15 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 26 Jul 2024 03:56:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wAFsRCaZidswfKQm/b04js/asjDMTHnjBitpL1loBDAG8UM6OdObBUCHkenzXZuMdtlDfXZv2JBHfvdaDFunldwYegeeihnQHSDxtd5XtDdze+6wzDBxoPnKaTNSpsRO0BGi6pNOBJJ21O4XhaU+T0Q6wVkE4jZGaCqJFyz+GjqQ+lPTnC9MzoT90LhhNqoncUtOAYmlhRjAcBieYbJri5tj9mQLnKw0FDGH57BexCwwgyotPDGafWNOQpm954s0BHTu81p/9LB75GyaAaJIxwKY/Dn4CR4AhPrNl+GTMQ0c9S44kbiG5sVUE4Huc6YcoHtZyVWSp76qMsElnEG1Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n0s5JXwXQ4jaDU7xP9ub0DhatGQJj5LAi+rEwyGmRWY=;
 b=Jh5nOPxn3P7syAoVpdp1GwijPPc1jIFSThIauCi8p1j2yqZiK7VarznYJ/L2UIv+IcVKwshNQzcwQk0p9NP6/212HBSYtUTbUCD6fCvIygqsU9mPX19+IIjqV9kgP+Bpk348lRN5VhgkrwvJ1Cp5qyHn2ejsqS4UUk6EVGqyh7YheyepAp65qS9l368jAdhsapX1Q9/RIX8uLg6GXl00+ChwiL6h4ccKNGTMPqAlzBZ3ZljiOtR0o15Ntkpay0iqBp9x98rPvEYUaMzFyaYOur0yltMN4Dv9klWFCEQTjZYV9Z9fMHlqHXU2u9/qNL5X+t4kQZedis2N5B5aMGdy3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 PH0PR11MB7635.namprd11.prod.outlook.com (2603:10b6:510:28e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.29; Fri, 26 Jul
 2024 10:56:13 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%3]) with mapi id 15.20.7784.020; Fri, 26 Jul 2024
 10:56:13 +0000
Message-ID: <0fdd0340-8daa-45b8-9e1c-bafe6f4e6a60@intel.com>
Date: Fri, 26 Jul 2024 18:56:00 +0800
User-Agent: Mozilla Thunderbird
From: Chenyi Qiang <chenyi.qiang@intel.com>
Subject: Re: [RFC PATCH 0/6] Enable shared device assignment
To: David Hildenbrand <david@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
	<philmd@linaro.org>, Michael Roth <michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Edgecombe Rick P <rick.p.edgecombe@intel.com>,
	Wang Wei W <wei.w.wang@intel.com>, Peng Chao P <chao.p.peng@intel.com>, "Gao
 Chao" <chao.gao@intel.com>, Wu Hao <hao.wu@intel.com>, Xu Yilun
	<yilun.xu@intel.com>
References: <20240725072118.358923-1-chenyi.qiang@intel.com>
 <ace9bb98-1415-460f-b8f5-e50607fbce20@redhat.com>
 <69091ee4-f1c9-43ce-8a2a-9bb370e8115f@intel.com>
 <d87a5e47-3c48-4e20-b3de-e83c2ca44606@redhat.com>
Content-Language: en-US
In-Reply-To: <d87a5e47-3c48-4e20-b3de-e83c2ca44606@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR02CA0042.apcprd02.prod.outlook.com
 (2603:1096:4:196::19) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|PH0PR11MB7635:EE_
X-MS-Office365-Filtering-Correlation-Id: 5de25b4d-1df5-43f5-8e8a-08dcad61906e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aHpoZDN4RDJUQXVadDhGeFp5VFJpMmJSc0xaTmJib1crY1AwbitzNnkyOXky?=
 =?utf-8?B?bHExTUhqOFVheEliaU1TMjFwaTlOUzg3YXJ6Rnp1dStMMWNKNUIramRjT3dl?=
 =?utf-8?B?QUx0VnYwK1N4YndHQ2FNZE40U0lLb2dacWd0RWk1M0VyWXp3aVptZWY5aGZ2?=
 =?utf-8?B?c3hERjhsRjhubld1d3dLakNjSEhsZk9CR2RvYmcrVWt1U1FMalpQQTQ5M1kz?=
 =?utf-8?B?UXdlUVRXKzBsZ1h2WU1lejZiMzlWMURIaUZ5eVdhdVdyWXhuSVZQbmNaS0tz?=
 =?utf-8?B?UjUyYVVEcTRFM1o2VFR4YzVxeW8xekswNi9qVk5ta1B1eE5RdlNxOU40MWhW?=
 =?utf-8?B?RzhRby9UT0VLZGpHWEQ3TWtuM3pTUXBxKzd1a2F4ZlYrNXdCdGhkMUs3RXYv?=
 =?utf-8?B?YjF2K0FPTGMvYU9IK3lsMmpyZENRcUphVTR3MTQwM25DTUxia2JmUFZQdVRv?=
 =?utf-8?B?MytxUVJSK05qYjJxTElSN1BRUENabjRjY2dXcUc2SDFoVXVjSHUyQi8wUUVE?=
 =?utf-8?B?cGpLVW9QY2piQkVWSkYzTUg5L0VteDVKeisxcW5ackJGdk1SLythczhQTFh2?=
 =?utf-8?B?OVRDZGtZOXUxVW94dkxBWXljeHhETmtrek1BeUR6dzVEeVZOeTBlVHVOMG1r?=
 =?utf-8?B?andnNi9zNVpnY2dIMkZrL0hxZnRwelAwdi8vTExJaGZRK1pmajdXdmRlc3Na?=
 =?utf-8?B?UzF2MEMrK2t5WHVVTkQwNXh6UzMyNE83cnc1cWgwbGJWR1RZeGRuMTVFRW1s?=
 =?utf-8?B?d2ZQZFMzWFRnbGp4ZlEzVjFNWExYNzlxYkZwUlA0akpwNUt4MDNoMFhKSGVa?=
 =?utf-8?B?bTJhcHRDbFJpOTFGVW5tc0tXNTlIOEd4UWY3TUR0Nzc1c04zS3ZCb3JkM3NT?=
 =?utf-8?B?bXREemU1UmFqdmhxamZLeHBEZ0FyejRFeUdFbXhiZ2JxSXlKb3ZNVy80N0E3?=
 =?utf-8?B?RTgrNlh5bVN0MU1zQkY4S0xpYXNIeHVEMjNtSG02QXRWdHk1R1lNRU9hazB3?=
 =?utf-8?B?aXlZblJURmpGVDdvQ2N6alU2OWhiaDIxanVPU0xUb2w2YSt4U1hybzU0dFVp?=
 =?utf-8?B?ZmZPSDV2NW9TVXd3eVVFeGNNa3QwNlg1azQ4cisxdG83T1hxSTVnZzlkL1Na?=
 =?utf-8?B?RkJNdmpIYWZaNm8vTUI4a3hDNFBuK0NDT2lyYjVaaGRPN3ErSDhtb1U5UnZW?=
 =?utf-8?B?akpwM0pIZjAyZVUwZXVReTUzaTNmV3JOQU1CVGV5WTRnS01oSjBra0JtaXor?=
 =?utf-8?B?NHhwbnBsY3EzSGxTaWVWNjdnVFZDeVNuREdPT1FGcDFGOHhxQ2RnSXJNd1NP?=
 =?utf-8?B?WndORU5zaTRlSkpEUGNxZjgwb1lydDRYQmpLeUJiSmFjM0E4WFRsbHAva1VN?=
 =?utf-8?B?elVQL1BTVjhwTnZzRU1IT3g0enNJMTl3dS8ySzVORFdncVhnNXhCaWhVdWxK?=
 =?utf-8?B?SnJJVHBjV09GVGliSnk2TUNIWWQzWlk0R0hvNXhzQkNRY3FjTDVrY1RWYUll?=
 =?utf-8?B?Z0huK2R5YmpOOXZjeEdNOGFNZ1NjRXI1djFtV0FSVWVDZ2RoUGZhczBvZm55?=
 =?utf-8?B?TldtVzNQajhwNUJwTkhFL2t3UUgzbm1YamVMR1M3NWsyZlh1SDdiWDhjTm01?=
 =?utf-8?B?QTZBLytqRFFueHE4Vk4renVkY1o0NCtsaExkSWZwN2VvSGxBU1Z5aHJFL25v?=
 =?utf-8?B?dXpXNVdiN09xSUJmTmtPUG1FOUgydW16d25XN3FTZ3QxRkZuamRLa1k5YXVN?=
 =?utf-8?Q?+RV39l+LuP9scHaEIg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?clFUclBLYjAzUk5qeWx0RjNvUmU3RXVrSEt0aFU4VVRaYU8wVEFlRm5JTG1B?=
 =?utf-8?B?QmEzWGU0ZjEwRUs1QXpJUjBmbWZXd0Ntb1NzMWpQNHFPYTlHNWhDZDNKTjdz?=
 =?utf-8?B?RTFhdE50SkRDd3BUQ0lHZ2x3dkNsdmM0OENUaUt4MmJPdmFKMTZFVGczMGtG?=
 =?utf-8?B?aXQzaUxLVTMzNVd5TkprTVhtTi9zdDNuZXR2MHY0NytvQ2g0ZVZkYlBZeE01?=
 =?utf-8?B?L0RGTFM3Z2xsWDZDWUZKVGJEdThDM0NYSm94RGlTSWQ0amZsRUVuZnhoYStz?=
 =?utf-8?B?Z21YRDNjN3BvMFVna0FVUXRPUDNQSHhMZkZRVG1UTkk5NHFtZGU2UHV5ZE9Z?=
 =?utf-8?B?WktUNVJjYVVBK2QwTjNnTHY1cU0yL3BZdU5KREw0VUwwdk1jd2VLa0JsMytE?=
 =?utf-8?B?a2VuV3dCdmo3S3k5UjNRRWpTaUkwVWRKMUkyWEluTEZnTHozdEVoWmZ5bm95?=
 =?utf-8?B?QnFocVJjN0tweU9XT0N5K1R4NFdWMW9SNWhTaTJYVlNjZDNyREZuQjNVZ2J2?=
 =?utf-8?B?RnZRdDc2M2lQQW5jS0RYaEpGN3JXZllDVUtDZEJrd3o2UGp4cWlsK1doeXZi?=
 =?utf-8?B?WGkxdW5EV2lXeHVSMlF1SmEvem9iaDF1VlUwcWJBYXprOHlGSEZCU0orYmRX?=
 =?utf-8?B?SHVKU09YVlI3R3VpMGw0VlRIaVFYLzJBZ3BoYUVydDZYNXlBY1BXWDk3WWhv?=
 =?utf-8?B?R2prcU54K0tLd1U1bVd0RHJoUWtVM2htczhpOWFlSVMweERTSW5FL3ZNdnFR?=
 =?utf-8?B?dXcwU1ZPT3pia1JLWHBkUjZidUhRWnJqdlZzZHJnL1NHbS84UHIvQno4VXNP?=
 =?utf-8?B?OXB5QWpLN1VCNVhhNTZOZUhsRFpMNjBBRGcxLy9tR25MMFFMdjZXT1ZlUkRp?=
 =?utf-8?B?dFdydVlVdk1YQTRza2lOQmowYU1BdWR2YjVaRFJrQ0hsMzNERk8xUC94UTNM?=
 =?utf-8?B?SFVWM0FkUTRhTE5Nclp4V0RjK2RqV0llLzJRcnd4QlY0QnlRY20rbSs0WjlI?=
 =?utf-8?B?Qmd4akxKa3prdGphVThEb01Jb3ZzYUpXTk5lMUpNM3g0dDZRZU1WMVB2WStV?=
 =?utf-8?B?cExvM0tTRFNXL1kwUW9qRjV0RlB0ZVF3ZndxeG4yNFJUcjhEcmxoWE5YMnRX?=
 =?utf-8?B?ZlBBbnV2bTJpY2ViRmdTYWs2TEU2Z3ZJUEFHditQTmxuR3RVcjl1SmtzYWt2?=
 =?utf-8?B?dGFxQjdQNHJuMW55WHJPZGNVYmdseHc1VEhscUg4bVpSd0RXcVBGWWhxb1Nz?=
 =?utf-8?B?a3NPbTgrQ2lNUmN4cTh0SGhGaDRBcTdsZmZuM0hCNW9HTC9udnpLY1VZYXhT?=
 =?utf-8?B?eGpxQ2xYRUlvZVhISVVQNExoRWV6ME0zalVDcGI1TnFrUVAxWUFqbnVjZE1z?=
 =?utf-8?B?a2Y2NVFRaHA5MjJ1bkdOWmlXb1IwZ0JMOTU5dE5VN09QV0VlRUtsVnJxdTVw?=
 =?utf-8?B?S3lzRUI1WmVFQ2J4UG1BZXdWWDNkZ2VMZTJ0QXJiZVFIN08zK1AwL0FVeDh1?=
 =?utf-8?B?V0dSajhnVkZva2tHSWdMNU5xRTZYZzFtOVY5eEJOaXdSNS8yZ0Z5Wi9zVFdt?=
 =?utf-8?B?NG82OWowdVI4K0RlQ0xxQWxzbnNzc1NyMUFvNnA0WVlJT1gyUVNjS1puTno5?=
 =?utf-8?B?TlJObkwwVEowUVYyUjQwbWdUUzZQTlAyL05jR2lnaVAzSmxIdzlMZmE4WTdG?=
 =?utf-8?B?eGhCVlhoZ2FERWx2clE2Z3JhYzB6bTRpVGpwNGlhL3hzeGhERTBiVDlRUVhB?=
 =?utf-8?B?T0w1K2NDRmEzRHFJNCtzc3JtZHlONm03WWxROU1DMng0KzNOVjlTaFdTdTNl?=
 =?utf-8?B?emNtb1NJTFp3UGhXaDhhZVFRQXROQWJTd3hxaFNnYm1rSnRMZnRMOUFza2RP?=
 =?utf-8?B?OGt5MjFuMGNlM2VqSWs5Ry95WmVJQitybGVZNzRackhoS1JDQVFSb2xQQ0VC?=
 =?utf-8?B?TTgwc2drTzhzUnNidHhFS0dWU1VmUXFwMVNxZ2JGTGJyRXJqWjlaNjNkVWJH?=
 =?utf-8?B?RzViZktkT0JUTlpkNGY3WUZVeWtHM0lDOHZlb3U1MTVzZXlHMGJpSUUxblpS?=
 =?utf-8?B?NXBaNS9tOVBEMy9yTHRGbmVHVldKdXB3MFBvbk5iMzBKcFFPQVFzcTFKS3lO?=
 =?utf-8?Q?OKndjWaMG7MY3uZ9ld+n+FoBz?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5de25b4d-1df5-43f5-8e8a-08dcad61906e
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2024 10:56:12.9339
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zbp3w/CPpOcQ09grWdTSJUHjDAqJzgmlJ1gari2/4iJD3MYHOL1fho14uT54G1bBhwGwu4mGVtI/nxioLokfRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7635
X-OriginatorOrg: intel.com



On 7/26/2024 3:20 PM, David Hildenbrand wrote:
> On 26.07.24 08:20, Chenyi Qiang wrote:
>>
>>
>> On 7/25/2024 10:04 PM, David Hildenbrand wrote:
>>>> Open
>>>> ====
>>>> Implementing a RamDiscardManager to notify VFIO of page conversions
>>>> causes changes in semantics: private memory is treated as discarded (or
>>>> hot-removed) memory. This isn't aligned with the expectation of current
>>>> RamDiscardManager users (e.g. VFIO or live migration) who really
>>>> expect that discarded memory is hot-removed and thus can be skipped
>>>> when
>>>> the users are processing guest memory. Treating private memory as
>>>> discarded won't work in future if VFIO or live migration needs to
>>>> handle
>>>> private memory. e.g. VFIO may need to map private memory to support
>>>> Trusted IO and live migration for confidential VMs need to migrate
>>>> private memory.
>>>
>>> "VFIO may need to map private memory to support Trusted IO"
>>>
>>> I've been told that the way we handle shared memory won't be the way
>>> this is going to work with guest_memfd. KVM will coordinate directly
>>> with VFIO or $whatever and update the IOMMU tables itself right in the
>>> kernel; the pages are pinned/owned by guest_memfd, so that will just
>>> work. So I don't consider that currently a concern. guest_memfd private
>>> memory is not mapped into user page tables and as it currently seems it
>>> never will be.
>>
>> That's correct. AFAIK, some TEE IO solution like TDX Connect would let
>> kernel coordinate and update private mapping in IOMMU tables. Here, It
>> mentions that VFIO "may" need map private memory. I want to make this
>> more generic to account for potential future TEE IO solutions that may
>> require such functionality. :)
> 
> Careful to not over-enginner something that is not even real or
> close-to-be-real yet, though. :) Nobody really knows who that will look
> like, besides that we know for Intel that we won't need that.

OK, Thanks for the reminder!

> 
>>
>>>
>>> Similarly: live migration. We cannot simply migrate that memory the
>>> traditional way. We even have to track the dirty state differently.
>>>
>>> So IMHO, treating both memory as discarded == don't touch it the usual
>>> way might actually be a feature not a bug ;)
>>
>> Do you mean treating the private memory in both VFIO and live migration
>> as discarded? That is what this patch series does. And as you mentioned,
>> these RDM users cannot follow the traditional RDM way. Because of this,
>> we also considered whether we should use RDM or a more generic mechanism
>> like notifier_list below.
> 
> Yes, the shared memory is logically discarded. At the same time we
> *might* get private memory effectively populated. See my reply to Kevin
> that there might be ways of having shared vs. private populate/discard
> in the future, if required. Just some idea, though.
> 
>>
>>>
>>>>
>>>> There are two possible ways to mitigate the semantics changes.
>>>> 1. Develop a new mechanism to notify the page conversions between
>>>> private and shared. For example, utilize the notifier_list in QEMU.
>>>> VFIO
>>>> registers its own handler and gets notified upon page conversions. This
>>>> is a clean approach which only touches the notifier workflow. A
>>>> challenge is that for device hotplug, existing shared memory should be
>>>> mapped in IOMMU. This will need additional changes.
>>>>
>>>> 2. Extend the existing RamDiscardManager interface to manage not only
>>>> the discarded/populated status of guest memory but also the
>>>> shared/private status. RamDiscardManager users like VFIO will be
>>>> notified with one more argument indicating what change is happening and
>>>> can take action accordingly. It also has challenges e.g. QEMU allows
>>>> only one RamDiscardManager, how to support virtio-mem for confidential
>>>> VMs would be a problem. And some APIs like .is_populated() exposed by
>>>> RamDiscardManager are meaningless to shared/private memory. So they may
>>>> need some adjustments.
>>>
>>> Think of all of that in terms of "shared memory is populated, private
>>> memory is some inaccessible stuff that needs very special way and other
>>> means for device assignment, live migration, etc.". Then it actually
>>> quite makes sense to use of RamDiscardManager (AFAIKS :) ).
>>
>> Yes, such notification mechanism is what we want. But for the users of
>> RDM, it would require additional change accordingly. Current users just
>> skip inaccessible stuff, but in private memory case, it can't be simply
>> skipped. Maybe renaming RamDiscardManager to RamStateManager is more
>> accurate then. :)
> 
> Current users must skip it, yes. How private memory would have to be
> handled, and who would handle it, is rather unclear.
> 
> Again, maybe we'd want separate RamDiscardManager for private and shared
> memory (after all, these are two separate memory backends).

We also considered distinguishing the populate and discard operation for
private and shared memory separately. As in method 2 above, we mentioned
to add a new argument to indicate the memory attribute to operate on.
They seem to have a similar idea.

> 
> Not sure that "RamStateManager" terminology would be reasonable in that
> approach.
> 
>>
>>>
>>>>
>>>> Testing
>>>> =======
>>>> This patch series is tested based on the internal TDX KVM/QEMU tree.
>>>>
>>>> To facilitate shared device assignment with the NIC, employ the legacy
>>>> type1 VFIO with the QEMU command:
>>>>
>>>> qemu-system-x86_64 [...]
>>>>       -device vfio-pci,host=XX:XX.X
>>>>
>>>> The parameter of dma_entry_limit needs to be adjusted. For example, a
>>>> 16GB guest needs to adjust the parameter like
>>>> vfio_iommu_type1.dma_entry_limit=4194304.
>>>
>>> But here you note the biggest real issue I see (not related to
>>> RAMDiscardManager, but that we have to prepare for conversion of each
>>> possible private page to shared and back): we need a single IOMMU
>>> mapping for each 4 KiB page.
>>>
>>> Doesn't that mean that we limit shared memory to 4194304*4096 == 16 GiB.
>>> Does it even scale then?
>>
>> The entry limitation needs to be increased as the guest memory size
>> increases. For this issue, are you concerned that having too many
>> entries might bring some performance issue? Maybe we could introduce
>> some PV mechanism to coordinate with guest to convert memory only in 2M
>> granularity. This may help mitigate the problem.
> 
> I've had this talk with Intel, because the 4K granularity is a pain. I
> was told that ship has sailed ... and we have to cope with random 4K
> conversions :(
> 
> The many mappings will likely add both memory and runtime overheads in
> the kernel. But we only know once we measure.

In the normal case, the main runtime overhead comes from
private<->shared flip in SWIOTLB, which defaults to 6% of memory with a
maximum of 1Gbyte. I think this overhead is acceptable. In non-default
case, e.g. dynamic allocated DMA buffer, the runtime overhead will
increase. As for the memory overheads, It is indeed unavoidable.

Will these performance issues be a deal breaker for enabling shared
device assignment in this way?

> 
> Key point is that even 4194304 "only" allows for 16 GiB. Imagine 1 TiB
> of shared memory :/
> 
>>
>>>
>>>
>>> There is the alternative of having in-place private/shared conversion
>>> when we also let guest_memfd manage some shared memory. It has plenty of
>>> downsides, but for the problem at hand it would mean that we don't
>>> discard on shared/private conversion.>
>>> But whenever we want to convert memory shared->private we would
>>> similarly have to from IOMMU page tables via VFIO. (the in-place
>>> conversion will only be allowed if any additional references on a page
>>> are gone -- when it is inaccessible by userspace/kernel).
>>
>> I'm not clear about this in-place private/shared conversion. Can you
>> elaborate a little bit? It seems this alternative changes private and
>> shared management in current guest_memfd?
> 
> Yes, there have been discussions about that, also in the context of
> supporting huge pages while allowing for the guest to still convert
> individual 4K chunks ...
> 
> A summary is here [1]. Likely more things will be covered at Linux
> Plumbers.
> 
> 
> [1]
> https://lore.kernel.org/kvm/20240712232937.2861788-1-ackerleytng@google.com/
> 

Thanks for your sharing.


