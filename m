Return-Path: <kvm+bounces-34393-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EC819FD2FA
	for <lists+kvm@lfdr.de>; Fri, 27 Dec 2024 11:25:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CAB0C1632B6
	for <lists+kvm@lfdr.de>; Fri, 27 Dec 2024 10:25:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C1F61DD874;
	Fri, 27 Dec 2024 10:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="M/gd5PTO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2069.outbound.protection.outlook.com [40.107.236.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4011482F5;
	Fri, 27 Dec 2024 10:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735295135; cv=fail; b=eV0ZUZG4Y2MR+Pu6nK7i9fepzqRnW9SsZUAgFZ/UOKrpv4GgAVZS1y9470YyeoayD/l0djODvRV8A8m9s8lI79SvK/xZBCrbwSBEhmjjnp07LMr3V3pYh3TruiBOUD6c4Lb4cKrhK4lhFWPJTrxbofc00SfbCqbmO7WW9KH9fso=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735295135; c=relaxed/simple;
	bh=FvkVtm5TRttbgRxwgVmnqPTEatf6khDfVtT1hOtvvVs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=I3NLey4tpvAC2mpiwJA9pAZ5noycfJHZYpg8BdwU0YPu0b+rHrYI39oQDOWVtd/SKN3tMYuYBoKVks6Xn8tU4HOPbhcg8PAgrQGBobk3MR+zlKzdpt6U5LVD+0YPn1hONhnLsdcu+xhyeB2LMYDdepLhF+VFnwJ4KPDaEzJtf1s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=M/gd5PTO; arc=fail smtp.client-ip=40.107.236.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cOk5hHtsB6nY6IwTjR7FFEw9RDYXRPzZwiG67z6X/cpuE1BqTnmlKpr/DK9UKbVvy9KsVdfNJg/pwp8jtpKOQp3rMI8WXjtRwKsfGF03WoD1rCk91wiGET2XtO4uN+Q0iemOWTwqx4573iDe2tbvKLyhQlh7soinJ4NKld5pdXZiEb8aAJmPViHR/VYgGLBYO7IllgH8OZK1qTuNnA1tKQ9v8XMsyeWElhFQe3NV+N1WqQaiEbeljtEz8A3py1kFhK3s54PwgOQ3w/TAfgetULexdk/JzgS2ppTJTPndF9Piw/B1HX7LpitFUnsFKQRGXCaYx0xoU+uTTA9jR3iZ9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hJUKTjmzmWDPHjTFUKF0bwORl+qHTgMjfMEVyoNfV6c=;
 b=F3EtklsoT/0yIy5zKhPMrQg468e4g2LKGdvPgnc34FaMAwLcmLBvfRVZlaulmcJ+p/lYTAjnuBMwUwsuyfx4U0CVWK7DY95I2WAR+a1Mez6x+j/gtgrKydgXWUxbDtiruftX2Kxa88dGBr622CYgtEmHSzerrua5lnLj3u18JNnCQgbRBxojvE9RZHdCZx+PJgIc8yACfl6x58QDnY2z0bYcbW9VEz2iRjXmwru9tVor8PdwfvNbE0+BLYBDeDMfNOOV0g6Q4Jl3HLuWNyI3a3qBhNtHyUt5FtA0AaHubtl9xTMRK5qGsqwnLLziJGtcrEJvsi+AH3pB2MDLgC/kxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hJUKTjmzmWDPHjTFUKF0bwORl+qHTgMjfMEVyoNfV6c=;
 b=M/gd5PTORtkX/hkArRa95kPQiD+oqduZogK9IK139LQDR65SMaKwrAGGn3H3DcmL3oNN/bew9/tMiiTd5uw9iqkscrh8ZdxscfksjT9ziBHMFXNIH8V45/eZ8hBNNfoI580ypok9lRWlT5aBaEe9TtYfRibgOy5c5Ia4paOCSYU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by SA1PR12MB7246.namprd12.prod.outlook.com (2603:10b6:806:2bc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.14; Fri, 27 Dec
 2024 10:25:27 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%4]) with mapi id 15.20.8293.000; Fri, 27 Dec 2024
 10:25:27 +0000
Message-ID: <2cbe9026-ce18-42c6-b8fd-750c55dde5a3@amd.com>
Date: Fri, 27 Dec 2024 21:25:12 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v2 7/9] crypto: ccp: Add new SEV/SNP platform
 initialization API
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 thomas.lendacky@amd.com, john.allen@amd.com, herbert@gondor.apana.org.au,
 davem@davemloft.net
Cc: michael.roth@amd.com, dionnaglaze@google.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-coco@lists.linux.dev
References: <cover.1734392473.git.ashish.kalra@amd.com>
 <a6e6bb0d16e70be61c1ecb2460c90803b937d42a.1734392473.git.ashish.kalra@amd.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <a6e6bb0d16e70be61c1ecb2460c90803b937d42a.1734392473.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TPYP295CA0002.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:9::11) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|SA1PR12MB7246:EE_
X-MS-Office365-Filtering-Correlation-Id: d2192f63-7574-41dd-7440-08dd2660c7d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WUEycEVUc2tNUyt3Wk5QZVBMcjA5SlV5dVhoWHJFdnVxSlpuV3g2N2E1SXVK?=
 =?utf-8?B?ZWlDMk9UQTBwMDNMQ09mZllmNmlxeFd2R2FSeFl1Wk1hTDNTcER3U0lkUUx0?=
 =?utf-8?B?MnB5N1BSa21YeXJDU09rRW9KUml4Z1daN2JTTExPbTJsNTRicGI4TklvVjY3?=
 =?utf-8?B?ZmhGZ2Ztdjg3YjV6cDU0MjZ5b2s5NHEvYkhYWXU1ZUhSK1VZRzBvUVR5UGFP?=
 =?utf-8?B?WUlPRWFHY25Fc2s0Q00xWnFZYTJzYXUzOXhsNFp5ak44eHcyM1NrYlhOaXJF?=
 =?utf-8?B?K0orMjV3MDBXbVBsQnJUclVXK0I4K2JsSGVIcUZhRFBBZ1V4djkzSHNwK2pO?=
 =?utf-8?B?Sk0yWCt6UGZpUnNxT1ZLQk5YYVovMUlZQlpWUVpKV3dPM2VRaTJ5bkdVWTBS?=
 =?utf-8?B?MmwwbDlybWtEWFczNDh2Q25wbGVWTVdTTDBTMVZScmdEV3o3OTZXb05meng2?=
 =?utf-8?B?ajhtVjhjY242M3o2ZzNhWnU5NGdkejBRKzFJbWxVOGlmekJXalFwR01PYlFz?=
 =?utf-8?B?MW5qWU5FSDROV3R6UDlZM2pvcVhqRFVHVWhITU44TldnZkhJandCc2MvVWtl?=
 =?utf-8?B?M2pUUEZiZjhrMWc0SHl2anVUUDRLQkhKT2dWYU80cGN5MDdLakd2bURJVytW?=
 =?utf-8?B?SFpubEc5azkzV0V4OU5QemlCNVlQOERLc1N6azV4eXlhMFhnSlJJNjF5Znk3?=
 =?utf-8?B?bkRwaFNRSUpQSzlZNVlwc2pDWW8yUUVXSXA5TGlNTXAwc0hXV0NoYzMxeXJC?=
 =?utf-8?B?cGF1YWRPclRFOXZRNTdacVFQYkxvYlhmQ1BOOHJYK2x3d2RBVlVZaTJlL29M?=
 =?utf-8?B?VWxHSkJMZHlRekt4ZjJZNjdaMC9rVjVaRWhTVkkzWlk1UnZZUEFZMXE1cUFH?=
 =?utf-8?B?eEJaODM0aTF2ODB6UElqRlBweGtwUXBMVlFlRGc0OFlCajgvN2wvN01GR1ZS?=
 =?utf-8?B?WkNwUGJSTVRyV0Y4TS9zbUVoYTVIQjg3d1JPN3hLS2F2a2FEK3FlSURZK3NT?=
 =?utf-8?B?WlFodEpGY1JqV0lKVnhOdTRITEJQaUM2NGFTR1IwZllVeFh2MUZUd2xYclJ2?=
 =?utf-8?B?SUpXMlh3MUhvRmNmQ1dhV1VWbjBmYUlMdmxFTE83ZVBITEFCSFVYajJDM1JM?=
 =?utf-8?B?VmQ4OXRvUjhGUU9QcUdxL1c2SjY5YWhCSkgvTnZ3UlZ5ZklCNXRKcllwekZ6?=
 =?utf-8?B?WlZLRGJqajZ6bnFpZW9Takd2ZUZJMVBuNGhzYjhIQ0pXeXBtU1NnczhDT0JZ?=
 =?utf-8?B?RS9EdEtXQkowcTdMM2U4RUZFL3lBOGFGWmRnbE0rbFl2dnBkTUx0cHVNckJt?=
 =?utf-8?B?MFl4NUNQZHFpd3BIU3Y1MGoyWG9jRjdTQUlEMkczL2dlR2tvTG1zYzdxWVRt?=
 =?utf-8?B?c3J3dzFzVThDWHJNVXQzMUk2QUZNZnMzclNmaEJJTDBiUkQwdUpSWFlhbnMv?=
 =?utf-8?B?TWtDcWxTMk5aYTdFdmp4YzVHMEcvYzZOSVFXbVYvbFN5Yk9GaGlTS0NjTlI4?=
 =?utf-8?B?U0dRM1VhR1FYYkZPNFRqemQ0V1Q5UVhqbGg3d3hHcy84RW53bXdZVDRXeUpn?=
 =?utf-8?B?Skh4NzFwelp3T2kzV3JUSGR3OXIwN0pBaTVTRU5NYWp0Tll5L1kwaklIU3po?=
 =?utf-8?B?NFVHUjVrOGtESDlSK0grR0tyUmg4cVFLckNDb2N0NzZWc04zdEhsYVdQOWZi?=
 =?utf-8?B?ZWFET3VJREEzaXhsSWRLL2d5U2dRS2JGTXJUanRlV3prSlVLUHZaekZnTlhw?=
 =?utf-8?B?NW5WRkJNUTc1VkplUVorUmtKbXR1THRoNi9Mc2pHb2sxMXdtdUFxOFZhZytY?=
 =?utf-8?B?dXVNQlVFZWRnSEVoMUJpVzUrNURCZmZ2MFF0TEkwVEVCVUkrY3R2SkRvVDUw?=
 =?utf-8?B?ekVPSDRjVXUvcVRkMC8rbUlHTjE4MGx3Z1piWmZud0kvNFlQVFZ4eUZwd2Ir?=
 =?utf-8?Q?AvRBttZdz5Y=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y25NSkRBTi95VWErL1lBWVdOYzBmNlYxV29tM2x3T0tkWHRvREFqb1o0bk4y?=
 =?utf-8?B?amM2UFk1OEdob01YeEtMRUFZaHdURDA1TVVRVE1tbjk1cmN0UU1JMUdJbHgz?=
 =?utf-8?B?Q0V2UUF6eEdraW9xQ0V4Q0luSkJJMHpERzlDSFV0dmxDMlRnOHozemw5UVNs?=
 =?utf-8?B?NjJwblc0SWdkK2MwOVZZWWdOS0RUSGhYMXVjblEyRVpnS0tUNzRVWlJjQXdE?=
 =?utf-8?B?b3Rkckp2UGJQU1QyWDZMbFpSazVDS253Z0dWbFE4SHFHYTd1bEtYRUxGbVYx?=
 =?utf-8?B?NjRkVTVyZG85WVo0OEFpQ2tQWnIxaEo2UHJ6NEdCMnlnYXd5ZHlLUmpPNHhn?=
 =?utf-8?B?d25nYlFOSkc3amJJa20zazN4U20rbTVyREpHZlNKR3c3REpIbHJuM2VKTG9J?=
 =?utf-8?B?aDRGakZnd1JqYUVuaDMrTzRCSFVWMFVpQ01hQTdjMGJuMTRIbnRBdVlhQlN3?=
 =?utf-8?B?dnhud1RvVHVkbjJoeGU3cStvb1ZEQW9PT1daWGRhV3drQS84bUFLRWU1QWVO?=
 =?utf-8?B?Z253VGJDaVR0bWplYTlKZ2ZDSUZ3R2dlVXJjQURVOG5GMWtlWWVjWWp2U3Bw?=
 =?utf-8?B?eDJzd2x3T051Mm1FZzBHTDNYMVVlMEt0Uk1yWkhBQTdyTnRLSFBJaUJHM04x?=
 =?utf-8?B?aHNjaVNsZzA2N0dMdndiUldwdnVGUnU3cVBNSDkyd1M3NXdSY2VGZmNoeWFB?=
 =?utf-8?B?SkFlVElLdW9hMFFySlFWWEJXVEZGUGZxeFJiWE9uQjdCNGhTeDBJdHRVTDRx?=
 =?utf-8?B?NDBsdlMyTFpTb3QrYi9qR1hPV1V5RE03VVVERVkydWVSckovSTdvTGI2Qytn?=
 =?utf-8?B?V3F2RzJPUVNHQmJiOCttbGNwQit4VmdIRkdIS2o1L2pMY0lweWNEMW55Z2lv?=
 =?utf-8?B?UWxOTnJlaDlSckxxT2U4Rm1NdytONk5pQlZnUEdEV3NMOXNTeGNCa0xlMTlQ?=
 =?utf-8?B?ZFlINUpHdUdaUzY3T3BnUExhYXk3YjVLSllabkVUbzRTcW84dFRSeE81bkNS?=
 =?utf-8?B?MU5rTTJ3MUJHZm9PMDdTQmh4ZnM0WlFPdCtaTXNETTU0K1ozbktvL1JMY1NN?=
 =?utf-8?B?SEpuTXZ1YjF6emRzaElMcVU0cktRdnNISStMc2dIU1prb25Zc2hQYUhGTldG?=
 =?utf-8?B?VHFPTG9mam5zTVcvem1MT0pqR0RwM3VUZzJDcDJPZ05UTU1BdXpBYnU0VWxh?=
 =?utf-8?B?L3lxWkxvdWxvYnkxSUZNbGJMdy9FaGVjODRhaXRFdjlCNmdIUkp2MU9QQ3Qx?=
 =?utf-8?B?OHJKSzljSDFHREVWN2tUaGZmNGQ2b29wc0FCNWJ4UzVqVW9UbmlCbWhwMmZs?=
 =?utf-8?B?eGF0Ky8wK2dqRklNZnNISmg4THlYUE5Ba0k4Tkt6a1ZwNUEvWEV6ckZoK28r?=
 =?utf-8?B?REVXMVpRMm5OUktSUlRodktYY3VVVTBLTEpwT2ZBcmJUazg5NGM3V2F4RFI1?=
 =?utf-8?B?b242WXhPRENxZTJGNjZZdmdaRlk5TmJJTVNsMWZQeDJ0c0RsOHRJV05TMmF6?=
 =?utf-8?B?U00rWDd5c0RNK3FRMVY4R1J6TVh2WUpjQmlOVHZaTmJEYm84NjFTaEYwSXBj?=
 =?utf-8?B?OGdlc2puM09iZVJUSjlySFBEOGxrMjR5T29OazBFRGNaZWNSdmx5d1hGVEQ1?=
 =?utf-8?B?NVdTTnVnUitIR1JwdTlTZW1TVUFGVVZNWWpqdVo3cFR6UktwK0lSbTRDWi9i?=
 =?utf-8?B?YWlBVTdDNmpCU3c2bzZtYm1EWjNqL3g3RGhCUzRaWVN1cVNuSWl3M3VNU1Iy?=
 =?utf-8?B?Tmg3Q0l2K1JrN2NaNnJYQ0xVa1IxZC9LWEdhT1BDaFppRVZ4QkFYbDJVVTVK?=
 =?utf-8?B?ZjJheTB6KzlqOSs1YnpZR1g0cU81Y3h3cjhzUk5sV3BBY0lPUGJ3MWpqMFpv?=
 =?utf-8?B?SHFVdFFaUmN4eFczQ1pTZzk2Z0o4ZGp0UmdKd2IvYzJNaytmWit6NXMyQmwz?=
 =?utf-8?B?ODVRMXp3a2xoTVNPUm9jdXFwcFVXR05pS0NNMmlqc1dCZ3NrL3dXQlViWmJE?=
 =?utf-8?B?UDIwMnB4NTBURGJrdGFNbWJmeURxTFE0MWNkUndMQk1hL2Vlem8rNDU0cXdm?=
 =?utf-8?B?OEJMQ1JCdldPMEs3TE5HTDd1TnZ3T0NJWW9GQnNGTzEzNGhMWmhNdjl4YUNr?=
 =?utf-8?Q?DrSNQuWuRmIS1PbBguTqmYIzc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2192f63-7574-41dd-7440-08dd2660c7d1
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2024 10:25:27.1094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 22jQSALR/Q9SdGxbbOsqRMIj78L2m7WqRg73JvA/Ndf6F4U7QFU0w4uFKnZvNGJLI8LwOYQUxRrvGwc1dBY2Rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7246

On 17/12/24 10:59, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Add new SNP platform initialization API to allow separate SEV and SNP
> initialization.
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>   drivers/crypto/ccp/sev-dev.c | 15 +++++++++++++++
>   include/linux/psp-sev.h      | 17 +++++++++++++++++
>   2 files changed, 32 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 001e7a401a6d..53c438b2b712 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1375,6 +1375,21 @@ int sev_platform_init(struct sev_platform_init_args *args)
>   }
>   EXPORT_SYMBOL_GPL(sev_platform_init);
>   
> +int sev_snp_platform_init(struct sev_platform_init_args *args)
> +{
> +	int rc;
> +
> +	if (!psp_master || !psp_master->sev_data)
> +		return -ENODEV;
> +
> +	mutex_lock(&sev_cmd_mutex);


I'm told that in 2024 we should use guard(mutex)(&sev_cmd_mutex) and 
drop explicit mutex_unlock(). I'm not a huge fan but there is a point :)


> +	rc = __sev_snp_init_locked(&args->error);
> +	mutex_unlock(&sev_cmd_mutex);
> +
> +	return rc;
> +}
> +EXPORT_SYMBOL_GPL(sev_snp_platform_init);
> +
>   static int __sev_platform_shutdown_locked(int *error)
>   {
>   	struct psp_device *psp = psp_master;
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 335b29b31457..e50643aef8a9 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -828,6 +828,21 @@ struct sev_data_snp_commit {
>    */
>   int sev_platform_init(struct sev_platform_init_args *args);
>   
> +/**
> + * sev_snp_platform_init - perform SNP INIT command
> + *
> + * @args: struct sev_platform_init_args to pass in arguments
> + *
> + * Returns:
> + * 0 if the SEV successfully processed the command
> + * -%ENODEV    if the SNP support is not enabled
> + * -%ENOMEM    if the SNP range list allocation failed
> + * -%E2BIG     if the HV_Fixed list is too big
> + * -%ETIMEDOUT if the SEV command timed out
> + * -%EIO       if the SEV returned a non-zero return code

The only caller ignores these, may be drop the returning value and print 
the errors inside sev_snp_platform_init() (if whatever 
__sev_snp_init_locked() already prints is not enough)?

Also, looks like 5/9 6/9 7/9 can be squashed into one patch, they touch 
the same files, equally do nothing until later patches, pretty straight 
forward. Thanks,


> + */
> +int sev_snp_platform_init(struct sev_platform_init_args *args);
> +
>   /**
>    * sev_platform_status - perform SEV PLATFORM_STATUS command
>    *
> @@ -955,6 +970,8 @@ sev_platform_status(struct sev_user_data_status *status, int *error) { return -E
>   
>   static inline int sev_platform_init(struct sev_platform_init_args *args) { return -ENODEV; }
>   
> +static inline int sev_snp_platform_init(struct sev_platform_init_args *args) { return -ENODEV; }
> +
>   static inline int
>   sev_guest_deactivate(struct sev_data_deactivate *data, int *error) { return -ENODEV; }
>   

-- 
Alexey


