Return-Path: <kvm+bounces-8723-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 828408558BA
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 02:23:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3B073287952
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 01:22:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2BB863D9;
	Thu, 15 Feb 2024 01:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="43K0cSQk"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2088.outbound.protection.outlook.com [40.107.102.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10FC21C15;
	Thu, 15 Feb 2024 01:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707960121; cv=fail; b=GsARRoCmqlT+jde87QOg8Do8lsefLtl+9llA2YnhodHETrSnkM1QPeZv1P/0mz2ZOOjF62O6IuHwUaFq/Ewz1vBT5ID7i7OduzNc44pHyFc0of+4FKIW40ODStZUz5N+cqRx1RLXl6VBoTuxUaOAH8JEp/iTAP+OOg0Ukoz4i+8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707960121; c=relaxed/simple;
	bh=LB/+gOWg05rQQrRydmNh1NOpcKgBvf+g50ht1ww0K24=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KSgQf3VWkDSc8oY+UAvLxQkEj8rE47Y2byVF5ASS11fiU5A5Xcgyq6oWD7flQatsgAKINtGlAGZXaitp4tepWOOSNkxCMeEhUzG/QyrGuI2TP86rZ0t7QZZQDwkm12FBOl2AckXU/O3/jJIG72gvILUGL+6RXNVDoZgBPx4kNbw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=43K0cSQk; arc=fail smtp.client-ip=40.107.102.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B2zSPN5zScOGUQaLIIUg862yQOpUsZQxj9J5yM0acaKeXXGJMK/LgDaNIBgrcrDnGCMEJGV8h9qMMLdWrIsGIEzJ18c2Gx5OkiEGjTSOTS00g70n/r+FTCOuwPHaydjwuzdaxj5zlKa7C2GFKOHUNyefb317aYYiPOQQ43Tpqn8GkEq7Dke2AYyRExocA2QLATuekFCKvux7NlfDD8wp6H+YiOQeo0fku03hHagLEgRupCe64/YF+3k4HOb1/SSs5Vc5eQ7m1OLpgAF5F7pfNo1wZBVkcnogxJBjzyOG7Z46pPAmNWdHfMZjzWjOs2/73RRBDd1YcS0EFw2BDFEUVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nAf6RpACGXcuMkuQ3mFUoCCgeYHRpGgTWb228r5wRqI=;
 b=R5QPFWC41tgoZidbXY1ZoXYuHgAyCuckKuQFRrrIQSIc1CCPWEMxi5rIrsOd+6Xfn7Mzb9RxxRbi0CdwY8dxMNqOPEe5EP/P6ZRtB3Zp54NHaKKpHFnQRWmn7bhsV9uWuE9tKfoSjLdRmObKe7AYux29/w4DzqMm3WQeRgHKtzFjeGXN1tQXyPzn35P3GWWqSCgMwHpnf0rxr+Ige2yhByYI/gXMyxlJpq99iDtIVva0QdKh4P54wyvEMVzX/aw1cgJOaKOfX9P/40UxeiINiyPGdypV9cqM094PkBeBSkqEhJKRzFrWBMReowlQ78Vbt1BaOMCbNlWDaUQtcvalVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nAf6RpACGXcuMkuQ3mFUoCCgeYHRpGgTWb228r5wRqI=;
 b=43K0cSQktwxyINL+yy8lcD/rANv4qA5VkQtgh65q/2pdbEh+OjwcfkxWrK9WOXOumVGSSw242LHmQ6nSbiePbRlrHKVkh54Ox4omss7jy+umLzIEsjXmopDG6J3ex2VVxyHKSxI0HG/4+pd1Rhkl30xEMxamrwCfT7FKokA/vac=
Received: from CH0PR03CA0120.namprd03.prod.outlook.com (2603:10b6:610:cd::35)
 by DS0PR12MB6413.namprd12.prod.outlook.com (2603:10b6:8:ce::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.21; Thu, 15 Feb
 2024 01:21:56 +0000
Received: from CH2PEPF000000A0.namprd02.prod.outlook.com
 (2603:10b6:610:cd:cafe::54) by CH0PR03CA0120.outlook.office365.com
 (2603:10b6:610:cd::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.26 via Frontend
 Transport; Thu, 15 Feb 2024 01:21:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF000000A0.mail.protection.outlook.com (10.167.244.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7292.25 via Frontend Transport; Thu, 15 Feb 2024 01:21:56 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 14 Feb
 2024 19:21:56 -0600
Date: Wed, 14 Feb 2024 18:03:47 -0600
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<seanjc@google.com>, <aik@amd.com>, <isaku.yamahata@intel.com>
Subject: Re: [PATCH 05/10] KVM: SEV: store VMSA features in kvm_sev_info
Message-ID: <20240215000347.f2xtw3k3soqpd2c2@amd.com>
References: <20240209183743.22030-1-pbonzini@redhat.com>
 <20240209183743.22030-6-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240209183743.22030-6-pbonzini@redhat.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF000000A0:EE_|DS0PR12MB6413:EE_
X-MS-Office365-Filtering-Correlation-Id: 558d9a01-db68-4d97-0998-08dc2dc4803d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	G+VdkmjRcgTqNSrn93ihow+s8sj5xdYMqeP7vv4Noe/vg5o0WLo+Q5YFUBf15SsuIrfLUnf4f17w8jammZq0HmrlPNSXRT5s0NGWaWgG0y0tv8Qh+5LnbwJ/oEGaJt8cBOLmjfCp3l5ZfVBuNQnBjC0fEkoHLF+y4JDa8O4fWHghgUEv1NKt3iw3/J3zLcHACC7wiQy7yU53pH6aFw83jnV0PfWLP+xmtJ1/TADDlxoybTpwN0HeACKv+gJ5W9kcuZzYGyqXUq/CDCWV6uzssSM9OcnXD727/wdKSIeQVfJPK3d3XBRETBh9JhUeNTrTJ4gCu0WTYBTuhmy48GOZKC86kTFvP3l51Qni0cG1BBW+6fg1NjSsgLfIlFLOtJpnDMj1LZ1utlc6bzHNgpjjQf9D0biJENmWBL9ZvDrdyH4igJmveo6EYJUX0VI5KUvd4WTRKBQITgcAL/LTqDKPhRQJcT2favbG4pZINOZXxrLghpGH1LNWIhgUmhvrzs8xMitp8Zcg/cgKuhZj8GiGIM1bntDwYkFjokqa1Z95j2X5bBbriGaJt70WJvpm8U9w9xiaYH6fMiId+b3+ZgPh+8CRfxhAb0kkkF0l8qIl/lx9AW6M13mGX1RlNJ1BnEimBxjJEdPV0fT59lIyaAJtvw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(136003)(396003)(376002)(39860400002)(230922051799003)(451199024)(64100799003)(82310400011)(1800799012)(186009)(36860700004)(40470700004)(46966006)(86362001)(356005)(83380400001)(82740400003)(336012)(70586007)(478600001)(81166007)(70206006)(1076003)(316002)(426003)(6666004)(6916009)(54906003)(16526019)(36756003)(26005)(2616005)(4326008)(41300700001)(8936002)(8676002)(5660300002)(2906002)(44832011);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2024 01:21:56.7154
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 558d9a01-db68-4d97-0998-08dc2dc4803d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF000000A0.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6413

On Fri, Feb 09, 2024 at 01:37:37PM -0500, Paolo Bonzini wrote:
> Right now, the set of features that are stored in the VMSA upon
> initialization is fixed and depends on the module parameters for
> kvm-amd.ko.  However, the hypervisor cannot really change it at will
> because the feature word has to match between the hypervisor and whatever
> computes a measurement of the VMSA for attestation purposes.
> 
> Add a field to kvm_set_info that holds the set of features to be stored

s/kvm_set_info_/kvm_sev_info/

Otherwise:

Reviewed-by: Michael Roth <michael.roth@amd.com>

> in the VMSA; and query it instead of referring to the module parameters.
> 
> Because KVM_SEV_INIT and KVM_SEV_ES_INIT accept no parameters, this
> does not yet introduce any functional change, but it paves the way for
> an API that allows customization of the features per-VM.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/svm/sev.c | 22 ++++++++++++++++++----
>  arch/x86/kvm/svm/svm.c |  2 +-
>  arch/x86/kvm/svm/svm.h |  3 ++-
>  3 files changed, 21 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 2e558f7538c2..712bfbc0028a 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -116,6 +116,14 @@ static inline bool is_mirroring_enc_context(struct kvm *kvm)
>  	return !!to_kvm_svm(kvm)->sev_info.enc_context_owner;
>  }
> 
> +static bool sev_vcpu_has_debug_swap(struct vcpu_svm *svm)
> +{
> +	struct kvm_vcpu *vcpu = &svm->vcpu;
> +	struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
> +
> +	return sev->vmsa_features & SVM_SEV_FEAT_DEBUG_SWAP;
> +}
> +
>  /* Must be called with the sev_bitmap_lock held */
>  static bool __sev_recycle_asids(int min_asid, int max_asid)
>  {
> @@ -258,6 +266,8 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
> 
>  	sev->active = true;
>  	sev->es_active = argp->id == KVM_SEV_ES_INIT;
> +	sev->vmsa_features = sev_supported_vmsa_features;
> +
>  	asid = sev_asid_new(sev);
>  	if (asid < 0)
>  		goto e_no_asid;
> @@ -278,6 +288,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	sev_asid_free(sev);
>  	sev->asid = 0;
>  e_no_asid:
> +	sev->vmsa_features = 0;
>  	sev->es_active = false;
>  	sev->active = false;
>  	return ret;
> @@ -572,6 +583,8 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
> 
>  static int sev_es_sync_vmsa(struct vcpu_svm *svm)
>  {
> +	struct kvm_vcpu *vcpu = &svm->vcpu;
> +	struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
>  	struct sev_es_save_area *save = svm->sev_es.vmsa;
> 
>  	/* Check some debug related fields before encrypting the VMSA */
> @@ -613,7 +626,7 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
>  	save->xss  = svm->vcpu.arch.ia32_xss;
>  	save->dr6  = svm->vcpu.arch.dr6;
> 
> -	save->sev_features = sev_supported_vmsa_features;
> +	save->sev_features = sev->vmsa_features;
> 
>  	pr_debug("Virtual Machine Save Area (VMSA):\n");
>  	print_hex_dump_debug("", DUMP_PREFIX_NONE, 16, 1, save, sizeof(*save), false);
> @@ -1693,6 +1706,7 @@ static void sev_migrate_from(struct kvm *dst_kvm, struct kvm *src_kvm)
>  	dst->pages_locked = src->pages_locked;
>  	dst->enc_context_owner = src->enc_context_owner;
>  	dst->es_active = src->es_active;
> +	dst->vmsa_features = src->vmsa_features;
> 
>  	src->asid = 0;
>  	src->active = false;
> @@ -3063,7 +3077,7 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
>  	svm_set_intercept(svm, TRAP_CR8_WRITE);
> 
>  	vmcb->control.intercepts[INTERCEPT_DR] = 0;
> -	if (!sev_es_debug_swap_enabled) {
> +	if (!sev_vcpu_has_debug_swap(svm)) {
>  		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
>  		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
>  		recalc_intercepts(svm);
> @@ -3118,7 +3132,7 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm)
>  					    sev_enc_bit));
>  }
> 
> -void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
> +void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm, struct sev_es_save_area *hostsa)
>  {
>  	/*
>  	 * All host state for SEV-ES guests is categorized into three swap types
> @@ -3146,7 +3160,7 @@ void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
>  	 * the CPU (Type-B). If DebugSwap is disabled/unsupported, the CPU both
>  	 * saves and loads debug registers (Type-A).
>  	 */
> -	if (sev_es_debug_swap_enabled) {
> +	if (sev_vcpu_has_debug_swap(svm)) {
>  		hostsa->dr0 = native_get_debugreg(0);
>  		hostsa->dr1 = native_get_debugreg(1);
>  		hostsa->dr2 = native_get_debugreg(2);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index aa1792f402ab..392b9c2e2ce1 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1523,7 +1523,7 @@ static void svm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
>  		struct sev_es_save_area *hostsa;
>  		hostsa = (struct sev_es_save_area *)(page_address(sd->save_area) + 0x400);
> 
> -		sev_es_prepare_switch_to_guest(hostsa);
> +		sev_es_prepare_switch_to_guest(svm, hostsa);
>  	}
> 
>  	if (tsc_scaling)
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index d630026b23b0..864c782eaa58 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -85,6 +85,7 @@ struct kvm_sev_info {
>  	unsigned long pages_locked; /* Number of pages locked */
>  	struct list_head regions_list;  /* List of registered regions */
>  	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
> +	u64 vmsa_features;
>  	struct kvm *enc_context_owner; /* Owner of copied encryption context */
>  	struct list_head mirror_vms; /* List of VMs mirroring */
>  	struct list_head mirror_entry; /* Use as a list entry of mirrors */
> @@ -693,7 +694,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu);
>  int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
>  void sev_es_vcpu_reset(struct vcpu_svm *svm);
>  void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
> -void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa);
> +void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm, struct sev_es_save_area *hostsa);
>  void sev_es_unmap_ghcb(struct vcpu_svm *svm);
> 
>  /* vmenter.S */
> -- 
> 2.39.0
> 
> 
> 

