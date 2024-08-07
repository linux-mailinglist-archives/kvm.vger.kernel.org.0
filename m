Return-Path: <kvm+bounces-23464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B1F3949D31
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 03:00:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AB574B2520C
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 01:00:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A63736B17;
	Wed,  7 Aug 2024 00:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rfFjvCGQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2068.outbound.protection.outlook.com [40.107.92.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4138629D06;
	Wed,  7 Aug 2024 00:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722992395; cv=fail; b=A/zMuBg5cpy4QSXK5fThtHlzTMg2DChov309jHHsciYbjvttD1moVwIX4E5e6mgjGcXylCgJWalWddbrkH7sGDpsYKAx9WEE4o8tp+CQr5Ijrgesa5H2mXJq+wrkjpr61RzhQnG2no3F1aF6wfArevKHCvD7RdTREhJleetsUDQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722992395; c=relaxed/simple;
	bh=s41LjGE5nZIC7BCsf90Lv4GzrhJ8WVGUe19doM7vyOE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MN/YWQtDk4enPTcSrpWcjkduVD2AkWLEuqhRqTR0EfP8tvF699+CpdBLaUgM+K/XdvRikj+heeV8JFcAu7oEHbsS7jdGqAChIBrW8DP/VHiDg5JbtA2p/+nrkFDLNVMxGgAIUHbHH2Stw14JDUZulyAu0qCGu418xa7YrqxBOMk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=rfFjvCGQ; arc=fail smtp.client-ip=40.107.92.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=od/FW08UxFOdc6nxB/SPyk/iOen4q0wK1bxWpXg0Pzu7c3c14cs7AReoeq/IraTUv469WiVQZxJTpEerZTIMGOHDSF17DsSW+rQCSZ+n/VJSBr9UFUQbkSwyiSUwyz/EJINkJ9IYfqsJDXAPC3EfPxEQcYXo5SVXUDeTAdZWNWj73bYaeNzTGfNIdOHaOJqN0dQn0S0mJFZHHoBGDrOHFWH+ygFO5CuE6y1vaYa9jn4CwKMW/MZ2O4FHX/kkEem22GRHSv0nRPg5T9fFkG3UJGnowdaXHPLTNMa/L7r5XQbuG7vQvmPbrqKTGY6Wjrk1SiKXgLSx2xp4bC0B7Wj+WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pAjtyXOJ+SnlJAkUKl2DdR8efYzHp74wt2fiIwaqP5Y=;
 b=GpX2GkTH3S49RbNhXsSvFsy7AKA5lNsFAFF+Y/Y7ocIfCXVk4XF23sgdXe5z/AzK0wAspXf2reIEEbpFJbZ9ypLPmQdRbX5GFq4Y2SgLPT1qqPg18j5bntgXkm26xLsa2UacdNQw9CF9Byb4FbhscO5zsLwKC1PH+V8Ft5WkMnoi0GOy4ONZ/BmDlshsnFZ1AToJfPAWRvCM2cs04qCin/7/nbpfgaKetNhZ1Ct3QJoE5HwK0TMelfE85hGnozFe7cnpwS0cjkmpGio4Vnt9ZNAQ2ILHJKugTf9QqaqlgyEgLVwqefzaT5ixfyatxJMOv9b7k0a8s8CKc6inKiu6Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pAjtyXOJ+SnlJAkUKl2DdR8efYzHp74wt2fiIwaqP5Y=;
 b=rfFjvCGQNrFhtp/lbDKyKwH5inAfNazVCD8amCZZggo98+C1B9xnghgVf0WWdNWTrTcRBG7lkVPuJxxIAw7Uj0YPNkh9QfQlHFAw0AlnFytLBK+wP+PjREehvafKDhjAJCA67qBz+JiXwqO4NmBY/bEmbAJVg1A8Uaa+O0cXM4g=
Received: from BN9PR03CA0524.namprd03.prod.outlook.com (2603:10b6:408:131::19)
 by SJ2PR12MB8782.namprd12.prod.outlook.com (2603:10b6:a03:4d0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.24; Wed, 7 Aug
 2024 00:59:50 +0000
Received: from BN3PEPF0000B076.namprd04.prod.outlook.com
 (2603:10b6:408:131:cafe::3f) by BN9PR03CA0524.outlook.office365.com
 (2603:10b6:408:131::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.28 via Frontend
 Transport; Wed, 7 Aug 2024 00:59:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B076.mail.protection.outlook.com (10.167.243.121) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7849.8 via Frontend Transport; Wed, 7 Aug 2024 00:59:49 +0000
Received: from ruby-9130host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 6 Aug
 2024 19:59:48 -0500
From: Melody Wang <huibo.wang@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Tom Lendacky <thomas.lendacky@amd.com>,
	"Ashish Kalra" <ashish.kalra@amd.com>, Michael Roth <michael.roth@amd.com>,
	"Melody Wang" <huibo.wang@amd.com>
Subject: [PATCH 3/6] KVM: SVM: Inject #HV when restricted injection is active
Date: Wed, 7 Aug 2024 00:57:57 +0000
Message-ID: <7dfe041d3ad27a082c000fe1cc6d7eea14296519.1722989996.git.huibo.wang@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1722989996.git.huibo.wang@amd.com>
References: <cover.1722989996.git.huibo.wang@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B076:EE_|SJ2PR12MB8782:EE_
X-MS-Office365-Filtering-Correlation-Id: d7b9d7fa-4a2f-4f1c-580d-08dcb67c3d1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VS2v/MKxnT1bB3kgVGhyUQ6FTNYBbo0c6ORrW7atyv8vSy3MQ8Z3bJTsO/Jq?=
 =?us-ascii?Q?3ED2v+2Nnrx8nwKxIEz6dZXq/VTlzVIQr0+ztbFx473qcljsNfIZcrweKXMH?=
 =?us-ascii?Q?5soQRP7OQ+/QgOcbUF4Uuixxik2EyJhUOKCmm0kK4lyR8hXmy9296l9ZUCiG?=
 =?us-ascii?Q?5JLcuVnd/ctXAbCTe4l8V/v3L5HBTazgnmDD1P/c/kC5W8RTfberqSTRwFLw?=
 =?us-ascii?Q?V1g0qGQURSv82Twi7WZgUw82LCKfGOaSZg9mw57UlrUntz9/WqVNdxC45Wih?=
 =?us-ascii?Q?M43os8xEDK/Uzo/UMWW1ocjYFdgtBlk9tSYECYdabyxgfYqls8Pzih7RhW1O?=
 =?us-ascii?Q?6Vypj15vIprGa4fS1J4vJfLBObWSP7GH9/bEGgjSA1ZKA1XjWqhFF2KNrgby?=
 =?us-ascii?Q?PuHL1meecMl1xf61WdKnqvaBprKMWwSwbJUvss4BgHHOOVZiNYs8KzNqK5o1?=
 =?us-ascii?Q?lLt522dLIoFJzBOgGcGNI4ETw4hFUU81RXq6KM5Ycel6RxcAoTWvLNqEXUIt?=
 =?us-ascii?Q?SdpffAxmpZ1S7nGPWMt156/0cVmICN9rgPV5Nt4j4F3HaiT978TyJaTrzh8o?=
 =?us-ascii?Q?E5fDlGVxkFC1dGwxoMLq+OWZv6MNv5i1ZPxhRAMpExkOmHfhCBKdM+Y6mn5C?=
 =?us-ascii?Q?9dCqCTFmHjE8qRlmafq/IZmdde7UCZz9SCBUU6QLs7Sr6Qj89QwSwKo1lqtL?=
 =?us-ascii?Q?zmsH5VbumEQZHi6rYFoh0E4ZtlpL4SYvLl6HU33qARo7C2Fzxl9hmw07jfqf?=
 =?us-ascii?Q?s1gIu7mgHiEKJHofYCx6iGz8KTbYgW1uT3NTxFMpY0VItx9H0cRLI0BJJWbT?=
 =?us-ascii?Q?Yh4k5u/bpYvinD96KP5BzfcBkR7+MaXR/qX4swluYedTXGyrSJZv+CG7GO3a?=
 =?us-ascii?Q?nt9Q1Al7As9Q+x7zCl6P3ER7MJTzRfGl/S3v8HYp9UOvzN8bP4dUIeVWZkSt?=
 =?us-ascii?Q?p+ovsGtP5qeENIlClZQ70y26lje75Sb8jjXCIonuf2FmgU91e3bCw+xItuQP?=
 =?us-ascii?Q?MiEjpZS/8jTYlUAD7A6bH1ykctug2jNTfm3gQpu1QGvIw3esU/6nA7+S+X7U?=
 =?us-ascii?Q?eVC+1J0Oqv+2QbK/r3CGH9YnwbXkXjfI1lnhIogk4APlT7fIW467pWAe4NAq?=
 =?us-ascii?Q?T36c7pZhUTQopygfagicS5wsn/Pm9c2+55nhlEqlCGJthKN8LFCsiSghoZeQ?=
 =?us-ascii?Q?XpfP3YQ3xr/tywRn6b94G+u5V3uqvM+7P+QDKGLIaPSGpKTSEnBQ+8tnXNms?=
 =?us-ascii?Q?Fcp9JeegIz2otMyMT6MHQSYij3rwaQvY8COUs0Kxj+AQFihN9LSbIvLxoumA?=
 =?us-ascii?Q?3ZxT8/ONRqgo8EUGblDTUjA2BACSqK0FvVKuB0v5eqOJQyAQcx0jD6hCOi9M?=
 =?us-ascii?Q?ZBqRC0vmaUBJzTk5/NkqV6h+eoeAnrt/3xdUMxS8QDJe1Kh34v1HAK9Paax0?=
 =?us-ascii?Q?5OdpucxBPsVJYnct+AhEJlaQ458bcUEf?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2024 00:59:49.6479
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d7b9d7fa-4a2f-4f1c-580d-08dcb67c3d1a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B076.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8782

When restricted injection is active, only #HV exceptions can be injected into
the SEV-SNP guest.

Detect that restricted injection feature is active for the guest, and then
follow the #HV doorbell communication from the GHCB specification to inject the
interrupt or exception.

Co-developed-by: Thomas Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Thomas Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Melody Wang <huibo.wang@amd.com>
---
 arch/x86/include/uapi/asm/kvm.h |   1 +
 arch/x86/kvm/svm/sev.c          | 153 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c          |  19 +++-
 arch/x86/kvm/svm/svm.h          |  21 ++++-
 4 files changed, 190 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index bf57a824f722..f5d85174e658 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -35,6 +35,7 @@
 #define MC_VECTOR 18
 #define XM_VECTOR 19
 #define VE_VECTOR 20
+#define HV_VECTOR 28
 
 /* Select x86 specific features in <linux/kvm.h> */
 #define __KVM_HAVE_PIT
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 19ee3f083cad..0d330b3357bc 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -5022,3 +5022,156 @@ int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
 
 	return level;
 }
+
+static void prepare_hv_injection(struct vcpu_svm *svm, struct hvdb *hvdb)
+{
+	if (hvdb->events.no_further_signal)
+		return;
+
+	svm->vmcb->control.event_inj = HV_VECTOR |
+				       SVM_EVTINJ_TYPE_EXEPT |
+				       SVM_EVTINJ_VALID;
+	svm->vmcb->control.event_inj_err = 0;
+
+	hvdb->events.no_further_signal = 1;
+}
+
+static void unmap_hvdb(struct kvm_vcpu *vcpu, struct kvm_host_map *map)
+{
+	kvm_vcpu_unmap(vcpu, map, true);
+}
+
+static struct hvdb *map_hvdb(struct kvm_vcpu *vcpu, struct kvm_host_map *map)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (!VALID_PAGE(svm->sev_es.hvdb_gpa))
+		return NULL;
+
+	if (kvm_vcpu_map(vcpu, gpa_to_gfn(svm->sev_es.hvdb_gpa), map)) {
+		/* Unable to map #HV doorbell page from guest */
+		vcpu_unimpl(vcpu, "snp: error mapping #HV doorbell page [%#llx] from guest\n",
+			    svm->sev_es.hvdb_gpa);
+
+		return NULL;
+	}
+
+	return map->hva;
+}
+
+static bool __sev_snp_inject(enum inject_type type, struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct kvm_host_map hvdb_map;
+	struct hvdb *hvdb;
+
+	hvdb = map_hvdb(vcpu, &hvdb_map);
+	if (!hvdb)
+		return false;
+
+	hvdb->events.vector = vcpu->arch.interrupt.nr;
+
+	prepare_hv_injection(svm, hvdb);
+
+	unmap_hvdb(vcpu, &hvdb_map);
+
+	return true;
+}
+
+bool sev_snp_queue_exception(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (!sev_snp_is_rinj_active(vcpu))
+		return false;
+
+	/*
+	 * Restricted injection is enabled, only #HV is supported.
+	 * If the vector is not HV_VECTOR, do not inject the exception,
+	 * then return true to skip the original injection path.
+	 */
+	if (WARN_ONCE(vcpu->arch.exception.vector != HV_VECTOR,
+		      "restricted injection enabled, exception %u injection not supported\n",
+		      vcpu->arch.exception.vector))
+		return true;
+
+	/*
+	 * An intercept likely occurred during #HV delivery, so re-inject it
+	 * using the current HVDB pending event values.
+	 */
+	svm->vmcb->control.event_inj = HV_VECTOR |
+				       SVM_EVTINJ_TYPE_EXEPT |
+				       SVM_EVTINJ_VALID;
+	svm->vmcb->control.event_inj_err = 0;
+
+	return true;
+}
+
+bool sev_snp_inject(enum inject_type type, struct kvm_vcpu *vcpu)
+{
+	if (!sev_snp_is_rinj_active(vcpu))
+		return false;
+
+	return __sev_snp_inject(type, vcpu);
+}
+
+void sev_snp_cancel_injection(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct kvm_host_map hvdb_map;
+	struct hvdb *hvdb;
+
+	if (!sev_snp_is_rinj_active(vcpu))
+		return;
+
+	if (!svm->vmcb->control.event_inj)
+		return;
+
+	if ((svm->vmcb->control.event_inj & SVM_EVTINJ_VEC_MASK) != HV_VECTOR)
+		return;
+
+	/*
+	 * Copy the information in the doorbell page into the event injection
+	 * fields to complete the cancellation flow.
+	 */
+	hvdb = map_hvdb(vcpu, &hvdb_map);
+	if (!hvdb)
+		return;
+
+	if (!hvdb->events.pending_events) {
+		/* No pending events, then event_inj field should be 0 */
+		WARN_ON_ONCE(svm->vmcb->control.event_inj);
+		goto out;
+	}
+
+	/* Copy info back into event_inj field (replaces #HV) */
+	svm->vmcb->control.event_inj = SVM_EVTINJ_VALID;
+
+	if (hvdb->events.vector)
+		svm->vmcb->control.event_inj |= hvdb->events.vector |
+						SVM_EVTINJ_TYPE_INTR;
+
+	hvdb->events.pending_events = 0;
+
+out:
+	unmap_hvdb(vcpu, &hvdb_map);
+}
+
+bool sev_snp_blocked(enum inject_type type, struct kvm_vcpu *vcpu)
+{
+	struct kvm_host_map hvdb_map;
+	struct hvdb *hvdb;
+	bool blocked;
+
+	/* Indicate interrupts are blocked if doorbell page can't be mapped */
+	hvdb = map_hvdb(vcpu, &hvdb_map);
+	if (!hvdb)
+		return true;
+
+	/* Indicate interrupts blocked based on guest acknowledgment */
+	blocked = !!hvdb->events.vector;
+
+	unmap_hvdb(vcpu, &hvdb_map);
+
+	return blocked;
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d6f252555ab3..a48388d99c97 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -447,6 +447,9 @@ static int svm_update_soft_interrupt_rip(struct kvm_vcpu *vcpu)
 	svm->soft_int_old_rip = old_rip;
 	svm->soft_int_next_rip = rip;
 
+	if (sev_snp_queue_exception(vcpu))
+		return 0;
+
 	if (nrips)
 		kvm_rip_write(vcpu, old_rip);
 
@@ -467,6 +470,9 @@ static void svm_inject_exception(struct kvm_vcpu *vcpu)
 	    svm_update_soft_interrupt_rip(vcpu))
 		return;
 
+	if (sev_snp_queue_exception(vcpu))
+		return;
+
 	svm->vmcb->control.event_inj = ex->vector
 		| SVM_EVTINJ_VALID
 		| (ex->has_error_code ? SVM_EVTINJ_VALID_ERR : 0)
@@ -3662,10 +3668,12 @@ static void svm_inject_irq(struct kvm_vcpu *vcpu, bool reinjected)
 
 	trace_kvm_inj_virq(vcpu->arch.interrupt.nr,
 			   vcpu->arch.interrupt.soft, reinjected);
-	++vcpu->stat.irq_injections;
 
-	svm->vmcb->control.event_inj = vcpu->arch.interrupt.nr |
-				       SVM_EVTINJ_VALID | type;
+	if (!sev_snp_inject(INJECT_IRQ, vcpu))
+		svm->vmcb->control.event_inj = vcpu->arch.interrupt.nr |
+						SVM_EVTINJ_VALID | type;
+
+	++vcpu->stat.irq_injections;
 }
 
 void svm_complete_interrupt_delivery(struct kvm_vcpu *vcpu, int delivery_mode,
@@ -3810,6 +3818,9 @@ bool svm_interrupt_blocked(struct kvm_vcpu *vcpu)
 	if (!gif_set(svm))
 		return true;
 
+	if (sev_snp_is_rinj_active(vcpu))
+		return sev_snp_blocked(INJECT_IRQ, vcpu);
+
 	if (is_guest_mode(vcpu)) {
 		/* As long as interrupts are being delivered...  */
 		if ((svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK)
@@ -4128,6 +4139,8 @@ static void svm_cancel_injection(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb_control_area *control = &svm->vmcb->control;
 
+	sev_snp_cancel_injection(vcpu);
+
 	control->exit_int_info = control->event_inj;
 	control->exit_int_info_err = control->event_inj_err;
 	control->event_inj = 0;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index f0f14801e122..95c0a7070bd1 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -41,6 +41,10 @@ extern bool x2avic_enabled;
 extern bool vnmi;
 extern int lbrv;
 
+enum inject_type {
+	INJECT_IRQ,
+};
+
 /*
  * Clean bits in VMCB.
  * VMCB_ALL_CLEAN_MASK might also need to
@@ -751,6 +755,17 @@ void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
 int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
 int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
+bool sev_snp_queue_exception(struct kvm_vcpu *vcpu);
+bool sev_snp_inject(enum inject_type type, struct kvm_vcpu *vcpu);
+void sev_snp_cancel_injection(struct kvm_vcpu *vcpu);
+bool sev_snp_blocked(enum inject_type type, struct kvm_vcpu *vcpu);
+static inline bool sev_snp_is_rinj_active(struct kvm_vcpu *vcpu)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
+
+	return sev_snp_guest(vcpu->kvm) &&
+		(sev->vmsa_features & SVM_SEV_FEAT_RESTRICTED_INJECTION);
+};
 #else
 static inline struct page *snp_safe_alloc_page_node(int node, gfp_t gfp)
 {
@@ -781,7 +796,11 @@ static inline int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
 {
 	return 0;
 }
-
+static inline bool sev_snp_queue_exception(struct kvm_vcpu *vcpu) { return false; }
+static inline bool sev_snp_inject(enum inject_type type, struct kvm_vcpu *vcpu) { return false; }
+static inline void sev_snp_cancel_injection(struct kvm_vcpu *vcpu) {}
+static inline bool sev_snp_blocked(enum inject_type type, struct kvm_vcpu *vcpu) { return false; }
+static inline bool sev_snp_is_rinj_active(struct kvm_vcpu *vcpu) { return false; }
 #endif
 
 /* vmenter.S */
-- 
2.34.1


