Return-Path: <kvm+bounces-31960-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D2C619CF549
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 20:52:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9234B282542
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 19:52:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64E8B1E1C2F;
	Fri, 15 Nov 2024 19:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="AeXFMj/N"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2089.outbound.protection.outlook.com [40.107.237.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4E21E105A;
	Fri, 15 Nov 2024 19:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731700320; cv=fail; b=s8ZFY5Gl1RaH/E0Yv11MSU3g45w9/XBnTbC0ChUkeYVcv7RzvqpgHpwQLbiQs9nVH5hUFDG7nm3zVpNz00lpflxthkjwCLrdS3t0SBrwJqvoUDwc6jyI/ZZKDO0li4cF+z5iGCWvreN7gFWfmBqHxR8eY7W1bpH9oMhdeRsvX9M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731700320; c=relaxed/simple;
	bh=leDIrENj2K/bz9pmBrd6Fo14nekoSIPmHA3T13QmRv4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AFIdkvlfAOEO7dw5U++3qoniYdTnNYMdWhklJrCTzQpCuj9R8/w8tkFsgbWLPvEXb7VZ5DeKplrXYbjABG3PBTU6qG9fdjLtSpiH9pMnVoYffDkYfwlNp/4cr8k2dMutL2nno8d2wnj3qoy7YLAi4E90eBt/8a7ibqgPq/Q/KhA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=AeXFMj/N; arc=fail smtp.client-ip=40.107.237.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W1e12f5l/Mc0VPwAVxNY7S5Lj+H1Wj3Jg9uoSz6VpDx2WFKo1qiXByPlzZa67Em68fmYv97v1Yl7ZA/3o0rTW1h+I1/8r53bq3PbS1GZVqyXTaQ/IG0l4yeLW5sKs2J93YjwOpc9E21wFAUv/CEUL0Lkh3CneHga2T8EP8cGdyFP/uZprfJ4GBNxcEtVcFTDKOBuUX8FUbaPTR64NSurQXPeIeIFyo7vtSfacFzvGtj0yxzIB4f6Ua40WYczl3nRcfxx0tkiJXjX+ZYZ+bcdPEHxtU0hIpi/ABiFR14Xfbwkhs0nDapO+/bUCgQ6WmGuJC1oaOVFnoLOAOVVqHOnsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YHSHVTddfs5Y6hEyevCVw356GLT9R8P+uJp2rmqHmKI=;
 b=zQ72vIw3AcdPcHwCZn5P/R+qYI7KAuN9aM3syouFQ1LP/hlNwagbFsCw/09s5+Y44iFn2Uelz/YvBv5YSYQ/sSQBJ2PZtRQn/khtR3nUcLtxcs7/zRRVFsxg3odojPF5E3msivh9hkq97bHbABIJJZ9UOOspDdmHuNAQCIrZowJnVhJf9KAW0YPbwFpp9/b/X6eaoG/KR+umgrcQCtlDoK4sl4dt8ZBAYbvd/bZOMLuRNQAKlUgGxCDJk1/ibc34yFODJDXUrvQ5yEjN5MPo64zqrjoUQljd4EoaiqghBtCQfgiS4yrrSEWq6foDQHWSNtehPc9UAUclGGVO7ZKjWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YHSHVTddfs5Y6hEyevCVw356GLT9R8P+uJp2rmqHmKI=;
 b=AeXFMj/N2keQr1k1Q+ZlcD1TrYcFPe5Nu7u+EqmR3aHLNleUww8r0KPDCSIhyyRB1EgHxLO37EpUXKsuZBRB1Qn8RBOTx07uB4HcdYkiwZv+0nObTar21rbi4Obq/j/1tj0hpCQt4hhdcHVCdyTZZ9Lfffv17D9oI0wMPvAPz9k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by SA1PR12MB6945.namprd12.prod.outlook.com (2603:10b6:806:24c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.18; Fri, 15 Nov
 2024 19:51:55 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87%4]) with mapi id 15.20.8158.013; Fri, 15 Nov 2024
 19:51:55 +0000
Message-ID: <5267175a-27ed-9293-c780-ed22b13bb8ca@amd.com>
Date: Fri, 15 Nov 2024 13:51:52 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH 1/2] x86: KVM: Advertise FSRS and FSRC on AMD to userspace
Content-Language: en-US
To: Maksim Davydov <davydov-max@yandex-team.ru>, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, babu.moger@amd.com, x86@kernel.org,
 seanjc@google.com, sandipan.das@amd.com, bp@alien8.de, mingo@redhat.com,
 tglx@linutronix.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 pbonzini@redhat.com
References: <20241113133042.702340-1-davydov-max@yandex-team.ru>
 <20241113133042.702340-2-davydov-max@yandex-team.ru>
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <20241113133042.702340-2-davydov-max@yandex-team.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0165.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::20) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|SA1PR12MB6945:EE_
X-MS-Office365-Filtering-Correlation-Id: 686ee697-740b-4f35-c657-08dd05aef50e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RUQwZVFpRkN4eCtHMUQvMk9TQ2FpeGF2V2t2S2grUFlza2NOY1RMYXRJTUNX?=
 =?utf-8?B?Q21lUnIyMGtZUjVTczZFSklUOEhmcDkyUTlXQkVkNmxXa2hLQW1aWTNJSmRq?=
 =?utf-8?B?UVg0OGVRRVc3eVhMK2t0QmdrSmtvYXJxamw4VTZ1dGZNeTFZVjRKNmR1MkVS?=
 =?utf-8?B?TWJ0bkgyT3dtcS9hMzBUcWZtMVE4OVVxTUI1eGNtVTBWdit1emNTZzd4WFpE?=
 =?utf-8?B?QmJ4ZklmanBmeXpTRTlmdzBIbFF1N0Z5RitrUVQ1UDIrNzZRdXVSdldpYWh2?=
 =?utf-8?B?VmpUdGdDWUFZVnBENkx5QjJlVUFhamhoSVMxZVB5ZGU0dlFYWTIzSE1lWXMv?=
 =?utf-8?B?N0Q3MVhzL3gxZ29vSGdTMUU0ZnJ6UVV3S0J0NXlRVUVMYnh2SlZYaVhQckhO?=
 =?utf-8?B?Y2dJcjBrNW54bHpBWUZvVlhmemlvemhWUW9Vc3dIK0NOdElZTS84dTdycC9T?=
 =?utf-8?B?Y21WS25Hdlo3d1FwNWtQK1E4M0RxVDBnMUpRblBnSTRNWXFlTTVwSVNTMW11?=
 =?utf-8?B?Vjl3TVVuUDJLWmRWQUlBVzlqZnBqUks5TDdCenVIRXRvWUNOalNxUzFHSCtr?=
 =?utf-8?B?VVBlbXA5elBzcWNMUXJzZDVXQXluZGE5MzZjaUtHZzJFeEUzWTNDcmVkMXc3?=
 =?utf-8?B?SHB4R3FRRXNoeVE3akpNRHpld1VSamppTm01a0FiV2l3ZWRyRGNQMHNET1No?=
 =?utf-8?B?ZlVVcW5mYWtRTGhuZUVReVpzUkhhTTlXMGhsN3B4eHEyN3dDN0ZzMVdIeXVI?=
 =?utf-8?B?NURxbzVnTTFvdHljMXdaRGxpK1V2YjhoaFRSaHYzNkhacGNOOEc3REFjSkpu?=
 =?utf-8?B?VlVXOE51aXNPK0JNd0syK0ZHN3I3TG4xNjgrUWRuMVNLR0JXb1Fkck9TVzFx?=
 =?utf-8?B?eG4zTXRLSEpTSkg3TkE2YnhVRGwrWVRXcnRvbE9UdTVOOHY1SHkxN24yODRm?=
 =?utf-8?B?c3ozcldrT1ZtdTEwdkhuZ0I1TlhwMUdEdzZ0SVJPeGliNktEUzVLVzhFakgr?=
 =?utf-8?B?YlZscFJsQUFLR3ZDMXR4Nm0wcUlQOVpncUMzbzUrVEtwUkdwZkxYcS92a3E0?=
 =?utf-8?B?dTdhaFE4QTZXTjh3SFV6UlZ1M2FXeGN1WE1jaFpYUVhLNlhWRSs0S3N5eDVW?=
 =?utf-8?B?Z0J4QlNZWndJRWx5N09WeFdkL1hxQjZnN3VUNG13RExwSFRpalF3UXFwRmR2?=
 =?utf-8?B?T2FHc2tJdUNhVVpBRnZsU0Fqb2FFMmVsU29kd0JRYVlYUi8rVW5iNWN1dE1W?=
 =?utf-8?B?RGJOOW1ZQ3JwdDMrTzdjWUZ2VENHSTM3RnVlODlhVTRKV0tWbTlackp4SGRy?=
 =?utf-8?B?ejlHY2xvd256ajY5YmFkL0Y1WkNReFd4WVp1VFd5WUE3RDkvVHBSVWt4U1Jv?=
 =?utf-8?B?bHNqYkFhZXBXSm0rdDl3ankyT2QrZEhSS1B3V2VQbzhISGVIUGQ0dlgyS2lE?=
 =?utf-8?B?c2dLUXo2OHBBK3hrV09sTFJQV3FtdzQ1YnZROTZ6bFpOVVZURWx0dkF2aytw?=
 =?utf-8?B?am9TbDhUYTg5aHdsNExoWTBpYUVrL3B0S3VFVFBQeFlhOUpoaUJHQkhQNCs4?=
 =?utf-8?B?MmZjcXI4TmFLU25BU1pCdU5UTnFrL2wvZHFmV284OU5iNG81ZXVadENWaUhx?=
 =?utf-8?B?WG9HcnNwclRyWEg4a1hnVURLeEdTZENtZjRKWlZ0dE43TWJVUi9xS25nV1Y5?=
 =?utf-8?B?M2s0WFhxYjF6MU9hODNrL2VnWHlGaGdaRngyWnY3NkU4MlBua2dRVTRqVTdX?=
 =?utf-8?Q?lnj3YcM7kubehTh9M9qjvKnJaHfp2Svhby7trJe?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UnpscHBXWmJCWGIvLy9Mdm0rVWVwR1o4ZWZ5SU0yZ2lPM3N0SEJNa1VTclJk?=
 =?utf-8?B?RU90Y0pyT2xMKzlxRHV1dG5RditOTm94RUJBNTlmVTlMbEdPYWZsZDI2L1hY?=
 =?utf-8?B?ei95WDRhbjNHMTBEQTZTSzZ3L1FFOXg2YlhvQWtHVE9HQWlUWklJNUw2MW1J?=
 =?utf-8?B?ekVycnBKMGRKaXViMWZYdWdiZVRDL2JDcFN3RVFZNlU3VTV2MnJERHRhaTZW?=
 =?utf-8?B?b3lNMitjUlNkbytlRER4L1YyNmw1N2VuaXFpenhNMUxSTkZOa0tSd1c4QmFL?=
 =?utf-8?B?L1B3R1RYdnZ2Z084dVdpZ2lGNk5oaExWWUhGZE96OHNmU3hIUmNhQVFlUUhL?=
 =?utf-8?B?eHJ0UytQaU5qWEJIckh1S2tUTlk1Y05MaDNaYUZmN2RiRU14UE15Z05KQU1V?=
 =?utf-8?B?UHE4UVhoNHljbkJGOUIzOGN5LytEdjBCY1pJdTRyTEgxcjY0R0VBNjllK3Ri?=
 =?utf-8?B?NzNtUmlhUFYyTlFMOVZjeGlicVNHRnUreUxueUxlMlBQcis3NXNaWlowMFRl?=
 =?utf-8?B?VHdOZ2g0V053NWU4YlB6VmQ2WU9uK2dlYlpJeTd6bHU5VWlDdkFGaHVhV1M1?=
 =?utf-8?B?eTV6V0xJRVQ2ZG5mcldMLzlzR2srTFN0SFhHVDhwVkdiMDFHRGh3OHFxSjFR?=
 =?utf-8?B?eGo5Q2hrM3lhZUVmcjdCZGgxVWMwaDZmYmZZOXFiRGl2NmxlMG9BM1V0TjBv?=
 =?utf-8?B?bU5Pb3N2V0lHREVqUXhDQmIzYklVaVRMWGhwK2IwZ09mZ1EveXFHYnl6RlBS?=
 =?utf-8?B?UkFaMmpya1Robi96d0taRE9WZGpnZVBoSnRWaTlWZEF4SEVBeTVPcmk3NHRJ?=
 =?utf-8?B?U1VaK3Vrb0ZLYmc5KytKeDJ1N2xWU2w1MUl5dndxU1VlMXlOZXRSU284cEVM?=
 =?utf-8?B?TDMzY3pheHdSYUIxd2dGejhhSGlsYUlyVHM1bUVPWVpXTDV4SC9jOWNTZFEx?=
 =?utf-8?B?OWhKZVIzZGVKbWg4UU9KcHhLNWJUcGg0dFg2dmZQMWh6bUtDcjM0K3U0bWxl?=
 =?utf-8?B?T1VEVm85N3F4Uk16VW05RlVYMEl6SzBualZlN1MyNVYybFVmeVJvSHRQQ3RQ?=
 =?utf-8?B?d1hCQktha0VZM20xTDVPSWVFOStMc2JvaWlNSDV2UDFCN3J2SzNUbVlQcWlP?=
 =?utf-8?B?QVBOWXFXVllaa2h0ZDZZaUxPYVhLTDgwTmhoZ0VHdEJZMU0zOE9CeTBadmhw?=
 =?utf-8?B?YU5ONDFDVWZqSjREcnZlazR6UXNST3RyVVZmNXNqeldNdlV4bmNQN3BSOHJS?=
 =?utf-8?B?TkRCdXFQcmZwVTduMzZNS0ZZcUZ3QW1DWkR2N3BUYVU2czZ2dFhNajJuR3FE?=
 =?utf-8?B?N0ZaUnlvUW4yQTc0TVFpRVpuVGVQWUZ2NTg5bjRadVBhS3NOWkdhK2FFQm16?=
 =?utf-8?B?MnQzUzByVU4waS9JaWhDaktnclg2K05LY2NiQXJpYXlTUzhOK1VBS1l0SExl?=
 =?utf-8?B?TVhsSTV4VFBlaWx0VjZFTzNCV29HMWdHR3lwL0hXcmhQRm5MaFBjV3hxemZK?=
 =?utf-8?B?UFN5Um4vLzZtZHR4VytLdTVMbUMvY2g4STgwenBkTXovOTRYaFZuWTYvb0pl?=
 =?utf-8?B?VFFmQk02Wkk5eUsvSUxmVzJ0ZXlPNVZ6OWhiSlRCa2g1UnpENjNxcTBuM1Ns?=
 =?utf-8?B?RndLc2s4OG1oWEhEbXc2WkVVUXR3S21wK0pjT3Ava2V5V2dheWhFU0xRT1gz?=
 =?utf-8?B?cVdLVjRtQTVLWnRnd3VhL05wYUhucUVQd09GUzFBUGNrZTRkQVp1YnplVW1T?=
 =?utf-8?B?N2JyWnFQQXcrT3lQZncxRTlReDJTVTA1TUVyL2tiSXplYnpDWmIwODhHejdY?=
 =?utf-8?B?MXloZmJ2QTJKWFZ1NzZxTGp4U2JYUFJFcWgzck5iZ1owK1l1L052aWNIWXBz?=
 =?utf-8?B?bDluQzNLV1p5anZnTVVOT3VNRDFuNkJzenV1bC9pR3lGZ0g4UElhL2lRS0hP?=
 =?utf-8?B?ZGJNRjc3UHZ1NllHZlVDRE9DU0dJbE1ibnlrNkpMOGpFOTgzRXdzNGNmNUwx?=
 =?utf-8?B?anJZNDR6UGVmN0c4Uy9wdGpxcG8ySDM3KzViNk96U3ZyWU9pS3NZWEZ6bnhn?=
 =?utf-8?B?Y0lVOU51Rmt0SWxWNE5pdWtNTUwxSUtwU3ZUeHcrTHV5SUpDYXk4RkpOTXpK?=
 =?utf-8?Q?gd14=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 686ee697-740b-4f35-c657-08dd05aef50e
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2024 19:51:55.2439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KfqIEBijDv8ikzWs1+pApgrG8xfTCvwEsOYgkZyw1H26aJ6LlZNsE39mRajBNUIg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6945

Hi Maksim,

On 11/13/2024 7:30 AM, Maksim Davydov wrote:
> Fast short REP STOSB and fast short CMPSB support on AMD processors are
> provided in other CPUID function in comparison with Intel processors:
> * FSRS: 10 bit in 0x80000021_EAX
> * FSRC: 11 bit in 0x80000021_EAX
> 
> AMD bit numbers differ from existing definition of FSRC and
> FSRS. So, the new appropriate values have to be added with new names.
> 
> It's safe to advertise these features to userspace because they are a part
> of CPU model definition and they can't be disabled (as existing Intel
> features).
> 
> Fixes: 2a4209d6a9cb ("KVM: x86: Advertise fast REP string features inherent to the CPU")
> Signed-off-by: Maksim Davydov <davydov-max@yandex-team.ru>
> ---
>   arch/x86/include/asm/cpufeatures.h | 2 ++
>   arch/x86/kvm/cpuid.c               | 4 ++--
>   2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 913fd3a7bac6..2f8a858325a4 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -457,6 +457,8 @@
>   #define X86_FEATURE_NULL_SEL_CLR_BASE	(20*32+ 6) /* Null Selector Clears Base */
>   #define X86_FEATURE_AUTOIBRS		(20*32+ 8) /* Automatic IBRS */
>   #define X86_FEATURE_NO_SMM_CTL_MSR	(20*32+ 9) /* SMM_CTL MSR is not present */
> +#define X86_FEATURE_AMD_FSRS	        (20*32+10) /* AMD Fast short REP STOSB supported */
> +#define X86_FEATURE_AMD_FSRC		(20*30+11) /* AMD Fast short REP CMPSB supported */
>   
>   #define X86_FEATURE_SBPB		(20*32+27) /* Selective Branch Prediction Barrier */
>   #define X86_FEATURE_IBPB_BRTYPE		(20*32+28) /* MSR_PRED_CMD[IBPB] flushes all branch type predictions */
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 41786b834b16..30ce1bcfc47f 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -793,8 +793,8 @@ void kvm_set_cpu_caps(void)
>   
>   	kvm_cpu_cap_mask(CPUID_8000_0021_EAX,
>   		F(NO_NESTED_DATA_BP) | F(LFENCE_RDTSC) | 0 /* SmmPgCfgLock */ |
> -		F(NULL_SEL_CLR_BASE) | F(AUTOIBRS) | 0 /* PrefetchCtlMsr */ |
> -		F(WRMSR_XX_BASE_NS)
> +		F(NULL_SEL_CLR_BASE) | F(AUTOIBRS) | F(AMD_FSRS) |
> +		F(AMD_FSRC) | 0 /* PrefetchCtlMsr */ | F(WRMSR_XX_BASE_NS)

KVM still does not report AMD_FSRC.

The KVM_GET_SUPPORTED_CPUID output for the function 0x80000021.

{0x80000021, 0000, eax = 0x1800074f, ebx= 0000000000, ecx = 0000000000, 
edx= 0000000000}, /* 0 */



>   	);
>   
>   	kvm_cpu_cap_check_and_set(X86_FEATURE_SBPB);

-- 
- Babu Moger

