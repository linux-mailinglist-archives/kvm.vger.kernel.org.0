Return-Path: <kvm+bounces-12234-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4ADC2880D6F
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:46:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 96482B22F6D
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 08:46:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 762EA38DE1;
	Wed, 20 Mar 2024 08:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="HWEe7NY3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2047.outbound.protection.outlook.com [40.107.220.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70655374C3
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 08:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710924388; cv=fail; b=piKH9eUr0EeO+BQMesUAA3HPlD9HDqZyS/lKSFwxC3i1hiJet4ozJt/6EIBN6h1nNsbBHFA0S/RKVTMhfH2AJCViaiMDPbVmjBF4qTl365QvIaKZM/d5k5h3CJOc7n7DrLKtLJdIbKStXeaWrbl1ofIxcjvNs9eGxmHuNb1NRzE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710924388; c=relaxed/simple;
	bh=QGlInYhHqaGsCojxB797NOspOtFxvpCA+Mf97xMjNb0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HsY3QrgdhjHjKnru3Ym1vdSweZvTFDiVrd3JwhwhmFJgYvYO6prHUogI+KZhzhSJokN91VM0qKkvzWmfydFd8Z4J7SIDCjLHAnTjxI/kHdF/+b1uoOT/cAIo79h2LSRW4BrWzs8Zkywp0uC+XOdP8qN1cKvTzLVncDjC7HwtIPo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=HWEe7NY3; arc=fail smtp.client-ip=40.107.220.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fz2ug7+qrWkRcIY4L4czPnlJkR1SsIVHiukyDUdEiaX6adK8eAskx/l5NzCY1QK5Epud5X/1ChWmh5Se41k9X/tXwjguVLFmHOH2ITo+6+9Tn1caqxu51zs+Ra9qr+5UaAkxcRtlASrmy//AFJxUuLmhHea/uSFCn2eJCxjpQOPs8H8eQ3dF13NhdEd1P4JpfHu3k5YuojxoLk0iEh96L9PTAY/sBckpJ4+1abp2SfUS7khCbvb6+5HfH/xMmer6f1uw5VEqdoPAXN9qnmyJv4Oj75JIOlrKGXf2rtPK6CpUCgVEMI2B4Ay+6q1QzqQwsjEBIzxMcJHt2Htv1ZnSLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gehi5mbMRnwlaPpR38+1auwvPqqhEjZFuH/Zj2vP/Fg=;
 b=EU8kzYPAHL/41N7iLQrBZlUKKsJ5VJEwG9Cd1gXHWqWz/mJY+b6BVEVl9UpTz/EdkTHpllbAD0wWTYAI0/BJHLUZG7cBcvUGuAFFGx4q0hay/LlMkgvijRhiYEw/4MLFTSgx10ZGQWVZv3cV/kKEkiU7YyD0Nol+J0iz3ZclslnXAmYDVmcAGz4CS2UtlHIglZA8FBvg4RErpV1g6SG98PlmReiRWNFfAGO/9Zlo+GgjcRpS8oo+Oq2Id+4tXtMbhYFhB2JUQVm+/4oZJFQ9qiE51JGPMy1NFEfZ7BYgDjzTXctkRBl4Ow+tf8J+n4AjCmS8AAUycj67bDpB48dAKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gehi5mbMRnwlaPpR38+1auwvPqqhEjZFuH/Zj2vP/Fg=;
 b=HWEe7NY3Og5ETAxh0Abq9eYwgwlxljsp43DSTERuTh0KPZ8S03KOpB0ABp+Z1V6xbKwavWLzvn6Nd+YdZsZkoHwm4qp0jstT/JWHDKucGpXTZ+6pXLavNngk8+OtWfDj37635Ffgu7I0CVE5hjS/vwG9Ba+kJ7J1GZdWIPwDW/s=
Received: from MW4PR03CA0285.namprd03.prod.outlook.com (2603:10b6:303:b5::20)
 by LV2PR12MB5728.namprd12.prod.outlook.com (2603:10b6:408:17c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.30; Wed, 20 Mar
 2024 08:46:23 +0000
Received: from MWH0EPF000A672F.namprd04.prod.outlook.com
 (2603:10b6:303:b5:cafe::4f) by MW4PR03CA0285.outlook.office365.com
 (2603:10b6:303:b5::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.28 via Frontend
 Transport; Wed, 20 Mar 2024 08:46:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000A672F.mail.protection.outlook.com (10.167.249.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Wed, 20 Mar 2024 08:46:23 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 20 Mar
 2024 03:46:22 -0500
From: Michael Roth <michael.roth@amd.com>
To: <qemu-devel@nongnu.org>
CC: <kvm@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?=
	<berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>, Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v3 22/49] i386/sev: Introduce 'sev-snp-guest' object
Date: Wed, 20 Mar 2024 03:39:18 -0500
Message-ID: <20240320083945.991426-23-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240320083945.991426-1-michael.roth@amd.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A672F:EE_|LV2PR12MB5728:EE_
X-MS-Office365-Filtering-Correlation-Id: b43a353e-9e38-4ea7-3b64-08dc48ba38e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Jja47tWWSdv4sFz7EWQTcBA3xzjFFiIgRDyifsFKQ5e5M2CIIhhMxeMuX7xngHt+sXzDZxTmUV0QevvJuEpMxhZzvbDA7/mM8SOKzvl8imLS3bOk/SnEHHWLIpRx0EXTQRKzY+xJDwqIss2TXQP69uLROlNO3wUhff/Ets0gs/zHnsgI6i0CWGLv8jrKO3111Z7ZByWCnBfJbSIhBccj5eMs0YOW6IRlrnHgvpNi0RXJhlsDZ4GXc83S6Kcv8kkRb6ftAISWhoANoCRgGW5QabJ+xZ1Ssd1H69vPGsR28JB2qSE/q4Nmn9URspwid21X761l12X2q8pEza33YfVqBOG4e4HtFI13OTbi/Hm0NtmKUioOlMW5GI2hFasLV8KoFNYG97AW7yxeRyJsk/83uSndapqHwWf4w3OQzrRNK/Fuw7CBi4f8ZdyplREzFj44TSIrHllTxpHeZ0b8uDc6xrS0ktbhygZXYdUmQpLBG2E0vrDoB1j/K1kiVY1irV+c8DZ4PBhdg4cBisISdY3o1RAoY6cXHZft54VR0H/H2OXb+9pizrTxg3hCXSUYBeHbicCBLhKSP0Vnkg7wSaMGD1lECH2Ql03kRt9rYQ68cyfaW+5f3yq4+LmJqR/yJS61eV+kSN2BY/tVvRXDPTg/nx7YAtFtYSbi6keyyZgHRXNt2IbGEK49s1VoJ9GaU243fOReRpjz7+zeyKssK9ad+G+KcKat9+BTskDs763an5djuCB1KClzZ+KGUGOA/IFD
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(36860700004)(376005)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 08:46:23.3541
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b43a353e-9e38-4ea7-3b64-08dc48ba38e0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A672F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5728

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

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Co-developed-by: Michael Roth <michael.roth@amd.com>
Acked-by: Markus Armbruster <armbru@redhat.com> (for QAPI schema)
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 docs/system/i386/amd-memory-encryption.rst |  78 ++++++-
 qapi/qom.json                              |  51 +++++
 target/i386/sev.c                          | 241 +++++++++++++++++++++
 target/i386/sev.h                          |   1 +
 4 files changed, 369 insertions(+), 2 deletions(-)

diff --git a/docs/system/i386/amd-memory-encryption.rst b/docs/system/i386/amd-memory-encryption.rst
index e9bc142bc1..9d6b63acd9 100644
--- a/docs/system/i386/amd-memory-encryption.rst
+++ b/docs/system/i386/amd-memory-encryption.rst
@@ -25,8 +25,8 @@ support for notifying a guest's operating system when certain types of VMEXITs
 are about to occur. This allows the guest to selectively share information with
 the hypervisor to satisfy the requested function.
 
-Launching
----------
+Launching (SEV and SEV-ES)
+--------------------------
 
 Boot images (such as bios) must be encrypted before a guest can be booted. The
 ``MEMORY_ENCRYPT_OP`` ioctl provides commands to encrypt the images: ``LAUNCH_START``,
@@ -161,6 +161,80 @@ The value of GCTX.LD is
 If kernel hashes are not used, or SEV-ES is disabled, use empty blobs for
 ``kernel_hashes_blob`` and ``vmsas_blob`` as needed.
 
+Launching (SEV-SNP)
+-------------------
+Boot images (such as bios) must be encrypted before a guest can be booted. The
+``MEMORY_ENCRYPT_OP`` ioctl provides commands to encrypt the images:
+``KVM_SNP_INIT``, ``SNP_LAUNCH_START``, ``SNP_LAUNCH_UPDATE``, and
+``SNP_LAUNCH_FINISH``. These four commands together generate a fresh memory
+encryption key for the VM, encrypt the boot images for a successful launch.
+
+KVM_SNP_INIT is called first to initialize the SEV-SNP firmware and SNP
+features in the KVM. The feature flags value can be provided through the
+init-flags property of the sev-snp-guest object.
+
++------------+-------+----------+---------------------------------+
+| key        | type  | default  | meaning                         |
++------------+-------+----------+---------------------------------+
+| init_flags | hex   | 0        | SNP feature flags               |
++-----------------------------------------------------------------+
+
+Note: currently the init_flags must be zero.
+
+``SNP_LAUNCH_START`` is called first to create a cryptographic launch context
+within the firmware. To create this context, guest owner must provide a guest
+policy and other parameters as described in the SEV-SNP firmware
+specification. The launch parameters should be specified as described in the
+QAPI schema for the sev-snp-guest object.
+
+The ``SNP_LAUNCH_START`` uses the following parameters (see the SEV-SNP
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
+``SNP_LAUNCH_UPDATE`` encrypts the memory region using the cryptographic context
+created via the ``SNP_LAUNCH_START`` command. If required, this command can be
+called multiple times to encrypt different memory regions. The command also
+calculates the measurement of the memory contents as it encrypts.
+
+``SNP_LAUNCH_FINISH`` finalizes the guest launch flow. Optionally, while
+finalizing the launch the firmware can perform checks on the launch digest
+computing through the ``SNP_LAUNCH_UPDATE``. To perform the check the user must
+supply the id block, authentication blob and host data that should be included
+in the attestation report. See the SEV-SNP spec for further details.
+
+The ``SNP_LAUNCH_FINISH`` uses the following parameters, which can be configured
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
+schema for the 'sev-snp-guest' object)::
+
+  # ${QEMU} \
+    -machine ...,confidential-guest-support=sev0 \
+    -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1
+
+
 Debugging
 ---------
 
diff --git a/qapi/qom.json b/qapi/qom.json
index 66b5781ca6..b25a3043da 100644
--- a/qapi/qom.json
+++ b/qapi/qom.json
@@ -920,6 +920,55 @@
             '*handle': 'uint32',
             '*kernel-hashes': 'bool' } }
 
+##
+# @SevSnpGuestProperties:
+#
+# Properties for sev-snp-guest objects. Most of these are direct arguments
+# for the KVM_SNP_* interfaces documented in the linux kernel source
+# under Documentation/virt/kvm/amd-memory-encryption.rst, which are in
+# turn closely coupled with the SNP_INIT/SNP_LAUNCH_* firmware commands
+# documented in the SEV-SNP Firmware ABI Specification (Rev 0.9).
+#
+# More usage information is also available in the QEMU source tree under
+# docs/amd-memory-encryption.
+#
+# @policy: the 'POLICY' parameter to the SNP_LAUNCH_START command, as
+#          defined in the SEV-SNP firmware ABI (default: 0x30000)
+#
+# @guest-visible-workarounds: 16-byte, base64-encoded blob to report
+#                             hypervisor-defined workarounds, corresponding
+#                             to the 'GOSVW' parameter of the
+#                             SNP_LAUNCH_START command defined in the
+#                             SEV-SNP firmware ABI (default: all-zero)
+#
+# @id-block: 96-byte, base64-encoded blob to provide the 'ID Block'
+#            structure for the SNP_LAUNCH_FINISH command defined in the
+#            SEV-SNP firmware ABI (default: all-zero)
+#
+# @id-auth: 4096-byte, base64-encoded blob to provide the 'ID Authentication
+#           Information Structure' for the SNP_LAUNCH_FINISH command defined
+#           in the SEV-SNP firmware ABI (default: all-zero)
+#
+# @auth-key-enabled: true if 'id-auth' blob contains the 'AUTHOR_KEY' field
+#                    defined SEV-SNP firmware ABI (default: false)
+#
+# @host-data: 32-byte, base64-encoded, user-defined blob to provide to the
+#             guest, as documented for the 'HOST_DATA' parameter of the
+#             SNP_LAUNCH_FINISH command in the SEV-SNP firmware ABI
+#             (default: all-zero)
+#
+# Since: 7.2
+##
+{ 'struct': 'SevSnpGuestProperties',
+  'base': 'SevCommonProperties',
+  'data': {
+            '*policy': 'uint64',
+            '*guest-visible-workarounds': 'str',
+            '*id-block': 'str',
+            '*id-auth': 'str',
+            '*auth-key-enabled': 'bool',
+            '*host-data': 'str' } }
+
 ##
 # @ThreadContextProperties:
 #
@@ -998,6 +1047,7 @@
     { 'name': 'secret_keyring',
       'if': 'CONFIG_SECRET_KEYRING' },
     'sev-guest',
+    'sev-snp-guest',
     'thread-context',
     's390-pv-guest',
     'throttle-group',
@@ -1068,6 +1118,7 @@
       'secret_keyring':             { 'type': 'SecretKeyringProperties',
                                       'if': 'CONFIG_SECRET_KEYRING' },
       'sev-guest':                  'SevGuestProperties',
+      'sev-snp-guest':              'SevSnpGuestProperties',
       'thread-context':             'ThreadContextProperties',
       'throttle-group':             'ThrottleGroupProperties',
       'tls-creds-anon':             'TlsCredsAnonProperties',
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 63a220de5e..7e6dab642a 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -42,6 +42,7 @@
 
 OBJECT_DECLARE_SIMPLE_TYPE(SevCommonState, SEV_COMMON)
 OBJECT_DECLARE_SIMPLE_TYPE(SevGuestState, SEV_GUEST)
+OBJECT_DECLARE_SIMPLE_TYPE(SevSnpGuestState, SEV_SNP_GUEST)
 
 struct SevCommonState {
     X86ConfidentialGuest parent_obj;
@@ -87,8 +88,22 @@ struct SevGuestState {
     bool kernel_hashes;
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
+    struct kvm_sev_snp_launch_start kvm_start_conf;
+    struct kvm_sev_snp_launch_finish kvm_finish_conf;
+};
+
 #define DEFAULT_GUEST_POLICY    0x1 /* disable debug */
 #define DEFAULT_SEV_DEVICE      "/dev/sev"
+#define DEFAULT_SEV_SNP_POLICY  0x30000
 
 #define SEV_INFO_BLOCK_GUID     "00f771de-1a7e-4fcb-890e-68c77e2fb44e"
 typedef struct __attribute__((__packed__)) SevInfoBlock {
@@ -1473,11 +1488,237 @@ static const TypeInfo sev_guest_info = {
     .class_init = sev_guest_class_init,
 };
 
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
+    blob = qbase64_decode(sev_snp_guest->guest_visible_workarounds, -1, &len, errp);
+    if (!blob) {
+        return;
+    }
+
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
+    finish->id_block_uaddr =
+        (uint64_t)qbase64_decode(sev_snp_guest->id_block, -1, &len, errp);
+
+    if (!finish->id_block_uaddr) {
+        return;
+    }
+
+    if (len > KVM_SEV_SNP_ID_BLOCK_SIZE) {
+        error_setg(errp, "parameter length of %lu exceeds max of %u",
+                   len, KVM_SEV_SNP_ID_BLOCK_SIZE);
+        return;
+    }
+
+    finish->id_block_en = (len) ? 1 : 0;
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
+    finish->id_auth_uaddr =
+        (uint64_t)qbase64_decode(sev_snp_guest->id_auth, -1, &len, errp);
+
+    if (!finish->id_auth_uaddr) {
+        return;
+    }
+
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
+    blob = qbase64_decode(sev_snp_guest->host_data, -1, &len, errp);
+
+    if (!blob) {
+        return;
+    }
+
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
 static void
 sev_register_types(void)
 {
     type_register_static(&sev_common_info);
     type_register_static(&sev_guest_info);
+    type_register_static(&sev_snp_guest_info);
 }
 
 type_init(sev_register_types);
diff --git a/target/i386/sev.h b/target/i386/sev.h
index 668374eef3..bedc667eeb 100644
--- a/target/i386/sev.h
+++ b/target/i386/sev.h
@@ -22,6 +22,7 @@
 
 #define TYPE_SEV_COMMON "sev-common"
 #define TYPE_SEV_GUEST "sev-guest"
+#define TYPE_SEV_SNP_GUEST "sev-snp-guest"
 
 #define SEV_POLICY_NODBG        0x1
 #define SEV_POLICY_NOKS         0x2
-- 
2.25.1


