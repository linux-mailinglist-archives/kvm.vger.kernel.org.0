Return-Path: <kvm+bounces-13218-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A5346893408
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 18:53:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1CA191F2139E
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 16:53:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B470C157E8D;
	Sun, 31 Mar 2024 16:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="49eW2WWB"
X-Original-To: kvm@vger.kernel.org
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C65F156F56
	for <kvm@vger.kernel.org>; Sun, 31 Mar 2024 16:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=62.96.220.36
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711903223; cv=fail; b=VYpUBZBCuMIacPcwIUyaiXoFHGkPLF00naKT6PG8tq08UghFyaVkmj+SD+YTXqB8h3vpFP1+ZbGkwxyy2HzrrbFSC+5QVz2hSqNMl9nn2NPBfFgKAz1kgZK1KO8a37K/mFYplmGUhJ0hgsUnyuOVyloYSfJDMWJpCb6vIn+jj2g=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711903223; c=relaxed/simple;
	bh=XK+D24Mus0Fd07JBujOKIkrDHXMbMMVpD3gupVHk9as=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ViosM8/mmE7JWNNWChrNiQvjOXb8MC/yOWl2dkqrgASR6O79UiHcqNG3f6o2zFoGCWE3sx6yeO1sTCpIeQ0CJHYVVCi+JmFXrTJCappnHXVsvtC/TnnODFe2fOLJYRuovJn3jvTI9D+RPsONUPk1T1cusNOLjrA5FJYrECU/Q38=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=49eW2WWB; arc=fail smtp.client-ip=40.107.102.73; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; arc=fail smtp.client-ip=62.96.220.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id D4046207C6;
	Sun, 31 Mar 2024 18:40:17 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id g6Jx0-kGxK7F; Sun, 31 Mar 2024 18:40:17 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 7F364208B2;
	Sun, 31 Mar 2024 18:40:14 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 7F364208B2
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
	by mailout1.secunet.com (Postfix) with ESMTP id 71BCC80004A;
	Sun, 31 Mar 2024 18:40:14 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 31 Mar 2024 18:40:14 +0200
Received: from Pickup by mbx-essen-01.secunet.de with Microsoft SMTP Server id
 15.1.2507.17; Sun, 31 Mar 2024 16:36:42 +0000
X-sender: <kvm+bounces-13110-martin.weber=secunet.com@vger.kernel.org>
X-Receiver: <martin.weber@secunet.com> ORCPT=rfc822;martin.weber@secunet.com
X-CreatedBy: MSExchange15
X-HeloDomain: mbx-dresden-01.secunet.de
X-ExtendedProps: BQBjAAoAkUemlidQ3AgFADcAAgAADwA8AAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5NYWlsUmVjaXBpZW50Lk9yZ2FuaXphdGlvblNjb3BlEQAAAAAAAAAAAAAAAAAAAAAADwA/AAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5EaXJlY3RvcnlEYXRhLk1haWxEZWxpdmVyeVByaW9yaXR5DwADAAAATG93
X-Source: SMTP:Default MBX-ESSEN-02
X-SourceIPAddress: 10.53.40.199
X-EndOfInjectedXHeaders: 13521
X-Virus-Scanned: by secunet
Received-SPF: Pass (sender SPF authorized) identity=mailfrom; client-ip=139.178.88.99; helo=sv.mirrors.kernel.org; envelope-from=kvm+bounces-13110-martin.weber=secunet.com@vger.kernel.org; receiver=martin.weber@secunet.com 
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 6BA7220892
X-Original-To: kvm@vger.kernel.org
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.73
ARC-Seal: i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711747844; cv=fail; b=YIkjwuNUzzOeRWU1I3zn+uRiXo0UOTNW5Wv4i24y52AR+VJKjh4MCVxYj6ri3mI43ovXaCz7cRcka/61NHzDOsCJiOjRiZ/9RF7xdmi0TxK8RshospfmyhZTbBsD0ZSlfLxtngr8fsw3kUTOaIvHq4QWwfhjqCx/TAZkdw1kAbo=
ARC-Message-Signature: i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711747844; c=relaxed/simple;
	bh=XK+D24Mus0Fd07JBujOKIkrDHXMbMMVpD3gupVHk9as=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XRG1K8LvSKHuPy+pIIjc7uu1l51w0tZp0D7tC4z4too2NPcVKD5pi/+Yh+RbWu3dVUiqiKM7xZWrcnTUVovojDGKCLPAo2Z1HRrnEmUi+79ygyNmmUedP/SItwmhYCVHe8OrZnAfvRT7gNgrejGS/+Jm/zWC362ZD4NkopOvuKo=
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=49eW2WWB; arc=fail smtp.client-ip=40.107.102.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GT1g8yvH1XiIyMv3WZzJr0f9OR4m2qNQEHYbpJNU2yS7QR0WxcABB+vft30MgudoqtusO2GADtOaEeK3/EDoaS0HmeKEVElxkdxnL1rT3vLf/6c/pO58VwLbtRhXgu44DCWEMjLzLbICMvKX4aa3LUFtKPEQoICO0Lu6wTz7sHy9aqttyb8HX0DwxcdKHeMURTPFDV26zRDJ7X1Y+MaTnrX+t+HeP+mCT95eGTVFix+i003o3SqYUP1ZrJWely38NM56W949SMYjn4Dg2ybjM/tOPyUhyOKmBmKYh8OQMPXxP8gAMs7/KEav6ltTzvqYmU7fZfH9iYFbZVWpK7hWLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SDJ9GNkgsvqUYnrui+dCPye3Ifpx9eOhVld2KHe7Kfg=;
 b=OhPSblThE+RenDPgf1HcXqsiDoZSm+4u9ni3LITnCRIyrK4j9MfHlIZfFaHF0tVdIrjncJVI3XnZGVWAENmEVPI/BkL0GpEusP95ea/+RiJ1U2t6eZW5PkRSMpnIXYOxfAtmUw49NdnZtX3vOy0gAAf2cRCOiKeO4zwRoBkk0aXeILbTJ5jLGZy8nvNF+UnEijqC1nOmhGGXLDRRFqsM9GgmoM4MFvf2rU2QYsx5dWNUMKPYx+roJtCW/iiOXh2BzLy+jWHUORKxx4mYlKPQlmknIhzwFWtpvllfOhgXd98MZ70NJk1+hovCcV/E5+jvONqwj2M+f/qqtl8OevvyFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SDJ9GNkgsvqUYnrui+dCPye3Ifpx9eOhVld2KHe7Kfg=;
 b=49eW2WWBX2d+bcp8GLInaCtH2PP/79KfcBPSjFAWhqUhYnziwuMReilySXJMi63SrZFe/e3aXvaX9W0/wMndJMXOSaRpkPfFdNfyRyL9yVH6ZcUKFNY4Pe++bH8Cki5fvp6jz6I4K1wgi5CVblObyjMCMqafjR4CYTdaaDWa/b4=
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, "Sean
 Christopherson" <seanjc@google.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>, Xu Yilun <yilun.xu@linux.intel.com>, Binbin
 Wu <binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH gmem 5/6] KVM: guest_memfd: Use AS_INACCESSIBLE when creating guest_memfd inode
Date: Fri, 29 Mar 2024 16:24:43 -0500
Message-ID: <20240329212444.395559-6-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240329212444.395559-1-michael.roth@amd.com>
References: <20240329212444.395559-1-michael.roth@amd.com>
Precedence: bulk
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001C9:EE_|CH3PR12MB8329:EE_
X-MS-Office365-Filtering-Correlation-Id: b0fa828f-dd22-4374-38d9-08dc5037791f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1Ah85ZJzdT1MmfwJUT1oLJ/mt5e06IV2F58zgUgMHG23CNVKp3VkSiuqNB6UfYaF4BEAE/r8jioyKjBpqnoQzYmBtQrMmSG4/60Bjb5x6+SUby31c2/TwWanex8taFGN/2hx0b+u9o6/Z6mlmd5EhXbtvU7EoQrhw46NTANnUDA4wdsIIBjruwWGLWuZmR0cLtW1bcrpKCoGhjjr6bPj2Z9SAzjn+FIa+VgaZdF6G0TO0sVRsE9kcOMFCHG0T476tXu5Ev5FSyiyaN/QY3k9Z2l918fdSepmREEqsIboP3BtrVtfsFxU9YRwaU8rWioBaa/teG5K6RmyT9CcfUzHOEMaRuqFpN64a05/ooAmXGZus86jbBNsN1Cr84GJpDcNQHsICgd19QcVgiZFrJo8+0aAm6HREvEJ06TtfeKRhuKpTxT77gE90sBhdCQ9Pau8V1D0SQodZnvsyOrQyLADSoxuooCwaj7Ras5kidhixfpqV/+F0dNuP5Zg0e5pN4HoM7L9/uRMEak1PYe0tXP2eINgP211TCnxK3KcNToC5NHJ9eJ8D8V+71y3LulvnmokXllkot8aSygikf1WG+tLJxrE42SSYM7Fbyo93G4oucvCL47Gr9zv4aNDUnw/x84yF555AIUjV4ZIZFGvz+JPtFm5s0Z3Tz/xK5uYrfIZA0i7ecFHzwamf5/g9M6Nss7HOIuhxn16Q4dydFvmDltcPw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(376005)(82310400014)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 21:30:36.4030
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b0fa828f-dd22-4374-38d9-08dc5037791f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SJ5PEPF000001C9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8329
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10

truncate_inode_pages_range() may attempt to zero pages before truncating
them, and this will occur before arch-specific invalidations can be
triggered via .invalidate_folio/.free_folio hooks via kvm_gmem_aops. For
AMD SEV-SNP this would result in an RMP #PF being generated by the
hardware, which is currently treated as fatal (and even if specifically
allowed for, would not result in anything other than garbage being
written to guest pages due to encryption). On Intel TDX this would also
result in undesirable behavior.

Set the AS_INACCESSIBLE flag to prevent the MM from attempting
unexpected accesses of this sort during operations like truncation.

This may also in some cases yield a decent performance improvement for
guest_memfd userspace implementations that hole-punch ranges immediately
after private->shared conversions via KVM_SET_MEMORY_ATTRIBUTES, since
the current implementation of truncate_inode_pages_range() always ends
up zero'ing an entire 4K range if it is backing by a 2M folio.

Link: https://lore.kernel.org/lkml/ZR9LYhpxTaTk6PJX@google.com/
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 virt/kvm/guest_memfd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 4ce0056d1149..3668a5f1d82b 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -428,6 +428,7 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 	inode->i_private = (void *)(unsigned long)flags;
 	inode->i_op = &kvm_gmem_iops;
 	inode->i_mapping->a_ops = &kvm_gmem_aops;
+	inode->i_mapping->flags |= AS_INACCESSIBLE;
 	inode->i_mode |= S_IFREG;
 	inode->i_size = size;
 	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
-- 
2.25.1



