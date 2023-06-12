Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB2172B6CA
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 06:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235005AbjFLEni (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 00:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234346AbjFLEnT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 00:43:19 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on20612.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8d::612])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9DFE171E;
        Sun, 11 Jun 2023 21:42:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=catWJ6PST+CGnxINGTq2d5U6JAwDFLk3aq53EDSzwU5OVmlvZUeD2+2PXTYMnrdtzXtKTvwBK4izIVGx1K/JZaZ4rLlJeNbJIsMJRDcP1a0+YOHroEIfW4ueHu2U3+E67CY1fwrfewy1dkGC9UNoLryIfSkWGbngHITbHIi8iI2LJzn8ZO9+FAwmR5xVvmjPuRnhKSFWLd6+DY97EgkzinNk1YH18NE22OYlETw2ExkdUFUtJsCheTdhiK5wDi9DSCwcYfVzEZsz+mfqeiTDeAz1pi5DTGpkk1z5LrXjA0PH3Uw4m8l2cnXhGKOYgMoKPEoE4UBm5rDWRKLoRCS1hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FG6QkCjqXiLpNLeaBHakaidVeB3qMARoqImjyr/5kEc=;
 b=Gwn9+NSgzskG8n4coqckBqN6zLJbNblXN/2MaL3QAs3rIAJs7hsozwK2rh0E0DsfNtFYsiaXQbNmlY0lm443qEY8LSWIH0kCf+p+nZR+mHvQ/W7k3cOEFiTAcuBRLStUe5/t2SxG4poSTD/brlPglC7CIj/QHGEvDG5xm68uuT1UnVzh0jCa4xrt/Bo57RH9k730FoGCkRm1zcfBT9dF2VWp2foAu+v+CwRU1LAuqzYOvr+46VuNtOhWbZbA1M7bStppXE10PVRvajeGvOd61byFOv0+17udoM1s4G7Z51v8UgplmeCEbHqlhVRLjAqD1n9CyidhQacA2mOKZocBqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FG6QkCjqXiLpNLeaBHakaidVeB3qMARoqImjyr/5kEc=;
 b=HoTGlsIlsnI4JrdCtxy+tcL9r9DAXj3Oap3mpA9qtYJrV+QRPVquVfLgLf6JCwkG5QeUPQnPRfT6BaqerF7tySpNmbrjxVmWc7J27fS+sWnKPpoTXZcuvc/CFCNj3BevNGpj/PbZ06awu4/gCIpXc+5Xn5RGOVsowb0ixD9pr1s=
Received: from SJ2PR07CA0004.namprd07.prod.outlook.com (2603:10b6:a03:505::10)
 by DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6477.29; Mon, 12 Jun 2023 04:42:23 +0000
Received: from CO1PEPF000042AC.namprd03.prod.outlook.com
 (2603:10b6:a03:505:cafe::28) by SJ2PR07CA0004.outlook.office365.com
 (2603:10b6:a03:505::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.33 via Frontend
 Transport; Mon, 12 Jun 2023 04:42:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000042AC.mail.protection.outlook.com (10.167.243.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6477.13 via Frontend Transport; Mon, 12 Jun 2023 04:42:22 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 11 Jun
 2023 23:42:19 -0500
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
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Harald Hoyer <harald@profian.com>
Subject: [PATCH RFC v9 33/51] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_FINISH command
Date:   Sun, 11 Jun 2023 23:25:41 -0500
Message-ID: <20230612042559.375660-34-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230612042559.375660-1-michael.roth@amd.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000042AC:EE_|DS7PR12MB6048:EE_
X-MS-Office365-Filtering-Correlation-Id: 1944eb23-9154-49d7-7573-08db6aff69de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ht8gzIVqf1TWuxzF9gRQOPGEWtDUsvncpha3zyEKdL0NL52JDoxgR2+nVa7y2A+oMVE7j/AmKtMTgTSMnL7mv6oMQQ18bcSRGVGE+mz7ZtOk2rPxjLgMNa5taWd1UWtxOa/tvbivlTCsGxSr5hchq5qqBJUpBTmpjTBhrcDJRKkYaSuIKkWCT8rFGrw/VOEuAoQAnA0LcW/QtYheJwDafdbv0HoYsX7oEgpZW86sATpyPS97bD0fWUOmILMvtreIMYupQkjD+Mpf7VvuoWJcTj2tVGy/WFBIJgTJHj3rPANpimvGP0Htkr7pmYBtgCt8cgqTOdkqJEy0mfPFExVkD/hwsVzizH0yERpzmlyf+Ra+KdKXL25JMG0G3jsts0ud9cZ9ihI5SfvyxD0mH3QMEvDDhavA48yU3ig2sbGeg6pjM6/BTf+HPzXahhvY4s8BmClpHNzNtz11Sm1/f4GbQ/rtmZmHnC9heBAAYXDaScoavxM2lrur4T5Z2S1qiVWxCCBF7EA1ni59275zIt3yX0WFBQZ8e+FAvociyVHoQijxl051ufL7qufEUexJFSUAyyBXq5JA+tLQGCka4y22I1an/YrDtn5g109TUi+QKvOdcp6yNta7bxhrljrI8SIUuBohC3FubMukezBDpurINAHlp1mapmZo+k5lXy+hYN+2e5yBHohJ9/6ltEGjQCerL95QLgdIvzQ+u4QLEkgUHa/+XdyaaZdW3hB3mk3shZ5f9nv4o/Dms0IHkKDlcaL8VNIZ/WzZw8hwzGWw1Og5sg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(376002)(346002)(39860400002)(451199021)(46966006)(40470700004)(36840700001)(316002)(40460700003)(41300700001)(336012)(426003)(82310400005)(83380400001)(86362001)(2616005)(36860700001)(26005)(1076003)(186003)(7416002)(7406005)(2906002)(47076005)(44832011)(16526019)(81166007)(356005)(82740400003)(40480700001)(8676002)(36756003)(5660300002)(8936002)(70586007)(70206006)(478600001)(54906003)(6666004)(4326008)(6916009)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 04:42:22.7042
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1944eb23-9154-49d7-7573-08db6aff69de
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF000042AC.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6048
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
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
index d8492af09796..cd77a19577fe 100644
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
index 6a82767d940f..a7cbdc24ccdb 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -66,6 +66,8 @@ static bool sev_snp_enabled;
 #define AP_RESET_HOLD_NAE_EVENT		1
 #define AP_RESET_HOLD_MSR_PROTO		2
 
+#define INITIAL_VMSA_GPA 0xFFFFFFFFF000
+
 static u8 sev_enc_bit;
 static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
@@ -727,7 +729,29 @@ static int sev_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
@@ -2139,6 +2163,109 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
@@ -2235,6 +2362,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_SNP_LAUNCH_UPDATE:
 		r = snp_launch_update(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SNP_LAUNCH_FINISH:
+		r = snp_launch_finish(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
@@ -2695,11 +2825,27 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu)
 
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
index 4961d2e67a4b..1fb6a6615d09 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1930,6 +1930,7 @@ enum sev_cmd_id {
 	KVM_SEV_SNP_INIT,
 	KVM_SEV_SNP_LAUNCH_START,
 	KVM_SEV_SNP_LAUNCH_UPDATE,
+	KVM_SEV_SNP_LAUNCH_FINISH,
 
 	KVM_SEV_NR_MAX,
 };
@@ -2064,6 +2065,19 @@ struct kvm_sev_snp_launch_update {
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

