Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89C293F90B6
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 01:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243797AbhHZW2H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 18:28:07 -0400
Received: from mail-dm6nam11hn2207.outbound.protection.outlook.com ([52.100.172.207]:43136
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243796AbhHZW2F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 18:28:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TVq+LiRVbrDnbO6sVkKRm5vnXySfbmbJIQSqzBKLa3bihNWALK7GQpElQWeP9zubGjrQF0Y459vXsshe5FvvL0/LStWByfKfaptIodjnKQBUdM1zIu7WUGie1zWYxYzfLxKsxUY5V8JGSLkibUnMHnGMjF/DPX2KJHdWGSgjTYorpYtjeXLhdki/jHHHcpCUFEad2xLy9jNZdPb6YGm4lCLlYjA54bCOgTYVd7uCmzsOkf7tAioWjCEaqUFGtoJAdT9jQI0qi/X1dBnpaN6sR7IlFrFxJSH8BA9ThI/GRY3bxvgWryaN8xXyGBJD4+7mHPzvP5DdRxjra822ci3NqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FU7FBvCnDgVKQ9DfFebIXTbIUW6gvYS5l+KNu/lKuYM=;
 b=JP4HE+5XUm1hgD55FxYJdlH9pIMjMdq80Eejw50wz6csmQqHBrlCEBvvwkJeQbbb7KuQZuu6box9CJZZiieHEfOvAycCNSXUzWQ58v7kq5thGgvpj/4xs83Kro8YqIaom1Vkj0IsXRxlUAXwwIZFmHQ5oK9CruBRWhq2cy8G9b9AeysLKL+TQGECLSnUiewvKY0LzRceQAgdnvIpJAw+DqDF0Uki7mx9XePN9qGhhpiA+wNM6FEaEl0KnOdelrZk81SbFB0AlMS9d+Tw+3kxTyPunp4c3iRZVdETkjiQo7LIy3qgOM2PpYVDtsC6lLE7mifc3pQ+J4yawYNMNrltqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FU7FBvCnDgVKQ9DfFebIXTbIUW6gvYS5l+KNu/lKuYM=;
 b=DiXT+NFeK25trhOakOsj4ITEJxefKRMni0Hb1cvV5cayVYlwUsrSRRReC2SS23c5klgGUULN3g797kFeyTyxhocFPh/zXhfuPT418G6gsUdTOZUcBngNTcDTufxw8T8d9bN56BvCxYgqvcWB0tHpAlN0p6tAhNIbuC28QvzwUMo=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13)
 by CH2PR12MB3925.namprd12.prod.outlook.com (2603:10b6:610:21::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Thu, 26 Aug
 2021 22:27:16 +0000
Received: from CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::d19e:b657:5259:24d0]) by CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::d19e:b657:5259:24d0%8]) with mapi id 15.20.4436.019; Thu, 26 Aug 2021
 22:27:16 +0000
From:   Michael Roth <michael.roth@amd.com>
To:     qemu-devel@nongnu.org
Cc:     Connor Kuehl <ckuehl@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>
Subject: [RFC PATCH v2 01/12] i386/sev: introduce "sev-common" type to encapsulate common SEV state
Date:   Thu, 26 Aug 2021 17:26:16 -0500
Message-Id: <20210826222627.3556-2-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210826222627.3556-1-michael.roth@amd.com>
References: <20210826222627.3556-1-michael.roth@amd.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0071.namprd11.prod.outlook.com
 (2603:10b6:806:d2::16) To CH2PR12MB4133.namprd12.prod.outlook.com
 (2603:10b6:610:7a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (165.204.77.1) by SA0PR11CA0071.namprd11.prod.outlook.com (2603:10b6:806:d2::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Thu, 26 Aug 2021 22:27:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e26a3c3-8394-4a6f-707e-08d968e0a89f
X-MS-TrafficTypeDiagnostic: CH2PR12MB3925:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR12MB3925C78F4DF57D37DA3CCA5595C79@CH2PR12MB3925.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?rtox3oSF/ZH4EKcIP7sDBXQCB6YwukBwgTxkVtHQrWufzuNv3WxHvE8dYAVx?=
 =?us-ascii?Q?T3yz4ZB+uD/9PnhwqCmehF54tsRR0WtjnFvxH7Y7cI1ykIntrXgf+xnmwLYI?=
 =?us-ascii?Q?x+xDBtMVrRBN9X7ZMU9MsMYtZvv3JrmT0Xjmxr//BIzIKzqySlJ59E0cg0Ip?=
 =?us-ascii?Q?U1plLUc55OrH6ubhKH5zcPt/243M+wO1ZL0toVmY+3A6zHv0jwF0MJ/Xkb+S?=
 =?us-ascii?Q?S5IO1VpmESF7Ad0wnEMX6b/yhVJew+Ip8RXW0gENvguNVmffJOSfs+BD8BuC?=
 =?us-ascii?Q?JD47rXw/QGyRNCM/mLmOJokZg3FDSjDaEa3tUzEyTpE6CPOqcxQ3y2BfC7tw?=
 =?us-ascii?Q?hyaIhT3cYUA0dDOcRrRn4H2O3JqAm62bTLFNaC39hyYH6IAG0tnL4hKHWxzy?=
 =?us-ascii?Q?wY4QVrhB56lYhv43pciN7bD5ytj3lDci1tRNC11T8RmCFJuIOrOYx8/tx49K?=
 =?us-ascii?Q?QIQe9W9463yeMS43CY2NvY8GK7elha5RKpyWck2QeMFBe+88mFxxe2htHEU7?=
 =?us-ascii?Q?/p+P6Wf/2s/Eun/yON1UWyBRD+TwDzeMjN6Y0dHBJRzS1swchVs/FyQECuqi?=
 =?us-ascii?Q?Du+okf5T9ERlOe8PSoZGeN6HHuijN5RBHbjs4buN1GHoIWHs0LKfkVECktmI?=
 =?us-ascii?Q?1QxNOXChMIyJe8XYMYJ3Qlxu67AAqtbF+3ggDvKOIOtrLE3ucRzRY8J8IsJp?=
 =?us-ascii?Q?u/LcSIuOe0eSYaC3WTnnrxAAu5GfUni0FpW+A8Zt/90QSeSxrVSLv6WfvZw7?=
 =?us-ascii?Q?gJn0fGoijaHG5kuHSdHElLm27CafbWl3Y7s3D3nUZUQ6D5i3kBwPbi/ojiZb?=
 =?us-ascii?Q?pYjqBbjsW9Xiod/iSZCTyCeZu0N/vEGVkm4wsL4ZlgpL5wXgqkf1stHr3K6c?=
 =?us-ascii?Q?RBkQpfPPibBzK3GcfkukYSjWrAGTwVsjMTEk7isetxhZwqOv5mlcAn6iLgW6?=
 =?us-ascii?Q?U2KcwoMSwxHaCcsdPIalCH3R1TWlkFfNKv0dFjAswBkMSmfYVxYtvdIV+aqm?=
 =?us-ascii?Q?DIkQBpbB2wA2h7hqhOmQmw/Y34eMr7PxACKUKEr7//HWdI0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:CH2PR12MB4133.namprd12.prod.outlook.com;PTR:;CAT:OSPM;SFS:(4636009)(376002)(396003)(346002)(136003)(39860400002)(366004)(8676002)(38350700002)(66476007)(38100700002)(956004)(2616005)(66556008)(83380400001)(186003)(30864003)(6916009)(478600001)(36756003)(316002)(4326008)(44832011)(54906003)(66946007)(52116002)(6496006)(2906002)(86362001)(1076003)(6486002)(5660300002)(7416002)(8936002)(26005)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KQ4/wtKFpwnDaB01J2viZvKc2FrW1w3Ng2ZhnckMD/lGg/ztGzsI9WC5vqFH?=
 =?us-ascii?Q?er8nIe6A3tUET7mYPcaLrDDoSRYA0XRIrmfn/NCzGM7LGnJf//tdVjQG2ZpE?=
 =?us-ascii?Q?RZLSTluNj6XwbjjVkCTP2qRZmZm9l+gj0tqHiVXeokRy45ViCnaHmA+IC5p9?=
 =?us-ascii?Q?USKLEnOtgJU/SSHcIOYo8f0cSHTQtn0SmTHz3zO3A9tItUlhYp/dLc8bKLqC?=
 =?us-ascii?Q?z/htNvvMHIbYp6iU1p9AfplXX+U/XrUsdkZziViNHRlNa39AMDtkGmZlFKRv?=
 =?us-ascii?Q?1cZvtrd37Ecem3HeDJG3nyUg6ZHAUJdDzlYZVSFg7wciSm7oOlxASKvtBM5D?=
 =?us-ascii?Q?Y0UbFEJnQK4SwMeU9AEzfxNtnJjO2BSHcqH+yzrMV6stn9tLrvJGeY4QsF1X?=
 =?us-ascii?Q?B17V1p4tS6JG2qNXkbcDlafYHLzRlhGICDxAkkbpQ37oQvzeLx2+/ckBQvLz?=
 =?us-ascii?Q?At8XNwQYwO9N9hKOepYNXitfnsb+oKH7XcCjfji09iRkqqViTJmL5LmZLltY?=
 =?us-ascii?Q?5YKqUCrzg1i530iwUIRbzY5Gbsi30xdnAF7HED4IQCGIoFTYL+QvGMiJgSk4?=
 =?us-ascii?Q?du79zm2CFGAH1e7UtXNZs0okKBcM6QCEPvqV0KeumLY5NyUTrCz2N44215mn?=
 =?us-ascii?Q?BRzeskpN8M6ifOAabjR+fs+4tMejMFAUmhUxMaxY0wdcCWwcdrNw6MxWrkD5?=
 =?us-ascii?Q?o668/NFZeeqhKz394Mb4UAzYHtGunsVHRgFUlbnzffB2npN9sOY5LfQyjSS9?=
 =?us-ascii?Q?um0LSq1Y1Qv9sA854FWQVmF1u1lq4LFyoA1shGzaXi9KhcjsRcIcmHRAALFR?=
 =?us-ascii?Q?g5V0Qtw+Uzp8od2iU81CL+muzD1kI8gJgqwBmyvUvGg6Bp6E6Wf+bXyFp5kk?=
 =?us-ascii?Q?nXA6xYCS+KVIlpHFtCBPfHtDns8seBbWt8qIztKFGcDz67ig49fUDsaW9+sK?=
 =?us-ascii?Q?WS0ESfzS8zAUjQLfyoPbMlr8mTt+DYjs3shS4rKFZtXySBDGgnwDLlyemwoU?=
 =?us-ascii?Q?RWLGGyAiXDE8KciesYqArB8GbI504AArkZf5ut8JqaJLElh0MYnllMbaUwGZ?=
 =?us-ascii?Q?IO+VzLctXPoQewY9unyf5ZS6+xOUD3U3++4W8hj8mdpuzotZXMD+Hdra9vsi?=
 =?us-ascii?Q?0kfgd2axqtT7JdaaiNFxe1LWFL955O8n7AMvmcTzrtCfDS4/o6eg7U+hqgoJ?=
 =?us-ascii?Q?Y0vZGfuVOLwxXCIGtFdaS7E4//lG8uoJ1PHHWtgtPASH1GJIBmgNH7/DOU7C?=
 =?us-ascii?Q?aySzoscKDKgRxcMJBpFqwhZAE+vnRlhOMJPhZBEaxgrlPVgpP+4/vxH40MuG?=
 =?us-ascii?Q?NoKnaG+dmdAqaVchDg8bqpbt?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e26a3c3-8394-4a6f-707e-08d968e0a89f
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4133.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2021 22:27:16.2362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BJN564CpAG5XtDxLDQALYx5+B2J4vjJoPvNqW28pNkXY7k4W9vAkxsR5j0cpZfwM1i577D8K0LR5s7NqqSSQzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3925
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently all SEV/SEV-ES functionality is managed through a single
'sev-guest' QOM type. With upcoming support for SEV-SNP, taking this
same approach won't work well since some of the properties/state
managed by 'sev-guest' is not applicable to SEV-SNP, which will instead
rely on a new QOM type with its own set of properties/state.

To prepare for this, this patch moves common state into an abstract
'sev-common' parent type to encapsulate properties/state that is
common to both SEV/SEV-ES and SEV-SNP, leaving only SEV/SEV-ES-specific
properties/state in the current 'sev-guest' type. This should not
affect current behavior or command-line options.

As part of this patch, some related changes are also made:

  - a static 'sev_guest' variable is currently used to keep track of
    the 'sev-guest' instance. SEV-SNP would similarly introduce an
    'sev_snp_guest' static variable. But these instances are now
    available via qdev_get_machine()->cgs, so switch to using that
    instead and drop the static variable.

  - 'sev_guest' is currently used as the name for the static variable
    holding a pointer to the 'sev-guest' instance. Re-purpose the name
    as a local variable referring the 'sev-guest' instance, and use
    that consistently throughout the code so it can be easily
    distinguished from sev-common/sev-snp-guest instances.

  - 'sev' is generally used as the name for local variables holding a
    pointer to the 'sev-guest' instance. In cases where that now points
    to common state, use the name 'sev_common'; in cases where that now
    points to state specific to 'sev-guest' instance, use the name
    'sev_guest'

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 qapi/qom.json     |  34 +++--
 target/i386/sev.c | 329 +++++++++++++++++++++++++++-------------------
 2 files changed, 214 insertions(+), 149 deletions(-)

diff --git a/qapi/qom.json b/qapi/qom.json
index a25616bc7a..211e083727 100644
--- a/qapi/qom.json
+++ b/qapi/qom.json
@@ -735,12 +735,29 @@
   'data': { '*filename': 'str' } }
 
 ##
-# @SevGuestProperties:
+# @SevCommonProperties:
 #
-# Properties for sev-guest objects.
+# Properties common to objects that are derivatives of sev-common.
 #
 # @sev-device: SEV device to use (default: "/dev/sev")
 #
+# @cbitpos: C-bit location in page table entry (default: 0)
+#
+# @reduced-phys-bits: number of bits in physical addresses that become
+#                     unavailable when SEV is enabled
+#
+# Since: 2.12
+##
+{ 'struct': 'SevCommonProperties',
+  'data': { '*sev-device': 'str',
+            '*cbitpos': 'uint32',
+            'reduced-phys-bits': 'uint32' } }
+
+##
+# @SevGuestProperties:
+#
+# Properties for sev-guest objects.
+#
 # @dh-cert-file: guest owners DH certificate (encoded with base64)
 #
 # @session-file: guest owners session parameters (encoded with base64)
@@ -749,21 +766,14 @@
 #
 # @handle: SEV firmware handle (default: 0)
 #
-# @cbitpos: C-bit location in page table entry (default: 0)
-#
-# @reduced-phys-bits: number of bits in physical addresses that become
-#                     unavailable when SEV is enabled
-#
 # Since: 2.12
 ##
 { 'struct': 'SevGuestProperties',
-  'data': { '*sev-device': 'str',
-            '*dh-cert-file': 'str',
+  'base': 'SevCommonProperties',
+  'data': { '*dh-cert-file': 'str',
             '*session-file': 'str',
             '*policy': 'uint32',
-            '*handle': 'uint32',
-            '*cbitpos': 'uint32',
-            'reduced-phys-bits': 'uint32' } }
+            '*handle': 'uint32' } }
 
 ##
 # @ObjectType:
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 83df8c09f6..6acebfbd53 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -34,6 +34,8 @@
 #include "exec/confidential-guest-support.h"
 #include "hw/i386/pc.h"
 
+#define TYPE_SEV_COMMON "sev-common"
+OBJECT_DECLARE_SIMPLE_TYPE(SevCommonState, SEV_COMMON)
 #define TYPE_SEV_GUEST "sev-guest"
 OBJECT_DECLARE_SIMPLE_TYPE(SevGuestState, SEV_GUEST)
 
@@ -48,32 +50,38 @@ OBJECT_DECLARE_SIMPLE_TYPE(SevGuestState, SEV_GUEST)
  *         -object sev-guest,id=sev0 \
  *         -machine ...,memory-encryption=sev0
  */
-struct SevGuestState {
+struct SevCommonState {
     ConfidentialGuestSupport parent_obj;
 
     /* configuration parameters */
     char *sev_device;
-    uint32_t policy;
-    char *dh_cert_file;
-    char *session_file;
     uint32_t cbitpos;
     uint32_t reduced_phys_bits;
 
     /* runtime state */
-    uint32_t handle;
     uint8_t api_major;
     uint8_t api_minor;
     uint8_t build_id;
     uint64_t me_mask;
     int sev_fd;
     SevState state;
-    gchar *measurement;
 
     uint32_t reset_cs;
     uint32_t reset_ip;
     bool reset_data_valid;
 };
 
+struct SevGuestState {
+    SevCommonState sev_common;
+    gchar *measurement;
+
+    /* configuration parameters */
+    uint32_t handle;
+    uint32_t policy;
+    char *dh_cert_file;
+    char *session_file;
+};
+
 #define DEFAULT_GUEST_POLICY    0x1 /* disable debug */
 #define DEFAULT_SEV_DEVICE      "/dev/sev"
 
@@ -83,7 +91,6 @@ typedef struct __attribute__((__packed__)) SevInfoBlock {
     uint32_t reset_addr;
 } SevInfoBlock;
 
-static SevGuestState *sev_guest;
 static Error *sev_mig_blocker;
 
 static const char *const sev_fw_errlist[] = {
@@ -164,21 +171,21 @@ fw_error_to_str(int code)
 }
 
 static bool
-sev_check_state(const SevGuestState *sev, SevState state)
+sev_check_state(const SevCommonState *sev_common, SevState state)
 {
-    assert(sev);
-    return sev->state == state ? true : false;
+    assert(sev_common);
+    return sev_common->state == state ? true : false;
 }
 
 static void
-sev_set_guest_state(SevGuestState *sev, SevState new_state)
+sev_set_guest_state(SevCommonState *sev_common, SevState new_state)
 {
     assert(new_state < SEV_STATE__MAX);
-    assert(sev);
+    assert(sev_common);
 
-    trace_kvm_sev_change_state(SevState_str(sev->state),
+    trace_kvm_sev_change_state(SevState_str(sev_common->state),
                                SevState_str(new_state));
-    sev->state = new_state;
+    sev_common->state = new_state;
 }
 
 static void
@@ -245,67 +252,85 @@ static struct RAMBlockNotifier sev_ram_notifier = {
     .ram_block_removed = sev_ram_block_removed,
 };
 
-static void
-sev_guest_finalize(Object *obj)
+static char *
+sev_common_get_sev_device(Object *obj, Error **errp)
 {
+    return g_strdup(SEV_COMMON(obj)->sev_device);
 }
 
-static char *
-sev_guest_get_session_file(Object *obj, Error **errp)
+static void
+sev_common_set_sev_device(Object *obj, const char *value, Error **errp)
 {
-    SevGuestState *s = SEV_GUEST(obj);
+    SEV_COMMON(obj)->sev_device = g_strdup(value);
+}
 
-    return s->session_file ? g_strdup(s->session_file) : NULL;
+static void
+sev_common_class_init(ObjectClass *oc, void *data)
+{
+    object_class_property_add_str(oc, "sev-device",
+                                  sev_common_get_sev_device,
+                                  sev_common_set_sev_device);
+    object_class_property_set_description(oc, "sev-device",
+            "SEV device to use");
 }
 
 static void
-sev_guest_set_session_file(Object *obj, const char *value, Error **errp)
+sev_common_instance_init(Object *obj)
 {
-    SevGuestState *s = SEV_GUEST(obj);
+    SevCommonState *sev_common = SEV_COMMON(obj);
+
+    sev_common->sev_device = g_strdup(DEFAULT_SEV_DEVICE);
 
-    s->session_file = g_strdup(value);
+    object_property_add_uint32_ptr(obj, "cbitpos", &sev_common->cbitpos,
+                                   OBJ_PROP_FLAG_READWRITE);
+    object_property_add_uint32_ptr(obj, "reduced-phys-bits",
+                                   &sev_common->reduced_phys_bits,
+                                   OBJ_PROP_FLAG_READWRITE);
 }
 
+/* sev guest info common to sev/sev-es/sev-snp */
+static const TypeInfo sev_common_info = {
+    .parent = TYPE_CONFIDENTIAL_GUEST_SUPPORT,
+    .name = TYPE_SEV_COMMON,
+    .instance_size = sizeof(SevCommonState),
+    .class_init = sev_common_class_init,
+    .instance_init = sev_common_instance_init,
+    .abstract = true,
+    .interfaces = (InterfaceInfo[]) {
+        { TYPE_USER_CREATABLE },
+        { }
+    }
+};
+
 static char *
 sev_guest_get_dh_cert_file(Object *obj, Error **errp)
 {
-    SevGuestState *s = SEV_GUEST(obj);
-
-    return g_strdup(s->dh_cert_file);
+    return g_strdup(SEV_GUEST(obj)->dh_cert_file);
 }
 
 static void
 sev_guest_set_dh_cert_file(Object *obj, const char *value, Error **errp)
 {
-    SevGuestState *s = SEV_GUEST(obj);
-
-    s->dh_cert_file = g_strdup(value);
+    SEV_GUEST(obj)->dh_cert_file = g_strdup(value);
 }
 
 static char *
-sev_guest_get_sev_device(Object *obj, Error **errp)
+sev_guest_get_session_file(Object *obj, Error **errp)
 {
-    SevGuestState *sev = SEV_GUEST(obj);
+    SevGuestState *sev_guest = SEV_GUEST(obj);
 
-    return g_strdup(sev->sev_device);
+    return sev_guest->session_file ? g_strdup(sev_guest->session_file) : NULL;
 }
 
 static void
-sev_guest_set_sev_device(Object *obj, const char *value, Error **errp)
+sev_guest_set_session_file(Object *obj, const char *value, Error **errp)
 {
-    SevGuestState *sev = SEV_GUEST(obj);
-
-    sev->sev_device = g_strdup(value);
+    SEV_GUEST(obj)->session_file = g_strdup(value);
 }
 
 static void
 sev_guest_class_init(ObjectClass *oc, void *data)
 {
-    object_class_property_add_str(oc, "sev-device",
-                                  sev_guest_get_sev_device,
-                                  sev_guest_set_sev_device);
-    object_class_property_set_description(oc, "sev-device",
-            "SEV device to use");
     object_class_property_add_str(oc, "dh-cert-file",
                                   sev_guest_get_dh_cert_file,
                                   sev_guest_set_dh_cert_file);
@@ -321,80 +346,88 @@ sev_guest_class_init(ObjectClass *oc, void *data)
 static void
 sev_guest_instance_init(Object *obj)
 {
-    SevGuestState *sev = SEV_GUEST(obj);
+    SevGuestState *sev_guest = SEV_GUEST(obj);
 
-    sev->sev_device = g_strdup(DEFAULT_SEV_DEVICE);
-    sev->policy = DEFAULT_GUEST_POLICY;
-    object_property_add_uint32_ptr(obj, "policy", &sev->policy,
-                                   OBJ_PROP_FLAG_READWRITE);
-    object_property_add_uint32_ptr(obj, "handle", &sev->handle,
+    sev_guest->policy = DEFAULT_GUEST_POLICY;
+    object_property_add_uint32_ptr(obj, "handle", &sev_guest->handle,
                                    OBJ_PROP_FLAG_READWRITE);
-    object_property_add_uint32_ptr(obj, "cbitpos", &sev->cbitpos,
-                                   OBJ_PROP_FLAG_READWRITE);
-    object_property_add_uint32_ptr(obj, "reduced-phys-bits",
-                                   &sev->reduced_phys_bits,
+    object_property_add_uint32_ptr(obj, "policy", &sev_guest->policy,
                                    OBJ_PROP_FLAG_READWRITE);
 }
 
-/* sev guest info */
+/* guest info specific sev/sev-es */
 static const TypeInfo sev_guest_info = {
-    .parent = TYPE_CONFIDENTIAL_GUEST_SUPPORT,
+    .parent = TYPE_SEV_COMMON,
     .name = TYPE_SEV_GUEST,
     .instance_size = sizeof(SevGuestState),
-    .instance_finalize = sev_guest_finalize,
-    .class_init = sev_guest_class_init,
     .instance_init = sev_guest_instance_init,
-    .interfaces = (InterfaceInfo[]) {
-        { TYPE_USER_CREATABLE },
-        { }
-    }
+    .class_init = sev_guest_class_init,
 };
 
 bool
 sev_enabled(void)
 {
-    return !!sev_guest;
+    ConfidentialGuestSupport *cgs = MACHINE(qdev_get_machine())->cgs;
+
+    return !!object_dynamic_cast(OBJECT(cgs), TYPE_SEV_COMMON);
 }
 
 bool
 sev_es_enabled(void)
 {
-    return sev_enabled() && (sev_guest->policy & SEV_POLICY_ES);
+    ConfidentialGuestSupport *cgs = MACHINE(qdev_get_machine())->cgs;
+
+    return sev_enabled() && (SEV_GUEST(cgs)->policy & SEV_POLICY_ES);
 }
 
 uint64_t
 sev_get_me_mask(void)
 {
-    return sev_guest ? sev_guest->me_mask : ~0;
+    SevCommonState *sev_common = SEV_COMMON(MACHINE(qdev_get_machine())->cgs);
+
+    return sev_common ? sev_common->me_mask : ~0;
 }
 
 uint32_t
 sev_get_cbit_position(void)
 {
-    return sev_guest ? sev_guest->cbitpos : 0;
+    SevCommonState *sev_common = SEV_COMMON(MACHINE(qdev_get_machine())->cgs);
+
+    return sev_common ? sev_common->cbitpos : 0;
 }
 
 uint32_t
 sev_get_reduced_phys_bits(void)
 {
-    return sev_guest ? sev_guest->reduced_phys_bits : 0;
+    SevCommonState *sev_common = SEV_COMMON(MACHINE(qdev_get_machine())->cgs);
+
+    return sev_common ? sev_common->reduced_phys_bits : 0;
 }
 
 SevInfo *
 sev_get_info(void)
 {
     SevInfo *info;
+    SevCommonState *sev_common = SEV_COMMON(MACHINE(qdev_get_machine())->cgs);
+    SevGuestState *sev_guest =
+        (SevGuestState *)object_dynamic_cast(OBJECT(sev_common),
+                                             TYPE_SEV_GUEST);
 
     info = g_new0(SevInfo, 1);
     info->enabled = sev_enabled();
 
     if (info->enabled) {
-        info->api_major = sev_guest->api_major;
-        info->api_minor = sev_guest->api_minor;
-        info->build_id = sev_guest->build_id;
-        info->policy = sev_guest->policy;
-        info->state = sev_guest->state;
-        info->handle = sev_guest->handle;
+        if (sev_guest) {
+            info->handle = sev_guest->handle;
+        }
+        info->api_major = sev_common->api_major;
+        info->api_minor = sev_common->api_minor;
+        info->build_id = sev_common->build_id;
+        info->state = sev_common->state;
+        /* we only report the lower 32-bits of policy for SNP, ok for now... */
+        info->policy =
+            (uint32_t)object_property_get_uint(OBJECT(sev_common),
+                                               "policy", NULL);
     }
 
     return info;
@@ -452,6 +485,8 @@ sev_get_capabilities(Error **errp)
     size_t pdh_len = 0, cert_chain_len = 0;
     uint32_t ebx;
     int fd;
+    SevCommonState *sev_common;
+    char *sev_device;
 
     if (!kvm_enabled()) {
         error_setg(errp, "KVM not enabled");
@@ -462,12 +497,21 @@ sev_get_capabilities(Error **errp)
         return NULL;
     }
 
-    fd = open(DEFAULT_SEV_DEVICE, O_RDWR);
+    sev_common = SEV_COMMON(MACHINE(qdev_get_machine())->cgs);
+    if (!sev_common) {
+        error_setg(errp, "SEV is not configured");
+    }
+
+    sev_device = object_property_get_str(OBJECT(sev_common), "sev-device",
+                                         &error_abort);
+    fd = open(sev_device, O_RDWR);
     if (fd < 0) {
         error_setg_errno(errp, errno, "Failed to open %s",
                          DEFAULT_SEV_DEVICE);
+        g_free(sev_device);
         return NULL;
     }
+    g_free(sev_device);
 
     if (sev_get_pdh_info(fd, &pdh_data, &pdh_len,
                          &cert_chain_data, &cert_chain_len, errp)) {
@@ -499,7 +543,7 @@ sev_get_attestation_report(const char *mnonce, Error **errp)
 {
     struct kvm_sev_attestation_report input = {};
     SevAttestationReport *report = NULL;
-    SevGuestState *sev = sev_guest;
+    SevCommonState *sev_common;
     guchar *data;
     guchar *buf;
     gsize len;
@@ -525,8 +569,10 @@ sev_get_attestation_report(const char *mnonce, Error **errp)
         return NULL;
     }
 
+    sev_common = SEV_COMMON(MACHINE(qdev_get_machine())->cgs);
+
     /* Query the report length */
-    ret = sev_ioctl(sev->sev_fd, KVM_SEV_GET_ATTESTATION_REPORT,
+    ret = sev_ioctl(sev_common->sev_fd, KVM_SEV_GET_ATTESTATION_REPORT,
             &input, &err);
     if (ret < 0) {
         if (err != SEV_RET_INVALID_LEN) {
@@ -542,7 +588,7 @@ sev_get_attestation_report(const char *mnonce, Error **errp)
     memcpy(input.mnonce, buf, sizeof(input.mnonce));
 
     /* Query the report */
-    ret = sev_ioctl(sev->sev_fd, KVM_SEV_GET_ATTESTATION_REPORT,
+    ret = sev_ioctl(sev_common->sev_fd, KVM_SEV_GET_ATTESTATION_REPORT,
             &input, &err);
     if (ret) {
         error_setg_errno(errp, errno, "Failed to get attestation report"
@@ -579,28 +625,29 @@ sev_read_file_base64(const char *filename, guchar **data, gsize *len)
 }
 
 static int
-sev_launch_start(SevGuestState *sev)
+sev_launch_start(SevGuestState *sev_guest)
 {
     gsize sz;
     int ret = 1;
     int fw_error, rc;
     struct kvm_sev_launch_start *start;
     guchar *session = NULL, *dh_cert = NULL;
+    SevCommonState *sev_common = SEV_COMMON(sev_guest);
 
     start = g_new0(struct kvm_sev_launch_start, 1);
 
-    start->handle = sev->handle;
-    start->policy = sev->policy;
-    if (sev->session_file) {
-        if (sev_read_file_base64(sev->session_file, &session, &sz) < 0) {
+    start->handle = sev_guest->handle;
+    start->policy = sev_guest->policy;
+    if (sev_guest->session_file) {
+        if (sev_read_file_base64(sev_guest->session_file, &session, &sz) < 0) {
             goto out;
         }
         start->session_uaddr = (unsigned long)session;
         start->session_len = sz;
     }
 
-    if (sev->dh_cert_file) {
-        if (sev_read_file_base64(sev->dh_cert_file, &dh_cert, &sz) < 0) {
+    if (sev_guest->dh_cert_file) {
+        if (sev_read_file_base64(sev_guest->dh_cert_file, &dh_cert, &sz) < 0) {
             goto out;
         }
         start->dh_uaddr = (unsigned long)dh_cert;
@@ -608,15 +655,15 @@ sev_launch_start(SevGuestState *sev)
     }
 
     trace_kvm_sev_launch_start(start->policy, session, dh_cert);
-    rc = sev_ioctl(sev->sev_fd, KVM_SEV_LAUNCH_START, start, &fw_error);
+    rc = sev_ioctl(sev_common->sev_fd, KVM_SEV_LAUNCH_START, start, &fw_error);
     if (rc < 0) {
         error_report("%s: LAUNCH_START ret=%d fw_error=%d '%s'",
                 __func__, ret, fw_error, fw_error_to_str(fw_error));
         goto out;
     }
 
-    sev_set_guest_state(sev, SEV_STATE_LAUNCH_UPDATE);
-    sev->handle = start->handle;
+    sev_set_guest_state(sev_common, SEV_STATE_LAUNCH_UPDATE);
+    sev_guest->handle = start->handle;
     ret = 0;
 
 out:
@@ -627,7 +674,7 @@ out:
 }
 
 static int
-sev_launch_update_data(SevGuestState *sev, uint8_t *addr, uint64_t len)
+sev_launch_update_data(SevGuestState *sev_guest, uint8_t *addr, uint64_t len)
 {
     int ret, fw_error;
     struct kvm_sev_launch_update_data update;
@@ -639,7 +686,7 @@ sev_launch_update_data(SevGuestState *sev, uint8_t *addr, uint64_t len)
     update.uaddr = (__u64)(unsigned long)addr;
     update.len = len;
     trace_kvm_sev_launch_update_data(addr, len);
-    ret = sev_ioctl(sev->sev_fd, KVM_SEV_LAUNCH_UPDATE_DATA,
+    ret = sev_ioctl(SEV_COMMON(sev_guest)->sev_fd, KVM_SEV_LAUNCH_UPDATE_DATA,
                     &update, &fw_error);
     if (ret) {
         error_report("%s: LAUNCH_UPDATE ret=%d fw_error=%d '%s'",
@@ -650,11 +697,12 @@ sev_launch_update_data(SevGuestState *sev, uint8_t *addr, uint64_t len)
 }
 
 static int
-sev_launch_update_vmsa(SevGuestState *sev)
+sev_launch_update_vmsa(SevGuestState *sev_guest)
 {
     int ret, fw_error;
 
-    ret = sev_ioctl(sev->sev_fd, KVM_SEV_LAUNCH_UPDATE_VMSA, NULL, &fw_error);
+    ret = sev_ioctl(SEV_COMMON(sev_guest)->sev_fd, KVM_SEV_LAUNCH_UPDATE_VMSA,
+                    NULL, &fw_error);
     if (ret) {
         error_report("%s: LAUNCH_UPDATE_VMSA ret=%d fw_error=%d '%s'",
                 __func__, ret, fw_error, fw_error_to_str(fw_error));
@@ -666,18 +714,19 @@ sev_launch_update_vmsa(SevGuestState *sev)
 static void
 sev_launch_get_measure(Notifier *notifier, void *unused)
 {
-    SevGuestState *sev = sev_guest;
+    SevCommonState *sev_common = SEV_COMMON(MACHINE(qdev_get_machine())->cgs);
+    SevGuestState *sev_guest = SEV_GUEST(sev_common);
     int ret, error;
     guchar *data;
     struct kvm_sev_launch_measure *measurement;
 
-    if (!sev_check_state(sev, SEV_STATE_LAUNCH_UPDATE)) {
+    if (!sev_check_state(sev_common, SEV_STATE_LAUNCH_UPDATE)) {
         return;
     }
 
     if (sev_es_enabled()) {
         /* measure all the VM save areas before getting launch_measure */
-        ret = sev_launch_update_vmsa(sev);
+        ret = sev_launch_update_vmsa(sev_guest);
         if (ret) {
             exit(1);
         }
@@ -686,7 +735,7 @@ sev_launch_get_measure(Notifier *notifier, void *unused)
     measurement = g_new0(struct kvm_sev_launch_measure, 1);
 
     /* query the measurement blob length */
-    ret = sev_ioctl(sev->sev_fd, KVM_SEV_LAUNCH_MEASURE,
+    ret = sev_ioctl(sev_common->sev_fd, KVM_SEV_LAUNCH_MEASURE,
                     measurement, &error);
     if (!measurement->len) {
         error_report("%s: LAUNCH_MEASURE ret=%d fw_error=%d '%s'",
@@ -698,7 +747,7 @@ sev_launch_get_measure(Notifier *notifier, void *unused)
     measurement->uaddr = (unsigned long)data;
 
     /* get the measurement blob */
-    ret = sev_ioctl(sev->sev_fd, KVM_SEV_LAUNCH_MEASURE,
+    ret = sev_ioctl(sev_common->sev_fd, KVM_SEV_LAUNCH_MEASURE,
                     measurement, &error);
     if (ret) {
         error_report("%s: LAUNCH_MEASURE ret=%d fw_error=%d '%s'",
@@ -706,11 +755,11 @@ sev_launch_get_measure(Notifier *notifier, void *unused)
         goto free_data;
     }
 
-    sev_set_guest_state(sev, SEV_STATE_LAUNCH_SECRET);
+    sev_set_guest_state(sev_common, SEV_STATE_LAUNCH_SECRET);
 
     /* encode the measurement value and emit the event */
-    sev->measurement = g_base64_encode(data, measurement->len);
-    trace_kvm_sev_launch_measurement(sev->measurement);
+    sev_guest->measurement = g_base64_encode(data, measurement->len);
+    trace_kvm_sev_launch_measurement(sev_guest->measurement);
 
 free_data:
     g_free(data);
@@ -721,8 +770,10 @@ free_measurement:
 char *
 sev_get_launch_measurement(void)
 {
+    SevGuestState *sev_guest = SEV_GUEST(MACHINE(qdev_get_machine())->cgs);
+
     if (sev_guest &&
-        sev_guest->state >= SEV_STATE_LAUNCH_SECRET) {
+        SEV_COMMON(sev_guest)->state >= SEV_STATE_LAUNCH_SECRET) {
         return g_strdup(sev_guest->measurement);
     }
 
@@ -734,20 +785,21 @@ static Notifier sev_machine_done_notify = {
 };
 
 static void
-sev_launch_finish(SevGuestState *sev)
+sev_launch_finish(SevGuestState *sev_guest)
 {
     int ret, error;
     Error *local_err = NULL;
 
     trace_kvm_sev_launch_finish();
-    ret = sev_ioctl(sev->sev_fd, KVM_SEV_LAUNCH_FINISH, 0, &error);
+    ret = sev_ioctl(SEV_COMMON(sev_guest)->sev_fd, KVM_SEV_LAUNCH_FINISH, 0,
+                    &error);
     if (ret) {
         error_report("%s: LAUNCH_FINISH ret=%d fw_error=%d '%s'",
                      __func__, ret, error, fw_error_to_str(error));
         exit(1);
     }
 
-    sev_set_guest_state(sev, SEV_STATE_RUNNING);
+    sev_set_guest_state(SEV_COMMON(sev_guest), SEV_STATE_RUNNING);
 
     /* add migration blocker */
     error_setg(&sev_mig_blocker,
@@ -763,26 +815,25 @@ sev_launch_finish(SevGuestState *sev)
 static void
 sev_vm_state_change(void *opaque, bool running, RunState state)
 {
-    SevGuestState *sev = opaque;
+    SevCommonState *sev_common = opaque;
 
     if (running) {
-        if (!sev_check_state(sev, SEV_STATE_RUNNING)) {
-            sev_launch_finish(sev);
+        if (!sev_check_state(sev_common, SEV_STATE_RUNNING)) {
+            sev_launch_finish(SEV_GUEST(sev_common));
         }
     }
 }
 
 int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
 {
-    SevGuestState *sev
-        = (SevGuestState *)object_dynamic_cast(OBJECT(cgs), TYPE_SEV_GUEST);
+    SevCommonState *sev_common = SEV_COMMON(cgs);
     char *devname;
     int ret, fw_error, cmd;
     uint32_t ebx;
     uint32_t host_cbitpos;
     struct sev_user_data_status status = {};
 
-    if (!sev) {
+    if (!sev_common) {
         return 0;
     }
 
@@ -792,29 +843,28 @@ int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
         return -1;
     }
 
-    sev_guest = sev;
-    sev->state = SEV_STATE_UNINIT;
+    sev_common->state = SEV_STATE_UNINIT;
 
     host_cpuid(0x8000001F, 0, NULL, &ebx, NULL, NULL);
     host_cbitpos = ebx & 0x3f;
 
-    if (host_cbitpos != sev->cbitpos) {
+    if (host_cbitpos != sev_common->cbitpos) {
         error_setg(errp, "%s: cbitpos check failed, host '%d' requested '%d'",
-                   __func__, host_cbitpos, sev->cbitpos);
+                   __func__, host_cbitpos, sev_common->cbitpos);
         goto err;
     }
 
-    if (sev->reduced_phys_bits < 1) {
+    if (sev_common->reduced_phys_bits < 1) {
         error_setg(errp, "%s: reduced_phys_bits check failed, it should be >=1,"
-                   " requested '%d'", __func__, sev->reduced_phys_bits);
+                   " requested '%d'", __func__, sev_common->reduced_phys_bits);
         goto err;
     }
 
-    sev->me_mask = ~(1UL << sev->cbitpos);
+    sev_common->me_mask = ~(1UL << sev_common->cbitpos);
 
-    devname = object_property_get_str(OBJECT(sev), "sev-device", NULL);
-    sev->sev_fd = open(devname, O_RDWR);
-    if (sev->sev_fd < 0) {
+    devname = object_property_get_str(OBJECT(sev_common), "sev-device", NULL);
+    sev_common->sev_fd = open(devname, O_RDWR);
+    if (sev_common->sev_fd < 0) {
         error_setg(errp, "%s: Failed to open %s '%s'", __func__,
                    devname, strerror(errno));
         g_free(devname);
@@ -822,7 +872,7 @@ int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
     }
     g_free(devname);
 
-    ret = sev_platform_ioctl(sev->sev_fd, SEV_PLATFORM_STATUS, &status,
+    ret = sev_platform_ioctl(sev_common->sev_fd, SEV_PLATFORM_STATUS, &status,
                              &fw_error);
     if (ret) {
         error_setg(errp, "%s: failed to get platform status ret=%d "
@@ -830,9 +880,9 @@ int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
                    fw_error_to_str(fw_error));
         goto err;
     }
-    sev->build_id = status.build;
-    sev->api_major = status.api_major;
-    sev->api_minor = status.api_minor;
+    sev_common->build_id = status.build;
+    sev_common->api_major = status.api_major;
+    sev_common->api_minor = status.api_minor;
 
     if (sev_es_enabled()) {
         if (!kvm_kernel_irqchip_allowed()) {
@@ -853,14 +903,14 @@ int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
     }
 
     trace_kvm_sev_init();
-    ret = sev_ioctl(sev->sev_fd, cmd, NULL, &fw_error);
+    ret = sev_ioctl(sev_common->sev_fd, cmd, NULL, &fw_error);
     if (ret) {
         error_setg(errp, "%s: failed to initialize ret=%d fw_error=%d '%s'",
                    __func__, ret, fw_error, fw_error_to_str(fw_error));
         goto err;
     }
 
-    ret = sev_launch_start(sev);
+    ret = sev_launch_start(SEV_GUEST(sev_common));
     if (ret) {
         error_setg(errp, "%s: failed to create encryption context", __func__);
         goto err;
@@ -868,13 +918,12 @@ int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
 
     ram_block_notifier_add(&sev_ram_notifier);
     qemu_add_machine_init_done_notifier(&sev_machine_done_notify);
-    qemu_add_vm_change_state_handler(sev_vm_state_change, sev);
+    qemu_add_vm_change_state_handler(sev_vm_state_change, sev_common);
 
     cgs->ready = true;
 
     return 0;
 err:
-    sev_guest = NULL;
     ram_block_discard_disable(false);
     return -1;
 }
@@ -882,13 +931,15 @@ err:
 int
 sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp)
 {
-    if (!sev_guest) {
+    SevCommonState *sev_common = SEV_COMMON(MACHINE(qdev_get_machine())->cgs);
+
+    if (!sev_common) {
         return 0;
     }
 
     /* if SEV is in update state then encrypt the data else do nothing */
-    if (sev_check_state(sev_guest, SEV_STATE_LAUNCH_UPDATE)) {
-        int ret = sev_launch_update_data(sev_guest, ptr, len);
+    if (sev_check_state(sev_common, SEV_STATE_LAUNCH_UPDATE)) {
+        int ret = sev_launch_update_data(SEV_GUEST(sev_common), ptr, len);
         if (ret < 0) {
             error_setg(errp, "failed to encrypt pflash rom");
             return ret;
@@ -907,16 +958,17 @@ int sev_inject_launch_secret(const char *packet_hdr, const char *secret,
     void *hva;
     gsize hdr_sz = 0, data_sz = 0;
     MemoryRegion *mr = NULL;
+    SevCommonState *sev_common = SEV_COMMON(MACHINE(qdev_get_machine())->cgs);
 
-    if (!sev_guest) {
+    if (!sev_common) {
         error_setg(errp, "SEV: SEV not enabled.");
         return 1;
     }
 
     /* secret can be injected only in this state */
-    if (!sev_check_state(sev_guest, SEV_STATE_LAUNCH_SECRET)) {
+    if (!sev_check_state(sev_common, SEV_STATE_LAUNCH_SECRET)) {
         error_setg(errp, "SEV: Not in correct state. (LSECRET) %x",
-                     sev_guest->state);
+                   sev_common->state);
         return 1;
     }
 
@@ -950,7 +1002,7 @@ int sev_inject_launch_secret(const char *packet_hdr, const char *secret,
     trace_kvm_sev_launch_secret(gpa, input.guest_uaddr,
                                 input.trans_uaddr, input.trans_len);
 
-    ret = sev_ioctl(sev_guest->sev_fd, KVM_SEV_LAUNCH_SECRET,
+    ret = sev_ioctl(sev_common->sev_fd, KVM_SEV_LAUNCH_SECRET,
                     &input, &error);
     if (ret) {
         error_setg(errp, "SEV: failed to inject secret ret=%d fw_error=%d '%s'",
@@ -1026,9 +1078,10 @@ void sev_es_set_reset_vector(CPUState *cpu)
 {
     X86CPU *x86;
     CPUX86State *env;
+    SevCommonState *sev_common = SEV_COMMON(MACHINE(qdev_get_machine())->cgs);
 
     /* Only update if we have valid reset information */
-    if (!sev_guest || !sev_guest->reset_data_valid) {
+    if (!sev_common || !sev_common->reset_data_valid) {
         return;
     }
 
@@ -1040,11 +1093,11 @@ void sev_es_set_reset_vector(CPUState *cpu)
     x86 = X86_CPU(cpu);
     env = &x86->env;
 
-    cpu_x86_load_seg_cache(env, R_CS, 0xf000, sev_guest->reset_cs, 0xffff,
+    cpu_x86_load_seg_cache(env, R_CS, 0xf000, sev_common->reset_cs, 0xffff,
                            DESC_P_MASK | DESC_S_MASK | DESC_CS_MASK |
                            DESC_R_MASK | DESC_A_MASK);
 
-    env->eip = sev_guest->reset_ip;
+    env->eip = sev_common->reset_ip;
 }
 
 int sev_es_save_reset_vector(void *flash_ptr, uint64_t flash_size)
@@ -1052,6 +1105,7 @@ int sev_es_save_reset_vector(void *flash_ptr, uint64_t flash_size)
     CPUState *cpu;
     uint32_t addr;
     int ret;
+    SevCommonState *sev_common = SEV_COMMON(MACHINE(qdev_get_machine())->cgs);
 
     if (!sev_es_enabled()) {
         return 0;
@@ -1065,9 +1119,9 @@ int sev_es_save_reset_vector(void *flash_ptr, uint64_t flash_size)
     }
 
     if (addr) {
-        sev_guest->reset_cs = addr & 0xffff0000;
-        sev_guest->reset_ip = addr & 0x0000ffff;
-        sev_guest->reset_data_valid = true;
+        sev_common->reset_cs = addr & 0xffff0000;
+        sev_common->reset_ip = addr & 0x0000ffff;
+        sev_common->reset_data_valid = true;
 
         CPU_FOREACH(cpu) {
             sev_es_set_reset_vector(cpu);
@@ -1080,6 +1134,7 @@ int sev_es_save_reset_vector(void *flash_ptr, uint64_t flash_size)
 static void
 sev_register_types(void)
 {
+    type_register_static(&sev_common_info);
     type_register_static(&sev_guest_info);
 }
 
-- 
2.25.1

