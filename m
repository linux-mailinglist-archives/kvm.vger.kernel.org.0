Return-Path: <kvm+bounces-53355-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B66D3B105B1
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 11:22:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D8EED16F4D4
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 09:22:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 481AE259C9A;
	Thu, 24 Jul 2025 09:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="SXvfgVNV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2062.outbound.protection.outlook.com [40.107.223.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D20C7153BE9;
	Thu, 24 Jul 2025 09:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753348955; cv=fail; b=se8BhRrIaO+IlfcwJBxt843WpOHn3ADix07qxtFurf33vj8vmxuJbplPETPOPbZ8s1nmoY6Bo+Wn89+RxFzXIb+nWS9ukLwyFVOgVkeVavS10fW9P4HXSmljulPJlPoTuJg39wmvtKmpPZyHgTH2I+maBCr6ljsp63SJ9EflP2I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753348955; c=relaxed/simple;
	bh=XWGD/wTU2khfbzBAhrQg1tF3auPTCePuzXBPbSZ/YRs=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=QKEBxYfDkh1joUzoLT0N2d7cdkpJ8P4buO4m5P2f1pcjt0YbuRPT6pyqJApnEOCyubIM5bePxYwgEhunfMHI/shnYrfh2ykmR7WScdDlr59X1DzOPlc4iLS8dLMldEi0bkCnyVvSJ6j9tnGuRFgmZY9HcFAk7s5YIRaUtAjh1Is=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=SXvfgVNV; arc=fail smtp.client-ip=40.107.223.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lo+xOpdsOuMTbW+f+GG+VAQ6HhlQrkoloGskRLGeilAKZc71YKYomINqxBmH0rJHOJtN+13gq8cUqLHjyhJJmZ9tmFgHXQ24MKIItbU0zAraMYOZ/d729LhRUrlNTPJOvsAbiZ+YHvEkbpMWXGAUo44s21uc/a1Oj9g/ALLEu3HmTOer4TkwrLpLR4J0yA6Xa+bahE7BdO6w/dXWAuFXrG1isZ1XnDDlQi4nvEoEgNMKGK/KPEHnDxFhaEq5WQWnnAKrloIr9LFBKvLIUP7vi/xWvh+U1CIj21FSmMZtov3x/zF4bSewI0+409jPjT3rczimgqWDRhrl76BIOv+S3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WVzKfd5Ezyn+oYkiu+h0sM+Iu/lduRUCYGgBwgRbRww=;
 b=MueLpkkpzfPW848B0jJFK5XR+K5rWsItxBKWtlF4k0CCAi+bqkUxxlLpXont2gqNCaFk96570cT2wYzd7kKV36gGacLsieM6/QohaO4ORSUXYUZeFwQujNhfliv48lUvSi+VtQjPZ0RCv4T8aBxsSpWrH7+IvJOKZWOBns3QadsRsspmex8Ex4U2t7cf8T/XYO0SE+H1ZwPINm5a5eWGZ6GjdInOpivUYUCQKG51ODNNiDszQHX1CmjTO8Xl48VlO2FvwdUYBhmKcNIyMMJZVxHCPRs9n7G7YVDBcDVY1u1sTI3TM+bmQlNGFLoEh52vfMziLwx3CVfNCEdUmRhIsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WVzKfd5Ezyn+oYkiu+h0sM+Iu/lduRUCYGgBwgRbRww=;
 b=SXvfgVNVCRhlw0++rR6mMWMpw2x+//6CpgTjkec55o26SMZ1jF/P/PSS4+PH6xYEyURrt9IqEtK8+P9GbX/Pxfxj12OLCQcNqtxoppga+JQyNwI0Hx5oxNTtM+aFbn3f1BEFYMk2wURxtL+MNWiVEspC/bzZsbkd5T/+0NHRiwA=
Received: from MW4PR03CA0025.namprd03.prod.outlook.com (2603:10b6:303:8f::30)
 by LV8PR12MB9272.namprd12.prod.outlook.com (2603:10b6:408:201::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.29; Thu, 24 Jul
 2025 09:22:30 +0000
Received: from MWH0EPF000971E5.namprd02.prod.outlook.com
 (2603:10b6:303:8f:cafe::7e) by MW4PR03CA0025.outlook.office365.com
 (2603:10b6:303:8f::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.25 via Frontend Transport; Thu,
 24 Jul 2025 09:22:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000971E5.mail.protection.outlook.com (10.167.243.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8964.20 via Frontend Transport; Thu, 24 Jul 2025 09:22:29 +0000
Received: from BLR-L1-NDADHANI (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 24 Jul
 2025 04:20:26 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: Sean Christopherson <seanjc@google.com>, Tom Lendacky
	<thomas.lendacky@amd.com>
CC: <pbonzini@redhat.com>, <kvm@vger.kernel.org>, <santosh.shukla@amd.com>,
	<bp@alien8.de>, Michael Roth <michael.roth@amd.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH v2] KVM: SEV: Enforce minimum GHCB version requirement
 for SEV-SNP guests
In-Reply-To: <aHp9EGExmlq9Kx9T@google.com>
References: <20250716055604.2229864-1-nikunj@amd.com>
 <2d787a83-8440-adb1-acbd-0a68358e817d@amd.com>
 <aHp9EGExmlq9Kx9T@google.com>
Date: Thu, 24 Jul 2025 09:20:18 +0000
Message-ID: <85ikji9c8d.fsf@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E5:EE_|LV8PR12MB9272:EE_
X-MS-Office365-Filtering-Correlation-Id: 7aacac74-2dd0-433e-f9cc-08ddca939cee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jgXstgZCYNxEVaoeyOgJjt/EVRjkI1vpTuLpb0Yuf/pEK7l9pRxEP3gAJQZH?=
 =?us-ascii?Q?hIo+RQyRTlfc85lN0BkSze6WvqSXFNbr/AjXm/tRd6ouGx4uoQsSd+O2WxgC?=
 =?us-ascii?Q?MD4FIgfoaxYohvtho0yeQhCp+GqxGByv7+2H1Te9LPSQlI6V/ywWHI91TQq7?=
 =?us-ascii?Q?V0hiYJdAo0e3pwhpPaaHDTRmjmHEe/CWbtNdXGvTf8A6BTpGh9b6q1PH7s6Z?=
 =?us-ascii?Q?30LctMH7ZTFAjNv/sjnz+fJhYcTXT2BNe+eGfRpm47kphJD1W56oITHc61oF?=
 =?us-ascii?Q?zQCur04otaP+fIdAhPQ1BA1g33ZafBMsRwBQIVa/AeByeYJEFL4Y8Ko7aYRh?=
 =?us-ascii?Q?hGc71cStLKNXyAvb39JNHPTvM0nmbHt1KwnXC/O0u6vDl1SXQBKVVBPak2I0?=
 =?us-ascii?Q?FQ6xLV7Zt1XNmzW/s/IzBe7po0hzCe5N4hAxDkT0IGmTSre7ZDiS1ty87LIY?=
 =?us-ascii?Q?x8VMh+KT0u1yLlKP9HZQES4rgx5tCvTOlSg9OM204AxteG6fcvwRbN3PlDoV?=
 =?us-ascii?Q?5OqIPUAimsU9v0mtdtbIuJc6meBLKWdAseErvvT3+8U2GWtsyh7Jg3mTR4v1?=
 =?us-ascii?Q?ifyQUMDr2SIA6N0CnnkizA8gcJOCGMwIm0kKI74fHISp9pP2oaGOfcHNp1K8?=
 =?us-ascii?Q?nEBVspUPuaXHAX/7OKMW0O4mhBqZGCjeTAUGHdzcZAhXE+PtDyP1fw7u53dJ?=
 =?us-ascii?Q?Op9RWEIPi9cII1uAGaDrnk+vUk9nRC76nDeF61KeWzAONFpPodwmHnlzXHg6?=
 =?us-ascii?Q?Z0zb2n8XjkqHQemb40U4e4AJphkFT8jW+xDSY0a99DLPoB9p/UMnzaW6yl9x?=
 =?us-ascii?Q?VfGx9o3n1xSsPRjJeMjrLcFSixHa3zQSfjkIKafPdG4nyXML6QLAZt6g8EH/?=
 =?us-ascii?Q?xETasLlCQVJ5mUbAOgRxTCJLU9Xg4KzuFIbXv8IOFPm8HiOanaHU2KdBuhnE?=
 =?us-ascii?Q?p2tzU1u1qgSVsK8bM+izYg6o6k6zXrBGqZJXnr4mc6FFGOcwpmVhTMHOXPi5?=
 =?us-ascii?Q?+UN5Hjw92wzdQdNzgyw4mFz+DDKrsHeuBPUz8HX9ClZw0RgiWoJAeIvJjnnf?=
 =?us-ascii?Q?HelXdKdyHIYR3bEjEAGhW8WMLVFvU7AE35wXhARfb5oXEVUSthRK6soQ5Oc4?=
 =?us-ascii?Q?dJ56MiSNQQEPLUiKFt5s2cJVrIxMPb0XCIowbfSGnxHSP9b8D+W/vjMciol1?=
 =?us-ascii?Q?oQmJxa+ikbzB/vhp6AvgYeufZqV7VEBwBDl4xZTvDxBSEhUBnKjRmM5GTnyn?=
 =?us-ascii?Q?zLPmbB7l9H3lqb0z7XdhOAQd2LZbsgISj7SNiPAJiVeHhRZwx6nYmIjuIIW0?=
 =?us-ascii?Q?3LhEjXkTLCm0AobM/6cUeT8qjMzk1jxHlQy+iVdqaXTumO6NIg+dnnnxs9Sa?=
 =?us-ascii?Q?ewFZteAdCivL5a8logzRP5aQVEcfYJXqCS8BKB44CGNQSuMjFq5X7iaLNoAD?=
 =?us-ascii?Q?QxguPxd5azxc1HaiHgPKalPhFT2bCcf0P1Ed+ZF0fIGd++S3gIDK4oZsx2sD?=
 =?us-ascii?Q?qOm63YDcF+kIEI+Da+IkNgtRIntpskEI20DO?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2025 09:22:29.7660
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7aacac74-2dd0-433e-f9cc-08ddca939cee
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E5.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9272

Sean Christopherson <seanjc@google.com> writes:

> On Wed, Jul 16, 2025, Tom Lendacky wrote:
>> On 7/16/25 00:56, Nikunj A Dadhania wrote:
>> > ---
>> >  arch/x86/kvm/svm/sev.c | 8 ++++++--
>> >  1 file changed, 6 insertions(+), 2 deletions(-)
>> > 
>> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> > index 95668e84ab86..fdc1309c68cb 100644
>> > --- a/arch/x86/kvm/svm/sev.c
>> > +++ b/arch/x86/kvm/svm/sev.c
>> > @@ -406,6 +406,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
>> >  	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
>> >  	struct sev_platform_init_args init_args = {0};
>> >  	bool es_active = vm_type != KVM_X86_SEV_VM;
>> > +	bool snp_active = vm_type == KVM_X86_SNP_VM;
>> >  	u64 valid_vmsa_features = es_active ? sev_supported_vmsa_features : 0;
>> >  	int ret;
>> >  
>> > @@ -424,6 +425,9 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
>> >  	if (unlikely(sev->active))
>> >  		return -EINVAL;
>> >  
>> > +	if (snp_active && data->ghcb_version && data->ghcb_version < 2)
>> > +		return -EINVAL;
>> > +
>> 
>> Would it make sense to move this up a little bit so that it follows the
>> other ghcb_version check? This way the checks are grouped.
>
> Yes, because there's a lot going on here, and this:
>
>   data->ghcb_version && data->ghcb_version < 2
>
> is an unnecesarily bizarre way of writing
>
>   data->ghcb_version == 1
>
> And *that* is super confusing because it begs the question of why version 0 is
> ok, but version 1 is not.

Yes, and had done the previous version because that.

> And then further down I see this:
>
> 	/*
> 	 * Currently KVM supports the full range of mandatory features defined
> 	 * by version 2 of the GHCB protocol, so default to that for SEV-ES
> 	 * guests created via KVM_SEV_INIT2.
> 	 */
> 	if (sev->es_active && !sev->ghcb_version)
> 		sev->ghcb_version = GHCB_VERSION_DEFAULT;
>
> Rather than have a funky sequence with odd logic, set data->ghcb_version before
> the SNP check.  We should also tweak the comment, because "Currently" implies
> that KVM might *drop* support for mandatory features, and that definitely isn't
> going to happen.  And because the reader shouldn't have to go look at sev_guest_init()
> to understand what's special about KVM_SEV_INIT2.
>
> Lastly, I think we should open code '2' and drop GHCB_VERSION_DEFAULT, because:
>
>  - it's a conditional default
>  - is not enumerated to userspace
>  - changing GHCB_VERSION_DEFAULT will impact ABI and could break existing setups
>  - will result in a stale if GHCB_VERSION_DEFAULT is modified
>  - this new check makes me want to assert GHCB_VERSION_DEFAULT > 2
>
> As a result, if we combine all of the above, then we effectively end up with:
>
> 	if (es_active && !data->ghcb_version)
> 		data->ghcb_version = GHCB_VERSION_DEFAULT;
>
> 	BUILD_BUG_ON(GHCB_VERSION_DEFAULT != 2);
>
> which is quite silly.
>
> So this?  Completely untested, and should probably be split over 2-3 patches.

Sure, will test and send updated patches.

> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 2fbdebf79fbb..f068cd466ae3 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -37,7 +37,6 @@
>  #include "trace.h"
>  
>  #define GHCB_VERSION_MAX       2ULL
> -#define GHCB_VERSION_DEFAULT   2ULL
>  #define GHCB_VERSION_MIN       1ULL
>  
>  #define GHCB_HV_FT_SUPPORTED   (GHCB_HV_FT_SNP | GHCB_HV_FT_SNP_AP_CREATION)
> @@ -405,6 +404,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
>  {
>         struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
>         struct sev_platform_init_args init_args = {0};
> +       bool snp_active = vm_type == KVM_X86_SNP_VM;
>         bool es_active = vm_type != KVM_X86_SEV_VM;
>         u64 valid_vmsa_features = es_active ? sev_supported_vmsa_features : 0;
>         int ret;
> @@ -418,7 +418,18 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
>         if (data->vmsa_features & ~valid_vmsa_features)
>                 return -EINVAL;
>  
> -       if (data->ghcb_version > GHCB_VERSION_MAX || (!es_active &&
> data->ghcb_version))

Any specific reason to get rid of the first check for GHCB_VERSION_MAX ?

Newer QEMU with support for ghcb_version = 3 and older KVM hypervisor
that still does not have say version 3 supported ?

> +       if (!es_active && data->ghcb_version)
> +               return -EINVAL;
> +
> +       /*
> +        * KVM supports the full range of mandatory features defined by version
> +        * 2 of the GHCB protocol, so default to that for SEV-ES guests created
> +        * via KVM_SEV_INIT2 (KVM_SEV_INIT forces version 1).
> +        */
> +       if (es_active && !data->ghcb_version)
> +               data->ghcb_version = 2;
> +
> +       if (snp_active && data->ghcb_version < 2)
>                 return -EINVAL;

Makes sense and is clear.

Thanks
Nikunj

