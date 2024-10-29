Return-Path: <kvm+bounces-29935-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8156E9B45D2
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 10:37:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 418EE282D5C
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 09:37:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF850204920;
	Tue, 29 Oct 2024 09:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="o1ltx7K1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2061.outbound.protection.outlook.com [40.107.236.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99521E102D;
	Tue, 29 Oct 2024 09:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730194612; cv=fail; b=GThRmfbxrVy9VYAjL4B436qIoys5NFgpc317EKe9aUPOF7RSS/5eapGXZRqPePTLAZ7e6DYghPDn65airU1vze0dRXcZckJL4f0bHEAFu/ZbVGCxAoEUiO7vwkAPk/A/mUpCsf2er4kfflswtBkPxDVN++Up+qugnJZMxdNggO4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730194612; c=relaxed/simple;
	bh=KPdeqVxhK34PEAQXlZ/BNEWEO6B10uS5uahl51AFYe4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=euJQGpovJvzoAExXxsflAC8E1WQyxdLrnunRlibgFauATrf8B/6TP3QoK19UoB1lUMH+xsSByF6hb9FFxan6m6FB4m6xO++5WwOPs2IJKW8B9riuotrB36OEsphV+W48ba3CKBa3QvNDD4UgBlATq6UbzeZWmx20moREb8Ih7KE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=o1ltx7K1; arc=fail smtp.client-ip=40.107.236.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BVSt5zijNZvzpQ30OrcLdN7JmaeRkAERl4dnYkMyv7xE2R6hFxxGPx5MBJGfW/zwmeFCU6F2a8ikiYFh48H4vgXlQvw3NGV3CK1rbxYCI4QNd2+duy+FnXbmH+1yLKZ0gSfQWKCE06O2hQZCN5t4P8KSkPiXVDtFHTihiOPtKsoGOUSHrLUu/F0lSLXp23P15CyKq5cLJoZN4iArMFT3EtTEzF1CaXoUMpp0lqWk3Vfu6MvC74Ri6g+9WJSNOsTwItW+2t1W7ZpuiPEdT88adFvzqlXZRDx6LwbV7jZQMfRSAji4oEJVlkdh5D18FlaTVu5TnxR0wEOf2BRGDMFn+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3WWdVZ7D+vTRzlmCGn2hZxw4FjkrB+7U9gOr7i49ZM8=;
 b=Pd5QeLeFdyMwBkZTVLzdUXC9Z2eUiKIoktKWE3nObKHGobimzPIetpE3O5cIpclQRmjJxnAzrGjrIDEE6HEw/8AxlhbGWvbTPOoCd7AxydwMYEqpJuLHyZx/ayODLLq1ctJ3mz3n8+onuI5pMgVSAN8HVsr14hXSW4T0gmhWvU0HZjnu0JdVEqJ3HYBhGr3Ibo7s//DlIi6nujtRq/Q6qugdhGPNAvaPLfsI1IC4Kzsx4EjwzF4TXuYi2TzjTgyugZTLV540JTrXAGGmocBxNB7ERX4+g06tlS5T/tifB2xJGlvGtfD/H+Hc++vRUcgugMXxOqYmR7voD3XBdGuSIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3WWdVZ7D+vTRzlmCGn2hZxw4FjkrB+7U9gOr7i49ZM8=;
 b=o1ltx7K1n3eIpBIh0S+IwyVTnqHWKt127k6oQ/BTj8FwnRWSxoij4KJgVV0ACU+OHFxntxcSoQpbvMMdkeyjrJoCsRCoevKJlrAaACAfxLzWTm5aWcOKsGjoo3GWnYnxIheHdTbxjQWJpR3eET2YQsPFHLjMoQSglNHP9iiubTw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 SN7PR12MB8026.namprd12.prod.outlook.com (2603:10b6:806:34b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.24; Tue, 29 Oct
 2024 09:36:46 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%4]) with mapi id 15.20.8093.024; Tue, 29 Oct 2024
 09:36:46 +0000
Message-ID: <8c824034-60cc-fac4-fe1c-c55bbedbb020@amd.com>
Date: Tue, 29 Oct 2024 15:06:37 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v14 09/13] tsc: Use the GUEST_TSC_FREQ MSR for discovering
 TSC frequency
To: Xiaoyao Li <xiaoyao.li@intel.com>, linux-kernel@vger.kernel.org,
 thomas.lendacky@amd.com, bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20241028053431.3439593-1-nikunj@amd.com>
 <20241028053431.3439593-10-nikunj@amd.com>
 <b015fb9c-4595-49a9-afde-ef01a45e15d1@intel.com>
 <ebfae76b-1a4d-175a-e0ab-91319164e461@amd.com>
 <ff5d23fa-12c6-47bb-8309-b19d39875827@intel.com>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <ff5d23fa-12c6-47bb-8309-b19d39875827@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN0PR01CA0042.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:49::13) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|SN7PR12MB8026:EE_
X-MS-Office365-Filtering-Correlation-Id: cacfb753-9235-49ee-2e4c-08dcf7fd34a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cFhHSkZHbnJIa1pUd2Q4dTBwSUlPTmtlMEdvNjFhVWFCdDRiSUZYRFQraTh3?=
 =?utf-8?B?NXlQcUN6RWFmVFErb3B4VXREbktUeG41K09HaGQ2NzU1WTM0MDJHOVdJcE1J?=
 =?utf-8?B?NGFtSllVdnBPOGUxSUtNbE9seVVCSkpsZWpwYVZ0NXFlQ3hmUkJqYlo3bHRx?=
 =?utf-8?B?SDJEK0FRc0lRcEdOMEM3cnFSWVRSTnFVb3VMNncxVXRPL3NzaENlTEx0NFFU?=
 =?utf-8?B?eFlOY1hHQ1ZwOUN1MGVQTllNOEx0VnVkcVRUbzVUTHRqTWdDWXdOUjg3TGNX?=
 =?utf-8?B?SW9uanBVY1dCeFA2cW9vVzZob0FNNnNaZW56QUNqWENkdUQ0OWZmWUprbGxG?=
 =?utf-8?B?YnlkMlBRaTJTUm9jUVRmMjBEZ3NwbzhPM056M0dIc2xRRjFUaHZ2S0RFNkVH?=
 =?utf-8?B?Q1pCU3RVMnlxQnpydmtJMDBSd1ZUTkRRaWxtRGNpTVpPSHpNbXp3N0FCR1lh?=
 =?utf-8?B?N0JwYXg5dzluQ1NsSGQ0dzJHU3AvR2dlVHoxUkFEbEd0K1VnenRsTXhzQ0o5?=
 =?utf-8?B?dmVRUmYyakFiQkxoOEhYSkpTQXp4bG1XMkRsZndGTXFmaVE1cFJNenkvZVov?=
 =?utf-8?B?cFFFc3N0RHM0bkdiY2lacWJ2TjYwY0UyNlhZYXVCb1g4RW9KNUpSa0V0QzZT?=
 =?utf-8?B?ZnVFbktKUGtqOU1hVDlseWJmSXhHMGU1dWw5Z3NIeHZYUU9XOXEzdTVDSmcx?=
 =?utf-8?B?dTRMdWFwR0tDODV1TDdRRlFYaEplbHVHamw4ZzdzZGJMYmJuTUgxZk1BTmF2?=
 =?utf-8?B?c0RKb1BiSWp6LzQ3Y3EraFhTZ0xoQkkwNlhYOStVRUE3V1hMSG92Mk80MklZ?=
 =?utf-8?B?MEl1ejY3bS9tRTRRai9rVDdETFNiTmIwNHhTRUpyN1dlZGJDamdxRVg3U3E4?=
 =?utf-8?B?NXp5cDFBc3lmSUlSL3BCS21rRVZ5a2I5am9VaVBLUE0rbnNEUzBET3duc1Y5?=
 =?utf-8?B?NnU5eC8rUTk0N0RYcjhsS0RPNXN1N1NGQ2NRUkxPTm1JQlV0ZHZhdWhLa1Z6?=
 =?utf-8?B?MHJSdlVpdzIrYkdHVjRsdEM3cW0zQUZJRElRMVFGSlFYZlhUYjl5QTVnam9q?=
 =?utf-8?B?UUw4WHhUQ1M3WmVubUhBYWJmTDJlT1lxS3orOG00SkY1cUNzZTl6WjV1QkQy?=
 =?utf-8?B?QjY0ek81RlBYNWxkOXdyUEhmK29jTVJiZitlL2xweU04UkZrTCtiSHZHOXBz?=
 =?utf-8?B?VXR6QWJ4NmxXd2NzSEI4MUU1dWdkWjF0TXpNQjRHeUQ0MU5zUW8yU1MrOGli?=
 =?utf-8?B?d0VscnlvK0MrSzFsOTJTNmpIQ3h3RDYvcTVsZWxFNzBVclBoMm5Vd0ZmLzd3?=
 =?utf-8?B?dlhNOE1CT25rbGF0ektlTHVhMEhmalJQV2diN0ZFZlpFSGplLzNFQjdUR2pl?=
 =?utf-8?B?ajd2T0JINW54MU9pakdXOExSVlFRRUI4S1Q5UCtWUWxEYTE5MEVlSk9FU2sx?=
 =?utf-8?B?czUybTNZNGxrenM0eDJJNUlHcHdvQnl4VTJZSWVmY1RNMmVDT3Q5Sm8rYStH?=
 =?utf-8?B?eDJqRFpDM3pMSHpvZlc4MWROam5udCtRdmVDZXZHUzFuYnVkbC9Ka01CQWpv?=
 =?utf-8?B?RUJEV0c0RS9kUVVPdXh4UjZ5dnI3THc0YTQ2QXQvTGFtWHVxUDJhb0JDTk5r?=
 =?utf-8?B?VVZ4WHF0UVdKQ3kydVNnZ0xJaS93NS9zekRRdzJ1TmFhVjUxMmFrMzJaZVEw?=
 =?utf-8?B?ZnQ0bXkzbSt3Qk90SkpFalAwbjRXSk9qZkpQR1dpYnZSb3FlOVo2bGlxaGp1?=
 =?utf-8?Q?uXRI7BAz6Hrc8tUGT8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R3diVnFiY2VjM1o4dWxjVlltM2VKdE5sL3ArSEZ5anBWYkpMejluWmF6aTNM?=
 =?utf-8?B?TllsSVpyRWRSZEd4UDJJblU4RWtDanVLa1hzNnhRQjErZWdNY1UwSjZmU1ky?=
 =?utf-8?B?RnFVMEhTZmR0QnFwa0dwdVcvTEpPYU43TnRqek9kdXI4WXZmQUJ6UmFSTm8z?=
 =?utf-8?B?eFJFREFjdEhHbFhMMzJRTjZTY25BVXJDVHorOXdjaUtBODltZ25wWksxeisw?=
 =?utf-8?B?eEl1OTFkcUpsK1orZCt0SFByNGxIZmNQVGpIbVFydTMxN2hZT1pNZnJJb09t?=
 =?utf-8?B?NkJHbmlBSjliMUhjQUdMMWd5RWpzTTJWMmpTdVNTbkhWQlBOeUFvekk5OWo5?=
 =?utf-8?B?UytIc2hQcTdYbGw0S0UyUHBlZWxLdm1Nb1FTWTVxSzA0MUNxMndmL0NXWEhG?=
 =?utf-8?B?UUhGa0dhMjNBaDRHTGF0V214Q1NVTi9SUUZMZWd4eGlmczIrRWovdEF0Q1dL?=
 =?utf-8?B?dWxObWZrV25JZGdpQWVqWDFUT2RSK0ZzcHJFUFJmNHU4OWpmYmtWbUZ3djVu?=
 =?utf-8?B?QkhwVHh1ckFsL1BML0tQNjlNY3pQYTQ2NWZnY0lVTDc0Vjk4dFJGUThJdG9Q?=
 =?utf-8?B?cG1WQmM3QU1Jei9vbVBLdWMzSW00ek5kQzFoalNYZEZpTVJnZFBKcDV3YWxD?=
 =?utf-8?B?NUlRNHNIWDNuVEtyZHMwemMydjIwVWh0amN5YTl3b0JjakxkSjBtRWJjU1FK?=
 =?utf-8?B?ZHRBSk1iNklBMWtFSnd6aTE2eGE3dnoyTzRpQ3Uzd2hhajB3dlBQRklSdmhO?=
 =?utf-8?B?RE5ISXlGQnZtMGVFVTdoN1dCc2s3VmRZV0tVT08zbklzYXdKWHd3SS9kMzlT?=
 =?utf-8?B?Z0wzclBlTkJaK0JZYW5mNk1hMThqZWMweHd5TndJOHcxNTZLRmtLeFlnVGFS?=
 =?utf-8?B?VXJYNHVRM0lGMVUwMUhQdTJUUkRoYXBhWUIwRkhxM05YdTk2UVFweHpYb2hq?=
 =?utf-8?B?M2ZUNTh5empwa0hrWU5CSG1OUlpDK2tXNk9wU0dnRHc0VXBzazhnS2liWjE2?=
 =?utf-8?B?dmN2M3ZaTWFMWWNhcStNd3lzMmJxbWtjZVBRMlpEeVhJVHBXNUJybXFDVFBI?=
 =?utf-8?B?NHNIQjBYa3kyMkFadktlUjRJMTlHalBsUUsxWmJSRXBpeVNTN0RyN0tRSi9o?=
 =?utf-8?B?SXQ3Q1pXLzUyaWdnYTZUWkpSS2tTKy9OMGZUMmhmUk9mMDc2VVBjQmh4V0dH?=
 =?utf-8?B?Z1c3NHJpOTNZVmd3Qnd6Q3o4Z3VLRHk1MW80NU5vK3FQNmpIZjNKdHVPYXpG?=
 =?utf-8?B?NmoreEVMaUdmbGJvN0lPaHRxVXZwVkhselZBdGtKTTVIbjhXYndwVUVENllu?=
 =?utf-8?B?cUtMZU82SVFtQkVEVmtaZ0Y4YlMrTnAzYWVsY1NFMHhZeTAvTytTUXNTY3ox?=
 =?utf-8?B?azFrYkh4YzE1KzU1bDhkejRVVUtVYzV5SklkdEF0MlVYVVdRc0NHNGhlL21N?=
 =?utf-8?B?L0J0eDU5aFIwSDdCYXNwZTladys3NUhGbnpNaGtIMy81Skt0TnkxL0NjTWxG?=
 =?utf-8?B?ZGRZREdNaFpUWElvSEpmcVI1NjNEWm9Hc0lqZnQ1RlArV2p4dEJJMUZueXAw?=
 =?utf-8?B?RVFHcEJFQWRTcmIyUmJwM2NFZDAwN3ZNdjBMMWRWdlhzT1BoQml4M0ZxUyts?=
 =?utf-8?B?WGhJeUUzcUhaUm9tSjBqZzk3NDUyenc3RVNSNnVQUDUyVCtmQmwzS2Z5djRY?=
 =?utf-8?B?RHd3YzVObTJrdWt6U1pQRUw2VUJjOUhmUi94UGJ3SjRLTmEvc1A4cGl3SlVV?=
 =?utf-8?B?MW1Kc08xTFlHQ1Y0RU4weG9TTUVDWDNvaUpscVdLekRpcG4yWUxpdDZ6NmRN?=
 =?utf-8?B?TTFpR3pWTW4va0NuWCtXWElXNXgvbDZBNVVJUjVqR2paS0VkdlBOYkh4QkRa?=
 =?utf-8?B?cTd4TjZMVkpSajF1WTBURGhjOUt5US85UFlKRXJXQm11bW5KN1Y3dXlrdm14?=
 =?utf-8?B?aEhGL1c2ZTRkaGV2V2NuY1Z6c05pR05ZUlNDR2xoRTZ4Sy9McXFNZkR3LzNY?=
 =?utf-8?B?SWQwYmZsZkZDTHk2eHdpWHFzMlVBdHlGNVB5d0lPQ2F6WTdmU1NoSm12MW4v?=
 =?utf-8?B?MDJ1WFhmTEVwbHJiT0xrNFhOc3BxYTR2YTB6NGo0eUFmcEh4TmJrZlFLK0ZU?=
 =?utf-8?Q?tA4xhMz07lCIYf7diUAzbVP7w?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cacfb753-9235-49ee-2e4c-08dcf7fd34a3
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2024 09:36:46.4925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BaL6R935NZlQ8ih3FH0w52vfQfJxKvX0JWMwAoiLOaxBoHBfcU56oP5p91fn9IdYNMeh3GtePxLD61lpeHKt2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8026



On 10/29/2024 2:45 PM, Xiaoyao Li wrote:
> On 10/29/2024 11:56 AM, Nikunj A. Dadhania wrote:
>>
>>
>> On 10/29/2024 8:32 AM, Xiaoyao Li wrote:
>>> On 10/28/2024 1:34 PM, Nikunj A Dadhania wrote:
>>>> Calibrating the TSC frequency using the kvmclock is not correct for
>>>> SecureTSC enabled guests. Use the platform provided TSC frequency via the
>>>> GUEST_TSC_FREQ MSR (C001_0134h).
>>>>
>>>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>>>> ---
>>>>    arch/x86/include/asm/sev.h |  2 ++
>>>>    arch/x86/coco/sev/core.c   | 16 ++++++++++++++++
>>>>    arch/x86/kernel/tsc.c      |  5 +++++
>>>>    3 files changed, 23 insertions(+)
>>>>
>>>> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
>>>> index d27c4e0f9f57..9ee63ddd0d90 100644
>>>> --- a/arch/x86/include/asm/sev.h
>>>> +++ b/arch/x86/include/asm/sev.h
>>>> @@ -536,6 +536,7 @@ static inline int handle_guest_request(struct snp_msg_desc *mdesc, u64 exit_code
>>>>    }
>>>>      void __init snp_secure_tsc_prepare(void);
>>>> +void __init snp_secure_tsc_init(void);
>>>>      #else    /* !CONFIG_AMD_MEM_ENCRYPT */
>>>>    @@ -584,6 +585,7 @@ static inline int handle_guest_request(struct snp_msg_desc *mdesc, u64 exit_code
>>>>                           u32 resp_sz) { return -ENODEV; }
>>>>      static inline void __init snp_secure_tsc_prepare(void) { }
>>>> +static inline void __init snp_secure_tsc_init(void) { }
>>>>      #endif    /* CONFIG_AMD_MEM_ENCRYPT */
>>>>    diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
>>>> index 140759fafe0c..0be9496b8dea 100644
>>>> --- a/arch/x86/coco/sev/core.c
>>>> +++ b/arch/x86/coco/sev/core.c
>>>> @@ -3064,3 +3064,19 @@ void __init snp_secure_tsc_prepare(void)
>>>>          pr_debug("SecureTSC enabled");
>>>>    }
>>>> +
>>>> +static unsigned long securetsc_get_tsc_khz(void)
>>>> +{
>>>> +    unsigned long long tsc_freq_mhz;
>>>> +
>>>> +    setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
>>>> +    rdmsrl(MSR_AMD64_GUEST_TSC_FREQ, tsc_freq_mhz);
>>>> +
>>>> +    return (unsigned long)(tsc_freq_mhz * 1000);
>>>> +}
>>>> +
>>>> +void __init snp_secure_tsc_init(void)
>>>> +{
>>>> +    x86_platform.calibrate_cpu = securetsc_get_tsc_khz;
>>>> +    x86_platform.calibrate_tsc = securetsc_get_tsc_khz;
>>>> +}
>>>> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
>>>> index dfe6847fd99e..730cbbd4554e 100644
>>>> --- a/arch/x86/kernel/tsc.c
>>>> +++ b/arch/x86/kernel/tsc.c
>>>> @@ -30,6 +30,7 @@
>>>>    #include <asm/i8259.h>
>>>>    #include <asm/topology.h>
>>>>    #include <asm/uv/uv.h>
>>>> +#include <asm/sev.h>
>>>>      unsigned int __read_mostly cpu_khz;    /* TSC clocks / usec, not used here */
>>>>    EXPORT_SYMBOL(cpu_khz);
>>>> @@ -1514,6 +1515,10 @@ void __init tsc_early_init(void)
>>>>        /* Don't change UV TSC multi-chassis synchronization */
>>>>        if (is_early_uv_system())
>>>>            return;
>>>> +
>>>> +    if (cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))
>>>> +        snp_secure_tsc_init();
>>>
>>> IMHO, it isn't the good place to call snp_secure_tsc_init() to update the callbacks here.
>>>
>>> It's better to be called in some snp init functions.
>>
>> As part of setup_arch(), init_hypervisor_platform() gets called and all the PV clocks
>> are registered and initialized as part of init_platform callback. Once the hypervisor
>> platform is initialized, tsc_early_init() is called. SEV SNP guest can be running on
>> any hypervisor, so the call back needs to be updated either in tsc_early_init() or
>> init_hypervisor_platform(), as the change is TSC related, I have updated it here.
> 
> I think it might be due to
> 
> 1. it lacks a central place for SNP related stuff, like tdx_early_init()

sme_early_init() does the init for SEV/SNP related stuff, but this is not the right place to do TSC callback inits as kvmclock will over-ride it.
 
> 2. even we have some place of 1), the callbacks will be overwrote in init_hypervisor_platform() by specific PV ops.
> 
> However, I don't think it's good practice to update it tsc.c. The reason why callback is used is that arch/hypervisor specific code can implement
> and overwrite with it's own implementation in its own file.
> 
> Back to your case, I think a central snp init function would be helpful, and we can introduce a new flag to skip the overwrite of tsc/cpu calibration for hypervisor when the flag is set.

That again touches all the hypervisor (KVM, Xen, HyperV and VMWare). We wanted to move this to common code as suggested by Sean.

Regards,
Nikunj

