Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 435A92CF644
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 22:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgLDVcI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 16:32:08 -0500
Received: from mail-co1nam11on2083.outbound.protection.outlook.com ([40.107.220.83]:25824
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726534AbgLDVcH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 16:32:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=maLWT1Nl1pip5XFcsJ6bHjYYfiF4vOoo96aW6ptPLWOeOGR0uSOYSIrdgJ0wPMA8y7Uz2uo9H8yR9u5K0hFPoYr1AQ2+FrYBrAI1O0piWr7AEGsYbTj7z3Y6D06YSYd3OlhqfcfFAF16A1UBL2LXALttU6WNu6mS+23qJbdPR8Ez8Na3QbpgAvCwihwWQGFRYmkTB+R215mVWAas4gQs1gwiVNlYX341F+L4E2G9D/pownpPp/JVhNHyojw3UYB7ZsappjBh+ob8OSl2jCqGOgGf00ELUOD34su3WFYVixE2tONupTBfCUEtmwD0PyzVxdEexvbtv/mnz0VqydX2Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cIFI4ju2A2xkxveYfptsHT7nH2HM2YPpf9lFfk5qebQ=;
 b=jA684B2tr5CCdV5lcSa2Cp5xxi1e89oQ4mQZn+x+yPb3bmfsAqZ1YRba7QriBoZDeXgicMO4BT5QxssPCYibe17j8h8DK5+Q39wXTYE4VemoFcRRcpLnCXsHBknrQr/eFPjnS+Nirumj66mn8JQs/kXI3SWEyCWnOAjHsrYFh5w9guzdANMEO9nQDLIICAVEO4eeZTmLguW5D9AK/O0XZWBEpB51Eb9ag+PwWqvXgFOmoGPFUTIs5qHnzpUq3rXlKblqCP1ayj8v0wHttfxI9Nc21ZmrbtR+NZtOxHouSbbJV0ZhNuZahJbKpZeRf7vgSqO80q5KbX/iPbIL3q0t/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cIFI4ju2A2xkxveYfptsHT7nH2HM2YPpf9lFfk5qebQ=;
 b=S/rJmTAUqxwN45fLR8OIATYDn/BCGM7VlTlUVvoPfkxgmJQj3wPBg/3qtOz5mFjKqLNfpfhUIoVEpgDsAUCeCuu7LZBe+xD34pttDRNEmvpVtWis2JxGUSHK1fhHDLlzjBW7TB+kdeKmSubqlyC121phAMZcE4GtJO02tGax+rg=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4431.namprd12.prod.outlook.com (2603:10b6:806:95::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Fri, 4 Dec
 2020 21:31:14 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::18a2:699:70b3:2b8a]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::18a2:699:70b3:2b8a%6]) with mapi id 15.20.3632.021; Fri, 4 Dec 2020
 21:31:14 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     qemu-devel@nongnu.org
Cc:     Brijesh Singh <brijesh.singh@amd.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        Eric Blake <eblake@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH] target/i386/sev: add the support to query the attestation report
Date:   Fri,  4 Dec 2020 15:31:01 -0600
Message-Id: <20201204213101.14552-1-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN6PR2101CA0022.namprd21.prod.outlook.com
 (2603:10b6:805:106::32) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN6PR2101CA0022.namprd21.prod.outlook.com (2603:10b6:805:106::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.2 via Frontend Transport; Fri, 4 Dec 2020 21:31:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 900d0ca3-73e0-4fa4-2a02-08d8989bed7b
X-MS-TrafficTypeDiagnostic: SA0PR12MB4431:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB44316D5BC2C7DBC26BE87DDCE5F10@SA0PR12MB4431.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1051;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZEYzC0z5YTXs+gMM3lHulWrHOZMcrX2O4hZop15YmlC6BeXMyiDqdUBj5F+XiVjCMWOprkaSS7OXejA7LGDK2235O4ZSbkFqWAxzgng0MS+1rw74oeJBedsjc3wgo3BCf6XAHEOZFIA/eUINREHbPylOt4v5cVA30T0EGch+ucxU8QBedz1kO398UsNGZw+cshnjgwl6TV+BIyvnAIe6o6li1LOkyTxCJtFu9Nj2dg3WbCfpd3ZiMvi6oSU/A8kLDdux5wPmMfyos2CebYbmOB1hC6L0AdrXpcWDKZcDfMm60weLRMBOpHdBwe7pk25I
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(376002)(136003)(39860400002)(346002)(66946007)(52116002)(6666004)(8676002)(86362001)(66556008)(5660300002)(316002)(186003)(83380400001)(44832011)(6916009)(66476007)(8936002)(2616005)(7696005)(2906002)(54906003)(36756003)(16526019)(1076003)(4326008)(6486002)(478600001)(956004)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?uS5/pglLyEPF25NM8MWpHYx9bpCt9FZ3lgIiz7ibpZOfILowqlInZNM48q7g?=
 =?us-ascii?Q?znw0agHuuB6WMktl3dBKH9zSJIhKcKQQnwgLSWFXPD3DnhhRFKm0Q/HXWhOF?=
 =?us-ascii?Q?RKhmiEVW7XopN8hOH919HkuLAKmQFB+QjB25cdjfL4ryk/6MRPrGeUTEEhtZ?=
 =?us-ascii?Q?CYLUxUuU0MFfU6CujKwTGLXN0PvD9NG8tCyabRvpdrZWfF7MUtX+wHmr2CxF?=
 =?us-ascii?Q?iIEN6u1mjDEwPM+uqZcIEG9XRu1gGBgvBLn6zBm9xb0ttqdPbgga7LwhRp7P?=
 =?us-ascii?Q?RiQy+3Y9Z8FGskCsvvVRH2hb7ChEne9ktJMLhOKKc8yqRwKRwxmnIPYHFzYc?=
 =?us-ascii?Q?Hi1QqfZWPT7oIlav/lamQfv6aq4lom/9OBAE4z1/BDOYokDHgo1Quxcioede?=
 =?us-ascii?Q?65+PrwYJEyrl8vRKIfwoelYfJeumCOCIUxtqs6HHMwgopi/GgN99bpbRW9NO?=
 =?us-ascii?Q?xs9v0DCHvmEh9wiQu+TK6rwuX1DjjqYxq5UP6a0jBp3sgLLsMKKx5/DbDaP/?=
 =?us-ascii?Q?UVL7PKtL/suwM1gzD14B2lgAoN34VA66EbbQimDeH1kVoBXock6KmmILeZ6x?=
 =?us-ascii?Q?I80xj4F5Th8Mn7RNcfvPFuSgM7Bl7wUutMsJjOmCR3J4ZUqVvUDRk/fk4Pu/?=
 =?us-ascii?Q?OjtDEcA7Wm7n+q6N092oWk9JmEt1XjzRP6CjmNZC46vhxEUfnCy/ASEdbgj1?=
 =?us-ascii?Q?00XtrwnqthbjM/wZPSt6Ka8V3z9uJcrSl2QK41mp/mxrvbWZC08aHMAGUoA6?=
 =?us-ascii?Q?N2jXhWG0HcXeLs3MNGiJafYwk7O+4B2gmDHQXnApdZ29tB0C20bTVDLPrdxj?=
 =?us-ascii?Q?WIFRkoHRDyJxC9gTNcc9uSdLN2EBQELUln3ClwMs8AhdrWUlxijwJxOv4Y47?=
 =?us-ascii?Q?kM57dayhXj7+284k5YucmyzmrQ3+nQant5Su6rCR93ALRhIrNwFhhGhjrKth?=
 =?us-ascii?Q?BxyUcnhnu1EzRz9VztqFkSZzVOSyjq17DB2bIIwkvcJoem68mKzQr5uqaY/H?=
 =?us-ascii?Q?1Ick?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 900d0ca3-73e0-4fa4-2a02-08d8989bed7b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2020 21:31:14.5809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VJDfbrXXlRJTz2uKSjc+E01eNpODfJ2+fqloJaMOApecGJGn64wlyM/iNHarrDneRpZIpq3RhulDVngXIEcJ6g==
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
 linux-headers/linux/kvm.h |  8 ++++++
 qapi/misc-target.json     | 38 +++++++++++++++++++++++++++
 target/i386/monitor.c     |  6 +++++
 target/i386/sev-stub.c    |  7 +++++
 target/i386/sev.c         | 54 +++++++++++++++++++++++++++++++++++++++
 target/i386/sev_i386.h    |  2 ++
 6 files changed, 115 insertions(+)

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
index 1e561fa97b..ec6565e6ef 100644
--- a/qapi/misc-target.json
+++ b/qapi/misc-target.json
@@ -267,3 +267,41 @@
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
+# @mnonce: a random 16 bytes of data (it will be included in report)
+#
+# Returns: SevAttestationReport objects.
+#
+# Since: 5.2
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
index 9f9e1c42f4..a4b65f330c 100644
--- a/target/i386/monitor.c
+++ b/target/i386/monitor.c
@@ -729,3 +729,9 @@ SevCapability *qmp_query_sev_capabilities(Error **errp)
 {
     return sev_get_capabilities(errp);
 }
+
+SevAttestationReport *
+qmp_query_sev_attestation_report(const char *mnonce, Error **errp)
+{
+    return sev_get_attestation_report(mnonce, errp);
+}
diff --git a/target/i386/sev-stub.c b/target/i386/sev-stub.c
index 88e3f39a1e..66d16f53d8 100644
--- a/target/i386/sev-stub.c
+++ b/target/i386/sev-stub.c
@@ -49,3 +49,10 @@ SevCapability *sev_get_capabilities(Error **errp)
     error_setg(errp, "SEV is not available in this QEMU");
     return NULL;
 }
+
+SevAttestationReport *
+sev_get_attestation_report(const char *mnonce, Error **errp)
+{
+    error_setg(errp, "SEV is not available in this QEMU");
+    return NULL;
+}
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 93c4d60b82..28958fb71b 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -68,6 +68,7 @@ struct SevGuestState {
 
 #define DEFAULT_GUEST_POLICY    0x1 /* disable debug */
 #define DEFAULT_SEV_DEVICE      "/dev/sev"
+#define DEFAULT_ATTESATION_REPORT_BUF_SIZE      4096
 
 static SevGuestState *sev_guest;
 static Error *sev_mig_blocker;
@@ -490,6 +491,59 @@ out:
     return cap;
 }
 
+SevAttestationReport *
+sev_get_attestation_report(const char *mnonce, Error **errp)
+{
+    struct kvm_sev_attestation_report input = {};
+    SevGuestState *sev = sev_guest;
+    SevAttestationReport *report;
+    guchar *data;
+    int err = 0, ret;
+
+    if (!sev_enabled()) {
+        error_setg(errp, "SEV is not enabled");
+        return NULL;
+    }
+
+    /* Verify that user provided random data length */
+    if (strlen(mnonce) != sizeof(input.mnonce)) {
+        error_setg(errp, "Expected mnonce data len %ld got %ld",
+                sizeof(input.mnonce), strlen(mnonce));
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
+    memcpy(input.mnonce, mnonce, sizeof(input.mnonce));
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
+e_free_data:
+    g_free(data);
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
-- 
2.17.1

