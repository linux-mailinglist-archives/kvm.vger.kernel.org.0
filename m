Return-Path: <kvm+bounces-73350-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cDEGIc0Pr2kYNQIAu9opvQ
	(envelope-from <kvm+bounces-73350-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 19:22:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3352523E8D6
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 19:22:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 88AFF302EE9E
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 18:21:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6BE3346E5F;
	Mon,  9 Mar 2026 18:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LZq3sOfg"
X-Original-To: kvm@vger.kernel.org
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012014.outbound.protection.outlook.com [40.107.209.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90A92DB78E;
	Mon,  9 Mar 2026 18:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773080477; cv=fail; b=Ydl8VU6Dh8pSsr0GjTJbOh+Lc5XRO9zREv8NnHZRVpfOuQffrP4JE0LZEhcO6ERjzihaCDzlme5ITZM7wptnF5WGBjEKxqQR4yfXUSU662+o1GPZpNkYnHlO/6Y5DzFmKPOosHNUQ0PhtnmJhFpvVxI0ej2cMz+/6HCb/aRY+60=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773080477; c=relaxed/simple;
	bh=cFhN+EuYtvowwjGlZTl4GZgopqfTvJWUk75iEPVt6BI=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=X4eg1Ah3vFi3oXulgTemvftgPVGOv3vESOf0dDxWlUoCKU3QdqzO5FS+omt1NVmiMY9kkfAOcTAWYpaTP53O2DYCIhObkAr54UVzvePSMeWmxBLjFeub36KclDeFWl+AjKSNDn4VviQsN3UPHI1QOHXpFfHp+PaZN+AY+zkKGyo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LZq3sOfg; arc=fail smtp.client-ip=40.107.209.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vrx9bJLUx9LJ2IR4C2BC6CFTLKoveW8ZJoLDPruLBJ1LywjZ2cjv2OjAP4qqqbzL+6m7Xg4siiLzy6y4e3tvBjxwMxrVsehpQIT7RvNVOgqLAYumQb9rzP4OjFKv8kZWKqKrJMTdE5w6acTcZEESdCtRyk4eXFPqMpcsP3FOyEeX86JPmEetpk1Nu1V5LkZCoyILK4thDJbaJwm1ZQzaoajVQ5HaAkcOGPpmek7nVMpJdOlDevMwirnddoj8513ITKOLml2ZE5IIWHySFpmwWFQJtEAyDjSUJzAAwGWP5wcdLCcrln7Wwnt58xt2utCSWygfe76VFoUBet/LILqzoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p/gthkCRcEByJvy20EgZ0D4Hv6PeAxj4jHU2PO/8Vts=;
 b=oDGmdC3HxgjV6kePDfmnLqva6mTSGVRoz3KPZVvBsZB3RZyy7vIAN75ucbA1jrVnMb4dvxTQj2VtJ3eV336jt69kMMc79f5s9rg21tHOZMj/3t94A42Et6yg5U8UrTq3V9JiE7UNN4txa9f8hq+49CqsOQbtThG5M8XVQumyi3yCUD+sge7zLDXnuQK/pOO7mm4VAK11YeTeKpnrAk4LQel6JA1VHM6GYydfY1/jSbufaTMVe/aH7cAIh9eTRcE/qutYViK8mTkEaqDaf2azkqhN/r4hRNT1qhcw7nfaRhiU04TOThWEZNY17RIWH6y0fpwYZKUpV5zPadrnMbQYCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p/gthkCRcEByJvy20EgZ0D4Hv6PeAxj4jHU2PO/8Vts=;
 b=LZq3sOfgVpwkwD7sZoNacSN+G/vYgOF4Gab1WOPELLwsI3TgJEvMnQV+3ff3E/bFPehgiHRkGOr9W82zf4BE7LvkSqJvDYVrrDifIW7GkvSsivA0oSUF7bfvJEaky6WJUYcUKzB77hCm0fpQFjEjyca/NtTdxenmH3V9iT/F1ac=
Received: from CH2PR18CA0049.namprd18.prod.outlook.com (2603:10b6:610:55::29)
 by SJ2PR12MB8158.namprd12.prod.outlook.com (2603:10b6:a03:4f7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.9; Mon, 9 Mar
 2026 18:21:06 +0000
Received: from CH3PEPF0000000D.namprd04.prod.outlook.com
 (2603:10b6:610:55:cafe::c1) by CH2PR18CA0049.outlook.office365.com
 (2603:10b6:610:55::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9678.25 via Frontend Transport; Mon,
 9 Mar 2026 18:21:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 CH3PEPF0000000D.mail.protection.outlook.com (10.167.244.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9678.18 via Frontend Transport; Mon, 9 Mar 2026 18:21:06 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 9 Mar
 2026 13:21:04 -0500
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 9 Mar
 2026 11:21:04 -0700
Received: from [10.143.203.87] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Mon, 9 Mar 2026 13:21:00 -0500
Message-ID: <6d74a4b2-67aa-42f5-8aa1-480e77be9ae9@amd.com>
Date: Mon, 9 Mar 2026 23:50:59 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] KVM: SVM: Enable save/restore of FRED MSRs
To: Sean Christopherson <seanjc@google.com>, Shivansh Dhiman
	<shivansh.dhiman@amd.com>
CC: <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <xin@zytor.com>, <nikunj.dadhania@amd.com>,
	<santosh.shukla@amd.com>
References: <20260129063653.3553076-1-shivansh.dhiman@amd.com>
 <20260129063653.3553076-8-shivansh.dhiman@amd.com>
 <aauJ80pZrw_SfF31@google.com>
Content-Language: en-US
From: Shivansh Dhiman <shivansh.dhiman@amd.com>
In-Reply-To: <aauJ80pZrw_SfF31@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000D:EE_|SJ2PR12MB8158:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d130aa9-72a1-4a49-87fb-08de7e08a15e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|36860700016|82310400026;
X-Microsoft-Antispam-Message-Info:
	wLbfKbxuQS1I8iKht9u6kzyEt7YJnNOs4tsx0qKS7MxJicZMtqhSuvUrloKzzdFZVNYl9cRD+sy4q4NtxgEdo9FM7sKoT3FcbtqNZAGDvxuQNA4EbEhTRcowXMt/gxY61YbKk9qdcHjLaTVkmjHHNXHeyBKDR8X2AFdKgeOj9Fro2Fg/Dd7cuWLupSqGQUqp/u25desesiN/aiaL71cphkjOE0obHSAGyAoUbGh5mqlKyjaKgKxRIwDAh1QpWiSQu/fIiysR71fpiTG5fp+eEnMhSf4T0E4f7eMggTdaDrrsx7wXSQkVhZwuY0RgwoqVGnpPwii3K6FDdt8rAyWJZMFoXpiVqJzDQEaPXxyb9yqldoSG8SlyXYaojKBFgoYys/5jQuMrRsEl6vCXvmL6H2lLcO70vz2J0SR7XQFkW0GQp3hadY3/eFE7Wjf1rVNyARn9gKsXKotsrJw+PpSPOioxdi76AG/BaZIWU5ckjwbg6ecObcZm0ILDh24JppRRnOpy/MS3lD3e32lizHREXnffGSk3sAlaqOJRDtvYS/5FLzDGGK2TEABD3R0FYaIBVwx4nztYHw/Op5KeiYkRzvWrbGjW8R7N4Y947lzVpTtX+mz2pjiI4+ioHLIGkTpVGEE9YFoYpizJFkMaAmlEto65iixZRRIjNQKAhLvk5UusfnNTQTY5sXaAAR3ZefRYBQp8lPbEs5BvYqr9OR14VtY/C9p12q/ffKM8g3ex5o5H8DZyJ4hgT/riXM+aFfci1VXinZmTA/UbyWYeYJzAzg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(36860700016)(82310400026);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	tOtlcpwwgr96OFWP+RV+NO+dLdLxOGFbqK074NxH+r+DXv/xrb1TAUwcNoZI2t44vGNWdY7/KtqznGIgOJMJ3ZvJroHyg6t03nitFPCndZiHJNefGND6CnlKDikgBC30y0alCll+duV4GpnxpOkqSt9FdOSBGq8bhoPhUM5YZmZKd3/XSZ2OuoAqB0zsVKxvwgungOsAgiZ9SxRs6PJj7A2CcNs5rU8BN4XuCR3K4gffKM/ESgCFH6PBBU5DLF7Ko/UJQ5fX+IyJAKbyxXYHvk2RyrkQyC/1WGs5INvLg9DxCEE8SjrpJ2s9Bva1j4d8/0gezKP25s3k5eCt+Zx18lnGi3kdRtDgvVHor/dnf4/jP8IWGfYcsBulGXl06KjFzaJp4MKsod5DXEX3uy4sYcF7FcSb/wweBvnPJdtyzm0+l7JsaJe+qJkIAfp+GM/9
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2026 18:21:06.4760
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d130aa9-72a1-4a49-87fb-08de7e08a15e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000D.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8158
X-Rspamd-Queue-Id: 3352523E8D6
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73350-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,amd.com:dkim,amd.com:email,amd.com:mid];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[shivansh.dhiman@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Action: no action



On 07-03-2026 07:44, Sean Christopherson wrote:
> On Thu, Jan 29, 2026, Shivansh Dhiman wrote:
>> Set the FRED_VIRT_ENABLE bit (bit 4) in the VIRT_EXT field of VMCB to enable
>> FRED Virtualization for the guest. This enables automatic save/restore of
>> FRED MSRs. Also toggle this bit when setting CPUIDs, to support booting of
>> secure guests.
>>
>> Signed-off-by: Shivansh Dhiman <shivansh.dhiman@amd.com>
>> ---
>>  arch/x86/kvm/svm/svm.c | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index 954df4eae90e..24579c149937 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -1144,6 +1144,9 @@ static void init_vmcb(struct kvm_vcpu *vcpu, bool init_event)
>>  	save->fred_ssp3 = 0;
>>  	save->fred_config = 0;
>>  
>> +	if (guest_cpu_cap_has(vcpu, X86_FEATURE_FRED))
>> +		svm->vmcb->control.virt_ext |= FRED_VIRT_ENABLE_MASK;
> 
> This is completely unnecessary, no?  CPUID is empty at vCPU creation and so FRED
> _can't_ be enabled before going through svm_vcpu_after_set_cpuid().

On a second thought, this is actually redundant. I'll drop this from init_vmcb().

> 
>>  	init_sys_seg(&save->ldtr, SEG_TYPE_LDT);
>>  	init_sys_seg(&save->tr, SEG_TYPE_BUSY_TSS16);
>>  
>> @@ -4529,6 +4532,9 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>>  	if (guest_cpuid_is_intel_compatible(vcpu))
>>  		guest_cpu_cap_clear(vcpu, X86_FEATURE_V_VMSAVE_VMLOAD);
>>  
>> +	if (guest_cpu_cap_has(vcpu, X86_FEATURE_FRED))
>> +		svm->vmcb->control.virt_ext |= FRED_VIRT_ENABLE_MASK;
> 
> The flag needs to be cleared if FRED isn't supported, because KVM's wonderful
> ABI allows userspace to modify CPUID however many times it wants before running
> the vCPU.

Agreed. I'll add:

if (guest_cpu_cap_has(vcpu, X86_FEATURE_FRED))
	svm->vmcb->control.virt_ext |= FRED_VIRT_ENABLE_MASK;
else
	svm->vmcb->control.virt_ext &= ~FRED_VIRT_ENABLE_MASK;

- Shivansh

> 
>> +
>>  	if (sev_guest(vcpu->kvm))
>>  		sev_vcpu_after_set_cpuid(svm);
>>  }
>> -- 
>> 2.43.0
>>


