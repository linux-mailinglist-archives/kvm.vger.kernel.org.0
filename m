Return-Path: <kvm+bounces-54523-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 23DB9B22AFA
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 16:49:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DCA113BA3D4
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 14:41:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8F1E2ECD26;
	Tue, 12 Aug 2025 14:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kVy+PevG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2056.outbound.protection.outlook.com [40.107.237.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20382EBBA8;
	Tue, 12 Aug 2025 14:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755009631; cv=fail; b=kNSLwLsEH21yhzMC6DeQsVGUYF7Lq9TOmXPZk/GS2/nR1vdF1xRDr+8thDgkBPQ2QwC0Sry62pXpSrTM2GyLUg0Lc/9RA85RyD4v4AbDVPH76qZGK5QYs5ZpUn2WXGvgIBMzpBnKX9nsdZ4qyTJBuyPYUlADMZhp38FtD79X990=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755009631; c=relaxed/simple;
	bh=987dTLOpEAoe0XT+FlfL2xr/6eC+7X3IGeZ7CasgRk4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IzdlLNyWN71xlXc59Sx+iT0BkZgxUGbkartbSPg96be9zM0adrVKQM/BooYewQUrmtaae8DB2jDaeA4XaViM8YL9XTczhsEJYBuHyH7UYMF0O90Gln8566Zlh8XXoLX+X9Ievdklq6YeUIc1G/pD0xp1DTkhRrxkYCCj2pcH+jc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kVy+PevG; arc=fail smtp.client-ip=40.107.237.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fUYr0t/yF3PwlSSYVM3lO9rkTikowYG1XaL7lEcf0O607JA2cti0MoJtbQvNdwn9pd/aasBqGkFG9hhrzoHL418zHIO/tHprrHuNBcnTKqLEtp/O+yf78dJey4tW60QF9StXdyET0GI8KppWQlsUKuIZWk2YSBGcY/uTbNLU6bM9X4lk0LsHBpOFfhimkuy1bOO6ynnea6UHB4y4W5XVekiU7S5407QzDqnA2JQmJFTxpXey1O59GcrRAJf1FhxsYrKBG6W04PU2563bpO4SJHkt1PF+O7fcpPPFxr66j1AJio5QoY5DSOg8Sh1O3zWqjptsmhLSNrgFNNNnWyzyUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7YukzyXZMenxabBH0+hrCkfb7JbtnkGqs/QxakqEavw=;
 b=DqKGnARTbU+9mOVWidLW5UzNiwNmBmUV/XOLm/x3QrBQUmtfb0pGO1bHetjTJEgkNErqs4aPpujI4its869aGw8DNsqQQaEh9KsZyBEnHwkdXIjhtUQl7wg4Z3Se4MgsZNoTsFQFKOSd/YW6iuC15r20bkUPQnwb1LAjllfzQqC9uv0T6IuRvmcA9tKJz0953jct6hq6X3Ha+qDg3yOMJA8NW1YCYAIMb8ulGDc1K97IyUf7tK7OephJn322ksE2OW66DphB2s2vGk3rLU1Yzd858IEC+mhu354WioKFGLa66Wp4AXzWFjprIEh7B9+QIaB5nQHz0hIC4V3f/Nd1/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7YukzyXZMenxabBH0+hrCkfb7JbtnkGqs/QxakqEavw=;
 b=kVy+PevGJOxox3ik2RgP8rlp4DZNEZBQxvsnlpnMZNFIVhCYXjBz43C08L37ZcAC1gqx3AxQR+2mO3pCjFCjK+fSC0RR1V2N2WsLDdq61z8+4GvQfXyvD0Ppn0fLx6R0x1VfBpRL9ut96XhcwZx7aV5YXauMsi/wOyT7Bv4J2HA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by IA0PPF4D923B935.namprd12.prod.outlook.com (2603:10b6:20f:fc04::bcd) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Tue, 12 Aug
 2025 14:40:23 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%6]) with mapi id 15.20.8989.018; Tue, 12 Aug 2025
 14:40:23 +0000
Message-ID: <5a207fe7-9553-4458-b702-ab34b21861da@amd.com>
Date: Tue, 12 Aug 2025 09:40:17 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 7/7] KVM: SEV: Add SEV-SNP CipherTextHiding support
To: Kim Phillips <kim.phillips@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, corbet@lwn.net, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 akpm@linux-foundation.org, rostedt@goodmis.org, paulmck@kernel.org
Cc: nikunj@amd.com, Neeraj.Upadhyay@amd.com, aik@amd.com, ardb@kernel.org,
 michael.roth@amd.com, arnd@arndb.de, linux-doc@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
References: <cover.1752869333.git.ashish.kalra@amd.com>
 <44866a07107f2b43d99ab640680eec8a08e66ee1.1752869333.git.ashish.kalra@amd.com>
 <9132edc0-1bc2-440a-ac90-64ed13d3c30c@amd.com>
 <03068367-fb6e-4f97-9910-4cf7271eae15@amd.com>
 <b063801d-af60-461d-8112-2614ebb3ac26@amd.com>
 <29bff13f-5926-49bb-af54-d4966ff3be96@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <29bff13f-5926-49bb-af54-d4966ff3be96@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA1P222CA0107.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c5::28) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|IA0PPF4D923B935:EE_
X-MS-Office365-Filtering-Correlation-Id: 86502b56-7243-43ca-f7a8-08ddd9ae2b4e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UGw5TnJOcW5UYXNBWlR2ZE9hUVhWM3NPNGliVko0QkFjOUNzVGNEa1QyYVFK?=
 =?utf-8?B?bldJQVc0RlllVnhPQmNiV1E3MmVrRGIxZDU3OXRSaWVkdEd4OGpBWTh6SjRu?=
 =?utf-8?B?L3o3VklKR1NvR2ZnVzB5ZnJTV2h0clhWTkxMVTVsdTFqTEtiaVJkbHVuU05v?=
 =?utf-8?B?QkpJVkhFQkVXc3RET25zbjFhU2g2ekRwcHE2ODdiQ3pwV0drYlNnV2xjUEYw?=
 =?utf-8?B?Nng2SWZ1TDU4UW42Qk1Na2s0Sk9KNTlxM1ZGQXA5OFI5dVZXZkpVMnZKVlNs?=
 =?utf-8?B?SzZMbHRkSHUvRUI3VWMxcks0VjVYRm1tMFZEMHA1a09oYWNjOFN3a2dZbkgx?=
 =?utf-8?B?VTZoRVdEYVEvZE5pNW4ra1FvUk4vVzNCZ0Z2V294MWpsNUYwVXBSUzRMYlVQ?=
 =?utf-8?B?UW1uNWVaTlVyNDhRNkdBY2FseFlzaTRnOFpYQWllTUhkNS8rM2hXVURjaGZV?=
 =?utf-8?B?YXJwcWRqb1lqYXhORXc4aTFqaVRiRTROUjdKdUt2dWV4d0dyTEdOUFRRQW5C?=
 =?utf-8?B?RENMNkh6enJnRlV2dFQ0Z3dEUy93VnhBUlI1eGdqR0hRSVVWWnF6ejdkYXJD?=
 =?utf-8?B?TEVvWUpZcGJURW5VTndMOXU5YlVFd3F6Y0JBTzYrbHF6UFoxOGI4dHFyS0hi?=
 =?utf-8?B?bTY0RnU5SDJDRW5KblNHSUk3c1g2TS9SajVPODVqcnFHL0ZoN3FXTVRZcFNp?=
 =?utf-8?B?Y3J3eDRjTmZ5QWFzWjExbzc0NHVGT1c3ZkJ2RXh3RWpqVVpxT0hEM2tqc0pQ?=
 =?utf-8?B?VmdEcEVPQklkcWptWEZ0clArMGV3QnNBV3RrZE9oaENkNGF5YjBLNTZIMytl?=
 =?utf-8?B?cGFoWlJqMEdiL3p2L3RxV1lDQXU2eFpaeWl1UWpBdkJMbDBMU2F5Z3l3L1lD?=
 =?utf-8?B?bU5laFBmWU1qeWk0WmlxQlNhMk9oOG5zQjB3S1c3ZHk3Ti9YeW1Gb25aUnpZ?=
 =?utf-8?B?Z3g5N2tpSzI0eitjS2huWUdDbTZiSWt5a0QvRVdlOWMzNTQxR0JBcktMZlZa?=
 =?utf-8?B?eXRvZWNvS1YvZ0p5bFA4VkpaWWh4MnBucGpwUVRGaU9pbG5NcmZ3M3ZkYndZ?=
 =?utf-8?B?SVMrTXl5L1JDTmpnaDhFdEh0cDk5eThHWE1HbVJLc2JjVkR3NjRteUZXZDZF?=
 =?utf-8?B?N29lVHM5cmlWaS93TmJ5YVpGeGVqRUE2VHY4N1h0TC9qWER1U1BVZTR2b3Iy?=
 =?utf-8?B?WEo3UXpUdmsyaHNMSWtuWFJCT013VVpTSHdlcVBJWGJDZzJwa1NSQlNDNi9K?=
 =?utf-8?B?c2FvUmVIVXNNUldFbkFrWWt2SC9Ba05yZEMwOVlDNnhZRGVOb1kzKzhhd2gy?=
 =?utf-8?B?Y1pQYVpjQ2h4VmZKMEVFS2puL09TWW44dEl5UUpPcUFNRVpCSllZMnhJZUdt?=
 =?utf-8?B?RHRQMEVqbGtsRmwyTE56Z3pyNFAreUlpSGRpTmhscWY1Rmd3S0RQbjcyZllE?=
 =?utf-8?B?RXRraEdaeGloUklwNCtqRGhOTytYRTl0ZnZmejVNQjZMb0FmbStaNDduVWJC?=
 =?utf-8?B?K3lJUWhOQVZSaisvUTJYSUkwZlBzWGFUNElGZkl3UUI0WTNCOG5wTDBNM2xR?=
 =?utf-8?B?dXRjR0wvVmlhc1o1YTBUc04yVVAvNXZxTkdIaGFHTUljWXpyVFBCT3ZyOUNW?=
 =?utf-8?B?MmFUbkVyVXpqdkRZaTcxREJPL1RoejFySUg2SWFhMXF3YlVVVGI4eDAyWnRD?=
 =?utf-8?B?N0VnY1FaL2VSc0NTT0tDNVdEeUwza3ZGaXpJWkJlQW1Lamc2VUFvWjlYbGJD?=
 =?utf-8?B?V1VZY2VSQysrNEZmdXprVnVFUGNsMlNmNkhlUzdaaEQyUWdYQ1huZ2J2TktU?=
 =?utf-8?B?d2x6TDloeFVLWmszeDI4cmlFQmg3b1JRNlA4Z2ZVb1ZXRU82TkhWVEJocXRw?=
 =?utf-8?B?em9QUUJoV0VXMFhUN0R3ZWZ0MXF6Z0prbXVwZDZwcWdrY0VQa3BTWkRLeVRV?=
 =?utf-8?B?Nlhka1dscmZKRHlSR1B4S0g2ZDQ3T2tMQWwwY0xldWtodnplS0N4am9vMHdm?=
 =?utf-8?B?WnhtdHRpNkh3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Vzd6WFBOSGVFdjRTcUhsL3E2MEd1bE5YRVhXV1pBRUdmblJJUk1nbTQ2V0hC?=
 =?utf-8?B?eVVhMnZiQzhuNXp6aTVJbERJekUvSXJ2aUVjYkVYd2twZGpBZ016bWszZnNw?=
 =?utf-8?B?RjBvck00Zko0b3pLNHExRXlKeEF5TmdBcCswbytianZnZmJkNFNNZHUveFY2?=
 =?utf-8?B?d2dqT3Y1bUsvSXZwd01lM3AvZktwSThvVDd1RXdBRk1zUzJWaTVPU1ZSbUJ5?=
 =?utf-8?B?ejVXV0FPaDNjeU1HSDYxT3ExSncyNjlYVS96czFkaE9RNnRtTzRId0k4TE5B?=
 =?utf-8?B?bHNsWVRBb09aZEtHR0s0THozNCs1OGtpU29MRTRjRmY0VFhaTzFGRVRDVmJl?=
 =?utf-8?B?QVVJZStKOEhNd0IvSnVzN1l6SEthSmNRZnlqVWZjazltZWk3NndIOC9nV2Fj?=
 =?utf-8?B?TmVhUUl3WU9sSTZxVDJQWWVVUUdiRmx6ZSs2c29KSEtGdzdRVlNKYUVSbFgv?=
 =?utf-8?B?Mm9tWEhiWm53WWkvTHV5UDhZTi9uSU4rb3NvQ3NKeExFQ1JYRFViaW5CNU1W?=
 =?utf-8?B?c09reTRZYVNxdXRSaGRGYmRwMEtBaGdVbmlSc2RHVjZxYXlBdzBXMG1LM1dk?=
 =?utf-8?B?RDBvb04xOFFzQUxmekJYa1hTQkhWeTNNNDRvWlQ2VjFEVWZpbHVJSW1ZZVV5?=
 =?utf-8?B?NXNocmxvL3pXQTNycFRKYWp0alNPZ0syV21JLzRlb3JFbkVMeTk5cE0rY2Ns?=
 =?utf-8?B?WDhtRnRsR051TFBqZ2RXNE9YR0NVSXFZOWlXUkV1RGdnb3IwZGdYRjhOUVZq?=
 =?utf-8?B?NXRaZ0JPTjBrTTlhYkpSK0d4cUxVMWVUbWRGbnlIaXVpMjVQUzkwTWl4eEJG?=
 =?utf-8?B?MFAxQXcyRExRZDRtKzFETGJKZDBDMkxacFExWHM4Y2IvamF2RWRIVG1UNHpG?=
 =?utf-8?B?eVIwU2hmVXVjR2d4TUo1UG9Ock91Qy9ORTFzaGlFb2J6R2oxU2NYcDlVZWpw?=
 =?utf-8?B?d0QzbE8rblVPRm41WWdQL3FORkt4amJaTHdGcUYzN0hmelMxa1N6a1NpSk9S?=
 =?utf-8?B?TEZ3UUhRcTR3dDZnT1FndFkrcmxGd2I3K3l3VUtodnhUV3RoQzFpdGFEL0F2?=
 =?utf-8?B?cS9JSjlhM1RxUjBJL2lwaW5WSlR4ZVJkNkhJWUladjVQdjk1ckthNTQxVEkv?=
 =?utf-8?B?N21jZFFZTkZVOE5ZUlBQdzhUcm5lYVJzQVVCbjIzU0xJdDRPdnpQSm5HOHlt?=
 =?utf-8?B?MEh4aS8zTDhPOW1Qd1RNNHhPUGIvOTZ2UWdWRnBBVVkrSVV3QTZmUXErVktx?=
 =?utf-8?B?L1prQVJpT2p1Q0MxQmZDblRFNm41OWo2V0themdIQVZHQklSN09CR3Exbm9s?=
 =?utf-8?B?Z3pMZGNyc05ZWEplenlJMUxYNHNYeTZzTFBRZUdzbE5mVXY0dTZVb3VJN2N5?=
 =?utf-8?B?aDV5ZXBMTDRxNWw4UEVCVFh6OU5GYk9VejdZU2lNSnplWXQ0SEs2ZGd6SklN?=
 =?utf-8?B?YWJWQnVOUGh4MWsyQndHU1h4WCszM2hUZjd0ZU02YTd5eEhaR3JObTlvY0xX?=
 =?utf-8?B?SXZYNklrUUNSSkFablNTSzBlY0JXb1NSdTREZjFiZG82cHUwUmRSZmN1RWV2?=
 =?utf-8?B?SjluQmhLSkRraVJQNzZsT2pDUkYrcENydHUrS3F3Z3ZVL1JwdDJVV0hSRDky?=
 =?utf-8?B?eWtiY3RpY1JNdStWMnprR0RMVklKUkRSbUlqbDhoenZrQlVFYmtUMlhibStp?=
 =?utf-8?B?bHZBd3ArT0FEMnVzTzZSWnc5U09Qdmx3bDVRNVQ2S2pQUlJmVUpTV3B5cjFO?=
 =?utf-8?B?aVRpV3NiM2p6UDlhOVMvbXZpSS9CVlJ2ZVlWdjJWeEt2aEhveWFra25pakpT?=
 =?utf-8?B?cFk1c3BYekVWVW0yS1pvYTE5WlBFbXI4aUw2aVhsc1h3NUlNdElwVUhvL05U?=
 =?utf-8?B?VzhSa21zNFUxdmw4UFRkZ0tBb2tNbkJVbFR3U2ZoTkRhNEJHRE0xK3JlTGR5?=
 =?utf-8?B?TU5ZZThYdHZMOHhGK1NjYTluU3hRMElDdDhseHNGaVNhclVTMkVQU1hZdCtM?=
 =?utf-8?B?MXV2S2xiTzcvN1J6Zks2M1JJTks1cUF5cDI1SUVpN1IzUmhPczBLd0lzM0dh?=
 =?utf-8?B?VUpSVmNyZldzdEszYzROVCtUZ2daNzB2SC9PdUkvN3BZaGs4S3l5ckt0aXFN?=
 =?utf-8?Q?wp8tuR7HfQ5zp0JFulVHfbTh4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86502b56-7243-43ca-f7a8-08ddd9ae2b4e
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2025 14:40:23.3843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WYgW7E3LMq6X5lfP9r1yD2pQTxkz8qa/324/FHjKTvpJgF+zZmXWmMH1i0kMDE7MHbrJTUArpf+kfK3hjhSPdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPF4D923B935



On 8/12/2025 7:06 AM, Kim Phillips wrote:
> On 7/25/25 1:46 PM, Kalra, Ashish wrote:
>> On 7/25/2025 1:28 PM, Tom Lendacky wrote:
>>> On 7/25/25 12:58, Kim Phillips wrote:
>>>> Hi Ashish,
>>>>
>>>> For patches 1 through 6 in this series:
>>>>
>>>> Reviewed-by: Kim Phillips <kim.phillips@amd.com>
>>>>
>>>> For this 7/7 patch, consider making the simplification changes I've supplied
>>>> in the diff at the bottom of this email: it cuts the number of lines for
>>>> check_and_enable_sev_snp_ciphertext_hiding() in half.
>>> Not sure that change works completely... see below.
>>>
>>>> Thanks,
>>>>
>>>> Kim
>>>>
>>>> On 7/21/25 9:14 AM, Ashish Kalra wrote:
>>>>> From: Ashish Kalra <ashish.kalra@amd.com>
>>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>>> index 7ac0f0f25e68..bd0947360e18 100644
>>>> --- a/arch/x86/kvm/svm/sev.c
>>>> +++ b/arch/x86/kvm/svm/sev.c
>>>> @@ -59,7 +59,7 @@ static bool sev_es_debug_swap_enabled = true;
>>>>   module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
>>>>   static u64 sev_supported_vmsa_features;
>>>>
>>>> -static char ciphertext_hiding_asids[16];
>>>> +static char ciphertext_hiding_asids[10];
>>>>   module_param_string(ciphertext_hiding_asids, ciphertext_hiding_asids,
>>>>               sizeof(ciphertext_hiding_asids), 0444);
>>>>   MODULE_PARM_DESC(ciphertext_hiding_asids, "  Enable ciphertext hiding for
>>>> SEV-SNP guests and specify the number of ASIDs to use ('max' to utilize
>>>> all available SEV-SNP ASIDs");
>>>> @@ -2970,42 +2970,22 @@ static bool is_sev_snp_initialized(void)
>>>>
>>>>   static bool check_and_enable_sev_snp_ciphertext_hiding(void)
>>>>   {
>>>> -    unsigned int ciphertext_hiding_asid_nr = 0;
>>>> -
>>>> -    if (!ciphertext_hiding_asids[0])
>>>> -        return false;
>>> If the parameter was never specified
>>>> -
>>>> -    if (!sev_is_snp_ciphertext_hiding_supported()) {
>>>> -        pr_warn("Module parameter ciphertext_hiding_asids specified but
>>>> ciphertext hiding not supported\n");
>>>> -        return false;
>>>> -    }
>>> Removing this block will create an issue below.
>>>
>>>> -
>>>> -    if (isdigit(ciphertext_hiding_asids[0])) {
>>>> -        if (kstrtoint(ciphertext_hiding_asids, 10,
>>>> &ciphertext_hiding_asid_nr))
>>>> -            goto invalid_parameter;
>>>> -
>>>> -        /* Do sanity check on user-defined ciphertext_hiding_asids */
>>>> -        if (ciphertext_hiding_asid_nr >= min_sev_asid) {
>>>> -            pr_warn("Module parameter ciphertext_hiding_asids (%u)
>>>> exceeds or equals minimum SEV ASID (%u)\n",
>>>> -                ciphertext_hiding_asid_nr, min_sev_asid);
>>>> -            return false;
>>>> -        }
>>>> -    } else if (!strcmp(ciphertext_hiding_asids, "max")) {
>>>> -        ciphertext_hiding_asid_nr = min_sev_asid - 1;
>>>> +    if (!strcmp(ciphertext_hiding_asids, "max")) {
>>>> +        max_snp_asid = min_sev_asid - 1;
>>>> +        return true;
>>>>       }
>> As Tom has already pointed out, we will try enabling ciphertext hiding with SNP_INIT_EX even if ciphertext hiding feature is not supported and enabled.
> AFAICT, Tom pointed out two bugs with my changes: the 'base' argument to kstrtoint(), and bad min_sev_es_asid assignment if ciphertext hiding isn't supported.
>> We do need to make these basic checks, i.e., if the parameter has been specified and if ciphertext hiding feature is supported and enabled,
>> before doing any further processing.
>>
>> Why should we even attempt to do any parameter comparison, parameter conversion or sanity checks if the parameter has not been specified and/or
>> ciphertext hiding feature itself is not supported and enabled.
> Agreed.
>> I believe this function should be simple and understandable which it is.
> Please take a look at the new diff below: I believe it's even simpler and more understandable as it's less code, and now alerts the user if they provide an empty "ciphertext_hiding_asids= ".
> 
> Thanks,
> 
> Kim
> 
>  arch/x86/kvm/svm/sev.c | 47 ++++++++++++++++++-----------------------------
>  1 file changed, 18 insertions(+), 29 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 7ac0f0f25e68..57c6e4717e51 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2970,42 +2970,29 @@ static bool is_sev_snp_initialized(void)
> 
>  static bool check_and_enable_sev_snp_ciphertext_hiding(void)
>  {
> -       unsigned int ciphertext_hiding_asid_nr = 0;
> -
> -       if (!ciphertext_hiding_asids[0])
> -               return false;
> -
> -       if (!sev_is_snp_ciphertext_hiding_supported()) {
> +       if (ciphertext_hiding_asids[0] && !sev_is_snp_ciphertext_hiding_supported()) {
>                 pr_warn("Module parameter ciphertext_hiding_asids specified but ciphertext hiding not supported\n");
>                 return false;
>         }
> 

This is incorrect, if ciphertext_hiding_asids module parameter is never specified, user will always 
get a warning of an invalid ciphertext_hiding_asids module parameter.

When this module parameter is optional why should the user get a warning about an invalid module parameter.

Again, why do we want to do all these checks below if this module parameter has not been specified by
the user ?

> -       if (isdigit(ciphertext_hiding_asids[0])) {
> -               if (kstrtoint(ciphertext_hiding_asids, 10, &ciphertext_hiding_asid_nr))
> -                       goto invalid_parameter;
> -
> -               /* Do sanity check on user-defined ciphertext_hiding_asids */
> -               if (ciphertext_hiding_asid_nr >= min_sev_asid) {
> -                       pr_warn("Module parameter ciphertext_hiding_asids (%u) exceeds or equals minimum SEV ASID (%u)\n",
> -                               ciphertext_hiding_asid_nr, min_sev_asid);

A *combined* error message such as this: 
"invalid ciphertext_hiding_asids XXX or !(0 < XXX < minimum SEV ASID 100)"

is going to be really confusing to the user.

It is much simpler for user to understand if the error/warning is: 
"Module parameter ciphertext_hiding_asids XXX exceeds or equals minimum SEV ASID YYY"
OR
"Module parameter ciphertext_hiding_asids XXX invalid"

Thanks,
Ashish

> -                       return false;
> -               }
> -       } else if (!strcmp(ciphertext_hiding_asids, "max")) {
> -               ciphertext_hiding_asid_nr = min_sev_asid - 1;
> -       }
> -
> -       if (ciphertext_hiding_asid_nr) {
> -               max_snp_asid = ciphertext_hiding_asid_nr;
> +       if (!strcmp(ciphertext_hiding_asids, "max")) {
> +               max_snp_asid = min_sev_asid - 1;
>                 min_sev_es_asid = max_snp_asid + 1;
> -               pr_info("SEV-SNP ciphertext hiding enabled\n");
> -
>                 return true;
>         }
> 
> -invalid_parameter:
> -       pr_warn("Module parameter ciphertext_hiding_asids (%s) invalid\n",
> -               ciphertext_hiding_asids);
> -       return false;
> +       /* Do sanity check on user-defined ciphertext_hiding_asids */
> +       if (kstrtoint(ciphertext_hiding_asids, 10, &max_snp_asid) ||
> +           max_snp_asid >= min_sev_asid) {
> +               pr_warn("invalid ciphertext_hiding_asids \"%s\" or !(0 < %u < minimum SEV ASID %u)\n",
> +                       ciphertext_hiding_asids, max_snp_asid, min_sev_asid);
> +               max_snp_asid = min_sev_asid - 1;
> +               return false;
> +       }
> +
> +       min_sev_es_asid = max_snp_asid + 1;
> +
> +       return true;
>  }
> 
>  void __init sev_hardware_setup(void)
> @@ -3122,8 +3109,10 @@ void __init sev_hardware_setup(void)
>                  * ASID range into separate SEV-ES and SEV-SNP ASID ranges with
>                  * the SEV-SNP ASID starting at 1.
>                  */
> -               if (check_and_enable_sev_snp_ciphertext_hiding())
> +               if (check_and_enable_sev_snp_ciphertext_hiding()) {
> +                       pr_info("SEV-SNP ciphertext hiding enabled\n");
>                         init_args.max_snp_asid = max_snp_asid;
> +               }
>                 if (sev_platform_init(&init_args))
>                         sev_supported = sev_es_supported = sev_snp_supported = false;
>                 else if (sev_snp_supported)
> 
> 
>> Thanks,
>> Ashish
>>
>>>> -    if (ciphertext_hiding_asid_nr) {
>>>> -        max_snp_asid = ciphertext_hiding_asid_nr;
>>>> -        min_sev_es_asid = max_snp_asid + 1;
>>>> -        pr_info("SEV-SNP ciphertext hiding enabled\n");
>>>> -
>>>> -        return true;
>>>> +    /* Do sanity check on user-defined ciphertext_hiding_asids */
>>>> +    if (kstrtoint(ciphertext_hiding_asids,
>>>> sizeof(ciphertext_hiding_asids), &max_snp_asid) ||
>>> The second parameter is supposed to be the base, this gets lucky because
>>> you changed the size of the ciphertext_hiding_asids to 10.
>>>
>>>> +        max_snp_asid >= min_sev_asid ||
>>>> +        !sev_is_snp_ciphertext_hiding_supported()) {
>>>> +        pr_warn("ciphertext_hiding not supported, or invalid
>>>> ciphertext_hiding_asids \"%s\", or !(0 < %u < minimum SEV ASID %u)\n",
>>>> +            ciphertext_hiding_asids, max_snp_asid, min_sev_asid);
>>>> +        max_snp_asid = min_sev_asid - 1;
>>>> +        return false;
>>>>       }
>>>>
>>>> -invalid_parameter:
>>>> -    pr_warn("Module parameter ciphertext_hiding_asids (%s) invalid\n",
>>>> -        ciphertext_hiding_asids);
>>>> -    return false;
>>>> +    return true;
>>>>   }
>>>>
>>>>   void __init sev_hardware_setup(void)
>>>> @@ -3122,8 +3102,11 @@ void __init sev_hardware_setup(void)
>>>>            * ASID range into separate SEV-ES and SEV-SNP ASID ranges with
>>>>            * the SEV-SNP ASID starting at 1.
>>>>            */
>>>> -        if (check_and_enable_sev_snp_ciphertext_hiding())
>>>> +        if (check_and_enable_sev_snp_ciphertext_hiding()) {
>>>> +            pr_info("SEV-SNP ciphertext hiding enabled\n");
>>>>               init_args.max_snp_asid = max_snp_asid;
>>>> +            min_sev_es_asid = max_snp_asid + 1;
>>> If "max" was specified, but ciphertext hiding isn't enabled, you've now
>>> changed min_sev_es_asid to an incorrect value and will be trying to enable
>>> ciphertext hiding during initialization.
>>>
>>> Thanks,
>>> Tom
>>>
>>>> +        }
>>>>           if (sev_platform_init(&init_args))
>>>>               sev_supported = sev_es_supported = sev_snp_supported = false;
>>>>           else if (sev_snp_supported)
>>>>
> 

