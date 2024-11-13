Return-Path: <kvm+bounces-31814-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 434409C7DD6
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 22:48:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F6312837EF
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 21:48:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F296918BC1D;
	Wed, 13 Nov 2024 21:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GQro55mF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E468157A48;
	Wed, 13 Nov 2024 21:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731534507; cv=fail; b=X4ssRVdEg8+fEN7ZrSevtCjJgwOv1CouucAY7GyjWN8DdV3pi+j7miDNh8TtRm2Fv1SbD5bKlKDZy6owksMyityoBaXXD7LpDizhNI1QQxi6q0QSdINRHuciAcqr5lZPANSaQrmMLZ4HYVE0ACf9roo48mGZGftWWKrUqowzu0Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731534507; c=relaxed/simple;
	bh=BQNV1f+pNcRcjlPMcIXqujn4DXThThxAkh8J1/FSdpM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=n5leq0+TILx8tgKEBlC36/DHYuSlSbPWA008eLF66k5ejAWAQ1tkuJo8ByI/xcC93YQWAbqdFUkacFQwJl5FuGv8zRTVufOjWrO/Kt3G6Zn7oAZl/h/FgZ8aOU2GO9/IGziqwaYSL8JNNMXUnYnuncgbzBObE7TrfwPcXK6IyRE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GQro55mF; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731534505; x=1763070505;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=BQNV1f+pNcRcjlPMcIXqujn4DXThThxAkh8J1/FSdpM=;
  b=GQro55mFPnTIHtnc+QQP74nVEuuj1Kd8uRMkSOyvPf6jfgNyGoDo5//h
   W6CrUd4pY3EzGCypFSFou9caJtwLzp9BBaUXG809Q60sRmnvVpJy8aobX
   lngtA6OxnsAiFyWZT29xCyMBCv55ukI4hFcNN4dmWGH0PCnxBe4gyIalV
   XB6X9399745foT9COiK1wHd92PO2lBlGxsU0Uh+wggpiK02nVGCBCBbfd
   hR3AKzlZW9JpuKUyGH8CSffQetUcIu+918opDwnVjpnp4jm65CVf/o2sP
   4Y3LjkB/l8WkNo0+ycbldrzjhyp/7e9wnH+9Q5oEyvUPUrj+SMwOC2Nj4
   w==;
X-CSE-ConnectionGUID: vQ1WsOVCR4yNQm5wJcNoqQ==
X-CSE-MsgGUID: c9Zd/6WuTzGQhVHDeiyd0g==
X-IronPort-AV: E=McAfee;i="6700,10204,11254"; a="31331167"
X-IronPort-AV: E=Sophos;i="6.12,152,1728975600"; 
   d="scan'208";a="31331167"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 13:48:25 -0800
X-CSE-ConnectionGUID: K1d8F2/5RyeoTUDWJ2o9Uw==
X-CSE-MsgGUID: /9Rkfxm3QxWW4yLtpW/xnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,152,1728975600"; 
   d="scan'208";a="92793490"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Nov 2024 13:48:25 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 13 Nov 2024 13:48:24 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 13 Nov 2024 13:48:24 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 13 Nov 2024 13:48:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=atsow25Sbkv7XM824A8w1FMNRraDrPn6CiJgPMwsY+IwSN73qdHQ1t2JnQCCNenW9xoavSb039c84gMzrftN16daa6nKvPpMOn7qcgfGGa3oJS1hxOgrCUS0ydliH8hNAyavYS9ELb0X8VtYevklqNPHwjsi1kVskQLMh7HWFxyvDLhv4dtPW1KXrjQuBNi9qRZlaEjO2BjKE2hS5Kycase/mFzr1+rXRFhKfwTcJwjgmlxISVBtrTpJdU/nWrgb3ZD8COvJ/lqZzIC0PlhEZVX0HVZVkS1Tlt/5+cHwnp4y5euheECQFKV28Qu2KC2heU1/sC2UVTFtZkXlzmbk4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BQNV1f+pNcRcjlPMcIXqujn4DXThThxAkh8J1/FSdpM=;
 b=cZwly+dBJjOu8WtkMJh62I6Lm8ag2gGdYl43jJLifGRBfVi+1S4Lg0VDStf6uhz51u19LCdnnBamhkispw1ZIABSCwm8ml2UH81SmNOkczyBVFyhAcqgWFj2V0dRnOE7IYnQInOjQET0olINdAPOX7bwzBrzVpTNjWD+DojI7EIA4ImRa/xrV5ulls1crIQIhFwkWJv91/E1SWpahxABomc6hmEuOON+8cbN9APt67mCNtHfqtnxuKCYqNJpqS3Btc9LOCoAlrI/fVMS5wXsBQ2KLKBrbTJWzZGJRG/fHkEneR8vI8IxfTgL/e7MVGli/TwMnlHzz2tPvJ9Ax4pGvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV2PR11MB5976.namprd11.prod.outlook.com (2603:10b6:408:17c::13)
 by SA1PR11MB8319.namprd11.prod.outlook.com (2603:10b6:806:38c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.29; Wed, 13 Nov
 2024 21:48:21 +0000
Received: from LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::d099:e70d:142b:c07d]) by LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::d099:e70d:142b:c07d%6]) with mapi id 15.20.8158.013; Wed, 13 Nov 2024
 21:48:21 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "seanjc@google.com" <seanjc@google.com>
CC: "Yao, Yuan" <yuan.yao@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v2 10/25] x86/virt/tdx: Add SEAMCALL wrappers for TDX
 flush operations
Thread-Topic: [PATCH v2 10/25] x86/virt/tdx: Add SEAMCALL wrappers for TDX
 flush operations
Thread-Index: AQHbKv4/8rncF8VelU6Hco9BT4aHk7K0e+6AgAFRIYCAAAalAIAAAdEA
Date: Wed, 13 Nov 2024 21:48:21 +0000
Message-ID: <037e52a151c4af1ed4b417eeff5df4e5de853c0c.camel@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
	 <20241030190039.77971-11-rick.p.edgecombe@intel.com>
	 <977e362f-bd0b-4653-8d47-c369b71c7dda@intel.com>
	 <966fcd7dc3b298935b4aa9b476d712eefa9fabbf.camel@intel.com>
	 <136df713-64f1-4dfb-90c2-88c613fc72a7@intel.com>
In-Reply-To: <136df713-64f1-4dfb-90c2-88c613fc72a7@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV2PR11MB5976:EE_|SA1PR11MB8319:EE_
x-ms-office365-filtering-correlation-id: 6e07770a-0ada-4c63-11d6-08dd042ce466
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?azNNbDRPdFN4QUVmVU1sZUcwNUp2dHk1cmhUR2ZpMVY0enZiWTRsckhsdnpp?=
 =?utf-8?B?NkhmckRjenFlNW5od0VDT1hSSWFCY0VIVmF1U3UvUisydEhHMm13NkNTQS9X?=
 =?utf-8?B?dldlcG04SUVWU3RqN3FIYTYvd2p3bGhrbzQxejM4bVlrQ0haLy9oOVg0dkpM?=
 =?utf-8?B?dldwUGQwQ3RzVktGTXdiUDhlc1NpeEhoRmJKTUdxUFVoM3ExdmJvaFZCbnZJ?=
 =?utf-8?B?dmVkNlB2ZjVhenh4ZVhQZ0VRTTkyeUhJU29QS3pYd1pyejhnVlFVeHN4VEkr?=
 =?utf-8?B?QVd6eTdyTWYwNTd1enlrZDBUMWlNaUVkdHlWdUtwdGkxMVlXVDJyRElWYU16?=
 =?utf-8?B?N0RmOEdvWWpqcWwwSHI3aWtYai9ORFh4cjYyZytJMmFYZTRMMjlUaG5ncDFJ?=
 =?utf-8?B?c0l2S0pwZEtSRHNieWR1RStwVkxPQTg1bFlFZXJFRGdOOGVyeFBmdVVOVXdn?=
 =?utf-8?B?TkF2d0ZlMzhlRVJlUzd2ZXpnVHM2Q3hFbEREK0ZwNTgybEhOdHllclNoekta?=
 =?utf-8?B?MzM0c1dYUnh6anlicWJLYUlqdUFRT3QxdDlydXZIUmI4b1VXYk9QMjYvbmpa?=
 =?utf-8?B?RUNKSU9yMXJsbWN0dGNGSG5xZnpLRVlQb21BY09Ob0JiOHlkSFFUL2pmWkxN?=
 =?utf-8?B?aHlRTll4MjkwbDhuVVpIREhvTkgrSmZaVHdUcnA2eU9ScVJUL1dnUStzdGhS?=
 =?utf-8?B?b3ZTUjlCZXhTRkw0Ni83RzJ0cjRLdXQrMXZuaGdiSW82SDNYSUx4d09vbkt4?=
 =?utf-8?B?SDBiZXBGTDViaC9OdW96SmVBTjBhMHZkYitPUVVVZXF0b05TMjMydkJxRnhL?=
 =?utf-8?B?Z1A1VWlaemJJZkVnMEhkaTA5TmowQm00Qm4wbWtOZDVONzc1bTFYeEYvRkZz?=
 =?utf-8?B?dGluMFFCdVhtdXJZaDNoZ2p1Nnd4TGpDQlhhOUhENW10dEdnYUhobHhnMWFy?=
 =?utf-8?B?bEp0bk8yQ0hSMW4yY1J6UWVIdDJ4dzdsQk4ra2w3NkJxSXRPVVpIcUFmSWk4?=
 =?utf-8?B?ZW04YUp1NEpCbHMzNnlEWGVTL3BQakNET2Nreno5dVhwWXlpOGhITDBFZ1Rs?=
 =?utf-8?B?dkFSZVlwa3NNM3hqV3VZNXIyQVhENi9lVnlidnNTRU9lYXpENHVQRTg5SDlm?=
 =?utf-8?B?b212Uy85TkJ0QjRBeis1MXd2NWUwNzN1bEdWcDgyTS9uOXFuRG83Ukd1TkJG?=
 =?utf-8?B?WG1uVC8yTzRoczBZQ0Q1NWoyQXVTN2ZxUDF6MU9JNnBVSFVobVFnT3FvYXg0?=
 =?utf-8?B?ZlVjbjFLcUdTSjJFMkltZnNNTFI5MXprRmhSNmsvd3VBdjlZVGdVaktVVWhR?=
 =?utf-8?B?djV1S1VscGphSHVieDJVcVlGdHZPVTVIcjJxdk9lMEUyNDFlNE5nRWJhNTl0?=
 =?utf-8?B?ZVY1ZkJtNE5nSXJDV25HNWIxNGhmYi9CYnBYVURpY24wZDhPVkhNWVhFSnhO?=
 =?utf-8?B?ekFZbzg3M3RPc1gwOXl6YnVPTzUxVGpIUGxwcXlQbmxXSmhvMldlWEk2M0lQ?=
 =?utf-8?B?UTI1U2EzeDBhNWZraWQzVjhkdTl0bUFueTVteVBBWVRzNnZpamV3U0pYaTRq?=
 =?utf-8?B?Yk9QVzJtOW1OWlBmek44OTA5anNqU0FmMDNhVW9HSk5iVG0wWXU3T1duazVU?=
 =?utf-8?B?T0JwY2RGRWtmNmtHN2NGUlR6QUtxdlVlNUxpN0R5OVIrSStGeVMrTlllQXdQ?=
 =?utf-8?B?Vzk5WFYyNTUzVGFEN1NSSXJyS0djMUR2WDlVZkhFZndEZVlwbzUrSjFwOVZz?=
 =?utf-8?B?YkM3SXA4ZTkyYnBJUHEvMXA5NGZTQ1VteGJsMHBhditpQ1lFYUZBM1lxRXJz?=
 =?utf-8?Q?0IxkhGLi26LQEYE8hlgM0gjT4ZL+l5XoLmlVk=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR11MB5976.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c1JoS3FmRmVGMitXUUtYZUZ5MG41QlVVUmV4Sll0U1BiamR4T2xRU1VFRXcy?=
 =?utf-8?B?MW0zVlAvdkxqZE4wV1FsRUhDUTNEeDA5V1ZmU0RxbXhxZjB3RUg4T3hGM25l?=
 =?utf-8?B?dTlBd3RyR09COWVxcmRvbVIvcDgrSGFmaU9mblJNV3ExUVFBTGVkTC80Q1BH?=
 =?utf-8?B?WnZnTnd4VGE4alNQcTJXbU1idWcrK2szazBDQXFQQUpHcjNGM01FUG1DM0sy?=
 =?utf-8?B?V0REY0x3eUkraW4xMFg4SlBvSHI1bHZHU2tMOTViMDR1Qi9HN1FEL0dHcGhi?=
 =?utf-8?B?SC8zVWZhZ1JhUUZ1YTJ6bmgrVVkzL01sQmY2RGNWdGttWmsyN1UxNmIyU2NR?=
 =?utf-8?B?Qm84OFNsRWtDNm4rY0FPa2pyM2ZCRWFzZGNrekNwZE5OSS85OTEwMlltS2ZB?=
 =?utf-8?B?NTRXeGlWZElQTjdNK2ZOV0pqVVRGMWNVSDR1V3k5WGJUKzZubHA0VVNNWXEz?=
 =?utf-8?B?LzUySFBSK1RDVXpaSG5aL2srYWRRMlpMWjYwVlU3ZUhtZGkvQms0aUt5Y01X?=
 =?utf-8?B?dFlpWExFY01rSDIrMkxVTnJzT2JZK0J1MmxkU0Z0SVpEYWlKZDVReERJWXVi?=
 =?utf-8?B?ZlhiWklJRVhwODZzWGlabTdqT0FTTFduOG9ndFA0b3NsT0ZENW1xOEZJN2pY?=
 =?utf-8?B?WEpHS1A4c0toa0RvUEh4ZW1qMXJScjB3NG1VMGp6dTVRNS90NS9zYnU3d1JM?=
 =?utf-8?B?bi9wWkgyWUFleHpTL2JWY0EzTnlKc1Q5czcvdk9vK0tCWUVRQmlNOEdYaHM1?=
 =?utf-8?B?eUV2a3l0RVlDR3ZtVExhOEJjSDFWQTVvUEZ6QW1TeERhSE9zMTJwa2N5NlVT?=
 =?utf-8?B?YmFxM1FWcWdsMklPTDg4R25ZSkYxTlR6THhPdVpUMEE5bmt2VG9oN0tKY3Rz?=
 =?utf-8?B?djdXVXV4MjIyVFpGV09KVUFLd2REemIvdzBvWk05b2pTZVhFV3dzV0h4Qk9D?=
 =?utf-8?B?MnBZZkJFYk9Bajk5dFdlQndQQUY2WnBlR05USllwYTVEOFRBNlFHTnQwaVhB?=
 =?utf-8?B?S05GOG9oT1VoUWV1dE9FRmJ2empGRkY3ZTBFQ1FHWEt1a3JSZm53WmdianFk?=
 =?utf-8?B?OFV2SGFwSDdQS1BQRFNSNkNIL0pUQzczQy9pcnpFNklLSUU1eUNkbEt6d0oy?=
 =?utf-8?B?YVhUSTFlKy9PdlZWNm8wN1VJdHVrd0tXcG0vZElSNnpQNWFscWhkemdrNlBX?=
 =?utf-8?B?cGUyMHdZMWFqTE4wTWtQVGpURXk1MmJEc3lscDdOS2M5YTVuMU0rSG1JaDEv?=
 =?utf-8?B?TUZsTW9iZ2xWTEdiNXVVOEk4UHpONlU0OWxaT3RPS2U1YStxQzh4NHorRmZI?=
 =?utf-8?B?dVl5bi9SNGo0UHlwOGJ2VTlsZU5vY1ZabFNOb0V2VTQxQzVNWENGckJDSGFL?=
 =?utf-8?B?NVYzUjZwMmZnSEdyUVpBOElOMSt1em9XVGVoN2ViLzRib1BYTko0ekR1YkFy?=
 =?utf-8?B?Mnp5aEJQNlFqZ2lRZzdpUTErNWNVNC91Sm1LblZqeGlsVGF0R0pDM1NyZHZ4?=
 =?utf-8?B?NU1qMjN3aE4wWjZqWWl5b2JsOUdSR2h4N2xZem9tM3lKSEdmSWxDa2d3SDhO?=
 =?utf-8?B?WEVWMGpEcG42T0NhS3I2aStkcVJ5Ym5maG45MFR4V0wxRUdrVjhaTllGQmlZ?=
 =?utf-8?B?eFpJS1JZaURzcUxrSG5YVldBMUdGYmJGanBYZnNUTWZGN3FsSzJrU3FTUG9h?=
 =?utf-8?B?azdHUGxYTzNVaGh5RHZ6VVd0QzR1Q09HaGFHbm5xT0cxVlc2aDBFZnQreWJ1?=
 =?utf-8?B?b1NLeDAyOGozS0RlUGwrbXJZaGsrUEhZL1ZhaFFMNWFmakZMRlJYaEk3cVlw?=
 =?utf-8?B?ZlE1ZXgyQ2RyL1lVelFQUzk2UzU0OVpzSHdtL1lQSnZMMzFjTWx1a1NiY3d0?=
 =?utf-8?B?cC9tTC9PdnhGRHdFdkdBanpFcTVmVG9vNEg0WkJoazFrNDh1Z04xRGRvWGtF?=
 =?utf-8?B?b2FYZTVGY0ZleFJTN3ViRnd0eVVDVTVhWGExSXNwZ1VBRXRMdXJ6bm1EYVVZ?=
 =?utf-8?B?NlNEMFdZeUUvWUlBQStVR0NMcGdKQWc1c1N5aHZWNUhNWTZaZ2JBaVBwbXNv?=
 =?utf-8?B?MXFKK3pDc1hnVzFxS0VUL3NmNHp6WmVVaXg1cXhtaVB3Tkh1UVdJVDQ2c1FG?=
 =?utf-8?B?S2lsWnFNd1ZKVHR0YXBoT01lZytqczFiVGk1cUNvUjYwR0djbWtlL1pVSURq?=
 =?utf-8?B?TGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C7CCE4CDA581E8498F997F135AEC609E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV2PR11MB5976.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e07770a-0ada-4c63-11d6-08dd042ce466
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2024 21:48:21.2813
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tbXYw9OygO7Q2XcWuqePnwtcr+XO1DhPcCwkiW1pUEdwUSqoOHYDTr1YhAilkOQq0Gx9pxfD0+qBfRjI0u8ZUbDkQO8kPHNxeypFKPNcJbA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8319
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTExLTEzIGF0IDEzOjQxIC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
SSdkIG11Y2ggcmF0aGVyIHRoZXNlIGJlOg0KPiANCj4gCXRkeC0+dGR2cHJfcGFnZSA9IGFsbG9j
X3BhZ2UoR0ZQX0tFUk5FTF9BQ0NPVU5UKTsNCj4gDQo+IGFuZCB0aGVuIHlvdSBwYXNzIGFyb3Vu
ZCB0aGUgc3RydWN0IHBhZ2UgYW5kIGRvOg0KPiANCj4gCS5yY3ggPSBwYWdlX3RvX3BoeXModGR2
cHIpDQo+IA0KPiBCZWNhdXNlIGl0J3MgaG9uZXN0bHkgX25vdF8gYW4gYWRkcmVzcy7CoCBJdCBy
ZWFsbHkgYW5kIHRydWx5IGlzIGEgcGFnZQ0KPiBhbmQgeW91IG5ldmVyIG5lZWQgdG8gZGVyZWZl
cmVuY2UgaXQsIG9ubHkgcGFzcyBpdCBhcm91bmQgYXMgYSBoYW5kbGUuDQoNClRoYXQgaXMgYSBy
ZWFsbHkgZ29vZCBwb2ludC4NCg0KPiBZb3UgY291bGQgZ2V0IGZhbmN5IGFuZCBtYWtlIGEgdHlw
ZWRlZiBmb3IgaXQgb3Igc29tZXRoaW5nLCBvciBldmVuDQo+IA0KPiBzdHJ1Y3QgdGR2cHJfc3Ry
dWN0IHsNCj4gCXN0cnVjdCBwYWdlICpwYWdlOw0KPiB9DQo+IA0KPiBCdXQgdGhhdCdzIHByb2Jh
Ymx5IG92ZXJraWxsLsKgIEl0IHdvdWxkIGhlbHAgdG8sIGZvciBpbnN0YW5jZSwgYXZvaWQNCj4g
bWl4aW5nIHVwIHRoZXNlIHR3byBwYWdlczoNCj4gDQo+ICt1NjQgdGRoX3ZwX2NyZWF0ZSh1NjQg
dGRyLCB1NjQgdGR2cHIpOw0KPiANCj4gQnV0IGl0IHdvdWxkbid0IGhlbHAgYXMgbXVjaCBmb3Ig
dGhlc2U6DQo+IA0KPiArdTY0IHRkaF92cF9hZGRjeCh1NjQgdGR2cHIsIHU2NCB0ZGN4KTsNCj4g
K3U2NCB0ZGhfdnBfaW5pdCh1NjQgdGR2cHIsIHU2NCBpbml0aWFsX3JjeCk7DQo+ICt1NjQgdGRo
X3ZwX2luaXRfYXBpY2lkKHU2NCB0ZHZwciwgdTY0IGluaXRpYWxfcmN4LCB1MzIgeDJhcGljaWQp
Ow0KPiArdTY0IHRkaF92cF9mbHVzaCh1NjQgdGR2cHIpOw0KPiArdTY0IHRkaF92cF9yZCh1NjQg
dGR2cHIsIHU2NCBmaWVsZCwgdTY0ICpkYXRhKTsNCj4gK3U2NCB0ZGhfdnBfd3IodTY0IHRkdnBy
LCB1NjQgZmllbGQsIHU2NCBkYXRhLCB1NjQgbWFzayk7DQo+IA0KPiBFeGNlcHQgZm9yIChmb3Ig
aW5zdGFuY2UpICd0ZHInIHZzLiAndGR2cHInIGNvbmZ1c2lvbi7CoCBTcG90IHRoZSBidWc6DQo+
IA0KPiAJdGRoX3ZwX2ZsdXNoKGt2bV90ZHgoZm9vKS0+dGRyX3BhKTsNCj4gCXRkaF92cF9mbHVz
aChrdm1fdGR4KGZvbyktPnRkcnZwX3BhKTsNCj4gDQo+IERvIHlvdSB3YW50IHRoZSBjb21waWxl
cidzIGhlbHAgZm9yIHRob3NlPw0KDQpIYWhhLCB3ZSBoYXZlIGFscmVhZHkgaGFkIGJ1Z3MgYXJv
dW5kIHRoZXNlIG5hbWVzIGFjdHVhbGx5LiBJZiB3ZSB3ZSBlbmQgdXAgd2l0aA0KdGhlIGN1cnJl
bnQgYXJjaC94ODYgYmFzZWQgYXBwcm9hY2ggd2UgY2FuIHNlZSBpZiB3ZSBjYW4gZml0IGl0IGlu
Lg0K

