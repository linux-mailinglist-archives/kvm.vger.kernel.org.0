Return-Path: <kvm+bounces-21675-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E4D4931E06
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 02:15:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 44FDB1C203A2
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 00:15:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 430901103;
	Tue, 16 Jul 2024 00:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amd.com header.i=@amd.com header.b="A4VnDKTX"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2072.outbound.protection.outlook.com [40.107.93.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B815C63AE;
	Tue, 16 Jul 2024 00:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721088922; cv=fail; b=kW1JuSZFlGSjYd7z8BB/Ema0wWrERTfUOvLSUEL0WsngVRfy3jgJnXvHwwEydXmYYdhsjDSQALUCdYJ00ymCvZzkZLuz/9M8oa6A00OqhqbqO8+ySaErNR/n96DSXJ5mgyMK/8KLoK+WyVVPcbd436uE1oGicfcMQsMbcFfordw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721088922; c=relaxed/simple;
	bh=eHGMY5/OHG2RGMvnU780kuvnE2ug7WXBTaS30MKAPsc=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g6gI5wm2xd2E1R648NEXHKUhCygFbuRjeZZ6vmWEydeoO6zOo6ltGUOuEvnT68aOFRPnWuv3Fg0HoQ+gAxyGyFgOHwbLr0L4kcXQQVcQRHNwM0DdvlJoNqHv1XwH031PmE/81xL88R8RM+SLa5BZhjbIGBGknX6mHwp53d0tucc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=fail (1024-bit key) header.d=amd.com header.i=@amd.com header.b=A4VnDKTX reason="signature verification failed"; arc=fail smtp.client-ip=40.107.93.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Moz7SmgStQJpklqbyRE535liABTNp/aCb9tieXDB2DsqqXUbQeWc8bsP8IP5ue8Us02LYHRSimnnhJtVy+8uc13QXgU7b8UkCKNeIv7tvbPe/dJRHFO0hveP/e8WXrVVzO66d4erfyqRHbtIDFMfF2dIRTQyqf5HLeonTtsumifwbotfsDMhwT0wv8i6bulARyPKGAnQ8+4r1RIU/XfVyS+6OgYsk7QHQwTeDrZ60AaXl6fjNXIVznu/uMQ5uv7AMyOcNP6aGgLN8R/ceXVXp8BoV9wvaSfumEPlLhuSMAE4+mMPsFCHdhWeE3jpxMr1eLzAS9NHOl2wp+7vprJ5Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZC+ZIaaby4WmH6i7nkwpiHcauol7R4ttEHY9XKb+qC0=;
 b=RMBReoMxa7okQ1GSratqrwRi/vJYc5p8qP11D/SChoDsEpgQrh4FrFq45ecq9W3kDjBFHBbKGboW7RifP3hEPa3PiTOqfi6hjLliS/d55QH9KRcH8l/xenfh+3N365mLCJn6xJu7I36i5VkkfwIGOl3ygVRq+EsmpcWTgzRs0baCQFyFgAa9XlayaTwZ8z2bxVCR7ZNm5ovydPlYRCQZsboNHjN4Pt+o/hGKKg1F0Lzz17nfDHaJ3m7hnL7TXf/0tM5LjJNJNQiK+Lqgxz70VQ+plxidFq8DVwJg3V/Ic+QE3V5onHGZga4pBGy5QVv/zW8xSsEH643L2wu6dDOlJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZC+ZIaaby4WmH6i7nkwpiHcauol7R4ttEHY9XKb+qC0=;
 b=A4VnDKTXMWDB74qd0d4es0YgG8nvJTrSgWMX/DAxlCg/RpbekVvKAgP0cKN2rWQZ1O6eBOQxNU6he1VUma5WteIqm+sQRsjbZn1dSgAC/X7V7NTnuhQTH8/UV19bhmtxeejxvsJDuKUjJegGLD1f3MBz3AOniAYA734TH9nqTgA=
Received: from MN0P220CA0014.NAMP220.PROD.OUTLOOK.COM (2603:10b6:208:52e::6)
 by IA0PR12MB8895.namprd12.prod.outlook.com (2603:10b6:208:491::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.29; Tue, 16 Jul
 2024 00:15:18 +0000
Received: from BN3PEPF0000B077.namprd04.prod.outlook.com
 (2603:10b6:208:52e:cafe::96) by MN0P220CA0014.outlook.office365.com
 (2603:10b6:208:52e::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.29 via Frontend
 Transport; Tue, 16 Jul 2024 00:15:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B077.mail.protection.outlook.com (10.167.243.122) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7784.11 via Frontend Transport; Tue, 16 Jul 2024 00:15:17 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 15 Jul
 2024 19:15:16 -0500
Date: Mon, 15 Jul 2024 19:13:12 -0500
From: Michael Roth <michael.roth@amd.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>
Subject: Re: [PATCH 09/12] KVM: guest_memfd: move check for already-populated
 page to common code
Message-ID: <5tp5sjq7e4s7wrcri5i24ubnehfi2q2xx33cesv2m4s3tuuyq4@eo6l7feq6tv6>
References: <20240711222755.57476-1-pbonzini@redhat.com>
 <20240711222755.57476-10-pbonzini@redhat.com>
 <73c62e76d83fe4e5990b640582da933ff3862cb1.camel@intel.com>
 <CABgObfbhTYDcVWwB5G=aYpFhAW1FZ5i665VFbbGC0UC=4GgEqQ@mail.gmail.com>
 <97796c0b86db5d98e03c119032f5b173f0f5de14.camel@intel.com>
 <n2nmszmuok75wzylgcqy2dz4lbrvfavewuxas56angjrkp3sl3@k4pj5k7uosfe>
 <CABgObfa=a3cKcKJHQRrCs-3Ty8ppSRou=dhi6Q+KdZnom0Zegw@mail.gmail.com>
 <i4gor4ugezj5ma4l6rnfqanylw6qsvh6rvlqk72ezuadxq6dkn@yqgr5iq3dqed>
 <00f105e249b7def9f5631fb2b0fa699688ece4c2.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <00f105e249b7def9f5631fb2b0fa699688ece4c2.camel@intel.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B077:EE_|IA0PR12MB8895:EE_
X-MS-Office365-Filtering-Correlation-Id: edac93db-481b-4096-3942-08dca52c5f5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?E9miHKXXv2Ftu0aEGuFzJEkhnkhjEFh4J6EQIIroEsoalpqqOjom7QN9rt?=
 =?iso-8859-1?Q?PPviQbFLi5OKkuT53ULUDo58Ns+ST6Yo6WP1WfiYE2TjO0tabnzmnXQrIx?=
 =?iso-8859-1?Q?rxz29kqN+HIinBFWY+ckDOjSfmKniY30UlT2mlA9qavOFsTC6xHo0xSf3b?=
 =?iso-8859-1?Q?MPMrEkVR+TkTQcMT8Fs8l83aq1xmGGiF79vBLat8O3R/wU6xVV/C9QMtxV?=
 =?iso-8859-1?Q?z8VSGfoegS0BcCxVyMGM//wvxId+uiTK1pQR3e1xSsSXguOGTVtB4CSowo?=
 =?iso-8859-1?Q?83775ZrZ+bj293pz7RWKy1/BPc0uhVrd5PrhWd8B878ZQTvh+bqKrBa9Z/?=
 =?iso-8859-1?Q?vJXSo5qDO9eJvN0rDwUICYqjeYVKKAfvfzs92WEJ1w/kjJ55aIkqy/YP8N?=
 =?iso-8859-1?Q?DwMUFvi1vIOCbaZDvP3i9I83rpeSCYwLQOGl2Hts+HssrCpRt73vk8xtMq?=
 =?iso-8859-1?Q?aHanJa62pAe3Fdbb1O00iJhQmgLmE+0ud5B76owR5+t1pkBtnYttTgL3yj?=
 =?iso-8859-1?Q?KJhiBDgaPIgh17TVKyyhghh3ZQThI6TTKNoE/aOcEtRh0n1Kh4LYySifeE?=
 =?iso-8859-1?Q?GZz9Ud7bHfRkhEqsC6/xg3MULzozHGcvAzFad7iKx3LgzPgtLXbu8qDWFB?=
 =?iso-8859-1?Q?liW52TID9ZZ3r4HsDVPXnWCf8KZXy4ANA28ohbnc00IDJA1JViNN1dW6pP?=
 =?iso-8859-1?Q?RoyvOTeg3YuviUeViY0S19QGL4oARPIJUPN8YF+w//e8amNGmBweii7EBF?=
 =?iso-8859-1?Q?NrI+uHQ7hhCLcHtt3JuzFQKx7kuUF0FfIayN8ICMokxiBZyuWl0HvrJN2u?=
 =?iso-8859-1?Q?52+NYiowmJWcGthN7IPR9DQa3f+8kRxIwifeqdjbpbiqFL78scjpCXYGS3?=
 =?iso-8859-1?Q?BPuenEi1ZavzMEIKkYJy8Ymp8bZrJDMpUp0Ew9zXZnqaqlQC7VPgLNwkFK?=
 =?iso-8859-1?Q?TaHdNxAOHUyC2hJFu3Mf0dRhLs88and3xYwXjGc+QSDXZkKtiyOjAjBKSy?=
 =?iso-8859-1?Q?qheglAFfMafnfuVnaaHPwaIdOSwLZDBcmFM0l2KPsWV2J3JdHo48aYKca5?=
 =?iso-8859-1?Q?aPqiS1p8O2NTMo6dtelYwEKKWuIeoVL3DoNlcOR+GwVed6fujc6bue3XSC?=
 =?iso-8859-1?Q?orD2rjvYUPFLJypZaESuMfBEWd2J1jwKFLiKHHVzh4haOLwudXE+am1hg8?=
 =?iso-8859-1?Q?HB+Th+9liSBZheL43isfTa4Redj+bOaha33e5rNa30q15Soww6NA9ORJC6?=
 =?iso-8859-1?Q?3HaubMdmk89oDa9wmnu526EcttTV4Z/4ehacAjG3T7kqrKAkdCuEVLzoOX?=
 =?iso-8859-1?Q?C9PmWJIW305GPtFGa3VDyI2Lh3nkbUSvmNcrorjLqfDb17RBg2kQw1UXj4?=
 =?iso-8859-1?Q?IXP3KeD3IdqPEpA7X4qBGfkrKeyQnRjB+2AkXx7Mu4PeXjifazGI6HxyRQ?=
 =?iso-8859-1?Q?W9SKGjDmPKfIQ2+ieclhzoFJfQGb5J47U6MtOw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2024 00:15:17.6035
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: edac93db-481b-4096-3942-08dca52c5f5a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B077.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8895

On Mon, Jul 15, 2024 at 10:57:35PM +0000, Edgecombe, Rick P wrote:
> On Mon, 2024-07-15 at 16:47 -0500, Michael Roth wrote:
> > Makes sense.
> > 
> > If we document mutual exclusion between ranges touched by
> > gmem_populate() vs ranges touched by actual userspace issuance of
> > KVM_PRE_FAULT_MEMORY (and make sure nothing too crazy happens if users
> > don't abide by the documentation), then I think most problems go away...
> > 
> > But there is still at least one awkward constraint for SNP:
> > KVM_PRE_FAULT_MEMORY cannot be called for private GPA ranges until after
> > SNP_LAUNCH_START is called. This is true even if the GPA range is not
> > one of the ranges that will get passed to
> > gmem_populate()/SNP_LAUNCH_UPDATE. The reason for this is that when
> > binding the ASID to the SNP context as part of SNP_LAUNCH_START, firmware
> > will perform checks to make sure that ASID is not already being used in
> > the RMP table, and that check will fail if KVM_PRE_FAULT_MEMORY triggered
> > for a private page before calling SNP_LAUNCH_START.
> > 
> > So we have this constraint that KVM_PRE_FAULT_MEMORY can't be issued
> > before SNP_LAUNCH_START. So it makes me wonder if we should just broaden
> > that constraint and for now just disallow KVM_PRE_FAULT_MEMORY prior to
> > finalizing a guest, since it'll be easier to lift that restriction later
> > versus discovering some other sort of edge case and need to
> > retroactively place restrictions.
> > 
> > I've taken Isaku's original pre_fault_memory_test and added a new
> > x86-specific coco_pre_fault_memory_test to try to better document and
> > exercise these corner cases for SEV and SNP, but I'm hoping it could
> > also be useful for TDX (hence the generic name). These are based on
> > Pratik's initial SNP selftests (which are in turn based on kvm/queue +
> > these patches):
> > 
> >   https://github.com/mdroth/linux/commits/snp-uptodate0-kst/
> >  
> > https://github.com/mdroth/linux/commit/dd7d4b1983ceeb653132cfd54ad63f597db85f74
> > 
> > 
> 
> From the TDX side it wouldn't be horrible to not have to worry about userspace
> mucking around with the mirrored page tables in unexpected ways during the
> special period. TDX already has its own "finalized" state in kvm_tdx, is there
> something similar on the SEV side we could unify with?

Unfortunately there isn't currently anything in place like that for SNP,
but if we had a common 'finalized' field somewhere it could easily be set in
snp_launch_finish() as well.

> 
> I looked at moving from kvm_arch_vcpu_pre_fault_memory() to directly calling
> kvm_tdp_map_page(), so we could potentially put whatever check in
> kvm_arch_vcpu_pre_fault_memory(). It required a couple exports:

Thanks. I'll give this a spin for SNP as well.

-Mike

> 
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 03737f3aaeeb..9004ac597a85 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -277,6 +277,7 @@ extern bool tdp_mmu_enabled;
>  #endif
>  
>  int kvm_tdp_mmu_get_walk_mirror_pfn(struct kvm_vcpu *vcpu, u64 gpa, kvm_pfn_t
> *pfn);
> +int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8
> *level);
>  
>  static inline bool kvm_memslots_have_rmaps(struct kvm *kvm)
>  {
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 7bb6b17b455f..4a3e471ec9fe 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4721,8 +4721,7 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct
> kvm_page_fault *fault)
>         return direct_page_fault(vcpu, fault);
>  }
>  
> -static int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
> -                           u8 *level)
> +int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8
> *level)
>  {
>         int r;
>  
> @@ -4759,6 +4758,7 @@ static int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t
> gpa, u64 error_code,
>                 return -EIO;
>         }
>  }
> +EXPORT_SYMBOL_GPL(kvm_tdp_map_page);
>  
>  long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
>                                     struct kvm_pre_fault_memory *range)
> @@ -5770,6 +5770,7 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
>  out:
>         return r;
>  }
> +EXPORT_SYMBOL_GPL(kvm_mmu_load);
>  
>  void kvm_mmu_unload(struct kvm_vcpu *vcpu)
>  {
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 9ac0821eb44b..7161ef68f3da 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -2809,11 +2809,13 @@ struct tdx_gmem_post_populate_arg {
>  static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>                                   void __user *src, int order, void *_arg)
>  {
> +       u64 error_code = PFERR_GUEST_FINAL_MASK | PFERR_PRIVATE_ACCESS;
>         struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
>         struct tdx_gmem_post_populate_arg *arg = _arg;
>         struct kvm_vcpu *vcpu = arg->vcpu;
>         struct kvm_memory_slot *slot;
>         gpa_t gpa = gfn_to_gpa(gfn);
> +       u8 level = PG_LEVEL_4K;
>         struct page *page;
>         kvm_pfn_t mmu_pfn;
>         int ret, i;
> @@ -2832,6 +2834,10 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t
> gfn, kvm_pfn_t pfn,
>                 goto out_put_page;
>         }
>  
> +       ret = kvm_tdp_map_page(vcpu, gpa, error_code, &level);
> +       if (ret < 0)
> +               goto out_put_page;
> +
>         read_lock(&kvm->mmu_lock);
>  
>         ret = kvm_tdp_mmu_get_walk_mirror_pfn(vcpu, gpa, &mmu_pfn);
> @@ -2910,6 +2916,7 @@ static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu,
> struct kvm_tdx_cmd *c
>         mutex_lock(&kvm->slots_lock);
>         idx = srcu_read_lock(&kvm->srcu);
>  
> +       kvm_mmu_reload(vcpu);
>         ret = 0;
>         while (region.nr_pages) {
>                 if (signal_pending(current)) {
> 

