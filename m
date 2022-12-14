Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 435F964D0FE
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 21:19:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbiLNUTq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 15:19:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbiLNUTB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 15:19:01 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2072.outbound.protection.outlook.com [40.107.100.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E6AFD0F;
        Wed, 14 Dec 2022 12:07:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PffBtNm14sTdFQJm5LQhkHiV4jLou0ajrCU3GRbrlYityg1zooHioCPnxUcUQgbph71MgdRpyPmCLc1NFa8p/kYubAAPCXS1lcRFh+Jb0TIwWfi7ncwTtWc5Ff1JgeaSiV0ZI2//3ekktpN4i1OG8HdIYtd9kjfiiAVo91vV2pioWArF92LpBymYVE5KTiT8OqiNK+wGWBm+d5xHCXS0IXY/b71LGdVHmrZ2GwBimql6q4dOy+KQA5TCIuvrT7zeMOsWGQjQUsHXF6EO0nzFdoUGWo30Tzr7hN8QzR1ce3s4htd1sHRajk+e3i178n14SHBGn/Pp3/XG4VlpJycpBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MQUMBExNxhs8U7TItiZxvWkZDCRmiRb0tzOnKzQnm4k=;
 b=bRpQd2YOWjl137T+SBBTODR5Lq1kCp5BpSEyL4btoHBLGWKqT/mHk8q81Yy/YHg3Ds/gdNReaIPdg64sULd4ubEGhY7bt1JrQomf7eU6IHSjgvl25M7Bbm6vsU4VHfEgaGqcpUhQBxauTVt1TmNS3FyW/Unnd+nceOHOR/hV2pwq3GckX0cNb78TXmWTIdLXQvuHu+XZUM9/ID9X1D8q4tC8jjLhvv3Lf6Eawh+ihHb6Kta/Lv0n2hELkMUpAxO7Fg30Ppw80gWycEmQRn2fD0Y6E3b+1ObpuQhhZZ0YApdN2y6q9Ge4kjE0M9YJ+s+cU0poxoit6HAqh8UXfOEh7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MQUMBExNxhs8U7TItiZxvWkZDCRmiRb0tzOnKzQnm4k=;
 b=j5C3rc3kx24ZrHkmWWJC+5eGKhHob3uCIQIbSBGLVa5OrFhV64+hfPhWcEwjFk/M396jEInScpIOeiFPeHiEujOp0/TpwYKPGWiJN2nXJpltZYag2L5gjfChOCsCmJA8AIaAZ+Ph7er/uMrp+nXt3JkeXM67G7W2gHy5nGMAMYw=
Received: from MW4PR04CA0386.namprd04.prod.outlook.com (2603:10b6:303:81::31)
 by CH2PR12MB4311.namprd12.prod.outlook.com (2603:10b6:610:a8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 20:07:45 +0000
Received: from CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:81:cafe::af) by MW4PR04CA0386.outlook.office365.com
 (2603:10b6:303:81::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11 via Frontend
 Transport; Wed, 14 Dec 2022 20:07:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT030.mail.protection.outlook.com (10.13.174.125) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.11 via Frontend Transport; Wed, 14 Dec 2022 20:07:45 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 14:07:44 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <harald@profian.com>,
        Dionna Glaze <dionnaglaze@google.com>,
        Thomas Lendacky <Thomas.Lendacky@amd.com>
Subject: [PATCH RFC v7 63/64] x86/sev: Document KVM_SEV_SNP_{G,S}ET_CERTS
Date:   Wed, 14 Dec 2022 13:40:55 -0600
Message-ID: <20221214194056.161492-64-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221214194056.161492-1-michael.roth@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT030:EE_|CH2PR12MB4311:EE_
X-MS-Office365-Filtering-Correlation-Id: 057bc176-fb98-4e50-7694-08dade0edd8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DSGd9aBr3Ge2D0VzQnxViKZf0aa9KRxd6mZo0UQbPf+XscEoTQ4t2UJLD92EWj62gVTphF616ESobRSl4U2//dmzZFhiDG5jlYjYN04NvboCJ99ryndKo6mT/lGA67Ow+criYRaCP060x5nFa7Z+ikBM5SnEFyZv4s+mdMPUMInQIesO6OQgaQc8jWDHiOG9on/2wka3B+rN1pfkqF2GHGj86hNu4XEBDj0tqsRRlV4x1sR6ZvuJ+n1l2J5nyJtAHLaZbBoOfnkq4BXFXWkNqP/g7PcfRCqlpT6HOUWZLWCMt2bJoWPt2IOJxFdLjMKYbcJYsbI3OORlI/ZCDLvWN9p9ZtyZaaTOrKZHyCvdkYlUm4jn5uyrrS6qjtD5SlnHP9SWcAXmw+UiYOEzq+Yyl4jU4O/6UUFb3fIvq5iMpmLrxTeX5On8mPa/xTvOZynsm/pD0cjH881x9fJTX3dWYiD1+IDdy7wesgFO4HwTFcUnqX3vMNR5toOEzIn3hiWUtT/Wh89GcT6f+Ha8BpiFPQl0Mgrau4MbVil/fqjp3atcO6puSHZs6G/pu/Am+H0SVNt71L/DFttncbDERM9T5kCVI0YvFCOX/JpXrp71XkazDAcZq28RHhldvW7rvXMaD8Kk13U9KyY1cBY8VZn+veKgrKWVI76soeQ89XInLbu46j25DpIWP2cCZQu7Su0rmDlNFmi1+ra2XhP8ae0qLSrH+tnAYJEW8QMXviS7kjc=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(376002)(39860400002)(346002)(451199015)(40470700004)(46966006)(36840700001)(36756003)(36860700001)(4326008)(70206006)(1076003)(40460700003)(70586007)(8676002)(16526019)(47076005)(2616005)(7406005)(8936002)(41300700001)(426003)(83380400001)(336012)(5660300002)(316002)(54906003)(6916009)(478600001)(186003)(26005)(82310400005)(86362001)(6666004)(7416002)(82740400003)(2906002)(81166007)(356005)(40480700001)(44832011)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 20:07:45.2637
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 057bc176-fb98-4e50-7694-08dade0edd8e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4311
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
index e4b42aaab1de..3cfe7b7cef61 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -536,6 +536,50 @@ Returns: 0 on success, -negative on error
 
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

