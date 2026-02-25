Return-Path: <kvm+bounces-71840-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8ACUAo8Mn2neYgQAu9opvQ
	(envelope-from <kvm+bounces-71840-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 15:51:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 620B0198FF2
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 15:51:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1AFF43113F62
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 14:51:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C27613203A0;
	Wed, 25 Feb 2026 14:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="h12SxxhR"
X-Original-To: kvm@vger.kernel.org
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012046.outbound.protection.outlook.com [40.107.200.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1683C1976;
	Wed, 25 Feb 2026 14:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772031077; cv=fail; b=EwoLATZyeQ8qWcJYtUdAXQqVR45Mw41Q9hdkj2UwuSNW7cWjP2m8WZJ3/Km8it1ET0hE+sZoiJ7kSgy9LEc1f3BzOt37jiQZllMpihdlOvSEa/0hL4TDKohezC4eqOaKN5yPRjFV6sM9uglXuXrLApnT30H6NncwjzZvpqdRf+w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772031077; c=relaxed/simple;
	bh=l6M1YSj2btJD/tJeAXRUYENChtVtiyiy6tASJWIVFlw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=unNZMKBq7hcTbPXiRR59ufhTAbDuC0HIzpgqc0t59MLpf1OLD8ljZ6Se5JmhHTx7VuQyo4BfNTxKUDWa3M2E+c4liPBZH59g+URAFXDM+aYgAzvlNX9dkSaVMKApZ600noyRMxyAhtdLMJ+y9QwvbG3dC1OcOieGQ55Pv0nc6BA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=h12SxxhR; arc=fail smtp.client-ip=40.107.200.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KBXWtlQZeky//VXnqzvz6g6FftqMwZ19dTtbZcRUsSgDnH72zTzmJc3Ih/BObkglTw6L5i6h7mZ+sisWMbRWdkleZQIqOWcedYXvvc0ufskpfyTLfxm5x8VcHlHIsiPMzqVF8v3wLTk/NsHJokxYTrFL9Zso0wHWl8xJGnGl8DQoXc0IyEJCSwWNftVMPvwqrDAkquXudY2I3vS1nv9YIaa6HauaPF2pnS3rihVAM2CODn12j6J0Cs4sncPWiuzOPxU73looeaHNDNZtjIo7TBAqHqyq8pbbJYAfzxp8hzCa0SeYeL2uyN92RDZkVSwYooExhXFwQLgvKFcspAlxXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tQ4XvNxSQHTcc8kEhPX6i8EcWp20TVEn7O6jme70yTM=;
 b=VEBNrum808zFvXD+V2L7Ft95IPUH3BevBNyagsFXQwns37JkJ+CopB+yuppacKqylaGLH/rf3vFq7tBOEtBe9wnzIIVv8aT8zHfy1ZXZ8ZUVLUUFX3oYTIzel5uVFXMZvEj1ZWkQbDl+HcpwIgXbCWlAfbzk1MczNfZzRvbhPHEdzAJ45ATfiwueorF+KakVxtEzNqJl4wKs83eo6d7IDry8hrX2TZEL+4J0z47st6f0/c+H5/fm/4kvsLNXu0SzZPSL6uMH3GNFV5F0FeeQiYnM5koh9yTEgWK8z1Fv2Bg+9rEp19JTN2/zWH7KOVqUkNCh/RUrGt2cYYUe7GlRYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tQ4XvNxSQHTcc8kEhPX6i8EcWp20TVEn7O6jme70yTM=;
 b=h12SxxhRk7rfxsf/fKTfgxeVjb3hFgCJFYVsgHuZ1zCPIUS3CfOlBVykM/7Vp6eRSJByneor773g/diB5ochxcIQPG5vmGpotxNbTwL+7xbH2NwtjMI7t3FgyLwjRJuBsDn8giLZw7VAkSI1IGBK7iSV55xtmk3nMHTx45fpJvM45KP08ZtmEYCShJ34NjrYJ2KKexZ66Xzhy2nvjokUMD3fgWBzGW1QZ/FVulK5/Wihi9EZn8fyueDZGXICoLGiOm2aN0b5H7Gq6ZRv78LwrB645ButS67npWIKK9eDO7rf6YHkR/rdjzeQcbBvj945gCR80xCXaz2H/lQ/n3T6TQ==
Received: from SJ0PR05CA0164.namprd05.prod.outlook.com (2603:10b6:a03:339::19)
 by CH2PR12MB4327.namprd12.prod.outlook.com (2603:10b6:610:7d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.23; Wed, 25 Feb
 2026 14:51:08 +0000
Received: from SJ5PEPF00000205.namprd05.prod.outlook.com
 (2603:10b6:a03:339:cafe::c) by SJ0PR05CA0164.outlook.office365.com
 (2603:10b6:a03:339::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.22 via Frontend Transport; Wed,
 25 Feb 2026 14:51:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF00000205.mail.protection.outlook.com (10.167.244.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Wed, 25 Feb 2026 14:51:07 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 25 Feb
 2026 06:50:47 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 25 Feb
 2026 06:50:47 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Wed, 25
 Feb 2026 06:50:44 -0800
From: Gal Pressman <gal@nvidia.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>, Naveen N Rao <naveen@kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Gal Pressman <gal@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>
Subject: [PATCH v2 1/2] KVM: SVM: Fix UBSAN warning when reading avic parameter
Date: Wed, 25 Feb 2026 16:50:49 +0200
Message-ID: <20260225145050.2350278-2-gal@nvidia.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260225145050.2350278-1-gal@nvidia.com>
References: <20260225145050.2350278-1-gal@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000205:EE_|CH2PR12MB4327:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b13bc6a-ade8-4e02-6409-08de747d4f1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	6YjCqza5pzh1g0d91Mw7C05F+nLD5Lq5hkLAKbsIhUOxnp5Twa8BQXeas1RX635eyvgcdEFN9y5BB5TBNtiSfYn7je01y2tyZaRhxBTgrthuDuWDi6KBYzEJvFQ6WA3TYtU+NYIELV6Z+MfxpeuUPpxQFiTaJqYlDGOyeYKDbVi56cJvqIX6ylW7dJzjyL+SJjn70rU1ig2QgfJ9mBt4eYKQDcx9Vg0IDa2EdO4FZ6ud5sArrIsCAzVmvw4swKm+/wQv/DmeBJL+RSgAWHPa0WqAeZRuJagOXhsTxsGFF/tSRfcIoB56LXt9VnOhBpXWPemu2mNB1WS0drVVjPN7uUqvSH1VlM+KyZQ3kUOQnE88fvts8Jbtk+PK3Qnm4CtexubYqYQcsMY59BwaPa/3y5iYuYxEfengcOEJPZHSvc86kz2B9P5278P8+j31Xuia9n+rsCIkbDuyY//0Ggj4HNQfT9F5AirwcLD+wlsyX/FNSP/Xo88ipFsJrrVnUaSy5yc3p8FgqaAJnp6A0C6uGn+F6R+LiWNdpqO2MHJWj4qrz7xKzYXU2t9+Aq3blRnUY3j1SasKFBNZlgJ1YwCFCKjf8NB8ChVu2vqfYQVvaFi6I6vEfbXoUPvNZEuXP51P+MeBaDbTx9zm8m/jXxM61fjeredFwT2vsgyz05PM9CKy3W3BTkAtD0uJTH4q6wqm4+c4LFVHNsq09aDkdntBFuOxGx//LZMwmuXgGvr1OZ2bA525WQLUz7tJGLgpyXihxLyTsUSYKIc8+dDpB1MSAN3S2y2FvxLu92YP/zVsHVfir+6QnFWp+IJ3FsXS6Jn+2cCD9HBS1705DU3GzKZAw6flleHiX1gzc8Mo+tkhQXE=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	mL+ufT8Y1T4lE0vvcHWGvqnRyKJECdZfKgXu57yHIlEgdS4Dm3DkqAeBio8zQaGEu9xYpBHyTONq9129BMEo7A13gq/baafsxY4VOCxzNC1Fi8cThQ3/lB4TPhibZLAYPxezi9xe8PU6p2XK3r/s9CPRDFJ8EUIYwaTQft6P36roOpGT7eSuk5mRC/rZ7OhIzSKwsJ1CXG69PRjqJAhSOaPgCzuoHEVdnVhv8BvSkqwQN+Gr/PjoV2IZckRuzC6h2S2OEFhOjpa4NOQJMwzPaeM2zbCviBm0ZD3QhErBtizKHCgTfP+9uLWxUenRA+ZzjNYAySGau8uzJtCqNE0pWnO1FGpXuGQuCSMkqLoNtxKZsJIJaiY6IOIMoyUsF/wCPzMxFVFXkckXiQfAwIhmbN/DCDHFKK5ttkP4n77xoEM+RA0KiztZWZrKnWqiTEWC
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 14:51:07.8869
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b13bc6a-ade8-4e02-6409-08de747d4f1c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000205.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4327
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71840-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[gal@nvidia.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[Nvidia.com:dkim,nvidia.com:mid,nvidia.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,qemu.org:url];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Queue-Id: 620B0198FF2
X-Rspamd-Action: no action

The avic parameter is stored as an int to support the special value -1
(AVIC_AUTO_MODE), but the cited commit changed it from bool to int while
keeping param_get_bool() as the getter function.
This causes UBSAN to report "load of value 255 is not a valid value for
type '_Bool'" when the parameter is read via sysfs.

The issue happens in two scenarios:

1. During module load: There's a time window between when module
   parameters are registered, and when avic_hardware_setup() runs to
   resolve the value, where the value is -1.

2. On non-AMD systems: On non-AMD hardware, the kvm_is_svm_supported()
   check returns early. The avic_hardware_setup() function never runs,
   so avic remains -1.

Fix that by implementing a getter function that properly reads and
converts the -1 value into a string.

Triggered by sos report:
  UBSAN: invalid-load in kernel/params.c:323:33
  load of value 255 is not a valid value for type '_Bool'
  CPU: 0 UID: 0 PID: 4667 Comm: sos Not tainted 6.19.0-rc5net_mlx5_1e86836 #1 NONE
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
  Call Trace:
   <TASK>
   dump_stack_lvl+0x69/0xa0
   ubsan_epilogue+0x5/0x2b
   __ubsan_handle_load_invalid_value.cold+0x47/0x4c
   ? lock_acquire+0x219/0x2c0
   param_get_bool.cold+0xf/0x14
   param_attr_show+0x51/0x80
   module_attr_show+0x19/0x30
   sysfs_kf_seq_show+0xac/0xf0
   seq_read_iter+0x100/0x410
   copy_splice_read+0x1b4/0x360
   splice_direct_to_actor+0xbd/0x270
   ? wait_for_space+0xb0/0xb0
   do_splice_direct+0x72/0xb0
   ? propagate_umount+0x870/0x870
   do_sendfile+0x3a3/0x470
   __x64_sys_sendfile64+0x5e/0xe0
   do_syscall_64+0x70/0x8c0
   entry_SYSCALL_64_after_hwframe+0x4b/0x53

Fixes: ca2967de5a5b ("KVM: SVM: Enable AVIC by default for Zen4+ if x2AVIC is support")
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Gal Pressman <gal@nvidia.com>
---
 arch/x86/kvm/svm/avic.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 0f6c8596719b..ffacd619956b 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -19,6 +19,7 @@
 #include <linux/amd-iommu.h>
 #include <linux/kvm_host.h>
 #include <linux/kvm_irqfd.h>
+#include <linux/sysfs.h>
 
 #include <asm/irq_remapping.h>
 #include <asm/msr.h>
@@ -76,10 +77,20 @@ static int avic_param_set(const char *val, const struct kernel_param *kp)
 	return param_set_bint(val, kp);
 }
 
+static int avic_param_get(char *buffer, const struct kernel_param *kp)
+{
+	int val = *(int *)kp->arg;
+
+	if (val == AVIC_AUTO_MODE)
+		return sysfs_emit(buffer, "N\n");
+
+	return param_get_bool(buffer, kp);
+}
+
 static const struct kernel_param_ops avic_ops = {
 	.flags = KERNEL_PARAM_OPS_FL_NOARG,
 	.set = avic_param_set,
-	.get = param_get_bool,
+	.get = avic_param_get,
 };
 
 /*
-- 
2.52.0


