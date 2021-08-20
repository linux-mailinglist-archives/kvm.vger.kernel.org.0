Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40F053F3084
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 18:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238105AbhHTQBL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 12:01:11 -0400
Received: from mail-co1nam11on2064.outbound.protection.outlook.com ([40.107.220.64]:53792
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233792AbhHTQAv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 12:00:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gMubDJesj0tg7c0QigaYpNrT6Y13jyXcnz4TMcLqW5ROsJ+4JUo2KvTel3kH3VUH38/XTNAe5jsFh2DEsjzuxVanrp+RAXB54BnOCn+J3SkkuHF2raAMad2qBdve0Tb2q8jp3ItFfGUEpocN33gDHPYJwD9z/72LlIB1zi/5KGBt+UMQ4lN38AiwJkJrjt6+8eklr9Y8k1jgHFlLEkfpCvWKuFpCkxRH0fJ+i+C3u6wyg1057HMBL0rmlHVMX4KO/Odbto+Frkm2moV3UDDh0vLtFXhrnyjfSol92t7tgngvzxltyr8pC/WzAdqhNTflF5aCJsFRdHdLmsHXcaQdoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=78KF/t3jq7p1Lwx88XKLitLKd3zgpV3gMZXCE/Db9D8=;
 b=RocWkUDe5EPJ28H1Ic5MmpFMfL+PEa7PNkakyfKU2usc3TSPIx7Fj0QJv7djFLT0xnsu8N1qCAblsn8QNFPPuQRNrBsg4tDFeopDEUSn5Pee2uo7p4Alf1Jrrq4dp1DHaHjTxyDfzqZpEVfUvavjiSc1y9W/uP5Fo0dElKcEFlqH/Viq1+/jqBwXwjPZKJby4avfqgXVkNBRnPgcs1z/xriurLbJG/2FpbXdxEfDWRYiEfrsAYOIfG3QMDn7NTMrKnCPXugRily+G0ztII9hKoPwNUiSvyQiGwErp6630AtrEonwQhS28QLrXvMqUfFDrsZUeORhfTYjg+L1NusZgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=78KF/t3jq7p1Lwx88XKLitLKd3zgpV3gMZXCE/Db9D8=;
 b=1CLUx507q75/6TuOjWMuoYQXinPalAJ5RO/dj+HlC09nZcwNmGbTFf8rlC5mWyTHIrfSgthQd7U72LSTQMxEItME5k6hgKGt+1tSf4+S8j5dCpJ/NhaLAsICQM1PlLIddpRrf625h0qhfu6xqeslFYrofB0s7nh9V5OHF0ukdo8=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2685.namprd12.prod.outlook.com (2603:10b6:805:67::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.21; Fri, 20 Aug
 2021 16:00:10 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 16:00:10 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 v5 13/45] crypto:ccp: Provide APIs to issue SEV-SNP commands
Date:   Fri, 20 Aug 2021 10:58:46 -0500
Message-Id: <20210820155918.7518-14-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210820155918.7518-1-brijesh.singh@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 16:00:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 05338dcc-03f2-4d8b-ea33-08d963f39680
X-MS-TrafficTypeDiagnostic: SN6PR12MB2685:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2685AF8269F7696B74AC2B20E5C19@SN6PR12MB2685.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dGvk5O5fGQQuvwa7BgqBe613cCbZzaVphVjtA+xAwMrzveQOpAfi34RtajRwTKv0eKYP6bgdPgbgQTmuCIiTzqhuLunDMPc9YiQ467GjPMqtz3vBISFJEHKH9SLZtodselcowZ0dZTPuT4f80pOre0W4nJVybcF0/odlxXaWCogQoWfBVkTAuXLEp9TMEWG2aOc2SVRV6XdG94HSYWSa3NVbvoJUyHCgVYsubZym5pzf6zHKAzsd99xQxjdtMvtXBD4Rf4plETpXqMXwpG+YJbnVrQKklIhpUYm4FV6LFK5/1RqlojdHNQlebjt/fmF+y7FXl7MhTdwJuEccXdpxOvFcJ+uar2ElT80wuD2m4hb0G7IhNrAzBO8yn8TOiKu5j4XiDMGJdr11pgujKSPHztpiczu3z/HrV5MfcmR4/ZtfpvaURtb/2Cp8f0yVJGcqnwMws1y34JRe2X/PSP4rGZ3NZFKp9+SPn3bvzmtPQBpci9XWZ+6gNfv5b6ngVEdD6dXE4TiWOSKjCKP5MTpmIyNlMJ+jA0cN/uz5U5deTyTPGYYyEP7pBkkAKHnBdzhi2EwKJsBsz49Y8oPPD6ze8z3LnuZpIoRRjhL8taQ20aa9hNx9qUp9QauSX82MZUS1G3gZKUanffOMMleGQyMRZ52b80+bAD0OmEu5667jXILicTPQsff1gI2E7UZm9+7+MyxiEhp5qzyYF6JqmVNccT3OGNVv3GP3vPfjG1kStGE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(376002)(346002)(366004)(956004)(186003)(44832011)(2616005)(26005)(66946007)(52116002)(66556008)(66476007)(7696005)(7406005)(6666004)(7416002)(1076003)(2906002)(478600001)(36756003)(316002)(54906003)(8676002)(8936002)(5660300002)(6486002)(38350700002)(4326008)(38100700002)(86362001)(134885004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mIj0wdvCwGElx/gilnxjwCAdADU+z1L9Fbps+FP8DD18apVFcJLq/viPs7o9?=
 =?us-ascii?Q?SSl7qTxPu5eMGDy8iqWcDt8fUWy3Ngozz3mfkAmLMEXbmkkOXzTp6bSjz2KG?=
 =?us-ascii?Q?ZtKo5S3oljN//4Be00mhYZDtS0+rCAgjiVit7+/D0RRtdtNj3InrHwIubaSp?=
 =?us-ascii?Q?9sFaeMjzca1GXxVRSnXcAzH6zD9cKuGHgJtJEHP+YrwmJbQf8pwem4WIFYRV?=
 =?us-ascii?Q?tVsK4DVF3BWXDaujmHQsDIXIZNYKgoGKzLHIZ3xy2J4UWxezQ1+l+Uwon7Fo?=
 =?us-ascii?Q?ZVdGoP0bWwAcl0OOGsPVEO3+kro1vxQAH5eVmz0q8gQjNA6D50IqBESYOBJJ?=
 =?us-ascii?Q?WuHag0gIDbMpPtjmOVR8GSyKrzc947j91QgQSAz0S7TjWef0znNj8a+dQub4?=
 =?us-ascii?Q?RGms55slk8R4GnGpeLP3mE3jBq1KeAYMN7xdUSnlN5RSxuxqlevfrQMkf4Iw?=
 =?us-ascii?Q?PYppVbdzUXsE7P+eJcHSwbdWcpQQ7I09nhrR/jQqoZ3xbU7F0PW7kBy8nu/r?=
 =?us-ascii?Q?OCJ/Lpj3eSdFR5MsVXkaxAUrB74C2R6oU1ZV5uLdW726Y4IcnHDHL6EeTyz4?=
 =?us-ascii?Q?Q+1FDFXcc4ja4PWEBnMkRQfPcGoi+oF63kZHFPEU6nVvx2WkrC+jM2AiWKKb?=
 =?us-ascii?Q?htB+HwWGeQy/A7Ei6tEH+p+43WeNgXXP1Dw2GKC2CM2kiryuXKJgM7RiRFw1?=
 =?us-ascii?Q?PXo+TTQ28GfPfYzWa4WLCnbdzaG2XiUuboK1YL91gTgFhLeIKXIfA5cSPrXo?=
 =?us-ascii?Q?fFcT9Vri1K+by8fi46AYEioHJxV8qZDNymNHNjIXKxRuFU4MyHLQ3wlXBZKG?=
 =?us-ascii?Q?6JnUh1/JgQKUfy2v+JSe7ROgO8+BvYGG2ILjvQZ9j72QwtRL7OJLfyUDk5aF?=
 =?us-ascii?Q?uKw+lsc5/dpEHfJH8v73lzH13GkCIByH5egFPmFaouAxtbHocZ1gBmlm3s3W?=
 =?us-ascii?Q?/wAIAaVppJo2wi4uQRxDQert/+b2EwP0cg8jF+6U0Vn4C6j0Sfv7UUFBC8ce?=
 =?us-ascii?Q?oFrNZJJCMqiTQRkImRFSCLp/AAhSXqMWDRrVNgekbJdlAZNIPSF04dXkS8xi?=
 =?us-ascii?Q?igrBL7xD0rvfQQG4q1PGwXkKDxLk2gu8gjJLdn5rre2Q0XV/N0FsFHu7q6Qp?=
 =?us-ascii?Q?MRCGUH0BqYI7Qn+uXbubXyjDguzmuUubkEumi2kju1EgwXTyCUlA8G4HGSFA?=
 =?us-ascii?Q?pZf/kpDsRXm8T2Klw4B2iv+RZOD99j5UgxRZUiDr2OR2UvT67YJHbWBpYdgN?=
 =?us-ascii?Q?zCI22pOC5Kq3+uNYq71ai90y0jXwFCOQ+FAeO3ylgQUDdb32PimyK0npm1bQ?=
 =?us-ascii?Q?5X+mGWMgjTAb9tGt2m5ghVJD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05338dcc-03f2-4d8b-ea33-08d963f39680
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 16:00:10.5128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UaheF4JB4EeTuHSm24FLGfIgIIVhA0Rkj8bhZ2RgkYhB4rewC7D9jJvA21cLLOjE529EiYJ5V/y0c6gI4LoCiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2685
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Provide the APIs for the hypervisor to manage an SEV-SNP guest. The
commands for SEV-SNP is defined in the SEV-SNP firmware specification.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 24 ++++++++++++
 include/linux/psp-sev.h      | 73 ++++++++++++++++++++++++++++++++++++
 2 files changed, 97 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 1321f6fb07c5..01edad9116f2 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1025,6 +1025,30 @@ int sev_guest_df_flush(int *error)
 }
 EXPORT_SYMBOL_GPL(sev_guest_df_flush);
 
+int snp_guest_decommission(struct sev_data_snp_decommission *data, int *error)
+{
+	return sev_do_cmd(SEV_CMD_SNP_DECOMMISSION, data, error);
+}
+EXPORT_SYMBOL_GPL(snp_guest_decommission);
+
+int snp_guest_df_flush(int *error)
+{
+	return sev_do_cmd(SEV_CMD_SNP_DF_FLUSH, NULL, error);
+}
+EXPORT_SYMBOL_GPL(snp_guest_df_flush);
+
+int snp_guest_page_reclaim(struct sev_data_snp_page_reclaim *data, int *error)
+{
+	return sev_do_cmd(SEV_CMD_SNP_PAGE_RECLAIM, data, error);
+}
+EXPORT_SYMBOL_GPL(snp_guest_page_reclaim);
+
+int snp_guest_dbg_decrypt(struct sev_data_snp_dbg *data, int *error)
+{
+	return sev_do_cmd(SEV_CMD_SNP_DBG_DECRYPT, data, error);
+}
+EXPORT_SYMBOL_GPL(snp_guest_dbg_decrypt);
+
 static void sev_exit(struct kref *ref)
 {
 	misc_deregister(&misc_dev->misc);
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 1b53e8782250..f2105a8755f9 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -860,6 +860,64 @@ int sev_guest_df_flush(int *error);
  */
 int sev_guest_decommission(struct sev_data_decommission *data, int *error);
 
+/**
+ * snp_guest_df_flush - perform SNP DF_FLUSH command
+ *
+ * @sev_ret: sev command return code
+ *
+ * Returns:
+ * 0 if the sev successfully processed the command
+ * -%ENODEV    if the sev device is not available
+ * -%ENOTSUPP  if the sev does not support SEV
+ * -%ETIMEDOUT if the sev command timed out
+ * -%EIO       if the sev returned a non-zero return code
+ */
+int snp_guest_df_flush(int *error);
+
+/**
+ * snp_guest_decommission - perform SNP_DECOMMISSION command
+ *
+ * @decommission: sev_data_decommission structure to be processed
+ * @sev_ret: sev command return code
+ *
+ * Returns:
+ * 0 if the sev successfully processed the command
+ * -%ENODEV    if the sev device is not available
+ * -%ENOTSUPP  if the sev does not support SEV
+ * -%ETIMEDOUT if the sev command timed out
+ * -%EIO       if the sev returned a non-zero return code
+ */
+int snp_guest_decommission(struct sev_data_snp_decommission *data, int *error);
+
+/**
+ * snp_guest_page_reclaim - perform SNP_PAGE_RECLAIM command
+ *
+ * @decommission: sev_snp_page_reclaim structure to be processed
+ * @sev_ret: sev command return code
+ *
+ * Returns:
+ * 0 if the sev successfully processed the command
+ * -%ENODEV    if the sev device is not available
+ * -%ENOTSUPP  if the sev does not support SEV
+ * -%ETIMEDOUT if the sev command timed out
+ * -%EIO       if the sev returned a non-zero return code
+ */
+int snp_guest_page_reclaim(struct sev_data_snp_page_reclaim *data, int *error);
+
+/**
+ * snp_guest_dbg_decrypt - perform SEV SNP_DBG_DECRYPT command
+ *
+ * @sev_ret: sev command return code
+ *
+ * Returns:
+ * 0 if the sev successfully processed the command
+ * -%ENODEV    if the sev device is not available
+ * -%ENOTSUPP  if the sev does not support SEV
+ * -%ETIMEDOUT if the sev command timed out
+ * -%EIO       if the sev returned a non-zero return code
+ */
+int snp_guest_dbg_decrypt(struct sev_data_snp_dbg *data, int *error);
+
 void *psp_copy_user_blob(u64 uaddr, u32 len);
 
 #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
@@ -887,6 +945,21 @@ sev_issue_cmd_external_user(struct file *filep, unsigned int id, void *data, int
 
 static inline void *psp_copy_user_blob(u64 __user uaddr, u32 len) { return ERR_PTR(-EINVAL); }
 
+static inline int
+snp_guest_decommission(struct sev_data_snp_decommission *data, int *error) { return -ENODEV; }
+
+static inline int snp_guest_df_flush(int *error) { return -ENODEV; }
+
+static inline int snp_guest_page_reclaim(struct sev_data_snp_page_reclaim *data, int *error)
+{
+	return -ENODEV;
+}
+
+static inline int snp_guest_dbg_decrypt(struct sev_data_snp_dbg *data, int *error)
+{
+	return -ENODEV;
+}
+
 #endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
 
 #endif	/* __PSP_SEV_H__ */
-- 
2.17.1

