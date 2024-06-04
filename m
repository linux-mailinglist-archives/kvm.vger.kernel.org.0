Return-Path: <kvm+bounces-18809-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B3EA8FBFA7
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 01:10:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5D3481C21D21
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 23:10:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C16F14D451;
	Tue,  4 Jun 2024 23:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amd.com header.i=@amd.com header.b="I1SCBCKM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2047.outbound.protection.outlook.com [40.107.94.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7996314B077;
	Tue,  4 Jun 2024 23:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717542626; cv=fail; b=LD0QQKXWHfuuTF4GgT+FR7QEdJVs1rwJnjR5xo/QiKmdG2d2ZCXI9W59PQ1veinIfxnKFTEcpXYlkAlS0h2TXyurzjwo10nbLZ2sN01Z2EaNhS0kbKYNFwOhqJ1SL8pCHoWgsy1L9s3OVSHoR6k1M+seGgWv4yk9zd+35JScfJM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717542626; c=relaxed/simple;
	bh=fdjEyX59p5xIs0REzL+hmBjiVWCxZVCWnwALt6zKejE=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B7TJAGqS2d46LP6Io/TP1NabHGwkIDM+GLj5EdTZ0XF131CRFtIiSirGVC8PsIjdhg/l84qfoLjSKJMvu1Z7cG2eKpbkSOLdL4Oc+W71KkNQXv63TrKdqA2hzIIlpZBlg5BGGIF5J36bIfchdrAeMII+5aHQsp12Rs/7e+cWnaA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=fail (1024-bit key) header.d=amd.com header.i=@amd.com header.b=I1SCBCKM reason="signature verification failed"; arc=fail smtp.client-ip=40.107.94.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XoPktVgQDojkrgt5r+RQaMqIiIMnZbcXbJcxg5Z2cuZF3N6NVSK0fRGJaKvjILGI9NJUUmF6mgTdVrm3FTAKBOgUjvlWagrROnBIlamzCWGNP8SUjoIZC4vnsg3SyYA1mH9LqhGr2h70OQojMaK1yz5puPPp07yd16yz5EyGFWjNhcUhfSeMDHSPUwbGNw3m3s6u7VkvmreXcdBvBbT5EZ7X2CktkVckeQP/7h3pTANCM+bL6zGpCRKVZlckdxh3/kslvu7njdv+BO7nufPwh8D85WNx9snx1wne/5HcJ9ro+xuXTjd0CAbXJiupf3GpMxeDGJFlf5ZdVyIjcKgyuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AZK6BewWgvIvT6+tk6GAwnInJZuFFKdjVRF383/RKxk=;
 b=QVwhmWfw08yKkMPZgyYb/zE5QKFmpuZ2C9LsjwVB06/SvrFaXPfrRls/TWL1M15Am/XZPx5RObF2YQbhvTVGlDmRVEwtg2MReD5jelsSU0zLpB7WXEO8QjviuKJkOFl7eal8pqScVcC1lXsGfXyOvASFAiNW0hln2GI73D3IHz9c3TPrmhrtabZMKVNUlkCG1oiYJjXvbyx3Q2+AwBj7eWeZYkUHTrBBaSLFLiYnczgmagkqWWXjNWEBuVYPvaJg25gNPSth1ukmUSmuqUsRd2Xdyj67JkhX+I3JBKfzHc94RE5SjMpltqlh/Xd5HXKOqU6dTaLg1xJPNWifaO729Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AZK6BewWgvIvT6+tk6GAwnInJZuFFKdjVRF383/RKxk=;
 b=I1SCBCKMgNZGjf0CIvpFWxPNc8iMtRT0JBMNQWRpwk+Q9GG6F8cnktOjkvaN84XfDO2klW0PcGTMCS+mGzN56JYfbhdArrvRQJdA4KMZWdgdkuOcAhjm0BT7oxAYWbepOwLT1B3TLWdBB0VPcPWhrWpklTnjCBkHvwLefPMXXJE=
Received: from SJ0PR13CA0097.namprd13.prod.outlook.com (2603:10b6:a03:2c5::12)
 by CY5PR12MB6525.namprd12.prod.outlook.com (2603:10b6:930:32::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.27; Tue, 4 Jun
 2024 23:10:18 +0000
Received: from MWH0EPF000A672E.namprd04.prod.outlook.com
 (2603:10b6:a03:2c5:cafe::87) by SJ0PR13CA0097.outlook.office365.com
 (2603:10b6:a03:2c5::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7656.16 via Frontend
 Transport; Tue, 4 Jun 2024 23:10:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000A672E.mail.protection.outlook.com (10.167.249.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Tue, 4 Jun 2024 23:10:17 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 4 Jun
 2024 18:10:16 -0500
Date: Tue, 4 Jun 2024 18:10:02 -0500
From: Michael Roth <michael.roth@amd.com>
To: Ravi Bangoria <ravi.bangoria@amd.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <seanjc@google.com>,
	<nikunj.dadhania@amd.com>, <thomas.lendacky@amd.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <pankaj.gupta@amd.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<santosh.shukla@amd.com>
Subject: Re: [PATCH v3 1/3] KVM: SEV-ES: Prevent MSR access post VMSA
 encryption
Message-ID: <37usuu4yu4ok7be2hqexhmcyopluuiqj3k266z4gajc2rcj4yo@eujb23qc3zcm>
References: <20240523121828.808-1-ravi.bangoria@amd.com>
 <20240523121828.808-2-ravi.bangoria@amd.com>
 <3eca1e7e-9ddc-47a2-b214-d8788a069222@redhat.com>
 <f0de86a8-81c9-4656-862f-e229845d47cd@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f0de86a8-81c9-4656-862f-e229845d47cd@amd.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A672E:EE_|CY5PR12MB6525:EE_
X-MS-Office365-Filtering-Correlation-Id: 92d4fe89-946a-40ab-cb94-08dc84eb8007
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|36860700004|7416005|376005|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?c7ZhvrtJoUQmQNavOWJuj9ymDwhFsfxR653+w4vypHsqN2ZCRkFbDuFGE2?=
 =?iso-8859-1?Q?oFmx7dwqEmLkpSVnTItRG3dA921J+mIVRB09Z9SYgbMNlKoxtIu30Gy/ik?=
 =?iso-8859-1?Q?QyDVTu6cmqm/Axqq9ZAu7vZ1N7BoqLi1YlJ3yUz2hq3bLCpenStlJqzp9+?=
 =?iso-8859-1?Q?VIGIgzzd/0EEglUVLlR/8vUkEk4a3fDzjYEmQyeyo/h16zZSwXbLj5HXRl?=
 =?iso-8859-1?Q?xcTOmqCtWzuZ4Ce6KfuPC6QyZi5Rc5CUm43SLbZoLONyJK7zY/Wr59AyEC?=
 =?iso-8859-1?Q?vA8cvgmZKzE5TQJkvnSDZHR90iDebgWePPzqGTQ70EtMvvCxSgrT7lEHWn?=
 =?iso-8859-1?Q?nn3Bmifv1OjaM6riltaKoft/4curF/xdivSQbZqCRi3+eTD9F+mgH77s9H?=
 =?iso-8859-1?Q?vsC0GykppCf8uSJ8ecG3Wl+98d42ml3SCyLRHjdRQJWpX25pBxB37K3g/0?=
 =?iso-8859-1?Q?jZe9t+eNOrnGSXzAhfAmgdOkc1AaIr78g8Ocf1+hBc2UMCsXhDpOdjbQou?=
 =?iso-8859-1?Q?YGLX/2kR5OnOjZKn/ltT5y/l+FTvvE/y5bT2AwdQxIDqlDgSg7YVbLGAX/?=
 =?iso-8859-1?Q?0r0Wu94aDlH3CePPIw333XzjN2t3PVmqcM5/b2i1b17qU/LPy8oebHCz2x?=
 =?iso-8859-1?Q?Oxnd+uaqbCbFGMIVo/Z5e/MGq59XTngxyrZGI0m1k3cxzuv4kMYebLypur?=
 =?iso-8859-1?Q?4A6cNBYFRqplYMX059+GOwY2BRgeUayMsGlYBbtNp3/M2LZYcf5uLiJdl5?=
 =?iso-8859-1?Q?jJ5mydBjNDjzExyChovNurNPIq3mxRHKfIfaVG3V03o0O6nAHeAFuz37ET?=
 =?iso-8859-1?Q?z8Fs40nKcxkDqqXZkaNGWXJ521tc8HLoioHDxbcfBWUZQRvEngPfA0hexC?=
 =?iso-8859-1?Q?GuBT3q6FjJ8G5eX5/Sb0ug9hzxopJSzMvOfSuqs0ksacz1IpVYfxL86OHT?=
 =?iso-8859-1?Q?Q8D6bxxgyHHKnZMWXdDwcHzi6y8HcfO5gOE76i+jDk4dERxGFiMJYf9pFv?=
 =?iso-8859-1?Q?cAVwT6GWbMjcmCSbiYjiZMb4ZPPylSv3V3/VAkkxzXQMaMH3RkavQR48Uf?=
 =?iso-8859-1?Q?lqncgT//JiqpJSfxQmq0d32XOFPWUalJgIRmjmUWnIp2yNVTsoq5ySkrDI?=
 =?iso-8859-1?Q?2zzeYOpvbOrE4Nn8s9HC6q4Hh/xDRlQb/6Ss7ca51pUJhJiIdbmEFTw04/?=
 =?iso-8859-1?Q?VdHNHs4Y66HZ/I2L51aFN4WQYs9IiOnxcQO9BaOy0Sa1npaLpaco+BHmHw?=
 =?iso-8859-1?Q?k3DsWIBpFUw6yGUnsh08sIlY3lDchf7uCEKno9slQbqUkFYZfOqrxuN4oi?=
 =?iso-8859-1?Q?ATLfvj7VX5R1U72l34k9AKucLE473NumOkKBdKTvdhSnSyc+0Z0FWNXCJd?=
 =?iso-8859-1?Q?BnqaJgVaKCi8KjM6YnL2w5EJjdXtN0hKgevS1/PBaOzJBIq52p4hvlHMwK?=
 =?iso-8859-1?Q?eMG/2rD0S2f4kdzH?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(36860700004)(7416005)(376005)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2024 23:10:17.7599
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 92d4fe89-946a-40ab-cb94-08dc84eb8007
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A672E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6525

On Wed, May 29, 2024 at 04:14:10PM +0530, Ravi Bangoria wrote:
> On 5/28/2024 10:01 PM, Paolo Bonzini wrote:
> > On 5/23/24 14:18, Ravi Bangoria wrote:
> >> From: Nikunj A Dadhania <nikunj@amd.com>
> >>
> >> KVM currently allows userspace to read/write MSRs even after the VMSA is
> >> encrypted. This can cause unintentional issues if MSR access has side-
> >> effects. For ex, while migrating a guest, userspace could attempt to
> >> migrate MSR_IA32_DEBUGCTLMSR and end up unintentionally disabling LBRV on
> >> the target. Fix this by preventing access to those MSRs which are context
> >> switched via the VMSA, once the VMSA is encrypted.
> >>
> >> Suggested-by: Sean Christopherson <seanjc@google.com>
> >> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> >> Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
> >> ---
> >>   arch/x86/kvm/svm/svm.c | 18 ++++++++++++++++++
> >>   1 file changed, 18 insertions(+)
> >>
> >> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> >> index 3d0549ca246f..489b0183f37d 100644
> >> --- a/arch/x86/kvm/svm/svm.c
> >> +++ b/arch/x86/kvm/svm/svm.c
> >> @@ -2834,10 +2834,24 @@ static int svm_get_msr_feature(struct kvm_msr_entry *msr)
> >>       return 0;
> >>   }
> >>   +static bool
> >> +sev_es_prevent_msr_access(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >> +{
> >> +    return sev_es_guest(vcpu->kvm) &&
> >> +           vcpu->arch.guest_state_protected &&
> >> +           svm_msrpm_offset(msr_info->index) != MSR_INVALID &&
> >> +           !msr_write_intercepted(vcpu, msr_info->index);
> >> +}
> >> +
> >>   static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >>   {
> >>       struct vcpu_svm *svm = to_svm(vcpu);
> >>   +    if (sev_es_prevent_msr_access(vcpu, msr_info)) {
> >> +        msr_info->data = 0;
> >> +        return 0;
> > 
> > This should return -EINVAL, not 0.  Likewise below in svm_set_msr().
> 
> Sure.

One consequence of this change is that older VMMs that might still call
svm_get_msr()/svm_set_msr() for SEV-ES guests.

Newer VMMs that are aware of KVM_SEV_INIT2 however are already aware of
the stricter limitations of what vCPU state can be sync'd during
guest run-time, so newer QEMU for instance will work both for legacy
KVM_SEV_ES_INIT interface as well as KVM_SEV_INIT2.

So when using KVM_SEV_INIT2 it's okay to assume userspace can deal with
-EINVAL, whereas for legacy KVM_SEV_ES_INIT we sort of have to assume the
VMM does not have the necessary changes to deal with -EINVAL, so in that
case it's probably more appropriate to return 0 and just silently noop.

We had a similar situations with stricter limitations on fpstate sync'ing
for KVM_SEV_INIT2 and that was the approach taken there:

  https://lore.kernel.org/kvm/ZfRhu0GVjWeAAJMB@google.com/

so I'll submit a patch that takes the same approach.

-Mike

> 
> Thanks,
> Ravi

