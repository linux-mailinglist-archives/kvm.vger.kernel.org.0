Return-Path: <kvm+bounces-68287-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F15CD2B399
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 05:13:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5AB0930194DC
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 04:12:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 038A8344053;
	Fri, 16 Jan 2026 04:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TNBLhrRM"
X-Original-To: kvm@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013053.outbound.protection.outlook.com [40.93.201.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EACB434320A
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 04:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768536747; cv=fail; b=dCY+/3hz7OVLQ5P7QzB34ijUh3getqdVVYEHyO1QiIzruggdjAeFtqPX0xDJ7BFAn0lgrAiKxUfHUfsNHgZQuS1yi8c9ZpvTNKagi7ZvHGmBU69yf/kZzYsAuUMl8s9pEbCuuQKF0p97n+dgnDforM8JsDv1nMw0SOPMmav4evw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768536747; c=relaxed/simple;
	bh=4tEIeSrD421vjcHxucB88XR9NRiAcnseBZFW7yJsimA=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=CK3PKHfLjh8ZcU4RK8q0QQ5IvM30cFZPljk6VaFXpS2PlCYOpWM7Hi7L4S7IN92G60yIyFDKYeSvH7++JFqGM9i6ff0WLsHEm+QAPAI3HdZ6WQUC6bd5iHK1hGpQCXZIFIn6ftg7wXJCavPVPdvviQDXEFZ7cPsKgZ8B8GoDpr0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TNBLhrRM; arc=fail smtp.client-ip=40.93.201.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I4phGxYnz4VWMcS8ql0dH9PjMuM/VusXqDz1wpg1nK4mPed19lYkM/uiErsA2lIvqC9ISqfMfbtdJ2TFZ5IEUKHcHSpAYzRKegHaNY9mMcg2B8XRve2buWzFBZloplVLALFdK6+T+IRKm/gsjOT7DSzs95Tn6AqhR31Wh+WTMdhllCN9TNLllkyl7g7b4lFnYF+gUiDDjYWjvjMXJNgwll3dedFZSs0qD4GSW88m/VZuqUGLr5G3LoFPm59Rfnrss1VVFQellF7R/XJBRjiRNfI+Sp/WRXrUrEY/T97FTUwd/Q1rXDCsxO9LILtpAXEdAY1cRcezsr8GVsOyBgPtdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EdcAGhvUi1K9qxsfHALPmiO8ycb05Dlc5NCLRFWMIek=;
 b=IDjqlE8ud+ezmD0lbCjyF07BeoKda1YYyWQJ/DqVkOHsY6FbIn4gYgs6LaCu3lXCEFiFh4b+Lh3FBy0tV3vHuWGs83gq95KEIkRZF3ksFj2c1iIh4B/hgVa9yk2igkCNPBzukmfvmlYfSlZIRPtuLMxcwM4dHVgbg9HafW0Yjg0kiS4UofGpUJREPf7lgJ3KY/AAsavxvMxj+uiBgTgkkeDztYzhUuLxIWcdzC3sBG13saB6Z5CteSczymH4O+ayl5Xl1+Kz/eNwBqViGK6oaMvf9Y4rq+nJXPcRu5Bysdc9DmCL6IBs/pudGweQYFjC7IN3QGzPk4rOKhfNr2kwzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EdcAGhvUi1K9qxsfHALPmiO8ycb05Dlc5NCLRFWMIek=;
 b=TNBLhrRMWyVP7BAL3aOeu44hkoO+ieqv+dXjLtoqFjbLD65lgJ/ycvZmyj45E0/0Cw/8MQe8daSSy5X8vZBO3bReU0PMFaax/mNdREyVFzQZtzNqswfM0EO4XxKLULbYL17vwfp86nuXk96zcbsFDTTJ2nt3wyAaPUD/wf1nkwc=
Received: from BN0PR04CA0054.namprd04.prod.outlook.com (2603:10b6:408:e8::29)
 by MN0PR12MB5716.namprd12.prod.outlook.com (2603:10b6:208:373::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Fri, 16 Jan
 2026 04:12:21 +0000
Received: from BN2PEPF000055DD.namprd21.prod.outlook.com
 (2603:10b6:408:e8:cafe::dc) by BN0PR04CA0054.outlook.office365.com
 (2603:10b6:408:e8::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.7 via Frontend Transport; Fri,
 16 Jan 2026 04:12:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BN2PEPF000055DD.mail.protection.outlook.com (10.167.245.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.0 via Frontend Transport; Fri, 16 Jan 2026 04:12:21 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 15 Jan
 2026 22:12:20 -0600
Received: from [10.136.32.219] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Thu, 15 Jan 2026 22:12:18 -0600
Message-ID: <7be33bec-fb3b-473a-b6a7-763cf6bd5d56@amd.com>
Date: Fri, 16 Jan 2026 09:42:16 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 7/8] KVM: SVM: Add Page modification logging support
To: "Huang, Kai" <kai.huang@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "santosh.shukla@amd.com"
	<santosh.shukla@amd.com>, "bp@alien8.de" <bp@alien8.de>
References: <20260105063622.894410-1-nikunj@amd.com>
 <20260105063622.894410-8-nikunj@amd.com>
 <58fbe8af3e34e01e7f5acdf3eefe13b5cab35631.camel@intel.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <58fbe8af3e34e01e7f5acdf3eefe13b5cab35631.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000055DD:EE_|MN0PR12MB5716:EE_
X-MS-Office365-Filtering-Correlation-Id: 478d6565-1e7d-4e18-fa4b-08de54b57243
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aVQzbXhDVnZvL2ttTmhESzRBVnZ4YWZWVkZCRHIwUnJ5U1lLVXM1ZlpVLzNO?=
 =?utf-8?B?Wk5ZVmJQTGRYckYrSFIwYnJIRWRVdDhLZWliVzNhbWsxbmd6UitQS1pkeHhp?=
 =?utf-8?B?ckFvWGZDY3dKN0h0N0pLdWJQZWVPUWRCdkVZMDV5WjJBbWlqWjZyODJyMEYr?=
 =?utf-8?B?VGJ0dVRJaUxJTTRncG4yVzVlaEgxNHVCWGdVckowamhBeldzRTR0SytlVmhh?=
 =?utf-8?B?cmpySmZHc01ZeXBkNmZISFFEaUpoWWpZby9UUnVmcjNtYWNLbTViOFVabW1a?=
 =?utf-8?B?N0FzeldHM2xWSjNLMUdqanpnU1lLU0RGNEV5bzk5U2g3c3NETE5RRkQwQk1P?=
 =?utf-8?B?ckY2ak1NaEdwVExpdEc2U2VLMHZ6b1VIay9oejVTRDNNdW91dStIc0phQmRZ?=
 =?utf-8?B?Y2dTdEdRMlNVeVFMOFE3N1N2SDJOUmZ2ak9JVVlIODluek1wWFQ5dTNjamRF?=
 =?utf-8?B?VUdLTFU4ZXliNHBxcjJTakhLc3VJcGxjRWM5S1djRFBhL2hIcVRDNUV3SmFl?=
 =?utf-8?B?VVQxcWgzS09aUTh0NkY3SmlYVkpCZHc1RG4wUlVucVBJeVF0QmxHU1ZlS1lw?=
 =?utf-8?B?SEJ4WHloVUZlT3ZmaXYyNlJCK1EzMmtRVFFFNHVTWS8rY2JYaWJpSnJENjRO?=
 =?utf-8?B?b3VXc3NQYTE3OHQxYW5KODd3ampkTXhhaWlCeDlnd0hodXZrSVhYcnd4SHZt?=
 =?utf-8?B?bVU1YXJxd05xSHZDdGJ1WW5xNTBZYnZoRU1ZRHBKODJldkJFMTB0MlFmYTVs?=
 =?utf-8?B?czdBSWtsdDFhUVJJY2dhUVZXQ3ZDcU9qOXNEVjJHWkpUMHlVeHc2Kyt5RjFz?=
 =?utf-8?B?OUhrT2w2N1ovRlpkdDhIck03Z2o0Q09qQnNLV3VNOGUxQmUvWjFhb1dtY1Rm?=
 =?utf-8?B?NVRpOVM1eFdyT2dRa0xqZ2xCVDl6QUs4dklTeVNOY1ZrdUZYQ3VSOG1ZcEJa?=
 =?utf-8?B?RVhWbGdKZ0t2aWVyTzc1WjNFdlRmaUhWNFhycC9pRDFhb0VDSjV5VW5TaXlk?=
 =?utf-8?B?dVZTZXJQRE9YTjFOZWFpMXNJSVBkb3Rhc2F4a1FOZHh0Z2R1M3d3TU1lN1dt?=
 =?utf-8?B?Y09majVTY3ZBNXdmOWEvWTlqOS9aSnVzYmxFVmlyNHBTT3FJc3RVZnlucDJn?=
 =?utf-8?B?Uzhwd1BGY05pQUV4L3BQeFZQdWx5UE84cjVCblB4UnF2K2FwMzR3cGlPZDky?=
 =?utf-8?B?bHVjRnZ3ZGVsY0xjOER4RzZZakZUU3FId1ZQR2JVaTZTUjFpRFl5SVdrRHF4?=
 =?utf-8?B?NkxVZGZWamowVnVjRzZiQTZ5NUFZMTYwK2RKWlhNQWhIWWtxZy9CUi94dWpt?=
 =?utf-8?B?SzYwd2RSRldNZXkyMTlJZnA2aXVrQlZzTFJ0ZjRmQVJ6cjdwRm1KTnRFcXhL?=
 =?utf-8?B?bCs3T242Z2FhTS85a3puZm5zUCs3cE1pU2RIMFQ1LzUzck9RblIyaW5DajR6?=
 =?utf-8?B?LzU3VXNCUmpteTh3ZHh4dE84eG84S08wVjB5dlgraE1Nc0U4NTRzZndQYk9O?=
 =?utf-8?B?ellLbXR0Z0xvV0ZjeC9FY3gyZGxoaWhUL0k4Umd0Tm8zcVZneXFaS1huQWpV?=
 =?utf-8?B?WVB0TWNrSWxtMHpldlplU3p0d2laVXZjeCtDN1VKNXN0YUlCYU16NUJIRXJC?=
 =?utf-8?B?NWRTeWdhelJzRDJpSGNQajRPQWFnOFhKTlpNY0kwZkNoODBlaTZrQm5yemFF?=
 =?utf-8?B?ZkpLMjMrTHlGUmI0czk4cG1Ec0pNUE9kbm9mMzJXcjB1ZHZvVXBScHFWK09s?=
 =?utf-8?B?ODdpYjRMajJkYllVRGFPV2tJK2Z2N3RXZ1ltaUp3WnJraXZHY0JOMDFnb0F6?=
 =?utf-8?B?T3NOQW91bUhXQWR6UmdLWXY1YVR6dFBTSm9lYXk0QmpkdnVRWFlSd24vN0VM?=
 =?utf-8?B?S2lMUlZhVjRHLzhGRHNBbS9WaDdtb21uaS96cGFxaFFRN3VObXdidEFkTCtP?=
 =?utf-8?B?QTlMUkZRbzYxbUtCaEc3V3NjNTNYMTUzd3FpeEFwUWRxRWp3VCtxYklxTXlF?=
 =?utf-8?B?NmczM1VBV1c4QktLQzBzYjBHUmZpd2xnZ1VZUzByVzh4OERjTWhDVXV1cmZz?=
 =?utf-8?B?SHVBVG1uTWhIYzByTVRxVCtMTmJDR2lZQU40eWluTWJCbVVWNWxEcVdFcGlt?=
 =?utf-8?B?RlNzK2xyOG1xeVVPY1pvd21kMVFKaU9lZk50ckxJYXVhaFhZbldkYTVmUU41?=
 =?utf-8?B?c2FkUHF0ZWFxUi82MXFLN1N1cEJ2YklyRjhDZDIxdGRieXMyOU0zUnhZb1M4?=
 =?utf-8?B?MXNNNHJDeEtMUGdaN0ZMTGo1RFVnPT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 04:12:21.5628
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 478d6565-1e7d-4e18-fa4b-08de54b57243
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055DD.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5716



On 1/15/2026 4:18 AM, Huang, Kai wrote:
> On Mon, 2026-01-05 at 06:36 +0000, Nikunj A Dadhania wrote:
>> Currently, dirty logging relies on write protecting guest memory and
>> marking dirty GFNs during subsequent write faults. This method works but
>> incurs overhead due to additional write faults for each dirty GFN.
>>
>> Implement support for the Page Modification Logging (PML) feature, a
>> hardware-assisted method for efficient dirty logging. PML automatically
>> logs dirty GPA[51:12] to a 4K buffer when the CPU sets NPT D-bits. Two new
>> VMCB fields are utilized: PML_ADDR and PML_INDEX. The PML_INDEX is
>> initialized to 511 (8 bytes per GPA entry), and the CPU decreases the
>> PML_INDEX after logging each GPA. When the PML buffer is full, a
>> VMEXIT(PML_FULL) with exit code 0x407 is generated.
>>
>>
> 
> Could you add sentence(s) to clarify PML works for SEV* guests on hardware
> level in the same way as for normal SVM guests?
> 
> This justifies the code change like always setting cpu_dirty_log_size for
> all AMD VMs when PML is enabled in svm_vm_init() (IIRC).  Otherwise you
> need to have code to make sure it's cleared for SEV* guests.

Ack.



