Return-Path: <kvm+bounces-34527-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 96B00A00A24
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 14:59:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 761AE7A1DEA
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 13:59:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BE431FA25D;
	Fri,  3 Jan 2025 13:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="GKW6M1SO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2049.outbound.protection.outlook.com [40.107.220.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE308145B3F;
	Fri,  3 Jan 2025 13:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735912771; cv=fail; b=pW8jPTdIztWEppHRdFxX4X1byBcdfMaQZyclffPxtfNiwat3MFRLBxH6X9e7I2SEVxR+FMGUxTvyKnvGbhVSTI9beNFHtbGmg4HRL18L5q1Z6jrAS3Bwi4JopCq3FkimPJfoNti5Hdyc+gDnC8dCCWDkY8V2Bpd1a0PVJ1S+Hg8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735912771; c=relaxed/simple;
	bh=9a0p3+V91a3OSHax0kbCtw3hZ5tpAZs1ef7699PJ+h4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KCckbFAM9KK8c9uXV/vmXCsELvC/DuNhUTuEuJLFGZWVjwcUxRifIaLMAwV5P7kUoLEQgbX5DiJW0uUuq/ZMjfRZNA8Ydo94Garr6ETYweIkef5HeDUy29XcGMsCCoJ1bIWSgZDLYC8fPAf6HND3ezoS+MgILgGulkd+g2b3RKY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=GKW6M1SO; arc=fail smtp.client-ip=40.107.220.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eC/Nu9WCINIVxZmNYDIXwAzOKifdFbMoSJQGUTb/fEvPaQl1PofSVLiimb9N3TDTMvSXPw9cS34lS0qcwEY8Dl29XCDscdifJNeK9OeApBS1xr8MCRwXRDDslzLv/hOWdgnbVClmPTQjhDt8HsN4lwvEQ9DXtbjgJZsF6If2hF482GmyZPztoyKHyeWFpGROoqDmDj2AUPVgavKYOlR5VKL80DGuJRKPDoW4pF5gSvCyOsmA/MNLzCVBoIMIPWY8GbgWjgTXvkpx6mLdO1FbinDuB7j9F9SEX9XpP235PZY2gZA96iSR/b+ECYxQmRbyuePFk1NfSZaOQ6dD6+7ETA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yGYHWGXgG3fUmxSxFHb85mDOoKVlWFLfuDAWpVqxaQs=;
 b=LojME2+KXyXs8n229oHCAhgeg2OXq7rmw2c6NTLYDDDiFztNThZvQDK5D9o2pZ1w2P12yldPGz10E8ipTHo3GDLZF5wOzBKCVMdEI048UJm2rE0DW2GlxOirBQuSWO3RZ7wX9BnMeQkMfCN/1XhyOy6ITe4kP3iuxiPexQnxwFYNTiZPhVTJbsPm0oJ0i4IQSN5ReFSYzxg56IqlYK3lJy0fonmUP6VpPVL81oFwmKJDvhofZeN/4o2cqv6iL9gWVxs46011qopQq7K6vpbFJI5YO5NYoV3OFn/A7Skg2sskYHqmmyiGO1IeRN6iWlinGaCTwVBN1chhjV7NpyNxpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yGYHWGXgG3fUmxSxFHb85mDOoKVlWFLfuDAWpVqxaQs=;
 b=GKW6M1SOo/TF9+Npv5bMiZ0n9AU+zOkOsSdfjEVVkx04rJLvauvx/avXEyPTpcV2wxK6KaZvBZh9cDU4+i/mUUBLLjyYyngu00ZXhLYha4MZr107hulZFUjpCIJhvdeYnhShb5aUquJnv5qiaohaQ6zDSWoRq4GhR6/IFmvSiQU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 MN2PR12MB4256.namprd12.prod.outlook.com (2603:10b6:208:1d2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.14; Fri, 3 Jan
 2025 13:59:20 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%6]) with mapi id 15.20.8314.012; Fri, 3 Jan 2025
 13:59:20 +0000
Message-ID: <8c3cc8a5-1b85-48b3-9361-523f27fb312a@amd.com>
Date: Fri, 3 Jan 2025 19:29:10 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 09/13] tsc: Use the GUEST_TSC_FREQ MSR for discovering
 TSC frequency
To: Borislav Petkov <bp@alien8.de>
Cc: thomas.lendacky@amd.com, linux-kernel@vger.kernel.org, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-10-nikunj@amd.com>
 <20241230112904.GJZ3KEAAcU5m2hDuwD@fat_crate.local>
 <343bfd4c-97b2-45f5-8a6a-5dbe0a809af3@amd.com>
 <20250101161537.GCZ3VqKY9GNlVVH647@fat_crate.local>
 <a978259b-355b-4271-ad54-43bb013e5704@amd.com>
 <20250102091722.GCZ3ZZosVREObWSfX_@fat_crate.local>
 <cc8acb94-04e7-4ef3-a5a7-12e62a6c0b3d@amd.com>
 <20250102104519.GFZ3ZuPx8z57jowOWr@fat_crate.local>
 <061b675d-529b-4175-93bc-67e4fa670cd3@amd.com>
 <20250103120406.GBZ3fSNnQ5vnkvkHKo@fat_crate.local>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20250103120406.GBZ3fSNnQ5vnkvkHKo@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PNYP287CA0060.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:23e::30) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|MN2PR12MB4256:EE_
X-MS-Office365-Filtering-Correlation-Id: 79529b40-f152-4633-5901-08dd2bfed1aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RU5tb3VhdFJ2MzZ4RSt4ZkxETEI1TVBSTDR2UG1QTkFmUENmeEtVeHpzcnds?=
 =?utf-8?B?TmdNdEptYmdEK2dZQkpDZGZuME1MdGx2OWVaSStaMmN3bEsybEtXTTd4L0Y0?=
 =?utf-8?B?dzhKS2ZPMTNPU3ZoWHlKdDBmblF0RkNCZk1tUWluaEpaV01OZjl4RXM3R1U3?=
 =?utf-8?B?ZkRmSUtBZk82Q1JSbkZuWEJEQjRVTTBNRERVbzRyZVM3c3hKU2dVcHRsNDg2?=
 =?utf-8?B?MnJ6MTgvNXBGOVRjUUNHRXl0V25ZSGxXUExmTnY0MVo3aS8rajJWSVF5TmJQ?=
 =?utf-8?B?SWJZNlhoMHJRRXFabFc3dEdseHBuWGt1S25VeGRrNjdHaGN0SmJ1WXd3azVT?=
 =?utf-8?B?YUs2ZUVDOGdrVk1lNlcrV2hvdEVqcCtSb0drNFRHYk9ianZiUGE3dkFtTnE3?=
 =?utf-8?B?NE1kRWE4OGJPUWlNL0x0c0trZCtvaGhFcGxjTVFFb3prWXl5Ny9vMzhRZllP?=
 =?utf-8?B?akwvNzFYNklVc3JXRnh0aGt3Y1FVNjQ2cDhJNkpweXNaRlA3cUdCOE8vb254?=
 =?utf-8?B?clFHTUd5RHpWK0IzQ2w3cjVERU1kTHF3blZvaXUzRVRyR3MzK2lNcmVLeHRq?=
 =?utf-8?B?MzBXZU5rVnhYTWlZOHFTVzlmK3JITVdGUG53U0xTRU5HWCtJdC9TemFiYUdI?=
 =?utf-8?B?QjI3bE42YWRTR3pIakh4THA0T3JJMEh3TFh2V3A0QkJPVzcvYUhaWkE2aUZv?=
 =?utf-8?B?U2R3VFFVbEZBUXliWVc5TDBja3BNV2RhbEJyYU1oOVlpZkpBSjBzUjhrWlY2?=
 =?utf-8?B?T05UTElEUzdiNUZ3c3IvSXFpQkFBV0c4VTB2dElucXR1T3VOZENZZklXcERa?=
 =?utf-8?B?RHRHTWdmdUw2K1p4a3JHK3RueWwzYnFTNFRkWnM3Tytvcjh1cmFpYXg3OFFU?=
 =?utf-8?B?RW1mUlNkZElpRzNES1gvMjdXQlY2dW9US0FGbXhUbW5yM2gyYXZpajNrRjBj?=
 =?utf-8?B?RzR5T2J1S21CNnd3Z1E4WDBuQytHNzBwSjZBTVJUV3l2VEhwT1JoQzhwaEJH?=
 =?utf-8?B?SlRGTzA5S3NLZjRkUVFJOFQ4dHM2bjRnUEpzSVQ3aUxjNmtMdERUUlphRGxU?=
 =?utf-8?B?SkNxRnRpYUtjbkpUc1VaeWRqYUNmQUFPSUxvOURnWXErOG9Bb2M2VTZFZ29w?=
 =?utf-8?B?alJVc2g5UFdFNGM3UkU2TE9TQU9NLzFsYTR5aFJTRVpEanJLRU5mVVVUNG5K?=
 =?utf-8?B?WHpkRDJ4R1hUS09udXJ6Qmw2aUgrc3VNQTg2MUo1dW5VZlFMaVFoQi9UVmxF?=
 =?utf-8?B?SGF1UDFmYWNJVzlucXlVRzJGdkN0T1BCdlJMMTlGUmxqVUxSQmxKYmRvcDRQ?=
 =?utf-8?B?SjBJY1piK2dyNkxMMENPUzFJTC9jVTc0NU9GNDJQMi9XL1hTTW9vdUhoZkhM?=
 =?utf-8?B?Y29yNUg4L3BKMmtOVUY2dmFuYUN6QXhIaEhGRjV4KzRhemFIY1F1eFhjUWZY?=
 =?utf-8?B?SFl4RGlhSzQrQzNKWXRidkh4UGJuTjBpZ01vWUl5NDFrNlZKVE5OMkZwQWJD?=
 =?utf-8?B?YkRybTV3NjZxNVdSK1VJc0xrUkQzYWpUYjMrRENFeHYrdEF1N0VSK0hpbWhK?=
 =?utf-8?B?R3ZiODJ0bFFpeS9lbFpXaUxhdDA0M3ZrNTQ5SnFXaUp3YjBrYnFjekozeG5N?=
 =?utf-8?B?WVkxNVJWMTNKSWdSWStuK1FmTXJ0UWdXVXJFcVdpMTdhQ2phSjB5cVZaUDdU?=
 =?utf-8?B?NVRMaWsreXBVZGNib05ob2t2ZjRsU05MZytZZ3NubVk3bjBMYk0waFFyd1dU?=
 =?utf-8?B?Sml5Z2xRREVkZVc3aDZ2U1pMRGd3S25OSFh3eTMzQ0U0N1RWcnB4eFRMQ3RG?=
 =?utf-8?B?N0NSY05pREFzQTVyRDlCVzBGRG8rZ1NXeWdvS1RBQlIydlpjQWlRQW5DK3ow?=
 =?utf-8?B?UUl5MnE0SHBRUzBpemx1SWpyaTB5OTY2b0tzQVZ0QWFoc1E9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q0FhWEt2bTNRbm01NU9RUjVjY1VBaGRQU2huaXJDVHRHbDdaazNIYzZQSi9B?=
 =?utf-8?B?dG1QVjU1RTRac29Wc1FmNklaRWx0eFAwNGZZVjd4Vk13aTJsWVpMVWhOMGVM?=
 =?utf-8?B?MkxKZ1d0K3BuU29VcENVdjB6QkpUNmdpU0NIYVRaN0I4TzJaVTJOd0FmRjJP?=
 =?utf-8?B?NDRSeEFzS3NjVDArNTRLUmlSU21kZkw1aGVYdjd0R1g5c29qYUVLbGdjWHRa?=
 =?utf-8?B?MGtXL2hLUWJJK29OdVNxRjBYRU9Ibm56bkdSUm5OUGdKNi9oeGpOckhrMWdw?=
 =?utf-8?B?T0RyeG40ejdHdWJrZVhYdXY1aWVvT3BNS2xPb3FNSmxNaFYwb25mWFA2UmFE?=
 =?utf-8?B?Qjd1b1hMT3ZpVmtFM1NqY3NCTzdJcTY1aDY1UExoOC9USjUzYzJUL2dWVm1s?=
 =?utf-8?B?T3R2MnQ2QW5sOGFDUkZ4aEJlL050SU1nZEJpbDB4bkwwRDVrRUlhZGdZcGVU?=
 =?utf-8?B?YTY5MTZmMEMyeEwyRndKZDhKQ3Y4cXNiVnIrTHZVZWpwbFk5L3JVMyt3UlZl?=
 =?utf-8?B?U01RUDNQbXdmUFNCdVcvdWhIV0lmbnNWYVVKQ2ROZTNqNWllekZtcjJMbk1v?=
 =?utf-8?B?K3NtY05aRVJGVm8zSmE0Z0VSV1drMU9OOXJWSXlsa1NDWlg0YzNOVHA2MEdD?=
 =?utf-8?B?U0wrWWpWbHI4WWRqa2JuY0FTK3EwWmhoSlRCR0JMaktyQXRnSW5lTGtmSXNY?=
 =?utf-8?B?QllhRlRVd0VrOG1lN3QwODFzTmtmdEc2RTZYVzJFazFjdzNFWWYwRno3TzVM?=
 =?utf-8?B?MXVmejhFNTJwNXRCZDJkL2NCQi93SHdVajBIV3Bhemc2N1BtTWthOGZrNlhl?=
 =?utf-8?B?ekhQdkJIZitUbmFKS01ncHJQTHM4N1RiUUNxMnFhQ3VhRTJDVnpMUTZmYXY4?=
 =?utf-8?B?ckJzQ1VBd28xVTBKSDNzSkd6RVNZRUIxT091OHVoT2F4MXI5UjlnV212ZUtm?=
 =?utf-8?B?QkpGaDhRc1BpcjIwZDZCSndkN0RGdGY2bkZYOEJnUXVlNHV6Qi9lbU05Y0hF?=
 =?utf-8?B?L1NJR3hBeXlVZmRkb2xJOUpxQW0yVVRzOUdNYTBna1Iwd3lVUnpsc1FTS3A4?=
 =?utf-8?B?bk44ZTlYdStNZndMZGtScGhjUVdqbjNrVHpxSXFBbFJvOFlzNlY1eUsydVhJ?=
 =?utf-8?B?bXlGeC9qMloxMm5TZncvbElvdjJoRjNqaDl3VE85WTc0dUtLak10WUNUdU5w?=
 =?utf-8?B?bVhibzBQRStyRmV0VVd5L3IrMVFsV2Zjc0ZtUnNCMHVBZXo2YVRXV1FHc2M3?=
 =?utf-8?B?QnkrQ3BBajJkL0dSQlM0RWZkd04wOHI0enQwZGJVTDNKMWo1ZnNFYVNtb1M5?=
 =?utf-8?B?NDZjK0twY3R1aFhVdHAwdjZxeUd0bEVNSndZYVVlb0laY3NPdVFYUHNKOFo5?=
 =?utf-8?B?WE9rdGdLSzNKcHhyUXNxeUdLYVhmZldOMEdXMmx2VUgyeDNkek1ER3Qva295?=
 =?utf-8?B?UU9QR2JIRkZGOFRvbkRINzRjeC9oNmNmRWdPS1hzc0tOQWtaZHk4eTViTldR?=
 =?utf-8?B?TDJSaGM1M3FaUVpJSjVhb0FZUXZTTm40bjJaZG5mbllwQVpWMDBaMWZSdUdQ?=
 =?utf-8?B?YWlxTFIwdUZqTVdEY2kweXRIMEtQOUpMVm1aU0xOQm5BL29IVGJYWTM4clMw?=
 =?utf-8?B?dkphenh6OVVlZXRhdHZiS3BQRGpvVFlxaDVabnhIRGhNVWplVjBpUUxRQy96?=
 =?utf-8?B?Y3NUOFFaM0ljN3BHaFAyLzNCZWZQTlhaaHJadUZaSDcyL1I1OE9NWHE3L2p4?=
 =?utf-8?B?MzNZYTcyN3dGU1Zobzl1MEtDS3BlM2lLNU9ZckdUMk8xMFF5WnJJVUhnM3Er?=
 =?utf-8?B?VHdyTVJiT0RHTlB3MUlqdnhMenZBT1NUQmxnQWZLWTdMeGkyL2QrT3Vtckxr?=
 =?utf-8?B?Q3Fzcm9VTGFRSm05VkZ2dTJWbXpSb2hJOGpuN1A2TWpSMDJWMXVUUWVSQVpw?=
 =?utf-8?B?RFYwL04yeWlFYlowU2RrZkNMSDlFa2tPQ2pqM0gyRjNuNXoxa2RvUklzbGI5?=
 =?utf-8?B?QzQ0U1hkYWxtdWpwOHdRQkxTUEo2SFZ4MC9XSnpmbGJnVzRoOGhtQUN5RU1M?=
 =?utf-8?B?R3FQbEVZU3I5Nk9ONjEvWVNoSnFqczBBYzErUHc3RmJSaUo1cnQ0ZXZkTzZh?=
 =?utf-8?Q?ClJDpUYNszgnenqUDVtFVKuuR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79529b40-f152-4633-5901-08dd2bfed1aa
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2025 13:59:19.9579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u/MgMwrVRM3PPpJ+53RS5MWEcyQhGMPfzb0jdT8ChuWd4JlFONEYf0X1/jctLKQ9urv8Sl+VodSEvIAZmMVa8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4256



On 1/3/2025 5:34 PM, Borislav Petkov wrote:
> On Thu, Jan 02, 2025 at 06:40:38PM +0530, Nikunj A. Dadhania wrote:

>> ○ Modern CPU/VMs: VMs running on platforms supporting constant, non-stop and reliable TSC
> 
> Modern?

Meaning platforms/CPU that support SNP/TDX, they have constant, non-stop and invariant TSC.

> What guarantees do you have on "modern" setups that the HV has no control over
> the TSC MSRs? None.

None.

But, non-secure guests uses the regular TSC when the guest is booted with 
TscInvariant bit set, although it doesn't switch the sched clock and
tsc calibration. The guest initially picks up kvm-clock instead 
of tsc-early as it was registered earlier and both the clocks have the same 
clock rating(299). But at a later point in time clocksource switches to 
regular TSC(clock rating 300) from kvm-clock

[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000001] kvm-clock: using sched offset of 1799357702246960 cycles
[    0.001493] clocksource: kvm-clock: mask: 0xffffffffffffffff max_cycles: 0x1cd42e4dffb, max_idle_ns: 881590591483 ns
[    0.006289] tsc: Detected 1996.249 MHz processor
[    0.305123] clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles: 0x398cadd9d93, max_idle_ns: 881590552906 ns
[    1.045759] clocksource: Switched to clocksource kvm-clock
[    1.141326] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x398cadd9d93, max_idle_ns: 881590552906 ns
[    1.144634] clocksource: Switched to clocksource tsc

 
> The only guarantee you have is when the TSC MSRs are not intercepted - IOW,
> you're a STSC guest.
> 
> So none of that modern stuff means anything - your only case is a STSC guest
> where you can somewhat reliably know in the guest that the host is not lying
> to you.

That was my understanding and implementation in v11, where Sean suggested that
VMs running on CPUs supporting stable and always running TSC, should switch over
to TSC properly[1] and [2], in a generic way.

> 
> So the only configuration is a STSC guest - everything else should use
> kvm-clock.

That is not right, if non-secure guest is booted with TscInvariant bit set, guest
will start using TSC as the clocksource, unfortunately sched clock keeps on using
kvm-clock :(

> 
> AFAIU.
> 
>>> After asking so many questions, it sounds to me like this patch and patch 12
>>> should be merged into one and there it should be explained what the strategy
>>> is when a STSC guest loads and how kvmclock is supposed to be handled, what is
>>> allowed, what is warned about, when the guest terminates what is tainted,
>>> yadda yadda. 
>>>> This all belongs in a single patch logically.
> 
> Now, why aren't you merging patch 9 and 12 into one and calling it:
>
> "Switch Secure TSC guests away from kvm-clock"
> 
> or so, where you switch a STSC guest to use the TSC MSRs and
> warn/taint/terminate the guest if the user chooses otherwise?

I am going to merge both the patches, but wanted your input on the commit
wordings.

Thanks,
Nikunj

1. https://lore.kernel.org/kvm/ZuR2t1QrBpPc1Sz2@google.com/
2. https://lore.kernel.org/kvm/ZurCbP7MesWXQbqZ@google.com/

