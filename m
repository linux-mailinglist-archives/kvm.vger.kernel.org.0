Return-Path: <kvm+bounces-40781-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E98FA5C7C4
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 16:38:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7DF3E16F3B1
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 15:34:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11EE725E805;
	Tue, 11 Mar 2025 15:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="iFrHxqwt"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2041.outbound.protection.outlook.com [40.107.94.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1961CAA8F
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 15:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707251; cv=fail; b=glpQB26x8Th0HLJvDjbjCDsTdhHi4e5Lsw6Tg5hn8xjHy2f6sX4wacMgaOnFKnUXO102HQai4kJM7sptdp/KrfGcF7m7YluApDfcND52yZGM3BORUsJxdBGUGQVfi01cGXmBH3R+gth4uAyp6wAttASV3cuUBMAhJJzlhywTBvA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707251; c=relaxed/simple;
	bh=eppO6rA/Pw/2ZsOjpbKjSQ2YoStU5Y6uDIg8jujI9hY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PU8JUFSbncJzUFTsT6W6AhMHeNn0ubAegt6eP7oPY6MQ6Vf+QCYRnltrY2oZrVDtXIAfvaV//a8oFurQoT4to5RziXglzDuQJpqlffGKLWoPyLX3cAjsB/xo5E+63fd6iOpoBANXIyCwm59X4+LG2zli7AKFv0JgNWCit+RWO60=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=iFrHxqwt; arc=fail smtp.client-ip=40.107.94.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o8Sz2Ykg3goBjrkP7+Kvq5hhMOgEiWATrySnEf4YcCA+aF/3rH9Lja99xXcipYhg+8R5sOMuInb4+rYdT22lTq4RaaJuQ1QgHcFNRYAYAM70GkyBmUgf/VgTLdc9NBpMMu66YHiqAz5Stc+I5jQqaN5g+ISUFhKnUoIA652OMXAyFI5VwlANkkhwThId9hii1LWFV4sM8kcy/wyQSeDEpElZkn3SckInt8zdkaEAa97pakhqykmpAfOZeMhlmk/1D1JP0gvEP4bJvIKhXX9hgrJNqyyvJgVtsYHNXAYG98tzNhSFIhl7nS6uHIXgbJKx4+ln5PC0a2ENV8MhZGWCdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CZzO25Tob0o+gAyRZxuYaNOByXoprJNuXUh1mh+OtAE=;
 b=VqSAngOik8dbK6t5cW8SlCvPjKoraXd/Z+zBTuosw00aB+rDPcSYaVC0vtB6gac/OdUdVG8eFXgAzQ/oZ2NlojANjTX1hpLrYRKhUrKPmvROUFk5M2sMv4vVojr7wNAfvnrWWK+CE6CqgjW3YToGphbVWOo7HHonf21SN45DU0p4za2uSn9kf/qh9c2dCuMQFEIK1dJ+sDjgBPcx73CLhwBjRCYh9XQqalvC9If20Z5cjdQnuXGUpKO7YYw5IfrDBuG8wiM/gmT8ILqUwW5PysmAjXVtugfQ54tLFq/UbiBzfe+JznDtgQnQWMP1gCurwSnHdMVIKwY/lT9XcMq2+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CZzO25Tob0o+gAyRZxuYaNOByXoprJNuXUh1mh+OtAE=;
 b=iFrHxqwt8R2WS3WDZhle373syGn0BD71AxvTBXAy/LfAkP8Z4eNkCCE9svxKeoaQY5S96hr+W6o3GxEvgpcoJM2j9rQWEoWS07Vhy1s7DVGUzcdHr8Iemp/snKnpxJhfftuIbCxXiAoRMCyP+87X8I+6PmQFsFwarfQpt4vsPtE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6321.namprd12.prod.outlook.com (2603:10b6:930:22::20)
 by BL1PR12MB5996.namprd12.prod.outlook.com (2603:10b6:208:39c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Tue, 11 Mar
 2025 15:34:06 +0000
Received: from CY5PR12MB6321.namprd12.prod.outlook.com
 ([fe80::62e5:ecc4:ecdc:f9a0]) by CY5PR12MB6321.namprd12.prod.outlook.com
 ([fe80::62e5:ecc4:ecdc:f9a0%4]) with mapi id 15.20.8511.026; Tue, 11 Mar 2025
 15:34:06 +0000
Message-ID: <73c6c8ea-93a0-4e2b-b5fe-74ea972b1a2c@amd.com>
Date: Tue, 11 Mar 2025 21:03:58 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/5] KVM: SVM: Enable Secure TSC for SNP guests
To: Sean Christopherson <seanjc@google.com>,
 Tom Lendacky <thomas.lendacky@amd.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, santosh.shukla@amd.com,
 bp@alien8.de, isaku.yamahata@intel.com
References: <20250310063938.13790-1-nikunj@amd.com>
 <20250310064522.14100-1-nikunj@amd.com>
 <20250310064522.14100-4-nikunj@amd.com>
 <5ac9fdb6-cbc5-2669-28fa-f178556449ca@amd.com>
 <cc076754-f465-426b-b404-1892d26e8f23@amd.com>
 <d92856e0-cc43-4c51-88c7-65f4c70424bf@amd.com>
 <0d121f41-a31d-1c0b-22cb-9533dd983b8a@amd.com> <Z9BOEtM6bm-ng68c@google.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <Z9BOEtM6bm-ng68c@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0182.apcprd04.prod.outlook.com
 (2603:1096:4:14::20) To CY5PR12MB6321.namprd12.prod.outlook.com
 (2603:10b6:930:22::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6321:EE_|BL1PR12MB5996:EE_
X-MS-Office365-Filtering-Correlation-Id: ea2278c0-679a-4144-afa8-08dd60b22873
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dUYxa09EMGNZRHErYzV1TG5UeGEwR2hFYzR2L3hXSzhLS0poSURrWTNWenBE?=
 =?utf-8?B?MnFTc1pWN2ZQWDh4TmtVdEdYR2RNdDRsaHljaUt1dElXV1kvYzUwWnllR1No?=
 =?utf-8?B?M1d0Zkg2UkI4YmZTT3IxZWRSeVhUTHFZc0FhNTJDTk1tMnpXd1Z1a3hEanlH?=
 =?utf-8?B?OGMxSDlKNGs2b201T0tQdDd0RUVpZk0zaEJQeWxaWDNQUytBNkpxbjhYa3Fy?=
 =?utf-8?B?bGFNTjhVTDVwOGFjOXdCWlcrV01uaXQvSTJ2YkJmT0E0Zldsd1B4SkxHd3Vn?=
 =?utf-8?B?SU9ZVUZRMCtWWkFpWTNKYmdXc1plMnRJTVQ2Z1UvK2hLRjhuNTRmYzVBRHAw?=
 =?utf-8?B?S2U3OXJzNlg0Z05WZnB3SGRkbTZDQXNKV3FiS0djejlwS1BwMSthYnB5QTVS?=
 =?utf-8?B?VDJNanhKakxpTDJUb0dIM01IWnRpNGlYUmlYODRwQlJ0Q1U1V3EyZnlocXRZ?=
 =?utf-8?B?TjZTSVhJTjZmTkloQW4zR2RhV3IyVzZaYjdGOGFqbjNlUDBld2IyWTlrQ2RH?=
 =?utf-8?B?eTNER0w3SC9xVlc5bHV3Rm5COERjVEF2NllURVJFeUxLYVRDYnltaHp6Ym9Q?=
 =?utf-8?B?SUloeTB5SWZhMlQxSytkcXVtMWFrR1REaGU5MDhkT29yWjBZZHlCS05wZnFs?=
 =?utf-8?B?OXd3OVBiZXp5MWJjV3R2WTBCdDhtb25TNUxPM0RUOFN1U0hrOU13cEpMTGp0?=
 =?utf-8?B?OTdFS2pIdysrRXlYNU14WTVnUUxUcmZCZ3VXaUtuZ1EySnI1bmNDb1lEbVYw?=
 =?utf-8?B?dm1tbnJoSXZxN3FKak5iQ1pXbm1CTitpeDRna0pvc3ZuSnMwV3RjZ2ZMaFV3?=
 =?utf-8?B?VFplMWNQR1I4Y05SbFErVnU3emRqKzFsdEdTdkRCNTNKSTJPM3g1R1IxRExa?=
 =?utf-8?B?QXB5czNRclJka0hBaEN3TXBHZWkxWll2Z2NXdVRDaGVoanNSd3Q0SjQ0MWdX?=
 =?utf-8?B?ZjBQQk1zdEpXMktQT0RiQWR6dU8wUVBldFRtcnFtNGx3bXgyOTd2RmRtM1RP?=
 =?utf-8?B?c1YrZUVkZ3BtZnpHVU1sd2YyR3JacmI5dTdDOTFkaC8rU3ZvdnFSa0U1RndH?=
 =?utf-8?B?Y2JoSncrQkxnNkl6S1lZRW5pZjEzYnFGc2lBQVBwV0ZHMVFyc1M4WTZxM052?=
 =?utf-8?B?RnJPTkcvZDJvL2VkNjBvMDREN05XYlQzejJCbU5TNkxIenFoWDFTWlY5TEZX?=
 =?utf-8?B?ZTIwRitGUk5OSmtua1o0alJ4QnNGYzhuV0xwRXBvSzlhRzN1YkN0VWVGNUZi?=
 =?utf-8?B?cmJkREQvcHZTRWE5OS9RMWlSekhFZVJXTnRVdXlHbXBrNnhFdFNDNEExcFc5?=
 =?utf-8?B?TVNnNkhSakd2NWdwd2tINzJIRC9sdzZ2V2M3aTFRNDQvZmlraCtzVldaTnAv?=
 =?utf-8?B?SVR2NFBYdURmKzFIakY5dFZTcDFEV0NuTTRRQVk3SWRQTkZoS2NVZ2RVY21p?=
 =?utf-8?B?cTJaQ0dpaXJWTDRrekdiWEdPVnpWeXNKR2ppNHlwdWJveDJDVVUxay9jTmNu?=
 =?utf-8?B?ZSttWkdMZmx0ZnQ5Z05MelE5RjFlWERkclJQRGhRRFpyME14VXZhaWhOblhQ?=
 =?utf-8?B?aXRTT1J2MTBPeFVuUGVrQVh6SzdqUmVNcUdnaXRUSVVKRWFoRTM4Ni8xMncv?=
 =?utf-8?B?WkZ5TmVFUW5hdjU0WWt3aFNSN0hCVGZaOW0vNjZpN1o5NW5QMk5FekJjWU5R?=
 =?utf-8?B?aXlKQWtwckltdmpNNnFFTzNYeTBzK09xNERSNVZHS1ZrR2hZR3RCQWdnWDA3?=
 =?utf-8?B?MW5iL09lTnlvRXZScTlNSjZNNitqdWhlQnVnNWticWVQVEFoVExiQjVBanpJ?=
 =?utf-8?B?ZEdIdjZiS3dTSDBSRTJqT1d4ZTdqY3JZeTE3c0ptL0IvaFliRTU1QW9JaVFF?=
 =?utf-8?Q?O0Eah6wmcSALS?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6321.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VExkOG5hSExFOFhHNklEMzROcGZQeEpETVhJZHdrbmNWUitZSmRlQWNQdHVN?=
 =?utf-8?B?QzhuRmQwMlhxdXBDbXNCUnh1Z01yY3g2bHpDdFlDMHpEUFhRYWRxc3pxT05G?=
 =?utf-8?B?M1RDN1FVRXF2OGF3VmZPR0lwdGY3Z0szL0xUOUExaWRRSXJtNkwvMzFBblVU?=
 =?utf-8?B?TUYyUEthdUk3ODYwMkVpMU5oUFZ4aTVJZmNWTzFFdmFWRWR4QnhoUkMrU1Z0?=
 =?utf-8?B?bUJ4SzdFa09mV21qVUtPSnhVVkQzLzhrblFMNXJBWENNSFE1QlhWTGwzTHpX?=
 =?utf-8?B?ZzN5UENWeG1EVml4QUh2emMwL3VWYU95dUt1YWh5SDVGZGdybnNOL3NnU3Zy?=
 =?utf-8?B?a0RPUEF4V2pjTjNCOXhXb0dPVFhIT1V4cm1DbFBxZ2labVY4VkhJeEdrazhQ?=
 =?utf-8?B?dmNyN21GblJSZi85UFhDUmdnYk4wM3BuYVdTWG0xUDRFdGdtRmJnNDNuZE5l?=
 =?utf-8?B?N1RXU0hQdlFyUmpnckorODFFbHVYdTlDQng0OFRMOXFDSVBqcjR4SWYreHk3?=
 =?utf-8?B?KzN0ZWEwcUNBOG8xS0kvRVZ6QncrM3ZHRGwwZmdMbFNpMnNTNXNVbG5YSlMv?=
 =?utf-8?B?YXVFOXJicFVzWmxsT2ZJdERXSXZWdWtTZ213T2F6ajZhNk5GeHBPRWhrVEhC?=
 =?utf-8?B?OEdXdW1NRkZ6TUNxMDRaSGErQ1BRRTMyMjZJNGE3Z3VTSlVoWlVEQVZ0R3Jn?=
 =?utf-8?B?QWE3TmwvdWpZazI4WHFTMVRKWlBobTd4cGp4UVJUeGJJYndiRUpEWDBpcnE3?=
 =?utf-8?B?VmlhRVExMHJ3U2ZvdzM2NFY4cUNvOHNaSHFKY3FOMmpFVzNJZm9Kek1YTUt6?=
 =?utf-8?B?MWxFUlBjWHNyV2ovRDV4YXh3MUxFdTMyTHkrS3RONVVMMFJ3MjdOMEs1Y1k1?=
 =?utf-8?B?ZkpFSm1ReUVYakZudzFLQWVxaEpvYzl1VEkxUmxtMWJFWU45bUtYbmJNbFNF?=
 =?utf-8?B?MTRwRWd0eXArOFRnblJmbXRsNlpubUU5NnVBQjN4cDQvLzArMnk0QWRRcXFJ?=
 =?utf-8?B?YjhvK2x6K3psaVhzNVE2YXJ1b0ZyRHRqRTR6UjRPbEZtQXgwTmNlZXE5cEJZ?=
 =?utf-8?B?WkZPbytYL2wwbWZIa3lKbjJ5a285Z3FiRGROU2h5NE5OOWp6YlltOXBsNXZk?=
 =?utf-8?B?WmYzMGZPWUdOVzFVZU9najI3TmkyQ2hqSEhxMzROZHVqb2FWSDBYclF6T2kw?=
 =?utf-8?B?UUlEd2NSK1Jndi8xZGpqL0F5ajV5NzdZSTBGcGtIRkh3c2JRQ2FOeTcwRnRs?=
 =?utf-8?B?N0MxNis1L0dSZWZnYU5QTEZyS1NVeWRjNlJmWXlTMlhvWEZsME1RMmRkR1Ja?=
 =?utf-8?B?MHZOYmhLdnpUNFBLMEpwei93YjJ0TWhncmJkYWM0aU5iazJma1VtMkJWT2lU?=
 =?utf-8?B?NjV1c2JkWXBXRHVNZy8wa0xkTXZhOGsrVFhWNm4rM25zSDZ4UGVTVk1YcE4y?=
 =?utf-8?B?VjBQUXZoTGdBSCtMQld1UUhEeU9rL3o2YkhxeDNLMlYrRytZR0lxeHZUR1ZX?=
 =?utf-8?B?UTBnbXRpeTRNNVNyZkN2ZVhueUx6TnJmcUhtSkJJZ3VCWTQ3Uy92dWkvN0ZY?=
 =?utf-8?B?MGhqSlk1Z3QxNVRyTTA1TlhrWW5TaWxKbFVCbVNvNnp0TFRwSFlTV1E0S0to?=
 =?utf-8?B?aGtCZC9qdTlrN2h6aFJGOGs2eWNuUUgra0c3REF4WHFnNS94bFh2RmQ2cHhG?=
 =?utf-8?B?blNvUThmY3hHYU1SNnVQbldyV1dXMnVmeGZlK0ZrT0RJUG9oYUR2N2tXNnc2?=
 =?utf-8?B?Qk9qbjVWb1RVaUVMeVpqUzN4TlZBSnpLRVE5WHlnVDBmOHJWVlA3VEhmSlNy?=
 =?utf-8?B?V0pVY1J2amJPWkRwOVY0cmV0TUZrV1M3R0I5c1hMOTNKRmt2WVpsSlc4NlR5?=
 =?utf-8?B?MDAxeHNETDFSM1Z6WE1sU0tXZytyZVVoU2ZoY043Tk1jaSt0S1hWS083emFV?=
 =?utf-8?B?emF5R3NkUTA3Rm9wNk9uc3hRZXg1cTBTQmxhVVFQbDdCb002WUlOZThCTEc5?=
 =?utf-8?B?SkpMc3NXVmJtdisxa0UvZUlialo3WnNZWTRad3VxTDl2ckZwSUQxd29VYkpW?=
 =?utf-8?B?YlhSRWlleW16ZlVEV1o0VmN4TTZyRDFya0xpQzVrK2RRbytHcEJlWENHamJK?=
 =?utf-8?Q?ONdi+uaK/OxTLMQKNgYrYZG/d?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea2278c0-679a-4144-afa8-08dd60b22873
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6321.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2025 15:34:05.9329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8BQifi7rAaULFEL1erFMCB0tLN0wEaDC6OSHFg+a/R3PEtBbC7C9IlZ04tGApJSuo2zXHNdnaR3GshgCSG8BLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5996



On 3/11/2025 8:22 PM, Sean Christopherson wrote:
> On Tue, Mar 11, 2025, Tom Lendacky wrote:
>> On 3/11/25 06:05, Nikunj A. Dadhania wrote:
>>> On 3/11/2025 2:41 PM, Nikunj A. Dadhania wrote:
>>>> On 3/10/2025 9:09 PM, Tom Lendacky wrote:
>>>>> On 3/10/25 01:45, Nikunj A Dadhania wrote:
>>>>
>>>>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>>>>> index 50263b473f95..b61d6bd75b37 100644
>>>>>> --- a/arch/x86/kvm/svm/sev.c
>>>>>> +++ b/arch/x86/kvm/svm/sev.c
>>>>>> @@ -2205,6 +2205,20 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>>>>>  
>>>>>>  	start.gctx_paddr = __psp_pa(sev->snp_context);
>>>>>>  	start.policy = params.policy;
>>>>>> +
>>>>>> +	if (snp_secure_tsc_enabled(kvm)) {
>>>>>> +		u32 user_tsc_khz = params.desired_tsc_khz;
>>>>>> +
>>>>>> +		/* Use tsc_khz if the VMM has not provided the TSC frequency */
>>>>>> +		if (!user_tsc_khz)
>>>>>> +			user_tsc_khz = tsc_khz;
>>>>>> +
>>>>>> +		start.desired_tsc_khz = user_tsc_khz;
> 
> The code just below this clobbers kvm->arch.default_tsc_khz, which could already
> have been set by userspace.  Why?  Either require params.desired_tsc_khz to match
> kvm->arch.default_tsc_khz, or have KVM's ABI be that KVM stuffs desired_tsc_khz
> based on kvm->arch.default_tsc_khz.  I don't see any reason to add yet another
> way to control TSC.

Setting of the desired TSC frequency needs to be done during SNP_LAUNCH_START,
while parsing of the tsc-frequency happens as part of the cpu common class, 
and kvm->arch.default_tsc_khz is set pretty late.

Intially, I had planned using "-cpu model,tsc-frequency=<>", but couldn't
find a way to get this parsed early during SNP_LAUNCH_START.

Regards,
Nikunj

