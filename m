Return-Path: <kvm+bounces-45560-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 41131AABBE1
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 09:50:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 19CCC3B884B
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 07:37:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C10932248BB;
	Tue,  6 May 2025 06:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cz2Ld+qi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0360B35975;
	Tue,  6 May 2025 06:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746511660; cv=fail; b=Ia8XBhpmMFVWZkiR8PV4Xxdhn7ly1zhn/mIWK4qE4CktOHU8r6tfIFkn8QXmQpw5HLqk490zU1s5iSTY19aIXmxE5NybSiOOaFu/OOrcpMiXXea70c2nYlhPCXwsG4YF+wT5MWZH+fS+j9DiL0YdhX+88gRUfHrU9/2jt2es8P0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746511660; c=relaxed/simple;
	bh=xGwKqCcUPLJBvUUGJ3FQ10Qsym2ZOIVIUWyYvPH1rX8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=g4uqW94GUg7VO3C/GEY9iD0CIPIxFfIhp2SS1gMct9Vr9iT+sFaP/W+IYM8dTNIMEv//mxv+sBHuidWvAXerU9waZnYVyyrByxEZFW741biaHOpkeZ28jv8VNsWTpHDUd4ONxZqQu8o3wIgHZS/uBi8dgWU0+61XetJ0rxSnnSs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cz2Ld+qi; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746511659; x=1778047659;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=xGwKqCcUPLJBvUUGJ3FQ10Qsym2ZOIVIUWyYvPH1rX8=;
  b=cz2Ld+qiepHucP0LMsTCMlI69PCRBiWytISLrn3rNAAJ7AoTUdomyhvK
   HJIiU9iIxEXodzmF34KYTrlzwHfWeobx6Di3Xg/rMdKHnYoYwLCEfj3m7
   fr5N3JJ6hkmxD+EI98GMUcxRAfdp/Ow8yeEiqWjiWGrNIgVcblOldEGrF
   LKeGon/A+fMie7NYF6xT6j1cCZ6Yre6aYb6vRADEODuSIO6vMNq8+MLeU
   4hQJUywDOA2TAmcg+cb3eqUjbHnSL3btjqakZRHFHFX90BlfBP/v/MxES
   AZtggO7vlbhVDFocGwAbkOFLGQUqMbeN12upWOZQHDQC4Ezo/pe55lDeN
   g==;
X-CSE-ConnectionGUID: zlRpZ5VBRD6jrEIOvohVzw==
X-CSE-MsgGUID: OZMond4ATB64uIr5p/3xIA==
X-IronPort-AV: E=McAfee;i="6700,10204,11424"; a="73553657"
X-IronPort-AV: E=Sophos;i="6.15,265,1739865600"; 
   d="scan'208";a="73553657"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2025 23:07:38 -0700
X-CSE-ConnectionGUID: rnXsUPMGSeW3/u8+GX2MVA==
X-CSE-MsgGUID: bjqbFLV5Sh++dRg8mi013w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,265,1739865600"; 
   d="scan'208";a="158749141"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2025 23:07:37 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 5 May 2025 23:07:36 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 5 May 2025 23:07:36 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 5 May 2025 23:07:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x8OQG0W9EHjXZH4mZOfNmR6JDELOID/c+vfsbNBOkCuge2Qzz8DQtxvbY9RyBlxYD92q2p6pKAzV8WF7cU9pi2dZ7pu8InXXMhObEObX1aQxM3Vc+pRQk3YY9ETagi8T8z5D+TWJ5z+wcBQ1IfoRB/pONnjTTiEUvQA3FuB0TyuAO3ZpUcvqscBRg093d4ftTXVH1P3LiC6y3S7fTf+fL+D3UKWNbWB0X4JvOu5jVdAg5q7+pKa02A47uL4VCdSC3k4iJph58JAbNNhOHDp0Grhmvm7+4flah4kpZylI28N8hG7jWn3C51HvBLOLQpq5JmzkIo0s+mmotfSiEZ8Gug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qJaqlIXLf357U2JlmdqeTGcIHNhFEFwC7+8EWkjlolM=;
 b=N8Fx6JcghbosEn7ub/XkmyWBC23edu04PjqLqBUdiSu3ou08TBqLUPMoAFcElrZTPnEn5x8fO/YCNYVt1OCkUZnyKvYT5bnbx0gFvxthVHRSRhQbj7yD+q9REFg9/CU/eeHv/QlDozS+eTU06cJ94dz/xh7mQPhSt7thp7U3tT1/mhNxE3jS/ljor7CZZbgOQY2QHGwRfmkBtASR2YyNuTbvcq2lWryeXT+GXpKrd8vSI5d/lBcBLXCb9MD1rU2LBLyjMdD2YhCVWpEmIcQ48hM/UO4VVrS4tg1EpvzttcsSqMOUP1TGTbYBL0LlYnNZOw2sXTOtWjypgwLIzATwDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ2PR11MB8403.namprd11.prod.outlook.com (2603:10b6:a03:53c::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8699.26; Tue, 6 May 2025 06:07:02 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8699.024; Tue, 6 May 2025
 06:07:02 +0000
Date: Tue, 6 May 2025 14:04:58 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Vishal Annapurve <vannapurve@google.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@intel.com>, <tabba@google.com>, <ackerleytng@google.com>,
	<quic_eberman@quicinc.com>, <michael.roth@amd.com>, <david@redhat.com>,
	<vbabka@suse.cz>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
	<pgonda@google.com>, <zhiquan1.li@intel.com>, <fan.du@intel.com>,
	<jun.miao@intel.com>, <ira.weiny@intel.com>, <isaku.yamahata@intel.com>,
	<xiaoyao.li@intel.com>, <binbin.wu@linux.intel.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Message-ID: <aBmmirBzOZfmMOJj@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030603.329-1-yan.y.zhao@intel.com>
 <CAGtprH9_McMDepbuvWMLRvHooPdtE4RHog=Dgr_zFXT5s49nXA@mail.gmail.com>
 <aBAiCBmON0g0Qro1@yzhao56-desk.sh.intel.com>
 <CAGtprH_ggm8N-R9QbV1f8mo8-cQkqyEta3W=h2jry-NRD7_6OA@mail.gmail.com>
 <aBldhnTK93+eKcMq@yzhao56-desk.sh.intel.com>
 <CAGtprH9wi6zHJ5JeuAnjZThMAzxxibJGo=XN1G1Nx8txZRg8_w@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGtprH9wi6zHJ5JeuAnjZThMAzxxibJGo=XN1G1Nx8txZRg8_w@mail.gmail.com>
X-ClientProxiedBy: KL1PR01CA0128.apcprd01.prod.exchangelabs.com
 (2603:1096:820:4::20) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ2PR11MB8403:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d31d060-89fb-4ba7-7a4a-08dd8c643808
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?d0tqL3dpZkFWVVlrekJEZHZoOUsvQ3N0NmNvWENpeHJDd0xQL1ltY3ZxMjUz?=
 =?utf-8?B?cVpSNk0xTUlMZFJ5WTJwL1Y5OVJKeCtPT3d5ZjZ5ZWJ3TFJDejVFS1BHK2ds?=
 =?utf-8?B?WTlVUUt4WUJjVmpob3lqU1dvVGJzNElrTFdBL0Y5SG92ZThPK1grUzkvTWJD?=
 =?utf-8?B?Vmd5ZzkrMjFmdnp2KzY0YXhTdlNacE5GNnhZNzE0OWRsS0hQaVRLMVI5d2Ix?=
 =?utf-8?B?THJVY3gxQkJydG9kejdQZytTM05vNXBLUm9QYWZWK1VnNmhaTnB5S0xlK2U3?=
 =?utf-8?B?ZGQyTkdvcGdqWTVlVjQzT1VsRGx3TG1LTGZrWFJoNW5QaVpUYnJ3U1NwbXBk?=
 =?utf-8?B?NTA5VklRcUp2dTA4M2pQQlRpMHhhU2pQbXFWVmhMMEVYV1ZLNU85S3F0N2d0?=
 =?utf-8?B?ZzJzelZpUjJMMVllbHhOV2Z1cmZVRU1SQk40OEtoQUZkR2t3QW43bzZIcUFY?=
 =?utf-8?B?WE44a0toOHlCNmxIc3I2c2oraFg1WVk4dTFIUmhnL2tlTHU3UkQzWXR5NUJZ?=
 =?utf-8?B?c3Q1YUYraXJrVFZ3SFNrcmZJcjFYbUJud1hYQStndEw0VCt3ZlBtS0I4d252?=
 =?utf-8?B?UE02UUhaRUp2Y044cGJqK0NjSmowWmN3ZTNDNzNoY3lDNVV5K1EwQ3pKczY0?=
 =?utf-8?B?dEIrSnl2ZkxscURPM2t6eXhNVkh0V2JRYVlTNEVuOUpHeTR5MXMrdExNSnBp?=
 =?utf-8?B?WlpsUk44d05VcXNVMnk3dlFvL1MxMXpqNkhnWWdac3V1a2w3cFhVaDRtMHdh?=
 =?utf-8?B?MGlaK3JXdnJCVHVuMFZYUnd4WjJ0Yy8xcm5nNkVVcDVkMWJ3TkFLVm9xMFBh?=
 =?utf-8?B?N1lrUDBNbjI3aHpKa1BkV1YwYTA2UVJOOUY5TkFGVW1iOC9iVEY5Znltcm9T?=
 =?utf-8?B?WnNVTFo1QXBlQjlpNmFVV1JHMlZkY29TaVNSNnRJak51VnNnekR1bFJJZ0Ix?=
 =?utf-8?B?TFBXMjU5eU5ueU4wM1BEeXdvVnhUSTA4Z3ZPODhIR05aVEl1Lytwc1NtV3VM?=
 =?utf-8?B?TWdXaUFrM2VlVlJtUkZaREg1dEpkY2NIVU5uUmVSYy9lM25SdUl3bVVPTVQx?=
 =?utf-8?B?dkpvUWI3VVhBMWIrazlxZzFHNkV1bFRGVTBtekJZbzNrUzBTcHZkZTcyc25a?=
 =?utf-8?B?TnhCTWd2YWpYb05pdi9salZwd0MwVzIxcDdpUjhXcStCeE9UVWtoeHpPQWdu?=
 =?utf-8?B?WHkwTmwwOGtIOHBxZ0R5bDNlK1czL28zbkIrSnJwNTExWVBzTENKYlJpU0Rx?=
 =?utf-8?B?M241eUxrSmtqdXFvb3pjdklaUUY5cWtXWlZGSytEVzFBMFdiMDNlTHhmMjdk?=
 =?utf-8?B?QklPTmVVWGdNckpOMU9mT0pqQm1CVElkY3YyRmdGamdINUpURldzRjB1Tld1?=
 =?utf-8?B?MnNPeHh1R3lYalpzZDVYaWhscjhwOUtaSlZTSnp3d2VGbG1oSHB6UE1FNUhN?=
 =?utf-8?B?UzVxU3BmU3RVUUc5dEV0WFpGcG1QQmhUazMvNUNEUnR6TTFGOUM4b1UyVldu?=
 =?utf-8?B?M2k2bUpydDhkdmJ4bEhHQ1hPMGwyMkgwbU5pc2NlRnF3Y00rSUZCU3RKbkg0?=
 =?utf-8?B?MXNWMUYwYlFKR2p5Z2duNWpPQXBhQ2x1VnQya0IyckoydE9DRHBFb2Y0NHp1?=
 =?utf-8?B?cE9uTkoxSGp0VEMxWVh3dnk4L2huUExHdDIwZ2NBUGlDWDFIdmYzQWRVSm53?=
 =?utf-8?B?V2xtMVJjTGprd2ZsOVM3cnVSNVBMckRMQU9jaUdLRTNFdDJmUjRNcGlRdlBS?=
 =?utf-8?B?SE54V3V1d2FYeFYvUFE1b1hHQnRGaG5LN0dma29Nd0IyY1oweUFkSHJ0YjhJ?=
 =?utf-8?Q?XFOBtRuAgU5ieKiPZzzUbCzOzzqpZYIr/8Vj0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y3FWczdWNGxSMzdzd0FnSmpZQ3Azbzd0V3djYndmZmZ0eHMvcTBoR3lOeHoz?=
 =?utf-8?B?azcxb09PeFdZQzhBZWZjMjh2em9ZWks3U1BmNitrNkFpWVNVdzltVmYwYXQz?=
 =?utf-8?B?WUhrU2tjY3B2VnBmazB1VGFCbVJaNVBDZDg2WkhBL2YyTW5TeDdRTzVQTFMr?=
 =?utf-8?B?YStqL2R2K0xIU2VoOUJZU0pyZUh2Q0VOQmw1eTFnaE4xL0dORDFTKzNLKy9u?=
 =?utf-8?B?K3htWXJKYkg5dHNJMFQ1MzdmUHZzSzN6eElJd0JoeHhmZHlPRzBYWlhQR2tJ?=
 =?utf-8?B?dERkKzJMenZ1cVdldnZ1bHhWcmZrU3Zxc2dnQUpNZlVQWnhZOE5mTGF2Yi82?=
 =?utf-8?B?d0tRYVVFZVM0VlVHNGc5MlNNVVdwN3gvRjRxYy9rZ3A3Q3d6ZTR6R0o4Ujky?=
 =?utf-8?B?RkxmVUZBVzQxTWI5L2RnWkg1NnMrVUJjSHRZRnVIR29Pb2NVWFBaSVhCaFcy?=
 =?utf-8?B?SEVzU1RmMGxjTmFTOWVyMjZFR0paZWgreElSR3kxMkZEbzV3Z3lFQnN4R3l1?=
 =?utf-8?B?U0JIM1MyR2R6SC9hSVVEcmM4Tm1sRW1IdW9kdkxHbVNtNERFRDBudjkwaU5Y?=
 =?utf-8?B?Q0prUWxGYnB0WmlTR0UxWWtvVkhrRm9jZEJ6RlVUenBQdFRYQ200aVArZmRZ?=
 =?utf-8?B?bjhqa0V1RnAyQUNyZDJaRDVicjFKME5iNlZtQXhTQWQzaXBOd3R1Zi9GSjRm?=
 =?utf-8?B?YlhxQlNRVllXN2luWTQvRStTc3pSVjF4dGlRc1J2QklSWDhJWlhFSEFEWkxH?=
 =?utf-8?B?QmFtcTFpS1FLcExQc2ppQzdDNU84Y1MyMDlGWnZPTTNnWWNpZGQ4MHdXN2hN?=
 =?utf-8?B?bDF2Nm9RN2dhQlc4OGZpSTZXL0ZwUXE1ZWdnNW1aQ0IwSm5XNS8za00yS1cz?=
 =?utf-8?B?dFdmRDVMeXV3MWwwMGtSUVIwanpuYkNSMHZiaWhkMGdMMzhGVS9pWDFwZTVC?=
 =?utf-8?B?Z3VTdjlEdVpsVXlZUzZtNzdWU01LWjhCb3RnYjJjbXBDMTF2K0pLOFEySEJz?=
 =?utf-8?B?UUV6TzJLemt6bTZPRTFlQ3FOSkpYZ0VUWURXL0tFOERiWEUrUlpQVG1ickxC?=
 =?utf-8?B?eHdKVnU0OTVyclFQZHZHK1FKaE9iY3FjSmRyU1EzK0h3MXZqZk5ld2ZsNm50?=
 =?utf-8?B?aEZLUjRjb20wVzQrRlRCVERLeTlDZUtFYUNROXFwVlZ2emlOWHJDR0JTZjBi?=
 =?utf-8?B?S3o1ZkhEZVg0YW5SdXByeFA3S3VMU21UUEF5dGNWZVZWaFJ1aFFCWklBTTVB?=
 =?utf-8?B?ak8wcjdHMjFtK1VwazN1N0RITTFYRzZjOWVVd1R6UGFscWhMTXByQW9MdkFH?=
 =?utf-8?B?M1FobkdsZGRKalo5MjhXNUZyTXRyNllRT1prSlp3S0s5VDA4YjI3TFdZemNx?=
 =?utf-8?B?N3FLcTlWY2t0TGpoWHNlamRuc0JFaERTZ0d2RFpNcEUyY2RocGRmeGg0QWZY?=
 =?utf-8?B?WkFoNFVsS21oNlNtYlZpN2tzTlYwRk1MZDJxSENlcDM5QUlJSmVhcnBJU3lq?=
 =?utf-8?B?VDdDZ0oraUQ1RVZWOGF6NzBMZXdnZENJNlc2YmdkbWdYMXZDQ3NnZjYxK1po?=
 =?utf-8?B?YnFlWkt1MU03a08rZkZ4b1UwWVZPVWFTc3djQ2F0T2VmeVAzelk5alEzbXh0?=
 =?utf-8?B?NnBNS0w0VEsvVG9FOUNKVHNwUVpCSkszTWlKWkFyQ0RJSUs2cml5V05lZFRB?=
 =?utf-8?B?WnVUMjc3NG40ODlHRGxzbnFpY0tzTTZZU05XYm1aSk01U1JJanJmSmZlUEVT?=
 =?utf-8?B?MXJiTVM1VGUxMzRUVTVBUlZLaWZmbFlPTkc4QjhrK01VWXFEWFhraXg0ZTZT?=
 =?utf-8?B?NUVNV1hYNGUrQzdaamZMQWoreTBMMEFrTTh1TjdIWmwwY2ppdWVqc2taNDhE?=
 =?utf-8?B?ZWd0N1d3SFVDcjU0WUZIK1VCcWZubHFsTStSdVpseUtmQ0NTK3ZCcEQrWW1C?=
 =?utf-8?B?d0V1SDFGazN6ZlI3SytvY05MdVMvODlOUkMwVEE5QzI5MmFaam9nWE9EMHFI?=
 =?utf-8?B?dlY2TnpHVXdKM1JwSnhWVzFXS3BCYzM5Z0JzdGM3TkQ0UjZ3cVIxRzZnaFpG?=
 =?utf-8?B?cThTbUFsSW5RQW9hYis5UnJpWWp4WVNDQUVMVThTQmpoL25wTEhGZC9JWVA0?=
 =?utf-8?Q?ZxY7sO0idNa+Nnl8nXvsTB9P7?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d31d060-89fb-4ba7-7a4a-08dd8c643808
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2025 06:07:02.3058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tfcfSqmLOLA8vW4+ffp7pwBYaYAUgCgxWj1cmjOEAeMZXYreTcfhXhnFUGO9oQen1G2/JjE8QfdDsGjGfz9ROg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8403
X-OriginatorOrg: intel.com

On Mon, May 05, 2025 at 10:08:24PM -0700, Vishal Annapurve wrote:
> On Mon, May 5, 2025 at 5:56 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> >
> > Sorry for the late reply, I was on leave last week.
> >
> > On Tue, Apr 29, 2025 at 06:46:59AM -0700, Vishal Annapurve wrote:
> > > On Mon, Apr 28, 2025 at 5:52 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > > So, we plan to remove folio_ref_add()/folio_put_refs() in future, only invoking
> > > > folio_ref_add() in the event of a removal failure.
> > >
> > > In my opinion, the above scheme can be deployed with this series
> > > itself. guest_memfd will not take away memory from TDX VMs without an
> > I initially intended to add a separate patch at the end of this series to
> > implement invoking folio_ref_add() only upon a removal failure. However, I
> > decided against it since it's not a must before guest_memfd supports in-place
> > conversion.
> >
> > We can include it in the next version If you think it's better.
> 
> Ackerley is planning to send out a series for 1G Hugetlb support with
> guest memfd soon, hopefully this week. Plus I don't see any reason to
> hold extra refcounts in TDX stack so it would be good to clean up this
> logic.
> 
> >
> > > invalidation. folio_ref_add() will not work for memory not backed by
> > > page structs, but that problem can be solved in future possibly by
> > With current TDX code, all memory must be backed by a page struct.
> > Both tdh_mem_page_add() and tdh_mem_page_aug() require a "struct page *" rather
> > than a pfn.
> >
> > > notifying guest_memfd of certain ranges being in use even after
> > > invalidation completes.
> > A curious question:
> > To support memory not backed by page structs in future, is there any counterpart
> > to the page struct to hold ref count and map count?
> >
> 
> I imagine the needed support will match similar semantics as VM_PFNMAP
> [1] memory. No need to maintain refcounts/map counts for such physical
> memory ranges as all users will be notified when mappings are
> changed/removed.
So, it's possible to map such memory in both shared and private EPT
simultaneously?


> Any guest_memfd range updates will result in invalidations/updates of
> userspace, guest, IOMMU or any other page tables referring to
> guest_memfd backed pfns. This story will become clearer once the
> support for PFN range allocator for backing guest_memfd starts getting
> discussed.
Ok. It is indeed unclear right now to support such kind of memory.

Up to now, we don't anticipate TDX will allow any mapping of VM_PFNMAP memory
into private EPT until TDX connect.
And even in that scenario, the memory is only for private MMIO, so the backend
driver is VFIO pci driver rather than guest_memfd.


> [1] https://elixir.bootlin.com/linux/v6.14.5/source/mm/memory.c#L6543

