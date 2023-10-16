Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E82B87CA9C7
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 15:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234021AbjJPNig (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 09:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233993AbjJPNiO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 09:38:14 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2050.outbound.protection.outlook.com [40.107.102.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B074FD50;
        Mon, 16 Oct 2023 06:38:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n0oL0Rz7ZngNJ8gwnlvW2uk+CmwinHzq0MjorG7oIuuZU5n1zGyngHDuuO63zUSLaydZMGlg7gh6WR5fK9TFtjPvUsHIPsA1zrfxQGI0Io0TxJkeDx0BdGlja99BaXiFmgP8MV7h8cQ4pJQdu3eA/v2l/CNVbKvHU55CprKft+gldoRnjeeI7llkIUoliQkp1tdocQS8Al9TRDjNdYtgd6dofqCOwdrweMaRCA46Jgvim3seQRK9iEX22J15M7WKAsZZSaYfNzLN6itcbxzjT2KH2MWxLslWV++gYUg/BvwQ7/yJZKlgEkzMTvqnSTU2A/qkqStSlYH5rYvSc7uBrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xPoTfOaMRNZg6OigKjxanh/Aj0Aw8yC/W7KGEK4NiIk=;
 b=E+OO/uTohiVSbyI4eOjs1Y8chaMqCkkXMY5owlQPdTZUBGcVbeQNQaHWQF5tNZtkcHTQG1LXM2xBRWPaZRjglvh3U+lwxiiQdddw6f+ln6IhNKlFaJiLSkcg6NzQGXoG71T5EUBLyKe+3pQNWr4ySPBLkqed1Y6HAmi5/Qk5qoFFUBH9HkN12e9bPY/rBDynxA8hahkbRY2RvMagHPBpNlAp/drc0eBlkjEzLRNlc77j3gy5p6pR4TuegZB3doIi/nrsuOGTsFdBrhcv8nGvMGPkbSL1GkrSImu4M2QPukS4KlKy1ob3g7ePqNzFjylTOeRxDHRJzqJcTwyAoWEHrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xPoTfOaMRNZg6OigKjxanh/Aj0Aw8yC/W7KGEK4NiIk=;
 b=NbhEMZLOeVmesWVgg9g2/793QBEQMfGJd5KVawqJzrCTSxwdloSrYzndoXl+MQtjX38iZGj4mhKBuKHO4gaQv3MGuBZ6OF4U5ZsiVyjBa83F4rKS7lOzpL+KTcuOG31ommJ/wSjmRzszrkYWWCPcL0iEOzvCzQNMpQirWvp2jkI=
Received: from BL1PR13CA0366.namprd13.prod.outlook.com (2603:10b6:208:2c0::11)
 by CH2PR12MB4309.namprd12.prod.outlook.com (2603:10b6:610:a4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.37; Mon, 16 Oct
 2023 13:38:04 +0000
Received: from BL02EPF0001A0FA.namprd03.prod.outlook.com
 (2603:10b6:208:2c0:cafe::94) by BL1PR13CA0366.outlook.office365.com
 (2603:10b6:208:2c0::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.18 via Frontend
 Transport; Mon, 16 Oct 2023 13:38:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0001A0FA.mail.protection.outlook.com (10.167.242.101) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Mon, 16 Oct 2023 13:38:04 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 16 Oct
 2023 08:38:04 -0500
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
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Harald Hoyer <harald@profian.com>
Subject: [PATCH v10 29/50] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_FINISH command
Date:   Mon, 16 Oct 2023 08:27:58 -0500
Message-ID: <20231016132819.1002933-30-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FA:EE_|CH2PR12MB4309:EE_
X-MS-Office365-Filtering-Correlation-Id: 19d62836-d7d0-4547-22c6-08dbce4d2013
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ToLm0ksb7Et/O8bS/AJoMk8v0Oe6USv4njDsV0dB35I5MiZvXTAmrZ3CdgWLOCf5onkuFNGGm+9qtG+9QJxWbcMGqP+MAWARsA/W/LVr0j5qtocPfixuM/JpXVlg1BSLC/oU8YHADlAq375ZihJXWEJoKcdjDD9Go3JhvQQwe7IDeZWS27x0UE67+bw7hIsgAH6LRYMY9DNnrA45XXryb9kbisLueB0n2/8Ma2o7QhGK0fWPVmCTHEmq1w2PlVBK/JCKloOsMx0zRneTCaQyOAu91r2TkVWIPT8/7B5klw0LaGfzrzwhBU8t3H530AKGHAMH1NTF9dGuhBZDyTrY1LF8m7Ok0s0L7xyl/2pn8wbD9l4ecoR5TeuToXDhsD0WPgPwl7Ntm2wmPjqqvxBZB0L/OZTmOsmAKQeha0N7YIaMpn/BKyhJJA8l1vrfy4mu/097n0F7ENGdZeFNEcyhQI/HS4QjZ11wpEc7k3z3yiy7ImR4oqfz8Zvp650oNQnMvzby5vRYBc1SQ/a4CUDQIZ6Xp/++0lNMH3AgOgYcbYw3SB3tKxwCd6Cj9zYLI8Aabd7LcFWTMscdxwhZoPT85VG0egL1+SCoUJHg9YEG9XtObPGFl+A9g7YfyJtO9ATouYuTy167WQpjGudjmV9L2mSqHeBQRnxIQRXLQbGNwg1z37alKLHwTYQqHe2wRHGSxQ2GC5MvEnUmcyRso32pEtng4oYacqSMa4+IORI+sQjWdmSh64q2YMWYK4+8pJc8VALYQRiZc2pd6LR2SLZxQA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(136003)(346002)(376002)(39860400002)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(82310400011)(46966006)(40470700004)(36840700001)(1076003)(2616005)(6666004)(82740400003)(81166007)(40480700001)(40460700003)(86362001)(356005)(36860700001)(316002)(7416002)(36756003)(47076005)(7406005)(44832011)(336012)(41300700001)(478600001)(70586007)(2906002)(426003)(83380400001)(26005)(16526019)(8936002)(4326008)(5660300002)(8676002)(6916009)(70206006)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 13:38:04.8360
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 19d62836-d7d0-4547-22c6-08dbce4d2013
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF0001A0FA.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4309
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

The KVM_SEV_SNP_LAUNCH_FINISH finalize the cryptographic digest and stores
it as the measurement of the guest at launch.

While finalizing the launch flow, it also issues the LAUNCH_UPDATE command
to encrypt the VMSA pages.

If its an SNP guest, then VMSA was added in the RMP entry as
a guest owned page and also removed from the kernel direct map
so flush it later after it is transitioned back to hypervisor
state and restored in the direct map.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Harald Hoyer <harald@profian.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
[mdr: always measure BSP first to get consistent launch measurements]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 .../virt/kvm/x86/amd-memory-encryption.rst    |  24 +++
 arch/x86/kvm/svm/sev.c                        | 146 ++++++++++++++++++
 include/uapi/linux/kvm.h                      |  14 ++
 3 files changed, 184 insertions(+)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index d4325b26724c..b89634cfcc06 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -513,6 +513,30 @@ Returns: 0 on success, -negative on error
 See the SEV-SNP spec for further details on how to build the VMPL permission
 mask and page type.
 
+21. KVM_SNP_LAUNCH_FINISH
+-------------------------
+
+After completion of the SNP guest launch flow, the KVM_SNP_LAUNCH_FINISH command can be
+issued to make the guest ready for the execution.
+
+Parameters (in): struct kvm_sev_snp_launch_finish
+
+Returns: 0 on success, -negative on error
+
+::
+
+        struct kvm_sev_snp_launch_finish {
+                __u64 id_block_uaddr;
+                __u64 id_auth_uaddr;
+                __u8 id_block_en;
+                __u8 auth_key_en;
+                __u8 host_data[32];
+                __u8 pad[6];
+        };
+
+
+See SEV-SNP specification for further details on launch finish input parameters.
+
 References
 ==========
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index c505e4620456..ae9f765dfa95 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -78,6 +78,8 @@ static bool sev_snp_enabled;
 #define SNP_POLICY_MASK_SMT		BIT_ULL(16)
 #define SNP_POLICY_MASK_SINGLE_SOCKET	BIT_ULL(20)
 
+#define INITIAL_VMSA_GPA 0xFFFFFFFFF000
+
 static u8 sev_enc_bit;
 static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
@@ -747,7 +749,29 @@ static int sev_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (!sev_es_guest(kvm))
 		return -ENOTTY;
 
+	/* Handle boot vCPU first to ensure consistent measurement of initial state. */
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (vcpu->vcpu_id != 0)
+			continue;
+
+		ret = mutex_lock_killable(&vcpu->mutex);
+		if (ret)
+			return ret;
+
+		ret = __sev_launch_update_vmsa(kvm, vcpu, &argp->error);
+
+		mutex_unlock(&vcpu->mutex);
+		if (ret)
+			return ret;
+
+		break;
+	}
+
+	/* Handle remaining vCPUs. */
 	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (vcpu->vcpu_id == 0)
+			continue;
+
 		ret = mutex_lock_killable(&vcpu->mutex);
 		if (ret)
 			return ret;
@@ -2166,6 +2190,109 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 				      snp_launch_update_gfn_handler, argp);
 }
 
+static int snp_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_snp_launch_update data = {};
+	struct kvm_vcpu *vcpu;
+	unsigned long i;
+	int ret;
+
+	data.gctx_paddr = __psp_pa(sev->snp_context);
+	data.page_type = SNP_PAGE_TYPE_VMSA;
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		struct vcpu_svm *svm = to_svm(vcpu);
+		u64 pfn = __pa(svm->sev_es.vmsa) >> PAGE_SHIFT;
+
+		/* Perform some pre-encryption checks against the VMSA */
+		ret = sev_es_sync_vmsa(svm);
+		if (ret)
+			return ret;
+
+		/* Transition the VMSA page to a firmware state. */
+		ret = rmp_make_private(pfn, INITIAL_VMSA_GPA, PG_LEVEL_4K, sev->asid, true);
+		if (ret)
+			return ret;
+
+		/* Issue the SNP command to encrypt the VMSA */
+		data.address = __sme_pa(svm->sev_es.vmsa);
+		ret = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_UPDATE,
+				      &data, &argp->error);
+		if (ret) {
+			snp_page_reclaim(pfn);
+			return ret;
+		}
+
+		svm->vcpu.arch.guest_state_protected = true;
+	}
+
+	return 0;
+}
+
+static int snp_launch_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct kvm_sev_snp_launch_finish params;
+	struct sev_data_snp_launch_finish *data;
+	void *id_block = NULL, *id_auth = NULL;
+	int ret;
+
+	if (!sev_snp_guest(kvm))
+		return -ENOTTY;
+
+	if (!sev->snp_context)
+		return -EINVAL;
+
+	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params)))
+		return -EFAULT;
+
+	/* Measure all vCPUs using LAUNCH_UPDATE before finalizing the launch flow. */
+	ret = snp_launch_update_vmsa(kvm, argp);
+	if (ret)
+		return ret;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
+	if (!data)
+		return -ENOMEM;
+
+	if (params.id_block_en) {
+		id_block = psp_copy_user_blob(params.id_block_uaddr, KVM_SEV_SNP_ID_BLOCK_SIZE);
+		if (IS_ERR(id_block)) {
+			ret = PTR_ERR(id_block);
+			goto e_free;
+		}
+
+		data->id_block_en = 1;
+		data->id_block_paddr = __sme_pa(id_block);
+
+		id_auth = psp_copy_user_blob(params.id_auth_uaddr, KVM_SEV_SNP_ID_AUTH_SIZE);
+		if (IS_ERR(id_auth)) {
+			ret = PTR_ERR(id_auth);
+			goto e_free_id_block;
+		}
+
+		data->id_auth_paddr = __sme_pa(id_auth);
+
+		if (params.auth_key_en)
+			data->auth_key_en = 1;
+	}
+
+	memcpy(data->host_data, params.host_data, KVM_SEV_SNP_FINISH_DATA_SIZE);
+	data->gctx_paddr = __psp_pa(sev->snp_context);
+	ret = sev_issue_cmd(kvm, SEV_CMD_SNP_LAUNCH_FINISH, data, &argp->error);
+
+	kfree(id_auth);
+
+e_free_id_block:
+	kfree(id_block);
+
+e_free:
+	kfree(data);
+
+	return ret;
+}
+
 int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -2262,6 +2389,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_SNP_LAUNCH_UPDATE:
 		r = snp_launch_update(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SNP_LAUNCH_FINISH:
+		r = snp_launch_finish(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
@@ -2730,11 +2860,27 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu)
 
 	svm = to_svm(vcpu);
 
+	/*
+	 * If its an SNP guest, then VMSA was added in the RMP entry as
+	 * a guest owned page. Transition the page to hypervisor state
+	 * before releasing it back to the system.
+	 * Also the page is removed from the kernel direct map, so flush it
+	 * later after it is transitioned back to hypervisor state and
+	 * restored in the direct map.
+	 */
+	if (sev_snp_guest(vcpu->kvm)) {
+		u64 pfn = __pa(svm->sev_es.vmsa) >> PAGE_SHIFT;
+
+		if (host_rmp_make_shared(pfn, PG_LEVEL_4K, true))
+			goto skip_vmsa_free;
+	}
+
 	if (vcpu->arch.guest_state_protected)
 		sev_flush_encrypted_page(vcpu, svm->sev_es.vmsa);
 
 	__free_page(virt_to_page(svm->sev_es.vmsa));
 
+skip_vmsa_free:
 	if (svm->sev_es.ghcb_sa_free)
 		kvfree(svm->sev_es.ghcb_sa);
 }
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 264e6acb7947..6f7b44b32497 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1966,6 +1966,7 @@ enum sev_cmd_id {
 	KVM_SEV_SNP_INIT,
 	KVM_SEV_SNP_LAUNCH_START,
 	KVM_SEV_SNP_LAUNCH_UPDATE,
+	KVM_SEV_SNP_LAUNCH_FINISH,
 
 	KVM_SEV_NR_MAX,
 };
@@ -2100,6 +2101,19 @@ struct kvm_sev_snp_launch_update {
 	__u8 vmpl1_perms;
 };
 
+#define KVM_SEV_SNP_ID_BLOCK_SIZE	96
+#define KVM_SEV_SNP_ID_AUTH_SIZE	4096
+#define KVM_SEV_SNP_FINISH_DATA_SIZE	32
+
+struct kvm_sev_snp_launch_finish {
+	__u64 id_block_uaddr;
+	__u64 id_auth_uaddr;
+	__u8 id_block_en;
+	__u8 auth_key_en;
+	__u8 host_data[KVM_SEV_SNP_FINISH_DATA_SIZE];
+	__u8 pad[6];
+};
+
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
 #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
-- 
2.25.1

