Return-Path: <kvm+bounces-54575-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 94237B24639
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 11:56:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2785088512A
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 09:51:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 264A12F530B;
	Wed, 13 Aug 2025 09:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rwCqrtiS"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2050.outbound.protection.outlook.com [40.107.237.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D68212550;
	Wed, 13 Aug 2025 09:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755078588; cv=fail; b=TUAug58G7cmrGpOde0XIsktpK3bAsBUERGhnI/tph1MlHU6DGh8s+svxyN9ppN3cw7iay6lxpPuibzpNweT3kj04Sl7xaZpbNDXpXuC3YRlSK/MKmDgeIYao0Ne40fxWCeXStoBR6wRLUEpqF7Z3VYOrZg4w8lkeaaG9yFOMxz8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755078588; c=relaxed/simple;
	bh=EqTQSUamyV3t41+YYYvSY5W4ewjcmagow+lqakpCAoM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NFxQl4rf5ewoBm9nrb70+glvVw/Cpw+Iq9w3K1Xqh0/Tpy3op3vag5Y/+1OSTYZCNPHRpmFpuYDpQ6zGzy178xrNyo63Jsyw230TKOScI548vVcUT5Ihalwe1HYIPQROapJhBocB7EHdmia/7mYNajuXzoM0clZGprNAF+ObcGM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=rwCqrtiS; arc=fail smtp.client-ip=40.107.237.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GcA5yIKl27/qgHZmSotgX9NGcX0A7B7YNSCTc1mAmkCRZl3/0UfoZ91nD1IG0CdguLc1gAsc/cwWZAqhiSC8ojhOHwWvPsRnJCxZi5kc9HXCuREP6n39EtKlva+NZBSFSO218SSujWy5TuuK9vf8sJyBSSudiey0FUPbx450mWx7Q6SLnZXOD72Gym9VWXIZJ9FEwhz/Ps6gIgeiDjbeeayi0incnCauXNxtnKtGSr3rTGvS3IjVF6GeOer9Qzy6XtUIXY16nRhKK3b+6bW22JQN6Qz7z+fUhJLvrL7s18N1k4hI3G9lbZSEU4GUF5Ike91CQnDTGaMH2iAW769jmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5mIAtkoQQU+/ekmx8hIB5wqJnSLrrW723lovBWuJ1QE=;
 b=H8w4g0gOoI9ViXOVHYRQYqoPz78VsoEsft/p2bq1Tuh7r5bIJiVLMu1Yt1QZjIXmG9Rri0jV78wg4S/Lt4dobZlIq9euPuvowVDHqcBH9yZnG/4VwYyZokVyvz2vgyUqbje87PJsZ48iwX2kvN+7Yq5/qx0NwxNoDMlqGyZemFRFgL+r34ELEcIkYQoYoKLW8YrjVQdPb0y4TAj+YLN0NcKX0eksOOJ4HafooU9K0pvzrWSeHDAQr/c6b1AEdQq31fhUWkojKztNgVOL8RvQOs/pGdrqLEXLzPrwm/BIfAZcz6TeOaabSceearQEZvaUs+WXNbyTI9m7ITFFmu+Hnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5mIAtkoQQU+/ekmx8hIB5wqJnSLrrW723lovBWuJ1QE=;
 b=rwCqrtiSQAiBR4wFrrp+R4Dj9Sj7X2ZKRy0qmqsgh1KbqNUGoFV7tTuHH+3ZYqLnsZNnil+M9foQBSyF62o/aEU7kvPCJHyIuLpifJs8bQ0i2hPxxmNsLeH9kCZk8VPT8mh7X0kFiWKggU7xevEcw+UYSL976lGTvtQ5VCC3QJ8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5712.namprd12.prod.outlook.com (2603:10b6:510:1e3::13)
 by MW3PR12MB4458.namprd12.prod.outlook.com (2603:10b6:303:5d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.13; Wed, 13 Aug
 2025 09:49:42 +0000
Received: from PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291]) by PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291%4]) with mapi id 15.20.9009.021; Wed, 13 Aug 2025
 09:49:42 +0000
Message-ID: <30e986b3-4d93-4b77-8f17-b966f0ba7fab@amd.com>
Date: Wed, 13 Aug 2025 15:19:27 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 20/44] KVM: x86/pmu: Implement AMD mediated PMU
 requirements
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao
 <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, loongarch@lists.linux.dev,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 Kan Liang <kan.liang@linux.intel.com>, Yongwei Ma <yongwei.ma@intel.com>,
 Mingwei Zhang <mizhang@google.com>,
 Xiong Zhang <xiong.y.zhang@linux.intel.com>,
 Dapeng Mi <dapeng1.mi@linux.intel.com>
References: <20250806195706.1650976-1-seanjc@google.com>
 <20250806195706.1650976-21-seanjc@google.com>
Content-Language: en-US
From: Sandipan Das <sandipan.das@amd.com>
In-Reply-To: <20250806195706.1650976-21-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXP287CA0010.INDP287.PROD.OUTLOOK.COM
 (2603:1096:b00:2c::20) To PH7PR12MB5712.namprd12.prod.outlook.com
 (2603:10b6:510:1e3::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5712:EE_|MW3PR12MB4458:EE_
X-MS-Office365-Filtering-Correlation-Id: e228179c-a083-48ed-c177-08ddda4eb9f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bUk4cWRreDdFd1llcXgxOHRFU2toSEhBdG9adHJzaFI2VC96TmczOXNDNHh4?=
 =?utf-8?B?Mnh2OEQ2RkNzTUlzd29PTWFXa29CeTNMVXI2T0dWRXo4dEJIam0xK1BEZmZF?=
 =?utf-8?B?d3pTbEVDSFdTWENBejNBbWZ6MXhHRzAvNUg5ZkNYWDVaT2JoS0dzWGZHWGFv?=
 =?utf-8?B?Q2JoMEE4RVNOdWVMaHp2VGZrVmRnMCsvWnl4T1ZnT2duZFRtdEc4dkdtSlhG?=
 =?utf-8?B?bnF6SXhSYmh3anNPcURIUEl0K29PMWVzTDVjOGZzUVVWTW9uclp6dnZNeXJ3?=
 =?utf-8?B?clZSWFpub1RQUmt5bEhaSENVSVZZSUJHT09NUVFJQnB0ZlYvSGRrQ25zT3F3?=
 =?utf-8?B?UFhVN1g2NCtCSU5IeHBLSzZCTGVGVW9FUlhJSmY1U21USVZ1UitCUE45djhB?=
 =?utf-8?B?ZWVLaUJlOGpBYWc4dDhxZDVMUWZ4NTA0b2lwWkp6ZFZKUWNhMnZWVVEvTWdv?=
 =?utf-8?B?Mjh5VFRpSXFLN3hJYkFYekhUd1ErRDRPeVZFVmhZOThOM01hOWdrTDVyVDcy?=
 =?utf-8?B?ZFFGb2htSVNtYk9xMzRBK3B4MmNqNDlMYm1zT21pR0NZUFVjSHVuMUltOW45?=
 =?utf-8?B?clJNMTdSREdXekZQLzUvbXViSmRJdVhISG5USmpydFNzbld3d01QNTRFenVh?=
 =?utf-8?B?VHRjYTVIRjhtdkhibGFORWVtUGJHcm9CRWN3dDk5eVo5NmNZTlUxOVhsNE5y?=
 =?utf-8?B?NTRLUTR0bUxwYjZZcFFFL0dYWktDdmpubC9ZVVpaUW5rWDI3ckVWRHFsRkYr?=
 =?utf-8?B?MGlHbXVLb3l0RTVua3Y3c3ByRU96M2JwMmNVb25GYVZhcExXaC81YldoVWdI?=
 =?utf-8?B?THBWV2d3dWU0aVBmc3hKK3ZPMkIwbllwZC9xdDZjSFNnMmdJckdTN2tHR3ZS?=
 =?utf-8?B?ZmJYa3ZnOThQM0ZVTHhOT3h1L21QSGxybEZOL3FMSVFBZTdnbmxRRDNZMzZp?=
 =?utf-8?B?UUdPTjBXdWdqVXAzZDJIOGg0OGNsU1pPdEVSL09PTWIweWMwYWErL0hQWDZ1?=
 =?utf-8?B?WlJmVzBzeERIZHgvMng5MVhvMGF3eWxsMk1MY1JRK2RBMC9ZN0lObGtRbEVX?=
 =?utf-8?B?OTA3cXBPL2RONlpaWE9PNk9lRndISHhWQkljSXJXMWdOUFFuakc1bEgzcmx1?=
 =?utf-8?B?QzVpUEFadjVwb3hQVERvT2xnK0NET0x6N25JWkxBVGpwK0s5M25TWGxkMWto?=
 =?utf-8?B?L2xreUVQWXFTYWtiZlFRb25aQm5pSEpCbHdNZ21XRy9YbWhINS9YYnBUNXpO?=
 =?utf-8?B?azdqaGhtTWc5VXFXRlUrTVpZSHJBQ2djZm1DemswR3AyL3VnRDRLeDNlbTZL?=
 =?utf-8?B?aVJkOGRGc3Z5akJzdFdvWGVRZG44RWxEL3RMQkUvVWwwMnR1YmJRSy9YNW9q?=
 =?utf-8?B?UmFUTUZtUUJiL2hPL2xMbTFvMFpCa2dhNG5MdHRkb1BVa2M5YzIrd2tNaFdm?=
 =?utf-8?B?TlgrZG1SSy9QQjhhVE1ucnpuVnoxK1F2bzFYMjJndzhlWWdaa2s3c2JzTWs2?=
 =?utf-8?B?NFNSR3Nha3ZrenBaRG4xbFFpNzdXUkdXZVFoT0JNZjlBUjRtbzdCcTRYSERU?=
 =?utf-8?B?SGN4TjJ0WFRySEZJWi9kaGNSdWovbDU2VmtjbklPVUFPak80YnZaalpYd0Q4?=
 =?utf-8?B?RWVydkQ2bHhzQXB1YXd4SjBCNW83eDM0bGgra3FRM3dkWUdKVzhKMWVHZzY0?=
 =?utf-8?B?OUNFUmgrNU85M3owZW5ib3c1elJleVkzRko2SHVvdkxycE1wbE9EYjV5aVcr?=
 =?utf-8?B?QXE2R01GLzc0RFJMcjVlOWV0NmdvbEVGbzhkN2dkOFRWNlIrSjh5ZkU4Z1JJ?=
 =?utf-8?B?Z1YxRGxySmsxci9QbE9ValFPbEhtc25tZnVqZE9DVzJVRnhXN1MrSHVDeU1m?=
 =?utf-8?B?RlpaVmprdzNHVTFPZDFIUEpBaGk3NW5EYytlTVdpQ0F0MXZoY0pHM1RjMFY5?=
 =?utf-8?B?RklNRThKMnNQaWY5WGZBQzFIS3EydzYyZU4rcXBjSWJHR3hpbjFiOHJsaFAy?=
 =?utf-8?B?QVQrd25nc2Z3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5712.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q1FpQ1pqVFJiRlV3NW5GN211Nk9SbUZqejVBY1lGSzNOSE10MmNhcytqUTA5?=
 =?utf-8?B?U2FydS9vQThQbzI0QS9OcDNyNGM1WFNWeHlyMHZnYVAvRTNzY1NUaWlOcjYv?=
 =?utf-8?B?UnpzemVIbGJ5aEZkM1orZE1LL0ltRlVsUWpOdDU5b042c0dzTDMwaHNwSThV?=
 =?utf-8?B?QUlEQ2FoOUdtcVhBR0FYYjhUalpBeGdWSm5QcFU4VXFpcm9maDZRd1gwVmpM?=
 =?utf-8?B?RDFPT1U1WVdEVytobG5kUVdPU21rUzF0bjVMV3JsVWxjZXZZK2FFYlZsdzly?=
 =?utf-8?B?NnJPcXlFS2dGQ3p6Wkx1TlRDSWNRNEd2V3Bud1ZoalFTdEYya3FqUU56K21x?=
 =?utf-8?B?dlFLR240eHNjQTFYekVNTkFOYTZXaXhkUXlGOE1zQ1lhSjNxMTB1OEhDQzNY?=
 =?utf-8?B?VWhmV0p0V2w1RjExUmFCMkxTQ1hRWmxLZUF6ckozeHVnak5BdU1sQ0U4d2Iz?=
 =?utf-8?B?Vk8yUmhFajdIbzFiQ25zYWJZVndUYmdkSEx2T0xOL0hiTUZtbmYxNTVhTUZ3?=
 =?utf-8?B?R1FiWm5PbTdyTUUrdnVIMUo3Ym5kYkdyeTF6Vkg1WWNibDk4QndaOUx1cVpk?=
 =?utf-8?B?L3RYU3oxN3pySzA3QlJWNnZla1Jpblk2QUs3Ri9TN3U4b1FnWnBCaGRhNHpm?=
 =?utf-8?B?YjFVSThhb2EvSmZqTjhxdWdEdUtDd3VxSXlPQVB3QWRiOGxCS0tUamk0MDhP?=
 =?utf-8?B?OEZXa1pGd21JcVJUQmlZNUY2Rjd0VFlpQ29mTGFOVU1yY25kd1k5bVVQSTYv?=
 =?utf-8?B?L1V4RXVXOUpnc04xVkhpU0xST2ZNRGRBWW95ZExTV2o1cG9kMHl1S0FUZ1RV?=
 =?utf-8?B?MXdEUmhCMVhUeDdBZVlsUW44QzdIZ1huVVZ0TWtQaWk4QU1WaWV2aDE0cy8r?=
 =?utf-8?B?UXRLZW5pLzFKWFc2ODNPQjlOZmovMStFUjNldmRDRm05Rk9YQWRqOHlySlhP?=
 =?utf-8?B?dG5hc3BMMDh2aTU5U3l0b1g5bUVGTml2K3pzSFQ4SEhFY2VmZDZHMHdabVpC?=
 =?utf-8?B?K0g3Z1hsVytRazVTZkdUUEc2V3h1cjNmelN1YlFkK3Z5MTNuYXV4eXVBS0I4?=
 =?utf-8?B?b2wwd1RsMUd4R2tsUTIrcUN2S3JHN1VrMDF0NCtDaWNlWThnUlgzQU1DeVZU?=
 =?utf-8?B?bGlkMzcxaGtNSmUrMGxsU3JVUndmVCtJRDVrWkVvZi9YQTBMM1FYbWFKQ09p?=
 =?utf-8?B?enJBTVRwR3ZKaHhzLzBkNmNkWS9ySUFxQXlLckUrcEt1emhNN3hGZy85UkFC?=
 =?utf-8?B?QmtzUTNvOGlFR09uNHNGY3laS2wraEx4VWx5RzRSYjlNUTRVaVNXZU9nZjJj?=
 =?utf-8?B?STIwQVUrVktUQXl4cUFwQ1Q2SGVFN0EyYWZnRHV0Qkt0ZFlXSGZGSUMyRFpj?=
 =?utf-8?B?WnVKUDN6NDl6UlB2MG5FTGdkS1FxSmhuNEJqK3lnaWpDWXBQRkVGMDc3OThR?=
 =?utf-8?B?ZmwrUVd4bDZRcmtYMGhmaitSN3U0TEZwSStxV0JuN3pTR3RaclpnMTlOSU1s?=
 =?utf-8?B?SjVidmdmbldhemNoOWJQUmsxYW11bzJaMHpOZ0lwSXl5L01vblUwOHNwSWdU?=
 =?utf-8?B?TFBNUW10VHB6TitIN3Q3WlN3OGlnbTY3OGFtcDVMK1FLUWhhTWFYU2hSOEg5?=
 =?utf-8?B?V0FJME40am0vWUphOGRBTXhHMko2YXk5eWVyTHlTNDlRWUxrRjBQcjI1WE5s?=
 =?utf-8?B?K1JZd2JCYmozZUtQdzd2dFJialI5MktrWnh2Sk9ITG16VWsySzBONW5waVdP?=
 =?utf-8?B?UkZLT0hEUTNWRCtqRlBHMHpjc2pCNmhpMmh6eWJEeWg4WjkyR3dJSGhSTDBt?=
 =?utf-8?B?QnI1QTEwdjlnbXFQTlFVNEpRUjdibWJkNUxRcW5QdW56cmJKT2pycEg5M1RS?=
 =?utf-8?B?ekRlZkVveUxqanFNc09KdXFOMVhaMGthRis2VFVyS09ScTRaUHhSSjg2TWhP?=
 =?utf-8?B?OVBCMjAwZjZkV3lNaGw4OXkvNTAvU2Z4SUNqZ2JDcHdock9TaW9NUE93eGNr?=
 =?utf-8?B?c2U2VHZLWVRnc25vd1lrcW1wQ3ZOTUVGeWVaRFVON0xaWElaRjVOMzArRlRl?=
 =?utf-8?B?K1pIVUNnbnVZeXo5azlRVzdqVGFLU1htbWRKMWFwc3NUdWowdWNobTl1UWFL?=
 =?utf-8?Q?37aKHYtVT6LxyE11esV9kY3s8?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e228179c-a083-48ed-c177-08ddda4eb9f2
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5712.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2025 09:49:42.2194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U+O3Ru+l147K3V/dI+i6Awd6igJyx0EE4/s66OeBkV982X5/7mqchDiPgfwO9BFYgzSjn62CCD61Xku0v8ISPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4458

On 07-08-2025 01:26, Sean Christopherson wrote:
> Require host PMU version 2+ for AMD mediated PMU support, as
> PERF_GLOBAL_CTRL and friends are hard requirements for the mediated PMU.
> 
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Co-developed-by: Mingwei Zhang <mizhang@google.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> [sean: extract to separate patch, write changelog]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/pmu.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> index 7b8577f3c57a..96be2c3e0d65 100644
> --- a/arch/x86/kvm/svm/pmu.c
> +++ b/arch/x86/kvm/svm/pmu.c
> @@ -227,6 +227,11 @@ static void amd_pmu_init(struct kvm_vcpu *vcpu)
>  	}
>  }
>  
> +static bool amd_pmu_is_mediated_pmu_supported(struct x86_pmu_capability *host_pmu)
> +{
> +	return host_pmu->version >= 2;
> +}
> +
>  struct kvm_pmu_ops amd_pmu_ops __initdata = {
>  	.rdpmc_ecx_to_pmc = amd_rdpmc_ecx_to_pmc,
>  	.msr_idx_to_pmc = amd_msr_idx_to_pmc,
> @@ -236,6 +241,9 @@ struct kvm_pmu_ops amd_pmu_ops __initdata = {
>  	.set_msr = amd_pmu_set_msr,
>  	.refresh = amd_pmu_refresh,
>  	.init = amd_pmu_init,
> +
> +	.is_mediated_pmu_supported = amd_pmu_is_mediated_pmu_supported,
> +
>  	.EVENTSEL_EVENT = AMD64_EVENTSEL_EVENT,
>  	.MAX_NR_GP_COUNTERS = KVM_MAX_NR_AMD_GP_COUNTERS,
>  	.MIN_NR_GP_COUNTERS = AMD64_NUM_COUNTERS,

Reviewed-by: Sandipan Das <sandipan.das@amd.com>


