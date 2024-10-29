Return-Path: <kvm+bounces-29930-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 224589B44BA
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 09:48:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 989631F25375
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 08:47:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1F8A205142;
	Tue, 29 Oct 2024 08:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Kli0qISP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2069.outbound.protection.outlook.com [40.107.243.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7C1204941;
	Tue, 29 Oct 2024 08:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730191586; cv=fail; b=r33WUpkN0uDe2eXwF6Ea6FUYicXEA32r52v+U3spabvmoOUzleXfq0KSLmVzrAge5RMvsyiHCHGGtOuH3JIpjemPSioEd19eR6R+l9Z66jGZoPt2YXqMMiE+AxPBI2uydrq/K9vBg7rzpVWnhDxENAO/f30bd18dzjUiaXYCa20=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730191586; c=relaxed/simple;
	bh=hJpBwDvc+Tjr54UKBRma+C0JkRYAVGi1oVZl8hNq3nw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=h1VB2+YKXFkF2OWWpjo1QZJLbLp4Iod9i3todygfb1vzaDTXSobw2jMCnj4yDIPOMU++4+bNduOtzrPQkZ2erZnEyfnkM71nj5nY3yZrbaaYwwjdJ4cy/uqEOuGp48CaMkItPy20CbtNVEftI0rSqYJDwOBfobqfLVBtMGM5WLA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Kli0qISP; arc=fail smtp.client-ip=40.107.243.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J585QkpB5VCSkNcT9tynP2NZtFGvTiH/XjsFi3cElCENVVKD+py8FZGICeWqYqP5Y8840o09H+lA0Qs46ZQCoK2OESEKiJeqSVsemBrdYUczOWw/1l3646Wt8A401CwsKuM1G4Yy0vsEqbms0lu+qd46+mbFh5G2x1AQaRWJWzg6yIuyme5XqWnf38JEM+hMKWKVa+Js/a28KBU4EcfAqaQrOqY55vwtm9ZTvBaTBSOBIErR3SSc/xzsnAVmoSjfMkeaJLe17WWXcUnY6RdvK1IR1qElbdqLU2du4eX9NKRCVBOfpF/hnms5Tq5wYxKkQMRgls+Q+zJwnVlxqDKw5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hh6FTGK9jDlBCG1dcOGjvn6yixR4GJ3OEdQ20//1YdM=;
 b=fErjRis5LL/KSxny4kukTbwOlM5cZc6YzWOPPoWTjrQBhg8kny5C9y9dGbXxweUAeEjtvRKEIvmLDopQtwqhnnkSvY9t/U/nvlSsZ7MJOMxtPPtK9CUZKlZgdSgRAf1ul6EM1oTDi2QwpQs01Oxt7eRnJQ/RDXngoSvgxMC+g5AKLRQJcJ7p9tlyqTF7P5DIyEU0b+tlo8Sgg5WicBncSLYYtXgMO10pN89p5OWadoUu3+4zlJchkB9yYrFNj/8MFOKzeBa6qqgmSFop4F5f5gnSLLoJHpeK3NxlAYcf0jJnSCBVZtj+k+cGHPKgUEq7aO9D3ONM5KG7i+Hhgs3TXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hh6FTGK9jDlBCG1dcOGjvn6yixR4GJ3OEdQ20//1YdM=;
 b=Kli0qISP696syjfDWCu02eRpuvsCb6YykGmPXuEhRtoX7DfQ2P7RZ2f2ggQFiqSOSzJeix+XClgtZB8rcXJQnIcs475ZnJoP3r9LyHm8b+2zlJFjRFhGeRN6ii5RcOKTZ3Oj71/ytBeDG7rjEvu1CdatpWq00Un6VK0O3T/ibaY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 CH0PR12MB8551.namprd12.prod.outlook.com (2603:10b6:610:186::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.27; Tue, 29 Oct
 2024 08:46:22 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%4]) with mapi id 15.20.8093.024; Tue, 29 Oct 2024
 08:46:22 +0000
Message-ID: <56ce5e7b-48c1-73b0-ae4b-05b80f10ccf7@amd.com>
Date: Tue, 29 Oct 2024 14:16:12 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v14 03/13] x86/sev: Add Secure TSC support for SNP guests
To: Xiaoyao Li <xiaoyao.li@intel.com>, linux-kernel@vger.kernel.org,
 thomas.lendacky@amd.com, bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20241028053431.3439593-1-nikunj@amd.com>
 <20241028053431.3439593-4-nikunj@amd.com>
 <3ea9cbf7-aea2-4d30-971e-d2ca5c00fb66@intel.com>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <3ea9cbf7-aea2-4d30-971e-d2ca5c00fb66@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0009.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:25::14) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|CH0PR12MB8551:EE_
X-MS-Office365-Filtering-Correlation-Id: 60f040b1-74c4-416e-fe66-08dcf7f62a1f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?alZnUG04WFR2TUZ5TkgzVHJPdE9YZ2RVeWc2bGEzbHNsckFJaW5zZmlMOFZk?=
 =?utf-8?B?RDJETXlnbFJvZUFPd2hpek82TDJLT2lSL09KdXk2cG1ES2svMGlIdnl0WDAw?=
 =?utf-8?B?SnRzbzJPajdYZGIxSzNsRlV3STBNK3NLUU9Nb0lsa1BXTFF3eGFtTFUzbjZl?=
 =?utf-8?B?em5ZL1lLcDRUUXVsMWVVZHMxTzhsUFdscUJVZ09KTjZRMHlDRXZZQWU3L3Z4?=
 =?utf-8?B?aXJVblpGOVlJT1BzK0xQeWpJeFdjUk44U1VVeEZKTnV3RlVHWFFTQTZMcU1u?=
 =?utf-8?B?OEc3RFJSdHBFc2liRWZMS0RTMWZMZlVZWUFXcm1WWGJrNTNUVmxBN3FJbDBw?=
 =?utf-8?B?UWdlMnVkcytra1h1cFl1R25rRURWQjU3a1NzQm1iZjJ1bmtLSEZhNFU5K3RF?=
 =?utf-8?B?NEE2NXJ6cEV5WFNCVEVIR00wQW9kZnRTSE9CaU5xWE1hUjc4QWFSS3Ryb1U5?=
 =?utf-8?B?UXcveWd1Sm1QSXdwQ0ZwZ1A5bm1Ld25iQnhNdUl4T2FqM0s5cmVYVGpFWG9V?=
 =?utf-8?B?U3dxaFlxYjBSb0twQW92SGFSdEs3L0EzSUhNSkNXZ3BabjNmOVc3bzYrbmZF?=
 =?utf-8?B?ZWZuVm0rcWorY0F0aHVCNG1GM280VFBIdUFuc2UvYXBtcUFFNW5RQW1LN0xD?=
 =?utf-8?B?WWNnQlBtUTZIOTh0RGNCTEdJaVVmTjNBdWFTM3R4S0RDdXRoM1dxbXMzWi9D?=
 =?utf-8?B?NFE4ak1YU1RUM2lmUW4wSHRBSG5Ld3lmbTBTalJPcHIvS0E1eXFtMDZnU1lE?=
 =?utf-8?B?Z3R6VnFPOXVOdlBHYzd6NklJY05EZnN5L1oxaVRKL1lrRFFGUm93S2Z6OWI1?=
 =?utf-8?B?MkI3Y093S2VHTzlwdjNMaklvTGdnN1FMR3JDNnQyR0VCMkNabFNrL2xycFk0?=
 =?utf-8?B?RjRhQVVIemRKdExkYmVDZkJCZjlhQTBLdVdtS0xrQW9kLzFjZVI5NmJ4SlN6?=
 =?utf-8?B?c1dFUnR6Qll4aHd5V0xFS1hmNjVNK1ZNalFyTmxIS2Fza29kQ3dSc3hyMDhz?=
 =?utf-8?B?S3AzRjRJRHlDbk01Y2pLcjZDamZKZHZyakRFVHdBUXBVWkZwZ3ZtcC9qWkpl?=
 =?utf-8?B?eHEyTVU4Vkg2amRnLzltbkt5SVp2T3NoZ2VPSUp1UEZLRFQwNEQ5TTJ4cFMv?=
 =?utf-8?B?blVnZ1hsNHhSSHhJUzV0VWFxbzI4eDJnWlMxOTlCTmNlTDhHejhFMTM5dHZl?=
 =?utf-8?B?UXNpQklQQnluVW1vQzUyanI5a21iQmdQWlhyd3FIRVZ3dkNnSzJUNHZJN0hm?=
 =?utf-8?B?ZXd3Y285RzFwZDFtcjNaS2JmNGFPUTdiMVY5SVN2Vzg0TEFyQzJibjZlc1Fr?=
 =?utf-8?B?WjBDTUJtamxva1ZIa3F6M1VrRTJZdWNYZFlMUndBeFdBL0VmcXAxMWkzRjM4?=
 =?utf-8?B?Nld2VHF6NitsUVNueENlWWNYbGNIMVRRa1RnNXN1ZHZQVzI4anZId2lYTk45?=
 =?utf-8?B?VDVFN0hyK2xrOVluQUZIazBFa245VzgzUXcvMWdlUWNCZWFZWmo1Q2lrd05C?=
 =?utf-8?B?NlVoTFp2L05jVnVMK1FKcUkvK01GN3dmVG9FUU5DVW1ON3Y4LzZ4RkNDUjI1?=
 =?utf-8?B?VlE0SE5kN3RmTU92R01Ddjd3bUdZYzZPdFc1WmpBUW94RW9XOG9OZkRTYWdu?=
 =?utf-8?B?SFdQdlppb1JobjdsQXVwcXNKYmNZOWdRdkJEMFZFZVM3b1FvZDRFcHphMGxo?=
 =?utf-8?B?VmJNYlYyVXhQQURiZFJkZVA1NS9qUm5Db3l1bURyUFVjOTcxWEU3eFhUM1V5?=
 =?utf-8?Q?kG6VPpVDpTUfLjZOjzeozpNoVs8m1+OLAddjIMD?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MEVDTVZvSXE2L2FJc1o5Y0Q2Ti9CTWROLzdCVzk5UllaNGlId29PVUYxRlU0?=
 =?utf-8?B?aVJ1OElWQ3FoL0tjeHFaRmVWWE5YNkhaTnNURlJ4WmVGWUk3TGx6N0hKNzd3?=
 =?utf-8?B?ekJmUzVJOUtCdFMvbkxURXBYNnN0czFFTUdkOEpsRzluQnNkUit4Q3dLQ2Nh?=
 =?utf-8?B?ams1ZFFMWlBXTmowaGNBQnlJenZlMURNclh3dVVKQzh0MnByVVp5aDVidmpP?=
 =?utf-8?B?Qk9iR2VHaURVSGpJNnFNdDNZeUxoNHlqblB1T0lEaGVBcnpBNllFSU1sOHVV?=
 =?utf-8?B?cHhxd2lsMmNWVWtrK1JlWWxnbURBdDY5THRpUmRib091NGJhcTRlYUxJYU9O?=
 =?utf-8?B?eW9tMG5JbnFTMWxaV2tPdm5rcFp2TUNSUVYwNm84VTR0aEVUaU85cGFCbEhm?=
 =?utf-8?B?RjRQTkhBVDVCM2Z0YnhmQjB6U3B0aUs4d2FaTEQxT1dabUNHa0tDalAvQkow?=
 =?utf-8?B?ckRZcklPeTdHbldIOGdtMTVXM1cxT0FwUW0wa1htbnNTNW4zTmt3NlpXMm1v?=
 =?utf-8?B?SWJPQjJ2ZlZZcXI4Z1pWSjFxcTR5NU1rQzJYbURxWnFuS3dDRU9KT3dXRzd0?=
 =?utf-8?B?MGhOcUIxSWFyaTlLN2NpdXJOVkNSb3VCVHBuUDVNcURvR05DNXRPQVpmQlQx?=
 =?utf-8?B?cHR2bHlXcmVreU5pM3c2b0pHWnpYakVmYzhMbVpMTWRPd3JGY1ZnbkFTUFNm?=
 =?utf-8?B?L0U0OWJObS9lUFMzd0tZbkdsaG00cm9GZUhWVnk4V01mVVhyVDJhMy9vNGN2?=
 =?utf-8?B?WWtpaml0VzI4SURQZjE0RmpmTFovUy9Bai9BNGxqRGdrTlA2anlxbUM3cUFt?=
 =?utf-8?B?YU5aMkxjazNsQkhBanpXRVBlR0oveFJYZDhZQ0JESmJodXFLVy9GaWVyRHBn?=
 =?utf-8?B?UzY0SVN4bVZkM0lqSWI1c1BXb3kzTDVod2sra1RldzNiZjRxdjh6OFByZVZD?=
 =?utf-8?B?eE94R3Z1dS9QZ0xQbDV2VklVOHRQaDRCdExKcTU5NkgzQ3NpMWFjbW00QTNk?=
 =?utf-8?B?aVltVVhrOFdNQUVsWWF4MnVuQ3VoNnB0d0xtV25VSTB2eTdhZDIySjlnQzZQ?=
 =?utf-8?B?ZXZudmxKd1ZuUFVTc0UvMDlweWdma2lnS2RteDFhY2d0VDJDeFZOcWV0WDZR?=
 =?utf-8?B?THZXZjF5WFQ4Y0V4d3p2aVNwVTVVNnhhZkk2NkVCSWhSVG9NRVVHM1NxSFZx?=
 =?utf-8?B?cFpwa1htQ3VyMkJva2YzUGhhVEJsTHVHRVNCRVVnUG1LVmZlWDBhNDBQYTFh?=
 =?utf-8?B?dGtBbG9PaTFmWEI5bzRHU2MwTU8zT2ZDbXFFNC9JRCtqSTNpaERUVUM0MUpz?=
 =?utf-8?B?QTBOOHprd1ZkMjJOQUpwRWwxM09CNmw0cFpPOU5Uank5blVjZkJ0a21jQjJw?=
 =?utf-8?B?cEphcGJWNDFHMHYwdTlYNFloS2JNSmlSbXc5eG1LbEhwbEFBUzJoakttUUtM?=
 =?utf-8?B?V1QwRnNGWVhmM0hlY2dJSGRzdW5DdkpsRlFWM0w4M0kxS0pTb2drbDBKNW5s?=
 =?utf-8?B?c2xsSnNjbkxIMVRXSjljeG4vb0ZTZ3g2bUZObnA1WURDQ2pkQXlmZkd4TmZT?=
 =?utf-8?B?VHRSdVlEOXQrNFZadkwrOSt3elJlWHB0dXp3U25WcHBSanh3bi9CM08rOGVh?=
 =?utf-8?B?aUk0TDFJZUs0aWVkQ1ZSK1pyKzV5QVRzVUloTWlvVjFGRUgveHBTQ0ZUQmYy?=
 =?utf-8?B?T2hXRzZKZm0rdWhlTEI4VVhMaCt0U2NVSmsvSGVWWWhjOExlZ25qNzZKK3Fv?=
 =?utf-8?B?RTk2dTBmMGNLWDg1OTRiU1JRT1Rzdmt4WlRTdFp6TlpUMGxiaVppY0hQV2gx?=
 =?utf-8?B?ZjdMY1FCSTYzL1NldUpIRjYzSjBHOTVHQVlzOGJEQzV4akpldGhjMm94UWsy?=
 =?utf-8?B?aHlpS0V1VnNNKzI5YWhBaVgzMXFYMkgwV0Rra0o2WmdzZGs4Q0ptOWNHbW5n?=
 =?utf-8?B?c2ZYdXRENlJTM05ZYytNTHpBS2szL3c5elN4T3ZycmRuamwrUHc2WEJQWkZn?=
 =?utf-8?B?L29jUm9rVExlN20vZCtsTDU3NmYzVUFISlh0dVNMbHhSOW1QaWQ5U3ZmUlcr?=
 =?utf-8?B?RCtFdVNiUWV2THNRU1JlWFlGQW43VUFKUDF2a0ZZN05aM2dKUVpKdzlIcm9m?=
 =?utf-8?Q?gO580bkvgqHQh2v63IodndvPv?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60f040b1-74c4-416e-fe66-08dcf7f62a1f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2024 08:46:22.4099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6FJR23Emvl4f0rlLM1rkbCHQKGCQZS6VR5rtOBk4OvcKj0FPBiwS8P65lOEQ3qxeJiQCY5CooyBnxf589ftfkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8551



On 10/29/2024 2:11 PM, Xiaoyao Li wrote:
> On 10/28/2024 1:34 PM, Nikunj A Dadhania wrote:
>> Add support for Secure TSC in SNP-enabled guests. Secure TSC allows guests
>> to securely use RDTSC/RDTSCP instructions, ensuring that the parameters
>> used cannot be altered by the hypervisor once the guest is launched.
>>
>> Secure TSC-enabled guests need to query TSC information from the AMD
>> Security Processor. This communication channel is encrypted between the AMD
>> Security Processor and the guest, with the hypervisor acting merely as a
>> conduit to deliver the guest messages to the AMD Security Processor. Each
>> message is protected with AEAD (AES-256 GCM). Use a minimal AES GCM library
>> to encrypt and decrypt SNP guest messages for communication with the PSP.
>>
>> Use mem_encrypt_init() to fetch SNP TSC information from the AMD Security
>> Processor and initialize snp_tsc_scale and snp_tsc_offset.
> 
> Why do it inside mem_encrypt_init()?

It was discussed here: https://lore.kernel.org/lkml/20240422132058.GBZiZkOqU0zFviMzoC@fat_crate.local/

Regards
Nikunj

