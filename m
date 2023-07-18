Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB3C475718A
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 03:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbjGRB7Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jul 2023 21:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbjGRB7Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jul 2023 21:59:24 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA2C3E76;
        Mon, 17 Jul 2023 18:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689645562; x=1721181562;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=C+UYYS9cur3L9L8VTlag6+jhTNIfmTouTpEXsaYzuWk=;
  b=VhWtncg+Rkve8f5C5OCrD/6Fd/VACLAW7cy/r45Aa3ZJ5k7SvZ5Xh1ky
   eUI6NoZZe81+Q5BNDWvanAImPOOOC1/47rcpT01aa0oaMnAoyG9dzMTrV
   /nRMdErPfVir0zcUFbo0oDdTaFuCypUVnq14PQHp+KtIZxiAGujQphldW
   LYktefnJwUni+AwCYZLxytajrC7T70rfqkHp8HhiYb4uShTAQx0ym4tDd
   +LzyQWkkbWJ8uPuB0DEQcWIqrSXFJUx6FqjVPIV0R5SSM/gu9yAgAmAuV
   CkZq81/UC8wlMHYikXV8QUtxOMWNn8mVYL8Ez0iJ2ENOXiteLnNBet8Rx
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10774"; a="350948334"
X-IronPort-AV: E=Sophos;i="6.01,213,1684825200"; 
   d="scan'208";a="350948334"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2023 18:59:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10774"; a="753125087"
X-IronPort-AV: E=Sophos;i="6.01,213,1684825200"; 
   d="scan'208";a="753125087"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2023 18:59:21 -0700
From:   isaku.yamahata@intel.com
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Michael Roth <michael.roth@amd.com>
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>, chen.bo@intel.com,
        Sagi Shahar <sagis@google.com>
Subject: [RFC PATCH] KVM: x86: Make struct sev_cmd common for KVM_MEM_ENC_OP
Date:   Mon, 17 Jul 2023 18:58:54 -0700
Message-Id: <2f296c5a255936b92cffde5e7d6414edfb93f660.1689645293.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX KVM will use KVM_MEM_ENC_OP.  Make struct sev_cmd common both for
vendor backend, SEV and TDX, with rename.  Make the struct common uABI for
KVM_MEM_ENC_OP.  TDX backend wants to return 64 bit error code instead of
32 bit. To keep ABI for SEV backend, use union to accommodate 64 bit
member.

Some data structures for sub-commands could be common.  The current
candidate would be KVM_SEV{,_ES}_INIT, KVM_SEV_LAUNCH_FINISH,
KVM_SEV_LAUNCH_UPDATE_VMSA, KVM_SEV_DBG_DECRYPT, and KVM_SEV_DBG_ENCRYPT.

Only compile tested for SEV code.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/include/uapi/asm/kvm.h | 22 +++++++++++
 arch/x86/kvm/svm/sev.c          | 68 ++++++++++++++++++---------------
 arch/x86/kvm/svm/svm.h          |  2 +-
 arch/x86/kvm/x86.c              | 16 +++++++-
 5 files changed, 76 insertions(+), 34 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 28bd38303d70..f14c8df707ac 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1706,7 +1706,7 @@ struct kvm_x86_ops {
 	void (*enable_smi_window)(struct kvm_vcpu *vcpu);
 #endif
 
-	int (*mem_enc_ioctl)(struct kvm *kvm, void __user *argp);
+	int (*mem_enc_ioctl)(struct kvm *kvm, struct kvm_mem_enc_cmd *cmd);
 	int (*mem_enc_register_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 	int (*mem_enc_unregister_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 	int (*vm_copy_enc_context_from)(struct kvm *kvm, unsigned int source_fd);
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 1a6a1f987949..c458c38bb0cb 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -562,4 +562,26 @@ struct kvm_pmu_event_filter {
 /* x86-specific KVM_EXIT_HYPERCALL flags. */
 #define KVM_EXIT_HYPERCALL_LONG_MODE	BIT(0)
 
+struct kvm_mem_enc_cmd {
+	/* sub-command id of KVM_MEM_ENC_OP. */
+	__u32 id;
+	/* Auxiliary flags for sub-command. */
+	__u32 flags;
+	/* Data for sub-command. Typically __user pointer to actual parameter. */
+	__u64 data;
+	/* Supplemental error code in error case. */
+	union {
+		struct {
+			__u32 error;
+			/*
+			 * KVM_SEV_LAUNCH_START and KVM_SEV_RECEIVE_START
+			 * require extra data. Not included in struct
+			 * kvm_sev_launch_start or struct kvm_sev_receive_start.
+			 */
+			__u32 sev_fd;
+		};
+		__u64 error64;
+	};
+};
+
 #endif /* _ASM_X86_KVM_H */
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 07756b7348ae..94e13bb49c86 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1835,30 +1835,39 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
 	return ret;
 }
 
-int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
+int sev_mem_enc_ioctl(struct kvm *kvm, struct kvm_mem_enc_cmd *cmd)
 {
-	struct kvm_sev_cmd sev_cmd;
+	struct kvm_sev_cmd *sev_cmd = (struct kvm_sev_cmd *)cmd;
 	int r;
 
+	/* TODO: replace struct kvm_sev_cmd with kvm_mem_enc_cmd. */
+	BUILD_BUG_ON(sizeof(*sev_cmd) != sizeof(*cmd));
+	BUILD_BUG_ON(offsetof(struct kvm_sev_cmd, id) !=
+		     offsetof(struct kvm_mem_enc_cmd, id));
+	BUILD_BUG_ON(sizeof(sev_cmd->id) != sizeof(cmd->id));
+	BUILD_BUG_ON(offsetof(struct kvm_sev_cmd, data) !=
+		     offsetof(struct kvm_mem_enc_cmd, data));
+	BUILD_BUG_ON(sizeof(sev_cmd->data) != sizeof(cmd->data));
+	BUILD_BUG_ON(offsetof(struct kvm_sev_cmd, error) !=
+		     offsetof(struct kvm_mem_enc_cmd, error));
+	BUILD_BUG_ON(sizeof(sev_cmd->error) != sizeof(cmd->error));
+	BUILD_BUG_ON(offsetof(struct kvm_sev_cmd, sev_fd) !=
+		     offsetof(struct kvm_mem_enc_cmd, sev_fd));
+	BUILD_BUG_ON(sizeof(sev_cmd->sev_fd) != sizeof(cmd->sev_fd));
+
 	if (!sev_enabled)
 		return -ENOTTY;
 
-	if (!argp)
-		return 0;
-
-	if (copy_from_user(&sev_cmd, argp, sizeof(struct kvm_sev_cmd)))
-		return -EFAULT;
-
 	mutex_lock(&kvm->lock);
 
 	/* Only the enc_context_owner handles some memory enc operations. */
 	if (is_mirroring_enc_context(kvm) &&
-	    !is_cmd_allowed_from_mirror(sev_cmd.id)) {
+	    !is_cmd_allowed_from_mirror(sev_cmd->id)) {
 		r = -EINVAL;
 		goto out;
 	}
 
-	switch (sev_cmd.id) {
+	switch (sev_cmd->id) {
 	case KVM_SEV_ES_INIT:
 		if (!sev_es_enabled) {
 			r = -ENOTTY;
@@ -1866,67 +1875,64 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 		}
 		fallthrough;
 	case KVM_SEV_INIT:
-		r = sev_guest_init(kvm, &sev_cmd);
+		r = sev_guest_init(kvm, sev_cmd);
 		break;
 	case KVM_SEV_LAUNCH_START:
-		r = sev_launch_start(kvm, &sev_cmd);
+		r = sev_launch_start(kvm, sev_cmd);
 		break;
 	case KVM_SEV_LAUNCH_UPDATE_DATA:
-		r = sev_launch_update_data(kvm, &sev_cmd);
+		r = sev_launch_update_data(kvm, sev_cmd);
 		break;
 	case KVM_SEV_LAUNCH_UPDATE_VMSA:
-		r = sev_launch_update_vmsa(kvm, &sev_cmd);
+		r = sev_launch_update_vmsa(kvm, sev_cmd);
 		break;
 	case KVM_SEV_LAUNCH_MEASURE:
-		r = sev_launch_measure(kvm, &sev_cmd);
+		r = sev_launch_measure(kvm, sev_cmd);
 		break;
 	case KVM_SEV_LAUNCH_FINISH:
-		r = sev_launch_finish(kvm, &sev_cmd);
+		r = sev_launch_finish(kvm, sev_cmd);
 		break;
 	case KVM_SEV_GUEST_STATUS:
-		r = sev_guest_status(kvm, &sev_cmd);
+		r = sev_guest_status(kvm, sev_cmd);
 		break;
 	case KVM_SEV_DBG_DECRYPT:
-		r = sev_dbg_crypt(kvm, &sev_cmd, true);
+		r = sev_dbg_crypt(kvm, sev_cmd, true);
 		break;
 	case KVM_SEV_DBG_ENCRYPT:
-		r = sev_dbg_crypt(kvm, &sev_cmd, false);
+		r = sev_dbg_crypt(kvm, sev_cmd, false);
 		break;
 	case KVM_SEV_LAUNCH_SECRET:
-		r = sev_launch_secret(kvm, &sev_cmd);
+		r = sev_launch_secret(kvm, sev_cmd);
 		break;
 	case KVM_SEV_GET_ATTESTATION_REPORT:
-		r = sev_get_attestation_report(kvm, &sev_cmd);
+		r = sev_get_attestation_report(kvm, sev_cmd);
 		break;
 	case KVM_SEV_SEND_START:
-		r = sev_send_start(kvm, &sev_cmd);
+		r = sev_send_start(kvm, sev_cmd);
 		break;
 	case KVM_SEV_SEND_UPDATE_DATA:
-		r = sev_send_update_data(kvm, &sev_cmd);
+		r = sev_send_update_data(kvm, sev_cmd);
 		break;
 	case KVM_SEV_SEND_FINISH:
-		r = sev_send_finish(kvm, &sev_cmd);
+		r = sev_send_finish(kvm, sev_cmd);
 		break;
 	case KVM_SEV_SEND_CANCEL:
-		r = sev_send_cancel(kvm, &sev_cmd);
+		r = sev_send_cancel(kvm, sev_cmd);
 		break;
 	case KVM_SEV_RECEIVE_START:
-		r = sev_receive_start(kvm, &sev_cmd);
+		r = sev_receive_start(kvm, sev_cmd);
 		break;
 	case KVM_SEV_RECEIVE_UPDATE_DATA:
-		r = sev_receive_update_data(kvm, &sev_cmd);
+		r = sev_receive_update_data(kvm, sev_cmd);
 		break;
 	case KVM_SEV_RECEIVE_FINISH:
-		r = sev_receive_finish(kvm, &sev_cmd);
+		r = sev_receive_finish(kvm, sev_cmd);
 		break;
 	default:
 		r = -EINVAL;
 		goto out;
 	}
 
-	if (copy_to_user(argp, &sev_cmd, sizeof(struct kvm_sev_cmd)))
-		r = -EFAULT;
-
 out:
 	mutex_unlock(&kvm->lock);
 	return r;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 18af7e712a5a..74ecab20c24b 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -716,7 +716,7 @@ void avic_refresh_virtual_apic_mode(struct kvm_vcpu *vcpu);
 extern unsigned int max_sev_asid;
 
 void sev_vm_destroy(struct kvm *kvm);
-int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp);
+int sev_mem_enc_ioctl(struct kvm *kvm, struct kvm_mem_enc_cmd *cmd);
 int sev_mem_enc_register_region(struct kvm *kvm,
 				struct kvm_enc_region *range);
 int sev_mem_enc_unregister_region(struct kvm *kvm,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a6b9bea62fb8..14cfbc3266dd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7018,11 +7018,25 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 		goto out;
 	}
 	case KVM_MEMORY_ENCRYPT_OP: {
+		struct kvm_mem_enc_cmd cmd;
+
 		r = -ENOTTY;
 		if (!kvm_x86_ops.mem_enc_ioctl)
 			goto out;
 
-		r = static_call(kvm_x86_mem_enc_ioctl)(kvm, argp);
+		if (!argp) {
+			r = 0;
+			goto out;
+		}
+
+		if (copy_from_user(&cmd, argp, sizeof(cmd))) {
+			r = -EFAULT;
+			goto out;
+		}
+		r = static_call(kvm_x86_mem_enc_ioctl)(kvm, &cmd);
+		if (copy_to_user(argp, &cmd, sizeof(cmd)))
+			r = -EFAULT;
+
 		break;
 	}
 	case KVM_MEMORY_ENCRYPT_REG_REGION: {

base-commit: 831fe284d8275987596b7d640518dddba5735f61
-- 
2.25.1

