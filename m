Return-Path: <kvm+bounces-17745-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F4B98C98B7
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 07:07:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E921B1F21560
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 05:07:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 393AF14290;
	Mon, 20 May 2024 05:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="j01nvbp8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2069.outbound.protection.outlook.com [40.107.92.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826A8DDA3;
	Mon, 20 May 2024 05:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716181616; cv=fail; b=CaHPCAq9ezQx4lSBdOlPxziTRlFY1rloqZcfsRUIsqAxcADpLXrjhkmJYkMz2yG7PnWZMK5va0PerLDdGUDkgQso6a9MLwe5QY2iDEpHTDFMKqhva4irh7tix/pR33PNoIjMO2oo7tBrQEGt3KuFmfMlbKiasMKBSKd6A9zrTpE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716181616; c=relaxed/simple;
	bh=cpnylsIT6vrnU1Zd7YJ2kUEqO5z/2MnBpfXYIua/gps=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=n6YLcfwhD4m1VGguSt99Z8QEysieeX2kK6y8FA0LA7wZwyqP8oqWgF/ny28cMz5OqAsusAnviN+IvP3oahrbdr4RByBI7eHswQzwqgk51RTAi942JgCtIXYX2I9NCByZ6DBYn/O31GrKqK5fkNqM10RfGY9x/1qyYwLH0ECvRJ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=j01nvbp8; arc=fail smtp.client-ip=40.107.92.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lXDFBb8VAzXu2M76REIStvXe9A1lyhsLL2bVP0gn4xTi4zvnSPC7+aBq7eFLdcS9sL0WHBUzRIrYGCKf99c+AtnvraXGSr6IiVXln6KpH02dqX42gXGvlDjvwgfFdD+0WYOQzR+v0m8pkD2TcuPeOHj8olw2oBazAJUcFa+wi2bplFNaIssd/R+DR5gqY+DzaRz9c3AqD+vWGSwaOsFfazY7yWkqnFrMCfCeyCNZFn3ixIbkDM5Q3mAB+0M5ppu+GVfhzFGz07FKq7qJZW18s8hyMBuSKDZCDQUIOmi7Rlih3+lMBgPvwqOc+wRpc4Bi+sNqfUvogjCFMZhQVmrgOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mJ5pW+rwTkuxDKuirHLQuxXNhJPZbzEiRTh/F74IXwU=;
 b=E+JsPeZGup+BwdBK0keAl8rdBBu+bWLQEMI9mpgmTs/uHCvTJUWQZj3QSGr+MNiAcwVbm5XBiuHUiRxa7NGO9dPjYp/vVdSHTkaqLkIL5EZkDXUg5YXU92TtXaR9ZT+TESJHwtUc3cKI0qjSrOTDidNUTxvczIg5MQsWA/fa0I+oZE6Vp4tvg0P6+K4Wu7apVHWU/UhR/vfa8qnikakZy34wp3gjuEcxOSFb1TTdm6m4wdyeXC1yHVCqRGZiBD0PunvjoQ2PDdE5ez07C0ZfFoKKgnlFj23i13XsZ4guPcYbo4SVkHnBO+Pbz8HiZuyUWLmyBLVVnO6xuxc9g5R96A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mJ5pW+rwTkuxDKuirHLQuxXNhJPZbzEiRTh/F74IXwU=;
 b=j01nvbp8Iu5p4c3hdKHERZD81byZqtgMFJzz3JZ9KqOw4NqRCw412RFDlUgRcz8HYYRg+inoTEDcrs2WFoS/PYzI9OoR6NR4O4S0c0O6VQQ1Ru+o1VoU/SwaL4hxwwh3sSVFx+CPODvX+0PTDTfFFQD4yUFtHtQPln9rUyOxRRU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10)
 by IA1PR12MB8287.namprd12.prod.outlook.com (2603:10b6:208:3f5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.35; Mon, 20 May
 2024 05:06:51 +0000
Received: from PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39]) by PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39%6]) with mapi id 15.20.7587.030; Mon, 20 May 2024
 05:06:51 +0000
Message-ID: <35c0dee9-0e25-4000-5386-2480db4ab1b4@amd.com>
Date: Mon, 20 May 2024 10:36:44 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2] KVM: SEV-ES: Don't intercept MSR_IA32_DEBUGCTLMSR for
 SEV-ES guests
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, thomas.lendacky@amd.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, michael.roth@amd.com, nikunj.dadhania@amd.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, santosh.shukla@amd.com,
 Ravi Bangoria <ravi.bangoria@amd.com>
References: <20240416050338.517-1-ravi.bangoria@amd.com>
 <ZjQnFO9Pf4OLZdLU@google.com> <9252b68e-2b6a-6173-2e13-20154903097d@amd.com>
 <Zjp8AIorXJ-TEZP0@google.com> <305b84aa-3897-40f4-873b-dc512a2da61f@amd.com>
 <ZkdqW8JGCrUUO3RA@google.com> <b66ea07a-f57e-014c-68b4-729f893c2fbd@amd.com>
From: Ravi Bangoria <ravi.bangoria@amd.com>
In-Reply-To: <b66ea07a-f57e-014c-68b4-729f893c2fbd@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0246.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:21a::16) To PH7PR12MB6588.namprd12.prod.outlook.com
 (2603:10b6:510:210::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB6588:EE_|IA1PR12MB8287:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b9b3901-51c3-4a75-9fa3-08dc788aa8b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|7416005|1800799015|376005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cGhGLzJzOW9FaHNOaFJsU3ZmM1VGdmdFWlBJMjFHOC9wcEFlVFc0L0pLalVP?=
 =?utf-8?B?Q0NiYWMya2dQeWNrOXVDTFd4aktyYlJFMWEzcTBUN1VLRUJ3VTl2d0JlUGZB?=
 =?utf-8?B?Tm1DNGlEUW5XTWd6Ti9rTFhlb3FYTjE3dTR0bzU2enlLRC82eVZtWUpTMldT?=
 =?utf-8?B?cjgyWlg2YzByMitXYlp5QXZncnJQd3lFZWxCWDRSNEJRQnJTK3BScnZkL2E4?=
 =?utf-8?B?VnplV215cDJzSG5mbTY2MUlRYWVZS2EyN25IVGZTZDZaVWVkSGUrcDd6d09s?=
 =?utf-8?B?dUhEZ2hjb2l4ejNsTVdHZ2RmaVF3dTQ3QUM3bDNzQm1mdWg5YXczcHdySU9j?=
 =?utf-8?B?TTFLMmlaSkY1L2ZhRFJHc2RhV0diTS9USDErTlZOM0g0dGMrWmZKcmpJN2gr?=
 =?utf-8?B?dFk0YTZnam4yVlZneHR2TG0yZ2hoQlRNT1gvTGtGcWRzS0NYQjlrSWFNcFVP?=
 =?utf-8?B?V0ZYZm1LTENGVHovREthL1pRMElreUpMWlNxTTRsWUdHbTZJOEx1UUpxak8y?=
 =?utf-8?B?OWtJdW9XQjV3QU1mdHFMNk5HZ0Rlb0xrVXRKVHVPQVkzZ3VYYk1RZ0FReHUx?=
 =?utf-8?B?K203aTAzck1RVHd3QllTcUxZL241bkgySUhWL1FvLzZ0V1VxMWRJQWlDNm9W?=
 =?utf-8?B?c3BSMlp4TzZLZ3VwZ2RORUE0YlJnblhYNVQzdy82VHhUN0NqMEpFS3lSZlp4?=
 =?utf-8?B?Yk53WUpsc3lYbFZQVEp2SkZnYmZucEF1Qm5lck9RNWJkY01SUXhBWWYvMXRh?=
 =?utf-8?B?SWhucnpudU1ZTHBJSnBDc2hTQ0dEV2cxRlExVWoyMWUxZVBKNW5YL0NEK0di?=
 =?utf-8?B?NkVhSXBUVEE0akVCb0ZwcjBPbkJiOUpCc0svYTBUU3J3UGRlaGgwTHFwUlhS?=
 =?utf-8?B?T3p6OXRpT1lDRzRqMUVuc01zdGlrRDV0UFFYVXUwSzUzQ1VoUitkUUR6NXdF?=
 =?utf-8?B?bTZURnZGaFpSKzMvUmxoa2svUkNKcXB6aWFGb0Q1cDk2aWJWMUhkR0J4NGpI?=
 =?utf-8?B?ZW12ak5HbWc2NFo5clNPeFRQcmcyUUxzUmtQMlJlSXJlNXZUT2ZrcXdiU1pX?=
 =?utf-8?B?TWtYa1hSQm9neC9EYnFzRVB5Y3E1V243ajhxTmd2RGZRZWNBMTArVGFWZWcy?=
 =?utf-8?B?WVQ5WW4yT3I0aXk2VmZGdHVrRDZsWks0Y0ZzS243L01BczRZeFljTk9NRnAy?=
 =?utf-8?B?ejNyK2tNcjFmOVFGRThYbjZ6UmJQRGlUQ0NyMzZ1aGphWXhVZWJzcHlCNjQx?=
 =?utf-8?B?MVJzSkpDbkhleHNxcXZUUDJwZFFrZmkzREJJY0lDaExMelI4ZDRuTVhrQjJ5?=
 =?utf-8?B?Q2RWUE5DUDVWKzdnZmhETzJsb0M5K3BWR0hGZVdhb2lmTnlHK05zQ3ZuUGU3?=
 =?utf-8?B?WGsrTHprL3B4TjBFdmVmb3pNR1Y0d1FycVlGUkQwMEtSZnZ6enhVRnk0OFp3?=
 =?utf-8?B?N1VyTGpWNTJ6dVUydG1WRHFZWlhJWVFKQzBwb0kzTWZmS0ZVU0NJOUtxQ2cr?=
 =?utf-8?B?WlZTT1V5Nmh0dGFtUllFK2ZoS3cybDdzeEtqanNMSXB5RDAzWVZJd285dllp?=
 =?utf-8?B?bEczLytEZTV4b0tZZzg2M0Rkait5ckR1RUZkSFRZT0g3QVRvWWtsbnl1amhu?=
 =?utf-8?B?aDltOEliQ1RKRkM2eTkrMjlwQnZVSUp0OVd3YjBURlZBSzIzMGVoRkFTSk5j?=
 =?utf-8?B?UHhhcU9mZUh3aE5pYklOWFZtcUFKTTFOM1ljcDRtcU9GZ1ZqcHBOUWR3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB6588.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TVJjeFBHaWxaaWpnUmVZd055aXp0amwrVm9tbGQvMzMrd3ZkL0xQdUZJd3ZB?=
 =?utf-8?B?WkVWWnRsQ21qUFl2cTUyYTU3NlI4TytmdzhRQm1UNkM1SWVqa2wvOG9wQVBH?=
 =?utf-8?B?NjR4Y25GZDZwWXNFaCsreW5FQVR0U0lUemtwSU14L0xpaGp6bTRualgvcmF3?=
 =?utf-8?B?RlpTNE5sMWhKSmtFcVhFQndCSTJ1RVN1THdQR0VWMGg4M0pCS01HQlpLZDBF?=
 =?utf-8?B?ay9Qc3ptZTFMRW1TQWVHM0xRVEF0UmRIbmRoZ3N6Ulg3eGpzdnM1NHFjbDlz?=
 =?utf-8?B?b1hwVi9ZQ0dRMDA2ZmE2NndmZDhuNitUR2tSUTdYMTZjSG9wRXJ6eUtXZHBz?=
 =?utf-8?B?S3BKbWJyNkZNd2NzVlluYkhJZDRMZTNULzVERWhJeW1rMTlpKzAvMUt2a3gw?=
 =?utf-8?B?K0cxYVRMZll1Ym42NFZHa3VGY0kzQ2VaTmhMNldOc2ZLdjhIOGV1a1B6L3Iz?=
 =?utf-8?B?R0hiR3RJSW5TU3c2MVoyNlJiUWdWaW0xd042M1lSaWNTOThxQy9VSUNYUStG?=
 =?utf-8?B?NFBNR2RrZUwvZ1BkOXR3LzBqQU50ZWt6SnpXOUlFZnJBNFJ2d1hvSGY1WEJt?=
 =?utf-8?B?UHBXZ0ZPWFV0cjNKcDdiMnZCb3psc2U5N2VVb21CcEhYYU9Wb01oT3k3ei9H?=
 =?utf-8?B?RXZJQjVTNEJwMlJlT3ZLZnVhV0Nyb3NOYmpJR1hpbW1Zclk0VWc2Y2g4YTY0?=
 =?utf-8?B?UWU4cS9WY3dmR21OZ2M1WHc2YVdpMVlDWHgzaHpoQ1VIZXI4ZVpJb3kyM0t0?=
 =?utf-8?B?aEI5OFJFZkRQMzMydS9BbFJESlRZYytmSnpxYWowdmtrM3hRRmY2WEZQWldI?=
 =?utf-8?B?QlpNL201RlRGSEtuU09MU29NMno4VnFkbG9xUmRSNk1wOEFQZjQrS3Z2cmE4?=
 =?utf-8?B?a3dzT2RrZ1Y0eGdhQlhjMnJoY3pqcXFZU2tmUEdQcTg1RmpNNEZaaHk2WFF2?=
 =?utf-8?B?dFJMMGNqcDErSkVJWklMSnpxcXFZN08vcG8yanNwQ0krbno0cEFtSnV5dFZx?=
 =?utf-8?B?UTQ5bnRIVEhLbHkwUm1JbXJrem11ajVBT01wVlByYVFMYWM5RG5JaXg3QnBY?=
 =?utf-8?B?ZzZaaUR3Qk5LQWNBV3FkOWVCTDloM1c2WkdmMC9uaWl1alhndVZZdldrWlhH?=
 =?utf-8?B?M3pQL1Y2NXVKcGExUW9obHlzaHlUNDFobnlXdHNVY2dLdTdobTFXbTIzZHNw?=
 =?utf-8?B?eWxRL29jNXJFcjFiUFBLS0VWSGZnWnlEM2llQ0QrV3VHYWs2bVR0WkZQcGo2?=
 =?utf-8?B?bEJObEQzejZIeFhaV2pqUVg0NXpCZTZ6TjNRSFBGNjRHZWFGVzBLUjFhZXUr?=
 =?utf-8?B?UlVtSWVzTkxuQ2Q0Y01TUWdMTjhqZkF6dnlHdXpTVlhLT0crRWllVURJd01P?=
 =?utf-8?B?TWpOSjNPcTFxTWs4YkpIem53YnRWbVVvMzR5UmcxcDRWa3Q4NUtrZ1BJNS9Q?=
 =?utf-8?B?OTltK1dFWUtPU1Z5K2VIUlF1UTdrR1RhVlMrTXplenN1Y3NWSURGRkdzeTJV?=
 =?utf-8?B?RXBiRVl4UXVuU1dtTk5vREN2SlZKYkR2NWtqbWRBNnhnWGxlbEN6bGY3Mm1V?=
 =?utf-8?B?UUtLclcrSXgvTUN6TUNJcndic3pzTW9YTXFTWGtYUEJrTyt3YVUvbEVxeTVj?=
 =?utf-8?B?TUxjVkNkWXZBMHp5VkhEM3ZjN0NqODRKV3Iwc1E5N1p1L0tkVXdtTmtXdmxO?=
 =?utf-8?B?R2FkRzdqMWhtQ3ZHMzVvYUVTNW4xZmlOSU4wckxsaW9aZmM5NHVNV1psZFVr?=
 =?utf-8?B?K25nekY1UnZmTmFjMW1CQmZoTFNaY0tJT2dUVGw3STB5cGN4cTBMbE9jdVNU?=
 =?utf-8?B?MUJ0eUpqU01Ha0FwaG9OeEF5eWFIeU5neEhQNUdzZWdza0xIVmI4S2MrT0pS?=
 =?utf-8?B?SFgwQytJaWRxNHZXWVBtNFVWdWY3Z2JzOUFGZkZXQVdFd2tGZDNzenNnRXc0?=
 =?utf-8?B?aHIwMEQ2QlEyYlVYTUkvakJwNjh4Y3F2cjR2bGZNOXovOGczMFJpWW4wbnMz?=
 =?utf-8?B?YXpXaVJPSVRnZ0dpNkZjdHBCUE5seXpUd1JUaWI3RGZBaVY4djRhMkduemJK?=
 =?utf-8?B?RERiMFZzUEJXRFF4TG9BSGR1NDRGRmVTeEpsQjRUcUQwSlpyMDlpT1d6OEp6?=
 =?utf-8?Q?chKabC3O2FZrzgNNT7BnJh+7k?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b9b3901-51c3-4a75-9fa3-08dc788aa8b4
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB6588.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2024 05:06:51.4219
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aQe4Se7Wshv57r/rs4Pab4zNbP49pl958nxPrZftgTB/G2G2hV2uUHlDky9hajaJwXDa5JS2kVs1IfTNZr2sAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8287

On 20-May-24 10:34 AM, Ravi Bangoria wrote:
> On 17-May-24 8:01 PM, Sean Christopherson wrote:
>> On Fri, May 17, 2024, Ravi Bangoria wrote:
>>> On 08-May-24 12:37 AM, Sean Christopherson wrote:
>>>> So unless I'm missing something, the only reason to ever disable LBRV would be
>>>> for performance reasons.  Indeed the original commits more or less says as much:
>>>>
>>>>   commit 24e09cbf480a72f9c952af4ca77b159503dca44b
>>>>   Author:     Joerg Roedel <joerg.roedel@amd.com>
>>>>   AuthorDate: Wed Feb 13 18:58:47 2008 +0100
>>>>
>>>>     KVM: SVM: enable LBR virtualization
>>>>     
>>>>     This patch implements the Last Branch Record Virtualization (LBRV) feature of
>>>>     the AMD Barcelona and Phenom processors into the kvm-amd module. It will only
>>>>     be enabled if the guest enables last branch recording in the DEBUG_CTL MSR. So
>>>>     there is no increased world switch overhead when the guest doesn't use these
>>>>     MSRs.
>>>>
>>>> but what it _doesn't_ say is what the world switch overhead is when LBRV is
>>>> enabled.  If the overhead is small, e.g. 20 cycles?, then I see no reason to
>>>> keep the dynamically toggling.
>>>>
>>>> And if we ditch the dynamic toggling, then this patch is unnecessary to fix the
>>>> LBRV issue.  It _is_ necessary to actually let the guest use the LBRs, but that's
>>>> a wildly different changelog and justification.
>>>
>>> The overhead might be less for legacy LBR. But upcoming hw also supports
>>> LBR Stack Virtualization[1]. LBR Stack has total 34 MSRs (two control and
>>> 16*2 stack). Also, Legacy and Stack LBR virtualization both are controlled
>>> through the same VMCB bit. So I think I still need to keep the dynamic
>>> toggling for LBR Stack virtualization.
>>
>> Please get performance number so that we can make an informed decision.  I don't
>> want to carry complexity because we _think_ the overhead would be too high.
> 
> LBR Virtualization overhead for guest entry + exit roundtrip is ~450 cycles* on
> a Genoa machine. Also, LBR MSRs (except MSR_AMD_DBG_EXTN_CFG) are of swap type

I meant LBR Stack MSRs.

