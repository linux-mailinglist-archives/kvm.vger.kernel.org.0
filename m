Return-Path: <kvm+bounces-44621-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F18AA9FDB1
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 01:25:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1EE1E464BFA
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 23:25:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C07312144DE;
	Mon, 28 Apr 2025 23:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Ydjx6GGR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2047.outbound.protection.outlook.com [40.107.244.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3FA32C85
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 23:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745882731; cv=fail; b=twk1ySYygQXPx5Q0FxvTn+Qc/QsA8fxZ9bbPVACwwOs0D+7Zr/G+KwggnXcUH0vhIW7Iuzgy+y3KU6w7UXwkE4m5BYKhNR00zZLvq37EdNLGXVHoswWxBgWDHN+PLLMNiD+ttYMIwdtL6OAzyNQkO2SCb1i/cRlt/kUcyNzyOvE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745882731; c=relaxed/simple;
	bh=/wj0rQi+6veFevuiFfFVu+mE0wOgnzDFHJ0y5YggYpw=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pqc3TXNadGfursKKfKE4ZZNYx4F6WJatr1hGDuMW6SYj+SFTe01PmYiQ2dNbUnGqK7NH8rsMJsoeHVqWEbbBq9fkErc8aDTp0DXxikRzhbeTssGBVGhKLJ9AKJqrsty4QzwJI4BZSv1x4gKGKtu2pR+vF9KmZzlAoxX4CPZ3BJE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Ydjx6GGR; arc=fail smtp.client-ip=40.107.244.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qpI7RewavzTwUd01BsmUC4k5LIbYBqiiCrRpK4awISS/p+/pUGQfZbW92tugw7yQNcEtc89y75V4EZXq27QWfi3Qj8UtvdCHDAmpDJgZOQFOJET7ewhfLtScL7hjizeAzsIGDppsrWXN+B+zlfYlbv027yowTdgcMGl9qqTMUvGa3vnSWGp/wNigGWvoBMAvRrJ+Gxr7HxcFZH4eOu6fM+Bmx0XXd+dU3MYjvSObCG/NZx+9UQrR1Ya4TJu/fV1dgkXwZnA7KKaz6wx2cIFAw4/iVtH5hVJ8nJZlspAbHFurOGAc5GB4OrKYmY9i66nghrGXVEzFyjRcIzMPXZS9aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3xKokICFFNzun8Pdkqvlon8sic0dRjMF2u1djPE5kac=;
 b=LXrAEVk2lxppQ7bSmiehVhdTUJTBU+LUM1DLCaZv7VL6/Bmmo4hD5zN9dIiJLbgyWtU8Al8BP/9I/jDTQR7B62rrFODAVIugtURwaVangp8s8fk4NE2M+ngBXQSLzglTSDCtJqGjJCeHxQWYJloZwclxGjk3XaDyxAUWEiolr/yALjGi6rEUBM30yQYuiWTrcDqnchP2E9QotPgU+ivJQADms/HZikOnHMLLRRbJBgQCZMf14PITWoc13KIWmYi9NejpQ/antbZI34r34hlqEVlYhzPhm63HraRujDuR/YN9pEaj7YZWOHBAQoXQmv2vjjdxipcJIxFksOYwhdKw0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3xKokICFFNzun8Pdkqvlon8sic0dRjMF2u1djPE5kac=;
 b=Ydjx6GGRst03rsva9L0lZYhJinXTYargqsiT7vNKOqGnNtoYqU8LO0J6iyAeE0OIfZOkoQDOqAH9+LS5eZHa+2QJwgm+tghvOiGRPAP2yo7Tcl9ItF/vGr7vUWO2a18sr1Y8lLLfdUmZhP5lP4zCGAgtx4ZQHSJJPAhkhrWM4k0=
Received: from SJ0PR03CA0150.namprd03.prod.outlook.com (2603:10b6:a03:33c::35)
 by CH3PR12MB8709.namprd12.prod.outlook.com (2603:10b6:610:17c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.31; Mon, 28 Apr
 2025 23:25:25 +0000
Received: from MWH0EPF000971E3.namprd02.prod.outlook.com
 (2603:10b6:a03:33c:cafe::90) by SJ0PR03CA0150.outlook.office365.com
 (2603:10b6:a03:33c::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.35 via Frontend Transport; Mon,
 28 Apr 2025 23:25:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000971E3.mail.protection.outlook.com (10.167.243.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8678.33 via Frontend Transport; Mon, 28 Apr 2025 23:25:23 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 28 Apr
 2025 18:25:22 -0500
Date: Mon, 28 Apr 2025 18:25:07 -0500
From: Michael Roth <michael.roth@amd.com>
To: Ackerley Tng <ackerleytng@google.com>
CC: Sean Christopherson <seanjc@google.com>, <kvm@vger.kernel.org>
Subject: Re: Untested fix for attributes vs. hugepage race
Message-ID: <20250428232507.zsodmdzyamwgynrh@amd.com>
References: <Z__AAB_EFxGFEjDR@google.com>
 <20250418001237.2b23j5ftoh25vhft@amd.com>
 <aAJsDVg5RNfSpiYX@google.com>
 <20250421183533.rnoif5ky37umyw3e@amd.com>
 <diqzwmbazqr1.fsf@ackerleytng-ctop.c.googlers.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <diqzwmbazqr1.fsf@ackerleytng-ctop.c.googlers.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E3:EE_|CH3PR12MB8709:EE_
X-MS-Office365-Filtering-Correlation-Id: 68329048-a4d1-4ed9-912b-08dd86abf372
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?j78NqSqAksDQtpOaJ29hUPHpqWwhcv+92OoFga0zptW1PVJsosFaXXNGskq5?=
 =?us-ascii?Q?beFqMI78dxFLAvlsc+L/9SWzvPZiYBtp4PoSQJ5R3tGhN89+mBkE2eVzpd7p?=
 =?us-ascii?Q?EmI+ZU2Lg3zyH+g/0kwbtWMC1hmgnOEZ5h6vox7KCZNrWAhFbo9Tt20EndB6?=
 =?us-ascii?Q?+9Ipf8ccbt3zAbAP8IFTzpy0nXMaJt8/KTpmBSjWDc5Q9Xlx/DTpelyrWNi4?=
 =?us-ascii?Q?3Khv8riqmwcxPz6Q6UVepKx44gYYHG+iot5KL5z5hLcJ4uLBkJklMSHczJrS?=
 =?us-ascii?Q?Y077jE39taVkc5ZCXHGgjdx4SQuXB3B7WQa6wZfETWEHrXqfCSghSFY8yRG+?=
 =?us-ascii?Q?W7sCql7SnAcRZc+jcfZq1X7t6f2c1cf3/0+0pH6+Fc1L0KpFYhCJfuEd0Dcr?=
 =?us-ascii?Q?0vrJlyJ3T0MLV5I+M08uLpgFfznjqxfEMJQmEAYC8BHRHj57JR1dyjyzVXG4?=
 =?us-ascii?Q?UMqQGbRLMZtOsboGkO97PXe4mMIXPqRkW9SmTVqxMCa4O+jPu5WH7ROy2CxD?=
 =?us-ascii?Q?GFtx2eUoxxu0aYCht7jCPZqenazQAjlsGZjmC/exTzltMoXY+JPW2+1XuZac?=
 =?us-ascii?Q?5c/eilROziyqGhCf3OxrmJfuPNZYWrq1Pe91c+743iCDxya+8KXCooGT68na?=
 =?us-ascii?Q?SXTbzyzwB4Vi884fUCxpdv4gakMbn2uPd9OHfCw63TnFrcSyujEbonWtSEgl?=
 =?us-ascii?Q?Uqy2htT1ra6rtw5iau+M0OKUtLJhX0kZXQhmxOoisjgKCdBA7Amh3pOrSC9w?=
 =?us-ascii?Q?yzT0TIkDAvDAtc4NFmi/9jsAvrnHEKlwP6cgZkBrJKOLLlzMsvGCFXFy6HIb?=
 =?us-ascii?Q?iU/p2Sn2Wtv82XyrPi6+ejpMXua/sW9/404X4qdadB1QHvJ+k/VebMsdhCcC?=
 =?us-ascii?Q?jrjL2HwDZ09R7TNM0UM65Ueeh1n3Oo3JpkwUK89JWN6LrL+dneiyxeftD6aF?=
 =?us-ascii?Q?XMtYCKZYcoAr5vvQMtTqMCS60jMobkxUywcMvla6rf0fWNCwYsc9l+MpJd9x?=
 =?us-ascii?Q?aj41rop/x5b8KJHNFc0e/MIRWr42MWJ7HPs+bHwhjHRMcbXmKTj8Zb00lFAn?=
 =?us-ascii?Q?vNGC6uuXQ3SmJuC61+Gu8dfPPbrfU+eRJgLtaF+WQZaVZiz3V8rmzq0BKS9T?=
 =?us-ascii?Q?YtoM1WJxichj30/qk/XEwuN+OfEnZlbs0c0G/+0kE7qrRM7FasfhtmdJqn64?=
 =?us-ascii?Q?7xO/WfNlOZqub4YkD3WxWQWcE7JAnUKLFLyQVyC5I+/uJ47D1PBbtERjknrv?=
 =?us-ascii?Q?q53+2RhWuqqpL8GvIQebERndmvdXvkuct8qVomoU9oWFA7Srf3KisAbDXDbJ?=
 =?us-ascii?Q?i4EfEFuRTCiQC1/70BA6ijZQFjXXZeHfLRWSl5o/EGV0t4OutNejlmtoCDK7?=
 =?us-ascii?Q?+XstKXdQxmTMyjuUXwic8hbP+5R3uMLUq93cLLkJR+ZjulpFLaYPl2kjn8HD?=
 =?us-ascii?Q?pMpPqe4rrBDxnvXn4CNBRvnHW8dMMpy37z82WHHO9eahRD9E3S1hI4vXKvgL?=
 =?us-ascii?Q?skFoR9vWIVVzUlnmWt5a2UyM1AEJp/4bFErZ?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2025 23:25:23.6846
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 68329048-a4d1-4ed9-912b-08dd86abf372
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E3.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8709

On Wed, Apr 23, 2025 at 11:17:54AM -0700, Ackerley Tng wrote:
> Michael Roth <michael.roth@amd.com> writes:
> 
> > On Fri, Apr 18, 2025 at 08:13:17AM -0700, Sean Christopherson wrote:
> >> 
> >> That all looks good to me.  And to ensure we don't go off the rails due to bad
> >> inputs (which are supposed to be fully validated by common KVM), we could add a
> >> WARN to detect a non-exclusive range->end.
> >> 
> >> So this?
> >> 
> >> 	if (WARN_ON_ONCE(range->end <= range->start))
> >> 		return false;
> >> 
> >> 	/*
> >> 	 * If the head and tail pages of the range currently allow a hugepage,
> >> 	 * i.e. reside fully in the slot and don't have mixed attributes, then
> >> 	 * add each corresponding hugepage range to the ongoing invalidation,
> >> 	 * e.g. to prevent KVM from creating a hugepage in response to a fault
> >> 	 * for a gfn whose attributes aren't changing.  Note, only the range
> >> 	 * of gfns whose attributes are being modified needs to be explicitly
> >> 	 * unmapped, as that will unmap any existing hugepages.
> >> 	 */
> >> 	for (level = PG_LEVEL_2M; level <= KVM_MAX_HUGEPAGE_LEVEL; level++) {
> >> 		gfn_t start = gfn_round_for_level(range->start, level);
> >> 		gfn_t end = gfn_round_for_level(range->end - 1, level);
> >> 		gfn_t nr_pages = KVM_PAGES_PER_HPAGE(level);
> >> 
> >> 		if ((start != range->start || start + nr_pages > range->end) &&
> >> 		    start >= slot->base_gfn &&
> >> 		    start + nr_pages <= slot->base_gfn + slot->npages &&
> >> 		    !hugepage_test_mixed(slot, start, level))
> >> 			kvm_mmu_invalidate_range_add(kvm, start, start + nr_pages);
> >> 
> >> 		if (end == start)
> >> 			continue;
> >> 
> >> 		if ((end + nr_pages) <= (slot->base_gfn + slot->npages) &&
> >> 		    !hugepage_test_mixed(slot, end, level))
> >> 			kvm_mmu_invalidate_range_add(kvm, end, end + nr_pages);
> >> 	}
> >
> > Looks good! Re-tested with this version of the patch and it seems to address
> > the original issue.
> >
> > Tested-by: Michael Roth <michael.roth@amd.com>
> >
> > Thanks,
> >
> > Mike
> 
> Would you be able to share how you set up a test to trigger this issue?
> Thanks in advance!

The original issue was triggered when running SNP guests using 2MB hugetlbfs
pages for the shared memory, and it would happen when
mem_encrypt_free_decrypted_mem() was called. In this case 20KB of 2MB BSS
decrypted region is used, and the issue was triggering an infinite loop
when the guest tries to re-encrypt the memory as part of freeing it back to
kernel:

  [   36.521488] Freeing unused decrypted memory: 2028K

I don't think it is specific to hugetlbfs, since the below hack can be used
to trigger the race fairly reliably even without hugetlbfs. I noticed that
pretty much every guest vCPU will fault on the same GPA after the initial
invalidation, and think it might be kvmclock that's using that GPA. So the
below just expands the race window to make sure one of those other vCPUs
triggers a fault after the shared->private conversion invalidates a 2MB
NPT entry.

I suspect hugetlbfs was originally a factor because it was using
pre-allocated pages so maybe it able to re-install the zapped entry more
quickly vs. the normal flow where the shared page would get hole-punched
by QEMU and so would need to get re-allocated.

-Mike

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index de2c11dae231..27fdf05c79eb 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2457,6 +2457,8 @@ static bool kvm_pre_set_memory_attributes(struct kvm *kvm,
        return kvm_arch_pre_set_memory_attributes(kvm, range);
 }

+#include <linux/delay.h>
+
 /* Set @attributes for the gfn range [@start, @end). */
 static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
                                     unsigned long attributes)
@@ -2500,6 +2502,11 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
        }

        kvm_handle_gfn_range(kvm, &pre_set_range);
+       /* page offset 5 corresponds to the first PSC for the BSS section in question. */
+       if ((start & 0x1FF) == 5) {
+               pr_warn("%s: prolonging GFN invalidation start %llx end %llx attributes %lx", __func__, start, end, attributes);
+               msleep(2000);
+       }

        for (i = start; i < end; i++) {
                r = xa_err(xa_store(&kvm->mem_attr_array, i, entry,

