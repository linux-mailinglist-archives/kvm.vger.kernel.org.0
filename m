Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB4736EE9B
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 19:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235685AbhD2RIf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 13:08:35 -0400
Received: from mail-dm6nam12on2051.outbound.protection.outlook.com ([40.107.243.51]:51585
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233302AbhD2RIe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Apr 2021 13:08:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KUa7q21ojmrvWnK+Kd1vzkYrxaJR41dXsqNM6ymRTJyEd9F9uccPn1+A90VOGC3/uNV1gTX92npVhEyhOoryT9Yax3G9xxpu6C17xrjFBIFgnFxSrpf3VX30mBD/RAJjuMBQn65uA+a9JOWlSKjBT6zanXn6Q4wBDErh+ru4pZgmasm42w546xd0E6CI9EygfjVhOYsmPktrE6fW31i1dEaRD5HDJf/xZWk1BuhovVi36rgKmGYvDeJxZ1ERTVI4UQLHqgNdGz+VRwF+9uD9N3rQuuk4j+PhUD8l+EY7WfFgyIbqenFv07RN49JTdbDo3xpogcNKZxhL1D+O0Zqrtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MfP+hXLtn/ZK40u/FpMl1bjkQsH/6S/F1gjNY2ZUes0=;
 b=jtWlU0piZw0xFUB89aBWtVrxCfRoyLdnWr5eDFaGbtJj4ntuUG6vBINBAzjwt9XDQw+zqqrBKFMrLntSFYitYOqhzkPHfbQmlG0uZ8EYyqvFnaOk+nNtqbKO/5cUF/4pCoQoUkSmv/6+86EB6pRUmHfYZhyH9vtX9ZVmg5clv+TeASEf2+mulaDAY4z7ZSUMiByS3GWzc+l8Fnvpk6wtuHS3hzik/s7NNP8GBqHKzsjJDrOefLp4df6WITzzvlPZ0fux7FIYw9oRPCaKS5cM4QB9jtp87Qa9nVrNnu1couHQMjRrS78iiQfbxn+ycECVNbWSkPaxooJUg5AVN6FxwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MfP+hXLtn/ZK40u/FpMl1bjkQsH/6S/F1gjNY2ZUes0=;
 b=qB5QSMa8HAtCiLn4F9UzYdMGs/tJ4axlfbsWygZDzeLDX7TK+3dIH47l07TD1jzO3RbvG53793B8n/w7b/du2lCNNnKkDObLkbUjK+e+QheXlO7CrGG8rZ7YZSmti7gjMS1oOjPlMX+9mEF+FIHPkJzrH3rzVEg5eNPYeFYH9uI=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB4671.namprd12.prod.outlook.com (2603:10b6:805:e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.25; Thu, 29 Apr
 2021 17:07:44 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Thu, 29 Apr 2021
 17:07:44 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     qemu-devel@nongnu.org
Cc:     armbru@redhat.com, dgilbert@redhat.com,
        Brijesh Singh <brijesh.singh@amd.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        Eric Blake <eblake@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v3] target/i386/sev: add support to query the attestation report
Date:   Thu, 29 Apr 2021 12:07:28 -0500
Message-Id: <20210429170728.24322-1-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0201CA0037.namprd02.prod.outlook.com
 (2603:10b6:803:2e::23) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0201CA0037.namprd02.prod.outlook.com (2603:10b6:803:2e::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.25 via Frontend Transport; Thu, 29 Apr 2021 17:07:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9f875787-9f37-42e1-d097-08d90b314e30
X-MS-TrafficTypeDiagnostic: SN6PR12MB4671:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB4671AFBCE2E283AFC18BFA2CE55F9@SN6PR12MB4671.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1265;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L7QRo26GgahcZoERItkFtWjzwBIBcbrugA0MYlWEiEgxPugYPHTHHmAmS6WHmVIAUGogyeAJRFVP3ioqbkPY7huxhVwqbCjcMpnvm0hPhp/l6BZ1k9qSoB+087/vn210LkkTOxFtftDGsjbsew2ayXYyZuh8J5/UQyQge7kIruQYplaF5stYJDIWgq0KtMqxQwxnGD4FYa4zj3Hgkqk1rX1mNu4Tb03wlb0fSVApEPI3PlBOrs+5B6HAZdkSFDUfw+/1+11Qkb0yIb88+owUYYMetEBQ8ybPFveC38vCVIw6bKJrdeTlddXcoM6M7NWOahaU2A1OueCWzpEsj35T/5nedjgLqjyC33uNLFba08fKw/0VsDeREnsnawZSYOHkV6yUbgvGdB9hJPTFxQpaZSJ3x+UABVnNIBD0HyG3OBN+Og4QlP11ZFVOhflHaPKXYDxMrg9/3VtJvQreN6O1jdluCMxtdxtmY484ERT6YRSkX99g7eKwKUMpFYKXOUisqkADRDrW7NpUaSuSAsHXMKHASV0teNlb18sFKonHnh5ISF0qU6c57MYqH1hZgSOE76OlWtC2YNu5rNeTML0chzU9mjYM3SnS7xk7C2RGKSx0qi+FbZtSwLwhuXJEV9ji5GP6/i7/b9FvsscE0d69+SVJT8DYD/65ewcPQ6iIRtk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(366004)(39860400002)(346002)(66946007)(1076003)(26005)(7696005)(186003)(478600001)(38350700002)(6666004)(44832011)(16526019)(5660300002)(6486002)(66476007)(52116002)(2616005)(8676002)(8936002)(38100700002)(54906003)(86362001)(316002)(6916009)(66556008)(36756003)(2906002)(956004)(4326008)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?xRYGD18xvvub3t57nLgPBYNPJzi5DkIm54xeE7iUYRHiB2CeEBG7n8J1NSlu?=
 =?us-ascii?Q?gUvVxoZaqf57Qzubbxn5xkV2pfJxghKS9IqfOJgeZjWbEpyFlbjO3R0lqgID?=
 =?us-ascii?Q?VH7fTd2getdb9Jsm6/dukX9hpFZccOQxOuZtLcM0QnpkzOjBqFGyhaWnD/bi?=
 =?us-ascii?Q?ieIWAcEoroL6zZ6kCSNrcOeSU5GuTAXMlxU6bxVop8pvcK8KYT8z2zj5yhpE?=
 =?us-ascii?Q?2hfUh/uzhKwEGFWN00Hh6Ij1rNFVb6eWrdcoxdsrgrF9DzXDDf7Y0BCYnOPQ?=
 =?us-ascii?Q?YH0IPd2OBXjHCUqXkvXugXC49kNchBpcbU0faXSjUXNaceLP/7c6FXEZK/RN?=
 =?us-ascii?Q?rJAONejSxWbaQtLPbjeQDgYrCtYlO/JimXH5FbGR//MuzfAj0qM3aoQwXvvL?=
 =?us-ascii?Q?P1etU4uypSYCtpNxKIMWCl2YBpZn6mOiuXRL52Hhj5bjQ0tz88dykX978XPS?=
 =?us-ascii?Q?7WnesNi4M3YNcYBK3+zRdueU5OUcU4p2MZuoaxbboyl/uN1kH7bvKbk0poWx?=
 =?us-ascii?Q?fhotL/EjJszRLUEhErCUiYkRyxhxirSAYbV5ttaEggU4MkRCY9yf0k22GRLo?=
 =?us-ascii?Q?JSUu9FZJRbBekYPkUZ9FDqap/Lfp5pcD4BE0OAI1XIBNVa4sWtOnv5Awa1pR?=
 =?us-ascii?Q?NPJh1mq/TY9ilmz5OPqdBJg3yOyAoVWanz+PmYN+wtKIMiWkz7lOVK0yubgi?=
 =?us-ascii?Q?5eoSNLfsogwQL9kIBvJjfPgP1X8txLf3hASLS2j7oiLEakQJ9EjnYBvQq6nY?=
 =?us-ascii?Q?0eAMMtU5QmIAzJIL3zjQFkJT5viCkf/hj9oBp03U3scZP7fid4v16usdfzFp?=
 =?us-ascii?Q?t2KUZpBub68NgPbY6s1RqDj4XV4drKUscVhAU1ZyrC8yVhTqwtyAc6fnUthx?=
 =?us-ascii?Q?Wr5g4nKw/b6hBnjsXOHNFWlt+62zNWbGYl0gyyw0FJLnCEo6q7iDbrSdrfT3?=
 =?us-ascii?Q?x6Xz0xcKWS3s+8j7/IwDddddYJXh84FJwlgCZYVypWG15t8l/AXNUQoYNRJO?=
 =?us-ascii?Q?rINyIaUcIAiFZreVUjB0fgQ7vStHwwFP36anethZjXjsO9FHKw0qChOC1NHJ?=
 =?us-ascii?Q?28biUZeZzw6dK/uudD6oYOcZZI8+GSjoTczzuVu48s3DM0HvTLB5gXpVMcVL?=
 =?us-ascii?Q?tYvtP08fwEjuyxxL9RrOx1uD223MelF/qCrWT7JZYbFMoJ08esyBAMzyADAP?=
 =?us-ascii?Q?hLXSbpXGwK3EUPQdc9Mo+AnLXchAge5zPjkYRRFce0H78tiiK7cfKVF1ceNO?=
 =?us-ascii?Q?6eZhJ63CDGei6FmXy8e7UYj44tQVjSPw5/WvsH4tfxJeWOzSLJpOPRmCVTYA?=
 =?us-ascii?Q?9w9VeBkbsd/vtIATpi6iob9M?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f875787-9f37-42e1-d097-08d90b314e30
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2021 17:07:44.3770
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: prj/lKLvCh+7ZVsL+6kengo6Z9tBreWUHRUCa+SgPHgS/oGivMf0gJAjEmwevIio5N/e/Mg47CaFBcRnpGSIwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4671
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
Reviewed-by: James Bottomley <jejb@linux.ibm.com>
Tested-by: James Bottomley <jejb@linux.ibm.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
v3:
  * free the buffer in error path.

v2:
  * add trace event.
  * fix the goto to return NULL on failure.
  * make the mnonce as a base64 encoded string

 linux-headers/linux/kvm.h |  8 +++++
 qapi/misc-target.json     | 38 ++++++++++++++++++++++
 target/i386/monitor.c     |  6 ++++
 target/i386/sev-stub.c    |  7 ++++
 target/i386/sev.c         | 67 +++++++++++++++++++++++++++++++++++++++
 target/i386/sev_i386.h    |  2 ++
 target/i386/trace-events  |  1 +
 7 files changed, 129 insertions(+)

diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 020b62a619..897f831374 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -1591,6 +1591,8 @@ enum sev_cmd_id {
 	KVM_SEV_DBG_ENCRYPT,
 	/* Guest certificates commands */
 	KVM_SEV_CERT_EXPORT,
+	/* Attestation report */
+	KVM_SEV_GET_ATTESTATION_REPORT,
 
 	KVM_SEV_NR_MAX,
 };
@@ -1643,6 +1645,12 @@ struct kvm_sev_dbg {
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
index 0c7491cd82..4b62f0ac05 100644
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
+# Since: 6.1
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
+# Since: 6.1
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
index 5994408bee..119211f0b0 100644
--- a/target/i386/monitor.c
+++ b/target/i386/monitor.c
@@ -757,3 +757,9 @@ void qmp_sev_inject_launch_secret(const char *packet_hdr,
 
     sev_inject_launch_secret(packet_hdr, secret, gpa, errp);
 }
+
+SevAttestationReport *
+qmp_query_sev_attestation_report(const char *mnonce, Error **errp)
+{
+    return sev_get_attestation_report(mnonce, errp);
+}
diff --git a/target/i386/sev-stub.c b/target/i386/sev-stub.c
index 0207f1c5aa..0227cb5177 100644
--- a/target/i386/sev-stub.c
+++ b/target/i386/sev-stub.c
@@ -74,3 +74,10 @@ int sev_es_save_reset_vector(void *flash_ptr, uint64_t flash_size)
 {
     abort();
 }
+
+SevAttestationReport *
+sev_get_attestation_report(const char *mnonce, Error **errp)
+{
+    error_setg(errp, "SEV is not available in this QEMU");
+    return NULL;
+}
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 72b9e2ab40..4b9d7d3bb9 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -491,6 +491,73 @@ out:
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
+            g_free(buf);
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
index ae221d4c72..ae6d840478 100644
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

