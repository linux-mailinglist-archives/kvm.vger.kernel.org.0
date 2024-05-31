Return-Path: <kvm+bounces-18547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CE5E8D6846
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 19:41:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6FBE11C25866
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 17:41:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A590017C7AA;
	Fri, 31 May 2024 17:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ULOOMztS"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2083.outbound.protection.outlook.com [40.107.220.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5FD8176223
	for <kvm@vger.kernel.org>; Fri, 31 May 2024 17:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717177266; cv=fail; b=VkbhFc2K8aakXyYa0TPCRKyemxtXOCUe+GZ4jA49Ms1cEjN0mbI0mgK65VZ3FsD7PiFZn+S3dNPelbhO05fMuoFIRPuzJ8rMIwUoFSCQWRLgaLqrIX12EYm3yvD+6aaZryg6KrU4msyLFTG8UAWkdg6QD8rJR59atMIlESsLTlM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717177266; c=relaxed/simple;
	bh=2kiaifs+EmTKmbbMvWOqR4ywVyC3axOu4mEArJ6E4rY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=t6+dxNO/+kGVENPV1ABQaM/XCq4um5nFT+2Jj2LiegGZ5bCBJCM1TNcKOV0M+LZSyd2pMRj4sFMZspv0GFxfBOxkF7wKIclUg7nwEIpdeppKd38k3pIUYhidwobRK/kYFTJQOdo7m81mgiUuxmOSpWjr/JHSi30EwPOkxU/LaKY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ULOOMztS; arc=fail smtp.client-ip=40.107.220.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I0t3BQYpkjmmZK7K6meINeh0Kwy4BiGKtmIxTs7MCuOJ+F1uADWs9tUBgHzd5PGuUBjhdxk3AeYaAEFmPaAs8n4iCKgKl+4VRIcAljzDsxQgfhH5cHuI9ySLGCHa05AlXzmH9Scj3BQyI92y+encHnGp0Fy51snsjxXDT8vPg3z+PJ2zqmbX+F0sRtS2dIoSoKO/SJS3RMv9pbvrgKNS8fqtlWEtEbY2J0J9gQ/cZjFz+UzpUr5kNsuryItLlnxvWKnS8jiyB3Xn0ivCxyxio7oSGTl4H+EGUtzUoahviUv0P3VV1WKx2eiRTrv7eg/nP/C1GhnyvfaFOhFx5Y1+3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zp2a8iU3aaHZf4NMuaE2b0J6FWT4TSqdEVWYgS+rIAs=;
 b=gXY4OCcWM5kV/K/jL86oJHMlMMtMeuAuYIkCW6PCxZi6a2Vb04wrjzAMzcM9QMVbBmW6y5SGPlaMsmYaE9ebOOEfh6MjQGiWp/6XsjjFDG4sIPAe1+waZdi6rafVfJQzNRvsj9wEL56wdU8pqa6hs9j9Zl7wQkNoxRBzCWOSlE0Rm1F8Q2kp9U1o6tVwfUyY7L31qzYzk7x4zGgfE7wOxquLyYHlgRuHglJtjXbbux3qmIyhUCcGPYrAYJJWZQeIA3GwOpVXLNl5iUdDmMWAi9HP1MoNp69ALCn2FjBuZm1c7/FDvfdx3TbFiXiRfXb0OR2/PsRhROIUrU0XjRAwvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zp2a8iU3aaHZf4NMuaE2b0J6FWT4TSqdEVWYgS+rIAs=;
 b=ULOOMztSMmCfPidXvr8jLCcTahps4GdzDX+IZbw0E33Bks619bEytwsXj7efqT33XBn+hCpZu0pSBWQI1NJHqFbIJSdC3htTkqEG4OL8cNOmsatfO3kg2r8AGlqYmyFAmEGtlXcclA5FEjmvUsfsRhyCBf1w5nZHg4Af+oFmuJI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13)
 by PH0PR12MB8151.namprd12.prod.outlook.com (2603:10b6:510:299::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.22; Fri, 31 May
 2024 17:41:01 +0000
Received: from IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48]) by IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48%5]) with mapi id 15.20.7633.021; Fri, 31 May 2024
 17:41:01 +0000
Message-ID: <621a8792-5b19-0861-0356-fb2d05caffa1@amd.com>
Date: Fri, 31 May 2024 19:40:56 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v4 00/31] Add AMD Secure Nested Paging (SEV-SNP) support
Content-Language: en-US
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-devel@nongnu.org, brijesh.singh@amd.com, dovmurik@linux.ibm.com,
 armbru@redhat.com, michael.roth@amd.com, xiaoyao.li@intel.com,
 thomas.lendacky@amd.com, isaku.yamahata@intel.com, berrange@redhat.com,
 kvm@vger.kernel.org, anisinha@redhat.com
References: <20240530111643.1091816-1-pankaj.gupta@amd.com>
 <CABgObfYFryXwEtVkMH-F6kw8hrivpQD6USMQ9=7fVikn5-mAhQ@mail.gmail.com>
 <CABgObfbwr6CJK1XCmmVhp83AsC2YcQfSsfuPFWDuxzCB_R4GoQ@mail.gmail.com>
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <CABgObfbwr6CJK1XCmmVhp83AsC2YcQfSsfuPFWDuxzCB_R4GoQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR5P281CA0015.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f2::12) To IA1PR12MB8189.namprd12.prod.outlook.com
 (2603:10b6:208:3f0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB8189:EE_|PH0PR12MB8151:EE_
X-MS-Office365-Filtering-Correlation-Id: 39164c09-bd7c-4479-d5d2-08dc8198d64b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?b2U5VGl0VU1HcG1IY0Q5eXRiZlpJSDBKRnRsOXprUjdMTzZmQUk2Z1U1QW4v?=
 =?utf-8?B?QStsRGZYYlQxeUM3bXI4Q2x5UUZibXRrZWZSQWx5ampuZzZEdk1WSzlqK1Uz?=
 =?utf-8?B?Y1l1MVdLVXhyclFsL1kxYnlVdmNIdzFCVVZrOElFR0hqUmNiaVlnbnh5QXV1?=
 =?utf-8?B?TmlKazVKNnA1cHBXSHQrcFpPdEpFbDdMbCtaUlVGRkxjSGRzSDdkRVBraWJt?=
 =?utf-8?B?dHhJTHhoeHphL2FBUEJmRWJ2aGxTb00vVlFhMWo0cGkwRTE5UWlwby9JTTkv?=
 =?utf-8?B?QzVnTzl2SWFvV3hXQVhtWFprd2F1OG96Z25yTkFEMm9uK1Zyc3o1MCtnM1ZJ?=
 =?utf-8?B?K0NLUDV4VUNFU2Z5TWU5bUlZcjhIS0U0Q3JpYVJoM3lGWFd6UnczczBqYVpr?=
 =?utf-8?B?Rjh6T2duYlhHN29vekQ5MGhGRGVDSWZxMXIvL3NYb2lIRjFJd2NEbk9YYUpl?=
 =?utf-8?B?ZUV3SGh1SlpyMVk2RmpXVG9Xd0NpTzVYYkZRVE5lNGtaVnh4YzVWZTNGWTJw?=
 =?utf-8?B?N1l3UVhESGdwZklXSUJndW5ZL25NS3FES0dCWTZJQzgzUTFXamR6OFR1bU54?=
 =?utf-8?B?ZFVRbVJiWHJqQlRscGRLRmxwbC8wOVNPWHpjRCtvNW93anFydkErM2JFMFox?=
 =?utf-8?B?MDJkSHlxM1pvNVlqL1FTKzl5b2xvQWw2UitkOStFa3VhVCtMOTBlUWZ0WEhD?=
 =?utf-8?B?MWVSZExCM1NkUTBiNjJ6ZDR6KzFkZXJnY1VQR0RsVElsMjJsUWVNV2ZWOUd0?=
 =?utf-8?B?R0ljMmEyVW1TWTdqU2sybkxKbm1DblEvaGQxNDQ4dHBndGl2SS9aV3dUa0Fj?=
 =?utf-8?B?eUhEUVJrc2FUbHpsc1BsRnBEZnRac1dGQWZVU05pR3JLajJxM1JkcE4ycWVa?=
 =?utf-8?B?K0o4UjV2TUM5Z2xaVGM2SGhRL3FkNWNIYmlOdVRnZ2VNaWJUL1pvT3VzYVhQ?=
 =?utf-8?B?YWk5TjZ6aFlzK0M1ckd4VHRLRXlZLytPSGdwSlUwM1hkVTJTazhmY2J0TUdk?=
 =?utf-8?B?YWd0VFc2NkxkSVpVcXUzb0VWVklsMzdqbnprYUp0WTB4VXpjK1VaT2I5Vzg2?=
 =?utf-8?B?WnRBSUs5ZDhxcHRJOEt5UW1KcUNXaXZUVHBSMWJxWTRoRWNnemIrQk43Z1lD?=
 =?utf-8?B?MjFYbTRGWHRlUC81SHJDSExQUVpyVUdVcXpBc0FZU0ZlbTdXd1RDSW1ocFkz?=
 =?utf-8?B?a3hxUHFOd2NKRGJqbFZuT3MzTkVnMkNITUJoblFDS3N0Q3hnVy84R2hRaUFX?=
 =?utf-8?B?OVNSMHY0U2c3eW5VbG9INXBJWFVmbkdhckxGemlxd0huZjJiOFhpVit5aDFl?=
 =?utf-8?B?Y3Q0Qk5FSUp5bnA2MlZZUkk3WklBWkhLOHNvZ0hVSnp5NmpQRjg1d1RkbmVj?=
 =?utf-8?B?SVd4S0VLZ3VVckVHWUJ5ZW96V3dPbjk1YUR3SVZubDEwakF0UHBoMTJ6OUVm?=
 =?utf-8?B?aldRdTJyQmZoNlFEbis2VjVCa1FRNjZsY0dOWFI2bGNQUFNFMXN1aDVDQ3Qy?=
 =?utf-8?B?R01SaFZ1eGFSLzlvbnRzZlZzaU5DNThvVnhYRytWRjQxRzBnUDd3K3ZaTFYr?=
 =?utf-8?B?VVpwTzNtTjBkREJodnEyNW43YTZHeTM1YWhudTVtajNlNXFBN3h4bEg0Wk5H?=
 =?utf-8?Q?wK6WErc2291a+7EGAqhzjVhWXsAhG9aUc1uPUN1MaMXM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB8189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S0JFQld3R2lBeDh4QnlHZHRaYTViWEI2dWN3bllWV1RkcDUxQXNiYWtGRmpo?=
 =?utf-8?B?MTRvNzFBcUhFMThpN3U4bzNZTWRuTlJBbGZkeEZHdWpFeVNrNGh0b09GOFNr?=
 =?utf-8?B?MVkyRWJqQ1oxclJld3E1MTRneVhHTFo3aXVHNlVKVTN2WGdYRktMd1VTYUJq?=
 =?utf-8?B?cFZDOVQvU1RyMUxHQXpybld6cnBJWnZUaGZMZUtpdkFBc2k2Tm5tMkJpWlA0?=
 =?utf-8?B?ZFJqdXYvR2VZb1E0N0k0ck5ZMjYwQzJLQUxrcUZFMXl4LzRJRW5jRXQvUVl3?=
 =?utf-8?B?Qy9RbWVxQ0FSYyttdGI4U0lCaG81UXlKa2R4Zm8wQ0V0WVZncWxKa3hCTmsz?=
 =?utf-8?B?VXR3ZGNsMG0rZWZRL1FwYkRacGNFQ3lPYkNkck43Y1RiR3NHVVZpZWhHN3RL?=
 =?utf-8?B?REJuYk00NDhqcDhOTk1yWTQyMWNZRVhGZHNCTVNXZTJxZXVmTGd1aVFkZU9O?=
 =?utf-8?B?OTZWLzFIZ1ZKN2c5M1o1SmFyOXU5bmlqT1pzdkIxcUY0bi9GMWxVaE94RktJ?=
 =?utf-8?B?aUhURnYva2xRdmxnOTZDbjRLSTVIZ0xhTVNVdFRmdFRWUlp5OGgzaHA1SVFM?=
 =?utf-8?B?cUlQa3p2b1M3ZE8reE5OL08rYWhjNVdMVDNMYzRMd2FmelhoOHhPNnl4K0Js?=
 =?utf-8?B?bTFPTWJzVTA5b0dLM0hkOFZ5eWYvbkhlWlFtUHcvTXcvN2pHUDAxVGlPcGRO?=
 =?utf-8?B?a016cEkyRGZSZzg4MDN5L2dqa2hFOUFhcUVGZHdBWTNDWEJ3Kzc5NjJIRE5H?=
 =?utf-8?B?WWhYVXJzRmwxTGMvRlY2RFFGcXFoZ011ejg2THY5TDkyaU01TUlDN0RwbTBn?=
 =?utf-8?B?ay9MWjJMSXVQdnNqbUU5SlNmcExreUdxbDFGa0FBVXZRUXVDNm5INk5sMjVi?=
 =?utf-8?B?QkZBMkRES2crbkNMeWg5bnJVeGdURFozZFhEa1JWc3dKaTNibVpxRWxJZWxj?=
 =?utf-8?B?a2wvSlhjSS9raW9JTlJKODZWTVUvUStiSUloTDlWMzlaWm8ycXVITlI1S3BB?=
 =?utf-8?B?YWlWNG5rb2lQeHo0NjA3dmlPU1lPRjVZclVoZVRnUVB3WGRSZVpKUmJtemNx?=
 =?utf-8?B?L1pJcmZmN0MzNEJsYWpvMTI0Unh2Uk1OeXRPcllLWENRTG9PNTZlOUpsTjZQ?=
 =?utf-8?B?ZVIzbndRT1hTL2hKODdUYjJnZnlCNjBHRVN1SDJOK3lJclhDK1hLNGJheWVI?=
 =?utf-8?B?NThXVzFHMU5XZExQakdPMm1UK3VleU03b3VubEFRMS85SFBYRElTUXp2MTJZ?=
 =?utf-8?B?SlNDbEcvZ2FQOUNxRFhoc3dXenFjTzMxOXFpNXNBaW1yUjE5N25JbUJjRkZK?=
 =?utf-8?B?d3ovWmt6T1p5OTBEY1hnVGhSQktoMXZmc0xJSW50YkxiVCtuUlAzbG5USFdV?=
 =?utf-8?B?YXovY1RyZ3QrK1JnbzlNcUZJUFRuVGVVZzhPNVc5N2srcDlRWUtFL1cwL0Nm?=
 =?utf-8?B?bTd1ZkU0U25MZXRPRUc4bmlxRG1ibDNqeExwYkhXVUxHT3BWSG1EcFdNeVZX?=
 =?utf-8?B?U3dVOCs2NDQ5TWkyeEpDbnJPQnBRVFkzMGYrU0RTbWJXeUdDbDgxV2U2WDBu?=
 =?utf-8?B?WHdwSEkraDdacFhsZkt6dnBVbUZBeWU4V3o0aE5KM05ZWEFRSklya1ljaHNa?=
 =?utf-8?B?YUxEcHFza0srYlRBWFIrS2s1VHpmSFZmZWZibnRKclNBQzhmdm5BcllUNDE1?=
 =?utf-8?B?TXNuVW9BeWdQYWZxNFVUVlg2MWh1dVU2ZmJTK2lqRk1PbzBMcFFqOXByK051?=
 =?utf-8?B?TEZtMWU0UlBsOXRNZlIxdGVDNkhOK0ozU296VjdaRVM4SG8xd1hJY1pXekR0?=
 =?utf-8?B?MmRvVk80S0MrdjArVU8xYnE0V0plSDBlbitWbTFQcnFYclA2c2xWM3MrYWFJ?=
 =?utf-8?B?S0RXbnZJaHJJR1c4aTVsaUdYeldpRFVOTG94cnVEMDgzWUd6cmJaajZqckJv?=
 =?utf-8?B?TW10TytEVGhzWGJDVFRla2laaUVxOWRuQy8reEdDelVodENEdWlvYXhQZEw2?=
 =?utf-8?B?cEFzb1dpdXc3WVBoeWVtc2Y0ZGtlZHlVSDZKREh2OWlYSVh0dER6aVlBYmg1?=
 =?utf-8?B?dWcrZnE4YzFWSVNJZ3QvWFNQdzMzNjhUdThyL3ZBcjgwdHAwUVRUblhrWk00?=
 =?utf-8?Q?Ax/ouFvS5RER3FUmwAl98YDqf?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39164c09-bd7c-4479-d5d2-08dc8198d64b
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB8189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 17:41:01.1992
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sWRd3NLWuzvJQsfOsymPjLdC4zsA2stwJgu7hdnNr7PPVEY4+YHETuW734jvR16075AJL1slKZeUxspUou49UQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8151


>>> These patches implement SEV-SNP base support along with CPUID enforcement
>>> support for QEMU, and are also available at:
>>>
>>> https://github.com/pagupta/qemu/tree/snp_v4
>>>
>>> Latest version of kvm changes are posted here [2] and also queued in kvm/next.
>>>
>>> Patch Layout
>>> ------------
>>> 01-03: 'error_setg' independent fix, kvm/next header sync & patch from
>>>         Xiaoyao's TDX v5 patchset.
>>> 04-29: Introduction of sev-snp-guest object and various configuration
>>>         requirements for SNP. Support for creating a cryptographic "launch" context
>>>         and populating various OVMF metadata pages, BIOS regions, and vCPU/VMSA
>>>         pages with the initial encrypted/measured/validated launch data prior to
>>>         launching the SNP guest.
>>> 30-31: Handling for KVM_HC_MAP_GPA_RANGE hypercall for userspace VMEXIT.
>>
>> These patches are more or less okay, with only a few nits, and I can
>> queue them already:
> 
> Hey,
> 
> please check if branch qemu-coco-queue of
> https://gitlab.com/bonzini/qemu works for you!

Getting compilation error here: Hope I am looking at correct branch.

softmmu.fa.p/target_i386_kvm_kvm.c.o.d -o 
libqemu-x86_64-softmmu.fa.p/target_i386_kvm_kvm.c.o -c 
../target/i386/kvm/kvm.c
../target/i386/kvm/kvm.c:171:6: error: ‘KVM_X86_SEV_SNP_VM’ undeclared 
here (not in a function); did you mean ‘KVM_X86_SEV_ES_VM’?
   171 |     [KVM_X86_SEV_SNP_VM] = "SEV-SNP",
       |      ^~~~~~~~~~~~~~~~~~
       |      KVM_X86_SEV_ES_VM

Thanks,
Pankaj

> 
> I tested it successfully on CentOS 9 Stream with kernel from kvm/next
> and firmware from edk2-ovmf-20240524-1.fc41.noarch.
> 
> Paolo
> 
>> i386/sev: Replace error_report with error_setg
>> linux-headers: Update to current kvm/next
>> i386/sev: Introduce "sev-common" type to encapsulate common SEV state
>> i386/sev: Move sev_launch_update to separate class method
>> i386/sev: Move sev_launch_finish to separate class method
>> i386/sev: Introduce 'sev-snp-guest' object
>> i386/sev: Add a sev_snp_enabled() helper
>> i386/sev: Add sev_kvm_init() override for SEV class
>> i386/sev: Add snp_kvm_init() override for SNP class
>> i386/cpu: Set SEV-SNP CPUID bit when SNP enabled
>> i386/sev: Don't return launch measurements for SEV-SNP guests
>> i386/sev: Add a class method to determine KVM VM type for SNP guests
>> i386/sev: Update query-sev QAPI format to handle SEV-SNP
>> i386/sev: Add the SNP launch start context
>> i386/sev: Add handling to encrypt/finalize guest launch data
>> i386/sev: Set CPU state to protected once SNP guest payload is finalized
>> hw/i386/sev: Add function to get SEV metadata from OVMF header
>> i386/sev: Add support for populating OVMF metadata pages
>> i386/sev: Add support for SNP CPUID validation
>> i386/sev: Invoke launch_updata_data() for SEV class
>> i386/sev: Invoke launch_updata_data() for SNP class
>> i386/kvm: Add KVM_EXIT_HYPERCALL handling for KVM_HC_MAP_GPA_RANGE
>> i386/sev: Enable KVM_HC_MAP_GPA_RANGE hcall for SNP guests
>> i386/sev: Extract build_kernel_loader_hashes
>> i386/sev: Reorder struct declarations
>> i386/sev: Allow measured direct kernel boot on SNP
>> hw/i386/sev: Add support to encrypt BIOS when SEV-SNP is enabled
>> memory: Introduce memory_region_init_ram_guest_memfd()
>>
>> These patches need a small prerequisite that I'll post soon:
>>
>> hw/i386/sev: Use guest_memfd for legacy ROMs
>> hw/i386: Add support for loading BIOS using guest_memfd
>>
>> This one definitely requires more work:
>>
>> hw/i386/sev: Allow use of pflash in conjunction with -bios
>>
>>
>> Paolo
> 


