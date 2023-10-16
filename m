Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE7767CA9D6
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 15:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233897AbjJPNjh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 09:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233860AbjJPNjP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 09:39:15 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2077.outbound.protection.outlook.com [40.107.212.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC3FD19F;
        Mon, 16 Oct 2023 06:39:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O6naHw8Glf/9Mfz807f1+/mj1U+fSJbDQxzkD5lGqXzzPYlgUrZcEqtCiDjJoJD/0w+xtPJkQLA97e9CL/8PWi07VqTHfsybASZ1vLWTza/0b0089fg+Ga0UcvdjCGUL4hmhCSxB/qmWq4oo6e5bWESV2uNurxDwOsUSz668eW2iBJxHDvi+76JaV0MrDfPG2plTd0XkW0gDRftYZg6xZNM3W/4D2Prt6dZTKXplLW/F5pmKt/yX0j9YMT2QCF9Unwph3AhJHqJjIH8ESZ+4e5B4U97zdfbl6tK7a1dtWt7RN5cSLwnXV/Ro/rfFLARfwAuaexPYu8sAQMA2bftWLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SHw1h6ViRdUzmCcT0hkWmDqDj8ovX0I1Wzl+XULPlrc=;
 b=aFqpyCTFYimWf3TdiWMy9O/ytMcPb9kxXU99HonjF3dPESfIu1s/Hig9xHYM2Zo2WLc/IUBRdvCjgo7RIO/HPqZaq0vp7Pl/Vn/K1xdo2az+YYaO+ZUdnjbffMZLQ+DIq+m7O0b85axpaIBVivD3hva6DEOpNLlH4pZ4bbw6pIB1VvQjrK+mKRrb+4zUdCReD3NrlDhEqvnqeILa5DLpEv+NiAcp0Ig08uxLiq2eBHC+D68s6FnRkz3EzLs6OvwTXB/Onz4EaVZ1RoVKIBsgLIe5ymWX2VDwN+9Jd0kSHlGE+wB8nRfD4CpcXaeDBkhWFh+q+F5GKa8igoSZ3g+kIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SHw1h6ViRdUzmCcT0hkWmDqDj8ovX0I1Wzl+XULPlrc=;
 b=ykQlUkyCiW4TZAXfGUrxrO76sDgzTRw13322D9BnUUqMM3QtEj/sV6URDnF93+vXqgyMIFEKBUcwlgMIfT4YiuWxitJrTyuTxFJQpUmylpvBpwSAYdL2Kuz+0Xvs6xJf0Wby+kECwrukDWn0drpxBIpJEAyibeqJBK6fbuqqoqs=
Received: from MN2PR19CA0022.namprd19.prod.outlook.com (2603:10b6:208:178::35)
 by SJ0PR12MB6832.namprd12.prod.outlook.com (2603:10b6:a03:47e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.45; Mon, 16 Oct
 2023 13:39:10 +0000
Received: from BL02EPF0001A0FF.namprd03.prod.outlook.com
 (2603:10b6:208:178:cafe::c5) by MN2PR19CA0022.outlook.office365.com
 (2603:10b6:208:178::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.34 via Frontend
 Transport; Mon, 16 Oct 2023 13:39:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0001A0FF.mail.protection.outlook.com (10.167.242.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Mon, 16 Oct 2023 13:39:09 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 16 Oct
 2023 08:39:09 -0500
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
Subject: [PATCH v10 31/50] KVM: SEV: Add KVM_EXIT_VMGEXIT
Date:   Mon, 16 Oct 2023 08:28:00 -0500
Message-ID: <20231016132819.1002933-32-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FF:EE_|SJ0PR12MB6832:EE_
X-MS-Office365-Filtering-Correlation-Id: eb41732a-1e0d-4e80-e6c9-08dbce4d46bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a3XoBNJ1O9oUpJ2xHQKDpcTNENU3Pqlc4IbGKyHfPNwv/vABvz6kQAbY3vjiTYmYw5qn2O1nWtU4DNdUV0iKmYI1nyQaTvGmuOPzZD4HEM/QQhNLMddF6M5P/1E6kccH6gUk+3MwAgKpzIspBrfxp6jayRwJbn83s5YL5jIRShuu6mwxx1JobiavVTMXVp0IRqrB1Y6x98tPGhnh31T65JKZKfe3tmD1aCPlA5U3fkfVMKxgHTPNGnOcHkElVamF40P/VeFHj7nQTLvs8Wllvbo6lSPEntKhX+2nMzt0sI1j8t0hzjQ6uZc8KCI8zDJywjUsfzWOduSiHlYa5qVTefQqMsfrAjyNm1EZb82XPLNmmGMP+H+DuIFPyOz0EEgyoPSJKn3xGE7oScLUzn+tZYDMx32cVhj30lQ/sx5ICeXGrJJO0xhVFD74+UVgmvr+5lltoK+gxusbosIlv058v/jMJ71qYJJbiVqQm9aGbf+hXZuPGYlJ10K4LuTA39gvPjPCs59AgZ9JTiSqDPAxWsyDNLrYsL7mpwDyrPKQTyNQ9fc6QckXVYuAtm49O7DpNmGp45gbbF1jioat0YO3SgFqNU7HcLTMrxRs9QfiNNXva0/p6YubyWvSznM8oD1pYVjkmV2DaWT6MW+8NI6HqEO5CpfWNauEYAegT9q/12UXQrK3qXbz1l2S3sa5sM45P0Vxg+o7ExJ/d6U9bDoQZb3bzq/p+rMiVz0y1mmWCJ9Xylt+yJAoKiU7hIf7vZej/viSOI8HW4+O6YkUi7p8hg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(136003)(39860400002)(376002)(346002)(230922051799003)(451199024)(82310400011)(64100799003)(1800799009)(186009)(46966006)(40470700004)(36840700001)(40480700001)(26005)(16526019)(81166007)(336012)(40460700003)(426003)(2616005)(8676002)(82740400003)(8936002)(356005)(4326008)(5660300002)(44832011)(86362001)(7416002)(2906002)(6666004)(6916009)(70206006)(70586007)(7406005)(41300700001)(1076003)(316002)(54906003)(36756003)(478600001)(36860700001)(47076005)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 13:39:09.4676
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eb41732a-1e0d-4e80-e6c9-08dbce4d46bc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF0001A0FF.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6832
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For private memslots, GHCB page state change requests will be forwarded
to userspace for processing. Define a new KVM_EXIT_VMGEXIT for exits of
this type, as well as other potential userspace handling for VMGEXITs in
the future.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 Documentation/virt/kvm/api.rst | 34 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h       |  6 ++++++
 2 files changed, 40 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 5e08f2a157ef..e84c62423ab7 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6847,6 +6847,40 @@ Please note that the kernel is allowed to use the kvm_run structure as the
 primary storage for certain register types. Therefore, the kernel may use the
 values in kvm_run even if the corresponding bit in kvm_dirty_regs is not set.
 
+::
+
+		/* KVM_EXIT_VMGEXIT */
+		struct {
+			__u64 ghcb_msr; /* GHCB MSR contents */
+			__u64 ret;      /* user -> kernel return value */
+		} memory;
+
+If exit reason is KVM_EXIT_VMGEXIT then it indicates that an SEV-SNP guest has
+issued a VMGEXIT instruction (as documented by the AMD Architecture
+Programmer's Manual (APM)) to the hypervisor that needs to be serviced by
+userspace. This is generally handled via the Guest-Hypervisor Communication
+Block (GHCB) specification. The value of 'ghcb_msr' will be the contents of
+the GHCB MSR register at the time of the VMGEXIT, which can either be the GPA
+of the GHCB page for page-based GHCB requests, or an encoding of an MSR-based
+GHCB request. The mechanism to distinguish between these two and determine the
+type of request is the same as what is documented in the GHCB specification.
+
+Not all VMGEXITs or GHCB requests will be forwarded to userspace. Currently
+this will only be the case for "SNP Page State Change" requests (PSCs), and
+only for the subset of these which involve actual shared <-> private
+transition. Userspace is expected to process these requests in accordance
+with the GHCB specification and issue KVM_SET_MEMORY_ATTRIBUTE ioctls to
+perform the shared/private transitions.
+
+GHCB page-based PSC requests require returning a 64-bit return value to the
+guest via the SW_EXITINFO2 field of the vCPU's VMCB structure, as documented
+in the GHCB. Userspace must set 'ret' to what the GHCB specification documents
+the SW_EXITINFO2 VMCB field should be set to after processing a PSC request.
+
+For MSR-based PSC requests, userspace must set the value of 'ghcb_msr' to be
+the same as what the GHCB specification documents the actual GHCB MSR register
+should be set to after processing a PSC request.
+
 
 6. Capabilities that can be enabled on vCPUs
 ============================================
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 6f7b44b32497..3af546adb962 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -279,6 +279,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_RISCV_CSR        36
 #define KVM_EXIT_NOTIFY           37
 #define KVM_EXIT_MEMORY_FAULT     38
+#define KVM_EXIT_VMGEXIT          50
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -525,6 +526,11 @@ struct kvm_run {
 #define KVM_NOTIFY_CONTEXT_INVALID	(1 << 0)
 			__u32 flags;
 		} notify;
+		/* KVM_EXIT_VMGEXIT */
+		struct {
+			__u64 ghcb_msr; /* GHCB MSR contents */
+			__u64 ret; /* user -> kernel */
+		} vmgexit;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
-- 
2.25.1

