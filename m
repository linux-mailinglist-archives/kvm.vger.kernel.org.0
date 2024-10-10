Return-Path: <kvm+bounces-28364-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 178CF997D35
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 08:29:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 37D9B1C22B61
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 06:29:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A04201A3031;
	Thu, 10 Oct 2024 06:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="a/Hp2Lrd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2050.outbound.protection.outlook.com [40.107.243.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3708F1A2540;
	Thu, 10 Oct 2024 06:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728541733; cv=fail; b=BlniQ+Tp/9v8rUzwDvq89FrKd9SolUINkmNMZ1JVx3tMN0/1m/PWAjPQa4VhAfOPuzu9Ni04I6Dcl8T2dyrEZ28p7urOycg5UPZAWo4tSg2QrXx7ZW8DQY6NEpGmDO2ReP0deT/uUREww5FIElMjgIOWSNNt2+29FBxfXYyoVVU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728541733; c=relaxed/simple;
	bh=BAvpIKpdtM91Qk62oLrCe02fPjDvric6dIGQH79zbU0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OI1nNxgu8j87Q8BOw21bq+Jk8YqBNjlWaT2MyOZ3fmJLc2/ddcQ/uEWo/Bzj8G/aHVjdewYu4G5foIAqcGOgGyvvCB1anS+EEYUGfAK/H0sz8dWqZ1xg6yvJkkK8vXKMaQYN0OGp6U2KmDCLahv+CR5EOhmhhALqNcTRewd9ooo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=a/Hp2Lrd; arc=fail smtp.client-ip=40.107.243.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gRxm9wLPVjLhJ0PDny/zOCY3ycmy5aDKDtuWYpbaM66Ht+xuYWZpK1byqlYkYGPDRHQi68Tvn1Z/M3jGtyQQzx/nsto6b2ouzbU1sKEgWa34irhNeQaE0mpt5ERiTRA7gsBZFHYwR+nXsw4HjiTMhfcc9xldq/2a4SMLQxtgfCPXJ9u2oaqZSjeY/OMiRYFk822V5RDk8Rti/c9MG1qtql5F9vAC0OkMgkjHbjZTP1xl4R1gGhemyjry938JgRAmNaBFtYrn8QIl8OBAW+f2PEKxpeFEXHfIE4LKWmTdODcpNAy+T3F6XNtD//ayb4OfTUvir/RAffl1+mvab3Ckmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NYg9uxWfGPLLGx3EWchcjJlcZ2C1TxfyIEMvFX9J5zM=;
 b=xPQtqfXc579HyOcxTVm9nF8pjPRxnnuI5lQ3sFR3lyiJXvTnWANOs5YN5qonGbLYIZawKKp06VhOsIi3VwZWWOK1Djcuac+KfUA0Nt8fgjeyTkNJX0eUfSlkwF564QdA9DTpOFRfR0B2gv/sYLVF2JDDvSGS8tVPIpzYeM/HMShxLabORKa3kmwo+AUrwAAp2LoSaH+tV762RaT6HaqVHajpflrCq+/gPZUJvxmTSCQ+2NsoHSxnn8q6LmbCkYjKKDWNjJNy8+fztIgJtPJVALIZpfagQMnIKD/di7njRaQPKFFa0TZKaj0W6g0VVkhy1+6DAW23zuNEn62zhgEsDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NYg9uxWfGPLLGx3EWchcjJlcZ2C1TxfyIEMvFX9J5zM=;
 b=a/Hp2Lrd45WQUuLDlywteXqqggSRos/ltqyOG/pBE+5flQ/1Er/yYW0ncOxOKcZNcFyt/xv3p6Z0GQ1eUWmrLhmmwOpIjBXRrDaAU/fzlXgQ4j2qXXKoDWKF+uRlLI7GOTQ7a8Xjn/hMtcsSUXaGACkEFMwiJ6En7UDVrRJ7Fu4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 DM6PR12MB4042.namprd12.prod.outlook.com (2603:10b6:5:215::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8048.18; Thu, 10 Oct 2024 06:28:49 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%4]) with mapi id 15.20.8026.020; Thu, 10 Oct 2024
 06:28:49 +0000
Message-ID: <ec1630ad-a75c-7164-49fd-9dcea3d1bc68@amd.com>
Date: Thu, 10 Oct 2024 11:58:41 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v12 00/19] Add Secure TSC support for SNP guests
To: Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
 thomas.lendacky@amd.com, bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20241009092850.197575-1-nikunj@amd.com>
 <52279d55-11bf-490f-b3c7-69e6fe246c9d@intel.com>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <52279d55-11bf-490f-b3c7-69e6fe246c9d@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN0PR01CA0054.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:49::15) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|DM6PR12MB4042:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f608426-5a32-4dea-c2b6-08dce8f4cd53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WTVZZkNMbDFQWHFzZUF1UjNieFZWaVQxQWVhSThIYnIrQ2M4UDczTjEyeXlL?=
 =?utf-8?B?bXFkQWhqOGwrbEpXN2dLVzVYSFVzOW5Pek8wSHlYQmxSZGxiRGRCZXZJeUx5?=
 =?utf-8?B?YXh0VXVWbU1WOHNVNDR4c21MdU5UM3FJaHA5UVcvYzQrRkVqeGR1Tkx2ZGM1?=
 =?utf-8?B?VHRjN2s5V1BsVFdyMElXeVp6aXVjWXBlTUYyeWU4dHR3RkNOOXR6Rmd6QnR2?=
 =?utf-8?B?RFA5MXpUR3hZRi9LZk9zZllrcFFvbytvWjFwYnZtWHFHRzBNTTEzemR0anV4?=
 =?utf-8?B?Rk5tMjJraUt5SlRHcmoxbVVsdWdVVjVoR3hVWWR1ZFVzTVlDSklySlRibUVL?=
 =?utf-8?B?YWxweUZTRGhQS3BqUVUxSURjdlFsZDhZR20vRWFJek1FYWh1WnI3U2FsM2Nh?=
 =?utf-8?B?YytYaVU3WHdDRVBCZFJkM2Q5Y2dIaHFBTHFmQVI1Q1NDVDhDNzRmYzdVaHY2?=
 =?utf-8?B?MWZ6Y0p3T3lrdUxJVStnSTlheVVJNDNHZFZHSWJ6c3k5MXhuNHBEakZnYTBJ?=
 =?utf-8?B?NDVjOTlVakR5UUhYVjMwbWZpTkxreFFFT2R3eEVaajJRc2xvK29PeGFnemQw?=
 =?utf-8?B?MEl5V3BycTJyNG1Oc0VjRmZPcVdoZFFTS0F3WDdxWno3QlV5QkEzaVlMcGo5?=
 =?utf-8?B?ekRqNHNNTEx5Ymhpdkl6SmxDdEpOQmxRczN0RVE5QmtLbXIvWlYyL0RRTGxl?=
 =?utf-8?B?ZUd5SFVOVy9oSkdVOWhDWE5tNXpGaS9USnJvTG5HbVJJWjVhOFB2UStTdlJE?=
 =?utf-8?B?eGlxV1V0aldJYm8zOEQzbUNJZWFYdlkyellqcU9GVjBZN01aSExoOFFsUDVJ?=
 =?utf-8?B?c1MzTmFYK1lINDRZVlRmQUpXVDRDUmxoK1VjTTNJTU1PVWxwUjFIUzB5SFlV?=
 =?utf-8?B?WXBYbGFvTDA4ajVuS1I3UmYzbWZGWDRiWXljbnJqWlYrSGVvcmt3em83RWVE?=
 =?utf-8?B?eHJZT2d1eEhQaGNwVFRscUl2c3JNak9HNzdPeDhhQ0hiN3kxRTAyVjZ6VUsy?=
 =?utf-8?B?YkYrQUYzdWZkZnNLbHkxZWZaL0NBMUh4VVpid2JpTG1XSWRJNGFZS3Q3K2pU?=
 =?utf-8?B?MXVmd1pDRVR1VjExMnFzcG83di81cUk0dnVpaVF1bTBadmhVWG83T1RZWFZI?=
 =?utf-8?B?M0p3dWo0dGhobFlhSG81a2ErdTdLc2hyRTFyZVcvNUxrSk9uMDgvYUF3OTAr?=
 =?utf-8?B?bU9zamJKcUpjVWhxNmhsVkRSU0c4NjhWY1FsWGFlemt0b3dpS210S2FJcXoz?=
 =?utf-8?B?b1BINU8zNit6RXpUdzNxQ3NFYU9pTk1aWnRPTTJWRENkdytFSHc5ZzdCVkJi?=
 =?utf-8?B?SFVIc3FqOFh3UWJOaVBud1kwNWllaHhoTjJXSlYvUHJsMG54d1pubUFwTXc0?=
 =?utf-8?B?bXJVbHBodzk1WVVwNWpDZkVtS1JvVmtOckQrdmVWRVhtN2V5Q2RDaDhJc1N2?=
 =?utf-8?B?c3VxS1ZvQnY0YTh2c21HdVFRVFAzQWhSVUdLYjAwREdnTUNuaGdrcFZYVE5S?=
 =?utf-8?B?RWtjMzBZNUsxNHdocVBwbkFOeFg1NnBxSERWYlFaeU5IMkt3N1dOZXFSdmxy?=
 =?utf-8?B?Wit5ZGh6QWpJOFdvUjhES1lLcExNY0NFenlGMjVtZGdSYThPVWZxVGNzdVJv?=
 =?utf-8?B?RVdqb3FhTWFlTlgrR2VhL1pBbG5JbThDSUFwRHFaektnVjdQa012LzNVSktZ?=
 =?utf-8?B?QlZ6SW1nVVJQdTFQMWlNV3RIdU54bXRhcGVBMFI5S2s2L25JSDNIYTRnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aWcwTVBnR20vVGt5dGxLWUdrNERCZ2JGaXM2QnZWbkdIbUIvNk9vL3pTY0Er?=
 =?utf-8?B?M1dBRWRZZmhPK1hNWEF5cm9LUDM0UVZ2QTlBYU9xNSs1bGtWSmpjaFdYVTV5?=
 =?utf-8?B?TCtnN2ZqamdzU0o5RWVBenh3bnpyODUxZ3dXdXk2UzhhamZzRjlZKyt5RitH?=
 =?utf-8?B?a3N5KzBaMXpPb2tpbWQ4RnVpQ3FSejFPSlRpWkFlTnR0bGorR0hVMnNmZjRy?=
 =?utf-8?B?d0h6dGtUVlVVRFJJQjg2QXlVK1ZBUkdGS3QvdWpFUUV0cE1rRFcyWHhhcGYw?=
 =?utf-8?B?UTEzRkx1alQrMklRNDM1ZW5CK1NQcU1aNURMVkJ4K3NhdnJDenBqR2ZCeFFq?=
 =?utf-8?B?YWRYTEthZVFIS05zVTlRZklWV0F6NndreEJyd3pDR3luVUczUEwzNmloNFc5?=
 =?utf-8?B?QjJFekZBSmVpMVhYdWhTakJOOTZzWFlHU2FuTExIODk3MEZ6MjFVT0luc2J1?=
 =?utf-8?B?YmM1SVVGeHBVN1F0bXkxSE0rdkRVR1I1ZThtRExFalRWNzR2WEpwVlhvbmpz?=
 =?utf-8?B?NDFMSnVHY0xCSEM3THh6THV2MGxtdm5Cbk9OSFAzU1ZYS3haVS9iTFdNR1p5?=
 =?utf-8?B?SWVSS3Vhd0tqMWpkT1BZb1BXbTBBZEt1Q0Z6TjAxVVU4OGU2UXM0SDFrZGlT?=
 =?utf-8?B?TmZnY0YzcURiVVdKN3VrMG5IOVRmNG1xeFpUdlFiS25uc0xnMmludkxGYVhp?=
 =?utf-8?B?Z0xlNFE2TGtxUy9pdmtmLzAzQnhKWUVSdWl0R0FQSjZVNFFQaXhYL0Y4WGdX?=
 =?utf-8?B?QTlwcElVend3SGVsZzM4UXpCZUNZc0hXV0ROSktNdkJKR2VLNk40dllaTUVm?=
 =?utf-8?B?WUpNM2lMeU00cWVrWEtML2EvN3hCbnlDT0ZENFJFeGcrMzloVDZQNWlGWDND?=
 =?utf-8?B?bXd0SjZ1TjFIUC9OZzdMc0IrUHhoRFRuUU04ajU0ZXRBYjN6ejRGMmQ5YnVJ?=
 =?utf-8?B?RUNXcFcvMlZOa0RDWkFiSW5IdlNTNkpYbXo3OWVYcXZJRXhiKzI5aXdyNmt6?=
 =?utf-8?B?aVNBbkNMMUhrTFNYK1FaK094TnFlWlF3bTg0Nm5HUCtqOUJtbDBYVUVjWnhv?=
 =?utf-8?B?ekRMWEhISHozU0puNUFZZzk5Y1RyK2RyTUN1aUZoK2V0OHVNcVdOdUNZdU1r?=
 =?utf-8?B?dXN1Vy9CN2s1RTNiMnRxZHFCNURyZ2dJQjhieEt2b2g2c0VGQW4rdnlSSEIy?=
 =?utf-8?B?SzZpSWVsOVkySy9UOWY1UThPamMwcDhTUjJ6NFZ3bVp5cFh5QXN0NFBmOXpu?=
 =?utf-8?B?MXZpM2hlTll0a3NYa0l5UndKdzZDczF6T24zakdpMUF5MDZPMGppYW45M3Z3?=
 =?utf-8?B?cnlBeWNBcExvSENuSWVHejRiSHB3WktVS0I1MjNZWFhxcUpvQW5pT2IrT0Rh?=
 =?utf-8?B?SGJUZGhBTkZ3enNGQVpHMWdTWis4a2pLcC9nMmtyWWc1L1BtamRoK3RDdEVU?=
 =?utf-8?B?aU1UNTdoR3RQWlFSNzJYd2RpeWxSTUp6VVRxUTgrVkMwTm16Y2tmZVR6a05F?=
 =?utf-8?B?T0xBOC8vZ25mVVkxUlY1bEhLNGk1dHdiZjVGRmRIUUJ6eHd5WXV3OC91NHpr?=
 =?utf-8?B?Zm9zdEFDSDhIOVVteW4zYTJLYmdBRnh3OCs0REFoYStDb3B5K3ZqRVVIYjBJ?=
 =?utf-8?B?UFJLWVhHNlJzUlVTRmFCZTRTU2FPU2FVU0Rpc0oyTTAvZDBOM3RPc3pkMU1x?=
 =?utf-8?B?SE1SeXNhWnJaRVVVYWhlTngwVWIzTFJPUERwcWp0MUZISVV1elFFbE9QOXZI?=
 =?utf-8?B?UlRyTkpvS2MvMVdOZ0Z5WVR6U3h5TVJNQVVPakx4UU1XNDJLZUNFZHNWdGdW?=
 =?utf-8?B?M2xES0gvVENwYTNlY091SWhFQm5aMnhDSnNoeU1CTlJITEJRK1JSd0FqTDgr?=
 =?utf-8?B?L2Y3dXR6ZGdTcTFEaXh6Q2hJdjMyeFlnUmc2ald6THNRVkpXUFFWK2RtMUJz?=
 =?utf-8?B?Wi95UXVLYVJaWGJiNHZXeFYzWlE4d2NTd3pvalNkbElkRmlJcFMzMEFVWllP?=
 =?utf-8?B?MTc3dWxSbXZWdVpySHJoeWc0NnJvVjlkMHZPTmFETnN1ZllMWmlvWTZFMmJG?=
 =?utf-8?B?L3NDWm44a0g0WmUrSkthWmVsLzJOYmhROXpZNVZvZ3EySHdDQVdMV0RNcmx2?=
 =?utf-8?Q?l8NcmQ2Y4Wl74JxNg9bBPptQb?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f608426-5a32-4dea-c2b6-08dce8f4cd53
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2024 06:28:49.7709
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yW5W+k9iwJk+lwAOWMTNNJPkXq8MTISXR09hkUFwH5MrfllcdjqYfxhA8r0mbXDqLrvQNhTpruYPmk7/gLxDpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4042



On 10/9/2024 9:38 PM, Dave Hansen wrote:
> On 10/9/24 02:28, Nikunj A Dadhania wrote:
>> Secure TSC allows guests to securely use RDTSC/RDTSCP instructions as the
>> parameters being used cannot be changed by hypervisor once the guest is
>> launched. More details in the AMD64 APM Vol 2, Section "Secure TSC".
>>
>> In order to enable secure TSC, SEV-SNP guests need to send a TSC_INFO guest
>> message before the APs are booted.
> 
> Superficially, this seems kinda silly.  If you ask someone, do you want
> more security or less, they usually say "more".

All SNP features are opt-in by default. The option is left to the VMM.
It is similar to having a legacy vs secure VM, the option is left to
the user.
 
> Why do guests need to turn this on instead of just always having a
> secure TSC?  There must be _some_ compromise, either backward
> compatibility or performance or...

Secure TSC has been there since the introduction of Milan when SEV-SNP was
introduced. It wasnt enabled in the kernel yet.

Regards
Nikunj 

