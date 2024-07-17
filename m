Return-Path: <kvm+bounces-21796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E9939934449
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 23:54:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A0531283416
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 21:54:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49AEC188CA9;
	Wed, 17 Jul 2024 21:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ckhdnhT2"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2072.outbound.protection.outlook.com [40.107.220.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40F918509D;
	Wed, 17 Jul 2024 21:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721253285; cv=fail; b=F1murSh2VJ4h0lNFFDKVpGXzaBMTlwJMqei8Jl3cmoiBYLd1r4LnRu5mClYWbwKUB/H19RqAwdH9XSXOhJrkrXGaV/tJri/CVr1DAYLJWffDT7ex6j3j3mkliT7iCPdKYBRytZQhixit3Y4opWpXw6yrYHOTas8tsMXrEDDuKlo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721253285; c=relaxed/simple;
	bh=n6yHDiKXxvzB2MgO8DV0c9zvWhHiOkgYmSXsDmvfrfQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ScsENQ6+lbVzPiDX9I94SyQxJ5OE5a0D+nU4+uWh1+8bksOiAnd53VWk9lrRpsI4REzn8Mo/J5mDalCFdXxCc0h19fcE0o2moHtaL2biYA4oaDyxN+Gm1mcEx3kwBGCCatQA56t1mcfGq3Psw9nSY+Po+uV1CCoEZVam+GBoIUk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ckhdnhT2; arc=fail smtp.client-ip=40.107.220.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zLN1Ofbvwc99DsWf5N++ogxUo/SltoPX9WfiWBi/ZgHWNGoBbEp7m4u/voGGx1mfUnH9eUeXQhZSBES/qQ9mPyCyVXZNxGns8y5w/R8vIQ8Fwxq9nwwCrEaf0r/Le04kAOlZPQqjHTb7ZHBU9dzvi2OqnW622bk8VhSfSNFnOADOH+pwuEECC1xFrc/lN9xNuke+VCwIEJK0/8tnMgNXJQtqryyqWA0rfDtGWZR6jGMnqmM8bj+8A8ybGq38ze+vvR8vZAOesr7LzuyINir5SQ5aVSYGTnx79QAsTgsHukmWI6ghzhhtr4lLH+DI/OCDvVQw0hnRAbMGgyWu4ClkQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PqcIOsnmRazqtlKuqlNv7RxfDQOIO5SC3viGWntFP4c=;
 b=i4kAgrDLIAf1+RMDgM8fX5Dms6ENGVQxkoufj+jfQ4YGuL8gJwZpnqrTwCXkCZ5Bpdbi+1TM564tFgdJGCDOszYTWz6YHx/QGoZeHuyZdqiU73OEqJgshgB2TDUfSgvYn+k1KT5PQGZZ8ATzLvgYzRCRNiAIc1Abu3EkRwqbAp/AiPw22Twgh5hs6pczaDjrv/RugI2VQ2IW7kbH9waiOz1I/jhDW26jyHpKedaw6ordZBr4XpkNxG21JRtevvzBZRQJ8eNyW73wjDwCYIjX2zafYs3xm5lwVygi/vfStBRb12NfdUlgncbuzfp5j/eHoQitk03vapuoufWAj8OB4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PqcIOsnmRazqtlKuqlNv7RxfDQOIO5SC3viGWntFP4c=;
 b=ckhdnhT2PS4C3elEreamySoox1djl+Nj1uJF0XZP5LsUDeWcaVdleJSA4tFUfpbnm+OMStL5Epm8FIvhl5OHr8KalqmqnLXMIzLR3mozTpbVvsZNZa0PIVQxKRT4W9uqn99R99YiwzQfMHG42h1f+QNmLGCpd2BjIphtUXBn5/8=
Received: from CH2PR18CA0018.namprd18.prod.outlook.com (2603:10b6:610:4f::28)
 by BY5PR12MB4051.namprd12.prod.outlook.com (2603:10b6:a03:20c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.15; Wed, 17 Jul
 2024 21:54:39 +0000
Received: from CH2PEPF00000148.namprd02.prod.outlook.com
 (2603:10b6:610:4f:cafe::f3) by CH2PR18CA0018.outlook.office365.com
 (2603:10b6:610:4f::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.23 via Frontend
 Transport; Wed, 17 Jul 2024 21:54:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF00000148.mail.protection.outlook.com (10.167.244.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7784.11 via Frontend Transport; Wed, 17 Jul 2024 21:54:39 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 17 Jul
 2024 16:54:38 -0500
Date: Wed, 17 Jul 2024 16:42:38 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <seanjc@google.com>
Subject: Re: [PATCH 08/12] KVM: remove kvm_arch_gmem_prepare_needed()
Message-ID: <20240717214238.7qsws5ppqkdwtzqp@amd.com>
References: <20240711222755.57476-1-pbonzini@redhat.com>
 <20240711222755.57476-9-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240711222755.57476-9-pbonzini@redhat.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000148:EE_|BY5PR12MB4051:EE_
X-MS-Office365-Filtering-Correlation-Id: c090015b-bbaa-4443-76c5-08dca6ab0ea2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?v/y5mcEgvxoKq9lXgXj/bdFAcCOg+M63TpPc8T4yODMNbFVb12g07sphGzb0?=
 =?us-ascii?Q?mb04BztFKN2ovAoyZKydQzVDjJfFoZ3lCpRdj3ZRdMfQo8MlNFKaomWUQ0sN?=
 =?us-ascii?Q?9r0oVSMbjPQMRp2pXWps2Jo9ir9XLK2ZPEcM7IxpCVJdVnPkazIK1OWQWCho?=
 =?us-ascii?Q?LjDVfgq4P3OpHfDyEfTyzaGjenpnxvYv7F8g2/rZxs9/R85CZjGvOqLfh3jz?=
 =?us-ascii?Q?vTwUCjBTsEKxb3IANOBGuc/akq1ow979Ixx69MQZOb+VtI1LsQzet7jbNlww?=
 =?us-ascii?Q?dK8ORtWiv8VVI19/4w+kH16xQ7MPdJCa3ppQWGlda/sSx5yUMxSh6xMMDMeR?=
 =?us-ascii?Q?d7/LcS8Gid7/wIchsuL5oxp0jVKc3kUp2Yq7vpsxHWc0lz2ucFd9o1wKQlrD?=
 =?us-ascii?Q?IuvWoBhrYN0z5yo/kv68nxyESDynOSTW4I3/gbvEcbq8lTmngeNf3REm0RX9?=
 =?us-ascii?Q?56CK2v92IM+u5TPP9CISVJfj0ru0HCB731Y7wEpuSydBNNq4IH4i/G8uGmUT?=
 =?us-ascii?Q?IqnWSEhiPv1xUucuk7BXsWKhroeVLGv8/AsZBxw0DjvJJJgz9s+ImLkguH/s?=
 =?us-ascii?Q?MaEyqQPGHr877d1ZAtyQ/yHslt4VtvMHtv5h6LIG8mdMRPgEu/25Dyt25qZV?=
 =?us-ascii?Q?+hbArT+FsL7RQdA8XZE9Kw29ywQktNdg0ohnGkKK+c4AtlbvpSfZchGGhiYR?=
 =?us-ascii?Q?TTxYoYDdfrAi0oVUtc5U88UNgA+bY1TLB+M25KiG1duWDvAO7ToXnb9nU9/6?=
 =?us-ascii?Q?wPHoNoxUNqcRjCRTbSBYX7BAY2RTbcSfjJZItiAOSD+ttOWTlBBJCVjsgpGx?=
 =?us-ascii?Q?0qwNwvvbFM/iUiB7SBdGa2dKMvhvWq30OPq8FuV7K+DP4430KsyttR9AXkMJ?=
 =?us-ascii?Q?lc6QhFPPPj5jZ/fhoyujTczNjvxf4pbxcDNFA5D6UA1Q1twdzL+sObPjJhGj?=
 =?us-ascii?Q?KFBe1RezfLHNjLOBLNOSE+vIZD1pit05DVKlucK9NEYIRFZrrVSYt84sq8Mi?=
 =?us-ascii?Q?VEJcyELzxryJ4Fd8WsavAfS7dckCEfbYCHzXYZr0n6uqprH8USRS0nqdOmxl?=
 =?us-ascii?Q?9ItKo/deUZNp70eUr83/Ss3IembGdEbwj7KpG3T+lRTQLB5jqyVTX/emgEsw?=
 =?us-ascii?Q?Lrt2/WYzRQgKN6cpupIeIAyOy60j5wbWU5d1XbWH8zt80QSunIlL0jX9JChD?=
 =?us-ascii?Q?H4b35KjMlR3Ix6ZbxnEHDNLA2nLdaVucrVU6K/oPNVfBsiQZNOGQs9Fhz3K+?=
 =?us-ascii?Q?eyXa5wEJYm6OqKNKzUmv2TsvxuPuwIo+JA54FnaVfIfChnnuw+IQllaZ3+U4?=
 =?us-ascii?Q?rTalkbokgj8CoNjCXjq86ElBts1hbMMc/aiRppsNhxhRpF4UELPTY9f0h65U?=
 =?us-ascii?Q?fi98JEhRg7xDlBtmbLKSM4AoZU+mP1cIDpXT/zYZp79Z8wIar/yyA+iIhERp?=
 =?us-ascii?Q?CGR0nIMe7UBQ8jYmBQoCNfV56nmJfhvy?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2024 21:54:39.3976
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c090015b-bbaa-4443-76c5-08dca6ab0ea2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000148.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4051

On Thu, Jul 11, 2024 at 06:27:51PM -0400, Paolo Bonzini wrote:
> It is enough to return 0 if a guest need not do any preparation.
> This is in fact how sev_gmem_prepare() works for non-SNP guests,
> and it extends naturally to Intel hosts: the x86 callback for
> gmem_prepare is optional and returns 0 if not defined.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c       |  5 -----
>  include/linux/kvm_host.h |  1 -
>  virt/kvm/guest_memfd.c   | 13 +++----------
>  3 files changed, 3 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a1c85591f92c..4f58423c6148 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -13604,11 +13604,6 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
>  EXPORT_SYMBOL_GPL(kvm_arch_no_poll);
>  
>  #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_PREPARE
> -bool kvm_arch_gmem_prepare_needed(struct kvm *kvm)
> -{
> -	return kvm->arch.vm_type == KVM_X86_SNP_VM;
> -}
> -
>  int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_order)
>  {
>  	return static_call(kvm_x86_gmem_prepare)(kvm, pfn, gfn, max_order);
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index eb8404e9aa03..f6e11991442d 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2443,7 +2443,6 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
>  
>  #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_PREPARE
>  int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_order);
> -bool kvm_arch_gmem_prepare_needed(struct kvm *kvm);
>  #endif
>  
>  /**
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index f4d82719ec19..509360eefea5 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -29,16 +29,9 @@ static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slo
>  				    pgoff_t index, struct folio *folio)
>  {
>  #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_PREPARE
> -	kvm_pfn_t pfn;
> -	gfn_t gfn;
> -	int rc;
> -
> -	if (!kvm_arch_gmem_prepare_needed(kvm))
> -		return 0;
> -
> -	pfn = folio_file_pfn(folio, index);
> -	gfn = slot->base_gfn + index - slot->gmem.pgoff;
> -	rc = kvm_arch_gmem_prepare(kvm, gfn, pfn, folio_order(folio));
> +	kvm_pfn_t pfn = folio_file_pfn(folio, index);
> +	gfn_t gfn = slot->base_gfn + index - slot->gmem.pgoff;
> +	int rc = kvm_arch_gmem_prepare(kvm, gfn, pfn, folio_order(folio));

Looks like this hunk was meant to be part of a different patch.

Otherwise:

Reviewed-by: Michael Roth <michael.roth@amd.com>

-Mike

>  	if (rc) {
>  		pr_warn_ratelimited("gmem: Failed to prepare folio for index %lx GFN %llx PFN %llx error %d.\n",
>  				    index, gfn, pfn, rc);
> -- 
> 2.43.0
> 
> 
> 

