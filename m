Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4A5FBFBDE
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 01:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729054AbfIZXT0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 19:19:26 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:34949 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729075AbfIZXTZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 19:19:25 -0400
Received: by mail-pl1-f201.google.com with SMTP id o12so481502pll.2
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 16:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=rjAV0P/C6E3BGhkruiYDZPulhPa8Gd0ceWhLOWGPyq4=;
        b=SZn15o0788D3ocpRkzfN4Dzt1Lh1ZZmALbCZM+rU97IjwYgC/ughizxyXYOAu+xCJq
         OxMFHPWRGHpMQf0bOKGfl9d/JJh3PVHR3+cinysHcY+4HBvf0GLwm38Pen8UBRagX8j/
         NL8R7UJBmIFCdWmDMiCNKL9l8NmFjcAn5cfDVZNjIKmJP8KVdF0CX1DBgZ8+/k3iXwHD
         0DVYvJvRHAjJHsTG9sFkAZYFi5AcWpCcnC7NR08IW5rlnJVX9Fi/A33mVZ5y0i7bjXXB
         QImToM9c0oiyCHHSRj0vuaLPhlIs8DVDrUjTw6CoAUub/l6LovTRMho+uTMyHm/0L9qH
         CePw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rjAV0P/C6E3BGhkruiYDZPulhPa8Gd0ceWhLOWGPyq4=;
        b=VFiIah5K4024UzM5hWV6mUF9Oin9QSqTr/bSu8owbMCh6BLdiY1qDIvQ2yNSfyzSM9
         nSAkuJeOO6owd3ZBS6GWsxLaKlUFtRaUtfQ3t9pV4Ny8XLiT8bQDWaSlCq+IZSOWVpId
         GlmOgqleF8QO6eb5lenxVxatlzkc+P0sIO4kddgOuasaODOWvgaRR5C8WILZArQiHUpX
         CA3O34fujbSxvANfqSDVDbrZnsFLFcLmdEOqSKpftzH8h1xddxxwUQyNi9NgaHJYyefX
         WGNmiA/MrAUjkDZVHBMWbxyUMRuM6m51uW9kfYqJP8Xam5GDP4aFZcwvw9fAOFJi4QJk
         XIow==
X-Gm-Message-State: APjAAAXcOfyp/UYV2ZOLu9ahB2LAuTepq0znBNFXPg48XtFsV9TLMOKT
        i0h9mfq4n4YLx383GI+rEQ2K4v29Qm6IyeazBKWQ6Q2VKoNBhdn2q4/56abmKY4GElaGisWhugC
        RZ4yFlROWxHp5C0r+hoteMEEw7xltkB0nnQRTvK4kTc4jgScsosjIpMqkLrp1
X-Google-Smtp-Source: APXvYqwSd5rwD/xI88cGwMjUAafzG6rKacbAvolJihEMJJHVyDqNvLwvvYkvusHISF1WlBWPtQ+mNPsq7IK/
X-Received: by 2002:a63:e512:: with SMTP id r18mr5892821pgh.117.1569539964969;
 Thu, 26 Sep 2019 16:19:24 -0700 (PDT)
Date:   Thu, 26 Sep 2019 16:18:21 -0700
In-Reply-To: <20190926231824.149014-1-bgardon@google.com>
Message-Id: <20190926231824.149014-26-bgardon@google.com>
Mime-Version: 1.0
References: <20190926231824.149014-1-bgardon@google.com>
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
Subject: [RFC PATCH 25/28] kvm: mmu: Support kvm_zap_gfn_range in the direct MMU
From:   Ben Gardon <bgardon@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a function for zapping ranges of GFNs in a memslot to support
kvm_zap_gfn_range for the direct MMU.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu.c | 27 +++++++++++++++++++++------
 arch/x86/kvm/mmu.h |  2 ++
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index ca58b27a17c52..a0c5271ae2381 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -7427,13 +7427,32 @@ void kvm_mmu_uninit_vm(struct kvm *kvm)
 	kvm_mmu_uninit_direct_mmu(kvm);
 }
 
+void kvm_zap_slot_gfn_range(struct kvm *kvm, struct kvm_memory_slot *memslot,
+			    gfn_t start, gfn_t end)
+{
+	write_lock(&kvm->mmu_lock);
+	if (kvm->arch.direct_mmu_enabled) {
+		zap_direct_gfn_range(kvm, memslot->as_id, start, end,
+				     MMU_READ_LOCK);
+	}
+
+	if (kvm->arch.pure_direct_mmu) {
+		write_unlock(&kvm->mmu_lock);
+		return;
+	}
+
+	slot_handle_level_range(kvm, memslot, kvm_zap_rmapp,
+				PT_PAGE_TABLE_LEVEL, PT_MAX_HUGEPAGE_LEVEL,
+				start, end - 1, true);
+	write_unlock(&kvm->mmu_lock);
+}
+
 void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 {
 	struct kvm_memslots *slots;
 	struct kvm_memory_slot *memslot;
 	int i;
 
-	write_lock(&kvm->mmu_lock);
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
 		slots = __kvm_memslots(kvm, i);
 		kvm_for_each_memslot(memslot, slots) {
@@ -7444,13 +7463,9 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 			if (start >= end)
 				continue;
 
-			slot_handle_level_range(kvm, memslot, kvm_zap_rmapp,
-						PT_PAGE_TABLE_LEVEL, PT_MAX_HUGEPAGE_LEVEL,
-						start, end - 1, true);
+			kvm_zap_slot_gfn_range(kvm, memslot, start, end);
 		}
 	}
-
-	write_unlock(&kvm->mmu_lock);
 }
 
 static bool slot_rmap_write_protect(struct kvm *kvm,
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 11f8ec89433b6..4ea8a72c8868d 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -204,6 +204,8 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 }
 
 void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
+void kvm_zap_slot_gfn_range(struct kvm *kvm, struct kvm_memory_slot *memslot,
+			    gfn_t start, gfn_t end);
 
 void kvm_mmu_gfn_disallow_lpage(struct kvm_memory_slot *slot, gfn_t gfn);
 void kvm_mmu_gfn_allow_lpage(struct kvm_memory_slot *slot, gfn_t gfn);
-- 
2.23.0.444.g18eeb5a265-goog

