Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E784F64D082
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 21:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbiLNT7d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 14:59:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbiLNT6b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 14:58:31 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2077.outbound.protection.outlook.com [40.107.223.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E132C120;
        Wed, 14 Dec 2022 11:55:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZeaZ+oNdBIxiXtWJr+dQx3cF4MKN8FuZ3b5rWFZYfMumDerK5fRYaBRTU1L+shXhxQdi0sJXFLkhasnoIwDhe6aqDKcCvBt7p2fe1gBBHzT4hV+6GyGIcrCt68BJs8sez4+qSq0Ui7iZdfFvXtuDhIgVR0snG1ENFqqsfkMVINEV4fHxYD9YZ5z3rvz3LCLTH8AY7ozV+MM2QG4nXIxh9HimLpqWGT24z7z1eCYjZOtcpet/wYiVmhDddPX5EAQHhbafFYrtd2HeCCjLkj8Un/7N5f0zK7QV+sZPA8xqdtWX+0/rSFUIdx2oLQ6f2CH6ZJf+CMjPvKTj655U5t2e1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j1/j0Qnnz3MPT8azUqqfnGGNMOaoM2mT2vdZ1g+r6s0=;
 b=baRPEDtregsH1hTv03uyhcSBtpQqkRwhBHOqY0yWdbBcV99HJhvTWLjznughAn9lsdlCbyYJMuwqYxBufHpCH9b3PeAfz3kqxyLaH9v5QF86oSN8ziNbjrMv2RP4WCa4N1I1kb3qTBlmrQuwdWm3RAKkUKwEtNmndI+t6fZIQIbBqMaid0kpcR2Z+eeY833siL5Wm0o0w2xzkjL7m8Sjs4zDO+U7u4Wq6iMfBd9U66E237rLbQoNYJ4N35ib/JL0CuPjAmj7pb+WLej+AAPuBs0kGFPolRQ6ffFsRG53vrTPo4t2D02N38LTR/6YjXMU9XcBaiAtEDgdpRB29sKf/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j1/j0Qnnz3MPT8azUqqfnGGNMOaoM2mT2vdZ1g+r6s0=;
 b=eJ22hGllH+u660sRa2M5tdZkZykX0xx5+ztW2AIoUoft452z6Q/mvCjJKUWV1wMBZJTJZE3gdLFCmsKLTRyMMnDpfCEGRQofucCyA9umMihi6T2ma9Z+uata6ci4/1VBTP4p+hCnMGqXx/I/0sNZBZT+b0ssBAm6qBc4IEN8I2g=
Received: from MW4PR04CA0318.namprd04.prod.outlook.com (2603:10b6:303:82::23)
 by SN7PR12MB6909.namprd12.prod.outlook.com (2603:10b6:806:263::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Wed, 14 Dec
 2022 19:55:08 +0000
Received: from CO1NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:82:cafe::fd) by MW4PR04CA0318.outlook.office365.com
 (2603:10b6:303:82::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11 via Frontend
 Transport; Wed, 14 Dec 2022 19:55:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT060.mail.protection.outlook.com (10.13.175.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.11 via Frontend Transport; Wed, 14 Dec 2022 19:55:08 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 13:55:07 -0600
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
        <ashish.kalra@amd.com>, <harald@profian.com>
Subject: [PATCH RFC v7 02/64] KVM: x86: Add KVM_CAP_UNMAPPED_PRIVATE_MEMORY
Date:   Wed, 14 Dec 2022 13:39:54 -0600
Message-ID: <20221214194056.161492-3-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT060:EE_|SN7PR12MB6909:EE_
X-MS-Office365-Filtering-Correlation-Id: fcd5f7ff-4cc0-45e8-0ebf-08dade0d1a8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QfTBjlSAW+BeHyMDd2Vio97+Gvm/0YUcxm9lBaEozxID2Io0D0KUd7/WK/uYV5KinKEQL5+BJhvGYHs085XPUrmQRqp7KV5hWguDmp5Qxp6Pekg0MMfHlSNf7q0MFjuDsOsZ9LfJrAv5YUuocJ/bIGfsn8bh/PAosc+rQTEC5929tcMDXizVCsPLD03q+7vbYN8MR9756Q8W8qb+pI9maGjrlL9+3PF5ilBCG27fS9My4AQ3vO3mjfdHDA3F2VzOjl6t4+JBqGzgR2ej8G78wu4ABhOPd5r2oJEQKBLBVkXqITemEibAjUfqD6JinLp1vlbEIWSfksDfvkxYABpmUlqkfduyOUtXL19dKLRyBOQgatgzXDmBx9gpr3hl239w+/qODqwVd2yE7Ib3S8PeHh2JLxeCNT0IkTJNHPXm8ajP9Tq7rHQASA2uYaD00jirX+mPiYvGGnzt4oG1A7fnk/cm+YJOExab8rEkGGyLh2cMLPfDv+o2BRMvTfiRoXlHthg0Sq9TZdvbZHTRfPk1BqWbDk08FDM/hg/li88zjvbRDvCNfeW4FSGxNyPp0Sk90lkvJzfnMyO+CRa+U/HLuReARPVuu4VoNFzllBxHG5mpK37MvYSvbUi3OldKzrjw55ETW7ZA/5tnHUekCtM8IZYcf+gH3VnxRDngxONcNMF+Mj80wMyt9k8BHFoxXS0rO+afztitoxjIu+w1jOD2rmfthpWLAYnmRqSS466TaBc=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(376002)(39860400002)(136003)(451199015)(40470700004)(46966006)(36840700001)(36756003)(40460700003)(41300700001)(478600001)(82310400005)(86362001)(81166007)(36860700001)(82740400003)(40480700001)(356005)(426003)(47076005)(336012)(1076003)(16526019)(66899015)(316002)(70206006)(83380400001)(6916009)(8676002)(5660300002)(6666004)(70586007)(54906003)(4326008)(26005)(44832011)(186003)(2616005)(8936002)(7406005)(7416002)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 19:55:08.6398
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fcd5f7ff-4cc0-45e8-0ebf-08dade0d1a8e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6909
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This mainly indicates to KVM that it should expect all private guest
memory to be backed by private memslots. Ideally this would work
similarly for others archs, give or take a few additional flags, but
for now it's a simple boolean indicator for x86.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +++
 arch/x86/kvm/x86.c              | 10 ++++++++++
 include/uapi/linux/kvm.h        |  1 +
 3 files changed, 14 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 27ef31133352..2b6244525107 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1438,6 +1438,9 @@ struct kvm_arch {
 	 */
 #define SPLIT_DESC_CACHE_MIN_NR_OBJECTS (SPTE_ENT_PER_PAGE + 1)
 	struct kvm_mmu_memory_cache split_desc_cache;
+
+	/* Use/enforce unmapped private memory. */
+	bool upm_mode;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c67e22f3e2ee..99ecf99bc4d2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4421,6 +4421,11 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_EXIT_HYPERCALL:
 		r = KVM_EXIT_HYPERCALL_VALID_MASK;
 		break;
+#ifdef CONFIG_HAVE_KVM_MEMORY_ATTRIBUTES
+	case KVM_CAP_UNMAPPED_PRIVATE_MEM:
+		r = 1;
+		break;
+#endif
 	case KVM_CAP_SET_GUEST_DEBUG2:
 		return KVM_GUESTDBG_VALID_MASK;
 #ifdef CONFIG_KVM_XEN
@@ -6382,6 +6387,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		}
 		mutex_unlock(&kvm->lock);
 		break;
+	case KVM_CAP_UNMAPPED_PRIVATE_MEM:
+		kvm->arch.upm_mode = true;
+		r = 0;
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -12128,6 +12137,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm->arch.default_tsc_khz = max_tsc_khz ? : tsc_khz;
 	kvm->arch.guest_can_read_msr_platform_info = true;
 	kvm->arch.enable_pmu = enable_pmu;
+	kvm->arch.upm_mode = false;
 
 #if IS_ENABLED(CONFIG_HYPERV)
 	spin_lock_init(&kvm->arch.hv_root_tdp_lock);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index c7e9d375a902..cc9424ccf9b2 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1219,6 +1219,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_DIRTY_LOG_RING_ACQ_REL 223
 #define KVM_CAP_S390_PROTECTED_ASYNC_DISABLE 224
 #define KVM_CAP_MEMORY_ATTRIBUTES 225
+#define KVM_CAP_UNMAPPED_PRIVATE_MEM 240
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.25.1

