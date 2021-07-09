Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 517AC3C2B08
	for <lists+kvm@lfdr.de>; Fri,  9 Jul 2021 23:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbhGIV66 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jul 2021 17:58:58 -0400
Received: from mail-bn7nam10on2062.outbound.protection.outlook.com ([40.107.92.62]:31937
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230494AbhGIV64 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jul 2021 17:58:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Od7qr1+rjah08GXh2JFio7DTzW9O7+Q7aKj4YT1J0aq8JCnMHkci8BNXxWlO0b49Wxtjxd6a4usMmpVAhyN2VWGVrBUfnQy9hPqPa+kjGa8ZsFPhsVD+fBVQ2us4ji1+IJOL2jZVNMaSEtC5Q28gFVSRWAw20YBdgHU8/Kk1Z7gNDj0J/wXddRTP8ctPEkBk7i0/o8JhdriCiZnnWAD6fpjCtcNt+gmJEYGweVLt14rAKqs+dyLcZuUUelnqL3eC58LtdNySXBvHaolJ2K5h0p0fs6Pt11/vYA9p4UlCGMFQucMYZuCuSuOQOsVKEysz9lMsKABL1GUu7z6b7isXkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qz/2JzX4a56wLgP9dFkSeajHUQGe8h0GKR7KnT3CW8c=;
 b=Io/v6yeSf+/MRIIoxsCl/tdL0/S8F/j3gXWn529vfAwgmCzB0l6nyvuQxf1P9pYMRGJEIjwvql8agMhiCbiQONxkHoanKLnlKGK+E2jUJvZ56A4sHgvz0eeFxaE521CE/kuDX7me9rByjYhsnnIvfog32HIyMQbDKYjbqd+5lKGjE7wDeH8h6ybSAjnungXcgQ0Kuv0EkWcgm+5N3gCDLHDehbCOfdcNLuW2xEG+xi22sVYJoHiw/NkJpu8sde9oicAiCBwAhaUz9Rg++zPVXZZw6YTIIeMd1piZPuepFWZNsKV4UscCUvsyOmrz0byyyx7Gxhd8Ff15yncchFeZTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qz/2JzX4a56wLgP9dFkSeajHUQGe8h0GKR7KnT3CW8c=;
 b=NMcaoEkSIMgUns+H6TbHm1GKQjPhyHQ6opftbVEZwNwns8nut2++jvCPU4yglhbL+GzU7FZnOXfryxFuWrlJ5FYsw8SQG1gFEAXs29tOyR//I8qPQoOUfVAgpDFVun7p04fly76/YJzqOqTe0I5sactEUs4tBwyyUrqLbzUQxpc=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4575.namprd12.prod.outlook.com (2603:10b6:806:73::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21; Fri, 9 Jul
 2021 21:56:10 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa%3]) with mapi id 15.20.4308.022; Fri, 9 Jul 2021
 21:56:10 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
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
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [RFC PATCH 2/6] i386/sev: extend sev-guest property to include SEV-SNP
Date:   Fri,  9 Jul 2021 16:55:46 -0500
Message-Id: <20210709215550.32496-3-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210709215550.32496-1-brijesh.singh@amd.com>
References: <20210709215550.32496-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0601CA0007.namprd06.prod.outlook.com
 (2603:10b6:803:2f::17) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0601CA0007.namprd06.prod.outlook.com (2603:10b6:803:2f::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Fri, 9 Jul 2021 21:56:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 80e2f6e3-c861-46ce-d7e1-08d943245cf4
X-MS-TrafficTypeDiagnostic: SA0PR12MB4575:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB457575A5F5544CF9B0B80103E5189@SA0PR12MB4575.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YzgK1dXLTKdNJU1xN4gpNNNkTcNUfnj2sid+XwdpvIltOH6snjV20t8bntA9qtEp8kZpPsSHBDfG785i4A6lAlcQrIgo+ByypdaNXxU7dvLk5lFgzQt1dTsgIZO1OxyAIINPg3XYhOhy7UHlGhUc4k4ySDpBtoiZ35IJZXbGxIbPVDeVjuwtzKaRWhk9jirnSeY9c+YxYeZMOxjrjiIpR9sO0vFYzqfimzsasvxk38a+44FdW2vogUdSAc72tAAeyTLcRZNC6jUGWSfLIWIznO23hDx2cnfMofXlfPHJE1uBA8WBotNg6KGiid5tX2PvaBVloCiG03vONy7OLlTZv8vbdQm+RXDeI/sEwBULyPVXLtxYvRwMapB4tlnLcXXvN/l6JXorjW1q94I2JPhUy7hd30FuDL7FDYS4rZ2DGFH3ULAnLC09LP265kCMXSsWp8PamzlKVUTSrXpm1ylv+hXRx5g7YXULyO+v6sAuCTa0/586Hh+pglFNlwb40h9//4kSQlTDVOPjgtDki1Flg/rv1fAnQGEYuWfhDD4PS878AYRzW2kDNrcsgbUWhjMPpCJk9/xr9zll3Cy87CgsvPpkkXbxAYBNgyx+gUkmVsfcf3LVarDZROlKH5OB3OSD3OAbQx7KaeW8fId4Dt4rLcHDIAKz43wgZxFkYaR2qIIPMlfpZLhO+189Mv2FpArUERlxYGO4gojk6iwfDH2HbA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(39860400002)(376002)(396003)(346002)(30864003)(6916009)(2616005)(66556008)(36756003)(6666004)(6486002)(83380400001)(7696005)(52116002)(2906002)(66476007)(316002)(4326008)(186003)(38100700002)(66946007)(38350700002)(8676002)(8936002)(956004)(86362001)(5660300002)(44832011)(54906003)(478600001)(1076003)(26005)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?flxAS2bmkWM+BXpp2iB5L9Z/R2NWcNIob9+nQVNZ6TzQNjly5lT/0+YN88Sf?=
 =?us-ascii?Q?QLJ0rlEph/2x2mM3z46ZYG++YhvIOmTczW7AWm21bn5hNEO+qF423mzNWlU3?=
 =?us-ascii?Q?5m5YcSvfnKT/eFTopU97m0lFnpS2OQNHrSchW1O+GShfFIMeXJIc9KVX17GU?=
 =?us-ascii?Q?+IzaKPYYek5b9UKTPfuYAp1mWKp+AR6tzkIosfNIKkOJ7UPr+l8CpeRfEJIn?=
 =?us-ascii?Q?MOn1iciO4tc9VfbHf6vF5cISp99hj5RKyPGxjC5Z0Xgo0pSGnyC1xep8cF9d?=
 =?us-ascii?Q?owqIXx6WHy1JeJbro1JJERA/I2JI8Bl5RIg5vBzBWzwKLwRlXLeQ3Y0X6zLO?=
 =?us-ascii?Q?YpWHRovW+18Rcc4OX6lZEa/PjO7LmS2SjVrA5RF5HpzE8vEr3VCNUZEy8S6l?=
 =?us-ascii?Q?5BzmnLNOw7lSPE274vwEK+cJ10NPvFff5gNCT1OygYVhq9+6W67ccMz63IxX?=
 =?us-ascii?Q?B2Rnn0nvMzr7rDJU/0aVDMWBNPb4IwxrtnHlJHQoliP6fiWbBTmpPS/+3JDj?=
 =?us-ascii?Q?sAScc1ekxVCM3eQkdP5IBtXCQS9SV1soiw4oD1HPOcUHLvIcM0nJor7XpJ0D?=
 =?us-ascii?Q?e7NYy2afPONlFvzu3tYNfjZLkASv3OQPPvxrm/L0qdDhMeP5KD/EPgLVkmMA?=
 =?us-ascii?Q?C8am0wEIc0TuCs1MvcW+dPum0gNNtFtRGwh0dQzoU6LK6lFkwfxGFQZThGbb?=
 =?us-ascii?Q?E01VFMsIs5N23oYosQq4hPMoYbNYDpt70AL9aFJmBLhzwRy5Y6RRDJkyYDww?=
 =?us-ascii?Q?IwufZau6IHMMC6ADc5RN8MTVFGKO7V2ppKCvIncRtnpLqDmWpENvhwi557h5?=
 =?us-ascii?Q?Jlz9FZWidb77N2x+atonjsqNFgh7CZUEiB3woc9yc4cg412T+bI5+mC4y5P9?=
 =?us-ascii?Q?1qPzRXeTKlewS9Xqze16IcmTihLI5kM1T/mDByZmirv2Ut0hKY01wi4wrYtr?=
 =?us-ascii?Q?1RrwsqRlo5dQG77mFfxPJm4SHREtva+yK5z9yeljELnKRo9E5g0BIzlp3E+L?=
 =?us-ascii?Q?6WXi3XamYvZ3uX5kX0EAg1Hm5X4CjBb+vkpl5uHygUwyctd+zHt+pbNawwVv?=
 =?us-ascii?Q?XUnbRmmbq+hloTRcLBhloZrBuonPHUciA9e1bz8CYE+QkBd5B5q38HusA7QP?=
 =?us-ascii?Q?o7WGthmTVc/7kmD/z02s9lhtvVc5yWpSBlhrJjSxg0gKf7Ot6+I1E48yHsh9?=
 =?us-ascii?Q?5ab2lJOPr/NqdFSRvHe+jd+8WehwsgaJAtTxKU43iN8m5p5VZQlJTvh4dE1Q?=
 =?us-ascii?Q?6tQhNaBcdY51JpWMhsqGwIhmhdYjpSuvuaZtED5c5ButI/2gGbrRvhLveRuu?=
 =?us-ascii?Q?b4dcRQyGmh7NIjPwHOdakuWj?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80e2f6e3-c861-46ce-d7e1-08d943245cf4
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2021 21:56:10.8448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gjO7Y0mXznxe4QgEdYzycxR8kVhuP6HZlCZ86j7MvqxyCZlFylWadQVxbsk5H3CKTozYZS5YZ7iX7/9TcwXz4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4575
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To launch the SEV-SNP guest, a user can specify up to 8 parameters.
Passing all parameters through command line can be difficult. To simplify
the launch parameter passing, introduce a .ini-like config file that can be
used for passing the parameters to the launch flow.

The contents of the config file will look like this:

$ cat snp-launch.init

# SNP launch parameters
[SEV-SNP]
init_flags = 0
policy = 0x1000
id_block = "YWFhYWFhYWFhYWFhYWFhCg=="


Add 'snp' property that can be used to indicate that SEV guest launch
should enable the SNP support.

SEV-SNP guest launch examples:

1) launch without additional parameters

  $(QEMU_CLI) \
    -object sev-guest,id=sev0,snp=on

2) launch with optional parameters
  $(QEMU_CLI) \
    -object sev-guest,id=sev0,snp=on,launch-config=<file>

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 docs/amd-memory-encryption.txt |  81 +++++++++++-
 qapi/qom.json                  |   6 +
 target/i386/sev.c              | 227 +++++++++++++++++++++++++++++++++
 3 files changed, 312 insertions(+), 2 deletions(-)

diff --git a/docs/amd-memory-encryption.txt b/docs/amd-memory-encryption.txt
index ffca382b5f..322bf38f68 100644
--- a/docs/amd-memory-encryption.txt
+++ b/docs/amd-memory-encryption.txt
@@ -22,8 +22,8 @@ support for notifying a guest's operating system when certain types of VMEXITs
 are about to occur. This allows the guest to selectively share information with
 the hypervisor to satisfy the requested function.
 
-Launching
----------
+Launching (SEV and SEV-ES)
+--------------------------
 Boot images (such as bios) must be encrypted before a guest can be booted. The
 MEMORY_ENCRYPT_OP ioctl provides commands to encrypt the images: LAUNCH_START,
 LAUNCH_UPDATE_DATA, LAUNCH_MEASURE and LAUNCH_FINISH. These four commands
@@ -113,6 +113,83 @@ a SEV-ES guest:
  - Requires in-kernel irqchip - the burden is placed on the hypervisor to
    manage booting APs.
 
+Launching (SEV-SNP)
+-------------------
+Boot images (such as bios) must be encrypted before a guest can be booted. The
+MEMORY_ENCRYPT_OP ioctl provides commands to encrypt the images:
+KVM_SNP_INIT, SNP_LAUNCH_START, SNP_LAUNCH_UPDATE, and SNP_LAUNCH_FINISH. These
+four commands together generate a fresh memory encryption key for the VM,
+encrypt the boot images for a successful launch.
+
+KVM_SNP_INIT is called first to initialize the SEV-SNP firmware and SNP
+features in the KVM. The feature flags value can be provided through the
+launch-config file.
+
++------------+-------+----------+---------------------------------+
+| key        | type  | default  | meaning                         |
++------------+-------+----------+---------------------------------+
+| init_flags | hex   | 0        | SNP feature flags               |
++-----------------------------------------------------------------+
+
+Note: currently the init_flags must be zero.
+
+SNP_LAUNCH_START is called first to create a cryptographic launch context
+within the firmware. To create this context, guest owner must provide a guest
+policy and other parameters as described in the SEV-SNP firmware
+specification. The launch parameters should be specified in the launch-config
+ini file and should be treated as a binary blob and must be passed as-is to
+the SEV-SNP firmware.
+
+The SNP_LAUNCH_START uses the following parameters from the launch-config
+file. See the SEV-SNP specification for more details.
+
++--------+-------+----------+----------------------------------------------+
+| key    | type  | default  | meaning                                      |
++--------+-------+----------+----------------------------------------------+
+| policy | hex   | 0x30000  | a 64-bit guest policy                        |
+| imi_en | bool  | 0        | 1 when IMI is enabled                        |
+| ma_end | bool  | 0        | 1 when migration agent is used               |
+| gosvw  | string| 0        | 16-byte base64 encoded string for the guest  |
+|        |       |          | OS visible workaround.                       |
++--------+-------+----------+----------------------------------------------+
+
+SNP_LAUNCH_UPDATE encrypts the memory region using the cryptographic context
+created via the SNP_LAUNCH_START command. If required, this command can be called
+multiple times to encrypt different memory regions. The command also calculates
+the measurement of the memory contents as it encrypts.
+
+SNP_LAUNCH_FINISH finalizes the guest launch flow. Optionally, while finalizing
+the launch the firmware can perform checks on the launch digest computing
+through the SNP_LAUNCH_UPDATE. To perform the check the user must supply
+the id block, authentication blob and host data that should be included in the
+attestation report. See the SEV-SNP spec for further details.
+
+The SNP_LAUNCH_FINISH uses the following parameters from the launch-config file.
+
++------------+-------+----------+----------------------------------------------+
+| key        | type  | default  | meaning                                      |
++------------+-------+----------+----------------------------------------------+
+| id_block   | string| none     | base64 encoded ID block                      |
++------------+-------+----------+----------------------------------------------+
+| id_auth    | string| none     | base64 encoded authentication information    |
++------------+-------+----------+----------------------------------------------+
+| auth_key_en| bool  | 0        | auth block contains author key               |
++------------+-------+----------+----------------------------------------------+
+| host_data  | string| none     | host provided data                           |
++------------+-------+----------+----------------------------------------------+
+
+To launch a SEV-SNP guest
+
+# ${QEMU} \
+    -machine ...,confidential-guest-support=sev0 \
+    -object sev-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,snp=on
+
+To launch a SEV-SNP guest with launch configuration
+
+# ${QEMU} \
+    -machine ...,confidential-guest-support=sev0 \
+    -object sev-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,snp=on,launch-config=<config>
+
 Debugging
 -----------
 Since the memory contents of a SEV guest are encrypted, hypervisor access to
diff --git a/qapi/qom.json b/qapi/qom.json
index 652be317b8..bdf89fda27 100644
--- a/qapi/qom.json
+++ b/qapi/qom.json
@@ -749,6 +749,10 @@
 # @reduced-phys-bits: number of bits in physical addresses that become
 #                     unavailable when SEV is enabled
 #
+# @snp: SEV-SNP is enabled (default: 0)
+#
+# @launch-config: launch config file to use
+#
 # Since: 2.12
 ##
 { 'struct': 'SevGuestProperties',
@@ -758,6 +762,8 @@
             '*policy': 'uint32',
             '*handle': 'uint32',
             '*cbitpos': 'uint32',
+            '*snp': 'bool',
+            '*launch-config': 'str',
             'reduced-phys-bits': 'uint32' } }
 
 ##
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 83df8c09f6..6b238ef969 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -37,6 +37,11 @@
 #define TYPE_SEV_GUEST "sev-guest"
 OBJECT_DECLARE_SIMPLE_TYPE(SevGuestState, SEV_GUEST)
 
+struct snp_launch_config {
+    struct kvm_snp_init init;
+    struct kvm_sev_snp_launch_start start;
+    struct kvm_sev_snp_launch_finish finish;
+};
 
 /**
  * SevGuestState:
@@ -58,6 +63,8 @@ struct SevGuestState {
     char *session_file;
     uint32_t cbitpos;
     uint32_t reduced_phys_bits;
+    char *launch_config_file;
+    bool snp;
 
     /* runtime state */
     uint32_t handle;
@@ -72,10 +79,13 @@ struct SevGuestState {
     uint32_t reset_cs;
     uint32_t reset_ip;
     bool reset_data_valid;
+
+    struct snp_launch_config snp_config;
 };
 
 #define DEFAULT_GUEST_POLICY    0x1 /* disable debug */
 #define DEFAULT_SEV_DEVICE      "/dev/sev"
+#define DEFAULT_SEV_SNP_POLICY  0x30000
 
 #define SEV_INFO_BLOCK_GUID     "00f771de-1a7e-4fcb-890e-68c77e2fb44e"
 typedef struct __attribute__((__packed__)) SevInfoBlock {
@@ -298,6 +308,212 @@ sev_guest_set_sev_device(Object *obj, const char *value, Error **errp)
     sev->sev_device = g_strdup(value);
 }
 
+static void
+sev_guest_set_snp(Object *obj, bool value, Error **errp)
+{
+    SevGuestState *sev = SEV_GUEST(obj);
+
+    sev->snp = value;
+}
+
+static bool
+sev_guest_get_snp(Object *obj, Error **errp)
+{
+    SevGuestState *sev = SEV_GUEST(obj);
+
+    return sev->snp;
+}
+
+
+static char *
+sev_guest_get_launch_config_file(Object *obj, Error **errp)
+{
+    SevGuestState *s = SEV_GUEST(obj);
+
+    return g_strdup(s->launch_config_file);
+}
+
+static int
+config_read_uint64(GKeyFile *f, const char *key, uint64_t *value, Error **errp)
+{
+    g_autoptr(GError) error = NULL;
+    g_autofree gchar *str = NULL;
+    uint64_t res;
+
+    str = g_key_file_get_string(f, "SEV-SNP", key, &error);
+    if (!str) {
+        /* key not found */
+        return 0;
+    }
+
+    res = g_ascii_strtoull(str, NULL, 16);
+    if (res == G_MAXUINT64) {
+        error_setg(errp, "Failed to convert %s", str);
+        return 1;
+    }
+
+    *value = res;
+    return 0;
+}
+
+static int
+config_read_bool(GKeyFile *f, const char *key, bool *value, Error **errp)
+{
+    g_autoptr(GError) error = NULL;
+    gboolean val;
+
+    val = g_key_file_get_boolean(f, "SEV-SNP", key, &error);
+    if (!val && g_error_matches(error, G_KEY_FILE_ERROR,
+                                 G_KEY_FILE_ERROR_INVALID_VALUE)) {
+        error_setg(errp, "%s", error->message);
+        return 1;
+    }
+
+    *value = val;
+    return 0;
+}
+
+static int
+config_read_blob(GKeyFile *f, const char *key, uint8_t *blob, uint32_t len,
+                 Error **errp)
+{
+    g_autoptr(GError) error = NULL;
+    g_autofree guchar *data = NULL;
+    g_autofree gchar *base64 = NULL;
+    gsize size;
+
+    base64 = g_key_file_get_string(f, "SEV-SNP", key, &error);
+    if (!base64) {
+        /* key not found */
+        return 0;
+    }
+
+    /* lets decode the value string */
+    data = g_base64_decode(base64, &size);
+    if (!data) {
+        error_setg(errp, "failed to decode '%s'", key);
+        return 1;
+    }
+
+    /* verify the length */
+    if (len != size) {
+        error_setg(errp, "invalid length for key '%s' (expected %d got %ld)",
+                   key, len, size);
+        return 1;
+    }
+
+    memcpy(blob, data, size);
+    return 0;
+}
+
+static int
+snp_parse_launch_config(SevGuestState *sev, const char *file, Error **errp)
+{
+    g_autoptr(GError) error = NULL;
+    g_autoptr(GKeyFile) key_file = g_key_file_new();
+    struct kvm_sev_snp_launch_start *start = &sev->snp_config.start;
+    struct kvm_snp_init *init = &sev->snp_config.init;
+    struct kvm_sev_snp_launch_finish *finish = &sev->snp_config.finish;
+    uint8_t *id_block = NULL, *id_auth = NULL;
+
+    if (!g_key_file_load_from_file(key_file, file, G_KEY_FILE_NONE, &error)) {
+        error_setg(errp, "Error loading config file: %s", error->message);
+        return 1;
+    }
+
+    /* Check the group first */
+    if (!g_key_file_has_group(key_file, "SEV-SNP")) {
+        error_setg(errp, "Error parsing config file, group SEV-SNP not found");
+        return 1;
+    }
+
+    /* Get the init_flags used in KVM_SNP_INIT */
+    if (config_read_uint64(key_file, "init_flags",
+                           (uint64_t *)&init->flags, errp)) {
+        goto err;
+    }
+
+    /* Get the policy used in LAUNCH_START */
+    if (config_read_uint64(key_file, "policy",
+                           (uint64_t *)&start->policy, errp)) {
+        goto err;
+    }
+
+    /* Get IMI_EN used in LAUNCH_START */
+    if (config_read_bool(key_file, "imi_en", (bool *)&start->imi_en, errp)) {
+        goto err;
+    }
+
+    /* Get MA_EN used in LAUNCH_START */
+    if (config_read_bool(key_file, "imi_en", (bool *)&start->ma_en, errp)) {
+        goto err;
+    }
+
+    /* Get GOSVW used in LAUNCH_START */
+    if (config_read_blob(key_file, "gosvw", (uint8_t *)&start->gosvw,
+                         sizeof(start->gosvw), errp)) {
+        goto err;
+    }
+
+    /* Get ID block used in LAUNCH_FINISH */
+    if (g_key_file_has_key(key_file, "SEV-SNP", "id_block", &error)) {
+
+        id_block = g_malloc(KVM_SEV_SNP_ID_BLOCK_SIZE);
+
+        if (config_read_blob(key_file, "id_block", id_block,
+                             KVM_SEV_SNP_ID_BLOCK_SIZE, errp)) {
+            goto err;
+        }
+
+        finish->id_block_uaddr = (unsigned long)id_block;
+        finish->id_block_en = 1;
+    }
+
+    /* Get authentication block used in LAUNCH_FINISH */
+    if (g_key_file_has_key(key_file, "SEV-SNP", "id_auth", &error)) {
+
+        id_auth = g_malloc(KVM_SEV_SNP_ID_AUTH_SIZE);
+
+        if (config_read_blob(key_file, "auth_block", id_auth,
+                             KVM_SEV_SNP_ID_AUTH_SIZE, errp)) {
+            goto err;
+        }
+
+        finish->id_auth_uaddr = (unsigned long)id_auth;
+
+        /* Get AUTH_KEY_EN used in LAUNCH_FINISH */
+        if (config_read_bool(key_file, "auth_key_en",
+                             (bool *)&finish->auth_key_en, errp)) {
+            goto err;
+        }
+    }
+
+    /* Get host_data used in LAUNCH_FINISH */
+    if (config_read_blob(key_file, "host_data", (uint8_t *)&finish->host_data,
+                         sizeof(finish->host_data), errp)) {
+        goto err;
+    }
+
+    return 0;
+
+err:
+    g_free(id_block);
+    g_free(id_auth);
+    return 1;
+}
+
+static void
+sev_guest_set_launch_config_file(Object *obj, const char *value, Error **errp)
+{
+    SevGuestState *s = SEV_GUEST(obj);
+
+    if (snp_parse_launch_config(s, value, errp)) {
+        return;
+    }
+
+    s->launch_config_file = g_strdup(value);
+}
+
 static void
 sev_guest_class_init(ObjectClass *oc, void *data)
 {
@@ -316,6 +532,16 @@ sev_guest_class_init(ObjectClass *oc, void *data)
                                   sev_guest_set_session_file);
     object_class_property_set_description(oc, "session-file",
             "guest owners session parameters (encoded with base64)");
+    object_class_property_add_bool(oc, "snp",
+                                   sev_guest_get_snp,
+                                   sev_guest_set_snp);
+    object_class_property_set_description(oc, "snp",
+            "enable SEV-SNP support");
+    object_class_property_add_str(oc, "launch-config",
+                                  sev_guest_get_launch_config_file,
+                                  sev_guest_set_launch_config_file);
+    object_class_property_set_description(oc, "launch-config",
+            "the file provides the SEV-SNP guest launch parameters");
 }
 
 static void
@@ -325,6 +551,7 @@ sev_guest_instance_init(Object *obj)
 
     sev->sev_device = g_strdup(DEFAULT_SEV_DEVICE);
     sev->policy = DEFAULT_GUEST_POLICY;
+    sev->snp_config.start.policy = DEFAULT_SEV_SNP_POLICY;
     object_property_add_uint32_ptr(obj, "policy", &sev->policy,
                                    OBJ_PROP_FLAG_READWRITE);
     object_property_add_uint32_ptr(obj, "handle", &sev->handle,
-- 
2.17.1

