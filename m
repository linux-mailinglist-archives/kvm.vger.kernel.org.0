Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3A8410275
	for <lists+kvm@lfdr.de>; Sat, 18 Sep 2021 02:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243233AbhIRA6R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Sep 2021 20:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243226AbhIRA6P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Sep 2021 20:58:15 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CAD6C061574;
        Fri, 17 Sep 2021 17:56:53 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id m21-20020a17090a859500b00197688449c4so8637931pjn.0;
        Fri, 17 Sep 2021 17:56:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UL21jgKxaRNfyyPYg4v6IIayXHcpZPBqIuWPy8p1uvE=;
        b=XAoXjyri0mY+WG5j86PR9O9ZcQGr7+u2d9X+6WlbhOongfQM7zUMh5EEIT7N+AmLa1
         MBO1PalAsV5TJ2jPVTgwPf6YlGBw9E6K7UzKJJYsVgCIrsZoPIS+TLHNZpIFxyP7fE2F
         bsbfbSD8tFVztoSEgOjlk/JMORUXCsf0MVTprSsheIiYMMtQudQ/t6tDoasYF/Yg7kxH
         ViBne3MnaZ611iYTfAslsn8lfLyReXkcnS+OT1Opvz5mRFpSjTRutPAt0zji8vFgoBGw
         DerEXyw6Jmd8zchwruqkK7nJQwCSWqM6Ye6iOyK3X/xp1UyPdJC45hKWx/CUF+A/s/KZ
         CLOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UL21jgKxaRNfyyPYg4v6IIayXHcpZPBqIuWPy8p1uvE=;
        b=H8D6oIJG+4WkoCQ5MfQlJJjYOIdXtYvKdGWk8ak2wLYTruTjilPNBsl/vsJqaIOqws
         QvPz3SjM0VGcg9Argi7U4DVyA+d/BTsypB+dAx0o7GZhAwANmgito7+rTAXrLnEAA0m8
         OlSYQRRO9ovZvKy15yGdkEK0W053HiDiESwUBl7ii9FYk/zXGMu/5JoDGDhlLXI7AGq3
         3FcesVSyJa1FIRhirm39mPJlu3VeSLjvmiT+gFgyR/CElWjHyt0f7Tq7jI8KGDJLDwb5
         UVeJhOlIbPndmogSFF64CC7N3qMUCwlqgbgmfUg5+sCRlm7uKLMSIzcTJGjyXU5G26qn
         GbJw==
X-Gm-Message-State: AOAM532CUoveoO2IJQDpNsd8eHr7tpS1WVVtXq1lLIsX5COZmSRPYN8z
        j8PQo4IdlHXNPKqJqIQbG1dTVMXefi4=
X-Google-Smtp-Source: ABdhPJzYSl4L5+MVfLtGnecSW9sPmboRcWzOTv2xMmBbLdA2kBzvmaYOjKdH7VgaX71/iEcuhRapCQ==
X-Received: by 2002:a17:90a:5513:: with SMTP id b19mr24764709pji.16.1631926612587;
        Fri, 17 Sep 2021 17:56:52 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id 141sm7370396pgg.16.2021.09.17.17.56.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 Sep 2021 17:56:52 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH V2 03/10] KVM: Remove tlbs_dirty
Date:   Sat, 18 Sep 2021 08:56:29 +0800
Message-Id: <20210918005636.3675-4-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20210918005636.3675-1-jiangshanlai@gmail.com>
References: <20210918005636.3675-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

There is no user of tlbs_dirty.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 include/linux/kvm_host.h | 1 -
 virt/kvm/kvm_main.c      | 9 +--------
 2 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e4d712e9f760..3b7846cd0637 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -608,7 +608,6 @@ struct kvm {
 	unsigned long mmu_notifier_range_start;
 	unsigned long mmu_notifier_range_end;
 #endif
-	long tlbs_dirty;
 	struct list_head devices;
 	u64 manual_dirty_log_protect;
 	struct dentry *debugfs_dentry;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3e67c93ca403..6d6be42ec78d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -312,12 +312,6 @@ EXPORT_SYMBOL_GPL(kvm_make_all_cpus_request);
 #ifndef CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL
 void kvm_flush_remote_tlbs(struct kvm *kvm)
 {
-	/*
-	 * Read tlbs_dirty before setting KVM_REQ_TLB_FLUSH in
-	 * kvm_make_all_cpus_request.
-	 */
-	long dirty_count = smp_load_acquire(&kvm->tlbs_dirty);
-
 	/*
 	 * We want to publish modifications to the page tables before reading
 	 * mode. Pairs with a memory barrier in arch-specific code.
@@ -332,7 +326,6 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
 	if (!kvm_arch_flush_remote_tlb(kvm)
 	    || kvm_make_all_cpus_request(kvm, KVM_REQ_TLB_FLUSH))
 		++kvm->stat.generic.remote_tlb_flush;
-	cmpxchg(&kvm->tlbs_dirty, dirty_count, 0);
 }
 EXPORT_SYMBOL_GPL(kvm_flush_remote_tlbs);
 #endif
@@ -537,7 +530,7 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 		}
 	}
 
-	if (range->flush_on_ret && (ret || kvm->tlbs_dirty))
+	if (range->flush_on_ret && ret)
 		kvm_flush_remote_tlbs(kvm);
 
 	if (locked)
-- 
2.19.1.6.gb485710b

