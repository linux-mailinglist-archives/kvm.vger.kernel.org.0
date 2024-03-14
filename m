Return-Path: <kvm+bounces-11842-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 179A787C4FD
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 23:09:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9FB99282E26
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 22:09:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE3FC768FC;
	Thu, 14 Mar 2024 22:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fagdtZhS"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2064.outbound.protection.outlook.com [40.107.94.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB92E1A38EE;
	Thu, 14 Mar 2024 22:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710454185; cv=fail; b=uvJA1yoHurFCsbhUZU7XUBflHHVl4hjtEdBxXjbEsNRCIv/R943RAj8TVDbTs3+A3MypNQDFi/Ol40d4DcnSOGPZVUsIDK4sTn1yOBrTkh+0qK6nwQjqiwVe9x6ZH2Sjw7lcbJmhkawNf++yD299SDTwfkToIBj83hkD7acooNE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710454185; c=relaxed/simple;
	bh=xbJ/HpVpN85F3hpUyXcMw0tKjoXP5KBu/UdSnRfsuqY=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ccZzW36bGgNpnNtjMfPeUApby0wSLiwp1DA7s+pBLN3tNnIKhBzgVKdTju4bJEpke+xM7osKQ99qNAzAWiM/gBVbJYyiUrzFHpZ/iYuPYElvOSV7lP+XYSa3+X8po8WIDeXb3qJKXp7ek1isHu/B7TLy7r/SlsdHTeSGgUKYJUU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fagdtZhS; arc=fail smtp.client-ip=40.107.94.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OBi0pEj2MmJ0e2Pszkg/QXwvFOljyd0k16cJwy+wlgEsWSCleJ0HfQFN11pgkoUv0miIgjRMKuoNX52r73qH1unYejwsY8x1Y/6Vr93Nl31gOJj4bOMvbMKIqKKWwzFfsueM34sMlyEevsCaI/y+q9vVHMLZwZP+WfWYDgeUXqZ0f7LmxY2bA2xxVIb1FZYguS0sljlDp42hOtJLWk+zTn0L3vnvAnlHyno1kSly/790RIZvIMaHTT2YKuEkKzkMG5RerK4Hh7tBqxYXR4aopk2X3Q0tAoYClyea/SqngBbkkvmc+SBH77/G7gxPqK34/Hd2niWgSPfZh4oGb7X/mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mXIvD71kWbLc4036pgkLHCMUk+upxaIL7CurXA2uh04=;
 b=nVhUHDSl06hT8gzKfvFMEbVjj7VxNH+TeFX5ZYEige3GyQ/LR8bnNUqoAmmLXh3YD+71oxMm+js22NexOhFbTJ0S0U30zVbUiF9JNiXgNWKxLBYwSeX0/3tdcf4DOFytOBJgrWobb4UqFlxOGYNtwIm3BTq3bIrpWmSqLr44kcVGcNFqg21uS+chw4Rcs6h9YmgcsWsfigqqDgFCeAiFMYzlBzAa48H2uWdLtNJe4ojKaiaPz3w5dk2leEtWR7QQvuK69NHuBcRyiIjNXyJbXSWNxyCVeIIspYRYPaVpa7eEBEKXvIRWwYcXpvVm+fwkp/7oYyeaiVDPfH+n3xrgQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mXIvD71kWbLc4036pgkLHCMUk+upxaIL7CurXA2uh04=;
 b=fagdtZhS4vxdp6dXxMgUU6bnBq6GdUBzuybCByWgVCoiREaDHwS7fguybDoM4OYEYFmsHN9ejcYVzs7hswi9MxumyX4rBBpiSDbiWINQqF5gTjX1Md0hdHOJd5uPkBiw9vpJNtFsFZs0Zyts7es/hEgmPgt46rIOiTweeTegV7Q=
Received: from MW3PR06CA0021.namprd06.prod.outlook.com (2603:10b6:303:2a::26)
 by CH3PR12MB8581.namprd12.prod.outlook.com (2603:10b6:610:15d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.21; Thu, 14 Mar
 2024 22:09:41 +0000
Received: from MWH0EPF000A672F.namprd04.prod.outlook.com
 (2603:10b6:303:2a:cafe::2b) by MW3PR06CA0021.outlook.office365.com
 (2603:10b6:303:2a::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.21 via Frontend
 Transport; Thu, 14 Mar 2024 22:09:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000A672F.mail.protection.outlook.com (10.167.249.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7386.12 via Frontend Transport; Thu, 14 Mar 2024 22:09:41 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 14 Mar
 2024 17:09:39 -0500
Date: Thu, 14 Mar 2024 17:09:23 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<seanjc@google.com>, <aik@amd.com>, <pankaj.gupta@amd.com>
Subject: Re: [PATCH v3 10/15] KVM: x86: add fields to struct kvm_arch for
 CoCo features
Message-ID: <20240314220923.htmb4qix4ct5m5om@amd.com>
References: <20240226190344.787149-1-pbonzini@redhat.com>
 <20240226190344.787149-11-pbonzini@redhat.com>
 <20240314024952.w6n6ol5hjzqayn2g@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240314024952.w6n6ol5hjzqayn2g@amd.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A672F:EE_|CH3PR12MB8581:EE_
X-MS-Office365-Filtering-Correlation-Id: 183a1e12-e3ef-44a5-b79d-08dc44737280
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	WMuIij8KHYyDvFZqgiYuWR/OMyspNaYhsDveJ23Kh6jIscnYlhMxYppczFk65PUzcKiVUtIqqwtILXZ2iq7IGiV3r4nfSTAOh2G727vk3QFEdD4UntAxNASS/QtyS3KdbqAoQY6evKuomuEI6Q1ALv8OseIPZbCFs7k3h5wAgvmhGugWsZr1b3yVbpv0DSlUihSEjRUKgy/fEG5hTYfkYP0OkJLZat6bQpeyrmhdkHATiHe6J9b99WxzLlFdUz2+sXL4KDoTC0zLkju/iXXlWcOHAvcG2mBPRd2PCfd/ADVHoEMq+vQp3Gg2mbE9oBnO9lMe++6GbvYwY8kGBDTd0ncfMta0hz0Y+bwRNOAurLehJqo8OWQqrPwxmUJvMsPM9am4+L2SIxQChJg14ilYhETxL2eNehcW4JmVT1jCAlMabHBbqZy2WLMnzF2eJEpmk/iaWQtHnXlWllPods3SLM790PtaGutXJxwiYYxqNwpSRsfUv1/G/2igHjUaqZZCaYwRLYfAeulH2oJm9svRBlb7frtqynCw/RAz3VTdjhlr4f8cK1KYTm5bjnJWANoeBUphUcFUwBc0hTwu2JyQeWWi4hTTfV2jAyOz9Zjr7vqoMQn9gzGinu5f4y/lLZy1gxCgrz5fVedUGeDkMTwDUl71LKhYwGkZY3RplmjYgEqsJBYfVrrbSVeS0ocSKHRqtB01FooAr/3j068L2LGFgfuCsU5rIQ/qES9LTskQu+erJOaIL7pKIiTVVBrW3ErY
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(376005)(36860700004)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2024 22:09:41.1015
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 183a1e12-e3ef-44a5-b79d-08dc44737280
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A672F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8581

On Wed, Mar 13, 2024 at 09:49:52PM -0500, Michael Roth wrote:
> On Mon, Feb 26, 2024 at 02:03:39PM -0500, Paolo Bonzini wrote:
> > Some VM types have characteristics in common; in fact, the only use
> > of VM types right now is kvm_arch_has_private_mem and it assumes that
> > _all_ nonzero VM types have private memory.
> > 
> > We will soon introduce a VM type for SEV and SEV-ES VMs, and at that
> > point we will have two special characteristics of confidential VMs
> > that depend on the VM type: not just if memory is private, but
> > also whether guest state is protected.  For the latter we have
> > kvm->arch.guest_state_protected, which is only set on a fully initialized
> > VM.
> > 
> > For VM types with protected guest state, we can actually fix a problem in
> > the SEV-ES implementation, where ioctls to set registers do not cause an
> > error even if the VM has been initialized and the guest state encrypted.
> > Make sure that when using VM types that will become an error.
> > 
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > Message-Id: <20240209183743.22030-7-pbonzini@redhat.com>
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  7 ++-
> >  arch/x86/kvm/x86.c              | 95 +++++++++++++++++++++++++++------
> >  2 files changed, 84 insertions(+), 18 deletions(-)
> > 
> > @@ -5552,9 +5561,13 @@ static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
> >  }
> >  
> >  
> > -static void kvm_vcpu_ioctl_x86_get_xsave2(struct kvm_vcpu *vcpu,
> > -					  u8 *state, unsigned int size)
> > +static int kvm_vcpu_ioctl_x86_get_xsave2(struct kvm_vcpu *vcpu,
> > +					 u8 *state, unsigned int size)
> >  {
> > +	if (vcpu->kvm->arch.has_protected_state &&
> > +	    fpstate_is_confidential(&vcpu->arch.guest_fpu))
> > +		return -EINVAL;
> > +
> >  	/*
> >  	 * Only copy state for features that are enabled for the guest.  The
> >  	 * state itself isn't problematic, but setting bits in the header for
> > @@ -5571,22 +5584,27 @@ static void kvm_vcpu_ioctl_x86_get_xsave2(struct kvm_vcpu *vcpu,
> >  			     XFEATURE_MASK_FPSSE;
> >  
> >  	if (fpstate_is_confidential(&vcpu->arch.guest_fpu))
> > -		return;
> > +		return 0;
> >  
> >  	fpu_copy_guest_fpstate_to_uabi(&vcpu->arch.guest_fpu, state, size,
> >  				       supported_xcr0, vcpu->arch.pkru);
> > +	return 0;
> >  }
> >  
> > -static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
> > -					 struct kvm_xsave *guest_xsave)
> > +static int kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
> > +					struct kvm_xsave *guest_xsave)
> >  {
> > -	kvm_vcpu_ioctl_x86_get_xsave2(vcpu, (void *)guest_xsave->region,
> > -				      sizeof(guest_xsave->region));
> > +	return kvm_vcpu_ioctl_x86_get_xsave2(vcpu, (void *)guest_xsave->region,
> > +					     sizeof(guest_xsave->region));
> >  }
> >  
> >  static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
> >  					struct kvm_xsave *guest_xsave)
> >  {
> > +	if (vcpu->kvm->arch.has_protected_state &&
> > +	    fpstate_is_confidential(&vcpu->arch.guest_fpu))
> > +		return -EINVAL;
> > +
> >  	if (fpstate_is_confidential(&vcpu->arch.guest_fpu))
> >  		return 0;
> 
> I've been trying to get SNP running on top of these patches and hit and
> issue with these due to fpstate_set_confidential() being done during
> svm_vcpu_create(), so when QEMU tries to sync FPU state prior to calling
> SNP_LAUNCH_FINISH it errors out. I think the same would happen with
> SEV-ES as well.
> 
> Maybe fpstate_set_confidential() should be relocated to SEV_LAUNCH_FINISH
> site as part of these patches?

Talked to Tom a bit about this and that might not make much sense unless
we actually want to add some code to sync that FPU state into the VMSA
prior to encryption/measurement. Otherwise, it might as well be set to
confidential as soon as vCPU is created.

And if userspace wants to write FPU register state that will not actually
become part of the guest state, it probably does make sense to return an
error for new VM types and leave it to userspace to deal with
special-casing that vs. the other ioctls like SET_REGS/SREGS/etc.

-Mike

> 
> Also, do you happen to have a pointer to the WIP QEMU patches? Happy to
> help with posting/testing those since we'll need similar for
> SEV_INIT2-based SNP patches.
> 
> Thanks,
> 
> Mike
> 

