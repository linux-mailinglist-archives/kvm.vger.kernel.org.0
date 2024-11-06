Return-Path: <kvm+bounces-30915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C2C99BE4D4
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 11:52:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 97C16B2198B
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 10:52:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 728141DE4C7;
	Wed,  6 Nov 2024 10:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fDqPnMHx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B931DE3B2;
	Wed,  6 Nov 2024 10:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730890174; cv=fail; b=Sumj8U9yzEu9AFAD1xF+r+bCNrMCaDEOV8pU9vLiA38VsHh0dgydYa50fd7cnqeFpt5szSwxIr0pStW330zzrrOl3dgo56Fpujl0wbSe62CHAnHVrSb4iQ6+vhHWvePynrm20ZztcjC355TNQnPoVuUn1oVvD5RxXaJ8x7zqBa8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730890174; c=relaxed/simple;
	bh=DiqIoBWbEBoPwVVnriFGxbc2BlQ+jXsP+BZcxV0GN4s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Y9oaxSgfSGjTho/smt37EcA8K3hoa0OBa7r4YkMfoymkLkqeOpd2qhNTC+VRlSjGft07nZsvIknnfItHVTQVQPtQeF4PWC1BAR0e64gsrsTzNrYBclIBQbQKxknRhQe8cZWlMrBvhWd+Sz24R3qp479nVGKU1klQkwBbIoOA9OQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fDqPnMHx; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730890173; x=1762426173;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=DiqIoBWbEBoPwVVnriFGxbc2BlQ+jXsP+BZcxV0GN4s=;
  b=fDqPnMHxg/TE3oesj9ZvecC1R5P3V2WXQw7mEDejp6RxnBD42pT3Xob2
   XGWtKeyVmUXHZIa2UjWxQXSiTi5AKcZ+GnZYCKjz9zTj/iNIj+WmWCpMs
   6IRGfgRTKEpe2+S31AK2GZcfIwoXogQRYo9p24OHaM/Mr/IzOgoYecako
   X3zM4qMjlJIASCBOpJ542bwZnacLsjKgnXIOSGXCnEzsfvlDPZFrTyQzn
   FGqC9s+/BGtjtRnG7vM8kPpbBh2zEooWVmedde4Wn5q+zIgBbiD6Rm6je
   cVtwB/gPiWKGPEQWQ3dIztpbHBUvYzJDfR63+yHr/75qz78f6oezQQhyW
   w==;
X-CSE-ConnectionGUID: cJbkYfXgQByuG2vp9Kkefg==
X-CSE-MsgGUID: sY/IO+58Q2SimXRMI4Izlg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="53244213"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="53244213"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 02:49:32 -0800
X-CSE-ConnectionGUID: ZA50cw4tQxmDlJ/AS/mhTA==
X-CSE-MsgGUID: tOwYXYOxSG2lI6/XQLzyEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="89295465"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Nov 2024 02:49:32 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 6 Nov 2024 02:49:31 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 6 Nov 2024 02:49:31 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 6 Nov 2024 02:49:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b3Bt8SrGtwKxa5SV2n4k4VFt6T7LoV0GHuKRvv34SyHxdKA7PcTpB1JSC6HuVeKnkgS11V8CYWaSHIMegN0s6XBAyIa+pm4gE25YJHyrRTaj0dy1EScVETB6qxtUkNAbPghhCHRjPA4dBihwUsibNIEKB3Gk0kdXqXDiUy4WVnMrLOxp6dYWfgaTMvd96KqNzoPnFo8QtB9oetgyGolAnHcTtYixiX8cAigwnpOxWaFf9tvHeBNtfoeiDUna7KCkmjA20+btvfHN5lBED1Y7hWuf2EYBdGkPE7OpUfvAFaVBKzfLdsRTpi2N+1GVicrWzk6FHY5nn5AcOCw6Qwi3CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DiqIoBWbEBoPwVVnriFGxbc2BlQ+jXsP+BZcxV0GN4s=;
 b=VROuj3kTj2KrEExx+ULgcREihMZ8OOToUthjeftRq4e0BujsYplurudol+EINMk/TXvWNEPHpjI8ed41v6jkXYw9cVGNwfLGFSRApZDGSR1aju+/kWOFvRkR3PQcljPLDWXXleELLByvU9efy0BxClceKXHs91YGGSkjlGelYaukX2aqgf+e8MIfufcjxSV7MeWYLqwWfdyNTSyLkuj0Me5mgInSKbOKhk5dMNCmts2Qssdiq87qbR/MnT7sZ9A2Jd+Yy4Fg3Ta5b/Fbdyw+CFZQHs3ZLM9LNK2GjCTMOEWptLPF1cHlNMznbKosR4oTFq4rZPk3EZ6ny3YlMA9bWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13)
 by MW5PR11MB5809.namprd11.prod.outlook.com (2603:10b6:303:197::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Wed, 6 Nov
 2024 10:49:23 +0000
Received: from PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::a5b0:59af:6300:72ad]) by PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::a5b0:59af:6300:72ad%4]) with mapi id 15.20.8114.028; Wed, 6 Nov 2024
 10:49:22 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "Lindgren, Tony" <tony.lindgren@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kristen@linux.intel.com"
	<kristen@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 3/3] KVM: VMX: Initialize TDX during KVM module load
Thread-Topic: [PATCH 3/3] KVM: VMX: Initialize TDX during KVM module load
Thread-Index: AQHbKTw/9pTudzVvXkeM2HJfNrr8zbKfa8kAgAFOlYCAAJhngIAIzdEA
Date: Wed, 6 Nov 2024 10:49:22 +0000
Message-ID: <37f497d9e6e624b56632021f122b81dd05f5d845.camel@intel.com>
References: <cover.1730120881.git.kai.huang@intel.com>
	 <f7394b88a22e52774f23854950d45c1bfeafe42c.1730120881.git.kai.huang@intel.com>
	 <ZyJOiPQnBz31qLZ7@google.com>
	 <46ea74bcd8eebe241a143e9280c65ca33cb8dcce.camel@intel.com>
	 <ZyPnC3K9hjjKAWCM@google.com>
In-Reply-To: <ZyPnC3K9hjjKAWCM@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB5983:EE_|MW5PR11MB5809:EE_
x-ms-office365-filtering-correlation-id: b4f4224a-3ee8-4b65-8074-08dcfe50acb0
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?SzFvbG0zWFVnUENRLzZhNS8yNVcxZm5Hc0hqVUI3UEFtUmMxcjhLK3FmVTNr?=
 =?utf-8?B?b0lvR0RYZXpFVjRQcEtDVTZhTWxUWS8rL1B6QlFEMVMzbkM4N0tvOEZsN2Iy?=
 =?utf-8?B?U0d4R1NnMFVmSWx1dm1lVmF1TG5mVnFjTUI0ajF6MEdJSCs5ZnNJelg5REha?=
 =?utf-8?B?bEtPaThxaUVpM0RERjhkOE1oWlVIdGhrcm1GWEtpN1JYY2Ewa01OT2xNTGlC?=
 =?utf-8?B?Qk01blY2SXZ1M2FmbklxYzFFdElNemdIY01za3JWTWprcFc4OUJCVncrc1Rk?=
 =?utf-8?B?ZjRuQnp5cTg4S3Boa3pkSDRGSDV4VXhyVXYxYUtoTUEzcDkxVThQZHFmMmVl?=
 =?utf-8?B?bEQ4UTkvUkZoUEtjeURsT2VkdzZmYkpGVlZxMER5Q1FuQ0djMnNxeWluQTFa?=
 =?utf-8?B?WWZlZGtaRmhXNndMalFuM0o4dTh6ejBHM2lSWGcwVXQzZlhVSTl0dHdxV3JL?=
 =?utf-8?B?VWxJdEs3NFpVSkMrUzFBUWRjZ09BS3VHbFRHWDFIY3JueG1FNGZaVkdRN2o1?=
 =?utf-8?B?bmlTTjlteDJCL25kc2tVT3BSckQrYkY5ZnJIOGRaY2h5UllBdkFnemdMWXVy?=
 =?utf-8?B?bFViK3VmdHRNclBqSEpENXh3RW4zQzZENnJHelZUbnRKUXFnTWtXMHg1WTh3?=
 =?utf-8?B?bnRpUlRNZlY3OFpsaDhwVE0rWDhtSCtqUzVOOGlTYmN0VXVqRVNqWXB1MWFq?=
 =?utf-8?B?WVE3UlFVWDlnbEpnNUwwcDlKM1FUcmxjeStzOStaSnp6U0JNUXREclBpZWxF?=
 =?utf-8?B?UVJpTTRzWUI3YVhUQy9PYmh2WkJVU2hYSjZZWVVEbEI4c284ZllEZStHbjVk?=
 =?utf-8?B?OTFkVVJDNkI4cy92MXE0MUszRjFHUlFMOEUwRmdzblJaMS9KMExxTGRjekxo?=
 =?utf-8?B?TFRiRy9SbjY4REFEUXA3M3dFT0pCUUpkeTBOKytyK2REWkEwYTg5L2JudXNq?=
 =?utf-8?B?alY0bEpiYnM4QU9EWHRkbTN6aW1nOE00amg4RUlQRThPNFZkaHFXTWk0YmtK?=
 =?utf-8?B?RzUwYXlQc3pNa2RVL1QybFpKNlEzY0R2REp4QVphd3JKa042Q3cvUnZsNUMy?=
 =?utf-8?B?UUcxdFU5RG4wTGwrR28zTTIyeU1LY0hDaTRTY0FwL25uWFJyOUtoQW5SSFl6?=
 =?utf-8?B?dlVGOGlzWEZOUE5MNlgvbjhzUGlJb05lV0xMMG50dDJYelgvRVJ6K1FabEhE?=
 =?utf-8?B?RTR3T0w0SHJ0SEJhc1NxNnVIeDd2WlJVYkNtUnQyNGwyd1VjRlNrck85QTFy?=
 =?utf-8?B?bnJKR3lyQlFCQk52aUFUS0daaWJkNmFHM24wUU5EMkN6bFRreVR0Zm50K284?=
 =?utf-8?B?R04xNTljSlV0N3dVaWZTb1RTQ2FETUJoVzVjeWIxWUI1SURlbWVPc0UxdnYr?=
 =?utf-8?B?cThib3dab3Fubnd6SmRQL1E3RDRtUmJOR0ViR2xJSE8wNStXTE5UYXJYNkpT?=
 =?utf-8?B?QWJUdU1LM2NoUXo3ZnVqMHhzMGxxUVdUcHBsdDN5UXl6OE11VXk1akhUVlVn?=
 =?utf-8?B?RmRDUTZuUnFpZjUzWHgzZHRGUWxXNXNEY2F6Mis3S1QwRWREZW0rNjhzaXBu?=
 =?utf-8?B?Q1ZiNnJNeEcwWDVWczhPcVhVZG9MRXRNQ2dQYnZFM1VnWWdCOTA4OXZqRTIv?=
 =?utf-8?B?RTNIZFJobThQSmJ2aGR2LzVjM1VtNVpKQ2RTL0QvQ3N1QnhDajMyc3g0c1JR?=
 =?utf-8?B?NngvUEVOc1RXNzB1b29wWDhDbzlZekRoSHJjdjAvK09WbHc3YzRJZkdmMldY?=
 =?utf-8?Q?2BVx1PXNCcJVPBFfYxNPPDQxKR4ufgdWlhUtWdb?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5983.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a3Q2OE5WODFSQzRHQ0wvNXVjYUdwWnBWVS9wTWdxbVMyaWNqYlhTb3ZmelRJ?=
 =?utf-8?B?TFlTSnhDcitZR3lnR1FyYVZkY0Z2d3paRG94bll0VTBmRGtTRU9lSVgzY0F6?=
 =?utf-8?B?em9vVmNzem81MVBMcVd1SjMrZWc5Nkl4SGpHMFRUZ2Y1aittZnprOFZuMExZ?=
 =?utf-8?B?WGVVY0l3N282d0ZFWk8vcFYrdkZqY3YvOVJHZE1BUDY2TG9lNDFRVGpTdjRQ?=
 =?utf-8?B?MUp3SHlxU01oaGJzbHJWZnJORXY1WFJHWmdCUnMrOTc5SGlydW1FK0wwcHN1?=
 =?utf-8?B?cmNFb25KTjA5a0pYMU93NTVCdytuYnNNUS9UWlVhb1RYV0FabGluV2ZkYThD?=
 =?utf-8?B?OUxOZklEb25hYlYxcGx5RS93UXdZOUR3bHNEdTBVVWRzMVlRMlB2S0h5LytJ?=
 =?utf-8?B?RW1TUUMzVTJPa1hJQXRnS2h6K3RlMUdnT0tJSXBDQ3NVRklCZWRYUXJKY2xN?=
 =?utf-8?B?QXdMWjZIaGs3TzRzZkhNUFhjbjJreExkYkFFU0oyNjdCb3FkSlRHTk9Ib3I5?=
 =?utf-8?B?a0NtUnBINmhkbThoelo0NHZBdHp1MTl2TC9HKzdsUEROSFlUVlZRYld2clA3?=
 =?utf-8?B?eGZ4dllKcXdkbEROMlNHVy9XS3Z6cDF5UzQ0YVNtcDlTYmdJZ1JxL3VISFlh?=
 =?utf-8?B?MGorRVBrOGlwQk9rT0VoTGtpOWNJSUVkdXBqckcrU1B5NDIxZUE3N0NOdnB4?=
 =?utf-8?B?dUprdllySVdyczB5eFlvcC9FWEV4VlFtdnFWeGNEU2REVVJFSHplbDByZjV3?=
 =?utf-8?B?UW5OanRJNVhPbk5aZEhuRTNzWEJSbVdFRUtwK1Y3MitRRWQ3MzRTZGNBWnZN?=
 =?utf-8?B?dGRNaTVwbTdGejZuelJlTGYvZXAxcDJRUllGMHVBcEIvNktnRk93dGl0Z1pY?=
 =?utf-8?B?YTFXRnpPSDJtVnBjWWJvN2w3YUVMUlZPRmVJTlpmY3RvMWZpWjZKREhtR2Jo?=
 =?utf-8?B?bmhYaFU0YVFuY0V2VWlyQldycXVXTkRNbW9PeXg0WFg4Yno4cVBTREdNWEw4?=
 =?utf-8?B?dnVGV3ZEVjVVbWttMXhNaHhZdGRUOHROTWNIcVVyTE5BcXFaWS9UY2VvNWZp?=
 =?utf-8?B?bmJoSlBDZkQ1cmdNd2xPNHU5YjAyNktkU0lRV2hqWjhEUzFOR2hSNEVKWmJ0?=
 =?utf-8?B?WEpXSyttWkdmMDNpN2xjeG1JRDB3ZDVBT2NKR3dKN1N5cTlZMXRqa1dpSkdy?=
 =?utf-8?B?bllpVzY2RFVTTFlQS25aMnFJUTJ3R25ycGRuZDdnY3pacVloa004S1VzQVlm?=
 =?utf-8?B?ZXJ5dXNnQkQvQjdSWXRSbEV6amFDZTE4d21tZjY1MmFyR0JnU2JubUd4dXNj?=
 =?utf-8?B?Mm0wbjk2UmJxYXJIU3hiaXR1ZlVnNCtQeEI5bTlXUkVRbUV3cy9aZjQ5K2Fn?=
 =?utf-8?B?dnlPTVNuOFRPdmcwQlBFR2lxNmVHY2hWdDB2SWFMZmh5YnJFdFYzRVpDT0Uy?=
 =?utf-8?B?SjFnSVQxRm51RGo2YUdHcUUvb3FNeXI2L0tWRWFESzFpNW5nbHBNOTZiaTh1?=
 =?utf-8?B?TFM5ZjVSVU5WWGZFS3lGeGNOSVNCWlo5ODhBVEVsdDRHVnlnR1h6VFZNbUM1?=
 =?utf-8?B?R0dxR21Md1BaOTVUTWZGVFhxM1BvckJ2VzNBZXg4dlNOcUNpUkwwWkg3YnFF?=
 =?utf-8?B?TmhOckNQd24zbFFkV2Z2bzlrTnZPSGRacW5GNElKSHd2NHRJWTFZSW9DSHpw?=
 =?utf-8?B?Q0NTWnBzVVZtZU0vSisyMnQrRFdVVkRZSHRXckRiNlI0UExlcGg0OXhZV09s?=
 =?utf-8?B?Sy9SU0prTk1UZ2EyM3VBd296cWRFdjJ1dGlMaVBNT04zRVZ1UTJOcURjM1J4?=
 =?utf-8?B?bVViWVRWVnNwbFBROFFvcWJKTDZpQkFBaGhtdk5Vei95c2RCeXk5OThVc1RW?=
 =?utf-8?B?bHFaWTRvRjhqL3gyTFB4Smo1OWhpMjk0Nks3VUFibFpoR3RKb3lteEEwL3Vi?=
 =?utf-8?B?cWg2c25lNWE0TFNlSlA2dmcwU0YwWTZ2VlZaTkl1M2QwcE1iMVl6ZHlSSDlO?=
 =?utf-8?B?Z2Z6a3FZd3U5ZEhZV0FmZVZvR1ZaZXp0UjNaVFRCdUpXSmx1cUtwdHltQ2tq?=
 =?utf-8?B?Z29JSGdTZmFycG9VNmVRRGhjZ0xRVFk3Q2YrRVZpcnRpcHUydG95N0phZ2Vz?=
 =?utf-8?Q?Moi/LVoJ5b/9MlwgyoAHIdfTp?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1B47503E00AB1440AAB271DEE2B5B8A8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5983.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4f4224a-3ee8-4b65-8074-08dcfe50acb0
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2024 10:49:22.7814
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VvTq8hyOqW9DHJodlU7AHEWIr6wNgFzUYMXEqP7422cEserc/e02+NqLpLbRZwq6vPAXP/80DHW6mgHoewj2RQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5809
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTEwLTMxIGF0IDEzOjIyIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIE9jdCAzMSwgMjAyNCwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIFdl
ZCwgMjAyNC0xMC0zMCBhdCAwODoxOSAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiA+ID4gK3ZvaWQgX19pbml0IHRkeF9icmluZ3VwKHZvaWQpDQo+ID4gPiA+ICt7DQo+ID4g
PiA+ICsJZW5hYmxlX3RkeCA9IGVuYWJsZV90ZHggJiYgIV9fdGR4X2JyaW5ndXAoKTsNCj4gPiA+
IA0KPiA+ID4gQWguICBJIGRvbid0IGxvdmUgdGhpcyBhcHByb2FjaCBiZWNhdXNlIGl0IG1peGVz
ICJmYWlsdXJlIiBkdWUgdG8gYW4gdW5zdXBwb3J0ZWQNCj4gPiA+IGNvbmZpZ3VyYXRpb24sIHdp
dGggZmFpbHVyZSBkdWUgdG8gdW5leHBlY3RlZCBpc3N1ZXMuICBFLmcuIGlmIGVuYWJsaW5nIHZp
cnR1YWxpemF0aW9uDQo+ID4gPiBmYWlscywgbG9hZGluZyBLVk0tdGhlLW1vZHVsZSBhYnNvbHV0
ZWx5IHNob3VsZCBmYWlsIHRvbywgbm90IHNpbXBseSBkaXNhYmxlIFREWC4NCj4gPiANCj4gPiBU
aGFua3MgZm9yIHRoZSBjb21tZW50cy4NCj4gPiANCj4gPiBJIHNlZSB5b3VyIHBvaW50LiAgSG93
ZXZlciBmb3IgImVuYWJsaW5nIHZpcnR1YWxpemF0aW9uIGZhaWx1cmUiIGt2bV9pbml0KCkgd2ls
bA0KPiA+IGFsc28gdHJ5IHRvIGRvIChkZWZhdWx0IGJlaGF2aW91ciksIHNvIGlmIGl0IGZhaWxz
IGl0IHdpbGwgcmVzdWx0IGluIG1vZHVsZQ0KPiA+IGxvYWRpbmcgZmFpbHVyZSBldmVudHVhbGx5
LiDCoFNvIHdoaWxlIEkgZ3Vlc3MgaXQgd291bGQgYmUgc2xpZ2h0bHkgYmV0dGVyIHRvDQo+ID4g
bWFrZSBtb2R1bGUgbG9hZGluZyBmYWlsIGlmICJlbmFibGluZyB2aXJ0dWFsaXphdGlvbiBmYWls
cyIgaW4gVERYLCBpdCBpcyBhIG5pdA0KPiA+IGlzc3VlIHRvIG1lLg0KPiA+IA0KPiA+IEkgdGhp
bmsgImVuYWJsaW5nIHZpcnR1YWxpemF0aW9uIGZhaWx1cmUiIGlzIHRoZSBvbmx5ICJ1bmV4cGVj
dGVkIGlzc3VlIiB0aGF0DQo+ID4gc2hvdWxkIHJlc3VsdCBpbiBtb2R1bGUgbG9hZGluZyBmYWls
dXJlLiAgRm9yIGFueSBvdGhlciBURFgtc3BlY2lmaWMNCj4gPiBpbml0aWFsaXphdGlvbiBmYWls
dXJlIChlLmcuLCBhbnkgbWVtb3J5IGFsbG9jYXRpb24gaW4gZnV0dXJlIHBhdGNoZXMpIGl0J3MN
Cj4gPiBiZXR0ZXIgdG8gb25seSBkaXNhYmxlIFREWC4NCj4gDQo+IEkgZGlzYWdyZWUuICBUaGUg
cGxhdGZvcm0gb3duZXIgd2FudHMgVERYIHRvIGJlIGVuYWJsZWQsIEtWTSBzaG91bGRuJ3Qgc2ls
ZW50bHkNCj4gZGlzYWJsZSBURFggYmVjYXVzZSBvZiBhIHRyYW5zaWVudCwgdW5yZWxhdGVkIGZh
aWx1cmUuDQo+IA0KPiBJZiBURFggX2Nhbid0XyBiZSBzdXBwb3J0ZWQsIGUuZy4gYmVjYXVzZSBF
UFQgb3IgTU1JTyBTUFRFIGNhY2hpbmcgd2FzIGV4cGxpY2l0bHkNCj4gZGlzYWJsZSwgdGhlbiB0
aGF0J3MgZGlmZmVyZW50LiAgQW5kIHRoYXQncyB0aGUgZ2VuZXJhbCBwYXR0ZXJuIHRocm91Z2hv
dXQgS1ZNLg0KPiBJZiBhIHJlcXVlc3RlZCBmZWF0dXJlIGlzbid0IHN1cHBvcnRlZCwgdGhlbiBL
Vk0gY29udGludWVzIG9uIHVwZGF0ZXMgdGhlIG1vZHVsZQ0KPiBwYXJhbSBhY2NvcmRpbmdseS4g
IEJ1dCBpZiBzb21ldGhpbmcgb3V0cmlnaHQgZmFpbHMgZHVyaW5nIHNldHVwLCBLVk0gYWJvcnRz
IHRoZQ0KPiBlbnRpcmUgc2VxdWVuY2UuDQo+IA0KPiA+IFNvIEkgY2FuIGNoYW5nZSB0byAibWFr
ZSBsb2FkaW5nIEtWTS10aGUtbW9kdWxlIGZhaWwgaWYgZW5hYmxpbmcgdmlydHVhbGl6YXRpb24N
Cj4gPiBmYWlscyBpbiBURFgiLCBidXQgSSB3YW50IHRvIGNvbmZpcm0gdGhpcyBpcyB3aGF0IHlv
dSB3YW50Pw0KPiANCj4gSSB3b3VsZCBwcmVmZXIgdGhlIGxvZ2ljIHRvIGJlOiByZWplY3QgbG9h
ZGluZyBrdm0taW50ZWwua28gaWYgYW4gb3BlcmF0aW9uIHRoYXQNCj4gd291bGQgbm9ybWFsbHkg
c3VjY2VlZCwgZmFpbHMuDQoNCkkgbG9va2VkIGF0IHRoZSBmaW5hbCB0ZHguYyB0aGF0IGluIG91
ciBkZXZlbG9wbWVudCBicmFuY2ggWypdLCBhbmQgYmVsb3cgaXMgdGhlDQpsaXN0IG9mIHRoZSB0
aGluZ3MgdGhhdCBuZWVkIHRvIGJlIGRvbmUgdG8gaW5pdCBURFggKHRoZSBjb2RlIGluDQpfX3Rk
eF9icmluZ3VwKCkpLCBhbmQgbXkgdGhpbmtpbmcgb2Ygd2hldGhlciB0byBmYWlsIGxvYWRpbmcg
dGhlIG1vZHVsZSBvciBqdXN0DQpkaXNhYmxlIFREWDoNCg0KMSkgRWFybHkgZGVwZW5kZW5jeSBj
aGVjayBmYWlscy4gIFRob3NlIGluY2x1ZGU6IHRkcF9tbXVfZW5hYmxlZCwNCmVuYWJsZV9tbWlv
X2NhY2hpbmcsIFg4Nl9GRUFUVVJFX01PVkRJUjY0QiBjaGVjayBhbmQgY2hlY2sgdGhlIHByZXNl
bmNlIG9mDQpUU1hfQ1RMIHVyZXQgTVNSLg0KDQpGb3IgdGhvc2Ugd2UgY2FuIGRpc2FibGUgVERY
IG9ubHkgYnV0IGNvbnRpbnVlIHRvIGxvYWQgbW9kdWxlLg0KDQoyKSBFbmFibGUgdmlydHVhbGl6
YXRpb24gZmFpbHMuDQoNCkZvciB0aGlzIHdlIGZhaWwgdG8gbG9hZCBtb2R1bGUgKGFzIHlvdSBz
dWdnZXN0ZWQpLg0KDQozKSBGYWlsIHRvIHJlZ2lzdGVyIFREWCBjcHVocCB0byBkbyB0ZHhfY3B1
X2VuYWJsZSgpIGFuZCBoYW5kbGUgY3B1IGhvdHBsdWcuDQoNCkZvciB0aGlzIHdlIG9ubHkgZGlz
YWJsZSBURFggYnV0IGNvbnRpbnVlIHRvIGxvYWQgbW9kdWxlLiAgVGhlIHJlYXNvbiBpcyBJIHRo
aW5rDQp0aGlzIGlzIHNpbWlsYXIgdG8gZW5hYmxlIGEgc3BlY2lmaWMgS1ZNIGZlYXR1cmUgYnV0
IHRoZSBoYXJkd2FyZSBkb2Vzbid0DQpzdXBwb3J0IGl0LiAgV2UgY2FuIGdvIGZ1cnRoZXIgdG8g
Y2hlY2sgdGhlIHJldHVybiB2YWx1ZSBvZiB0ZHhfY3B1X2VuYWJsZSgpIHRvDQpkaXN0aW5ndWlz
aCBjYXNlcyBsaWtlICJtb2R1bGUgbm90IGxvYWRlZCIgYW5kICJ1bmV4cGVjdGVkIGVycm9yIiwg
YnV0IEkgcmVhbGx5DQpkb24ndCB3YW50IHRvIGdvIHRoYXQgZmFyLg0KDQo0KSB0ZHhfZW5hYmxl
KCkgZmFpbHMuDQoNCkRpdHRvIHRvIDMpLg0KDQo1KSB0ZHhfZ2V0X3N5c2luZm8oKSBmYWlscy4N
Cg0KVGhpcyBpcyBhIGtlcm5lbCBidWcgc2luY2UgdGR4X2dldF9zeXNpbmZvKCkgc2hvdWxkIGFs
d2F5cyByZXR1cm4gdmFsaWQgVERYDQpzeXNpbmZvIHN0cnVjdHVyZSBwb2ludGVyIGFmdGVyIHRk
eF9lbmFibGUoKSBpcyBkb25lIHN1Y2Nlc3NmdWxseS4gIEN1cnJlbnRseSB3ZQ0KanVzdCBXQVJO
KCkgaWYgdGhlIHJldHVybmVkIHBvaW50ZXIgaXMgTlVMTCBhbmQgZGlzYWJsZSBURFggb25seS4g
IEkgdGhpbmsgaXQncw0KYWxzbyBmaW5lLg0KDQo2KSBURFggZ2xvYmFsIG1ldGFkYXRhIGNoZWNr
IGZhaWxzLCBlLmcuLCBNQVhfVkNQVVMgZXRjLg0KDQpEaXR0byB0byAzKS4gIEZvciB0aGlzIHdl
IGRpc2FibGUgVERYIG9ubHkuDQoNClRvIHN1bW1hcml6ZSwgaWYgeW91IGFncmVlIHdpdGggYWJv
dmUsIHRoZW4gb25seSAiZW5hYmxlIHZpcnR1YWxpemF0aW9uIGZhaWx1cmUiDQpyZXN1bHRzIGlu
IG1vZHVsZSBsb2FkaW5nIGZhaWx1cmUuDQoNCkFuZCBJIGFtIG5vdCBzdXJlIHdoZXRoZXIgaXQn
cyB3b3J0aCB0byBkaXN0aW5ndWlzaCB0aG9zZSBjYXNlcy4gIEZvciB0aGUNCmNvbmNlcm4gb2Yg
IktWTSBzaG91bGRuJ3Qgc2lsZW50bHkgZGlzYWJsZSBURFggYmVjYXVzZSBvZiBhIHRyYW5zaWVu
dCwgdW5yZWxhdGVkDQpmYWlsdXJlIiwgd2UgY2FuIGV4cGxpY2l0bHkgcHJpbnQgZXJyb3IgbWVz
c2FnZSB0byB0ZWxsIHVzZXIgd2h5IFREWCBpcw0KZGlzYWJsZWQuDQoNCkFueSBjb21tZW50cz8N
Cg0KWypdDQpodHRwczovL2dpdGh1Yi5jb20vaW50ZWwvdGR4L2Jsb2IvdGR4X2t2bV9kZXYtMjAy
NC0xMC0yNS4xLWhvc3QtbWV0YWRhdGEtdjYtcmViYXNlL2FyY2gveDg2L2t2bS92bXgvdGR4LmMN
Cg==

