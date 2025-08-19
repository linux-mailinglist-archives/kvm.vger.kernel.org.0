Return-Path: <kvm+bounces-55040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 346B2B2CE1F
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 22:36:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E1E0C4E411E
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 20:36:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72FAC3431F2;
	Tue, 19 Aug 2025 20:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mfNVaQuE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2073.outbound.protection.outlook.com [40.107.94.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F976FC5;
	Tue, 19 Aug 2025 20:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755635651; cv=fail; b=YRQcHbB7dlklMAuh+PEvDppjqM0vf3YT6lSAQCefefLxWbO2RzkVR6wP2YUNCPOmhd5sygZQE1uFLvbshDFvOdo/L4kB0nWl6dwSSd5So2hI5thiVclIYGRRP2bSoHZovRLzqCjlwi7D/SOf6pxtd+pAPEJcQw/N+3j/LLWXahI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755635651; c=relaxed/simple;
	bh=7dWbu+yaywZvotgLwee+sztio3mWijU+QSnqUdR3Wzo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=j9Ug7V/wtofA2Tm8MAjHAj1m6nuU3CZAecLtJ5XWx/J1H2+zjkSDKWfMusb5h70uHuQ0PwGvx5ID8Rxkl3ZGUDYrg6ievXoXQw0EFZLY/eZfMjY1eZN6E6SH8twvKqnNlKs0s9fvW/yDQLk7uqcMnhjS+RStPi2Bt1RhLHABlWY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mfNVaQuE; arc=fail smtp.client-ip=40.107.94.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pu/zhNPCwDNkbLGeAzq49igl1AezvW9xCehZSTodRTOhuBCcfrGe+bxntIqxAnD0BMiZLyOfEoiatMdwPlTJt6qh2wSXvQysiVJSllBYoCVt65RTndguMbkhvsRslZROc4omlCJP1u8jGxOihmP1bhGX6ir400hdN7PR6m4kkvrw58DBr4FH/8m1vvFfaTBWEU1cHIM9LBCxFybo54Ob1I/KY8PN4xW2DikyS3HOxJN3Smx478sqkaXLgtxkMY1sokZZWya/m23ClM66ntSI7ciA0eVpJ9W8o2IHAI0c8nJWStYdic9WV9Q6AwdgdmlrkYLtpu/slfcY0X767PYoHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nuKXjj/v2WyHELsmakpTIbYyLUmvdfg5QNrRFjzyRFA=;
 b=Hi8sZgYSkTeQqbXh+AWNE9Lls/Zq4/767v3BpB7vtf+CcVlhknNAMcZIQqMyoPxF/9tnQ6l2Mo3/9MR4dPFDDFoEV6bsCjX3FkHi3ndHFbxIWLGZwFLdPyddWYMc9EMT58j51nOEpywdRlXJ+4wWqd1pMsk9abjFjgpkgbrr/i3AqhPfSg2zhADIty2jlzMqLAT49mggayFVgopiqL8YMz8gWgWWz8FJqJfXmIofZdKlID7VL0JwJcLgNxaN1w3iYf4UiaFu2wgymjn2REPUmRGv6lAHugyegU3PvV7VcJQ6YYjp15gtiBJ0bWDnw3Lo0L8+mNLf4q6bosOKCChkOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nuKXjj/v2WyHELsmakpTIbYyLUmvdfg5QNrRFjzyRFA=;
 b=mfNVaQuEavIhyko+Jri3nROgLtJ65wHdHJSnCDJi/ym5Mhe2/WJX+reDHn9oaYpDV9kfY/E4a+YjpDNVqi7alR+m/gRXZu3CoScV6anxsdJy3cB9kTsDD02TfOO31xwKF/HCUw/EVXybjp9WW8eLjNc2eMkj+ozzHYymdMGioDY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by CY3PR12MB9680.namprd12.prod.outlook.com (2603:10b6:930:100::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Tue, 19 Aug
 2025 20:34:07 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%6]) with mapi id 15.20.8989.018; Tue, 19 Aug 2025
 20:34:06 +0000
Message-ID: <35d77bbf-0578-433d-8df1-952fb14d09e1@amd.com>
Date: Tue, 19 Aug 2025 15:34:03 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND PATCH v2 1/3] x86/sev: Add new quiet parameter to
 snp_leak_pages() API
To: Sean Christopherson <seanjc@google.com>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 pbonzini@redhat.com, thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
 nikunj@amd.com, davem@davemloft.net, aik@amd.com, ardb@kernel.org,
 michael.roth@amd.com, Neeraj.Upadhyay@amd.com, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, linux-crypto@vger.kernel.org
References: <cover.1755548015.git.ashish.kalra@amd.com>
 <7f7cdb3268e95b7dfa924c3da16a201da0b095f3.1755548015.git.ashish.kalra@amd.com>
 <aKOXmlCkk900zyVY@google.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <aKOXmlCkk900zyVY@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR05CA0026.namprd05.prod.outlook.com
 (2603:10b6:805:de::39) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|CY3PR12MB9680:EE_
X-MS-Office365-Filtering-Correlation-Id: f89a7fc2-ba79-4d89-c294-08dddf5fbdd5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UlZ1c2h5K3A1cE5jSG10QXgrQWtnQys0RUYyRmdwWWw4dWl6NmM4bFEzSWsr?=
 =?utf-8?B?eVlrZ3RxcjBXSTl5aGs1TXNNS0tCcVdJbzZxb3JTUXhwUFNiakphWmFSVjlo?=
 =?utf-8?B?MnlXVytrTDZsc2lnTklvUWFYSkxhWERocWV5bGFNdnVzVHE3SzFpbll5K2l6?=
 =?utf-8?B?YVU0SVhSM1Q5bTZDRitBSnNDVWNHSnN3WUExNi9oNTU2L2xBQVpXdlNsUk15?=
 =?utf-8?B?dXd4eldzQ0RPNEZmYTBqSzFZSS9tSVAwMjNMcHBJQS90SGx3NFBlQ2xYakZx?=
 =?utf-8?B?OHBOcGdRS1B5RDNvNXVCRnhvSWJCbENVVnhZRUFTallHMlp0aXRNTXlPcitN?=
 =?utf-8?B?OStPQ3lYRDdpYWlxcFhCNGR2UkI4THptZ2kreDRpNFJqVVpWTUx6SU4xdnRi?=
 =?utf-8?B?WkE1QkxGMjc4VnovMzZPbURwc1VCaTlraWgrK3pMWCtMSnFGQlJIVTBiQ0tQ?=
 =?utf-8?B?V0M5dVNaV2RQUE5SRGE5VGdSNnRNZjdKelN6Rkw3TXBHZTRKOTlWM2krQldS?=
 =?utf-8?B?STQxbCtMWWozVzJRZ2FNVVlzdlVBV2M1ZXlaU21aOS9NUlhuQmN5VW94L0FS?=
 =?utf-8?B?UnpiN0pBNk0wSW5hMTMvYi82TzY0V0U1NWNyd2ZQTHFkMnZLYXBrbUZOb2ZD?=
 =?utf-8?B?RC9BVHpWK2RId3hITjZUTHk3MWhSZHpOS2lFS0k5WGZ1RzBFR3R2SEw1Tisx?=
 =?utf-8?B?RzhTWDdLK3dxNGI3SkhZSUs2THowQlNHNTFFaFVhaEoxT2F0bHo5ZGI3VHVP?=
 =?utf-8?B?L1Z2UXJDUm9yckFKQk1iNGtyZmx3K1FOeDhqTWRLSjhKTlgydEFuQW9Xd2ln?=
 =?utf-8?B?eGVmRzBhSW9KRUZFZXByVXNCZHI4T1NNcVVFMzZBdS9GbTZUZUp3NEdORHR4?=
 =?utf-8?B?cmROcFM2emt5SDFYQlhxNTd0dkxWZzNSekhMdWVFZlVIYm9kYXdsMVdIQVVi?=
 =?utf-8?B?QUJidFVGNVQrUEMzZFFaaUpSbk5jZkJVcVoxeXNXQ2pVVDFkNDN2U0ZveGVG?=
 =?utf-8?B?elF5VDYreEhwc1M3eURhOFlJa0lKajR3Z0oyVE40RkRKcE5SRzNJWGsweHdY?=
 =?utf-8?B?VEgyYnZQNTJtNUxIcDk1c3NiQ3VEbnFUYllTS0NFYTdKZTBlRnZEUG1jWm5W?=
 =?utf-8?B?Ui9LMjBOaThjZnhYYVdFaDBqZi9yNDhLQUJGb0xqbUl3OUFTWFo2VDZEYlpF?=
 =?utf-8?B?VnYzbnF4a0xXWGFpTHBIOUpyQk5DMENuZUJoQmRZZUk4VXRtb3VwSmtNSW9p?=
 =?utf-8?B?OU5heVhnNXBLOW5OUnVzWU1Wa3pGa0FXa0NaWTJhdlRNTmczZUx1a0VtSmRv?=
 =?utf-8?B?ZlUxdkpnVC81NGlEeFlqMHZxS2M3TGpJTGRycy81Q1FzeGxVSUFCdzhsUDdU?=
 =?utf-8?B?bHh6NXkzVHlUcFhqd29pdnlpZ0s4QWFjRjdJMlNFS0NGOWF5d2NzbTZhelQy?=
 =?utf-8?B?VkE1cGtyZS9HUVp1T2I2aW1LL0ZObDI1MWk0UUpnbW0vQ0I1aHd4U0N0S0JY?=
 =?utf-8?B?MDFmc3dtN2RYM0l1bWxFa05pVWVqemVuYjUrcjNWcFUzNWxzMFVnbDh1azhh?=
 =?utf-8?B?WTZpYmRNRE9QMEN2NTZ5eWxoejBrbnNCZzVQbTRCaHlwVm56U2Z3RWM3SDBK?=
 =?utf-8?B?SWR0R0laRGJUaHpDYW5KZW4wMjBueHAzczhzci8yQzFmUENJcnBuRGtHaHB1?=
 =?utf-8?B?dzMwcUlGNGEyK3RNNmY5QU03THQvN3NHOWx1d0lvYzJKWTI4dkl1Rm9JT2Uz?=
 =?utf-8?B?SDVSa2VVN0NuQWxSZWRuSjFVbDJwZEdpUlpHSExHV3dUSk5lb1JTblJWMHdr?=
 =?utf-8?B?cHJBVWJNQ0xDYVVIMlM1SWxoc09DRnFBaTZPNS9kNmpiQ0M0U3hrcEUwVldT?=
 =?utf-8?B?QW40UXg5eTB5TFdOeDNlS212UlhEbnpia1htcXhWZmxPd2lJUVVNNm0ybWRr?=
 =?utf-8?Q?0sUtl2cDMIM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d0JaQktXQml1bnhwbWZzelFJdFJlZjV0SkIrTUlXaHhrMDZXSmJmV2FIZWRv?=
 =?utf-8?B?WHZtcGlRQzN3TUdYUlU4SE92NjZTV2kxSTB0dDlDT0lxU2ZyU0pUNmZSSFJQ?=
 =?utf-8?B?aE5md1JkYk9iakNmZFQwQ3FHUGdkdWV4VTR0WFFuYThSY1MwMElxK1RmWWxs?=
 =?utf-8?B?bUh2aC96QWVwV2dEeXF6dW1QLzZKVElMYmR5VmhiWTc4Z29nclZzL0xyNitH?=
 =?utf-8?B?OUt6NjY3MVJrdThtQTFnbXBhcVNxVEJtZ0R4ODFQN3dVa2JUVEtuZ2x4VkFC?=
 =?utf-8?B?c3NRZU9taHF5cUNGbHdvNzYzSDg2QXRiUC90QjBYenBETEUrQkFOQjNUTi9k?=
 =?utf-8?B?bGlRQkJkaDRSdStDeFd6blVTQjc4cklRT2hFMEJrN29qdVlTQ005UUFTdDNt?=
 =?utf-8?B?VkN4SS9VTEZCdE9xWjRYSVRuNll4ay9NTnNidnlBaVJhelFySlVBcDlNYWcy?=
 =?utf-8?B?emxWVGJGTndDRFVZbW1nZm0rb2hUNmhqbWM2SWZZaytNbStPMVZPNk4xeW9F?=
 =?utf-8?B?VlZsaHF1VHRnaXVQMC8yaFlZV2ZjQUtCNUFyc2NqNzRUbmRQbGxXU29VTThF?=
 =?utf-8?B?aGZoVDMrNzFsTUxad09IbDFoQ0o3YzR3WWRCSE52WWFXQSthaW0ya2FSeUVO?=
 =?utf-8?B?S1I0QXM1MUt1b01icVI3WWFPMmN6eDJWYVZOZFYvVkE4emhBQ0lOOGJYQXNY?=
 =?utf-8?B?dnpFTlhkcEN4TWVJZ01BYVZvai9SMHE3Um80VzFmajhSSlp5QjFpc3pwNHVO?=
 =?utf-8?B?ZTNhck56K3JEWDQvUnFsN0Npc1psVTR6eThqbnVqbWY5SlVxYkZGVGZrcUVr?=
 =?utf-8?B?eGVQYk0xR200Q3VsaU4yNnV4ZkVWVXAxKy93MlB3RGtJcWNjL0lGVndTakY5?=
 =?utf-8?B?NXdaS1dGRFBSSjhJaFF6Q2R4T2YzbkFlRlp0bHFwZ3VEdlhRQld4VTJPUnVi?=
 =?utf-8?B?Rkc0NHBJdTROV2loNkp4Q0dOUWlGRHZITkd5M2lqL2drNUNpMlp0b3FUMDdT?=
 =?utf-8?B?eWNoRVVpVkV2QTlpbGhOaFBSYW04UUxpQ1F4RDhyRU0xYTRpVnFxZDNsdkxy?=
 =?utf-8?B?WDZYaUJ4dnlSUVhOSUpkQVZTemkzZndnUFVwVEx6SEF1WERRUFBlL1pBMEcr?=
 =?utf-8?B?MSs0UXBPNW5CS05qaXdzZUU2cDAvSXlNTGNzaE5RVVBRVVVJTnFTUjFncHg0?=
 =?utf-8?B?eUx4TXE3d3FxZGFsN1h1MHBwUGZSMS91WEtZUWpVUlpmQW15SldXa3lVSXZE?=
 =?utf-8?B?UDdzbjNvbG9UOVJZcTVSNnlaYTZpd004KzhaVW5DRW81bDI0NE0vN2hEZUhY?=
 =?utf-8?B?Y0VVbVU0c2R1SzVaY0JKVHV3WDR6VEZsbThabGZTb1VWOFVDTGFXQ083cEFY?=
 =?utf-8?B?SEI5RFVuNmF1NDBOZzNTR2J5UWozK0ZLTzJaT0xSN2sreWhZMFZMQjlMMWVn?=
 =?utf-8?B?bzNQaWUyN1VtblJNbjNoOC90emppVVlxVE9QdXhxMmt6RDNBRk1NdVY1ckw3?=
 =?utf-8?B?ZlJja3lvWE9TcmJJTFhqNCtaMm5vMm1tSE90ajRMd0gxcXFES1dZcVBTeDBI?=
 =?utf-8?B?Wk5ZM0kxSnUrSUttQURScGFZOTNCZXVCRUttVUZLRWsxL3ZyOVZUYzhxUDBt?=
 =?utf-8?B?aVdhbWN0YkFPeTk3KzNPTGlUdkoxb01YL3NhUVllU3RsRHBLUTRkNXVQL3BQ?=
 =?utf-8?B?NFAvVVlobFcyMExYaWNxd2ZPZm44UC9WSnlGZmJtT3Y1cWNPN0RNc1d3dEln?=
 =?utf-8?B?a1lkd2h1UnUyQU1mbkcrTjNMRms0K2dZdnZQZU1aWldURkpsa2czSks3N2g0?=
 =?utf-8?B?c3VRWDA0bmNaMlVQRGVYTXVGMnhPSGV1ektJcldBSlVYOFRqMlk5UVhkUHA2?=
 =?utf-8?B?Vko0d2lGKzZYeWpORytudzJUMG51V1FFN3IrdjE1OFZ2ZkZBT01kOWFOUlNR?=
 =?utf-8?B?ZjZaSDhMY01iazJNbjVQd3M2aWRLVFpCd1llaHZxNTJxVzBLcTZSUUx5cXNJ?=
 =?utf-8?B?dkJPNHVjYXV6S2dCVGhtTStYbEh6dk0yU25ESTBrSnhXRHhOb0c4WjBsdUpj?=
 =?utf-8?B?bXdveFR4dlF1dDVEOHNaZCtCNXZMUEw5aDc5UVFqWmVHNHhoR3J6WVdlVXdl?=
 =?utf-8?Q?RuaUedoMpEGq633dBKoqHnZ1a?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f89a7fc2-ba79-4d89-c294-08dddf5fbdd5
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2025 20:34:06.0246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HynrI2xdxln7VqGvmOCAqvqz92/63hkplJrI/S7jI/U8AR1mnY0NDmJFO9VDkcDX25RSkud7Z+UNd/7wisXzEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9680

Hello Sean,

On 8/18/2025 4:14 PM, Sean Christopherson wrote:
> On Mon, Aug 18, 2025, Ashish Kalra wrote:
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 2fbdebf79fbb..a7db96a5f56d 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -271,7 +271,7 @@ static void sev_decommission(unsigned int handle)
>>  static int kvm_rmp_make_shared(struct kvm *kvm, u64 pfn, enum pg_level level)
>>  {
>>  	if (KVM_BUG_ON(rmp_make_shared(pfn, level), kvm)) {
>> -		snp_leak_pages(pfn, page_level_size(level) >> PAGE_SHIFT);
>> +		snp_leak_pages(pfn, page_level_size(level) >> PAGE_SHIFT, false);
>>  		return -EIO;
>>  	}
>>  
>> @@ -300,7 +300,7 @@ static int snp_page_reclaim(struct kvm *kvm, u64 pfn)
>>  	data.paddr = __sme_set(pfn << PAGE_SHIFT);
>>  	rc = sev_do_cmd(SEV_CMD_SNP_PAGE_RECLAIM, &data, &fw_err);
>>  	if (KVM_BUG(rc, kvm, "Failed to reclaim PFN %llx, rc %d fw_err %d", pfn, rc, fw_err)) {
>> -		snp_leak_pages(pfn, 1);
>> +		snp_leak_pages(pfn, 1, false);
> 
> Open coded true/false literals are ugly, e.g. now I have to go look at the
> declaration (or even definition) of snp_leak_pages() to understand what %false
> controls.
> 
> Assuming "don't dump the RMP entry" is the rare case, then craft the APIs to
> reflect that, i.e. make snp_leak_pages() a wrapper for the common case.  As a
> bonus, you don't need to churn any extra code either.
> 
> void __snp_leak_pages(u64 pfn, unsigned int npages, bool dump_rmp);
> 
> static inline void snp_leak_pages(u64 pfn, unsigned int npages)
> {
> 	__snp_leak_pages(pfn, npages, true);
> }
> 
>>  		return -EIO;
>>  	}
>>  
>> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
>> index 942372e69b4d..d75659859a07 100644
>> --- a/arch/x86/virt/svm/sev.c
>> +++ b/arch/x86/virt/svm/sev.c
>> @@ -1029,7 +1029,7 @@ int rmp_make_shared(u64 pfn, enum pg_level level)
>>  }
>>  EXPORT_SYMBOL_GPL(rmp_make_shared);
>>  
>> -void snp_leak_pages(u64 pfn, unsigned int npages)
>> +void snp_leak_pages(u64 pfn, unsigned int npages, bool quiet)
>>  {
>>  	struct page *page = pfn_to_page(pfn);
>>  
>> @@ -1052,7 +1052,8 @@ void snp_leak_pages(u64 pfn, unsigned int npages)
>>  		    (PageHead(page) && compound_nr(page) <= npages))
>>  			list_add_tail(&page->buddy_list, &snp_leaked_pages_list);
>>  
>> -		dump_rmpentry(pfn);
>> +		if (!quiet)
> 
> The polarity is arbitrarily odd, and "quiet" is annoyingly ambiguous and arguably
> misleading, e.g. one could expect "quiet=true" to suppress the pr_warn() too, but
> it does not.
> 
> 	pr_warn("Leaking PFN range 0x%llx-0x%llx\n", pfn, pfn + npages)
> 
> If you call it "bool dump_rmp" then it's more precise, self-explanatory, and
> doesn't need to be inverted.

Thanks, i will re-work this accordingly.

Ashish

> 
>> +			dump_rmpentry(pfn);
>>  		snp_nr_leaked_pages++;
>>  		pfn++;
>>  		page++;
>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>> index 4f000dc2e639..203a43a2df63 100644
>> --- a/drivers/crypto/ccp/sev-dev.c
>> +++ b/drivers/crypto/ccp/sev-dev.c
>> @@ -408,7 +408,7 @@ static int snp_reclaim_pages(unsigned long paddr, unsigned int npages, bool lock
>>  	 * If there was a failure reclaiming the page then it is no longer safe
>>  	 * to release it back to the system; leak it instead.
>>  	 */
>> -	snp_leak_pages(__phys_to_pfn(paddr), npages - i);
>> +	snp_leak_pages(__phys_to_pfn(paddr), npages - i, false);
>>  	return ret;
>>  }
>>  
>> -- 
>> 2.34.1
>>

