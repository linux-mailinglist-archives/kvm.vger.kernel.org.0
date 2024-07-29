Return-Path: <kvm+bounces-22532-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B8699400E5
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 00:09:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 20DDF283ADD
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 22:09:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D673918EFD3;
	Mon, 29 Jul 2024 22:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0ktpDjKt"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2043.outbound.protection.outlook.com [40.107.236.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825E918E75C;
	Mon, 29 Jul 2024 22:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722290969; cv=fail; b=PsHRmNDUd9i751T6pxzJ+LG26jejkjsim4tsQFmqGY6RbMZeFQ3pNHHGfJeL6hYnyNpEiZn4FcBivCIUW4n3Jcm9Xf2Bh9cSdGyvj2gmmWmSSHw+WXcKkWOoqgKR7VHX1eGQDp8pfa2hbt7+oSQy1/MG8MMxkvjXWoMlTJXF028=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722290969; c=relaxed/simple;
	bh=2HMFQeDao+cXQlPul4dhfuIbcE7LTlT+tusG+YeZMl4=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RU+gCJF9nt5Fb9sgt5Cx73QxJ5k3QgfbpFgRRKsQ+PrhGKnp48BbnflblBzE8zOgTqBgMIh9iQ6Cf81qdUT5zFXVfzXP7y7b9dSiQvGz5iqiDoEZs5iykA+doDf14CgCLiUeWkud0uuMA4OhWRmAYPAyf6Vwd/HWxK1FzZFNMOU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0ktpDjKt; arc=fail smtp.client-ip=40.107.236.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KnOoWeEf2r5QieaAOYJy03j46TM7MX90IFE54gRffSUkkSEAf/UBV9UL75tDmn6eMKxOMnUI4jDxRnK6oTAbXjvUF5B2hKIitDHOLuhJp/ls5TcyUxpe6UPFT7TDNa/S0iqaX3fX1s14FX4CahqDc6FSgeDIQEByQPgl6buookHnqALdC4YY241O4Spv0+lylCext8jLVS0Sb5pi1m491grNL7aXISO57QP66ujoDQin2DjTDV4YKtWlGpab3ij8MZgKAzRU4uviO1b2pyBhHQcPoGbEwH8UkiftpKaHaIzS6koivCerkPkGBST21N+OrMn4v5OWjbIMYyzcapg5+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=im/U/6UwFEEoCWWlvKyyPWPRtYlijmJp2HuOiN2p+2Y=;
 b=SflxeMndaK4E0NYSZon5njQWKCQ5AcfzuL7usQsMKjfTqBiuq4CA6xS0a1IZqivUZ8dGy0ljwbpUF92RtS573OnFeIlHedOGOnP9aM/JBSLbQtTSo8hmP3g3Z8M/SPzvNt5ZSGgTBuigKOsDDfPqjIk2JX9TOoYMaY0wC/PBiviTRFsr3ys8eBeFxujE65PYHuj382F9pD06KT3svw0hAoE+zu4BlCIlC5NCxeKOqKoIIYUe/bmeQfv5lpuCkSPBgbBOuIgxgfBVP6n5yJnaP1l04UxlIOADYLjIsZSeiJzqranPhHwB8dAJa/HASDgP65tDf4pvUQ/CkmnkusAncA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=im/U/6UwFEEoCWWlvKyyPWPRtYlijmJp2HuOiN2p+2Y=;
 b=0ktpDjKtsnoUPJYtIFBiZDM8jPNEy1f8fUbNykkZrkhLAe/qbmGIdVXR5cSMbLsrUB+7LuXWWrJcXhmDtlY477rsJv2+KELzUL5Ark3hksW3yfdpN8P7QWPaWnBga9lsTKiaTB8VCltuhzBLoTpQU+fdQvyUG6VNmthNPB3fG/o=
Received: from CH0PR03CA0043.namprd03.prod.outlook.com (2603:10b6:610:b3::18)
 by SJ1PR12MB6338.namprd12.prod.outlook.com (2603:10b6:a03:455::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.27; Mon, 29 Jul
 2024 22:09:22 +0000
Received: from CH2PEPF0000009D.namprd02.prod.outlook.com
 (2603:10b6:610:b3:cafe::9e) by CH0PR03CA0043.outlook.office365.com
 (2603:10b6:610:b3::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.34 via Frontend
 Transport; Mon, 29 Jul 2024 22:09:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF0000009D.mail.protection.outlook.com (10.167.244.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7828.19 via Frontend Transport; Mon, 29 Jul 2024 22:09:21 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 29 Jul
 2024 17:09:21 -0500
Date: Mon, 29 Jul 2024 17:06:38 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<seanjc@google.com>, <pratikrajesh.sampat@amd.com>
Subject: Re: [PATCH v2 00/14] KVM: guest_memfd: lazy preparation of pages +
 prefault support for SEV-SNP
Message-ID: <20240729220638.s7r4ibv5gln6h74u@amd.com>
References: <20240726185157.72821-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240726185157.72821-1-pbonzini@redhat.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009D:EE_|SJ1PR12MB6338:EE_
X-MS-Office365-Filtering-Correlation-Id: 93729253-1822-49dc-17a2-08dcb01b19a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vxx0Hyc0jUbAptI7RfrPY1+t9rqEqNnOAQJAtRhq0IChh4oqE512aCGAbYeU?=
 =?us-ascii?Q?VHTu4uPF32Se+EeRcPihxlc1tscTAgC+MM+L8RaZicy4eZ+QUplLn9VqSmwz?=
 =?us-ascii?Q?UN3i2LxnoYmbcd7abDUz24PJhWRBrb+V0F2crrQ47GvFSPh1A9KHcDef6EGv?=
 =?us-ascii?Q?rd0g/w7eHI2RNTnQy+R9AdZrfwXRGdAHHjj0eYdGNjNrgHaW94C6x47s/Vwv?=
 =?us-ascii?Q?t4vKMsdza2ShdM4ThS4kiCPMPxRs17lbSiV3o97eYUguI/czI5I4ahSq2TDH?=
 =?us-ascii?Q?vZHUWYaIK3I9SyZ0GlxENo4bh7y4wp4/wEbH6H5KsxKmrcf8LVYri7tlbF/B?=
 =?us-ascii?Q?y1kq+bmVKRlXPu2T9yrL7Vv+P8hiqbtUCFRnXYniLfaXPeib+9tp+ND14FCb?=
 =?us-ascii?Q?AbpORTGyK6FBl379w7P+5KMe9LdIttv/guhVA03N8jpUYMIqqKD1yUyryoCI?=
 =?us-ascii?Q?Cx8oo4T40a9298kiy9OVurLu/fSDDF7e+0Y6b6fQj1psGlYH5Ffj2Qypl/Qn?=
 =?us-ascii?Q?2OUpnbeaucM/vdUlrW2xMXi1H60FOpFRw6bPVEw+g0sRHTzYuea0TZERk5ud?=
 =?us-ascii?Q?Edgp18lRQmwZ7e8iIvYebbTEhyiRBHYEzjZQdynS/BPphG1gDLn1EQyp2Rs0?=
 =?us-ascii?Q?HjedfykCWOFxZJBDhfZ1a3rNWmAJf4bSvhlbZKEEEDbiHu+eal0VVhSFUDFY?=
 =?us-ascii?Q?GjIkn4MK4GTF5FeP+zcmGmx7pkdwjq6x6U6Ci4BuvLE7coQU5AHuvDs0bXWZ?=
 =?us-ascii?Q?QKIgKmGocQv7EkAwiuQbB/b5YcUoHYGiAj54U3cAe++hc5uTdBPZl7OwjP5h?=
 =?us-ascii?Q?bCldCxgTUPqj/OHbnAEtzkQbLZpS5CoUzZEMQczMzK9eIUyFIMFXcXOVQGCZ?=
 =?us-ascii?Q?f+fPqGHaP03ZX/pgSymrimezXngJ/Wh3hTh8ec1m/cFeenga81lZG6dCZm3P?=
 =?us-ascii?Q?7Cr4C3TUM24ux+Ck4dkLeU78riBFtSyoiblOzTk0wd3gw+UOUBBfAlvELqoy?=
 =?us-ascii?Q?uSO550Cn2JFbMqKvVclr1+WvYPGJUocpW8zpKRoqxb4IcJA+D099U+J4/v7s?=
 =?us-ascii?Q?cHadfYdy/SvphSLpypqRLanpRCV5suN5EOSCzTLMiS1GbPL+17HsB9D54b+m?=
 =?us-ascii?Q?hD4Sdsrb5oVHiVHUBgYXlcXWzWwFjmdT10IOKGlpCFqvaFe4dacni3teNU53?=
 =?us-ascii?Q?4WmLWEYykaQ+To+69pLw169DgCvAoVUphPB6KV8NSKKip7pdKvWihqr3gj+h?=
 =?us-ascii?Q?tFOsxQ1XYSk1SmFhx5yh+VvgNWmJ6Dfmskn0earWBjW/AiY2hyVrrE1vFnap?=
 =?us-ascii?Q?xErlEf4/dGSQWVbtcltft71qcpzvxFsyqCUnGm1su31eYRJKGYdkAYAjf/qb?=
 =?us-ascii?Q?I7bIJotUBJwR7emleC6uCEWagxPJZqw0fIEJmNAezjWxV+jXlA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2024 22:09:21.9101
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 93729253-1822-49dc-17a2-08dcb01b19a8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6338

On Fri, Jul 26, 2024 at 02:51:43PM -0400, Paolo Bonzini wrote:
> Paolo Bonzini (14):
>   KVM: x86: disallow pre-fault for SNP VMs before initialization
>   KVM: guest_memfd: return folio from __kvm_gmem_get_pfn()
>   KVM: guest_memfd: delay folio_mark_uptodate() until after successful
>     preparation
>   KVM: guest_memfd: do not go through struct page
>   KVM: rename CONFIG_HAVE_KVM_GMEM_* to CONFIG_HAVE_KVM_ARCH_GMEM_*
>   KVM: guest_memfd: return locked folio from __kvm_gmem_get_pfn
>   KVM: guest_memfd: delay kvm_gmem_prepare_folio() until the memory is
>     passed to the guest
>   KVM: guest_memfd: make kvm_gmem_prepare_folio() operate on a single
>     struct kvm
>   KVM: remove kvm_arch_gmem_prepare_needed()
>   KVM: guest_memfd: move check for already-populated page to common code
>   KVM: cleanup and add shortcuts to kvm_range_has_memory_attributes()
>   KVM: extend kvm_range_has_memory_attributes() to check subset of
>     attributes
>   KVM: guest_memfd: let kvm_gmem_populate() operate only on private gfns
>   KVM: guest_memfd: abstract how prepared folios are recorded

Re-tested series with multiple SNP guests with/without experimental THP
patches on top.

Also re-tested using the following SNP self tests (I believe Pratik has
a newer version he'll be submitting soon):

  https://github.com/mdroth/linux/commits/snp-uptodate2-kst4/
  x86_64/coco_pre_fault_memory_test

Series:

Tested-by: Michael Roth <michael.roth@amd.com>

> 
> v1->v2:
> - patch 1: new
> - patch 7: point out benign race between page fault and hole-punch
> - patch 7: clean up comments
> - patch 10: clean up commit message
> - patch 11: remove ";;"
> - patch 13: fix length argument to kvm_range_has_memory_attributes()
> - patch 14: new
> 
>  Documentation/virt/kvm/api.rst  |   6 +
>  arch/x86/include/asm/kvm_host.h |   1 +
>  arch/x86/kvm/Kconfig            |   4 +-
>  arch/x86/kvm/mmu/mmu.c          |   5 +-
>  arch/x86/kvm/svm/sev.c          |  17 +--
>  arch/x86/kvm/svm/svm.c          |   1 +
>  arch/x86/kvm/x86.c              |  12 +-
>  include/linux/kvm_host.h        |   9 +-
>  virt/kvm/Kconfig                |   4 +-
>  virt/kvm/guest_memfd.c          | 226 +++++++++++++++++++-------------
>  virt/kvm/kvm_main.c             |  73 +++++------
>  11 files changed, 206 insertions(+), 152 deletions(-)
> 
> -- 
> 2.43.0
> 
> 

