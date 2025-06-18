Return-Path: <kvm+bounces-49882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 54C41ADF00D
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 16:47:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 05D131887B0F
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 14:47:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B683E3B1AB;
	Wed, 18 Jun 2025 14:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="X7ZHrxrP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2045.outbound.protection.outlook.com [40.107.92.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53734F9CB;
	Wed, 18 Jun 2025 14:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750258008; cv=fail; b=qkD5i7jjPWchV92nxEMUn9BNM0UBEOyQ76jYQvH90VCU+rPbhM35nebkR1Lo+wCKaO47mn9QzJN5DamjVZlZz999w+no+iXoCFZriFumqf4+GXylVdnyR9iyfckOkC3Uzuk1YBx1J9IDBLJwoiVYafaMX40jzIDjHHYUOoZzek0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750258008; c=relaxed/simple;
	bh=EDB70jokEyTJPUMM1+0EA2lecSV6bQVRi8wNhKoZ8+w=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AAJGFUbiomsOyYU1Ae4co17HKm0c7WiPUpojr2vnSLrO7H4KlOcAGNLSJxFBs8XRWy3XEAcFPCb5WP3f6yScION2dvZnFhqhQUmDB0WU7vv6zeQQYBbjSkDxRaSCofdrC7IreznTQjDvkB20G+T3PBQDmpLJ9j/aHOkGblqYmmA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=X7ZHrxrP; arc=fail smtp.client-ip=40.107.92.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZbudpYY9D8ikai6w8ge5v3I+yiiLBeEMOzmM8R3lpqlZp0fG5zBNNfK6EII4M8sMCgXfqZivsheJxRl7hQzlPpCO1NnnTCiu9ZwJu+zbjP6VOwhmftxbQ/ZzwDZ0nfk2LdpIFqUjuZKAaRWZY9Bg+IWX9l0FvV9KTVLDLMwLoN4pozRpcIOxkbtszGb+o1v4qYQNFeiJkgzhFWUBY4400QVJhkrEzn7MVwdyWkZDXCbXj6HP3/lZ7K7U407lBD7oI2nUVGS46qB5sbycAUbhp4hwEeLB4R6yQVI0voEiX4PRmxkMmUg8x+gH0WRmijvYNCy7jMZyhgyyMYOfe3Z5GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NwSvsnNKLrW5de5000QFGLz22toQoXNueYjK8uKTfzU=;
 b=kMR9DpP7H33incic9rBpJ3+/c3KL+ZVewXEYBECd6RLbOsX2NSYzW1wjUu9yrWy6g0tXNSUH7FKnw67GUzi770zR74Zt36TqcWY2Gyi4KVtZ5CdyLzdH4kHy7d2CeiFTueypntFdsdVgTBu2cJNpFMxz+IPJ4+ZwKE1ETgSKINYehTT7Q2E5X8LB48ofyBNg78tIFYR2MpAlL9imx6Zb2w+ok+6HxU6r4tnz+z7fpYlazzpO712wYVZ6D+nMTy2qYw+SitlnyrVWY8JlwrHCLga1gQ1aBD4mgvxQzkeZXm2RcikUMTYHOFnkKeYq+A1xRplt6rW0SFACfs8pj+RwgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NwSvsnNKLrW5de5000QFGLz22toQoXNueYjK8uKTfzU=;
 b=X7ZHrxrP0n3HkEurD4OlZkYwc7AxShl0SPnRGXYIZUCrt9ccgIwgp1icBYOxN5vqcrqi0luVwXKfZ7lDcDzTOukJFCRfKH6GmpmKf2HdR/HWdKqn0ZPJCYo3qe10R+aUX9shdLFvc3Nj60cZlogQUoa9zfv1BkYhUqdiQfJpYes=
Received: from MW4PR03CA0008.namprd03.prod.outlook.com (2603:10b6:303:8f::13)
 by MN2PR12MB4392.namprd12.prod.outlook.com (2603:10b6:208:264::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Wed, 18 Jun
 2025 14:46:43 +0000
Received: from CO1PEPF000075ED.namprd03.prod.outlook.com
 (2603:10b6:303:8f:cafe::e0) by MW4PR03CA0008.outlook.office365.com
 (2603:10b6:303:8f::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8792.35 via Frontend Transport; Wed,
 18 Jun 2025 14:46:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000075ED.mail.protection.outlook.com (10.167.249.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8857.21 via Frontend Transport; Wed, 18 Jun 2025 14:46:42 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 18 Jun
 2025 09:46:41 -0500
Received: from localhost (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Wed, 18 Jun 2025 09:45:11 -0500
Date: Wed, 18 Jun 2025 20:09:57 +0530
From: Naveen N Rao <naveen.rao@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, "David
 Woodhouse" <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<kvm@vger.kernel.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Sairaj Kodilkar <sarunkod@amd.com>, "Vasant
 Hegde" <vasant.hegde@amd.com>, Maxim Levitsky <mlevitsk@redhat.com>, "Joao
 Martins" <joao.m.martins@oracle.com>, Francesco Lavra
	<francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v3 13/62] KVM: SVM: Drop redundant check in AVIC code on
 ID during vCPU creation
Message-ID: <4f7d3pbe4s52twxaddjwlpca3mlb6htxi3ozze7n2sv4d3cafn@o3cyq3tmjhbx>
References: <20250611224604.313496-2-seanjc@google.com>
 <20250611224604.313496-15-seanjc@google.com>
 <qusmkqqsvc7hyuemddv66mooach7mdq66mxbk7qbr6if6spguj@k57k5lqmvt5u>
 <aFGY0KVUksf1a6xB@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aFGY0KVUksf1a6xB@google.com>
Received-SPF: None (SATLEXMB04.amd.com: naveen.rao@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000075ED:EE_|MN2PR12MB4392:EE_
X-MS-Office365-Filtering-Correlation-Id: bad62481-28a5-4a21-3ed6-08ddae76f106
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NGI0KzgxeE1GTnVxWDd3ajRrcUo5aytFZm8raStMZy9PM1NWNENOOG53aDdi?=
 =?utf-8?B?SDNMcmdScWlSTkliS0tNb0k5aFIwRXRQb0tsdVg2NWFFRHA2M0VHTkt1emhq?=
 =?utf-8?B?VGVCTy9vT09GdXNBRmJON09ibU1EYTI4bExBK0ZBYlp5NFJsbS8wN1FRb3FJ?=
 =?utf-8?B?ancyelkxcUlGRVlwM0FEd1pBZkQ2NUpPUkdpZlYwVVpocy9Rd3dObjNkY1pa?=
 =?utf-8?B?end0ZXREaWc1YS95U29WOEhxOWFiZ0taMGFyVkpBRlNXSTlCU1pxTlp0Mkd1?=
 =?utf-8?B?a2RrWEVoSG5Wa2dhVnNyQ0trcXQrUGQ1VEpJb0lSeHViRG9DaWNEVXM3dnRl?=
 =?utf-8?B?Zlp4MHh5RkxFbyt3U3FWcEZwUkRzbHNmMHpZcmJwL2ZGZ0lSNktGVGhEOEhN?=
 =?utf-8?B?WHNLWnltV0ZnaGFBK3pzejIvN2VUNHllaWVyMFJIc1IzdzMyU0ViMHBPcDk4?=
 =?utf-8?B?ZWhKK2ZqM1drVUxsTitidGFxeWMxZWVWdzRVRk9rUXcwQVpRcytBanpkaGtW?=
 =?utf-8?B?UUwyalZDc1duNDNYbTBUVXZab251M2VxdGFLaFZvSHJpLzFDVFRSVStCdG8v?=
 =?utf-8?B?aEU1VzJpWVRDYVNxeFRObTJlanFWSE5KNXlZS1hGOFN5VmV0eHJIS2dILzZx?=
 =?utf-8?B?SE5JVXRrZlRLYTZZRFZQeGhndlFXVVF2VmRCRFU2Si8vOTY1SGhDU0FZMWNq?=
 =?utf-8?B?RTRaMXZPTWRGQThBK2MrMjgxWWJyZGV5clNSNHVpcGM1WlFZWHJRZk1LK0ZO?=
 =?utf-8?B?amZOeHhJSmQyb0xKSmlFVmo0cVF3YStRWHR1V2NIblNLOHJaanhMdjVJbkJ2?=
 =?utf-8?B?WlYvTUFQMkR2SFNVWkhxYXVLNW1LQTUwSFcxZHRnUjJOdTBUVGNzU3hGYWVJ?=
 =?utf-8?B?Mnh6TVBFQUEzS2kvUUNGR1dSSmFYd3pVdkpRZDBZMzFURitNeXdGNXdxd05N?=
 =?utf-8?B?SG5MeHVSU0ZBUHhIYjlnWGxOdkRWc0VaamdmRmdxRnZyelZBbHVBWVdEU00v?=
 =?utf-8?B?cEpNZndaZXU2VWdKSFlJTjRCcDg4MGJET3pWUVVPU1c1Y2ROcm9oTzBoWFYz?=
 =?utf-8?B?bzkxWlBtRDc3WnM0SW16VytLQXVtWnRyTHFjWURNeXFsZ1pmbUZVaml6RnF0?=
 =?utf-8?B?dXZ5Q1N6ZllJc3U1cHhESlAyck42N3lJWExuSlpZbkxNeUtrTE9oRUlWN0ht?=
 =?utf-8?B?eDRWNDRGWjhEOWNhY3VTMFRoZTNESUNUajhDY0ZFd1NKMm04MkhvekhIaHpn?=
 =?utf-8?B?MUZoSDV3QVB1cXoyRDVaR2RCSnVHUFlMK01pNjNLVDhWdnBJM1BzVWFWeFNi?=
 =?utf-8?B?OEQ3ZFpHUjJFWnVscUk3eFVaamdoSFpNMDFqS0VITUh2V0xOVE43M1ZsbXl0?=
 =?utf-8?B?VzBydlRwMFBGR0hYek00bVpxcWlFVWpQY1R6djJLSUlZNkhRK0RsMzlhdUlI?=
 =?utf-8?B?YXFHWFJGT0FseHFWNVFzdHh1d0pFSXg2MmhpRXBGU3RMY1hOajFJd3B3Q3ZZ?=
 =?utf-8?B?T3IwV3BqRGg1TVdzZ3o1M1NpdWV5Zis4UGR6SDQyeFlOeE5JZ2RJUnNnelM3?=
 =?utf-8?B?U1ZlSncvbi8wVVlRTERKZTlnR1UxOHZ5KytuTnU2dGNhaUpSRm9rTkg3VXdu?=
 =?utf-8?B?dEFGRFVseHVoYkhIVmk3MG5zb2FlSkhBWTcyemRhUVYyV0xtbjRlRkxKbjRL?=
 =?utf-8?B?NUNzZy9rZWR1TEZBWHpYWlE1MFBQRkxRakJKcktCMHBFckFXZ1d1b0hPN2FM?=
 =?utf-8?B?Z3NzOVJLV3VkbFFVdnN0V0tlU2VWanIyOFlDbTBsQzgwa3F5VWdHUmNRbEU4?=
 =?utf-8?B?OXhpbFJET3VxeEpxRUpZcFJveGxHZGh0ZUpHOXBTektteDVyQWQyc0dlMk94?=
 =?utf-8?B?dkhyYjdUdEhybEdDL0lDUnFGNjhrRUFneVJLZE9jbThrZnBuZFNEOW8rdnEv?=
 =?utf-8?B?TlRUQmt2b1duL0xKcndaTWgraGcyUi9Tbk9FMW05RFRQSm1Vb2Yvb2JaUEVJ?=
 =?utf-8?B?T1U4czVjZEtTZUVSbmMrMjRDK0tFWnMraW5icG4rdXNGN0ZLQ3JZRmZGVlUv?=
 =?utf-8?Q?VdIZxa?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2025 14:46:42.8229
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bad62481-28a5-4a21-3ed6-08ddae76f106
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075ED.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4392

On Tue, Jun 17, 2025 at 09:33:20AM -0700, Sean Christopherson wrote:
> On Tue, Jun 17, 2025, Naveen N Rao wrote:
> > On Wed, Jun 11, 2025 at 03:45:16PM -0700, Sean Christopherson wrote:
> > >  static int avic_init_backing_page(struct kvm_vcpu *vcpu)
> > >  {
> > > -	u64 *entry, new_entry;
> > > -	int id = vcpu->vcpu_id;
> > > +	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
> > >  	struct vcpu_svm *svm = to_svm(vcpu);
> > > +	u32 id = vcpu->vcpu_id;
> > > +	u64 *table, new_entry;
> > >  
> > >  	/*
> > >  	 * Inhibit AVIC if the vCPU ID is bigger than what is supported by AVIC
> > > @@ -291,6 +277,9 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
> > >  		return 0;
> > >  	}
> > >  
> > > +	BUILD_BUG_ON((AVIC_MAX_PHYSICAL_ID + 1) * sizeof(*table) > PAGE_SIZE ||
> > > +		     (X2AVIC_MAX_PHYSICAL_ID + 1) * sizeof(*table) > PAGE_SIZE);
> > 						    ^^^^^^^^^^^^^^
> > Renaming new_entry to just 'entry' and using sizeof(entry) makes this 
> > more readable for me.
> 
> Good call, though I think it makes sense to do that on top so as to minimize the
> churn in this patch.  I'll post a patch, unless you want the honors?

Not at all, please feel free to add a patch (or not, given that this 
will be a trivial change).

> 
> > Otherwise, for this patch:
> > Reviewed-by: Naveen N Rao (AMD) <naveen@kernel.org>
> > 
> > As an aside, there are a few static asserts to validate some of the 
> > related macros. Can this also be a static_assert(), or is there is 
> > reason to prefer BUILD_BUG_ON()?
> 
> For this particular assertion, static_assert() would be fine.  That said,
> BUILD_BUG_ON() is slightly preferred in this context.
> 
> The advantage of BUILD_BUG_ON() is that it works so long as the condition is
> compile-time constant, whereas static_assert() requires the condition to an
> integer constant expression.  E.g. BUILD_BUG_ON() can be used so long as the
> condition is eventually resolved to a constant, whereas static_assert() has
> stricter requirements.
> 
> E.g. the fls64() assert below is fully resolved at compile time, but isn't a
> purely constant expression, i.e. that one *needs* to be BUILD_BUG_ON().
> 
> --
> arch/x86/kvm/svm/avic.c: In function ‘avic_init_backing_page’:
> arch/x86/kvm/svm/avic.c:293:45: error: expression in static assertion is not constant
>   293 |         static_assert(__PHYSICAL_MASK_SHIFT <=
> include/linux/build_bug.h:78:56: note: in definition of macro ‘__static_assert’
>    78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
>       |                                                        ^~~~
> arch/x86/kvm/svm/avic.c:293:9: note: in expansion of macro ‘static_assert’
>   293 |         static_assert(__PHYSICAL_MASK_SHIFT <=
>       |         ^~~~~~~~~~~~~
> make[5]: *** [scripts/Makefile.build:203: arch/x86/kvm/svm/avic.o] Error 1
> --
> 
> The downside of BUILD_BUG_ON() is that it can't be used at global scope, i.e.
> needs to be called from a function.
> 
> As a result, when adding an assertion in a function, using BUILD_BUG_ON() is
> slightly preferred, because it's less likely to break in the future.  E.g. if
> X2AVIC_MAX_PHYSICAL_ID were changed to something that is a compile-time constant,
> but for whatever reason isn't a pure integer constant.

Understood, thanks for the explanation.


- Naveen


