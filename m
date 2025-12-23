Return-Path: <kvm+bounces-66610-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D449CD87F5
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 09:59:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A53DA3022F03
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 08:59:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF726322C77;
	Tue, 23 Dec 2025 08:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="b0NNZ9m9"
X-Original-To: kvm@vger.kernel.org
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012043.outbound.protection.outlook.com [52.101.43.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D08322B73;
	Tue, 23 Dec 2025 08:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766480381; cv=fail; b=jGUczYrawxg0hbQGZ6wRYp1cgF/cLNrVtmtFb2L/l8s/5wrmQSHXfMvGUJ6vEnWnN5ImdrukjzKXpiJv/YUvE1vNlGKx3R8vC5kze5DZYtZ90nedEtJLEMQ6pNt0l1yyjJQiALlLJpZfaqJafGnNXN99+Qbrdby8fT81zhJMVDY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766480381; c=relaxed/simple;
	bh=JHM3aiS8pUf4hT6YFAv4SPwSp3e+vEJFn1Jmei2ZvOo=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=beY8ZF/1+1Y+KhFwi64yuH34t3brVkZ/jaG2aLAoDdq/Jdxw8WLpkJEZoGmSh6/4hF57yVLyya/tLkx10X8B/y+tFISzON1dB5IelzSewr5FyjaAzvJ/CF4BUsErIVdzeTjx3sC3RQ1Q/7OM61ld5RXMsQn4kQ8Tv+qsXC+qpT4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=b0NNZ9m9; arc=fail smtp.client-ip=52.101.43.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bZLqQAEgwgVHHU02teCZUI3xuiLlDgraiu3nMA4XChAmmC1O1Aj+ZvsvbSRUvaxCbe1VtvmwrXLCpHpsVHCVy4LtpXGeIrkh1UyPeNfLqEjfo5v+VaOX4z8lP3dT1tIvo7ph0duMDwIBxPFsEKrGzwG49hktydZaVgy3dWPBDvVqHX7Hrfc/TPEzbr1feEMmjjM0ZugfLIpQzI/s3xYdt8gD2nCDbNco9pYwKUISUigR4bLr+Rbkgj4ibuadEKpMWvrpy+hLRxD2x8NPVTRAwjkOMEGx6vagQiBLW77V1cBZeHyn6YjR8VIRj6C9pGRSFcpgHZdP1OqM8Ha0ddkqKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=12bL4pV2x92K5QmLODMNEuHdkTHwtldnFUlDk1fCpFs=;
 b=s0AXCCrnlD/5o7j8WgCBN51FcnH3zVmDztKJSDFmRr2elk84yktucClRfoyUMaHxRhnYHCo2OCpa0soNokheTz9COhbwDbTrJMTahvx/PV7ab+ACCYupmZxaVWByhXT2a7kEPvd8OSsQiup5SfH+jJcm10ueha51bXvsec08xwAo89H8pWQO+9hRLx7D9+FH1+DcsqPUjjDE345EnW2aGXpkx+x1dZY0EWCN0oXcxbdRq35ry2hd8h1RhhYtw7cuFiQG2nC7EQlIhjhjXBOYd4/q6CiGNdCKxjs1k/QhtOUFGL5tqQQu3fPDxmK5PCupaZGoqppGTJkX/PxWQGjPAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=12bL4pV2x92K5QmLODMNEuHdkTHwtldnFUlDk1fCpFs=;
 b=b0NNZ9m9Zp9/IQRRTwYlpRF3dvkZt65KwuHq36M3CFDiOTo1zPSqlSj0CX/1ErTh8h/K3iSK5VjFJdeNQnkX4IgFjtks9szgRuSTZ1sqlGYCyH3ly9azQDWS37gOIjzJTMdRhgTDaJENLFYp4psC1lrA1fyqdakeyrVdsg3w7Z0=
Received: from SJ0PR03CA0054.namprd03.prod.outlook.com (2603:10b6:a03:33e::29)
 by IA0PR12MB8208.namprd12.prod.outlook.com (2603:10b6:208:409::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.11; Tue, 23 Dec
 2025 08:59:34 +0000
Received: from SJ1PEPF00002323.namprd03.prod.outlook.com
 (2603:10b6:a03:33e:cafe::d0) by SJ0PR03CA0054.outlook.office365.com
 (2603:10b6:a03:33e::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.11 via Frontend Transport; Tue,
 23 Dec 2025 08:59:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00002323.mail.protection.outlook.com (10.167.242.85) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9456.9 via Frontend Transport; Tue, 23 Dec 2025 08:59:33 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 23 Dec
 2025 02:59:33 -0600
Received: from amd.com (10.180.168.240) by satlexmb08.amd.com (10.181.42.217)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Tue, 23 Dec 2025 02:59:28 -0600
Date: Tue, 23 Dec 2025 08:59:15 +0000
From: Ankit Soni <Ankit.Soni@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>, Joerg Roedel <joro@8bytes.org>, "David
 Woodhouse" <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<kvm@vger.kernel.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Sairaj Kodilkar <sarunkod@amd.com>, "Vasant
 Hegde" <vasant.hegde@amd.com>, Maxim Levitsky <mlevitsk@redhat.com>, "Joao
 Martins" <joao.m.martins@oracle.com>, Francesco Lavra
	<francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>, "Naveen
 Rao" <Naveen.Rao@amd.com>
Subject: Re: possible deadlock due to irq_set_thread_affinity() calling into
 the scheduler (was Re: [PATCH v3 38/62] KVM: SVM: Take and hold ir_list_lock
 across IRTE updates in IOMMU)
Message-ID: <flitmw3b2imbpbyhygaushwt4h6k3fa5l2ebdfkl7knw5ghvod@ioqe2bsvq6vz>
References: <20250611224604.313496-2-seanjc@google.com>
 <20250611224604.313496-40-seanjc@google.com>
 <njhjud3e6wbdftzr3ziyuh5bhyvc5ndt5qvmg7rlvh5isoop2l@f2uxctws2c7d>
 <42513cb3-3c2e-4aa8-b748-23b6656a5096@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <42513cb3-3c2e-4aa8-b748-23b6656a5096@redhat.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002323:EE_|IA0PR12MB8208:EE_
X-MS-Office365-Filtering-Correlation-Id: d4a54094-8a13-4b83-b517-08de420197a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dTl2WUdFZTdCWVYvSExNTEQ2NERUT3BaUXR1QlpyY1J2c01qWTdqRWE1T0Nx?=
 =?utf-8?B?WHEvY012UktSUFFGTzJ4bGpGRzlqTkRaaFgzWWF6eXB6ancvVmpDeXZWNmI0?=
 =?utf-8?B?UWJoRUVTSkNVcEJqZmprWUxQc1FidFVvN1BXMVFkdGJyUHlTSzZtOFhQTCtG?=
 =?utf-8?B?ekJQb3RhZDlZcWkwaTlQcHRzRVZmbFVjUnZkb3duY0Fid1dSU0w2YWtkbEk5?=
 =?utf-8?B?dXpRQ2duVkFKSW5rYUd1eEg1eHVRaE9FUytTWGQ5SjU1Q2JNWGpXdkFaWUZQ?=
 =?utf-8?B?SWRoZDZ1bnJkWkhlM0wyWlk4d0Y2bmp3dDRHbXYwaEVsamo3blRZVmVOL3Ro?=
 =?utf-8?B?YmFoeW1rd3J4U3RnOTZ4eVU4dzBDeDZpNCt0VXR4aDlRY21Pb3NXTEpRT3Ir?=
 =?utf-8?B?MG84em0remduOG5uQXNFbDgwdVREU2Fyb1dUVlRjaG9icE53NmhkdU1ZWWor?=
 =?utf-8?B?L094NmdZUDFZdExmUEtGL3dnRG0zUmVaQmZNVzZZQ2l3a2ZlQlNWUHE4akVw?=
 =?utf-8?B?Y054am9oM0dZMTRjUUtzdi8vTUlOcEc2c2NIcldhSGtiZzBkeDhxZ29QSWQ5?=
 =?utf-8?B?TTJPN05jRHdHSElBcytlQXBGZXk3YjhudFBNOWZqT0hyTjN2cG9LclVsNFJI?=
 =?utf-8?B?VExIcUdLeEVmQXkvYWpydjE5MWU5c0VNVXpDdnVkNjdIYk05UE1wbDZMQzhU?=
 =?utf-8?B?NlVYUExLYWRQeXlqNXRmZjRvSkVvUVBxTjlrcjBJVzhlTDR2Y3QrT1h4UmNr?=
 =?utf-8?B?ME9NWkpiSEg5OGd3VE5aejh0Y1JYMU1Hb25QSHVoL2xKOXEyUXFOVmxiSGpm?=
 =?utf-8?B?eGJkWDd4QzZsaGcralV5MkNtZDhzQ3BVVUFyNnRFbXJ6SHRDMEY0d2hGTkZL?=
 =?utf-8?B?NWp5dUNNdExWSi9RZjc4SU1YaVJlK1ZBd3ZzRnVjSzdTUlkyazFVdFAwRHFU?=
 =?utf-8?B?MzZ2eExCUmsvLzdHTnE1c3U0elVGaCtvZ1FNYnJBNjQyR29lT1FDU2NCdFNG?=
 =?utf-8?B?K1hqMDRJUlE2dEo4czFEQXVxWXlzUWpIY3U2MWFyeHI3WVRpRlArVlBnM2tm?=
 =?utf-8?B?a1RadWYvemsybUF4VDRDYnhwMmNRcXV5LzRqTkZyOWtWQkFScGhaMlRmVyt0?=
 =?utf-8?B?TTJKaFRFY1lZNDJPOEZVc2E0YmxKVFE2K2dmVS9vMkMzNDhuRUh0TDBPTFJH?=
 =?utf-8?B?eVBjQ25SaW5sVzE0M1Nkc0lwL252bTBZQ3IrK28yaEhXRWFZMERIL0xjUi95?=
 =?utf-8?B?dEFOQXp2b1UzaCtsVmlTVWZMVW9hNC9yY04zVVBURlhINStCT0NDOGxSMFFF?=
 =?utf-8?B?bW1CV2VhcVhzclZPTkh2b0ZIWVVuV3FFNHNTQ0ZGNzJZV0lLMzZpWVJQb1dR?=
 =?utf-8?B?bE1UUUZCMGRDM1FYeU1sOVloUHpGWG5aaWJjUkZES040MmE1bkw0TUdMNEpp?=
 =?utf-8?B?ZnpibCtwUVdRN0hUOWtYTzVhOHEydmc2OXpNNVh6czhJNGNsU3JjbHp2Z21B?=
 =?utf-8?B?QXNhd2hJRjY0Ym1UV0NwZW5RajZJT2o2RFh2RnlPdE5Ub3ZYNkZnRWJlN2pl?=
 =?utf-8?B?b1YyZE5pWjk1ZkN5Qk0wbEhQdmV3TGZoekxiaFhkRVZ6dXJBQmxXRm02aGJv?=
 =?utf-8?B?OFY4eTNnTFc5czNRWi9rQ0I4c2RZOXI0K2JpbXZIZ1pZVXh2RXh6S3NiZ3o1?=
 =?utf-8?B?Q2c0TXJ6Vko2YkY5T0kxN01heDlXM0NZNkJJbmRGME9vbWxDZC9lUUxjMUJr?=
 =?utf-8?B?TnFzWU9lbCsxNmNLQ0xiU3FQQk8zN3lhWlg0UXpyanFFeml1R3ZnZlI1cXo5?=
 =?utf-8?B?RElkWlkrRldtZnVwbFp1VXJJSGVuZE81RThIcElISSsrVWFmNURPZHBtZlFU?=
 =?utf-8?B?eWhDQWNVMXEzNHZJY25IWnZNYVdGT3g3Q0ZOaGZvb0h5SlpHWnRaakphTS9o?=
 =?utf-8?B?bExNWEpWdWVBcUV5REZwemdVWXIzQS83N2dMZFo3UnFqUHVaZXVuTSt5V2xV?=
 =?utf-8?B?Um05R016YU9YSHVpamRxaUx0R2pGOCt5Q0JIY1dzT0lrSzBqdnI2Um03NDhn?=
 =?utf-8?B?R1hWRFBlSHhYMWRNS3A1UW5KVVowcFZveTlYOCtUM014Nk1lcER0dCsvZXdQ?=
 =?utf-8?Q?hLvM=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2025 08:59:33.8742
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d4a54094-8a13-4b83-b517-08de420197a9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002323.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8208

On Mon, Dec 22, 2025 at 03:09:13PM +0100, Paolo Bonzini wrote:
> On 12/22/25 10:16, Ankit Soni wrote:
> >    ======================================================
> >    WARNING: possible circular locking dependency detected
> >    6.19.0-rc2 #20 Tainted: G            E
> >    ------------------------------------------------------
> >    CPU 58/KVM/28597 is trying to acquire lock:
> >      ff12c47d4b1f34c0 (&irq_desc_lock_class){-.-.}-{2:2}, at: __irq_get_desc_lock+0x58/0xa0
> > 
> >      but task is already holding lock:
> >      ff12c49b28552110 (&svm->ir_list_lock){....}-{2:2}, at: avic_pi_update_irte+0x147/0x270 [kvm_amd]
> > 
> >      which lock already depends on the new lock.
> > 
> >    Chain exists of:
> >      &irq_desc_lock_class --> &rq->__lock --> &svm->ir_list_lock
> > 
> >    Possible unsafe locking scenario:
> > 
> >          CPU0                            CPU1
> >          ----                            ----
> >     lock(&svm->ir_list_lock);
> >                                        lock(&rq->__lock);
> >                                        lock(&svm->ir_list_lock);
> >     lock(&irq_desc_lock_class);
> > 
> >          *** DEADLOCK ***
> > 
> > So lockdep sees:
> > 
> >    &irq_desc_lock_class -> &rq->__lock -> &svm->ir_list_lock
> > 
> > while avic_pi_update_irte() currently holds svm->ir_list_lock and then
> > takes irq_desc_lock via irq_set_vcpu_affinity(), which creates the
> > potential inversion.
> > 
> >    - Is this lockdep warning expected/benign in this code path, or does it
> >      indicate a real potential deadlock between svm->ir_list_lock and
> >      irq_desc_lock with AVIC + irq_bypass + VFIO?
> 
> I'd treat it as a potential (if unlikely) deadlock:
> 
> (a) irq_set_thread_affinity triggers the scheduler via wake_up_process,
> while irq_desc->lock is taken
> 
> (b) the scheduler calls into KVM with rq_lock taken, and KVM uses
> ir_list_lock within __avic_vcpu_load/__avic_vcpu_put
> 
> (c) KVM wants to block scheduling for a while and uses ir_list_lock for
> that purpose, but then takes irq_set_vcpu_affinity takes irq_desc->lock.
> 
> I don't think there's an alternative choice of lock for (c); and there's
> no easy way to pull the irq_desc->lock out of the IRQ subsystem--in fact
> the stickiness of the situation comes from rq->rq_lock and
> irq_desc->lock being both internal and not leaf.
> 
> Of the three, the most sketchy is (a); notably, __setup_irq() calls
> wake_up_process outside desc->lock.  Therefore I'd like so much to treat
> it as a kernel/irq/ bug; and the simplest (perhaps too simple...) fix is
> to drop the wake_up_process().  The only cost is extra latency on the
> next interrupt after an affinity change.
> 
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index 8b1b4c8a4f54..fc135bd079a4 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -189,14 +189,10 @@ static void irq_set_thread_affinity(struct irq_desc *desc)
>  	struct irqaction *action;
>  	for_each_action_of_desc(desc, action) {
> -		if (action->thread) {
> +		if (action->thread)
>  			set_bit(IRQTF_AFFINITY, &action->thread_flags);
> -			wake_up_process(action->thread);
> -		}
> -		if (action->secondary && action->secondary->thread) {
> +		if (action->secondary && action->secondary->thread)
>  			set_bit(IRQTF_AFFINITY, &action->secondary->thread_flags);
> -			wake_up_process(action->secondary->thread);
> -		}
>  	}
>  }
> Marc, what do you think?
> 
> Paolo
> 

Hi Paolo,
With the above patch I’m still seeing the same circular dependency warning.
However, and with Sean’s patch I’m not seeing any warnings.

[  335.128640] ======================================================
[  335.128650] WARNING: possible circular locking dependency detected
[  335.128660] 6.19.0-rc2-dirty #21 Tainted: G            E
[  335.128668] ------------------------------------------------------
[  335.128675] CPU 96/KVM/28699 is trying to acquire lock:
[  335.128682] ff453c6b59bb18c0 (&irq_desc_lock_class){-.-.}-{2:2}, at: __irq_get_desc_lock+0x58/0xa0
[  335.128704]
               but task is already holding lock:
[  335.128712] ff453c8b0946e600 (&svm->ir_list_lock){....}-{2:2}, at: avic_pi_update_irte+0x147/0x270 [kvm_amd]
[  335.128732]
               which lock already depends on the new lock.

[  335.128742]
               the existing dependency chain (in reverse order) is:
[  335.128751]
               -> #4 (&svm->ir_list_lock){....}-{2:2}:
[  335.128760]        _raw_spin_lock_irqsave+0x4e/0xb0
[  335.128772]        __avic_vcpu_put+0x7a/0x150 [kvm_amd]
[  335.128783]        avic_vcpu_put+0x50/0x70 [kvm_amd]
[  335.128791]        svm_vcpu_put+0x38/0x70 [kvm_amd]
[  335.128800]        kvm_arch_vcpu_put+0x21b/0x330 [kvm]
[  335.128854]        kvm_sched_out+0x62/0x90 [kvm]
[  335.128893]        __schedule+0x8d3/0x1d10
[  335.128901]        __cond_resched+0x5c/0x80
[  335.128909]        __kmalloc_cache_noprof+0x3d7/0x730
[  335.128920]        kvm_hv_vcpu_init+0x48/0x260 [kvm]
[  335.128957]        kvm_hv_set_msr_common+0x5b/0x12a0 [kvm]
[  335.128988]        kvm_set_msr_common+0x468/0x1310 [kvm]
[  335.129019]        svm_set_msr+0x645/0x730 [kvm_amd]
[  335.129028]        __kvm_set_msr+0xa3/0x2f0 [kvm]
[  335.129066]        kvm_set_msr_ignored_check+0x23/0x1b0 [kvm]
[  335.129096]        do_set_msr+0x76/0xd0 [kvm]
[  335.129126]        msr_io+0xbe/0x1c0 [kvm]
[  335.129152]        kvm_arch_vcpu_ioctl+0x700/0x2090 [kvm]
[  335.129181]        kvm_vcpu_ioctl+0x632/0xc60 [kvm]
[  335.129215]        __x64_sys_ioctl+0xa5/0x100
[  335.129224]        x64_sys_call+0x1243/0x26b0
[  335.129234]        do_syscall_64+0x93/0x1470
[  335.129242]        entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  335.129251]
               -> #3 (&rq->__lock){-.-.}-{2:2}:
[  335.129259]        _raw_spin_lock_nested+0x32/0x80
[  335.129267]        raw_spin_rq_lock_nested+0x22/0xa0
[  335.129276]        task_rq_lock+0x5f/0x150
[  335.129392]        cgroup_move_task+0x46/0x110
[  335.129494]        css_set_move_task+0xe1/0x240
[  335.129614]        cgroup_post_fork+0x98/0x2d0
[  335.129704]        copy_process+0x1ea8/0x2330
[  335.129795]        kernel_clone+0xa7/0x440
[  335.129883]        user_mode_thread+0x63/0x90
[  335.129970]        rest_init+0x28/0x200
[  335.130056]        start_kernel+0xae0/0xcd0
[  335.130144]        x86_64_start_reservations+0x18/0x30
[  335.130230]        x86_64_start_kernel+0xfd/0x150
[  335.130312]        common_startup_64+0x13e/0x141
[  335.130396]
               -> #2 (&p->pi_lock){-.-.}-{2:2}:
[  335.130554]        _raw_spin_lock_irqsave+0x4e/0xb0
[  335.130631]        try_to_wake_up+0x59/0xaa0
[  335.130709]        wake_up_process+0x15/0x30
[  335.130785]        create_worker+0x154/0x250
[  335.130862]        workqueue_init+0x414/0x760
[  335.130938]        kernel_init_freeable+0x24f/0x630
[  335.131013]        kernel_init+0x1b/0x200
[  335.131086]        ret_from_fork+0x344/0x3a0
[  335.131161]        ret_from_fork_asm+0x1a/0x30
[  335.131235]
               -> #1 (&pool->lock){-.-.}-{2:2}:
[  335.131375]        _raw_spin_lock+0x34/0x80
[  335.131448]        __queue_work+0xf4/0x740
[  335.131523]        queue_work_on+0x70/0xd0
[  335.131595]        irq_set_affinity_locked+0x13b/0x250
[  335.131669]        __irq_apply_affinity_hint+0xf8/0x120
[  335.131742]        mlx5_irq_alloc+0x28e/0x4e0 [mlx5_core]
[  335.131884]        mlx5_irq_request+0x125/0x140 [mlx5_core]
[  335.131997]        mlx5_irq_request_vector+0xb4/0x110 [mlx5_core]
[  335.132107]        comp_irq_request_pci+0x68/0xf0 [mlx5_core]
[  335.132219]        mlx5_comp_eqn_get+0x127/0x850 [mlx5_core]
[  335.132327]        mlx5e_create_cq+0x58/0x260 [mlx5_core]
[  335.132452]        mlx5e_open_drop_rq+0x11c/0x220 [mlx5_core]
[  335.132573]        mlx5e_init_nic_rx+0x2c/0x270 [mlx5_core]
[  335.132687]        mlx5e_attach_netdev+0xed/0x340 [mlx5_core]
[  335.132794]        _mlx5e_resume+0x6a/0xd0 [mlx5_core]
[  335.132900]        mlx5e_probe+0x5e3/0xa50 [mlx5_core]
[  335.133010]        auxiliary_bus_probe+0x45/0x90
[  335.133086]        really_probe+0xf1/0x410
[  335.133160]        __driver_probe_device+0x8c/0x190
[  335.133233]        driver_probe_device+0x24/0xd0
[  335.133305]        __device_attach_driver+0xcd/0x170
[  335.133377]        bus_for_each_drv+0x99/0x100
[  335.133450]        __device_attach+0xba/0x1f0
[  335.133523]        device_initial_probe+0x4e/0x50
[  335.133595]        bus_probe_device+0x3c/0xa0
[  335.133668]        device_add+0x6af/0x8a0
[  335.133740]        __auxiliary_device_add+0x43/0xc0
[  335.133813]        add_adev+0xd3/0x160 [mlx5_core]
[  335.133931]        mlx5_rescan_drivers_locked+0x1ee/0x340 [mlx5_core]
[  335.134045]        mlx5_register_device+0x37/0xb0 [mlx5_core]
[  335.134156]        mlx5_init_one_devl_locked+0x43e/0x710 [mlx5_core]
[  335.134267]        probe_one+0x35b/0x530 [mlx5_core]
[  335.134382]        local_pci_probe+0x47/0xb0
[  335.134460]        work_for_cpu_fn+0x1a/0x30
[  335.134538]        process_one_work+0x22b/0x6f0
[  335.134613]        worker_thread+0x1c6/0x3b0
[  335.134687]        kthread+0x110/0x230
[  335.134764]        ret_from_fork+0x344/0x3a0
[  335.134838]        ret_from_fork_asm+0x1a/0x30
[  335.134913]
               -> #0 (&irq_desc_lock_class){-.-.}-{2:2}:
[  335.135059]        __lock_acquire+0x1595/0x2640
[  335.135135]        lock_acquire+0xc4/0x2c0
[  335.135210]        _raw_spin_lock_irqsave+0x4e/0xb0
[  335.135286]        __irq_get_desc_lock+0x58/0xa0
[  335.135362]        irq_set_vcpu_affinity+0x4a/0x100
[  335.135438]        avic_pi_update_irte+0x170/0x270 [kvm_amd]
[  335.135521]        kvm_pi_update_irte+0xea/0x220 [kvm]
[  335.135633]        kvm_arch_irq_bypass_add_producer+0x9b/0xb0 [kvm]
[  335.135737]        __connect+0x5f/0x100 [irqbypass]
[  335.135815]        irq_bypass_register_producer+0xe4/0xb90 [irqbypass]
[  335.135895]        vfio_msi_set_vector_signal+0x1b0/0x330 [vfio_pci_core]
[  335.135979]        vfio_msi_set_block+0x5a/0xd0 [vfio_pci_core]
[  335.136060]        vfio_pci_set_msi_trigger+0x19e/0x260 [vfio_pci_core]
[  335.136142]        vfio_pci_set_irqs_ioctl+0x46/0x140 [vfio_pci_core]
[  335.136224]        vfio_pci_core_ioctl+0x6ea/0xc20 [vfio_pci_core]
[  335.136306]        vfio_device_fops_unl_ioctl+0xb1/0x9d0 [vfio]
[  335.136390]        __x64_sys_ioctl+0xa5/0x100
[  335.136470]        x64_sys_call+0x1243/0x26b0
[  335.136553]        do_syscall_64+0x93/0x1470
[  335.136632]        entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  335.136712]
               other info that might help us debug this:

[  335.136942] Chain exists of:
                 &irq_desc_lock_class --> &rq->__lock --> &svm->ir_list_lock

[  335.137178]  Possible unsafe locking scenario:

[  335.137340]        CPU0                    CPU1
[  335.137420]        ----                    ----
[  335.137502]   lock(&svm->ir_list_lock);
[  335.137582]                                lock(&rq->__lock);
[  335.137664]                                lock(&svm->ir_list_lock);
[  335.137746]   lock(&irq_desc_lock_class);
[  335.137826]
                *** DEADLOCK ***

[  335.138057] 4 locks held by CPU 96/KVM/28699:
[  335.138136]  #0: ff453c6c28bae800 (&vdev->igate){+.+.}-{4:4}, at: vfio_pci_core_ioctl+0x6d2/0xc20 [vfio_pci_core]
[  335.138223]  #1: ffffffffc0faf110 (lock#10){+.+.}-{4:4}, at: irq_bypass_register_producer+0x31/0xb90 [irqbypass]
[  335.138310]  #2: ff453c8b11179478 (&kvm->irqfds.lock){....}-{3:3}, at: kvm_arch_irq_bypass_add_producer+0x2d/0xb0 [kvm]
[  335.138423]  #3: ff453c8b0946e600 (&svm->ir_list_lock){....}-{2:2}, at: avic_pi_update_irte+0x147/0x270 [kvm_amd]

-Ankit

