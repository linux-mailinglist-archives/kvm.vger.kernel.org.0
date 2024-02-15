Return-Path: <kvm+bounces-8726-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D19F88558CC
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 02:34:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 568CE1F25D6D
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 01:34:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F8AB1864;
	Thu, 15 Feb 2024 01:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="t0swm05l"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2047.outbound.protection.outlook.com [40.107.220.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BFEB138A;
	Thu, 15 Feb 2024 01:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707960884; cv=fail; b=lxPMc3k3bjPi4ctUaagoigSO3npKbhkPOwg42lIBH3uN+3AYrIw/rkZ79ch5u9McWv+9MITy+96c7EdFHyQE9wIwgpQX58SyMkFBApls0e94MCT7JRTsFPN69beTBzyRG6xgnPBqRW5kzVa7gZFZGv2ptIfMiebTaSWmUZ7K1VE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707960884; c=relaxed/simple;
	bh=fwIEvew8Xa8+ZzU+iEtXoB6F7S2CPWsw9KSaoEoMrIU=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n1AkX2dP62qKA5GREe6T6Z+wBR7e6u+ortJc0XMVL37E27jCS99oiUkpe6MdW8+WLS5hDyo5H80Z8ofOt5anoKx7J/PgSeNpmAuPXjs2PknDN/NuV7/U3Pb1MlxjDzrUSIlXQ37bMgtYqKfjImCriW+mTh/H1G9iaWzUmftqrFM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=t0swm05l; arc=fail smtp.client-ip=40.107.220.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LevAJCmlzoxAkZjAhdClQmy0CxEXO0yHRi3j7cf9I+zAIRrOxBj4bvtH7wq0L0xnLmRVP8HqkKIRINWrbiHAWtiUgGw4EFmgp8DLUHFvP9GPI2OnoAyC3/xly5odqcYpliOav3rCxe5UXAXt9NJGV8q1IGlNaefBV5VvJ6TYCNBxWCS7cFfNgULfE2N43KfARn7cCurMbAKqi8Gn3eE46T1eYS+ts+TwRg0xuHKzDvxLtTg+fmf6Z3mgZJ/E8RC6UIgcgAjY7pTOGJlqhz3OTvUc+6sYHKFYH5867uKLNaRSvg0KCPu+oplbHHIa7i8Pbaz0CWn+cxuO9WPal+Copg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RTZ1DMw/BJwqpFwkHF2djDLJkQP/fKZAISJoFLG7Qpc=;
 b=QEG6C30lHZiBzuu7ENYbbOb90XzrpBy+muF+BGR4krtSZ05CORUURK2Zzz7OTsyw7Aiw5JIySIcyMAjjHyu8ZQaWynWNDU/6uJ4yR/BqeYZ+C9msoXcm14zInHa4/FcDDgVxV3QAnIoVkA5wFvD5Ye5uzWXxzl19Ml2cGsrtI7K9VJP0PEpwvQkiBwtCGbIjGKGKo2K6d0PqEBB8inhb8WuOe6SBW8cdk+tGc4FL5Yvp3/f/rbQSuAZZe/QWEreltkxHSaTiCRVu449N42ws474XmRYfhCIvhoP4IAHALwxI/ucEaC+PnGVzkTXbNBeP5PFh4N69sHQ2pEQH9XeS+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RTZ1DMw/BJwqpFwkHF2djDLJkQP/fKZAISJoFLG7Qpc=;
 b=t0swm05lVkzKtA+qJaDI35oWlMlXm5I27HooNG6lx/GR06hns/lV0BirGT9pG4EY9pdXE4bveCC7LLcf2UPaiOZWWIkpfcZN/KxGrwxOxH3xxcXzv8xeNsVZbmWv5wfN3r3tSl4OG7My49vnkPSy8wLIykWlx+MVJkyLjpgeT8I=
Received: from BLAPR03CA0008.namprd03.prod.outlook.com (2603:10b6:208:32b::13)
 by DM4PR12MB7695.namprd12.prod.outlook.com (2603:10b6:8:101::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.25; Thu, 15 Feb
 2024 01:34:38 +0000
Received: from BL02EPF0001A0FC.namprd03.prod.outlook.com
 (2603:10b6:208:32b:cafe::e8) by BLAPR03CA0008.outlook.office365.com
 (2603:10b6:208:32b::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.40 via Frontend
 Transport; Thu, 15 Feb 2024 01:34:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0001A0FC.mail.protection.outlook.com (10.167.242.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7292.25 via Frontend Transport; Thu, 15 Feb 2024 01:34:38 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 14 Feb
 2024 19:34:37 -0600
Date: Wed, 14 Feb 2024 19:34:15 -0600
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<seanjc@google.com>, <aik@amd.com>, <isaku.yamahata@intel.com>
Subject: Re: [PATCH 09/10] KVM: SEV: introduce KVM_SEV_INIT2 operation
Message-ID: <20240215013415.bmlsmt7tmebmgtkh@amd.com>
References: <20240209183743.22030-1-pbonzini@redhat.com>
 <20240209183743.22030-10-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240209183743.22030-10-pbonzini@redhat.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FC:EE_|DM4PR12MB7695:EE_
X-MS-Office365-Filtering-Correlation-Id: 8cfd4b43-6d79-4181-fe1d-08dc2dc6460b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	0qZUd3Qt6YFQMixnUrMy/ad6+tI3bap7x1jOqi9nAz4wL6WtOhQjr4XQsUnrzvTglUaKjQZ8pOnRU/ogex4JkGbneKkNLD4nf/S4kYcGvJnkvoyutAVdZzKfgB5rQyIw0yBwlqh1C/5pyrYg+AUiJbT7fSWFfFfVr5p8n3kB7ybChUfSmNq2wkjy1qV+9jR5T4/ZCMUQMoLzvBVujagIDlm65PIi7eRCRgEudSqZTIDFHA5V1TXkjlI7AQznV9BlY4/YGAERd16KccU2Rw3pCiytAvMna/of6emrymVl4xu7NIsnEaMtiG1b1djxksHxXZZTWkvlbmKJ+0kDjCIT02ZTICUUbQXV11NODi4APq5AubJZwIWLz6EWtlatcdqB5g5rAcBi+266scyHZS+O7s0390RKwFSJNvieYGBEzRa9nzletlfAp+WIaupmhecmDXxZ7eMZAlBvrBMfkVRTPxQdYA4D2IY9sa/2QjhYa4pgbIyF9FXo/hbvtCUf9Qm0M4hrnPN2G1/0D3rOilBaPuyIj/gNBewq5jPRxI4lEz2rwWAhyV78xKELe5Z/9wAOIbMzkCkjzCf3+v7WCB/gFwKvwocRPTljmgWP3dsnmdFeh/POO4L3ig3DjERsZUP8mDHM0jVnu4Wn2GOyD2pgbPlLr05cfpXvpK1dM1IDnOY=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(136003)(396003)(39860400002)(346002)(230922051799003)(82310400011)(186009)(1800799012)(451199024)(64100799003)(36860700004)(46966006)(40470700004)(4326008)(44832011)(8936002)(8676002)(5660300002)(2906002)(2616005)(336012)(81166007)(426003)(83380400001)(26005)(1076003)(16526019)(36756003)(82740400003)(86362001)(356005)(316002)(6916009)(70586007)(54906003)(6666004)(70206006)(478600001)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2024 01:34:38.1420
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cfd4b43-6d79-4181-fe1d-08dc2dc6460b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FC.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7695

On Fri, Feb 09, 2024 at 01:37:41PM -0500, Paolo Bonzini wrote:
> The idea that no parameter would ever be necessary when enabling SEV or
> SEV-ES for a VM was decidedly optimistic.  In fact, in some sense it's
> already a parameter whether SEV or SEV-ES is desired.  Another possible
> source of variability is the desired set of VMSA features, as that affects
> the measurement of the VM's initial state and cannot be changed
> arbitrarily by the hypervisor.
> 
> Create a new sub-operation for KVM_MEM_ENCRYPT_OP that can take a struct,
> and put the new op to work by including the VMSA features as a field of the
> struct.  The existing KVM_SEV_INIT and KVM_SEV_ES_INIT use the full set of
> supported VMSA features for backwards compatibility.
> 
> The struct also includes the usual bells and whistles for future
> extensibility: a flags field that must be zero for now, and some padding
> at the end.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  .../virt/kvm/x86/amd-memory-encryption.rst    | 41 ++++++++++++++--
>  arch/x86/include/uapi/asm/kvm.h               | 10 ++++
>  arch/x86/kvm/svm/sev.c                        | 48 +++++++++++++++++--
>  3 files changed, 92 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> index 5ed11bc16b96..a4291e7bd8ed 100644
> --- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> @@ -75,15 +75,50 @@ are defined in ``<linux/psp-dev.h>``.
>  KVM implements the following commands to support common lifecycle events of SEV
>  guests, such as launching, running, snapshotting, migrating and decommissioning.
>  
> -1. KVM_SEV_INIT
> ----------------
> +1. KVM_SEV_INIT2
> +----------------
>  
> -The KVM_SEV_INIT command is used by the hypervisor to initialize the SEV platform
> +The KVM_SEV_INIT2 command is used by the hypervisor to initialize the SEV platform
>  context. In a typical workflow, this command should be the first command issued.
>  
> +For this command to be accepted, either KVM_X86_SEV_VM or KVM_X86_SEV_ES_VM
> +must have been passed to the KVM_CREATE_VM ioctl.  A virtual machine created
> +with those machine types in turn cannot be run until KVM_SEV_INIT2 is invoked.
> +
> +Parameters: struct kvm_sev_init (in)
>  
>  Returns: 0 on success, -negative on error
>  
> +::
> +
> +        struct struct kvm_sev_init {

Missing the vm_type param here.

> +                __u32 flags;          /* must be 0 */
> +                __u64 vmsa_features;  /* initial value of features field in VMSA */
> +                __u32 pad[8];
> +        };
> +
> +It is an error if the hypervisor does not support any of the bits that
> +are set in ``flags`` or ``vmsa_features``.
> +
> +This command replaces the deprecated KVM_SEV_INIT and KVM_SEV_ES_INIT commands.
> +The commands did not have any parameters (the ```data``` field was unused) and
> +only work for the KVM_X86_DEFAULT_VM machine type (0).
> +
> +They behave as if:
> +
> +* the VM type is KVM_X86_SEV_VM for KVM_SEV_INIT, or KVM_X86_SEV_ES_VM for
> +  KVM_SEV_ES_INIT
> +
> +* the ``flags`` field of ``struct kvm_sev_init`` is set to zero
> +
> +* the ``vmsa_features`` field of ``struct kvm_sev_init`` is set to all features
> +  supported by the hypervisor (as returned by ``KVM_GET_DEVICE_ATTR`` when
> +  passed group 0 and attribute id ``KVM_X86_SEV_VMSA_FEATURES``).
> +
> +If the ``KVM_X86_SEV_VMSA_FEATURES`` attribute does not exist, the hypervisor only
> +supports KVM_SEV_INIT and KVM_SEV_ES_INIT.  In that case the set of VMSA features is
> +undefined.

It's hard to imagine userspace implementation support for querying
KVM_X86_SEV_VMSA_FEATURES but still insisting on KVM_SEV_INIT. Maybe it
would be better to just lock in that VMSA_FEATURES at what is currently
supported: DEBUG_SWAP=on/off depending on the kvm_amd module param, and
then for all other features require opt-in via KVM_SEV_INIT2, and then
bake that into the documentation. That way way they could still reference
this documentation to properly calculate measurements for older/existing
VMM implementations.

-Mike

> +
>  2. KVM_SEV_LAUNCH_START
>  -----------------------
>  
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 7c46e96cfe62..6baf18335c7b 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -683,6 +683,9 @@ enum sev_cmd_id {
>  	/* Guest Migration Extension */
>  	KVM_SEV_SEND_CANCEL,
>  
> +	/* Second time is the charm; improved versions of the above ioctls.  */
> +	KVM_SEV_INIT2,
> +
>  	KVM_SEV_NR_MAX,
>  };
>  
> @@ -694,6 +697,13 @@ struct kvm_sev_cmd {
>  	__u32 sev_fd;
>  };
>  
> +struct kvm_sev_init {
> +	__u32 vm_type;
> +	__u32 flags;
> +	__u64 vmsa_features;
> +	__u32 pad[8];
> +};
> +
>  struct kvm_sev_launch_start {
>  	__u32 handle;
>  	__u32 policy;
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index acf5c45ef14e..78c52764453f 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -252,7 +252,9 @@ static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
>  	sev_decommission(handle);
>  }
>  
> -static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
> +			    struct kvm_sev_init *data,
> +			    unsigned long vm_type)
>  {
>  	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>  	int asid, ret;
> @@ -260,7 +262,10 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	if (kvm->created_vcpus)
>  		return -EINVAL;
>  
> -	if (kvm->arch.vm_type != KVM_X86_DEFAULT_VM)
> +	if (data->flags)
> +		return -EINVAL;
> +
> +	if (data->vmsa_features & ~sev_supported_vmsa_features)
>  		return -EINVAL;
>  
>  	ret = -EBUSY;
> @@ -268,8 +273,8 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  		return ret;
>  
>  	sev->active = true;
> -	sev->es_active = argp->id == KVM_SEV_ES_INIT;
> -	sev->vmsa_features = sev_supported_vmsa_features;
> +	sev->es_active = (vm_type & __KVM_X86_PROTECTED_STATE_TYPE) != 0;
> +	sev->vmsa_features = data->vmsa_features;
>  
>  	asid = sev_asid_new(sev);
>  	if (asid < 0)
> @@ -298,6 +303,38 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	return ret;
>  }
>  
> +static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +	struct kvm_sev_init data = {
> +		.vmsa_features = sev_supported_vmsa_features,
> +	};
> +	unsigned long vm_type;
> +
> +	if (kvm->arch.vm_type != KVM_X86_DEFAULT_VM)
> +		return -EINVAL;
> +
> +	vm_type = (argp->id == KVM_SEV_INIT ? KVM_X86_SEV_VM : KVM_X86_SEV_ES_VM);
> +	return __sev_guest_init(kvm, argp, &data, vm_type);
> +}
> +
> +static int sev_guest_init2(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_sev_init data;
> +
> +	if (!sev->need_init)
> +		return -EINVAL;
> +
> +	if (kvm->arch.vm_type != KVM_X86_SEV_VM &&
> +	    kvm->arch.vm_type != KVM_X86_SEV_ES_VM)
> +		return -EINVAL;
> +
> +	if (copy_from_user(&data, (void __user *)(uintptr_t)argp->data, sizeof(data)))
> +		return -EFAULT;
> +
> +	return __sev_guest_init(kvm, argp, &data, kvm->arch.vm_type);
> +}
> +
>  static int sev_bind_asid(struct kvm *kvm, unsigned int handle, int *error)
>  {
>  	struct sev_data_activate activate;
> @@ -1915,6 +1952,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>  	case KVM_SEV_INIT:
>  		r = sev_guest_init(kvm, &sev_cmd);
>  		break;
> +	case KVM_SEV_INIT2:
> +		r = sev_guest_init2(kvm, &sev_cmd);
> +		break;
>  	case KVM_SEV_LAUNCH_START:
>  		r = sev_launch_start(kvm, &sev_cmd);
>  		break;
> -- 
> 2.39.0
> 
> 

