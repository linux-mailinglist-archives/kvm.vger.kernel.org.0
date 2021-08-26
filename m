Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3E03F90B8
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 01:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243801AbhHZW2K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 18:28:10 -0400
Received: from mail-bn8nam12hn2241.outbound.protection.outlook.com ([52.100.165.241]:35809
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243799AbhHZW2J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 18:28:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bWYTN6xLON8vWjQDWxRFwtGaf0y/dIVZsdsZOrewHcLctQMqqtimDs5N9PWRsYLQiKiC47rZu2lbJCYJ52mWeeXhgNBtFzJQvp0PmOJrvtxEgB/DyXiUo4jyVTHYUrB/wKPXC8MYGgNV+bRb/0H+CdOWksZCED2p7AnFAj+k4QwQhasSKiAKrRzuifn/pfDh2/Lb6ipGY0+2SNiJ5N6mHLwlquuA6fpx2m39bvU8eJRgKs4hUfZZK3os7K9DO8ksGz+2n9VF2cDMTr3mlKfpslp0xZmdDic/V37LEvUyNyRYzfDML3EuAxo3/x3aOpNcLLgjSiwoHHX8M0BNZunHzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HV7v0NmLhzPtEFGMzP5rFBe6CQyNABf3k+MF8AZqoyA=;
 b=R84kpH9UjFC6u3XA3x57zUGA4Cxki/H8Ez9iljqk5hTmUM5Lvzq57IfeknC0R9BSP9NFauQGa5zJgR1Ea/m0y72TUhvQdwo4cwflSB1vJ4bWKC5b+97937bPNfOetIb+7z9eUFE5FV8333CU+w14LPcNe3ID2lSOfoh3hiBfDR1xx5m+6PE9Mkej0quJ9KW7dUu/OEsmVY6wRiTsD3ILjCXArx2AdRrwoYx2gtwwLZZraw13F/iNQ72022oT6U+Au5AQvU/YmD0uO+HAad90iFx4oRqbT9SgaX47ULv2zId1CXM9p0Dqljrz35L6nSZiidVS7AiSdkXQv5Yhmj5QYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HV7v0NmLhzPtEFGMzP5rFBe6CQyNABf3k+MF8AZqoyA=;
 b=Xoj1wjdFBAcNfZsh4rnQCL0MAWhFK58HxX2opWXO5rYsIOElq7ffZxvu4io/T99n3ZTrJ0JfcV+qs+L8DLBwYV16rkElEweMBqfdUn7EtrYMmqnJ9DnnoUXZBgMUrX6kyP3UE6oqebYccagLocDzvmsgif9yJTzJPAhoV6ha75Y=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13)
 by CH2PR12MB3925.namprd12.prod.outlook.com (2603:10b6:610:21::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Thu, 26 Aug
 2021 22:27:19 +0000
Received: from CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::d19e:b657:5259:24d0]) by CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::d19e:b657:5259:24d0%8]) with mapi id 15.20.4436.019; Thu, 26 Aug 2021
 22:27:19 +0000
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
Subject: [RFC PATCH v2 03/12] i386/sev: introduce 'sev-snp-guest' object
Date:   Thu, 26 Aug 2021 17:26:18 -0500
Message-Id: <20210826222627.3556-4-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210826222627.3556-1-michael.roth@amd.com>
References: <20210826222627.3556-1-michael.roth@amd.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA9P221CA0003.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:806:25::8) To CH2PR12MB4133.namprd12.prod.outlook.com
 (2603:10b6:610:7a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (165.204.77.1) by SA9P221CA0003.NAMP221.PROD.OUTLOOK.COM (2603:10b6:806:25::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.21 via Frontend Transport; Thu, 26 Aug 2021 22:27:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21bf55d1-ce56-42c8-06c8-08d968e0aac4
X-MS-TrafficTypeDiagnostic: CH2PR12MB3925:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR12MB392507BE71EAEF8897D186FD95C79@CH2PR12MB3925.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?kBmCEaAkZ7L+2a7OyyIQqYmFwP9kimjRY9uaQmdz0XkZ7r9oc9X1Bb3kMnY/?=
 =?us-ascii?Q?oKWXuyl6MdZpa6JnJjy0B7JJmR2BmIYaRo063B/sbchO5X188aZWHX28Xu7i?=
 =?us-ascii?Q?0WnV43EVuMfclqm6enJ5RYRZ7KLhO5HVaIzg3uiSC411xlpKsLwaLe67jknJ?=
 =?us-ascii?Q?6pZRLmyX6g/y1dRpkXb9wEe8gXkMGXuEWBBUBrEeq54ZcHBpDQklcQz4XoMG?=
 =?us-ascii?Q?eOIjlPjJX87YsXcq1gOnTDxq2J7vSl7ag9P9nehrRDEtNu3Mz2EIu5v3phwP?=
 =?us-ascii?Q?j/4W6m+lg2Q/5E/lGyQ1zlbhMr3EHBGuxna1ki5YcGxTOLWQ3lY4D5VrsmOV?=
 =?us-ascii?Q?pM8OR2PnvFsiLeYNvzbNjywDBQ1+dbTuHDToOSBtK0ILi7cae3e7cn4eh4G+?=
 =?us-ascii?Q?+AetYy6f6xdcX2VcIZvWdqS9MJpDO9rWObJDCh0nBHIzL/E3Ty0CUDJ01Clu?=
 =?us-ascii?Q?GMbxFBj8akG33DOEsnaTRjSOMUuij/rK1MiyPVloCymg0iXC2Q8RT2+aBSYI?=
 =?us-ascii?Q?1FdgS5KMLHCaBw+6hZL+LjQaH6sJYFnQp+mfb5wxGI0wN/lbQLzL+1G8lJzP?=
 =?us-ascii?Q?JoX22Ets43bnh+Vy++wNKStvDTbSXDJTMDMIVtIK7s+3jei0hndptH4I24kR?=
 =?us-ascii?Q?ly1I16XrmQ8CwYEBt/oPzDhKYxmQORCyhP3Fjq9kB/EivoKuOqqNSZJOHDo+?=
 =?us-ascii?Q?XsQQgZS1X9OCwgzzSzeYV12KlALQq1Ft3oDkc8kwI1LW4Z/DbYfjchcTuV+J?=
 =?us-ascii?Q?xxgwP1zDXuXxy5qDdiiqZLPbrliluNyQvsZ6dsGBwQRPySBONSFGGLLrVT1W?=
 =?us-ascii?Q?NzMw0xZtSbeXadOZX9TFkevEpgF0W2cy2t0kTHlFvs+riMIkbFq+a5zD7/3n?=
 =?us-ascii?Q?gCE9aaDbOoisE+lz4xAHMuR2dcDBpuObgHEy6UpjM3Gi7X7hi6wznjJGmKPP?=
 =?us-ascii?Q?Jd8JvQOIMG3gsjuNdDkio/AN9y2MMtC9yg1Gnq06Xsiz1wEAzzWZHO4bsjI0?=
 =?us-ascii?Q?3Ow83Et1XFL6f9mgMO7zprOpHZqk30ky9vS+JAocALsubPY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:CH2PR12MB4133.namprd12.prod.outlook.com;PTR:;CAT:OSPM;SFS:(4636009)(376002)(396003)(346002)(136003)(39860400002)(366004)(8676002)(38350700002)(66476007)(38100700002)(956004)(2616005)(66556008)(83380400001)(186003)(30864003)(6916009)(478600001)(36756003)(316002)(4326008)(44832011)(54906003)(66946007)(52116002)(6496006)(2906002)(86362001)(1076003)(6486002)(5660300002)(7416002)(8936002)(26005)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LjQ5/5nmPQE4r/z9m6AE7O4Mz/F72gA1aRiJxoRrlc7T/SSWjgLavKn9ZOyl?=
 =?us-ascii?Q?YUXqR4u9FBJYEy+jBbEqPnuXkpUD6DjJp03iY2lWjrmHp/LCgx+EPQRLWndH?=
 =?us-ascii?Q?xs2E0rHq+am7nGqtXSIfTiEhjJnqmByokz5pGYVXKp6cFX5DfHGqdwDyEb3v?=
 =?us-ascii?Q?EL2p98XlEttWRPAQWihcQ+HZbkkT++rMCeY8yVUiihhU2y6M0d1/Gc8oJORu?=
 =?us-ascii?Q?TKertK6vtbGUCMaHtAwT7uJ0WD6+iywm1Sy34NbwSLcWep+5saSbZnOJmM/o?=
 =?us-ascii?Q?Wux8suZTqrWHPd5DWBS5VvSLle4uhEjuz+H07u7ir6raKrntI6/iNu8zbpE0?=
 =?us-ascii?Q?MOt9LkB/VWWT2+H6Piskx+9rB2O+ay1RdBUfj4zMf26SzKmp4DvtpAT0NQ/t?=
 =?us-ascii?Q?WEswNV/t+OfgcHZND9R+HsZWTyuAn9vJO8WPKBw45tSOdpSV+7tUKO4G840c?=
 =?us-ascii?Q?FgaYbv1Jg2SqylwdqD4Wcuqp2prjcdme6hyh7RhC+6BYth5u+Uq0d05e1Hqx?=
 =?us-ascii?Q?kY24MAKgIKwW37vbTmO7jlndXYQZYfrUP6H6OTXWPcgWGVDj7/3SNlwYT8T7?=
 =?us-ascii?Q?GmjFN16UMF5TP8GBVu8xtNVu59Oimxt9bapfjWvLp3qoeBsFszIakVX7mO3p?=
 =?us-ascii?Q?OjTU55H7PsUMM68ZLHaaROTQ/XDxwzrY6C7ilZz36Byrh3OG37P/nKL93gbH?=
 =?us-ascii?Q?AvBHVISsjasfuuUQuQZqts1sje1Rvpb7w98ge7B40uLSahfk9Nlc2aUYF05d?=
 =?us-ascii?Q?HhhHgrSkNhgYOGQQ/nyC2tZ/zTMxvqeOJlv5oxa2GxbvdQ4cxwYGm1LaaoxA?=
 =?us-ascii?Q?7VsGblhSBumgka++v3aXVCp+HWmh3iRLQAacM8x4WvxY+xFGCHhPXco2p3+c?=
 =?us-ascii?Q?dIx9d9XdyNyystJy7phNHUT+eSDxSYwCsL2LpOWomKEWQKff5tyFv/k7m+5G?=
 =?us-ascii?Q?TgYlPVMteVrdDm2OFZjbepVrZnDbt4X5kHBfJOM21h7jhDzT3lJ6oYUCJy3+?=
 =?us-ascii?Q?eW8W54hofYpbZF933rwDePXn4lyrNhOMMh2U38hcKNuO0phlrK0vBq0DYIit?=
 =?us-ascii?Q?ZobFBc56RLllFQ4MVEqrkKFNG+MbC1/+URbG/YUpAb/BQodHA150mnmJmcbc?=
 =?us-ascii?Q?YXlpxTtP0C7C/CvmTva5EQoSa5Kq5Qwef8RYy8FTBOE5+GgZICsiBaCmKYLX?=
 =?us-ascii?Q?tBuwkyWPuj5BDU1QroK9cdJi7oMePfvPNc1JDEiac9hRfXre9FbGO/ugolk7?=
 =?us-ascii?Q?Ne6PPJNBvwXAOUvkhIEcprbkxC9ifcnijw/3XkHD3VZohpnAFjaLhiSviaEX?=
 =?us-ascii?Q?R8GxezS7COvkucu8ynBnTfls?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21bf55d1-ce56-42c8-06c8-08d968e0aac4
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4133.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2021 22:27:19.8155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z3gzyGPDKyluR+aeoazTi21a7Tt88iQL5fnSO5NyWhdPY326Cbi/XkMC5UyY9LJecKJcOBVN8Y/hcCq5ez3OCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3925
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

SEV-SNP support relies on a different set of properties/state than the
existing 'sev-guest' object. This patch introduces the 'sev-snp-guest'
object, which can be used to configure an SEV-SNP guest. For example,
a default-configured SEV-SNP guest with no additional information
passed in for use with attestation:

  -object sev-snp-guest,id=sev0

or a fully-specified SEV-SNP guest where all spec-defined binary
blobs are passed in as base64-encoded strings:

  -object sev-snp-guest,id=sev0, \
    policy=0x30000, \
    init-flags=0, \
    id-block=YWFhYWFhYWFhYWFhYWFhCg==, \
    id-auth=CxHK/OKLkXGn/KpAC7Wl1FSiisWDbGTEKz..., \
    auth-key-enabled=on, \
    host-data=LNkCWBRC5CcdGXirbNUV1OrsR28s..., \
    guest-visible-workarounds=AA==, \

See the QAPI schema updates included in this patch for more usage
details.

In some cases these blobs may be up to 4096 characters, but this is
generally well below the default limit for linux hosts where
command-line sizes are defined by the sysconf-configurable ARG_MAX
value, which defaults to 2097152 characters for Ubuntu hosts, for
example.

Co-developed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 docs/amd-memory-encryption.txt |  77 ++++++++++-
 qapi/qom.json                  |  60 ++++++++
 target/i386/sev.c              | 245 ++++++++++++++++++++++++++++++++-
 3 files changed, 379 insertions(+), 3 deletions(-)

diff --git a/docs/amd-memory-encryption.txt b/docs/amd-memory-encryption.txt
index ffca382b5f..0d82e67fa1 100644
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
@@ -113,6 +113,79 @@ a SEV-ES guest:
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
+'init-flags' property of the 'sev-snp-guest' object.
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
+specification. The launch parameters should be specified as described in the
+QAPI schema for the 'sev-snp-guest' object.
+
+The SNP_LAUNCH_START uses the following parameters (see the SEV-SNP
+specification for more details):
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
+The SNP_LAUNCH_FINISH uses the following parameters, which can be configured
+by the corresponding parameters documented in the QAPI schema for the
+'sev-snp-guest' object.
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
+To launch a SEV-SNP guest (additional parameters are documented in the QAPI
+schema for the 'sev-snp-guest' object):
+
+# ${QEMU} \
+    -machine ...,confidential-guest-support=sev0 \
+    -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1
+
 Debugging
 -----------
 Since the memory contents of a SEV guest are encrypted, hypervisor access to
diff --git a/qapi/qom.json b/qapi/qom.json
index 211e083727..ea39585026 100644
--- a/qapi/qom.json
+++ b/qapi/qom.json
@@ -775,6 +775,64 @@
             '*policy': 'uint32',
             '*handle': 'uint32' } }
 
+##
+# @SevSnpGuestProperties:
+#
+# Properties for sev-snp-guest objects. Many of these are direct arguments
+# for the SEV-SNP KVM interfaces documented in the linux kernel source
+# documentation under 'amd-memory-encryption.rst'. Additional documentation
+# is also available in the QEMU source tree under
+# 'amd-memory-encryption.rst'.
+#
+# In addition to those files, please see the SEV-SNP Firmware Specification
+# (Rev 0.9) documentation for the SNP_INIT and
+# SNP_LAUNCH_{START,UPDATE,FINISH} firmware interfaces, which the KVM
+# interfaces are written against.
+#
+# @init-flags: as documented for the 'flags' parameter of the
+#              KVM_SNP_INIT KVM command (default: 0)
+#
+# @policy: as documented for the 'policy' parameter of the
+#          KVM_SNP_LAUNCH_START KVM command (default: 0x30000)
+#
+# @guest-visible-workarounds: 16-byte, base64-encoded blob to report
+#                             hypervisor-defined workarounds, as documented
+#                             for the 'gosvm' parameter of the
+#                             KVM_SNP_LAUNCH_START KVM command.
+#                             (default: all-zero)
+#
+# @id-block: 8-byte, base64-encoded blob to provide the ID Block
+#            structure documented in SEV-SNP spec, as documented for the
+#            'id_block_uaddr' parameter of the KVM_SNP_LAUNCH_FINISH
+#            command (default: all-zero)
+#
+# @id-auth: 4096-byte, base64-encoded blob to provide the ID Authentication
+#           Information Structure documented in SEV-SNP spec, as documented
+#           for the 'id_auth_uaddr' parameter of the KVM_SNP_LAUNCH_FINISH
+#           command (default: all-zero)
+#
+# @auth-key-enabled: true if 'id-auth' blob contains the Author Key
+#                    documented in the SEV-SNP spec, as documented for the
+#                    'auth_key_en' parameter of the KVM_SNP_LAUNCH_FINISH
+#                    command (default: false)
+#
+# @host-data: 32-byte, base64-encoded user-defined blob to provide to the
+#             guest, as documented for the 'host_data' parameter of the
+#             KVM_SNP_LAUNCH_FINISH command (default: all-zero)
+#
+# Since: 6.2
+##
+{ 'struct': 'SevSnpGuestProperties',
+  'base': 'SevCommonProperties',
+  'data': {
+            '*init-flags': 'uint64',
+            '*policy': 'uint64',
+            '*guest-visible-workarounds': 'str',
+            '*id-block': 'str',
+            '*id-auth': 'str',
+            '*auth-key-enabled': 'bool',
+            '*host-data': 'str' } }
+
 ##
 # @ObjectType:
 #
@@ -816,6 +874,7 @@
     'secret',
     'secret_keyring',
     'sev-guest',
+    'sev-snp-guest',
     's390-pv-guest',
     'throttle-group',
     'tls-creds-anon',
@@ -873,6 +932,7 @@
       'secret':                     'SecretProperties',
       'secret_keyring':             'SecretKeyringProperties',
       'sev-guest':                  'SevGuestProperties',
+      'sev-snp-guest':              'SevSnpGuestProperties',
       'throttle-group':             'ThrottleGroupProperties',
       'tls-creds-anon':             'TlsCredsAnonProperties',
       'tls-creds-psk':              'TlsCredsPskProperties',
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 6acebfbd53..ba08b7d3ab 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -38,7 +38,8 @@
 OBJECT_DECLARE_SIMPLE_TYPE(SevCommonState, SEV_COMMON)
 #define TYPE_SEV_GUEST "sev-guest"
 OBJECT_DECLARE_SIMPLE_TYPE(SevGuestState, SEV_GUEST)
-
+#define TYPE_SEV_SNP_GUEST "sev-snp-guest"
+OBJECT_DECLARE_SIMPLE_TYPE(SevSnpGuestState, SEV_SNP_GUEST)
 
 /**
  * SevGuestState:
@@ -82,8 +83,23 @@ struct SevGuestState {
     char *session_file;
 };
 
+struct SevSnpGuestState {
+    SevCommonState sev_common;
+
+    /* configuration parameters */
+    char *guest_visible_workarounds;
+    char *id_block;
+    char *id_auth;
+    char *host_data;
+
+    struct kvm_snp_init kvm_init_conf;
+    struct kvm_sev_snp_launch_start kvm_start_conf;
+    struct kvm_sev_snp_launch_finish kvm_finish_conf;
+};
+
 #define DEFAULT_GUEST_POLICY    0x1 /* disable debug */
 #define DEFAULT_SEV_DEVICE      "/dev/sev"
+#define DEFAULT_SEV_SNP_POLICY  0x30000
 
 #define SEV_INFO_BLOCK_GUID     "00f771de-1a7e-4fcb-890e-68c77e2fb44e"
 typedef struct __attribute__((__packed__)) SevInfoBlock {
@@ -364,6 +380,232 @@ static const TypeInfo sev_guest_info = {
     .class_init = sev_guest_class_init,
 };
 
+static void
+sev_snp_guest_get_init_flags(Object *obj, Visitor *v, const char *name,
+                             void *opaque, Error **errp)
+{
+    visit_type_uint64(v, name,
+                      (uint64_t *)&SEV_SNP_GUEST(obj)->kvm_init_conf.flags,
+                      errp);
+}
+
+static void
+sev_snp_guest_set_init_flags(Object *obj, Visitor *v, const char *name,
+                             void *opaque, Error **errp)
+{
+    visit_type_uint64(v, name,
+                      (uint64_t *)&SEV_SNP_GUEST(obj)->kvm_init_conf.flags,
+                      errp);
+}
+
+static void
+sev_snp_guest_get_policy(Object *obj, Visitor *v, const char *name,
+                         void *opaque, Error **errp)
+{
+    visit_type_uint64(v, name,
+                      (uint64_t *)&SEV_SNP_GUEST(obj)->kvm_start_conf.policy,
+                      errp);
+}
+
+static void
+sev_snp_guest_set_policy(Object *obj, Visitor *v, const char *name,
+                         void *opaque, Error **errp)
+{
+    visit_type_uint64(v, name,
+                      (uint64_t *)&SEV_SNP_GUEST(obj)->kvm_start_conf.policy,
+                      errp);
+}
+
+static char *
+sev_snp_guest_get_guest_visible_workarounds(Object *obj, Error **errp)
+{
+    return g_strdup(SEV_SNP_GUEST(obj)->guest_visible_workarounds);
+}
+
+static void
+sev_snp_guest_set_guest_visible_workarounds(Object *obj, const char *value,
+                                            Error **errp)
+{
+    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
+    struct kvm_sev_snp_launch_start *start = &sev_snp_guest->kvm_start_conf;
+    g_autofree guchar *blob;
+    gsize len;
+
+    if (sev_snp_guest->guest_visible_workarounds) {
+        g_free(sev_snp_guest->guest_visible_workarounds);
+    }
+
+    /* store the base64 str so we don't need to re-encode in getter */
+    sev_snp_guest->guest_visible_workarounds = g_strdup(value);
+
+    blob = g_base64_decode(sev_snp_guest->guest_visible_workarounds, &len);
+    if (len > sizeof(start->gosvw)) {
+        error_setg(errp, "parameter length of %lu exceeds max of %lu",
+                   len, sizeof(start->gosvw));
+        return;
+    }
+
+    memcpy(start->gosvw, blob, len);
+}
+
+static char *
+sev_snp_guest_get_id_block(Object *obj, Error **errp)
+{
+    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
+
+    return g_strdup(sev_snp_guest->id_block);
+}
+
+static void
+sev_snp_guest_set_id_block(Object *obj, const char *value, Error **errp)
+{
+    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
+    struct kvm_sev_snp_launch_finish *finish = &sev_snp_guest->kvm_finish_conf;
+    gsize len;
+
+    if (sev_snp_guest->id_block) {
+        g_free(sev_snp_guest->id_block);
+        g_free((guchar *)finish->id_block_uaddr);
+    }
+
+    /* store the base64 str so we don't need to re-encode in getter */
+    sev_snp_guest->id_block = g_strdup(value);
+
+    finish->id_block_uaddr = (uint64_t)g_base64_decode(sev_snp_guest->id_block, &len);
+    if (len > KVM_SEV_SNP_ID_BLOCK_SIZE) {
+        error_setg(errp, "parameter length of %lu exceeds max of %u",
+                   len, KVM_SEV_SNP_ID_BLOCK_SIZE);
+        return;
+    }
+    finish->id_block_en = 1;
+}
+
+static char *
+sev_snp_guest_get_id_auth(Object *obj, Error **errp)
+{
+    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
+
+    return g_strdup(sev_snp_guest->id_auth);
+}
+
+static void
+sev_snp_guest_set_id_auth(Object *obj, const char *value, Error **errp)
+{
+    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
+    struct kvm_sev_snp_launch_finish *finish = &sev_snp_guest->kvm_finish_conf;
+    gsize len;
+
+    if (sev_snp_guest->id_auth) {
+        g_free(sev_snp_guest->id_auth);
+        g_free((guchar *)finish->id_auth_uaddr);
+    }
+
+    /* store the base64 str so we don't need to re-encode in getter */
+    sev_snp_guest->id_auth = g_strdup(value);
+
+    finish->id_auth_uaddr = (uint64_t)g_base64_decode(sev_snp_guest->id_auth, &len);
+    if (len > KVM_SEV_SNP_ID_AUTH_SIZE) {
+        error_setg(errp, "parameter length of %lu exceeds max of %u",
+                   len, KVM_SEV_SNP_ID_AUTH_SIZE);
+        return;
+    }
+}
+
+static bool
+sev_snp_guest_get_auth_key_en(Object *obj, Error **errp)
+{
+    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
+
+    return !!sev_snp_guest->kvm_finish_conf.auth_key_en;
+}
+
+static void
+sev_snp_guest_set_auth_key_en(Object *obj, bool value, Error **errp)
+{
+    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
+
+    sev_snp_guest->kvm_finish_conf.auth_key_en = value;
+}
+
+static char *
+sev_snp_guest_get_host_data(Object *obj, Error **errp)
+{
+    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
+
+    return g_strdup(sev_snp_guest->host_data);
+}
+
+static void
+sev_snp_guest_set_host_data(Object *obj, const char *value, Error **errp)
+{
+    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
+    struct kvm_sev_snp_launch_finish *finish = &sev_snp_guest->kvm_finish_conf;
+    g_autofree guchar *blob;
+    gsize len;
+
+    if (sev_snp_guest->host_data) {
+        g_free(sev_snp_guest->host_data);
+    }
+
+    /* store the base64 str so we don't need to re-encode in getter */
+    sev_snp_guest->host_data = g_strdup(value);
+
+    blob = g_base64_decode(sev_snp_guest->host_data, &len);
+    if (len > sizeof(finish->host_data)) {
+        error_setg(errp, "parameter length of %lu exceeds max of %lu",
+                   len, sizeof(finish->host_data));
+        return;
+    }
+
+    memcpy(finish->host_data, blob, len);
+}
+
+static void
+sev_snp_guest_class_init(ObjectClass *oc, void *data)
+{
+    object_class_property_add(oc, "init-flags", "uint64",
+                              sev_snp_guest_get_init_flags,
+                              sev_snp_guest_set_init_flags, NULL, NULL);
+    object_class_property_set_description(oc, "init-flags",
+        "guest initialization flags");
+    object_class_property_add(oc, "policy", "uint64",
+                              sev_snp_guest_get_policy,
+                              sev_snp_guest_set_policy, NULL, NULL);
+    object_class_property_add_str(oc, "guest-visible-workarounds",
+                                  sev_snp_guest_get_guest_visible_workarounds,
+                                  sev_snp_guest_set_guest_visible_workarounds);
+    object_class_property_add_str(oc, "id-block",
+                                  sev_snp_guest_get_id_block,
+                                  sev_snp_guest_set_id_block);
+    object_class_property_add_str(oc, "id-auth",
+                                  sev_snp_guest_get_id_auth,
+                                  sev_snp_guest_set_id_auth);
+    object_class_property_add_bool(oc, "auth-key-enabled",
+                                   sev_snp_guest_get_auth_key_en,
+                                   sev_snp_guest_set_auth_key_en);
+    object_class_property_add_str(oc, "host-data",
+                                  sev_snp_guest_get_host_data,
+                                  sev_snp_guest_set_host_data);
+}
+
+static void
+sev_snp_guest_instance_init(Object *obj)
+{
+    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
+
+    /* default init/start/finish params for kvm */
+    sev_snp_guest->kvm_start_conf.policy = DEFAULT_SEV_SNP_POLICY;
+}
+
+/* guest info specific to sev-snp */
+static const TypeInfo sev_snp_guest_info = {
+    .parent = TYPE_SEV_COMMON,
+    .name = TYPE_SEV_SNP_GUEST,
+    .instance_size = sizeof(SevSnpGuestState),
+    .class_init = sev_snp_guest_class_init,
+    .instance_init = sev_snp_guest_instance_init,
+};
+
 bool
 sev_enabled(void)
 {
@@ -1136,6 +1378,7 @@ sev_register_types(void)
 {
     type_register_static(&sev_common_info);
     type_register_static(&sev_guest_info);
+    type_register_static(&sev_snp_guest_info);
 }
 
 type_init(sev_register_types);
-- 
2.25.1

