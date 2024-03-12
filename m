Return-Path: <kvm+bounces-11691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C817879B31
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 19:18:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F23A1C225F9
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 18:18:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0522A13A875;
	Tue, 12 Mar 2024 18:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XN8jeFAx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2084.outbound.protection.outlook.com [40.107.244.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D3D8139568;
	Tue, 12 Mar 2024 18:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710267462; cv=fail; b=HBhiW18IPSRe6ftxW5XtV8yilTn+EVTOoqRGb4Oje7N/sz+A+ymSv3Mf8jm6tFpquHrMfAjlcd9v07Zcs8aZAtBuppHglFAcX0gOHDgTLYl5TSjNjUbK/Q0MnUEZZ4Wk+REA6C3RFw5JJSwhdc59Tdj9P0IhtuuOdnuQsvuz7uM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710267462; c=relaxed/simple;
	bh=kuHZofzAq/2R0Z4fbDkAWJam4FC2tX3kUlK5B37tcjM=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GOHYiJWyStFTz6d8Nu3OlRF29OK1KXkTZiuizVv4nLAJeUkTHJSiujj/NogQc5HvpAA1xleW1W/nUMuIoLTHiHDmDbrJafFNMm0xRDiZUPiiIc0G7E1PH/ufw9EwCf7XeM+czKKb0w04exNqv0JIGWzZy6vjr9IU/GvUf0tqgV4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XN8jeFAx; arc=fail smtp.client-ip=40.107.244.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eczUq5PO1sVq1O/BdMyrWU2lRWVcPStvuJWIX+8js2J3LjQTTHf2SkAt5M7IHYJTmx5ciB1aNyIntNGUiZDMV81Px3AF1r76TCMtYy+fKntEe8NrWVmsTZEw2zCQh+Jl4SrCmhnV4SqZ1Ok/ROKWS0Tpa5coccgYxhagbFQyZ5R9cWO8Xr7pT0HiiZ6nAfY/81qqP/4K2vwiyCd/8HixBqBzzfYOfrDKkra1CNrlYxhZEH21bByf4bOoi6JDe73ih1F2twPH643VdUjNOmJ5EV5a8rPt/YgAARsxYQO+Is3VIyilv32hRqUNJoRMNFLoqwnvW4NM4fANWVHuinTEWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VwTN2VXR1tAhU+uS4RNEOXcBSgcbdvl/I1ALc/OZnpI=;
 b=HOXg8Qloqi230OKRzyssUaJd3FQ51BYDlWYeYa60pRi1QmQHx0jDN6bQzXfGTh+u08PN/VXLUT2UNsQnqfaStzyRZYsKpSqZQ9fjDWaQBe1Y5VJPvifKx3STO+Qtr5s8GSq9hgBtJR2DuavRSJ4FoAiw53PgFd8buIb/9OGelkPITfi4efyfSzl8W/5jNFRxxCH5cMdxZVc8wzYJA9FelSnDXg0k5vvydG7tZaDiu+uUthAaPr7koJISYCkosQWzDaXC8Ob8Ilvxe4zS5hsEcq+bnUqX0KvvTLPX9HRy3xICXQG2B7Ljx89RLqkDRaPkIvnfeuNUathEXD/029yTDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VwTN2VXR1tAhU+uS4RNEOXcBSgcbdvl/I1ALc/OZnpI=;
 b=XN8jeFAx0asIltEg+Sqv9+Uw/sVhgQ9O4ZfbQSXN0+s8srNbQFJIq+mxQGUBdrd1YTXn2cnCiwfJpqckiS49ksEN6gsU8+SZk+8VGvq/WawRKMTgcoPB2yoZtZee04ajWFA882F3p/G4T+PgozoQWLTKlkyeyL/v94bzEmBrTts=
Received: from SN6PR08CA0033.namprd08.prod.outlook.com (2603:10b6:805:66::46)
 by CY8PR12MB7363.namprd12.prod.outlook.com (2603:10b6:930:51::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.35; Tue, 12 Mar
 2024 18:17:38 +0000
Received: from SA2PEPF00001508.namprd04.prod.outlook.com
 (2603:10b6:805:66:cafe::c2) by SN6PR08CA0033.outlook.office365.com
 (2603:10b6:805:66::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.36 via Frontend
 Transport; Tue, 12 Mar 2024 18:17:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF00001508.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7386.12 via Frontend Transport; Tue, 12 Mar 2024 18:17:38 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 12 Mar
 2024 13:17:33 -0500
Date: Tue, 12 Mar 2024 10:19:02 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<seanjc@google.com>, <aik@amd.com>
Subject: Re: [PATCH v3 03/15] KVM: SVM: Invert handling of SEV and SEV_ES
 feature flags
Message-ID: <20240312151902.xkh7bxdmecwzw77h@amd.com>
References: <20240226190344.787149-1-pbonzini@redhat.com>
 <20240226190344.787149-4-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240226190344.787149-4-pbonzini@redhat.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00001508:EE_|CY8PR12MB7363:EE_
X-MS-Office365-Filtering-Correlation-Id: 7cab4da5-e4b6-4c9a-1d51-08dc42c0b2e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	oOm3yCQr9TCoLxV0m+aIEx9XMyQ6LGikAvrdKWb0lg/NpZOIKBPI6nawxay2wB/7YvbdAL5tmyKJNepm0D3mjDm3fjmwisSgbimPmO59M9uYHsjDtyNiYvC0PXpxdDeGQZKNJZN8J4Y4GcDs4zg2+Hr7Eg9ZpKdVNVqmtNiABVXR0otD8+v9XUZLP6oSXkAzns4squUoAIZIk5dUYJr98Hyg1ZFZjXNDka6kUj2O+JgM43tKvSBBmdryN1FyPDl5qVH3vOwYqKrx5drTfwSaJpyU3MvPUo5BXcdI0a6cGhQbhENF36sO8s9e5Xm7DGD7Yxk6cpYr4rq+i+c7caMUZ5SfR4vOAd82o5SBr11IIXduFn4McslIvc9Xp488ikRI6h8BlzXrmDqKyK4veXv4euWo5U3laz1DH0zUXpbWRnsnGEX+eglavbvddQNbOLkNaJToq+tGOGLfRnLVl4v/eScuoYT8NwiKEJNLzGDNWdtyZ1VeFR9qoZYKyg89HY+aq8gvmN3y6arEGK126KmBqJCAnPFzdFIP5+UK7I8+/FXPs12rgcR8ubUKjZ+IPjxf6QkMy6JDm9jq5GGYN7v4DHjW4BSIZePHVG81tWpzmVxObFsG38mO8eEQKbF+i8fjggkaR4tJs/slQk4Sf5XhxfqxoUB4zSkvVk7oyseanz4oLaCIOzT9JsgsKOCm9f/rVipRAKGNbYQ1vmhdxXFHP4BYYaEfE+xYigw2kv4eL454UZqP9QFSkJouVH0VSPTH
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(82310400014)(376005)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2024 18:17:38.1328
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cab4da5-e4b6-4c9a-1d51-08dc42c0b2e0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001508.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7363

On Mon, Feb 26, 2024 at 02:03:32PM -0500, Paolo Bonzini wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Leave SEV and SEV_ES '0' in kvm_cpu_caps by default, and instead set them
> in sev_set_cpu_caps() if SEV and SEV-ES support are fully enabled.  Aside
> from the fact that sev_set_cpu_caps() is wildly misleading when it *clears*
> capabilities, this will allow compiling out sev.c without falsely
> advertising SEV/SEV-ES support in KVM_GET_SUPPORTED_CPUID.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Michael Roth <michael.roth@amd.com>

> ---
>  arch/x86/kvm/cpuid.c   | 2 +-
>  arch/x86/kvm/svm/sev.c | 8 ++++----
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index adba49afb5fe..bde4df13a7e8 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -761,7 +761,7 @@ void kvm_set_cpu_caps(void)
>  	kvm_cpu_cap_mask(CPUID_8000_000A_EDX, 0);
>  
>  	kvm_cpu_cap_mask(CPUID_8000_001F_EAX,
> -		0 /* SME */ | F(SEV) | 0 /* VM_PAGE_FLUSH */ | F(SEV_ES) |
> +		0 /* SME */ | 0 /* SEV */ | 0 /* VM_PAGE_FLUSH */ | 0 /* SEV_ES */ |
>  		F(SME_COHERENT));
>  
>  	kvm_cpu_cap_mask(CPUID_8000_0021_EAX,
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index f06f9e51ad9d..aec3453fd73c 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2178,10 +2178,10 @@ void sev_vm_destroy(struct kvm *kvm)
>  
>  void __init sev_set_cpu_caps(void)
>  {
> -	if (!sev_enabled)
> -		kvm_cpu_cap_clear(X86_FEATURE_SEV);
> -	if (!sev_es_enabled)
> -		kvm_cpu_cap_clear(X86_FEATURE_SEV_ES);
> +	if (sev_enabled)
> +		kvm_cpu_cap_set(X86_FEATURE_SEV);
> +	if (sev_es_enabled)
> +		kvm_cpu_cap_set(X86_FEATURE_SEV_ES);
>  }
>  
>  void __init sev_hardware_setup(void)
> -- 
> 2.39.1
> 
> 

