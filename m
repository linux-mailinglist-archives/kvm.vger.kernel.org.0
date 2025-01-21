Return-Path: <kvm+bounces-36083-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 18D84A176C3
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 06:01:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 99433188B1E9
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 05:02:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D86EE19DF98;
	Tue, 21 Jan 2025 05:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Wfrz83/E"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2079.outbound.protection.outlook.com [40.107.244.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5088F14900F;
	Tue, 21 Jan 2025 05:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737435708; cv=fail; b=aHysrQT7J0OGQZI+I5ViUz2H8e8b2OVm23G4imoUET2w75J5gJXrUaXQe+5MM8B1sVUW7VhEN9RzomYv1yi09XQBFL2y+ISk1X6nvKM/fHuIB25IxNchQRQj0CUIVpXNfnJ/HdT1PpBEogyWEsNIVEU3WkbSTcHvuMY1hnFzdXk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737435708; c=relaxed/simple;
	bh=uThBtxXGVPpOY9RTj0/pRZsH4B46eaJBKF2IIt+uXb0=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=jQQCA9yFbXxk7ry5eG5xegahcQj6dnfViLhFFj5636bserDaPeu05YUpVHuieqguQGDUdq+7ly4oqyZKoGexN/oVPCW8dA5fQwcxMHizxfaXTRvOJ2++hJVlKbvDdx7uKANeYA2YPuh8Pogt8GpwXJEM+lsoAi8L5v1GDDp+TUk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Wfrz83/E; arc=fail smtp.client-ip=40.107.244.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dDPrnBKRSwIywpAftO8zemV56u14FqDmF83qu4/j541f0YG+ufsEOzKXCK0k/dLhrWXm9wcXHkZ8kYgTcvLtcRBrLqtDF8t4Jx1tMBZyoHsQcvlLYlta3VW1ILwnGZKTmOB1KTwE1QA++opRfTBr3YagfgtCVTH2TlMxE8HGlIwvmYaZl+xSWq7+KX/4AKQXdlUc4feejwBa6t2QV8eKMDAE9GAptQdU0y9wLFHLEydHkUB+sB5u6pw2XbRSXsG0GPVwI3w8nW9AfIMJyC9VNV1UNg1Xbnv7r18wOl8RSOzO3zHaeIFzXSU+ADuKOEkDk5O+fZUwWzPGLiOP4ymKHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NHjhLNKvCDJtgCobNBeGein8ZxTxkNrWUnzyQ+KDlns=;
 b=BpZPfF2c5UZcMQJFSuW7Mmd3M7/tZNXTCrKgthskhqpdqcJ/9izaeB724MgGAjYzDpbRrwtVb78SADhsgR7miYJwNuWguMR0R//6JFysOlzEb5AO4EvGc8MjZpMAS/TecA/zc/3ogI6tc9usPpplPV/0sE++fsyCeiDUTKnaGdCAQs0aIExBjV5xbLIpQ3aG0oLhiSr6W6QoBoXhMMiBUeobattxtV3LMlS94ZOwtzNegz5ByTcu4nZXlSWVQQSA1tLqAwH3+n/6/SUH7tiWy6Y3v2nQr5caW8p5ZKUNpPHUXTK5oowHqrcc9ER3RRNhzf9+T2i5eBesyCU58r1eyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=sjtu.edu.cn smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NHjhLNKvCDJtgCobNBeGein8ZxTxkNrWUnzyQ+KDlns=;
 b=Wfrz83/Epcn/ITl4do6i9Y/OSCKa0Hqh6p+mdngzVhG6Hs0pl8qOm3LZec0N9VsmcDR+5B8UDqWG9zDBcsR9ClS9C3494vCEokXdpkziZhG56zlJnamKMtGiHDxqA0IGB8vqTEGhnfN5keduZqPvUsG16ddxhw78xdm7npHDQ6I=
Received: from BN7PR02CA0035.namprd02.prod.outlook.com (2603:10b6:408:20::48)
 by SA3PR12MB8439.namprd12.prod.outlook.com (2603:10b6:806:2f7::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.18; Tue, 21 Jan
 2025 05:01:43 +0000
Received: from BL6PEPF0001AB54.namprd02.prod.outlook.com
 (2603:10b6:408:20:cafe::f) by BN7PR02CA0035.outlook.office365.com
 (2603:10b6:408:20::48) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8356.21 via Frontend Transport; Tue,
 21 Jan 2025 05:01:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB54.mail.protection.outlook.com (10.167.241.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8377.8 via Frontend Transport; Tue, 21 Jan 2025 05:01:41 +0000
Received: from BLR-L1-NDADHANI (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 20 Jan
 2025 23:01:38 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: Zheyun Shen <szy0127@sjtu.edu.cn>, <thomas.lendacky@amd.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<kevinloughlin@google.com>, <mingo@redhat.com>, <bp@alien8.de>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Zheyun Shen
	<szy0127@sjtu.edu.cn>
Subject: Re: [PATCH v5 3/3] KVM: SVM: Flush cache only on CPUs running SEV
 guest
In-Reply-To: <20250120120503.470533-4-szy0127@sjtu.edu.cn>
References: <20250120120503.470533-1-szy0127@sjtu.edu.cn>
 <20250120120503.470533-4-szy0127@sjtu.edu.cn>
Date: Tue, 21 Jan 2025 05:01:35 +0000
Message-ID: <85frlcvjyo.fsf@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB54:EE_|SA3PR12MB8439:EE_
X-MS-Office365-Filtering-Correlation-Id: d1dc2249-0ddb-44d9-fdc6-08dd39d8b20d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700013|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jybYxQsP4d5vh9Ir2b4tap534L8yQJ6IM3b+7GRJQesJ5kheyErZuUzu1rXv?=
 =?us-ascii?Q?oy9j3gQcE0QjXzSMXsAbGkHDP7Z3HM/cl9ZNs2mcu/k19PhlQ3FEHWVC+epH?=
 =?us-ascii?Q?GfloXHv3wE9pPEWwCb8+6C9XVcuprdWaRhnhRF38zvAPiaggrCpAPRNxX27/?=
 =?us-ascii?Q?HeR3j94lfboS2OmwWyYGz0W8sB67poyf3ya5T6AXSxhLdDxF7otaO3YzHXBS?=
 =?us-ascii?Q?wVEzDOMe+ZcbT5Op8RDkYSFttqPbpy13SBjoldMRWgS1NC8g9aCgK5XZJKpW?=
 =?us-ascii?Q?yrZZgvC1dtpFb1hGxbtAkmBvftsk2w8Q7E0Xnz62Qwfq9tsD1fwiECvn55t1?=
 =?us-ascii?Q?rZklWrRqcrRaN+zgoLYR4qCf9XfSrTFXIVOq8Cau4ICNN9hjEBYEZueHWTUO?=
 =?us-ascii?Q?6KvnH+BEbCoeblqfUbvlo4FQGsBVoi/IfPM7pFYMy6U+i90XyuMzt/+hu1Xf?=
 =?us-ascii?Q?x1eB2w6PpgRAAJHKF/ykmrx6gMaEA+Pni+ZK0iAiP1WimbKrPcOoggxQGELz?=
 =?us-ascii?Q?GZFk3eC++xDRN5FMvC/cI5XfqvnuTYZkKUn4Jyg4Kny+Wdoq3X7AGejgqqNG?=
 =?us-ascii?Q?XX43mn1rkrez5ywsJ+vzsJkbErfxVIajojuhNQAlM2V9u9Kts9v9cZYYSOEG?=
 =?us-ascii?Q?0SKpu92YH1mJTwD7nDY6agrtcBVkIPAMyjq4neJ3M1AaO5ScJe5em20hzwmn?=
 =?us-ascii?Q?9NA9Wgi6+wBFyv/1iYhcIEIxC7rD4rkbol6OHNBQ3LDKrhlzPHqOkNtsFJyC?=
 =?us-ascii?Q?K5VYvOIZVwAUUxQHHHdV4w9pgXXoN9Y6AY1ekiMEW9ogeq0OY+rTVxaRlGqI?=
 =?us-ascii?Q?hH4zYofd5vCn4oSGQMU7duonsPeRxAwzz2u71HCYnSUxNUQqaqg6mFFJEUQU?=
 =?us-ascii?Q?Wsp9So9O0tMOybF5p8woyHZCXCwmpPb+5Rln4kVxx8DaCylSu5YSS3P4Tj1+?=
 =?us-ascii?Q?S10qL+f1UtETYQN802RqovLFZqS1qF0bZikKJAcptOZKxgS6jQ/90eU1Pgw0?=
 =?us-ascii?Q?1kuR2wl017PFiC/gyU9zE+XkRtkltDRCOK8JArO8ATZaHNeoO18p1A4R2nh4?=
 =?us-ascii?Q?G19RI5tP3OTkt3LHbMiG8ZL0Ginm3LcH/2CCSc1+9cczQEN9ziXvMfkIiwgD?=
 =?us-ascii?Q?9RqHNnHCSqapHDwEgQ+rY6IPqKWAaOkrPENlm8MVjKjkSOR8f2ArPQC3qgb7?=
 =?us-ascii?Q?uFJZwmXn3RXZT8shOIDskkU6ZfZnN5hHKULP05wP+Bjy0phijnYnlEZ17Pt2?=
 =?us-ascii?Q?8rd2MO6BKADmF81NKJz3pKmY/CtZfcB2OGvyeY5MiLFKrC6VaQMvSf00ZNjQ?=
 =?us-ascii?Q?FjrbAfH/YAmsxrp/karhxcpAa1CK+vvLHy1cZw4sllA6yvdkAShz0yBAXncq?=
 =?us-ascii?Q?R7NoOI8huj5qyaXsnEhPG13MxFoZEs+oxL24Wymh4r6n/rlsZtZaMJ1gI2RG?=
 =?us-ascii?Q?6srmsZqh+PuXATyzkYRctJD9g9zCKAXxQoC1SRbADjH22d7qhz6ASp4rcqg5?=
 =?us-ascii?Q?bCgsv+I8vOLK+6k=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700013)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2025 05:01:41.8833
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d1dc2249-0ddb-44d9-fdc6-08dd39d8b20d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB54.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8439

Zheyun Shen <szy0127@sjtu.edu.cn> writes:

> On AMD CPUs without ensuring cache consistency, each memory page
> reclamation in an SEV guest triggers a call to wbinvd_on_all_cpus(),
> thereby affecting the performance of other programs on the host.
>
> Typically, an AMD server may have 128 cores or more, while the SEV guest
> might only utilize 8 of these cores. Meanwhile, host can use qemu-affinity
> to bind these 8 vCPUs to specific physical CPUs.
>
> Therefore, keeping a record of the physical core numbers each time a vCPU
> runs can help avoid flushing the cache for all CPUs every time.
>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Zheyun Shen <szy0127@sjtu.edu.cn>
> ---
>  arch/x86/kvm/svm/sev.c | 39 ++++++++++++++++++++++++++++++++++++---
>  arch/x86/kvm/svm/svm.c |  2 ++
>  arch/x86/kvm/svm/svm.h |  5 ++++-
>  3 files changed, 42 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 1ce67de9d..91469edd1 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -252,6 +252,36 @@ static void sev_asid_free(struct kvm_sev_info *sev)
>  	sev->misc_cg = NULL;
>  }
>  
> +static struct cpumask *sev_get_wbinvd_dirty_mask(struct kvm *kvm)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;

There is a helper to get sev_info: to_kvm_sev_info(), if you use that,
sev_get_wbinvd_dirty_mask() helper will not be needed.

> +
> +	return sev->wbinvd_dirty_mask;
> +}
> +
> +void sev_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> +{
> +	/*
> +	 * To optimize cache flushes when memory is reclaimed from an SEV VM,
> +	 * track physical CPUs that enter the guest for SEV VMs and thus can
> +	 * have encrypted, dirty data in the cache, and flush caches only for
> +	 * CPUs that have entered the guest.
> +	 */
> +	cpumask_set_cpu(cpu, sev_get_wbinvd_dirty_mask(vcpu->kvm));
> +}
> +
> +static void sev_do_wbinvd(struct kvm *kvm)
> +{
> +	struct cpumask *dirty_mask = sev_get_wbinvd_dirty_mask(kvm);
> +
> +	/*
> +	 * TODO: Clear CPUs from the bitmap prior to flushing.  Doing so
> +	 * requires serializing multiple calls and having CPUs mark themselves
> +	 * "dirty" if they are currently running a vCPU for the VM.
> +	 */
> +	wbinvd_on_many_cpus(dirty_mask);
> +}

Something like the below

void sev_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
{
        /* ... */
        cpumask_set_cpu(cpu, to_kvm_sev_info(kvm)->wbinvd_dirty_mask);
}

static void sev_do_wbinvd(struct kvm *kvm)
{
        /* ... */
        wbinvd_on_many_cpus(to_kvm_sev_info(kvm)->wbinvd_dirty_mask);
}

Regards,
Nikunj


