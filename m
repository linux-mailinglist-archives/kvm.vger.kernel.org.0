Return-Path: <kvm+bounces-38796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D9B63A3E657
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 22:06:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 202603BE5F9
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 21:06:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8348A1EDA1C;
	Thu, 20 Feb 2025 21:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jxMuqgkI"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2046.outbound.protection.outlook.com [40.107.237.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9FF26462B;
	Thu, 20 Feb 2025 21:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740085562; cv=fail; b=rosRWE0toNpc+bsjsWN+e0uBWbM19JPL85f9Nm9lcA7bRVSp6BGU9g7EumXfEOcrEVlPIFgXWoVktV7qqdh5lKtErhc5SjJY9C9I1cFBPntT92NCni2JDrmU5mbVTlIFXRdXkRh6SDKTWyqfFXMPQsiR8Nh26OwNMSVPHhWWDWU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740085562; c=relaxed/simple;
	bh=UZahu0ccT02O0cA7wGnvsqRNYsu36ZWKTFPq4nH274o=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TNjJYFewZlbPqEXsya2ih2Wp5fwN+03swuBbzMRJn6vwY4VPo0CrdX/ACteaOiiweTS2F6FIsBVzqy6jlWHttDVzsfFoAmCkc0q10zvFfJjyzdZlbp7vga1T+H1qAmtnX0PY/X87euXdAN2az96HGWNpgylXwmdb4xFpgd7WuQA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jxMuqgkI; arc=fail smtp.client-ip=40.107.237.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LYj0MCD0f68TTC5b4INLveGABSO7kH7LgNNU1sb8EVfahXS7O228sMfreuHmXd5v+kR8mZXPqIvaEcfDjj5AMPGSCGHdONd7nSaGmBSULpKSk6c2Qrn7YmIRTU8SiUfOk6KNulz83I3+Za3pk+Ynrss53F9XIDAOmElmw7PEiHOHordGF1WbZSZK8LxLhg2xVCEgInPoimrxhD3/tT8N3i74mAgs/tAIwLPBY3asqHEE8t418vQtSFCsGsw+s5y5LPjkuGXTirCF7N/9l3w4qrDRz3uQPigOc2d6UM91cifqeGWmXcAFLZq3b1oVPAonEoFy49RywocnTQersySFiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TkZBEYOFrROBlKDzUZZfwdDDGcjytwpyFhj/TWoDAMo=;
 b=Cw7ZCSgAiDkd7o6UqA3hwzlWKvg7fw37ofwWDmxOKF5XlwTiiDezzmMdlwnO/94QsYbj4DQhjEiukNvrtsLNwGvRaTaIKDUZTU6ILZL+w3/wm9+/tOVOpY6WQlOi2H9OpCxmTQW6lpVCuT3Fb0+OATTyyqt+7qDL+k5OVBlQdbkG9xMAO7C2QweRA1ElNdaQvJXOqivesZfiN7gAHPGSnk8nfaECIqFF0BqwRoTZ0ibBDYC0lrLwnPUgvfHgV/MTQ0SXzXq7CbtcINHuLKM5hlGCPzwqvL7C7xzvkNhUKf134I+qfP/YmL88dpOXqC74dzmbV2Dp+qyC8bGIZYyIHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TkZBEYOFrROBlKDzUZZfwdDDGcjytwpyFhj/TWoDAMo=;
 b=jxMuqgkIBJdxoAAOysCRIq+Q+QpSoKK6A/y6LRcZtYuslvdxG3kwpEZXnA9GpHKLV19e5zu4EXdMLpVLw7DHBJUO8vM8bN0Hp3/xsxTzx7syDw9jHnlaf0RvFjDoV6VeclZ4g3OJnXTHzKSSVlyO62iV3T0i5Xb+4kk5YyPpLao=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SJ0PR12MB8139.namprd12.prod.outlook.com (2603:10b6:a03:4e8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.14; Thu, 20 Feb
 2025 21:05:56 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8466.016; Thu, 20 Feb 2025
 21:05:56 +0000
Message-ID: <491714b8-6cb7-ac0f-862c-7fdec3be5175@amd.com>
Date: Thu, 20 Feb 2025 15:05:53 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v4 7/7] crypto: ccp: Move SEV/SNP Platform initialization
 to KVM
Content-Language: en-US
To: "Kalra, Ashish" <ashish.kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au
Cc: michael.roth@amd.com, dionnaglaze@google.com, nikunj@amd.com,
 ardb@kernel.org, kevinloughlin@google.com, Neeraj.Upadhyay@amd.com,
 aik@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1739997129.git.ashish.kalra@amd.com>
 <8ddb15b23f5c7c9a250109a402b6541e5bc72d0f.1739997129.git.ashish.kalra@amd.com>
 <68daec1d-63b3-ecc5-f8c3-9df8a905ec88@amd.com>
 <cc89eda4-d1f8-48e1-9bfd-d550846e2d84@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <cc89eda4-d1f8-48e1-9bfd-d550846e2d84@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0040.namprd04.prod.outlook.com
 (2603:10b6:806:120::15) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SJ0PR12MB8139:EE_
X-MS-Office365-Filtering-Correlation-Id: 4035f9c0-b4f9-475f-bd22-08dd51f25e5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|1800799024|376014|7053199007|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M2tiT2VRbXFLczhKR0R1YkJNQ3ltQWFWSmU1SENIZzVXVjlxU2pSTHNNM04y?=
 =?utf-8?B?TDJVS3h2T1VRcEYrNjQyQUdFZk5UbkVOSDZMVTF4Rlgzcm5MbVFIbnVrQkNI?=
 =?utf-8?B?dlI5RUZEU1Fqa3p3RnRGc1R6VUtqSC9zSmEzWGZvS2FxUkRRTksxTjJRODNP?=
 =?utf-8?B?b1h1Rk5paklNVzg0OS96N0VnbmQyZ3JhZDhSbEFHeGpoaXd5d1p5OWF3ZFYx?=
 =?utf-8?B?Skk4WEJqRjYyRCtwL05sRW1GNzQ3RnB5UGd6SGQ0cVR5cnlrNG5admREU3li?=
 =?utf-8?B?dmRNdEgzTExTbXJxeHRZVjc5VkpYdTVVL1ByeXpQVmp3dWMzSlo4bEhQTG8r?=
 =?utf-8?B?dmpCNk1UaytiajB5RkZMV0c3UkR0ekpLK3ZPSFJtU3ErdFBGVWZDbFFQa0lS?=
 =?utf-8?B?aC9tNXM4ZDNwcjVIRzhPNmdydHFnM3hLN1lQY2JjRlI5RFluM3ErVVVNa2Fn?=
 =?utf-8?B?alppUlJCa2JBZWZOeUUvK0p5eUhWdi9qSEtjMUM1UitqTWx3TFdhUHcrRnZR?=
 =?utf-8?B?U1RiWXQ4bm93bWx2dG81R1VzUVVha1locG9iN3hPZnZDOVovSkN5dnl1VVlo?=
 =?utf-8?B?Zk1CcFlJaW5pVE1TU1kxYUNUb0VTRXc4VXpCSTJXTmFzd3dKNXhSRlgzNzY0?=
 =?utf-8?B?RW9ZblVBdDRjelU0Wm55QkNvbEVhRmkyODh0SnQwaEI4SWlqeHRJS09POTZk?=
 =?utf-8?B?c3p2N1FQOTRTMUxEbHdKQXJJekN1aXQyZFcyOE94bklxU0UzK1Z5OFFJanZj?=
 =?utf-8?B?MkQwWjY3UzUvRDkzd0F2a0dqSWZKR3pZMWZNb3VMdGxGcXlXK1FNblVHQzJt?=
 =?utf-8?B?TThaZ1ZrZkN5dEN5L1JoUEc4L3FqTHA5VlNjWEpVYmlqOWU4ZGlyMzFQYUdQ?=
 =?utf-8?B?TVc0YlJuNVM3Y3N0VGJSOSt2bW96NkRCN2ZxK1A5RE5pcVlERzdVb1VZb01a?=
 =?utf-8?B?dkw4enptM2VYeS8zOXZlYnQ1WUhkSEFFSnJuWTllRXc2YjMzdTlENFNtRCs2?=
 =?utf-8?B?SXFzbnlSamhuNFlzZkpMczNuT2Q0TXZLTjZFVEs5WGU0WEg4R255N0JReUh6?=
 =?utf-8?B?YnJKRko1Q1BUNUlKT1Ara0c4WTJXMXp2Vk9IUHJRZDFjYndxNUpMRGZTTXVp?=
 =?utf-8?B?SEU2ZmlaQjMvWFhUOW5zNXlhVDJzb3pqQlQvaUFuRloxSUxQdXNtT3FsZmc0?=
 =?utf-8?B?UnlPblNka0tkZVJyQUxwa0hVd2pEbHl1OEZPcWtTbHpMQTNiWkt2Y3BQSlhi?=
 =?utf-8?B?eWtvc1VzT2NPTWdoNGVwQUZWTjFUQnJRVzJYVzlCdWp0RjBQSWYxaTlUQ0p1?=
 =?utf-8?B?UGpwQWpKSmlZd2dyTzJLa2FWaXhOeENWZld5YzQybFpsai81VStyU1M1UU9V?=
 =?utf-8?B?U2hCdmJRODZURGErYVlkWVZBNmVTSDB2NHlKa1lRbGRYVlVNWnJxdENrRHZr?=
 =?utf-8?B?MDlkdTVSNCsvcnJxWFNmODdOcU92N2IxMWtnQ1NnTk5CTzI0dWRsVzdabm5D?=
 =?utf-8?B?UFFUYmJqVGVmWWdwU29sZG9zeWNWUXlFaXZ1S1JlVmdWQzhoRWxaVXlBZ1Fv?=
 =?utf-8?B?ZlkxRThRS3hKbllEZUhqWmxLUHI2MUsreFBoa0M5RTNYT3lSVm1oSGdCdWhw?=
 =?utf-8?B?ckpXVTRsQlFJNmdSakVkMStKUlZVclhNZmp1K3Zpbjkzb2VPbUtsdlhidWtv?=
 =?utf-8?B?MFpsNUd4b3J4RytVNWxwZnJvUHNMTWdZVFF4QUJVSitmaGp0eHJCNm1jRDIx?=
 =?utf-8?B?Ymh1WHd5QU13cVVFQmUyUWtjNEdscVZPZEM4Z3lPZytEOGF6bU5ycGRuVGJi?=
 =?utf-8?B?R3JsN05HTGZCWnJHQ0ljMnJWSmxyRlByajhUY0VtOVU4ejN2bXZCdVkvYUQ0?=
 =?utf-8?B?WVB3OXJVMDNXbEFlLzZwb2V0aXlvRkxzUlRvaU1MaGtNVEVyTXJ4dzF1a2kx?=
 =?utf-8?Q?H3Q7L+dLEqU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014)(7053199007)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VnE3UlVUbUl1S3Q1UEtxRVFZWUEvSXVNWmVwR3ltY0l4R2dmZ0FxMHFVMXp4?=
 =?utf-8?B?M1Rlb0kwVExHWWRoMURBRHZFbUNDbEpySk1XNytLeHI0c1N4OGlpeWEwYkpu?=
 =?utf-8?B?STBQeUtoUWlHa2NvbGwyNUpFT3B1V3BnaHhlWmsrZjJKWmFyTUxDc1daUHdj?=
 =?utf-8?B?LzdZWng1YUZTUVROVVFobnRnZjVkRmFRdjYxMDEvY2JlSzhIb3FkYm54clYr?=
 =?utf-8?B?YmhUcTU4TmVYa2docHhsNyt3VkhqZGI1c3did2Q2NDVZdExzWGpMeUJ4ZjBr?=
 =?utf-8?B?dmo0dTVGQ1gyaWl6TFpNTzF2amJodFQrUURNVFBQVVhZdkpOQmNkaWx2eTg1?=
 =?utf-8?B?MThSY1FVUXlwZ2JNK2pEVjEzQnJUWHk3SkQxdTNxTjhuY3Y4SHpmWFoyQkE0?=
 =?utf-8?B?cW1PWlRLYUlmcENTUVJFUS8rSmttMTQvTDhjcCt1anV4azdRbnBFdXFQSFZ6?=
 =?utf-8?B?d3NsQW9meVRLcGxEckpxL2hKcUp1Vm13Zis1VmptaWVVaVVoclpYdkRERW5S?=
 =?utf-8?B?YllDUTY4enJHT1VLc0hmcEFLa2Fva0hTMENvQk1iNlF4c0JtRC9lRjVCMnRY?=
 =?utf-8?B?bTVQSXU3eHlRQmY1UmRyQm8rRVBtd2o2bkdNTHVvMnpvNjBaa2ZwcnhCSmJ4?=
 =?utf-8?B?R0UvaU93MGpyLzFGaE1kTUlUUlg4cytnQTZubUNob2k3UldDYzBFbUo4YnR6?=
 =?utf-8?B?eFZSTXgxd1NWWEZrNndIUEc1Yk9CSEM5S2cycHRHMmZuV0hSSXdjak5NU3Jz?=
 =?utf-8?B?WTV5cjMyTTRVSU0rc210WTZ0azduK3V5WTVONFVORzg1MTFoM3ZYS3VjVUpi?=
 =?utf-8?B?VVJBSXBBUXFyeElqUElpZzZQWVc0VDcrQzFVM3I3Q2Fmcmw3VHNnbk5NMmZw?=
 =?utf-8?B?RVhKUGYvSm5rLzlLVmlKS25BaGxNZWZqZlpRVnB5TzJwQ3h6UFI3cnk0K05G?=
 =?utf-8?B?dkpaTXdDRHJ2RkVjZEQxay8xamIvenMyekRrK1N4VDFDRlpFVW5Wb0hjVklx?=
 =?utf-8?B?WXVPcm9GMUNGQ25CY1lzRnpITlMvS0JtZkpLRjcrdzVyeGpsVHNpd09Jb0py?=
 =?utf-8?B?VVUyQm0zUFRrbjFqaXl3eEc2cXhDbGFTZ3JSeEQrWmhiSS9Yc2FYd0oydnl2?=
 =?utf-8?B?TGRQZnJiL2l0aC9SMldQa3J1TFRrdUordFIyT2lDTFRWSkk4N0ZvdFpSUHpQ?=
 =?utf-8?B?SlZucGdhWlpORUYza1RGb1oyTTFGaFpHOGY1dFkyMzR6cXFZZUgvemdNTDRu?=
 =?utf-8?B?ZzFsOGZRZ3ZkOWJnYWRTeXNhcjlxb1hacUNMa3I3bGlwWmNoeTBwVmYrZDJq?=
 =?utf-8?B?TEsxTTgvR3VBSXd1UWw5R1ZleXpYcVUrV2hyK2txOGZCUFpxOWRJaEx5aFpN?=
 =?utf-8?B?RTVnOFpZS3paRkxmbHVJSTM5VjNqYWFJNUdaa1d6TnRYTFcvWmxnMFp5SWxi?=
 =?utf-8?B?eEZXZDd4WTdnbmJwbGdqOXNKTkllQWlwcVB1Vm1CYWlkM2VWSXQ3bU0waTlw?=
 =?utf-8?B?QmZ0ZHo1czdjMG1IRHFJcTR6Wm1BaWFmTEdYQ1VWbm9laGVEU2xXa0lhbi9k?=
 =?utf-8?B?SkE4Q2RhY3l0cTQ0MmMvVmNtN2xvUmNyTG91SEJSWWlXdllrQkVMVVd1amhh?=
 =?utf-8?B?MzB5V0RhODlpSkdJaTU3S3hZTWIzbmlsdktSS2Fxbi8rMTNONGZnQWRrcDky?=
 =?utf-8?B?eHVqM0Y0S3U0MzFRL3VFUkU5dmN2OVBjQWdEd3NZYTEzamRhUFRHSzdVSTQv?=
 =?utf-8?B?SGxEemE3KzZodW5WdjZ0WEQ2bEJWVy93WGxUMDlDUHVCL21UTVY5ZkxtakY2?=
 =?utf-8?B?UWU1R3hlNVBDcXJtUEhsUFpiMmNSajh0YnBRYkpNSDZ4NGl4QjV6VkFhWVdT?=
 =?utf-8?B?VzNBSU0yUWZDSlhvRyt2eThsMzc5WmpRMVBMMU8xb1BsejZhTDBnaEhDRG9L?=
 =?utf-8?B?cFkxaElhTDZqdDFHdjR3SlFrSUdoMWYybU53SmIrU0VPNGIxWThnY0NRa0xz?=
 =?utf-8?B?THlmSmI2cVJJNW9wVThhQnFpb2ZCQ1JIb3poaHhybG9SQXhGbzVNZ21INzE5?=
 =?utf-8?B?bkFXMVg4RWgzN0pmRUwxckV5cytrTDJ2S2ZVRldvQ1A2eEtMMENnTzN2NmZO?=
 =?utf-8?Q?F65nfisYQ/hxLSYP2FtIU40AQ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4035f9c0-b4f9-475f-bd22-08dd51f25e5a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2025 21:05:56.4917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SwyDsh61wh+LKIzI6gp2PCnlGtl4fScr6WIsi6utRJOMUtgtL2kIApF8UDHAEig0ejz7kfGY+vDeC3PsmpX/hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8139

On 2/20/25 14:23, Kalra, Ashish wrote:
> Hello Tom,
> 
> On 2/20/2025 2:03 PM, Tom Lendacky wrote:
>> On 2/19/25 14:55, Ashish Kalra wrote:
>>> From: Ashish Kalra <ashish.kalra@amd.com>
>>>
>>> SNP initialization is forced during PSP driver probe purely because SNP
>>> can't be initialized if VMs are running.  But the only in-tree user of
>>> SEV/SNP functionality is KVM, and KVM depends on PSP driver for the same.
>>> Forcing SEV/SNP initialization because a hypervisor could be running
>>> legacy non-confidential VMs make no sense.
>>>
>>> This patch removes SEV/SNP initialization from the PSP driver probe
>>> time and moves the requirement to initialize SEV/SNP functionality
>>> to KVM if it wants to use SEV/SNP.
>>>
>>> Suggested-by: Sean Christopherson <seanjc@google.com>
>>> Reviewed-by: Alexey Kardashevskiy <aik@amd.com>
>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>> ---
>>>  drivers/crypto/ccp/sev-dev.c | 25 +------------------------
>>>  1 file changed, 1 insertion(+), 24 deletions(-)
>>>
>>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>>> index f0f3e6d29200..99a663dbc2b6 100644
>>> --- a/drivers/crypto/ccp/sev-dev.c
>>> +++ b/drivers/crypto/ccp/sev-dev.c
>>> @@ -1346,18 +1346,13 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
>>>  	if (sev->state == SEV_STATE_INIT)
>>>  		return 0;
>>>  
>>> -	/*
>>> -	 * Legacy guests cannot be running while SNP_INIT(_EX) is executing,
>>> -	 * so perform SEV-SNP initialization at probe time.
>>> -	 */
>>>  	rc = __sev_snp_init_locked(&args->error);
>>>  	if (rc && rc != -ENODEV) {
>>>  		/*
>>>  		 * Don't abort the probe if SNP INIT failed,
>>>  		 * continue to initialize the legacy SEV firmware.
>>>  		 */
>>> -		dev_err(sev->dev, "SEV-SNP: failed to INIT rc %d, error %#x\n",
>>> -			rc, args->error);
>>> +		dev_err(sev->dev, "SEV-SNP: failed to INIT, continue SEV INIT\n");
>>
>> Please don't remove the error information.
>>
> 
> The error(s) are already being printed in __sev_snp_init_locked() otherwise the same
> error will be printed twice, hence removing it here.

Sounds like this change should be in patch #1 then.

Thanks,
Tom

> 
>>>  	}
>>>  
>>>  	/* Defer legacy SEV/SEV-ES support if allowed by caller/module. */
>>> @@ -2505,9 +2500,7 @@ EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user);
>>>  void sev_pci_init(void)
>>>  {
>>>  	struct sev_device *sev = psp_master->sev_data;
>>> -	struct sev_platform_init_args args = {0};
>>>  	u8 api_major, api_minor, build;
>>> -	int rc;
>>>  
>>>  	if (!sev)
>>>  		return;
>>> @@ -2530,16 +2523,6 @@ void sev_pci_init(void)
>>>  			 api_major, api_minor, build,
>>>  			 sev->api_major, sev->api_minor, sev->build);
>>>  
>>> -	/* Initialize the platform */
>>> -	args.probe = true;
>>> -	rc = sev_platform_init(&args);
>>> -	if (rc)
>>> -		dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
>>> -			args.error, rc);
>>> -
>>> -	dev_info(sev->dev, "SEV%s API:%d.%d build:%d\n", sev->snp_initialized ?
>>> -		"-SNP" : "", sev->api_major, sev->api_minor, sev->build);
>>> -
>>>  	return;
>>>  
>>>  err:
>>> @@ -2550,10 +2533,4 @@ void sev_pci_init(void)
>>>  
>>>  void sev_pci_exit(void)
>>>  {
>>> -	struct sev_device *sev = psp_master->sev_data;
>>> -
>>> -	if (!sev)
>>> -		return;
>>> -
>>> -	sev_firmware_shutdown(sev);
>>
>> Should this remain? If there's a bug in KVM that somehow skips the
>> shutdown call, then SEV will remain initialized. I think the path is
>> safe to call a second time.
> 
> Ok.
> 
> Thanks,
> Ashish
> 

