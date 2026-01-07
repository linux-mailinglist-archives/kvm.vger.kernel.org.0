Return-Path: <kvm+bounces-67287-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E4271D002D7
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 22:34:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 57368302016B
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 21:34:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69209335BCC;
	Wed,  7 Jan 2026 21:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HXjrSwpo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C252868A7;
	Wed,  7 Jan 2026 21:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767821670; cv=fail; b=SBhI7XhM8qr4ZmqdJVl+YLTnGqwAThOBhG7Z8aWuFe25XdqZyUbgaS+lmtSzWa2ywsabNqq2+UGFHkaP+jOVzFfLoIBgBi3UKf4sKzHpmBi38CZbUwdpVF2ajx1bILbnVC1JfRo/DaCTxdqDC/YuMwQz8szjAmSoBDgQKop0RiI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767821670; c=relaxed/simple;
	bh=G3tkhQXf1rR1dAuqYFy64Kx9mTQU26vnExvVz51Dr7E=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=rnPUXT3XNmiyI4dmaeiA4eJDG4woOUAfqF8guH4JwaEWEZQFuLCAw6805zF8BSRThSwYTtXUvYqPFZ8Bcq/vCQ4uuJ4Jignf9mQ9yMIVKiGMPpQCpJYjtwbkLN45WQINPttE/RlepxsjQfAixQqmxYE7j3+uOxscSbbDY2Unkis=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HXjrSwpo; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767821669; x=1799357669;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=G3tkhQXf1rR1dAuqYFy64Kx9mTQU26vnExvVz51Dr7E=;
  b=HXjrSwpoQkFxW2wlLgTp44hvw/79gioY1FfImaRZZd2TKdbrwiQvIJo5
   lrCHXd+h9Yvp0/Lef73FDfUnYa87tNoMos58kzAXAS2a9CeN1UGWwbGrf
   FfGT0A6EmegfjQoxPzgh3lL89CBUPXJavXhQtgtzLViIMYa8ZBm2PlNlM
   y+ELHTqw43EGL+I0032UIizvO+TCGwnUkzhAWXGJuQQRqG508fQIvb1Hs
   IwuOrHZm6GnTOWFMbZXtg+IoH+qns2ujc9FBc6Kwax42LELvHwq1RIWDr
   MIDnD2ow8XTMrgZ6wpj1rSqsA7tMYKJMGoslmC3elcWKnXsdOUHkevup6
   w==;
X-CSE-ConnectionGUID: XuxIMwVLQHuahLanwOyC0Q==
X-CSE-MsgGUID: lLgovXhhRyq2igatQ7olGQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11664"; a="69179651"
X-IronPort-AV: E=Sophos;i="6.21,209,1763452800"; 
   d="scan'208";a="69179651"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 13:34:29 -0800
X-CSE-ConnectionGUID: Dn9c6nHiRdy/9J6h+8fyZw==
X-CSE-MsgGUID: aVv1rQ93RgC8YMtwaQXIog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,209,1763452800"; 
   d="scan'208";a="208092310"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 13:34:29 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 7 Jan 2026 13:34:28 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 7 Jan 2026 13:34:28 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.13) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 7 Jan 2026 13:34:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xM4cwem4DEqKafMiW/jTw8BFLQKlDC1Xi22swtd+c1Bsv7DA8E3ZFD/gZ6Sf97bFblmK9Dhktp283nrcW2LYEap0y6ot3AVG4VU2jfEvV4PTOdFHERR9nHg9FJbpXCk7WDH0TuxDs4CdZHOsDPwqPEgA/xLf0CczXz5lbk199RlG/Ct8fkIQHsZGOs+neMHyp3jJXYnQUlgL43johmHPW36aJt94O3Kl/rzKW4Ng6oDFzSpX9UUVJQaJ0hTnle5Cx41rTVvr9QOylGC6cv0Byb4dKhyGMDoDgiRZrsBSncsGMZSqKZcyIuiF3AjtS+9uST1J/jxnLY2lbuWXZKSo3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KLNKGfgGWkgNh3VPQuhzWOfC9RUHQew2kKCaHRxcft0=;
 b=WFsitQMWglcRu2qjOtSeyS8CDxTuMyWt8ki1nHgbxX7WbA4DPZcLOjDMaTnPRA6J21KhWfcp77upV6buCFLo88+UrBIl3naoorQdFTTWI7Rb6GJjgdMtP2CH8Sc9vVb6LC1PvGgtwt/JHBtq7LkpPkiGOMbgokLmCB6NOJEJxUOXPeMDyrozT8wavcWVAF2BBoJ0rbZooUQaTipkjoPvYJjF8yA1hE0ORmT+kJ7dJv5T80FI3IKmyImMkxygx8tIqxH/4r0Zli1kCTWve4x3V87zbpFh98sotlnERPN0+j1FX/xoHjEeLGEFw2gbRapQXQc0GATdc4rv7sTmpO+DwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DS7PR11MB7806.namprd11.prod.outlook.com (2603:10b6:8:db::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Wed, 7 Jan
 2026 21:34:25 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%4]) with mapi id 15.20.9499.002; Wed, 7 Jan 2026
 21:34:25 +0000
From: <dan.j.williams@intel.com>
Date: Wed, 7 Jan 2026 13:34:24 -0800
To: Dave Hansen <dave.hansen@intel.com>, Kiryl Shutsemau <kas@kernel.org>
CC: Chao Gao <chao.gao@intel.com>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<x86@kernel.org>, <vishal.l.verma@intel.com>, <kai.huang@intel.com>,
	<dan.j.williams@intel.com>, <yilun.xu@linux.intel.com>,
	<vannapurve@google.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar
	<mingo@redhat.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, "Thomas
 Gleixner" <tglx@linutronix.de>
Message-ID: <695ed1604db38_4b7a10028@dwillia2-mobl4.notmuch>
In-Reply-To: <7cbac499-6145-4b83-873c-c2d283f9cb79@intel.com>
References: <20260105074350.98564-1-chao.gao@intel.com>
 <dfb66mcbxqw2a6qjyg74jqp7aucmnkztl224rj3u6znrcr7ukw@yy65kqagdsoh>
 <d45cc504-509c-48a7-88e2-374e00068e79@intel.com>
 <zhsopfh4qddsg2q5xj26koahf2xzyg2qvn7oo4sqyd3z4mhnly@u7bwmrzxqbhx>
 <7cbac499-6145-4b83-873c-c2d283f9cb79@intel.com>
Subject: Re: [PATCH v2 0/3] Expose TDX Module version
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0275.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::10) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DS7PR11MB7806:EE_
X-MS-Office365-Filtering-Correlation-Id: dde4329d-1327-4eb3-fd08-08de4e3487b0
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YitLdUVoVjZlRDFGUEJST05tSXhEQUpKUXpOMHZtSzE0S1hQaDBHckM1NGZy?=
 =?utf-8?B?eVM0SGFBQksrVlMzUVVQTk9ZWmVieHpYKzVmOHY3b2ZzVHZXVHE1TWczWXdH?=
 =?utf-8?B?bkhzeXRybTVvL2R2OFFqbW1qNmxOWnlvLzM1SjVZTHMxTFNSdndCZFc0V0NG?=
 =?utf-8?B?em1HdzJjUnM2ZDhwT3hNb2UzKzYwdWxpOVdnSTBaQnBTSmQ2QlBpQlBqQjdl?=
 =?utf-8?B?V2YrUTVhQkIvVUE1WUxUQ0NOaklmd2FQMXh5TGhKVE0zVW1KcFJDQjZWak9L?=
 =?utf-8?B?eVdMME5idTFVNlFITlVvMStVSVlQL0hrN1F2aTM2ZUtNQWlVN2ZYQjlDSzFH?=
 =?utf-8?B?OVh5cVJCS0RJNDZsTlNHbEVYR2wwd2RmYmxTODdhL1ViUU5QY09CR3BMZU1R?=
 =?utf-8?B?ODBMV2dmQ3M5ckVuSWRnWnJpUGV3SllONmd6VGp6eEROa2p4ODluQW8yZlpI?=
 =?utf-8?B?Wkl0RllIZ1o4MWVoVjRQOVdtTVgrM05tTHNPbWcwVzliaEUzOXduZzJQSkhQ?=
 =?utf-8?B?cWhjcTB5cGlGZEdpdWo1SThVYUUwUVBmSWVOa0htSTB3ZW1KQm45alZCcFBL?=
 =?utf-8?B?V1hrU0JMTTgxNys0VWkwZ1lGQUpSKzViTHB3ZVdnbUJzTUl1a1NKcU14NG1S?=
 =?utf-8?B?OFRFT0kvYlNuOFpmOVRUakI1QzIrbmJQYVN4MVJXVnc4VFA1dXYzdWNDb05Z?=
 =?utf-8?B?UXl2ZEwyTUpKeU5mT0RPaC9GZENsakNuNWdSM1dwU0d0MjF3cjN5MUtzSlBU?=
 =?utf-8?B?V28xZlZkQmZ3cjFJZW5qcVVmSjVLM1pmQ1ZhZEJSR2NrRDlxRE9PYUFDT2pT?=
 =?utf-8?B?MWxmTzJEVThYenE0aWVaalo4OHVIV0VYLzFPYU9HeExHNVRianNZRWZTNTBQ?=
 =?utf-8?B?Q2QveVJkVkZscDBXbkpjakZQdE02YVI1V0hiRldMZWxtamg4Z3NHamhnZXJH?=
 =?utf-8?B?dU8xMDAxTVg1cHQrNnZ2cXY5Q2EyZW4vZ2l0M0ZBTEMvNzVJWXB6WS9BcnA5?=
 =?utf-8?B?cFc1Z2Z4Yk5TQ1FUeHZNcVhscE9IS2xEcFBTVCt1UE9aZm5NcFBtdk4rZnJI?=
 =?utf-8?B?OTBHbUFteW5oT1g4MkZONEl5VXpRdzJBbE5zc0I0NzRrbm1lMHBkTzJkVEJw?=
 =?utf-8?B?WWFrdEhVTUd0S3VkVzZqYW03bGgwcEk2ajdaMzNDWkhzU2hqeW16SGhydjM1?=
 =?utf-8?B?VVlBcy94Q3E1ZEJXNTRVSHgzL1VoeWFhZDRTeDhWbGVCaGtMUFNPUExBajR6?=
 =?utf-8?B?a0I0QVZ3dmVjSklHU1Bic0ZPRURZdWJKQ2I3eW1zcHNMTWRJUkZWejhzeGlx?=
 =?utf-8?B?QWpCM1RRdkp5Q251SEErZ2hCdlg3MzFvQzIyZnMreXZINmRmYjVMenkyUEdG?=
 =?utf-8?B?bCs0MHZnMVIwTm9wZHI1S2ZXY1paYzNHMzJ3ZzJtRFBKaENOSHFxK2dwNUNj?=
 =?utf-8?B?Wm1wc3phdWI1YU9LdzFNd0w0MkJZbHVraGpZM2JRdTlPYlRLdzdGS29qU0NP?=
 =?utf-8?B?aExBRDByS0Y2SWFTdzlheHArL05kOE93dk1hdjNWSUtwbU9ZaVdobWxvYm5I?=
 =?utf-8?B?OWRDeVJFRUtNRk5uUmk0QTdZWCtkRXkxb2lqenNqOVlWU216YWxLZjI2aHBo?=
 =?utf-8?B?dVN1d3lpYVF2SVRORXRQVC9PbW9EWlpsaVhHQXEvY1hLQkFEV2hqUDI5eWpp?=
 =?utf-8?B?S1F6QVM3amErVkx6aWdzZW1NeXRPcWEra28wR092SkNpTFl3U2huTmpGS0lz?=
 =?utf-8?B?VE5jamd0eEFzUU9Cenc1dmFRZkJTeFBoSzNOblEyUDZZWnJLMVkxNURBZGlV?=
 =?utf-8?B?bTRZdERGazlYdndSTFZXcVdJSnBGYkIrcituNElwK2hvMzFrS3NiRHJ2ZlVI?=
 =?utf-8?B?NlpwUEFYVjNrUmtqMXVLTXcyQ2RUa29FOWtqcHNlczdKMXhGaUhOSXNTMXpa?=
 =?utf-8?B?ajhwVFg5SGZhOVZsb1Y4MEZvdEZMeGRYWGFZYXFPL2J4UUZQdmU3anBNYlBu?=
 =?utf-8?B?Yzc3T3VQMW93PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z1Zxa1dxMU5SOTk3cmxJUXRFMVVHS2pGYVUvMTRoRWNBcUhTanFCMUZLMmJ0?=
 =?utf-8?B?NG9zbEdhTndVamNRMXBsNThXTHRSaDdDZ0lKbko2NEtub005NTBGRzQ3YnV5?=
 =?utf-8?B?NGZsT3VlUURFL2M2bnYzMjlybloyZllKdENJQmpCV3A2YTQzZXBTOWk1V0tB?=
 =?utf-8?B?a0JRT0V0aHl4cGdKQ0theW44SVhKSXd1RGJjT0hMSWI4RU9udlJ0SDFvbHJ3?=
 =?utf-8?B?V2UwYk1CbnNMcVBIblB4Z1J0a3VKdkc2eGRoUWI0aHN3T1JVOTVySENlclpz?=
 =?utf-8?B?QTdCTS91RWZKaE4xWEdCRXpJcTZPN3NGcGR0S2Q2bExDazFsak8zOUZQRHRq?=
 =?utf-8?B?UVJoclVWczBiN1U4WlgzWHpvRjJYcTR1R1RhNFY3NjhHWU9yYkxiWmpJbVVV?=
 =?utf-8?B?VXpZQk9Tems1UUw5ZERRallRWW00dXY1QUFrQUVsanFibzdTdzRzREVsOWho?=
 =?utf-8?B?dXZTOWJvQWZkcUhvR3JTRUo2UEhuczY1TWZKdGFvNkpLYUFrVnpYUklNZExh?=
 =?utf-8?B?Ymc5SjZxWXdhSEFweUFSNERCYVRGMlVJVXNHMGEycldaT0xiNHNvS0RqOXRt?=
 =?utf-8?B?MnB2a2FJZ1Zucjg1TjFhaVBiUWtlS3hxMkZaY3VTYjhxL2labDg5RDBud0pH?=
 =?utf-8?B?MnFLZVNBbGZ0YkJldk5EY3cxV284TlZ5WkwvcTZ4Nk1ndGh1RTdtc0Jtbm5Y?=
 =?utf-8?B?QnRZR2cxUElUa3lvUzBLTXd4VTBKNXFGZlNLajBGUEwzRXhaR2RSMHBxRlNL?=
 =?utf-8?B?MEJEM3RHUCtlZ3dFVFBNZjFSK3lzU2ZETnVCSzgzdVdsTm8xNllLQzJYN1M4?=
 =?utf-8?B?WDQzbkYyUHJoL0RXY3B6cHpFM2xyOTAxQm1kWU9QU3MvMUZLMHZxT2tlQzRv?=
 =?utf-8?B?eHNmek9iV0swbWRGRkluWWVtZng2TUczZitsZDA0bllub0xidlRxY1hHSU5y?=
 =?utf-8?B?VDR1cXNtc3ZNVEdyWWQvajkwOWtrVmVzU25hNkVTMUNCOGp3WitvSjE5dDlX?=
 =?utf-8?B?MmtYejN2Mk9Yb1l2Vmc3MVlLTWNSL2F1K2JVYkhLSkpreUZVK3pzTWtOemJU?=
 =?utf-8?B?TU54cGJ4eHRjMklZZDV3cUtxM1Vxa0tOUW8vS2plSTQwajh1bElwMUZhRWpQ?=
 =?utf-8?B?RTNXV3lpTUFmazJzZEFxOGFzL0J4VTJlUVIrSmJiS01QVzFlU2dUSHhRYjhX?=
 =?utf-8?B?N1NiVXVacXU3c1cvR0VxSTdYNWJGdXNKZUNLR3lUb3lkVm40aW5UcG9zcUFt?=
 =?utf-8?B?Z29rdzdIWkhYdGkzNHFxeGpTNWZ1MzJjajZTTHBpMWNjanpCQ21HenFsWk9O?=
 =?utf-8?B?QWw0aFJMNTlaeUFUREVXM0hhT24rdytkeUtXZFdYUHJOT05hSGV4d0w1NWpE?=
 =?utf-8?B?NXZ1MjZpWWtjK0JwYlBaeEFhZ1dlUFpVeGYwKzJMaWNOUndTbnFJb0VRdnZP?=
 =?utf-8?B?ZXNxaXVGMFBPc1pVSDhXZ0o2M010NHAwYUdjOEU1OGFTVS9adHdNcHc4eHBk?=
 =?utf-8?B?WHo0cUhBNWhEMyt3UmlWVDAxMVoya3VXLzJUc3NQTC9zN1gxeHZVdnB1STlR?=
 =?utf-8?B?NlU3b1Q0c2dPbHJmVGlqYlF6dzhUc0Q2bHJsVkt2YXQ5bDVVT0FzL2tpbERS?=
 =?utf-8?B?VXpCT0Q3LzNpTEdwN3B0ZmpmTk9CTEpzV2xkYTBmWGJVbU9qaW5GelpmcFJW?=
 =?utf-8?B?YVJSMSt6ZEwvNHUxQnVReW1pU0c1SE80UVROQUs2SlhxYU8rdUs3VFduUlRR?=
 =?utf-8?B?b1VLdWZDblJRaHk1bjlScytBSzB4dEd1NEdqRzMveVdWMWNOVFpjQnRJZ0xk?=
 =?utf-8?B?QUNhQlFlc0hNZEZwbVovTGw5WFBmeEp4Zy9GZHZnMDlmMFBwS2JieldPaS92?=
 =?utf-8?B?Mnkrek9KQzdUY0o2SXUwck5WRXB5Z2RvdFc1K3lVQ3BybEV4L1pCYW5UVEhI?=
 =?utf-8?B?cGtiWFk5NEVJV2ZobktjZTJzLzhPS1pBZFJDdVZHZVd1eGdPNXE2KzNqZmNR?=
 =?utf-8?B?SGhydE1MdjJLTTdmN0JiY3pXc05zV1dOS0tySTZ5UG9lUWNkNFlZSkcwUkYy?=
 =?utf-8?B?WXZZMkgyU2Z3M1FYN3lOK3QvVEJtR3BOYlUrNTlWTDZQNTc1Ni9RYzdqQm5N?=
 =?utf-8?B?MHJ1dHZ2NlpDZEZzNXgxZE9VWEU3elg5YU5YdDVvcEl0VGlHQzZ4cmJrREEr?=
 =?utf-8?B?V3hBZ2tWVm51aHVka3FlTXc2V2NzR3dkeDhyL1Byd2FmbU8rMzF1Y0h0QW5q?=
 =?utf-8?B?c0FSN2J1QTVwRGx0OHRhUmNCQ1JpL1BPMXpyclU3aVcwM1pIVzQxVUN3Vk1x?=
 =?utf-8?B?WFBCVDVHV3lDR1R4RjZqQ09sVlErTGpJS2txVlFWRTk4QmxEc3FDUWl3UFFz?=
 =?utf-8?Q?dlI2cNV5Ys4IBy58=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dde4329d-1327-4eb3-fd08-08de4e3487b0
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 21:34:25.6702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UsD3HsXEfGiRdvqJ4m3/OCshHEtBgqOgDQ1qzYEtLkTUifnUyoWO2XhbHG8/O5nlXBqqpfZYv+AnyFx0GJqhzS3ve0umSVHGlCdQEcH8pAI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7806
X-OriginatorOrg: intel.com

Dave Hansen wrote:
[..]
> Since there's a dearth of discussion of this topic in the changelog or
> cover letter, my working assumption is that Chao did not consider any of
> this before posting.

Unfortunately that is incorrect, harsh, but somewhat forgivable because
features like TDX module update and the PCI device security stuff
stretch the boundaries of what tip.git historically needed to worry
about.

For example, the equivalent on the SNP side goes through
drivers/crypto/ccp/ which sometimes Boris takes changes through tip.git,
but many other commits, for features like "update device firmware" and
"PCI device security", go through crypto.git and now tsm.git. Case in
point, nobody in tip.git land had cause to even glance at commits like:

    2e424c33d8e7 crypto: ccp - Add support for displaying PSP firmware versions

I do not know where your specific objection lies so I am going to start
from the beginning summarizing all the discussions had around this to
date, some off list, some on list [1]. Chao has been involved in those
from the beginning and threw a fair share of consideration logs into the
fire.

The main problem for TDX with respect to the considered features of:

- sysfs to display some module metadata
- sysfs to mediate module update
- device + driver to coordinate PCI device security 

Is that TDX does not come with a device enumeration. It has no ACPI
description, it only has CPUID. Note, that at least puts TDX in a more
comfortable position than ARM which is also struggling with the "where
do we hang a useful device abstraction for this software pseudo
hypervisor thingy that controls confidential computing".

For sake of argument, I assume you have no fundamental objection to
module version information in sysfs in general? I.e. is the question
more on the where and how for TDX sysfs?

Note that back in March of last year there was this nak from me on the
proposal for something like a custom crafted /sys/hypervisor hierarchy
[2]. I still hold the same position today that all these archs are to
have widely different ways to enumerate their capabilities.  Anything
implementation specific should hang off an implementation specific
device. Everything else that is cross-arch should create a shared class
device. We now have that "shared class device" upstream via
tsm_register() [3].

For TDX the question is what is the best path to create a device
abstraction for a technology that does not come with a PCI device nor a
firmware enumerated platform device. The faux device infrastructure was
purpose built for cases like this. Now, faux device arrived in February
after I had sent out my original "tdx_subsys" proposal in January [1].
While I found the /sys/devices/faux path prefix somewhat unsavory
compared to /sys/devices/virtual, the implementation does exactly what
is needed and avoids the abuses of /sys/devices/platform that would
usually result from cases like this.

It turns out ARM is strongly recommended to go the faux device route as
well [4], so if you have other ideas here you have some work ahead to
undo some standing consensus.

As for which patch set should introduce this new device, I am in favor
of following Chao's lead here. Land the least controversial of all
possible TDX module metadata to publish in sysfs, a version string.
This simple infrastructure unblocks the path for the module update and
PCI device security features. Those add more attributes, a fw_upload
instance, and an idiomatic driver model for the tail of TDX features
that are more suitable for driver enabling than core-x86 enabling.

Yes, you were not directly copied on any of the references I have below,
yes you are free to have an opinion on proposals you are not copied.
However, going forward I would like to negotiate some working model
similar to the tip.git relationship to drivers/crypto/ccp/, and work on
how to avoid surprises like this in the future.

[1]: Earliest on list concept of needing device infrastructure for TDX
features: http://lore.kernel.org/170660662589.224441.11503798303914595072.stgit@dwillia2-xfh.jf.intel.com
[2]: http://lore.kernel.org/67d4bee77313a_12e31294c7@dwillia2-xfh.jf.intel.com.notmuch
[3]: http://lore.kernel.org/20251031212902.2256310-2-dan.j.williams@intel.com
[4]: http://lore.kernel.org/2025073035-bulginess-rematch-b92e@gregkh

