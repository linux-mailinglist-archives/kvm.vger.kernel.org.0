Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1656C7CAA01
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 15:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233508AbjJPNmr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 09:42:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233749AbjJPNmn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 09:42:43 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2080.outbound.protection.outlook.com [40.107.93.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A141B5;
        Mon, 16 Oct 2023 06:42:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FD08Z9Qhnwr7ob4n5Pk4O+vtyCtR3uzH2bRfVRinX06TarBsX+A89ifaSCnqE6S5chepdEu4lrbWBbLNWBvd6JMj2TbdX/VuzTNPl0lx1exlyBdDI57/tgvNo5zFirEZI9lar9CdDsJ/SowqadEXCo4hQKPAO5H9iGPpnf7lW2f5u71s9nMfYPzOQNLnBOozQ9vM9cYWi+Jx7mjP78KtBdUKCcgHCFgfMzAk7Ftdu00+SO7HL4Fh2mGoH7mHwWKHjg8QpzMNPoBf2xnZqMTMeNyelOTnzD79Qm3sTD76jV6/eHElx1j7Ss3AzZ2bJLMZHP7tuGYcK3rHjXSIhMAdXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=taEAnXAx4AHIhFKtNmiIBrEk5Qj5RWdX2hupeZhmCl4=;
 b=dB+Kqbm2PjTh/gbwagKMmSUwl0JdPeW7RtRTyhuUQEWXLZyMIvpuL+ZRDhhaZFB9c5zJVGJ5+gHv7Q9bdbX49jlB5XEWqgk5CkB0aFarz+Z9W8dYu6ybWHkaQfsaaaagBYo5rQ8VZPcucnZP0TmzhnuQhdQZ4MJxxRL2LauAZXouBIaSksTFGjJEPEOruI7G5FDWnRTTANZcP53emQsAAI6AncmrOCCiUVgNs6CJz3kDuCE49eB1BWYCBu01HZB2qqTSYOO/3xhObu7qLoSDRgqvnhYQj1ErJpDgSiKcf3WPGzWoyCAaADx3K30vSqqLOU7Nh5lhcio7zn3+7Ypv8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=taEAnXAx4AHIhFKtNmiIBrEk5Qj5RWdX2hupeZhmCl4=;
 b=IE9R83fQKzE/o+7mWjqLdx5SoZKOk0l+g0ZRnbyVPu7TAfURe33uz8bckEVjkXb9FeV9ukzAe6TbTeL7O0w7bcn+f9ievDxMvYHslr2cXhg6ltqw6EboWoA3OuVkk58T8jSogmegmpi6IuyOmpjhQPOt/Gd7+8mDZe7yrRQIU8I=
Received: from PH7PR17CA0066.namprd17.prod.outlook.com (2603:10b6:510:325::15)
 by SJ2PR12MB8111.namprd12.prod.outlook.com (2603:10b6:a03:4fe::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Mon, 16 Oct
 2023 13:42:33 +0000
Received: from SN1PEPF000252A1.namprd05.prod.outlook.com
 (2603:10b6:510:325:cafe::87) by PH7PR17CA0066.outlook.office365.com
 (2603:10b6:510:325::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35 via Frontend
 Transport; Mon, 16 Oct 2023 13:42:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF000252A1.mail.protection.outlook.com (10.167.242.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Mon, 16 Oct 2023 13:42:33 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 16 Oct
 2023 08:42:32 -0500
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
        <alpergun@google.com>, <jarkko@kernel.org>, <ashish.kalra@amd.com>,
        <nikunj.dadhania@amd.com>, <pankaj.gupta@amd.com>,
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
Subject: [PATCH v10 38/50] KVM: SEV: Add support for GHCB-based termination requests
Date:   Mon, 16 Oct 2023 08:28:07 -0500
Message-ID: <20231016132819.1002933-39-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231016132819.1002933-1-michael.roth@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A1:EE_|SJ2PR12MB8111:EE_
X-MS-Office365-Filtering-Correlation-Id: b8f739cc-04f1-4473-7819-08dbce4dc00f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cu3L7Sif8VPbMyA+ubp1eBadBHxnIsJXI1PmXa+d6RwjhsjkPA2lrugmGNGZ7lLwBnmRZDMaLEosHMqpwWlSPQ2e1C/PhlcQeNMAbN9dVKRL7TosdEkU6GT0Tm+SN5TKdzYrJSy2K/4dY/qs7XfQ+mVRtahbGQtLM3ojQ3W9X/jMxRY9xtGsv1AImNS/XOev7obx6g1llrJgwngOoMQDHYwSUP2e60x7r/yh29UYc354XJq0MjehM0kRCVFkriubp/rtbRupcb+fpbFQVbgaIvlkvCLvm+Ld7LHdvI65vJaCk2wOd7eoLX6fVTxW7zJj1qHNFPW/t3r92d2NigtLoYceW6NfVaZpJ9fYw1nUuyX+pq+zaIofycXDpRHIKch6UHFOEHugDMW22UZquyRGrzs6+kcQaWgGyxa5nB0tIWvnO66GRE/C1oBju9DNqIwtQNx4ueTw7Za+bL+Jp9KIRVTCAHnwdtG5uMxfso43o1poT/Nc/ZV5L37pAbecU6WTLCxEQ6InzB1lWo7sCiMW4yaTWypFHpM9pp+YNtoe2LY58A/rjj0+qGrFAM9rQbJEWa8haYTdGzLmdQzdilTwShyCUH844P4wDJsTPsyXS46nSHW7YrQlym6ToWysnB27atVUcUTK5EivaXE5vfqM0vjxA+NSxg/43iXf0ASBvXbbLJTYUcVaO9Irg9MvJQViAx+HEw1lmR1nChj12AMM+ZEe0TFprnaVe+nZEnxhDK7EXnunR3VPIZexeUDUMLk4/SviQKkQrNnp+5Zev/RTfA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(136003)(376002)(39860400002)(396003)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(82310400011)(46966006)(36840700001)(40470700004)(40460700003)(40480700001)(36860700001)(82740400003)(356005)(47076005)(83380400001)(81166007)(6666004)(16526019)(26005)(36756003)(70586007)(70206006)(54906003)(316002)(6916009)(478600001)(1076003)(426003)(336012)(2616005)(41300700001)(44832011)(7416002)(7406005)(86362001)(2906002)(5660300002)(8936002)(8676002)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 13:42:33.2318
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b8f739cc-04f1-4473-7819-08dbce4dc00f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF000252A1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8111
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

GHCB version 2 adds support for a GHCB-based termination request that
a guest can issue when it reaches an error state and wishes to inform
the hypervisor that it should be terminated. Implement support for that
similarly to GHCB MSR-based termination requests that are already
available to SEV-ES guests via earlier versions of the GHCB protocol.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index e547adddacfa..9c38fe796e00 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3094,6 +3094,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 	case SVM_VMGEXIT_HV_FEATURES:
 	case SVM_VMGEXIT_PSC:
+	case SVM_VMGEXIT_TERM_REQUEST:
 		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
@@ -3762,6 +3763,14 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 
 		ret = 1;
 		break;
+	case SVM_VMGEXIT_TERM_REQUEST:
+		pr_info("SEV-ES guess requested termination: reason %#llx info %#llx\n",
+			control->exit_info_1, control->exit_info_1);
+		vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
+		vcpu->run->system_event.type = KVM_SYSTEM_EVENT_SEV_TERM;
+		vcpu->run->system_event.ndata = 1;
+		vcpu->run->system_event.data[0] = control->ghcb_gpa;
+		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
-- 
2.25.1

