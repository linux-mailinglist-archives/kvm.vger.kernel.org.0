Return-Path: <kvm+bounces-71841-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oE0TCbUMn2neYgQAu9opvQ
	(envelope-from <kvm+bounces-71841-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 15:52:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B851419902E
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 15:52:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0895E3136414
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 14:51:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D73773D3D03;
	Wed, 25 Feb 2026 14:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EMjWH7Ot"
X-Original-To: kvm@vger.kernel.org
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010067.outbound.protection.outlook.com [40.93.198.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F23711EA7CB;
	Wed, 25 Feb 2026 14:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772031083; cv=fail; b=u6BYJPTniYcO6Z8XTP1FDbZAYN+mhZb77tMDOs474Vw/6FWGioq8L6Axit2zOCSZkCB5d0lcSoA+QniY9ybnPh9UCDwXIM18dPcBqVcnMDF/DQdTM/0OgJSGSckW0D/yMAHGZChcl6FHonghQxifF776nCJCA6gPUjWbuzSIfRg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772031083; c=relaxed/simple;
	bh=Afut1vXkjmusQta3QeUKzUAIYhtZAaJj3tvU3W/UAE0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EYmSE+ZaLhRvE6J1FtTKAogNZWTiCpaFJetbffGwno6O21NwV4rwWzqQSnXWexKSbx+JiX/LGP/2v7xClAHNZgN46zvYse06evOAM0kJgmVBoe69AYe+4V+Wbe5MXaQ9sJOrnktL+uD8HSvwHgmdTZw9Y5RVc6rtu5RrN+Ft/n4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EMjWH7Ot; arc=fail smtp.client-ip=40.93.198.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YH7VWbTOdCBa+qZDGpbqO99injeKCN//pazlCJ1tUBYLojlwt6WPJ55rHIbFeR8bpXyuCNpQxND7XDxYO29c91CrM6YVezdxgBOAvOJxN1av0oD5F/PF83I8dy10dgtjQz0yA3Xzj/tedXF6nAhv7HWgHqwbM/AEyroTk8HFDbUV93EybEIY//k7A5PqCyiLIo5AzjWsovIh8H5JWfw98uXGTjYrDq3SpoDQLvsY7ml5+hOdG2PzWdZtGo5zmR2y72UnCGpJlZVMjCFEVYTUTMImDjkUDMZEgP0z68wuKmuC08KPHNP0VXAvFtdHkqHg1tdPx8MK0J+RSg7Wa8wStw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LsIYeZy3yDAHmuO+F9eXH6KS5suYQ4Nmpa+ELTJiK7E=;
 b=lyZZnP1MfuQW6u+jcCoBRSTGI32myYJQbeEF1mVCJgE3F4j071lgvm8DpDFtnyF4nIG1S3sJZhhnfwf0oVVbuiKMN3LRwZsKKd9EiADpG99vvzvbpESdD35A0V8Dod5vEopwksTwztGIzLx/LnIb7Rf6vzGu6cYUOsF01DWp7i8YmAL/HC4pwzL0N63SCXeMpAMPX4y/47HRHEh8hgIxVnKhAIkqMD0d5wrRUEjNKiZ0/LJefpp3Onqvg6QTWLFf4fhxgXYDVE37zCvRmxt6jPGrJ/Nq1eHrXIsZVBsr+oIRadnqryVW2i1ceBxTtpnWluYAlAJBxcAP/nktc2xUuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LsIYeZy3yDAHmuO+F9eXH6KS5suYQ4Nmpa+ELTJiK7E=;
 b=EMjWH7Ot6I1Wjk1vE6k3/jL7657NHLhJzJQazO4n9wHa5bpd9gI7JXv9Mbf3ijI9zIaPOxlfox0WD32gIel8VabCnevixtf5WCgZqETvuW8xnSkgK1YE4HMiwpNGSPghKaJI0myxc69Gk3Y3AIMEqDWxgQCYDsfpBOyLRRKA/1Wx5wfsS174PBhIiFpdq9YpLEb/tuf8EgUimHBEY50GZQfgXo3uwsgn0k1cke3oL1oi0BnByN/1uezfBY51NrPZZ4m1s0QMX1UDyl8+/lmRN9upu0LDgHb6e1EgKkphl2VMphVIlDLRC9V/1Wkvje2gbRxx64/63gt3Bvktq9ji6Q==
Received: from SJ0PR03CA0245.namprd03.prod.outlook.com (2603:10b6:a03:3a0::10)
 by SN7PR12MB7810.namprd12.prod.outlook.com (2603:10b6:806:34c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.11; Wed, 25 Feb
 2026 14:51:11 +0000
Received: from SJ1PEPF00002319.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0:cafe::33) by SJ0PR03CA0245.outlook.office365.com
 (2603:10b6:a03:3a0::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.22 via Frontend Transport; Wed,
 25 Feb 2026 14:50:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF00002319.mail.protection.outlook.com (10.167.242.229) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Wed, 25 Feb 2026 14:51:11 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 25 Feb
 2026 06:50:51 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 25 Feb
 2026 06:50:51 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Wed, 25
 Feb 2026 06:50:47 -0800
From: Gal Pressman <gal@nvidia.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>, Naveen N Rao <naveen@kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Gal Pressman <gal@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>
Subject: [PATCH v2 2/2] KVM: x86/mmu: Fix UBSAN warning when reading nx_huge_pages parameter
Date: Wed, 25 Feb 2026 16:50:50 +0200
Message-ID: <20260225145050.2350278-3-gal@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002319:EE_|SN7PR12MB7810:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d810435-d98a-4dec-8577-08de747d5135
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|7416014|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	vLvt4FstadkKid+RWeMZB+pqPW0/BkE/DCjIfoe6qFW6hkSVIY/sFhRgF9FU2y1I+oO+xYNDUEJcoM4W74Oi4snLf81JjU+CJpwooFneuqfpcCURZ+Hq05HOxpGTQDLk4385gFct1RP2huPNFdluAdD40m4hLzdLR3rIVHyP2O8Vio/ROPshleXBKXT3cSbRvxBpvGrelwunWSRZYoLAmVkPUvAQ4q5PICV1xL0Kdl/ioXvDCqIVRjDG+xZrlCabSYcYxsJ8m1vFUSHtnvGzBYTV4Sc8cPkt5UJFn1/oe1/59wjY2ZjnvQxL/sJeoAQytLhh0uxniQvPIE7gsB7sWOVgCBQHY0XTqhXoJVulIpLc7IN3RHoPWdqJUjUa2h/uASfPU61NbvRnasGg8k9ilpzE6ZLLtojKrMfr7X1wFUjUOxvHWYBfkqQ9OfpUax3P0AYaUGBfKBV0Wroq+HwzGBPteOtobR6FuIbFL63r/HjGFv+FkTE+ZQrUi4KGutFkIqt3TTGJGUIAO4xC1l3SgYJUulo0aAfS4gZn+rD6nwPukhSx5H17G2kivWK5WCxz4FUuO22/UZXGVzHmA13FGzhKg5bvRFM/z/BByOANYHhyDoywhAN5cbWcLdkMDVyLBSnQeujhYTVBmO9+UlNoSqIhBoEnkmPKwur9TYFqYtwFuEnEzf9nfJamtFMgaWDl+BqWNpLtsToXfNq07+jHJEwJGq+ymeqiws96afyDZMgqikFL2Lk7wi4Dy6Uw8XN3mXdnsB7cLeHQbL68Hbhnznz4XBHbtarTFvWlLMuNrcjSLYk8KJ1ARemucoiGMO/a0jnz+zsKNPYjONkATEDGtDkhDk34ELpDAAF+xT7/arI=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(7416014)(82310400026)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	7HF9UwbbfmMblG0NDqNgFU5R33tsVcQDnF3i4EXs8Q3JAM5/7uA//wbN27ZZoHLt1A/17nKrwj/zyjfO+Wdw+z3jcUAU6jrvYma9H8NUzwdILnjPnhv4H6z3bGYtOxaEG9a8JtD0egN/vJER8Ockfh1RX3ib9acX5ntiRECOlUKADHFBhiyx4E6Y3efy5dvpuYYP273XFueYKXXERjsl3MEyDXzTaZukE5ds21uKqAqcsZkjoEV0brbuORDeOfoyvzdxGbzquru7mpVUcLc8tbFCAJo4145r+bmJ9hgvrnD1KdkHCXTvKBmega8cQXws6O+3Ra8NG71wN97jFf5SvIbjNnqWJmbMDreLof40KfzTyvYWuL8o5FNsEjhJrv5rOhM4ThdQmmHo9aVQouzELhDHnZFSoPBahbO1CRviVFnjdqW4I3Obzee7dS99NVeH
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 14:51:11.5126
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d810435-d98a-4dec-8577-08de747d5135
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002319.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7810
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71841-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[gal@nvidia.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[Nvidia.com:dkim,nvidia.com:mid,nvidia.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Queue-Id: B851419902E
X-Rspamd-Action: no action

The nx_huge_pages parameter is stored as an int (initialized to -1 to
indicate auto mode), but get_nx_huge_pages() calls param_get_bool()
which expects a bool pointer.
This causes UBSAN to report "load of value 255 is not a valid value for
type '_Bool'" when the parameter is read via sysfs during a narrow time
window.

The issue occurs during module load: the module parameter is registered
and its sysfs file becomes readable before the kvm_mmu_x86_module_init()
function runs:

1. Module load begins, static variable initialized to -1
2. mod_sysfs_setup() creates /sys/module/kvm/parameters/nx_huge_pages
3. (Parameter readable, value = -1)
4. do_init_module() runs kvm_x86_init()
5. kvm_mmu_x86_module_init() resolves -1 to bool

If userspace (e.g., sos report) reads the parameter during step 3,
param_get_bool() dereferences the int as a bool, triggering the UBSAN
warning.

Fix that by properly reading and converting the -1 value into an 'auto'
string.

Fixes: b8e8c8303ff2 ("kvm: mmu: ITLB_MULTIHIT mitigation")
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Gal Pressman <gal@nvidia.com>
---
 arch/x86/kvm/mmu/mmu.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 02c450686b4a..3644d1db8be1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7488,9 +7488,14 @@ static void kvm_wake_nx_recovery_thread(struct kvm *kvm)
 
 static int get_nx_huge_pages(char *buffer, const struct kernel_param *kp)
 {
+	int val = *(int *)kp->arg;
+
 	if (nx_hugepage_mitigation_hard_disabled)
 		return sysfs_emit(buffer, "never\n");
 
+	if (val == -1)
+		return sysfs_emit(buffer, "auto\n");
+
 	return param_get_bool(buffer, kp);
 }
 
-- 
2.52.0


