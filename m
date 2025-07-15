Return-Path: <kvm+bounces-52510-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 976ECB0619A
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 16:45:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 700E1189F627
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 14:39:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B78B1DDC0F;
	Tue, 15 Jul 2025 14:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="A8ObU0Ez"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2050.outbound.protection.outlook.com [40.107.96.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24C41B4248;
	Tue, 15 Jul 2025 14:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752590323; cv=fail; b=CvbX7NnboYgWGsHcS6oDGmYXyyMTK580flB09CRrpsFXV015lnzRNwkwuF7FhghPgzykuH1RZUteTyM9WWfsWSAxZTSBkvWGUVyAHDaPVValucmHhhSuKISIss86ozVPQo/0qyDhrdMIwS1i9as8YPLBRZfW/bgZPXgNkWw/aB8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752590323; c=relaxed/simple;
	bh=2NQFWb/xC6QOg/wmT1QD5psCERTfiGA5oY0cKJqFy9g=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=N+XFh+NoQ8UxGObCve9rWtE4ixHSgYY3U2vfeXuRKZUGuQe86K5SuyDhAjlsVuQn1d7oM3qob4ol8Bag/CYHzQF3zb2v+NhcHO7VG82GGCpfUIQfvyO3nvGIDrJrIfOmGYrjqh6Mzd+ITdeFF627OCiTxYcQKY07NWpToyGs064=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=A8ObU0Ez; arc=fail smtp.client-ip=40.107.96.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lrNBKXCPutYf2ug/IXDhV9cii0j/83P3+FSZqd7gu05hwFLZE1YLPxpV6YJkCI7lODE/IIsijWQZxhyEzyVtLrtUcZbTQBz1Zl2i6hhe65ca0xVM3QKdSEGspVEkwnUHZT8W/XB4YGlQgQvHMmf2/OvwDpUHxD2mTyXX01upgHx7jIOioaI7ehyYcHd5rbNK5J8lLiAJATlgQDI3gjppcVh+0ihNFwcJLXJA2kB9YyWX47DxG6V/l8ZuACny/AXtz7wESjqf/Aqaz/xL1HY6oDDyj8C8Evft0COu6A3OwJOnzor+V7YVKksJEqW/klmOMpqgG93yTx+QjDFqDKnqaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c0L0jy9BSFG3hEVl51iS9e7RZ8nxNqbAAHpc7avXBPU=;
 b=S6ee1ZdKJ23m6lYxBJXQOXVvYjTXfclDqFxxDJpBA6gZxEZOtj8kvdCXXBrVgjDesvuoakQ6TsE79XUbIQAksRA8C5ZbTEcslUNyZkSsxRGH8ag/anMPxaSsEZarfxQ5+rTXLoSLjMBSaO/n1HFpQisovCJ1xt+40Md8KNvjiqDT82xNWAwjTmqD56UdorrCl4O3Vf4LTFMpyc7knr7eh/58m2qDXEJs0+dnATk+xOCw17gLCqUA5olghX/4gIy+Ax6EodjN+gPraetiYW8sSrPAclv/BFTzXD7h5Cq0SSenx7TX2E7lGw61TrK0wXV0rtDnE9mCciS33R4zT4J+tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c0L0jy9BSFG3hEVl51iS9e7RZ8nxNqbAAHpc7avXBPU=;
 b=A8ObU0EzD0jKjoSV5WOOju7A0aHPHBMTP85uSM5mYHmnNuM08qMHBTFn2JBpfOI2+LSDMpLJ7svmA2/M7zNv3OdVoKEc1vXUe+SyRIhF0dzNvqYxHGlLxA45QzkIR1MCKRb9qwo90YUHic8807ryHbuPZ8vR4hP7thfYTvkluKw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5712.namprd12.prod.outlook.com (2603:10b6:510:1e3::13)
 by LV9PR12MB9781.namprd12.prod.outlook.com (2603:10b6:408:2f6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.35; Tue, 15 Jul
 2025 14:38:39 +0000
Received: from PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291]) by PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291%4]) with mapi id 15.20.8901.033; Tue, 15 Jul 2025
 14:38:39 +0000
Message-ID: <ab9bcf19-3804-4678-99c2-d2ac8b04a343@amd.com>
Date: Tue, 15 Jul 2025 20:08:33 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: SVM: Emulate PERF_CNTR_GLOBAL_STATUS_SET for
 PerfMonV2
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250711172746.1579423-1-seanjc@google.com>
 <aHFL-QjqG4hDVV4I@google.com>
Content-Language: en-US
From: Sandipan Das <sandipan.das@amd.com>
In-Reply-To: <aHFL-QjqG4hDVV4I@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXP287CA0015.INDP287.PROD.OUTLOOK.COM
 (2603:1096:b00:2c::32) To PH7PR12MB5712.namprd12.prod.outlook.com
 (2603:10b6:510:1e3::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5712:EE_|LV9PR12MB9781:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f4812d5-6bf4-4f39-d7e3-08ddc3ad4989
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RjRSNlNPSXN5RWIxaC9ta0hJUFh2VGtvYkY5YmJxNDI0cGViUUVMY28wY0Yw?=
 =?utf-8?B?WWt5aHM4bkh0dUJWYlZMelJiNjFCdVFSYWI1by9lTEVHYStETHlOaFBYTHA5?=
 =?utf-8?B?UWxhL3Z4VS9UTWtFZGxweEVOcEEwVUpKZWdTcGNDeDJlcldHR3YyMUE2V1Jz?=
 =?utf-8?B?Mm1ZRmY2aG5acFZZREZrQW9KVnlKYWlRbEhFZ2Fyb0ZDYjROTnFTTjE0QVg2?=
 =?utf-8?B?RGFicEN5cU85WlcxMFI4dU13ZUROSTVoY0Y4ajBaekJnUHdZbWtSUmJPZlZ4?=
 =?utf-8?B?Y1ZsMG5iWkYrQmVJY3Z2bmNzbENCbkR0aGNTQnF6ZXBRY21rZlYrMlp4Vjhh?=
 =?utf-8?B?YlZNM2FiZDBGYmFRb3h6TFlRR1dZYTdPZ3RKYkVya25KditPTmZpdExGdkx0?=
 =?utf-8?B?aXN2QmhoMzdrOWxzdXBQTVFZNEhnYTdGZmIxWHFxZE5ZRzI1cXhmMEFHR2hm?=
 =?utf-8?B?b1EvYjN2SDhwclNTN0FpbDlNM1FKRUd6b2hhZjA4RzhTU1BTaTB5MDJ5NlJV?=
 =?utf-8?B?dzhKOTNvS25BUWtzbUxHRVBldFA3WUpYUGJYZ2poZTVSM3Bhb1NpZmZNYlRX?=
 =?utf-8?B?UUczR0pxRm5DZ0V2di9meGVKTmdwVDUxS2pVNFpMRWRwMHo3VG15K0VtUy94?=
 =?utf-8?B?czgxTEUvcjJ0S3dkK2VlemRsYytzWHZCTmMrMlJFUnZRN085Nk02Yld6Y2cr?=
 =?utf-8?B?MWQ0SnhVR2lCSzhvTHBGeDlSU2dVT0k0bFZIcnNSY2VCNFAwUU85L1JyVjY2?=
 =?utf-8?B?NE8wc1ZzaCtQZzUrUEZtb082eXRhOHNtNUZBazlVeDFrUnpkOEcwT21ybVBZ?=
 =?utf-8?B?dm5wMERpYXpoVHZUdlFta1U1cmd1U2dLcFQ0bllrMjlaeXpUQnhYQ01LWTBa?=
 =?utf-8?B?c0d2NENZbVM0R1JIN29XMmJjZk5KK0xIVEJoN0hIV3paSkNvclFPa3pJb0pK?=
 =?utf-8?B?ZnZuNUlLMHdhTDBWTFkrWkl1R2dyeW5FWTBvMFhhK3VsTDFYVGFpQ0pqbW5x?=
 =?utf-8?B?V0xRVHkraGdGb2VHTktDTUhmZnBuSEliNmtsc3VqMmpNdWNyWXJyblFuR01h?=
 =?utf-8?B?U1d0MDJLN3ZjeEY5djN1b2tjVzRDMXQvdURZdFZUTnVldFNUNFc3TGtwUzE2?=
 =?utf-8?B?bUxSSFRPRXA3eEIvaEcrTWRqdktWY2hZNTRTRnpvQUlXQ1dJZUJEa2tpZDNW?=
 =?utf-8?B?a000Z2doK2FvWWVpL2xaMlAvM2crYkJFK0p4akVLRjFQakdZWE1kcUJTazFu?=
 =?utf-8?B?UExJY2p3a2Z0a2t4VVlIaXJLQ0NNSXZuOElPenJCVDNlbStIWGt6WFg5MENm?=
 =?utf-8?B?U0JZKzMzZlVld1gzdkVETG5xWjJKUlVNNXNuZVlNaGJ0UzdpZmFWaU0xcndn?=
 =?utf-8?B?VnB1ZjJtcXhmT3BnMGhQcWFxMnJyVEFhR3ducWt0MG9XS0JsV2VlZFFuVVVQ?=
 =?utf-8?B?TDVZS1l0Rk96MjBtQnordTE2R0QrVno3cjFJWkJqbXlKQkVKWXJEQTNQU3l4?=
 =?utf-8?B?VVdsNnNzejdINkpDNUFKdVdMWVBQWEFKako3ZzN0Zk5pQUk5RUtmOWhKcXdP?=
 =?utf-8?B?NlUzcGI1bGp2Z1ZIQWVESFVzLzJDQXN6YXVjYUhyTmcvc1ZnRE1rN3BaWkNo?=
 =?utf-8?B?MDVKc010cGthSDNkWlZTZDJEQy9FSm5YNFltUlZiWXo3QWs5VDJFdDRMVmZm?=
 =?utf-8?B?WnJpV2ZRUlNDZ29Vd01JR01EOTg5QzlBN0p0S1VybGd2OHk0TVJqQlBRUTNR?=
 =?utf-8?B?V25NRnd0MldpVklpakhPbytqbDdCbnJYNVRxQU02ZnhvNG9NdkRPY0trMjFn?=
 =?utf-8?B?L1AxNm1FVkQ4ZWY4bnRNUk9iTEplR0JJc205S01iRFNrWU1YK2IzVlg3YlA3?=
 =?utf-8?B?Tzl0aEp1b0RWc0xnR3h2a2VpRGpKdS9HTzdBWmhNaHpHVmxiOVUvUUhRbTZm?=
 =?utf-8?Q?L2XcJ6Veggg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5712.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eEdzcVdIT25GRlVrT3pkUFdXL3A5UW1FbjFndTU5eDhKMDBqbGxpNEV4Si9n?=
 =?utf-8?B?akV3dW1aZU9FczRmalZ5TDFZSzkrenZacVBiUnFQOEJnOFdIY1NhYXZodXB0?=
 =?utf-8?B?Sk1aYmhNNU5xU3Jpb1ZLMzR5RnhaVmRzK2JFNlVXSGZsZy9yR1ZEdzFlOU5Y?=
 =?utf-8?B?c0p5RWljTEhkbWRNMk1adTNTT21MVmN6eWdmQ1hZU1VjNjltUnB3T1EvcHpH?=
 =?utf-8?B?NDRCSlJEUHNBZm5QUWcrb2h0Ujh5bTFvdjdHYjhWMytHeEJjaStCTkNMbHdJ?=
 =?utf-8?B?eE1nY3F0UUxpTk51dW1YZkJiYVhrYnJCNjBsZVN4NHVTeW96SjFSVE9XZC9i?=
 =?utf-8?B?TmFMQmg5c3BRNXphTXZFWWlaWjhPcXp0RVpiS1BVcjh6bm14aEtzK1dGSmpR?=
 =?utf-8?B?U1dESzJSV2ttODdBNXBTWXhMc01iY3grNkROV1MzM0xjWDF4NmV3aHBjZXJN?=
 =?utf-8?B?NTIvMXJPRE9MbUtEcGlSVHRpbnpCelA2YWVZS1V6OUtUaTRrVW5YRzNqYnpF?=
 =?utf-8?B?MDZpYnZ3RlRKVmluZW11UWdxY2Z2bTBJd1dvc09WUUt5OXRNSVBFZ24xQjZJ?=
 =?utf-8?B?d0pVUEk1eGVacXd2c0tQN1pRVzMvTE1FemlWL1cxUVZLdnNZOVlHRVFuUnFU?=
 =?utf-8?B?ZWVlTDFwQlZVc3BYbWZsM0d4bFV6RERLYm4zRWRmOExLMkJ1R3R3encxZVRD?=
 =?utf-8?B?eWxjZGczbW1HYjVvK2RzRE9qalhrTjhUb3lFWmU3STZrK041K3lqTXd3NDZR?=
 =?utf-8?B?bGoxSllTbVl1YUlMMmpNcEsrT3NOTENkd3Vsc0ZOUXpmb3dSWWV1ZUlGbm1J?=
 =?utf-8?B?bWtjalFrUmUwM244OUhURWV4cDdGT3d1bGJTWEtSajIrMUlqSnArYjJlZ2Zw?=
 =?utf-8?B?Si9wdEh3UUpNcHFZMHRLZHRjUGZtcm9Sc05CWlV0MVBiTFc1aTVRNG1jOWNF?=
 =?utf-8?B?dFR5K3EzVCsybktRNWF1RTM3QWlGcHNiMXlzbG9leUVQOEkwaTFQTm4waUNi?=
 =?utf-8?B?TVNmUEtyMUxwRUN2cEZrUlFyWTZMcjdXZU9PT2xtbEd4YnRuQzBJczIrSnZO?=
 =?utf-8?B?aXRvWEVrUFZsdy9SV0hIR1BYNVR6ZGxSV0VGM0tlMEZObVdYQURjN1hoU01q?=
 =?utf-8?B?K2E3NkdFQTJkdzRWSlVpREt4dENjZ1dlVXo0bDhXYnIxdXJpM1VDbVlLSCsy?=
 =?utf-8?B?YlBJcURLSGhaSlo4bkNybVViVjcwaUpQSE5OL21SQkR0UEtmdzRQWnlJR2tL?=
 =?utf-8?B?T2RSZ3JLS3BOV1RZcStLNWM1Vjd5QnhDQ0kyNEErZCtWNFNaelBXRFRmZ2xG?=
 =?utf-8?B?REt6VUdJcXBoV2J0aVlneTlWM3JGVDhtTXBjVU5OZk9hbUU1UEpkTXR0ZEgw?=
 =?utf-8?B?K0lnS1l1UCsxVWdqNDJwYlV0bDR0R0RqNzhyb3gwb2FWd3FzYzZ4bFFUcitY?=
 =?utf-8?B?eVA4Vm56eGhkWU1kTk55M3hKYVJMOXpLZWt0cDZ0U0sya1ZyK3ROSXIzWmwz?=
 =?utf-8?B?dnRMTXI2QXluVXB4dXlGS3FlT0ZWaDFnN2F6TkVzTFdCMURCbVdQby9IbWQ0?=
 =?utf-8?B?eEpqT1czbjd5RWhKUkZqQ1phczBveUtoZU9kTlBUT3hpQnZJSlBDRzkxa09m?=
 =?utf-8?B?YzhHdUV5WDlZTjRmdCtHSS9kZ2pGUFVYa3BQeTcyQjIrRC9pOHNaNXI4SGJ5?=
 =?utf-8?B?K2ExTEpYbmd2QWdhS1JUVGh0STY2cGtvYjk0TEtLS2xiYWlxZUNyVWFoN21u?=
 =?utf-8?B?V0lPM2ZpUVQrZ1F0L2w0MnRQVkNGaHBDcUc5Q3B4b3JZcEEzVkRpelJNTG85?=
 =?utf-8?B?RlkrRFZ6aG9qaU5KbzJLNFdZWEtOZG5RS010R3d5TDIyTUlFNmV1WTJwNkJw?=
 =?utf-8?B?U0pIT1BtWGM3WkR2ZDQyNHlPRHk5ZVNsdVdwNUVmT1k3Q1BYaS8zcFBzYzRt?=
 =?utf-8?B?SWFYOUpxa0ZCK29TTUIwdHdEWUdOcG15QnpkTWc5VmpjOXduTWZlYUx2NHlZ?=
 =?utf-8?B?OWRLZmpZaVRMUVNjclQxaXlpczdVaWJOaCtBeGZNek5na2R2Z0crcGFJTDUw?=
 =?utf-8?B?RzR4MVN2enRYbXN0NExNYWQxVEFRN3BVVCtnTURmUGxvVEMyNnVMZ0w2cGRW?=
 =?utf-8?Q?Nr638Li/Droh/Znhandm7ZPll?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f4812d5-6bf4-4f39-d7e3-08ddc3ad4989
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5712.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2025 14:38:39.3151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Li1orrIxSr5LLHC5eayKgqBAPfEEfW7GQxIXZoMAmqTbvyDzp1/dMOVDr5ccFDcdTC9BFtfCdjqPcXw1ybrnCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV9PR12MB9781

On 7/11/2025 11:08 PM, Sean Christopherson wrote:
> On Fri, Jul 11, 2025, Sean Christopherson wrote:
>> Emulate PERF_CNTR_GLOBAL_STATUS_SET when PerfMonV2 is enumerated to the
>> guest, as the MSR is supposed to exist in all AMD v2 PMUs.
>>
>> Fixes: 4a2771895ca6 ("KVM: x86/svm/pmu: Add AMD PerfMonV2 support")
>> Cc: stable@vger.kernel.org
>> Cc: Sandipan Das <sandipan.das@amd.com>
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> ---
> 
> ...
> 
>> @@ -711,6 +712,10 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>  		if (!msr_info->host_initiated)
>>  			pmu->global_status &= ~data;
>>  		break;
>> +	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_SET:
>> +		if (!msr_info->host_initiated)
>> +			pmu->global_status |= data & ~pmu->global_status_rsvd;
>> +		break;
>>  	default:
>>  		kvm_pmu_mark_pmc_in_use(vcpu, msr_info->index);
>>  		return kvm_pmu_call(set_msr)(vcpu, msr_info);
> 
> Tested with a hacky KUT test to verify I got the semantics correct.  I think I did?
> 
>   static void test_pmu_msrs(void)
>   {
> 	const unsigned long long rsvd = GENMASK_ULL(63, 6);
> 
> 	wrmsr(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR, -1ull);
> 	report(!rdmsr(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS),
> 	       "Wanted '0', got 0x%" PRIx64, rdmsr(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS));
> 
> 	wrmsr(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_SET, -1ull);
> 	report(rdmsr(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS) == ~rsvd,
> 	       "Wanted '0x%llx', got 0x%" PRIx64,
> 	       ~rsvd, rdmsr(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS));
> 
> 	wrmsr(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR, -1ull);
> 	report(!rdmsr(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS),
> 	       "Wanted '0', got 0x%" PRIx64, rdmsr(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS));
> 
> 	wrmsr(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_SET, 0);
> 	report(!rdmsr(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS),
> 	       "Wanted '0', got 0x%" PRIx64, rdmsr(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS));
>   }
> 
> One oddity is that the test fails when run on the mediated PMU on Turin, i.e. when
> the guest can write MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_SET directly.
> 
>   FAIL: Wanted '0x3f', got 0xc000000000000ff
> 
> Bits 59:58 failing is expected, because lack of KVM support for DebugCtl[FPCI]
> and DebugCtl[FLBRI] doesn't remove them from hardware.  Disabling interception
> of MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_SET creates a virtualization hole on that
> front, but I don't know that it's worth closing.  Letting the guest manually
> freeze its counters doesn't seem terribly interesting.
> 
> Bits 7:6 being set is _much_ more interesting, at least to me.  They're allegedly
> reserved per the APM, and CPUID 0x80000022 says there are only 6 counters, so...

Some of these reserved bits correspond to internal functionality :)
While it is not ideal for software to be able to toggle them, my understanding is
that these bits can be ignored. Otherwise, KVM has to intercept writes to both
MSR_AMD64_PERF_CNTR_GLOBAL_CTRL and MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_SET.

