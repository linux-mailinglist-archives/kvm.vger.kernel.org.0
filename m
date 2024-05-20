Return-Path: <kvm+bounces-17802-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AD058CA4C4
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 00:56:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EC8291F211B3
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 22:56:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26E7B137C55;
	Mon, 20 May 2024 22:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KWew3cDH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2086.outbound.protection.outlook.com [40.107.223.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76DC650A68;
	Mon, 20 May 2024 22:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716245481; cv=fail; b=cOdsFNcMAWAaCbLmZx43JFveo1Sgm98gG7qRxJPdH+vwtgoRfXSqw7TRMgDygLXVh1NVycXxYNPVsg+U13tq8Q+jv1n9ExWrigAzwE0IXer6JH2ovQbaGMiHcalsYxDA3o0+Ck6rt2QVjKAOSABXIm+84/WtFRv9hVW3kscW5Us=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716245481; c=relaxed/simple;
	bh=OUb8rRkg6p2fz67Z51cPS+T8YGYNrfZWpqoWDwC2MaY=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L7gWnx9Hr0r7Z1aRkt5Cjmr1wF6dQilYQurfZuT5A2azk9AWB4wgaOHBFh5E/vuk05crF1PmynNLXKVLnHSfRD8MlkcRgIoXzxTapk0G0eyIDYMEZ96Z6fFkDNWE/G16s5MlGXqdyyorTqJdWrcnHg5kHKyX9zlmvcZ12Z8EW08=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KWew3cDH; arc=fail smtp.client-ip=40.107.223.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kOZGj7+n9qpdADgLYZKpdPrmD5GQtCibd7htftYIKu0lju2U9kVYoUK+csDbgCOJeB/Kg/X9o/4R4FT5NbFUnCe9qkg7xqsaAgXJsKPgHXlHryK3ofbYEXH5t1Qi6A21OrV4MzJkglamTgnq93uCe2+grRzxjiwJdpRjNK6l+YoF1SJvDH4b5X1VjbCwWPVbSA4SVVOZnErINtxp2OBFyAC0jYFRIa4+Oq8vu4EVvtJ+n88bjR8mPMyv+yMedGeCP3fN0LyjAkHf4sOWjLVosnW8f0EhLC78/btGXl5qEIlZwE4qB44IxxaAibpDdEHZ9309U+YG4UYPrqR5N1bmoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lfr0FTlF298ECHw4NXy+gQFL4aX2FCr0rdRcaYcRbtM=;
 b=ihC1UKXMXLYi6FhLEVBBjYfjkWi0OH7v2jD6n3FQI4M8nHxpuFsGDCwOpX6Zdpop/sMigBkBGpHEFPH36t+gygL024pntzPVJB7/pgQQLlLf6e/AFV61xWcGRjZ3bowJBdiQj7S4CZSHRwhPxYn0QdeYtvNvkkoxBYGs6MjieMOOkli1v0R2AGZnOD0s/mEC/lTvBLR+mXSslgEIqKXVKbFpepRYgifAX4mcWNS1AgC8p8tkTrAQ5DAovbqMZye59LFtYdymIkQs6eVmTr3smyk55aghYwhE1OjBP2DuNfKYR5WUe984quUvLTRmQgyL0RCby1dwhPVTMKMo5UOM8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lfr0FTlF298ECHw4NXy+gQFL4aX2FCr0rdRcaYcRbtM=;
 b=KWew3cDHfwsGJC8E/11xppbOq0tCq/pk6T8RH79BilnLwKFBHrESmNX0sfGJVbbd/KgyjNlNfHuoTnPbTQk8S1PnDAnPubZ3LYW7H4Ytoku4P+8R9oZI0dM/sMV+K910CpUrbZDFsPtw5LMgQxwsktlXR5LuEsL2kIYnTAhQCvo=
Received: from SN7PR04CA0073.namprd04.prod.outlook.com (2603:10b6:806:121::18)
 by SN7PR12MB7884.namprd12.prod.outlook.com (2603:10b6:806:343::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.35; Mon, 20 May
 2024 22:51:16 +0000
Received: from SN1PEPF00036F41.namprd05.prod.outlook.com
 (2603:10b6:806:121:cafe::10) by SN7PR04CA0073.outlook.office365.com
 (2603:10b6:806:121::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.35 via Frontend
 Transport; Mon, 20 May 2024 22:51:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00036F41.mail.protection.outlook.com (10.167.248.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7611.14 via Frontend Transport; Mon, 20 May 2024 22:51:16 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 20 May
 2024 17:51:15 -0500
Date: Mon, 20 May 2024 17:50:44 -0500
From: Michael Roth <michael.roth@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: Michael Roth <mdroth@utexas.edu>, <pbonzini@redhat.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<rick.p.edgecombe@intel.com>
Subject: Re: [PATCH] KVM: SEV: Fix guest memory leak when handling guest
 requests
Message-ID: <iqzde53xfkcpqpjvrpyetklutgqpepy3pzykwpdwyjdo7rth3m@taolptudb62c>
References: <58492a1a-63bb-47d2-afef-164557d15261@redhat.com>
 <20240518150457.1033295-1-michael.roth@amd.com>
 <ZktbBRLXeOp9X6aH@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZktbBRLXeOp9X6aH@google.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F41:EE_|SN7PR12MB7884:EE_
X-MS-Office365-Filtering-Correlation-Id: 548c9d37-5f8a-4214-b8b6-08dc791f5b86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|82310400017|1800799015|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ecpLzKjdMRgo6o8zxEQKb2bmPP1GWZd/eOqlVqiUpCOTh/maDuKBI7yUbuWU?=
 =?us-ascii?Q?hZD+dCReu+DKKrQCU1eFbEyOFROvOyoX5FkwLriEYR7G/8vEFNyWcDMjBNtp?=
 =?us-ascii?Q?VH/PxY0RBKp2id0b7MP+r+ZRDnphV9+I5TMOncHgyAo+exHWvypm9PGxIOye?=
 =?us-ascii?Q?zCZ+5xF6oSEjQ9wmViGqDRE2Ou1oqqxZgMB6OaTd5PyB1qufsSv6qWu+TDVZ?=
 =?us-ascii?Q?ObbsWu/JJ9OrpW6f0eUC280R2Yy/xdPXNaFQZZBAuVmbq5hWwTJ13ZcY+vY1?=
 =?us-ascii?Q?sBw9iwYEl5HUbAJ6R50q+GNm/PRthckdVSQkR+exHy2FeCIRae6RO7FR7duO?=
 =?us-ascii?Q?i26KFbZFauu98Bo9IsvCqv1vPYKx/pCH2MxLxMYoZQb2LK6Vg7gCc+mVBCAk?=
 =?us-ascii?Q?6fk95ZYjZMBxQxclw7n6lWzoPWzHpXLb+u0/Paqf1s/p1kqVB4N7sOTNwma9?=
 =?us-ascii?Q?Z+D+utRdtLxVpwEDQ/yN2pK3lnuj10eVmnpWtfApOKRCRP6ywUXWuGEDKTeh?=
 =?us-ascii?Q?VR+Z71PGMl3x0/9zGQ1oeQz68t/omMTalielhlBy6FRWTAFM5PpLkzL9kGUz?=
 =?us-ascii?Q?yb0FPVteh4YtqXuS/pjJu8MdAUyO+Q9mpUjK/ZHbMHh5morrXaJCPnxdVojM?=
 =?us-ascii?Q?kEBc4aJdDqobieWu4hdYPkEDCtntXSFM1PBEsvZfRAykSnGrvKlO45tnBxgu?=
 =?us-ascii?Q?L24ibS6SbLGrEPt3g2jaBvgQu6LnDjBlh02sp7Knq7JwbQSqdr+KPVkCADXv?=
 =?us-ascii?Q?gVv/uNak7HK1ZwgAa+cZLH5llRkzMVxTFp0cY+PCIjBC5aChyH3f2KxdDvjN?=
 =?us-ascii?Q?wkaY0dXblIbJr7lKaaNOjkZKSFtGISSigmf8fgLNvw0Tdfum2i1lUuFGnZ0c?=
 =?us-ascii?Q?ehWBOEcSZqpswXM3WLu4QyiaQJTzRxuMyf9Ns+rZ7tAdEeg6lpZkqDtu5cb+?=
 =?us-ascii?Q?Qm/u8nKhCp8vT0Gz196uTOfxvsVz97cMFeOtlXEJuS429maKZ/mlr2meuuZt?=
 =?us-ascii?Q?F/Hv+GyarsQscWYf9XKwBr3RpTPlvh2I2e2onQ/kSDwFtkbMQoUuofUquiog?=
 =?us-ascii?Q?O+YG4+6Kyc7EgWI1HPtPJo6eoqco664UYstPJh4tEiQK/wEx1qPYrE4T6w0A?=
 =?us-ascii?Q?uqHX4NzohklfcWORkXHovjWyhQ8yyTVOcS5hJIERfW0lkpYLGpUhJirlUoib?=
 =?us-ascii?Q?u6TqallcohnAneSbrVD3AS6ys0Qyc/tp2Tnq1JOxbBI8t0XAJRz3UrUA1cns?=
 =?us-ascii?Q?IxHaqs/qmq39aaI+dNJA0CgcaATHqT6urdoiZC8iTOkTNxTk41qEfzHXDx/F?=
 =?us-ascii?Q?rqEdNm5wDscvmLyF6RGEGECdXarVs4whxEdnH8B4KyYR1w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(82310400017)(1800799015)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2024 22:51:16.5645
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 548c9d37-5f8a-4214-b8b6-08dc791f5b86
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F41.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7884

On Mon, May 20, 2024 at 07:17:13AM -0700, Sean Christopherson wrote:
> This needs a
> 
>   From: Michael Roth <michael.roth@amd.com>
> 
> otherwise Author will be assigned to your @utexas.edu email.

Thanks, I hadn't considered that. My work email issue seems to be
resolved now, but will keep that in mind if I ever need to use a
fallback again.

> 
> On Sat, May 18, 2024, Michael Roth wrote:
> > Before forwarding guest requests to firmware, KVM takes a reference on
> > the 2 pages the guest uses for its request/response buffers. Make sure
> > to release these when cleaning up after the request is completed.
> > 
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > ---
> 
> ...
> 
> > @@ -3970,14 +3980,11 @@ static int __snp_handle_guest_req(struct kvm *kvm, gpa_t req_gpa, gpa_t resp_gpa
> >  		return ret;
> >  
> >  	ret = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &data, fw_err);
> > -	if (ret)
> > -		return ret;
> >  
> > -	ret = snp_cleanup_guest_buf(&data);
> > -	if (ret)
> > -		return ret;
> > +	if (snp_cleanup_guest_buf(&data))
> > +		return -EINVAL;
> 
> EINVAL feels wrong.  The input was completely valid.  Also, forwarding the error

Yah, EIO seems more suitable here.

> to the guest doesn't seem like the right thing to do if KVM can't reclaim the
> response PFN.  Shouldn't that be fatal to the VM?

The thinking here is that pretty much all guest request failures will be
fatal to the guest being able to continue. At least, that's definitely
true for attestation. So reporting the error to the guest would allow that
failure to be propagated along by handling in the guest where it would
presumably be reported a little more clearly to the guest owner, at
which point the guest would most likely terminate itself anyway.

But there is a possibility that the guest will attempt access the response
PFN before/during that reporting and spin on an #NPF instead though. So
maybe the safer more repeatable approach is to handle the error directly
from KVM and propagate it to userspace.

But the GHCB spec does require that the firmware response code for
SNP_GUEST_REQUEST be passed directly to the guest via lower 32-bits of
SW_EXITINFO2, so we'd still want handling to pass that error on to the
guest, so I made some changes to retain that behavior.

> 
> > -	return 0;
> > +	return ret;
> 
> I find the setup/cleanup split makes this code harder to read, not easier.  It
> won't be pretty no matter waht due to the potential RMP failures, but IMO this
> is easier to follow:

It *might* make more sense to split things out into helpers when extended
guest requests are implemented, but for the patch in question I agree
what you have below is clearer. I also went a step further and moved
__snp_handle_guest_req() back into snp_handle_guest_req() as well to
simplify the logic for always passing firmware errors back to the guest.

I'll post a v2 of the fixup with these changes added. But I've also
pushed it here for reference:

  https://github.com/mdroth/linux/commit/8ceab17950dc5f1b94231037748104f7c31752f8
  (from https://github.com/mdroth/linux/commits/kvm-next-snp-fixes2/)

and here's the original PATCH 17/19 with all pending fixes squashed in:

  https://github.com/mdroth/linux/commit/b4f51e38da22a2b163c546cb2a3aefd04446b3c7
  (from https://github.com/mdroth/linux/commits/kvm-next-snp-fixes2-squashed/)
  (also retested attestation with simulated failures and double-checked
   for clang warnings with W=1)
  
Thanks!

-Mike

> 
> 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> 	struct sev_data_snp_guest_request data = {0};
> 	kvm_pfn_t req_pfn, resp_pfn;
> 	int ret;
> 
> 	if (!sev_snp_guest(kvm))
> 		return -EINVAL;
> 
> 	if (!PAGE_ALIGNED(req_gpa) || !PAGE_ALIGNED(resp_gpa))
> 		return -EINVAL;
> 
> 	req_pfn = gfn_to_pfn(kvm, gpa_to_gfn(req_gpa));
> 	if (is_error_noslot_pfn(req_pfn))
> 		return -EINVAL;
> 
> 	ret = -EINVAL;
> 
> 	resp_pfn = gfn_to_pfn(kvm, gpa_to_gfn(resp_gpa));
> 	if (is_error_noslot_pfn(resp_pfn))
> 		goto release_req;
> 
> 	if (rmp_make_private(resp_pfn, 0, PG_LEVEL_4K, 0, true)) {
> 		kvm_release_pfn_clean(resp_pfn);
> 		goto release_req;
> 	}
> 
> 	data.gctx_paddr = __psp_pa(sev->snp_context);
> 	data.req_paddr = __sme_set(req_pfn << PAGE_SHIFT);
> 	data.res_paddr = __sme_set(resp_pfn << PAGE_SHIFT);
> 	ret = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &data, fw_err);
> 
> 	if (snp_page_reclaim(resp_pfn) ||
> 	    rmp_make_shared(resp_pfn, PG_LEVEL_4K))
> 		ret = ret ?: -EIO;
> 	else
> 		kvm_release_pfn_dirty(resp_pfn);
> release_req:
> 	kvm_release_pfn_clean(req_pfn);
> 	return ret;
> 
> 

