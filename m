Return-Path: <kvm+bounces-11776-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A87D987B687
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 03:50:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC4D81C20E1D
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 02:50:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9878B4A1B;
	Thu, 14 Mar 2024 02:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="iB9tHFt6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2048.outbound.protection.outlook.com [40.107.93.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA98A55;
	Thu, 14 Mar 2024 02:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710384631; cv=fail; b=ZwiXhxahljpKGEblUfYG9FwHU7pdR3D7QHoCCTMiZZmRPRFH+JnHGygU4RTUPqTiEjW8l67t5W11kbzmcOt/KQDEBE3yVM3wC9a5pYdl6X5yImSFpYRJqMj9kYtdlZEe5M3edMXGbk4VhPDFJvoyGl9vUJ/WUXZEff2W47jieUc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710384631; c=relaxed/simple;
	bh=VcSIvDraVTQ0SoTqGV10kaXHzYhGjWL2DtQmHCqrs0I=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OmBZ9/TM8X8auBc4sKrAM2zbC8VpQa/wNbD35IAUXaYF5Yqt6ZkrMsMbXiQFmq28jde6CZ8zuf+gpIqzfO/yiMFpzONEXHitttJBYJA86bGrwoj4cKZmcEqHeqg8qXjkYClOFEpMLm+BYupYTWUhDVSv4e0BldK8xRAYx+T685o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=iB9tHFt6; arc=fail smtp.client-ip=40.107.93.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A/BbUMBdf2pTRa33JzFt0ppOVE/ai3yWpeV1ALDRd+FF+a+/tRx3KaVRmNA2UtdJhkOv8cZxZbFBlPz0hcIXtkmqPDUnmLgyIRqlmQNL7kT7IHPKuDcSrqZ3to1j2ncSvRFoVPTYVwbd2z6vMa/dm6tjWMWlrrB/mcwjgirdCOdIoOYypfwcXwlBT8RMx/tJX8UwC9OpK1H6cKPXFC6QHvMKgUSeFTDZzSbVImneyBB8csOx8hQiKR8j1ikjBIaGeu43Ga+57Wv2ePiduJqJ16MFZHrB+ziokMjbdHQNYje2Ly96DODmTAsmSlucQY6VhxRbqQeOO/UBEY7p+pC5AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j/hLD2u8/doA1s3xZJgJWLcaS+GBoIW8R2SRxPBIJPE=;
 b=nX5kLydBbGYkuGDIFJe/wXONn5bgx71bLQvht/Siu2+co1Y2tfyCBRv9cjElcqop5QJtqJZgSdgVe4hLeTU6/dI741Gsxdz6f/d8WPCaxR43c4PIF7Ig8C0j7r4qVwkwgLmY1GxKfj5VlTGCuDH0qAISutTH1nTW0BTbjK0iCivAo+2DkVfGple1Ho1BIhGC6TUXkxJrlY88YEfVTMI+3pNZvxtvAbcHvRixzUE2g/nzDY0BpK7n6QV1JM/rq1S7Os0tzjchU8siwxX8MBxU6pvYfoE1pGtwFC5d0Tj5PlzDTIuyJFq8wdxieGfC7e6TIkDUVhclJoQZ2cEPy1DQnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j/hLD2u8/doA1s3xZJgJWLcaS+GBoIW8R2SRxPBIJPE=;
 b=iB9tHFt6oaoWjrAlc70pn32lRmUQqYrNHwLH4OKLfaDsoN48KG7qGVFEKNrDFJ0JBxWV+ULcTQ5gAcSnKe3PBxdCruYDqLRGW50qe9Bb++E8cGWninFMMwWBI3uF2xO3P0xVWjePa4axEIqWBZXzx4yspoISeuo8wScwm5EKPp8=
Received: from MW4PR03CA0305.namprd03.prod.outlook.com (2603:10b6:303:dd::10)
 by PH0PR12MB7929.namprd12.prod.outlook.com (2603:10b6:510:284::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.36; Thu, 14 Mar
 2024 02:50:25 +0000
Received: from MWH0EPF000971E3.namprd02.prod.outlook.com
 (2603:10b6:303:dd:cafe::a6) by MW4PR03CA0305.outlook.office365.com
 (2603:10b6:303:dd::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.18 via Frontend
 Transport; Thu, 14 Mar 2024 02:50:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000971E3.mail.protection.outlook.com (10.167.243.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7386.12 via Frontend Transport; Thu, 14 Mar 2024 02:50:25 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 13 Mar
 2024 21:50:22 -0500
Date: Wed, 13 Mar 2024 21:49:52 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<seanjc@google.com>, <aik@amd.com>, <pankaj.gupta@amd.com>
Subject: Re: [PATCH v3 10/15] KVM: x86: add fields to struct kvm_arch for
 CoCo features
Message-ID: <20240314024952.w6n6ol5hjzqayn2g@amd.com>
References: <20240226190344.787149-1-pbonzini@redhat.com>
 <20240226190344.787149-11-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240226190344.787149-11-pbonzini@redhat.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E3:EE_|PH0PR12MB7929:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a38f629-c0f5-4ef2-6422-08dc43d1803b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	S48XOy0sKfNLXOLQi1Fn18IyPl/7PlA55JrQ4Mq4BlDqlE4GEa/At4MXO85/fm2+fHdeZ/X2wY8MXyeIZYdN7JkDdKG71s2ayNmxa066sCyQM9MnKJXRk6PwOy4XesjmitI9mRa3ujmYIys3/ybMIbRjnHm07hV7dtkQmKW0FWfM29F0zTRcpvKZcGL+NmFoTR6fuUxz/HHWGRsU2cRP1qm60eQIIoRcKPLJBknAmuqRBdATPQvgf6H9l1//fKnEkf9dAGTMu+E3RU8m6Kn+uqiIj/XdWugud7kp60GfHCPiBhK4FHK7REtBgQ3YUIv6Imtm5b68+i3zXAwAab8ySYuDJ3d1LnFodxaVDb4qU0VW6lcJni6P8qvZtEvhNDKEvlur2n5twejJW5JhK20wpml1rUq+Nmg448EuQ+78y+HvqTFDrruWHLTgzgjaaUjFtoBTvjzIWnyDYf6N7xTZE+u3V1pJSKUigUc76OpKEPahmeLDHqArreHxnneqwxf1Pycdjpd4lGOTAtlyGqx+mEeMoHE+ajS1gbwlRQdQt5v9AzdupWUpemp74BYn20H31PfBV6caloM+uUbAcB4J8vJG5MSVWJC3ZuPHuWPly4G6BTrHHLRcTPfV8bhetf1P+IZljXgoMa/GbQtMaKrdv93+kefzz/tLAzsaBzuYl8k6dqPJlWwdf1osVbDcm3F33+rnhxxkJJyw7leYmp8izk0IW4mp5sKXHhGlf/l/Lf+OmFCpeho0FhwogKHjdRn/
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(1800799015)(36860700004)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2024 02:50:25.6494
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a38f629-c0f5-4ef2-6422-08dc43d1803b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E3.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7929

On Mon, Feb 26, 2024 at 02:03:39PM -0500, Paolo Bonzini wrote:
> Some VM types have characteristics in common; in fact, the only use
> of VM types right now is kvm_arch_has_private_mem and it assumes that
> _all_ nonzero VM types have private memory.
> 
> We will soon introduce a VM type for SEV and SEV-ES VMs, and at that
> point we will have two special characteristics of confidential VMs
> that depend on the VM type: not just if memory is private, but
> also whether guest state is protected.  For the latter we have
> kvm->arch.guest_state_protected, which is only set on a fully initialized
> VM.
> 
> For VM types with protected guest state, we can actually fix a problem in
> the SEV-ES implementation, where ioctls to set registers do not cause an
> error even if the VM has been initialized and the guest state encrypted.
> Make sure that when using VM types that will become an error.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Message-Id: <20240209183743.22030-7-pbonzini@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  7 ++-
>  arch/x86/kvm/x86.c              | 95 +++++++++++++++++++++++++++------
>  2 files changed, 84 insertions(+), 18 deletions(-)
> 
> @@ -5552,9 +5561,13 @@ static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
>  }
>  
>  
> -static void kvm_vcpu_ioctl_x86_get_xsave2(struct kvm_vcpu *vcpu,
> -					  u8 *state, unsigned int size)
> +static int kvm_vcpu_ioctl_x86_get_xsave2(struct kvm_vcpu *vcpu,
> +					 u8 *state, unsigned int size)
>  {
> +	if (vcpu->kvm->arch.has_protected_state &&
> +	    fpstate_is_confidential(&vcpu->arch.guest_fpu))
> +		return -EINVAL;
> +
>  	/*
>  	 * Only copy state for features that are enabled for the guest.  The
>  	 * state itself isn't problematic, but setting bits in the header for
> @@ -5571,22 +5584,27 @@ static void kvm_vcpu_ioctl_x86_get_xsave2(struct kvm_vcpu *vcpu,
>  			     XFEATURE_MASK_FPSSE;
>  
>  	if (fpstate_is_confidential(&vcpu->arch.guest_fpu))
> -		return;
> +		return 0;
>  
>  	fpu_copy_guest_fpstate_to_uabi(&vcpu->arch.guest_fpu, state, size,
>  				       supported_xcr0, vcpu->arch.pkru);
> +	return 0;
>  }
>  
> -static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
> -					 struct kvm_xsave *guest_xsave)
> +static int kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
> +					struct kvm_xsave *guest_xsave)
>  {
> -	kvm_vcpu_ioctl_x86_get_xsave2(vcpu, (void *)guest_xsave->region,
> -				      sizeof(guest_xsave->region));
> +	return kvm_vcpu_ioctl_x86_get_xsave2(vcpu, (void *)guest_xsave->region,
> +					     sizeof(guest_xsave->region));
>  }
>  
>  static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
>  					struct kvm_xsave *guest_xsave)
>  {
> +	if (vcpu->kvm->arch.has_protected_state &&
> +	    fpstate_is_confidential(&vcpu->arch.guest_fpu))
> +		return -EINVAL;
> +
>  	if (fpstate_is_confidential(&vcpu->arch.guest_fpu))
>  		return 0;

I've been trying to get SNP running on top of these patches and hit and
issue with these due to fpstate_set_confidential() being done during
svm_vcpu_create(), so when QEMU tries to sync FPU state prior to calling
SNP_LAUNCH_FINISH it errors out. I think the same would happen with
SEV-ES as well.

Maybe fpstate_set_confidential() should be relocated to SEV_LAUNCH_FINISH
site as part of these patches?

Also, do you happen to have a pointer to the WIP QEMU patches? Happy to
help with posting/testing those since we'll need similar for
SEV_INIT2-based SNP patches.

Thanks,

Mike

