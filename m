Return-Path: <kvm+bounces-60063-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 7301BBDC80E
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 06:40:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6567E4FDE19
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 04:39:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F4162FDC5A;
	Wed, 15 Oct 2025 04:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="sq/i/xlI"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012045.outbound.protection.outlook.com [40.93.195.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E7A72F99A6
	for <kvm@vger.kernel.org>; Wed, 15 Oct 2025 04:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760503154; cv=fail; b=GSfFx1mGiON8h/srzfRAS4CJqY4+nwWkmR4n3oVRM0hN6gtCVpr1eY9sAhiRUqEli0xtyUrOUSUbYVsbecheXzdi7wkAviYwWOYC12YUqxuP+sqLhte1N/LQYbCdzsz8TzhBonYx7ERgEysBmj17cAlgWtVhNLcD/KY2AS2Fodg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760503154; c=relaxed/simple;
	bh=6sAl8PqCbdPA5iao0SDKBJDq4c8/CNg2U/IGRyYhMB8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=pxie0LsHtdlXtPchX0v4tP+4CR/N2/4Ccs2h/bfzYgCg5iPjECz2CqTHdDzELlrTDwsYwmpIR3qEXH09DNB7alIMKf6Itun5+1tBUyNS4ptlqQc2QzTpW/iUV2H4lxIuVA2suW+ptFFaa2AqW1LaXuvhw6aLjDYDF1zyzHv2fq8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=sq/i/xlI; arc=fail smtp.client-ip=40.93.195.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rvKFppfoJLmohTH9BANAjy7ZDUOdN/kTnTBLLsUL2Pg2UyTlAX8slk1QnePdyfOabGM4EcjV3FUF30B2p0mzdsKHN1O7VfTxGOi9tgKIkrNU4p63WlJ8Vg84wT57Op9wtv6d2oLxuYcXrGdB4kdd7O2GnxY+e3ovoZsCmeRwsdQl3jIMgjrYPJi5rs1l4j57BNHpZWq/uC3QwydN6xyMEpSvCnybQbEsR8BLrZGWqCoUtmdgeemrho3O3wRzKdM3ukWRure6T29C8RVIJW4Q07FdSEjFCbcCtL+fhmDIW1YN4pwtQWwO431Vpxgl7meNMUgeNsmietSg9MPNgqQs8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jUCHPcG/L9VDSlAEYPzV6HrTdoOdxQv6MZJ2A74bXE0=;
 b=nxADRYhAhtC6J0i75mFkLHHd/fFnmyYAKtXTeBNu0wBZ5FosCi+XD4MDpaq6zE2WXszF4n8sYaScDL74XKl3ps4zKLkFa4Wr9ZyQNuwHF/qya6hHVE8UmVoqwrHm9FVez2p9TpiLEncZPi9ztNJWZnWGcZOdjCf05ybhNkmDW6Sl006orVCs08KsOX3s8IpiFZlHrZoP/STAx03B9YD3PHg9ZMMpRQt55WHU1d7YAS5GgXG5lkdqt2kpNEzyeOzaBeZ2Panm4tQYa31R6hAHRDDE2bMJ5k/9ISOjy7JQPZNee+aJ0U41WCWT6nm7WmQrBsZVW/Uz+KqQuR5xfstmEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jUCHPcG/L9VDSlAEYPzV6HrTdoOdxQv6MZJ2A74bXE0=;
 b=sq/i/xlIBeFdPZHtovYMHCnk4/2lkg6AWj+gLZhpKdtT/dkXSD4DfnOE87jtrNpTJzCkP2yqfw73evTqr8ZtEZp5a6eXvJ066DhnG8G8v0J4apZFAjymi8fTYO7rJiJPaRYK3CKC1GTV4d1jmfE+F2tF78U0c8Pl4m2eRh93nAw=
Received: from BL1PR13CA0421.namprd13.prod.outlook.com (2603:10b6:208:2c3::6)
 by CY5PR12MB6250.namprd12.prod.outlook.com (2603:10b6:930:22::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.13; Wed, 15 Oct
 2025 04:39:07 +0000
Received: from BN2PEPF000044A3.namprd02.prod.outlook.com
 (2603:10b6:208:2c3:cafe::38) by BL1PR13CA0421.outlook.office365.com
 (2603:10b6:208:2c3::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9228.9 via Frontend Transport; Wed,
 15 Oct 2025 04:39:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BN2PEPF000044A3.mail.protection.outlook.com (10.167.243.154) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9228.7 via Frontend Transport; Wed, 15 Oct 2025 04:39:07 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 14 Oct
 2025 21:39:06 -0700
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 14 Oct
 2025 21:39:06 -0700
Received: from [10.252.207.152] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Tue, 14 Oct 2025 21:39:03 -0700
Message-ID: <46a83335-bfc7-4203-ab20-c3eb33a81e32@amd.com>
Date: Wed, 15 Oct 2025 10:09:03 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/7] KVM: x86: Move enable_pml variable to common x86
 code
To: "Huang, Kai" <kai.huang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"joao.m.martins@oracle.com" <joao.m.martins@oracle.com>, "bp@alien8.de"
	<bp@alien8.de>, "santosh.shukla@amd.com" <santosh.shukla@amd.com>
References: <20251013062515.3712430-1-nikunj@amd.com>
 <20251013062515.3712430-4-nikunj@amd.com>
 <c6d0df58437e0f76ce9bdf0c3b7f5b53c81989a9.camel@intel.com>
 <aO6jC_UEH13oWIs0@google.com>
 <caa07ae9ebd6401a05ca6b28f31c11bff0a7f955.camel@intel.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <caa07ae9ebd6401a05ca6b28f31c11bff0a7f955.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A3:EE_|CY5PR12MB6250:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f8297ce-88e8-421f-508a-08de0ba4c70f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024|13003099007|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QzQ1UGFtMmdURHR2T2pKUkhXWUtMc2JpSjdqRXdtbXNUWnRYWDJONUV4Nk5R?=
 =?utf-8?B?WHBZVTl3VnAydUlaRlhtK3VCaWpFV1hTV0s4ZjI1Tnd4SWxMUUJBUnB6R3FE?=
 =?utf-8?B?K3E3R0FvRWhjWkpDdUFpWmRFcWN2UXpMVllUSnJzNllyNTlON0REN1VIM05O?=
 =?utf-8?B?MVF5MCtrV3RoNVo3TnI0SW1iTjlCQWNzaURQQTdUWm1LaHRxQ0llSHVzcmNT?=
 =?utf-8?B?bnVnVXovcVZ3YjEvTi9RVG9ZWlRrZ2FWVlY0RDVSQk9Yanl4TkpBUTNLM0dw?=
 =?utf-8?B?OXM4bFFsRkZxOEh4Rk9xcURTOEdXZkxrTkQ2TW91dE5KcGVyS29TU3FtWWll?=
 =?utf-8?B?akhLbktNekI1Tkw2aXRucnB2TDk3V0w2QVdzUDJzcTNzSVZJbjRWTmlSZTk5?=
 =?utf-8?B?c0xxdGZRajZIVUJjRncyT0tDRUJlbmlXRTArMkI2UmZzbjBxZGpRQURFd3B4?=
 =?utf-8?B?eklNT3R3UUlaaGQ3anE1MWQvMjZjMmpmbDdPSUNVSE9yWjUrcmVRZStnMGw0?=
 =?utf-8?B?NW43dG1NWEkyQjNSdG1Zdk01TlZSQ2xVZXNpM3FGazEvY3laYzNEbUl6VVJt?=
 =?utf-8?B?Qlord1luN1lzdWI2czU1ckFJbm90dVlxbWc3djN2Q0NqYXFqRGtPL2RITkl2?=
 =?utf-8?B?L2ZKaWs0R2JGUjlad3M1YkpIUllZdGE3N0NSdUQ0RTIvK3lDN2J4aDBiZ2I4?=
 =?utf-8?B?dWxQTHExeUpHUEsrMDJ0aFBYckNkY3FVL09pWndvNlB5NmpKSXIyQTBRVjF5?=
 =?utf-8?B?TXZKa2xOMjczQTJUbTIzblk0VWV1dm9iV1pkYmNFN2tkZyt3eHNGZUpIWXF3?=
 =?utf-8?B?Q0VXRTl3SjlvWU5tNXJuSmEwZDV3bHpRcFdFRzAyZzJnRzc5VUZVU09YNTVv?=
 =?utf-8?B?dFlMN0J3bUg4SXFHSDVobG1sZ3k3R3hDeVh4eUplSUczQkVZWnoyRnVheGtZ?=
 =?utf-8?B?YWJUZXdEdkFRaGl2Mk5WdGhucW5tRnVMdGhvdXlZbnZiZWZuWTRVU294Wkpl?=
 =?utf-8?B?M1pWVTAvLzlOOTZoMlhjNXV1SWkzMWlYdDdwY0IydDByL1VHSDN5Q0R2QXhO?=
 =?utf-8?B?K3VTMExYNC94czRFaktUTTIzN1hKYkhZUHlTUmFWc2I5QnR0a3FFSmZMeWJj?=
 =?utf-8?B?YW5CYm1xSTZESXRyTjNLWTFWaWovVjI4TXNXYVVJYm5FKzI3dXVTYkkxM1lq?=
 =?utf-8?B?S1NPQm5xVEVHcUs0ajE5cmNOMzFoQ3MwWlR3T3liV3RFTzNqMUlnS0NoRHFG?=
 =?utf-8?B?ZGRZRFhaS1hLUEVpakhoS2RNUDdkQk1ud3AwS3pUbWNGRDg2SEI1ZW1oTFNG?=
 =?utf-8?B?QzJUTndpZDdEQS9HTmtnbGZBNkMxcVVNUkVWUjJPUXNLdWFaak9OZkMxWGx2?=
 =?utf-8?B?WTVCZFlOdFdNc3EveXRDYVVWb3ZnZ1BOVzdxVVViQVVvdEV2ZDdLcm5BS3RP?=
 =?utf-8?B?VGpCOStxUXRHL2hkLzBRM1JIczBsQVZLOEV6SmRGRTRzOTF4UFhpMHRhSWpN?=
 =?utf-8?B?QW9pZHRJVmVHZTU4bldla2tkbGVvckEvYU15Nkk3eVdkeXR0UW9iK3JhZm9G?=
 =?utf-8?B?dUFBMC90YjA5QWk5dmY4ZUFLVG53OUNJbjJUQ3BZUFZtMVp0UlJDeDRWWWhY?=
 =?utf-8?B?bzVkZGtncVd4eHBYUmVNTmpsR2lUeGdLeXJ3SGMyNTFORmMrakJucDdTKzhv?=
 =?utf-8?B?djNVTGtRMWdLMnJJNHo1V2U3cFgrUnBrTFFsSlNza0lMQkpHMjNDRFVmOEdl?=
 =?utf-8?B?MXdFWk95ZGUwN1pXRExrVk1TaWNXVHRocFpSTkp5bmkrc05LdnZtS2d6bzJM?=
 =?utf-8?B?Q01FNXgrVlJaSVBrcXpLWUczZlk0ZU9YQ0J4V3gwSW1OQzRaS3FaLzdBbW1Z?=
 =?utf-8?B?eDRtOHV4UzUvbjVURmJkT0FwS2xxWEhKdjVZczllL2Q1OVhtbnpWZ3dkT1pY?=
 =?utf-8?B?VHl0aW5WMHVYV2h3ajBFVFhVNGYyRzUzZUJZTDF2d2Z5ODRobHVOTE5zQTZI?=
 =?utf-8?B?N1p1emtYeDh2RGRSb2huRWEzY2cwbExLSll2RDY3ck1xeFNvdjRvaS9TVUN3?=
 =?utf-8?Q?e+p6Yp?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024)(13003099007)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2025 04:39:07.4963
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f8297ce-88e8-421f-508a-08de0ba4c70f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A3.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6250



On 10/15/2025 2:17 AM, Huang, Kai wrote:
> On Tue, 2025-10-14 at 12:22 -0700, Sean Christopherson wrote:
>> On Tue, Oct 14, 2025, Kai Huang wrote:
>>> On Mon, 2025-10-13 at 06:25 +0000, Nikunj A Dadhania wrote:
>>>> Move the enable_pml module parameter from VMX-specific code to common x86
>>>> KVM code. This allows both VMX and SVM implementations to access the same
>>>> PML enable/disable control.
>>>>
>>>> No functional change, just code reorganization to support shared PML
>>>> infrastructure.
>>>>
>>>> Suggested-by: Kai Huang <kai.huang@intel.com>
>>>
>>> For the record :-)
>>>
>>> When I moved the 'enable_pml' from VMX to x86 in the diff I attached to v6
>>> was purely because vmx_update_cpu_dirty_logging() checks 'enable_pml' and
>>> after it got moved to x86 the new kvm_vcpu_update_cpu_dirty_logging() also
>>> needed to use it (for the sake of just moving code).
>>>
>>> I didn't mean to suggest to use a common boolean in x86 and let SVM/VMX
>>> code to access it, since the downside is we need to export it.  But I
>>> think it's not a bad idea either.

As per the comment on v3 [1], I had implemented the common boolean like enable_apic

>>
>> Ya.  At some point it might makes sense to define "struct kvm_params", a la
>> "kvm_caps" and "kvm_host_values", so that we don't need a pile of one-off exports.
>> I'm not sure I'm entirely in favor of that idea though, as I think it'd be a net
>> negative for overall code readability.  And with EXPORT_SYMBOL_FOR_KVM_INTERNAL,
>> exports feel a lot less gross :-)
> 
> Yeah I like EXPORT_SYMBOL_FOR_KVM_INTERNAL().
> 
> Btw maybe we can avoid this patch?  Please see my second reply to the next
> patch:
> 
> https://lore.kernel.org/kvm/8b1f31fec081c7e570ddec93477dd719638cc363.camel@intel.com/

Agree, with kvm_mmu_update_cpu_dirty_logging() checking kvm->arch.cpu_dirty_log_size
there is no need to export enable_pml.

Regards
Nikunj

1. https://lore.kernel.org/kvm/0d1baaecc56de2b77f82ab3af9c75a12be91d6b2.camel@intel.com/

