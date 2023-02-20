Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F81C69D3BE
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 20:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233038AbjBTTEP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 14:04:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232721AbjBTTEO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 14:04:14 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2082.outbound.protection.outlook.com [40.107.102.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE6632201D;
        Mon, 20 Feb 2023 11:03:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DLDu94Nqnh9/vD1yUqt8QADAm08mbhkWREprrsfNLwl9tzkufTtVpAKG0/VVtxi0Eqw49eyQViT8tVrvYcHIyiP+DYTTd32g/nMcSUu6zp0x7G+0hj0WwhZG++MjMcicRDFOegv6veIdLgNS9nq6q7S0GJGru+UOofZIjetqHRtIbQZ3OsZmqpyZORRVejRuKFrjCJKqc5gcpJCd9cP5qsewj8JmXzptQetb5/XkEmtBIK+6LFBYnmOLLLxU3yJ9tJMH7H813NS6aEVGzTqmb9NP5GIC71GmSuQBkLRQsvVnvt7AXplMpmKfUOrdLfXSvX+RgWgVsoL066wnACvdXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bhdLB+9fGVwgfwLdW0pGauuauXN7czdXY6hjutnQW1g=;
 b=Zr+Bi4jFXsFxOQ4Hz5nZRBzJx3f7wEIR/b59kp27uG2n7MZPwo0e5XNeVxw5JMyyGSp2QeBc/F7NFbZKYojJ3cigJQgk4y+PBXRP0uccqbLjbfFHnW95oMb3J75HKKqbSB9zS+S/sdQK9pVsZvTgYM0bEjXiB0w8LMB1T/1YZcTbJRYgGuMHMl1smvaXPAYr3pJ+bpP9S8Tv0sUR0MzT1B3ixvBLeAvuxZT21KRJQt6csA+iuVTseZ1sUDiF3S7lZ/69RQYK7VILnZpTNJyoQCV1rlaYmQ2BLwkiuF1yB1tBLlAoFsIerIyYi9FsFXnJFzUbRONJIbkJGnG0jGL5mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bhdLB+9fGVwgfwLdW0pGauuauXN7czdXY6hjutnQW1g=;
 b=DtUz3FYMKqlsy4VdJNvf6rrjZ5X0RkEy5lOJSTU2T3awTQh3xKom3q/bh2slCozG0aet3xBiCz2ZJ4+zkBMXfo7CxH2CvzzbHXbFWV/m+HBbbTOwWzQS+UkF/cIekSBWSFROPKSylAxjXYWGHvtG3KQ49VvRBIum+9UFdp4uW+Q=
Received: from MW4P222CA0023.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::28)
 by SN7PR12MB7810.namprd12.prod.outlook.com (2603:10b6:806:34c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Mon, 20 Feb
 2023 19:01:02 +0000
Received: from CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:114:cafe::64) by MW4P222CA0023.outlook.office365.com
 (2603:10b6:303:114::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19 via Frontend
 Transport; Mon, 20 Feb 2023 19:01:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT018.mail.protection.outlook.com (10.13.175.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.21 via Frontend Transport; Mon, 20 Feb 2023 19:01:02 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 13:01:01 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>, <jmattson@google.com>,
        <luto@kernel.org>, <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
        Dionna Glaze <dionnaglaze@google.com>,
        "Thomas Lendacky" <Thomas.Lendacky@amd.com>
Subject: [PATCH RFC v8 55/56] x86/sev: Document KVM_SEV_SNP_{G,S}ET_CERTS
Date:   Mon, 20 Feb 2023 12:38:46 -0600
Message-ID: <20230220183847.59159-56-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230220183847.59159-1-michael.roth@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT018:EE_|SN7PR12MB7810:EE_
X-MS-Office365-Filtering-Correlation-Id: f41b3fd6-8231-470a-4532-08db1374cfb3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e65c5ls0TTnpXU4cZJQW4nNcRpTjRarYf1eErEGrO6OXnOWPpla+eNKBdyqaSpWOEyCDvWA/4W9lhsYdoF7yvLyEwIeo/PR9dTxUFXEK14QMWGj+MVV8obywmfNFFKd9Z81/EP4GC7HWy0ZUF5YC1gN4pst9KV3h4RzGR5FX41gbwISznl6G2zrzaVqllQuKWuI389zL1Q8R9/HKPOmeuTQvurAO8mw4KJCWZEpylcY6AVeqCYpHuFy8Cax9b8VUO5zMiujQ8k78cZGi6oKyNW3wgDev/5NHv0xPL/APoYRRyqmczau6DOGW3y7dQW/gcyTZSWDDYaL+Jnm72OH7jnSHw0klAkFCU+I+ozTGslmwSvalE8O51aJpIzu9/SI4VWcQNhwmc8rRdmwhb9yLPb5QjBY3S61h2qkyV8xXY68agEXdbKIpz3WC6250dw6HzY9Agqwo5e6n4QIfMgN1D45dEa1pNNXGZgWsfUixOGnfza7LU8FMUt9ynJzVejswFNZd8I9RryxTrrTBhaYhDpa3LxGyZ2LcTH8giMugPKAlyPaXXbVhyLwawpLPbMJxXnFkmWgFK4cGKJ++3YYGNyhPwzyyiBsSfYZGk+lcsjq2JGnl7VWH2TdPWGWdo/2OSsq5SEETJXplsYDltAAJ4QBZAtJnHE3BRBNGIsWbhub+u9EXpKs+g66eM3mScwBMKRvh3aXatC2X4TIKdE4G8D67Px5dNj3dAi4x8lJSHqE=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(376002)(136003)(39860400002)(451199018)(36840700001)(46966006)(40470700004)(2906002)(26005)(186003)(16526019)(41300700001)(356005)(82740400003)(44832011)(6666004)(1076003)(81166007)(2616005)(7416002)(5660300002)(36860700001)(7406005)(8936002)(478600001)(316002)(40460700003)(86362001)(70206006)(70586007)(6916009)(8676002)(4326008)(336012)(82310400005)(47076005)(40480700001)(426003)(36756003)(83380400001)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 19:01:02.3104
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f41b3fd6-8231-470a-4532-08db1374cfb3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7810
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Dionna Glaze <dionnaglaze@google.com>

Update the KVM_MEMORY_ENCRYPT_OP documentation to include the new
commands for overriding the host certificates that the guest receives
from an extended guest request.

Cc: Thomas Lendacky <Thomas.Lendacky@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>

Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 .../virt/kvm/x86/amd-memory-encryption.rst    | 44 +++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index dafb0c9984f1..153003ff2c51 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -537,6 +537,50 @@ Returns: 0 on success, -negative on error
 
 See SEV-SNP specification for further details on launch finish input parameters.
 
+22. KVM_SEV_SNP_GET_CERTS
+-------------------------
+
+After the SNP guest launch flow has started, the KVM_SEV_SNP_GET_CERTS command
+can be issued to request the data that has been installed with the
+KVM_SEV_SNP_SET_CERTS command.
+
+Parameters (in/out): struct kvm_sev_snp_get_certs
+
+Returns: 0 on success, -negative on error
+
+::
+
+	struct kvm_sev_snp_get_certs {
+		__u64 certs_uaddr;
+		__u64 certs_len
+	};
+
+If no certs have been installed, then the return value is -ENOENT.
+If the buffer specified in the struct is too small, the certs_len field will be
+overwritten with the required bytes to receive all the certificate bytes and the
+return value will be -EINVAL.
+
+23. KVM_SEV_SNP_SET_CERTS
+-------------------------
+
+After the SNP guest launch flow has started, the KVM_SEV_SNP_SET_CERTS command
+can be issued to override the /dev/sev certs data that is returned when a
+guest issues an extended guest request. This is useful for instance-specific
+extensions to the host certificates.
+
+Parameters (in/out): struct kvm_sev_snp_set_certs
+
+Returns: 0 on success, -negative on error
+
+::
+
+	struct kvm_sev_snp_set_certs {
+		__u64 certs_uaddr;
+		__u64 certs_len
+	};
+
+The certs_len field may not exceed SEV_FW_BLOB_MAX_SIZE.
+
 References
 ==========
 
-- 
2.25.1

