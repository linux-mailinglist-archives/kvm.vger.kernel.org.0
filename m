Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F03CF433A87
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 17:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233890AbhJSPe4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 11:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233335AbhJSPeu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 11:34:50 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82743C06161C
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 08:32:37 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id k26so249942pfi.5
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 08:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Fxvvbxs7gfwj8X673aD2/pAKWVOalT8g3gZlZ6FiINc=;
        b=RKV3BzMqw22aCESASRVbdyruWIJLyRFzVu0OHYX0qeth1T46S12eZ3FmGN5WzCkki7
         3N2gswTwIJL3oMgOyLrY4LoJiU/QhjfXVpTy1eaaBl7wsO3W8488qy06HpjeuPTV0Kh8
         SNEIglpT495UE8UxzrI8JLK4kwnc8f2yDq7lc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Fxvvbxs7gfwj8X673aD2/pAKWVOalT8g3gZlZ6FiINc=;
        b=14ZaGJTcuLiXnUQ4flzog7Yj5d1NBOfqEpf1iIgs7VvQyLLvhDRXaoHO37MX2EHjx6
         9zuAt0DijZmY70Lmo87XPkfW0arFfu841ZCooRBx0R1ViqTdOUs9XpiEZynz/B95qY/p
         k+wE0Scq+WPsbW9dSGI1T3VOrHTTNSJhIETbHgWR53hx7et9GKKv9+TEzIPcDuYGlZ16
         5GLXibl5gnGwlbTrUyrYS3rh6lhAJdRXNTaiWJHofACim7e4d8e6VZsMLVFJAQS/yS2A
         vaJcbQj84OOr/m3M03v+Dq4eYgxXVQjLF069ydP2yGMMYEt5bQPgVI8ZTMJpriPZ9Pxz
         Un7Q==
X-Gm-Message-State: AOAM533gAAJeJRLYpDZw2paXDHKT3rfSxG8PIKiuC/5CzTqEftYDkFgc
        9vlRemvzV4o6okvggBAGCK/ZUw==
X-Google-Smtp-Source: ABdhPJxFoLLzZT1e5zp7U+EpZj6f6YwumDONO8bkV09WKsn9ifAPoA0OBXm5zLIesrROI7D0GEIuKg==
X-Received: by 2002:a63:b04c:: with SMTP id z12mr28743687pgo.371.1634657556924;
        Tue, 19 Oct 2021 08:32:36 -0700 (PDT)
Received: from senozhatsky.flets-east.jp ([2409:10:2e40:5100:490f:f89:7449:e615])
        by smtp.gmail.com with ESMTPSA id v8sm3087474pjd.7.2021.10.19.08.32.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 08:32:36 -0700 (PDT)
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suleiman Souhlal <suleiman@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCHV2 3/3] KVM: x86: add KVM_SET_MMU_PREFETCH ioctl
Date:   Wed, 20 Oct 2021 00:32:14 +0900
Message-Id: <20211019153214.109519-4-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211019153214.109519-1-senozhatsky@chromium.org>
References: <20211019153214.109519-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This ioctl lets user-space set the number of PTEs KVM will
prefetch:

-  pte_prefetch 8

             VM-EXIT    Samples  Samples%     Time%    Min Time    Max Time         Avg time

       EPT_VIOLATION     760998    54.85%     7.23%      0.92us  31765.89us      7.78us ( +-   1.46% )
           MSR_WRITE     170599    12.30%     0.53%      0.60us   3334.13us      2.52us ( +-   0.86% )
  EXTERNAL_INTERRUPT     159510    11.50%     1.65%      0.49us  43705.81us      8.45us ( +-   7.54% )
[..]

Total Samples:1387305, Total events handled time:81900258.99us.

- pte_prefetch 16

             VM-EXIT    Samples  Samples%     Time%    Min Time    Max Time         Avg time

       EPT_VIOLATION     658064    52.58%     7.04%      0.91us  17022.84us      8.34us ( +-   1.52% )
           MSR_WRITE     163776    13.09%     0.54%      0.56us   5192.10us      2.57us ( +-   1.25% )
  EXTERNAL_INTERRUPT     144588    11.55%     1.62%      0.48us  97410.16us      8.75us ( +-  11.44% )
[..]

Total Samples:1251546, Total events handled time:77956187.56us.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 Documentation/virt/kvm/api.rst | 21 +++++++++++++++++++++
 arch/x86/kvm/x86.c             | 29 +++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h       |  4 ++++
 3 files changed, 54 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 0c0bf26426b3..b06b7c11a430 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5473,6 +5473,17 @@ the trailing ``'\0'``, is indicated by ``name_size`` in the header.
 The Stats Data block contains an array of 64-bit values in the same order
 as the descriptors in Descriptors block.
 
+4.134 KVM SET MMU PREFETCH
+----------------------
+
+:Capability: KVM_CAP_MMU PREFETCH
+:Architectures: x86
+:Type: vm ioctl
+:Parameters: int value (in)
+:Returns: 0 on success, error code otherwise
+
+Sets the maximum number of PTEs KVM will try to prefetch.
+
 5. The kvm_run structure
 ========================
 
@@ -7440,3 +7451,13 @@ The argument to KVM_ENABLE_CAP is also a bitmask, and must be a subset
 of the result of KVM_CHECK_EXTENSION.  KVM will forward to userspace
 the hypercalls whose corresponding bit is in the argument, and return
 ENOSYS for the others.
+
+8.35 KVM_CAP_MMU_PTE_PREFETCH
+---------------------------
+
+:Capability: KVM_CAP_MMU_PTE_PREFETCH
+:Architectures: x86
+:Parameters: args[0] - the number of PTEs to prefetch
+
+Sets the maximum number of PTEs KVM will prefetch. The value must be power
+of two and within (0, 128] range.
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4805960a89e6..e1b2224c4176 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4030,6 +4030,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_VM_COPY_ENC_CONTEXT_FROM:
 	case KVM_CAP_SREGS2:
 	case KVM_CAP_EXIT_ON_EMULATION_FAILURE:
+	case KVM_CAP_MMU_PTE_PREFETCH:
 		r = 1;
 		break;
 	case KVM_CAP_EXIT_HYPERCALL:
@@ -5831,6 +5832,25 @@ int kvm_arch_pm_notifier(struct kvm *kvm, unsigned long state)
 }
 #endif /* CONFIG_HAVE_KVM_PM_NOTIFIER */
 
+static int kvm_arch_mmu_pte_prefetch(struct kvm *kvm, unsigned int num_pages)
+{
+	struct kvm_vcpu *vcpu;
+	int i, ret;
+
+	mutex_lock(&kvm->lock);
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		ret = kvm_set_pte_prefetch(vcpu, num_pages);
+		if (ret) {
+			kvm_err("Failed to set PTE prefetch on VCPU%d: %d\n",
+				vcpu->vcpu_id, ret);
+			break;
+		}
+	}
+	mutex_unlock(&kvm->lock);
+
+	return ret;
+}
+
 static int kvm_vm_ioctl_get_clock(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_clock_data data;
@@ -6169,6 +6189,15 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	case KVM_X86_SET_MSR_FILTER:
 		r = kvm_vm_ioctl_set_msr_filter(kvm, argp);
 		break;
+	case KVM_SET_MMU_PREFETCH: {
+		u64 val;
+
+		r = -EFAULT;
+		if (copy_from_user(&val, argp, sizeof(val)))
+			goto out;
+		r = kvm_arch_mmu_pte_prefetch(kvm, val);
+		break;
+	}
 	default:
 		r = -ENOTTY;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 322b4b588d75..0782eb4c424d 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1120,6 +1120,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_BINARY_STATS_FD 203
 #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
 #define KVM_CAP_ARM_MTE 205
+#define KVM_CAP_MMU_PTE_PREFETCH 206
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -2015,4 +2016,7 @@ struct kvm_stats_desc {
 
 #define KVM_GET_STATS_FD  _IO(KVMIO,  0xce)
 
+/* Set number of PTEs to prefetch */
+#define KVM_SET_MMU_PREFETCH      _IOW(KVMIO, 0xcf, __u64)
+
 #endif /* __LINUX_KVM_H */
-- 
2.33.0.1079.g6e70778dc9-goog

