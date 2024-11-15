Return-Path: <kvm+bounces-31917-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25A489CDB63
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 10:20:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 59794B24A44
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 09:20:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 603D218F2FC;
	Fri, 15 Nov 2024 09:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QrFa1D/n"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C839318F2DB
	for <kvm@vger.kernel.org>; Fri, 15 Nov 2024 09:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731662379; cv=fail; b=j6QAafsrE7QuEvCBLaUo1ne+xMPGzj8J1cYDidB5Xf/jsIJoP2Eqcbg2f74LZnVq8bPdNe4Dx185YGNLnrj8b7aHYvZOoNpnBrcufTBCapd5U6BW2iklYdBBTB/sTc04NqTM7jdqlRxUOhdXkf5w4/0vS7jAsO5kinPQHzNPgr4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731662379; c=relaxed/simple;
	bh=pSNNO+FugzkB2ASUj8foWwG5Giw5GcwMxcHLMYi3A+s=;
	h=Message-ID:Date:Subject:From:To:CC:References:In-Reply-To:
	 Content-Type:MIME-Version; b=J5Ujt6MEYRqovXtHPhXi8BwAStoDPhM937Qlx1vfWTMaPpxURa+rcolDENkW8bn1TXY8cTcGpNg28lNZEauopD2J0KWrztwEiaoYrFkhTZmx62L8vSeJyJ0rFyITJdudFwT9VkvAptwP/KlzXjBOuLle+cvfKLOiQvKU66D4WsI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QrFa1D/n; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731662377; x=1763198377;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pSNNO+FugzkB2ASUj8foWwG5Giw5GcwMxcHLMYi3A+s=;
  b=QrFa1D/nE9YQaYzfawGe1yjzsfvKjNTDmIeiHARDVSwbHQe8dbW+4ctS
   JUr8pD6OyftsCCyGQd17DBCLslKkL/ZPt11OxPcm19uAsa55w2okMioz3
   D7H6RkOnxcPHwIAL6rxwf9vjtZMTCJDVsDuVgSea0XpEJGN7/Ghk3p36v
   7HSFnbc2RwgshCCWZcHaQR0oLLuaaAiyKlG6fKuJR2OVLbcc+BgMIRssv
   lFKx7YILbj1o89JBLlpMwMBRu+OMjNSZhxPdmfYpdaMJE5NwnKW+kgdpX
   TNsEe06PBgClxM4mQYr+zohakF6xa88FFsepoQnm2QwlLE6jn9Sf1k+xM
   g==;
X-CSE-ConnectionGUID: W+/e+noMSSCVRdkS6XTxzg==
X-CSE-MsgGUID: pfAX2DvvQiq+urLSBu8Gtw==
X-IronPort-AV: E=McAfee;i="6700,10204,11256"; a="31815781"
X-IronPort-AV: E=Sophos;i="6.12,156,1728975600"; 
   d="scan'208";a="31815781"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 01:19:37 -0800
X-CSE-ConnectionGUID: SDL/pC68Tpmg0HgjovzB3Q==
X-CSE-MsgGUID: G7V8QqxZSVyYibhEhrVE0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,156,1728975600"; 
   d="scan'208";a="88920553"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Nov 2024 01:19:36 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 15 Nov 2024 01:19:36 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 15 Nov 2024 01:19:36 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 15 Nov 2024 01:19:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fmlw8NEHuRtyq4BsP3cJSViWVY4MrSSNg56O/lw1u7GB5uJAR7uFI5z2AM/YRr4nntsNOjUhsK6ADeUJtef01bDASkJR91TGYqqEJSSfqQF17H4DE6DMwo2hNKfUtnxgn/TLV8aias4H8d8f8xEKTr5nuk3L8Z8Zz1S0uO0dzsljePYXfSN2pImw0xm9bTl8DdcL5v5wzzHDxDc2lYVfl/sDYSf9HYnxW/H3gLBtIgmZP/ZVfl6nlvZt7PDx/9ggDELiAOSbTvonpIZ/7uH2OaX1mFdfnIMDZ55YXlPdWJkl8X8q1pX9Rr673ejkBwJwhwmSBwhMcH0ZFTuayXBkVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aiVegDwNryXmKpmIUMFGVaBSVy4uzZOBQV+6W8BpzRs=;
 b=LFfPGp6yC0bqasspF309kctbSdZxfOjWM4DDLE/YoFq6ltD9j1qIBdjpzrHqz59F1Oub19J+0J/gdusLDUhCnOx//6WBi3BX6fcB4X1e91zq/GILiyJn+X05gv0sRzR78yN5Zy9+TYuVIULkrKePhyaHYCdxZM9DC6XCPftkd31Iwhd+vvQVPm0bI/Pk/r5n8Q0vbHnXdaatulMRXRlwBjGaMo/eoxN3gGfjdvunV8rizNUd0U8jdXTVTkJv49N4CJXVH5aBfykVsOXjy3e7nbdKslks9jS3c7w9DZWKIaTh5fIYzlJWfitQlMXGXAXMWvnnTnpYsUfgjeTVPcVK4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH7PR11MB7550.namprd11.prod.outlook.com (2603:10b6:510:27d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Fri, 15 Nov
 2024 09:19:31 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%5]) with mapi id 15.20.8158.013; Fri, 15 Nov 2024
 09:19:31 +0000
Message-ID: <0659858c-68fd-4214-9b76-6a31e91ba5ea@intel.com>
Date: Fri, 15 Nov 2024 17:24:09 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/12] iommufd support pasid attach/replace
From: Yi Liu <yi.l.liu@intel.com>
To: Baolu Lu <baolu.lu@linux.intel.com>, Jason Gunthorpe <jgg@nvidia.com>
CC: <joro@8bytes.org>, <kevin.tian@intel.com>, <alex.williamson@redhat.com>,
	<eric.auger@redhat.com>, <nicolinc@nvidia.com>, <kvm@vger.kernel.org>,
	<chao.p.peng@linux.intel.com>, <iommu@lists.linux.dev>,
	<zhenzhong.duan@intel.com>, <vasant.hegde@amd.com>
References: <20241104132513.15890-1-yi.l.liu@intel.com>
 <20241113013748.GD35230@nvidia.com>
 <4d0173f0-2739-47aa-a9f0-429bf3173c0c@linux.intel.com>
 <745904ae-f9d9-4437-88a0-7d4cb5d19053@intel.com>
 <ab2bdbe3-d21a-400c-8a63-ed515b4fab72@intel.com>
Content-Language: en-US
In-Reply-To: <ab2bdbe3-d21a-400c-8a63-ed515b4fab72@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2P153CA0012.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::15) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|PH7PR11MB7550:EE_
X-MS-Office365-Filtering-Correlation-Id: f3655e84-d5d3-4d1e-a4be-08dd05569cbc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bzkrRlV1d3NOY2UvbndFcTNnZ1NwSFVvdVV3QTJmYzhBdFVGbEU3aDlKNHBG?=
 =?utf-8?B?YmVJSUxLa0o1OHA1eUo0UHlVS2RoYVJmdWFRZGV3ZG14ZFdzUGNnWVJLV1ZM?=
 =?utf-8?B?MTVxejdQL2NxWmFSVjlqSUJ6c2RMQ0NqdVpZMU9zc2pvbXBxZ3F0SEtvQ0hZ?=
 =?utf-8?B?TS8yYXdHVXB1TE5QSHVuSm1DWWQ0d21lTk9UdVdFT3ExL0lmRFJPY2lTNGtw?=
 =?utf-8?B?dWxkUHMyWjJ5U0YyUzVQV3hFSnRCM3UvaHJoaGVnLzNUbVUrdGF5THJ5T3Vv?=
 =?utf-8?B?Y1UzT1d3bHNlY1NiQ3RweVduSkdBeStxbWtiZXM1K0RQYjl1YURLVUNDZ0U2?=
 =?utf-8?B?bm1JakozNVplcElscmJUYXVSeW52VW85M0V3dGIvV2Zvc1RnN2dCRXJJSStK?=
 =?utf-8?B?K1JBSzdaUnJzZ3R0cDQyYW5HSWo5eTk2K0dJeGtIVjJyMkJ5bFVoUCtWK3dx?=
 =?utf-8?B?NUx6ckFCT0I1ZFN0TVNDTFNobENWNXN5eHd0SGEzVkhJT2N3a3hrdkI3SGZn?=
 =?utf-8?B?dkhIZUdPcXduTW9hQnhQakFKaUg5U1o3b1VNLzVRbkpGK3ZRRzJMNW1qTVRi?=
 =?utf-8?B?NENXK0Q0NUlQVHg2S1FzNXNETlV4Qzk3T0pENlRTNko2TThTa3QxMEtLUGFL?=
 =?utf-8?B?VW9hK2ZxbkRCNXBweXlOT1FCVm5tcnRWQ1JOL2d6UHZiM05VWlJCWnVETFp2?=
 =?utf-8?B?dE40TG9HNDVGN2ZZMzhWWnlmK01BMHQ0T0g1c1VkRngrTWFaL3BwTEJGM2p0?=
 =?utf-8?B?b0I1cGVWa3pTQ3ZSMkRKNDRxdDBKWGp1bUNJYTRNSFVCSVFNKzF4bUpBK1Y1?=
 =?utf-8?B?Nkw3NkxKYzBYU0NnZWJzRXBkejdQckU0R1ZHSnI3SDJ4VGp0cUtDZW82Q1Jn?=
 =?utf-8?B?NWo1UDN2MVlvN3ZGWlpPb1dYUTlBbTVnenZVUkxOT3QrMWVycWI0YUhJR1lQ?=
 =?utf-8?B?VUVCWG5iWmhSQVRaTlBicWpmck5JNTQyQjV2T094Z1Z3MURJZEZHSDNwT1g1?=
 =?utf-8?B?UlVNcGFtaURlMStiRUxIS0l6eVY1YWhpa0ZEdmZUMENod1BaL2pmbGp0Y2c2?=
 =?utf-8?B?SG1kUU1IZXRBajlrRUk4bmdnT2llTWF6Yk9YM2dFY1RoN3dvYVo3OEZMeVJZ?=
 =?utf-8?B?SUlVRnoxbFhiWFFKcWNjQWVSMTVUVEFaZkFOTGJqV1RaamlmSVhabmlyYU8x?=
 =?utf-8?B?WjNPbkFDL2FhcVlFYlBoRk4xYnhTY0JZd1JaaXNwWEZUYUpLNzlkdGRJbFBS?=
 =?utf-8?B?bDMzaDFoN2dMSmNkTEExMktFU3d5YUVzdXdzQ09jbWtTc1F6K3BsNml1aS9s?=
 =?utf-8?B?Nm5Ma1I4N2tUaXBoUmc0c1VlYU50VUI2eUxhMis3bC82R2RiUXRKdnVJOVlu?=
 =?utf-8?B?MUM4bVB5NVIwYnRGUzRiZlp5Y2tJWDBPRm96WUxpenZmbWQ4UmRJQ1YvN2tn?=
 =?utf-8?B?eXFMMDl5MXVhVVpNdDRpa2ZaWHJaWUtJdi9XOTROZ2QzR1dqMExoVVBGTjRM?=
 =?utf-8?B?SUx5R2xndkhEZzIzK1VaK1h6UU56TnVnTzFxMTNiMERkY1hvWjYrK0JiNWE1?=
 =?utf-8?B?RnRHaUNTbzJid3UrMEpwWmUvSHBPZE43bU9rTFN3c1dCVHRQR1c0Nmg1TGhO?=
 =?utf-8?B?cEIzMDR1K0hlckV5cVp6bytlUTNBblhzMm9jRCtWYllqL0hOVytCR2tidExy?=
 =?utf-8?B?NDJIcjFSbjJmdDU5UHN0STYxaUg3dDhsMVZITnFXSitwaTZDVEJlMkNHaVFX?=
 =?utf-8?Q?uDSL28it07NFU7jjUvai6a81tbq5yycXVNwFnrk?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aStINUR6UW9tcE9XRzg2b3JaenhrUVpkeS9wNEkreFpSWkROU2U3Rk9OczJP?=
 =?utf-8?B?OWQzT01TUVhJMjZQOEsxYnYwNWQ1enpFZVRxNWxPMFAwcldjR1A5dExPQWdh?=
 =?utf-8?B?SkczUG9CeGNBRXRJTDlnRmxrZUZ0WnY2Nm9oUUFmQytiWW1uWFEvSXFLV3lB?=
 =?utf-8?B?Uy82TTVEN1dkd2h0S1VxVjV1bno5c1d5V3hBSjEvOXhSV0RDakY1MkRKcFgx?=
 =?utf-8?B?MEovT0NLOEprQ2d6VTJTTHZycnZLMzljTG9hMFdhOWlzMGtsWFg1ZUxqYUpw?=
 =?utf-8?B?OVdUcTJuZ3Y0RW9DdVh0cFFxWUF2YllEbDBrVDJSK1hJNTVRcEZvQjFPNENJ?=
 =?utf-8?B?YTJxWFlNaTRSNzNxWmRwRHlhRkxrcGluVmpuQTZzSGtWSXhaQ0UySDRzcFQ2?=
 =?utf-8?B?Qjk4bXdoY1lFRzVZNUpEejhTbThsZldzM2hOQnpUQmVlOHJUaUd5YUpGaWx5?=
 =?utf-8?B?YldXMWpMWTU4SUhoZ1UyWWZaYko0WnlqSzdtZHI2UVpPOE5nNFVNVEpyS3NX?=
 =?utf-8?B?OWZNQ3BSS0ZmYTcwcmtwTXRnRkY1RFNHanBWdXJJZUFEZU93b1c0bUN1OFla?=
 =?utf-8?B?cEpzVU5xU082U21ZaG1VV3c4L3JkUjdQTkIxZ3h1NWgyZXhJU3dwZUd4YnI1?=
 =?utf-8?B?SndzU1JFVTNXTnVlejlSSVNFdFltQjNaWnF0ZHhBWDZBRzMwbXNUODhpOEFt?=
 =?utf-8?B?cHhHNnhNYkhCbVpUVTM4UnFiY2xHeEp1b2JwT1ljb2lWK242K2NvUllPTzBz?=
 =?utf-8?B?bkR0bmtOcXN5c0hYR1gzVmYxM2dSYkdjQUVQeEM2akVSWVpoMzZ3cE50WHIz?=
 =?utf-8?B?T09GZzJmMGZOK2wzUlhNYytHNDBmYkFOeU5yZGNwbUkrTHp5WVpyVTNCMGxH?=
 =?utf-8?B?OVpCVFF4L2dOQ2JTYk9RTXZTLzMzQkVTYkpJTmZwdTUwQkJONFdUdzgxUmd4?=
 =?utf-8?B?bGs0YVpQQzRRUzM3b0srMzB2cnVTc3VRWG1POGNodm1saUJ5QTlsSDNIbVFG?=
 =?utf-8?B?ekZORmQydXFFSjNhZ1I0R2FwK0dMZXhBUjdCU0x4N3RwMDRwMEJXS09samFW?=
 =?utf-8?B?WG1Fcml4am9RcVdnVDdPY3FkZTFjaXNkay9COWRNSVZzNnp4eWVOTGJzcjJY?=
 =?utf-8?B?cFdjb1BlKyt0M3NNamVOZlFaZ3p0enBQZmNNWkdEVVd0Y295QXZzQ1pPcFFn?=
 =?utf-8?B?US9JTFJza0hWK0ROU0xoV3BhNGtVbmJ6dDcyQ3VoaHRYZFhQNys0dVBRemNE?=
 =?utf-8?B?QjNUWG94MytUU1NTTFJOOTJiTUNQM1NRZnVBS2JVYnZIU3JNb1lvTERTZ0h1?=
 =?utf-8?B?SGJQZ1pZSXR2cSt5WDF2SGwwVnhoejlNaGpGSTVYQXE3VkJQbmd3YTVjd1Z1?=
 =?utf-8?B?Q0Z0elN4OW5FVlBuZStkOVRyTmpQWUY2MEZsMEl0VGVpSHpTRVBZQjJDNi95?=
 =?utf-8?B?Z0ROU1NGQ05MNFpoSUhJTElrN0dQd0tFYlBkZm9NSkVHNjVRUVM5NStianNv?=
 =?utf-8?B?QkIzNEt4MnpzQWQwWWhrTUZ6VFhmOEhiaTVSOTlnbTFTdUE3bHo1SnRXejJ5?=
 =?utf-8?B?enNZQjAyd3FKK1l3NmQyWFJIV3pUSjJQd0JwcloxNHNSS3RPanU0U2F3WG5i?=
 =?utf-8?B?NWsvUWQwTkdFQmdhVWxJZ2IzYks3bm5sRnRVdTRsVzM5dzRJQkVIai9lQjlY?=
 =?utf-8?B?Q2p6d2xDK2ZLZ0FXT3ZWT2xTSFQzL0V6YnNvVzFLV1ZYMDg1R2krNGNxMW9V?=
 =?utf-8?B?djcxRk8yY1FUa0JYelE0RlIrTUJBZHNJWWxpbkJqais1aHZMbkdUR0psbU1w?=
 =?utf-8?B?clpSQnJ4NEZDcjE1MGRrOWh0L3Q3ajl5NElEZGhIZU1NcDFjaHRpWmxpbTRF?=
 =?utf-8?B?ejB1NkFxc2tUb0JacFN4WkhZeWU0MGlQRmRDdjJkYnNXY1h5YnM5T0diUE9y?=
 =?utf-8?B?aGVENmppZWVCVlFLZHVkZVhac1N4ZlFLY0hZK0NSNGNLa0IraWdadzVydXgr?=
 =?utf-8?B?eTJlcCsvOENFdWs4NUtKdEI5V2sycnFJcDFIN1dTcVNtYWxUZWNXZGhxVi9H?=
 =?utf-8?B?ZFJEUmxSbmpsL3YzSnJIL3ppUzJ2SkhGV3BJKzFXNThVUko1V1FQQzBwVm5I?=
 =?utf-8?Q?7nHFyS3deWMXyevcZJmj68gUi?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f3655e84-d5d3-4d1e-a4be-08dd05569cbc
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2024 09:19:31.4574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PkRXXaQ1/UVJQBt+pUFWqfORqy6E/jCWGh5JE4BVk0pP0GNsJtiEP9+1/qgPGqQ/2DZ8b6VPJBwTBaWXZA9aDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7550
X-OriginatorOrg: intel.com

On 2024/11/13 11:26, Yi Liu wrote:
> On 2024/11/13 11:24, Yi Liu wrote:
>> On 2024/11/13 11:01, Baolu Lu wrote:
>>> On 11/13/24 09:37, Jason Gunthorpe wrote:
>>>> On Mon, Nov 04, 2024 at 05:25:01AM -0800, Yi Liu wrote:
>>>>
>>>>> This series is based on the preparation series [1] [2], it first adds a
>>>>> missing iommu API to replace the domain for a pasid.
>>>> Let's try hard to get some of these dependencies merged this cycle..

The second dependency has a new version in the below.

https://lore.kernel.org/linux-iommu/20241113134613.7173-1-yi.l.liu@intel.com/

-- 
Regards,
Yi Liu

