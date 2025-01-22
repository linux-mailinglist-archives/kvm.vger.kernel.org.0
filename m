Return-Path: <kvm+bounces-36255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 74F8EA1950C
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 16:23:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0EB2D3ACA23
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 15:23:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06E0F21420B;
	Wed, 22 Jan 2025 15:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="IYpr/Ddn"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2045.outbound.protection.outlook.com [40.107.100.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957EB2144D9;
	Wed, 22 Jan 2025 15:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737559383; cv=fail; b=jMlsb3pRECvh5QUHUyNWLw2hBt/4gDZc8pV1Ch8jfVQCNAMpcW/EPhWyGGxMcCi6Q2AfPLyPb3pOwvtLMrfUU32uhvLc73VmtQh6eqlwdbbjQOeINfWYYmIwYz5SHyFevSEk2iQ2eKTmrgrAA5nYWAVMtmar6C3QNxluY9p22/c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737559383; c=relaxed/simple;
	bh=jKHWO9o+bXStHXxWub8hZ0bVjmz+1nUSwyDB2LFG2Ek=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=FfFVCUZDwXznDj7xDNjQmVb3gPE7/CoEtynXw05pRbVS4UfihD59yrQr1Kmh0pHbcC6YyD5qvZ2BSUC6L10D4LWgIM2a3V3CS5scr30rXF+6zPCZGCw1MD/0leZTJY2ftsEVzEP2iHtnkNyEHyuXX5rnLVSludhMs6cK2+zIZCI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=IYpr/Ddn; arc=fail smtp.client-ip=40.107.100.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FnMs+Rjr/FO+wRtOqMFk2Z27ZnKVjFfPAEdMgXQx33VjWzTaaQZf6NOYPR3hB6G9kzeFaa2aXBebHAySUJqivyvFikX1C06NTn9Ugaga8ABA1LVgmEZ/+eyGaIWgV/ZWIZ70osw6s9yfD/E99oXT6dI0xGWIpdT2kaavXGyqoqs0j7hHj7LdbkZLKIw4QI71lDbRbK8RwlDmymyl8H6Dp+X763FqTHeFORb3rRyiOpCjXbsgWQwHNNgQgg3B7HvNRXo+hA59+CTjvZcBEJlOSa90E+gte8PvX9P5LMwrtVP69tnZRp77HptCGhVyQGXHnPNJCGt5zh7ykVOTRbwjAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X8eJONigEalRExAZ0iOsQsAtQyy+ygJUf9u6WbQc5qs=;
 b=refnjyBsAFYb1ggRbDsjTm9QAEONOOjNNR30oHpo72qnbCt8Knl1f+BioD/XpxqjmabOl9mF9GEf+fYaTWVt2ZTL4DYyZCguv/jMAHTF/c1eJHvQTcTy95CTgPrAc/KaNWTUqzDEzpXO+CyVa/gSg7UZlkJG9mXitmHl9jvFvIpoRu03ZRH+nzuI2gd2TXKyIfK2w68PorJq8A8XaOPypWLT+aYfOEo77REO5yMG5OukNizEk8EPgq3Bg6GBx8beIHR7zGkHmNCGyC7tT6y9lblpgJwRJakw6rhNJyr3dPmXm+nm0wjuSkLN0bQs0JPVBarPsQBnfkDSxZGNEdGQOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X8eJONigEalRExAZ0iOsQsAtQyy+ygJUf9u6WbQc5qs=;
 b=IYpr/DdnN/jqaBZpxgmvWCUJoqQG5PyabPkuqRS7V5TFlp/IBtu9oJ7FCGZUW52aj8o0DHwt9nMsEjomOBTEIiVK35JT/s0Sp+78rK0I+paU6U6uxFteEgjuQE3VQ6gU4eNbFz9hXRlzc8PAkyOm91el2YyEW8AL7F58l++pYHc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by IA1PR12MB6209.namprd12.prod.outlook.com (2603:10b6:208:3e7::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.21; Wed, 22 Jan
 2025 15:22:59 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8377.009; Wed, 22 Jan 2025
 15:22:58 +0000
Message-ID: <c310e42d-d8a8-4ca0-f308-e5bb4e978002@amd.com>
Date: Wed, 22 Jan 2025 09:22:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 joro@8bytes.org, suravee.suthikulpanit@amd.com, will@kernel.org,
 robin.murphy@arm.com
Cc: michael.roth@amd.com, dionnaglaze@google.com, vasant.hegde@amd.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev,
 iommu@lists.linux.dev
References: <cover.1737505394.git.ashish.kalra@amd.com>
 <0b74c3fce90ea464621c0be1dbf681bf46f1aadd.1737505394.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 1/4] iommu/amd: Check SNP support before enabling IOMMU
In-Reply-To: <0b74c3fce90ea464621c0be1dbf681bf46f1aadd.1737505394.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0040.namprd04.prod.outlook.com
 (2603:10b6:806:120::15) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|IA1PR12MB6209:EE_
X-MS-Office365-Filtering-Correlation-Id: f58ac867-4188-4b21-e2d6-08dd3af8a6a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q0pTWmhoc3BxeVFrb01uRUIrZzJubDRNRm1Nb1lCRjBHV0lyV25yVUxMeC9h?=
 =?utf-8?B?bHFRcDZyR1J5bUNvenlxN1gwYml3M3RQbklTWUJIUlFxWkZUUkY1T2RFQzM5?=
 =?utf-8?B?MzE1eUcyblVXb1lESEtVaFdnK01zTFoxY2NIYUVBWDhkUmZsNDNNcHlYY3VL?=
 =?utf-8?B?WXB6OUtpYzNOUVZSc09qd1pmOHZHQ1hmRklyUGxLbTVqUkx6blRROTUzMWdk?=
 =?utf-8?B?dFpPbWRybmNoaDRzeThwRFFRcWhDTHJ0WHVOTHgyb2h0TWxZV0pHejJvVDE0?=
 =?utf-8?B?Nkl3U2pSYTI0ZDVpdTI0OFh2N2NLa3VDU0plWnVqSk85aDdKZUxRL3lsM3Rr?=
 =?utf-8?B?Z2lSeHZQeURva2pEd1Y0T1R6RE1sVC9YLzBsUU9DcmxBY1c0OHREeFpxMXIz?=
 =?utf-8?B?bHN6NjgzVXAyTVczQkM2R3FhaytublpRNmN3d1d5SkhJOXk4c000QTRwcjB0?=
 =?utf-8?B?MURqVU1oR1ZYZUxwS3ppa3FQSUtZT04xMzF0WXNEVFZ2VlNpRzhMd1pUWUg5?=
 =?utf-8?B?TzNsMWhjcEU5UUlhVU5ERy95elBzOExMZmt0R3ZmVmFaOTJ3cDNoam1HcGVv?=
 =?utf-8?B?WlNGSXdhYURZcU1Xb3Z2VCswSEdiVXB4cm92SWpvNDAxbUNkRnBBY1BLVVN1?=
 =?utf-8?B?d2V3alArOFdxb2tRYUtpMFM1dkdDbmF3d0FYQTlXY2pZSWt6UXJINXJrZ1lZ?=
 =?utf-8?B?Y2h1Ky9OMDQ0clQ3Z0E4OGoxZFdUWjhjV0RnMVNZVG5uRzg3SlJsUHRzSENW?=
 =?utf-8?B?d20wdlI4WVphSEp0aHl5bzBCYUtXRkxlNE5KK2pWTjVqSmxFbHNCZUVZUll3?=
 =?utf-8?B?bkR4eklkaDVLUGFQT2Q3dWhGRGxIREQzY1FLUkxsb2VFUktyVmxuZFg5OFdK?=
 =?utf-8?B?WHZzSUN5b0RmT2ZrL1R2NkF3WkducGV4UUtnYndWUmdIZVRaYmx4T1lYY1cv?=
 =?utf-8?B?K1BZNlRJaGxIbEtpV0FFaHE0NDcwZVhxY3puQlpNcE4rUG1rck5xZEViRXpt?=
 =?utf-8?B?bmUvL1NDMWFvUlJSUGUzZXM4bUdkbHVDdXl1YVVrYnpOTDFKaUkvR3RZTVpv?=
 =?utf-8?B?d3NkbnhxdUkvMktkTmd5azBJOVRncGFxTjFRWUZ4Sk9yU240Y2F2bHdlM2l6?=
 =?utf-8?B?cU9DcktTMnNkVlQ4a284NlVkNDFsWjd4SmE2TzlhcEI4OWdmUnNsRWhMSm5y?=
 =?utf-8?B?d3VBY0ZCaXc5bjhwYVk1UllLK1NLVk14OXJ6Kzg2QXU5NGpxN2t4RU1RNG5i?=
 =?utf-8?B?TXprS1ZqY3hxUGpMeEI2TjBhVTJZamk5dUlLejg2R0xNUzJObGRqV1ZScTli?=
 =?utf-8?B?YlRBU3ViYnYvY2NDVkdrMDVvZFlWSFhjTEd6TFB4a2ZBaE9ENGozZTJJR3dx?=
 =?utf-8?B?Zk8vb3cwdWFoZERpbEt2M3JXVWNxVlRRTThOais1ZWtBMXc3bEVQaTFPeWFS?=
 =?utf-8?B?eGtFUXVFNSs1QVRwQ1YrWkRuc2xNam1qZFBrL2V4WnRUd0tyVHhXbWlyMC9i?=
 =?utf-8?B?SEIvVVlQK1dJZFFremhDOExKTXAwQmRGbUYwSkZYUkc0eVMxUDhKd0VGdDYy?=
 =?utf-8?B?Z3ZNWTc2aXYvMnRuU3hXUDVZdHhremVuTUxaMkQ4dmJpeU54MG1tSGEvM1hN?=
 =?utf-8?B?UW9JeGNlTmxMc0NBR2xoSUJBMGVkSjZSSFJFa1BaSGRsU2NQa3RtQ0IrT00r?=
 =?utf-8?B?MjJ3cjVldWhZSCtwMk5JcTZ0akZ5cnhsUG1VSjN3RnpGdUJkNUNZYW00RWpS?=
 =?utf-8?B?NzlNejN0WUM4OTI2S01vc0FsNGYvaHRSVjBaR3h2Q3VRN1VpcVJQUFVHT3JW?=
 =?utf-8?B?S3lYUjc3ZmlRMFVrV0NxbklOUm9DRStEZ1BuenlVOWgyKzlEMm14SUNXVlJZ?=
 =?utf-8?B?MWVyRjYxbDhPZUZXVHE1MXFQRWNyR0tvQ1NzWURudE9FL0psSzV1TmRoSk56?=
 =?utf-8?Q?GMNH16OFm3g=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bEQ1UDdsaUU3T1hGajJQS2tUTkFnZnplOWpib0swZVJ5cWxlcExmSXBhOTZV?=
 =?utf-8?B?REs4dlRjOXh6MlZPYjM4K0YxUFptQm54TjFESURtQzIzYzJWWGUyV09SRndJ?=
 =?utf-8?B?R2ZmVFUyOE03czhsY1hBQkxDbUx1QVBxTisxMHhiWDJBdG9WMlZBMlJqZHM3?=
 =?utf-8?B?M21JOUszbU9adnJHUVgrbGRpNkpKSnhJS2ZFTnpzQituMW5QOG1HdHlUdFhJ?=
 =?utf-8?B?Z2RZTGpSWjgya1RkOC9sdWl0Z05rcGV4dkRxbWYxR21uVE5JN1BnVE95NHVy?=
 =?utf-8?B?aFRvSlIrY3dnK1lTWjQzTGVLbUt6TXM2V3VMSEIzZ25pczlJcUZPa0FIZjUy?=
 =?utf-8?B?YTZDYjB5Z2kxTHV1M05ocm0wQ1dpMDBkSFZucHlNVytCR3crVEZid0Y3OEs0?=
 =?utf-8?B?cGpsQjNiNTgrUjd2TzIzUmd4OCtscnBzdkZvV0EwMThhbEV1TDhnZVpKdVp2?=
 =?utf-8?B?aUJYMkYyRngycDNSZ0h3MG5WeHVnOUNZd3cxSjJFNVVObE0yUzhmQ2crd3BX?=
 =?utf-8?B?c01SazJqeFNDZUZUTlh6Z3I3ZlZ1U2ZwemhvVXVMMEZ2bU9GdXQrYUtHam15?=
 =?utf-8?B?VDJGUW5NN3R1RFA2a1g2Y3NuZzcxMzc4RDhZK3VEQWVscFVjK3FFMkNBd0R0?=
 =?utf-8?B?dURPZThEWXdHaFdZSjhSTEdNR3JRM2E1SnNsMGJ1cldkQ2x2RWNYOTRGZlhq?=
 =?utf-8?B?YVpWazcwSDNuQisxWnBBMDN2UXo4TTBBbENKV2FWSkk0dmpQSnRvOXhZdVVF?=
 =?utf-8?B?UTRodkFobjd3RDdIQVYvQjdxayt6anFnK2ZiaE1zcTZBOU5VaExpajhXWFdI?=
 =?utf-8?B?UE5rN0tDaWVpWlBRc0ZGN1NKdDNBM3Q4bUVnckhZYVpEYnZ5alZ3K3pXSUZp?=
 =?utf-8?B?RTF6aElENm5UODV0dnVtZGhHOXhqZDBCbkk5OUZWcVRjVU44RTBRSXA3eFZm?=
 =?utf-8?B?d3pyQU5XTmpqdk1oaHFHNkd4Z0c0aXp4dlR5T2phMzJ1UXdYTTBvQldzZVA1?=
 =?utf-8?B?OENMOVQwT3NzTTlIN2J1RlJTT1BSbW1GcC85SnNOK1BoMzRuaWVLWUtpdHpm?=
 =?utf-8?B?dmY1RHdRUEJNN2NhN1ExL0RNaTROZ0luUUVJWi9jSXNOM2NHMTE2Vjk3bmJK?=
 =?utf-8?B?TjJBT1UzTGRxQmtiVWQyUHIzSEJFWHBGa005WDNoVEFGYzZ3OXY0dHNhZGN1?=
 =?utf-8?B?YVlWSGdIR2F0ZC9OeUcxNmp1Sk1ZQUQ2OTFyVEsrWnRQTVNKUUgvTFhCUEhS?=
 =?utf-8?B?aTdrU2thc0sraXlxVjhsck1iU1QyTnpVNGFiVXA1WTBPdE5LSVh2Yy9aNzVW?=
 =?utf-8?B?YTZkYnZlWG9GNmhqcXM3amx2eW1DcnpGU1lMYmhNRmZYSUYyQ2hJVVJQbmRD?=
 =?utf-8?B?Y0Z0aFp1ZmJ0a3JMbjMrYWFCcmM0dkJlT1VjRGRFam96elpMb1QxbjRDSjZa?=
 =?utf-8?B?UFB2dEt3Q3cwd1VYVlhLUWxrZHViQ21lc1grMkJsaUxqKzkrZkJZTEhXRmJN?=
 =?utf-8?B?bUtRNDYxRG9HMFNFVXhLU2JwSXljK1AwUDNWTFk1SG54TEF6R21sOEJKRGVX?=
 =?utf-8?B?UTBtbFBiNDcyZXlNWGlaM1g3TmYzdmJ0MS9MR1RhTTRDRFc0bTBGa25nMlAz?=
 =?utf-8?B?QnRYbUN3bUJNUlMyT21WU2JCUmJkTDFqM0tmazc0OFZvS3lXUXZQMVExNTZX?=
 =?utf-8?B?SnU4MFhkQ1loY1BZSHJOTmtZMnJaM2RwUUsweVZjR3dwSXBEZFRHcGRyVWoz?=
 =?utf-8?B?SXUwVXY5UjFhaWJ1VzEvWjd3dUFjWmRnaGN3MUJxeGU0czFPYnB0SkdQZExr?=
 =?utf-8?B?NGY0UDkwcCtNM3p1WGJqN1BBNXFURnZzeHpReVB3VkZheHk2MWhtdnRGa09p?=
 =?utf-8?B?YU1sQVE5ODljNVJWS3FPelpQbDU2WWpzMEFNbWZMYyszTWQ4cjJ3dUU0c2Nj?=
 =?utf-8?B?MzIvSU1CVEFoR0dONXIrY0plWGphT0puTXBMNTY3Y0trSFlpak5kOGluczIw?=
 =?utf-8?B?NWM3bTYrWnNPTlloNHhKdkhHc2hLM1E1alcvbE94TS81UlY1ZS8vWjBTL0FE?=
 =?utf-8?B?N0dJV2I5Vlp3ellPYi9rVDQ2bWJRdTJOaUN6VkgydFZvODZSR1IxNFFUMmV4?=
 =?utf-8?Q?o9J8WfQIarZzK8UEFuj8kTe7N?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f58ac867-4188-4b21-e2d6-08dd3af8a6a5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2025 15:22:58.8698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aOsjB82WJSZvDwUmKNUbw3GAy1r2K/QxZj4iejaoXw+ghET8Xjit7NZqfQWYDzQCfY6TibJcdChEsPGZliuNmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6209

On 1/21/25 19:00, Ashish Kalra wrote:
> From: Vasant Hegde <vasant.hegde@amd.com>
> 
> iommu_snp_enable() checks for IOMMU feature support and page table
> compatibility. Ideally this check should be done before enabling
> IOMMUs. Currently its done after enabling IOMMUs. Also its causes

Why should it be done before enabling the IOMMUs? In other words, at
some more detail here.

> issue if kvm_amd is builtin.
> 
> Hence move SNP enable check before enabling IOMMUs.
> 
> Fixes: 04d65a9dbb33 ("iommu/amd: Don't rely on external callers to enable IOMMU SNP support")
> Cc: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>

Ashish, as the submitter, this requires your Signed-off-by:.

> ---
>  drivers/iommu/amd/init.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
> index c5cd92edada0..419a0bc8eeea 100644
> --- a/drivers/iommu/amd/init.c
> +++ b/drivers/iommu/amd/init.c
> @@ -3256,13 +3256,14 @@ static int __init state_next(void)
>  		}
>  		break;
>  	case IOMMU_ACPI_FINISHED:
> +		/* SNP enable has to be called after early_amd_iommu_init() */

This comment doesn't really explain anything, so I think it should
either be improved or just remove it.

Thanks,
Tom

> +		iommu_snp_enable();
>  		early_enable_iommus();
>  		x86_platform.iommu_shutdown = disable_iommus;
>  		init_state = IOMMU_ENABLED;
>  		break;
>  	case IOMMU_ENABLED:
>  		register_syscore_ops(&amd_iommu_syscore_ops);
> -		iommu_snp_enable();
>  		ret = amd_iommu_init_pci();
>  		init_state = ret ? IOMMU_INIT_ERROR : IOMMU_PCI_INIT;
>  		break;

