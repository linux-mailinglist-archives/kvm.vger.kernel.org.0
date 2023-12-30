Return-Path: <kvm+bounces-5381-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC12B8207C4
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 18:29:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 093F7B20F27
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:29:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C4FFBE68;
	Sat, 30 Dec 2023 17:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="c7z5DKbU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2051.outbound.protection.outlook.com [40.107.102.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6209714F63;
	Sat, 30 Dec 2023 17:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RxYiSYxezJqAkd/xVuGnx/mRv5TXTQxt02bsUdC63Jmy9zYofaGKDJzKGowpT8+nbKET1NvIurqFi1U44pc1If6CriUlen62wlApehREDAt8PEQVHHz6rscu2t2C+jjmZQVBOl0cm/Q4GAc64cxJ1lf9TuJPLHT++7tjt0W4DfNvoHEtncYBD/T2z+ZexVupBcSaN9Z1gAy+/ofi2LJD0vov9tVO0MyECvB428UwRc8uN22uunytFvlAujDVp/QHe86ycjKF0pXyHyA0zfOceI8Q+loMiBDsqmI2QQ1b83+PwKzLMIwY+MiLxb6T5G9zIP/MpoV1xOiyNbfuda1mgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SzR7GW7ckpOWv9GGj1LrteQHUqD4jqbPWFD/LBADNGA=;
 b=YrnxIxCm9vyiJ7jv2v0P2f6lscN3M8Ttz20izUZA5ovQYgs91gJ0gfnschHCfHBvP0gnz9M2aoR9R4Yl1CSkRh3zfZVEsctKLNW1g681AF/2V7hUTb/dgBcdLrztdFHk1JwQl5Tq49iKIMONvOEpBWVrQaOTWGiioAq6tCYGzmoj5XkNELV255YPgR+Mpl/oPuJ+8ArynQuMMzFIawr7TYWCRSLAVPwzZAbgJQAirPhFIzeRyY2GqoTweurahXzfjvAuajU4KQgOVFS1rKK9Po0stKCKJ82Ozi7O0vd22FYqd/4nK+/sUZTFRq1IyjMPkKPG2eHUT5rsfxQ01PdXEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SzR7GW7ckpOWv9GGj1LrteQHUqD4jqbPWFD/LBADNGA=;
 b=c7z5DKbUSfh+o/9nyDNUh46JFvktXBaozT91lnt6QQKhs70gynnat9cQjv7AiFsi+jZh/0txBWdQwvgPfTHKdK0KxETUkNTgqb3rzm6z0xHu4nZQxLTWyZNH5x/NfRhwsOcJgHTbGweDRlIJBctYng+QXAHe766myg/nrG0WWZk=
Received: from BLAPR03CA0168.namprd03.prod.outlook.com (2603:10b6:208:32f::6)
 by CY8PR12MB7708.namprd12.prod.outlook.com (2603:10b6:930:87::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.22; Sat, 30 Dec
 2023 17:28:11 +0000
Received: from MN1PEPF0000ECD6.namprd02.prod.outlook.com
 (2603:10b6:208:32f:cafe::e2) by BLAPR03CA0168.outlook.office365.com
 (2603:10b6:208:32f::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.20 via Frontend
 Transport; Sat, 30 Dec 2023 17:28:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000ECD6.mail.protection.outlook.com (10.167.242.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 17:28:10 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 11:28:09 -0600
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
	Brijesh Singh <brijesh.singh@amd.com>, Harald Hoyer <harald@profian.com>
Subject: [PATCH v11 19/35] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_FINISH command
Date: Sat, 30 Dec 2023 11:23:35 -0600
Message-ID: <20231230172351.574091-20-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231230172351.574091-1-michael.roth@amd.com>
References: <20231230172351.574091-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECD6:EE_|CY8PR12MB7708:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e74950c-dd17-4e45-1154-08dc095cb1df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	2wG8pe444SDKC9msaCHjUFjD44wOxgXa7t+EBKn6YwsbJCd7e4kOHoIlJ9ofvMuxAmYtKDPxiGLszT4RPLyTudMGDsoGsjIImmbmHyiamhFDI+p/N6V8xmaGbATSOGeCo72iYJjhdMi9HaUQDaDgPrYg7CvWjSXfR/YtxhXJ2o4jBRJ62iCwm9ZkEZbCAXjDAzVL80/4sO5Q3cEtx0PAsiMYf1Q/M9+Qm/Yj/2udxazoSzqWLCWKD+co2T2uJ/gJKnx2znWnLEmBWkj57r9hTYjPSYHxtm1uzL+xYjDmIeB6tHaH4t0ACNw5pX2l6bGtttpEZiMQNeXDoeEVh1DGaH6gKsIahGaRh2oN7YeN44sdEIPetkYiEXQ8rUsfead0jgerFq+D90G2850QA8WWQP7nX8Lpp5rd5UjQI0pqKszDcCfM3l7oDgx+yKEtbEeR6nvrbhThICiG2WdGLED+mVA1qrCWda8Ih3C1HsxDPJVORBvCPHHAZY1DfljARtwuAV0MqJ6YzNUllz9rv/w8bw38HpoZ/1oVhoRmHt4TBSS9+mlawLj0DpYp40IL9f0QeFGDbfWLzD3YQO0wE68Ey1jr8rC/uNRjRUwNeqs7EygfvVcjtGCZEbUy5HA66dSAM9DN/5C/MC+VHVHCwe8fBgmE0MggcLr1U7DxUmkIUrYnkbwEG7HcyQxYrBl5tY6ghaPKckN636+RIkjGLANIZSlgajaLS7ffj8cvEmbckK/7kuQka5R5TZ5njc4BPDWcon3ej6Xdr8Y1Q3qbUbtLkw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(136003)(346002)(376002)(396003)(230922051799003)(186009)(64100799003)(451199024)(1800799012)(82310400011)(40470700004)(36840700001)(46966006)(40480700001)(40460700003)(426003)(336012)(2616005)(1076003)(16526019)(83380400001)(26005)(86362001)(81166007)(36756003)(356005)(82740400003)(47076005)(4326008)(44832011)(7406005)(5660300002)(7416002)(36860700001)(6666004)(54906003)(8936002)(70586007)(70206006)(8676002)(316002)(6916009)(2906002)(41300700001)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 17:28:10.4657
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e74950c-dd17-4e45-1154-08dc095cb1df
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECD6.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7708

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
index d60209e6e68b..ada40a79b2f7 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -77,6 +77,8 @@ static bool sev_snp_enabled;
 #define SNP_POLICY_MASK_SMT		BIT_ULL(16)
 #define SNP_POLICY_MASK_SINGLE_SOCKET	BIT_ULL(20)
 
+#define INITIAL_VMSA_GPA 0xFFFFFFFFF000
+
 static u8 sev_enc_bit;
 static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
@@ -749,7 +751,29 @@ static int sev_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
@@ -2168,6 +2192,109 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
@@ -2264,6 +2391,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_SNP_LAUNCH_UPDATE:
 		r = snp_launch_update(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SNP_LAUNCH_FINISH:
+		r = snp_launch_finish(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
@@ -2736,11 +2866,27 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu)
 
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
index 6e6e3a478022..5218075fe1f4 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1873,6 +1873,7 @@ enum sev_cmd_id {
 	KVM_SEV_SNP_INIT,
 	KVM_SEV_SNP_LAUNCH_START,
 	KVM_SEV_SNP_LAUNCH_UPDATE,
+	KVM_SEV_SNP_LAUNCH_FINISH,
 
 	KVM_SEV_NR_MAX,
 };
@@ -2007,6 +2008,19 @@ struct kvm_sev_snp_launch_update {
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


