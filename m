Return-Path: <kvm+bounces-71574-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YHqOI9cFnWk7MgQAu9opvQ
	(envelope-from <kvm+bounces-71574-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 02:58:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 05A33180C65
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 02:58:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 85A8430733BF
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 01:57:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 393471DFF0;
	Tue, 24 Feb 2026 01:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MjLWNKHy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89227244687;
	Tue, 24 Feb 2026 01:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771898272; cv=fail; b=nXixewDPk0dYOS8ra2V+LZF8v21YsfsJKRufV4kS2obTqEIyyYh7QE4GxM5VEi2jWyk3L289KGqGHfty/XzuJfoVq8sup5TD99FVBKS+15xa1TZwUNC4dRpvbYgLKOqwNSJIXLEJDD2sUlXQIhl39EPDk+mCV9FRDO9wFStx3zo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771898272; c=relaxed/simple;
	bh=rjz9Yzwc+kY/0TT7ylKpehWf5nTExKvB+CGb2q7prqE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qdahPofk0zrj2AtVYJjg3+orcEME6OEtX/BszP6l3vYqHodIYoDGqp14vn7WLq3f2ryq7A3w80LHTPqMte06zr/aWpWpoyzehfIuUrfMFe1lR/QtBq9gPfFALghLg2JEQFqEAKdl+nGfAbyEiREo/PZKfgIQqxNKneaFO4PeSsw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MjLWNKHy; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771898271; x=1803434271;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=rjz9Yzwc+kY/0TT7ylKpehWf5nTExKvB+CGb2q7prqE=;
  b=MjLWNKHyHOYTL8BsHcOc/eZhUpG3LW6Rv7VJp4Vk3Kxi1BtO8st46DX5
   XgNswp6mUGPfXktiW6Yk7qJpDydBK+evrvsdY/G/228dnGImdQK0iPFh4
   jKlBsfdJ/vkN4K+gmORHKSNK3VdvC+dE3GKsbkmAFTbDmJG3d93/RpeFc
   zRUYliEcNS9xUS1VcKXbalTEPAXlVQ3MQo7DNdlN1DVjjXRPIwcRZVAlW
   ZdBFQiYXOrRQjAtDVVuR9LkuAYHlZE9Ct/WeKybS2rayG2lbol0kka/9f
   i2CX+JFZe3ODP7ZieOY/PdHPd04EO6R5IPiOeLOuUlvNknAWR1ZmjoY5U
   A==;
X-CSE-ConnectionGUID: fnn1WaJBTK2JlTGrUBQuxg==
X-CSE-MsgGUID: 2zaNb1W8TJiPU4B6ydx/Gw==
X-IronPort-AV: E=McAfee;i="6800,10657,11710"; a="72816987"
X-IronPort-AV: E=Sophos;i="6.21,307,1763452800"; 
   d="scan'208";a="72816987"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2026 17:57:50 -0800
X-CSE-ConnectionGUID: PeZMJ+OnS9mwAab/UCiEbw==
X-CSE-MsgGUID: m5xaTeJzReag665ENDpZww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,307,1763452800"; 
   d="scan'208";a="246337240"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2026 17:57:49 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 23 Feb 2026 17:57:48 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 23 Feb 2026 17:57:48 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.34) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 23 Feb 2026 17:57:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=poyIVtzy2kpDFLy5Fp2o7XTRpOqnrqDApFZpb+z40arEgHFeA2sCHGzAV1yfqbclEpwV2ZF/B/d8sP1pVIPFYuq6GGxcZa1Q9hZVp3wLrEMnNse0VR3uIxSSPrtJP2XExT9leK/27LUbLpwe9kr1pxAVd+f0DHdkLr62vF8mYm8oxFpRgocUqEJfHUsnD9c5zvJvDYcJrDnG7wNdC4BTzRTquZ2s1KJXTZlrvSrN1epo3uT/6VGPkxW4JTEdeedvqvkUVjE+3tMVZNN1+ez3kfg3j8pwjn47m8A8rxXyxgTJmFnGoUGuk1k2yW6KiBOJ/0FOePrNi9ip2pGoXLsgxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rjz9Yzwc+kY/0TT7ylKpehWf5nTExKvB+CGb2q7prqE=;
 b=aFcXLhxMrk85g09S82mKNVNp8yhv2Ptm0YwCXqSoN9TYKW8SzCq/SZ//iBE42LTe7JHNWUhPeA6toqdwVPaHJZKt/BGQ05OquKwzROxciMYFvx4jLaO2GLUSZ8ssAx6ZW435e+RyxjtiKtY2oMWzqccoERtin5tCt6kWmcQp2NSSl7+stdUHeNJDKav4cDRIr7o3Jh3M3qFBmu2CSF7j81SiMzlL0iKdNmCuXsoFxNAGrTCe53uYSZCKf0IJ1iouO54oAmPoYn2cGu3MLaZqgSgV60FoEovDtXiCOPi0rQ7/LrHmqbT0zSCwovaIWWGuPJWzy7DjOcODIJeIoCx/xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH8PR11MB8037.namprd11.prod.outlook.com (2603:10b6:510:25d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Tue, 24 Feb
 2026 01:57:46 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9632.010; Tue, 24 Feb 2026
 01:57:46 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "changyuanl@google.com"
	<changyuanl@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "Wu, Binbin" <binbin.wu@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
	"kas@kernel.org" <kas@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "tglx@kernel.org" <tglx@kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>
Subject: Re: [PATCH] KVM: TDX: Set SIGNIFCANT_INDEX flag for supported CPUIDs
Thread-Topic: [PATCH] KVM: TDX: Set SIGNIFCANT_INDEX flag for supported CPUIDs
Thread-Index: AQHcpQ2GOhqLqfK3/0a3C1hWKddGMrWRGDiA
Date: Tue, 24 Feb 2026 01:57:46 +0000
Message-ID: <213d614fe73e183a230c8f4e0c8fa1cc3d45df39.camel@intel.com>
References: <20260223214336.722463-1-changyuanl@google.com>
In-Reply-To: <20260223214336.722463-1-changyuanl@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH8PR11MB8037:EE_
x-ms-office365-filtering-correlation-id: 8d88921f-6942-48a5-f70a-08de73481aff
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?Qkd0OWxMMzdvMkJray83M2VkVVNxenUzTFVRQmxrcXlMZUhSbXFiT3ZBeGMv?=
 =?utf-8?B?cHVzRmZNZFFtY0U3SVJYMm50Rk9QSHdCUjIxWDczdzZRK3JaUFdyWmZOWmtB?=
 =?utf-8?B?N1JUbXl1ci85bkhZTm5nVTlqRlhjWUJwb1h1cTlNcEFnREhmSWR0ekEyZjJq?=
 =?utf-8?B?ZG9mQ2lQWm1vd1VNY2FLQ1FTb1RYZFlUOEdmbkNrM3JCMXVaQlM4N0hnYVRO?=
 =?utf-8?B?aGV4OEdRemJjazgvbmVpS09YZFMyK2p3RXlqeDJTa3ljV1VWeTVYYUpETTNC?=
 =?utf-8?B?T0FCaUtmMEVuc2JnOWgySS83ekFmT2poZTJVN0wvYUtuK2dtdjlQcDZYVTM0?=
 =?utf-8?B?NWNaajY1ejVtWlJUQS9Qa0RUU2hDdzNaZzM1RlUvMDVHTDQycVJaOFJrMVdC?=
 =?utf-8?B?dW9RR0hxSzAxRmxjY3Y3TVdvV2laNFI5V0gyWFZteTl3akJHUWVxY1phSWt5?=
 =?utf-8?B?enFRWmFqY3JnOWRxak5uN0ZEdWhPQ1ZONnJ5bzZpdlE3emNBSWNCSWkwYlhQ?=
 =?utf-8?B?bExyV3NVeTQySTU1MDFYWjYyUFBxQnBZeUozeGRJSENtTG1sQkxHWWcrdnVt?=
 =?utf-8?B?Yyszdy92WWd2WWZBa1g0ZDNVYUtHOWFpK2ZUWk1GRzBseHZPY242cGJST0pt?=
 =?utf-8?B?RllXYWpRZWNOd0x4OXAzUCtHcmlSRnZxZFNOR3Mxb3k4NEpXcUNLdGhVZDNw?=
 =?utf-8?B?NUFLQVI2emM4cG5tcmI1RjIvb3ByUFdrZWFPOUZSUnRIZTdDcnl5QjBidmdO?=
 =?utf-8?B?c2luS2xPclRrUkh2R2k1c1NpcnFpS0UwLzEwMmJlZGpjTEMvYlU3NjVZVzY1?=
 =?utf-8?B?QkZkSzgvbUE0TE1RekIwMktOMFJrdlRNYjl0aDRxd0NYU2ZYVkNEUDlVWXVO?=
 =?utf-8?B?SWpMUU5VOVVkQmV6ek1XSDZFcWt3a21mWjMyTTdORVo1SEdXbUxPUC9yd0FQ?=
 =?utf-8?B?WThrQVBmU3Z3NC9aYmlxaERRMnhnSkxudE9aSXRxQ3g5OVNJdDdNODYrSkZU?=
 =?utf-8?B?eE9lYUZNUTVvdnViVmozc3N1NnZhcHUzaXJkL3VpcjVPZ0JUZ1hkS0xXL0h4?=
 =?utf-8?B?bW9Tb29Ma0tJNGhLeWFLblNVeW1jcGlUNDJvODF0M1NGRGVMYUpSNk1EYmZU?=
 =?utf-8?B?WEF2R1ppMFo2M2hEdXZiMzg5YUQyc1hjTDZiSVMyOXBYWEdVMW9XSm1OdnZa?=
 =?utf-8?B?SzR4N1VsUUZmZ3l6NGpianBpaHJvVGwycWYzc0h5S250NGJwSFdrTWpFZVdi?=
 =?utf-8?B?Wno1LzFEM3lYR1ZOMXpFR3pxZTM3WnJGazI3cThWeTNYQXp4aHl1aWh0OW9L?=
 =?utf-8?B?YXhuYytNZ29tRjc0Tm1ub214dndJMjV3R09rWUh3KzgxU1VkdGRaNmFIWDRE?=
 =?utf-8?B?Sm1tMWhVVU9QVXptTjNPL0E2aENJR1c3Qm5yZXhWUittZXBHMHVwV3ZibFox?=
 =?utf-8?B?aUlaejN6MDBGYU9EVnhuMFZRd2lvYnZSZnA1dVpGRjc2eFNOM3ZDWWtiQURI?=
 =?utf-8?B?UGVXazZHSURnSW83RWRVT2hZSmpqYnk4OUh1RS9ZSm9nQ2Z4TVI5eDVIOVMz?=
 =?utf-8?B?MGNWMGxEdG1jOVRleW5VOCtUNG9nQWY3c3VJN0F6d1ExZkdhNEJiRVhTcVVl?=
 =?utf-8?B?Q2xWVXA0R09GOFV4VGkxZkpRWDQ0Ylp0aFJuVitzZzJURGFYZ1pmVTBRc1ZK?=
 =?utf-8?B?bWtqYlhQQ3M5MjVTcS9FYlFCbm11ZnFFYldhREJVRGUzdFhBMGUvQzB2d0JV?=
 =?utf-8?B?QmVVa2lIM2hsbThGbE9PMFVtLzhsazY4RzUvMjJhdnQrRkFpZUpqVFlwSzE5?=
 =?utf-8?B?SFFha2d1SlRKSlEybm84M0ZEbjJ5YURwOEcwcjk1TUhxQWJST2lDTllqOXcz?=
 =?utf-8?B?bWd0WGFpV1ppUDNQdHpZajBVTUs1V3pTd1ZUZTZjMzQ3U0lNTWNraFEwMDZv?=
 =?utf-8?B?TDZBV0JrL01YMVhrQmdiN1BjVjB4YVJ6NXFYQVB6MGNaTHJxYzRzQlRDbFZO?=
 =?utf-8?B?SUd3YTdvR1N0dS9BeTIrMHNXTDRhTkJDcmJqRzQ0NjBDNEV1Sk1kU1Y3elQ5?=
 =?utf-8?B?RFU5ZEVkU0dOaHpYVUhjeDB0SUlMMXIwQ3VPbXRMeXA1dGMzekwvMnk5Q1pI?=
 =?utf-8?B?VVVheHhMdnBRbWdISGk2cU9TTC94cWRUYjdraVVKVFVudkJObUNaVVBwcEo1?=
 =?utf-8?Q?a00WOXm9bJ5qZ6Ua8yd9e6Y=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VXlxUUdKQTJWMkJGQkVwSWo2NXp1NHdTTnA3NDU4WEpYejNPS2kvOW1zSjVQ?=
 =?utf-8?B?Q25QQWFPZW9lSHg1R0NPcmlWT0FxbzRHbnUwbG5iU0ZaeEhyWXBNdUNVN1hJ?=
 =?utf-8?B?T1FmWHdlcWJwTUN4NUdKek1PU0RlVnFuSCtPNDB0c1l2YkExVXlHcUdlVW5G?=
 =?utf-8?B?RURtcUFQcHJyNTZzYjlBc0VrNi81ZVl1dW5yS2QwUDNKRE9hYWtxbnBQd3pC?=
 =?utf-8?B?bzBHZWRNRENiVHdIYVl5OWdkWnlxclVXc2NHdndLVVY3VWRMZVVQMWk4RkxW?=
 =?utf-8?B?a0c4ZGNGcmI0VTQ3QmdJNXB3bW9TK2toRmFqSzU2ai8rbFlFUVpwY1E2NkpI?=
 =?utf-8?B?UU5odDdVV00wR0k3UTZVVEpuOEZWakMzUFhBRG5TY1BCY2RSV2RBM3FJdS90?=
 =?utf-8?B?QVVCVWdmQnBhUFYxWWVmQ2NoNmprdmwveUI1bE5wUk16OTBUdnhiUnhYTS9a?=
 =?utf-8?B?SG8xdXNZelJZU3NocVo4K0x5bFRKd1pNYXdqdTM3THZWTTUzblp3S0pWam5B?=
 =?utf-8?B?N3NDTDJPOGNMOXR6TUd1UnJPaGJtdk4vLzNsTlpPSmcrRy90N3JDbENWaXlF?=
 =?utf-8?B?Zk83Uis2ejYwZWxKNkJOZkR0WUNOcDY3ZXl1S0tRTUZwcjNEaHZxdkpZUUtF?=
 =?utf-8?B?MVBsaW42S3l4UDY0amw4ZTF4MTlQVDRGVE1qUGw5UkVLNEpMZkNSVW8zTkZG?=
 =?utf-8?B?MUZmZFBvb2FYbS83OVFpcFhqVFpka29uMW85LyswaWdFc1ZrUXNhNHlEQnhl?=
 =?utf-8?B?QjdRSGNEYXoyZ25oV0JSZGtJMnBzOTNpYTlRbk1ld21pRUJRRW5CNHRmd0Vt?=
 =?utf-8?B?YUpNTHRTZEFUZXBuRGNuZEtqMzBHK0lqVjh2bk5xVWxlUWJ0UDBkTDg1ZDhM?=
 =?utf-8?B?Nll1TnVQV0pPcmxlcXQzT2hRdytvK3ZBc3J5NFc4ZEJ4MGZZYkNRaDh2aklK?=
 =?utf-8?B?emZhT3hxTEpacTd0QTEzNkdQa28vQzVZejRheWY2SVJRdHRhUXJaeWMzWVJx?=
 =?utf-8?B?VXU1blRkaG53U0VuN3dTNzA2TnMyZzB0QjVRMHc2QkhEVnJHczRXaFJHL3g2?=
 =?utf-8?B?Z3ZKeTVqejF0RGptV2RmQlpSTEh3dlVLeWJjUTdTR01wS1pBWFNVOEx0N0dW?=
 =?utf-8?B?eXY1UWY1UGZydjllOXV3dWMxc2daUk0wWmtWRXcyL2NINUVtWWg5L0JYU3du?=
 =?utf-8?B?Y09XblZyb0RKQWNiNVZ1dWdMTkRxdkMyb0crd1luQWg1Q2FZVDBGWlRsS1Y0?=
 =?utf-8?B?MmUrbFk3VnMwY1ZNZmF6RWFFQ1llR1dKVG90cTBJc0hjUE9yZEl4RXZEMmpX?=
 =?utf-8?B?b1llUzl1bzV5TUtNOHkzamNoRFVwUlRyNmZ2QmN5OWgyWFlUdFhWWjRZdW1l?=
 =?utf-8?B?MWFZTnlSRVhnVkdOTy9GYU5BZlNvUHpFaWx3aGl6QUdFdTBHdkdmRTc2N3R3?=
 =?utf-8?B?emlmaFdTMTc5ZlFST0ZOT1RHMzRMcTVOcnlJOEZFMXJ5eHBDY2NzeHNTMzVH?=
 =?utf-8?B?Qndyd3hobmUyRUxRT2ZaRlB4dHJMOTNjK0gyK0ladFF0Nlk0RWVCU3VPQ1FF?=
 =?utf-8?B?T3VteW00ZzlzQjNQRHpSMFc2U21HL0VLZHNFTkVYVHlha2FPdExhK29wdzk4?=
 =?utf-8?B?L1JSRkxCRlBmNTRyUkNoVEpsZG41SUVSZW9xYXQ5UWdLVFJib2lNT1RPdkFj?=
 =?utf-8?B?dElpVG9qaDhhbUhDVlgrVTFNcU8vTkFLdzF2c2N2b0I1Wk9oQm8yVm5ocU91?=
 =?utf-8?B?ZHF1NEhjZWJVNFQ0cklpbWEvb2ZmdEtDWUVnczQzbFRKTXNINDRuVTRwSTJM?=
 =?utf-8?B?N2xBbWpnbHFLTjY4OWNHdW9DZy9kTmxhT0dvNG0xNDJ0VVdQQlREWGxuYVpa?=
 =?utf-8?B?UzBBQ3p2V3daQ0ZvaWVQbVlHZEVSS1IxSkw4ZmtyS0ViQ29HYUkwelFSWUxp?=
 =?utf-8?B?ODJsM0pyS1o2NytRbXM1bjJ6cDdRTTljYkpTMS9wclRiUWQ5WTZoUG5EZGQw?=
 =?utf-8?B?Y29YckxjR09Qc3pvVGluSHE4WmhlZGFzS0tJeXJxeFdiN0JFSXI4amRRQ2Vr?=
 =?utf-8?B?bG9nckhueTMxWmFPdEV6SXNqVzJBUmFNQjZJY0lPc0JTWk14aUVIR2liMWFC?=
 =?utf-8?B?OTZUcE1mZmlmVHd0bTZDWkNheVBHcnVLcFJUSHV3c3RyOThHNFlYZmdWVlR0?=
 =?utf-8?B?bUNobVJsRUtaem1BYlVCZDQzUzdBMDBjamFnS3VucDRJWi9jRWVpZ3R2Tkhx?=
 =?utf-8?B?UktML0hKRVkraU43MkNWUmZIWXZqK3pOeHV0RmsxYVNWT2g3eHBmUHF6djdo?=
 =?utf-8?B?aFAxREZGTHp3NzhsMk9RSFl6cThrMXErMjdXK1J3MU5xRFhZK3NDcXJOMy9t?=
 =?utf-8?Q?hbjQj+wsZely3ra0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C5DB40048D383D45A87A189D3F46C84D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d88921f-6942-48a5-f70a-08de73481aff
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2026 01:57:46.0715
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RA4+AInBiy5KjXbohjhAvjPFCiNDBkpEfpF20WkaiML3PyVTTy4V1E33i6OoEJ+mmg1M9GvqNHF5KvxFewuw18EQPiuVqgjtwWMUAqRGwL4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8037
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71574-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rick.p.edgecombe@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.996];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 05A33180C65
X-Rspamd-Action: no action

K2JpbmJpbg0KDQpPbiBNb24sIDIwMjYtMDItMjMgYXQgMTM6NDMgLTA4MDAsIENoYW5neXVhbiBM
eXUgd3JvdGU6DQo+IFNldCB0aGUgS1ZNX0NQVUlEX0ZMQUdfU0lHTklGQ0FOVF9JTkRFWCBmbGFn
IGluIHRoZSBrdm1fY3B1aWRfZW50cnkyDQo+IHN0cnVjdHVyZXMgcmV0dXJuZWQgYnkgS1ZNX1RE
WF9DQVBBQklMSVRJRVMgaWYgdGhlIENQVUlEIGlzIGluZGV4ZWQuDQo+IFRoaXMgZW5zdXJlcyBj
b25zaXN0ZW5jeSB3aXRoIHRoZSBDUFVJRCBlbnRyaWVzIHJldHVybmVkIGJ5DQo+IEtWTV9HRVRf
U1VQUE9SVEVEX0NQVUlELg0KPiANCj4gQWRkaXRpb25hbGx5LCBhZGQgYSBXQVJOX09OX09OQ0Uo
KSB0byB2ZXJpZnkgdGhhdCB0aGUgVERYIG1vZHVsZSdzDQo+IHJlcG9ydGVkIGVudHJpZXMgYWxp
Z24gd2l0aCBLVk0ncyBleHBlY3RhdGlvbnMgcmVnYXJkaW5nIGluZGV4ZWQNCj4gQ1BVSUQgZnVu
Y3Rpb25zLg0KPiANCj4gU3VnZ2VzdGVkLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNA
Z29vZ2xlLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogQ2hhbmd5dWFuIEx5dSA8Y2hhbmd5dWFubEBn
b29nbGUuY29tPg0KPiAtLS0NCj4gwqBhcmNoL3g4Ni9rdm0vdm14L3RkeC5jIHwgOCArKysrKysr
LQ0KPiDCoDEgZmlsZSBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4g
DQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vdm14L3RkeC5jIGIvYXJjaC94ODYva3ZtL3Zt
eC90ZHguYw0KPiBpbmRleCAyZDdhNGQ1MmNjZmI0Li4wYzUyNGY5YTk0YTZjIDEwMDY0NA0KPiAt
LS0gYS9hcmNoL3g4Ni9rdm0vdm14L3RkeC5jDQo+ICsrKyBiL2FyY2gveDg2L2t2bS92bXgvdGR4
LmMNCj4gQEAgLTE3Miw5ICsxNzIsMTUgQEAgc3RhdGljIHZvaWQgdGRfaW5pdF9jcHVpZF9lbnRy
eTIoc3RydWN0DQo+IGt2bV9jcHVpZF9lbnRyeTIgKmVudHJ5LCB1bnNpZ25lZCBjaGFyIGkNCj4g
wqAJZW50cnktPmVjeCA9ICh1MzIpdGRfY29uZi0+Y3B1aWRfY29uZmlnX3ZhbHVlc1tpZHhdWzFd
Ow0KPiDCoAllbnRyeS0+ZWR4ID0gdGRfY29uZi0+Y3B1aWRfY29uZmlnX3ZhbHVlc1tpZHhdWzFd
ID4+IDMyOw0KPiDCoA0KPiAtCWlmIChlbnRyeS0+aW5kZXggPT0gS1ZNX1REWF9DUFVJRF9OT19T
VUJMRUFGKQ0KPiArCWlmIChlbnRyeS0+aW5kZXggPT0gS1ZNX1REWF9DUFVJRF9OT19TVUJMRUFG
KSB7DQo+IMKgCQllbnRyeS0+aW5kZXggPSAwOw0KPiArCQllbnRyeS0+ZmxhZ3MgJj0gfktWTV9D
UFVJRF9GTEFHX1NJR05JRkNBTlRfSU5ERVg7DQoNClRoZXJlIGFyZSB0d28gY2FsbGVycyBvZiB0
aGlzLiBPbmUgaXMgYWxyZWFkeSB6ZXJvZWQsIGFuZCB0aGUgb3RoZXIgaGFzDQpzdGFjayBnYXJi
YWdlIGluIGZsYWdzLiBCdXQgdGhhdCBzZWNvbmQgY2FsbGVyIGRvZXNuJ3QgbG9vayBhdCB0aGUN
CmZsYWdzIHNvIGl0IGlzIGhhcm1sZXNzLiBNYXliZSBpdCB3b3VsZCBiZSBzaW1wbGVyIGFuZCBj
bGVhcmVyIHRvIGp1c3QNCnplcm8gaW5pdCB0aGUgZW50cnkgc3RydWN0IGluIHRoYXQgY2FsbGVy
LiBUaGVuIHlvdSBkb24ndCBuZWVkIHRvIGNsZWFyDQppdCBoZXJlLiBPciBhbHRlcm5hdGl2ZWx5
IHNldCBmbGFncyB0byB6ZXJvIGFib3ZlLCBhbmQgdGhlbiBhZGQNCktWTV9DUFVJRF9GTEFHX1NJ
R05JRkNBTlRfSU5ERVggaWYgbmVlZGVkLiBSYXRoZXIgdGhhbiBtYW5pcHVsYXRpbmcgYQ0Kc2lu
Z2xlIGJpdCBpbiBhIGZpZWxkIG9mIGdhcmJhZ2UsIHdoaWNoIHNlZW1zIHdlaXJkLg0KDQo+ICsJ
fSBlbHNlIHsNCj4gKwkJZW50cnktPmZsYWdzIHw9IEtWTV9DUFVJRF9GTEFHX1NJR05JRkNBTlRf
SU5ERVg7DQo+ICsJfQ0KPiDCoA0KPiArCVdBUk5fT05fT05DRShjcHVpZF9mdW5jdGlvbl9pc19p
bmRleGVkKGVudHJ5LT5mdW5jdGlvbikgIT0NCj4gKwkJwqDCoMKgwqAgISEoZW50cnktPmZsYWdz
ICYNCj4gS1ZNX0NQVUlEX0ZMQUdfU0lHTklGQ0FOVF9JTkRFWCkpOw0KDQpJdCB3YXJucyBvbiBs
ZWFmIDB4MjMgZm9yIG1lLsKgSXMgaXQgaW50ZW50aW9uYWw/DQoNClRoaXMgd2FybmluZyBraW5k
IG9mIGJlZ3MgdGhlIHF1ZXN0aW9uIG9mIGhvdyBob3cgbXVjaCBjb25zaXN0ZW5jeQ0KdGhlcmUg
c2hvdWxkIGJlIGJldHdlZW4gS1ZNX1REWF9DQVBBQklMSVRJRVMgYW5kDQpLVk1fR0VUX1NVUFBP
UlRFRF9DUFVJRC4gVGhlcmUgd2FzIHF1aXRlIGEgYml0IG9mIGRlYmF0ZSBvbiB0aGlzIGFuZCBp
bg0KdGhlIGVuZCB3ZSBtb3ZlZCBmb3J3YXJkIHdpdGggYSBzb2x1dGlvbiB0aGF0IGRpZCB0aGUg
YmFyZSBtaW5pbXVtDQpjb25zaXN0ZW5jeSBjaGVja2luZy4NCg0KV2UgYWN0dWFsbHkgaGF2ZSBi
ZWVuIGxvb2tpbmcgYXQgc29tZSBwb3RlbnRpYWwgVERYIG1vZHVsZSBjaGFuZ2VzIHRvDQpmaXgg
dGhlIGRlZmljaWVuY2llcyBmcm9tIG5vdCBlbmZvcmNpbmcgdGhlIGNvbnNpc3RlbmN5LiBCdXQg
ZGlkbid0DQpjb25zaWRlciB0aGlzIHBhdHRlcm4uIENhbiB5b3UgZXhwbGFpbiBtb3JlIGFib3V0
IHRoZSBmYWlsdXJlIG1vZGU/ICANCg0KPiDCoAkvKg0KPiDCoAkgKiBUaGUgVERYIG1vZHVsZSBk
b2Vzbid0IGFsbG93IGNvbmZpZ3VyaW5nIHRoZSBndWVzdCBwaHlzDQo+IGFkZHIgYml0cw0KPiDC
oAkgKiAoRUFYWzIzOjE2XSkuwqAgSG93ZXZlciwgS1ZNIHVzZXMgaXQgYXMgYW4gaW50ZXJmYWNl
IHRvDQo+IHRoZSB1c2Vyc3BhY2UNCj4gLS0NCg0K

