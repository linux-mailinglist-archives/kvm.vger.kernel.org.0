Return-Path: <kvm+bounces-12248-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E6AAF880DD7
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:53:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5BDC81F25AA4
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 08:53:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47C1D38F82;
	Wed, 20 Mar 2024 08:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Xy/Pa4CD"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2081.outbound.protection.outlook.com [40.107.220.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0126638394
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 08:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710924682; cv=fail; b=QeXl78jq+tlO24PnKsgRt2orXg3bY8v0Yn683RUZSVRVZINXhqs/IOZ2ggLyGrhcvtm4gTtBdeTf3vUbRrcI/lB9bonsg8N+oX4QM3mMJ7ViTE2SmtcW5xSJWvcwkYjosJrskuEr27j16xeStRsOWl2DHfzVs/yWy/5h19fEQpk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710924682; c=relaxed/simple;
	bh=6Hi3B7ZgbqfAFa0xSNKL3vNji/ZSusGwTlFEeaJV59I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XlQAQ6K/5irunicT6IFcvxW8rOeHpH4QRoacrMc9qh3HJ54eBiAd+pWGgGWFUmnRH4TYCOILBmnmg1Plcx8qTpfG6+bztuNbD00cVh3OHFVN9nMclUO14q8xnDzULR2oKao/QA1ivwF8iBexYQBCVAB2wM8hoyPOUKLw2+zBHOo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Xy/Pa4CD; arc=fail smtp.client-ip=40.107.220.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oQtp4xyMnO0tbdc7ql4kb7fyMEXijqvRRkz7zvbg8lFoqCgGMGPJgZcCekKqu30rssXGSkQE9AatypENfMhIeAiZTbsB1WhPeKuNRqu3JhAHZppzRvDPyDqYu9FAx9RXtExzwHrz24Z0CaWGf9NttcLXsDv3TgmDds8nm99GoTf8Gj1KiYR7MLvys+/lnWVO8Q4fPnbOogUav2qRa0UrG2KbDwsWCmzpFnCAD9Rk/JNgqZFY/CZzXCE0kgDbPW8GZSOnTRw1KNFiW51pQas0+EIHevtc3e5QTgHzDUQPC89z4HJQLfYxhS3eGn4QDBu4JoBJUPO9K7g6LBTYHvaIvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rGRYDkRxuhjt7XwOcdG8t4p65Q79QnZet15tqh210vk=;
 b=E9xdp2PXlKRT3yhfLHEsKzWK0qyrn1F0fHQTMx+IQf7/EWDor5T0cq/jJ02cml/8dJHmf+9p3g21Vt4rsTTc7j/hNTgfGoodNrl8W+IIF0H1Eco3N6sQh1pCA6qynz1e0lARnLUdHWK8NJzZ72Ip0Gv7ZVPzIoWVmfA5FbAfrRCD+HQ2HSdV8nmidCYuhg4uE/bMV3w3uc//qx36Cy0FyvfJzW/j2WxZ+m1toepJ/ruGf5SzUlTvWMrMaHRe3tL4vfj0hu2cMjCySgfihk49OakKsyIr7YOOtEOA6mv7cd9vI9k97m4oZ7dW2fIrQ1XNut5igMfnqmt4Jg2SXYvA1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rGRYDkRxuhjt7XwOcdG8t4p65Q79QnZet15tqh210vk=;
 b=Xy/Pa4CDSxZD39yDNTVr+a29E5U3sTZaEmTJUEKPqXRjcVgliMvlTkr89TFVEmw3WkGJcxbVtOOCOfY0hKsCDdXhNbyEbX/9vkON7QSzztmULCdWR+9tBofRaDfN9dZuD2ZFG/Ov7AWAEmYKCrx/jhmJeyiHkcmO6jfo8qjI1RQ=
Received: from BN8PR15CA0023.namprd15.prod.outlook.com (2603:10b6:408:c0::36)
 by DM4PR12MB6494.namprd12.prod.outlook.com (2603:10b6:8:ba::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.34; Wed, 20 Mar
 2024 08:51:17 +0000
Received: from BN1PEPF00004685.namprd03.prod.outlook.com
 (2603:10b6:408:c0:cafe::a2) by BN8PR15CA0023.outlook.office365.com
 (2603:10b6:408:c0::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.27 via Frontend
 Transport; Wed, 20 Mar 2024 08:51:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00004685.mail.protection.outlook.com (10.167.243.86) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Wed, 20 Mar 2024 08:51:16 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 20 Mar
 2024 03:51:16 -0500
From: Michael Roth <michael.roth@amd.com>
To: <qemu-devel@nongnu.org>
CC: <kvm@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?=
	<berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>
Subject: [PATCH v3 35/49] i386/sev: Add KVM_EXIT_VMGEXIT handling for Page State Changes (MSR-based)
Date: Wed, 20 Mar 2024 03:39:31 -0500
Message-ID: <20240320083945.991426-36-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240320083945.991426-1-michael.roth@amd.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00004685:EE_|DM4PR12MB6494:EE_
X-MS-Office365-Filtering-Correlation-Id: d22e9a2c-ef91-44fb-8f59-08dc48bae7a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	MSuBxKsViFHt1D/KCXEz+5Uvcnv1KjV2rbD82UPaON+tC8orzp515uwXvMDmLnKYlXF/EtPAz1u+sXP5s+z1FjxBJ4WLG6yLoeuGR3Xo7s2yk9U9NSjZf1arBBgG74jCt7X3KHJ7/32+zFiUXEJmFZigEeIaK0Tar3elfRyW1WpWmKf1WZNqxjxFVUJx+dLQKC/P346D1aqPqtbS+zYp2ll3oBKwoiB+1YVsMug8WLMk/4zkZWeMirXhtgVNCkWe64L9iAhTyZhvmGqpEfx11uCJT3jnRo7FLY9gB2iaWlILTZANGpwX9AwMQ9oDhFJvWcMVWkmxB1NRbEq8x3D2OynvajhT0dO/u92thb0d1nqr7C2lhCxJVtYiciGeK1OW+d6FASJk6K8ildgcKAeV/Uzabxfiu7lmOeTKs/jAiioQqNU/c+gGk376hnskletSmI00gHkriqWwe9AaZc3zuTwjGxI2yUT8LO4O6ePPWWnjq/fsekSdD7/4K71BdQbw0ohGc3IIVIpm3P4nXTwe8OpWkUVoE+Dw7AMyBMUS6YdGMrQmcPDErUdFg/FX0Z6TnSl8tR3TZ3gkJEZS0zN95P320Rmsm8F5lt3euqNvlg8Y+0UYNCWG08102brYBV/KihB4yxzRevKl1Myzk2B15vBo94nqPdDtzy4zjUC8ZYukERBVlU2PIqqgeb9hYHmS1XokyLWOyxQ8AWNfqyu/yNS/ox3qIiT595Tmob9VzxoKHJ8n1DIwd6+3Oedf62fL
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(36860700004)(376005)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 08:51:16.7066
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d22e9a2c-ef91-44fb-8f59-08dc48bae7a9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004685.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6494

SEV-SNP guests might issue MSR-based Page State Changes for situations
like early boot where it might not be easily able to make use of a GHCB
page to issue the request. Just as with GHCB-based Page State Changes,
these are forwarded to userspace as KVM_EXIT_VMGEXITs. Add handling for
these.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 target/i386/sev.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 0c6a253138..b54422b28e 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -1560,6 +1560,18 @@ out_unmap:
     return 0;
 }
 
+static int kvm_handle_vmgexit_psc_msr_protocol(__u64 gpa, __u8 op, __u32 *psc_ret)
+{
+    int ret;
+
+    ret = kvm_convert_memory(gpa, TARGET_PAGE_SIZE,
+                             op == KVM_USER_VMGEXIT_PSC_MSR_OP_PRIVATE);
+
+    *psc_ret = ret;
+
+    return ret;
+}
+
 int kvm_handle_vmgexit(struct kvm_run *run)
 {
     int ret;
@@ -1567,6 +1579,10 @@ int kvm_handle_vmgexit(struct kvm_run *run)
     if (run->vmgexit.type == KVM_USER_VMGEXIT_PSC) {
         ret = kvm_handle_vmgexit_psc(run->vmgexit.psc.shared_gpa,
                                      &run->vmgexit.psc.ret);
+    } else if (run->vmgexit.type == KVM_USER_VMGEXIT_PSC_MSR) {
+        ret = kvm_handle_vmgexit_psc_msr_protocol(run->vmgexit.psc_msr.gpa,
+                                                  run->vmgexit.psc_msr.op,
+                                                  &run->vmgexit.psc_msr.ret);
     } else {
         warn_report("KVM: unknown vmgexit type: %d", run->vmgexit.type);
         ret = -1;
-- 
2.25.1


