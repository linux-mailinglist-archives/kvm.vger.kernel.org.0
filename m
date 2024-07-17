Return-Path: <kvm+bounces-21803-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A70F9344E9
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 00:50:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1F8F31F21C3D
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 22:50:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65CFD55886;
	Wed, 17 Jul 2024 22:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Kz++pQxV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2054.outbound.protection.outlook.com [40.107.243.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53ADB947E;
	Wed, 17 Jul 2024 22:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721256615; cv=fail; b=mxbO0tNFlQ0JpK0hf6NgGt0lJBA8TPXx+NH7YTEDrsh6+RpXeesa57ptch0rlAVWyE4hwYTr9Vdjmlip0q4V40kIeGHh3pw7bOr6nNz4ejkFqQSfTHZK8H4gDylbQouW7uxaFygTkym8qPVPw8HYZgN9JvnCmm1k+ATapPyzAos=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721256615; c=relaxed/simple;
	bh=YNzbKw7s9UTKRiPjUS9EZop+4R0u1w/eucOUVu6P3D4=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=egyr+k6i7NEI7MBWRfUkTEgn1vyJJueZetXIDwjmqrOB5tf9Yn0NMIhrUxAbTQRcHFrq9+gNK4JDl+AIoR5Jhv85rxMTd0Jka+xxPU88KHKSv2RzC2uQFX9jydyxcZQw70SuZceaEh1cp/cpBfhDHi51vHJZQKtcopw2DF9VnMo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Kz++pQxV; arc=fail smtp.client-ip=40.107.243.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YMPok1mHXNJoAxT8flLmJ/T6Nxhkt6+VVX0ilTXP0Rn32/d/mmiV01KIGKHffgLBdcWhWOhy//vbi8grikKTAq7n+ULBe1fCLUfV3e90+Q05xld+mXZE0yrHZOQqQEEOcnDQmxWW4LMGHfU99AbrNb247qR/XmRE5h5UZWidRadunKootiTWpNNc8vAbzhN0emH9yv6iZ4zlJEFjx+GZMjLxopqKAkbyKZqQ8T3vXqQJReOWWnyObiTLxxv+2U76G2Vij4mDctXOTU3cjSSgHU1h9ukcnAfIj1dmpNe0s8FSBvdjgtVF48aFYWfXu4df2khnAIB+Z75bNulc988pkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fg53AxYDX0iOnIqt/ufNAvpMpYldABsRxgRKd+FIG4Y=;
 b=o8N1AMO+kf6aRJ+dVbejprq5NLaHew49FUxWCwKmFADMZfbXk2RMVGqul2jgXYhaUlrZNUlFUwDyR0YNxUHjVaLFgtLJXQsZQ8ZyEiPNwhX+ReP8h+MCisHb6CVKP1UTjl5vfLLFUFtcePbP2lakcc4Eu2r6tS3tEmc0BSR6ENpjNhWX/Ysf9nz2U/UtScxypwmYjfboSKlc5PYlq2sK2KpLK9KMF+3x9DRwK0W81sjiscGgjxGAZpfl9bJ96ozVkBB3niIeCt4rLN9g3agFJ9Z9fxS2veQgIZX8oByo/+IgTGlMaoig7VYTF35onGjgPbbILSnrJNjsLPhQZfH7Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fg53AxYDX0iOnIqt/ufNAvpMpYldABsRxgRKd+FIG4Y=;
 b=Kz++pQxVFDp/KZsMQMylv5TRcIAihBOlBk/oSzeVPu8cIu5Xs2N27+gWwDncX2+g7jzO39KH7ikwWa8LNb0Krdsto/UmTTSzEJaVH4xvl5n7c0u5EiwP+nU5Fq2zP16LxRERzw4e8Oihlj0Rlg+tbIVRI0hTJFDq5gmnAS8IMc4=
Received: from SJ0PR03CA0018.namprd03.prod.outlook.com (2603:10b6:a03:33a::23)
 by MW4PR12MB5601.namprd12.prod.outlook.com (2603:10b6:303:168::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.16; Wed, 17 Jul
 2024 22:50:04 +0000
Received: from MWH0EPF000989E7.namprd02.prod.outlook.com
 (2603:10b6:a03:33a:cafe::1b) by SJ0PR03CA0018.outlook.office365.com
 (2603:10b6:a03:33a::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.17 via Frontend
 Transport; Wed, 17 Jul 2024 22:50:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000989E7.mail.protection.outlook.com (10.167.241.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7784.11 via Frontend Transport; Wed, 17 Jul 2024 22:50:03 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 17 Jul
 2024 17:50:02 -0500
Date: Wed, 17 Jul 2024 17:23:48 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <seanjc@google.com>
Subject: Re: [PATCH 10/12] KVM: cleanup and add shortcuts to
 kvm_range_has_memory_attributes()
Message-ID: <20240717222348.pau4yzeq6q5kkk2p@amd.com>
References: <20240711222755.57476-1-pbonzini@redhat.com>
 <20240711222755.57476-11-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240711222755.57476-11-pbonzini@redhat.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000989E7:EE_|MW4PR12MB5601:EE_
X-MS-Office365-Filtering-Correlation-Id: cd24d1a3-b7d0-478e-169c-08dca6b2cc22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jBLj1x+3rXC4MYpMM6ECpdtJ2Em8tTXRekn1mu+2LdqCQAUDKh9OIXxljKTJ?=
 =?us-ascii?Q?aAJDUBoM/JsLI0BDTylyRAVge1G5+Gg1fqeko89e6B2M4Wnakhht0YEJv2mV?=
 =?us-ascii?Q?gvS3R86u9LhH438t3uywXJHHWQZOG0fSOPad8u6okadrkUKplddLrNR8pv3p?=
 =?us-ascii?Q?yEDASoNz6Q6mJrWB31d1EtH4V/2zdj2ULw47Uw7tt6oM73aJPcAtPd5tRF9W?=
 =?us-ascii?Q?gLqx0WzQfGYwuQN/XaNphvPCMeKlDRX1GrFtCV2gYw8qyLAL2TSF8So+9fzW?=
 =?us-ascii?Q?KhLWBT2xI87fBy1R+r2W7/I0vbdFtpKXcPAJ2ojF3n7pAuoYe0djZE3O87I/?=
 =?us-ascii?Q?LGvwUANpfdTgTIOEKqTKcoEUGxamYMs7iQJNt7iZ3ZBw9T1GnH4aEJ0PDwal?=
 =?us-ascii?Q?zMDED40F/0fQ6SFfXagp6fVuG55rWziCz+diIarkBbl4ben20KOh+X8NkSy6?=
 =?us-ascii?Q?m9bB/BVFqdeZTaprAzXWi33rRDj22rXFd4jKRghBDID824qkGR5KfazmKzqK?=
 =?us-ascii?Q?JlwBkh20jVyKndxKprqEM3OuQDwi1saqj80kCXaaura/Ob9mJw4hYgN+MSl7?=
 =?us-ascii?Q?Fyrfl2ZY0wfZcHB2CsnuKLZGdtWDfYXt9tQalD/msFJHAohf9KMGtP62KHeH?=
 =?us-ascii?Q?l5cPb/vIPd8ECQZAri99OaM7qcjEVRsJXP43xGd+JrasqS+tCXaDlGIbPaCK?=
 =?us-ascii?Q?luY/Rsayd4BwrFxt7DksC/TJKXgcFoQrzVdrEVvAS3wux2H+xOBh09j7/3VG?=
 =?us-ascii?Q?k7G3bKuCorSdf8EuWpTGIdnxWr7oNaitFKsjSyeUorkWPgem4alddnrrPqDg?=
 =?us-ascii?Q?T9hsyEzmSL5DLcUafk4Psu+Dejb3JCkPrxsPT5IIrvAWjhVh6MjomYKCbUYx?=
 =?us-ascii?Q?5eftwInWLaDLkROhbgRXQd82rIgvov98AAAa2PBznCJCX2CUQYHwmHp5HESa?=
 =?us-ascii?Q?2jf7ysoBHkDTRyamnGnynR48E1bsSVDKY2bWJM7O+D2j5jrmIlDzJPEPiUea?=
 =?us-ascii?Q?tVgNyqs1+3bfApYWdQMQvpkeeqZj+6BSsv+iaa8y9OHLwA+jv2J0p+2Qe7mA?=
 =?us-ascii?Q?oSuxpEPQiEnIyxs2b510+WRJIZ2Zy1285xJZupwjoPsNy3C1Iimu/U1r/8Bo?=
 =?us-ascii?Q?0wDCMz0y9aQWIiC+OYA5vIocBm00MIu5oXzivoLhEVcjMJK/fSXf/XllOnzi?=
 =?us-ascii?Q?qV1dY/2i6cS+fGPyx7DMXsgVkDR2fBedfLAzaiffastvk8tA36N9CFOwaAZ+?=
 =?us-ascii?Q?eTdeV58pmRnnVPHBaW9FdOaYxTbU4p584b9CIdFWDU2gMfiKNbZSelPimSEC?=
 =?us-ascii?Q?fh4zrK15e1A+rvF+Pp8H1lD3grEK8rA/RYNL03WbmTLeTERv0NOaBopcUq5g?=
 =?us-ascii?Q?aH2MKC0As8Yc8aTx1oY7jbf83+O38s2qG8K9GaAoMgELGOsKC2/ElzbD9iSm?=
 =?us-ascii?Q?Ql8yLDTb/anAu6jTBcJjsoW/h08dNivl?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2024 22:50:03.7224
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cd24d1a3-b7d0-478e-169c-08dca6b2cc22
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000989E7.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5601

On Thu, Jul 11, 2024 at 06:27:53PM -0400, Paolo Bonzini wrote:
> Use a guard to simplify early returns, and add two more easy
> shortcuts.  If the requested attributes are invalid, the attributes
> xarray will never show them as set.  And if testing a single page,
> kvm_get_memory_attributes() is more efficient.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  virt/kvm/kvm_main.c | 42 ++++++++++++++++++++----------------------
>  1 file changed, 20 insertions(+), 22 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index f817ec66c85f..8ab9d8ff7b74 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2392,6 +2392,14 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
>  #endif /* CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT */
>  
>  #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
> +static u64 kvm_supported_mem_attributes(struct kvm *kvm)
> +{
> +	if (!kvm || kvm_arch_has_private_mem(kvm))
> +		return KVM_MEMORY_ATTRIBUTE_PRIVATE;
> +
> +	return 0;
> +}
> +
>  /*
>   * Returns true if _all_ gfns in the range [@start, @end) have attributes
>   * matching @attrs.
> @@ -2400,40 +2408,30 @@ bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
>  				     unsigned long attrs)
>  {
>  	XA_STATE(xas, &kvm->mem_attr_array, start);
> +	unsigned long mask = kvm_supported_mem_attributes(kvm);;

Extra semicolon.

Otherwise:

Reviewed-by: Michael Roth <michael.roth@amd.com>

