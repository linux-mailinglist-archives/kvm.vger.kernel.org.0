Return-Path: <kvm+bounces-30615-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B15109BC488
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:07:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 435051F222E8
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 05:07:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F91C1B3951;
	Tue,  5 Nov 2024 05:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DlhZoud+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3912C3D9E
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 05:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730783251; cv=fail; b=CoqtWuICdiOxukGxhgoOVb0pnMEKvTlKzXSEuU7xEYvVP/ch+KD1jrk+r9g1YK3NpzJW6acPj4IhsI55ChjIqsCpFlMMKtHpJXLaKX8zhEWVLxzh4d3qR7URyxQzABXm2WeuC+UzrNBcVL0av/CD91MHeFG5YMXTmK2bcnpLDvs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730783251; c=relaxed/simple;
	bh=INBc3RGGEqLEkSuSD/Q/S/d+uZ8BCwMFA4gxYUj9SJE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=L6wVw8GaOEPZeOVJlIm9nFQlZuQXwRAzbfle42WPZbU07pHv6Wp+6xRILyIQ+zF+fe03hQKJp5IqgSzCRMz7EmZp8jHxRBZSAk8n9IHXn2NBMUW3K7A68fCNmpcnaAJBFch0H1cZ3Ica8pN48nU4/Fu/Z6mzepvMVDxJwReXKBI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DlhZoud+; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730783250; x=1762319250;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=INBc3RGGEqLEkSuSD/Q/S/d+uZ8BCwMFA4gxYUj9SJE=;
  b=DlhZoud+0wvNc7+ToyG5Laq5yQ3dghe6+Tk1amEc7Vw+bF8G+8Z74kA1
   6mwCafOx0TsDnM637QRIIXpIjGcHFiSru+UMnFV/YRhdRR6X0ZdgCFWWv
   SOCsEXyIX5Z1qcF9Gs2Rm7R+sMrjeZcIB3R2xbCrp1Z2qGLGjWeEgUmzk
   qv9Jw+sO12RQv+E5h0Eqp2hkLJd/AZV8xjbtRm4fzjUWRUjAvQa/HNZf1
   vBqsGsdmSb532cQuUhGFk/GkG/7LffaIbgYqaksxg+CJTMyoyhWX7z1ut
   nS2J9aV8LVeYJuEn6ouk3p8P7ngjrWaImwHcixB8+aPjHIcbucbtkZOHn
   A==;
X-CSE-ConnectionGUID: DjTagGCpQ7eEaGZ2iDGfRg==
X-CSE-MsgGUID: EAmHa+W2QLi9Di5dd45ILg==
X-IronPort-AV: E=McAfee;i="6700,10204,11246"; a="34441265"
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="34441265"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 21:07:30 -0800
X-CSE-ConnectionGUID: rGHsoxJaTdG0ekjXdcVVrQ==
X-CSE-MsgGUID: 2Za1mJWwR3Gb18D4OdpvRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="121355823"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Nov 2024 21:07:29 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 4 Nov 2024 21:07:29 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 4 Nov 2024 21:07:29 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.49) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 4 Nov 2024 21:07:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xLQKZZcVn+hyFtlXsURm/1DnSDW2hejlMoEZVqeQ2VtM1e9dnPzH1+gE7HXzhJ1QwEP2zd0to8HWT9xDdzF2Px4fYJQwrg/2fLCYKz4fgEgzfmTbO7boCu//1rwb5vt+Zq0vUXAxr+g5fYh0sSNQ2irayvxpZgqX6PMJbWeMhJBlrBBUCDG+1rkz6HK1H6655fm6hkxoWoVARSBxIk7RwPMZ7WiK23jcpCAXG+vo533SmXMquH2io3JSO99j9GLYoOnDucJ/fQlG/CLLqxH+WXnDT1OfO+3YkG4LS3ylZ203RDUXLA76VNo6as0CAuz7UrXIoux4VpE62tEETdHpyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F9NkXWm+mOD/+iKrtkeS3sacrQfa1f0ZaGO4NbPqzEI=;
 b=CjbyWlnZmkz1oo28AbfuAqEgpfZvVmAjjQMOGqIbeI3Z2mDsxEEJZjgXXqI2CwiZ/IIDcscIX4L+oRrkTO8xvlDOyBuh89BwDKb/Bfp1VFWojIBLiGLlHQwaRkJNDOM17prMPKNajef/SSFR9ZAZtW6ZpekD1iUiW/Lkf3JkuB43cHl5/3YcTlxvhrqoPuF7Q/tjeDv1JkujTHV4RgKItfDEMycES9csy1gdpUTlOed9H+lC6MujjiGetuVYrhUx16L/gL7mddqH5pwiBIvXjfsZ9KcdxZBHbdrVyiu1jc8rniRvl4LJBLORakYlCe+3JeP/Odc9o0CzEYAQD8DoCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SJ0PR11MB7153.namprd11.prod.outlook.com (2603:10b6:a03:48d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Tue, 5 Nov
 2024 05:07:21 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%6]) with mapi id 15.20.8114.028; Tue, 5 Nov 2024
 05:07:21 +0000
Message-ID: <19cf6e84-f137-4bcf-9187-9e67bddc2f8c@intel.com>
Date: Tue, 5 Nov 2024 13:11:59 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 04/13] iommu/vt-d: Add pasid replace helpers
To: Baolu Lu <baolu.lu@linux.intel.com>, <joro@8bytes.org>, <jgg@nvidia.com>,
	<kevin.tian@intel.com>
CC: <alex.williamson@redhat.com>, <eric.auger@redhat.com>,
	<nicolinc@nvidia.com>, <kvm@vger.kernel.org>, <chao.p.peng@linux.intel.com>,
	<iommu@lists.linux.dev>, <zhenzhong.duan@intel.com>, <vasant.hegde@amd.com>,
	<will@kernel.org>
References: <20241104131842.13303-1-yi.l.liu@intel.com>
 <20241104131842.13303-5-yi.l.liu@intel.com>
 <de7cbf75-930f-42b3-beb5-3be697defe50@linux.intel.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <de7cbf75-930f-42b3-beb5-3be697defe50@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR04CA0015.apcprd04.prod.outlook.com
 (2603:1096:4:197::21) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|SJ0PR11MB7153:EE_
X-MS-Office365-Filtering-Correlation-Id: a2d57a9d-085a-409f-0d6a-08dcfd57ba97
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?d0UvVTBIZFNmTCtEWEpxMEgyUTJIZDRSOTlpcE5NVVFjSHBQV3l5M2tLVFdh?=
 =?utf-8?B?UW44c1FLaWN3ZS9JT3ArRFV5SVV6N0xjbHFNNEFJTm1pUWZQRGhiTWV2MXQv?=
 =?utf-8?B?WlczVElFN2xSOGw0RVpURmJVS212TlhBQkVNVjdxbm5uejFZUmdyL0VzS0RH?=
 =?utf-8?B?Q1lqM2R5ZTdXNzU5RjlRUzVFYXV1WGZlbVVGTHBWN0NUSFZ4K1F0dWVXb01T?=
 =?utf-8?B?a2pLeVBtZ3FheHFRUUZpbldWS3VkdWRMWVJaS1FzK3NxQk5Bdmd1OWFvZCsy?=
 =?utf-8?B?Mm5BdzR0R3p1OGxsSW5YZUorK011VnkyK2hMdzA4Y0dpMCtQSGtRVldGV2h4?=
 =?utf-8?B?Si9wNjlFM0JnQWlCdXM1T2VQeG9BaEQxdDRLd09NNzhtNnN0OU8wMUsvMjM1?=
 =?utf-8?B?MHBoOCsvZ05pR2Q5dlVrMkVNdzNoclZyZlUrNjQ1VVorbXVlUy93NS9uVlFz?=
 =?utf-8?B?NHR4OHY2bGJzRDBqZU5PbGRSVGt0Zmxra0V4d1ZYSWltM2xmaC8wcDBDNjI2?=
 =?utf-8?B?OWRsb25sTDFJY3NmUXZUYWtTNHh1U1pmMi9yZFFsbGRJN2hqZTV4UWExYXhm?=
 =?utf-8?B?c1dIWFc5bzd0OE9ib1piNE0xKy9nMDRtd0FkVDFGVllud2diNVVhV1ZWKzFO?=
 =?utf-8?B?TXRMR1pReDR1dkV6cy9sS3ZvYjVGSHJ2bzJMU0Q0TEpyaFU5TXJMQzk0VVpQ?=
 =?utf-8?B?aEhTL0tvU3VHTmZnejlseDZVSURrWkZFblNMRldMSTZEeTUvVUFnbDQwdCs4?=
 =?utf-8?B?ZHFtYm9xWTkwSWJJazdpb1VGV1dqcG5XcmRrOXFXVytiOFMyNm04VGM4T2ZJ?=
 =?utf-8?B?WnRkVUZ5NW1DaGxaWFpSMTA3cTVlUkFpUko5a0M5VDlTVktPQ1lPZ0prSHBp?=
 =?utf-8?B?bnBlcGhhd0ZnVDk5L2hZVmxqRGZpS0E5M05QWnl2NVdSNHZvSWd1aHNCRm5G?=
 =?utf-8?B?YzZFd01acDFHcGJ0RTgxOGZNM3RlbWh0WUFjNEhiNm5GUHJGVlNJK3NoVjBy?=
 =?utf-8?B?N2FqTmJGUWhjdXRlSU9VTm0rcTVMWHZwRXM3QVdMbXA1Vy9WaDUzQS9jUkMz?=
 =?utf-8?B?N1pETjdRSjdXZ1c4SDh0dnp1a1NnZEIyTGU3RW1LYVFNcGpuelFscmhzRDlj?=
 =?utf-8?B?STUxTVc4QW1ZS3pSZDdMYlFnNEdwZUZOUklaUkdqWXUxeGd2QVNxd1N3cUlO?=
 =?utf-8?B?M3RKYXNvVjNJWGxmWStVZ2g4MWYwSUthMXcwS3FpMk44b3Z1ZXJNV200Ujdn?=
 =?utf-8?B?aGhXc2Jlb3FUZ3ViRmNqa3FDbnZHby9hZitENEcvcVJnTXE4Y2JVbWU0ck05?=
 =?utf-8?B?RTVvK3FqNHVtOVlRajdZdXZIWndjREN2cHpSc3FFZURLK01pM1BSQzhaZW5h?=
 =?utf-8?B?NnNiZkJWNHhtUjdFSGtPWks3cEVHZkhtR2xoVVViVzJ4VGtmQ2pZMVFOV2p5?=
 =?utf-8?B?WWp5am8yTDNvKzcwT1pVWEFXN0ZiTHdRZG53MzRFQmZUTnNsUnMwQjhVTkZ6?=
 =?utf-8?B?Z2NPamdzK2xzc2hOMVZMUVVMbXhpdTlvc1hpL3ptZjJ4Qko5T212NkhJa3Ez?=
 =?utf-8?B?NkpQakRtaDcydWJnQmU4MUlhWkVLYnc5byszcmZZU3hsUEQ1bkFhVVVsL0ly?=
 =?utf-8?B?VWRCcytEQTVpYW84SmQrNzRhU1N2WmhTS05qOGZCRHJwaFJlYzNBUTJpYm9u?=
 =?utf-8?B?SERTdmhuWSt6RmJKSHovZXd4dnVWeVdoQWdpUzV0SWF2VHl5S0hqRmxRYUF1?=
 =?utf-8?Q?fwaxv0f9gL0irZcPGqGTgmILByr/F3nw29eT07R?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MjJxMW5FSWF6WVZ3TUllR0lDdHFGWmhCVVF6T0p2VnU2RVM1eVZpcUt5Sk84?=
 =?utf-8?B?bExMVjFNME53NnhjaTRPK3cwOFhpRWdPTFZ0TXJpdUdEVHUyYktYbzQxZVA4?=
 =?utf-8?B?QndFUVh1aGhZN2kvVDRmKzhDNStLSkFVNldJRGt0U2V3a3hsazVQZ2NNaWtH?=
 =?utf-8?B?UGR6TDI0NzRnVStma3V3NjJvcitSUjRWVGo5aEErVm12eHpTRXBjVm9kZ3dK?=
 =?utf-8?B?RnUveHVTSWVnQ3MzQ3JpV2lrYXJpRFBrRW15WTlZVmpsTU1SVTIzckVnOFQ4?=
 =?utf-8?B?b2Y4R2E5KzJBMDYwcE4rY1hkeFJHNkZ5bEFhUTZiWGpXemQ0eVRxVkRNc3VH?=
 =?utf-8?B?OVFFQXpLWVV6UDRMa2I1NXN5cHlLVkZ2RytUUk1TZU1oN2p4MzBnNDJTWnZR?=
 =?utf-8?B?bkJISmpMUE4yYXVaQWNBM0VhTmxqYzZHc245RU5MeGFEdFUrZ3ExMklxbURP?=
 =?utf-8?B?WjhpZ2ZpUWZmNnlFc2xMVWdDdkIzRVdTZ1BXZk1MVVpsNGt0a0hXZndGZEM4?=
 =?utf-8?B?QmhDSlZOd1FndWlNWmVkQ3BxcE84alZYd0toYlRXOHVueG03dFRYRG42UDZW?=
 =?utf-8?B?T1hhbFFINCt0a0VtNUdYaVp5dTZHQWZQZERnblcveUwwZ0d2dFRUTWo1UDI1?=
 =?utf-8?B?YjdDQmhGUGxwSm11a3I3WFlNZ083VEpNdmNrbHROcWoyL1Q2QnBHRnNSeDMr?=
 =?utf-8?B?ZWRqcnY4bFhvcWRORzRiMnBISFNTRmVVeDZzSitIeGlwR1ZlZVQ1Tyt1LzR1?=
 =?utf-8?B?eDBmVWY2NlNGTWRQeHhsUUNhUjJUZVJiVmJTM2tjNnpSeGtTQ1R2VjFvNVNr?=
 =?utf-8?B?dXJXTllFUm16VmxTRmpaY1U3ZU9EUnBjcksrd2FGa1M1ZjlhMlNlUlJXWldH?=
 =?utf-8?B?SXQ1L0psQjhIMnF4cWRIY2phZUc0V1EwSmtKR29CenRBaEZjbG8wdkx5TmVq?=
 =?utf-8?B?NE9tR1VSQnBUVW4vYUR4V3gzc1JaR1BhbFpnUEtCZWk0S2NRUGwrN0l6aFZw?=
 =?utf-8?B?YTF5MTZiNXZ0eEZhRlgrOTdodGFkMENubXA0c2xZSi9xN3I1Vk5aT3JVdHZT?=
 =?utf-8?B?TkFudUgvWTBxL0xpR0p4UlFIWDRLVXNLTlpSRnBNaEJuR2FEeHRXMXlMRzFl?=
 =?utf-8?B?azBIM0lzMy9FZ0JJUy9tV214RUNTQ1FPbHplTGJzSFhSKytJYmcyUTFOOGU1?=
 =?utf-8?B?ZVcvYUg5Q1ErdkR2dHBITjVhQTljcHdlRmEyTTAwV1BXYngyUHZaWVJtNlhL?=
 =?utf-8?B?UTZoc2YveWYzSXdIcFREbDFlc1R4cEl3Vk5GeXNjMUhlRGJHeHZ3Rm9qbW5H?=
 =?utf-8?B?OWpnSmhHby8yVXp0bFRhUllUeWZ5V0hGMlkvUnNsb0RENWlQYXlNZFd2dWIx?=
 =?utf-8?B?WEwzdm5BYXJkVG8zSStQWUZ1ZU1GUDk0ZFpJQ1daVVBWWnE5NEhMOWcrU1pJ?=
 =?utf-8?B?bDhhU0E2bjhIbkE3UHdRcHdnTmY0dTd3NTVvRGNnOGdoamF5RUtHT2J6dE9s?=
 =?utf-8?B?NmJNV2hhVTFJZW55RnNwYlY2SWdRQUtMT0xEVFk4TnRxcTc0d2l6aytxMGhL?=
 =?utf-8?B?Mjh6dktpeDZPWEMyUTlRQlJ2V3I1RkZNWXMyZ3pHMDRCcVdCUTJmRkt4ZTNV?=
 =?utf-8?B?SWxkUVJ2UktaVUZmVHdiV2VyOHZtbHZMT09OR3hVcndoOTFteWd1WUo3Ykxz?=
 =?utf-8?B?aHpkQTRwdHM0cSs0ZHI3Nk5oM29tY1ZWNFp0b21QK0V2OEljVUhxYzkyNkd1?=
 =?utf-8?B?RG1Dc3oxOXRRbmkwY0JoenNONTdsUXF5TTZXTnl1bS9wS2M4MGluaDhVcTVZ?=
 =?utf-8?B?bTNpTEZjZFA5aTRseXJWbEQyTGQ1UWtsbjlINmdHU1ZmTVM2Zjg4OVh5SWY2?=
 =?utf-8?B?VExDcUlkeVVnak5RQWFGd0h3OUxNR1lkUnVHWGp2TkxZNUFxQ3RDK205VVVq?=
 =?utf-8?B?T2lnNStseHJuYndCN3R5SVFXYjc3V0p0UlRsZ0ZDdk9wdWwxNElOalpEd0pj?=
 =?utf-8?B?cjdldDdQK0FqTjVaa01JQjZuaEdxdERwK0ZzZUc3d2RibndLRUphbU8wb3cx?=
 =?utf-8?B?K3F2alV5SlpqMEY1NGZXcHFjcHh6N0JyMjdOaGZoQUZTMm55QnlVcnI2UjFC?=
 =?utf-8?Q?0WjYWt8vcvv59ocDCatT5+fD5?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a2d57a9d-085a-409f-0d6a-08dcfd57ba97
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 05:07:21.5330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8yFFKIUOV9sKOz8dml8iIrIUFE8GLFUBuqi0ogj21n33yrz6kZwluimJHfVi7OM33NGOtaJf/Si5UJPZpYTxig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB7153
X-OriginatorOrg: intel.com

On 2024/11/5 10:06, Baolu Lu wrote:
> On 11/4/24 21:18, Yi Liu wrote:
>> pasid replacement allows converting a present pasid entry to be FS, SS,
>> PT or nested, hence add helpers for such operations. This simplifies the
>> callers as well since the caller can switch the pasid to the new domain
>> by one-shot.
>>
>> Suggested-by: Lu Baolu<baolu.lu@linux.intel.com>
>> Signed-off-by: Yi Liu<yi.l.liu@intel.com>
>> ---
>>   drivers/iommu/intel/pasid.c | 173 ++++++++++++++++++++++++++++++++++++
>>   drivers/iommu/intel/pasid.h |  12 +++
>>   2 files changed, 185 insertions(+)
> 
> Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
> 
> with a nit below
> 
>>
>> diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
>> index 65fd2fee01b7..b7c2d65b8726 100644
>> --- a/drivers/iommu/intel/pasid.c
>> +++ b/drivers/iommu/intel/pasid.c
>> @@ -390,6 +390,40 @@ int intel_pasid_setup_first_level(struct intel_iommu 
>> *iommu,
>>       return 0;
>>   }
>> +int intel_pasid_replace_first_level(struct intel_iommu *iommu,
>> +                    struct device *dev, pgd_t *pgd,
>> +                    u32 pasid, u16 did, int flags)
>> +{
>> +    struct pasid_entry *pte;
>> +    u16 old_did;
>> +
>> +    if (!ecap_flts(iommu->ecap) ||
>> +        ((flags & PASID_FLAG_FL5LP) && !cap_fl5lp_support(iommu->cap)))
>> +        return -EINVAL;
>> +
>> +    spin_lock(&iommu->lock);
>> +    pte = intel_pasid_get_entry(dev, pasid);
>> +    if (!pte) {
>> +        spin_unlock(&iommu->lock);
>> +        return -ENODEV;
>> +    }
>> +
>> +    if (!pasid_pte_is_present(pte)) {
>> +        spin_unlock(&iommu->lock);
>> +        return -EINVAL;
>> +    }
>> +
>> +    old_did = pasid_get_domain_id(pte);
>> +
>> +    pasid_pte_config_first_level(iommu, pte, pgd, did, flags);
>> +    spin_unlock(&iommu->lock);
>> +
>> +    intel_pasid_flush_present(iommu, dev, pasid, old_did, pte);
>> +    intel_drain_pasid_prq(dev, pasid);
>> +
>> +    return 0;
>> +}
>> +
>>   /*
>>    * Skip top levels of page tables for iommu which has less agaw
>>    * than default. Unnecessary for PT mode.
>> @@ -483,6 +517,55 @@ int intel_pasid_setup_second_level(struct 
>> intel_iommu *iommu,
>>       return 0;
>>   }
>> +int intel_pasid_replace_second_level(struct intel_iommu *iommu,
>> +                     struct dmar_domain *domain,
>> +                     struct device *dev, u32 pasid)
>> +{
>> +    struct pasid_entry *pte;
>> +    struct dma_pte *pgd;
>> +    u16 did, old_did;
>> +    u64 pgd_val;
>> +    int agaw;
>> +
>> +    /*
>> +     * If hardware advertises no support for second level
>> +     * translation, return directly.
>> +     */
>> +    if (!ecap_slts(iommu->ecap))
>> +        return -EINVAL;
>> +
>> +    pgd = domain->pgd;
>> +    agaw = iommu_skip_agaw(domain, iommu, &pgd);
> 
> iommu_skip_agaw() has been removed after domain_alloc_paging is
> supported in this driver. Perhaps you need a rebase if you have a new
> version.

yep.

> 
>> +    if (agaw < 0)
>> +        return -EINVAL;
>> +
>> +    pgd_val = virt_to_phys(pgd);
>> +    did = domain_id_iommu(domain, iommu);
>> +
>> +    spin_lock(&iommu->lock);
>> +    pte = intel_pasid_get_entry(dev, pasid);
>> +    if (!pte) {
>> +        spin_unlock(&iommu->lock);
>> +        return -ENODEV;
>> +    }
>> +
>> +    if (!pasid_pte_is_present(pte)) {
>> +        spin_unlock(&iommu->lock);
>> +        return -EINVAL;
>> +    }
>> +
>> +    old_did = pasid_get_domain_id(pte);
>> +
>> +    pasid_pte_config_second_level(iommu, pte, pgd_val, agaw,
>> +                      did, domain->dirty_tracking);
>> +    spin_unlock(&iommu->lock);
>> +
>> +    intel_pasid_flush_present(iommu, dev, pasid, old_did, pte);
>> +    intel_drain_pasid_prq(dev, pasid);
>> +
>> +    return 0;
>> +}
> 
> -- 
> baolu
> 

-- 
Regards,
Yi Liu

