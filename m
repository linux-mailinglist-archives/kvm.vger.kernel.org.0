Return-Path: <kvm+bounces-54548-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D32FBB2392B
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 21:40:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52AA63B10A7
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 19:39:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DDF92FFDE5;
	Tue, 12 Aug 2025 19:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="11qEVJgd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2084.outbound.protection.outlook.com [40.107.92.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2D727FB15;
	Tue, 12 Aug 2025 19:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755027539; cv=fail; b=m3rKlqBlY+8rCMOTujtB+GHrVgnojEunI8ne/CfnXH2Zzc92+OehFwoJvckQPbKbzGFaW2UnEPLT9MuaFTFXIfozk/Z1LyDiRoXuc1Kc65uro06p8peFqaJKqeI3hZTBfs1k5ZrQT9STIj1xfxZno4UKDJ2DD73dDncQaUuFJXw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755027539; c=relaxed/simple;
	bh=k9i5z9f2uILxKlqNgUKKSqIRo+AKvEhLrT4WRX7s4kI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bOIkIm/f581UZrfZ+F2M4kTOoH4EPWDuZI5lx5zyT+jiRGdbd/S26MKQA0vmu8Of/20rQK/fEdE6l5zbo2vI3j3kCxy1LJo+ZYCP8xEftlyAQwYl42g4utoZw5Se2NvC3NPsWAx6HF6Ni9hW9ETke1VNMlxrUI5gr8k4MnK1gbg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=11qEVJgd; arc=fail smtp.client-ip=40.107.92.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w7Pz1SbPZU8u70+uBCk8sVA7o65a9Eh6znks6tJtVuQZZkrfIPBMbFxm3ymCE88wQE+LX6kMatx6DCUM1rVfUcBXtEsJewJrWmMNJP3XS9XOoqIxnai/Ja/LQZMmi1TL7vCXaGa8CFXp+XJrShLe/aklJqB5PQB83siMcuzurYi/w402yHva+oFDM6R4ZRwX7XYXrOZukP3aUD+CexTaI1oOtMY/u134Y3qTlyouSSWJ80dfpeLwQ1uyXejjEK+L8Mbrp696b9dCoisLpdaFNTvfNbeQr0vS8gQIfzt4AMesRJ4jnLBG25fgiHU65Y7GR21Yc47fLBfKvj8JGzBacA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V6vgaEWrc54+SWP7V1JOEz18PH+xh+2lV2BpMHfvAEg=;
 b=tJlfFDqnSKX+gprRDV7yxI15b58Q3l77MWNFOJSx+oQik66YtlcM2mMFQb63m/PiN8kCzWYRhc39CzvKWM0sRX7Nn7TbSQ6YMjZiWn2blg4idp3+KWEr8jFoiLnBEFRBepjNCkeFk/rs/467VtIOskZB9QUgoCuDnEJJoFmkfrPjS3oYrWnJklTjZ1ehqUR3b22UIMkJbq2/xOZYUgQovOOrcVqh8YFZY63mm8NnFBR2t/ZSl7Hn7HgoPzeJyx0ZtOo688J45lXuAQEECXTTpdQ41Hgnfm+MqqU6CjuaYHy3ZPCw64sVPyCkzzCo7JuftU3pPYpNBMoDxFNZ+Vf80A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V6vgaEWrc54+SWP7V1JOEz18PH+xh+2lV2BpMHfvAEg=;
 b=11qEVJgd6YtGWhwRrMgMWgOelRHIacGoFLcRbDsSZRvlxqi3V+5tKKjEnN691vrYFtB/r3ZdYGdBGBNbaQdalQ+sBVAKGmg5/hxgb21D+TcQyYw5tFos/9F4CASNDW/Tchv//oWCD13DEL4LPOzzeI/vC8uGdUyxDVECRtydOTo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB9066.namprd12.prod.outlook.com (2603:10b6:510:1f6::5)
 by SA1PR12MB6821.namprd12.prod.outlook.com (2603:10b6:806:25c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.22; Tue, 12 Aug
 2025 19:38:53 +0000
Received: from PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::954d:ca3a:4eac:213f]) by PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::954d:ca3a:4eac:213f%4]) with mapi id 15.20.8989.018; Tue, 12 Aug 2025
 19:38:53 +0000
Message-ID: <47783816-ff18-4ae0-a1c8-b81df6d2f4ef@amd.com>
Date: Tue, 12 Aug 2025 14:38:46 -0500
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
 <5a207fe7-9553-4458-b702-ab34b21861da@amd.com>
 <a6864a2c-b88f-4639-bf66-0b0cfbc5b20c@amd.com>
 <9b0f1a56-7b8f-45ce-9219-3489faedb06c@amd.com>
 <96022875-5a6f-4192-b1eb-40f389b4859f@amd.com>
 <5eed047b-c0c1-4e89-87e9-5105cfbb578e@amd.com>
 <506de534-d4dd-4dda-b537-77964aea01b9@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <506de534-d4dd-4dda-b537-77964aea01b9@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7PR18CA0017.namprd18.prod.outlook.com
 (2603:10b6:806:f3::34) To PH7PR12MB9066.namprd12.prod.outlook.com
 (2603:10b6:510:1f6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB9066:EE_|SA1PR12MB6821:EE_
X-MS-Office365-Filtering-Correlation-Id: 2737e662-f2f1-4f5c-fd24-08ddd9d7de33
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UlN6ZCtkNHNQalZCZTRuMXVhTG9DME10bnFkUHExMDlVZkhqdi9yZHAxK0hP?=
 =?utf-8?B?TGZLVVpFOWcyRmZQRzVzVWM2MW1mNm1PQUVOWklseWFrWHNER2ZSQ2djdE5O?=
 =?utf-8?B?aStYeEVURXhvRlVBMUNJMEJ5VCtQdTZkWVVPYTVWVlZGai9aOURxbm55cGwr?=
 =?utf-8?B?dEJJM1U5RElocUN6RENWNHhtL2RnOWVzQzhxWktCTkI2WXNuSTUyc1llWVhM?=
 =?utf-8?B?Yi9BMEZhS3VUUHJNUEYzTEN2N3VnbVpTUTJrVHVvcUVwMm1YRWlLVWJTL2hi?=
 =?utf-8?B?UlhJNXlZOGJlM1BoQUxMRXdIcDMxSzBseWFKcEdweU5ZaHErT21mMmx0bCtF?=
 =?utf-8?B?U0MzZE00THZTMzFVRGZlbU1Fd1FrUUw2Vzd2TW9GenBIdWtoeXRmOW1TMGFy?=
 =?utf-8?B?ZGxQRFdmNThRZHJTc1BRQTdkY1FWcGlDSmVNZEFzY3Q2YnZGaU9oOTRsZHUw?=
 =?utf-8?B?YVBTMngxWHNzekpYc29YK3R6bWNnVVM0K3NxMU51K3FtOVFZTmdyVFBaWWtP?=
 =?utf-8?B?SktrQ2FYcWYrN2haV0dUSDRGdGZXRWlNVE5VbmVlM2JicTNyYWYzRnl4QkVu?=
 =?utf-8?B?b013WFpWb3h3N0g5SlJRMnNmdDZDMmVnUURuZ0JITE16K1NUWFRKZ29xSHl2?=
 =?utf-8?B?V3IxZVZRL0diZ2dNWVZlR1RMbVdHd0Z3S1J0c0t5Y005NVVneXBBaFZlRUdn?=
 =?utf-8?B?L2VXQjYrc08rVWpsU3ZxdEpVem5Ia0FiS0hJSDRZYzlud3h1cXlvcWRZckQy?=
 =?utf-8?B?WEZTQlgwTlZma08rL0VkZm9ESHFYTys0ZjEvUHdUdFdrN1ZKVG9YN2tHUzhE?=
 =?utf-8?B?MWpXZU5pREJVZUREQU01VzRzaFJQMEkvMDE5UGExUmZpV0o1UFp0M2pWL0R3?=
 =?utf-8?B?NkZSVG1tY2Jhck5LamNvNGtsUWRLS3lRQ0t0M1MrWEZyclpacVRVRUtkNm9r?=
 =?utf-8?B?c3FhelFLSFkrQXBZTi9xYjJjOFV2OGdmRVdxcEFIMk5HMTQ0UkxpRm5hd1J6?=
 =?utf-8?B?bDdxZklqR2duK2NMYWVrMzdzYW1wWWVDRGszQlNBeGFpd0VIODZQUVo2RjFX?=
 =?utf-8?B?akJTeGtacEMvN0ZUaWoyL0hYUHFQLzNOYjV2djlJN3VEblFCZy80U0xMTTFU?=
 =?utf-8?B?KzVVb0NyV3ZkQkVWcmJVYmdKNlV1VldlWVBtYWM1NVhGaEIwcTRxT1hlNisr?=
 =?utf-8?B?U3NpT3A1QXZmYUp4UFovdmJhTzcyb3phckhsMFFmY1l5c0VYTHczaEZPSDRq?=
 =?utf-8?B?a1A0a1NTWVFuTGpVc3poRlc0a0dCQllNK0tEdHlIazc5RWhwdEZQYjRYQTNX?=
 =?utf-8?B?UG5ocmVzbUpMeDJvTnhDbHhRcXBEVHhXaGpIMGdiSUh4YnRiWVRIWUh4RlRa?=
 =?utf-8?B?YTk1RHY5cVR0WUxxSmZPVXNvVnJMTVhBdFo3cWtsSFB5MXdvdU5NNXNNK09C?=
 =?utf-8?B?V2xlVDRRT1Q3UlZ6Z1hLYnl4TzhETXlJTFBhL2Q2cmZNZFZMSHJBZGR2UEpU?=
 =?utf-8?B?MGJCdWdpU1JxZXhCMHZ1MXQ2SXJxcVNxVEZ2VFA0U3dzc3RqK3lxeGExaW1a?=
 =?utf-8?B?anJNdXBzelM1L2R6RHYyTVFOSndmZlI3M2NLTFkwd3NXYVlSRkFsYVY5SURO?=
 =?utf-8?B?ZllLcWUvYjN2Y3psMk9PWWxvSk5mcUhJYnNvTkkvN01zSit0bnlSKzZhbFda?=
 =?utf-8?B?SlcvUURseEQzVmNSMkNDdW03Ymx6aFRPYkYvZCsxalJqL1pFb2pZYXV6YmQ2?=
 =?utf-8?B?ejNRYVBIZW9nVjlhL2NoZDltcXR1Q2VPWmVPVDR6ZEVHRlZXMmlmRzljYlQr?=
 =?utf-8?B?bnJHSU5sNFI5UERHOGJ6REF2bXhodFpVS29tWjhYYWVmYjNRcjZISXVEVU5Z?=
 =?utf-8?B?cUxVK3NVb3NLT2tGVXJ6ZG9qZVdLa3NmWWZDSjJEdTdSZU1EZXZVVGRuNXNo?=
 =?utf-8?B?RnkyQnAzZHcwVjNiMVZtY0xNYjVhTktpUmNMWlRDZ0hlRXpaeHpINVA0TjB2?=
 =?utf-8?B?MG9FUFN4Q2NBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB9066.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SnY1WEJVdHlYRmVXTnNVLzkyd1ByV3pNZVdZelV3RWE2T0kyNS9JaDhmVFlW?=
 =?utf-8?B?TW1SMEJGS29iWXBHaFMyZFp4QTNBZDVvTnY1R3dhTzRJZGNGMnpLYVcxVFpt?=
 =?utf-8?B?aElCWWNtU3g5TGhCdzVPWXN3Q2IrbHp1YlY5WXkzbkd6dTBrTFZyUER5cjVp?=
 =?utf-8?B?L281TGEyc1NXazJRSUdHVWpUOWl6NElwQ241Uno3YkwyWVdRY0g3cHBYaTdj?=
 =?utf-8?B?TE5mKzRxV2w0bUo2Yko5UUVzK1dkZVU1K3creis2Z0l2dHlrMWwyUzVlZjBs?=
 =?utf-8?B?YmcwL2x5QlR4dnVZd2JTR0p3UmdmbUYzY3VFOEY4b243ZndQM1Q1WXQvME85?=
 =?utf-8?B?M3lldm9id0YrSzRtVGVrT3FiR1p4a21zalpzbXp6cVZvQWhyMElBNzZnTXBY?=
 =?utf-8?B?amRPQUs4c3lxNlVXVjlnd2pNTTIwYlcwdkhwMFlnTitXT3o0WG1wRlRLNTRZ?=
 =?utf-8?B?SjZ6M3FQeTdybnBzWnNwYXljckFoajFNTlhvOXkxTHNyY0NlY1E3WEpKMFVO?=
 =?utf-8?B?VjhUbkJrcGQycEVtTnUycnlaOWVIZmlIeHdoS2t6N2QxcjgxWHNraWRsUzlL?=
 =?utf-8?B?Y2J5d2R6UUJTOVRNWG5HUUhmQnNvc0xlWUNkVCtSUWkzdmJYM0U2c0xOcFhS?=
 =?utf-8?B?UFVEeE40VUIzV0l5akJ4WnZXSTcvYXEzK092ZkpWT0tVYXdRU05YeERnSVVs?=
 =?utf-8?B?elRCYkRtUTZORlNvWDNuQmQ2djlGVUd4UzRkZ1RyR2NOOE5lQU5BNEZkWFVZ?=
 =?utf-8?B?QmVVams5UTJicmVUcGpSNkFUUlF1c2lkY2dob1RyZ2FjZnBkUzBaWmdQYkh3?=
 =?utf-8?B?ejljbHo4cXhSWVcvRDA0TmZQc0lCZjVXRTBjUE4wenlPZUo2VFlQSWtvR2VN?=
 =?utf-8?B?dW5TMG5pZ3ZjSkJNSVZzUWFJMi9KaDllUVJleGY5MGVudjNURkdPajl6cTAw?=
 =?utf-8?B?aElwTUZ6UlpCSEl4amFFUUlzczZrcnRaYmtOZG9Pbit1dHdMMFJVZU4vdmZU?=
 =?utf-8?B?cktYeCtZU1RGQjFaY2lnSEhSRUpRR2pQSUJpNW9RVE1QNDlNd1hqZ2JFUXJO?=
 =?utf-8?B?dXN1YjZFRUpLUXhFMkN3MnhTV2xYaHVGUzBlOWh0ekM2a29seHNmNlY0T013?=
 =?utf-8?B?UVBaUmVQa0VvaWt1TjZHY3crZ1FvOEt5T1RkT1Bla1NEUGtMU2RvNXAxbW0y?=
 =?utf-8?B?bHFyM1BTQ2dSUkxHaHZtYnBxQjljU1RsYU4wcjhQYnNnaFlEdkU4SmFYWklZ?=
 =?utf-8?B?dTRoUkxsWUJCTkVZSThwRWdobUZXT3ZrcEhaZ1FqQzNmbGNBN3ozdXcyTFBC?=
 =?utf-8?B?Q1hxcE9sQWNQZDlQd2lCZGRmRGRKR09SNlVENFpZQWxGN1R5YUM5NGJ6dVVn?=
 =?utf-8?B?dXA5VHVUYkQ0SmJ3WVBabGJRcGY4OElJcEJ1aWFGY1Q2QURwQ3NxdmtRZ1pQ?=
 =?utf-8?B?SmltcUhNc2tnbWFnUEFuR1VXc0R4N1lJekVDSW5taFJBZGc1MHF4SzRHVjlK?=
 =?utf-8?B?bk9EMmE4UlNCTnpLazZpQzZBTkR3T04wek11ZnlkU2pEZDJaaDczYXB2Qkh3?=
 =?utf-8?B?cHBzNDdEdDFPWkhTc3E0N1N2Vy9qZktkaHFZRFdzcUxBSGZYd0VScVc5aWxt?=
 =?utf-8?B?c3l5amdubit4TGcyeitKZ0pCWlVOM0NWTGdmTmVtTFBpMHV2R3NkRmV6Uy9Z?=
 =?utf-8?B?NitRSTFaYVdsbGZYcnMxaklpbmxvWmFjNmZCNUtlZEpUN0hQWTB1d3MrYmh6?=
 =?utf-8?B?N0Exejc5YWsxTkNTSkJxeWdVSU4wZkRyLzhtcEE1eldTaTZwTlhocXdEU29n?=
 =?utf-8?B?YmxVZkorUm12NzJkUVc3NjBxMG1wRUVsbnA2TVdBYTdPMlJyQ0Rwc2hQZ2tT?=
 =?utf-8?B?MVJUSkJ1VEZKVXliVzA5RkZqU3o3YmVqNGVLbkoxVTZScnE4MUN4VXFsVFhs?=
 =?utf-8?B?dEtKVlRBQkhlS21LUk5CWHFsOWl0dWM5ZEVybzkyK2E4Q0lnL09rVDEvMzVI?=
 =?utf-8?B?bFhuc3owVTNlRlR5aExGeWpibFl3RVlmUVdIeENScjErdldSbWdPU2ZmaEpt?=
 =?utf-8?B?cXo2a0Z4VDNkUWMweW1DdktRWGs1Tnd4Tmg2NUFSOUhUdUJtNkVKOG9qTkp2?=
 =?utf-8?Q?6JtUd4E7KokT6DR8ukoruTq6F?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2737e662-f2f1-4f5c-fd24-08ddd9d7de33
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB9066.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2025 19:38:52.9577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BvLxSM+t0DDy31Mw0ohLJtkX+WDTGebUxQrrWzixpoU7noDFjc0AIUlFvQuSfp0o19qPRYxGo6xcwlqY5Wc1Sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6821


On 8/12/2025 2:11 PM, Kim Phillips wrote:
> 
> 
> On 8/12/25 1:52 PM, Kalra, Ashish wrote:
>>
>> On 8/12/2025 1:40 PM, Kim Phillips wrote:
>>
>>>>> It's not as immediately obvious that it needs to (0 < x < minimum SEV ASID 100).
>>>>> OTOH, if the user inputs "ciphertext_hiding_asids=0x1", they now see:
>>>>>
>>>>>        kvm_amd: invalid ciphertext_hiding_asids "0x1" or !(0 < 99 < minimum SEV ASID 100)
>>>>>
>>>>> which - unlike the original v7 code - shows the user that the '0x1' was not interpreted as a number at all: thus the 99 in the latter condition.
>>>> This is incorrect, as 0 < 99 < minimum SEV ASID 100 is a valid condition!
>>> Precisely, meaning it's the '0x' in '0x1' that's the "invalid" part.
>>>
>>>> And how can user input of 0x1, result in max_snp_asid == 99 ?
>>> It doesn't, again, the 0x is the invalid part.
>>>
>>>> This is the issue with combining the checks and emitting a combined error message:
>>>>
>>>> Here, kstroint(0x1) fails with -EINVAL and so, max_snp_asid remains set to 99 and then the combined error conveys a wrong information :
>>>> !(0 < 99 < minimum SEV ASID 100)
>>> It's not, it says it's *OR* that condition.
>> To me this is wrong as
>> !(0 < 99 < minimum SEV ASID 100) is simply not a correct statement!
> 
> The diff I provided emits exactly this:
> 
> kvm_amd: invalid ciphertext_hiding_asids "0x1" or !(0 < 99 < minimum SEV ASID 100)
> 
> 
> which means *EITHER*:
> 
> invalid ciphertext_hiding_asids "0x1"
> 
> *OR*
> 
> !(0 < 99 < minimum SEV ASID 100)
> 
> but since the latter is 'true', the user is pointed to the former
> "0x1" as being the interpretation problem.
> 
> Would adding the word "Either" help?:
> 
> kvm_amd: Either invalid ciphertext_hiding_asids "0x1", or !(0 < 99 < minimum SEV ASID 100)
> 
> ?

No, i simply won't put an invalid expression out there:

!(0 < 99 < minimum SEV ASID 100)

> 
> If not, feel free to separate them: the code is still much cleaner.
>

Separating the checks will make the code not very different from the original function, so i am going to keep the original code.

Thanks,
Ashish
 
> Thanks,
> 
> Kim
> 

