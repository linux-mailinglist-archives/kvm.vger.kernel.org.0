Return-Path: <kvm+bounces-38773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C411A3E452
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 19:57:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 51CCB7AA265
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 18:55:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C994626462B;
	Thu, 20 Feb 2025 18:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="qJ/H/7Rb"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2049.outbound.protection.outlook.com [40.107.212.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F94264608;
	Thu, 20 Feb 2025 18:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740077752; cv=fail; b=jApnG0pLdNs02KRCQXQj8QdNh5y2p0DOPso8MGkdyXhMnrXpmP7DJUGplGIHXGzRGvBUMoCgGHSHZLCRaNLDIWvi0uZftbiaRST77TEU7ovxF8znFd5qtUs4GbRTtGrcQLnu27EsO5tIrjQ8JYDOya/e129wDqSynGhOPYdVXkg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740077752; c=relaxed/simple;
	bh=lfIi8q+fpgCV6OodZ0AWmE7N8k8X4xHPQYwzpemleis=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=TjrLPcSfJRw6Ek0+psMCjBUKBuOyBEUyibqq3zf0yQc0/QtXN4ywvgSQ2I+6D0Z8tvaP+gPw9Mo8Qu+kVC6QX7ax+en6i/p5632sFLdzrwYcNv6Q0u3+WFIo+I9MkK20p5R5BS9E9tZliknYU090jimlA2++5UbqfC9IGZR9pqc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=qJ/H/7Rb; arc=fail smtp.client-ip=40.107.212.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HGs+PYbxZ9xw96uUIJ6RUIuLlFzsOGFna/TR5wS/3k0rI3w1HaYc0asavsZzNXOtaYNeVkwehdB6FYWeMcKBis9vZM4zch4DpTT0ssTNAS46h+2M+zANbvySfyG/KIFRbQeLaaCRLwEsUnEqvbwQbJ19VsnEdlmwqd7kd4oJfOW92T41jmd5DU7dUyDrKWO9vm8gicH+e3d2Dwcgdr0CXpIKqVoHwt23fKqNFDc2JXEhsgJj+EwpPJdtufUOZ0GK0LpnwuTRVw7XyJzLNDDUNM57jfhWx7rdYbqWLUhurxLI+YClqQIpj70J37ESuH+Bb8L9Odn7rFoY2rwP9bHjvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lE6QQFEAOTGYZTSwTVlZYISo/hOcBJG6eNZaXipyKqs=;
 b=WK9qzCU29Ny83hqUk0Pco4L675wxxXNqKZEeXeeEh9KGlvOQoZfoGIxtkFLLxGOAuc8DlYMo07CWlp5H4jPHj4/BJSL7ouU9NZfeJ+ZKK62Q2F/ji/iBLA8PwUF7hHRCcv7ct8QYSoW2lefglIRfOUyBgcc9DvVnQIoqZ6jOIpNzZN4vT/71L81Q2A/khOSF8SB0nqK7npd7B3ONtVDEe+SuhVCxjwo5nkJJXdjWAXlS0YR0P/4HzzUvMfrlegEliKeVnqB6+zBHk0tszVcb8lhaJceV0TPnKDfUGpJwsAh0nI/VLF2L94kX6UwEG2f4wjk+J7mE+xEEb6tlx4NfGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lE6QQFEAOTGYZTSwTVlZYISo/hOcBJG6eNZaXipyKqs=;
 b=qJ/H/7RbUwpt11a0A+BCmch1yTKGiRMMHJc5liQGQKPhrznIY1UT30KN0dM+wRgceRgyWaXFqwi6EkUa3FfCHiN6P2Ne8eA0bj4K4n6qOIVaFnGrhC8QzEGL9J8WIzT2oGD4jQJnFH7/dUXt+uIGn2e9w/e8OL4aysVntSxwXQc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH8PR12MB7302.namprd12.prod.outlook.com (2603:10b6:510:221::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.15; Thu, 20 Feb
 2025 18:55:47 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8466.016; Thu, 20 Feb 2025
 18:55:47 +0000
Message-ID: <2d15480e-2782-89bf-4eec-681de812fa5e@amd.com>
Date: Thu, 20 Feb 2025 12:55:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au
Cc: michael.roth@amd.com, dionnaglaze@google.com, nikunj@amd.com,
 ardb@kernel.org, kevinloughlin@google.com, Neeraj.Upadhyay@amd.com,
 aik@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1739997129.git.ashish.kalra@amd.com>
 <e13263246be91e4e0073b4c81d4d9e2fc41a6e1d.1739997129.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v4 3/7] crypto: ccp: Reset TMR size at SNP Shutdown
In-Reply-To: <e13263246be91e4e0073b4c81d4d9e2fc41a6e1d.1739997129.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0008.namprd04.prod.outlook.com
 (2603:10b6:806:f2::13) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH8PR12MB7302:EE_
X-MS-Office365-Filtering-Correlation-Id: 418cf175-754c-474b-e314-08dd51e02fa3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?emV1YTNwMTY3S1JiNHNTbGJWN1dhRHFvQ2lrL3N6VGUrYjEwU0lhRXhDaCto?=
 =?utf-8?B?SXpMSWE1YVRyL21ZRTNRY3JwclBvekhCMTVnNzNTZitHNi9KcjBBb0RURDhk?=
 =?utf-8?B?VHhEY2d2Y2JReVkyVWJxK1lGYUZnT1JDY1RTaEtpN3JHcUJWZnVubWV2ODg5?=
 =?utf-8?B?U084ZXVaaHFleGFKT25qZUViZ1RseE5GNXJOWDh5ZVhwcVh3N0E4QjEyV2dT?=
 =?utf-8?B?SkhvenpnTm9LeFlWRGRmbFBUN2h2VVluOCsxUy9yN0VpLzIxc0svSHQwdDNX?=
 =?utf-8?B?aTMra1ptbUlYeUcxREhvNVBDZFd4QUtkL0ZDMmxBNlJPTmhwVlZQemhsSFhW?=
 =?utf-8?B?SmxjcEJnRlJVTFZFUzlUcjBtRnVMOTdmME84VjI2cnVWbXRJL3ZHN01aSFJL?=
 =?utf-8?B?NDNhKzV2Wlo4cHJwTm5hL0JnSk9rSm9nRi8zT0tEcllpUHNCZlFvRDkwUUw5?=
 =?utf-8?B?Ujk4a2tmRHJhVUVjcjJKQUN0SWZpdnp5V2dHQ1dWbHJYYjlWVjBSYlVSN0da?=
 =?utf-8?B?ZTM1aWFpTDB3RjhFY2R1ZDhJRHRKdlBJZE42NUpuL1RvK2ovNis2MHFGYVQr?=
 =?utf-8?B?cDUwK0UreDhxcjdvdnY1VXR0c0FpdmRXVGtPeTlzbHY5djZsOEFrT2ZSRTcx?=
 =?utf-8?B?S0k3WVNrSTh2T09IZGN2NkRUTWY3MktwR1Z2WTdFR3pYVkZhdEtKQ1pPeHNk?=
 =?utf-8?B?Zk43U2lmdzkxTStDMXQrU1RBanRmTEY4ZDJyMkVhWWg5NVF0aUFSc3VrbEk2?=
 =?utf-8?B?d29QbjNoODFwMllFdkl4MXRPOXVQd1cxSXlSK0xaREtvWkM5MUE1c21hWUM5?=
 =?utf-8?B?d3FTTkhXZk9VaHVDajl2cStFeldxZGllNkkxU2tMeENCS0twLzdlNFpLdmtM?=
 =?utf-8?B?MW1aNDBTNFpHYk0rVHg4OTF4V1diaGgreityc3BHd0dXZVVFNGxMb0ZJcEx5?=
 =?utf-8?B?VzQyTndZZHBHSnpPZFZ4WStSU0w4TFpkUXJvMjh6VEltcHN1UjRpRkh2NFNi?=
 =?utf-8?B?ME9GNHJ0aUl0bWJWKy9wYnk1RWFCTS9jb3c3cFQzSm9YeCtNcEt3eTF3L2g3?=
 =?utf-8?B?SG5qTHBBbzl3cHRzSEFLVWVKYldKMzdZQ1Vxa2V6Z1ExZE9ORDJyL2Q3TnQy?=
 =?utf-8?B?eUdCYmE4SkZuaFdsSzZrMlc2NXBib3d6bW44Q0pPeEVNeVM0SnhEeDFKWVpG?=
 =?utf-8?B?bVN0Z0F1ZVBuanBVWmtxdGFrWG1pVDFQMStwc1lSLzd6OC94T3FvR0YrcFFq?=
 =?utf-8?B?eXBtSFNmS1BOVlY1TWxZNjg5WElHUVpqWjk2dVVQaEVDQVRVVHRMYjFiNCt1?=
 =?utf-8?B?VVM3Y2tkZlRQV0ZzNUwxZGFBNE5PRVhvZ0NjVzR2b1lNbzFpamMrUHNPdzAw?=
 =?utf-8?B?eG1EVmpxQUZ0aVJSNHRZRXZKMW1GWHpoT1p2LzIrZFFBeHF3amdhU3ZENGpP?=
 =?utf-8?B?ODMrcmhWRzRvNWtwYTIxMFh4T3lFY25rZVdCaEpkVGlnTDFRSjR2eHhvcmVu?=
 =?utf-8?B?a0JhY2l4UUp6T05panJYeWRTY3h0L1BjOStVY1JkSmhNMVBRU2gyMjZBeldo?=
 =?utf-8?B?dUNIT0pQSnFZeTNCRTh2Y3FUZVBnZzMvS2sxMGdaTVphS3JGTU9ISjk4ang4?=
 =?utf-8?B?dHplcHV3MWUvNHdDOTFrV1JoSGMxWnhKYXp6dWVhMUpxdGowRUE1TFU0akZR?=
 =?utf-8?B?OWdmWW1wcEM0dXFqcEZkS05zYmtVVHJxUXphSWlwUDhVWlI2bVVrTmZJOEVn?=
 =?utf-8?B?emNNUHZEdzQ1REtCMnBNTnFXaGtPc3RZaERvaUlwYnlFUGYyWk54ZzU1K0pT?=
 =?utf-8?B?Yi9xS3U0eXVzYU1FalUyYlMwL2RhNU5kcVFINTh5enFzRWVNQVJTY2Y1L3B3?=
 =?utf-8?B?QnlVZWhLYXAxZWpQdnRxczBkU0U1SGpkNERtQnZrUDJLTVB1cWNqL215NVl3?=
 =?utf-8?Q?XQdH+ym6NlY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TlBPbnJHNzBkQjRFTGk4M3Ayb3UrWGZJT2E2ckJ6WGNJbEV5R1d3RHd2UjN5?=
 =?utf-8?B?eEU1RjRYZU40UlJtYzA0aTVqNWptQkRJajFhL05NelEyVzg0WFQweEJwZHlq?=
 =?utf-8?B?TWNNSXNRMFdZSEZmaThXWllKNWJjRzdiUWVZTE9YOUFBN0dDaG8wZGVJeFMw?=
 =?utf-8?B?aG1oRmRlcktYWSsrdHJ2LzhBMDRUMXdva215b1RodFRSc05Rankyd1hKUnpU?=
 =?utf-8?B?NGFydEtMVjNsclVMN2M2SE9qYWFLNlRRV2oxSkkwRi9CNjlyZHV3UHFqRjRD?=
 =?utf-8?B?V0FpWlBPNFhxc040YWNYTU84ZTZCUGlWaDBCd2NaRXhJL2V6RVRDUWw4M0pt?=
 =?utf-8?B?ZThJNWYvNGU5VUlscjdNU3lVV21Ba3RLTHlKcTlxMVppMWRJUVNkS2h3dW9u?=
 =?utf-8?B?Uk92UkM4RGJUc01KREFCUkp5ZktEMFB1QlhlYXpXVFpTZkNOdzVWSzAvT2Vx?=
 =?utf-8?B?QWFzUFM2Tlp6aC9uU1BqMXlNVHdVZTB4V1MzUzBxV1FpRGw2MXBWbEloK3Ji?=
 =?utf-8?B?UWNKKzRnSCtxdEczdmZuTTVsc3BmRmdiWTlMK3U5bFBKUlVFRU8zMmhQb2tH?=
 =?utf-8?B?T1hZUjlQV2lyVlhDVTNUZWhzTHU2bTJMR1NoVjdNWlJmMTFjMXFPR0NrQ2lV?=
 =?utf-8?B?RHlxcUxmNVdMYUlmM1VTSndMZEp0VEFvaTZwbmtLb2ZqNzliUjJvOEJkdUt0?=
 =?utf-8?B?VE0xTnRhTFZpT3ljVmtxZ2pHa29Id2twMzluK3Fzbm4zNCsxeGlOS2FNQlcw?=
 =?utf-8?B?M2lZZjJMaEFWRVUyTFI4VENWYWp2VkN0THh2eUowTnc1MUpJTTFCY05URjNN?=
 =?utf-8?B?S3VDdzUwMHVycVlSMGdFS0NSeGhleDF2YW9XS1lFcGNDTkZrUGhxTURjcVB2?=
 =?utf-8?B?M0V2eGhObFFTQi9qd25HcjdmZHc5RDA1ZVQ3U0pHNTdLNWtEWnpZaU1UTGxh?=
 =?utf-8?B?Yk9KWjdqRk5zZzdpRWNQZUNwbXkvZjB4MEMwbFBoVjM5bVRhQzFGaDlVcWhU?=
 =?utf-8?B?M1VqL0liQk00Nlk3aW1oMjQ0Z0FBeTVUZW5oRGN6TXEvTHBRSDRsZzVud0tD?=
 =?utf-8?B?bzhCd1ZSUlRYSHpGbVdlZ2dZZUQyQ2R0VzdnaXlSRW1DeHExUUwxZ25relJL?=
 =?utf-8?B?TEJnaUs2RVJYUmo0cUFKY3c4SmpVY2k0a05hUXpxaUgwSVl5MnNRV2Q2UFZV?=
 =?utf-8?B?engycWxrUDQvRmtkbzB5RC82UnFlVmduUDkzbEo1KzBCUXNqeC9uTEpVaHZX?=
 =?utf-8?B?T25MOXdnL1J0VzBPSTYzTkthdHlhZ2d1UEtoKzdHQkJDWTBLQ3UwQ3N3OGwx?=
 =?utf-8?B?bVhUdC9iS2daUDhoeEhjUWJub1VucHAySmpCVW11ZTFYZmVTcDFiRldyWkxQ?=
 =?utf-8?B?ZXhJL1VIR1plR3d5cnZtZ2JEanZQcmdVOXg5a2VkU2UxcDJDSllIM29OWkJo?=
 =?utf-8?B?dGdRYURnK3I5U2FzM3NGRFEyaVMrWHhsSll1cjhwK01Sdy81eXBkN0NXTmNv?=
 =?utf-8?B?a1VDalBzcDJtM1ZER3phUldMelVsMmZsa2hhcDIwVHR5ZGNzalY3cHowOE96?=
 =?utf-8?B?LzVPSUljUmlOR1dMcnU4R0dqR1NIQlgyV2RyU3k1ekIxYTc1dzNOMjFMVlRq?=
 =?utf-8?B?Sm9YYTl0MjRXK280cFBzR29EQmp3TzNUc3QzWFNHTElXUEgxNVdzUTR2VDZL?=
 =?utf-8?B?bllZcnFSM1dSVDlBa3FFMmYwcnFxVTVsTmxyd1FXWkVtZlNMRVY3ajZ5cTU2?=
 =?utf-8?B?OUxsak92VGtnNzVqSEt5d1N3TXdDcTZ3OFphRXVGb3YxMThSelROZEZEVjNI?=
 =?utf-8?B?Zndvb2NzOUQzdGtqRmhWV2RSM1dPdlNvTjVKYVBjQ2xvRkNvYjJRL21jdmh1?=
 =?utf-8?B?Z1Nqc1YvSU1XR0pTWVBCS0lmSTNyelJTY0RnakZaS3l6eUtvb3NqVzJxanA5?=
 =?utf-8?B?Z1licVFlSlFjcTJGbk8vMWZnMDZwQVRJNWRuek5scWVZMEJRYTJBY3l0WjAw?=
 =?utf-8?B?bUtod1UzdlpHL0lCUXBiN1E0bG50Rjd3bVpqYlpMeXFvZDFDZ2Z2TmNQajl4?=
 =?utf-8?B?a0QwWVQ5RjlTOHFKaUVvZHlTemI4NUIwWVVIQXprUzdmV2ZiM3JydkNEeHpN?=
 =?utf-8?Q?OCP6RUdqD5cOHUezPDkTre4Ia?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 418cf175-754c-474b-e314-08dd51e02fa3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2025 18:55:47.2181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qV8A+oGO7qkDGIQMvoB45poII+PM9HmzBK5URfEA8cn/7wQ/MEzRNhCupIlRCeeMZueVNkbLpRXi066omLQAOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7302

On 2/19/25 14:53, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> When SEV-SNP is enabled the TMR needs to be 2MB aligned and 2MB sized,
> ensure that TMR size is reset back to default when SNP is shutdown as
> SNP initialization and shutdown as part of some SNP ioctls may leave
> TMR size modified and cause subsequent SEV only initialization to fail.

This is a long run-on sentence, please re-work this to make it more
informative and clear as to what the issue is.

Other than that,

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index b06f43eb18f7..be8a84ce24c7 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1751,6 +1751,9 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
>  	sev->snp_initialized = false;
>  	dev_dbg(sev->dev, "SEV-SNP firmware shutdown\n");
>  
> +	/* Reset TMR size back to default */
> +	sev_es_tmr_size = SEV_TMR_SIZE;
> +
>  	return ret;
>  }
>  

