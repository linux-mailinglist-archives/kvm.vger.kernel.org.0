Return-Path: <kvm+bounces-57983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D510AB831A8
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 08:13:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 87EEC4A2058
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 06:13:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE8C42D77FF;
	Thu, 18 Sep 2025 06:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2lkBJUbE"
X-Original-To: kvm@vger.kernel.org
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010044.outbound.protection.outlook.com [52.101.193.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7042284899
	for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 06:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758175984; cv=fail; b=pmODBv+fyFClRwVGTdEKxipmJhUgiGCSgnmch/UW6PtR16kTg6KOiT3yLsfxSCwltsAl7YWI8XXHh2zu/77vwPp3aoFJkHWHsOBIr3ZN4MzOY7MMib2JNNVqT0ARI8qxmBeO/STlkM8bIU98VkaFPiBrJWVLTsAPD8gsmlVgZg8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758175984; c=relaxed/simple;
	bh=gmTyaWjnLd1ZDYXaXlh16VAloXbRngggaopUVSAtk1c=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=gKD62dViFR+EuXljTq90HTnIunSaWbqVQwtkp/7nYgs4AcO7kl1T/vhdIOUfJ0+9gYkVMIQPyjiWis/9QMeEgOp3wxS3m8rSny2pGNisBLeqdxnlK2TPaL6KNWR753vR9WJoBytIkP+ZEfzXiXjBvgnQMcRLWZi8IRXYtBJVD/M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2lkBJUbE; arc=fail smtp.client-ip=52.101.193.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a35gTDIjxBHOTXmbw3OAuLxi5yC4UY2xBUxbO+SEn8WYA7oFNSK/IlBKLtkT+Yz4u9/LklOoAcGRroVaBI5YjYSiiSGa39CQLjf/IgkwTwg0/hCRWLnqaIewm8k8vqOoXmxfAPGe+rc1i1NQ+RrWLkky6r6ObtkxYC0S/3APt17weF/TtEoqUrobrODubYueYERR001Hn7M+V8gtQyDFd3wk1bj4VJkLlsijE8xqBzdCw/YpbekLoBA/hn+ROIarH2AYzqw5BHSaWCBSuUC64BhmNO3e12F+Mm1tnCcb88DootzyjAEhh7xQqKpIHHMIfnsUK5uFtKo8MICSnrLS4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J/8UGC9RbihPDEbOtcs90uzgEo2b8NuEolww1eV7paQ=;
 b=Wep37LFCZyA5U7jBbHz5nsNaaYUT8V4dqS3qd+NOJTAc83gYQV7L3XPehXxEPsu/Dwsh8Y1mvd196y46sCed5/9WTja9UspmuIn9aX6HiXlf9gyhgNXcEZoIbMlvCrv8UuTulj52PRYZm0KRrYvhQiFqa5ifN23jbHjzV7TP9CgbitKWgEdY8F+ssmCmBaGJ8OMQpdcOFxqXjyySy5NCi8rtRcww26+1n7gj/fz0f4vZnG0YAsEST8pnJjvL3BUWoU8v+FBSFI12N5C5JgNh9IACYuJWDQE5h7JCFHkD++NIJ1RkA2iLwuttn9FxzVv7v1kT3ckeu4QnLi3RzB8p/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J/8UGC9RbihPDEbOtcs90uzgEo2b8NuEolww1eV7paQ=;
 b=2lkBJUbE9vi9SxO0Ou3m02/KAFMXJ0Rjtj5LgoDYo6jUrncJTxtJH0+GbSUQUQzT/3jDqmBfs/otqYk9kIRvKclH4IutyeQVn5xdWx2yMP6bpgEEY8kFK8Klnz75vuu0hurddnGLhC4RK/vOAgWyWTeA52aZzsuSMxh1YxI/9r0=
Received: from CH3P221CA0004.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:1e7::35)
 by MN2PR12MB4405.namprd12.prod.outlook.com (2603:10b6:208:26d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Thu, 18 Sep
 2025 06:12:58 +0000
Received: from CH2PEPF00000140.namprd02.prod.outlook.com
 (2603:10b6:610:1e7:cafe::62) by CH3P221CA0004.outlook.office365.com
 (2603:10b6:610:1e7::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.14 via Frontend Transport; Thu,
 18 Sep 2025 06:12:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH2PEPF00000140.mail.protection.outlook.com (10.167.244.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Thu, 18 Sep 2025 06:12:57 +0000
Received: from BLR-L1-NDADHANI (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 17 Sep
 2025 23:12:53 -0700
From: Nikunj A Dadhania <nikunj@amd.com>
To: "Huang, Kai" <kai.huang@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "santosh.shukla@amd.com"
	<santosh.shukla@amd.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v2 4/4] KVM: SVM: Add Page modification logging support
In-Reply-To: <4c9e02133992661190b644d93a393f5f2d6bb32c.camel@intel.com>
References: <20250915085938.639049-1-nikunj@amd.com>
 <20250915085938.639049-5-nikunj@amd.com>
 <4c9e02133992661190b644d93a393f5f2d6bb32c.camel@intel.com>
Date: Thu, 18 Sep 2025 06:12:50 +0000
Message-ID: <85ecs4nva5.fsf@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000140:EE_|MN2PR12MB4405:EE_
X-MS-Office365-Filtering-Correlation-Id: c7e020bd-7fcb-4268-0ba5-08ddf67a69c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V2RHVUloU2RIVEVrUGE5ZjlmaDgva3lvQjZkYnR3TGZoaXo3aGNhelhNMCtY?=
 =?utf-8?B?cmcwY3VOOVV2d3pHNFlZZ3lGQ1lqazFnanRaRHU4T3h4WWljOSsreHY1ZGE1?=
 =?utf-8?B?SUVHZUNwVWQ3S2tRWGdzbXo0UjZYYXVCeFlZOGxnNnptWUVWVUQvU1pDb0VP?=
 =?utf-8?B?RkhkRG02N2VWS2F2TlQ1RnArQzhkMmhhTk9BOEtFWVRWNGw2OENiaTVoNmVD?=
 =?utf-8?B?dktrMHhvRUpROEtHZUwyMXBHWFYvMm5URDVVZVRFdUI2cWtzdWhwemJPZTQ3?=
 =?utf-8?B?dDhwY2FZcitXTTJTMkVWTTgydVA0Qm9DeElhWjE2QVJZakx2eklTOFpmdFdu?=
 =?utf-8?B?QWdvZUxYY2VQZENjYWhLbUN6Tm00cXdCRlNpVE5uU3JsM2JqUDdLTzJhcytQ?=
 =?utf-8?B?TU5CbzNqcUFyaGpxY2s4TUgrWFVDcVlZeWJCVHNiRDJGajFHVUlLTEFkbTNq?=
 =?utf-8?B?UUQ1NlE3bUZLYkl1NElBT2ZuWEtHTDlhQytiaHZoRXhpbFRJWlMzeVVSNkYv?=
 =?utf-8?B?ejZxNi91SFZpbFNLMCs0cFJML2NlYUlIM1FXb2N4aG5pU2dlOHNGaktOSlRH?=
 =?utf-8?B?aG1OUVNaWnR3TGdhdkJyTTRxeGJ6Yy9yR2ZLdXFwV2pSWnRNUXNDaXNDUWcw?=
 =?utf-8?B?eDllQXV6SEFmRThVU3lkdkFnR1NINTJBQTRHQVJEZ2E3UDhBN2JpTlVzSHpl?=
 =?utf-8?B?SzA2T0l2NG95Z1VNbEMyZzU3dkduWWVrN0tDRDJWb0ZyWGlKUnMzaUgySmJX?=
 =?utf-8?B?bEFLU2hrVE1NUGN0RjZOM1gxT1NjRko3aHd0R05yMitYdzM0ZmRvdjlZelhI?=
 =?utf-8?B?aHA4eGZGay9SZk5DYmxHM2pzblo2WFA4MEt3eHBMMFcvcitQSDFEYUJnUHBz?=
 =?utf-8?B?YkFFTUlFRVQwRjJJbW55VGhZQVVMV2k4L3NRREpvWnlONFBYS01YZ3MzN2o4?=
 =?utf-8?B?N0V1bU51QlFXcXg1YjQvWE9icXN2UWlyT3lPTzl0RzVVOEZzeVNlZm9Tbk54?=
 =?utf-8?B?bGtMTHhZSEgwdW04bmQrZGJYQ3VsNWkyU25yWTdxQ2R4ZHpKOG1MTm5tQzVC?=
 =?utf-8?B?VDErTXlXeXJnMTFrV2RkN0hTM3YvNTZLVW1TZTRMam1HVmh5QzMrY2o3MnNN?=
 =?utf-8?B?eDRLYWFEdmVzVGM4T1Vra1I0S3IzQzRKam14amc1L1FGalVhcjBJS0hLb1VU?=
 =?utf-8?B?eThBVkVzUW1KRVczNWpIa1pBMWpVUzhDYXlmRmswd0pnMUR2M2pZd3ZITGUr?=
 =?utf-8?B?a2VRbWo2QkJUOHcwQzA1OXZDd09KRFFOeDdSdEhTWDh1dDR3cjJiejgzaFQ1?=
 =?utf-8?B?VlNySGRQOUtRaWJhTXp5UEFGS2dxZmVRTGdrUEwzVWxnWm5kZ21uOUdFWGQ3?=
 =?utf-8?B?WFBXZThVQXZKa2tWQlI2RE9LNmZyL24wZ3VkMm1qSDFnWmRRVkhZK0N2MllF?=
 =?utf-8?B?a0UzbXJyWi80UmhmUnE1dFRKcmlHNjdmS2VtMFk4dmJxRWdmbjFIdzBNeDJQ?=
 =?utf-8?B?L2E3ZUIvRGg1V215WWlTRGhOQ0JtcGFKSEdaM2JpSnhLUDhuVlQyMjFIcXdK?=
 =?utf-8?B?RlRZUlBaSjRPWWx6VEpzOGRpTjR2c2txNXRodkI2bzA0eUhZLzVDdE5pa0ZO?=
 =?utf-8?B?ak9nbjdrV3d2Z3N5ZHdpUHVVaWxoUWozemxKVXdZSFVqSXMyVVI2WTB6NXcy?=
 =?utf-8?B?Sk96S3M5dEhvd25xUUMxNjJ3b1dTenJZbXpHbHlyMC9pYjJaTVpZa1dBNGwr?=
 =?utf-8?B?SHJNYzBSQzk0ejJUL2ltRFlEY3RVRWJEdEIwdnJCZ1NCNk44aHpKT0lITWU3?=
 =?utf-8?B?d1V6ZzRuK1dUUTdLSm9EZVM1L1ExbUkzZUtwUW0yVkxIMXBFWjNsazNRSkI3?=
 =?utf-8?B?UGNZcHFBVWJLN2MvaGNJUmttMStRd2pXSnZjRjI0aVAxMFBkSEJIMFVFM3FK?=
 =?utf-8?B?SVVsN0N2YXRDNVdnVHZ0OWRlTlY3aVZKM0dNb2s2S0txajZ4QXIzSmVCNFM0?=
 =?utf-8?B?ckdqTDl5NmhkOVpWWnp0WjhXOWNVRExnWEJaOXd0QzR5VEk5ZU5sd29IYjlU?=
 =?utf-8?Q?A07Xej?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 06:12:57.7106
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c7e020bd-7fcb-4268-0ba5-08ddf67a69c8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000140.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4405

"Huang, Kai" <kai.huang@intel.com> writes:

> On Mon, 2025-09-15 at 08:59 +0000, Nikunj A Dadhania wrote:
>> Currently, dirty logging relies on write protecting guest memory and
>> marking dirty GFNs during subsequent write faults.=C2=A0
>>=20
>
> Better to point out "On AMD platforms only".

Subject being "KVM: SVM: ", this seems redundant to me.

>
>> This method works but
>> incurs overhead due to additional write faults for each dirty GFN.
>>=20
>> Implement support for the Page Modification Logging (PML) feature, a
>> hardware-assisted method for efficient dirty logging. PML automatically
>> logs dirty GPA[51:12] to a 4K buffer when the CPU sets NPT D-bits. Two n=
ew
>> VMCB fields are utilized: PML_ADDR and PML_INDEX. The PML_INDEX is
>> initialized to 511 (8 bytes per GPA entry), and the CPU decreases the
>> PML_INDEX after logging each GPA. When the PML buffer is full, a
>> VMEXIT(PML_FULL) with exit code 0x407 is generated.
>>=20
>> PML is enabled by default when supported and can be disabled via the 'pm=
l'
>> module parameter.
>
> This changelog mentions nothing about interaction between PML vs nested.
>
> On VMX, PML is emulated for L2 (for nested EPT) but is never enabled in
> hardware when CPU runs in L2, so:
>
> 1) PML is exposed to L1 (for nested EPT).
> 2) PML needs to be turned off when CPU runs in L2 otherwise L2's GPA=C2=A0
>    could be logged, and turned on again after CPU leaves L2 (and restore
>    PML buffer/index of VMCS01).

I get your point and I see that when nested VM entry, PML is set in
the nested_ctl for L2.

I am trying to create this scenario, and couldnt get the L2 GPA's.

>
> It doesn't seem this series supports emulating PML for L2 (for nested
> NPT), because AMD's PML is also enumerated via a CPUID bit (while VMX
> doesn't) and it's not exposed to guest, so we don't need to handle nested
> PML_FULL VMEXIT etc.
>
> This is fine I think, and we can support this in the future if needed.
>
> But 2) is also needed anyway for AMD's PML AFAICT, regardless of whether
> 1) is supported or not ?

I see your point, we will need to disable PML for L2.

>
> If so, could we add some text to clarify all of these in the changelog?
>
>
> [...]
>
>>=20=20
>> +void svm_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
>> +{
>> +	struct vcpu_svm *svm =3D to_svm(vcpu);
>> +
>> +	if (WARN_ON_ONCE(!pml))
>> +		return;
>> +
>> +	if (is_guest_mode(vcpu))
>> +		return;
>
> VMX has a vmx->nested.update_vmcs01_cpu_dirty_logging boolean.  It's set
> here to indicate PML enabling is not updated for L2 here, but later when
> switching to run in L1, the PML enabling needs to updated.
>
> Shouldn't SVM have similar handling?

Sure, will get back to you on this.

>
>> +
>> +	/*
>> +	 * Note, nr_memslots_dirty_logging can be changed concurrently with th=
is
>> +	 * code, but in that case another update request will be made and so t=
he
>> +	 * guest will never run with a stale PML value.
>> +	 */
>> +	if (atomic_read(&vcpu->kvm->nr_memslots_dirty_logging))
>> +		svm->vmcb->control.nested_ctl |=3D SVM_NESTED_CTL_PML_ENABLE;
>> +	else
>> +		svm->vmcb->control.nested_ctl &=3D ~SVM_NESTED_CTL_PML_ENABLE;
>> +}
>> +
>>=20
> [...]
>
>> --- a/arch/x86/kvm/svm/svm.h
>> +++ b/arch/x86/kvm/svm/svm.h
>> @@ -335,6 +335,8 @@ struct vcpu_svm {
>>=20=20
>>  	/* Guest GIF value, used when vGIF is not enabled */
>>  	bool guest_gif;
>> +
>> +	struct page *pml_page;
>>  };
>
> This seems to be a leftover.

Sure.

Regards
Nikunj

