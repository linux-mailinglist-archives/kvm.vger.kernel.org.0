Return-Path: <kvm+bounces-56029-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C3DECB393C5
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 08:30:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 787B47AAA90
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 06:29:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73A34272E75;
	Thu, 28 Aug 2025 06:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="L+LK11AF"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2077.outbound.protection.outlook.com [40.107.236.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E450C3594A
	for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 06:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756362636; cv=fail; b=FW+d4PMm16AWSUbI1bUuGdln8zSOcYItJAOOczN2GgODP9QrLTt7Kk9s0RkQ/imkKFzyHSdYT1fvCQ3ym/Bwem8jeFKhaYoq70hxona+HhNvbwCSjG4SWipO2nQ8OGV2Z2W7EG5tPaSC5ggnl/t+mdd8HZvrGT3eYBCK63JnMXQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756362636; c=relaxed/simple;
	bh=BsmEG7cJdPWr0inPTthNdFNO6chJpgIWmlAfDJA7Ca4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=tuJq9pBdLqr9B5aO0nLU4knbZi7KRLBCfqeosYxE6YKWq8Dk1GtWWKxZoteVAqU7DvC1pIRBmHzcdIwqHNsREEOhp7A3Hp/Fhemzrk8EQukQyYh6x5nOwYsRhuZlY0bBp4W6PgtLYNwxXtKgb/1f/bm7dVYc17FKEuruXbSkLS0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=L+LK11AF; arc=fail smtp.client-ip=40.107.236.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yRYlcxXA/Mok9KMKtnennfUlmTTR26f0SUYLpausIAXeaO87wBbZmTmW/cIntFnf5QYduJ7Ysl84pJk7RBaBDAXTfdN/wPF4hxM1G0OhF/v5GJ6yb2lbp7tZHW1rlW9hVa6Qgd6NLFe6CucvHj0jh6Kmpmk4GUn2y7lkBF08TemXmT+eLBn18a9Xzk13D3h2FrSGRDC3VchGowAl776Pvh52wQt3NxwKEd2vFcPglPzxaUBAXJ7SZ7/oUynMsCnEYVSvaf14WgM1oAaOh20ot/ewRvarezO7myuMnLhGS8pqPo96IC8TVdqcsL04NhgUhguxs+gGJIwfeGYhXQ/uIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Egut0l6GA/Jf6BqCN3ZOtvCEybKl5L6/WNILGfNwUCQ=;
 b=cfrpbVK9U2WAuPj3WGAi7CA9zJ/2Bn6ZqHNjYxcvV4xgZ0TxiDCQg0zy7BNZeYIWIqYgG1dWYAj+m9As9QM05sGEinbhM9npJCbbYyIccHWzzZ4Hcd5xLM2EI+ns1B1HXkQ0jvBOGuv6SLH+v48C3jsg6vMdKkY2oZ8ZSP0bCKCfskohe38PbhddCrCRJhWEyYz/D7uv+Xtg9VM5ptd1buD1GJCtwipFmc9t1/Kmhv+Mnxgd2q4CSwdQYcM++JcsmEnopJA2XJCG6Ps4vwzr4HVgzHRFE6OSYTjoCNxykfuY2F8iTF05AR/JXaYs0veuylz/Kus7W3peDCEJm0WdYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Egut0l6GA/Jf6BqCN3ZOtvCEybKl5L6/WNILGfNwUCQ=;
 b=L+LK11AFAo4A0HpKdZmJQzsdcE6Dm1/Q/iVm4Zg94bSs4BsezjZBgbzcdRlAWH9DcAvJNOpxxDRz7byCnzOLhwJG+xUpMNUfsMaxtc60fZM7lXdfHXB2nNaQnihuhRwqtBUI+Y6uZ2h0AUBGVjMmVgxQPJzNl/iJwaW1jUMaY2o=
Received: from SJ0PR03CA0385.namprd03.prod.outlook.com (2603:10b6:a03:3a1::30)
 by MW5PR12MB5597.namprd12.prod.outlook.com (2603:10b6:303:192::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Thu, 28 Aug
 2025 06:30:30 +0000
Received: from SJ5PEPF000001D3.namprd05.prod.outlook.com
 (2603:10b6:a03:3a1:cafe::8d) by SJ0PR03CA0385.outlook.office365.com
 (2603:10b6:a03:3a1::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.21 via Frontend Transport; Thu,
 28 Aug 2025 06:30:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 SJ5PEPF000001D3.mail.protection.outlook.com (10.167.242.55) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9073.11 via Frontend Transport; Thu, 28 Aug 2025 06:30:30 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 28 Aug
 2025 01:30:29 -0500
Received: from [10.252.207.152] (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Thu, 28 Aug 2025 01:30:27 -0500
Message-ID: <0cdeefa9-0b31-4321-9b72-cb1823afb418@amd.com>
Date: Thu, 28 Aug 2025 12:00:26 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/4] KVM: x86: Carve out PML flush routine
To: "Huang, Kai" <kai.huang@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "santosh.shukla@amd.com"
	<santosh.shukla@amd.com>, "bp@alien8.de" <bp@alien8.de>
References: <20250825152009.3512-1-nikunj@amd.com>
 <20250825152009.3512-2-nikunj@amd.com>
 <84a1809495eb262c26987559a90bc80f285f1c0d.camel@intel.com>
 <0e709b57-0a7e-4aba-8974-e20934ac6415@amd.com>
 <37959b67573fe11d1ff4f3c730c49776d3d229d4.camel@intel.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <37959b67573fe11d1ff4f3c730c49776d3d229d4.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Received-SPF: None (SATLEXMB03.amd.com: nikunj@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D3:EE_|MW5PR12MB5597:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e5c0f38-17fc-4581-155a-08dde5fc62a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UzJKRzBmemlsemUrK3J5WDl1dzZyQ1ZWUUdkRFgxWEQ2WGN1alNlSGE2NEJF?=
 =?utf-8?B?cUJWS3NiYlpMRS9PVWZSSkRUM0JiV0hXTy9QRUllaE5TY1R3aFJwbDlNcXBH?=
 =?utf-8?B?YkcrSW9wcXNIdGcxNXkxcy8yd0hXVGtlcVE5QlRyZEpkQ3Zqa1E5RGhZOUNs?=
 =?utf-8?B?Mi85N2MvbDU0bC9LWUx1VEFaZHNlTUg4SHd5OGtoaGszSEJ2aG4vUWllOGJY?=
 =?utf-8?B?S05pNTBPTG5BVjVpRzkxQnVJV1lXQmQxUEZMbTQyVUhRUzk2QjBMMWk5alZt?=
 =?utf-8?B?OTg0VXM3bVBMOU5HTzY4NFJQUHNpTlFlSTBEc3lZUHNTZGQ5SURSNVNEL3Fh?=
 =?utf-8?B?YlZWWll6dmNtQXQ2UEFEZXJwMk12K1hxeEUxZS9XZEI4Y3lVK1Y2TERUU3VY?=
 =?utf-8?B?bU96TUpXdHFQbEpzTkVjMit5RlJ6V2JFejl2SUZocUFsMW14WjJod0tjeGx1?=
 =?utf-8?B?dENqSG14ZEpkdy9JeEk4RVJ4dTBqcG0weTRHT0ZDM2t4Z1BxY0IyMjFtVi95?=
 =?utf-8?B?TitBS3pNNFh3WlM3c2xmeXJQdGpKV0N2Q3FoN0ZMVjJjcDh0bzFxUmZFSFI2?=
 =?utf-8?B?dHRJV0ZxUFpub2R6VXNNZ1pKNlgrSTcyL0R5RnR3a3BjQ1gvb2hWTmlLMm15?=
 =?utf-8?B?T1I0WXUvNng5V01VOWJ5cTJWQTNRYkMrY3I5djl1R3NROWhvQzF4aWNZbUdh?=
 =?utf-8?B?bVpweFBxUFZmd1JBT0FmWkJ4Y0xISW4xcm5BVVFGbzRtanJuTFZ3YzFBM1pm?=
 =?utf-8?B?cWpDYlNnZjZBb0wycnRIRE5wRE0zeXl2Q3RXLzlhMGNHbm5YMTg4MmtPbTJK?=
 =?utf-8?B?eW1EZjhEZ0Mxcm9DNk5lRThtV1F4REZDUmt1cmR0TXhMMzhCcitGbHlvZ01x?=
 =?utf-8?B?aGxJaU1WZy82dVp0a2VaMVFjUEdlQnVOUkppNGlHUTZxa2tleC8yZlR3OWFK?=
 =?utf-8?B?SngrN1c2U3NlbkVtYlliRnEvQXg4NCsvL0V2ZGdNQzF3RitTd3pUOHk4bURF?=
 =?utf-8?B?YklySWJSeWZ5a29yMURFWGVZRldVTytFYnZvSmZVZVY3dzVneU9VdFhjWnJB?=
 =?utf-8?B?eTR4aXZWTUJFVTdqZFJmTm1weDBNNUhuTTBCTmg0S1RkeVVDL1JoMkNaUmti?=
 =?utf-8?B?ZXNZczJocHRmVGl0UzNtbHhaM0dtVDdxTHlNQmJoMGp5MHFuSXlpR1JkVEpn?=
 =?utf-8?B?NDRrN0ljVE5PcXp3ckowbi9OL0xiRHd0VFYzdDV5N3RCZVVuYnFvSksxNllN?=
 =?utf-8?B?R3pDN2pkejJYVHF1aTAvOWFKRGw0RXZwMWtyU0EwblAzcDZUZEcvZVVuYlVP?=
 =?utf-8?B?VEs5cVZDNU4vTU1CcjdIeHRjWXQ2UkJydlNYL1gwS2hKNHBMelBtNEtmenJR?=
 =?utf-8?B?NmdWV0pHTnI3NjZ1R1JQL3poQ2Iza29Fc3NzLzhSZ3FLdWhud2VZaFE3SjlP?=
 =?utf-8?B?K2hMbFVYTm94OEtJbHdIZmkzcWVLWHlWRk1kUm1BU2hwekVGc1dwYnFDaG8x?=
 =?utf-8?B?cFRWY09zL1p3RVU4Q1lBejdjQ0RVb1VMd2xORHE0NWVLMVNIam00ejFBdlRM?=
 =?utf-8?B?VTRLTE5uMkFRWStxUDZlb2RHZU9qb3BvWmRSYlp3QjFVaVVJc3RkV0xweDVz?=
 =?utf-8?B?RUM4eW1tNzk1THhNc1k2cE9ZWFNZaU1wSk5xbUY4dWFEOGVMSlpCcUsxdlVV?=
 =?utf-8?B?T3F4bHdBNFlQZnN3ZGthVzl3MmhQVzVRdmkybFVaTW5VOHVGVHFmMk9ZRnk1?=
 =?utf-8?B?MWlkc2VJcVBUOStLT001ZWgvVWplUDNEOXhQRlF2RlUzdWF6UjY0czZDdnpl?=
 =?utf-8?B?cDlYVGJhMHU3Z1pVNUxvdmF3SFMzRmlKQUN4b2hHREhoWmpJS3V2akpRTWFz?=
 =?utf-8?B?c3lteXlKZzYyVGt5TEk0OFFlVW5pN3EvUTZsS2tiQXpuL2VqWGs3cWFTTU1y?=
 =?utf-8?B?NDRMNGRqOWpmQkt5cnpXYVRscFdkeTRDMTlUVDdrVXFYNXU5UTlRZkJyVzBw?=
 =?utf-8?B?VTdHQk9NcUFZRkZUNlVSY0VQNmtoV2dXRUd0aEcvT3l5clJlaXVFcWVKckNr?=
 =?utf-8?Q?9zEb0y?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 06:30:30.4382
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e5c0f38-17fc-4581-155a-08dde5fc62a0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5597



On 8/27/2025 3:23 PM, Huang, Kai wrote:
> On Tue, 2025-08-26 at 20:28 +0530, Nikunj A. Dadhania wrote:
>>
>> On 8/26/2025 3:36 PM, Huang, Kai wrote:
>>> On Mon, 2025-08-25 at 15:20 +0000, Nikunj A Dadhania wrote:
>>>
>>> Looking at the code change, IIUC the PML code that is moved to x86 common
>>> assumes AMD's PML also follows VMX's behaviour:
>>>
>>>  1) The PML buffer is a 4K page;
>>>  2) The hardware records the dirty GPA in backwards to the PML buffer
>>>
>>> Could we point this out in the changelog?
>>
>> Ack, will add in the next revision
> 
> Thanks.  Maybe one more to point out:
> 
>   3) AMD PML also clears bit 11:0 when recording the GPA.

Sure.


