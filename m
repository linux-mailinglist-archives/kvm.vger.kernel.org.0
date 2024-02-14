Return-Path: <kvm+bounces-8722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3DC48558B8
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 02:22:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D84251C23042
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 01:22:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95FC517FE;
	Thu, 15 Feb 2024 01:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="WeZULpPx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3991362;
	Thu, 15 Feb 2024 01:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707960101; cv=fail; b=Ut2CM16sAW5pzmBzPuBPjDU+kzc+balds15ADkpd4CQHFJZJfbRJFgdcYIbd7OJFDZVZ0Zq3ExIEGALQY6RxyfcV5P4fpzdWDuAkcKtf470+tx/E9SfEPiir2j4/BUbTVhfvvpj4eHwhcWVy+4l3Y2HgbbF++j/lAcOW6Ums8cs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707960101; c=relaxed/simple;
	bh=oz+EmMu5hfIBea/d9PmsjOTagWdbeDTmovZM5Ywjog8=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ff33kEx4IjkkiMfG+effmmNVfIhkuAVF33292L1gVtkpY+u8kBXN6UT/ouJUq93/ZOsczdpTwkmb9Av79bo4jUvm6QIKianm7CupCgFg0OBeyHUVCljUBr64bMC6pTfCD6okyIoE4AccSw7csM1OpQpl/hf3s1u4DXu4QQxIQw4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=WeZULpPx; arc=fail smtp.client-ip=40.107.236.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IzbacGrlAY2h+uUcMLvl6uwFBjUzeswOZUWIAgWxiM40+ciSNBJFkRq2priieO0A9doNCYQ47d/7gMJQVdhpZW5EC5w32bZw2MbPfR7shORq7ANNAKhlRoVMc1A+HUuJNk3aIJPRDZdJXapPLHudllu0HD/bJLvck9hv1xwaXQHJIljc0NhCzKUhHa/b9znlFlBIJdws/GZzB19ZtFBoEdyv8EN23RljI069agB6K1yOi1GM4DUo7GcNYTOL5B2Jlhu2qtZUiL5kTzpAVlJu5aL0YCDQNozs7RIBeUZx71AlNgTCRdvD4yglNY8qPlNFvTesVj0seq6JKlidC25Uvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VCJtRqNFHUPy9vfIhEBLag99u6Wm4o7/4XvDOgyWUx8=;
 b=gQtz/rVyaFFRXFvNZpSxizmneG+hVqo12nWLzL/M9ZOHBIzHfqm6QGekrgClqun1xlLFcDSAL2WAiIz00BA+SJaAFs4Hu11HRScbOEsfBNopUr+ZyyEmcdpLOuewcvVEC9c6b5wrxGDGJRCRhonu1t+n9gHtroT+m6caXVHyjOhFoBScoyt6ygnqMfpQmJCQH0FVS3Z3x/WP+XnkQqlq6TYKw42sGaifkHt7rAN8YJLCBYlA9A4ZYkgUX5cToTWRCr6btBT3E40VkuCn2Hv0jxdN5wzLylWrLvmZZBlCLD+dGksBTIZEa2gqk4T7dI0ayCq7y7JtgpE43YVXrgwG9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VCJtRqNFHUPy9vfIhEBLag99u6Wm4o7/4XvDOgyWUx8=;
 b=WeZULpPxa8CE1elAOYWor1ertsC2Hsf+hEYOIuKU7XPqoy+/36zX+68OLlSedOI6Y/cShGQ6trwbuv5EOSqLq3Xj3MXS3BZyRZIYwZcKmfegCwdlCzlXnAdFhG4/yikX3n9+4NU8pT3D+sk1pPrkmaJ7nQ+bWe/eVWQV28GvWlI=
Received: from CH0PR03CA0105.namprd03.prod.outlook.com (2603:10b6:610:cd::20)
 by DM6PR12MB4530.namprd12.prod.outlook.com (2603:10b6:5:2aa::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.26; Thu, 15 Feb
 2024 01:21:36 +0000
Received: from CH2PEPF000000A0.namprd02.prod.outlook.com
 (2603:10b6:610:cd:cafe::f8) by CH0PR03CA0105.outlook.office365.com
 (2603:10b6:610:cd::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.38 via Frontend
 Transport; Thu, 15 Feb 2024 01:21:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF000000A0.mail.protection.outlook.com (10.167.244.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7292.25 via Frontend Transport; Thu, 15 Feb 2024 01:21:36 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 14 Feb
 2024 19:21:35 -0600
Date: Wed, 14 Feb 2024 17:49:09 -0600
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<seanjc@google.com>, <aik@amd.com>, <isaku.yamahata@intel.com>
Subject: Re: [PATCH 04/10] KVM: SEV: publish supported VMSA features
Message-ID: <20240214234909.u2tc2i2qrrfq655s@amd.com>
References: <20240209183743.22030-1-pbonzini@redhat.com>
 <20240209183743.22030-5-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240209183743.22030-5-pbonzini@redhat.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF000000A0:EE_|DM6PR12MB4530:EE_
X-MS-Office365-Filtering-Correlation-Id: 2eec48ee-6ea5-4a8c-2697-08dc2dc473ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	YtBt5oeEjPJDpMQTd8ElwNcwv1kA2AsguPhRUTEzpEZ/OzEODMb6bSzG/74dwfbwfnhHJ0E7CvVS/pFqWBA0sEyhbx/6vq7sqLzFVuJnRoFbIIbZq+m4P9qHcnGzFRLo6nDp5fMJ+UxAXBRvflVeptUa16VFqgklmQVSOlHO7M2JaL8gfILCK6RMD7K/B1bsoe7wu6C8nt4voZlVrDWp1frCZrRWhMeodiV7M6+rUPppQkIYf/m9OteFItK86ibq/3xQn4FPePvwXUjtzIhwD3H8iaRzAVsbEJWSbTE6X5vPBOLdiflIdyyXso3E0xOIlVpqY/O3WFLEP59veuY8K2skAxDCEuq47OFP0y+PVfKB2zOyVz3oRRZy3S+K+pZPgu7Xygpo0EuQPMJ5o7jy29eemTfL9LjuuBGuDS9an2C64TjAfXYP8jwnDEI3ngAUIQhGT0c6A3uo6oJsv2z7azS+ZYtFSvB2WXz+CUPdJKxvlvFeoX0BE76x1Ggfbr7FfSWk6JIiApfOoVxR/Hzfh+N/W8j5pHTHF9mr8/EU4m6ueRNsbAywDEsUTynHX4/RUB/nfyOyyU4GpnV4zZ5PrAXRGV3IXM/eydC6M0cx7MIkQDhTxvyND46LKbcdcMfI+GJ3HF4xuAZSPow2buKZJ+2DAW2fu4QldduvvdvYiXo=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(39860400002)(376002)(396003)(346002)(230922051799003)(186009)(1800799012)(64100799003)(451199024)(82310400011)(36860700004)(46966006)(40470700004)(41300700001)(44832011)(54906003)(316002)(5660300002)(2906002)(82740400003)(86362001)(81166007)(36756003)(356005)(426003)(2616005)(16526019)(26005)(83380400001)(70586007)(6666004)(478600001)(336012)(4326008)(8936002)(70206006)(6916009)(8676002)(1076003);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2024 01:21:36.0748
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2eec48ee-6ea5-4a8c-2697-08dc2dc473ed
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF000000A0.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4530

On Fri, Feb 09, 2024 at 01:37:36PM -0500, Paolo Bonzini wrote:
> Compute the set of features to be stored in the VMSA when KVM is
> initialized; move it from there into kvm_sev_info when SEV is initialized,
> and then into the initial VMSA.
> 
> The new variable can then be used to return the set of supported features
> to userspace, via the KVM_GET_DEVICE_ATTR ioctl.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  .../virt/kvm/x86/amd-memory-encryption.rst    | 12 ++++++++++
>  arch/x86/include/uapi/asm/kvm.h               |  1 +
>  arch/x86/kvm/svm/sev.c                        | 22 +++++++++++++++++--
>  arch/x86/kvm/svm/svm.c                        |  1 +
>  arch/x86/kvm/svm/svm.h                        |  1 +
>  5 files changed, 35 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> index 37c5c37f4f6e..5ed11bc16b96 100644
> --- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> @@ -424,6 +424,18 @@ issued by the hypervisor to make the guest ready for execution.
>  
>  Returns: 0 on success, -negative on error
>  
> +Device attribute API
> +====================
> +
> +Attributes of the SEV implementation can be retrieved through the
> +``KVM_HAS_DEVICE_ATTR`` and ``KVM_GET_DEVICE_ATTR`` ioctls on the ``/dev/kvm``
> +device node.
> +
> +Currently only one attribute is implemented:
> +
> +* group 0, attribute ``KVM_X86_SEV_VMSA_FEATURES``: return the set of all
> +  bits that are accepted in the ``vmsa_features`` of ``KVM_SEV_INIT2``.
> +
>  Firmware Management
>  ===================
>  
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index b305daff056e..cccaa5ff6d01 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -459,6 +459,7 @@ struct kvm_sync_regs {
>  
>  /* attributes for system fd (group 0) */
>  #define KVM_X86_XCOMP_GUEST_SUPP	0
> +#define KVM_X86_SEV_VMSA_FEATURES	1
>  
>  struct kvm_vmx_nested_state_data {
>  	__u8 vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index f760106c31f8..2e558f7538c2 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -65,6 +65,7 @@ module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
>  #define sev_es_debug_swap_enabled false
>  #endif /* CONFIG_KVM_AMD_SEV */
>  
> +static u64 sev_supported_vmsa_features;
>  static u8 sev_enc_bit;
>  static DECLARE_RWSEM(sev_deactivate_lock);
>  static DEFINE_MUTEX(sev_bitmap_lock);

...

> @@ -2276,6 +2290,10 @@ void __init sev_hardware_setup(void)
>  	if (!sev_es_enabled || !cpu_feature_enabled(X86_FEATURE_DEBUG_SWAP) ||
>  	    !cpu_feature_enabled(X86_FEATURE_NO_NESTED_DATA_BP))
>  		sev_es_debug_swap_enabled = false;
> +
> +	sev_supported_vmsa_features = 0;

This ^ seems unecessary. Otherwise:

Reviewed-by: Michael Roth <michael.roth@amd.com>

> +	if (sev_es_debug_swap_enabled)
> +		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
>  #endif
>  }

