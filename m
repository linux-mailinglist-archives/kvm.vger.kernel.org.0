Return-Path: <kvm+bounces-33553-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 00F5F9EDF89
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 07:38:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9E58A282F16
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 06:37:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53FB4204C1C;
	Thu, 12 Dec 2024 06:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="E9vkbK65"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2058.outbound.protection.outlook.com [40.107.244.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E701318787A;
	Thu, 12 Dec 2024 06:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733985466; cv=fail; b=pr8bqk9G+l9be0OAH2p226iyU/BOBsG82CHmXSH8yrPVllCL9AvYgBnRZt2a9pyyJeoYlfuGF2Z9yws2xF/75SdUHbaFvQZ4cF31SZzl1jFA1IbGKdXUjGjQXc6WURTrbj64eQutzf4dHw71lj1m+qoQxsEtoXKghN5RyXHJIWs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733985466; c=relaxed/simple;
	bh=DKuI1bIedzb8yEPhsKd99F1Kuy92BaF8v5ekTLYOqOM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gN5zwr453rEOWDqD6A6ABq7F1Rrs0e2QnkKy74hNMj7Rq5vnJgEmY4RQdECQGsFsDRAMv9kgh0YZpJOTP6/eHoCDN7LeYvIPZAtGLQq4wyEkkmLP805FWeNzGSN5S7Eo+0CYq/vsR8j8Un0ZWVyUb1i+MUG4ni8ZnSsDQvB9AIU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=E9vkbK65; arc=fail smtp.client-ip=40.107.244.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A/nw6CHuS9bWYDtT+GJHTbxL/zdlGYLQQAvdF33I0ux4mwHLpxwglIknZzHhCG1QA1GfIOHfxcAOQ2iZA32uf3MSrPEkS2uYgrs0gk0+qWwpBDcQmKPCdX9lidvEYSjWxlYr07nwRPdQ8tVpgruPNEVqroRGaZEA6+hUyP0PCjfUZIbQnsRExgYZ45hhVYzPzYV6CxI5A2giEQQQvW8qQfEOS5RJ5LqGsS0u8MH+ykVMcQWAX8Ra5muAscmIhytYlL2ZhderYtx1ClErtQR+h1Ni6O5TfDsPvNEbjDl0jIhod/8yh6w06N5z3tCegdiOcXH1SLlpPoyoamXXHdlD+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SEpCbqaP6FQ1j0TWnQ3nVGlIYvGyQD458x1MBo6G7N8=;
 b=yCh6md83K+GNaTIAQ/Jitl8GZsT2Lfz7825jGcaWOkoTigZ03zlcXXu0CGwzDUhF3Z351NGvm0T0fnU1xU+8T6wIdxCBEOxIvONF3/QQFVw0xTpLonl1VkPFlFqkxGEJB+g6xYBjtstJfQq/sXQA6CDrYwcHX4wgGqQCMQU1kgUv537QZ/y0hEQQJn/aRi72JehuZSb7IaNXk/uZ1O9WXb+MSglxGYNbrSKCYlzm9QBfsle/j2PLYCSDorNrPNoiXnHkE/b7kt0IKL9DHPLTC295PfXYiqYxgPzg/+t5KKNftfdHQVB7dXof+paTLXjnOrWW2qOMWcTqKmFpJ1XXug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SEpCbqaP6FQ1j0TWnQ3nVGlIYvGyQD458x1MBo6G7N8=;
 b=E9vkbK651amljcd47a3F6zCVJLJGYZCtn07JzVzfe1eM12F0tIrCCjDzEPnDZ91Bed2FaELbovFhjUsrQK8StDT8ZS8m7zaEnzKWBoGkZtR6uvkAU8IKm+8M8rtIGRkXA/mMX2ZjhJlLRpzITFjqg0Z0c7eZUkSC+yJs7VV9Kqw=
Received: from CH0PR03CA0017.namprd03.prod.outlook.com (2603:10b6:610:b0::22)
 by PH0PR12MB8822.namprd12.prod.outlook.com (2603:10b6:510:28d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.20; Thu, 12 Dec
 2024 06:37:40 +0000
Received: from CH2PEPF000000A0.namprd02.prod.outlook.com
 (2603:10b6:610:b0:cafe::df) by CH0PR03CA0017.outlook.office365.com
 (2603:10b6:610:b0::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8158.24 via Frontend Transport; Thu,
 12 Dec 2024 06:37:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF000000A0.mail.protection.outlook.com (10.167.244.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8251.15 via Frontend Transport; Thu, 12 Dec 2024 06:37:39 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 12 Dec
 2024 00:37:38 -0600
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<amit.shah@amd.com>, <pratikrajesh.sampat@amd.com>, <ashish.kalra@amd.com>,
	<liam.merwick@oracle.com>, <david@redhat.com>, <vannapurve@google.com>,
	<ackerleytng@google.com>, <quic_eberman@quicinc.com>
Subject: [PATCH 1/5] KVM: gmem: Don't rely on __kvm_gmem_get_pfn() for preparedness
Date: Thu, 12 Dec 2024 00:36:31 -0600
Message-ID: <20241212063635.712877-2-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241212063635.712877-1-michael.roth@amd.com>
References: <20241212063635.712877-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF000000A0:EE_|PH0PR12MB8822:EE_
X-MS-Office365-Filtering-Correlation-Id: 565f4e3d-34e6-4fa7-7255-08dd1a777972
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2LwviWw6veuI0RziRn3eKGsjkbIWG9gjmwK6jYLERg5Qj2NSP58BwE17rZLR?=
 =?us-ascii?Q?8Qv5Q3LiO/gJF6CA72cnQJ+iWvZVZ7unpVDr9/iAZJC8tSGUy7k1dRIpgcOl?=
 =?us-ascii?Q?5IS/nuCTwyM2ESEB9x6uTS3Wd6Jo/8iu5smWEf3f36rtU/HYyIgwKsCTCRwC?=
 =?us-ascii?Q?W/jTb+Z32ed2XI4+ydGJdvoDRwT4zGl1TtLrcRK59RYtocynh3pzbIsvmFKh?=
 =?us-ascii?Q?9yVM93W5U7gzi1fdZCSebJYkpz1WMx+CssOnpFhUiNhbiAy9OUD8uv5m8ybl?=
 =?us-ascii?Q?nOYv1G/vYJPnArxbFoS+rJxVdoKm3WdQrP0sQnE1nGFWa5E8L7E5glE3dRne?=
 =?us-ascii?Q?QSplEUdLoegUvEDUXV2YocXIkNmFhlroQgiRJ84m3Agbwjxg1wjmGpY0bR6G?=
 =?us-ascii?Q?cPzHza43fSPp48vhRnfk9bIY+r31nGamBbbwnUcSd1lyDbowPjSHZMG5KH+a?=
 =?us-ascii?Q?kf5pWgjPwUnVXRKXuRKY81pAGflaOoQ5Jd1kqtIVMxnDDo06CKQ0lM0u3Q5m?=
 =?us-ascii?Q?EjMDw/1XBc/bjzEOS0nDesY+3iZTxJbdAH5WbId+SY4L5AC0ZXtuzlGMEPAD?=
 =?us-ascii?Q?hnzJnwvkfEAbahRcsRROgEv409ZGWNLLqaJvYGdhV+Bt3u8h6/YCKpHrJdKf?=
 =?us-ascii?Q?fpX47JZiMJXgh1Je+6T4IQJuZ2PY/XeLyqjd88GxXwm7iczEAStJldjc4WkD?=
 =?us-ascii?Q?3TmXy58h06I8pbbn6yCVGqcIQXnYb0kP0h99wA2+Zp3arbCReuckOSfNbGIT?=
 =?us-ascii?Q?tGYHKWjryvVgKq74Zvo5LjHzPBTRLpF+GCi3hXAgewQIm7QGoQCavohdBsV0?=
 =?us-ascii?Q?m1maqmYDj2Vd5cDPfjUX+ZbvbZzgWF6kXNoeWuwZ5x5oN+zz+2JbdjDupuUS?=
 =?us-ascii?Q?p8CWZYtxHSJQDFfQIgo6ai75DOADq+eZHV1INOOri35v0xmv3MQdzvFcRLGp?=
 =?us-ascii?Q?Fg9VGT18cD9dMSYuVvyXXgr73Z9iWYnBbk9jO7tgK15vGu4mWXPhMAoothq6?=
 =?us-ascii?Q?efhZnm2tewK2likoEyYjxlNkwsP+5HscpEr9DVaOeXMO16H5THz1R7nBfznj?=
 =?us-ascii?Q?ivN0g5TTW4cMw2EJcq94XfqsiyfqABOmJcJVgMPEuvtDjgpvvBEzc09DNPno?=
 =?us-ascii?Q?NIquqv6bv0GBgToQ8T6orIyrq5vm+IzZwwOHHUf7iak2bNSraYPm9sXhgULX?=
 =?us-ascii?Q?c3EhMvz+qeT6Mw+sGtxFb43imRSu9uRoH2n9jX8Cqm9xrFisLbeDJ+jTLuRU?=
 =?us-ascii?Q?YUXSaQBPbnryUvNkpW8auWau1w7oxxkSt8iGkJ5HzGGKCRWfrmbHTTTq20et?=
 =?us-ascii?Q?CDvgRBodGjMQZoNVKjAATrtJCs/fNJ0bjT1KNfD5C8ZyLnV/UDeaWw1rTmOI?=
 =?us-ascii?Q?z6tzovo7qzm4J+2Gg+0ZFCCtbD18J+NW9X0fUzYKFsX4Veq0AVQCLIlTHPgt?=
 =?us-ascii?Q?FX1EzLHconIacRj307Vc9t1Ru/bvShZY?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2024 06:37:39.6671
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 565f4e3d-34e6-4fa7-7255-08dd1a777972
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF000000A0.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8822

Currently __kvm_gmem_get_pfn() sets 'is_prepared' so callers can skip
calling kvm_gmem_prepare_folio(). However, subsequent patches will
introduce some locking constraints around setting/checking preparedness
that will require filemap_invalidate_lock*() to be held while checking
for preparedness. This locking could theoretically be done inside
__kvm_gmem_get_pfn(), or by requiring that filemap_invalidate_lock*() is
held while calling __kvm_gmem_get_pfn(), but that places unnecessary
constraints around when __kvm_gmem_get_pfn() can be called, whereas
callers could just as easily call kvm_gmem_is_prepared() directly.

So, in preparation for these locking changes, drop the 'is_prepared'
argument, and leave it up to callers to handle checking preparedness
where needed and with the proper locking constraints.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 virt/kvm/guest_memfd.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index b69af3580bef..aa0038ddf4a4 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -773,7 +773,7 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 static struct folio *__kvm_gmem_get_pfn(struct file *file,
 					struct kvm_memory_slot *slot,
 					pgoff_t index, kvm_pfn_t *pfn,
-					bool *is_prepared, int *max_order)
+					int *max_order)
 {
 	struct kvm_gmem *gmem = file->private_data;
 	struct folio *folio;
@@ -803,7 +803,6 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
 	if (max_order)
 		*max_order = 0;
 
-	*is_prepared = kvm_gmem_is_prepared(file, index, folio);
 	return folio;
 }
 
@@ -814,19 +813,18 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 	pgoff_t index = kvm_gmem_get_index(slot, gfn);
 	struct file *file = kvm_gmem_get_file(slot);
 	struct folio *folio;
-	bool is_prepared = false;
 	int r = 0;
 
 	if (!file)
 		return -EFAULT;
 
-	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, &is_prepared, max_order);
+	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, max_order);
 	if (IS_ERR(folio)) {
 		r = PTR_ERR(folio);
 		goto out;
 	}
 
-	if (!is_prepared)
+	if (kvm_gmem_is_prepared(file, index, folio))
 		r = kvm_gmem_prepare_folio(kvm, file, slot, gfn, folio);
 
 	folio_unlock(folio);
@@ -872,7 +870,6 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 		struct folio *folio;
 		gfn_t gfn = start_gfn + i;
 		pgoff_t index = kvm_gmem_get_index(slot, gfn);
-		bool is_prepared = false;
 		kvm_pfn_t pfn;
 
 		if (signal_pending(current)) {
@@ -880,13 +877,13 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 			break;
 		}
 
-		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &is_prepared, &max_order);
+		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &max_order);
 		if (IS_ERR(folio)) {
 			ret = PTR_ERR(folio);
 			break;
 		}
 
-		if (is_prepared) {
+		if (kvm_gmem_is_prepared(file, index, folio)) {
 			folio_unlock(folio);
 			folio_put(folio);
 			ret = -EEXIST;
-- 
2.25.1


