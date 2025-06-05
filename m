Return-Path: <kvm+bounces-48583-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CA151ACF79F
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 21:09:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 84E6717ABDE
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 19:09:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12F7227C150;
	Thu,  5 Jun 2025 19:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="K7ToWDkk"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2046.outbound.protection.outlook.com [40.107.212.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464D218C06;
	Thu,  5 Jun 2025 19:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749150581; cv=fail; b=d/1IPHpjYSs+f07VrtBTOCKhC4dagTkpdDH13G67FpBLqXlfORw69bUjXJSvfjixgImAtYastbfq/Ts2Jo1zuP43EX/gHhCegQ3yagyQ7XvgoBdVyEUg0XL/jjJhiemFGChTh7Olx6vABvSIshAtBlh/EItTdDQG++H8I4XsHqA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749150581; c=relaxed/simple;
	bh=joZSu1TOwKMMtG3W5aDFoyeWQsuwEZ8aTBTGG2r8XjI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=o71RduQyfTWemn7+5LtE1d6bxrg9/VmfXFzgRBQow45imQemYUabo7CcN6HSyH9BJUg7499xpJn38lc2QTg5iD9KzSSlgPC2/vq8xHF3SFL2moBGcGeffhtCDaJ1tva919/5KOiIJbBFLAHHgMZWQ0soYcyngHgIomD+Fs0nxJc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=K7ToWDkk; arc=fail smtp.client-ip=40.107.212.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qkxWuFLdwbkcS2esb5Xh22qXigAtiwchOcxb3fAp6ItWPr2lbEkxbMsRNUq3NC9BrDCGAVK7vrll5HfJWatC+8WIJxYtXYjM7964y2IB3CQh74oxamZJR/GDAXsdzpnlNlmCzkxdUhtQhrtjqvYQL+SX1hMB4c2NJuisFhiJmWg1tzW1nNwAaDWVRlYXm1P8qb313A13TqeAXgu+LV9wy/zkX33YU/yrmaNnlzQWburk6sGkk9Yqhm7WOIpqI/BcevKEMw/kZaSB984cRtcozzbl+fnWtNMvSSAd/dlI/9S4Sv6MDucsWyWgZ0hBE6xZIZQW5mMsBE1gKNe8az8/tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AUHZzA8QeIq3XO6ZW8/aBkOVx3gZV3esNdmHzgMdUR4=;
 b=l4QAtZwg1Qm9uqE2RZg9af4FIwRAm36Ke4vke2KkqjAfZur1gAc7bUecPpQDH7BDVzGZ12rMX4KXqcTQSXhA9feUIHgOCzDN0Yx2UZoWc2Otd9X1D+iuxRb1/J+YynNZVV1/rXCGkCAFtc9AeJVIC7ovkBmWjFPtGHMOyfUb9BvAKVGKAn0hf/VecnvHhvUBygn5fuhXdRZcWaZlGXZgwtAJDZy5uYryd0gJNcHELvhuvzoqhoekZccPr6rUb2tOPKbQqQMBtLfoQAOJgUKxv5yjjzkKkd/iGfHR0hHUkmvLZyde1ik8bnzZzkWKXKkaKX4IxV6en80ospS7vAfTrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AUHZzA8QeIq3XO6ZW8/aBkOVx3gZV3esNdmHzgMdUR4=;
 b=K7ToWDkkYPzpNJ3fgduD6JAqWcWy6bb8pcqWJieu0RIgrvWGqDu06QsLiPXsGSR6OAusg7tjrTNI1JL9bU+BsosIIKy/0x96S7XpJeTG753RCO6cGFW/LD3I5KwQ4Ym8RYcDxPbd5x/o1oCywgwRlAmr9cgVEnnvWK4619pIdwA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by SA1PR12MB6679.namprd12.prod.outlook.com (2603:10b6:806:252::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.37; Thu, 5 Jun
 2025 19:09:34 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%5]) with mapi id 15.20.8792.034; Thu, 5 Jun 2025
 19:09:33 +0000
Message-ID: <755d9317-a004-4d4a-948d-729a3b3ef13d@amd.com>
Date: Thu, 5 Jun 2025 14:09:30 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/5] crypto: ccp: Add support to enable
 CipherTextHiding on SNP_INIT_EX
To: Alexey Kardashevskiy <aik@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, herbert@gondor.apana.org.au
Cc: x86@kernel.org, john.allen@amd.com, davem@davemloft.net,
 thomas.lendacky@amd.com, michael.roth@amd.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
References: <cover.1747696092.git.ashish.kalra@amd.com>
 <0952165821cbf2d8fb69c85f2ccbf7f4290518e5.1747696092.git.ashish.kalra@amd.com>
 <e59803e9-017a-4257-ac9c-7bdafbc624ff@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <e59803e9-017a-4257-ac9c-7bdafbc624ff@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA1PR05CA0018.namprd05.prod.outlook.com
 (2603:10b6:806:2d2::18) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|SA1PR12MB6679:EE_
X-MS-Office365-Filtering-Correlation-Id: c78daab1-7bd1-4688-68c3-08dda46481bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NWNJcjdWVEVMbC9zeDZueHpSQU1IdUo4TXgxVGk0T2lkNkZYWGFyMUJCc05w?=
 =?utf-8?B?MkpxeFdld25wbjJ0U015cm8xSXU4VkY2ZEM2aHFVeWNaSTBlWUZVVWc0YnB4?=
 =?utf-8?B?OThhL0dlK0lVTlJVZUcxTTF0dEdYa055Rzhjc2RGMTN3SFgyQnZkcjBHamps?=
 =?utf-8?B?MndTOUhhL2dKWFAxZmZhblh0UVdTWmRVRXRGblRMK0N4MnRMdlY1ckw2OWl0?=
 =?utf-8?B?LzBZK2lpV0hWN0ViN1Q1UnlwZjZBTWZEcFducGFXaDFsYjNjQVcwTjdwdGFu?=
 =?utf-8?B?V01hOWVhRklxQ2lkK053L3l0eTB0KzNuMmJpWUd0b3VWaytWZytsY3Q4MTZS?=
 =?utf-8?B?Q2RoYzd4T2ZqVDRqYjZESHROeWZCN0t6dVdHZE1HS1JNZ09md0RmakZ2ZE5r?=
 =?utf-8?B?YnRMODhtQ3g3L0hFOHBNaFdpNml5Q0l3aVh3MS9xVUtrNUcrd3AzVVVnWGVR?=
 =?utf-8?B?Q0pqVS9WWWtxUFN4UXpENTE3MGtCUVNZNm5DOS93eER0L2U2aE9jQm5SSy8r?=
 =?utf-8?B?SmRjbHNvVFdTUTEwb1VscGovOENIWWlkV1lrMFZNT1E1T2dqYjBHUFcwTUNQ?=
 =?utf-8?B?bDNwQXlNeWtTdm4zM2g4UFMzSm82cCtaNTA3cjBrb1lOSUpXTnhlUmNpN1Iz?=
 =?utf-8?B?bUVJWGZRWGVHaFdBMGNUcUN6L2F3bS9LTDRpOHorRHM4c25rUURFYVpqbEc1?=
 =?utf-8?B?ODFkMTFZRWVxcjJRejVBZmVrNGl4MlhhOTIxeEhZbnh1dlRtTjBaUUc3a0hY?=
 =?utf-8?B?VXRQNDZNdW5CWUFQb1BVaHVUcWtNWkI3T202WktMVzZlV3dKbmx0cVBidVRV?=
 =?utf-8?B?a3p6OFhnTjJWMEU1Yk5sN0FhUWw5U2lIMkRBeW1PLzIzMUY4ak1yTmVCOVNh?=
 =?utf-8?B?eGIwY1BYRW9BNzZOclNranlOMXVBb3Q4T29lU0Z0Z2tjelg2WlpZYzZmLzFM?=
 =?utf-8?B?ZlByNTl3c09hUFdHeXRKY0RDeHAzT00zS2FtOVF4eXlzUUtOc3FzZnRvU0FC?=
 =?utf-8?B?TVhnSHV6NWR3V0M5WlhwcXorOTUxRlk4WDFYWVV0OVM3N0FVUGw3YUZBYmht?=
 =?utf-8?B?ditSQjF4TDJ0MHV2VDQ5MkVBMERYbU0wcFBVMkYwbzNIcDAwZjhrejJPRit3?=
 =?utf-8?B?MWtab2ZIMUIzZ0N4R08yTXZpNFBRaytRTzJYcDBPZ0plcWlSMlBpL0g3Mll3?=
 =?utf-8?B?ZnQyVzdyK0lEY0w0UCthMXBBWFFkZCtSTTdMSkRkNzRmV2ZYK3lpd1V1Zy9S?=
 =?utf-8?B?SVdEMXBiblIxZW9aRXdQV3pDcW00bTlqQnRibG1LZm5NUUxZRVpiSFd0VkJQ?=
 =?utf-8?B?YXlZMWFwM0Vrc3JheVdxQWs5aDU2ZUsyWlZmeXkzL1RCcnRYWWFrVzJZZEd0?=
 =?utf-8?B?T2RqeTh3RGp0L2plOUFkUm1xWmkxMUJXS2FqdXpyV1pSZHdJSUFjZE4rZ0hr?=
 =?utf-8?B?MW05eG12cDNuTkc4NHR4VHpibWVqR1YvbWI2SVRSMWhyTjFMNHJyQnRrbnZt?=
 =?utf-8?B?YkdJTXh3ZFFKdVBVcWVDSjhIUVdNd05vN3duc2x2QXdudW9EYmlYZ3pFYzg1?=
 =?utf-8?B?NktRNXVaRDU5WXNhcVVNbHRUT2xpUW5GcVNyWk9TT1pjWlVFdWVMcHJmOGZt?=
 =?utf-8?B?T0YvUXlrTFRpQVROMjJHRFZEVzVya0ZPRkhwME5xc0EzMWxISnlZRXhYT0Rh?=
 =?utf-8?B?ZmFYekVncGc2VTBWL2ZremQrVzMzQXlWRXNOaE5FR0NWNGtMa3RMV2N5b2RU?=
 =?utf-8?B?ay9lMk9rZXdZL3o2Zkc1bDY2akZQRldYa1ZwYjgxRDhlMElPaDBBaXVONWVC?=
 =?utf-8?B?dXFvbTBJQUY0U0NOaEx2UEZyRER0anM4MVI0ZVVrZDRMRnFlY0xIT3E5UFkv?=
 =?utf-8?B?emJPZlJxRVZpNUpSelFaN1dCWlh5bUxaYVVnUnFpcmJpMndkbVhLTm10NG13?=
 =?utf-8?Q?fYpXYGszyOg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WC9OU2VpTjdIUDJHOWdCbG1JTFBSaFpBSEtaKzUyaHUyYjF5dzQ0M3hOSHN3?=
 =?utf-8?B?azA2UHhpTHpVcmMvL2h2WnlSYkZlOUk0aEhPMGhCcXBNKzYwM1pQVlIwQ1pG?=
 =?utf-8?B?TkFuK3h3ekxwOFY5ejk4OTJzSHpJeU0xekQwWTlHSE1Falo4ejFieXp4M0Jm?=
 =?utf-8?B?REdsd1UvQmJhVGEvRFZMNkc1dHdoR1pKTTROT2ZVamJZR1RZMXh5VVlSTDdx?=
 =?utf-8?B?eHNCWnhac1pkN2VISGd3SXpxMGEveEd1SWVzRTRKVTI3ZnNHSXFURWhKMGVn?=
 =?utf-8?B?NWY5N3VtZTRpRkRobFgrSWdmV3BEdHVHY3lPOUc3VXdDMXF3SmV0MFhSZTR3?=
 =?utf-8?B?cUNudUFxYUtsaDVIaDJGQ2sydFVMRFpWdGpnbUd4OWtWQ3drT29vbEY1MlEv?=
 =?utf-8?B?cVJldVB2ZnVrdHFwbVBpVkx4d1BxSFlNYlg0MWVKSlpjSzlRRzZaODdsS1Fl?=
 =?utf-8?B?VWtOU1lFSnJoYlh4eUZ0RnEwS2htdXAwTkZOQjV4RFQxYUhiUytwR1pjRG53?=
 =?utf-8?B?Um1zNlFZaE16K3FRN2dabVhSVGNxV0tjV0plSzR1ZnV3dkt4OGw3aFZ1ZDJt?=
 =?utf-8?B?ck5jN3NZQVdXd1RSbHgwVDF6SzBld3RkZXluTjR1NlRZZjhnWXFIeW9rNHNP?=
 =?utf-8?B?SzVMWGlxREtSNnBqZnQweTA5dE4xTFJqeE1pejkxVHdaZHN6ZzJEZFhrd1lt?=
 =?utf-8?B?WjcrR3BwVjM1MnBwSXo0WG5CZmFNMm9aWjM2dmRVd092Ris0aUlWQUJGTDJz?=
 =?utf-8?B?a0hHTHNFQ0UyRnVlN2hpdjZYeUpIV2xnYXY4VUQ5RlkxUVZNMGE5UGt6NVFZ?=
 =?utf-8?B?ODgzd0ZJSS91UnVhWHJpbzNROFFnVWloUUMzR2pDOEpVcDh1dWc1ZEgrN3Np?=
 =?utf-8?B?TVNoNVBITi9qYWR0UUs3Ti84ckdIQWRZK3pVTFhEc241V3QvTlhzazBjbmwy?=
 =?utf-8?B?aW1tS3l5eDhwVWpZelZFVXpvaVh0UmsvRCtQR2wyeGdXc1J4SFB1cXJkc1Yr?=
 =?utf-8?B?QkdKNm9WS01adHFXR001ZUxYS1VIdWhXVjViNzYvSEdJNC9peHJGNDJ3U3lE?=
 =?utf-8?B?eGgxZ2oyRUNDcXdzTEY1QjVEYXRBa2p3V1AybmF4bXdpUiszaExldUFKeCtW?=
 =?utf-8?B?YXkwbWpKQ294MS9pRUhRekxXOEhHSTZZMDJUdkpIdS9UdUExWXpEeTJGK3da?=
 =?utf-8?B?aVRLcEpaZ0FvY2Y0MGJ4ZU40QThvWkVQMW5CR0I5ZmMrVnFZNks3aGN2Rk90?=
 =?utf-8?B?UjRseGpoMmt1TTAzWC9wdGNGSG1FTFhyRXFJK0NvdnAzbi9FTE8vMHcwa1Ju?=
 =?utf-8?B?aHQ3YjFDZXg1aFNDdXF5cUxCbXQwdGVuNUs3NWVUN2tVUktTRnpFM0V5aEtT?=
 =?utf-8?B?dDJaQ1VPeUhWa1hFQjJOaWVGc0svS0RudU8rKzBJYjdaMm5WT1g2bm56b09n?=
 =?utf-8?B?azdOZ0R4c1RNcDl1NXNoWFY5YnYyZ1pvblk2RTVIcGpIaWE1RC95S3hXM21m?=
 =?utf-8?B?SlVDL2FDTEFJd3lFS3NENVdMUXZVUnVZNGhLMFpqQXNSamRTT284VXRCQzhX?=
 =?utf-8?B?bkZTZlVRK2h5eUxSZERWZENLbW5DdzlpN1o4ckV4ZzkzRmFOa2QvREdFUDB5?=
 =?utf-8?B?S0NBQnpXeDFsa3FQL2FscWFhZy9SWEljWHhiOGxTRU1WSXZQZTFIdGJMQXFQ?=
 =?utf-8?B?bjJpR2pCL0JkcGQ0dkZuTkNDNUhlK2tydnBhNEhKNm1uYjB0NG9XSVErcEFX?=
 =?utf-8?B?bllyZk1EWTZ0WWJZWi9Ua0pjV25OZVFGUVYwdm96VkZOdnNsVXhzR09jYy9J?=
 =?utf-8?B?V3BIN3IwRS9VNHBGTjZZL0dSbTZiYnAzNE54bHhNeG1nbzF2V1B5VHlrczFD?=
 =?utf-8?B?aTMySHU0VkkrL0tLWk9mamJlSUFTdS9OeGtnYmU4cElUanBZSlVVcmg1VXhx?=
 =?utf-8?B?dmNseTdUMC9NVUFoa3kwSmpUVkhIaTIvbTMyamNsd1B0bWN4NDBrLzllRGpU?=
 =?utf-8?B?cWlMbTVMVTlMT3VZZWtrVkgwbkROaVlhTGdnT0FBUzh6bzd4WHEvazczSkw4?=
 =?utf-8?B?RkVkUjY2N0V0V1IzcnNRYVdKMGdSbEJLQXNuTURtajllaktmTFl6Q3k2Y1lY?=
 =?utf-8?Q?4EppeI53Tk73pmi8bSNQp94oh?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c78daab1-7bd1-4688-68c3-08dda46481bd
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2025 19:09:33.8754
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KUW9LUp0h5xcCPn/jn1fSP/oRmMwEWZeGgsISrWXIpUl34bkkD4UW3coUeXTxfGzILgWDGHtZGTAu4wyF38XYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6679


On 6/5/2025 1:32 AM, Alexey Kardashevskiy wrote:
> On 20/5/25 09:57, Ashish Kalra wrote:
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> Ciphertext hiding needs to be enabled on SNP_INIT_EX.
>>
>> Add new argument to sev_platform_init_args to allow KVM module to
>> specify during SNP initialization if CipherTextHiding feature is
>> to be enabled and the maximum ASID usable for an SEV-SNP guest
>> when CipherTextHiding feature is enabled.
>>
>> Add new API interface to indicate if SEV-SNP CipherTextHiding
>> feature is supported by SEV firmware and additionally if
>> CipherTextHiding feature is enabled in the Platform BIOS.
>>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> ---
>>   drivers/crypto/ccp/sev-dev.c | 30 +++++++++++++++++++++++++++---
>>   include/linux/psp-sev.h      | 15 +++++++++++++--
>>   2 files changed, 40 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>> index b642f1183b8b..185668477182 100644
>> --- a/drivers/crypto/ccp/sev-dev.c
>> +++ b/drivers/crypto/ccp/sev-dev.c
>> @@ -1074,6 +1074,24 @@ static void snp_set_hsave_pa(void *arg)
>>       wrmsrq(MSR_VM_HSAVE_PA, 0);
>>   }
>>   +bool sev_is_snp_ciphertext_hiding_supported(void)
>> +{
>> +    struct psp_device *psp = psp_master;
>> +    struct sev_device *sev;
>> +
>> +    sev = psp->sev_data;
>> +
>> +    /*
>> +     * Feature information indicates if CipherTextHiding feature is
>> +     * supported by the SEV firmware and additionally platform status
>> +     * indicates if CipherTextHiding feature is enabled in the
>> +     * Platform BIOS.
>> +     */
>> +    return ((sev->feat_info.ecx & SNP_CIPHER_TEXT_HIDING_SUPPORTED) &&
>> +        sev->snp_plat_status.ciphertext_hiding_cap);
>> +}
>> +EXPORT_SYMBOL_GPL(sev_is_snp_ciphertext_hiding_supported);
>> +
>>   static int snp_get_platform_data(struct sev_user_data_status *status, int *error)
>>   {
>>       struct sev_data_snp_feature_info snp_feat_info;
>> @@ -1167,7 +1185,7 @@ static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
>>       return 0;
>>   }
>>   -static int __sev_snp_init_locked(int *error)
>> +static int __sev_snp_init_locked(int *error, unsigned int snp_max_snp_asid)
>>   {
>>       struct psp_device *psp = psp_master;
>>       struct sev_data_snp_init_ex data;
>> @@ -1228,6 +1246,12 @@ static int __sev_snp_init_locked(int *error)
>>           }
>>             memset(&data, 0, sizeof(data));
>> +
>> +        if (snp_max_snp_asid) {
>> +            data.ciphertext_hiding_en = 1;
>> +            data.max_snp_asid = snp_max_snp_asid;
>> +        }
>> +
>>           data.init_rmp = 1;
>>           data.list_paddr_en = 1;
>>           data.list_paddr = __psp_pa(snp_range_list);
>> @@ -1412,7 +1436,7 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
>>       if (sev->state == SEV_STATE_INIT)
>>           return 0;
>>   -    rc = __sev_snp_init_locked(&args->error);
>> +    rc = __sev_snp_init_locked(&args->error, args->snp_max_snp_asid);
>>       if (rc && rc != -ENODEV)
>>           return rc;
>>   @@ -1495,7 +1519,7 @@ static int snp_move_to_init_state(struct sev_issue_cmd *argp, bool *shutdown_req
>>   {
>>       int error, rc;
>>   -    rc = __sev_snp_init_locked(&error);
>> +    rc = __sev_snp_init_locked(&error, 0);
>>       if (rc) {
>>           argp->error = SEV_RET_INVALID_PLATFORM_STATE;
>>           return rc;
>> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
>> index 0149d4a6aceb..66fecd0c0f88 100644
>> --- a/include/linux/psp-sev.h
>> +++ b/include/linux/psp-sev.h
>> @@ -746,10 +746,13 @@ struct sev_data_snp_guest_request {
>>   struct sev_data_snp_init_ex {
>>       u32 init_rmp:1;
>>       u32 list_paddr_en:1;
>> -    u32 rsvd:30;
>> +    u32 rapl_dis:1;
>> +    u32 ciphertext_hiding_en:1;
>> +    u32 rsvd:28;
>>       u32 rsvd1;
>>       u64 list_paddr;
>> -    u8  rsvd2[48];
>> +    u16 max_snp_asid;
>> +    u8  rsvd2[46];
>>   } __packed;
>>     /**
>> @@ -798,10 +801,13 @@ struct sev_data_snp_shutdown_ex {
>>    * @probe: True if this is being called as part of CCP module probe, which
>>    *  will defer SEV_INIT/SEV_INIT_EX firmware initialization until needed
>>    *  unless psp_init_on_probe module param is set
>> + *  @snp_max_snp_asid: maximum ASID usable for SEV-SNP guest if
>> + *  CipherTextHiding feature is to be enabled
>>    */
>>   struct sev_platform_init_args {
>>       int error;
>>       bool probe;
>> +    unsigned int snp_max_snp_asid;
>>   };
>>     /**
>> @@ -841,6 +847,8 @@ struct snp_feature_info {
>>       u32 edx;
>>   } __packed;
>>   +#define SNP_CIPHER_TEXT_HIDING_SUPPORTED    BIT(3)
> 
> SNP_FEATURE_CIPHER_TEXT_HIDING ?
> or X86_FEATURE_CIPHER_TEXT_HIDING ?
> 
> In other words, mimic X86_FEATURE_SEV which is a real CPUID bit and FEATURE_INFO mimics CPUID. Thanks,
>

I will still prefer to name it SNP_FEATURE_CIPHER_TEXT_HIDING, as the SNP FW ABI specs names it as such
and it is a SNP specific feature, prefixing X86 is confusing.

Thanks,
Ashish
 
> 
>> +
>>   #ifdef CONFIG_CRYPTO_DEV_SP_PSP
>>     /**
>> @@ -984,6 +992,7 @@ void *psp_copy_user_blob(u64 uaddr, u32 len);
>>   void *snp_alloc_firmware_page(gfp_t mask);
>>   void snp_free_firmware_page(void *addr);
>>   void sev_platform_shutdown(void);
>> +bool sev_is_snp_ciphertext_hiding_supported(void);
>>     #else    /* !CONFIG_CRYPTO_DEV_SP_PSP */
>>   @@ -1020,6 +1029,8 @@ static inline void snp_free_firmware_page(void *addr) { }
>>     static inline void sev_platform_shutdown(void) { }
>>   +static inline bool sev_is_snp_ciphertext_hiding_supported(void) { return false; }
>> +
>>   #endif    /* CONFIG_CRYPTO_DEV_SP_PSP */
>>     #endif    /* __PSP_SEV_H__ */
> 


