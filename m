Return-Path: <kvm+bounces-64436-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E948C8289B
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 22:29:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3FDE44E06B3
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 21:29:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F034832E731;
	Mon, 24 Nov 2025 21:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RGCmwZ5/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1842D5C7A;
	Mon, 24 Nov 2025 21:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764019775; cv=fail; b=C9hD4lDv9hcGKktqE6FVILwRlPRV9zxMk5kn3ssDhp44Yzz5YRYu3a5dE6e9ejvx/UFERQXOxPCeIXyS6h/vY2XZHihNlIKXgHVAl9Vca0LqfNn88qXCGIPxxMmZWg6390KA/JXjeiI+621xlazXpFfyc2wHsy6yRX6oZTPGLuA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764019775; c=relaxed/simple;
	bh=OStwHhDGXtmaKVbBoutgd4WogLQz22XYQK4lh0Spk0M=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qvRaBP2nyfq6TxW2mE/I1IJ7O+DyjhQwGI/4Ow+3dQs3bP7j6PpX6CKO3Gbj9UXR7tGV4sX50eAZgXUqthpeTrUwyC4XHI1E/kp/PVuy95MQliAR9f/c/q7p8Qoh0ehlg7Fal2ERH7gl8U01d2q3YCgPODcRjRyi4rdnDMde8PA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RGCmwZ5/; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764019773; x=1795555773;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=OStwHhDGXtmaKVbBoutgd4WogLQz22XYQK4lh0Spk0M=;
  b=RGCmwZ5/FaqVFszJkdQf0GtZKJ/iQFtHpeDEDxZVKrkz+awq68w75DX/
   urpOjzEx8Y/8+bddBG86J/tzXagSlZX0v8Up1D5fhi05I+fO8srhlCcPM
   dAPLD3x5bKSx6g+NblOUZqQei278KHjDb+A755eSrbdvhGhVu/COx7uyb
   v5yhcyAHdVrtfHbaeekqTnqP+950VF54w910TkuHDu8tUB4vYn2YgeBm4
   csjOjmSULr74IKmPmgyeGAc4CWdQR4WTjopoPt0VMsrow/n1ple6pg5nA
   W1E3h07CZ6LDBIXwKmcfANBfI2UhLgJ7wiZHxLmJEtma9VW90iac2t56e
   g==;
X-CSE-ConnectionGUID: nDWYJFE9QZ29eclAJ2dwMg==
X-CSE-MsgGUID: Jnxem/NOQ1SIe699cJaYnA==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="65033621"
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="65033621"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 13:29:32 -0800
X-CSE-ConnectionGUID: h6uTdX8ySB6vrqadojEdug==
X-CSE-MsgGUID: +UuJ71M1R9aK6jXFxiLb+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="191587114"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 13:29:32 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 24 Nov 2025 13:29:31 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 24 Nov 2025 13:29:31 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.65) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 24 Nov 2025 13:29:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kIS0ajIO3y6iUpngvDlRyH59+lTPZXGCRtB+Tdv2xnAOWyiJAl7PMQGd2VZ3VvftBczVJkIDVM2RKk8yDt2G4/Is/Wg12aIDikCMdF2dhAeDmnVB4y6Cg+uk/q5L3kwv9OxkZ9Tt858dcNpCaWrLrQpQm/qRZhrv/JgHIRrkbgM61qyOkhIyxuxJQoOhwDdfgnfKkhunWLApw8eaOWLCbqcEpMtl5F2COAgGBFYOsqSZT5/7rJGWHUmK6ZlSNUtxLaiBA10aUKaTV6KeB6rVt0CyEc0iKgOlkIsjrJESXtJFWyBI4wfl4Ecb+sI0tLhMoCpWuo6KygsijUphWNyzyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pQgjPw597nuF8S/uGcxRmZ0VQOhKzB60s+1uWHYNsbw=;
 b=CzCtlscUZxhOePuZw9NuKn71CZlKBcF8d2VWdbxajymWRA5y23NVEJ0PI+rkbw4UwtHgmMr20aJZ0N4BMwAerahi9SgxzpNwNSyo9l1boACmwMnoiwpjHbZ5QMcpUDH6YaHr9jSV+lx2JcPttbS2HXDInXbPgk4YHDEd+gaagiPxX/6K10Vh5bUxURqBrdQBWH4e7OveEDiptd0MVuSNSAkx9XkEeJ/b5kwIpss8lyZn6p4rT10KGELqqxXnf4g7LzK3qc6G3BInGIgo2j1CIXe5ICKYmD2LmAV+OmUKMqmsAGPcoX1h915X2Jd93ZKf3CbcA1lpBbQDRbLiqqkfxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5373.namprd11.prod.outlook.com (2603:10b6:5:394::7) by
 SJ0PR11MB5021.namprd11.prod.outlook.com (2603:10b6:a03:2dc::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 21:29:29 +0000
Received: from DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39]) by DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39%5]) with mapi id 15.20.9343.016; Mon, 24 Nov 2025
 21:29:29 +0000
Date: Mon, 24 Nov 2025 22:29:25 +0100
From: "Winiarski, Michal" <michal.winiarski@intel.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
CC: Jason Gunthorpe <jgg@ziepe.ca>, Alex Williamson <alex@shazbot.org>,
	"Yishai Hadas" <yishaih@nvidia.com>, Longfang Liu <liulongfang@huawei.com>,
	"Shameer Kolothum" <skolothumtho@nvidia.com>, Brett Creeley
	<brett.creeley@amd.com>, "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, qat-linux <qat-linux@intel.com>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] vfio: Introduce .migration_reset_state() callback
Message-ID: <ff23k7d3uhdskwnx42ogdcno72qwkcuxjcbgoocesvjf3saybq@drqmfu6k3bwy>
References: <20251120123647.3522082-1-michal.winiarski@intel.com>
 <20251120123647.3522082-2-michal.winiarski@intel.com>
 <BN9PR11MB52765AD421658A2C867AD77E8CD5A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BN9PR11MB52765AD421658A2C867AD77E8CD5A@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: VI1PR07CA0227.eurprd07.prod.outlook.com
 (2603:10a6:802:58::30) To DM4PR11MB5373.namprd11.prod.outlook.com
 (2603:10b6:5:394::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5373:EE_|SJ0PR11MB5021:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d2709c4-7cd5-4ae0-898e-08de2ba08cf3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WXFXQkJQeGh3a3lyUUVtd3ljeWJSejhReU5nNjE4dTFoUTdXWVFxK3Rwamlq?=
 =?utf-8?B?Q0krM1R2aHF3Tm1yQUFRSUNzZy9MNEVUNjlqdHdiM0NUaGxMUE5kVEF2RlJw?=
 =?utf-8?B?NHk2TElMS24wNWdiYWhXZDY3NVVGQzZER0gxWHk1SVJxbDhpZjJnZlZ0YUFh?=
 =?utf-8?B?Z3QyUDg4NTZJei8veDBqZnBtUDd1SjNwY2lEQ1h6eFZXRndHQ09nRnRCb2tY?=
 =?utf-8?B?U0lUZnRxMUFDNzlDbFNyTStvcFdMMDNibjZNOFRFbURzK3crbXJUYXBZUzdM?=
 =?utf-8?B?TUJ1d1FxL1oyMUc0eWRxRVNOZTZFQ2hVNktKTjZPOTk5ZTA1OTJsZXFPTWk1?=
 =?utf-8?B?SWV5ekJFcDBrZUhLbURxSHNKbGhaTllzMXI1eTI1R1ZkRWxJVHJESi9LWkFr?=
 =?utf-8?B?L0lhTXRqM1IrS3V1d0gwbVhUZmJLMWdFZE9vRGFLOGplQ1NGbDFYb2htcXc3?=
 =?utf-8?B?VVF1cGl0YWpPdTY0OXA0cVY1amhJZS83eEZGaFg0cUQ1S3A1YVRhNlNxSVA0?=
 =?utf-8?B?aFhieWhYdDdwdHNJTzdFZ1Bqc2VORmxKVytZbk13NFUwSUdFMWwvYndSNDFi?=
 =?utf-8?B?VWFNSXB5RUZURTdsc28zdVlYWGxVcWpHUURnN2RnZHFsUVV3NVRuTmxZVmx6?=
 =?utf-8?B?bHFLWXRtYVl2cjQycWNUM0VTZngzSXFnVnRtMmJTa29mQTJkNmRFc241M0hR?=
 =?utf-8?B?SE9LT29PU3d0SW5HbFVMTnpOR2t0bnBKVk45NVAvZ3l3blN2MjIvZ2tiMi85?=
 =?utf-8?B?V1Jqb0FsaGZuZkNhTVBaejlvY3ErNEloT0RGREgxNWN5SFQ3RERKbXRaQ0ZD?=
 =?utf-8?B?dE0xKzhPRTBMSnJoa2h1MmF3cXg0TTVYMEJPL280ckZyRjRtODJnZ095OWNC?=
 =?utf-8?B?YUIwRDUxTXpCOWtOYndheG9rNmkvZHI2WlpROXk5TXg0dmEvb2hlVWROejFy?=
 =?utf-8?B?OHZZNXF3ajFOOFpwUklkY0NsYVI5WnFSN1JsL2tlUVp4RzVyNHJLcU4wMG0v?=
 =?utf-8?B?bktCeHNVa0UyM3BNdGU4RWs0dlBJSjNBWlB4NWNsemJXcVdudVRlTGluR2Fp?=
 =?utf-8?B?ME0rYklPNnpPWlIrRHZYSEVwb1o2UDYvU0lMUzlCZVlGdW8zd0c2UVlzM0hk?=
 =?utf-8?B?QWRXYjdicXVKMGthRXlleXZnZU9IVEFXYVNqalM5NU1kZU9hMDBuYXI5N0pm?=
 =?utf-8?B?SWpycExJTVJlYTREVlVud2tpTVFJVkVmSzE1ZDREdUNHNWF2ejRrRUR2T09P?=
 =?utf-8?B?aldUWUdGdVNQT2c0V2I1Mk14d3NEYUM3ekhTbFgzcUdKeWhkTlRITmdrdDlj?=
 =?utf-8?B?UGJLaHlQa3FzVzMwVTZPb2hXRmZwZEdDYktTU2pQcFoyNmNhbVVTN1d1cWJI?=
 =?utf-8?B?Q3R6ZmZPZDN6MW51MVBZT2FSN3JRSkZEM1grZDhNRGFIek1jNWJxeWdnVUJt?=
 =?utf-8?B?dHdKbVNZdWdPV2FEYmc5ZDJoTysrMEFOTjIyUGdJcUpsK0RJa0NFL3ZzNlJD?=
 =?utf-8?B?N3FTSDNRUGdkTXovcVM2Z3UzQ1dXTFJHYmtyM2l2RWNVdlV2eUF1ZWRrRHBx?=
 =?utf-8?B?T28zemE2bGJVK3ozU2hYdGdNOU15UTlxREs4MGdSaFVqTDUwcDFSMGZReXdH?=
 =?utf-8?B?azFHTVJmVVU5eHdhc2t2Q1NBMlR0eUtwZzJJS1c0eXVOU0x0UlZ3bGtaQnNu?=
 =?utf-8?B?WWNjeWU3NWM3cHFHZzltN2xxaXpZRlNSbTNod21HOHFJK2tlVktuOGcxN1dQ?=
 =?utf-8?B?UFZ3NnNjOXRmTzBpSFAzUEd0MEc4KzJsdEpjYzFqTVl5NFZQcStyamJMY1hu?=
 =?utf-8?B?UjllRW56SHVPRnJqTzlaZExuc1YzamYwTGZUNHpWaXUrajBCcHN3MUVjelVM?=
 =?utf-8?B?KzR4Wlg1T0Z2UktvRDBMdE1CMlp2T1YzdGdFQXppZlpLZ0E1YkpRWEp5Zlo3?=
 =?utf-8?Q?30KmTtHdGnl+qBCegKcWNRXpq1L8ahap?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OG1BRVpMTERqcTNxZEJuWEE0MjBiaHExL1FzdTVLaDU2UXdYUGdGaWdSd1NX?=
 =?utf-8?B?eDRVUmpxbkhhSWZNdFpXZEE1dGtEWkhOeGlLWVUyRU5hVUg1czgvZFY0OEdt?=
 =?utf-8?B?WUJxeTVPK25vcjg0akRWWmJwNEpjNExJZk5RNzYyQUdDV3BMUnNCMWpvdjU2?=
 =?utf-8?B?QUlKakJwczhKaXhhZHA3YnpieTBFYTRCclRjdXN0S2Jjbk4xV1hxRy9sc3lu?=
 =?utf-8?B?SlQ2V28xc2o2dFlRUGZPQVdZTkIzRHA4Z0VUeVZqWVdrTnRNMjJpNWdGdmN0?=
 =?utf-8?B?TEFoQzFqb05IWlRCSFVuUVRyektDMDF5SUM1dUQ1bW1TTnlDd2NJMEk2cElm?=
 =?utf-8?B?MFdvdGtiRWlVaHpNRkdYdmQwNmV5NGZma3NNRkZ5cjlINVhFamo3R3RTRm1W?=
 =?utf-8?B?dnlrTStSeVVUeTNmaXhVaU1uUU5nZzJFTjV4WE1HcUFpem83bjJTT3B2ZFND?=
 =?utf-8?B?YVNoNFRQMEtmTXlUUDdzaitxemhFL2RJN2JjQjdCeHNUeS9taTRxTGRHMm9E?=
 =?utf-8?B?WldVVHJJMS90bGlrc0hEbkpiVldrWG9MMVMrY3Z3Y1RrYTltOWZ3aTluWGVX?=
 =?utf-8?B?SFVsRFgralhucEdXQ3RTSDd1VEhtVDhaalNSZkQxbHMza01ISGRpSEFkNklG?=
 =?utf-8?B?cVJ1ZzZ0NTQxQ1Y3c1BmRTYrY20zcTl4cHlLL3NCckI4OUhoTVcyMTh4WHd5?=
 =?utf-8?B?RGc5WVFJRE9uVXkyYUNwK0txc1FFMGhNV3Z3UjZSRlpEZHA1NERJMWxOZDJO?=
 =?utf-8?B?T0dacmZKNlhrSWg0aWE0SFhRZytzYnBQTXB6cG1lYkR1YjAyRmZwb0M4Tlh0?=
 =?utf-8?B?bzlCWld5ZkVyVm02WU85NzhVNWR0REtHR01DQnIrMVFYM1pCODJFeWNpeXFj?=
 =?utf-8?B?Q1hDWi9tTHNxdTlOT0U5UThacU5Ea29DajlWVzROcHUxUlVHY2ZtbnJTR0JN?=
 =?utf-8?B?TTFlSUlxa0c0a2tZNGpQTVpEbXd1ZE40a1VWclYvTzNxb0N3cU5LS0xoZm9z?=
 =?utf-8?B?NDBqZUo3VkdrKzlkQytkRWQvdE1zazVRLysySDV5eUIrdWtCTGhBelRYMGRP?=
 =?utf-8?B?NGhFelVmbXFEMXBnWExCYmdvK0VNWmpFcmF3STVYMWtZeTM4RDNmc1Q3Nllz?=
 =?utf-8?B?YjdsenlMWlBCZG9rYUhrcDM1ckM2UUlnazJjM04rN0tHREZ1OGVzUW4rN1Nt?=
 =?utf-8?B?VVZiYXV2TmFKOUFRNzRNUWNETG85eEtwV2Rhc0RBQlNKbXJkcW1aV3REQ2tS?=
 =?utf-8?B?Z1Z4ZDdnNFd1OWZVTk1yUkZoSjEySWI3MmNEN0g3amZNS1lmQ2xqUFJEbHMr?=
 =?utf-8?B?cmxkVzQzZDBlKzdlWTlINm9QVkdydzF4UG5UekJWL2xzUFVTOEs4aU9zNmZ6?=
 =?utf-8?B?N29iYmhKVStHRU1vWVNoSWIxM3RjVHJRNVBqRjFITkwxaHJZUVEvVXkwdFRM?=
 =?utf-8?B?RnFFM28ySEZpdkZuQXU1T0E4QXQzZ1dNbjZpWEJoTXl0U2VXelIzMjR0NzI3?=
 =?utf-8?B?VVc3QjhSM1dZWGxWNDEva3QrVkpzM3Znemk2bEVoNHpTUEt0cjVObnRWWXpG?=
 =?utf-8?B?ajZwUXp5S2FXalV2WXp1WG5XenM0MDhNY1RCNFBxUWpjSVlia2oyS2tFa09o?=
 =?utf-8?B?QTRhZnhVYUcrN2Z3Rm4zNDJBK09qeGN6Qm1OOVNXRXJBdnEyazhtOUlOQ1ox?=
 =?utf-8?B?cVhuV2dHbjNTUzBONnJQeGNKRGtIOUI5S2xqM2JNS0VXNzU2ZkhGeW94VGtT?=
 =?utf-8?B?bDkza2d1bDZTVGNrM2NsS1hzSnNCSGRXUGhBdzllTFlqaklQcXN2R0NuTFVY?=
 =?utf-8?B?dlRmV25EaGVkNXZkNTJwZkFwMVk2RWFlOENXalVZSVZqVS9mc0lxYjBHdWZM?=
 =?utf-8?B?blFBQWV0Mm41ZW5pNHFTK25ySDJpaFFzeEdKZGpJMmMyWERKbG5jUVVLTnRy?=
 =?utf-8?B?cXFNbDF4S1AzZ3U5NzVvZ3EwbFpkMzhXK1JpZG8ySmp6TXljd3F0aXBCS2pT?=
 =?utf-8?B?U2dXOG5kU1d3aCt1eGZZUThtSzBLRTNrbExJbFM5OTFLeUxYajhKSENIRXFi?=
 =?utf-8?B?NEo5bytLR1lDOXNzdEtMZ0F6QnFEN1F3NGRJVTIrdTRuMW5QcTVIclZYUDZU?=
 =?utf-8?B?d0pRVGhwL2FoSFhPRXVVeHM5MkZJaEVkNFIyNmVjb2s3OUt2YkRHVXIwYnFz?=
 =?utf-8?B?dnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d2709c4-7cd5-4ae0-898e-08de2ba08cf3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 21:29:29.4404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eiAU442mBDF0jWnO+vt7zp4V2kIdnhMlG81D86zfSy/nGrPzc5D/x9B4kns190o+EJrXTH36fpQbFLoYMJgu/gTusd2DEW/gCUybaEudH94=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5021
X-OriginatorOrg: intel.com

On Fri, Nov 21, 2025 at 08:13:38AM +0100, Tian, Kevin wrote:
> > From: Winiarski, Michal <michal.winiarski@intel.com>
> > Sent: Thursday, November 20, 2025 8:37 PM
> > 
> > Resetting the migration device state is typically delegated to PCI
> > .reset_done() callback.
> > With VFIO, reset is usually called under vdev->memory_lock, which causes
> > lockdep to report a following circular locking dependency scenario:
> > 
> > 0: set_device_state
> > driver->state_mutex -> migf->lock
> > 1: data_read
> > migf->lock -> mm->mmap_lock
> > 2: vfio_pin_dma
> > mm->mmap_lock -> vdev->memory_lock
> > 3: vfio_pci_ioctl_reset
> > vdev->memory_lock -> driver->state_mutex
> > 
> > Introduce a .migration_reset_state() callback called outside of
> > vdev->memory_lock to break the dependency chain.
> 
> so it kind of unifies the deferred_reset logic cross all drivers.
> 
> sounds reasonable as nobody should expect a concrete sequence of
> a reset done vs. a racing set_device_state.
> 
> > 
> > +static void vfio_pci_dev_migration_reset_state(struct vfio_pci_core_device
> > *vdev)
> > +{
> > +	lockdep_assert_not_held(&vdev->memory_lock);
> > +
> > +	if (!vdev->vdev.mig_ops->migration_reset_state)
> > +		return;
> 
> mig_ops could be NULL.

I'll replace it with pure mig_ops check, as the migration_reset_state()
is not optional.

> 
> > @@ -1230,6 +1242,8 @@ static int vfio_pci_ioctl_reset(struct
> > vfio_pci_core_device *vdev,
> >  	ret = pci_try_reset_function(vdev->pdev);
> >  	up_write(&vdev->memory_lock);
> > 
> > +	vfio_pci_dev_migration_reset_state(vdev);
> > +
> 
> only if the previous reset succeeds.

Ok.

> 
> > @@ -2486,8 +2501,10 @@ static int vfio_pci_dev_set_hot_reset(struct
> > vfio_device_set *dev_set,
> > 
> >  err_undo:
> >  	list_for_each_entry_from_reverse(vdev, &dev_set->device_list,
> > -					 vdev.dev_set_list)
> > +					 vdev.dev_set_list) {
> >  		up_write(&vdev->memory_lock);
> > +		vfio_pci_dev_migration_reset_state(vdev);
> > +	}
> 
> ditto
> 
> btw some reset paths are missed in drivers/vfio/pci/vfio_pci_config.c,
> e.g. for vFLR emulation.
> 

I'll add the missing paths in v2.

Thanks,
-Michał

