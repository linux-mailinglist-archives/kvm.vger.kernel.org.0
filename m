Return-Path: <kvm+bounces-64435-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FE19C82879
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 22:25:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 05CDE4E354C
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 21:25:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4566B32E6A8;
	Mon, 24 Nov 2025 21:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Mjv4fT01"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0FC2D5957;
	Mon, 24 Nov 2025 21:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764019517; cv=fail; b=ckirAdVupRoe81Xn5fKtW85EfGLYyGOgqAAOeruGlvLJgO11ClCfdXPzcZFpTrqBRHWpGNvY+9sAWuA4XYv94CvJ4Yvt7nktAOfX3fl1MqUoDjC/01czlozPmZKXZDWgHetXPpreOC5tNCjwqqZPfYO8ohyxesSSm204+LPLvOo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764019517; c=relaxed/simple;
	bh=IwHiwS/eaOqWTqXSaKRzNUt7LEt4/UZRUe9fIy0pYyA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=RVRAR6pnmerPiIwJDxZA9QKxVrh3IRUwhsIzImoE5QxBrgPzzTpJJ8ImznZQ8/SLSlQXNOp+WU7emHMtap8tzeidyMtBgDCLfcF9qk+dgGBO/Ux9+lMObYLQpYPNd1v144t73a4S6h+cXtjKaAlnrz9YGP/DJ5sbyEyKZseZm0Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Mjv4fT01; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764019515; x=1795555515;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=IwHiwS/eaOqWTqXSaKRzNUt7LEt4/UZRUe9fIy0pYyA=;
  b=Mjv4fT01Wn09ytwXYcPSXsP/YB1jxFqIk70bwQcU/pg+hbcv47KQTBS4
   gGd6E5pYY8Q1G7NrKsdoq9gDQwWUhUWxN+2uOfw8vM7sQHz97NsOZKFRO
   6hzcA52CUb0CRZGBDjkfYELDlPfdQfo4lr7V2pIbEeRsTO+Znn+ed5eO4
   Zs0u28fYBdIciAIUjbkxSHLik7TbGQutiFVV3wOiy85Mfcw/jFIoNjhBg
   oIL6/CSawwoWr2WF/RcM4BVRw04lMG/n0ylyjZE7qV/Jc0fQBVnPxxf5F
   aT+CSLHoY1WvPajEe1GbTvrwuqby6N6On+T7UQobD3QWNhvWJsZogOWE0
   A==;
X-CSE-ConnectionGUID: ek+9jvpzTsOH8BsAXQgYNg==
X-CSE-MsgGUID: k919OsnSTA6QpRy+PIDyiA==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="69651482"
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="69651482"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 13:25:15 -0800
X-CSE-ConnectionGUID: YtvdzWfMRMKf4Jvk94lZ4A==
X-CSE-MsgGUID: G220h0qtTpaRbLU/ghIdKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="192527740"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 13:25:14 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 24 Nov 2025 13:25:14 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 24 Nov 2025 13:25:14 -0800
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.40) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 24 Nov 2025 13:25:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BagfLkXJQv9Zdz4Om/FB7L8jA9XVqwxRDHZYBIfx4fHHFvtyd+ZOZ8XXv/lx1Hq7Nm73RpRkcoGdIOPIRiRs46Oioq5iELN38S9aD3Q1bu69qE721M1BH7RItTJg1IlaO0WeKGY7c5Hk35KEYwiLgGpJvwl7WYCkmIUwMFjaf3++o1LCuYcru7YCw6MQ+beMzR1G/9TKEhhYDpYank2jo7klI8dq55ETEajURPSUy8hWhfH9OBqsdfBTJjsBGGs4zD8d9wH8hK63zdDaMDz2Jlb701idq4cekPTaXbXWcvH3PGm8+tI/kyICbixB+Z2PQd7E+KzrNfMQcAyDETLJmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J32GRS6qqYj2c4StlAt7s5x9SOvcVTTMiw8z9EFvny8=;
 b=nQgXhImz7q7Ycs8SLh3NE1eyVTy9p/6/ksvZAb9QZO0ymN1O2zBiSvLL2t8nVqAS2U54FI1tsaF6GLInJ/uFmhz6AC+8CsBNBIHcsJmWzdcaKNSSxUZsqXIXX/J4CKePrE5X3eFMANDXEt7LkWL0ZEDYq/JY0gUT8Lc8DC4UtvaiEXuHzAfHLykpH0SsSdfFh3JT6LxZd/k7eLuRTNi8Jj52FfKtYg1GKZ4BJzbnrRV/5qLMN5ALzijQ55jPsD++BFh0++MFDanzJ3Y61doV+qLuDQMF9v31vUnZX2ZOboVzTMU8bJNigcpHQrowKIGvqftMFcyYqxxhy/5+BAyIVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5373.namprd11.prod.outlook.com (2603:10b6:5:394::7) by
 BN9PR11MB5275.namprd11.prod.outlook.com (2603:10b6:408:134::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 21:25:12 +0000
Received: from DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39]) by DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39%5]) with mapi id 15.20.9343.016; Mon, 24 Nov 2025
 21:25:11 +0000
Date: Mon, 24 Nov 2025 22:25:07 +0100
From: =?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>
To: Michal Wajdeczko <michal.wajdeczko@intel.com>
CC: Alex Williamson <alex@shazbot.org>, Lucas De Marchi
	<lucas.demarchi@intel.com>, Thomas =?utf-8?Q?Hellstr=C3=B6m?=
	<thomas.hellstrom@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>, Kevin Tian
	<kevin.tian@intel.com>, Shameer Kolothum <skolothumtho@nvidia.com>,
	<intel-xe@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, Matthew Brost <matthew.brost@intel.com>,
	<dri-devel@lists.freedesktop.org>, Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Tvrtko Ursulin
	<tursulin@ursulin.net>, David Airlie <airlied@gmail.com>, Simona Vetter
	<simona@ffwll.ch>, Lukasz Laguna <lukasz.laguna@intel.com>, Christoph Hellwig
	<hch@infradead.org>
Subject: Re: [PATCH v5 26/28] drm/xe/pf: Export helpers for VFIO
Message-ID: <uzdflevtty3zvzjcf5zhiwjc3qpi5rebh5kxgo7kwupceh4r4a@66ftjkny67gu>
References: <20251111010439.347045-1-michal.winiarski@intel.com>
 <20251111010439.347045-27-michal.winiarski@intel.com>
 <5c82393b-968d-4081-9cf3-b9a02a5f6072@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5c82393b-968d-4081-9cf3-b9a02a5f6072@intel.com>
X-ClientProxiedBy: VI1PR07CA0225.eurprd07.prod.outlook.com
 (2603:10a6:802:58::28) To DM4PR11MB5373.namprd11.prod.outlook.com
 (2603:10b6:5:394::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5373:EE_|BN9PR11MB5275:EE_
X-MS-Office365-Filtering-Correlation-Id: 5db8ec41-76e6-4950-a769-08de2b9ff376
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cWtLc0JReDR1RFRVSDAxcUhLZEtZRHV2VWJTN2lnYTdWakFmb1lPM0Y4d3FG?=
 =?utf-8?B?ZFVrSktHbU1XeTFGcGdBWkowWlRlVlNDdlF4NC8wM3ZpcGlVR2FMVzRTUFpT?=
 =?utf-8?B?dThKbUNxQTNuUVZEelZGNlFDeTdzdjd0QkN4ZmMzM3FQYkRJZFdSR1E0SXJW?=
 =?utf-8?B?STAzK2xpand6UENURjcxcFlTRjZsLzZPZVY2QTF0WFMvcGtFQjNTb0F4WVFF?=
 =?utf-8?B?alprSkx3SkcxOFdlQ042TlNYUkhCdVplSlV6WVYra2hRN2Z4SFhwS2hML0Zy?=
 =?utf-8?B?MmdUaCs1aHQvcjlBeDBla1VIcUlnWnBQSzNRVjBseVk4QVUyQW1CcEZXTnQ2?=
 =?utf-8?B?eW5OWmkxZENiQ0ZsRkdtTVZwK3JNdlBJeHpBWnFFay9WV2dkcHBaUGVSdFE2?=
 =?utf-8?B?TUEvdVRBZWhMMHBQbUhqSDBTMUx3cFpuTjRScmp4aTA0bGZXa3k0eHhCNFkw?=
 =?utf-8?B?SjAxOFY5YURBcmNLZUwxZ1ltY2ZnSjZMWXdub01OU0pWbEM4QkRoNmJyNkNq?=
 =?utf-8?B?RXpQRUVFUnNIUEgxOG9md2V0R3Z1aGwwUzdBTnBiODkrODA3QlF3M1FyTjBm?=
 =?utf-8?B?OGFjSEVEWmhNcW42QUIrajloN0EvMjYvdVZMSFFXem9tZ1V2TFFaWmMzWGF5?=
 =?utf-8?B?Uit5K2kyY3Y3NmRhQ2ZsL0J0Y1JJWER4d1d1Y1V4RU5xcG5mWjZ3WGx6RE9B?=
 =?utf-8?B?V08vdFBXaU5Xb3A1NHVNSVo3ZUdKd3B5Tm1QZ3pHRlJLc1paWkQ1NXFEaEph?=
 =?utf-8?B?Ujlxb2pwdE51T1V4MGdCUFBxMkZkTktEUlBIT2lFK1h1Q0tyTTNRa2luR1RJ?=
 =?utf-8?B?S3d5MkVHeTZtZnQ2VnBXdUJKclBqVzlaZXRvMHR3QkM2QzQ2K24reE12SDhC?=
 =?utf-8?B?bE5STjFWUnkyc3hUcmdMT09qNHJtNVA5NUdCMWQ4eENMVGZyMGJHYWtEQ0Qx?=
 =?utf-8?B?RWtrUUI1QU00M3k4RnpNSHU0ejNleGcxZUNRbEY3ZGNULzBWeVIxeU1TRzFn?=
 =?utf-8?B?SVRFU1R0RWJJTHl0MVJ3WS9qanBFTFUzMzJFSXp5TktMTWxwRVJIQnhKOEhh?=
 =?utf-8?B?SjZyU2NXL2l6Wkx4Vi9rM3pkQ2Ivb245WFJzcVh4V3N4Um5jaEkyazdmbk1J?=
 =?utf-8?B?ZVFSSTNnMzNVTTYvdVZXK0RPNDhXeEdIRVRKaitUb0JEV0lzMzUxbHh3YXVO?=
 =?utf-8?B?SjRoeWg4KzFuK3pvY05IQWlDWVNlMlo1Smxod3ZOOEdOVTBhQ01rRjczbWQw?=
 =?utf-8?B?c1crZldmdS8rdno4OEE5b3E2anc3NnczM3Jvb3pqRmkzUSszRmQraEhmK1d1?=
 =?utf-8?B?NkVIc3pnRlBrVXhoazQwVzViRlV0b3lzSmRUU2xHMFhYMW81VytCYUpMVXhn?=
 =?utf-8?B?T0lWWS9ucy8zRkt2VUNFUHA3WjVhdkNFdHBJRmRVMzIrRVh4R1VWbkt3bUZm?=
 =?utf-8?B?cjNaWXdKMU92V1FVRmVvSGRsN2xwU2NobTI2dmZzeGlNRU11Zlpwa3p6YjNl?=
 =?utf-8?B?bVoybVFTZ2IvZ1RoK2xZTnFUVzRPK0tMYzM0VndXUGJaZlFjTC9xL1N0c21n?=
 =?utf-8?B?ZmJJcktqODBwcnZpK1ZaMTNVdkdqR0MwdXZzb0NFSk1Vb0p6MjV3Q3V3K0d0?=
 =?utf-8?B?YlBVbzIweG1PdWp2cHBZU2tZRCtlOGx3QjJOSlA0WDc0ZkFlaVJnaERPeEVT?=
 =?utf-8?B?QWRnS1RLNmw0UGtYaVRadUJ0L2J2WVZXSCtnc0lVVHd5TzV6dDhGSU14U21j?=
 =?utf-8?B?QVVCWFFhKytNTkNRS0RUZm1wdTBRMENIbFdhMGdYaTA5OXliNXdNYUV1QTZQ?=
 =?utf-8?B?dUZDOHU0Qmg1c0lFQVRaUng3bDVYbUhjUElHcDA5eFM1MXo0YzlLRVhDYTVD?=
 =?utf-8?B?VVp6UzZOTnlrdkdXQ2VxSVBXeUs2L1p6M0lxOVgrZmZzNklVMG5tekFQTHh5?=
 =?utf-8?Q?Hh+ZZLC9FfUc3hseZ74ghk1zeUI5YiSO?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bXhqTTVibWEyQmxrUFdHL1ZrSkpVb2pnUDMvK21MSk13LzFGL0JXTmMyTjZJ?=
 =?utf-8?B?Qm1NcWVFR2VYa1pQaS9zZ0MzWTUvMUtNVytYUWRKYmNtUmxHTUNabUZleE1G?=
 =?utf-8?B?NVArRjRYRmFwRVRxQXBMUWZNbzlWeHNBRGJ3QlkrVHMvVHkzSWI4bU5FQVYx?=
 =?utf-8?B?ZnBaVzYraW1kdDN0S0g4U1RvZVNMNTZBOWwybXk4MFVQZG03RDQ3MEJ5b3VD?=
 =?utf-8?B?UDhGMVMwL09XWXpCTExwelVoWWlqcXV3REE2YU9TazhHcm1WbkYzd2c3Q0J1?=
 =?utf-8?B?a0M1TEJOU1QzTFVweWN6TlMrMjdoa2hGQTRLeEpJMVNlbytIQU0rZ1NWenlC?=
 =?utf-8?B?NDBiZ2swQ1BVZkMzL0dURi9vLzRZM0Q4aTI1dDJyTENycmJiRUVVVDdaYmh1?=
 =?utf-8?B?cS9oUk4yMHd2NFlpcnlqSU94T2IyTWJtbitnL3NjNlhkTXRDQUpxZDBldEtH?=
 =?utf-8?B?TUU4UUxNYXRlazZGRkhFczdCMFhVVlFvZEN5RWI5WFpvRWY3Z3pjUEtXeEUw?=
 =?utf-8?B?WWdtejI5S29XMjFXRUdWdzRYYnlmNExoL1gvUGpkZklCUUNWd2F6ZTZFYU5s?=
 =?utf-8?B?SUZKZm9sYlVJZFpab0lDSlRENHQ5cEpnbE03TFpHQ0doRkdjK2NBYWZvL29M?=
 =?utf-8?B?Wm1XU3pSUmlPbURuV2hSSEI3N3VzNllVc01uUndoZUhaMk1mN25mTUZiVkJY?=
 =?utf-8?B?TUJtRXdiYXNLa1lrL3hjeXlxUGMydHBQWTRaTVhBSWFaWDRkenZmM0RhNSt1?=
 =?utf-8?B?THB4WWNGUGxJWU0rUDF2Q21Ia2JEZGJqTGtGU25taHJseWNvRTdGWE11VnRa?=
 =?utf-8?B?U0Z5eTVFOGRPZHJpUGtEVVhGbTVTWEN2WEpFOU0vSGtLYkx4cW9JZVVCVFB4?=
 =?utf-8?B?OTBYN1pzUmtJS0Rsck80RXFMV25rTEFSTG1YMkt5WW51U3R6cjVuSjRXVkV0?=
 =?utf-8?B?ZUQyRk9ScEQwZGJiTERsK25zbWkzM3NsYmVmZ3VXYzkrcFZlWUJ6TXRUWVdv?=
 =?utf-8?B?UHVuY1JYSm1Hdk5QNk96MlUvYy9DcUpseTkvV3k2ZlE0NlMzck9ISWZNbXFH?=
 =?utf-8?B?bW9jVU1Ubi9yN0lVYnNtNnVzZEdjMElnVXlsK3VEaFJObEtOWiswRVIxb1FM?=
 =?utf-8?B?Ly9CZEZ0anU1R1V0Y1R4akR4dWZFK21oQTU4eEJVcHg1VnJqc0lSK3ZIRmtT?=
 =?utf-8?B?UFlxbWQ2d09icXRYQjluWW45UlZBN1IzYTdyK21kaHZBbWlKVTdMcTh4RTkw?=
 =?utf-8?B?UkFjMzdaSHk0S21rVFZJaUZuYTZ4NEZEbXd4WkxkTVVDVGU4R012dFlqREhD?=
 =?utf-8?B?RjhwN1hwb3dlbnNvVkdEVHUyYVhqYUxoNEVxcDdlZk9wcGc0M0Z3eHgzdTZw?=
 =?utf-8?B?ZnNyVWpBb2FjeTdNd0EvdWlmOWxZMmpLRVI5TkIveG10QmNER2d5T25tSlEr?=
 =?utf-8?B?VTh4OVlaYXFBTC9aZ0FsTTBGZnV1Tno4czFmRkhFYjg1YmVDYUtNSXZEY0w0?=
 =?utf-8?B?UDROblo1eTJCUC80RDNSRm9nVlZHNTFYUnVLa2xLenpxOFNON2FkZXV0T0tS?=
 =?utf-8?B?QnUzVE10QUlWQzRveEJ0NG9NZko1R29Zc0tOaEZKV3ltanRTUEJLNHRiRjBU?=
 =?utf-8?B?VjhtaWU3YUVTTGxwczZpSFYyMkNha3dQanlmTkhmc3NRQjBiaHh3QVpUZVNl?=
 =?utf-8?B?NDZmVlBabmtzTnBySXlVc0ViU1I3bFMyZ3NiQ1B3eUd6WlRmTDRMME5zZVV0?=
 =?utf-8?B?WFBibS9NdE9HeW4zazhBQ3A3azZIUDJWOU1pbnpqRVJ4Qi9SZFNqMUt0cEtn?=
 =?utf-8?B?L0p6TjVRT3JuaFgwd240Q3psVEJLTGZ6TUI3dnk1UjJXb3NOSnBha1JkQnNY?=
 =?utf-8?B?NUUxRTh1NnZXQlc1bmc4TzdtSVRBOU5ucFRGWXllQThnQXhCQS81N2RIN3Ny?=
 =?utf-8?B?UjNFb3llV0d5M2hqcURZSkNtWEIySnNGM0JEbEdVUVlVcU1lc3lDSHJCeDNY?=
 =?utf-8?B?OTJDQnNJWEhNeVlmTzFjMFpJUmdFcGZzS3o3a0F2b3ExaG9oRUFFZ0xTeGFX?=
 =?utf-8?B?TXpPMHN5cHM3UkFBSzdzZ3laWDJXY2ljQjQySVRscFBoRU05ZEZQWFRTemg3?=
 =?utf-8?B?cmtZYUxBREk4RkNUbisvTkNTVmZ3VWU3dGEvcG5kUnhpUTFENlBVc1YzMkR1?=
 =?utf-8?B?QkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5db8ec41-76e6-4950-a769-08de2b9ff376
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 21:25:11.8806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z2TmDm50Mr129WMi/NTi6LS2D0cLAJpy7YLgY4ro2+SNm28/tt+Xz8ZtZR0TNzWAvQgJ5oBYTmMuw7qVv5XOrOJlkcTLXJpuHKpsHoX82+c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5275
X-OriginatorOrg: intel.com

On Sat, Nov 22, 2025 at 06:45:16PM +0100, Michal Wajdeczko wrote:
> 
> 
> On 11/11/2025 2:04 AM, Michał Winiarski wrote:
> > Vendor-specific VFIO driver for Xe will implement VF migration.
> 
> I guess "Vendor-specific" phrase is not welcomed

Oops.

> 
> > Export everything that's needed for migration ops.
> > 
> > Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
> > ---
> >  drivers/gpu/drm/xe/Makefile        |   2 +
> >  drivers/gpu/drm/xe/xe_sriov_vfio.c | 247 +++++++++++++++++++++++++++++
> >  include/drm/intel/xe_sriov_vfio.h  |  30 ++++
> >  3 files changed, 279 insertions(+)
> >  create mode 100644 drivers/gpu/drm/xe/xe_sriov_vfio.c
> >  create mode 100644 include/drm/intel/xe_sriov_vfio.h
> > 
> > diff --git a/drivers/gpu/drm/xe/Makefile b/drivers/gpu/drm/xe/Makefile
> > index e4b273b025d2a..eef09c44fbde6 100644
> > --- a/drivers/gpu/drm/xe/Makefile
> > +++ b/drivers/gpu/drm/xe/Makefile
> > @@ -184,6 +184,8 @@ xe-$(CONFIG_PCI_IOV) += \
> >  	xe_sriov_pf_sysfs.o \
> >  	xe_tile_sriov_pf_debugfs.o
> >  
> > +xe-$(CONFIG_XE_VFIO_PCI) += xe_sriov_vfio.o
> > +
> >  # include helpers for tests even when XE is built-in
> >  ifdef CONFIG_DRM_XE_KUNIT_TEST
> >  xe-y += tests/xe_kunit_helpers.o
> > diff --git a/drivers/gpu/drm/xe/xe_sriov_vfio.c b/drivers/gpu/drm/xe/xe_sriov_vfio.c
> > new file mode 100644
> > index 0000000000000..5aed2efbf6502
> > --- /dev/null
> > +++ b/drivers/gpu/drm/xe/xe_sriov_vfio.c
> > @@ -0,0 +1,247 @@
> > +// SPDX-License-Identifier: MIT
> > +/*
> > + * Copyright © 2025 Intel Corporation
> > + */
> > +
> > +#include <drm/intel/xe_sriov_vfio.h>
> > +
> > +#include "xe_assert.h"
> > +#include "xe_pci.h"
> > +#include "xe_pm.h"
> > +#include "xe_sriov_pf_control.h"
> > +#include "xe_sriov_pf_helpers.h"
> > +#include "xe_sriov_pf_migration.h"
> > +
> > +/**
> > + * xe_sriov_vfio_get_pf() - Get PF &xe_device.
> > + * @pdev: the VF &pci_dev device
> > + *
> > + * Return: pointer to PF &xe_device, NULL otherwise.
> > + */
> > +struct xe_device *xe_sriov_vfio_get_pf(struct pci_dev *pdev)
> > +{
> > +	return xe_pci_get_pf(pdev);
> > +}
> > +EXPORT_SYMBOL_FOR_MODULES(xe_sriov_vfio_get_pf, "xe-vfio-pci");
> > +
> > +/**
> > + * xe_sriov_vfio_migration_supported() - Check if migration is supported.
> > + * @xe: the PF &xe_device
> > + *
> 
> maybe we should mention here (and in all below docs) that this @xe shall
> be obtained by calling above xe_sriov_vfio_get_pf() function?

Ok.

> 
> > + * Return: true if migration is supported, false otherwise.
> > + */
> > +bool xe_sriov_vfio_migration_supported(struct xe_device *xe)
> > +{
> 
> while xe_sriov_vfio_get_pf() returns only valid PF's @xe, since this is an
> exported function, maybe we should add some checks like:
> 
> 	if (!IS_SRIOV_PF(xe))
> 		return false;
> 
> or at least use asserts to reinforce that:
> 
> 	xe_assert(xe, IS_SRIOV_PF(xe));
> 
> here and in all below functions

Ok.

> 
> > +	return xe_sriov_pf_migration_supported(xe);
> > +}
> > +EXPORT_SYMBOL_FOR_MODULES(xe_sriov_vfio_migration_supported, "xe-vfio-pci");
> > +
> > +/**
> > + * xe_sriov_vfio_wait_flr_done() - Wait for VF FLR completion.
> > + * @xe: the PF &xe_device
> > + * @vfid: the VF identifier (can't be 0)
> > + *
> > + * This function will wait until VF FLR is processed by PF on all tiles (or
> > + * until timeout occurs).
> > + *
> > + * Return: 0 on success or a negative error code on failure.
> > + */
> > +int xe_sriov_vfio_wait_flr_done(struct xe_device *xe, unsigned int vfid)
> > +{
> > +	if (vfid == PFID || vfid > xe_sriov_pf_get_totalvfs(xe))
> > +		return -EINVAL;
> > +
> > +	xe_assert(xe, !xe_pm_runtime_suspended(xe));
> 
> please move assert (or asserts) to the beginning of the function
> (and please be consistent in all functions below)

Following the discussion off-list, I'll replace it with
guard(xe_pm_runtime_noresume).

> 
> > +
> > +	return xe_sriov_pf_control_wait_flr(xe, vfid);
> > +}
> > +EXPORT_SYMBOL_FOR_MODULES(xe_sriov_vfio_wait_flr_done, "xe-vfio-pci");
> > +
> > +/**
> > + * xe_sriov_vfio_suspend_device() - Suspend VF.
> > + * @xe: the PF &xe_device
> > + * @vfid: the VF identifier (can't be 0)
> > + *
> > + * This function will pause VF on all tiles/GTs.
> > + *
> > + * Return: 0 on success or a negative error code on failure.
> > + */
> > +int xe_sriov_vfio_suspend_device(struct xe_device *xe, unsigned int vfid)
> > +{
> > +	xe_assert(xe, !xe_pm_runtime_suspended(xe));
> > +
> > +	if (vfid == PFID || vfid > xe_sriov_pf_get_totalvfs(xe))
> > +		return -EINVAL;
> > +
> > +	return xe_sriov_pf_control_pause_vf(xe, vfid);
> > +}
> > +EXPORT_SYMBOL_FOR_MODULES(xe_sriov_vfio_suspend_device, "xe-vfio-pci");
> > +
> > +/**
> > + * xe_sriov_vfio_resume_device() - Resume VF.
> > + * @xe: the PF &xe_device
> > + * @vfid: the VF identifier (can't be 0)
> > + *
> > + * This function will resume VF on all tiles.
> > + *
> > + * Return: 0 on success or a negative error code on failure.
> > + */
> > +int xe_sriov_vfio_resume_device(struct xe_device *xe, unsigned int vfid)
> > +{
> > +	if (vfid == PFID || vfid > xe_sriov_pf_get_totalvfs(xe))
> > +		return -EINVAL;
> > +
> > +	xe_assert(xe, !xe_pm_runtime_suspended(xe));
> > +
> > +	return xe_sriov_pf_control_resume_vf(xe, vfid);
> > +}
> > +EXPORT_SYMBOL_FOR_MODULES(xe_sriov_vfio_resume_device, "xe-vfio-pci");
> > +
> > +/**
> > + * xe_sriov_vfio_stop_copy_enter() - Initiate a VF device migration data save.
> > + * @xe: the PF &xe_device
> > + * @vfid: the VF identifier (can't be 0)
> > + *
> > + * Return: 0 on success or a negative error code on failure.
> > + */
> > +int xe_sriov_vfio_stop_copy_enter(struct xe_device *xe, unsigned int vfid)
> > +{
> > +	xe_assert(xe, !xe_pm_runtime_suspended(xe));
> > +
> > +	if (vfid == PFID || vfid > xe_sriov_pf_get_totalvfs(xe))
> > +		return -EINVAL;
> > +
> > +	return xe_sriov_pf_control_trigger_save_vf(xe, vfid);
> > +}
> > +EXPORT_SYMBOL_FOR_MODULES(xe_sriov_vfio_stop_copy_enter, "xe-vfio-pci");
> > +
> > +/**
> > + * xe_sriov_vfio_stop_copy_exit() - Finish a VF device migration data save.
> > + * @xe: the PF &xe_device
> > + * @vfid: the VF identifier (can't be 0)
> > + *
> > + * Return: 0 on success or a negative error code on failure.
> > + */
> > +int xe_sriov_vfio_stop_copy_exit(struct xe_device *xe, unsigned int vfid)
> > +{
> > +	if (vfid == PFID || vfid > xe_sriov_pf_get_totalvfs(xe))
> > +		return -EINVAL;
> > +
> > +	xe_assert(xe, !xe_pm_runtime_suspended(xe));
> > +
> > +	return xe_sriov_pf_control_finish_save_vf(xe, vfid);
> > +}
> > +EXPORT_SYMBOL_FOR_MODULES(xe_sriov_vfio_stop_copy_exit, "xe-vfio-pci");
> > +
> > +/**
> > + * xe_sriov_vfio_resume_data_enter() - Initiate a VF device migration data restore.
> > + * @xe: the PF &xe_device
> > + * @vfid: the VF identifier (can't be 0)
> > + *
> > + * Return: 0 on success or a negative error code on failure.
> > + */
> > +int xe_sriov_vfio_resume_data_enter(struct xe_device *xe, unsigned int vfid)
> > +{
> > +	xe_assert(xe, !xe_pm_runtime_suspended(xe));
> > +
> > +	if (vfid == PFID || vfid > xe_sriov_pf_get_totalvfs(xe))
> > +		return -EINVAL;
> > +
> > +	return xe_sriov_pf_control_trigger_restore_vf(xe, vfid);
> > +}
> > +EXPORT_SYMBOL_FOR_MODULES(xe_sriov_vfio_resume_data_enter, "xe-vfio-pci");
> > +
> > +/**
> > + * xe_sriov_vfio_resume_data_exit() - Finish a VF device migration data restore.
> > + * @xe: the PF &xe_device
> > + * @vfid: the VF identifier (can't be 0)
> > + *
> > + * Return: 0 on success or a negative error code on failure.
> > + */
> > +int xe_sriov_vfio_resume_data_exit(struct xe_device *xe, unsigned int vfid)
> > +{
> > +	if (vfid == PFID || vfid > xe_sriov_pf_get_totalvfs(xe))
> > +		return -EINVAL;
> > +
> > +	xe_assert(xe, !xe_pm_runtime_suspended(xe));
> > +
> > +	return xe_sriov_pf_control_finish_restore_vf(xe, vfid);
> > +}
> > +EXPORT_SYMBOL_FOR_MODULES(xe_sriov_vfio_resume_data_exit, "xe-vfio-pci");
> > +
> > +/**
> > + * xe_sriov_vfio_error() - Move VF device to error state.
> > + * @xe: the PF &xe_device
> > + * @vfid: the VF identifier (can't be 0)
> > + *
> > + * Reset is needed to move it out of error state.
> > + *
> > + * Return: 0 on success or a negative error code on failure.
> > + */
> > +int xe_sriov_vfio_error(struct xe_device *xe, unsigned int vfid)
> > +{
> > +	if (vfid == PFID || vfid > xe_sriov_pf_get_totalvfs(xe))
> > +		return -EINVAL;
> > +
> > +	xe_assert(xe, !xe_pm_runtime_suspended(xe));
> > +
> > +	return xe_sriov_pf_control_stop_vf(xe, vfid);
> > +}
> > +EXPORT_SYMBOL_FOR_MODULES(xe_sriov_vfio_error, "xe-vfio-pci");
> > +
> > +/**
> > + * xe_sriov_vfio_data_read() - Read migration data from the VF device.
> > + * @xe: the PF &xe_device
> > + * @vfid: the VF identifier (can't be 0)
> > + * @buf: start address of userspace buffer
> > + * @len: requested read size from userspace
> > + *
> > + * Return: number of bytes that has been successfully read,
> > + *	   0 if no more migration data is available, -errno on failure.
> > + */
> > +ssize_t xe_sriov_vfio_data_read(struct xe_device *xe, unsigned int vfid,
> > +				char __user *buf, size_t len)
> > +{
> 
> what about assert for xe_pm_runtime_suspended ?

Technically - we're only interacting with the SW "queue" holding the
data packets and with the control state worker. But I'll add it for
consistency (and to express that we do need to hold the PM ref for the
lifetime of a VF).

Thanks,
-Michał

> 
> > +	if (vfid == PFID || vfid > xe_sriov_pf_get_totalvfs(xe))
> > +		return -EINVAL;
> > +
> > +	return xe_sriov_pf_migration_read(xe, vfid, buf, len);
> > +}
> > +EXPORT_SYMBOL_FOR_MODULES(xe_sriov_vfio_data_read, "xe-vfio-pci");
> > +
> > +/**
> > + * xe_sriov_vfio_data_write() - Write migration data to the VF device.
> > + * @xe: the PF &xe_device
> > + * @vfid: the VF identifier (can't be 0)
> > + * @buf: start address of userspace buffer
> > + * @len: requested write size from userspace
> > + *
> > + * Return: number of bytes that has been successfully written, -errno on failure.
> > + */
> > +ssize_t xe_sriov_vfio_data_write(struct xe_device *xe, unsigned int vfid,
> > +				 const char __user *buf, size_t len)
> > +{
> 
> ditto
> 
> > +	if (vfid == PFID || vfid > xe_sriov_pf_get_totalvfs(xe))
> > +		return -EINVAL;
> > +
> > +	return xe_sriov_pf_migration_write(xe, vfid, buf, len);
> > +}
> > +EXPORT_SYMBOL_FOR_MODULES(xe_sriov_vfio_data_write, "xe-vfio-pci");
> > +
> > +/**
> > + * xe_sriov_vfio_stop_copy_size() - Get a size estimate of VF device migration data.
> > + * @xe: the PF &xe_device
> > + * @vfid: the VF identifier (can't be 0)
> > + *
> > + * Return: migration data size in bytes or a negative error code on failure.
> > + */
> > +ssize_t xe_sriov_vfio_stop_copy_size(struct xe_device *xe, unsigned int vfid)
> > +{
> > +	if (vfid == PFID || vfid > xe_sriov_pf_get_totalvfs(xe))
> > +		return -EINVAL;
> > +
> > +	xe_assert(xe, !xe_pm_runtime_suspended(xe));
> > +
> > +	return xe_sriov_pf_migration_size(xe, vfid);
> > +}
> > +EXPORT_SYMBOL_FOR_MODULES(xe_sriov_vfio_stop_copy_size, "xe-vfio-pci");
> > diff --git a/include/drm/intel/xe_sriov_vfio.h b/include/drm/intel/xe_sriov_vfio.h
> > new file mode 100644
> > index 0000000000000..bcd7085a81c55
> > --- /dev/null
> > +++ b/include/drm/intel/xe_sriov_vfio.h
> > @@ -0,0 +1,30 @@
> > +/* SPDX-License-Identifier: MIT */
> > +/*
> > + * Copyright © 2025 Intel Corporation
> > + */
> > +
> > +#ifndef _XE_SRIOV_VFIO_H_
> > +#define _XE_SRIOV_VFIO_H_
> > +
> > +#include <linux/types.h>
> > +
> > +struct pci_dev;
> > +struct xe_device;
> > +
> > +struct xe_device *xe_sriov_vfio_get_pf(struct pci_dev *pdev);
> > +bool xe_sriov_vfio_migration_supported(struct xe_device *xe);
> > +int xe_sriov_vfio_wait_flr_done(struct xe_device *xe, unsigned int vfid);
> > +int xe_sriov_vfio_suspend_device(struct xe_device *xe, unsigned int vfid);
> > +int xe_sriov_vfio_resume_device(struct xe_device *xe, unsigned int vfid);
> > +int xe_sriov_vfio_stop_copy_enter(struct xe_device *xe, unsigned int vfid);
> > +int xe_sriov_vfio_stop_copy_exit(struct xe_device *xe, unsigned int vfid);
> > +int xe_sriov_vfio_resume_data_enter(struct xe_device *xe, unsigned int vfid);
> > +int xe_sriov_vfio_resume_data_exit(struct xe_device *xe, unsigned int vfid);
> > +int xe_sriov_vfio_error(struct xe_device *xe, unsigned int vfid);
> > +ssize_t xe_sriov_vfio_data_read(struct xe_device *xe, unsigned int vfid,
> > +				char __user *buf, size_t len);
> > +ssize_t xe_sriov_vfio_data_write(struct xe_device *xe, unsigned int vfid,
> > +				 const char __user *buf, size_t len);
> > +ssize_t xe_sriov_vfio_stop_copy_size(struct xe_device *xe, unsigned int vfid);
> > +
> > +#endif
> 

