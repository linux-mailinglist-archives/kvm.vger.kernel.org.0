Return-Path: <kvm+bounces-30959-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 15ECF9BF03C
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 15:29:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA0C72858A8
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 14:29:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B3D82036E1;
	Wed,  6 Nov 2024 14:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="IEyCporS"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2045.outbound.protection.outlook.com [40.107.220.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257371DEFD7;
	Wed,  6 Nov 2024 14:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730903351; cv=fail; b=JCEPT7r8tdiajbuS8MqAL4iHe7WIF8TY1qCyAGSDvAEWFryflYfbDwgMYA3C+o/mEYqlurtpt0xr92GK1Sks4UFf4zwzJ1QuJyhCS+YD3429SOjRAfR87jF/lK6QyzpXI1r1TCtNhT2N8BB5wpcjv41ux2X1F+slqbdRwuSyFuk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730903351; c=relaxed/simple;
	bh=3GTEBk68A4fZ2SpOJ3rcd26Op2/H66PE/0RLpQMY23Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WbNVVOCUJtc4lAslRY4gHkYcpyuUJakEWKFaUBljVbT2rc03x3u/pvvZQofy5BCZdxocLy5kbe7h1FXxCYlMRlEHkO+3Wgq3zLDORXsAe61QjdmkIDodk966RZp1vgNe/iphpNXJSMk4TtJwdoZ5MmYQWKovz9b0HdaBQZRSKb0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=IEyCporS; arc=fail smtp.client-ip=40.107.220.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o/KUuiZBJFZGHTHeSAGkmSyNh0aV0rqU5Zkm/Trfj5qq7+kddMqoURb8U+KyWW7HK9RXot4tGTcz5P7CcX6KcRiH70cX6D8LKDCiZgXJ17l0SAUZXrSvwjJzsNKQugM8Wg+pdH1ZqSfmeKNi+G4SQtjWbXBztP1py8E+Judt22Fal1KXGOPd/na1piSVU3lkp0mXVLbR/xgCpLUy1HJbw/0y3mCT2VjEvoZnxPBUDR5zJf4m+FP3fJeetRydW7mjZCT9cYaTZj2sXIU1XBvcE8Hzdai0onqPddp6at48SsOxDgGAjR63ChbplVAYMSa5uIFb4RJPkQrspZ/w3BOWEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WxFcdehw5kmmdN6cPfCu/C67a7kMt8Xe9aeA1By+Nx0=;
 b=HT7oTP2x3R03l/VkYOMfT0jYfc//t5UBGrRgY+XKsz/I/S+eiktFRjzI1lVs3kb3lMrY/pQb2kdcYGhkdOCpx+vadU4hT/QZo9grIHn5oUt3ljN5wXxeJUYZ0Xb1usdFMrBzgZZH3LrHeaUJ8PDP0+JXdTjsfYc4ewnhmLvdV3F9RJZqPs6+ZiOZ5Lb0qypTi34rZxcl91l3Sv6p9mzmyCQVmHf103wn7dh8JB1uTEMi4AoxL6RrnhRdT25eQ7NXnbAMmqRPN/zV7QV1fxKCOXMm8vSu74C/L2Y3v2l1b4vlqmfPM6J9xL009A6nM6ksowwQhyNs3fA6OInEPITmqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WxFcdehw5kmmdN6cPfCu/C67a7kMt8Xe9aeA1By+Nx0=;
 b=IEyCporSsanKnmep4xcqVj66vQolCsu5jooofN9w2l3eV5EXZLu0KBgdL4zvJwXBXpgrsRGAhP0aIju4+LrLZUxRcBPcbCBCYt36jxxxdDlOvsR7sD+3fxBe6EYGpAaQX1ViE4xCqTqUrGqQb8pWYlIxPNa0qBoY+Hf2aeJx3m0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH7PR12MB7377.namprd12.prod.outlook.com (2603:10b6:510:20c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Wed, 6 Nov
 2024 14:29:07 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8137.018; Wed, 6 Nov 2024
 14:29:07 +0000
Message-ID: <867da10c-352b-317e-6ba8-7e4369000773@amd.com>
Date: Wed, 6 Nov 2024 08:29:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v4 1/6] kvm: svm: Fix gctx page leak on invalid inputs
Content-Language: en-US
To: Dionna Glaze <dionnaglaze@google.com>, x86@kernel.org,
 linux-kernel@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Michael Roth <michael.roth@amd.com>, Brijesh Singh <brijesh.singh@amd.com>,
 Ashish Kalra <ashish.kalra@amd.com>
Cc: John Allen <john.allen@amd.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>,
 Luis Chamberlain <mcgrof@kernel.org>, Russ Weight <russ.weight@linux.dev>,
 Danilo Krummrich <dakr@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Tianfei zhang <tianfei.zhang@intel.com>, Alexey Kardashevskiy <aik@amd.com>,
 kvm@vger.kernel.org
References: <20241105010558.1266699-1-dionnaglaze@google.com>
 <20241105010558.1266699-2-dionnaglaze@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20241105010558.1266699-2-dionnaglaze@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0066.namprd11.prod.outlook.com
 (2603:10b6:806:d2::11) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH7PR12MB7377:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a687862-0e2b-4b39-f998-08dcfe6f5f02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SXFuSm5RcGxycGcwdlVDYjdMOXBqdWhUMW5OMU0vazJVZzF5SlJyRUhmRjR1?=
 =?utf-8?B?b25yL20zVkN1TzJSa0EzRG5aUHBXTXBvRTdrRkdad0hBaDVMc0ZvT1BXeGZr?=
 =?utf-8?B?ckhCK01odFhaNjM1TVRsVnVvV29HczR6UHhyYmdDaXpXK3V0cXRIbnJiTnFI?=
 =?utf-8?B?VlpxUDBIcGFiTmwxTU9qandEak9GcnE1RG5XendJSk5CWmk2T0xBemxWKzZP?=
 =?utf-8?B?OE5QbnJHdTduS0U5dXIxTmQ0aGxWaHBUVVByR3FMOVVmb2JrNVppODJZZ3pt?=
 =?utf-8?B?MTQ4WWpuSERYNm9idG1OUklGMnBDWUJpZ2NjTmdnTDg0RWJGaUVBL1A0WmFM?=
 =?utf-8?B?MVIyVmNKN2lIT3UvaW9pb1BjY2ROeVhUU2oyTDI4K3EzMmtKN2tiUVFNclR4?=
 =?utf-8?B?YXZBWVVIMSs2UHE0am15ZUlEUlJ3dFZLTXovWnh1TXd1RHovUy93Y0ZOUWlK?=
 =?utf-8?B?L2ZOMFRxRzUvRUlpaE1NejJUZ25IRHl2b28vM3ptK2JqMHRyWGtoa1hpWTha?=
 =?utf-8?B?NkVnbTEvbTc4ZFRUNDZUUzJ6Snp1RStMcXFxWHI3WHJnZjhORGhMRnlGMGc4?=
 =?utf-8?B?dVVwK2x6ekxVNkl3OGpFNjRvQTJ1clBIa1ZDMXZrbjhCSEt6cS9jMU1MT2VS?=
 =?utf-8?B?d21kajZyTXVOWFh2OVNGQmVGMGVpeGlCRTFMVlhqaFQ2TE92QkNhaWZ5bDY0?=
 =?utf-8?B?YXV1MDlUSXpTRDBOSnMzNk9xRW9XT1pMQm85Z21vOGVPK1F6MXB6aCsyMU5w?=
 =?utf-8?B?cW04ZG1Va3Q4dVdvMWY4dWVrK1BNYXZTVDBScjZEWFBHQS9tdGg0cW5MYlp2?=
 =?utf-8?B?RDVnWEtBYndSSTQzZmpnd2lMVXIrOXVIZlIwS1pMRTROOHlsUGJXRURJT0FF?=
 =?utf-8?B?cG53ZlRnL0pZZHg4alhxUCt0OHRtRzZzMjdnNmFnTEV3aUZDWjV5ZkJzZGJS?=
 =?utf-8?B?bVp1b1pVNGlOL0tVaS9JVVQvYW51UWxaek9MbFhOMzJUMk9id2hXM05TaUVs?=
 =?utf-8?B?TDF1bDl3VkR5R01JeVVRdk5McHVJVWpBRnM1VHNoSGZSSW1jQ2ZvREZSY2ZY?=
 =?utf-8?B?RlRNYVUzVTREM0FZZTlla2N4Q01hekhkbHpnRExnZXlKTUhzK0JrQTEvcEZH?=
 =?utf-8?B?U0Q3TnpZcXNPbW9qVGlHYUlrbTJkb3B1RWJJRmdZN0dHZy9oL2RhclBpdGdF?=
 =?utf-8?B?dEhDNHNpTjR6UFNpa0EzV2d0NTZhK0tuYXBZNkhpMHlXQTdHNXoxZ0xTSHpn?=
 =?utf-8?B?TTdHRDFCTDJweExDZWk0a2lZcC9KTzJob2VXOUdZMUhrR20yZUdSYkVvQUtY?=
 =?utf-8?B?bjliWncwWW9GcVJDUVk2RGRjTGowNGc4bFpVczM3aEZIdHZPcXIxVU1SZXk0?=
 =?utf-8?B?U0sxODlOV1p3YWcwZlBjRFZLemkxRnJVeTh5eHEyYml6Y2NXMnZVUGxaWTFo?=
 =?utf-8?B?WGtXKy9KSG5waENiYlZuUWlCZjdYQUZXQWU1WFpNeEdyQmNSVkZTa2U5ZkRu?=
 =?utf-8?B?NkE1enhkaDZCL0E2UmtjR3UyVytKc2x4ZzJQVWxiVEs2L2xqYkZKMDByei9h?=
 =?utf-8?B?UTJHdzRtTUprcndKeWRSVThUa01HODA4aW90M2lFZkRSWlQ3WTdTL0VNUXpa?=
 =?utf-8?B?T3lhaldXMU9qOWkwbHF5bnBsUGJLSkFDejg5YlhSaGFlRXFKOStWalBXVXVF?=
 =?utf-8?B?L1d2N1ZPWGEyVGRZRlQvbDRnRTNTejZlRnUyL09na0p1eDlWaGFuVFoyYTdU?=
 =?utf-8?B?SFFSWXFCa1BmV25ORDRNVVlkVDFRQ1JtN2pWTndCYTFGRDV4NlNXTEcyaFFI?=
 =?utf-8?Q?O+zhb1DqHys0ovOfOzTiWtcmgLsW269uCKh1Q=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MGplaVdyRXY5ZU9udzR2N2x0dVN4MGxEVU1pQmhoWHR5OVJLYTZRbUJiTjFH?=
 =?utf-8?B?ZHRaNUlOcUJKM0t4eHE2WEFFd280WnZodFdYZ2F3Nlhoc21HOUhiOVVqaS9u?=
 =?utf-8?B?QjBhT3JjS3VVVU40R25BWTA5YlJSWkQzME96UTZyQkcyMCtSR2c5c0tBVUIy?=
 =?utf-8?B?ZFQ1WlQxcEJhcVJZNWRkd3lPdW40M2h3d3g1SThYUFc2djlaOS9uTHpNRmlr?=
 =?utf-8?B?bGxlaFY1UzJzaDdCVkhUZHFuYzArNnZGWW00S3dKdlN2Zm1xU1VvbjRDNlNm?=
 =?utf-8?B?WThqd0ljRVNZSWNCYmxzTWQ1dkFyK0FOanF0WFhGYy9Jem80U1FQelMrenJK?=
 =?utf-8?B?L3RVYVc0RFk3SFd2OU9oZ2FJajN0UXJZUWgwWExDNjNVRGwyS1B2OE9QaHhx?=
 =?utf-8?B?ZnVqcVRtTmVJcHVKSDljakd2a2pXRWFWak5seVJEN3NLaFJMZnE4M3Z5aUtp?=
 =?utf-8?B?dDBlMENSaDZWQ2xiZDFveVZ4L2xMcVBWcUtDaTAzZitudEJzekVWbGM1VlNv?=
 =?utf-8?B?cWJLQ28vSW93NnBGMkZqTmxUelY2Nmw1WWt0Uk5razRzdVI5dE1OdVhScHhN?=
 =?utf-8?B?VUtic1pWazRTZXlBejZqVks0UmdjOTU2S1J1RzNmNnVjRjVLaVc0Y3lGSmI0?=
 =?utf-8?B?aG1QSjdvWlo0TGs4WmpVSFBRQ0NtTGpBZ2I1V1ZVM1dGUnF4LzVhemNTNGUz?=
 =?utf-8?B?VHlGcExmL2NCK0hUNVBoWE05NGEyMXVPOEFwc1FQdkdmYlRGazRzUXJ5WUY5?=
 =?utf-8?B?NDFXNzVGQ0dWSEdPQ0tZTDhFL2UvRzJNakdDdDFGUGZlc1NzWVZHRVRIWGUw?=
 =?utf-8?B?TW9XU3NFMGFoRW9MYkVrblZqdS9STk5ZUDdIUUxhblVxU0FNaW8zS3I4eVQ1?=
 =?utf-8?B?a25wYWp4d3NaMVFMVXRwNlNRekhrZFlQQWtMZFNCa0Y5aERXV3h5NzdwVnIz?=
 =?utf-8?B?NzkwWlMvRmJCNEVEUll2Z0VCQm4ySkhLY2w0dFJiRStNU2MwbjV6MGhLRzJQ?=
 =?utf-8?B?dWM0WFZiSnhoNzY2aWN4c3JFdTI2UXNEOUgzUTVYeUlDSDh5RURPRURscG51?=
 =?utf-8?B?bHhSUUtvZUV1bU92ZXRQdGRhR0U5ZVI5R1NHTXZuMktlM2FmZ0hVRTk1N0lB?=
 =?utf-8?B?VkZrSEg4VkRJN2MyZEJLMUc3amt6R2lOK1I1MEJsdDhvc0dUSWVvYjNOVnpa?=
 =?utf-8?B?M040NUJTcjRhNkRUeXVjSlNzTnk1ZUd0aVZGbWpDcWkvVUhjdDFEanRsS2RB?=
 =?utf-8?B?elNUaXZ0KzUrWE1ET0lNcm9xd0RNc1RzTEJCa3psV1NxUlZtRGcyT2YyZDRW?=
 =?utf-8?B?ZmkxNlpUK3pxVWxnYnpYeWJJalZnM2pYQS9BR2hoeHNQckZKZzE5bVlUL0lF?=
 =?utf-8?B?bFViSHk3bmdVUC9CRERkYTIvOWdzZHlwelkwU0t5ci8yM3NTYk5vMUttVjB6?=
 =?utf-8?B?SElDSlZCTERQVkhOeStQTndEUkErd2pweVREYjF1VEgyWkhNNUZPWFpaZ0Y4?=
 =?utf-8?B?WnE3YUpmVVFaTHBpZG81S3UyTFhmampHWmd6WlVGbHMveUJaKzVXOVV6Mkxz?=
 =?utf-8?B?b1k5ZjFDbzNScHBaK0g4YnNQZXR2WWJwR3M3eEl2UHRhN2UxaWtzRXlPSHIz?=
 =?utf-8?B?NWY0QVRXbENJWnkvNlVyWnI1WWhHUkk4MFlNWktOTVRxTVNpclArVllNd1F4?=
 =?utf-8?B?YlV1K2o3dFAwek5vUU8vZ1VpVElSSXFwb3plbGNmeHh1aStPS0QrSFBwMCtC?=
 =?utf-8?B?aTdHSGEySHhrRkkwTDFSb3JUNjZHQ2dpWU1ETnVsWTVCSHF6V3g5YzMzWUVB?=
 =?utf-8?B?VkdOcGppRFhGeTU3ck5IQk1iRWpwWkswdkl0NHdhV2RHaGFaSUl2bnJkNXJK?=
 =?utf-8?B?dWJ4RGNoN25IQ2U1eVJLZXNMKy9RZjZUY2Y1SnFTY2NsQjhDWTRrSWQ1SjRu?=
 =?utf-8?B?ZzBMUjNvcjJQaXBJTGdUN1hFaklVQUU5UzVHaHBhdnRub0JkN0VZeUJmTVN0?=
 =?utf-8?B?Y1BvNjdhQmczMncra3lEVmRmOEhRUXNaemxqQjMzOCtSYVFaUnY0VjhSUWxt?=
 =?utf-8?B?cVd3dzRXWldkc3ZOVGdkb0c1K2g0Zk9MM1hST2didFQ4V2l5dFZlRGM0T3Jh?=
 =?utf-8?Q?tb3D5hFJUPDKSycUWQf2l+ZWU?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a687862-0e2b-4b39-f998-08dcfe6f5f02
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2024 14:29:07.0870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1dQpEC5Gytz3tseHX3XPK9ayAZgvOmMMC2DBCsHaDRxdDvCOnJ6OPQ4lmGkDOvvOXQXWUT/G0o34e7rAvIkSfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7377

On 11/4/24 19:05, Dionna Glaze wrote:
> Ensure that snp gctx page allocation is adequately deallocated on
> failure during snp_launch_start.
> 
> Fixes: 136d8bc931c8 ("KVM: SEV: Add KVM_SEV_SNP_LAUNCH_START command")
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

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/kvm/svm/sev.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 714c517dd4b72..f6e96ec0a5caa 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2212,10 +2212,6 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	if (sev->snp_context)
>  		return -EINVAL;
>  
> -	sev->snp_context = snp_context_create(kvm, argp);
> -	if (!sev->snp_context)
> -		return -ENOTTY;
> -
>  	if (params.flags)
>  		return -EINVAL;
>  
> @@ -2230,6 +2226,10 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	if (params.policy & SNP_POLICY_MASK_SINGLE_SOCKET)
>  		return -EINVAL;
>  
> +	sev->snp_context = snp_context_create(kvm, argp);
> +	if (!sev->snp_context)
> +		return -ENOTTY;
> +
>  	start.gctx_paddr = __psp_pa(sev->snp_context);
>  	start.policy = params.policy;
>  	memcpy(start.gosvw, params.gosvw, sizeof(params.gosvw));

