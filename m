Return-Path: <kvm+bounces-12142-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C0C287FEFE
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 14:42:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 18338B24B61
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 13:42:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A2D38060A;
	Tue, 19 Mar 2024 13:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KCnALScf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2049.outbound.protection.outlook.com [40.107.244.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788548004F;
	Tue, 19 Mar 2024 13:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710855761; cv=fail; b=Fw4j3tFiwzNSqXEdQd8NRswHSEODjD/r+3lRbBm9jDL2Rpoh1T8ulZjluQAbSthX8ajYZumz/uaWe9BHSd7u/Q9WuoVzbsCXfOi8Cuig13NOz9UwQt+dlU4bUBgDcAfo6OcSDPyKTQZ36c4YIrWdNDIU/8KhzHBKirF2pq8zrlg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710855761; c=relaxed/simple;
	bh=shCkLJOM0r/jTvQoNFLIBEDNP5L7Yiah5m2af36FRn0=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aY1lqPS6UW2LSUbJAAcARK+VPaOPRMr6O1gaJ55MXfz3jp5hH8situsf0c9CpkDUmw80YWyx097MP0tECTVD/pA2o50WGaIPx6UJbkH2obFarVdIhSaF5XA71HWfpIfe7mUnDRrBOJwz/FhjGdRiVpWJI3M5HO7MIOOVfivKBRI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KCnALScf; arc=fail smtp.client-ip=40.107.244.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BAlohNwekp4gueBnCoqYlDiE8GPH7TD/9lpbz2+pBiAUWUeGMBcHst7wmj4tp9JiBvCFIyfLeb4zixvFQVVEw4QHqXK8KeeoqmVa/Vsc6rTyqsp1fdE7sXDRPhY/bU3fSlttyjwWbTHUzOuBYFglRAfxy2KhIDQ9xlIzAjYHN7M+p8TIGZE/7KSKw5sP1gh2UYUkgZAOqOAN+WaKBGzXlqto4+RCIP3XHjpPMq9PO48NdSmdcNrh2wg+utGSEpyFUSb3cI+t32/f8frb2B39maggy/CZZp46MfJBkq6Lgl08qY8oHn5tYTrMd0IS/pCQlCK3siLNiYZNZcyvr5O+wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TE4MleOWZ+7YHedAEqbKhFO3BCPTbI7uAmUr6d1gOZ8=;
 b=M+Dczfln2JyjJzLVwdAoZ9gFjiwlumR019jU0Z8ZKms+8E9hmAFxhaACKKmuCP0UNp7SXxMq2VB39yFoY/Rg/NRkA2HuTm3uHZ6zElcUjsn8tzERnRtOW+VNg4MvlKX0BC0kGKoiXt/keUQ5sE+N8KKaUx91JpTiGCksO68ooTP8N2R+NXmlXeWaPMIcfSzQrZlSASDbRluLUC2Za4DL6n4aqRLA92OAnf+rGSamVCZ6D3wvwZv3io2icT4gRATi92LY2Lkw9dozE9nK6R46149LZU1wUAz8vi4+z0bhiQygPb966Cpo2MZSZvvxdW4nv27dDvYa4VJaIrVksTR1FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TE4MleOWZ+7YHedAEqbKhFO3BCPTbI7uAmUr6d1gOZ8=;
 b=KCnALScfHWT7RkXGRBBE3AFn7Xb1hcmA5e12Cvt7sDLep//+bF2+vRxak0HFYsKbCbM5iSv71VqtSufSLhXPMfIme65jdDvmIR8f4UZxg6Gnjc4Dk0m6s4aS9Oa4QRa22xRq8loqI/Ay33FYqGxnH+3xByTFNbftwf59gfSzctI=
Received: from DM6PR13CA0016.namprd13.prod.outlook.com (2603:10b6:5:bc::29) by
 SJ2PR12MB8954.namprd12.prod.outlook.com (2603:10b6:a03:541::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7386.26; Tue, 19 Mar 2024 13:42:37 +0000
Received: from DS1PEPF0001709B.namprd05.prod.outlook.com
 (2603:10b6:5:bc:cafe::30) by DM6PR13CA0016.outlook.office365.com
 (2603:10b6:5:bc::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.11 via Frontend
 Transport; Tue, 19 Mar 2024 13:42:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0001709B.mail.protection.outlook.com (10.167.18.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Tue, 19 Mar 2024 13:42:37 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 19 Mar
 2024 08:42:36 -0500
Date: Tue, 19 Mar 2024 08:42:19 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<isaku.yamahata@intel.com>, <seanjc@google.com>, Dave Hansen
	<dave.hansen@linux.intel.com>
Subject: Re: [PATCH v4 09/15] KVM: SEV: sync FPU and AVX state at
 LAUNCH_UPDATE_VMSA time
Message-ID: <20240319134219.evphel2bmyopdz75@amd.com>
References: <20240318233352.2728327-1-pbonzini@redhat.com>
 <20240318233352.2728327-10-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240318233352.2728327-10-pbonzini@redhat.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0001709B:EE_|SJ2PR12MB8954:EE_
X-MS-Office365-Filtering-Correlation-Id: 467fc3a0-6bd1-46ad-fe31-08dc481a7081
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	d4sP/oVARyXSXReeDx1dzBdOs/1rX1MtyCGZHgbH+bR6mPWmrsuj8jfzDn1HPoPYvmiqB4benmgnnBzpcHEqjXWfA2ChXyae53MKv5oYR9yYPOt/tRLnLGSLCZItNK3gcFa5RmfQNCf8kb3uivdhs+3HsJGPhTK/1vEUA3Jy/IHrzk1z8HQoY454kKIiKXYoaNQFDx/I/zJL3TAPDnyViHEAKvfw7R71BJFbeeeZFbjkAHUuWTlrwY5geeHCXINkVvJEEotFdJ/HQ3SBAyCWnZhoGperTaM4oVgb3hFmuhldrq+ocKv94+Q3JdsfPAkuAh6o85l47VSq5+M7DFALElqlxg21+HpRrQXm/zYuAevG+0B4OwV8bv9nXFJ78XrC2yonvQMVjxFiJMnExtYFBAZHwp0RrozfcyUR/CdkqozMI4RW+jplQbwD/Qs/Jidp+U54SEdsCGWottWrXmCaqj0ZR25oTbAQdg+VfEH/SD+jlZEO3NWsJGTutEB0rGhzSfSddG2w7qce6JuZg+hrtLUZ8MtFBiph3nZ6m4sYgnzBNKogw2m07dGeTuXiPyPhZgVGVaZPh3qD2UNqrTVauvDXJtjYkPtVsF24/EbnPwhQLrRlY3+Tpn6+S0GTaq5wyDG+jFmTrZTgzgEKY3HfxXEpto6BELMWXPfkmB9uSoh5I9UT1TSsTOb3ARWLL0nqTofhPVeRg+692ndHPgx1cHtCoQ07wrhCzJQvzTCrnRTRcoQZAghUYWIyx/o12D5I
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(1800799015)(82310400014)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2024 13:42:37.2747
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 467fc3a0-6bd1-46ad-fe31-08dc481a7081
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF0001709B.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8954

On Mon, Mar 18, 2024 at 07:33:46PM -0400, Paolo Bonzini wrote:
> SEV-ES allows passing custom contents for x87, SSE and AVX state into the VMSA.
> Allow userspace to do that with the usual KVM_SET_XSAVE API and only mark
> FPU contents as confidential after it has been copied and encrypted into
> the VMSA.
> 
> Since the XSAVE state for AVX is the first, it does not need the
> compacted-state handling of get_xsave_addr().  However, there are other
> parts of XSAVE state in the VMSA that currently are not handled, and
> the validation logic of get_xsave_addr() is pointless to duplicate
> in KVM, so move get_xsave_addr() to public FPU API; it is really just
> a facility to operate on XSAVE state and does not expose any internal
> details of arch/x86/kernel/fpu.
> 
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/fpu/api.h |  3 +++
>  arch/x86/kernel/fpu/xstate.h   |  2 --
>  arch/x86/kvm/svm/sev.c         | 36 ++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.c         |  8 --------
>  4 files changed, 39 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/include/asm/fpu/api.h b/arch/x86/include/asm/fpu/api.h
> index a2be3aefff9f..f86ad3335529 100644
> --- a/arch/x86/include/asm/fpu/api.h
> +++ b/arch/x86/include/asm/fpu/api.h
> @@ -143,6 +143,9 @@ extern void fpstate_clear_xstate_component(struct fpstate *fps, unsigned int xfe
>  
>  extern u64 xstate_get_guest_group_perm(void);
>  
> +extern void *get_xsave_addr(struct xregs_state *xsave, int xfeature_nr);

I get a linker error if I don't add an EXPORT_SYMBOL_GPL(get_xsave_addr)

-Mike

