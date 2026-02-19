Return-Path: <kvm+bounces-71335-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SNp/HOillmmTiQIAu9opvQ
	(envelope-from <kvm+bounces-71335-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 06:55:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CB79815C3C2
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 06:55:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9ED4F3032F71
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 05:52:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42C8A2D1F7B;
	Thu, 19 Feb 2026 05:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tQcnuPD8"
X-Original-To: kvm@vger.kernel.org
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013018.outbound.protection.outlook.com [40.107.201.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572D62D0600
	for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 05:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771480342; cv=fail; b=fF8wwZ/6S7aFPyBYapsQ5sLuhN/bV1zz664WB34ATyA+PsoWcq9HfOgziSMUV0b3WJGOh/R6McJhyq0SbuiEFJJUSmx8YYJtOkOXmzhIQIKciVZhdq3eB27rzL4QXF4FiKysS2NjQL1X2bkDukeSy+52MVoyV71daB/HA+uV4WU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771480342; c=relaxed/simple;
	bh=cN0ZhOBFwcA8Wu0c8Jvx7WrNJeuIpic9KhT4d/wJQ7U=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=LDZUIsZw/LeNFH8ys8bZnTAUYCRPoBjJP3nYWefIR5VNvfCmj2ZwJMIWWgnelwuggwRBktSylZOECLKxjaRu9WlmvvGueZte4PiCJ/7QEw2cgLPSYZAjDvdrXHnkewMWYvNeBUb0R02m6Cq51WXruEzi+nqgymYFOo0sy/EkWpU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tQcnuPD8; arc=fail smtp.client-ip=40.107.201.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MRATiIePXUb4OoJymO9+uQHOcWCUlSAk1AjUukvnklXuPhALvd2Tk699fxSU/kHs2MVIKN7JBXlvlkzsS7rUQPqa5O9nLH52p880by3I5irvy7IZKvCVIYPeNnDc/XC67E+pkVk/qENHl6l/nO0P52ucJTPha6YcmNTWuJlh1ttVnPNaat4FblPWq1A0qkR1eUJ3UE4Z6Lcn4Dqslx6a1NdL6A9a1m0Jhb4iAhlDMYeYfSaptoKMKsrpAs12Cc7yXfU64gdsy9fKArE7/27TrQA3ThSN19F1jIUrA3j4Fyc1cs9+MF2iCEyeIlXZuqrfj4zw7E2oRYinVSDWSKOt8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PaqBUQZTELNUDGR/wjWI62sCghUO+WS0939AmCwMZcU=;
 b=ErTqjhw9Ynqmwu4D37PgwjmXTYEqIgNKnvj/lCW1Hdin6cOH/G1imQF6kroF24eYKn3+269m9MG9HU0ObvUZJsUCBPH6JANS4RIybqeIHDU2wAegZSerbg+Qv8/ULo0H6+Z+vmLNlmgGs9HyYAqslurSjxrxHBTfQFnf5kNLWKDrSOJrWVIKK3VjXOjDhbVqApQLT4tprfK/nLgtG9v8tRNJSSU7WSSs5lTpIw0aSvTCENrt/9SPHLUd4aTeOV476h9BLM3gV2UjaAv8ieXiDngH+/EhGvqtnQ+Vl4hiAtDIbjHCvaLfSr3VZhCZcvs3cldcjHv5nx8jOXSovXFazA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PaqBUQZTELNUDGR/wjWI62sCghUO+WS0939AmCwMZcU=;
 b=tQcnuPD8OIn72Bs1bAInjetkUfs1nH8j2U6aIAkiYuLy58E2GrIhHq5mylUDLBYRVz0q3xUBTs8xKL4wRE4ix7LdO/fQy68IU5jzmkQnK1iVMI60LknH1wvA/e7K6eSlldFKniUXd1p47x/4SGN0t0OsHhkM3Li9U4+eAQVK4OE=
Received: from SJ0PR03CA0123.namprd03.prod.outlook.com (2603:10b6:a03:33c::8)
 by IA0PR12MB8745.namprd12.prod.outlook.com (2603:10b6:208:48d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.15; Thu, 19 Feb
 2026 05:52:17 +0000
Received: from SJ5PEPF000001C9.namprd05.prod.outlook.com
 (2603:10b6:a03:33c:cafe::19) by SJ0PR03CA0123.outlook.office365.com
 (2603:10b6:a03:33c::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.14 via Frontend Transport; Thu,
 19 Feb 2026 05:52:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF000001C9.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Thu, 19 Feb 2026 05:52:16 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 18 Feb
 2026 23:52:16 -0600
Received: from [10.143.194.143] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Wed, 18 Feb 2026 23:52:12 -0600
Message-ID: <70cc1005-301e-488b-9b52-0d6e4b3207f7@amd.com>
Date: Thu, 19 Feb 2026 11:22:11 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 8/8] DO NOT MERGE: Temporary EXTAPIC UAPI definitions
To: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
CC: Cornelia Huck <cohuck@redhat.com>, Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Marcelo Tosatti
	<mtosatti@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, "Richard
 Henderson" <richard.henderson@linaro.org>, Naveen N Rao <naveen@kernel.org>,
	Nikunj Dadhaniya <nikunj@amd.com>
References: <20260219054207.471303-1-manali.shukla@amd.com>
 <20260219054207.471303-9-manali.shukla@amd.com>
Content-Language: en-US
From: Manali Shukla <manali.shukla@amd.com>
In-Reply-To: <20260219054207.471303-9-manali.shukla@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001C9:EE_|IA0PR12MB8745:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e4b6372-d064-40e0-4f4f-08de6f7b09ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|36860700013|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NUVtNExkV1BJUExzUjhXcFpNcWdRQlg1YW9XRFZvK3hpS0NlWHhhbnhWdFUx?=
 =?utf-8?B?ZmhnQ3dnck9pNG9DZVZkaXE2Z0hOUFpRYXo2c1VTdmd5cjJERWp4YWNHRzdt?=
 =?utf-8?B?ejBQNHVSaG1nRkR0SGVHczdxcjVTL2pLZUREeXVCL3h5aHMyVGludEVzSEcw?=
 =?utf-8?B?OXJHSFlleHlhVFUzK2lJZ1J4Y0p2R0h1dEZtR1pPOGx6aXRxUEhUT1AwZDVF?=
 =?utf-8?B?SXFYdXdoY0JGb0g2U3JHQTEraFdud2QwNkNHalJVajhHOUE5SHEzMVN6VHRz?=
 =?utf-8?B?aGZkWEpVZTFKOVYvZGltVXdnck9Cai9QenVFYm82L3U3Q0wrenRCNk1NQVVW?=
 =?utf-8?B?WWR2MGVRRkZDVkJIYWN0WHI2NDZCWlA1RlBaSUJOeFU2QWZndXVNc3pLa0I5?=
 =?utf-8?B?OGhOb2tzMDR0SndJMXhnOU4wcThVc2o1NlFVNnlhZ2NDY0ZrTkRMR0FIL0Rx?=
 =?utf-8?B?bVNrUFdCQ0g1bWM4eEZaQ0F0NHBFMHlUVFRJMjVoWGRIQko1YStNTEltZ1pW?=
 =?utf-8?B?WHh1Mk1DWERyR1dUajdDaWhCYThnTXVqVnZIRjBGRjM3VXF5MFluM2hhczhS?=
 =?utf-8?B?dGlobUdieEk2OHRMTW94RVI1S1dGYXNpam5yV1lFUkxacW5jMm5KS1RnQjla?=
 =?utf-8?B?SFhhWjJMM1lUeVpuak5DMlZQaTdiRnN4M3ZlMkZUY2Y2ckRocXNYeHZMRWdh?=
 =?utf-8?B?RCtyUTE5NlZsZ1lFdThDVUprK2NEdlFhclUxa1EvL1AzUk1aLzNNTklqU2p1?=
 =?utf-8?B?RXdPeUJ5QnBjek9wQWp4NGljUGZxbXZuQVhndTIvS3hMSTRCTmpNNHQwTEpQ?=
 =?utf-8?B?eHZkbyt4eGJEbk12S0ZlR0xUUjNISWZINVhNcFFVS01FaUpkOCt6aEZIVzgw?=
 =?utf-8?B?OEpRemlMSTEwQjg2a3ZESndpUWNnMmR1NjluelFYNmxoK2xnVmRPMXdLZWhz?=
 =?utf-8?B?bDFkd0hhZFhCS1E2TXVFVnpUbCtHdy9RcVZQV01BMm0yRnpCcVJYQkZBRkcw?=
 =?utf-8?B?S00yK2tNTEhvbDFEeHRKZndneWQwYWZlVERaTGNMVExSL0V1b0Y4cFVycGFY?=
 =?utf-8?B?amo0SUFVVFhleUs4WlpXaEc2cE9WeFhaMStDT243bE1lck12WmlFNW03eFds?=
 =?utf-8?B?OFJwRGtwenFSdmpPQm9iQXRvcmRjU3dvUUxSa3BxaThtNzlYYTF0RXlnbVo1?=
 =?utf-8?B?YkhYMXpYaUFQOGg4V3g0MW5GZjkxdFMvMTBiLzhHbVlsclMxN0xkeTAyemNh?=
 =?utf-8?B?UVVHRmphTUI1cngrZ2g3YmV6U0twRkVGSk0wYW9lZVlJNTdtZlA2OXJESTFy?=
 =?utf-8?B?bVB3WlE1UHl1VmtQc0hFWVUxa3V5WEhXSFRFYncreDhSalY1MmMvUExUOGpH?=
 =?utf-8?B?c2ZDcVVMakcwTjV6NkNOYVFLMGVsQ2VLdDU4VHRDaFBPemc1QXZjVUI3S3lh?=
 =?utf-8?B?bW9UdlFqZVNGOW1DOElremxpcVAvdDRPNll2M2YrbEtMNXdCRWh4ZCtWR0ls?=
 =?utf-8?B?MEE0MzE4MUhTdGhGNm1zLzZqaFlNU084RW8vZXRrbkFLWElVQW9YUUxCMnBN?=
 =?utf-8?B?MUE2bkxxc0paMkRBc0hITFJxQ2orbnJlQlY2OGtqdUtUeFZaNFIxUE9xRzhG?=
 =?utf-8?B?enUyWGpqMWJpQjk2dHJjT0tVTmhRSnB6TFdsMjVyYWMvNlRwdnREY2VNYi9t?=
 =?utf-8?B?QzZFWThtK0hpNFBYQUp6QXFma2Q5OWRJbk4rTE9jSmE0Nm9Wcnd6dG0zTGxD?=
 =?utf-8?B?Q09GN1NKUFkrdnIwTGdVbGpNOFN6c3pDM2RCOHFVeTA2K3h6aWVtV2g3d3FK?=
 =?utf-8?B?SzQrakJ2d1hDNEl1QVQxQVZNL3BRM1RkMFNjLzRWOUhqNFlBR2U5ZU5tN1Zr?=
 =?utf-8?B?Y09LdzgvR08veWJQYndaSDdDZElmNDhpYWxkR1FiVEo3TzJvYXlmOEJUb1ox?=
 =?utf-8?B?Q3hXbXpjVHhmaTFKRTFvNlhQV29lTnFWa254TFFLWjYzaEpvVGhlVXZaZFJS?=
 =?utf-8?B?Z0tDa0grMlpZVTBlbFdlMUhOQ2ptM1lKTjJWR1NDS0kyOWJBdDBVUjI3UXBn?=
 =?utf-8?B?TWU1RUVRSHk2emtCbDBZbTBvMnJ6M2Q1SzVCL1JrcVhJNUtLS0NDczhPOWtt?=
 =?utf-8?B?L04wTHNtZ2tkaHlZSU9wUjZsdm9YYklvNllmYlBJSzBBZXZTNThDYVpTeSt2?=
 =?utf-8?B?Y3lERnBQbmRiVWtnL0RoM0RGTXN4Yi9zN0xBdkNJUStTMWYvUXhlcWxJaVFO?=
 =?utf-8?Q?X4o/ZMzREw9ZpkqJMz7S8wm8U4v4EwC66v5hjBAHMg=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(36860700013)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	euIbPCf1DW2eVXMkALvumwxLxE0jhDATwef8natBV7a1YBtuGvI+AVd3Twl4m+wZmCEddSWJVdnToBgrHN3R4FAaahJXtCN2lr1ZtRi6KNjGYg7P5ZtHArk5fvqhaL0WcWrWIPC5oUoF++CVMTGjdTgDpcUfxQECpECbwe3yLwlYsU4X1vzTq5bO2nCkpwr3+mGtpxpRSN+kBuAXcwgJaoudHEWKQQZa8hxui922o5ZJARmL8rnQTyJ5Il8luxbxOdz7jULm38np/njSvUzb4cJkGVjD/p5A1r4l/pnq5RjLgeJyBueNp/yQcMSR8PY+ABdkD+gin7pcJsegVlLCcCcq3B5FKYWji1HRQIR9J+mgUAp/qVlbp2R0ae13pODjgdHyqyouCwsKT82nbH2kRkNDYjPjQ9qsfbtKWzSC9o+i549sdByQ5RsRMecTRNIH
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2026 05:52:16.6478
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e4b6372-d064-40e0-4f4f-08de6f7b09ad
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001C9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8745
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71335-lists,kvm=lfdr.de];
	FREEMAIL_CC(0.00)[redhat.com,habkost.net,gmail.com,google.com,linaro.org,kernel.org,amd.com];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:mid,amd.com:dkim,amd.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[manali.shukla@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[amd.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: CB79815C3C2
X-Rspamd-Action: no action

On 2/19/2026 11:12 AM, Manali Shukla wrote:
> This patch adds the minimal UAPI definitions required for extended
> LAPIC support. These definitions will be imported via the standard
> scripts/update-linux-headers.sh process once the kernel patches are
> merged.
> 
> This patch is provided only for testing and review purposes and
> should NOT be merged.
> 
> Kernel patches: https://lore.kernel.org/kvm/...

Sorry. I missed to add the correct link.
Kernel patches for this changes are available at:

https://lore.kernel.org/kvm/20260219054207.471303-9-manali.shukla@amd.com/T/#u

-Manali

> 
> Signed-off-by: Manali Shukla <manali.shukla@amd.com>
> 
> ---
> NOT-FOR-MERGE
> ---
> ---
>  linux-headers/asm-x86/kvm.h | 7 +++++++
>  linux-headers/linux/kvm.h   | 7 +++++++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/linux-headers/asm-x86/kvm.h b/linux-headers/asm-x86/kvm.h
> index f0c1a730d9..04d1a1a527 100644
> --- a/linux-headers/asm-x86/kvm.h
> +++ b/linux-headers/asm-x86/kvm.h
> @@ -124,6 +124,13 @@ struct kvm_lapic_state {
>  	char regs[KVM_APIC_REG_SIZE];
>  };
>  
> +
> +/* for KVM_GET_LAPIC2 and KVM_SET_LAPIC2 */
> +#define KVM_APIC_EXT_REG_SIZE 0x1000
> +struct kvm_lapic_state2 {
> +	char regs[KVM_APIC_EXT_REG_SIZE];
> +};
> +
>  struct kvm_segment {
>  	__u64 base;
>  	__u32 limit;
> diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
> index 32c5885a3c..4e67281e99 100644
> --- a/linux-headers/linux/kvm.h
> +++ b/linux-headers/linux/kvm.h
> @@ -637,6 +637,10 @@ struct kvm_ioeventfd {
>  #define KVM_X86_DISABLE_EXITS_PAUSE          (1 << 2)
>  #define KVM_X86_DISABLE_EXITS_CSTATE         (1 << 3)
>  
> +#define KVM_X86_NR_EXTLVT_DEFAULT		4
> +#define KVM_LAPIC2_DEFAULT			(1 << 0)
> +#define KVM_LAPIC2_AMD_DEFAULT			(1 << 1)
> +
>  /* for KVM_ENABLE_CAP */
>  struct kvm_enable_cap {
>  	/* in */
> @@ -952,6 +956,7 @@ struct kvm_enable_cap {
>  #define KVM_CAP_ARM_EL2 240
>  #define KVM_CAP_ARM_EL2_E2H0 241
>  #define KVM_CAP_RISCV_MP_STATE_RESET 242
> +#define KVM_CAP_LAPIC2 247
>  
>  struct kvm_irq_routing_irqchip {
>  	__u32 irqchip;
> @@ -1308,6 +1313,8 @@ struct kvm_vfio_spapr_tce {
>  #define KVM_SET_FPU               _IOW(KVMIO,  0x8d, struct kvm_fpu)
>  #define KVM_GET_LAPIC             _IOR(KVMIO,  0x8e, struct kvm_lapic_state)
>  #define KVM_SET_LAPIC             _IOW(KVMIO,  0x8f, struct kvm_lapic_state)
> +#define KVM_GET_LAPIC2            _IOR(KVMIO,  0x8e, struct kvm_lapic_state2)
> +#define KVM_SET_LAPIC2            _IOW(KVMIO,  0x8f, struct kvm_lapic_state2)
>  #define KVM_SET_CPUID2            _IOW(KVMIO,  0x90, struct kvm_cpuid2)
>  #define KVM_GET_CPUID2            _IOWR(KVMIO, 0x91, struct kvm_cpuid2)
>  /* Available with KVM_CAP_VAPIC */


