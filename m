Return-Path: <kvm+bounces-49677-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2417EADC29E
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 08:56:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 499B61893DB1
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 06:56:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A38A828C2A1;
	Tue, 17 Jun 2025 06:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RYeajF4T"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228DE23A563;
	Tue, 17 Jun 2025 06:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750143349; cv=fail; b=arPrqsuZTc6ClkiQ/Ex99jXrygmIJUe8k1Sh1Ac/9L/4JF/awoIueQrQHxZNj8fA1Qph9rjPJN5xW3vn2qvyxKLhVTH7iarKe9FNiuYLUXHkyaG0VETaum8Rp/kKSz8HH84SiB1+tZG4YltsPcsIfKNNdqAPlQMNOIz/dRgmrj8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750143349; c=relaxed/simple;
	bh=4fChFRAXhZfuNyLq3cDI/Qk1aTbRhZ+HADwW+pTLGKE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PWWvkzDpHilzE9SuO9/tV0vv9Y83dcTaHqnDbodXQfDteQ+KCGTFO0dwDlSeg0hXVA34GwQRdvLyrm53+FlRFGohoWzV5EjuMu8nZ4DJhFVyn9uORT31oyyf3ryxcj6SvSnXIP08bx2a1otO7+zrFenWeF0r8PcEEdzmtdq/rL4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RYeajF4T; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750143348; x=1781679348;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=4fChFRAXhZfuNyLq3cDI/Qk1aTbRhZ+HADwW+pTLGKE=;
  b=RYeajF4TZiM2k8C5O9HY+HpkPt9trShjoUMo2aru7ofTs64/QzDo1Ijd
   OqDaWPjGyqawIxY5afrA4rpcTZ2yKVHjInRbvX8JCMb14BnXI/r89lbrz
   fZ6FJZYABzrebNsWsCGVh/luloTfwgYSjtP6sIumhqadgu3r84wAiGOP8
   WgE9ZRVrhGcS0YnN5eP9ZP9UZ7fymnXZxmRPMok6Gz1xo/LP6t4wE/6xY
   QfzRdWPfYuqO2M2yZ0j2KVcAUGydeTNwUGhqmsFFMtNcd/UQjw8RuTeD6
   1niPyLEuR7PnanSSPVMjX+89dCytiyJRsE3wt3qYuInqHDhohRjDFr3l3
   A==;
X-CSE-ConnectionGUID: FULOk1OdRZyMYQdKIvtgiw==
X-CSE-MsgGUID: 4EN7bHsJToCvfXqoIk2MwQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11465"; a="77700932"
X-IronPort-AV: E=Sophos;i="6.16,242,1744095600"; 
   d="scan'208";a="77700932"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2025 23:55:46 -0700
X-CSE-ConnectionGUID: uawHpJuKQya26OOBicJWRA==
X-CSE-MsgGUID: kG1yvnEaRROeuDTjwkuaOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,242,1744095600"; 
   d="scan'208";a="153573922"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2025 23:55:32 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 16 Jun 2025 23:55:31 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 16 Jun 2025 23:55:31 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.50)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 16 Jun 2025 23:55:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FeXwG1gtBhmDRELooBFvy5SsxaVZAtUOkWqhs/kBratPLHxGmTTCL2VFBda5AG0vPIIcCl64B6x2XuPquQJMmfC24OFxzwnsnW8LQueVAkRzgUe5iqevIskZsqAU7r9UadQGtSAdNHF7bc7DvCmcGl1JXfvkWXcOILc+aRBgvFsxIdwQrEp6S3Jt6FdOLMTfdfWkxcGyDDbAHYzXqPQcE9XWZH63zDrazSSbHdpLLO4ZgujMscBjKJzzWC8l9GGhbYEaj2GGCKaYD3wsr7bImnKlYZriGTeEqkeqdgB8i82sOzT9NCjUTWV3GNLOT3IV18u6RHRTs5S1x+WLm6vDeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GCGx5Vli6caHYCz+3Siok5zek/9VWRw6RVuwbinB5mw=;
 b=ByTVg2crNXfvTcQFJ+DLv6rz6LgK0bzS7w0Cpz+pfX8EJ0yTRwbxcC0qH06u1dcS9+l1Bk+0K/6duBXWwSYoFzGzeqeHHD4cpWwxRVIc91jz+sVIipvgFoq7vhqf9ND1fGaen0X9dsm3Z36Oon2NjbVUBoY940cTKaupM387A7oGXhHyCkbpJsmI6t9sdsP5GZjI+q77/fVZUdpE8Bcg5/CKi68CLpdZXIFkTaPe/griYMLLIoYYEFti6SfXeMQPaqln3Pvl57UeUBMpCE4WdDvirxIO3HF0QpiO5PZUglxtemEcZtuw2Gig69fhPPb7GhLnf1BJUOuQFJ024gxSBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SN7PR11MB6995.namprd11.prod.outlook.com (2603:10b6:806:2ae::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.27; Tue, 17 Jun
 2025 06:55:28 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8835.027; Tue, 17 Jun 2025
 06:55:28 +0000
Date: Tue, 17 Jun 2025 14:52:59 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Vishal Annapurve <vannapurve@google.com>
CC: Ackerley Tng <ackerleytng@google.com>, <pbonzini@redhat.com>,
	<seanjc@google.com>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<x86@kernel.org>, <rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@intel.com>, <tabba@google.com>, <quic_eberman@quicinc.com>,
	<michael.roth@amd.com>, <david@redhat.com>, <vbabka@suse.cz>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <pgonda@google.com>,
	<zhiquan1.li@intel.com>, <fan.du@intel.com>, <jun.miao@intel.com>,
	<ira.weiny@intel.com>, <isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>,
	<binbin.wu@linux.intel.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Message-ID: <aFEQy4g4Y2Rod5GV@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <aCVZIuBHx51o7Pbl@yzhao56-desk.sh.intel.com>
 <diqzfrgfp95d.fsf@ackerleytng-ctop.c.googlers.com>
 <aEEEJbTzlncbRaRA@yzhao56-desk.sh.intel.com>
 <CAGtprH_Vj=KS0BmiX=P6nUTdYeAZhNEyjrRFXVK0sG=k4gbBMg@mail.gmail.com>
 <aE/q9VKkmaCcuwpU@yzhao56-desk.sh.intel.com>
 <CAGtprH_SKJ4hbQ4aSxxybcsD=eSQraP7a4AkQ3SKuMm2=Oyp+A@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGtprH_SKJ4hbQ4aSxxybcsD=eSQraP7a4AkQ3SKuMm2=Oyp+A@mail.gmail.com>
X-ClientProxiedBy: KU2P306CA0006.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:14::11) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SN7PR11MB6995:EE_
X-MS-Office365-Filtering-Correlation-Id: eed65fce-72e8-4516-7803-08ddad6bf18a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dGxuUUJPL1ZURFI1cDZVTThaRERYb3pyLzVPYm00eTJDS0k5YlFqa2s0ejNq?=
 =?utf-8?B?YWc4Sk1vTDhqbmU2aFJwakxjWWIxK2oxWnpuanV0d3o0ekUyWitJdm5aMTVN?=
 =?utf-8?B?bE9UT2NGZ2dIWDhxakU3U1FFZE55b3prNEE3ZHVjK252Q3RlNGk4bXBJUEdL?=
 =?utf-8?B?NjVFLzcyNko5d1FzT3FGaUpobGx3cDEwY01OUHNTZjc1bzZHNmdRb3J4QVpw?=
 =?utf-8?B?MzRHT3NxT1Z3a2twYjhHWldPTVQzcDhEQ3dJMnJ2WTJTRi9YSExXb09NZFBJ?=
 =?utf-8?B?M0VCcWRlMFlvVEpicUExd2hraE94UlpqR1Blbmp4a3J2K2xOb3RwbFpmOENR?=
 =?utf-8?B?QlFwVEw5WEZ0dlAvYVdEeWVyYUdwa2lrQ2NDa0dsRG9aaU1lbFhrbVRnZ1Zj?=
 =?utf-8?B?SnpaWThRNWtBbEVYNXlRUzFXelpnWUlGaExJalFVMERDeUtVRk01OVhTTSti?=
 =?utf-8?B?dFFrNmFKWUdENzNrU3VHY0ZxcEhMZThzdjVEdVhsa0VMb0dvcGVNelgzV3FI?=
 =?utf-8?B?ZTVHRkdxamRFOHk2WEp2eUFiVGdqYUZ2TjNoQVJpS3ZZSFVjRGZFaThESjdM?=
 =?utf-8?B?b2xnRDZLN1pCLzRqcnZTajlUMko3MXk3TWtTQ1B4Sjd2QWNFRjI3U3hGY21B?=
 =?utf-8?B?anQ2ci91Q0JvNVRySXBkWXF2VS9yOC92Q0dlVnRuLzdhRzZWWXJRMFkvTngz?=
 =?utf-8?B?N05jSmFYY3FJVzZlOUwzdzdRb3A2YVBNdkN6Y3FUL1k5K3pMRlIrVVBxUURV?=
 =?utf-8?B?TWhDcVFueVI5S0ZNMDRKdzhISmZsNVNqMVloWjlyZStZVWV1NEpxODdPRmVr?=
 =?utf-8?B?TU52Z3dBRmpSZnF1M1ZzNXJBOTFMSWxybSs1UnpZWWN6bjYxRE9uaEJvbXdw?=
 =?utf-8?B?WlZ4d20rYnlVSTVTdlN0aTJGUFYyWllNZ1Aza0hTeXZXaVBBWGluN3F6QmJq?=
 =?utf-8?B?YVFiR0NNVGxRanJvRUdReVU0RlJhOUo2dGZ0SG9BMVZ5NTFIWFVDTC91bkt3?=
 =?utf-8?B?OGpKaEpVZDBGZEtucXptOTJ0YXBLMklLTzVqRzVKZ2loekMwa0Q5c3BJNG9N?=
 =?utf-8?B?dmhxSXNjdXFHcWo5VVRqNW5oM1ZmaDNlR0FrUnNDNUwvVHU0RnRPQ29jeDRt?=
 =?utf-8?B?NGJMUWM4Zno2MFAyYU1EdHlIeGkxdzB1VkRlUTFFTVk4NmdIQUkzMWkrL2ll?=
 =?utf-8?B?UENvYXJvUGFGTEczOHJQbGpwMStKSWpFaUZMaXgwU2lnSmVEM1lpYzF0UkQy?=
 =?utf-8?B?UksreFZuajh5UnhIeU41Q0twRjRsWlJaaC9jbEovdWo3YnJUVWhNeGIwT1RO?=
 =?utf-8?B?QU1Pa1g5elN6QStxOFdpY01mbWk1K2I1d3NoY2xGZVFFQm9GcFpnNWxHakF3?=
 =?utf-8?B?Vmd2Zkp5MThDZ1JhRzEzdTZqQTR6VjlJTjdmanVhTFM3c3U3UGVIN0diNWV4?=
 =?utf-8?B?dWs3cDBGN1B5dGQzdmNZS1NseXpoLzlwQkFGYjFTVmtOQTdzMHEyNnNFVjZr?=
 =?utf-8?B?ZU9WVjNOZmNqdlZwL1BBZ2FRdG1nTU1PTGtYUk55TWVUcmxtK1p0NTIzREtJ?=
 =?utf-8?B?R3hOTUtnS1o0SHZlc3pYZTRXWE0zRzN3bzVBblY2TWw4ZE1FSWRUb2RSY2hp?=
 =?utf-8?B?OW5rc0pKNmJjNkNqc0RVWWk5MDNGQVFhU1UyUHRndWRVMk1lVEF5VHM5a3FC?=
 =?utf-8?B?QkZMNVMvWlp1dVBTVHhXQit4TTU0UjIxelRQYW9BT3MzSEY5MGpld2VZdnVy?=
 =?utf-8?B?ckxmOC9IVWNXWHYwbDB1UnFmM3BuQjlWdnpoSVFFSEVGOWw2cDU2SWhBSUZo?=
 =?utf-8?B?RWx2K3J1RW1nZkREd2N5MWpmTUNSbXIwSjhUR2hMaDN6bU42TTRDbUlQZ2xo?=
 =?utf-8?B?RU4yMWRkZ3lFQVRyaEdaQUtZb3JFT1dvZjVBUW1HUFZ4ZTdnbkdHd29mc2JH?=
 =?utf-8?Q?TKTS8h58SQU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NVpYYm1yZit5NDNSTTd0YWxoSkJTazN3aVNZWUNhcHZTVlJUcXlxVGEvZ2pn?=
 =?utf-8?B?TkVQSzZ5d2NwYVBrWUMxRDNiN0FWdTFUeVFYYWN4SE4wS2FvTjZOZFYrUHF2?=
 =?utf-8?B?OC90azg0Zmh6VHZjRFVCS0tEY3UvT29TcGNUYmhzSzFyT2d4VXlZR1duaHdT?=
 =?utf-8?B?aTNaMHZSbG9JZzhrdGw5T3NQY3RhVFJpRElySDVFLzRLZzZCcFBJTFJydFow?=
 =?utf-8?B?KzRDekE2Tnd5cG1WMHN4ZVJwc1FGTkpiT3dRR3MrYStrYTNPUXR1ZmRFQkY0?=
 =?utf-8?B?VVJ6V0o4S1Bia0dNem8wSVVSZ01LNXl6cFVjMXZ6eklFVERQNndGTDZMS01E?=
 =?utf-8?B?YzROaXVTb0l0MGlXcjcvSDBIQzdyZEk0Nk1KSm14ZklTdXNuZU5jbjRsYnBB?=
 =?utf-8?B?ODVmWVRxVUtYby80cnpGK1grTHhaWDhOeGt0VjhZbkk2MW5ETW9yUzNEaGkv?=
 =?utf-8?B?eUthNWcxc0dPSG9hYkdYR0ZZdHp3ZW5iNXB5TGtBRlF5ckdGVzdXMFkwVVBq?=
 =?utf-8?B?YVRQYXh6MHhVWVNxUDNYRkxyVU1xbGtPdEE0Qkdlb2hpUEZsWG9MTm50ZHdK?=
 =?utf-8?B?T3ZHNVNTN3c1VTYwOGVMTTNiRithM0lFNUhNTkxRcU5TOTYxZFV1ZStLZ0wy?=
 =?utf-8?B?RW5uSVQvdUFmUTN2cXUyWmI1dTlpUjR0N0dIZy9oNG9yNnBzSUxaTWgySjdH?=
 =?utf-8?B?STJRMi9sT2dZNitLRTk1UnRSWVBUczVHcXczWjZyZjQveVFoeDhFSUVEQkVt?=
 =?utf-8?B?eCtUcHBvS2JiSG9kdFdxY0QybGU0UWVHMU5LejNyNkJSWGdyRkl1dEo3dStS?=
 =?utf-8?B?Vi9RNHNUQXF4cmU1WHk5OU1vWnFzaHFvWmZNUkErMnI0NUM0SVl4UG54T0sy?=
 =?utf-8?B?Undla3dYMWRsRmllQ2x3Q3Nzbm9sVmRtcktSQ3ZDdzcxcVNyMWw1NTBEeDhl?=
 =?utf-8?B?UFpsV1NrMU5QMm50S2llTHl4RCtkK04yRmFGeTN5YlY4bkpBd3VIQTUwWFVQ?=
 =?utf-8?B?TjA3Z1g2aXpuaHdNUEd1NnNPU1Q2K1NUNnhoUWJKclpnbVQrSkcxZWdaam9W?=
 =?utf-8?B?MjBrVEhzRmR1TGtZcnlCUHkzd2R1NWZnbS9Yb3VKMjlRbFc5YTI1ZElKQWs2?=
 =?utf-8?B?V0I5eTJIeHBacVRVVjFsRkxkL2lod3FWZXFMa24vS3VyKzN3NS9OUUx6R0hw?=
 =?utf-8?B?Qnc0Qm1UMXJaQ25GQlJkbjFycHJYeG5qYTR6WGpVTzBFZmIrWTBGUnNXSXpq?=
 =?utf-8?B?T2NTc1p3T29hakdYUjJGSitURGpUdWF6eGdvaWVPY3NtN3Vha09iVzNXdVB1?=
 =?utf-8?B?ajBFc2dWRTZmZWVhUnRPN3RSL0xGRExHV0xENjQ4VlhJNkdUVmNqdGQ3eWlp?=
 =?utf-8?B?Z1FIK2NFNzdrbDFOcHJQb3JnTlNXMlA3V1d0WldrWEVMaUVvVHdnZlAxdVBP?=
 =?utf-8?B?cnE5SGZTTUxhWHpwQ2svZW52SmIxSFdnM3dqdlhhUnhCNVB5Q21PYm5iZGhB?=
 =?utf-8?B?NDhWME8xVjVtM1NYMDh4WFhhWkFicVRrZEx6bXV2SUdEZ2p3ZlZlWFFNTERr?=
 =?utf-8?B?Q1IzZFIvYUp5UHdGMXRONDJJVHZBVVBnMk0rRDhxNVFURG4vRXRScUNFSHo0?=
 =?utf-8?B?RlpWUm5tY2RYM1JmUzAzTy84TXlYbFVyNkxzZHVadWRUSGdBTWtrTlYzV1Nw?=
 =?utf-8?B?R01OTzl2aCtjVlYxaWw2Z0hmc29pMk5SeHRVS1Qvc3lGQWZUaGo4c3RQNGhV?=
 =?utf-8?B?WlkwVVFoSFJhUGt2Q1l0SkU1NE5UQUswUkhWSHlkY2U4WW9EOGI0QXBoTVF3?=
 =?utf-8?B?RitYUHU0S1UwQVcwOE9qcndvbkk2Y3gzSzdYb0p6NVJJUkhDbFlxemo4YW5x?=
 =?utf-8?B?ZExUcC9qelIwVE1TY09mR3VIWW5JWVQ5TTNqQ0tYWVJnWkNUL05XZW9XbXp3?=
 =?utf-8?B?Z0xRZXJqMVAzU1JkT2s1WUpGVm1qVzBVeElsTWhyZ0FQc2Y4TGsxNDFFaklG?=
 =?utf-8?B?c1Y2d29iWEZNM3JtY1BJUkRnLzhwY3BnaUlRU0Q2dWdmOHBENWkxWndMQVlS?=
 =?utf-8?B?dGk3WEM4bDBjU1J0eS9LM1A3eUswZHFkRldoNnh0TnMvRHBxdDRCd3BFUVJw?=
 =?utf-8?Q?9EYHoVjsXkaBlRJou6HRHVQ4R?=
X-MS-Exchange-CrossTenant-Network-Message-Id: eed65fce-72e8-4516-7803-08ddad6bf18a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2025 06:55:28.3780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7glioH+wLOa3PdFHJHj4YQ3JTsMiHIjUAC/e7On/awnkqAHKntJmgoLpvgmTxQpv3U4g2KxWBlBnYUldAb73GQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6995
X-OriginatorOrg: intel.com

On Mon, Jun 16, 2025 at 08:51:41PM -0700, Vishal Annapurve wrote:
> On Mon, Jun 16, 2025 at 3:02 AM Yan Zhao <yan.y.zhao@intel.com> wrote:
> >
> > On Wed, Jun 11, 2025 at 07:30:10AM -0700, Vishal Annapurve wrote:
> > > On Wed, Jun 4, 2025 at 7:45 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > >
> > > > We need to restore to the previous status (which includes the host page table)
> > > > if conversion can't be done.
> > > > That said, in my view, a better flow would be:
> > > >
> > > > 1. guest_memfd sends a pre-invalidation request to users (users here means the
> > > >    consumers in kernel of memory allocated from guest_memfd).
> > > >
> > > > 2. Users (A, B, ..., X) perform pre-checks to determine if invalidation can
> > > >    proceed. For example, in the case of TDX, this might involve memory
> > > >    allocation and page splitting.
> > > >
> > > > 3. Based on the pre-check results, guest_memfd either aborts the invalidation or
> > > >    proceeds by sending the actual invalidation request.
> > > >
> > > > 4. Users (A-X) perform the actual unmap operation, ensuring it cannot fail. For
> > > >    TDX, the unmap must succeed unless there are bugs in the KVM or TDX module.
> > > >    In such cases, TDX can callback guest_memfd to inform the poison-status of
> > > >    the page or elevate the page reference count.
> > >
> > > Few questions here:
> > > 1) It sounds like the failure to remove entries from SEPT could only
> > > be due to bugs in the KVM/TDX module,
> > Yes.
> >
> > > how reliable would it be to
> > > continue executing TDX VMs on the host once such bugs are hit?
> > The TDX VMs will be killed. However, the private pages are still mapped in the
> > SEPT (after the unmapping failure).
> > The teardown flow for TDX VM is:
> >
> > do_exit
> >   |->exit_files
> >      |->kvm_gmem_release ==> (1) Unmap guest pages
> >      |->release kvmfd
> >         |->kvm_destroy_vm  (2) Reclaiming resources
> >            |->kvm_arch_pre_destroy_vm  ==> Release hkid
> >            |->kvm_arch_destroy_vm  ==> Reclaim SEPT page table pages
> >
> > Without holding page reference after (1) fails, the guest pages may have been
> > re-assigned by the host OS while they are still still tracked in the TDX module.
> 
> What happens to the pagetable memory holding the SEPT entry? Is that
> also supposed to be leaked?
It depends on if the reclaiming of the page table pages holding the SEPT entry
fails. If it is, it will be also leaked.
But the page to hold TDR is for sure to be leaked as the reclaiming of TDR page
will fail after (1) fails.



> > > 2) Is it reliable to continue executing the host kernel and other
> > > normal VMs once such bugs are hit?
> > If with TDX holding the page ref count, the impact of unmapping failure of guest
> > pages is just to leak those pages.
> >
> > > 3) Can the memory be reclaimed reliably if the VM is marked as dead
> > > and cleaned up right away?
> > As in the above flow, TDX needs to hold the page reference on unmapping failure
> > until after reclaiming is successful. Well, reclaiming itself is possible to
> > fail either.
> >
> > So, below is my proposal. Showed in the simple POC code based on
> > https://github.com/googleprodkernel/linux-cc/commits/wip-tdx-gmem-conversions-hugetlb-2mept-v2.
> >
> > Patch 1: TDX increases page ref count on unmap failure.
> 
> This will not work as Ackerley pointed out earlier [1], it will be
> impossible to differentiate between transient refcounts on private
> pages and extra refcounts of private memory due to TDX unmap failure.
Hmm. why are there transient refcounts on private pages?
And why should we differentiate the two?


> [1] https://lore.kernel.org/lkml/diqzfrgfp95d.fsf@ackerleytng-ctop.c.googlers.com/
> 
> > Patch 2: Bail out private-to-shared conversion if splitting fails.
> > Patch 3: Make kvm_gmem_zap() return void.
> >
> > ...
> >         /*
> >
> >
> > If the above changes are agreeable, we could consider a more ambitious approach:
> > introducing an interface like:
> >
> > int guest_memfd_add_page_ref_count(gfn_t gfn, int nr);
> > int guest_memfd_dec_page_ref_count(gfn_t gfn, int nr);
> 
> I don't see any reason to introduce full tracking of gfn mapping
> status in SEPTs just to handle very rare scenarios which KVM/TDX are
> taking utmost care to avoid.
> 
> That being said, I see value in letting guest_memfd know exact ranges
> still being under use by the TDX module due to unmapping failures.
> guest_memfd can take the right action instead of relying on refcounts.
> 
> Does KVM continue unmapping the full range even after TDX SEPT
> management fails to unmap a subrange?
Yes, if there's no bug in KVM, it will continue unmapping the full ranges.

