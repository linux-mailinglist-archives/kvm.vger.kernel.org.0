Return-Path: <kvm+bounces-26602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EF3F4975DE4
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 02:16:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 51698B23BD5
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 00:16:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEF871D545;
	Thu, 12 Sep 2024 00:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XYgEl+a3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66898489;
	Thu, 12 Sep 2024 00:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726100134; cv=fail; b=RxGRB/L0QwGD0fTPqe3+U4RV4R/NXph+ylbWZaP5g+x638PSFBln7VlOzQOUOlSE5eBtTv8YoSXSdNDdxtnfNtz/6BgCxnRhXdBH3TpRctmAqDK8NfE5x+EG8uEdS81QBrECQt9C91aaInnZeBVC4q4f5eVh9AosAtPjVn/GSVI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726100134; c=relaxed/simple;
	bh=L1UIFoh51uI90Q7/ZckL0kM1thDxRM+fO11fIoJFDrE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=m1xj4xmJk57wLZg2JSdN1CxWG+vE2oF4MDeZ48CVK0+0NztSEje02clt2KS5AgE2VIfKqIU+NTofTTQ7DgedworUWyVeYOp3PlRlOxvLWL4I4cV/aM4VYjpUJtK5O28U8yeqJ3tHSrnyqNWA5Bw5hpr02T9VfStao87jqILncTU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XYgEl+a3; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726100132; x=1757636132;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=L1UIFoh51uI90Q7/ZckL0kM1thDxRM+fO11fIoJFDrE=;
  b=XYgEl+a3OfWHrl9ed9kE9f61dLfxB/I6OBBf+GE0PF7rmFpODPZJLEHC
   dxIORX2BMrJLmwlDQ0TtZcz6mTfB+8b/sw+34tI6Uzla7r92a7JvfGLPI
   N64JBLRQm4XcelH9ykxBFVMFri1mFhzn5m6oaBt/zB0mg2ylXiX8KI1SX
   MaK+J4jukvKV+ZNDBgeZwIIqyIQJdKACF1/7rPamkVXkVBxiNcWri4X00
   YBI28EiNr63nJLYKl7J7czCHm4g/Mw3LN9rt0jn5Q2Zrx38ZOYsYEB24i
   hyXLOCO4CdgTn4xltWLaSdzmrSg7U/WR+3l86n/ngYo/xyReRoAiYbsAg
   Q==;
X-CSE-ConnectionGUID: aQ1LpV0CSq647v0VOT4M3g==
X-CSE-MsgGUID: Sz97MSpNQPOBjvg0Fbarjg==
X-IronPort-AV: E=McAfee;i="6700,10204,11192"; a="36317180"
X-IronPort-AV: E=Sophos;i="6.10,221,1719903600"; 
   d="scan'208";a="36317180"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2024 17:15:30 -0700
X-CSE-ConnectionGUID: 0sJgUjaURE6pnDHbMui43w==
X-CSE-MsgGUID: pMmKRLYHQtOGSbdCqP7hmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,221,1719903600"; 
   d="scan'208";a="68038083"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Sep 2024 17:15:30 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 11 Sep 2024 17:15:29 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 11 Sep 2024 17:15:29 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 11 Sep 2024 17:15:29 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.174)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 11 Sep 2024 17:15:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HxVWkyoJ40Coe0KC+mjuRBtJ8R8UeZl9J1fPRtey0d6TctgF5xXBkJEL8E7bWlTsbsSkJ200bYnzPzZsGb6seWeYXWA1Wf7h12tOchRdy/p8TmKSC1erUnxw116aubQLU65UTaUxOgIGwcp1iCyQxgG62fiMoyQrcvF0mS9UxIYsQGZzEW60LqN3wnpq5Cz/oe5ubY2dRGxcs4m6p/gcWSshm3r2lmXFwjrfW6/5JzaYwJbZvosRns+IPoPDOcLMXsl+afquo24qP0U9yBY1i7MsV6XqAgCIvzOOhmAOu6A6ne6Equrmp+rCv/umSATqVG1fTXXY4Kj0zGmhmxphkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rTquRTjDF7nslBrBYX3giq+6BbOCGx8AwVwHJQL41Jg=;
 b=d/wD6iHkuL0AXSLB8XSI0M9LTdfbzmkuWUQNpi+517TdIvVToUCosCw+q9ut6AeY55IA6Ejx0ZP3kh1myP57WcaboYFack8RNyhbob2KT+s3FSWsJnrGNA+Oh6a7hx4yVgZkGDo5dwi/rjpaZNR51AoQmVvQPqc3W0a9MgTlzK4tUFneq1t/3cwmnBYgtPJm1/xoVAsZZVgzDsvy6TUuENp5JWZ4046HALdIWYbnG8p76rPrw5A14JR9G+IQbzRIO4rgrfTzHZo9NApYJCwECNOAJJAiYHLZBMZrgu6Y3Snoop8WWjdzXUed143HJG2ncKGRjq0FLc7JltdbImEOLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CO1PR11MB4946.namprd11.prod.outlook.com (2603:10b6:303:9e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.17; Thu, 12 Sep
 2024 00:15:24 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7939.022; Thu, 12 Sep 2024
 00:15:24 +0000
Message-ID: <78d7b648-ad06-4065-bc87-c195c790f699@intel.com>
Date: Thu, 12 Sep 2024 12:15:18 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/21] KVM: TDX: Require TDP MMU and mmio caching for TDX
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: "dmatlack@google.com" <dmatlack@google.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-11-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240904030751.117579-11-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0168.namprd03.prod.outlook.com
 (2603:10b6:a03:338::23) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|CO1PR11MB4946:EE_
X-MS-Office365-Filtering-Correlation-Id: 50b07db9-20b2-43e7-0cda-08dcd2bfff21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?a3RkRGxySlcvUFFWOE04SDFldXB6ZVRENFZ4aGtyK1ZjTWlRMzAvV1hhMDRP?=
 =?utf-8?B?b2VqMWp0RDVQa2k3OGxTVVVseXJGcUVKc2JHbkRqd1hHZFVveE1hMjdWSVJY?=
 =?utf-8?B?MXlibklocUVLQy8vM0EybVBvQVhKcGxaWFJrZUdBUCtnRmREdE9vV0MxTDd4?=
 =?utf-8?B?SmphSzFvNlRPMkJteStSVjJhbnREOWQrMi9iblh5L3U4bVFNTTFIODJnaGx3?=
 =?utf-8?B?SXlqdlIrRHBJWkhYVnFlaVYyS3ZWRTZPTUdqa2M1K2FWMkhabHBDeHVJbGtI?=
 =?utf-8?B?Z1Y5dWVnTWNnTkxHTVl4RmI0TWJIdElPMXhwOGRjOVpnYlVPMmRYaEwyUUov?=
 =?utf-8?B?Y2NVUzR6THpCZFVIY0d5am9uNVhiZmt3aFdYQWVuRmpFZlhPaHArczBJb2FH?=
 =?utf-8?B?ODVBekxLRXpZMFJKNGFzMk45eVl0K1FZbURWSXFOV0hrak8weURIVVlBcGM0?=
 =?utf-8?B?WjdpVStkVTVod1lqdUsrSG93ZnRicG1sdmZUS3lRYjlwbmxwNElRVlQ1NHFz?=
 =?utf-8?B?M3ZUbDVqMTdJQ05seUMyMGc3SGxEVnMydWNoV09BZGo5SE91VnY5V3cvS01U?=
 =?utf-8?B?RVNNekpyeUoxSFJpT1MrQXdNc04wTm1LYWpQOTcvNnVBZkFMTUFCM2ljTGJV?=
 =?utf-8?B?bnhUU3hRTXY1dnNVdjdMRkdKTG5DQWFvSzREbmh1amtQYU1wMEhMMVI1eXRp?=
 =?utf-8?B?WGh4TWlmQWN6U3E4eW5EMms3SnF4SWZnbFRNSnNyVUZkOEVQMnF2T0VQbVh5?=
 =?utf-8?B?YlZaY0o0VzlONzNwekw3cG02SDU0bldPSjR2bUVHUUpsN1hVdDQxR0lqS2hv?=
 =?utf-8?B?djhZM2dITTVoaFJudDl0cWhQQXluQzllWXZ6ZVBnbGFrQWxxMEtDeHNKN1Ju?=
 =?utf-8?B?Um1IbzBLQkErbmZ4ajgvdzVnc2x6OEFwVjJnRHludXNvcGdBalBwOTd2cng1?=
 =?utf-8?B?SXBWb2N0djNZUjIvbjNvNlNYbnpQU0hXOFM5cmJ3ZXU5RjN1ZnBIMHVvelYv?=
 =?utf-8?B?S2tDYzIxdEhDOExxNm02QUUxYWF5dWVqVjBxRDVEK2o5dVo4ZFg3NVJHSEVj?=
 =?utf-8?B?SFNhK1plSjkzcE1NVXV0ZExwMlJuc0V1V1Faam5leVFreG5Vbk85QTVKMmt6?=
 =?utf-8?B?alpEeTVLdGVnc1Y2LzA0SW40eHA0TnhrenJiemhsNlhudlhxNk5uNnhSbTFw?=
 =?utf-8?B?TnZmVHVSTjJoMWs0ZitQdkVJc3pteFhiMzBHaEhLNU96alpSdmVxK3dhaEVO?=
 =?utf-8?B?ZDJjSnlSMFZIZHpjcm5LRmdKM0VNLy9kdWwwUThkTDhHMXBrWTltMVp4YjNE?=
 =?utf-8?B?TlVkWXFMSkNKSW1rVXM4WWtCbE9HRG1WV3JyMUc1elFnWXlocGdYNXgyRVcz?=
 =?utf-8?B?U3FSOXZGSzYrY29mQ3ExT2grN09uamJxVWNHOGo0L285cTZnaXdOVUs0U2k0?=
 =?utf-8?B?MnZieVoyTzQ0L2hEWklNUU8rM1Z5b3cxZ0dHVE52dFdSdWhqUWlueDBWWG11?=
 =?utf-8?B?TnRLQWRuUlNqbVpqTUVsd1RWMStsR1dTbkRXOHJ2RUFoampkV3RpRW81RDJy?=
 =?utf-8?B?M0t6MHNxTy8yajBwUUpwTFpySkJYZ3duQUw2dEljRThSdWJzcW4vOExiQ1Jq?=
 =?utf-8?B?NFIvS0JHMEhqL2o4QVNoemVNVnpqQXpVUjNHc3lrTmFwbDVHc3UxYVBuaUtD?=
 =?utf-8?B?bEtYVjhaZzFmd1FEZmxxdURlYThvcjZrTlFlaCt0bEExZG5wdWhHRnkrcUFr?=
 =?utf-8?B?dmxpTzlvdGNxSWEza0lNVmRKcDV6bXl3a2xRMGlGR09DRjRJalpDTnVKZUpN?=
 =?utf-8?B?TWJFODRZZ2t5UTNENjNhZz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OTZxTThncndSeFlvTDFtRWFSRHdFNERnQ3hLY1B6OTZ3T05MZ0kybXd3bTZs?=
 =?utf-8?B?a3lSMzEvMER0Zno3V2Fjd215N20zcXpiTjhuV2xNRGxVS2F3UUU4Q1hQMlNt?=
 =?utf-8?B?TGEzc1ZkWTlZREtGY0ZjTUhiTzlnSElSMGF5ZGJ6ZWd4UThDcXMrQ3AwWjJO?=
 =?utf-8?B?Sld1TDZMYU8vRDRaWWZsNEQrSGVGYUZiVGphaXFzMHR5ckd4Z3ArVEJnaHRS?=
 =?utf-8?B?N2dIK3ZHRHEzRUtML1k3Tm1FamxSeitJUVdCdGpJa1hlTm15SUdhL1BBOEpB?=
 =?utf-8?B?QVljMStRRUk4YmV0R2puUVloL3Y4dm5OaGd5aWphYzVGVWowVDFqdGhVQzJJ?=
 =?utf-8?B?RDVwN0NqTzVtcFBzOFMxMGY3cWtERXFJSW1Gakh1b0szL3YyRUp5VUt2ZEpH?=
 =?utf-8?B?c04vYTVFZC9mallvVldGOGUvaDltT3JLZlorN0F6MTNQSmhOSTdnUjQ4Nldu?=
 =?utf-8?B?Y0R3elFFWXVBTVZZRFY2Yzh0M1pmb1JRVVh1TkJacjJ5OTN4QnZyZ200WFVR?=
 =?utf-8?B?Q3hyanZ1bmkxVkJPUnRKS2J0cVVTaXRkRFZXZWVOYVVxSXBScXgzNWljcDl0?=
 =?utf-8?B?MW1JT1dFa3kyeVlIS2dab1o3VmZqc1RpRnZwQSs5VTF3NVZuajZJT0RtQVpC?=
 =?utf-8?B?aFhvRXlLWmVNc1pFL2lGUzloRmZlUkthYUs4bWJ1OUxpT2txbytraWhQRlNX?=
 =?utf-8?B?VERiVndRcU44Y3E3SCtsdmxGZ2ZzMk9WZG5sc0UzYm1UK0p3M3QrZHJoajZG?=
 =?utf-8?B?NUlCQ0REWkR3Ny9LaGFkRjNORnNyYm5xK2g0RWJKL0lQYlB3MytCVUVYM1BK?=
 =?utf-8?B?NUdUVnAwL3RjLzJmMUZaajVPVnd0WWkvUE96OHllanI0eVEwa0NBWDJQVkZx?=
 =?utf-8?B?bnc2N1A4dERpZUtsMkY4ejhXbjJsS2NTd2psY1dqRFM0Y2w3TWtNMktrYjJU?=
 =?utf-8?B?eVBXMS85RkQ5QkpYOGRha1ZRWDAyUDFnUjluMFhJa0lzL1lTZkFkNXdtYjBC?=
 =?utf-8?B?V29qY29EOTlUU0ZkVDh1em5sTVpzZVZ3WnVpNmtJRWZRV1ZmcGx2cFJNR0dZ?=
 =?utf-8?B?SzJHNDMzUllxemFGUnJseTU0RUc1b1lZbDlCNHJsOE45TmhDM1R2Vjh1TGY1?=
 =?utf-8?B?dHhINVp3bGl6TDIrQVdlRXU3TWx3WWtzOFVGcFJxbzg3NFIrK0tuMXdLNHVw?=
 =?utf-8?B?c001UkcrdXVXYnV4NW00TWNaT1N5UW5Xbks5SkZ2RlJTVXFCMFd3OFBnY1pV?=
 =?utf-8?B?djA0clBjUGFtWkthRDFIanpDK1RLYmtkT0FEZ1NHWmZPenEvTmI1eTdHMEwy?=
 =?utf-8?B?S2xlS1BTR0FuUDhBejRSZ0J3eUdkcDQ4cDNhZnJRck9nMmlzOXdMUVVhTTJG?=
 =?utf-8?B?YUYyMG9wZEc0S2dwaVVJcmY4UDZ0WlJ0ZDZabXB1dTVhaWZ4eHY0R1JoOTY1?=
 =?utf-8?B?aUJ3NDNpME5SKzFQY2QybW9yejE4bk13YXRDeFFGbFI0eStVOGdHeVlhdFR4?=
 =?utf-8?B?RkI2L1ZUU1FSMzN1VkpVQTYvUjkyVHp6d1hzNzR4WGhhdmNYUjJIU0dZU2pp?=
 =?utf-8?B?bXN6d0NuZ3hXeURtTWhJR2dtYlpaMTk5d1hmYzNvejVCNExiUkJGR05RU0J0?=
 =?utf-8?B?eFR4bDUzSDdTK2NiYzJVenlGMkZvRzZYL0Z6UkhEWXBaZWd0WGRkM01Dc3VO?=
 =?utf-8?B?RzdzYlRITTdQcVJiM1NwU3pib2JVVkpYaVhvdGVpK1ZWZTlFa3JHTHdVbXRs?=
 =?utf-8?B?TCtVWDZtTmZFdHdsNjcwUlgxTU5jbWpWZWw3VlpzY3E1bUhUMEpYYXphR3Fx?=
 =?utf-8?B?Q1lCNEZyMVFEa3dKS2o1c2U3N04rcFN6eE50czUzb0dMRklsNGNMVGVNbHZs?=
 =?utf-8?B?QVVDQndkelZhdG4xbDl0VHJySDd6L1o1SGthanF0SjZiVXdhR1pDa1hJZSto?=
 =?utf-8?B?b1J3MnMrb293VDY1VkRVekQxSzFFQWFLS2FIR3djYnZXNmtiYi9JRGZHTXlU?=
 =?utf-8?B?V2FnK1djV1dqK29CcmVmdWljL3ovcEJvVDcramNwSXNVNUVTNEZxa21WYW9v?=
 =?utf-8?B?Zjhab0xsVkk4NWliSUFhdXZQaUtXQ2JLa00yOGJET2Nqbzk2cWRUUFNUUERJ?=
 =?utf-8?Q?LkeYFCHBiqS0XtPhwiHQXoHBp?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 50b07db9-20b2-43e7-0cda-08dcd2bfff21
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2024 00:15:24.2685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZUcBbextFokaqW4mO4wzJit/eaPVzNuRZiNhNrzd7xHZm+zB/L+7iq5rLi2e2d0XF1XRr6F0wut9wzp9A0EEtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4946
X-OriginatorOrg: intel.com



On 4/09/2024 3:07 pm, Edgecombe, Rick P wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Disable TDX support when TDP MMU or mmio caching aren't supported.
> 
> As TDP MMU is becoming main stream than the legacy MMU, the legacy MMU
> support for TDX isn't implemented.

Nitpickings:

I suppose we should use imperative mode since this is part of what this 
patch does?

Like:

TDX needs extensive MMU code change to make it work.  As TDP MMU is 
becoming main stream than the legacy MMU, for simplicity only support 
TDX for TDP MMU for now.

> 
> TDX requires KVM mmio caching. Without mmio caching, KVM will go to MMIO
> emulation without installing SPTEs for MMIOs. However, TDX guest is
> protected and KVM would meet errors when trying to emulate MMIOs for TDX
> guest during instruction decoding. So, TDX guest relies on SPTEs being
> installed for MMIOs, which are with no RWX bits and with VE suppress bit
> unset, to inject VE to TDX guest. The TDX guest would then issue TDVMCALL
> in the VE handler to perform instruction decoding and have host do MMIO
> emulation.

AFAICT the above two paragraphs are talking about two different things 
that one thing doens't have hard dependency to the other.

Should we separate this into two patches:  one patch to change 'checking 
enable_ept' to 'checking tdp_mmu_enabled' (which justifies the first 
paragraph), and the other to add MMIO caching checking.

The final code after the two patches could still end up with ...

[...]

> +	if (!tdp_mmu_enabled || !enable_mmio_caching)
> +		return -EOPNOTSUPP;
> +

... this though.

But feel free to ignore (since nitpickings).


