Return-Path: <kvm+bounces-34088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E3CF9F7193
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 02:12:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B31A1169324
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 01:12:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFA684206E;
	Thu, 19 Dec 2024 01:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Hhy/X7Ah"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2044.outbound.protection.outlook.com [40.107.94.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB6C1863E;
	Thu, 19 Dec 2024 01:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734570716; cv=fail; b=RF09Ecb3xC/CatqcDCsxToXzp4mPHIefKClKI8wEGsQ1u/zmWSyPrlNqImzHnpmzt/ykuum6rfhg6+8Sj5Zj6g4jGgTOn80krpg9lnCUIp1EgXodQtQiD2ymq1/ZXW2WoAMIe7Uj8EsX0uPRwYth7vUO0LK/QwBkZmhM088zumw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734570716; c=relaxed/simple;
	bh=UwAKHXxbHmg4AzMMZFKFJyoJhI3zLKpROr3+OEDVxQ4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Tfh7JwUoqjIfAtJxO3jrAgaJobX+cuhrhk8d5o5tMqoh6yx6Fu0ObkH500UKac5yp3laDbSSlbQrS5JIs0QtAr8BSCEZ7GDWorWpD0p8M55mYyYFLsgtf8QULTqLLMEAefbcdONMUcfvmP8T74OAynjb2tSeCdNWNxHDqX+P8oY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Hhy/X7Ah; arc=fail smtp.client-ip=40.107.94.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wn7sqoQDIfU/BqnBmOoOhJo6sP5SsubUNTXKAXPn9X4N5MiyS8CsiCuW/S2csf1DEOXiKDumU/jKplj7ByQzDEz8eOLuafUgySj8VDF6CfFCy8roFi7BDdJu0E7XTw2u1taf/J+grcBr2Q6NGCFUQ9Cpl4G1MjFC+361rJAjsdFhSGHuqr55q5YNFqnjcH9gfRjzAc6l8pqgI8NH8V626ql5MxCfk98pEn5Ov6u727BAnAb9fNFXx5+IIWFzqSeST84fO9KKxTwEa1YCnRXes3bUGR9MvGIaFBAWy+GvdIVyENW3Ws5y7n8fvS3e3HOEulf9c2IcNtgRNEEmybsEDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Phz/99xcjp//KAo1hmbP8zWaFQW5MVC6IhWDDXX2y5s=;
 b=rJ4C32CAJLsV2iPkFRmof01vQ0Wn+RBtzqxbfSHo//sku4FspVqzSf5gdqbj4QVWdgAn6Dkiuihri4MMixDFQVovCsza2kYwFCXEWWbyMN0PeDJFIfsvt1ZnpoBRu1VJzg1nBVVAk5KgQMvO+nG1yJlFGQwMNSy8PCSVsCIieqxl2WrOy8SsKG3PFRwm3XcWqScuSLjbNhhQEbCOd0WzVheBRY1Rmf/biAGBA7m0Zn+Gdt85K0oETlxDsBUkpX6o7HLfWRSeAM0YucpiQn3qwUYgFHFZ1m7QJyrlHrEv6eQdJg+64LrRUCNrxWz0z195PmJCI3aPGL9VsGKSg+x9TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Phz/99xcjp//KAo1hmbP8zWaFQW5MVC6IhWDDXX2y5s=;
 b=Hhy/X7AhgiqvrB33rt1SWjlrtxo2YhpK53Uoy+tHOZnBtjnPSP8KW6x3R99bxyJ54/gd5XcEBc7JLcbz6XBbIrrxAs6SONwY0yJ+nsxxmKoPn5DhKW5VUJH/HFbdjptIBnKbfYmlnVcT6g3/fkf5VFO+SCIO8MwG+n7m9SyuMxw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB9066.namprd12.prod.outlook.com (2603:10b6:510:1f6::5)
 by MW4PR12MB7336.namprd12.prod.outlook.com (2603:10b6:303:21a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.12; Thu, 19 Dec
 2024 01:11:52 +0000
Received: from PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::954d:ca3a:4eac:213f]) by PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::954d:ca3a:4eac:213f%5]) with mapi id 15.20.8251.015; Thu, 19 Dec 2024
 01:11:51 +0000
Message-ID: <3ef3f54c-c55f-482d-9c1f-0d40508e2002@amd.com>
Date: Wed, 18 Dec 2024 19:11:49 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/9] Move initializing SEV/SNP functionality to KVM
To: Sean Christopherson <seanjc@google.com>
Cc: Dionna Amalie Glaze <dionnaglaze@google.com>, pbonzini@redhat.com,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 thomas.lendacky@amd.com, john.allen@amd.com, herbert@gondor.apana.org.au,
 davem@davemloft.net, michael.roth@amd.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-coco@lists.linux.dev
References: <cover.1734392473.git.ashish.kalra@amd.com>
 <CAAH4kHa2msL_gvk12h_qv9h2M43hVKQQaaYeEXV14=R3VtqsPg@mail.gmail.com>
 <cc27bfe2-de7c-4038-86e3-58da65f84e50@amd.com> <Z2HvJESqpc7Gd-dG@google.com>
 <57d43fae-ab5e-4686-9fed-82cd3c0e0a3c@amd.com> <Z2MeN9z69ul3oGiN@google.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <Z2MeN9z69ul3oGiN@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN6PR05CA0031.namprd05.prod.outlook.com
 (2603:10b6:805:de::44) To PH7PR12MB9066.namprd12.prod.outlook.com
 (2603:10b6:510:1f6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB9066:EE_|MW4PR12MB7336:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a85e4d6-3835-44f0-23ce-08dd1fca1ebf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N3MwNjFaWUtzVWprczBwUHU3S2dZWTZ6dFpiMmFkQWNEVkZlQm1BeTBiS0F3?=
 =?utf-8?B?WTZOMUora2NwTytYN3duNUlzNU0yL1RYb0YrQ0VOOXpjaXVkR1VLeGNlTG1o?=
 =?utf-8?B?MzEzQ2tSSlBhOWlNWjZFeFBtc3c2VkZ0cHp1M29vZDdJdEJ6Njh3d2p0TUR0?=
 =?utf-8?B?T0JBTTdSUjVLSmFoOUxMNzFKTG9XZDVYYWF1M0RZazVEbExGOUQxTDlkOWNH?=
 =?utf-8?B?dk1NY21NU2hKR0N6VDBxd3J5QTF6UmI2OUd2UzJCMk1DOExHLzFmbzN1bU1C?=
 =?utf-8?B?U3dVblhZSzI2SGM2VGdCNWx6MmtEQ0R0TkV0WUJ3eS9kRGNxdWxrMnZZUkhy?=
 =?utf-8?B?Nytaay9IelZ6N25DYWFhVVJla3o2dHNwUnBxZisySEhVeVRtZlowb2hvdVlK?=
 =?utf-8?B?RmxhbmF5VnBFeXgwY3pRYmc2NXVJWTNhZEtxeEpiNm95bW9DR2FTTGNzbU40?=
 =?utf-8?B?TTBNTktmSGpIdWhKbzd0R3Rkb0hFaEpXYTVUSmNyYThBOFpjdWpNVmZ5YjJa?=
 =?utf-8?B?bFhRWmFTZXlKNCtVMWFzY3pzRTFYS2VENXZUWUpVUHdWVjgzMEhLRFpWdG40?=
 =?utf-8?B?VS9BcWtYSzRsVDV0c0VkN29EcFBtZjJrVUlTRStFMklyWmJXWUlNM3R2dkRN?=
 =?utf-8?B?UGwvUWViRE5yR3psNmY5VmxzL29TbW9mOGpoZjFRNng0ZzFmbGVlTFV3YjI2?=
 =?utf-8?B?aTNrdkc2UVZDRzQ0WnFMeWg0MVZxUUZWa08vYWpiWUQ1eWJBUnU5UE85ZWtt?=
 =?utf-8?B?U1A1UkpKaTFvYnAzOTlPNllYdUZnUzE4M3JiczJUaXBJWEVxSnVCZ2E3Rk10?=
 =?utf-8?B?M3FkNG1VMUdWM0VEcDI0YUsvUzRZKzBSSHdnV1FyeUp1anliMmxKZVZvL29v?=
 =?utf-8?B?WXh5dmlCbDZrQUlJWmR1c3A4RnFQNFVqT3BBdkhOUWZaTTRTQXcwSi85dSth?=
 =?utf-8?B?Rzl1M3hFMlhBbElEbGQvcGtWbGhQSC9BZE1hMWhmbXVuZ0NtMXJNajFFczRP?=
 =?utf-8?B?eVQxYk1CT0w1WXRDR0tIcUhZWjZxekxncU1NcjBHaXpkK1JVYnJ5bWYyMkVM?=
 =?utf-8?B?TUVlbCszcldza3UyaTl4VFoxZU56LzhQMjhZMTQ1OEgzTURWenVNckJxOUhG?=
 =?utf-8?B?K0RxMllpRjRocFdUSnlBUUxkWWwvaXZWUmR1S2xzdDJ0bk02MEdmNVdWS3lt?=
 =?utf-8?B?eTJHb3FRTXdQMHE2ZWdnK0pwT2duSjJraDFSNU5XQVFNYlNHS0V5TjFiNkgy?=
 =?utf-8?B?cUN4YWtOdEZEanBWckZ6ckJFQjNSRWZJSk04cHBHNk55M1lSKzdrOHZncHM3?=
 =?utf-8?B?WVBCc3RPY21RcDFzNmpBMnU0ODNnOGFuTGxnRmU3ZThYajFQUjg5WUFaTGNq?=
 =?utf-8?B?WEE2R2M0cW1pZ3RqK2t2bGxIV3lVN0F6Y1ZmWU55QTlMVURLazdaMkdFL2h6?=
 =?utf-8?B?Z3NHWXJYdDZ1MzhTU0diUkJ5R1NpcURNME51TGNSb0xjY0MrK2pTTmVVR1Q4?=
 =?utf-8?B?THhOTVJBRjl1cG5iczA3c3UrL0RMQmpVNFQrN2ErRDRXMmVDZU1ackFlT3Zk?=
 =?utf-8?B?M1ZNaEhHRTI3ajc0eFFqOW42SlBiMkU2T2cyNDJMQlU1STh1VE9tL2grSlQx?=
 =?utf-8?B?OTdlZkpmMnNFSHZtdGkzTmFjbi9LVWZXUlhYUmMrRlZrTENHc2hSUkNUZ0E1?=
 =?utf-8?B?QjFSSkMrclRvSmpLNnJnbHpwN25RM3k2MUtUK2VMWFR6WkhzU2dLVDRSTVU0?=
 =?utf-8?B?aDZBcVVCeGQ5cFVoNHJkaDloWFUyeUtaS0F3TmJPS0JRVlFTcVgrODN3VlBl?=
 =?utf-8?B?MVpnN2tCSW1EY09WTFF1TTdGdWVrVkZTaXIvR0RSZ1EzUldBWWYrVEVja1RQ?=
 =?utf-8?Q?SgUcczBCcZSiK?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB9066.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QUVLNlFobk9HZkRpWmNXRHZtamZQQU52RkVnQkxFNTBBRXZ1Ymx3YXVnN0Z5?=
 =?utf-8?B?aU9JUFVFSkJma1QvcjZBZDZGSmNxSDdteW5qMU1wQjJMSStOM2RIeHdvZjFQ?=
 =?utf-8?B?a2YxcVQrR2dxakRHNllva0JDL3E2am1BQmhieEhQcnFnMSs4dVVkU1h0Uk1E?=
 =?utf-8?B?MXVQaFVBSDRpWGdrMnJZdGg5amNtMFVyQ0sxYXo3MkFLckM2dTlYcEhaMnZI?=
 =?utf-8?B?T245QmtNVk5mazFpd1FBU2dPOUpsTnVlOFdWaEk4MVpNdFd6aGlpdU82YmlG?=
 =?utf-8?B?M0N6ZTlkRlJZMnhSQkQ3dWYrRkFMbnd4WDF4c29IaityaktjVG8xbHBOSklE?=
 =?utf-8?B?Y0dYZ3k4OTdQMmhVNnM0Vnp1alRxQXRCWk1TU0FIYUM5Q2NHcWhwYnJjK1VN?=
 =?utf-8?B?L3lLaklEZUdPU3BYelVFbnVvV2xaUldVcWRQVHgxL2o2NGI4OFc4eGl0WmxI?=
 =?utf-8?B?aDViRmF0YWZ2SHU1aU11UStYZmovd05lZU85aVJLUTVLdTY4Vlo5dHFJb2lP?=
 =?utf-8?B?cGhPM0pVMmFzdm5kV3Vkb0pZTGlFYi96K2hsMkt3WWNDaEVnKzdiM3pPUFFs?=
 =?utf-8?B?VDZYWHd6VzVLeitqbFlOUzJMZkk1Rm9FSExuNi8vTkxYMzFGK0JWbG5BdGx0?=
 =?utf-8?B?OXNkMXBUMTlxYkNlQnN5eHRLdEM4MmM1YnYrVmlUUXJqOGV1cGdnSGg2NU4w?=
 =?utf-8?B?QitDaWJxU0p5QmtEblB6WkhhRmdoTjVJUExiM2o4N2dtL2RvWkhxeVE3RTJh?=
 =?utf-8?B?VTN1ZDBMb3huZFZMOGxFTDBFVGZ2Qmd1U3lKd1VrbmtmZGZvTTJTeitNVkNa?=
 =?utf-8?B?eHFKVzk3em5CV0xFWEdTTkNGTnpPeEI1OWFFdzlnTWVIM3FVbjc0b3VUK09L?=
 =?utf-8?B?V2w3VkZjS3haTzlOSUNRZlJIY0tYU1lMZG1BcExMZGNkQ1ljYUgrdHFZcGhI?=
 =?utf-8?B?NnBBN3F6ZDl3UVBIdDVIWGJNK2pZNHZNcU5WMU1SbXgzWnk4RlkwN2w0emNZ?=
 =?utf-8?B?L2kvYldSQS9xOVdaQU1qMERlVDlCVW1zcytUYW13dWI2RkJtMTlCdE9WNTh5?=
 =?utf-8?B?LzRBY21PTkZYamRtSFdrbk82eDdkTzNXc0lEcE1teEx1VmZYK3BwZ0dUb2c5?=
 =?utf-8?B?dlprYUFIWjU5NlBKMEJrSnFHait6dU03NjBGdlBydWJDL202ZWFMcXVvSTdP?=
 =?utf-8?B?akNGZ0ZDTEQ4cUNmdE5NMzlzaXpDbjNub3gwM25hZWFWVGt1c1N3emljcGxt?=
 =?utf-8?B?ajlwZHZwOVpEbUFPckIvNzdUbjhlQjZDN0RxVjNnMmhLMVVNRm81SDAycmhq?=
 =?utf-8?B?ZTZJY3cySUtXQXlxVHc4b3FGL2JjS1VTK1dvZzFSbzJTaXVZZDFndHJqWEV4?=
 =?utf-8?B?TXFHanhHT2FCTFRkY3RzQzMyK3E3TkI1VUlJNlhyUjVnTit4RnR0OStUazdv?=
 =?utf-8?B?cVZTOUZyNjVVa1NRb3BMUDJ3eFg1TlBhbGNocHRyR1JlaS9GMmsrNXdackdw?=
 =?utf-8?B?Q2FvQnRRN0tpbGVETFZQSFRpbDlGNEZYSUhLSnN1NTFPMWJjM2V1TGYrRkx0?=
 =?utf-8?B?U2k0QitVRVg4cDViYkpURFJQb2NlUmY3ODZFcDVSZUR3K2h5TGFMYlVnMXNC?=
 =?utf-8?B?THBmbTdkeWI4a0dPZWtqaFZsVGNzZnRWaHFRMFZ2STltcGRlcXEvSE1UZ214?=
 =?utf-8?B?MWdFMVhDWWhPaWVxYWpzanNDVlNLc2wvVmZTdnBGUzJnYS9mZGI4enFlZS9m?=
 =?utf-8?B?OW9Lc0NET2hSaU9hZVlMVGFkMlJtVFlqTXNRelRsb2FBazdnUkgyTXZTUG1w?=
 =?utf-8?B?NXhrSnNQaEJEYzRra1RXaDFQRnRLZm5LbjF5VXdNV1p5SWFMOTZ5R0FhSWRn?=
 =?utf-8?B?eUZCWkJicEljZWtlRHB6eHNvL0RHTXVQQW9RUWRUQXZscWdkMUozUGRiTXRn?=
 =?utf-8?B?ZlZzQ1NWSHFlNVZuQ05tZDM0eE5GVzNGdFFjZHNLckpnWk05VEhUUDZYRFBh?=
 =?utf-8?B?SmtpN09VY2F3N0pPN3Q4RVYxbzNrR05YS3FQcGF3TW51MFBGQ2hPMWdJS1Ix?=
 =?utf-8?B?WU1wQlU3aUhMdkpGZndBWC9JMnI5TkE4WndKZm8rNFc1YUY3alVWemJ1YW15?=
 =?utf-8?Q?wohpsU3m94WIxetVLWvzQKPqQ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a85e4d6-3835-44f0-23ce-08dd1fca1ebf
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB9066.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2024 01:11:51.7895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J3Kyb54J5gCQ2CBhUViQa0K9PKjZf4mDfwmEywA+jbx9d2F5Jf685ojiUBkoVfKcYlL5ChLW112R8jvW4Fpk/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7336


On 12/18/2024 1:10 PM, Sean Christopherson wrote:
> On Tue, Dec 17, 2024, Ashish Kalra wrote:
>> On 12/17/2024 3:37 PM, Sean Christopherson wrote:
>>> On Tue, Dec 17, 2024, Ashish Kalra wrote:
>>>> On 12/17/2024 10:00 AM, Dionna Amalie Glaze wrote:
>>>>> On Mon, Dec 16, 2024 at 3:57 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>>>>>>
>>>>>> From: Ashish Kalra <ashish.kalra@amd.com>
>>>>>
>>>>>> The on-demand SEV initialization support requires a fix in QEMU to
>>>>>> remove check for SEV initialization to be done prior to launching
>>>>>> SEV/SEV-ES VMs.
>>>>>> NOTE: With the above fix for QEMU, older QEMU versions will be broken
>>>>>> with respect to launching SEV/SEV-ES VMs with the newer kernel/KVM as
>>>>>> older QEMU versions require SEV initialization to be done before
>>>>>> launching SEV/SEV-ES VMs.
>>>>>>
>>>>>
>>>>> I don't think this is okay. I think you need to introduce a KVM
>>>>> capability to switch over to the new way of initializing SEV VMs and
>>>>> deprecate the old way so it doesn't need to be supported for any new
>>>>> additions to the interface.
>>>>>
>>>>
>>>> But that means KVM will need to support both mechanisms of doing SEV
>>>> initialization - during KVM module load time and the deferred/lazy
>>>> (on-demand) SEV INIT during VM launch.
>>>
>>> What's the QEMU change?  Dionna is right, we can't break userspace, but maybe
>>> there's an alternative to supporting both models.
>>
>> Here is the QEMU fix : (makes a SEV PLATFORM STATUS firmware call via PSP
>> driver ioctl to check if SEV is in INIT state)
>>  
>> diff --git a/target/i386/sev.c b/target/i386/sev.c
>> index 1a4eb1ada6..4fa8665395 100644
>> --- a/target/i386/sev.c
>> +++ b/target/i386/sev.c
>> @@ -1503,15 +1503,6 @@ static int sev_common_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>>          }
>>      }
>>
>> -    if (sev_es_enabled() && !sev_snp_enabled()) {
>> -        if (!(status.flags & SEV_STATUS_FLAGS_CONFIG_ES)) {
>> -            error_setg(errp, "%s: guest policy requires SEV-ES, but "
>> -                         "host SEV-ES support unavailable",
>> -                         __func__);
>> -            return -1;
>> -        }
>> -    }
> 
> Aside from breaking userspace, removing a sanity check is not a "fix".

Actually this sanity check is not really required, if SEV INIT is not done before 
launching a SEV/SEV-ES VM, then LAUNCH_START will fail with invalid platform state
error as below:

...
qemu-system-x86_64: sev_launch_start: LAUNCH_START ret=1 fw_error=1 'Platform state is invalid'
...

So we can safely remove this check without causing a SEV/SEV-ES VM to blow up or something.

> 
> Can't we simply have the kernel do __sev_platform_init_locked() on-demand for
> SEV_PLATFORM_STATUS?  The goal with lazy initialization is defer initialization
> until it's necessary so that userspace can do firmware updates.  And it's quite
> clearly necessary in this case, so...

I don't think we want to do that, probably want to return "raw" status back to userspace,
if SEV INIT has not been done we probably need to return back that status, otherwise
it may break some other userspace tool.

Now, looking at this qemu check we will always have issues launching SEV/SEV-ES VMs
with SEV INIT on demand as this check enforces SEV INIT to be done before launching
the VMs. And then this causes issues with SEV firmware hotloading as the check 
enforces SEV INIT before launching VMs and once SEV INIT is done we can't do 
firmware  hotloading.

But, i believe there is another alternative approach : 

- PSP driver can call SEV Shutdown right before calling DLFW_EX and then do
a SEV INIT after successful DLFW_EX, in other words, we wrap DLFW_EX with 
SEV_SHUTDOWN prior to it and SEV INIT post it. This approach will also allow
us to do both SNP and SEV INIT at KVM module load time, there is no need to
do SEV INIT lazily or on demand before SEV/SEV-ES VM launch.

This approach should work without any changes in qemu and also allow 
SEV firmware hotloading without having any concerns about SEV INIT state.

Thanks,
Ashish


