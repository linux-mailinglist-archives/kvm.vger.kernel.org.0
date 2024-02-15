Return-Path: <kvm+bounces-8725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 524DF8558BF
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 02:23:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 76D921C231D6
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 01:23:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6BFF1864;
	Thu, 15 Feb 2024 01:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="GWVQmokD"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2081.outbound.protection.outlook.com [40.107.93.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168211361;
	Thu, 15 Feb 2024 01:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707960162; cv=fail; b=p+g5PoPulZiKvF5EimnFhaA9xC34lscvMmTtxSxbi/9Iwi+Yz5fQMej88WqwQbVmcji11GW+lvL6l8cTZXQzZgtP/2o8kzk/r5GCQTvzWIx2uww9cc1wxoDjmCyT5OT8+8gRjrqEeve0grUjtKHN+oK8yZPCY9KI7mMZPdT2aK4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707960162; c=relaxed/simple;
	bh=MMz8cfPqaau6ZbeXY//zkrJwR9RntbLkMw7SGkzN7DM=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d9gVqPs7v53Mu61g8rt/0V1I9LoVgjHgy8t91r7iN4+6ZnohrDsh7UWff7ndY/k9yxzLfbw9SGn0v/wLscsAGqKhnraXpgHuUClo86zapg6z8YL3niXi/on4QYfPzLf9JbRRCwRGNs62guJM6f0y7G2Bh2x6wocoBgNz8edyX2M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=GWVQmokD; arc=fail smtp.client-ip=40.107.93.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D/zGgUYCox21JBe31Efzk/GW5XjrhzlazC9rCsZaQhpabqN6I/cMgKFUR8wZku1m4ls7fvkFn1Tdot8ysKIhU/kKkQmqMz0qU8i67S8ucljCW2yR4WNrDyeShoa6DkVEtDuL/gwWrOYk3aOJGjISx9xbSGhWz38UE0YYr3rASTU1gymj3ymOoqPVRr04Ry+F/sHNcjxg4REhcNlx6dKZP/dw4T82qJ6lu3nW82+nenUMxxJR6VEjfxZROqMXsFfuB7Pw8ZgkBIrVSZMsR0YYdXoll+bV0KdqDOmAnczgCcHZZZQ4mEVHisD5Y64eZApV6g7jYduBIPwpPy6La0MZ+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Mkhn6VH0D6dxBZjHW5RE8+RO3AG15oeAlBjVkoT5kE=;
 b=cfIo5LaQXwBEWYsls9fVXEkdHHCoT6NpJfT9Ljm9VvPQ0yS5Orc7QsKab4RL3pR27SvqMNUA7NpLxrxR+XX10d6asIEh9P4Q79SbIcqTmkOkKChMqpPZUDdEO4gIR/D0My2Dcf/SAwiUfiGI2JzULxrA/RMIPV1fTXlymfxBgaD+Zm9DL6Ej9bW53Mil++YbblKRkPlhb/b0O2GZ3jY9gCBwtS/SjIBF6WX3COiJWoukrgG7Mfa89hMk9eMKICCJoaDb53eKzYmrl4bIOrtiOX5dLIykJ0XuCDY0BPUGDIhSDGM1rvfCGL5l2RB/mI0+QgHxiGz/krbdm+H1UkYwaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Mkhn6VH0D6dxBZjHW5RE8+RO3AG15oeAlBjVkoT5kE=;
 b=GWVQmokD/dxwW4/dbTptS1PcP0vW7pWe4h06i6vwMuxewasyzebnSQvkff+Wbsfnt3wNicj8RvVnEPSB7TtzldW9Xe3tm66PWavbR+uxIHYHswUQXb+hLyv5itnKg+SIjgc0mQHaCm83ZvGSFcMlJszH/25o3Pb84fEr2iYcE44=
Received: from CH0PR03CA0097.namprd03.prod.outlook.com (2603:10b6:610:cd::12)
 by DM8PR12MB5430.namprd12.prod.outlook.com (2603:10b6:8:28::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7292.26; Thu, 15 Feb 2024 01:22:38 +0000
Received: from CH2PEPF000000A0.namprd02.prod.outlook.com
 (2603:10b6:610:cd:cafe::4a) by CH0PR03CA0097.outlook.office365.com
 (2603:10b6:610:cd::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.41 via Frontend
 Transport; Thu, 15 Feb 2024 01:22:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF000000A0.mail.protection.outlook.com (10.167.244.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7292.25 via Frontend Transport; Thu, 15 Feb 2024 01:22:38 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 14 Feb
 2024 19:22:37 -0600
Date: Wed, 14 Feb 2024 19:19:57 -0600
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<seanjc@google.com>, <aik@amd.com>, <isaku.yamahata@intel.com>
Subject: Re: [PATCH 08/10] KVM: SEV: define VM types for SEV and SEV-ES
Message-ID: <20240215011957.4bidufstf4mp5jij@amd.com>
References: <20240209183743.22030-1-pbonzini@redhat.com>
 <20240209183743.22030-9-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240209183743.22030-9-pbonzini@redhat.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF000000A0:EE_|DM8PR12MB5430:EE_
X-MS-Office365-Filtering-Correlation-Id: 467794c7-ce62-4cc1-93e2-08dc2dc498e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ONhHIsqQTK8FCVCBS4no8RcGpvuV04CsD6HVmZRQ64Xeg9P50cqIlLdS5ajzQauRPtVgP6W6DGsqolT0hkQ5oH1piBK58YyXKaPUMMrGiqt1YU0/c5BKjNeexfbiO576Dxl+9WcQx9RT/96KWu6TOGBUBn9j2wSXZIh63KN95cCMuId9WHLuyMCHihafTCKgZ4F2Z0T88DFTBlpy5Qm3eMtwsulEGCJAwszPDM3LIHmd7rJy+2UyrEqUo9M/ApouRLeiCevE0miBR3YRq07xBphIERDonlwslwXHGktKlVxCmXNjrf3NrAHv04bsvnicAVQlm2AZ6j6F0SGZkYG50M8K8sIjn93Lt9sXXgsFm6uMp0ODmi/KBQGlCEGsumRnmhP4CmMXWsrPL7q8l4BXG5lJ0Dnn97MXQE/FlW1GFDTIsf/P0rmCZ4KPuvpXehqACOdek9M2ir38XSf+bd/npmXPK/0S7we8q0xFNoW4c482utVRiQiDVAgX5QfRFEo+F7Ba7keijSMeCvmsgB1vGWkIyIGYuezgSD1n2/EnTLg0llzsys59cnHN8UliSB1gZ1Idg/kHbabXKHeJLhc1d5IwGcn8ktCBj8LLxVoiZjUP+HJ56FAJWjBqx19XyPaIuQFy+6h2Tc28fgS3ddXQIoBjJvQrsJ+pgA990l0d06w=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(136003)(346002)(376002)(39860400002)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(82310400011)(36860700004)(40470700004)(46966006)(478600001)(41300700001)(6666004)(8676002)(8936002)(44832011)(2906002)(4326008)(5660300002)(70586007)(54906003)(70206006)(316002)(6916009)(2616005)(83380400001)(86362001)(336012)(426003)(356005)(81166007)(26005)(1076003)(16526019)(82740400003)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2024 01:22:38.0746
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 467794c7-ce62-4cc1-93e2-08dc2dc498e1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF000000A0.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5430

On Fri, Feb 09, 2024 at 01:37:40PM -0500, Paolo Bonzini wrote:
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  Documentation/virt/kvm/api.rst  |  2 ++
>  arch/x86/include/uapi/asm/kvm.h |  2 ++
>  arch/x86/kvm/svm/sev.c          | 18 +++++++++++++++++-
>  arch/x86/kvm/svm/svm.c          | 11 +++++++++++
>  arch/x86/kvm/svm/svm.h          |  2 ++
>  arch/x86/kvm/x86.c              |  4 ++++
>  6 files changed, 38 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 3ec0b7a455a0..bf957bb70e4b 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -8790,6 +8790,8 @@ means the VM type with value @n is supported.  Possible values of @n are::
>  
>    #define KVM_X86_DEFAULT_VM	0
>    #define KVM_X86_SW_PROTECTED_VM	1
> +  #define KVM_X86_SEV_VM	8
> +  #define KVM_X86_SEV_ES_VM	10
>  
>  9. Known KVM API problems
>  =========================
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 6c74db23257e..7c46e96cfe62 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -854,5 +854,7 @@ struct kvm_hyperv_eventfd {
>  
>  #define KVM_X86_DEFAULT_VM	0
>  #define KVM_X86_SW_PROTECTED_VM	(KVM_X86_DEFAULT_VM | __KVM_X86_PRIVATE_MEM_TYPE)
> +#define KVM_X86_SEV_VM		8

Hmm... would it make sense to decouple the VM types and their associated
capabilities? Only bit 2 is left in the lower range after this, and using any
bits beyond TDX's bit 4 risks overflowing check_extension ioctl's 32-bit return
value. Maybe a separate lookup table instead?

> +#define KVM_X86_SEV_ES_VM	(KVM_X86_SEV_VM | __KVM_X86_PROTECTED_STATE_TYPE)
>  
>  #endif /* _ASM_X86_KVM_H */
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 712bfbc0028a..acf5c45ef14e 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -260,6 +260,9 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	if (kvm->created_vcpus)
>  		return -EINVAL;
>  
> +	if (kvm->arch.vm_type != KVM_X86_DEFAULT_VM)
> +		return -EINVAL;
> +
>  	ret = -EBUSY;
>  	if (unlikely(sev->active))
>  		return ret;
> @@ -279,6 +282,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  
>  	INIT_LIST_HEAD(&sev->regions_list);
>  	INIT_LIST_HEAD(&sev->mirror_vms);
> +	sev->need_init = false;
>  
>  	kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_SEV);
>  
> @@ -1814,7 +1818,8 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
>  	if (ret)
>  		goto out_fput;
>  
> -	if (sev_guest(kvm) || !sev_guest(source_kvm)) {
> +	if (kvm->arch.vm_type != source_kvm->arch.vm_type ||
> +	    sev_guest(kvm) || !sev_guest(source_kvm)) {
>  		ret = -EINVAL;
>  		goto out_unlock;
>  	}
> @@ -2135,6 +2140,7 @@ int sev_vm_copy_enc_context_from(struct kvm *kvm, unsigned int source_fd)
>  	mirror_sev->asid = source_sev->asid;
>  	mirror_sev->fd = source_sev->fd;
>  	mirror_sev->es_active = source_sev->es_active;
> +	mirror_sev->need_init = false;
>  	mirror_sev->handle = source_sev->handle;
>  	INIT_LIST_HEAD(&mirror_sev->regions_list);
>  	INIT_LIST_HEAD(&mirror_sev->mirror_vms);
> @@ -3192,3 +3198,13 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
>  
>  	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 1);
>  }
> +
> +bool sev_is_vm_type_supported(unsigned long type)
> +{
> +	if (type == KVM_X86_SEV_VM)
> +		return sev_enabled;
> +	if (type == KVM_X86_SEV_ES_VM)
> +		return sev_es_enabled;
> +
> +	return false;
> +}
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 392b9c2e2ce1..87541c84d07e 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4087,6 +4087,11 @@ static void svm_cancel_injection(struct kvm_vcpu *vcpu)
>  
>  static int svm_vcpu_pre_run(struct kvm_vcpu *vcpu)
>  {
> +	struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
> +
> +	if (sev->need_init)
> +		return -EINVAL;
> +
>  	return 1;
>  }
>  
> @@ -4888,6 +4893,11 @@ static void svm_vm_destroy(struct kvm *kvm)
>  
>  static int svm_vm_init(struct kvm *kvm)
>  {
> +	if (kvm->arch.vm_type) {
> +		struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +		sev->need_init = true;
> +	}
> +
>  	if (!pause_filter_count || !pause_filter_thresh)
>  		kvm->arch.pause_in_guest = true;
>  
> @@ -4914,6 +4924,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.vcpu_free = svm_vcpu_free,
>  	.vcpu_reset = svm_vcpu_reset,
>  
> +	.is_vm_type_supported = sev_is_vm_type_supported,
>  	.vm_size = sizeof(struct kvm_svm),
>  	.vm_init = svm_vm_init,
>  	.vm_destroy = svm_vm_destroy,
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 864c782eaa58..63be26d4a024 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -79,6 +79,7 @@ enum {
>  struct kvm_sev_info {
>  	bool active;		/* SEV enabled guest */
>  	bool es_active;		/* SEV-ES enabled guest */
> +	bool need_init;		/* waiting for SEV_INIT2 */

Seems like this should be a separate patch.

-Mike

>  	unsigned int asid;	/* ASID used for this guest */
>  	unsigned int handle;	/* SEV firmware handle */
>  	int fd;			/* SEV device fd */
> @@ -696,6 +697,7 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm);
>  void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
>  void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm, struct sev_es_save_area *hostsa);
>  void sev_es_unmap_ghcb(struct vcpu_svm *svm);
> +bool sev_is_vm_type_supported(unsigned long type);
>  
>  /* vmenter.S */
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c89ddaa1e09f..dfc66ee091a1 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4795,6 +4795,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  		r = BIT(KVM_X86_DEFAULT_VM);
>  		if (kvm_is_vm_type_supported(KVM_X86_SW_PROTECTED_VM))
>  			r |= BIT(KVM_X86_SW_PROTECTED_VM);
> +		if (kvm_is_vm_type_supported(KVM_X86_SEV_VM))
> +			r |= BIT(KVM_X86_SEV_VM);
> +		if (kvm_is_vm_type_supported(KVM_X86_SEV_ES_VM))
> +			r |= BIT(KVM_X86_SEV_ES_VM);
>  		break;
>  	default:
>  		break;
> -- 
> 2.39.0
> 
> 

