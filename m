Return-Path: <kvm+bounces-33279-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DE9F19E8B6E
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 07:17:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42DDB281398
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 06:17:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6728F2144A9;
	Mon,  9 Dec 2024 06:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tqHeyw5I"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2068.outbound.protection.outlook.com [40.107.236.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A497216C69F;
	Mon,  9 Dec 2024 06:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733725018; cv=fail; b=DH1KWGs1kdq5aAy1zvNV81CRE4evPMaKA3QYg1B8CdkzfPx/7qrZ2q3bOrta93hR1TCqUxjb4mcSPI2zIndyIHXezND7RsTAO4A6mLGj5xSkEJB8ieNDXqswh6sRnQjWpFlAQXtb3seJ/2/GOH/H4uNARS/7lw8AcknawbjpkEs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733725018; c=relaxed/simple;
	bh=vH+MA0QmiY2ZH1UXD0eCSlZyjEavDYdrKu6h2D4JNGo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=M7Qgqmr147LdFQVHIFj96Scfu8gWQYJagDIvaoyt3FAxAr28icC7g6VRojjJJ5cc20ajeAKyK8lSmfx88ocRGv4j1xYgd7dr2o3xeO4XfzGm+Shxu0PC0P+VTUfY2+Fck9dicZbeQYiTwV713GTvODcuwuSTJYz3GcVO+4nopKg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tqHeyw5I; arc=fail smtp.client-ip=40.107.236.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M8lJDIz5bnEP+cbdBwuWEqVSC968R5t//gdGtFWCHlZ0RoMKNB7GU8HnO57Fi9BAp1LR4+p2llB+P2qX++pvA9xo1jaWqbcdaecjtfCrKbs4qjJux8efc+AUTSDjNfz5MX71Qpy2NwpTvgAAPWEjADttkQDUqZogeOPtZksCZOex04k7W3/wv6ZnrN3dGsrn+QzJRnDhWKnF2HrDDQAQz/pSuwfwkJxUbpJsgAPvQu5CDdCkc/AN8o7UG0me2kK8Gj3Yxjm4ooLAyqh1f5XCdlV3i1LiZofNst1ORl6YdXhzCYIx6i/WkxGG35te6neWO+xsTdxcouW+L8TFnFhFwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XjfCmXSGOzNC4NIvYyVqfz7VtDSq0NM+sTyX3NlJa84=;
 b=rmy4t+ZyzpoX10P/XtKdX7fW7fhSvwgs67KQke9DE1cy15/0v3J5R6g1DxAsWGiUSfI8TmsBdtxoUu4r8UQEJg5oNMptsqkWVDJd3Tk7+3hZoPr60dPuRUEakZ6BE7kFsjNqH4jKA+kDIKAapBdey3J7fJ10W2w8lYHsdvEqMD0WU44ziJv5+pjjHGLdu1fAXCqj6h10oOedQe00UB+tWNX0OfxEx3V98BqpH7nCm0rf/RBtyn2EnVTg/qkMn1e7vDxem/AulGECkNcpIOv+zBcFhLXI7vtG5nv5JiA2VVwGOE6PwL273Qzuh70ezZR8+DYCgrLpKifd5UsTaqb4pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XjfCmXSGOzNC4NIvYyVqfz7VtDSq0NM+sTyX3NlJa84=;
 b=tqHeyw5Iip1yTM1qP1RVYP2mjD4aB+ugDcJ+L7jmLmuQGhCpCalmNr6WA06aQeYAR01LiMFjR1BeakYvMmSnSYZvbCFquuxlH1cdo3cbym2NADAxkQyMfETW3kdeVN0PsKIyS62rV106+QNTd2UpJdjXwS3qrgX1o7OQjEwfbI0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 DS7PR12MB5766.namprd12.prod.outlook.com (2603:10b6:8:75::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8230.12; Mon, 9 Dec 2024 06:16:53 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%5]) with mapi id 15.20.8207.020; Mon, 9 Dec 2024
 06:16:53 +0000
Message-ID: <f0b27aab-2adb-444c-97d3-07e69c4c48a7@amd.com>
Date: Mon, 9 Dec 2024 11:46:44 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 01/13] x86/sev: Carve out and export SNP guest
 messaging init routines
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-2-nikunj@amd.com>
 <20241203141950.GCZ08ThrMOHmDFeaa2@fat_crate.local>
 <fef7abe1-29ce-4818-b8b5-988e5e6a2027@amd.com>
 <20241204200255.GCZ1C1b3krGc_4QOeg@fat_crate.local>
 <8965fa19-8a9b-403e-a542-8566f30f3fee@amd.com>
 <20241206202752.GCZ1NeSMYTZ4ZDcfGJ@fat_crate.local>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20241206202752.GCZ1NeSMYTZ4ZDcfGJ@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0163.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:de::7) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|DS7PR12MB5766:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e9eea6d-dc29-4538-0679-08dd18191342
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZjBhUVUxb1pvM1VDNUNObWU0QmhYdk9OWXVvM01OSEpSampoV1gvZ1hhRDFu?=
 =?utf-8?B?MXNqVkFub0tPMVVyYUd6Tzd2ejVDd3dkeXFaZHlxbWJEendUcEJEbkx4NHFa?=
 =?utf-8?B?b3k4NEViVisvSG93bmlXcldLNlc2S0FCWTJKOTJNMWdheTRpYUNMclhrSjFK?=
 =?utf-8?B?K0dwRkcwK090N2lkNVF5NnRhUTIwdFNVR1E4UWpPUWpnOHQ4aWY4M1dSdkRz?=
 =?utf-8?B?T1ZSTUNVYkd2SjN1SEJ0UTdmbFlNQlM4Smo4V0tHU2p2U2tUMWpTSFROOEwv?=
 =?utf-8?B?YjFUc3h3S0xsWDFGUGlBcFhhUDN0dFFoT2ZKdWVkV0s2SFpsK2ZCa2dRaW1V?=
 =?utf-8?B?bzhHaU5VcXVoN1lheXJMVVMwb1BwbHpHRnB1Mm9FeHNUZTRhcWR1L0xyZGlQ?=
 =?utf-8?B?NVg0ay8ybWNDZ2paNzRabkFZZ0pZTWgrMTZVZHZmYUpMdTNPYmFxZWRRUHRW?=
 =?utf-8?B?dWE2eVZPZWZQM0N5MTQxUlhXNTlNQU93Nyt5c0ZuK3piZUt5Q3JyaHc5eFF2?=
 =?utf-8?B?aGp6enFFcVc5OCtwM1J5ZmdLelBJYzJIT2taSGJjR25KVzlkTUF2eU1HRGNk?=
 =?utf-8?B?ZEc4QjZRaHRFbWI0d3JvM1dHSlJ2UWttdkd2TVVZUlRadVk1R1lHZUpCQUFS?=
 =?utf-8?B?bTZJRUd1U3dwNm04WmdwT2xoZ0NuM3RGaUxpQVZQQTRFZmFsalRYQWpDd09M?=
 =?utf-8?B?NFpjUXhrakxPaDM0VmZrM1hhcTZCZlN3ZE01elhheU5aMXNDRnpOZHJzWnFL?=
 =?utf-8?B?aFFESXhCRUZ6SFliY1VFTFRUK3F1RTVWWDVsVTZ5SEZ3L2hFekJDUUsxdVN1?=
 =?utf-8?B?RUorZUdwaC83NkxzY0E4U20wOWtYRzczdGNoaDhma1V4YUJseXpsWXZyMjdh?=
 =?utf-8?B?ZHFDR0RLSmUyL2d5Z3B1K0RmckRacnZMNmpwOExqdlBxWnFoejZhTC9wYWVj?=
 =?utf-8?B?SDBaSktobDR2Q1NJR2lWSFNROTdsd1FRTHd4WVM4bzJuUGdkaUEwbGZnekps?=
 =?utf-8?B?dUZDMXFBUWRYMzBaNFd2b3c4NCtGM3hGaitGeWFEd0pXOGt2dzdvTDIxL05N?=
 =?utf-8?B?aDR6VEY3WHNWTkNpUE9aM2w0NnNnRnhmYVA1N1pIYnJYVm5IbGRDdXBjSjVF?=
 =?utf-8?B?WWRIM3A2VlFMdzBZUDFiYUtpTGlNV0U5bHhaLzg5ZkZpT1NVd1h1cUM2ajJp?=
 =?utf-8?B?cUhLRkN5Y2hISXF0ZTR1R29VS0d3YTNmdFI1MmRmOVYxU0dUTWRYTjgxSXBP?=
 =?utf-8?B?WFQ4S0plZTluQnJZV1c0WGFQSnNKQVU2MzFYeVUrTzRXNi83V3VDSTg4MkJu?=
 =?utf-8?B?MFlvOHpQR2ZWOUtDUzJsdzhQeDRXbHdrYkZNWmYrZWVQZkdHVmNEb0NkOFda?=
 =?utf-8?B?akF0bWFsTW5UQ1RWRGEweDRNbmpLMFkzSlpTWUwrdFhjUjZqRUsvOEtxYmhO?=
 =?utf-8?B?Y015MlJFcHI3Rkx6a0dXRVorNnlNWTE3V0FFYzdIUEp2UXFvc3NEa3crRlBr?=
 =?utf-8?B?Mzl5SGMwSkN3ZE9NLzl3eEZOekdqc29xczhJVldsZjloZEEzUlU0eTBKdkdv?=
 =?utf-8?B?WjFlWmJiU0pNL0NOZjJPQ0UweXowbXpTazRLdTF5WVM4Q00yZXB0K3B1L09U?=
 =?utf-8?B?d2Z6U2VsUlNyK3F3NCtrcVIzT0lHTzBUY2dUUHhyVWxVV0VoMEFiNVpiTCtU?=
 =?utf-8?B?V21XNXNwNHoybVZZR2Y3N3R5VTdtcDNUdGh1T3JJaUdqSmVIRm5GSzJnWmly?=
 =?utf-8?B?eGRrdG56S3ZYSy9kTGF1eTl5Ylg3OUZhamhSL1g4eFcwdmwxbllCb0VWcGFT?=
 =?utf-8?B?dVhHVFBEMGRRSERHZXdJQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aTFrVTlqZnF0SFZDaUlRNHZzelJuWDc1aFlJUW14RTkwNzk5YlF2dzdRK2VU?=
 =?utf-8?B?VmFWdCtkbG9OQWxCZmJYOGgwMU5TSHNtSjlVOURWMTY5amhXVmNyeExCVDg3?=
 =?utf-8?B?QjdkcnFBVXREWVhOeDIvck5ZUncvMVo5NXZKMXFQNW5tclRrbWh3MDY1VWVl?=
 =?utf-8?B?V0ZSMjl4U3c3NXJEbjIzdFplUnhvMjRiYjg0VXBIc2JBSlNabEJHNm1GT0Ns?=
 =?utf-8?B?L2VPUDJHUFNuVWk2aTB5S0w3UHZocENxaUhEOEhMak9YRzhoU3Viblp4dDJo?=
 =?utf-8?B?WkJsKzdGQ2c3dHh1Umd1aldHZ2RKeW02SnZoNTV6ZUVYZzRDbVlDOG1UMmE2?=
 =?utf-8?B?Z2EwWnBwOVBNbHBKUWRySjZZQUZsZmNSL0J6bXV1Y1djMXg3Z0VNQ2kzMUFJ?=
 =?utf-8?B?RXN3RXUvMk9aUnFOdkpocld5S1BJRGgxN1ZOcTJCUzhFOGlFaTZlWnViaURB?=
 =?utf-8?B?WUZyU25vdy9qZ2ZZMHlZcjFCQzZrZVBGK3V4dE9MbFEvTE9yWWVkbkpYdktI?=
 =?utf-8?B?U1QrZ2F5ditYaUl0amdKZmk4VnNkc21aVDdYK1B0Tldkd0szZlVnd2FFcnNz?=
 =?utf-8?B?UjFITk1na1BCRWFHYmF0WWJlRnl6c3l3N0RLaTVLa0wzd3hmSVFjUmFRejJP?=
 =?utf-8?B?SEZhMU5SWThELzQvVE1LRDFuWEM2cjZJcTAvdTluZTJQR0VOcEY2MXlrWjAr?=
 =?utf-8?B?N1U1b0JXUHprT1IvdHVEQ3B6bmNGb3lNYkR1T3E2bWIvRm5XeE9WbDNDbURk?=
 =?utf-8?B?WWxxVm84cmVia3pSaTFQZjFjTDNtdW43U1ZabU5FMzRxYm4vZHlkLzVOb0xS?=
 =?utf-8?B?QTZ4djhsNHArMmVSUTl4eHhzcmZDcU5LSGpSZXNxamQvMkhCUG5ORzFlVEZn?=
 =?utf-8?B?bjBJMFpaRWdtOG5naXI0Wlc1RU51R3RvUDRhSE9CcE1jSlJQWmtTcnc1c1FY?=
 =?utf-8?B?RVlqVUdGWVlJS3pBejRMUm5yYVVpcWVRdG1OclErOFVaRkh1UlBHZDR2YmU4?=
 =?utf-8?B?Q2xZUnQ0VXpCYmVqdW5IZ0VOeGduOTROZGhwdkNpSkxzNnE5OVE5WEJZMDQ5?=
 =?utf-8?B?YkI1WnNCZ0huTVo3bXpPWnlSQ1FCSVFaUDAvRXc1VHY3WHcxTjdOcW1na1FW?=
 =?utf-8?B?Wm5wdXo0eHFnNVYyS1plWGc3RnFSeXI3MHZxRzJqeUl3RkVWOFVRR0pLYVNJ?=
 =?utf-8?B?YTA2SDNnTjFNQkQ2NmdaeFpqZThOVFMyNS9sYlFSeFovK1lYajR5K3hRNTlD?=
 =?utf-8?B?VFY1anJQSi9sa2wyVTU1TGcxYTdrUlJxL2t1Ly8rc0JPR2FaN0JpcklnQTFV?=
 =?utf-8?B?L3RDWFRGNzB4bHZacVBONko3RDI0UU5UTUlxdXFmR1o0VjJsa0RPNEtXeGFw?=
 =?utf-8?B?R0NpamUxQVpSQW9lVUhNeFdDSXhQYkt2VlNaRjFodHNNdXhWU0NJZEQwR3Ax?=
 =?utf-8?B?bU9uTzR0d3haN3hsSnhEcGszdkxqaldVTXFHZElMYVBtYnlHOXdVRlgwNWd2?=
 =?utf-8?B?TFNvSENBbXRJNllhcHRmeXdLbVBxQ2xTdlNEZEttWkx0alIwcjlTeGtwcVhJ?=
 =?utf-8?B?aVVQc0l4YkZLdG9FM1RRcUlXZmFDdFF2SW5ZQVM5bE5qT3ArYVZUaXJkOWE5?=
 =?utf-8?B?NXJ5dDF0bXluNlRBMDAyWWlKQjNsL2tkYU91b3IvdHdXOGVFQ21EbDNub1Ev?=
 =?utf-8?B?aTV6VndIUlduZGpTeFliWFFKeEpsVndpdXFCaGsvRm81bWp5WGNyTFpXNnZp?=
 =?utf-8?B?Qlg4Q1ZsRDR6THVuSStoN3ZDKzAwbkRqQmJ3U08yalVBSjdpU1VkSnkwenJl?=
 =?utf-8?B?UVd1T29sOWN4cGFpTWtlQlFlMS9pTkFhM0M1MlNJZ0VPRERIbDFjbzZOb09p?=
 =?utf-8?B?TzVoUGRWVjFkZTIvOVQ5VGlUZUJ6Qmc5UkRmR1ZUdTgvM2Z4MTlUaENMc0lX?=
 =?utf-8?B?MUdCRmtuQ0taaDlJY0hYTlArM2tVU1N6Sll1RHdzaHloMGZMSmprV0JuMlJK?=
 =?utf-8?B?cDB5Q1ZlYUZTOHBXYXdEaVJaS0Y2WFRRd3hJTTRXUTltZE9RRmU1Y2lUV3Uy?=
 =?utf-8?B?L0J2NHlEQ1pnV2dnQXZacU0vRWd3S3d1ZURhejlaNVBFWEN2MUlSR0V3Mi9n?=
 =?utf-8?Q?b3GWffL16v4qDmQJW3Irht2lG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e9eea6d-dc29-4538-0679-08dd18191342
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2024 06:16:53.6317
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l/46GeugWePU2NFBUt+r44cVprjqMzg7og+/wXq9EBEPYugLALXBI3UBdIt5R1qq9Jm9vVocZM9WCszDWwvnsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5766



On 12/7/2024 1:57 AM, Borislav Petkov wrote:
> On Thu, Dec 05, 2024 at 11:53:53AM +0530, Nikunj A. Dadhania wrote:
>>> * get_report - I don't think so:
>>>
>>>         /*      
>>>          * The intermediate response buffer is used while decrypting the
>>>          * response payload. Make sure that it has enough space to cover the
>>>          * authtag.
>>>          */
>>>         resp_len = sizeof(report_resp->data) + mdesc->ctx->authsize;
>>>         report_resp = kzalloc(resp_len, GFP_KERNEL_ACCOUNT);
>>>
>>> That resp_len is limited and that's on the guest_ioctl path which cannot
>>> happen concurrently?
>>
>> It is a trusted allocation, but should it be accounted as it is part of
>> the userspace ioctl path ?
> 
> Well, it is unlocked_ioctl() and snp_guest_ioctl() is not taking any locks.
> What's stopping anyone from writing a nasty little program which hammers the
> sev-guest on the ioctl interface until the OOM killer activates?
> 
> IOW, this should probably remain _ACCOUNT AFAICT.

Both get_report()/get_ext_report() are in the unlocked_ioctl(), we will
retain the _ACCOUNT

That leaves us with only one site: snp_init_crypto(), should I fold this change
in current patch ?
Regards
Nikunj
 


