Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4832D2EB05D
	for <lists+kvm@lfdr.de>; Tue,  5 Jan 2021 17:42:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729897AbhAEQlH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 11:41:07 -0500
Received: from mail-dm6nam10on2069.outbound.protection.outlook.com ([40.107.93.69]:34305
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729878AbhAEQlH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jan 2021 11:41:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jyyKzOFdP9cS01Or/CNvAJp/iE9I97KNj2+cRhqnfiHbw46ZrBYEj4oYOWn8gnNFOozm8r2mHN/fGNsEczm4M1ZE9rX4IDlNBqLd9oFfd9tzBJWonx1fbMjZNLG2IhN5Kd6cJtx/jZaUXXD1BQ62CgD7GEfJ3PKSxUu6VZgH5Yox23ksSTAdhacRx191UaiqVGcU4GYbj4LCkWVXK/Bfnur+0xuwBQre0ie6lIqvm0MoGtRWKw7waUOu4vo064jyAdjjccF0nnOUcRidZ+yeDaJrUH+400UubgGJLdTyOtB5tUgeugYUgCHYny/XhettBv5HAJ6q3kUIv0LuQNESdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p/Nq6ERcvzdMzZjHNW8sKgBleQmIGLKc/KsoKWIOhMY=;
 b=FF09nivEQp9s8MPAZDdUbTlvauFYHprxC7vD7NL8IwjC3inS6jOpdJOmqSmIPbhPANVTlhoX8omsRoTfKS22M4woqWV8q8o1mPVXrfYPQhrNxIf+6tYdS3VohyAkv9jfm8Nm4BPKPN3UuPyCiRC1Up1zEWTvKNFouZXxH/Y257fUdLc/L78pg/CMwun/No5lrS7WUvxuf0CFdlHYzKqwLyEcI5GFfl5oTRrPXS3mAdkrrGNy/iWuYv2CSVOeJDdVK6Vucj3rvFA4vlJOHPuT7jsCJRMZ79r5txnctJfmvukHIePFD5zwq+oJ9HnCbXYYqoRTuHrb/MLduVY+zZs41g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p/Nq6ERcvzdMzZjHNW8sKgBleQmIGLKc/KsoKWIOhMY=;
 b=ZL2FU1Vz5vASiCkoYNcEf0Zi7Z8pfJqFrklWRunxtiocdzkrBN0Vannx4dxx4nwfQSga4PrKkUmnHNs7c9+rmkUnUNuhWEceubZxrqGYIsrNfvbFL7ab+zeJqQJ1pmbX5Ttd8UJ585goSVRI8dwhWkfxCLz0T7iblNmle/7yuNY=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4431.namprd12.prod.outlook.com (2603:10b6:806:95::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.20; Tue, 5 Jan
 2021 16:40:13 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::18a2:699:70b3:2b8a]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::18a2:699:70b3:2b8a%6]) with mapi id 15.20.3721.024; Tue, 5 Jan 2021
 16:40:13 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     qemu-devel@nongnu.org
Cc:     Brijesh Singh <brijesh.singh@amd.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        Eric Blake <eblake@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v2] target/i386/sev: add support to query the attestation report
Date:   Tue,  5 Jan 2021 10:39:42 -0600
Message-Id: <20210105163943.30510-1-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0201CA0049.namprd02.prod.outlook.com
 (2603:10b6:803:20::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0201CA0049.namprd02.prod.outlook.com (2603:10b6:803:20::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Tue, 5 Jan 2021 16:40:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 142e6d6e-c3cc-4ea8-384d-08d8b198930d
X-MS-TrafficTypeDiagnostic: SA0PR12MB4431:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB44319E3BDF6878AFD21BCDE2E5D10@SA0PR12MB4431.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1265;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OYdiYNyoizsQe1EbeOct7ZsJettbtXu+kGhYBo4UEoCRKHDYgVhsbSkJcpTiUr+Bw0ok+ZdB4VdLG+QpWmkZ2QSjVV0jGqtP16Bc141n6prpFbc5bukXw9gHh8ZuEm9GXMJVxQc0uQo0z6lgQGrCerBFJgbc0P63L71oNO+Aw+EoJdtJ/zkrD/LTFZ9B9bERHsHOzYMLDyjuF6/lJR1qAsKt02BafEMS1EKr+qLEhTBRAi4AaqzZaAoeg6xnan4tFVRUBKzMplmJEG9sVCAvfRUD6rI3qsKIl2rDUWY4NURCSohl453TjQ/k1t96kLQ0Gb1HSgWJPmPf/r+Rl0Zsjoi+w29jNPcPULfPH51cEp2HYnXkTPQRx8g12sRB1NVVD9hKB4FR9C6m2YzgJIzX4w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(366004)(376002)(39850400004)(6666004)(316002)(66476007)(86362001)(2616005)(16526019)(26005)(6486002)(4326008)(8676002)(8936002)(2906002)(54906003)(83380400001)(36756003)(6916009)(52116002)(186003)(66556008)(7696005)(66946007)(5660300002)(478600001)(956004)(1076003)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?8pxezmSwdLCH7/BmG7CCI5QNAjjI4hwqjWm0jsvL3cKvdrcqpraynw12B963?=
 =?us-ascii?Q?fIVnTN3jDsMWLPmbmrWaLICeB//D3vLPNwWE0jMROBl9s7r5QO8tVSPVYQUi?=
 =?us-ascii?Q?GUfRPHiLfqw6e1COtyCEYF86I9BKeBovefC6JciLFgWdU8RV+FbkB+fGGZbx?=
 =?us-ascii?Q?0rIGYFOrn6LLKIfyQAqtsj1D61AIRgrE1zdbLTNFoXpeukvG+PHHKVjRastY?=
 =?us-ascii?Q?fktGC5ykPAHzv2IynZ3BYsks0U5DURKw5hnLGaRd4mBQWRSSeR66uQoO71uH?=
 =?us-ascii?Q?lPYzamzKRJ6IvgZSDsGkeSJYSXruW2RVuASem10Bqz0z+DrIrcGPZ7L3joq4?=
 =?us-ascii?Q?pjTflhEiLPiLE8ILy4fX9ZaJ+jcZzuSARvnIDxCEnY7xwJdSVmNpXZjanuOl?=
 =?us-ascii?Q?9NhWLRezEl5y+tbvMt1IN5e9EL43Nxhzp1/eAlawLrKtp5vIc/5kkozj+thm?=
 =?us-ascii?Q?Kx3JRcK7jWx6udKuu6766RP8fYAo6ZOJcvcSDKcw7crXgWlnMbK+2fjxI8/Q?=
 =?us-ascii?Q?wpA9ZynKQyWK3y8aSepXDhwOu9IWBjfjbD4KvbqvwtCihc8whM5jl8c+wOKm?=
 =?us-ascii?Q?ECQRYF1HxriHMDn5s5FPuhNtH73zb1bEflLVL+rCc5GG7Hz4J1opa9x2WQHY?=
 =?us-ascii?Q?FJUTk/wUmQt8Vdel3wG1B03RA4tDl6qcT+a9+BjJAPe4fSoznWnmPpsK5G0h?=
 =?us-ascii?Q?XG2ycw+4Co6fM10dzLylb5398FxxVeVUThkEIeEQtMNJkl56ANQut9kbv/PV?=
 =?us-ascii?Q?hpFNXD272RV856JRegIUoxwphIPnfFbWzG0Nk2TjKMwDKqoOjdIJmZKQgDS7?=
 =?us-ascii?Q?zZ5JEmUDd8M+DuP0vpNMMih+w+ozU1j+eKBkyV250JSewrF/DnNkz46ebeQM?=
 =?us-ascii?Q?wz+X4oQBzPX84XVUdHzeCQNorEeaRElbSsL9ERpOZbU/3iamATItMzIOi1Wq?=
 =?us-ascii?Q?y1Ku+5P3XfpXTL8AX1gN7WW/ZktUMJdEEDju+7EV4VfVaCN2q7wzgkwF8Tck?=
 =?us-ascii?Q?BCiw?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2021 16:40:13.2418
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 142e6d6e-c3cc-4ea8-384d-08d8b198930d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yWsRJGt7YjtVzkFDD2XUH3WnO/QVU0p0h3tZ5+mcxSc1Hdet1/LS4PQUzH6IsJKr+oq4WGhW+Pr5mLsX9aZODw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4431
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The SEV FW >= 0.23 added a new command that can be used to query the
attestation report containing the SHA-256 digest of the guest memory
and VMSA encrypted with the LAUNCH_UPDATE and sign it with the PEK.

Note, we already have a command (LAUNCH_MEASURE) that can be used to
query the SHA-256 digest of the guest memory encrypted through the
LAUNCH_UPDATE. The main difference between previous and this command
is that the report is signed with the PEK and unlike the LAUNCH_MEASURE
command the ATTESATION_REPORT command can be called while the guest
is running.

Add a QMP interface "query-sev-attestation-report" that can be used
to get the report encoded in base64.

Cc: James Bottomley <jejb@linux.ibm.com>
Cc: Tom Lendacky <Thomas.Lendacky@amd.com>
Cc: Eric Blake <eblake@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
v2:
  * add trace event.
  * fix the goto to return NULL on failure.
  * make the mnonce as a base64 encoded string

 linux-headers/linux/kvm.h |  8 +++++
 qapi/misc-target.json     | 38 ++++++++++++++++++++++
 target/i386/monitor.c     |  6 ++++
 target/i386/sev-stub.c    |  7 +++++
 target/i386/sev.c         | 66 +++++++++++++++++++++++++++++++++++++++
 target/i386/sev_i386.h    |  2 ++
 target/i386/trace-events  |  1 +
 7 files changed, 128 insertions(+)

diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 56ce14ad20..6d0f8101ba 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -1585,6 +1585,8 @@ enum sev_cmd_id {
 	KVM_SEV_DBG_ENCRYPT,
 	/* Guest certificates commands */
 	KVM_SEV_CERT_EXPORT,
+	/* Attestation report */
+	KVM_SEV_GET_ATTESTATION_REPORT,
 
 	KVM_SEV_NR_MAX,
 };
@@ -1637,6 +1639,12 @@ struct kvm_sev_dbg {
 	__u32 len;
 };
 
+struct kvm_sev_attestation_report {
+	__u8 mnonce[16];
+	__u64 uaddr;
+	__u32 len;
+};
+
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
 #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
diff --git a/qapi/misc-target.json b/qapi/misc-target.json
index 06ef8757f0..5907a2dfaa 100644
--- a/qapi/misc-target.json
+++ b/qapi/misc-target.json
@@ -285,3 +285,41 @@
 ##
 { 'command': 'query-gic-capabilities', 'returns': ['GICCapability'],
   'if': 'defined(TARGET_ARM)' }
+
+
+##
+# @SevAttestationReport:
+#
+# The struct describes attestation report for a Secure Encrypted Virtualization
+# feature.
+#
+# @data:  guest attestation report (base64 encoded)
+#
+#
+# Since: 5.2
+##
+{ 'struct': 'SevAttestationReport',
+  'data': { 'data': 'str'},
+  'if': 'defined(TARGET_I386)' }
+
+##
+# @query-sev-attestation-report:
+#
+# This command is used to get the SEV attestation report, and is supported on AMD
+# X86 platforms only.
+#
+# @mnonce: a random 16 bytes value encoded in base64 (it will be included in report)
+#
+# Returns: SevAttestationReport objects.
+#
+# Since: 5.3
+#
+# Example:
+#
+# -> { "execute" : "query-sev-attestation-report", "arguments": { "mnonce": "aaaaaaa" } }
+# <- { "return" : { "data": "aaaaaaaabbbddddd"} }
+#
+##
+{ 'command': 'query-sev-attestation-report', 'data': { 'mnonce': 'str' },
+  'returns': 'SevAttestationReport',
+  'if': 'defined(TARGET_I386)' }
diff --git a/target/i386/monitor.c b/target/i386/monitor.c
index 1bc91442b1..0c8377f900 100644
--- a/target/i386/monitor.c
+++ b/target/i386/monitor.c
@@ -736,3 +736,9 @@ void qmp_sev_inject_launch_secret(const char *packet_hdr,
 {
     sev_inject_launch_secret(packet_hdr, secret, gpa, errp);
 }
+
+SevAttestationReport *
+qmp_query_sev_attestation_report(const char *mnonce, Error **errp)
+{
+    return sev_get_attestation_report(mnonce, errp);
+}
diff --git a/target/i386/sev-stub.c b/target/i386/sev-stub.c
index c1fecc2101..cdc9a014ee 100644
--- a/target/i386/sev-stub.c
+++ b/target/i386/sev-stub.c
@@ -54,3 +54,10 @@ int sev_inject_launch_secret(const char *hdr, const char *secret,
 {
     return 1;
 }
+
+SevAttestationReport *
+sev_get_attestation_report(const char *mnonce, Error **errp)
+{
+    error_setg(errp, "SEV is not available in this QEMU");
+    return NULL;
+}
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 1546606811..d1f90a1d8a 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -492,6 +492,72 @@ out:
     return cap;
 }
 
+SevAttestationReport *
+sev_get_attestation_report(const char *mnonce, Error **errp)
+{
+    struct kvm_sev_attestation_report input = {};
+    SevAttestationReport *report = NULL;
+    SevGuestState *sev = sev_guest;
+    guchar *data;
+    guchar *buf;
+    gsize len;
+    int err = 0, ret;
+
+    if (!sev_enabled()) {
+        error_setg(errp, "SEV is not enabled");
+        return NULL;
+    }
+
+    /* lets decode the mnonce string */
+    buf = g_base64_decode(mnonce, &len);
+    if (!buf) {
+        error_setg(errp, "SEV: failed to decode mnonce input");
+        return NULL;
+    }
+
+    /* verify the input mnonce length */
+    if (len != sizeof(input.mnonce)) {
+        error_setg(errp, "SEV: mnonce must be %ld bytes (got %ld)",
+                sizeof(input.mnonce), len);
+        g_free(buf);
+        return NULL;
+    }
+
+    /* Query the report length */
+    ret = sev_ioctl(sev->sev_fd, KVM_SEV_GET_ATTESTATION_REPORT,
+            &input, &err);
+    if (ret < 0) {
+        if (err != SEV_RET_INVALID_LEN) {
+            error_setg(errp, "failed to query the attestation report length "
+                    "ret=%d fw_err=%d (%s)", ret, err, fw_error_to_str(err));
+            return NULL;
+        }
+    }
+
+    data = g_malloc(input.len);
+    input.uaddr = (unsigned long)data;
+    memcpy(input.mnonce, buf, sizeof(input.mnonce));
+
+    /* Query the report */
+    ret = sev_ioctl(sev->sev_fd, KVM_SEV_GET_ATTESTATION_REPORT,
+            &input, &err);
+    if (ret) {
+        error_setg_errno(errp, errno, "Failed to get attestation report"
+                " ret=%d fw_err=%d (%s)", ret, err, fw_error_to_str(err));
+        goto e_free_data;
+    }
+
+    report = g_new0(SevAttestationReport, 1);
+    report->data = g_base64_encode(data, input.len);
+
+    trace_kvm_sev_attestation_report(mnonce, report->data);
+
+e_free_data:
+    g_free(data);
+    g_free(buf);
+    return report;
+}
+
 static int
 sev_read_file_base64(const char *filename, guchar **data, gsize *len)
 {
diff --git a/target/i386/sev_i386.h b/target/i386/sev_i386.h
index 4db6960f60..e2d0774708 100644
--- a/target/i386/sev_i386.h
+++ b/target/i386/sev_i386.h
@@ -35,5 +35,7 @@ extern uint32_t sev_get_cbit_position(void);
 extern uint32_t sev_get_reduced_phys_bits(void);
 extern char *sev_get_launch_measurement(void);
 extern SevCapability *sev_get_capabilities(Error **errp);
+extern SevAttestationReport *
+sev_get_attestation_report(const char *mnonce, Error **errp);
 
 #endif
diff --git a/target/i386/trace-events b/target/i386/trace-events
index a22ab24e21..8d6437404d 100644
--- a/target/i386/trace-events
+++ b/target/i386/trace-events
@@ -10,3 +10,4 @@ kvm_sev_launch_update_data(void *addr, uint64_t len) "addr %p len 0x%" PRIx64
 kvm_sev_launch_measurement(const char *value) "data %s"
 kvm_sev_launch_finish(void) ""
 kvm_sev_launch_secret(uint64_t hpa, uint64_t hva, uint64_t secret, int len) "hpa 0x%" PRIx64 " hva 0x%" PRIx64 " data 0x%" PRIx64 " len %d"
+kvm_sev_attestation_report(const char *mnonce, const char *data) "mnonce %s data %s"
-- 
2.17.1

