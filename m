Return-Path: <kvm+bounces-61652-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B8E6DC239D2
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 08:51:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D58BE18861AD
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 07:51:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 605A232AAC9;
	Fri, 31 Oct 2025 07:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aAFlk0j1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D572868B0;
	Fri, 31 Oct 2025 07:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761897052; cv=fail; b=OJIU2f3keXKAVE+QHoz9QB4OHk8dnpcaqskkfwaDdQqQ2NSBT1OxVeQB+8fyyUAPt42QmXHekRHUnfXUAH5pb4Eurav+VZYz+zVkDmm5tHj5IoOaNwcjod1Bt5OlhMoKVr4up+UbNvQFOFMsBnNVsdEefs6Hg+P7e0ApjWI7o0c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761897052; c=relaxed/simple;
	bh=K9oMg2/AdJagPsARyP7+lmEACJVv7cyE18sDcSpdaLc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nJuapse1vARECxywLDDj7lXdESszAoki11Seo/tN5zt2oldYAQbc66BHPbR/a5cPVdB9Kfw4k/qhGcwGxP2TAEZMrAyityW0ioczRo6FsosTIcjELJWSjlGLpqRJxcM5U1qvOfsBKhybM/gRP6fdj71v+XtQz2d6wf0DXein6Bw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aAFlk0j1; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761897051; x=1793433051;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=K9oMg2/AdJagPsARyP7+lmEACJVv7cyE18sDcSpdaLc=;
  b=aAFlk0j15jFgWh6XM62BciKtiNT5D+M9q2n5krw+Eabln6kLadqlUkEW
   fsVje25KCkFbwU+4plgHWd+5uLRl8fS9d/G9DYTGk9ns+vH2rcigqhpiD
   fBUmUvTLp/vHMhnYgUc+nsXBIMZvYQ7+2cnIVKbYipCXpBhS1k8UXw7DB
   Husx6lXC1tcUBZPgwyQmD7ygoZx0Ea9Tt3wuznrwlhcoJieRIBAbZESDd
   Aku9XfkgtFrOKsJ/80M/YASjApIPUkCVUL8K5i8HaRS7jrtobV+b0fTnx
   iJZ/BOG+domU0IH7UxzFjkuPqvlokN2VdUZl3DN5wOUwLCBMOIUc26WHm
   g==;
X-CSE-ConnectionGUID: agkll0L8QLeC7g++hTrnqg==
X-CSE-MsgGUID: vbpTyqb0SNSlEXJiFY5z0A==
X-IronPort-AV: E=McAfee;i="6800,10657,11598"; a="75169366"
X-IronPort-AV: E=Sophos;i="6.19,268,1754982000"; 
   d="scan'208";a="75169366"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 00:50:51 -0700
X-CSE-ConnectionGUID: ya3aX0YqR8WO4ySsuUfxSQ==
X-CSE-MsgGUID: 00+Odd98QM2jtS4HIuqfoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,268,1754982000"; 
   d="scan'208";a="190251369"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 00:50:50 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 31 Oct 2025 00:50:49 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 31 Oct 2025 00:50:49 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.46) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 31 Oct 2025 00:50:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p83ScFxWmAD6KOfTzkdLf+cyBFxTQnuYHQvHIBVuoZ8KanmXHzmdtmNaAzgYaSSf50sCAPYT0ZX+PI5zT81HbR7JqjbJSrgcViwAdesUgdwSbOuLiLyY0I16iGoTK5F+pVPkgD0Wrc0WvvKS/hC34hfk0yaPOfnWOKEPrgE99Frmpt6j4qurRNc2NeGpNlrL+OXwnW1wu/Sq1oiidRKpvgA5HOAC747V91wmczanPzf95tXCsHD3k80qXWNsQX//DyZVs5i0wYflUoCy75JehG3tkIvrAnietlKS9JKk22egnf1mgJNF2riLgjj9NoW8btDYCCBRFToEBN228f8Tjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VcP2KVSEJRU2ELKISkjsaDt8/cZbhFGcc48jRIlB9Vw=;
 b=D4XrtxsXFAFGbHfC0cKsixQAA/yzQl/MlOtHY5CqNf9MBUnMiFkKqPP2J4UoxXxnQKP3x5DPp+/KWkg/0M9ZEzwjQrEk2XESrxTAv4fcnn7hwfWKjXR4qRtNWFNGW6AGHnTw/g2eLFRwfj7k83GKGIUcbNQr4AiKgu+WF0Qx3SOpcf+K67b9a2mlcJcXUjFKwY5IrlOhrj/w/trp4aWuZAxOivmhVyW4yzLr7ojqIHl320pZ5H3HABom31j0Heo7+4o3q5cZ0pzoov/nD+w3mwiqFtw+klI0gLv1w/es1qfvev5AXdelLBojBtwPWPGeWpVGtkmsh8sLEfphoPEFXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5373.namprd11.prod.outlook.com (2603:10b6:5:394::7) by
 SA3PR11MB8002.namprd11.prod.outlook.com (2603:10b6:806:2f6::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.15; Fri, 31 Oct 2025 07:50:47 +0000
Received: from DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39]) by DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39%5]) with mapi id 15.20.9275.011; Fri, 31 Oct 2025
 07:50:47 +0000
Date: Fri, 31 Oct 2025 08:50:42 +0100
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
	<hch@infradead.org>, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v3 03/28] drm/xe/pf: Convert control state to bitmap
Message-ID: <gtnomrunyh72n55y4wg7blgqeuyx5h6y5ddeq7uvbdovnyy67l@fapstjgnvdkn>
References: <20251030203135.337696-1-michal.winiarski@intel.com>
 <20251030203135.337696-4-michal.winiarski@intel.com>
 <612b77d4-236b-411b-9b6f-93c6924e8a1d@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <612b77d4-236b-411b-9b6f-93c6924e8a1d@intel.com>
X-ClientProxiedBy: VI1PR06CA0217.eurprd06.prod.outlook.com
 (2603:10a6:802:2c::38) To DM4PR11MB5373.namprd11.prod.outlook.com
 (2603:10b6:5:394::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5373:EE_|SA3PR11MB8002:EE_
X-MS-Office365-Filtering-Correlation-Id: a0eac95c-81a3-4818-8314-08de185233dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|27256017;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Z251dTVVLzM4RHBqemFsRG4vZTdKR0FCekRiQWZIb25KQWpMeHNlRkNPalor?=
 =?utf-8?B?OG9IdU9jWWZ5eExlZFU1SGJSKzhSWFdSZ1A4Qmo5VHZxdDhCNE1kaEFEc3Fn?=
 =?utf-8?B?aTNIWUNObW1VbTk5REFRUzZzdjREN2ZjSlJZamU0UStxeUVObi9JRVpid21S?=
 =?utf-8?B?YkJ2b0NxRlc3MGRRSk92TnVFTXNRSCsvYW9INUd4TFh2MnNIYXc3Z1BIN1l3?=
 =?utf-8?B?RFE3ZHBvTFZkemFtQ1JZclV6ZWZGbmJQU0VUb3Y4allwSGFzN3BsL0RUcHNG?=
 =?utf-8?B?amRoR0ZuSkw1bmo1elhLM0h5NHVEcXJONGtuL0g0bEI4bTRTbUtRcVJnblFU?=
 =?utf-8?B?TmtrazZmWFhUc1VXSGdaakNJTEVFN2M2cWNZMm50VW84UzBUdjE4cEp3U0lD?=
 =?utf-8?B?UUhIYzBRT043eHpoY3NyWGdrUUhvOUNsZVhDbHN1amFlZnc3cU5USys4dEJW?=
 =?utf-8?B?SCtoT0lzYXFSZ0pkQ0RsTGNLdnp2RE9xYk1kZldpTzZlU0l5R1VRN3ZsM0tQ?=
 =?utf-8?B?YWt5MjA1T3VhNThJVUx1aUxwSTZtdXR2MXlGRTVaUm1PY1o1aUtnVEdJVk44?=
 =?utf-8?B?NHZ6ZjRIYXdpSmwydzRqNXN1LzJlaTJUekJMY1FFZ2ZGRkZGT2g0TUoyeDJD?=
 =?utf-8?B?cFpoeDBLMjUxUVd2V0c2cFBaQUFKdTNpMGM5OFRwWkExSTNGa0xkVGZtUTdk?=
 =?utf-8?B?RU1CSjBWRG1nNjdlMkZmdzVPSThveTQxeXd3dnFuYzNHYjRaWWYzYUZQRkFC?=
 =?utf-8?B?RUhLd29SUzl4M2ZnZUR1eWNSVStsOUVXTGtCWmxSalFVNlJncmdyeW1lWVk0?=
 =?utf-8?B?Z3Q3M0pHUURPeGx6R05GSzJETzdJVmFlRkRhSTBxQjNrTXV2MkVGdWJhNEMz?=
 =?utf-8?B?V2U5WC9rUGIzQ2VTcENpK2NjQ3RQbHRwWmpQY0kzRHY5ZmZpV1NLODd5MnE4?=
 =?utf-8?B?ZWZLbmtEOVNkdXJWc0Uvb3ZVeTNnM2dPTlB1ck0vdEdpb1hYZ0lNbUlnZE1U?=
 =?utf-8?B?VnFPRmJncHZRcVdvcUtCTGlzOVZBMGVMZ0V3UmwwMGhyTzdsMS9ycUdXMTNm?=
 =?utf-8?B?RmFYRC82MUxVdlpNbkVjTG9KckF6UFZqQUVIVG9KeWtuV1RaakhYdUlQUE1o?=
 =?utf-8?B?QlpOdWVldnBMbWtDQzNNTGVRY0szaWJHbVB5ZlpWWTRHQUJqbTQ1VjlxR1Ew?=
 =?utf-8?B?RmpUYXpDa3JIZXBSUXlKTVNxcUlRYjRtUkJleGlaUlJXcFM2RTlvc2cyUFZD?=
 =?utf-8?B?K1FodHVPWlYwZUI4RFVzZ214MVcweE9NS25ma3VVaGxmYXlrL0xnY0RPWnY4?=
 =?utf-8?B?N21VR3BVQkpQRVFqS0R0YlZaaThpSG5tWDU4U0UzbUhEeVM1UDd0eC9Ca2JI?=
 =?utf-8?B?cnhSQVNWNGE4KzJwLzhkd0xOczV5NHlpajI1emlpT0lrL2s3RytmOWlFNEZI?=
 =?utf-8?B?Z3BsWkMrbi9ienoxczlnSVVDZmdMVi9ibW5ZZTQyTkl5MWhZN0JMeDROT3hB?=
 =?utf-8?B?RUJJMTlBczFMRFVaSDNpd3VMamNBSjJjUXFrQi9DdW9KQ2NYUkpDUjRYRTRx?=
 =?utf-8?B?L1dWeDdYZ3BMYlZzNGZiV0xuYmpsb0FHNUtzaHR2WVJtaHZ4bUJaQVFhUDN2?=
 =?utf-8?B?cmg0RFgzSUFmays2dTBNYnFrbHJHdGlwZFdyWjVOcHkrL0hkaFhCN0FLQVhW?=
 =?utf-8?B?b09IZitmMCtidnhEMTBjaEl2NHh6Z0tGVHlPMmF6aXdEVmRCb3BWUFJ6eGdE?=
 =?utf-8?B?TndHeStqU3dIR3FsR0k1RmVBRklNeG1iZUpUSllXdnRldURyODVVM2dUMGtG?=
 =?utf-8?B?bE1TT2cxbFVpMVpQQk82RlNQSW8rbTRLYTJ3YXRPQVYybHRaWExtN2ZMczh0?=
 =?utf-8?B?YUY0aVJ6QTZGcG1pQzFLRllSdUlLbDlkZ2I2U0lKcFJCYUhEdjJUcjZ2Vm51?=
 =?utf-8?B?Mk4rR2NIMTFtNVJsaHlNU3VXbFNQMGxNR1o1SWIyeE4wUys3SWdtRG80bXIv?=
 =?utf-8?B?bFljL3BvZFh3RkdHeDZEVlZmdE4rbVRvVGpvWHlwSW91MDczMmd5RmhKK2VN?=
 =?utf-8?Q?piQ8fX?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(27256017);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z01SaE12b3NUVHVXSm0rYmI0aDkxUitkcCtINGUzUjZMdXlpQWlHZkVxUklK?=
 =?utf-8?B?cEhiTWtKY0doNzIvdVlxaU14OStnRlJVMDRpcm1xVUExUnZVQVdPMHQ1OXJn?=
 =?utf-8?B?cUh6b0lUUjBXTDQ5b2oxM3VlYjByYUZoaEowd3V2T1BxSlpQdHU0b1VZNjlu?=
 =?utf-8?B?UXpza2dtUk9QbC9jS1JPZmduU0dXVmREODhWc3dUVnM4bnhDeERYMXIvNENh?=
 =?utf-8?B?N1RpQlZ4S2hUUWtaNDVscThmalRPU21aRGIyUnFuSWo3Zm44M0VpclBIUjVa?=
 =?utf-8?B?VDczTHZsd0FCd2Z0SWJoVWJhQS9VN0V0MVpwcUlTUmFZd2NjNTQ1ZlJWL3Mv?=
 =?utf-8?B?OWVqa1hUZjcwSXJYTjhPTTBZSWJlR1kzUUQ1elUzNlAveHd3b0JRaXVHVGF0?=
 =?utf-8?B?Q3JTRmdEdW5Vb1l1Wk15SGh4a2twV0FQR1VTK3RmZ0pMalJkN1ZEeGZESmRN?=
 =?utf-8?B?VUVhaHltcEJxVW1SUGVEMHFtVDVRVkkvRTJVbUJrYWE2QzErQmVhNFBTSGFV?=
 =?utf-8?B?eG9pVzA0MzVzYWFyNTJRUEtGeFVnK0g1U3pVNmNZeTRHUGNmNFRwcHlDS0V3?=
 =?utf-8?B?SGlmeGpqaEx5R3lTK1lCV0UvNGdCZy9odXNyTmxQMEloNGJWNGliM0lTajMy?=
 =?utf-8?B?cGhDeDlKZzEwZXM1bnZPMEhiS3J0VUk0dnAvK3JBSm5xMU1FZ3JRSlV6amlU?=
 =?utf-8?B?UGxrYVdQY204bHg4Wk9LUFJCMjBGa1h5N2ZoYTdrdlJnQldmNE9ESlI2cmM3?=
 =?utf-8?B?Q1A0RURoZzFJNzdlMUMvWmovOUdwVUxDY3dDbmlUUG5hQk9rL1UzMzZocE03?=
 =?utf-8?B?VndNeEl6OHZ3b0NZODhZMUZ6Nk9DMytpNE1NTFdrc2tuRm0xMmlvZHNjM1JY?=
 =?utf-8?B?L0dZRm1nYms3YjdFdC9lQloyU28zTVFrclpkNTI3SGM4dDFVZmkySjI5TGVo?=
 =?utf-8?B?dnFkS0h3ZHArZEZ4ckJScThCZGlkbEhGa3ZCajFUU2puSDJTZEI3UXZ4NUpY?=
 =?utf-8?B?MnFBd3AxMDBac2VIbm1ONTdjczVxNy9qWTVKNkZhay9yZ1dRODIxb0dRYXZr?=
 =?utf-8?B?Yk1nWnB0ZGpQUkIxeC9sQ0N3ditETFJDYWJSbHkyOG9vbWZBVFRtd3h2U0ww?=
 =?utf-8?B?bkkvWUFOSlZqVVlHSHZ5aXNhV1Mxd0RmNi9hakowQitkUDRuVzZpWU5COWZi?=
 =?utf-8?B?azh1U0FnTkIwdUFHenhleEdXem5MQmg2c0svbTN4VkxpL0p5SXdhd0NrMkRi?=
 =?utf-8?B?OVNCVmg4dFNLd2NVWGtxUzFzb053WnNFUzhCaC9FMTIzNElEYlZpbU5veTFu?=
 =?utf-8?B?cTE2bzhrSlZoQVJZM0ltRUI0L2MramtqbWlmakc4Qkl6Qkg4ZmN6OWFuTHNs?=
 =?utf-8?B?RGdDRHVVY1hrQmpER0dhZVZRMktFelhkV3Q2U0MzVmpaSjRqUm1RK3I3bHh4?=
 =?utf-8?B?OUFRNFRNWFlWZWVXSVBGZXNuYnFsRHRjWVJrQVFaVm5Yd1pJcTMwc2d0aWZ0?=
 =?utf-8?B?QmJwOU01M2lWSEUwV0NodWhhV1BwU1UxQVBkUTBKRzJiTHZqaGdSUGdLOTZk?=
 =?utf-8?B?Nyt3YktXMzYvVWJLb1dZajBZb05LTWtyVEZqVlNuWG90WE1jQlFlY2JCemR4?=
 =?utf-8?B?eWhNa0xqL2Q3c1JzaldEbEFOYjVYRHp0YnY1eVdjVmZSd0VRRkF4REZvUHJx?=
 =?utf-8?B?QWlQWHBEVjU4dGpvaGNNODJBSkdNVmVRcm1lWHQyK0pKclV3U2FZa0hsd2ts?=
 =?utf-8?B?cWpDclI2ZjQwV2E5NlcxRE9KTEtpZHI5V0NmVTIrcENQTGw4cDdGR1NyK0Mx?=
 =?utf-8?B?bVRpYU9yWFVPcS9KM0x2UDJWU3RVbFRleEVlNUlXbDNrTkp5S1haUWN6ejNT?=
 =?utf-8?B?ODE3N1ZaeFUzUGVrd3ZtNWQrSENyQVhkWHV6K3Y5WTJsTENaWTRVQjdXRzZC?=
 =?utf-8?B?b2ZjVjlrZnkybHhYazZaMGZZN3diQjlkVG9QWWJ6MXpvVkI4VG1EUlhQV3hT?=
 =?utf-8?B?dzRQekxUbUlkSWsyck9EY0toOXpBU2lodTZvRjBxQmRrb2FvVGw0Y0NOWkFR?=
 =?utf-8?B?NHkwTDhnam44cmVkVmNNa0MwVnZBbDFDNXAzL0pRRW43U3Q2MWgrUGIrR2Ey?=
 =?utf-8?B?Q3lTcXhtVUhUMFVGdVU0V2VBb1E1czg1anEvNWh1WnNRWENtVmFodFcxcCs0?=
 =?utf-8?B?V1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a0eac95c-81a3-4818-8314-08de185233dc
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2025 07:50:47.2100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bPfd33FM3Q1+c+Xr5U8YuEX1JsYLLvUnvRXVO+vro5s5toYtD+mGMPJxYdb0wxt7NYpXNSV+9LPE62PuBihZI+cGyQnB5eDOjX4KHMQoqmU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8002
X-OriginatorOrg: intel.com

On Thu, Oct 30, 2025 at 11:57:28PM +0100, Michal Wajdeczko wrote:
> 
> 
> On 10/30/2025 9:31 PM, Michał Winiarski wrote:
> > In upcoming changes, the number of states will increase as a result of
> > introducing SAVE and RESTORE states.
> > This means that using unsigned long as underlying storage won't work on
> > 32-bit architectures, as we'll run out of bits.
> > Use bitmap instead.
> > 
> > Reported-by: kernel test robot <lkp@intel.com>
> > Closes: https://lore.kernel.org/oe-kbuild-all/202510231918.XlOqymLC-lkp@intel.com/
> > Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
> > ---
> >  drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c       | 2 +-
> >  drivers/gpu/drm/xe/xe_gt_sriov_pf_control_types.h | 5 +++--
> >  2 files changed, 4 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c b/drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c
> > index 9de05db1f0905..8a2577fda4198 100644
> > --- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c
> > +++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c
> > @@ -225,7 +225,7 @@ static unsigned long *pf_peek_vf_state(struct xe_gt *gt, unsigned int vfid)
> >  {
> >  	struct xe_gt_sriov_control_state *cs = pf_pick_vf_control(gt, vfid);
> >  
> > -	return &cs->state;
> > +	return cs->state;
> >  }
> >  
> >  static bool pf_check_vf_state(struct xe_gt *gt, unsigned int vfid,
> > diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_control_types.h b/drivers/gpu/drm/xe/xe_gt_sriov_pf_control_types.h
> > index c80b7e77f1ad2..3ba6ad886c939 100644
> > --- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_control_types.h
> > +++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_control_types.h
> > @@ -73,7 +73,8 @@ enum xe_gt_sriov_control_bits {
> >  	XE_GT_SRIOV_STATE_STOP_FAILED,
> >  	XE_GT_SRIOV_STATE_STOPPED,
> >  
> > -	XE_GT_SRIOV_STATE_MISMATCH = BITS_PER_LONG - 1,
> > +	XE_GT_SRIOV_STATE_MISMATCH,
> > +	XE_GT_SRIOV_STATE_MAX,
> 
> while this feels handy, this MAX enumerator is not a real state
> and as such shouldn't be passed to any function that expects
> "enum"
> 
> since we know (and want) to keep MISMATCH state as last one
> (aka top bit) then maybe tag it and use separate define:
> 
> -	XE_GT_SRIOV_STATE_MISMATCH = BITS_PER_LONG - 1,
> +	XE_GT_SRIOV_STATE_MISMATCH /* always keep as last */
> +
> + #define XE_GT_SRIOV_NUM_STATES (XE_GT_SRIOV_STATE_MISMATCH + 1)

Sure, sounds good.

Thanks,
-Michał

> 
> >  };
> >  
> >  /**
> > @@ -83,7 +84,7 @@ enum xe_gt_sriov_control_bits {
> >   */
> >  struct xe_gt_sriov_control_state {
> >  	/** @state: VF state bits */
> > -	unsigned long state;
> > +	DECLARE_BITMAP(state, XE_GT_SRIOV_STATE_MAX);
> >  
> >  	/** @done: completion of async operations */
> >  	struct completion done;
> 

