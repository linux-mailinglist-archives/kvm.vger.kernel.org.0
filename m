Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6DA976C90E
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 11:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbjHBJLr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 05:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231342AbjHBJLo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 05:11:44 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2055.outbound.protection.outlook.com [40.107.92.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D369273B
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 02:11:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m1dH6KSOW37X+S+OdmtPnzVXGoAgg8EzgyBzGdVPUs79h5pkGIu55A7WPxiPs9GKKzOC2XzaUyCor9m1f0ylAyFfsb5k2HrvPkNWTVKafSU3u/PYRCsfwxswqrzJfZ+20NFUzyLybCv6opYm8j1t3EZ7GgjQ6FA1M5XpxjmYwnB66YEjZnqWnkAdC9oZwE2qyyCroi0ddkJ3lLkIL3WTIPygYVMgT1oFZElKg2wvaY2Rgp5fRqhA/LVGxlM+LgslitQJ3VvjVl3jFqg2gs1j/Sw6N/5qlZ16dfuEfT70NpymLDsnb4GsOP0PInK7ToFvL8VLtZTdCu8q49+wQATBxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x39f8qCw7sVQ2eNfBlK3oYM1eSIILZF+kuC05dwSGsQ=;
 b=lFon9pdugwjiALK0oEMNmJYtFGTpP/DgrXqW7JA8T6sPL1zRPMMYS7tMQ2FUowfBFU1LDsTcfCs+h84bHWxKg/z0mhbcwt976vZ1nnThXMh/A64hfhohBh1KyvAqe/ObV+5WwVkiP2OyySgkIVHdwITY8Gf8BEDCC8q+U73yQLRoOs7KbuNMA9MrGa/ddhkjCdEbMSp1BmDZFzAzRyiPnOTbGg9wRMivraKizledwtEGfYDlLiR3617Cjys+jWtpTj2W4ZoVSpQR03RTxn8y0rC200PIvHy8s5QsrqSYiu4INo86iCiqlOxedHy/LKhDBcr1tCxbWx64Jt9NEjh5gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x39f8qCw7sVQ2eNfBlK3oYM1eSIILZF+kuC05dwSGsQ=;
 b=y/TcEsm0afc/mzGRxW7UlzjE0mShpU522ouDihbC5yId42iz2Pzht1uO5Xi4SymA08u6L+V+EYDD9Ufl7dicZ14K6IC1jzCXvF1VbpMZzsO4iGRJuVZ3qJr5TJmEPodP8KzfZlwlwmxU/AAfq3YGn0KdepKr05pO+DeDvh+9IKI=
Received: from MW4PR03CA0021.namprd03.prod.outlook.com (2603:10b6:303:8f::26)
 by SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.45; Wed, 2 Aug
 2023 09:11:38 +0000
Received: from CO1PEPF000044EF.namprd05.prod.outlook.com
 (2603:10b6:303:8f:cafe::c7) by MW4PR03CA0021.outlook.office365.com
 (2603:10b6:303:8f::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.19 via Frontend
 Transport; Wed, 2 Aug 2023 09:11:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044EF.mail.protection.outlook.com (10.167.241.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6652.19 via Frontend Transport; Wed, 2 Aug 2023 09:11:38 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Wed, 2 Aug
 2023 04:11:35 -0500
From:   Nikunj A Dadhania <nikunj@amd.com>
To:     <kvm@vger.kernel.org>, Sean Christopherson <seanjc@google.com>
CC:     Nikunj A Dadhania <nikunj@amd.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ravi Bangoria <ravi.bangoria@amd.com>
Subject: [PATCH] KVM: SVM: Add exception to disable objtool warning for kvm-amd.o
Date:   Wed, 2 Aug 2023 14:41:07 +0530
Message-ID: <20230802091107.1160320-1-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044EF:EE_|SJ2PR12MB8784:EE_
X-MS-Office365-Filtering-Correlation-Id: 59faa81c-edb0-4eba-d9fa-08db93387a6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y9IAiqlaubuMXrgDQVMIT5WkEySfwcB3hx61LHM2+UpoVGa+T/k2eYLTkc77SjEYNxrakxnQMuLyhwciuk+BTp7izNZpzhpmsGxNOG9LHG/IzB4hy2ixm+haxaYANkIr0cCg/U7kvntVaptb+6tjczMp34ONprrPF2PuzBn04l3IHmc6AuDUoc+A6bFjMrqi1UWwKsq6Fq59XBdW5hJO96QYJnWRkskZsivNNbGJjPD+rnnQpl7X3SIWyfecZ1Q6WkMW3LwsYsXWWlzBZhIyDTJDPS9JBi0aYOj1663Wf3Osq2gZxR1wI7We5xNiLkf/RTJh2cbFDI9bvycSUZVJm4VDl/yJ1kDL0VzkQt0EH33Bxypyjp7o/iKkBF/SW20RgUQa4W6MW4j7dwMg5qdYUdixGEzl1yIVcCVS0z2atUUy86hFMsL8TeE4ukqXlzUeoatz0EoaWmv5vmPtBdWhQyJ/IOHj35z9h4RpeHh86hoIw4qenK1EAlqlzTvqHT1XvP7jDFBuX5CREvMMG/PzSX32vANwPWUcU9Str1w2QHPv7lH/mtu+WFeRv10P7j6z8YhZnh0ylOSYKp1dL2JMfSsGsKZoI5OsidcTTsvzAeMp+SZa6KfTNa3GZo8O+nXmcLDRK4CSDa536u5g4YK8PedouJWVWx0kSgzkYHUyKLLx6wlTx+GeQIJ2hZDHpAFxLz7QLrNET+uGdYxdArOYeO21wD5DHDzQWVQH1eQ7OaHF6dqNKUZ58Fb2W7C4b7ah7dsPUecg4M/24mLtTYSY4w==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(136003)(396003)(376002)(451199021)(82310400008)(36840700001)(40470700004)(46966006)(356005)(83380400001)(36756003)(2616005)(426003)(36860700001)(16526019)(81166007)(26005)(186003)(1076003)(336012)(110136005)(54906003)(82740400003)(7696005)(6666004)(478600001)(47076005)(70206006)(70586007)(40460700003)(41300700001)(4326008)(316002)(8936002)(8676002)(5660300002)(40480700001)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2023 09:11:38.2834
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 59faa81c-edb0-4eba-d9fa-08db93387a6b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF000044EF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8784
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

commit 7f4b5cde2409 ("kvm: Disable objtool frame pointer checking for
vmenter.S") had added the vmenter.o file to the exception list.

objtool gives the following warnings in the newer kernel builds:

  arch/x86/kvm/kvm-amd.o: warning: objtool: __svm_vcpu_run+0x17d: BP used as a scratch register
  arch/x86/kvm/kvm-amd.o: warning: objtool: __svm_sev_es_vcpu_run+0x72: BP used as a scratch register

As kvm-amd.o is a link time object, skipping the kvm-amd.o is not possible
as per the objtool documentation, better to skip the offending functions.

Functions __svm_vcpu_run() and __svm_sev_es_vcpu_run() saves and restores
RBP. Below is the snippet:

    SYM_FUNC_START(__svm_vcpu_run)
        push %_ASM_BP
    <…>
        pop %_ASM_BP
        RET

Add exceptions to skip both these functions. Remove the
OBJECT_FILES_NON_STANDARD for vmenter.o

Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Sean Christopherson <seanjc@google.com>
Reported-by: Ravi Bangoria <ravi.bangoria@amd.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/kvm/Makefile      | 4 ----
 arch/x86/kvm/svm/vmenter.S | 2 ++
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 80e3fe184d17..0c5c2f090e93 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -3,10 +3,6 @@
 ccflags-y += -I $(srctree)/arch/x86/kvm
 ccflags-$(CONFIG_KVM_WERROR) += -Werror
 
-ifeq ($(CONFIG_FRAME_POINTER),y)
-OBJECT_FILES_NON_STANDARD_vmenter.o := y
-endif
-
 include $(srctree)/virt/kvm/Makefile.kvm
 
 kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index 8e8295e774f0..8fd37d661c33 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -289,6 +289,7 @@ SYM_FUNC_START(__svm_vcpu_run)
 	_ASM_EXTABLE(7b, 70b)
 
 SYM_FUNC_END(__svm_vcpu_run)
+STACK_FRAME_NON_STANDARD(__svm_vcpu_run)
 
 /**
  * __svm_sev_es_vcpu_run - Run a SEV-ES vCPU via a transition to SVM guest mode
@@ -388,3 +389,4 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
 	_ASM_EXTABLE(1b, 3b)
 
 SYM_FUNC_END(__svm_sev_es_vcpu_run)
+STACK_FRAME_NON_STANDARD_FP(__svm_sev_es_vcpu_run)
-- 
2.34.1

