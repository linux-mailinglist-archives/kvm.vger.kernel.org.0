Return-Path: <kvm+bounces-49370-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 124DCAD8336
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 08:24:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3CEFC189348B
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 06:24:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12E2F2580CB;
	Fri, 13 Jun 2025 06:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JjbfR1+0"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2053.outbound.protection.outlook.com [40.107.243.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54CCD253958
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 06:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749795852; cv=fail; b=uxuMYvdzmUnJKUrceSes+PG5pOFrRz9usgcNQImH1n1wH0flqDwk6g0GuSvA0//O2fJmwlWyIFDepivH8WCXE/XewLz+K9pkayhVU9PdzdfPSP4g7AqVdaaZvjDxiaze7hC+YOMpnmeSJEeuIBZUTJX86t7U6yF6VFYLkrwaxWA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749795852; c=relaxed/simple;
	bh=aCKoUMwrDMZSks6B9OJqg22J3nUkZV7n07I9Dyw5hgs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HIaMu6BVwHqn9pPMeHKGRAy598G8LSLWe7M+3LNzI69/MvoOuZ/d8bwzDdtdmnHwpVgPsORAT6iTN+2DjRcc3QozVB7VNCnV/aeUfSQveWJufEimC6LS7XN/CbC4s17rraX/my0+Twv1B37UspJK2LIxd01IxtxmiJxvUOZU1TE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JjbfR1+0; arc=fail smtp.client-ip=40.107.243.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ofW/rIx//hT/q7Rh4Hv7vnmy0K7CTgdF8rntIrPiVs0CRjinNu6WzKsE+R7stjuXM7YykGmQZWLcE4qP9AlxZzkbqvVD/KOwsCFrzP6FZzK8p+9rbLBVU0IALMtfGfhhVZ4pbF8CWdMIr89rokSH06wpgqcF7ixQ6QQkQgvaQLqPEjWzJffCMn3THtSGsilio0kH10rbBmfNslJXQjwVpNh9OxMygSL+ST4q8k0SB5bl6IaJuumee65R9x4C1sCmELoyEkNd0QGdG5aUadW9TAOZuHiEeTlSJH4xYOqv+jr3s+7N8JCJ3UTZrn3DwkTXL2KJTGVKtNgtTqEjDBh2jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZWa++MG+DjlROpgoKuq5Ay9AWZHXavVXeNwBYROAEts=;
 b=OH611uwxry0Cayx3aMPbHSrQ+Y8ZH+l2k+3YcqO4D6L7lLCSs/hmlOKmLiweYSeePpj7GVw2JP9n025jHQrGxtcrO3lEQj2PCaLMXVrSFD+wRguNVP98pBIafuNTidLueNMuoTwSOKvEdEzqnm38AD2V6V+I/Nz1wEZhetCarQrsdMkhldcPsoGyeX2Uh1Nmq/vGagzu/ejmD2uoDeHtYDq4HgsfXmzl1y2owdilk6DbEcfoUBRR5sVEocFlvctNI97jTZAmIvetDnh30qO8cx7UHW+0AAJkgst2SFB6tTPIsENgmYOAzin6xH5joJ4VvZqDS8NAr7yCwAFXqOMGjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZWa++MG+DjlROpgoKuq5Ay9AWZHXavVXeNwBYROAEts=;
 b=JjbfR1+0gLUPnZf+U9oWSNKPUB9vNzFnkTH8ZWOFK/HRbZ5tK2cDFfSESPZELMyuHgg4FxTtFFKLgQRWEZ0xfarXGeXZJiHA46QCPZEju08ST8z0meaNLWX20KS/dVAERj6jG8DhJjANtJ+WYrRz3ybL3OZZQi1g9oUTBhCZSGs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5712.namprd12.prod.outlook.com (2603:10b6:510:1e3::13)
 by DS0PR12MB6392.namprd12.prod.outlook.com (2603:10b6:8:cc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Fri, 13 Jun
 2025 06:24:08 +0000
Received: from PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291]) by PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291%6]) with mapi id 15.20.8835.018; Fri, 13 Jun 2025
 06:24:08 +0000
Message-ID: <a561b3ed-56bd-410a-b22b-ad4a940f2ead@amd.com>
Date: Fri, 13 Jun 2025 11:54:01 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 06/14] x86/pmu: Mark all arch events as
 available on AMD, and rename fields
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Dapeng Mi <dapeng1.mi@linux.intel.com>,
 Liam Merwick <liam.merwick@oracle.com>
References: <20250610195415.115404-1-seanjc@google.com>
 <20250610195415.115404-7-seanjc@google.com>
Content-Language: en-US
From: Sandipan Das <sandipan.das@amd.com>
In-Reply-To: <20250610195415.115404-7-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4P287CA0093.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:268::13) To PH7PR12MB5712.namprd12.prod.outlook.com
 (2603:10b6:510:1e3::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5712:EE_|DS0PR12MB6392:EE_
X-MS-Office365-Filtering-Correlation-Id: cfea5a3d-ce7a-48a8-2694-08ddaa42e6f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TW9QVlo1d0c4UWNWV1VLalFLV3ZOeWxRSVl3eEd1Ni96R083OW5ueEE1ZE4w?=
 =?utf-8?B?eW5lVmduR3hhMkFVRndVMGhWRFdCNE1iSDB3cjF5YkNRNENzTE1pMmtTVUpJ?=
 =?utf-8?B?Z0lmWDVORUJud0xpd2dTMGZicEU2K0VnZXBndFJvM3ZyQkhJUkNrcjNNWFNp?=
 =?utf-8?B?T1ZPZGpnbWZaRGc0K296alV2MWJ5cDMrb3E2Z0prQkNLRmljNzc2NHhxVkwr?=
 =?utf-8?B?anVSbXJzV1NjWWNkU29hV1FWblYwQlBLdzlzampqS2xlRnpzNnZDYXV5YS9W?=
 =?utf-8?B?L3FUYTFJQnpsWjhleVpPaUJQaDQrNUtFYVZSOTVwNTZMSWRDUENRb0V3SC9z?=
 =?utf-8?B?T1VnbDA5eVpnYjZQbjMrTXk4aHUrc1BKTkNTM0VwOUs4MWRlMGJiL05qS3Vo?=
 =?utf-8?B?aVpBd29KRFJQdGswMkhpVEYwekRZZXlOWmFoNTlrZHhGVDRLNGxOdUxLd3dr?=
 =?utf-8?B?Y1ovTnMvY21SMkxpdkRZUGZhZnJCVTQvMHd6d1A2QVdmamJtZ2REOXJBQnha?=
 =?utf-8?B?aFBIMDRoVEtwaUVYanR4NjRYajVEYWxMSTJid204eGR3YTBEaSs1NEJ0Nmxl?=
 =?utf-8?B?dlcrUjNyQUVWOEd0QkpMU3Bid1l6ODRpRTBFRjc1NXJkcHNKY0FrSXlHbXJW?=
 =?utf-8?B?dThreGphUVg2Q1NXTGJBYWxhSithaUZsZk5nemFDdGVSQURXbGdSYjlldU5a?=
 =?utf-8?B?dEJFak9aRHVLc0l0dWgwdXVLWm50NW1iUTZ6TnVhVzZoaURVb0Y2UUpvQ2Zm?=
 =?utf-8?B?dGJGREhlYzNWVkRuM0xsTGFiYldrR29uc2dWa1plQlExV2gzaFlJbkp5cWRS?=
 =?utf-8?B?TmV2WHdJNWVWTUVXWVpIRHlITm1PVERabnMyZjB2OFNCcG9ybVo4ZkttdDlD?=
 =?utf-8?B?V0o4Z0xQUW9hcWtBeC8wZjFJUlZ6SWpEVmV2aUxCRjVOSHJYaGpJaU9EMVhB?=
 =?utf-8?B?WnpEb0lCbXU5MTlXc0FsM2xISzhMaS9XWW9KcjFzNzFoMDNTOGJsU0tUakQ1?=
 =?utf-8?B?bkZUS1FhQlJCK0ZGVDBpd3VhcnhWUUg0eGhBMGRrcDNrYmdweXRnRHgrQmI1?=
 =?utf-8?B?SUlNcmZUZXVvb0wrbXd2T3k4QlVhQS9ubE5WcDhOYnhmcjZuMEVkNjJUa0lh?=
 =?utf-8?B?RkQ2K1VIOE1iZHFGbjJEOTI5cXpjclhwM1FUam9nblZwRmVFNmQ0QkdYVlJO?=
 =?utf-8?B?ejJWRlNEajB3dEZRdk9LeGQ4T0FqMFBlS2crb0M3Sm5iVUU1U0ZjM2Q2b1NK?=
 =?utf-8?B?QUFoK1FpU2RFWXF6eFVVS05WUXozUTRTQTBGZDl1R0lBZDVnQWxORzNpcis5?=
 =?utf-8?B?U0dlSXU3LzhWWGxCRUNZRCttUHZZRUFhTktHVE5BellHSlJqalJqRnZUYkNt?=
 =?utf-8?B?cjdoTndFK1BnbS8vaitSbzFoMm9KRDE5eHE4N2hOeExnZkNadkQxY3ZOaUJJ?=
 =?utf-8?B?QWdEeFZHTW9LTG11ajhYNThiVVdPbDRWYnE0a3FOcG85Q3dVcmJrMDRnU080?=
 =?utf-8?B?aEdvRm90M3Bld0syS3N5bW1BZXV0Q3lkZnl2cEh2dDNOMk5iTGd0ckRXVGRH?=
 =?utf-8?B?Ny9lRVZRYkZnRzkwYk41aU9SZURCRUZGbDJ3emZOZ2lvUkc5YVFyR0ZFdDRK?=
 =?utf-8?B?VTdWV05RYzYxYi9pRXFCT05RaGpCYzN6RFhBSW5TNHQrQ2Ivb0RRd0c4R0Fa?=
 =?utf-8?B?S1QyS1lzMndCc0Z2amt1dzBJckVKWk92WnRMSGIrNXpDNU1HTEdOclJ0eUoy?=
 =?utf-8?B?Ni9GQmtRY0VrTFpVR3RwM2NoeDFtRVowWkpRUjBoNy81QWVJRzFnanc5WEZx?=
 =?utf-8?B?YVJRdWZaYlcrWGRBSTBVcmVKaWVuQWoxQzRVYmtSZk9UZXF6RkVRMFdmRjlx?=
 =?utf-8?B?SURUUDRPaERpQlRSK2Y0N2xjekZrNUxGZjRCK25mVnBJVmF1cUR1L2diVko3?=
 =?utf-8?Q?mO6xdTcdSVY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5712.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eVVxejJQNG1iZ3NPZ0I1SnM0enpzYUpReklVY2ZzSWV6OWJzd0dPK2ZYR2lT?=
 =?utf-8?B?NGZEY0JIeFFKdzNSbTB1aUozZjk1bDlhQ0l5YVlNWUdDMFNEOUcwaVo3QzYx?=
 =?utf-8?B?UTdHNGp4RGE5ZmNOWTltbTVtT1BHUldZRTh6Q3dhUno4cExNUzBQclZFdTc2?=
 =?utf-8?B?a3BLT1ZoNDJScUE1UlRMQ3ZvRjlrWGRYQncwcXhXNG9EY05ZQkkwdGdZY25V?=
 =?utf-8?B?KzZnM2ZVSzlqY3lkcHVjS3dKd0tOcmdDakVKS1R2MUhXWGlWSnZQdnQ5bnlN?=
 =?utf-8?B?b2tqQm9LZEdZOS85bTZaNC96ZXZOVjY1RlNHWnJvZ3MrTkxMemNBR1JCVkpQ?=
 =?utf-8?B?UTVBTlc1K2k3MndxTmJtUzBGR051YnA0MkloQUN1a09yZTZCaEtkdnQyeXkw?=
 =?utf-8?B?SGNwQS9sbGFUZXdwS2Q4ZmVLenR4SjdCUmY5WXJnREZJWGtmYjJzemV0TkdU?=
 =?utf-8?B?bzdlRkpBU3Jxbkc1VlBvNVQvV1lweWhMOGhLM2dXL1k4b3krWU11ZVdDTEpF?=
 =?utf-8?B?S3dkbGdrYis2d240akd1Ri9LUldFRFR0SnE5REJWeW0rdkdQSjJuKzB0OUQ1?=
 =?utf-8?B?YXpaRVRoU3Q3RDdoa1kvLzU0azVTeTVRS1JkZUc3bm9JVzR5TWoza21XdS94?=
 =?utf-8?B?OXlqbTcybW04YjFmWWY1dmtTQWl1cE04KzhtaCtkLysvSm51L0FVR2xPWDdJ?=
 =?utf-8?B?RUFFenpvU1A1UkVkaWxXZjQ0N2JnQ0hNR29SbXI3b3ZNemNsTkIrTVRmRHJ5?=
 =?utf-8?B?SkxqcHlBNk9UN21jMFdRcldyNDZOREpSVDFmQzlDcHZvQ3hsaGIxelNtbTJD?=
 =?utf-8?B?TkdOWGRoK3M4OTB0REtHb2NTZDRRN2ZZWGR2eWJpbXlrUkRQKzlOZkRMMm1R?=
 =?utf-8?B?WlNJemIwa1NyUGlCUkF1QnVvS2tiallEbmFZQU4xU3hYV1psejhUcUJYckdS?=
 =?utf-8?B?NVgzWSsvZjllay9HcmM0aVBLc1c0TlpNVVZtcllVMjFjNWErQ2NycmxKWFAz?=
 =?utf-8?B?SG9FQ1VPa0U1ejQ3V2dVSnd6Qk5OOFRrZzdnY2VBeFd6d3lDOXRiOWlVazBI?=
 =?utf-8?B?Nm1FeStxRGNCekY3SG1panNBRERKZHJaR0s4dGVza2tmMzN6UEk1UkJhckVX?=
 =?utf-8?B?cUg5QUI3K2ltVHJHREtHRFZLRnM3ZkVMZkRDa3VUOW1mVW92N0VtdWtFOGox?=
 =?utf-8?B?NGVpVCtLUUcwWnBSRnp2QnArUDZ3cmlsSXR3bU9Hd2IvcmZmK3Y5R2J5cDZE?=
 =?utf-8?B?V29yTmg5ZVRqOTEwYi9kV1dWQmJwM0F0RkU1a1IzZUhrOFd4Ni9TZVk2MDF2?=
 =?utf-8?B?eldlY0pVbkpvMWRMRUo2OEZWTWtHZGlSV2h3L2cxN1RZZlMxM2JycFF2SzBD?=
 =?utf-8?B?cWxaYlczQ0o3T1hvMjd1YmkxdEFKV0xrNnBlaGpLL1UwVWJGS1lwNzd4ZkJX?=
 =?utf-8?B?TldiYmgwN1R4cFlGblBTUDRwam9mdHlwYi85eHh2ZVAzK0gyaVFVampqUDJI?=
 =?utf-8?B?b1BrSldIaVFzNmFTbUFpR0V0LzdqbVFDeXVqYUNxc2dRblN4YjRHbGNaZmxH?=
 =?utf-8?B?bVcvWFNCREVKR3BIV1NmVUhFNm1MY09FL1hNbSs0eEtEdmxFZWdla1pKVnJ6?=
 =?utf-8?B?VUVHYjZKMWJYMWRXOXh0UkpwZ0xrVGRmTGZLUXpEZ284L2NzRmI1MnVjakdD?=
 =?utf-8?B?eUw2SE1KWDU4azNFcm1xcGlCaUJCNHZXWG9hWXdZaXZaWEU0M2EvTTNCMWdI?=
 =?utf-8?B?QTM4NjBhY0hHMk5pY1E3VEsyMVVoaU9rZnJMQmRCYkNJL296YUFjaWVlaFo4?=
 =?utf-8?B?UjFOdlJINlU3eWFBOXFUS2J1R3FNVjVUVkNvOU9zQnZnL0lnd1dZRnRIUzhV?=
 =?utf-8?B?VjNXWU8xMDRFSjlkbnNwNmNWZkQyNW1SbXVlN0JkdDM3UWNnRzJQZzVCYVhi?=
 =?utf-8?B?dmRHUDZTdi8rTVgwb2tXUGprMi94SUZ6Z2VhaW1XNDhtRmdCVE92NzZ0dXkw?=
 =?utf-8?B?MnA2MGtXenFUVmhEN2l3TlppNU4rQy9IanJpK0oxNW56UzJEQWdrY1F4NUY2?=
 =?utf-8?B?c1JydkR4VDBLamVhaXBNMG4vZ2s0R0xYcHFIeHZGK3dtOU1mMEc0UHdQY2hm?=
 =?utf-8?Q?9ysnno8JdzJM2QgEMV2zUp6no?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfea5a3d-ce7a-48a8-2694-08ddaa42e6f3
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5712.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 06:24:08.0305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DP1dvK5+ioJgwY8z1aFUt4I/OHcJEfMeXXqqMLqTchBQSlvZUtPflAUXrFsADuRBthHNOogpCgyUU3Lihf24xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6392

On 6/11/2025 1:24 AM, Sean Christopherson wrote:
> Mark all arch events as available on AMD, as AMD PMUs don't provide the
> "not available" CPUID field, and the number of GP counters has nothing to
> do with which architectural events are available/supported.
> 
> Rename gp_counter_mask_length to arch_event_mask_length, and
> pmu_gp_counter_is_available() to pmu_arch_event_is_available(), to
> reflect what the field and helper actually track.
> 
> Cc: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Fixes: b883751a ("x86/pmu: Update testcases to cover AMD PMU")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  lib/x86/pmu.c | 10 +++++-----
>  lib/x86/pmu.h |  8 ++++----
>  x86/pmu.c     |  8 ++++----
>  3 files changed, 13 insertions(+), 13 deletions(-)
> 

Tested-by: Sandipan Das <sandipan.das@amd.com>

> diff --git a/lib/x86/pmu.c b/lib/x86/pmu.c
> index d06e9455..d37c874c 100644
> --- a/lib/x86/pmu.c
> +++ b/lib/x86/pmu.c
> @@ -18,10 +18,10 @@ void pmu_init(void)
>  
>  		pmu.nr_gp_counters = (cpuid_10.a >> 8) & 0xff;
>  		pmu.gp_counter_width = (cpuid_10.a >> 16) & 0xff;
> -		pmu.gp_counter_mask_length = (cpuid_10.a >> 24) & 0xff;
> +		pmu.arch_event_mask_length = (cpuid_10.a >> 24) & 0xff;
>  
> -		/* CPUID.0xA.EBX bit is '1' if a counter is NOT available. */
> -		pmu.gp_counter_available = ~cpuid_10.b;
> +		/* CPUID.0xA.EBX bit is '1' if an arch event is NOT available. */
> +		pmu.arch_event_available = ~cpuid_10.b;
>  
>  		if (this_cpu_has(X86_FEATURE_PDCM))
>  			pmu.perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
> @@ -50,8 +50,8 @@ void pmu_init(void)
>  			pmu.msr_gp_event_select_base = MSR_K7_EVNTSEL0;
>  		}
>  		pmu.gp_counter_width = PMC_DEFAULT_WIDTH;
> -		pmu.gp_counter_mask_length = pmu.nr_gp_counters;
> -		pmu.gp_counter_available = (1u << pmu.nr_gp_counters) - 1;
> +		pmu.arch_event_mask_length = 32;
> +		pmu.arch_event_available = -1u;
>  
>  		if (this_cpu_has_perf_global_status()) {
>  			pmu.msr_global_status = MSR_AMD64_PERF_CNTR_GLOBAL_STATUS;
> diff --git a/lib/x86/pmu.h b/lib/x86/pmu.h
> index f07fbd93..c7dc68c1 100644
> --- a/lib/x86/pmu.h
> +++ b/lib/x86/pmu.h
> @@ -63,8 +63,8 @@ struct pmu_caps {
>  	u8 fixed_counter_width;
>  	u8 nr_gp_counters;
>  	u8 gp_counter_width;
> -	u8 gp_counter_mask_length;
> -	u32 gp_counter_available;
> +	u8 arch_event_mask_length;
> +	u32 arch_event_available;
>  	u32 msr_gp_counter_base;
>  	u32 msr_gp_event_select_base;
>  
> @@ -110,9 +110,9 @@ static inline bool this_cpu_has_perf_global_status(void)
>  	return pmu.version > 1;
>  }
>  
> -static inline bool pmu_gp_counter_is_available(int i)
> +static inline bool pmu_arch_event_is_available(int i)
>  {
> -	return pmu.gp_counter_available & BIT(i);
> +	return pmu.arch_event_available & BIT(i);
>  }
>  
>  static inline u64 pmu_lbr_version(void)
> diff --git a/x86/pmu.c b/x86/pmu.c
> index 45c6db3c..e79122ed 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -436,7 +436,7 @@ static void check_gp_counters(void)
>  	int i;
>  
>  	for (i = 0; i < gp_events_size; i++)
> -		if (pmu_gp_counter_is_available(i))
> +		if (pmu_arch_event_is_available(i))
>  			check_gp_counter(&gp_events[i]);
>  		else
>  			printf("GP event '%s' is disabled\n",
> @@ -463,7 +463,7 @@ static void check_counters_many(void)
>  	int i, n;
>  
>  	for (i = 0, n = 0; n < pmu.nr_gp_counters; i++) {
> -		if (!pmu_gp_counter_is_available(i))
> +		if (!pmu_arch_event_is_available(i))
>  			continue;
>  
>  		cnt[n].ctr = MSR_GP_COUNTERx(n);
> @@ -902,7 +902,7 @@ static void set_ref_cycle_expectations(void)
>  	uint64_t t0, t1, t2, t3;
>  
>  	/* Bit 2 enumerates the availability of reference cycles events. */
> -	if (!pmu.nr_gp_counters || !pmu_gp_counter_is_available(2))
> +	if (!pmu.nr_gp_counters || !pmu_arch_event_is_available(2))
>  		return;
>  
>  	t0 = fenced_rdtsc();
> @@ -992,7 +992,7 @@ int main(int ac, char **av)
>  	printf("PMU version:         %d\n", pmu.version);
>  	printf("GP counters:         %d\n", pmu.nr_gp_counters);
>  	printf("GP counter width:    %d\n", pmu.gp_counter_width);
> -	printf("Mask length:         %d\n", pmu.gp_counter_mask_length);
> +	printf("Event Mask length:   %d\n", pmu.arch_event_mask_length);
>  	printf("Fixed counters:      %d\n", pmu.nr_fixed_counters);
>  	printf("Fixed counter width: %d\n", pmu.fixed_counter_width);
>  


