Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3004E15CD4A
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 22:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387414AbgBMVav (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Feb 2020 16:30:51 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41963 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728685AbgBMVav (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Feb 2020 16:30:51 -0500
Received: by mail-pg1-f193.google.com with SMTP id 70so3787098pgf.8
        for <kvm@vger.kernel.org>; Thu, 13 Feb 2020 13:30:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DG+sC065wv/LqT/1QFpUrBb6eJ4oJu7xTukCQgs4qZI=;
        b=beFPM7qyKZAOPM6XrFUgkxr4sKe18G6WJ44lZKteVhn7xUcVt+5lgnlU5reXySx0py
         mj38GDA8/I/oNdPPwpfGsECeogJ5pkenZ8o3juAkAex8W7aWjitOXAlWG1AVn0xFr5kZ
         a/pp5ZXlwA7K70WSGHoHQ7scvR5dgg8vAqgQEZpxoJp75LPVsA8fxCS79/cZcDll7QJf
         +wBCpLCRvtPKLTq0Z+2yvqBopTDgRkaGbAuoZtVzWhBlBjeDALCakqi7hhftDBVtifya
         Hv+wpjNhn9Gw4mQV7gmpOYF27rlm8tfbzi1QvbbWWJR6C5ItSRNVQ7TiTqFyXr80aSnS
         BfZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DG+sC065wv/LqT/1QFpUrBb6eJ4oJu7xTukCQgs4qZI=;
        b=exfUEGXXQnf+dfvZVxW2v7yoQvZnul4zLQQaZ7CbkOScAcBIqtwf0dh+0WVrnXhNzc
         Ou3yKGmcoVLGSaAGRpBwPm9bpQ+d7lq4gLTiS7sJ74+pBETiAtpHOrrQjkqfaedgjf5i
         zHHUdnuKafxemV3amIw1xSTLte4wneEjNbJNtKuLnW/Nr+GsKtjPPCRZdzUM1fwgYyUk
         Y6RoLiTkPFaKiDMHQEFGC9UkBikK8pENtSH2pOSKYD+5v/C2De2A+APf+FTW/fYIkjJq
         Zg31HirHwHvyUxsiceQQi8S6lmYJFNs+CTwlTieMb2K6yNNDI3HvCSsC4bxW+ai0MpFK
         z+0Q==
X-Gm-Message-State: APjAAAWj4JVFvSt6tmVkWxwFXPus82W/h8HtkUoiJbbUOMMVcEB9hWv6
        y01C+mkMdgmPlz2E6e/YZClWR8y6
X-Google-Smtp-Source: APXvYqyC4/eQjrcqgMEtd9bRzFz57SaLWVVcql322CjrzbZzBAKrZ5Uy6k+kTxrjDV6fGdkKFachhQ==
X-Received: by 2002:aa7:84cd:: with SMTP id x13mr19792586pfn.130.1581629450470;
        Thu, 13 Feb 2020 13:30:50 -0800 (PST)
Received: from olv0.mtv.corp.google.com ([2620:15c:202:201:9649:82d6:f889:b307])
        by smtp.gmail.com with ESMTPSA id s130sm4346683pfc.62.2020.02.13.13.30.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 13:30:50 -0800 (PST)
From:   Chia-I Wu <olvaffe@gmail.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, gurchetansingh@chromium.org,
        kraxel@redhat.com, dri-devel@lists.freedesktop.org
Subject: [RFC PATCH 3/3] RFC: KVM: x86: support KVM_CAP_DMA_MEM
Date:   Thu, 13 Feb 2020 13:30:36 -0800
Message-Id: <20200213213036.207625-4-olvaffe@gmail.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
In-Reply-To: <20200213213036.207625-1-olvaffe@gmail.com>
References: <20200213213036.207625-1-olvaffe@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a memslot has KVM_MEM_DMA set, we want VMX_EPT_IPAT_BIT cleared
for the memslot.  Before that is possible, simply call
kvm_arch_register_noncoherent_dma for the memslot.

SVM does not have the ignore-pat bit.  Guest PAT is always honored.

Signed-off-by: Chia-I Wu <olvaffe@gmail.com>
Cc: Gurchetan Singh <gurchetansingh@chromium.org>
Cc: Gerd Hoffmann <kraxel@redhat.com>
---
 arch/x86/include/uapi/asm/kvm.h | 1 +
 arch/x86/kvm/x86.c              | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 503d3f42da16..578b686e3880 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -48,6 +48,7 @@
 #define __KVM_HAVE_XSAVE
 #define __KVM_HAVE_XCRS
 #define __KVM_HAVE_READONLY_MEM
+#define __KVM_HAVE_DMA_MEM
 
 /* Architectural interrupt line count. */
 #define KVM_NR_INTERRUPTS 256
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fb5d64ebc35d..c89a4647fef6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3331,6 +3331,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_GET_TSC_KHZ:
 	case KVM_CAP_KVMCLOCK_CTRL:
 	case KVM_CAP_READONLY_MEM:
+	case KVM_CAP_DMA_MEM:
 	case KVM_CAP_HYPERV_TIME:
 	case KVM_CAP_IOAPIC_POLARITY_IGNORED:
 	case KVM_CAP_TSC_DEADLINE_TIMER:
@@ -10045,6 +10046,11 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 	 */
 	if (change != KVM_MR_DELETE)
 		kvm_mmu_slot_apply_flags(kvm, (struct kvm_memory_slot *) new);
+
+	if (change == KVM_MR_CREATE && new->flags & KVM_MEM_DMA)
+		kvm_arch_register_noncoherent_dma(kvm);
+	else if (change == KVM_MR_DELETE && old->flags & KVM_MEM_DMA)
+		kvm_arch_unregister_noncoherent_dma(kvm);
 }
 
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
-- 
2.25.0.265.gbab2e86ba0-goog

