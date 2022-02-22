Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4B34BF23F
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 07:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbiBVGsK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 01:48:10 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:35432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbiBVGsK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 01:48:10 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B6310DA41
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 22:47:45 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id l8so14784411pls.7
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 22:47:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zyP1CDnBZz+or+GUa/iSW1eRXWHN1F8ZgUdecrqgvGI=;
        b=SWk/strLjmDoEYAWt8Ial+BNg08vwBhkBUAUTiIrOm0h9JzI9089awMslPw9rrQLM7
         lr7eqFEnycVzvez1IMdL38nWgBzcV/Muzj7l9r2/Y/wnO4J0AK6f/gdoaMhS2FpggY0L
         HNQGzdbKs0vr0wKftafgEUGw4oA9MQLroskGgNNSFXht6N/jr79GE/r6sT1/D5ikaEwj
         cl5EKakhOpx+Xs+8iQXiOzjWazMY1zUol1+d8KkdovxV+sl7CJET1TjvOgSRxPGe74bl
         P8Dzcpr9ScGa3N16cBFtl902HqQUAJTrPCgUImxPQTd8EXV1+az5rNzsTToy58GgH0jF
         rmZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zyP1CDnBZz+or+GUa/iSW1eRXWHN1F8ZgUdecrqgvGI=;
        b=ifulj7NQdEKJP6PyXHZHfEUypOxuT3NkVpAsit/TyAIBpNaG+4qGCOioMVCrCpPDVw
         IBbKWixykOIb/1XTyEs6WjjSS99qgn5SMbllIjKtZOtLo71Xk7q35yHpPx2DaYI0o+0w
         StQuYfxqxyPtCKK60pWHonyMt7NsOOEnsf2NgiiwC/nqvfYaWWuESesuCTPqmTQZnAkJ
         XKOcKQSBEDA80jkQXR3jC2pcaHnC/sczmkueoriukKAvPIPRqUCNX5JMjvz4GKbyGASF
         mvr8T5jje+9d8iz1hRQlnvPx/X7Q6GP+Am/C45f1K2e+IpzmuIGqBWbjnS37vXFx7e1E
         4HHw==
X-Gm-Message-State: AOAM530jXF8S+YQFq/3+zvMxCXgnLOXIhMGrNxIapBD2tNXITH2HlteY
        ufITcoYBm2Oi3Fbvb65Pwn4=
X-Google-Smtp-Source: ABdhPJzOfiyirnWhuN3Uc4DQ4wrL7Ir3DNaGBfpOD/pWn21PotYcLFLrspNR2ceR5MpdIJgZliatsA==
X-Received: by 2002:a17:90a:9288:b0:1bc:568b:55bc with SMTP id n8-20020a17090a928800b001bc568b55bcmr2678772pjo.9.1645512465185;
        Mon, 21 Feb 2022 22:47:45 -0800 (PST)
Received: from bobo.ibm.com (193-116-225-41.tpgi.com.au. [193.116.225.41])
        by smtp.gmail.com with ESMTPSA id d8sm16346711pfv.84.2022.02.21.22.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 22:47:44 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v4 3/3] KVM: PPC: Add KVM_CAP_PPC_AIL_MODE_3
Date:   Tue, 22 Feb 2022 16:47:27 +1000
Message-Id: <20220222064727.2314380-4-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20220222064727.2314380-1-npiggin@gmail.com>
References: <20220222064727.2314380-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add KVM_CAP_PPC_AIL_MODE_3 to advertise the capability to set the AIL
resource mode to 3 with the H_SET_MODE hypercall. This capability
differs between processor types and KVM types (PR, HV, Nested HV), and
affects guest-visible behaviour.

QEMU will implement a cap-ail-mode-3 to control this behaviour[1], and
use the KVM CAP if available to determine KVM support[2].

[1] https://lists.nongnu.org/archive/html/qemu-ppc/2022-02/msg00437.html
[2] https://lists.nongnu.org/archive/html/qemu-ppc/2022-02/msg00439.html

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 Documentation/virt/kvm/api.rst         | 14 ++++++++++++++
 arch/powerpc/include/asm/setup.h       |  2 ++
 arch/powerpc/kvm/powerpc.c             | 17 +++++++++++++++++
 arch/powerpc/platforms/pseries/setup.c | 12 +++++++++++-
 include/uapi/linux/kvm.h               |  1 +
 tools/include/uapi/linux/kvm.h         |  1 +
 6 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index a4267104db50..9954568c7eab 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6997,6 +6997,20 @@ indicated by the fd to the VM this is called on.
 This is intended to support intra-host migration of VMs between userspace VMMs,
 upgrading the VMM process without interrupting the guest.
 
+7.30 KVM_CAP_PPC_AIL_MODE_3
+-------------------------------
+
+:Capability: KVM_CAP_PPC_AIL_MODE_3
+:Architectures: ppc
+:Type: vm
+
+This capability indicates that the kernel supports the mode 3 setting for the
+"Address Translation Mode on Interrupt" aka "Alternate Interrupt Location"
+resource that is controlled with the H_SET_MODE hypercall.
+
+This capability allows a guest kernel to use a better-performance mode for
+handling interrupts and system calls.
+
 8. Other capabilities.
 ======================
 
diff --git a/arch/powerpc/include/asm/setup.h b/arch/powerpc/include/asm/setup.h
index d0d3dd531c7f..a555fb77258a 100644
--- a/arch/powerpc/include/asm/setup.h
+++ b/arch/powerpc/include/asm/setup.h
@@ -28,11 +28,13 @@ void setup_panic(void);
 #define ARCH_PANIC_TIMEOUT 180
 
 #ifdef CONFIG_PPC_PSERIES
+extern bool pseries_reloc_on_exception(void);
 extern bool pseries_enable_reloc_on_exc(void);
 extern void pseries_disable_reloc_on_exc(void);
 extern void pseries_big_endian_exceptions(void);
 void __init pseries_little_endian_exceptions(void);
 #else
+static inline bool pseries_reloc_on_exception(void) { return false; }
 static inline bool pseries_enable_reloc_on_exc(void) { return false; }
 static inline void pseries_disable_reloc_on_exc(void) {}
 static inline void pseries_big_endian_exceptions(void) {}
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 2ad0ccd202d5..56a6b66d16fe 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -678,6 +678,23 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = 1;
 		break;
 #endif
+	case KVM_CAP_PPC_AIL_MODE_3:
+		r = 0;
+		/*
+		 * KVM PR, POWER7, and some POWER9s don't support AIL=3 mode.
+		 * The POWER9s can support it if the guest runs in hash mode,
+		 * but QEMU doesn't necessarily query the capability in time.
+		 */
+		if (hv_enabled) {
+			if (kvmhv_on_pseries()) {
+				if (pseries_reloc_on_exception())
+					r = 1;
+			} else if (cpu_has_feature(CPU_FTR_ARCH_207S) &&
+				  !cpu_has_feature(CPU_FTR_P9_RADIX_PREFETCH_BUG)) {
+				r = 1;
+			}
+		}
+		break;
 	default:
 		r = 0;
 		break;
diff --git a/arch/powerpc/platforms/pseries/setup.c b/arch/powerpc/platforms/pseries/setup.c
index 83a04d967a59..182525c2abd5 100644
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -353,6 +353,13 @@ static void pseries_lpar_idle(void)
 	pseries_idle_epilog();
 }
 
+static bool pseries_reloc_on_exception_enabled;
+
+bool pseries_reloc_on_exception(void)
+{
+	return pseries_reloc_on_exception_enabled;
+}
+
 /*
  * Enable relocation on during exceptions. This has partition wide scope and
  * may take a while to complete, if it takes longer than one second we will
@@ -377,6 +384,7 @@ bool pseries_enable_reloc_on_exc(void)
 					" on exceptions: %ld\n", rc);
 				return false;
 			}
+			pseries_reloc_on_exception_enabled = true;
 			return true;
 		}
 
@@ -404,7 +412,9 @@ void pseries_disable_reloc_on_exc(void)
 			break;
 		mdelay(get_longbusy_msecs(rc));
 	}
-	if (rc != H_SUCCESS)
+	if (rc == H_SUCCESS)
+		pseries_reloc_on_exception_enabled = false;
+	else
 		pr_warn("Warning: Failed to disable relocation on exceptions: %ld\n",
 			rc);
 }
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 5191b57e1562..507ee1f2aa96 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1134,6 +1134,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_VM_GPA_BITS 207
 #define KVM_CAP_XSAVE2 208
 #define KVM_CAP_SYS_ATTRIBUTES 209
+#define KVM_CAP_PPC_AIL_MODE_3 210
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index 5191b57e1562..507ee1f2aa96 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -1134,6 +1134,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_VM_GPA_BITS 207
 #define KVM_CAP_XSAVE2 208
 #define KVM_CAP_SYS_ATTRIBUTES 209
+#define KVM_CAP_PPC_AIL_MODE_3 210
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.23.0

