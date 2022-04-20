Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1A50508C70
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 17:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380333AbiDTPxI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 11:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380320AbiDTPxH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 11:53:07 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2063.outbound.protection.outlook.com [40.107.243.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8343C33A1C;
        Wed, 20 Apr 2022 08:50:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GDtpN5w8RM3eAtKTO1QqNdTk0qm+e7Hjet7b8Oba/6YAgrY7IwnLt2VfjUE+neKtWeRdlfY/qwwQcOTZpoOZFgG7Fb57aRV+hC53BQpH8mYYnn7CH7Y/UKXM7O5LKbJWUYT2WbfHQj1GLnWvlsa+gZG0MqU+QJXiA/bTLp7ubHd7w3GdHjwUsWN7vV7JsKwYIXCXBmxJwb2s7I8laOUVuZeQ7zK4ULdTZgAx5b+GxZMupvkcGB8XFbutCzdQjxdbhCcFpk+zvFytWnpwGtbwddjKHJvTovY6S0LDvFjZnc81GSqi5FYcNnjIN8sF4pwTWq7ayilGRDk+MNbWIvmBDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XFhc4jiKjROsxKTnTcg1HMiPEk9V6yPx384bmk/m6QU=;
 b=jZ70fHtjsm8zFG+DzDDovW+08A5HHp6VTmiVqBUgRgpYRU0ivYvuPiS+zKgSohG/9ICfCBOBOV9nCCCatlAt7zH5+I6EbFwPMaLC5EagD4QHmwBIUkzzFhlGPIRCcK+0LAWWk8YIyEdGqzTI2LDijRkw/OOx4f8UnFwlGgFrBQV8a7JqAAr0kMoP4ybzT9WmivkHvYwptPNCOlbCPwt/kIyoZzgdodEPGaHL66JyjDStsE4ebXl+OpGKZz6dSAzUvjFuZL8uiXVIyPRRHWoBelB9kSY66E4ZumfGo5yRtP5Dk8A8EisRhGDLQNS1h3z76qPI9KOXRFHIZrOhYtUObw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XFhc4jiKjROsxKTnTcg1HMiPEk9V6yPx384bmk/m6QU=;
 b=Z6KhDnC8Rjp/v5XOIbffuXJ6QXwzqnUyOOM8lcgFLfsHWK+53pEzflJVwWmkEf80tyTCZjfc0i2SbvdL3jQBH/L64GJz8Z642uNviaXdkNzriXs8jdhP42w+axJoSy2SXGwki4B1lLZcNjk1U2/zkF26OzGILIp5nE5oUPXegIw=
Received: from MW4P222CA0028.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::33)
 by DM5PR12MB1194.namprd12.prod.outlook.com (2603:10b6:3:6e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Wed, 20 Apr
 2022 15:50:17 +0000
Received: from CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:114:cafe::59) by MW4P222CA0028.outlook.office365.com
 (2603:10b6:303:114::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20 via Frontend
 Transport; Wed, 20 Apr 2022 15:50:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT018.mail.protection.outlook.com (10.13.175.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5186.14 via Frontend Transport; Wed, 20 Apr 2022 15:50:16 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 20 Apr
 2022 10:50:14 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 1/2] KVM: SVM: Use target APIC ID to complete AVIC IRQs when possible
Date:   Wed, 20 Apr 2022 10:49:53 -0500
Message-ID: <20220420154954.19305-2-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220420154954.19305-1-suravee.suthikulpanit@amd.com>
References: <20220420154954.19305-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8453e13-92f3-43b6-b52f-08da22e57711
X-MS-TrafficTypeDiagnostic: DM5PR12MB1194:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1194A753AA2369992481C321F3F59@DM5PR12MB1194.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /6srvuzmXMdNn3mLDKR0ltPvoHjDquLkeSK7EVkrq4HQm3LFQFcmH8G45ilYMIGA8BA5tsjjSxeO6yqcHz6AOOGUSBibP1Laf3wZbB0DFXs/qFmOQUqc0Xl00HiXtW+LXKA0h1IQ+UsftVmD6xkvFQndFtWD3Nw6+HP75MLYIOwRNNDI9qeTEsBCzwI/Qtq2agZIXtqNG4GwAQG/1jxmHs01nGgclrOthD2CIa4wCAzVUSsXONhDt2rc5Ptb6KDzRpNizhwBhhChtLveGz1spq5s4r8rGN4B7DkoaBhKhISgPkj5yAj5iKQmanSTsEzQa3pjVsdG1iwv71PcbC97lb0b32grbUatAzQ5bSrpCei7OlQkLfJC5Hjo6ZleQxkmuaYT87l5t4G+Gqj7wcdWe+lrt//pGNTD5pYajrtjXtoHrTOhx0rCLb0untLEJSBkicF+z551NrrrcqZ5tFC2hGvkxGNbzpuSwXpB5YciNifsqlDjsLsrmycL6T6BNAtLnDSLZf4Ynxfw8yl/sAHolk3OrSCD6N0+gUYjnQKaahBwtnHT++YQDdxaSN3yxNmag04+tp41+O4BMrkpSF0t7ma3A4ZI5hamqQHexWNt5WGuIaLEy2bsOTht7Wr8BW4DEGa+hvNXUpVvFy7HRf9CY9Otdcud/BfXN+HzDH7vIo4Z8iEIfOjhdP4syJ1uqgOiEQ1lmcqQxz4Rop9SO3bd9g==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(1076003)(110136005)(316002)(16526019)(186003)(83380400001)(44832011)(8936002)(36756003)(5660300002)(2616005)(82310400005)(54906003)(426003)(336012)(47076005)(2906002)(26005)(6666004)(70586007)(70206006)(7696005)(81166007)(508600001)(40460700003)(8676002)(36860700001)(86362001)(356005)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2022 15:50:16.4975
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a8453e13-92f3-43b6-b52f-08da22e57711
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1194
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, an AVIC-enabled VM suffers from performance bottleneck
when scaling to large number of vCPUs for I/O intensive workloads.

In such case, a vCPU often executes halt instruction to get into idle state
waiting for interrupts, in which KVM would de-schedule the vCPU from
physical CPU.

When AVIC HW tries to deliver interrupt to the halting vCPU, it would
result in AVIC incomplete IPI #vmexit to notify KVM to reschedule
the target vCPU into running state.

Investigation has shown the main hotspot is in the kvm_apic_match_dest()
in the following call stack where it tries to find target vCPUs
corresponding to the information in the ICRH/ICRL registers.

  - handle_exit
    - svm_invoke_exit_handler
      - avic_incomplete_ipi_interception
        - kvm_apic_match_dest

However, AVIC provides hints in the #vmexit info, which can be used to
retrieve the destination guest physical APIC ID.

In addition, since QEMU defines guest physical APIC ID to be the same as
vCPU ID, it can be used to quickly identify the target vCPU to deliver IPI,
and avoid the overhead from searching through all vCPUs to match the target
vCPU.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 72 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 68 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 421619540ff9..c8b8a0cb02b0 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -285,11 +285,75 @@ void avic_ring_doorbell(struct kvm_vcpu *vcpu)
 	put_cpu();
 }
 
-static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
-				   u32 icrl, u32 icrh)
+/*
+ * A fast-path version of avic_kick_target_vcpus(), which attempts to match
+ * destination APIC ID to vCPU without looping through all vCPUs.
+ */
+static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source,
+				       u32 icrl, u32 icrh, u32 index)
 {
+	u32 dest, apic_id;
 	struct kvm_vcpu *vcpu;
+	int dest_mode = icrl & APIC_DEST_MASK;
+	int shorthand = icrl & APIC_SHORT_MASK;
+	struct kvm_svm *kvm_svm = to_kvm_svm(kvm);
+	u32 *avic_logical_id_table = page_address(kvm_svm->avic_logical_id_table_page);
+
+	if (shorthand != APIC_DEST_NOSHORT)
+		return -EINVAL;
+
+	/*
+	 * The AVIC incomplete IPI #vmexit info provides index into
+	 * the physical APIC ID table, which can be used to derive
+	 * guest physical APIC ID.
+	 */
+	if (dest_mode == APIC_DEST_PHYSICAL) {
+		apic_id = index;
+	} else {
+		if (!apic_x2apic_mode(source)) {
+			/* For xAPIC logical mode, the index is for logical APIC table. */
+			apic_id = avic_logical_id_table[index] & 0x1ff;
+		} else {
+			return -EINVAL;
+		}
+	}
+
+	/*
+	 * Assuming vcpu ID is the same as physical apic ID,
+	 * and use it to retrieve the target vCPU.
+	 */
+	vcpu = kvm_get_vcpu_by_id(kvm, apic_id);
+	if (!vcpu)
+		return -EINVAL;
+
+	if (apic_x2apic_mode(vcpu->arch.apic))
+		dest = icrh;
+	else
+		dest = GET_APIC_DEST_FIELD(icrh);
+
+	/*
+	 * Try matching the destination APIC ID with the vCPU.
+	 */
+	if (kvm_apic_match_dest(vcpu, source, shorthand, dest, dest_mode)) {
+		vcpu->arch.apic->irr_pending = true;
+		svm_complete_interrupt_delivery(vcpu,
+						icrl & APIC_MODE_MASK,
+						icrl & APIC_INT_LEVELTRIG,
+						icrl & APIC_VECTOR_MASK);
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
+				   u32 icrl, u32 icrh, u32 index)
+{
 	unsigned long i;
+	struct kvm_vcpu *vcpu;
+
+	if (!avic_kick_target_vcpus_fast(kvm, source, icrl, icrh, index))
+		return;
 
 	/*
 	 * Wake any target vCPUs that are blocking, i.e. waiting for a wake
@@ -316,7 +380,7 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
 	u32 icrh = svm->vmcb->control.exit_info_1 >> 32;
 	u32 icrl = svm->vmcb->control.exit_info_1;
 	u32 id = svm->vmcb->control.exit_info_2 >> 32;
-	u32 index = svm->vmcb->control.exit_info_2 & 0xFF;
+	u32 index = svm->vmcb->control.exit_info_2 & 0x1FF;
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
 	trace_kvm_avic_incomplete_ipi(vcpu->vcpu_id, icrh, icrl, id, index);
@@ -343,7 +407,7 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
 		 * set the appropriate IRR bits on the valid target
 		 * vcpus. So, we just need to kick the appropriate vcpu.
 		 */
-		avic_kick_target_vcpus(vcpu->kvm, apic, icrl, icrh);
+		avic_kick_target_vcpus(vcpu->kvm, apic, icrl, icrh, index);
 		break;
 	case AVIC_IPI_FAILURE_INVALID_TARGET:
 		break;
-- 
2.25.1

