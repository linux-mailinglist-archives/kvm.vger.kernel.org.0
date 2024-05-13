Return-Path: <kvm+bounces-17354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB2AD8C48BB
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 23:18:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 60301282B0D
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 21:18:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62B5982C7E;
	Mon, 13 May 2024 21:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ECv/sK9Z"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2061.outbound.protection.outlook.com [40.107.243.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D701E824A3;
	Mon, 13 May 2024 21:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715635127; cv=fail; b=Q53KPOagxKIfAoI+Yxb2ZtBQktKSgcXEBBOXX0jF0MwlWHXUpsMGetdo6KneCf6UfIMRBVDmZHjXt5LUCwLFI94IaOwixciWtxW0ySAD2YEEBgOaZWm58Gj66vxb6HPgl4LcyMhDU9nnpH8E5Ax+iQudC33nlbM/YrGEYW5iyO4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715635127; c=relaxed/simple;
	bh=5oUD2nPoyGUCx5TGQuQtjxRyRApUCGP3mMnNFdt9mAQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uGI2POb6pLLcl1qeVgN6AI8hDiq4WoZFu3fsSs8/jaaFvJUJTkfUZbSl/lIAu1zOV8XklegEVmrTGBWxwb+UzoI0s9ccaCL5R13nKbOlRjxXSbPaJeFApoRU51emq1+92J6UQwMv9iTSPXwrhYxlzur78gSpKi7SEAAyN7ouWbk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ECv/sK9Z; arc=fail smtp.client-ip=40.107.243.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lXX27+MYX0BgM9/g1WhC1ssgcYZ3JYzCSJH14XJjYGNcIN9sBBbS9+bCi0cOyRljp11w3BlTbpKdF4RCGJrQ7cHko7argJ/9EFW4UsrGBvPidb/f4k0Yw8k7GmBsohQQkHb9wrolLSal+BYChZW2dvX02wV6c114P+xLi/E4OwmDRBDD0o6pXsYP+eFRItA3MJtog8v8vzHejmbpIaoUPq19VrnLGk9AR4r9zOzhIuH5TCBDYMWlYAgfNKpXl+n9+hNYfIyMm92rHl/c2Xjn3l2KQY9GvGRb3F7p+OAbSSWwsFXcVoNoADgeBPeJ71+u8LqxI3XEeHaOu+JkaqWmvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2JwlqFjexOxmYJkPHvWfL5YnAjxWZsyeZM1VRbh7/sE=;
 b=Apzi9pRNpvjlGts9WhTchSX8RCOKsNp4xyGrLepeB2bPQaPflfl1C0TvDWCOEs+MQviZxg8y+gQbRGxNvRxu6Bjxm0ccKJU1+uJKHBi9Wxa+FkAghHXLYf8A4a8anhR3wKjovxE/trDRmib9Jh7VgwIHrvfnnbGg04NMMxHvOAZA81qprkdn+DpYuqlzc1JbSPUoIi3RIRzCLTpha/a1rvRfGSJYo55CmM3jlpf58xWC3EHOOW0rhVR/wWV8aQej+mo+kzF6MUF73qUnNVNrf4mJggYvuiwh2PVmKnR2mfncOSt+kkvI67U5oxvTbVAinV+pU2YXu96wieNSMEeOaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2JwlqFjexOxmYJkPHvWfL5YnAjxWZsyeZM1VRbh7/sE=;
 b=ECv/sK9ZqJ0si+JwhN8mib6mDUy+lj25eTEw+I4yj4IVR7oo9dQ9HIWbsak9fSO0Y/lhTG4iHi0KNJK1OTAWNSSdVn/+nNs/aj0wiYt26THyB0Q4ekYM9Fvk20G+opPNMQvZi1kWG1iaFuFjxo+5/jrN+UYMUmQwT5/0a7zIL00=
Received: from CH2PR05CA0023.namprd05.prod.outlook.com (2603:10b6:610::36) by
 DS0PR12MB7534.namprd12.prod.outlook.com (2603:10b6:8:139::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7544.49; Mon, 13 May 2024 21:18:40 +0000
Received: from CH2PEPF00000148.namprd02.prod.outlook.com
 (2603:10b6:610:0:cafe::9a) by CH2PR05CA0023.outlook.office365.com
 (2603:10b6:610::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.22 via Frontend
 Transport; Mon, 13 May 2024 21:18:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF00000148.mail.protection.outlook.com (10.167.244.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7587.21 via Frontend Transport; Mon, 13 May 2024 21:18:40 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 13 May
 2024 16:18:40 -0500
Date: Mon, 13 May 2024 16:18:21 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Nathan Chancellor <nathan@kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Sean Christopherson <seanjc@google.com>,
	<llvm@lists.linux.dev>
Subject: Re: [PULL 18/19] KVM: SEV: Provide support for
 SNP_EXTENDED_GUEST_REQUEST NAE event
Message-ID: <20240513211821.rgg6mz4dgj5w3b4h@amd.com>
References: <20240510211024.556136-1-michael.roth@amd.com>
 <20240510211024.556136-19-michael.roth@amd.com>
 <20240513151920.GA3061950@thelio-3990X>
 <0ceafce9-0e08-4d47-813d-6b3f52ac5fd6@redhat.com>
 <20240513170535.je74yhujxpogijga@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240513170535.je74yhujxpogijga@amd.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000148:EE_|DS0PR12MB7534:EE_
X-MS-Office365-Filtering-Correlation-Id: c6f9db7b-1a52-49a8-c6d4-08dc73924316
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|36860700004|82310400017|376005|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?z4Jb8G/hXkRc6ODxswmySX4zZsJKYq2s3duZgNg8YRVbEVK9+br6TGbF8YxJ?=
 =?us-ascii?Q?NnZ1lgZm8RuZnoTnkAGLwy0QKlU9Ab1w9ODkx16tmQ9Ot7P91p+ykAXqr87Y?=
 =?us-ascii?Q?tXoPmuD5DNBqARVdTF2cBYLaCBX1sRUqMpol80/BZVLMIAgD4gHATUSwYPP1?=
 =?us-ascii?Q?yvDecyoLJ0ZWbeXava16A2IAb9LeX8gGgRsy9dcKEwgIe2+NF1j/BeyTIxCF?=
 =?us-ascii?Q?4ZehqRrmjBKP/9+1VLnvLRxLEQ/nJH+VoETF9UbEH1XKA3klmSHVxkrOySP/?=
 =?us-ascii?Q?2kvQF/O5586RFyoPTy+TyoLNxdj52ijwwXWYAFISkMyCes/4jDre/7MwEUMi?=
 =?us-ascii?Q?iAR3cNRiepitkVrNfGs4cmeF/4H24qyiERCoHwyfdb9o/SmontvLgkDLKTHy?=
 =?us-ascii?Q?qOpgwyQRSYnxTmet+4JkjRegimquLKaaOgjlNdGRrjfmghtgDGojVCZQjA/H?=
 =?us-ascii?Q?f7EahBawerJOB67mb0WnAcdxXg23h6ryFbytp1oMfzghI96aMw1DNoYyhZpT?=
 =?us-ascii?Q?Ahb0v/vd2AV0k3XbxlwG3c2trijH2i932dVlF1skB6OYvG490bGzvYLU9tD/?=
 =?us-ascii?Q?AchrhZYl+iYBF3Xfq++4vZ5Ay+NqZqcR4FuyEeN9nSOn8yxepO2iheTm43Wd?=
 =?us-ascii?Q?95cXBQY64hdfYJEze2kl7ycPG/s33nc/3sNXeRTazaCXoF+fWQI65Gkb59ql?=
 =?us-ascii?Q?vp360pYDJ699FMVUARn8XEa+6MLWR/ubBVJfs0mv1rsadnsXCXnA3bq5DuzG?=
 =?us-ascii?Q?Si9pxnRs9lo/z3nZ78rk7tNuNjALb396JVIpoO1oKUFv5f/4DtKgNOLIsE9p?=
 =?us-ascii?Q?yymTcYaskXe2BPhks16lXK70oEV/rtE0/RBjt4gC1QXOMJB+Y3lX3dLFld15?=
 =?us-ascii?Q?8oX2MhF25W8TZ/O65iXDr22gn8XH05MxTA7BPJgA7ixHsmz2CIY5SHoG87P/?=
 =?us-ascii?Q?oUWLdV9VNOPNGh4dF3ZYXgZvMTjkjjnlfHa3tXRqwk50teIjwMYAUXSFvqVR?=
 =?us-ascii?Q?012COh3INLU7QV0KPNcZ5ejCQAcZrpDnKBR/Q6b0IcN+RJO4e/a2Dc/iPAZY?=
 =?us-ascii?Q?975kndCkx6ffQAesAOy+lQWLDdYJScZ+iHUCPrvffghVpc6XQu6i/+E2vNdE?=
 =?us-ascii?Q?tYstH/yNolE1LV6kCdqRJsszwE1EFX2d1NJfekUX8lGXfktAu8Q9SbKYvg7d?=
 =?us-ascii?Q?fDuSxicNkvDwomaEygteAU34PQWMbK4CC3cczCiABxblM+FWrtcFS3IrDse4?=
 =?us-ascii?Q?re/zsg9xVS3YsolARHI3XkRRJ9wMpZm3PKzU6dG10mzdOropNbYZIllZhK9u?=
 =?us-ascii?Q?qvzjoUghUO/HRidPnMnoL/h0PWyXRdoz0tWRyzZiO1mVVA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(82310400017)(376005)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2024 21:18:40.6659
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c6f9db7b-1a52-49a8-c6d4-08dc73924316
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000148.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7534

On Mon, May 13, 2024 at 12:05:35PM -0500, Michael Roth wrote:
> On Mon, May 13, 2024 at 06:53:24PM +0200, Paolo Bonzini wrote:
> > On 5/13/24 17:19, Nathan Chancellor wrote:
> > > > +static int snp_begin_ext_guest_req(struct kvm_vcpu *vcpu)
> > > > +{
> > > > +	int vmm_ret = SNP_GUEST_VMM_ERR_GENERIC;
> > > > +	struct vcpu_svm *svm = to_svm(vcpu);
> > > > +	unsigned long data_npages;
> > > > +	sev_ret_code fw_err;
> > > > +	gpa_t data_gpa;
> > > > +
> > > > +	if (!sev_snp_guest(vcpu->kvm))
> > > > +		goto abort_request;
> > > > +
> > > > +	data_gpa = vcpu->arch.regs[VCPU_REGS_RAX];
> > > > +	data_npages = vcpu->arch.regs[VCPU_REGS_RBX];
> > > > +
> > > > +	if (!IS_ALIGNED(data_gpa, PAGE_SIZE))
> > > > +		goto abort_request;
> > > 
> > > [...]
> > > 
> > > > +abort_request:
> > > > +	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SNP_GUEST_ERR(vmm_ret, fw_err));
> > > > +	return 1; /* resume guest */
> > > > +}
> > > 
> > > This patch is now in -next as commit 32fde9e18b3f ("KVM: SEV: Provide
> > > support for SNP_EXTENDED_GUEST_REQUEST NAE event"), where it causes a
> > > clang warning (or hard error when CONFIG_WERROR is enabled) [...]
> > > Seems legitimate to me. What was the intention here?
> > 
> > Mike, I think this should just be 0?
> 
> Hi Paolo,
> 
> Yes, I was just about to submit a patch that does just that:
> 
>   https://github.com/mdroth/linux/commit/df55e9c5b97542fe037f5b5293c11a49f7c658ef

Submitted a proper patch here:

  https://lore.kernel.org/kvm/20240513172704.718533-1-michael.roth@amd.com/

and also one for a separate warning:

  https://lore.kernel.org/kvm/20240513181928.720979-1-michael.roth@amd.com/

I saw my build environment had WARN=0 for the last round of changes, so I
re-tested various kernel configs with/without clang and haven't seen any
other issues. So I think that should be the last of it. I'll be sure to be
a lot more careful about this in the future.

Thanks,

Mike

> 
> Sorry for the breakage,
> 
> Mike
> 
> > 
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index c7a0971149f2..affb4fb47f91 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -3911,7 +3911,6 @@ static int snp_begin_ext_guest_req(struct kvm_vcpu *vcpu)
> >  	int vmm_ret = SNP_GUEST_VMM_ERR_GENERIC;
> >  	struct vcpu_svm *svm = to_svm(vcpu);
> >  	unsigned long data_npages;
> > -	sev_ret_code fw_err;
> >  	gpa_t data_gpa;
> >  	if (!sev_snp_guest(vcpu->kvm))
> > @@ -3938,7 +3937,7 @@ static int snp_begin_ext_guest_req(struct kvm_vcpu *vcpu)
> >  	return 0; /* forward request to userspace */
> >  abort_request:
> > -	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SNP_GUEST_ERR(vmm_ret, fw_err));
> > +	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SNP_GUEST_ERR(vmm_ret, 0));
> >  	return 1; /* resume guest */
> >  }
> > Paolo
> > 
> > 
> 

