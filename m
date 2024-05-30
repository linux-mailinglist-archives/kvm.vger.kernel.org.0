Return-Path: <kvm+bounces-18406-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E16A18D4A3C
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 13:18:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 92FA9282420
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 11:18:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08A0917D352;
	Thu, 30 May 2024 11:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fYgcOTZL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2067.outbound.protection.outlook.com [40.107.100.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5F0171658
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 11:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717067821; cv=fail; b=FI1TIIPlJRQIJsSZ9w7ES69cjUROT3P8fUtwyR+ugzlMFlaE4dReFX4ROcuIT82fExcH9R46kxw7Yc6ZGRumcIvV9TGga9CWh794RmqUcGaXkT4QwYK11BFpak3vurrIYGdjY58jIz9ekGVRv3yWSrPKjLkcFAwFrnPa9X1oYTw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717067821; c=relaxed/simple;
	bh=dpq+TwBnW4IIq7FO1pWay2QZ6wn4KygmK/bEtYBg0ig=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qczb16+nEqNDPomQxEgRJ7A4lZ7ZsWAiT+cel2YvC+7mat7z9yJoEyoBK5oM/K8bhgT50uDScc1s6/5hm0iBjgcgMoL51E84ZuEj8GpAEJiPdhCli0HIER0zgIUi8fEGGp9SSc+Hg7svxOFvKLpPqWr+ifa+DBdIYI3o0ceUFkc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fYgcOTZL; arc=fail smtp.client-ip=40.107.100.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KcdMnXzXIjAZesvdFrRMKkS+TZVvuKENtl9fLH/Hib6LW9C9lw2CI30a/9UXF4w8izfds0T/8M1L5JrYr1gbHCN96KRsmdLezJMh0ARvB0PDvfHJ1W+EcaXLrYif8W1M3QW9GqoIAExCsN0Nl1/Emlgh61k713GP5hz+ZwEh//t4kanG2winrO11bZ4pLeLs17FZX7AYWsc/8Z9P5p4KtfQV59X8YlcCt3hYQf6L0eVJ6UVafFjwxyF/kDBXzCuttUkl5Ax3cSwqCELazg653nrYDz43za84Gdym+xPeTVeDM4HwA4VZ6u6oUYKTlfXgJcuEbB0NTtrbf3RmmM6J4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Re6EjQml751ainpbvIc5WAIKEvI0hSYAOcHg7ly2tl8=;
 b=TV22voQjU3GGQnrfTWYN1Sp+ET5yqxNTZ0Jvb7MCFBHqqeJ1O8+G5hvCPCL3GBojCZrBu+S6wW3G3d3VucNqN/eNNkMVD2oKKER+Ul6MHvMIKysxXm/u6T6jJ0cR22dF3EmVWYfn1yr8quJk+ZohZAY1TaoKL7gr6wuALh+GEvkL6hCOVN920ktPr6qRqMd72BFdueh0TnoOJEIxJ024G7i5+02btFPLBXx7nZeoHKlD9z4TROEK4TJh8Q0+WkBgFDVKdc33v9HxiszKhOH5Zp6N5Z9oZDSj14T8hAWQhIIVuwpMRqy5iBdOcnk+2pERGw7vvFHRUIubFLRno2w6Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Re6EjQml751ainpbvIc5WAIKEvI0hSYAOcHg7ly2tl8=;
 b=fYgcOTZLbdK39WKd6VWszUy6ernHVZ7GRnqamxr3qhjbXUTlAT3U0hWC2sCVb2dF+azr1xlG/5QCb5frXjmBGH9X9uejP00OMs+UF/3HQMU8lMUBNBHDwlDORnJhC5HILJr/wYsmcZDBN017iz3n80yNqZe0hTZyGqn049ICVKA=
Received: from BN1PR14CA0006.namprd14.prod.outlook.com (2603:10b6:408:e3::11)
 by LV3PR12MB9402.namprd12.prod.outlook.com (2603:10b6:408:213::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.22; Thu, 30 May
 2024 11:16:55 +0000
Received: from BN2PEPF00004FBC.namprd04.prod.outlook.com
 (2603:10b6:408:e3:cafe::7c) by BN1PR14CA0006.outlook.office365.com
 (2603:10b6:408:e3::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.18 via Frontend
 Transport; Thu, 30 May 2024 11:16:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN2PEPF00004FBC.mail.protection.outlook.com (10.167.243.182) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Thu, 30 May 2024 11:16:55 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 06:16:54 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 06:16:54 -0500
Received: from pankaj-M75q.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Thu, 30 May 2024 06:16:54 -0500
From: Pankaj Gupta <pankaj.gupta@amd.com>
To: <qemu-devel@nongnu.org>
CC: <brijesh.singh@amd.com>, <dovmurik@linux.ibm.com>, <armbru@redhat.com>,
	<michael.roth@amd.com>, <xiaoyao.li@intel.com>, <pbonzini@redhat.com>,
	<thomas.lendacky@amd.com>, <isaku.yamahata@intel.com>, <berrange@redhat.com>,
	<kvm@vger.kernel.org>, <anisinha@redhat.com>, <pankaj.gupta@amd.com>
Subject: [PATCH v4 16/31] i386/sev: Add handling to encrypt/finalize guest launch data
Date: Thu, 30 May 2024 06:16:28 -0500
Message-ID: <20240530111643.1091816-17-pankaj.gupta@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240530111643.1091816-1-pankaj.gupta@amd.com>
References: <20240530111643.1091816-1-pankaj.gupta@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBC:EE_|LV3PR12MB9402:EE_
X-MS-Office365-Filtering-Correlation-Id: 3afb176f-8d72-45c3-7812-08dc809a037a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|376005|36860700004|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FixcmsDcIRFPK1YU93NeCZhG+xmpdxnReZixoZ1Ne9Ba4LTxoPEAdlwki6g0?=
 =?us-ascii?Q?qT9JtYJA91sBntXwCHTB03q2ifCYivC6lJX2+1nH3pVabmabtQdvx7BkOrkC?=
 =?us-ascii?Q?cl95b/ekOCadyNYzZElhMoGx5LvvhXfF7esAoS3fY8Fu9T6vhqp0q0CYwa+t?=
 =?us-ascii?Q?oKPPaljwIisiw2jHYb1pYpqlcndLqxcVYmhqZEt+rucPA6DEZlS6r1skER99?=
 =?us-ascii?Q?4EZB/3rLALK4psD5GX2ynBPS5tW+nVgDk00XSrLvc3DI+v4RbgK7aerLoGdk?=
 =?us-ascii?Q?NVu2c4ECOYtbJAL6qn303NNa2z1rA2RhtDm7wlVTB4RYt/zvTudbJ6oao7Ps?=
 =?us-ascii?Q?1lF5BZTDffC/9QH+UycLQsa6vkFpNt8QuU6HAxUuyiKzh6yMTgrT+RRSVWXK?=
 =?us-ascii?Q?qoahNKWHAAD25ymuLRW1IQdXkkcmi+O8kG77sobhSFhFYZ0zCB4LQsXa9k5D?=
 =?us-ascii?Q?hhlVRtWphJnTMZojZFqrg0YAhK9QjTuzE67Qm9Af86MsKmrgE28bqNpdbDwL?=
 =?us-ascii?Q?QgN7/DjX5NJfh+BLzJUqc5iiY0GGNbJV9aIDmxCG/4+gP2yLZdAGbSTh7iiA?=
 =?us-ascii?Q?uUE+rTNARrv80qfCaZdd5KSa+mgPSqLgnES+Q3KyKNF9G327vuGHLssvGC77?=
 =?us-ascii?Q?39+ETfz+QrQS8F3znm5fUW8r8GcmVUAB15+BCtFDeIHLnjgOvVhxlferEtSA?=
 =?us-ascii?Q?TO0vW6wux0QRppna7tQDNq5UsqYbG2LxiPP/CeFaUeeYKjfkSj0WmfOehbfX?=
 =?us-ascii?Q?C+pT2BKf7KAZHwIk4WwXfJNjF1cIn0yyaLcusBh352acOYGk0y0FaWgEY06p?=
 =?us-ascii?Q?pM4iIcG9+4ka6+5mhH3qmwtTSjEoTZaPWXxENFUzu4JEgLbiYrP8awCnYXkr?=
 =?us-ascii?Q?Dp64u9odS+GZVi37y+8R0uLmsbRwCztTokzAb56XKea87CBeCuTuPv30Grd7?=
 =?us-ascii?Q?Qo27854hFugmneLf4Sd/NRi3RboLcbtOkinzi1wxWbcF/Tx5Rtr9GCAMzFhj?=
 =?us-ascii?Q?EMrAZg0sj3aYD/iK2YVZzuHyeNyz4QgXdUzBhDQifQt9PDHF8iLKfXI63TqJ?=
 =?us-ascii?Q?8+JlZHxpA83C/m+cFIl/fTQ+mupJ7wAYzHVPTdTdO5x/KZXjRhUzQooWhkmT?=
 =?us-ascii?Q?vmrlFxLY/ew4+KKmdvomgKiEjFfyobRkHZM4jBTPVZjcewt2DjRqnQEX+jm/?=
 =?us-ascii?Q?57n+XYDIhW97sVsJrkyG59mycF4uYfIPUFMooBD25rs9og10UgfstyzSToVT?=
 =?us-ascii?Q?/4meSiQO7IzaRmGoOJ1SNgXIrpRNifrVTxewTDq8D/9EljViRXkl5/TrPNXr?=
 =?us-ascii?Q?vbRxGnQnb3clayS7RshkPQMDRMb0C2YCSC1X9phg8n174eQlbWityK666R/0?=
 =?us-ascii?Q?AxBjHz8=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(376005)(36860700004)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 11:16:55.0975
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3afb176f-8d72-45c3-7812-08dc809a037a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBC.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9402

From: Brijesh Singh <brijesh.singh@amd.com>

Process any queued up launch data and encrypt/measure it into the SNP
guest instance prior to initial guest launch.

This also updates the KVM_SEV_SNP_LAUNCH_UPDATE call to handle partial
update responses.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Co-developed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Co-developed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
---
 target/i386/sev.c        | 112 ++++++++++++++++++++++++++++++++++++++-
 target/i386/trace-events |   2 +
 2 files changed, 113 insertions(+), 1 deletion(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index acbb22ff15..cd47c195cd 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -770,6 +770,76 @@ out:
     return ret;
 }
 
+static const char *
+snp_page_type_to_str(int type)
+{
+    switch (type) {
+    case KVM_SEV_SNP_PAGE_TYPE_NORMAL: return "Normal";
+    case KVM_SEV_SNP_PAGE_TYPE_ZERO: return "Zero";
+    case KVM_SEV_SNP_PAGE_TYPE_UNMEASURED: return "Unmeasured";
+    case KVM_SEV_SNP_PAGE_TYPE_SECRETS: return "Secrets";
+    case KVM_SEV_SNP_PAGE_TYPE_CPUID: return "Cpuid";
+    default: return "unknown";
+    }
+}
+
+static int
+sev_snp_launch_update(SevSnpGuestState *sev_snp_guest,
+                      SevLaunchUpdateData *data)
+{
+    int ret, fw_error;
+    struct kvm_sev_snp_launch_update update = {0};
+
+    if (!data->hva || !data->len) {
+        error_report("SNP_LAUNCH_UPDATE called with invalid address"
+                     "/ length: %p / %lx",
+                     data->hva, data->len);
+        return 1;
+    }
+
+    update.uaddr = (__u64)(unsigned long)data->hva;
+    update.gfn_start = data->gpa >> TARGET_PAGE_BITS;
+    update.len = data->len;
+    update.type = data->type;
+
+    /*
+     * KVM_SEV_SNP_LAUNCH_UPDATE requires that GPA ranges have the private
+     * memory attribute set in advance.
+     */
+    ret = kvm_set_memory_attributes_private(data->gpa, data->len);
+    if (ret) {
+        error_report("SEV-SNP: failed to configure initial"
+                     "private guest memory");
+        goto out;
+    }
+
+    while (update.len || ret == -EAGAIN) {
+        trace_kvm_sev_snp_launch_update(update.uaddr, update.gfn_start <<
+                                        TARGET_PAGE_BITS, update.len,
+                                        snp_page_type_to_str(update.type));
+
+        ret = sev_ioctl(SEV_COMMON(sev_snp_guest)->sev_fd,
+                        KVM_SEV_SNP_LAUNCH_UPDATE,
+                        &update, &fw_error);
+        if (ret && ret != -EAGAIN) {
+            error_report("SNP_LAUNCH_UPDATE ret=%d fw_error=%d '%s'",
+                         ret, fw_error, fw_error_to_str(fw_error));
+            break;
+        }
+    }
+
+out:
+    if (!ret && update.gfn_start << TARGET_PAGE_BITS != data->gpa + data->len) {
+        error_report("SEV-SNP: expected update of GPA range %lx-%lx,"
+                     "got GPA range %lx-%llx",
+                     data->gpa, data->gpa + data->len, data->gpa,
+                     update.gfn_start << TARGET_PAGE_BITS);
+        ret = -EIO;
+    }
+
+    return ret;
+}
+
 static int
 sev_launch_update_data(SevGuestState *sev_guest, uint8_t *addr, uint64_t len)
 {
@@ -915,6 +985,46 @@ sev_launch_finish(SevCommonState *sev_common)
     migrate_add_blocker(&sev_mig_blocker, &error_fatal);
 }
 
+static void
+sev_snp_launch_finish(SevCommonState *sev_common)
+{
+    int ret, error;
+    Error *local_err = NULL;
+    SevLaunchUpdateData *data;
+    SevSnpGuestState *sev_snp = SEV_SNP_GUEST(sev_common);
+    struct kvm_sev_snp_launch_finish *finish = &sev_snp->kvm_finish_conf;
+
+    QTAILQ_FOREACH(data, &launch_update, next) {
+        ret = sev_snp_launch_update(sev_snp, data);
+        if (ret) {
+            exit(1);
+        }
+    }
+
+    trace_kvm_sev_snp_launch_finish(sev_snp->id_block, sev_snp->id_auth,
+                                    sev_snp->host_data);
+    ret = sev_ioctl(sev_common->sev_fd, KVM_SEV_SNP_LAUNCH_FINISH,
+                    finish, &error);
+    if (ret) {
+        error_report("SNP_LAUNCH_FINISH ret=%d fw_error=%d '%s'",
+                     ret, error, fw_error_to_str(error));
+        exit(1);
+    }
+
+    sev_set_guest_state(sev_common, SEV_STATE_RUNNING);
+
+    /* add migration blocker */
+    error_setg(&sev_mig_blocker,
+               "SEV-SNP: Migration is not implemented");
+    ret = migrate_add_blocker(&sev_mig_blocker, &local_err);
+    if (local_err) {
+        error_report_err(local_err);
+        error_free(sev_mig_blocker);
+        exit(1);
+    }
+}
+
+
 static void
 sev_vm_state_change(void *opaque, bool running, RunState state)
 {
@@ -1849,10 +1959,10 @@ sev_snp_guest_class_init(ObjectClass *oc, void *data)
     X86ConfidentialGuestClass *x86_klass = X86_CONFIDENTIAL_GUEST_CLASS(oc);
 
     klass->launch_start = sev_snp_launch_start;
+    klass->launch_finish = sev_snp_launch_finish;
     klass->kvm_init = sev_snp_kvm_init;
     x86_klass->kvm_type = sev_snp_kvm_type;
 
-
     object_class_property_add(oc, "policy", "uint64",
                               sev_snp_guest_get_policy,
                               sev_snp_guest_set_policy, NULL, NULL);
diff --git a/target/i386/trace-events b/target/i386/trace-events
index cb26d8a925..06b44ead2e 100644
--- a/target/i386/trace-events
+++ b/target/i386/trace-events
@@ -12,3 +12,5 @@ kvm_sev_launch_finish(void) ""
 kvm_sev_launch_secret(uint64_t hpa, uint64_t hva, uint64_t secret, int len) "hpa 0x%" PRIx64 " hva 0x%" PRIx64 " data 0x%" PRIx64 " len %d"
 kvm_sev_attestation_report(const char *mnonce, const char *data) "mnonce %s data %s"
 kvm_sev_snp_launch_start(uint64_t policy, char *gosvw) "policy 0x%" PRIx64 " gosvw %s"
+kvm_sev_snp_launch_update(uint64_t src, uint64_t gpa, uint64_t len, const char *type) "src 0x%" PRIx64 " gpa 0x%" PRIx64 " len 0x%" PRIx64 " (%s page)"
+kvm_sev_snp_launch_finish(char *id_block, char *id_auth, char *host_data) "id_block %s id_auth %s host_data %s"
-- 
2.34.1


