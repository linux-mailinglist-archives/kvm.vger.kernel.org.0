Return-Path: <kvm+bounces-31624-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B74CC9C5E79
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 18:12:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8BDBDB2D4E6
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 15:55:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8A9D2040AB;
	Tue, 12 Nov 2024 15:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TwrRpEL8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2074.outbound.protection.outlook.com [40.107.212.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28BF4202635;
	Tue, 12 Nov 2024 15:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731426737; cv=fail; b=BpKR0aToVOTUEotglA00jrNt4q2Nkcm8IW6n/ScEYdP5OUN8sVfLwkheVroZIKG6w4PyrwZsqeXZPcMT97wk3zTGSSJJg4usabgcXR9XB5aymdjW/AcrA8tc5yAq7Ue/GR9/XZCSsfnDkgPFR0n9gPGjRkmLiXLyXOzCpET7iMU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731426737; c=relaxed/simple;
	bh=V2EfbQaFRI/+/G+HfoHFgcwVj6sgNW+ddgwfl5T6AB4=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=cLhsjWxLu8F3KdXZxTn8s73BZdBtCQxGhgBv+fyjbgPsMreKzV3KGpnqTJLoyamgQ/E+HA70XCp7BHGcmNJCQ7cd9w34bckiok3t3rray4HgiQtkfxPGtyoqFB2cMZVzNeWdsox7fWxv6GZMJoKJKHnQPy1xWgU+5f/oDiYGROI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TwrRpEL8; arc=fail smtp.client-ip=40.107.212.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kS73lk4QAxoW3tzxoSXeVGgoORnvpBXCgm462v18meCDOUK8Ftwpc+Gs/wreyLNPPrAD7HdLOgKZfraBtg+0+R7byvN7SO0kgszHb85gAxzzwfssPw354cGfHLSQmXKanH1MGPjBfBZjpTiibeIs7P8gBSeMtCWwLWb0m3bHwBYjRNZU8OQuVxRFtxCz8YQywpUVNy6SqcI7gsdDh4Ehi15t7IfAry3PAo/tdSRB00G+GJAm3EbD/NQtg7uHU3gxXiiE8Ip0KK0xjOBCDyO6Ar+lU/UF3h7EuyFFc3JM9lLPP3iR6Mwij+5hTbFZMyvfLA3qqEOKIUaKuDmqD65bJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l8GhQPqLXgCxHTkVGssDEkonLnR4NoFlhQOL4nGoCug=;
 b=rkagahRBUXpNCCZ1rIl/SJ8CiJ8zYrDzNDHYqiZZoXG9G6bs7zfmKhPvsI51WUjUDhsdqCYbhPUmKoRMyDOPEIFBWtIcTUZFnHJlEpAN977A0ui/BjgOHbIiSoTZ1Ka3wk7eriGQgaoWZXLnlxgDSt8r7DNvQRkyP07M9DMKuyF21SgEQn/5GqCg4ncq/PObNnw0q6idEuEZvCJd4ZqRXjgvNGOWXE7GtCyHAGoU7QztXBWTcClMTD5BuvLYqQ1G/VrFIeyXQ22Q/UHHh7Pu/Kq8sT0RDHZaB5+9QBxymcXn9OUtnO3VP4kgO7UDl4lWrXNHq31GtGWFQR0Lyw/9iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l8GhQPqLXgCxHTkVGssDEkonLnR4NoFlhQOL4nGoCug=;
 b=TwrRpEL8mKhUqje6R1n24CnaAJufjfb9vz8eq9JByWMYjO16VWJXFvI5wqfeU2wR64VB/NU86D1tKO0WKJPN5bryx4XqMrYJJ2uaCjNNsdjbgrX6EQyrD8EibQDi36T8nSIFPPKbsJEuYoU2vrOjGhpTT4zlh+iyOWWY94cXXdo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DS0PR12MB7655.namprd12.prod.outlook.com (2603:10b6:8:11e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.29; Tue, 12 Nov
 2024 15:52:11 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8137.027; Tue, 12 Nov 2024
 15:52:11 +0000
Message-ID: <d49430ec-8701-72c1-36ab-4d9e612ac443@amd.com>
Date: Tue, 12 Nov 2024 09:52:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Dionna Glaze <dionnaglaze@google.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Ashish Kalra <ashish.kalra@amd.com>, John Allen <john.allen@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: linux-coco@lists.linux.dev, Michael Roth <michael.roth@amd.com>,
 Luis Chamberlain <mcgrof@kernel.org>, Russ Weight <russ.weight@linux.dev>,
 Danilo Krummrich <dakr@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Tianfei zhang <tianfei.zhang@intel.com>, Alexey Kardashevskiy <aik@amd.com>,
 kvm@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20241107232457.4059785-1-dionnaglaze@google.com>
 <20241107232457.4059785-9-dionnaglaze@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v5 08/10] KVM: SVM: move sev_issue_cmd_external_user to
 new API
In-Reply-To: <20241107232457.4059785-9-dionnaglaze@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR16CA0045.namprd16.prod.outlook.com
 (2603:10b6:805:ca::22) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DS0PR12MB7655:EE_
X-MS-Office365-Filtering-Correlation-Id: 7cec05f8-e40c-4a8c-85f9-08dd0331f80d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YUVTL1ZPN3ZadTZSUEI2b1B4NFZGVmYycVp0Z0JDSk1qRTNsZlgydDl5Y09E?=
 =?utf-8?B?R2lZNU40Q1FFNVVZTk16SEx2T3c4Q3FPcjRVbkJHTlEvUWpvM3VZbkc5SVNx?=
 =?utf-8?B?NlIzNzNZakMyS2lObE85b1BvQ0wrUnpqR3pQaHV6cUZTV04wU1B0WXNiR0NX?=
 =?utf-8?B?NHduKzY2NEFheGVFTjNPZ0s1dlYyOHl6ZFpnK1c2RGFNQ2s3dHFTckYyL1pJ?=
 =?utf-8?B?emRidU5wdlUweFJIRDlTVWM4RjdPQnludGVOV3ZINzdESi90YUF2NmxjcHZU?=
 =?utf-8?B?RmE3ZVM5QkhBNWh4ZFhpRGtVNVR5NDBIYWhkSzVrVEVKekZFZ2NQbmdrMFBR?=
 =?utf-8?B?T2t0WXE2aWxteHB1WmpJOCtwNHQrMEdEdlRQdFphWXV5WjdvdWxxeS9KRncy?=
 =?utf-8?B?NGJhSDhzYWY5TS8wVTl3VC9FWUl3M3dlVkJjeDRKVW53cGg3RWtPS29Db2Fn?=
 =?utf-8?B?cURPTTlKeWx1OFNFMEowd2RQRlg5YzJHMk8zV3YrbGpIWjU2T0tKYzdFQjhV?=
 =?utf-8?B?SHI1bnZsVjRCUGQ5NDA0b25LSzQyNGJJOGVsQlA3RGkwT1d3RTFrVncxYmpx?=
 =?utf-8?B?Q1ZKcFBRREEvS1ltOXJSRytCYUlHTDVTQXgzMmVuWWRab2pKQk16V2pGbEZU?=
 =?utf-8?B?NmdKZDlpb1lwYW9VbE5PTHBQRng1bXloNll3QktLeGwrMVIyNGlkMVFFTGhG?=
 =?utf-8?B?V21vSFR5M1VUeSt6NFRDcGpaVVF3WGRFWUFoZFpYMzhSY2prM3RWbUdPQmpv?=
 =?utf-8?B?WEs0cldTbWhxYml5L1pMUzJ2R1VmeEFCNmlWUy9iWmZ0Z3ZXaGQvOVQvM1pk?=
 =?utf-8?B?NndidGw1UDZxdVB3YktwTEpUYXJzZXhpK3h0enZhWS9OU0NHSXc2NVozTjJJ?=
 =?utf-8?B?blN1RjR6MmNSVG85Wko0M2ZBNHpGMWpNV1F1UUIycVl4V1dsamdiNUZzOTFM?=
 =?utf-8?B?eDhrUkozaS8yYVVuZlFtdFY5SnVBN3lNRFdvRm1rajZWMVBVdUp1VFd1Njl6?=
 =?utf-8?B?bUtMU1RvdEhTN3EvMXhLQzIxWkYxbjVWK0xheTBXYURzNW5MeHlQRU8wWDhS?=
 =?utf-8?B?RHl2bGZNKzJTTGEyVFBjbTNQZU5MOWJlZjU2bnFzTjRRTm1iUnBOayszencr?=
 =?utf-8?B?QkNZdkFMWWlEUFhlbkVLbGY0MEJCUWk5NFFFSGlBV2IvTWdObXo1eEQ4TlJR?=
 =?utf-8?B?RXNhUlUxZU1ORUVZZWlzSy9QLytNSmNqTE5SY3JscFN5RzdSaldnK3dZMml5?=
 =?utf-8?B?cGdITUhZMWgxR0srbm8vV0VjUzV5Q01tNjkvTnUxNEp4UllwZnk0a1JsdVlD?=
 =?utf-8?B?bHBNdmZWSzIvbTVMREV2bGdqMW5EbGp0c1N2aEcvQVZYcFhna0huc0dBQncw?=
 =?utf-8?B?ZlVoN1prV0pXWk0rOWtjeFhSLzJCbEJEQm1sTm1mVW41MVdrWGR0aWlEd1pn?=
 =?utf-8?B?dkpKN2FPYjNBNld6c2tvR2hOMFIyRGZ3YVgrdU1LMEczUGJrYlNCc1Zub1Bq?=
 =?utf-8?B?VjMvMmZJK2NYaFBLWE5MeGNodlFvK1hmaUsvMjFFTk0zejRIWnZ3NCtFcnF6?=
 =?utf-8?B?R3NSQkt4TlhQUExvbnBXZE92K0hoKzI3YUQycGk3bHFGNHlYR1BIVGlEWU9z?=
 =?utf-8?B?WldnekFpRWJNa1pZWDRpbUxWSk9DSklyWk9rSTAyekFUeEhYdlczdUlzRHlZ?=
 =?utf-8?B?c2FQRVI1eTlQOU1EbUdkSzUzem5QdEVZTWlPc3hzeFlWb1hubTRJdTFrNUU5?=
 =?utf-8?B?d2gxNnRabHY2SG5zQTBsOVdMQ0JsUG1aVkJhODJNNGQ0U1VhTURCaExWbVNi?=
 =?utf-8?Q?yvOgpPn/hD3KrMpYGbnw247q9OhnfMoeyJ46s=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZnV1bktIT2xtK1BYZU9jSDRUaTNSSmRlTGZHdWJyRTRXdk9CbDZHK04rRVNG?=
 =?utf-8?B?NUJsSXFONEJKRHZxSUJCR2FEUGErbWV5Q3A4R053RnZ5c1N1WEpTUzVNNDJr?=
 =?utf-8?B?YzZaeFd1R2JxZjRNNWxFQzJrR25TU1hqSkFjR0lPV0xQS0hXQVNJMGR1R1hD?=
 =?utf-8?B?c0pLMUc5THRVd0NQS1BNWUltVkpORnhxTGhZUkdNMUtUMEtNUGR5VjJmRmpq?=
 =?utf-8?B?ejg4eTVtN1c3Uy9pRXZuMEhLck5Od0lsTU1neDJKMWl3UEV1VDBwRjNnWGpx?=
 =?utf-8?B?YUl2Y2FGU0Y4YkdoV0JubnZ6TlVsM0M3cVMyVFhBK0JxZldzNGJab0RGVjFZ?=
 =?utf-8?B?Z3BpWUhDRzA1VlZ6L0ROMGExVTZyMU1qajRsTFkvS0ZXMmUxNXRYOHhseWEw?=
 =?utf-8?B?VkxpdStEczZwMHFCd2h3U011OHdONndaSkdBMnFVZTBWUy9VNzltTTBTRjhI?=
 =?utf-8?B?d2trMUlPSGdWNWh5TzZOb0tRNE9lVFYyL2YwVU1CQmxCY1RkOE9KdnB3OEda?=
 =?utf-8?B?eWxYYW56RytOZDFiaHVUOFNSRFJ4eW9NM3NORjRHTU1RV0ZIQ1VjUnpRSVgv?=
 =?utf-8?B?OUtFUnl4eEZJNlIyTnJud3lsNU1vYXliZDV5V2FHQjRXMFE4ejlNOW9hY1ZN?=
 =?utf-8?B?VzBmdlkvR1NpTFZMaWVReU5abk1YTzVpZFNTTWI5ZXFUYUh3MCtPbWV3cU1S?=
 =?utf-8?B?dVg1QXNUOGlDZXZHeVBDNVVYUHRORUZsR0RaazRXdDFDcWR2NEcwbXFqMlZZ?=
 =?utf-8?B?M2NmS0xlY2VaVkhwVDVvaWphbDFJbGY4Qld6YzNQUyttSXpOeDdQNkNVNnhC?=
 =?utf-8?B?c0d2dnRjU0twZGhIby9od0RTN2ExYVBBaDN2U1d6dWRWbmgwUDdBMUxER25z?=
 =?utf-8?B?STZQS256SS9GMDd1SVFISFg4UFFES0V2UTcxcVpieXlsY2NXaEVpZmpWUmRW?=
 =?utf-8?B?UlZEdzNKWkdOZmdXS0ZqZTBySitKZWN1NG1YOWt5VzVVaFFURGZYZ0JsV0d3?=
 =?utf-8?B?OFlpK3ltWHQvQjR0OUdQZXRnenpGdGJmV3FoNjNFQVcxS2taTW1wUnE4ajNt?=
 =?utf-8?B?YmliaEVuRUFLcTFsN1kxL0laaENFVnV6Qmt5RVBRU1VQb2VrZ1JCMWlPTHdl?=
 =?utf-8?B?clVDNDYxaGtJNFJ4U00rWVU3WEJ6bWx1MnZBTjJWYUxtNWI4aGFkd053YTBZ?=
 =?utf-8?B?R0J4by9GTnJUcW1zMlBoNXpzdVlWQ2VzMjgzYk9hV25MUmxYRFB0QmxDSGlv?=
 =?utf-8?B?Umsyc1QvRzR1S2FjTTEvTGJnOVg1bVNCS2c2bjMxMkJnVGlHVVFqaGltNjNT?=
 =?utf-8?B?ODRXT0xHR09pMVYvUTlxRWE2QXJZQXQyK3BrY2xrWk82Rm1reXI3NGRSNzBZ?=
 =?utf-8?B?b01CL1NYZm91UjYrTEgrREh4YzBQcjU5ZTM1T2oyVS9OYXljRFhXMTVoYTRK?=
 =?utf-8?B?TldUWEZFZVNZS0M1U1RCNFBZV3lnQzdKbDF0LzhtVkxxNmh0cUZyNjltU1F3?=
 =?utf-8?B?NGZTbU1RcEVPY0RHQitmWFlIRUR4Wm5jZjI0Mi91VGN1cFcyYzBEcEp3bFF6?=
 =?utf-8?B?Y2lQMWRMRVpRbnM5bFlmazJIWE9BOEdJcWlKY1phMFEwVjRoVmRCSUtKTGtW?=
 =?utf-8?B?YXVuWHE0UTFKT1g0R1duNDYyam85RHRvcmtySjl0TjRJa1ZmZXZoVDg3UnRn?=
 =?utf-8?B?dm90VS85MmZRcldxeklRL1ZXQXRzZk04MmRVbGxmcWpaMlZ5bTAxL1lyY1V6?=
 =?utf-8?B?UFFKRWdHRUVpL3Q0b1lqV0VRbXp3WUE2Y3kwK0Y3SjBMVHlIanpkamREakxa?=
 =?utf-8?B?L0gvTGplRXlCSndDWGlEb1kzSG9waDVFSnBTeEM1NVB6SXVyYVVBMUZUbEYr?=
 =?utf-8?B?bExmTUF0VHJaTkx0ZWYrNEtBL2wzdU8zdGxVUVozTXdwWFk4bHRxbjBsdkhj?=
 =?utf-8?B?U1NJUEd0MnQxcHdmOCtsUUh0OEdiQUhvTU44eEo2RFVIbnVaTGxDaG1zS1Yy?=
 =?utf-8?B?TFR0RUkrdzd1Rmg5QjNkRmZCZGNlYkdCaktneFRNR0VBdVJhRDdNWkRZTFE1?=
 =?utf-8?B?SktVUVkyMjZRblFFSUZQSkdiY2tCcnUrdlc1RUpUN1htUVV1RW1oOWZPaEFZ?=
 =?utf-8?Q?bZJmYvJa7b0mU6gL3WUvkW7nX?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cec05f8-e40c-4a8c-85f9-08dd0331f80d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2024 15:52:10.8204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8kXTS7PCU3r2TmrFKDHEOATHnNqJj8ey5r66i7P3rAPkoRI9FUNz7XQJ3acxkFij7B8qHbiTgj1r60FRgu4qGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7655

On 11/7/24 17:24, Dionna Glaze wrote:
> ccp now prefers all calls from external drivers to dominate all calls
> into the driver on behalf of a user with a successful
> sev_check_external_user call.

Would it be simpler to have the new APIs take an fd for an argument,
instead of doing this rework?

Thanks,
Tom

> 
> CC: Sean Christopherson <seanjc@google.com>
> CC: Paolo Bonzini <pbonzini@redhat.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Ingo Molnar <mingo@redhat.com>
> CC: Borislav Petkov <bp@alien8.de>
> CC: Dave Hansen <dave.hansen@linux.intel.com>
> CC: Ashish Kalra <ashish.kalra@amd.com>
> CC: Tom Lendacky <thomas.lendacky@amd.com>
> CC: John Allen <john.allen@amd.com>
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: "David S. Miller" <davem@davemloft.net>
> CC: Michael Roth <michael.roth@amd.com>
> CC: Luis Chamberlain <mcgrof@kernel.org>
> CC: Russ Weight <russ.weight@linux.dev>
> CC: Danilo Krummrich <dakr@redhat.com>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> CC: "Rafael J. Wysocki" <rafael@kernel.org>
> CC: Tianfei zhang <tianfei.zhang@intel.com>
> CC: Alexey Kardashevskiy <aik@amd.com>
> 
> Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
> ---
>  arch/x86/kvm/svm/sev.c       | 18 +++++++++++++++---
>  drivers/crypto/ccp/sev-dev.c | 12 ------------
>  include/linux/psp-sev.h      | 27 ---------------------------
>  3 files changed, 15 insertions(+), 42 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index d0e0152aefb32..cea41b8cdabe4 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -528,21 +528,33 @@ static int sev_bind_asid(struct kvm *kvm, unsigned int handle, int *error)
>  	return ret;
>  }
>  
> -static int __sev_issue_cmd(int fd, int id, void *data, int *error)
> +static int sev_check_external_user(int fd)
>  {
>  	struct fd f;
> -	int ret;
> +	int ret = 0;
>  
>  	f = fdget(fd);
>  	if (!fd_file(f))
>  		return -EBADF;
>  
> -	ret = sev_issue_cmd_external_user(fd_file(f), id, data, error);
> +	if (!file_is_sev(fd_file(f)))
> +		ret = -EBADF;
>  
>  	fdput(f);
>  	return ret;
>  }
>  
> +static int __sev_issue_cmd(int fd, int id, void *data, int *error)
> +{
> +	int ret;
> +
> +	ret = sev_check_external_user(fd);
> +	if (ret)
> +		return ret;
> +
> +	return sev_do_cmd(id, data, error);
> +}
> +
>  static int sev_issue_cmd(struct kvm *kvm, int id, void *data, int *error)
>  {
>  	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index f92e6a222da8a..67f6425b7ed07 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -2493,18 +2493,6 @@ bool file_is_sev(struct file *p)
>  }
>  EXPORT_SYMBOL_GPL(file_is_sev);
>  
> -int sev_issue_cmd_external_user(struct file *filep, unsigned int cmd,
> -				void *data, int *error)
> -{
> -	int rc = file_is_sev(filep) ? 0 : -EBADF;
> -
> -	if (rc)
> -		return rc;
> -
> -	return sev_do_cmd(cmd, data, error);
> -}
> -EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user);
> -
>  void sev_pci_init(void)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index ed85c0cfcfcbe..b4164d3600702 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -860,30 +860,6 @@ int sev_platform_init(struct sev_platform_init_args *args);
>   */
>  int sev_platform_status(struct sev_user_data_status *status, int *error);
>  
> -/**
> - * sev_issue_cmd_external_user - issue SEV command by other driver with a file
> - * handle.
> - *
> - * This function can be used by other drivers to issue a SEV command on
> - * behalf of userspace. The caller must pass a valid SEV file descriptor
> - * so that we know that it has access to SEV device.
> - *
> - * @filep - SEV device file pointer
> - * @cmd - command to issue
> - * @data - command buffer
> - * @error: SEV command return code
> - *
> - * Returns:
> - * 0 if the SEV successfully processed the command
> - * -%ENODEV    if the SEV device is not available
> - * -%ENOTSUPP  if the SEV does not support SEV
> - * -%ETIMEDOUT if the SEV command timed out
> - * -%EIO       if the SEV returned a non-zero return code
> - * -%EBADF     if the file pointer is bad or does not grant access
> - */
> -int sev_issue_cmd_external_user(struct file *filep, unsigned int id,
> -				void *data, int *error);
> -
>  /**
>   * file_is_sev - returns whether a file pointer is for the SEV device
>   *
> @@ -1043,9 +1019,6 @@ sev_guest_activate(struct sev_data_activate *data, int *error) { return -ENODEV;
>  
>  static inline int sev_guest_df_flush(int *error) { return -ENODEV; }
>  
> -static inline int
> -sev_issue_cmd_external_user(struct file *filep, unsigned int id, void *data, int *error) { return -ENODEV; }
> -
>  static inline bool file_is_sev(struct file *filep) { return false; }
>  
>  static inline void *psp_copy_user_blob(u64 __user uaddr, u32 len) { return ERR_PTR(-EINVAL); }

