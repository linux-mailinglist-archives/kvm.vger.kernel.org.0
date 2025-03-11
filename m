Return-Path: <kvm+bounces-40771-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F37C9A5C3DF
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 15:34:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8F5EA1899920
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 14:34:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98E5325CC87;
	Tue, 11 Mar 2025 14:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xKj1AGwz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2075.outbound.protection.outlook.com [40.107.102.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3731025CC70
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 14:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741703606; cv=fail; b=epIXio38TSntTVVvPe2buySddIsbUmE/ykr13O7RUlvAfQgV2UzTfJJqQkJmGoATmJ6Dxa6B/uLbfk3fjoSNzrnFM2t0Drjxu+bTnKk2AQufngXJJE+GD/TDggHJ+LEI+db3iCc13X4rkU7eYxx9wNQe/Zkq8C2x0XThf1HAv7U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741703606; c=relaxed/simple;
	bh=5oZmpDYW5p7xwX01lk2VtkyMnS9OKUEWbwL+h/hmwcg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QVSvgjXy2MihGce1BX3SnokSN8SmN68fL1qLasXyy2I8WNHP6KBMx7UxFXMY0gJM6HJP8tgbSu6r2OxaSsos0s4yEJcf15YAJ7WdOk7Y1IU2Z/DJ1Bh0ADid/u0b52HooUcrZEABP9pQfoiT54ONoaZ0/YHucoyTcUVPEihVZmo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xKj1AGwz; arc=fail smtp.client-ip=40.107.102.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QqO4XmKC7ee3YJwIa3w2KzUUF9DJE9vlrnATQKwdSgfJnFHazvEOiwhfAgB3UIueKXgygO+GpjqYl1Qp0RpsH5SWxw32oKvQUcc1zoQMnSafd+0ql03fyg9JxAd8liL8EhME8wvH5q2LqbmY33xrlKXpZ9gGuOQo+ogubajuZMD39TvZqRQIYUeRijdxem2ADU0J2fNWY5yJ+KwELYq3FMAL6G0Z/qU6QZWpatTMbwFVBCf8C7SBLSWg5tfXRR2HNCUkQvvL9/AwRsycJ/YC5ux7zU6/o5yl7t/x9HxaEfIGdu20HZD94H5+hwYZTWbb0/FYoV1eplJtZ3RXUHXWVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vj4ih6VbWyeO7JwegMn5ojnZpBo3z9wGtZFrEWtxuMc=;
 b=Ovj7Ta6+nQAuzDlaMVcDjPYemg800Q3eq5a4hFFulCQKX5FbUUqMqD3mAX6frd+dHzzfVbL4Y0//rjvnMtTV0dD7+cShPzUjpeHcrmXkNqUj89sffQfHSYxO0J8vSEVe7eTiLY22k3LoMp0QE5xQ8Q5PJArmDxdo4tYL10Qrm12JeIRDeWHYJGb0TVlJ2QPJuFpfQsEXnj0tH2aecekU5hL2dtiRXOMoALX/ZLJLN8gXP3heJcDJ8I8k7jTaADFrcDNNOdcwm3S050bI+GarCqxSTOjCkxoB7rSZKp9JnOANSCTXKtsQh0BFdUHy3aXRepB7eciWfl6PgyvgHhLLmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vj4ih6VbWyeO7JwegMn5ojnZpBo3z9wGtZFrEWtxuMc=;
 b=xKj1AGwzPjIGRcmfFr5st9oFTqystdEqOQo4TSR81tVCHyqwY1imvHlEfddUZfAk4TWU4MzigVyXPcAHFIymiMz+/GOTkDn5kRaqugvnaubAU6RWBQGUbGM/jxf7JJhGZqHCqnDfdcBZWkFE+uXxQHBs0c9oOxiKG+UgRcK5Sd0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by BL3PR12MB6570.namprd12.prod.outlook.com (2603:10b6:208:38d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Tue, 11 Mar
 2025 14:33:20 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%4]) with mapi id 15.20.8511.026; Tue, 11 Mar 2025
 14:33:20 +0000
Message-ID: <0d121f41-a31d-1c0b-22cb-9533dd983b8a@amd.com>
Date: Tue, 11 Mar 2025 09:33:18 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v4 5/5] KVM: SVM: Enable Secure TSC for SNP guests
To: "Nikunj A. Dadhania" <nikunj@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org
Cc: santosh.shukla@amd.com, bp@alien8.de, isaku.yamahata@intel.com
References: <20250310063938.13790-1-nikunj@amd.com>
 <20250310064522.14100-1-nikunj@amd.com>
 <20250310064522.14100-4-nikunj@amd.com>
 <5ac9fdb6-cbc5-2669-28fa-f178556449ca@amd.com>
 <cc076754-f465-426b-b404-1892d26e8f23@amd.com>
 <d92856e0-cc43-4c51-88c7-65f4c70424bf@amd.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <d92856e0-cc43-4c51-88c7-65f4c70424bf@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0030.namprd11.prod.outlook.com
 (2603:10b6:806:d3::35) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|BL3PR12MB6570:EE_
X-MS-Office365-Filtering-Correlation-Id: 058afe50-c7e1-48d9-e2dc-08dd60a9abe9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SnN1b1dZSVVwVEt2NE5RZitCa1NtMEhTRmtuQ00yNFk5YWFpR2tNemdMOWk3?=
 =?utf-8?B?WjBvREY2MGdJRjJmTUt6WnYySkhoTCtLeWFwZTU3eGQ1YlNEb0VjRTRwQktm?=
 =?utf-8?B?TmJNYlFzMGIzbjNua2ZJK1NEMUhabUJDcWx5MTBmNVhWcFpFL1FuV1JKQkVj?=
 =?utf-8?B?d0w0S2poZTlNeG05THZ1MFAwYU5MQWxQTkJKVEppUkk1bDZlUkNkNGF0SWI5?=
 =?utf-8?B?OXl4Nm53SlF4K2JhUWhJY05yMXNGZEpFcFp5UVd6L2dvMHBobUJpcUFRUmdo?=
 =?utf-8?B?OG5LV1k4ZGQvTTFRZVpiUXczdDdmZGp2NkhlMVlScjNETm1sNWNQajFhTEJr?=
 =?utf-8?B?WjhqeW9LMGpZcFFFSU5ieUlwQ0pMWWhkUHhtME5vbzA1RHB5K0NVNUFOVFZM?=
 =?utf-8?B?K2lMblZNdFZvaHdBMlhqeW1OaTRTcGdSdCsrMFg4anBNY1Z2NUw3ODV1N0xQ?=
 =?utf-8?B?UGx0cnl1UzhCNi9wcFhGclFRL2JhVkJGMGZHYTBPdXZVYXJBaVFLSUk4RFlQ?=
 =?utf-8?B?ZmtKTVNQK284aU0yeW5DN3JhanJsdUpqdXpBTitEYUVsOGt3TWpRNGdCQU9W?=
 =?utf-8?B?dFczS0lscVBYSE1CUXRLWVA5cVRITnVtZ3JqclNheXdrdzVVa29zRzQyWUIz?=
 =?utf-8?B?bHExWEh5QmVUd1k3cXpkazgyZVBJNkFHRmhDQkN2Ni9hcVpUVHg3aEM1dExI?=
 =?utf-8?B?bFJxZzJnQ0wycUpKMGF6RW9pRmpjbWNGSVFMYzc2NzNWMUZ1UUhaUE1jNFda?=
 =?utf-8?B?VWRZSVQwVk9oZEoyVXNucVZ0M1BpSXRoS1Rlam50UnRFS2w4L0pKcVNCNVRS?=
 =?utf-8?B?MzRKdjZkZG1hdnV4YjNQSGZyL0F6d2l1UnpRYWlIT3lRRzc0cFl5VGdmc2lY?=
 =?utf-8?B?S2cvWStTcmxiRHlCQ3hzb0RuYUdFQnkxMFZ1djBsb2YvL2VRc3h1MDNSSXRG?=
 =?utf-8?B?Z29VdEx4MjJuRFFmcU9tRytvTmJ6eGoyeEhUZ2Z0NW10NGQrWXFSTEo1UFhB?=
 =?utf-8?B?SGNlTVNNbmd5T2pBRmN5SitEZlhDbFg0NHErVytiU3E0RGpYSCtBZWpMemdu?=
 =?utf-8?B?bkg3OVpLY1FLc2EvejdPRm1WS2VQZDZnTksrWi9leWxOYWs3WnJHcTc3Uzcy?=
 =?utf-8?B?M1QzYVJ2c3YrTTFONm94eWg5RHpTSzVsUDdZTk94ZVllcHpuWXd3VWNQS1o0?=
 =?utf-8?B?VndKZHZvNEJILzZzdTMxem1YbTZPSjN5RUw4TVFwRVliSjJ0R3puZ2JFVWRy?=
 =?utf-8?B?WXdtdDUzcU1RalA5bVhlS3U4RUJxSHpwUWlQekhIZElsZ0xaVWl5eldCWFhu?=
 =?utf-8?B?SVBJdnZZRldOMDRIdCtUQzhZSkZsNGxEZjVONDIydEFXd0VuckZmY2dOeGdD?=
 =?utf-8?B?b2MwakVia3BpQTFlTHF4bWNyNEpZZ3I5bkJBOFBLWGllZ09UbDJqSlhyeWhB?=
 =?utf-8?B?ZHY1TFJXZVIyWmtLQUE1bFljN05pM2d2b0s4Qnh4L3ZzVitSSFJmeU44QjFu?=
 =?utf-8?B?RHpPOGNyZ1IxN0FNSVFsSVppazVSM0pPSDFhT3MwelBmakJQV3hNRW5XZm9T?=
 =?utf-8?B?S2dpbmR3TXNtWHoyZXY5OUw2TDJuRldSYVNRejVaNjc5U0t3bkZkUEZPSUJO?=
 =?utf-8?B?T3JkTTViekk5SkpyQytnQUlGMENONG9TZDBFUlEyMUFHWUtVOW5NQy9QR0d5?=
 =?utf-8?B?Z05TUklzUUl0anJhcUI2ZXFBME9tWFNZTG82VDlrMXVqaWlNdmxFMVZPV0FQ?=
 =?utf-8?B?Q1luQ0FmUkc0TStHTEExTCtOT25VTkV2OFBFTjYyMDBKUGRVYm1iT2xLWVRz?=
 =?utf-8?B?amdCbmx2TU5keTMwd3l0dnpTUWI1RzZ6SVFxQmtValBzRnNOOHlPdlBKL29s?=
 =?utf-8?Q?/xMqS1xP+5kaR?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cWM2OVdKZVRyZVptTlB1Y0FmS3QzUXhJR1g5eFl3OWNaMWQ2VU1sR0hEbUty?=
 =?utf-8?B?bUlwWHBKSWxPZEQxcTdsdVFIdTdJRlU4cG5tZjJPWXhKazZRMUxUcUIxL0tB?=
 =?utf-8?B?OWxNeUVSTGhjWVFoYlhKajBEUkRpNGlTeWxMVWtTVG8rL1h6S2QyRURBRUlI?=
 =?utf-8?B?V05CdkJDaXIwWGlUekFJbVBiRWxyMSs2bDIvRWJXMkpxblZBMURDVzlFdWhN?=
 =?utf-8?B?OTJnSk02aEVONzBhVnR0QjN4RXNheUxXZjN3elBKdUdVbnV1V0l4VmVwR1o5?=
 =?utf-8?B?Y1lONkZsMEhzeUREMWlsSlBzVHBBQ2xsUjFkelRJdm1Mb1JHanBSd01BT0U3?=
 =?utf-8?B?S1RlK1JBVS9EaHhIS3AvakVCczllQmxwaDJqdDJOSmxRQTl4dnpWOUExM1hN?=
 =?utf-8?B?VUlWYVd5dFZxUWhXc0VJSGM4ek5DN09VSUlTWXRNR1Zxb3JrejBmcmR1eWVB?=
 =?utf-8?B?MTV2cHpxS1pnYWxpTDAxZGFMWDc4citBUWpleWV1emJoRHpsQ2Vxc3FmcWtS?=
 =?utf-8?B?MjlVRWNRRnJCc2VuZ0F0ZDdiLzhWUXUzeGM0VzAxcEdXN3pNekppN0c1c3F6?=
 =?utf-8?B?RUlTWTUzbnZPWjRFUThxd29LS29SVmtZUUNmMnZFV2kzQVQzZTdOS1dHU2Vi?=
 =?utf-8?B?aFdDT29QcWxVMnNqUytjMm9IYTRjZTlrZFVGdk9ENjRFaEI4V0lQOHBteHFk?=
 =?utf-8?B?ZXpyTlhVbUZJZEdrZWlRQnVtTk9kMzhkM3AxaUFpa0ZhNTdMVnZzb3dZaXBN?=
 =?utf-8?B?QThFTEV0ZzdZVzFsbFhmQXFjYXlUSU5ma0xjRmp3NVM5Z2lXcnRMZ3RsbEFt?=
 =?utf-8?B?SUhNNThmOTFhTmZkaVIzdUJuNGorUFErWk1aV3M5WXMwQnJ0ZkxYTUJHazdV?=
 =?utf-8?B?dGNLQ29RZFpxNzczQXFFeENsT2UrVTJFZjhSZWdBU1BtNTJJemh3OE1xcTll?=
 =?utf-8?B?OUpZVlRjbGp0K3RkOUhQY3dFN09HQk9SM3RQZDhJNTg1R1BlVXhlREU4SnRw?=
 =?utf-8?B?SUsvdXZCV2RrTm9FckV2VFJpbXpERlR0R210ZVVYbXVoYlNxN25xdmRSd2w4?=
 =?utf-8?B?WmdZMlB3cVJ4YVd0MXVpdURINmZFUitoMlVSS3pUMTFTTVNwWGtYWDJ0WTZ2?=
 =?utf-8?B?SDBsd0VCejdkRWZGOERJVWVJSGpzajMxck9qM1ZMaEd4RU9NNG5uamV5bUhS?=
 =?utf-8?B?UThuQnUyZGt3a3VvRkoxTHdDc1RiYjAxUGJTRjFBb0s1bFdNVDVtQlBtUlgw?=
 =?utf-8?B?dXhobHNuczJhM3VOelN2ZmJoTlM3cjd0WVZCdlpYUmV3VTVQT3ZHSTVySC96?=
 =?utf-8?B?YkNDWnBKUTZhd0xjUEVtczBwa3dPTHZZOGhiK3l2clZ5d3A0d2l1V1FEcExN?=
 =?utf-8?B?ekt3MDIrZ0JOd01Mbi92MzZUcm9ESFErVDhIS2Q1YzQzeEZtd09oL3U5R2VF?=
 =?utf-8?B?cGVrQkhRcDZnRlRSL2VTY3ZVREVTTDZlT25Ja0d1L0RCcTIraXpwTU5ISUNT?=
 =?utf-8?B?UVlIbWZDUzJWVWw4OVdoZGRBUjRhVTRwdzRDQzJld2pmSGs3QldaWTd3Rno0?=
 =?utf-8?B?Z2oxNExOWFcwdVAzRmtyUXV6WWpaUHRUOWw5SW1oT0NLNUd5VzNXOFEyRFRu?=
 =?utf-8?B?NS8yN2UyWEV0THNoL1pRdWFhVW9iczRUNUxCNGdqZEhJVGhZUVFVeFVWQ20r?=
 =?utf-8?B?ZUZTYXFxa0ZjMG9vTEs2VGE0dXBabFFYV3B3UU1oYUxWMTd3cEd0THhDSWFF?=
 =?utf-8?B?aWJzeEdkS1M5cE13ci9RNnhkS3kwS1UrSS8vZEE4U210aXo4OWlmcjRGb0VK?=
 =?utf-8?B?ZXp1U3h6OUdLa09OeFczSlEvWW90bVpvUC9KZ09qMTZ4RXhlb0dKcXdDNFlz?=
 =?utf-8?B?d0ozeXhoZWlZc2ExVmhsZ3YxYmZaRFlVZXVoTGxxbG1lNzRLQjllb1k1MnIw?=
 =?utf-8?B?MEVYcklmc2k1NDBsNC85RE5hVDl5aDNRR09FNFcwOGxPcDZZME91N2gwSTk3?=
 =?utf-8?B?K0M4ekdvL2QyYWlrVmwxMFpYb1ZVdjU3cEY5YVd2M09ISncrL2Z3U2RYSFN4?=
 =?utf-8?B?clRPTG5vdHE0ci9zU0JadC9GQlBCcU1yZnQ5Z1pOV085UldlT1VjZE1reE9R?=
 =?utf-8?Q?rVQXRdIR9oYS4qXOZ4Re4qTza?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 058afe50-c7e1-48d9-e2dc-08dd60a9abe9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2025 14:33:20.7749
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /5BI/exsDnqlX39lACG71nanKaY3VlqH4LQdcJ8RM2makHh5dhJsQF3yDlpjSKNSsTnczwQvO2Nmz/VSf5nVbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6570

On 3/11/25 06:05, Nikunj A. Dadhania wrote:
> On 3/11/2025 2:41 PM, Nikunj A. Dadhania wrote:
>> On 3/10/2025 9:09 PM, Tom Lendacky wrote:
>>> On 3/10/25 01:45, Nikunj A Dadhania wrote:
>>
>>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>>> index 50263b473f95..b61d6bd75b37 100644
>>>> --- a/arch/x86/kvm/svm/sev.c
>>>> +++ b/arch/x86/kvm/svm/sev.c
>>>> @@ -2205,6 +2205,20 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>>>  
>>>>  	start.gctx_paddr = __psp_pa(sev->snp_context);
>>>>  	start.policy = params.policy;
>>>> +
>>>> +	if (snp_secure_tsc_enabled(kvm)) {
>>>> +		u32 user_tsc_khz = params.desired_tsc_khz;
>>>> +
>>>> +		/* Use tsc_khz if the VMM has not provided the TSC frequency */
>>>> +		if (!user_tsc_khz)
>>>> +			user_tsc_khz = tsc_khz;
>>>> +
>>>> +		start.desired_tsc_khz = user_tsc_khz;
>>>
>>> Do we need to perform any sanity checking against this value?
>>
>> On the higher side, sev-snp-guest.stsc-freq is u32, a Secure TSC guest boots fine with
>> TSC frequency set to the highest value (stsc-freq=0xFFFFFFFF).
>>
>> On the lower side as MSR_AMD64_GUEST_TSC_FREQ is in MHz, TSC clock should at least be 1Mhz. 
> 
> Something like this ?
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index b61d6bd75b37..c46b6afa969d 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2213,6 +2213,14 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  		if (!user_tsc_khz)
>  			user_tsc_khz = tsc_khz;
>  
> +		/*
> +		 * The minimum granularity for reporting Secure TSC frequency is
> +		 * 1MHz. Return an error if the user specifies a TSC frequency
> +		 * less than 1MHz.
> +		 */
> +		if (user_tsc_khz < 1000)
> +			return -EINVAL;

Seems reasonable to me. I'll let Sean or Paolo weigh in on it. I don't
think we need a message, there should be a check in the VMM, too, which
would be able to provide information to the end user?

Thanks,
Tom

> +
>  		start.desired_tsc_khz = user_tsc_khz;
>  
>  		/* Set the arch default TSC for the VM*/
> 
> Regards
> Nikunj

