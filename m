Return-Path: <kvm+bounces-37655-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 22B1EA2D3E3
	for <lists+kvm@lfdr.de>; Sat,  8 Feb 2025 05:53:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1F62F188E520
	for <lists+kvm@lfdr.de>; Sat,  8 Feb 2025 04:53:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29A0419AD8D;
	Sat,  8 Feb 2025 04:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ieVHFamt"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2069.outbound.protection.outlook.com [40.107.236.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 798B517B425;
	Sat,  8 Feb 2025 04:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738990380; cv=fail; b=bfmFYWjIbR4qoZ6FER7SFoesbF3g2zyrQOJtXwyvVGPRKaSisNyQDfO+t0Z8SYkbuBlpFKm2X1wxkzkqgiRt2qN3BtHyHsNTbcvGNKIBzWG7zBGF4D/5AO8ObrD5n5JLeyEGM9mqX54s1oOMD9195H26G2uloxyjs/NP7VT4nNs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738990380; c=relaxed/simple;
	bh=p6Hp1Mn4xW9X8TtV2uYFMvs+PNig+kai8rzLYpv8mYk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=X18rG5ZnbZ4Jurx781zXIf+tO+cL7pV0kGV4e99vf/QIivi8WMkoLKJLE9piV4Lh5VLtL1Dd/kq0aOopqiUZYsfux7rFn4kMl9E5ogPWOiJc8b0+baGTrS+h+ddvoZuH0UB96AEmuANlNwFIU21OAjpU2/hZEZ1dL+cb27+huLw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ieVHFamt; arc=fail smtp.client-ip=40.107.236.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oaoEcPd2sRo+Vyy5c8YZRfTlI6qtJjVvFunWcBPUF7wkAy84bYxZLje3LxCF844CU+IBp420+Wtu3DYtcrUMhFKblniDm/D0kgjvv7YIDiUjOLZaOAEvtSX/P1tojBWC3MDvNKgMsW2IkMWKqRzlcLpxsTW9ywwFx04bjvxTPOB5pSzIpmKOUSoUnB3ldDrkqQ7TqrPEmuo6aQME29uxoTxAXE9OsRtEfiNNH1qAZcLlHpIotpovY192bB0xpDVcpo3VYC2gdMfRnB3I6yBDGF97+NsMwQqBRGlrqT8Whc3LLLcSqmrBw6Mi/34kqLOsp1XXuof3tWWSsWgwuQ6fcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bK0eH143pXYV0phDM0y3vn7Hge1QJQn/oKeByWzDVoU=;
 b=Tc9pvUm1y4Xp0HrjWMAveSEHycw2reUhbTzPL3TRbUXzNdb1C5krX9Lo/FWmHI5g8Nlxu7JX32KNd2tZF3mq5VfJfFiewt/7Q0bf/9OuFHOulSAlWZn0oI3oZkLYJoZYZhJKSK9e20979gFwN7CdO7fOmsMoswC/GoAGDPKtGogwnZa4EZ2SpHzh1t5f9DbsNI4hRoRzV0GmQPE1iQxPGIaNFpeb2EujgVUet+gDUjECOI05Mbzs8/S9cAUMBGUtDVRJk/bCYk/P4Bg151eNNUHl95AtryESTp90vKj+q2DhuYU4zVVAL9H3ueYk5cEIez3ZrUhinWW8DqAemrIZyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bK0eH143pXYV0phDM0y3vn7Hge1QJQn/oKeByWzDVoU=;
 b=ieVHFamt0jus+m67ZRgSo0SWK9XwTh9dFDh4o78pJkmz9q41eR1cJu2u9cv6JUwsr8+6sk6SU1Rd4e5qCvDwXzIQnLsTrdJjuQm9HoG0cvvF4p5IsxeRkGNvGoWKp6Qgm26JCFfiWw4sw9DQFijLWoBV5Gx/KwvoQxPAqEm42/Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by MN2PR12MB4373.namprd12.prod.outlook.com (2603:10b6:208:261::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.12; Sat, 8 Feb
 2025 04:52:55 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%3]) with mapi id 15.20.8422.009; Sat, 8 Feb 2025
 04:52:55 +0000
Message-ID: <30d6b5d6-d397-490a-afcf-0cae9d6d303c@amd.com>
Date: Fri, 7 Feb 2025 22:52:50 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] crypto: ccp: Add external API interface for PSP
 module initialization
To: Tom Lendacky <thomas.lendacky@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 joro@8bytes.org, suravee.suthikulpanit@amd.com, will@kernel.org,
 robin.murphy@arm.com
Cc: michael.roth@amd.com, dionnaglaze@google.com, nikunj@amd.com,
 ardb@kernel.org, kevinloughlin@google.com, Neeraj.Upadhyay@amd.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev,
 iommu@lists.linux.dev
References: <cover.1738618801.git.ashish.kalra@amd.com>
 <02f6935e6156df959d0542899c5e1a12d65d2b61.1738618801.git.ashish.kalra@amd.com>
 <2794745e-c33a-68dc-f0e7-961e1631299e@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <2794745e-c33a-68dc-f0e7-961e1631299e@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR04CA0001.namprd04.prod.outlook.com
 (2603:10b6:806:2ce::8) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|MN2PR12MB4373:EE_
X-MS-Office365-Filtering-Correlation-Id: c1579123-6dd0-4544-f2fb-08dd47fc7359
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cTAwdFgvMzBiZjRjanRpaW5QNVBHM1pQTTU5MUlTZjlSVURpR3ZjbmFub3pr?=
 =?utf-8?B?MXBGTzRFVStkU3RhQmx4YlhueEJKVjRFSGZQMjRkZlRLWkk4aldxSTM0Q1hF?=
 =?utf-8?B?dHcxQkluREFsdWs3WjVmakFpVmNJVzV2L3FwakU5N2ovNlJBRHl0ZkxhRlNa?=
 =?utf-8?B?elpoNmNUK2VyRE00aGNRUHVjRnA1REVmUWpUQWFDdEtVVWpYWStrSFl0NGt1?=
 =?utf-8?B?QWxQYk9Camg2UThielRYTUhlaHRmOXBCT2swek1YUXVuOXliWStIZVZtOTh5?=
 =?utf-8?B?QjVWS2NUQlVxVmMwRHZQTm5IKzQ5cE1YRkVOWFFDdmxwOGU4VEhNa0s5MTB5?=
 =?utf-8?B?M0hvdFdERTc3SXJRSVJZWExUSVorcHVMTGRDeXdPNTJtamZsN2U1bXVQM2Jh?=
 =?utf-8?B?Zmt0UmgzcHRmcGZZTGdZSnZUWDhSVExyb1ZWN0pkNUsxcFNIQnpCbkN4Rncr?=
 =?utf-8?B?dHNsRURTMFBEaGxEcU56eVc2b0NjQkR4eUJQSDRnZnRXOGNhcVUwSm43K0I4?=
 =?utf-8?B?MFMwREd4Mm01M1F1ZmZCUXpBdVNYSXlKU1BLWlhaaGxBMDVBSUthQnZ6UUVo?=
 =?utf-8?B?V2JVbUw3Rjl3L0JxRmlRU1pyNDdIaU1MK0JqbmxJWm5DSGYrbzQ0QzdCZ0NJ?=
 =?utf-8?B?T3BaZnZNRzhkbEJwaFN0TFhOK3RtRy9KQUZZK3ZPZFhXZWJmZVFhdkV6ZzZY?=
 =?utf-8?B?bFUxTWt6bUtYcG8yVGZULzRlSlZiMlBITGRySlF0SEJVTzdJL21jWlg5REdB?=
 =?utf-8?B?R1hsd1NoVGJxSXloL3pFV05aclVpRlc5VG1TSFZYNVJJSTI0NWh6YXdUcVFV?=
 =?utf-8?B?V0gyb3NFOXVGLzc1VmczaTdjU0hyUUhzQ2YwcmJhUXNUZ0RhRUlkNkptUURJ?=
 =?utf-8?B?ODQ5WFRHN0VJSmxsYWxYeFc2cGJHeEtXWDkwVWk5Rk50YTZKQUV3NUZuSU5W?=
 =?utf-8?B?REJoR2p4MjlsRnlxTTlIcVV1UEpiL2ZNRlZYcnFiWnp0M1kzalBHV1RoMEFy?=
 =?utf-8?B?VE12K1J5OUpjaEFOYURPTVpYYmpFaURqdkIrRXI3d3JEQnZhY0J6WHJtM2Jh?=
 =?utf-8?B?ZEJRSTFYYXhxQjg1WXZuUS93R3UweWdVS0FCeU9ROWkwM3RjdVJPMmgxV3RB?=
 =?utf-8?B?VFB3U2Z5NjNoVEgxVGc4Smp6Ukg5ZjF0ZHZaQVdYbmwvQnNGenBHSEI5aE9s?=
 =?utf-8?B?aVZSaDlnTzVCbHJLWHRva1F3bWNyelpaeVB5dmpNaHFCK3FoZnp2M2F0Y2l0?=
 =?utf-8?B?cWhQL2NhbW94R3JvblpZbXVBb2dPYUhZN3k1ak1sb3ZlWmZ2TFJGd1FKQUsv?=
 =?utf-8?B?VDZGVllnY0dQSEF6SFZPbngxWUVCNUhtS0N3eGVMMFYxUE1zOUtuR2tKbFMw?=
 =?utf-8?B?NEdYQ25JUmJvcTNRTk85TmJla0d2Y1ZlcXgxVDJzZ1lyWFJTcnVEQU4vWGVV?=
 =?utf-8?B?OExYb2ZYdEZOZ2FibG0yN3JlaUZhTitwalIrWmdxcWFnVzh6Y1A4QTE2eUxs?=
 =?utf-8?B?WmZqT3JyWkdGVUx2cGZaclFhWjlnelljcUhpM3g2c0lUcnMrTUdpdmpOaUpO?=
 =?utf-8?B?UlMxUXI2dGdSZEpvWGpkb29nTHdsajRaajdCWVkyc2lEallBR29ZbktGSjRl?=
 =?utf-8?B?MDhqTWU1eEEycEp4eUhoR0FJUHBJamxaWjZ2V3VhZ2hJSU96V3NlZnFCWFpR?=
 =?utf-8?B?SkF3RUJ1K3ZIK0txaHdKUjFZbVJCZHlvcXU0eVFDOERZaGYrQVIyQWMrUnBp?=
 =?utf-8?B?aGZENkt0SUhYK25kZ05rQVRmRG5Yb25JQkRqU1Q5VnZVVEt4dG0zVndmRThV?=
 =?utf-8?B?VWZHMCtCeW9WQ0cwMm1QSGtVK1ZLTkl1VmZxK3NzTmhQT0dnbnhvR2l1TVdG?=
 =?utf-8?B?dXdzME5abWFhTXpDeHBwL0Zma25uL2JsM3FYMVRyYUdBMS82VmFVc2ZtUURI?=
 =?utf-8?Q?DLQ1FOecwuo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(921020)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VnJ3T0ZBaThjRE1Vcm0zZEc4TzN2Ty9zaG5oTkJyeVNZOEN1NDlzdXIwK1Uy?=
 =?utf-8?B?UnJubzM4YjA3U3oyYk4yMm4xNk0rZXNuVXJuKzFNYU9kcnRsZG1GQ0wwY0dP?=
 =?utf-8?B?dXpGTTVNMHlLUnJydXNCTzlPMklIQkxlVkpxODFFSUdkQlFSMGZaampaOTVZ?=
 =?utf-8?B?Y24wK0JJRy9NQU1rRHRlRk5reHgvaGV2Tk1hREtrNDY5VHc1b1F2VW9tMWgy?=
 =?utf-8?B?UGp6VTFCcW1FbUNLRTZ2MU4zdjF5Zzl2QTJDZFU3emx3dFA5M3FtRS9lb2Js?=
 =?utf-8?B?NG42UVBaL1VxdWZUQTZPVDNvclk2QzJvQmV6THZDdEhFMDhrT1J4K09qTEpE?=
 =?utf-8?B?ekpBSVgyV2lqb09PYlZSeHpMUzdiSkU2RTFqL3BJZXVOMVMyU1pXeDRzRDdZ?=
 =?utf-8?B?ZkxoT3YyWG5aMFFLaU1FRGZhUEF4aWMxN3ZWaXY1TEJmUi9QWm9idy9HbjY1?=
 =?utf-8?B?cVZKeCtVY2d2TlllNUlvVjlBanFaTnVVTDRZTStmcXdqTHVMYy9sN0ZxVFVk?=
 =?utf-8?B?SVY3YnptZitrN0xGcmNvcnZRNFlJcGhsbVFsUUtia3o2OS95bzJnYm5zQ3cv?=
 =?utf-8?B?MGlIYkRMZDJLTU54SkhBY1dSWjI4RjBFdmZaaSswazZ5VFZuV2hBWE5CZTFZ?=
 =?utf-8?B?cUMyamVHQUlYbm03U05lS2pMRzlhRThFNXVRN29FcDN2azZ2akRVblVEWDFp?=
 =?utf-8?B?OFgzOFpJVTYxUm1BaEwreWpGbG1hMllFU0JpdzhuUjltVXZXSkFCS1dHSDhW?=
 =?utf-8?B?SktZNDJ4VXRndVZwbXNJOTJuN0lsOUtHQ2xNRjJUbU9vVzlWU2lqWkMyNllp?=
 =?utf-8?B?MFl0TGs0S2p6WVVzeC8vbE9rYWM0UWNETCtPQTdCcVkzZkJYbW14ZDBaS1I3?=
 =?utf-8?B?N3l5L3pPRkRRMWphL0EzejNoL1BFcFNMUm9IM0pjQnpuN1JOaGFibExZaDVC?=
 =?utf-8?B?M0o5eTlrdCtLazdHY1Vha0hONHB3YXBGVmE0K3BiZWdmSmNZcm55RnEyU1FH?=
 =?utf-8?B?dlVWK3pmcGdwa2ptcSt6ckxETm1Xdks5T1FsZUduTUdoeU9Na0xnREREMGVE?=
 =?utf-8?B?RDJpL3FzbjhObDNFNmVXRlo5RDVGNWNYenpxV1I5ZFhnZ3FlOWpRTEY5Ty9z?=
 =?utf-8?B?eUk5dGtmRmdFQUdSK25HRkczNS9hNE1pbldFSEQ2NWV3eUNOalFmVTBvSHUw?=
 =?utf-8?B?Q2pFVzJMUGxMdzA3S3NCVE1jL3FXeXBud2p5VlA2MWJnek56OEZoTC9OU1NE?=
 =?utf-8?B?cllWOTVjeFdrbCtNKy85VW53RjV3MmZjbnJRTWsrQXdEKytibnd4TGJHd2Iv?=
 =?utf-8?B?QXc3NGxUK2RjWnNyR0tabGNPOUZGMkJ6TGVZZ0xMK1RETkxHeWhLeXd6NlVG?=
 =?utf-8?B?WC8yTjMwZU5NdDUxRjBMKzkzWlZwOC9LclVFaFN5YW1SazhBQVNpb1Y3Tlcz?=
 =?utf-8?B?WGxqRHpuWDZVR1pmQ3J6LytlODJzRVhlMXB0ZVlpYUxYcHRZakVKU2V2NnJQ?=
 =?utf-8?B?UGRjbklLdVkvcmsrTVhuaWZ6L0EyMGhqakdVenZuY2hheTZUeWQ3cWF3YXoz?=
 =?utf-8?B?TEd1NytrZGJMSGpvOWUxVlBDcGtqZVRDK3RoeG96TmQ1WCtqSTB3cjd3eFQ4?=
 =?utf-8?B?Vmc2cEo1Y0h5WTAveUxTNEFlSm1STExpN25YdzJlT3pyUXEwMGlSMjdRQjVY?=
 =?utf-8?B?T0V5WUZ1NGRoY2tMNHpQcm93N1JNVTR4ak5WL3FiTkJsN1NkV01sNWlSZGtO?=
 =?utf-8?B?d2pnd1ZPeWtYSVYzc3JPcEtlaVg4Q3c1VFJVd1FKbUZFU0NqMnBWMW5Wb1di?=
 =?utf-8?B?YXNRS0NVRjd5bWRMQmNFaE05S2FoamRtRXcrYWZUMWRDdjRyc0VURkppT0xv?=
 =?utf-8?B?NEtpSVhISWlmeGM4RWlUMktVMndBcWtHNlN3SU5CTmVwOU1zcGxYQVVHUnli?=
 =?utf-8?B?RnFPR0NzM2V5MW1HTld6Z2lKQXhwWXdqWno2ditxNFhEUEVWR0dvbStpTHFX?=
 =?utf-8?B?ZDl4SnBWaytHYTR6M3IwcktEMjRDMmZxYjJLelc2Mk9FQ1JyUllKQ3hhQUhO?=
 =?utf-8?B?a2Y1a0pESDd0WEl0cmNWWTE2cDQ2ODJsaTN2VWVUVVhjUWZlR3FNazJod0cz?=
 =?utf-8?Q?iJMkFAYGjyLPJi+oPolnA8Km0?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1579123-6dd0-4544-f2fb-08dd47fc7359
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2025 04:52:55.1706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BbVTQ3TXGJzgGETT4zYW7VTwUBUH1IwWcfrAmioz2JyILueiCYzoj61sU18/RTnBiGk0nrqWdnacKcWKZM3ipg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4373

Hello Tom,

On 2/7/2025 3:45 PM, Tom Lendacky wrote:
> On 2/3/25 15:56, Ashish Kalra wrote:
>> From: Sean Christopherson <seanjc@google.com>
>>
>> KVM is dependent on the PSP SEV driver and PSP SEV driver needs to be
>> loaded before KVM module. In case of module loading any dependent
>> modules are automatically loaded but in case of built-in modules there
>> is no inherent mechanism available to specify dependencies between
>> modules and ensure that any dependent modules are loaded implicitly.
>>
>> Add a new external API interface for PSP module initialization which
>> allows PSP SEV driver to be loaded explicitly if KVM is built-in.
>>
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> ---
>>  drivers/crypto/ccp/sp-dev.c | 14 ++++++++++++++
>>  include/linux/psp-sev.h     |  9 +++++++++
>>  2 files changed, 23 insertions(+)
>>
>> diff --git a/drivers/crypto/ccp/sp-dev.c b/drivers/crypto/ccp/sp-dev.c
>> index 7eb3e4668286..3467f6db4f50 100644
>> --- a/drivers/crypto/ccp/sp-dev.c
>> +++ b/drivers/crypto/ccp/sp-dev.c
>> @@ -19,6 +19,7 @@
>>  #include <linux/types.h>
>>  #include <linux/ccp.h>
>>  
>> +#include "sev-dev.h"
>>  #include "ccp-dev.h"
>>  #include "sp-dev.h"
>>  
>> @@ -253,8 +254,12 @@ struct sp_device *sp_get_psp_master_device(void)
>>  static int __init sp_mod_init(void)
>>  {
>>  #ifdef CONFIG_X86
>> +	static bool initialized;
>>  	int ret;
>>  
>> +	if (initialized)
>> +		return 0;
> 
> Do we need any kind of mutex protection here? Is the init process
> parallelized? We only have one caller today, so probably not a big deal.
> 

Yes the booting will be parallelized, but the main reason we needed to 
explicitly initialize the PSP driver from KVM module load time was that
for the built-in modules case, KVM module was being loaded before the PSP
driver, as per the order of compilation of modules.

So as kvm_amd module will be loading before CCP driver, therefore,
i don't believe kvm module load -> sev_module_init() -> sp_mod_init() can execute
concurrently with CCP module probe -> sp_mod_init(). 

Therefore i believe, the above code in sp_mod_init() should be safe. 

And sev_module_init() is only called in case kvm_amd module is built-in.

Thanks,
Ashish

> If we don't need that:
> 
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> 
> Thanks,
> Tom
> 
>> +
>>  	ret = sp_pci_init();
>>  	if (ret)
>>  		return ret;
>> @@ -263,6 +268,8 @@ static int __init sp_mod_init(void)
>>  	psp_pci_init();
>>  #endif
>>  
>> +	initialized = true;
>> +
>>  	return 0;
>>  #endif
>>  
>> @@ -279,6 +286,13 @@ static int __init sp_mod_init(void)
>>  	return -ENODEV;
>>  }
>>  
>> +#if IS_BUILTIN(CONFIG_KVM_AMD) && IS_ENABLED(CONFIG_KVM_AMD_SEV)
>> +int __init sev_module_init(void)
>> +{
>> +	return sp_mod_init();
>> +}
>> +#endif
>> +
>>  static void __exit sp_mod_exit(void)
>>  {
>>  #ifdef CONFIG_X86
>> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
>> index 903ddfea8585..f3cad182d4ef 100644
>> --- a/include/linux/psp-sev.h
>> +++ b/include/linux/psp-sev.h
>> @@ -814,6 +814,15 @@ struct sev_data_snp_commit {
>>  
>>  #ifdef CONFIG_CRYPTO_DEV_SP_PSP
>>  
>> +/**
>> + * sev_module_init - perform PSP SEV module initialization
>> + *
>> + * Returns:
>> + * 0 if the PSP module is successfully initialized
>> + * negative value if the PSP module initialization fails
>> + */
>> +int sev_module_init(void);
>> +
>>  /**
>>   * sev_platform_init - perform SEV INIT command
>>   *


