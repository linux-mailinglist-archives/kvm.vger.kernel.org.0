Return-Path: <kvm+bounces-38381-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 92BFAA38BC3
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 19:58:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DF3731894A4D
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 18:58:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3604236422;
	Mon, 17 Feb 2025 18:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="WIG48r5r"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2080.outbound.protection.outlook.com [40.107.244.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85AAE235BF4
	for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 18:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739818692; cv=fail; b=WuFLa8W36X/HhF6AM+sUHGdTqnr5WtQ58hxUaSZ4Z2tNm9irWHLLlHw9L/S0zf1gSq5ImtAAS4jtlxkqU+PLq+TLFZzJ3B9fPuAIJHd0mPsmWXxcS/+u9H1tKvefVaHY0COH/YnLkofvNhI2NMz4p0cIcFSCd6wPeVr+nykT8Gc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739818692; c=relaxed/simple;
	bh=7TRIF2q8bywarddCAzD+UO8iSFVgQEoK8TH28ag7L74=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=QtdDzUQM1U+V/AXsKWg4dS8OqiWAeMIU64Rh2hxoLiLlFsjtxWcb+petN2GEY2EdPN/Z/hmirZrZeao8QCjqccBJJh0LXcgTcP3Blu+MsAxXlDiCyBrjTHs+uvutnsBUq0Gy5AS/+CJUpt5M+0zNAxnM9jhCXK9vtfjKpoYQsag=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=WIG48r5r; arc=fail smtp.client-ip=40.107.244.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fkFbBUmGjUrkzUE3M2FyRWl4VUvgyrq95lHeqvLdQxX3Ya70AMqES5xOeJLcvW+xX/JjSrWuDiTN81w71OlZmyeCxHwadoi8lOBc3peMBTbQLwcPQ2PJD/RJl9zVAwxswF/b9ssxLXsA/guhrGYBgNIfT0b77Vl8eNwwFhHAK8pqfVbMFq6hA/MQZlTANciQJDN0LAxRqD+59c6/1hKT34CT7qLf6jDJnCg8YpzW3FkAG8zu7qZwz7eE2TwD0eaIOkVhhMc/07u1AzxiN40kBzDuGGRfkuZG42/8jHcyTJBL7xqH89DW24Hh5yxU1yrxRvjma3T7aO0/oLIr2PO2nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m0LxvOMqxiNrOLkP7pOPGFNRhWIGpGhKB1dtKSaFP8s=;
 b=nVnKfdkH8CRnPoOihMXeDHjW54isWcYPkIkQ0wqWLeDccPe8Be8TUBiJB2Jusz2LBYvPik2560Mwq2qPN10oJyW6uafkH98nzWiSo+QQWj7q5ZaAfpPdInSnzAt7j2W9JtpseEmeyHGfUEhV6XNVmBtkJVrlsyrNXKNLdJ04q39AvAmfc50dI/FOXBKUw71Y5EhIjieOTVruD23Z4PI7FIWkHnrPZIzTC/j9dhNdL9TCa4pw5Y9AZcp4azwOxM7SlLBHC59Cgks8pua9I9IEeK8BprmhtVtZfNfFEoYh8mlGEGItQNqX6kPZTLxgTXv96dAEWVIcbvo711TX4AP+kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m0LxvOMqxiNrOLkP7pOPGFNRhWIGpGhKB1dtKSaFP8s=;
 b=WIG48r5rhjD1BQBW6lG9+PTj2wgfasnwjdWCHwXrAMq28p7hYLxWqa8nWy2IVk11P68Fypwm08ebWOjFP3EA185y/2mJaA/7O1zHrOnwSdYMm4ej5BgcBNvEoGyZOxnbkxkpHplwPz2L+v4/xM8asVCDUt1D+4PSNiqtRMfD8H0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CY8PR12MB8215.namprd12.prod.outlook.com (2603:10b6:930:77::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.18; Mon, 17 Feb
 2025 18:58:08 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8445.017; Mon, 17 Feb 2025
 18:58:08 +0000
Message-ID: <cd36710b-957e-bfe9-7904-e1041f00d98a@amd.com>
Date: Mon, 17 Feb 2025 12:58:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org
Cc: santosh.shukla@amd.com, bp@alien8.de, isaku.yamahata@intel.com
References: <20250217102237.16434-1-nikunj@amd.com>
 <20250217102237.16434-5-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v3 4/5] KVM: SVM: Prevent writes to TSC MSR when Secure
 TSC is enabled
In-Reply-To: <20250217102237.16434-5-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR03CA0013.namprd03.prod.outlook.com
 (2603:10b6:806:2d3::9) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CY8PR12MB8215:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e06252b-8495-4745-a2e1-08dd4f850479
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MjRpK1ZyYlprelVNaXpxMVR0VDN2Uk5sVjVOd1k4YWtGZW9ZTWV0ZVBOdjRp?=
 =?utf-8?B?SzNBd2hoMWI3cFBKQmhGK0hoZlp5ZzNZN25FeWZDbDFMeEpndVIxTWtxdFpD?=
 =?utf-8?B?L294a3RIYmQxOGJBM21xTThpdEg2YkFWRkJiWWhCWjAzZ01kRndQVkJMWHZz?=
 =?utf-8?B?MzNZK09Id2pqRTF3STM2M2FiRUR3cFVJcTdRYVZTRjgrTkFuV0x4ZVdkODEr?=
 =?utf-8?B?cjkvOC8vbGJ4L1NmNFJmWlNBSEcvUTN1ZERpeDRiUXBpOXpEbzRkcXg4bW5Y?=
 =?utf-8?B?Uld4T0dtQ1B4VE1MOHcrSWd1R0tKR2EvWkxmLzBqdlV4L3hSdVpOSnhxcTF4?=
 =?utf-8?B?L092VEtpY3ZObEFROFRlTXhjelU2MHFaUHphQ3pJQklicWJYV2YySjRDNE1w?=
 =?utf-8?B?Z0tiMDFqNEplWW02YmdBTmZsZmVFWXAxQU9vajg3ZGJER2hQVlBnMUI1QWN6?=
 =?utf-8?B?VHc3ZyttTjBtTU5Xa3gwVFlrY0VqT29NeTV2SC9hajlra0hXN0dPejlmOGFo?=
 =?utf-8?B?Wm1CTElQV3Q0RjUxMTFHdkVlcjN4OHZ2UjIxamVCcGdldmozOUt5d3NTK2s5?=
 =?utf-8?B?Nm9LZGNyN1R0d0NheDUvdisvOXlQcnZSUVBsRzgxVG9MSW9VbEZPS3VkVEFK?=
 =?utf-8?B?aEVJRG5xWmY0cEVwdUE3WjlQaDh3RkJ6Y2RlVzgrbEtaRUtHTXE5ZHZLcXFh?=
 =?utf-8?B?ZzM5ZTJ3YlVaRFNjOC9oR2p2VVZUOEE4YnlEcndTZHJQNnUwb2phcEZCbnds?=
 =?utf-8?B?c3J5VTBpS1o0SFFrN3VGK0FMeTZrMW43Mm9iUVhNNVhHMHlYUE5ReTYwbTM1?=
 =?utf-8?B?Rm9hRzAxL01sclBid1BvUnhmTUZZdHNzRmtESFNUdkVNSmFyeFN1S1R6VVQv?=
 =?utf-8?B?byt3NDV5QkQ3Q1I3Y1BDREl5SDFvQythek5hVHR1TzF0SzRMenNuRmk0V2dB?=
 =?utf-8?B?aXJ5ZlNlMU16a2Q4eis1K2xHOTVyOG94N0VvMzFpZ3ZPTEV1M1BsaU9HY2ZI?=
 =?utf-8?B?aVR5K0VNcHlKZ3JkQ05lb0NTYzJqbWdhdmYxMm02dGZrQnFoNW5VaEIzM1kz?=
 =?utf-8?B?WTI5QytZaEx1dTNCc1JtZEI2UFFYZFdkWGdHNUdtUmRrV1JxZk9hd2UyanNV?=
 =?utf-8?B?RlNWazBFKzZ0eE42Sk5BODlmVTBrN0I1Um05c1IrZFNXS2d5NWZiQlFHNmcy?=
 =?utf-8?B?aGtQSWs3RThDaTd6OVVZSkVBd1o3YzJHMmcrUkgzQWlIMEh3bm1ONGNuUHNH?=
 =?utf-8?B?SXlrNjVLckZwT2V2V2NLcEtQRVBRVHZYUDFWOHFRb3VJVG1Ha3hJSUtPVEcr?=
 =?utf-8?B?TU1zMHdxWjg5eEphYkFkZnRmcmhvQzIrSWpEczNkZyszKzFsTjAySXFRMU5L?=
 =?utf-8?B?T0JhMFZiTUlmMEFRVXlLdkxXZWZtK0dCZVRzcVJrZFRmRGJsM2NRSEJ0QzFZ?=
 =?utf-8?B?U3plV3FPM2RiOXFhelAvakFlQTB5WjhRUE5JNFFvUDhEajZxaE1BN1BUcHU1?=
 =?utf-8?B?bW5BSG5iZjhpNldUVjNvY0YzcDZ1Z1BwdDVJUXBwbk1DbU5FQzJ1eEJLeDNZ?=
 =?utf-8?B?SUZjSkZBNUZUN1hKK2lvb2VMblI3N3I3K0ttTU9IS3dGb0JMN2s4WnFaMGVr?=
 =?utf-8?B?TEFnNnNpcjZFWllXZTQ2L0c1Zk13MEZvNjBsMXh2YS9HbE4zMGRXSmxZdmFh?=
 =?utf-8?B?THZ3Um4xNnA0TGVzbUdldFVzZU90bjkzZ2lnOVpQejlPNUswS20zQitJWmJT?=
 =?utf-8?B?c3QzdGhkMlgyS2ZRZEdyb1M2bE52Y1Arb3Z2RzBLa01mLy9EZjJlNWx2QUxS?=
 =?utf-8?B?eTZxOHJPZ2xjS01uRkhmYlVrUHhvakNyTGNBMVp2K201SzZEWDhlb3pWNjFS?=
 =?utf-8?Q?u4glxvX86qkOj?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MEpvZzdDekdJTjR0Snkyc3d3WVhRQmxFOFQ1Q2UwR1RFbGZMVTJTUTk3Qzhk?=
 =?utf-8?B?N3RqZ1UrOXpwNkl1Rll4VHVVRWNuWE9aOUt2dlk0b1hMZllOTUt4b0JkV3V1?=
 =?utf-8?B?NFdOM3ZSUjNxWWc0SW5jN0FBczd5RTM2a3RxZFgzam1hb3VSTlQ2MnVkRHc1?=
 =?utf-8?B?bWlOem1oRi9DczdlOWFyQU5oU3VFSUtFSXZsUlJ6OFBORGczUUZydGhFZml1?=
 =?utf-8?B?dE1TVEF3T2l1WU9yaUZ4SHhyS3BEM3J3akVVc2RKOG12Y3U0YkdYV0VMZTBB?=
 =?utf-8?B?L3ZSbFhHTFJ4L1F2c0lZNjVycTg3RHI2UTY0KzNTNHJUUEI1dEhKdFdiRWxl?=
 =?utf-8?B?VjA5eCtFTWVSSk9RNjJOeFZWWlh1dDY5VWt4U1BaVWwwU1hZMWxwMmh6RUpL?=
 =?utf-8?B?WWl5SFZBclQ0VVBueVl6V2YydkQ4ay83cTY2Ynk4SU9qMTdxbHUyRDJyMlpo?=
 =?utf-8?B?RnZ2YnBNYzVZb3pmTC9TZTV6MHpJN3ZRdGU2eHFQWVNhYUVmMVI4MktBbmxy?=
 =?utf-8?B?Y09FaWJJRDZCQXFHWVVMRkMreWd3c04raFhOZWhLNDlvcjN2ZGdWM1hhUEl0?=
 =?utf-8?B?N3BOTmp6S3VqaXRrb21qd0laZSttOXorVU1TOFVkb3RzUjdXN3RVOVN5L0ZT?=
 =?utf-8?B?andraTJIS2g5U2JGcERjOHcvNUxVL2ZVaU8rU2EvK2Q4SWVFOWFNbmFJZmJB?=
 =?utf-8?B?ZHI1aExHRWl5VmJyQmRIVnJKRCtadHZ0OU52OXdiaTJKbUZ6NnRoZDM1MlZC?=
 =?utf-8?B?VDZsRmdXbW9EVWs4dFZpNUFKQnRrT2RRQ29zT2JrOHlpbWFlWXFySVdvQzd6?=
 =?utf-8?B?eUUyWEhUVmFrMG9xSjI0R3J1Y1pxbklKTExDY3FUaCtMRloxVWViNXQyZ3BH?=
 =?utf-8?B?anVoTDBDNXVaaEl6K2dlb0YxOHhRN0k5Wjh1UmJXblNvU3pmUUthUFdyRHJS?=
 =?utf-8?B?ZDFId2JRUFRqUnJ4V3lmUFNtM1RBeHo5QWtpVytkdTEwOWtOb0ZROWdqK2tB?=
 =?utf-8?B?SzJqZVlsdkpUK01YRW9LZmNiZGlaSERNUkpoTzllVHNlb1JOZ2loWUdtV0Zm?=
 =?utf-8?B?ZXdjcEJlakYzM3FYZG5PRnhCdVNNSDg0dVZKTWkzZlhyTmtoT1hQTlNvYzJ1?=
 =?utf-8?B?T3JjREtjU1RuWUt4amJMZzhVZHlQVHkzWnpwb25BYUtxVS9SQkQ3MnEvWkNw?=
 =?utf-8?B?dktiVllZdVloN0dDSWZLdWFsYjI1VkU2NGZBaHV6b1lNWmlHaXA4cE5VNVpu?=
 =?utf-8?B?TEFZRjRua25ZSkpCcmx3S1k2b0FlcTZTdmIybUdlS0Zrc0dIT1lzeEM2TkdI?=
 =?utf-8?B?TzUwT2pCUFVFTlB2aGlHbjhYa1d5ekp4Y1MvT2twVEJDU2NWK053MjhENlJ5?=
 =?utf-8?B?R2R3WjFCWGhRSE83Y3pMc1paSTlFVitKeEpYVXZ4SGsrbkNyLzBzTktSMG5L?=
 =?utf-8?B?emhpT1lYUGtGWVBPaXhYTGR4Y0hJK0FlZmFyNlRVc3JNZ1BVNjBmZkdTS2J0?=
 =?utf-8?B?OEk0cTk0TDU3SUt1Z1FNZHYrZVI2VC9qNmMyVlpsU2l6S2VhekdSaGVROEth?=
 =?utf-8?B?SmNHVzhNNjk0SmZYUk1JUG9WY3ZZeWNuS2lpblJKckdjbWNzYnVIZDhFNlpt?=
 =?utf-8?B?Q3I4TVpEa0NSL3BFaVZnZ3dlcmpISFdqbHhxRDJuaHRtV1RoVXR5K3ZJSVFu?=
 =?utf-8?B?WEtXZU01MlhNeXFjY09IWE1ocEtWaFBERkdOelNOa1AxY0JWcUpXTGYyQ1pF?=
 =?utf-8?B?Q2NYN0hENjIrTEI5Zk9NS3Raa1QwMkJLSGVIa2xBazgzbXU0MXVCQllwQTV1?=
 =?utf-8?B?VitJY3VRNTZGZW1McklDUzEvZXNKbWhncytaQmMrenI4SVNGcDhENWJ3MUNi?=
 =?utf-8?B?dUkyU1lhRmtSWW1maXFWRE5vSGVtaWtNejdYYVpZWFhZV2szb3pZOFFyWW1v?=
 =?utf-8?B?YVExNWFXcFp4RG9hcndjUDIwaU5sL05wN3daU1VXb0FwYVc2RmNDbVJlaGZm?=
 =?utf-8?B?UklQS1VXZm9BWElqWDRnZkx5akoyZEU4aGxMOGlGb0ZUYmtjN0tLUVRQNHI1?=
 =?utf-8?B?M2dKaFdhaVRWOTl4eGdIRDRFei9mY01LblFOYXZ2K053SGx1bS85YW1vU0JS?=
 =?utf-8?Q?kch0powtc08nxt0DYxNx0lbiZ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e06252b-8495-4745-a2e1-08dd4f850479
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2025 18:58:08.2350
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qdkjuftzx1gBW7L/5z3PKrz/aBAqB/kuXsWFvxKBXFQFgOWEf2nRS3eqoQk1sKb3o9rSdbjk9hwQv+hICmUm3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8215

On 2/17/25 04:22, Nikunj A Dadhania wrote:
> Disallow writes to MSR_IA32_TSC for Secure TSC enabled SNP guests. Even if
> KVM attempts to emulate such writes, TSC calculation will ignore the
> TSC_SCALE and TSC_OFFSET present in the VMCB. Instead, it will use
> GUEST_TSC_SCALE and GUEST_TSC_OFFSET stored in the VMSA.
> 
> Additionally, incorporate a check for protected guest state to allow the
> VMM to initialize the TSC MSR.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>  arch/x86/kvm/svm/svm.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 93cf508f983c..7463466f5126 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3161,6 +3161,20 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>  
>  		svm->tsc_aux = data;
>  		break;
> +	case MSR_IA32_TSC:
> +		/*
> +		 * If Secure TSC is enabled, do not emulate TSC write as TSC calculation
> +		 * ignores the TSC_OFFSET and TSC_SCALE control fields, record the error
> +		 * and return a #GP. Allow the TSC to be initialized until the guest state
> +		 * is protected to prevent unexpected VMM errors.
> +		 */
> +		if (vcpu->arch.guest_state_protected && snp_secure_tsc_enabled(vcpu->kvm)) {

I'm not sure if it matters, but do we need to differentiate between
guest and host write in this situation at all in regards to the message
or return code?

> +			vcpu_unimpl(vcpu, "unimplemented IA32_TSC for secure tsc\n");

s/secure tsc/Secure TSC/ ?

Thanks,
Tom

> +			return 1;
> +		}
> +
> +		ret = kvm_set_msr_common(vcpu, msr);
> +		break;
>  	case MSR_IA32_DEBUGCTLMSR:
>  		if (!lbrv) {
>  			kvm_pr_unimpl_wrmsr(vcpu, ecx, data);

