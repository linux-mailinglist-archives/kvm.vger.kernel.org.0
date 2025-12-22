Return-Path: <kvm+bounces-66465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D1DCCD5490
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 10:18:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 08011302514A
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 09:17:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BDA53101B2;
	Mon, 22 Dec 2025 09:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ygbxbL7P"
X-Original-To: kvm@vger.kernel.org
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012061.outbound.protection.outlook.com [52.101.43.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA35221710;
	Mon, 22 Dec 2025 09:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766395033; cv=fail; b=vAcRtY2H1NF1JbQSYA4LTYgBR3/Dhu/OgeILMlZcACjwIrGeQKk4BcXGO31MqrBe3oUAPN58HH3NL6lMQddDXuzc97PK6XEPW0ZQ0lBPw/homIrdBbwIAWKwT7n9H3ujfUSgOSkWXpKnOwWd8BtfpkZe9+8zLo8OuBG0KiwB3Xo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766395033; c=relaxed/simple;
	bh=15ATssXtSkUgkDkIa6QUlMx9IxjQhzgH+8TCp2fY3tM=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I0VfTKY+julmqI7y+5gqij+cvKQ87lmy0RXsP9o/cB1cBeQsF3KYhQ9fvboaozFKiqAf9EZTFUylclNRqxPg8e4fKM4GsAWMh+kSRjQfCii3VlSOFN4sX5M+AjSs6vlrPbotpxrdyFft9ZTmuRjWXm9eaHeWI9n3e+1PL6/uDUE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ygbxbL7P; arc=fail smtp.client-ip=52.101.43.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qjXTx53TBLaF+kU0zAxryZRNZ3uQhNHKbc/5H+HjqpD1sFhz5Uekhif/fNl8ufuVBfHvUd1FoSaXTRxVbDVIuOQ5ntQ9hsog7VWi5ffKJ9CzWjs+PLxLnyS845V7yxqWE6pkG4iZvbe1zs/HIfBmjZ+DTNZxSRoxKBmw2CSGjaUThluPPmCuV1hJP93K6A6WShczOVSNMGhhV/JSAcnNF/TpXo6DpIg/l3oz/lQaZFN5kdDm6xdVqw9wSBqPDyVnbI63lEG0OlcS8KosX14trrbQN9xUNmpEYaMMjhNxc5qHlQFKiFaIDPjCMVJtw6LMyaJ3pv/v8xSwBxG7GDS6cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gEttamuP59dkMhpfbDzlvMFEqXSf8qpVnYodQGfdzkw=;
 b=MSVQJd+sODtoCBS1xOvPLNwy/lpuMsaEGdlWtm+DUKPBjFOLAlUiajJ5QrwXREqb6Ks0lstFgcSGbJ+cWJIugPAFyoHMcfWNFIIknefrRLZN3D5sPj8d7OMjQWK5MypwfbEUCPTJCwgAmAmI8LomEnGrWaCxSU3z4kGe0ImWctel08IQfPPHsGcmtdQ0Z3Uy5NK5jpO7ejf2w7C2nEoiYA54TaRebePidDNaSu0mBf+99SJTfDPzgqK/sS6LQVZGgMaOy4xuBfy1o24oJj6etywRfge/2gERNhhtmaZ1f6pifkdhspmKdEg4KfsDoEM4NVoDD1pWmVw7FC5zd1Ol8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gEttamuP59dkMhpfbDzlvMFEqXSf8qpVnYodQGfdzkw=;
 b=ygbxbL7PFuh2yzNOwnEk60DP+8II1jlzoyJ+aXojwauOJ+POZNpsnngCpfjlbHIqOygwXxn+exqEwMSfW2n15DqDvu+GjwccOQRSLRMXOi4oywJ7QW49B511NKP2CiEFCXrc075H18f9r1FvKa36Gg/RSlV5oRbTq5taskktlNU=
Received: from BL1PR13CA0171.namprd13.prod.outlook.com (2603:10b6:208:2bd::26)
 by DS0PR12MB7852.namprd12.prod.outlook.com (2603:10b6:8:147::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.11; Mon, 22 Dec
 2025 09:17:06 +0000
Received: from BL02EPF0001A101.namprd05.prod.outlook.com
 (2603:10b6:208:2bd:cafe::f7) by BL1PR13CA0171.outlook.office365.com
 (2603:10b6:208:2bd::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9456.10 via Frontend Transport; Mon,
 22 Dec 2025 09:17:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BL02EPF0001A101.mail.protection.outlook.com (10.167.241.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9456.9 via Frontend Transport; Mon, 22 Dec 2025 09:17:06 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Mon, 22 Dec
 2025 03:17:06 -0600
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 22 Dec
 2025 03:17:05 -0600
Received: from amd.com (10.180.168.240) by satlexmb07.amd.com (10.181.42.216)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Mon, 22 Dec 2025 01:17:00 -0800
Date: Mon, 22 Dec 2025 09:16:55 +0000
From: Ankit Soni <Ankit.Soni@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, "David
 Woodhouse" <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<kvm@vger.kernel.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Sairaj Kodilkar <sarunkod@amd.com>, "Vasant
 Hegde" <vasant.hegde@amd.com>, Maxim Levitsky <mlevitsk@redhat.com>, "Joao
 Martins" <joao.m.martins@oracle.com>, Francesco Lavra
	<francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>, "Naveen
 Rao" <Naveen.Rao@amd.com>
Subject: Re: [PATCH v3 38/62] KVM: SVM: Take and hold ir_list_lock across
 IRTE updates in IOMMU
Message-ID: <njhjud3e6wbdftzr3ziyuh5bhyvc5ndt5qvmg7rlvh5isoop2l@f2uxctws2c7d>
References: <20250611224604.313496-2-seanjc@google.com>
 <20250611224604.313496-40-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250611224604.313496-40-seanjc@google.com>
Received-SPF: None (SATLEXMB04.amd.com: Ankit.Soni@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A101:EE_|DS0PR12MB7852:EE_
X-MS-Office365-Filtering-Correlation-Id: a7d36328-7e40-43b2-b9d9-08de413ae09b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|1800799024|82310400026|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OERFbDZCL3FWT1huNDJjd255ZC9BSkRUOGFoeWtMTy92V0RWRFg0eThoQzlX?=
 =?utf-8?B?aW9SNGxTWkN2bjYyU2pjUG12UVIyRzNwVnIyaU5qVGFnVEdsTTN3MGRRM1BD?=
 =?utf-8?B?WjY1UXAvMnVtWjJsV1ZETWJWR2tnWFVsVWJTSkdrSlNsemR2NkxpOXZvSTZO?=
 =?utf-8?B?YkloWEtiLy93UTY5VVhmY0pFQlNjZG5TVEs1aWZyN3N5R3pBNWxTWDBST0Vz?=
 =?utf-8?B?RENOK3Nla3ladUtML09wRTRPQVNJYkxhUk5aL01ZOE5LM0FDdzdvOGtSL2VK?=
 =?utf-8?B?QWNMUXVIeFBTL21FU0ZJbXlBcTdLZml2QmZsdkh4SkVXUVJOU0RkcWhGV2tP?=
 =?utf-8?B?MmVCTjFtY3FlUmRjeDlkSmhoSDlPMGtzS2NxMi9YemhoaExXNzhTZFV4YlQy?=
 =?utf-8?B?emJmYkdvcVVWTTlBdGhNa24zMUE5NUVuNFBLRWYxRWxsZWRqV29ENHlidy94?=
 =?utf-8?B?NFdsdjZNaEJBZEtpenhkRC82S2p1enlkWXNqTGsxZ2tRcUZ3aDdadUhPRjdZ?=
 =?utf-8?B?ZHNhUENPY3ovZ0h5UlRTZUpWUklLRkIyMlA5NWJFdFJhOStIV0NlVkFDZ2th?=
 =?utf-8?B?d3FqYTZTVTE5M3NLdzJEZHJzSS9hbW9sb0JXVGtOWUVaTWdIVlF4ekZUNFNn?=
 =?utf-8?B?NTFXbmNnSkFtZUw5V2VYVHV4c2E5bFFmWG8xNnhSTko1ajNiQnN5WHlkeUta?=
 =?utf-8?B?U1ZjSU1ZSUtrQTltQ0M0QXJpMTc4WHFlMkk3eDl5SXVNUzBhckM4UlUxTlBV?=
 =?utf-8?B?d1JRaWlMTTA4SExySnFkWHBCK0RtbFJyczhSNk9xNDFpQW0yRStSMUhmeWxQ?=
 =?utf-8?B?cXFOcENtNUd4dkwvYS9lYVRCMDYwOWZ0UFZMMndUeUNPSGwwcHh6OEtuRElr?=
 =?utf-8?B?US9TdFR3Y2QzMW50TTJpSUlkcVZtM3ZYd21NOGJ2MlNhVHFlRUZ2bnJ0ZVcy?=
 =?utf-8?B?RFZRTWp6dUdmR3ZnYmlFbFN2NFVOazl6cThHL0xkSmlBdUkvMy9NVFZCRno2?=
 =?utf-8?B?SVhNWlR6M2hRNnpCbU1NdzZRL1dBWVdJWTFqZUIxUnU0MDcrRUhJZ2xjaDEy?=
 =?utf-8?B?UXEwKzlEenVpSHNDeTNMNWtRVlhLeFdlM0dIalZieXVqeHFjSWtIZDZQcDJw?=
 =?utf-8?B?MUloYmg2MSt1bW14MHdyZTZkREVZT3RRcmpiQjJMUnRGUGhMb05UUUxXRHN3?=
 =?utf-8?B?Z3NYc0hSSUZzaTlSUEkyREJXWjlhVE5BMHdGUUk3QkdsT3JDeVY4Wm8zV2Zm?=
 =?utf-8?B?MzVKSTd3cTZTZThVZUJjYjFhV09TTTZNZHNITlVqSGhDOGRXelViWmVVMVB4?=
 =?utf-8?B?ZWJoYjlBaWtLazhRZ2QxMTJ1dkdFYkM2cG0yTzZnZ1dZNjQyL2ticVR2TGxp?=
 =?utf-8?B?MjllaGwyZWJKWW8zdlo5V1oyRStlRWtEcmhwdHF5MUZxWlBQWnZmODQrYy9v?=
 =?utf-8?B?ZDZ4enBUVTZwUmpsNE4vNWo4OExrdDJWQmovcnJnSEpja1d6TDNZalZUWm1V?=
 =?utf-8?B?NFEzWFRJT0tGazdWczlKSTRaRCtnTDJ0VHBJYURrdjBIdmRLZWsvR1JtVTdv?=
 =?utf-8?B?TEVoRmdUbTRIR0tNc3JhRWlqYUtwYlFGbmo2TThKYU9JY1hBQmYzM1pnZ0c4?=
 =?utf-8?B?N012MHhrWlJkUEtrSEE4c0d5dTRmbjBqVC8wRmhpMXJPT1N5SE8wenZOMFpz?=
 =?utf-8?B?UVZaOSs1V1paUDdyTkkzRjNWcjhJcnFJNzdHMUF6OVNXVnFIM1VnYmZoeElF?=
 =?utf-8?B?V1R4b3ZkOXpGM3c0alRTa2xXMmlXN3RLTWxWbUJhN2ljMlg1MlFqdzZzVk83?=
 =?utf-8?B?ZDcyTEJvY1BvTXh1czNEQmh1M00zM3Nsa1JFalQ1ZFlieWROdC94UDk5Zmpo?=
 =?utf-8?B?M2l4U3p1L1M1TjkzWU9JWEZVUThxcWhPd0NSaTFuYndmRTFteVJxQ0hGck9F?=
 =?utf-8?B?NHBkT2VrN3FaQWg3UzBLSWtRNHQ4d1l6ZEJvWUlaMnM5YkpRaU41Z2piQUp2?=
 =?utf-8?B?bC9XSnk4STNCc0N0WXlOdWFQMG1sb3QrSXlNZllBUUtHc0IzQzlzdlRWSDF0?=
 =?utf-8?B?N3NkY0RDQnVtZlhhVU9XRlZJNENDbzFXNitCdz09?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(1800799024)(82310400026)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2025 09:17:06.4946
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a7d36328-7e40-43b2-b9d9-08de413ae09b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A101.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7852

On Wed, Jun 11, 2025 at 03:45:41PM -0700, Sean Christopherson wrote:
> Now that svm_ir_list_add() isn't overloaded with all manner of weird
> things, fold it into avic_pi_update_irte(), and more importantly take
> ir_list_lock across the irq_set_vcpu_affinity() calls to ensure the info
> that's shoved into the IRTE is fresh.  While preemption (and IRQs) is
> disabled on the task performing the IRTE update, thanks to irqfds.lock,
> that task doesn't hold the vCPU's mutex, i.e. preemption being disabled
> is irrelevant.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/avic.c | 55 +++++++++++++++++------------------------
>  1 file changed, 22 insertions(+), 33 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index f1e9f0dd43e8..4747fb09aca4 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
>  
>  int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
>  			unsigned int host_irq, uint32_t guest_irq,
>  			struct kvm_vcpu *vcpu, u32 vector)
> @@ -823,8 +797,18 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
>  			.vapic_addr = avic_get_backing_page_address(to_svm(vcpu)),
>  			.vector = vector,
>  		};
> +		struct vcpu_svm *svm = to_svm(vcpu);
> +		u64 entry;
>  		int ret;
>  
> +		/*
> +		 * Prevent the vCPU from being scheduled out or migrated until
> +		 * the IRTE is updated and its metadata has been added to the
> +		 * list of IRQs being posted to the vCPU, to ensure the IRTE
> +		 * isn't programmed with stale pCPU/IsRunning information.
> +		 */
> +		guard(spinlock_irqsave)(&svm->ir_list_lock);
> +

Hi,

I’m seeing a lockdep warning about a possible circular locking dependency
involving svm->ir_list_lock and irq_desc_lock when using AMD SVM with AVIC
enabled and a VFIO passthrough device, on 6.19-rc2.

Environment
===========

  - Kernel: 6.19.0-rc2
  - QEMU: 10.1.94
  - CPU: AMD EPYC 9965
  - Modules involved: kvm_amd, kvm, vfio_pci, vfio, irqbypass, mlx5_core
  - Workload: QEMU guest with an mlx5 PCI device passed through.

Lockdep warning
===============

The warning is:

  ======================================================
  WARNING: possible circular locking dependency detected
  6.19.0-rc2 #20 Tainted: G            E
  ------------------------------------------------------
  CPU 58/KVM/28597 is trying to acquire lock:
    ff12c47d4b1f34c0 (&irq_desc_lock_class){-.-.}-{2:2}, at: __irq_get_desc_lock+0x58/0xa0

    but task is already holding lock:
    ff12c49b28552110 (&svm->ir_list_lock){....}-{2:2}, at: avic_pi_update_irte+0x147/0x270 [kvm_amd]

    which lock already depends on the new lock.

  the existing dependency chain (in reverse order) is:

    -> #3 (&svm->ir_list_lock){....}-{2:2}:
         _raw_spin_lock_irqsave+0x4e/0xb0
         __avic_vcpu_put+0x7a/0x150 [kvm_amd]
         avic_vcpu_put+0x50/0x70 [kvm_amd]
         svm_vcpu_put+0x38/0x70 [kvm_amd]
         kvm_arch_vcpu_put+0x21b/0x330 [kvm]
         kvm_sched_out+0x62/0x90 [kvm]
         __schedule+0x8d3/0x1d10
         __cond_resched+0x5c/0x80
         __mutex_lock+0x83/0x10b0
         mutex_lock_nested+0x1b/0x30
         kvm_hv_set_msr_common+0x199/0x12a0 [kvm]
         kvm_set_msr_common+0x468/0x1310 [kvm]
         svm_set_msr+0x645/0x730 [kvm_amd]
         __kvm_set_msr+0xa3/0x2f0 [kvm]
         kvm_set_msr_ignored_check+0x23/0x1b0 [kvm]
         do_set_msr+0x76/0xd0 [kvm]
         msr_io+0xbe/0x1c0 [kvm]
         kvm_arch_vcpu_ioctl+0x700/0x2090 [kvm]
         kvm_vcpu_ioctl+0x632/0xc60 [kvm]
         __x64_sys_ioctl+0xa5/0x100
         x64_sys_call+0x1243/0x26b0
         do_syscall_64+0x93/0x1470
         entry_SYSCALL_64_after_hwframe+0x76/0x7e

    -> #2 (&rq->__lock){-.-.}-{2:2}:
         _raw_spin_lock_nested+0x32/0x80
         raw_spin_rq_lock_nested+0x22/0xa0
         task_rq_lock+0x5f/0x150
         cgroup_move_task+0x46/0x110
         css_set_move_task+0xe1/0x240
         cgroup_post_fork+0x98/0x2d0
         copy_process+0x1ea8/0x2330
         kernel_clone+0xa7/0x440
         user_mode_thread+0x63/0x90
         rest_init+0x28/0x200
         start_kernel+0xae0/0xcd0
         x86_64_start_reservations+0x18/0x30
         x86_64_start_kernel+0xfd/0x150
         common_startup_64+0x13e/0x141

    -> #1 (&p->pi_lock){-.-.}-{2:2}:
         _raw_spin_lock_irqsave+0x4e/0xb0
         try_to_wake_up+0x59/0xaa0
         wake_up_process+0x15/0x30
         irq_do_set_affinity+0x145/0x270
         irq_set_affinity_locked+0x172/0x250
         irq_set_affinity+0x47/0x80
         write_irq_affinity.isra.0+0xfe/0x120
         irq_affinity_proc_write+0x1d/0x30
         proc_reg_write+0x69/0xa0
         vfs_write+0x110/0x560
         ksys_write+0x77/0x100
         __x64_sys_write+0x19/0x30
         x64_sys_call+0x79/0x26b0
         do_syscall_64+0x93/0x1470
         entry_SYSCALL_64_after_hwframe+0x76/0x7e

    -> #0 (&irq_desc_lock_class){-.-.}-{2:2}:
         __lock_acquire+0x1595/0x2640
         lock_acquire+0xc4/0x2c0
         _raw_spin_lock_irqsave+0x4e/0xb0
         __irq_get_desc_lock+0x58/0xa0
         irq_set_vcpu_affinity+0x4a/0x100
         avic_pi_update_irte+0x170/0x270 [kvm_amd]
         kvm_pi_update_irte+0xea/0x220 [kvm]
         kvm_arch_irq_bypass_add_producer+0x9b/0xb0 [kvm]
         __connect+0x5f/0x100 [irqbypass]
         irq_bypass_register_producer+0xe4/0xb90 [irqbypass]
         vfio_msi_set_vector_signal+0x1b0/0x330 [vfio_pci_core]
         vfio_msi_set_block+0x5a/0xd0 [vfio_pci_core]
         vfio_pci_set_msi_trigger+0x19e/0x260 [vfio_pci_core]
         vfio_pci_set_irqs_ioctl+0x46/0x140 [vfio_pci_core]
         vfio_pci_core_ioctl+0x6ea/0xc20 [vfio_pci_core]
         vfio_device_fops_unl_ioctl+0xb1/0x9d0 [vfio]
         __x64_sys_ioctl+0xa5/0x100
         x64_sys_call+0x1243/0x26b0
         do_syscall_64+0x93/0x1470
         entry_SYSCALL_64_after_hwframe+0x76/0x7e

  Chain exists of:
    &irq_desc_lock_class --> &rq->__lock --> &svm->ir_list_lock

  Possible unsafe locking scenario:

        CPU0                            CPU1
        ----                            ----
   lock(&svm->ir_list_lock);
                                      lock(&rq->__lock);
                                      lock(&svm->ir_list_lock);
   lock(&irq_desc_lock_class);

        *** DEADLOCK ***

At the point of the warning, the following locks are held:

  #0: &vdev->igate           (vfio_pci_core)
  #1: lock#10                (irqbypass)
  #2: &kvm->irqfds.lock      (kvm)
  #3: &svm->ir_list_lock     (kvm_amd)

and the stack backtrace has:

  __irq_get_desc_lock
  irq_set_vcpu_affinity
  avic_pi_update_irte               [kvm_amd]
  kvm_pi_update_irte                [kvm]
  kvm_arch_irq_bypass_add_producer  [kvm]
  __connect                         [irqbypass]
  irq_bypass_register_producer      [irqbypass]
  vfio_msi_set_vector_signal        [vfio_pci_core]
  vfio_pci_set_irqs_ioctl           [vfio_pci_core]
  vfio_pci_core_ioctl               [vfio_pci_core]
  vfio_device_fops_unl_ioctl        [vfio]
  __x64_sys_ioctl
  x64_sys_call
  do_syscall_64
  entry_SYSCALL_64_after_hwframe

So lockdep sees:

  &irq_desc_lock_class -> &rq->__lock -> &svm->ir_list_lock

while avic_pi_update_irte() currently holds svm->ir_list_lock and then
takes irq_desc_lock via irq_set_vcpu_affinity(), which creates the
potential inversion.

Reproduction
============

Host:

  - AMD EPYC + AVIC enabled
  - Kernel 6.19-rc2 with lockdep
  - VFIO passthrough of an mlx5 device (mlx5_core loaded)

Launch command with Passthrough device, with AVIC mode.

The warning triggers when enabling MSI/MSI-X for the passthrough device
from the guest, i.e. via VFIO ioctl on the host that goes through
irq_bypass and eventually calls avic_pi_update_irte().

I can reproduce this reliably when starting the guest with the VFIO
device assigned after every host reboot.

Questions
=========

  - Is this lockdep warning expected/benign in this code path, or does it
    indicate a real potential deadlock between svm->ir_list_lock and
    irq_desc_lock with AVIC + irq_bypass + VFIO?

  - If this is considered a real issue, is the expected direction to:
      * change the locking around avic_pi_update_irte()/svm->ir_list_lock, or
      * adjust how irq_bypass / VFIO interacts with vCPU affinity updates
        on AMD/AVIC, or
      * annotate the locking somehow if lockdep is over-reporting here?

I’m happy to:

  - Provide my full .config
  - Share the exact QEMU command line
  - Test any proposed patches or instrumentation

Thanks,
Ankit Soni
Ankit.Soni@amd.com

> -- 
> 2.50.0.rc1.591.g9c95f17f64-goog
> 

