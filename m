Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E38F39115E
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 09:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232971AbhEZHZt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 03:25:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232844AbhEZHZr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 03:25:47 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9364EC061574;
        Wed, 26 May 2021 00:24:15 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id b7so196050plg.0;
        Wed, 26 May 2021 00:24:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mcGhWCWPLrAkZ1CyWh+58HU300HwJblNW/+1rM/WIVQ=;
        b=OdjOPXZ5jJRQk+4MqWx/nGmFpf1HUkJ3ksBzBlwhXMSTbA9ehAVTHiKPXAhTffFeYB
         MKeutovJTUOR7rj8nMXsYyfCqvXfJHpQrn7fcbWNVyU1sbh5m2+miJVskJfHDrd3/iuK
         tSSG9NJa1aIMyUWlsTw456yNBmePyvCBtbTU2Z6jheYr0oVbSFKlkC+cpfGXb5UVVY4Z
         D+rhgYuSunsYPLfpc5uJj91nzBA01GL6bJX/yq9tjJIjF0JmPEQOCr2rYbTkC98LrieO
         KqyZt689vGVwJcfkOGP2cruDf8h0BroHRoWu81+maBHrYAo4lH0XGWutKhSrl+J23ioB
         cDMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mcGhWCWPLrAkZ1CyWh+58HU300HwJblNW/+1rM/WIVQ=;
        b=JFImZx3jxip2D1o5KhZaqhumyvoRnjoyBXjnIC0G/B1b8uM3JYbj3qEC706BrIkLXj
         z0zRm33E1fhO3eioT9/Tvvzdu/9i+JM/K3LukY3FW7lTLi6weMFEuF5Ic0NnZ2F4+mi2
         P5KmdT+x4qyJblZs/+rI306pu4oDcmJCqW43GeRHXqT5JFI4T1QRLKmlUIzY+Qlyt12h
         6WipeRpjWKzGZcp7pb0jPfWtjj489ttuLa59pZao4q1cHlFfEl2a8hMrGlQjBQu6Kyrr
         A/FFdHWPD60cPlv6SO4GYKcLxsbuQJ2qUHogHEXnsoc8u7JXaFhvTxXClmpa5QEIro0D
         Jacw==
X-Gm-Message-State: AOAM532A6h+hjY2W2d0WhZmrj6N8+0/7DvG+iHM2HoY9ko6LryUVpYdN
        dZ7murUYOQfo+/ZAMWMFoCQVMWVSnBQ=
X-Google-Smtp-Source: ABdhPJwDoSy6mzbd328vxfnHpHaNrncjMmHieHYlGsTKCZTPYg3f7TV7lR+5Jw4f5T2Lo/okUCxOmQ==
X-Received: by 2002:a17:902:bc44:b029:fd:ea73:a2d0 with SMTP id t4-20020a170902bc44b02900fdea73a2d0mr143015plz.3.1622013854929;
        Wed, 26 May 2021 00:24:14 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id 184sm14496127pfv.38.2021.05.26.00.24.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 May 2021 00:24:14 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: [RFC PATCH] kvm/x86: Keep root hpa in prev_roots as much as possible
Date:   Wed, 26 May 2021 05:39:20 +0800
Message-Id: <20210525213920.3340-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

Pagetable roots in prev_roots[] are likely to be reused soon and
there is no much overhead to keep it with a new need_sync field
introduced.

With the help of the new need_sync field, pagetable roots are
kept as much as possible, and they will be re-synced before reused
instead of being dropped.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---

This patch is just for RFC.
  Is the idea Ok?
  If the idea is Ok, we need to reused one bit from pgd or hpa
    as need_sync to save memory.  Which one is better?

 arch/x86/include/asm/kvm_host.h |  3 ++-
 arch/x86/kvm/mmu/mmu.c          |  6 ++++++
 arch/x86/kvm/vmx/nested.c       | 12 ++++--------
 arch/x86/kvm/x86.c              |  9 +++++----
 4 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 55efbacfc244..19a337cf7aa6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -354,10 +354,11 @@ struct rsvd_bits_validate {
 struct kvm_mmu_root_info {
 	gpa_t pgd;
 	hpa_t hpa;
+	bool need_sync;
 };
 
 #define KVM_MMU_ROOT_INFO_INVALID \
-	((struct kvm_mmu_root_info) { .pgd = INVALID_PAGE, .hpa = INVALID_PAGE })
+	((struct kvm_mmu_root_info) { .pgd = INVALID_PAGE, .hpa = INVALID_PAGE, .need_sync = true})
 
 #define KVM_MMU_NUM_PREV_ROOTS 3
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5e60b00e8e50..147827135549 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3878,6 +3878,7 @@ static bool cached_root_available(struct kvm_vcpu *vcpu, gpa_t new_pgd,
 
 	root.pgd = mmu->root_pgd;
 	root.hpa = mmu->root_hpa;
+	root.need_sync = false;
 
 	if (is_root_usable(&root, new_pgd, new_role))
 		return true;
@@ -3892,6 +3893,11 @@ static bool cached_root_available(struct kvm_vcpu *vcpu, gpa_t new_pgd,
 	mmu->root_hpa = root.hpa;
 	mmu->root_pgd = root.pgd;
 
+	if (i < KVM_MMU_NUM_PREV_ROOTS && root.need_sync) {
+		kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
+		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
+	}
+
 	return i < KVM_MMU_NUM_PREV_ROOTS;
 }
 
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 6058a65a6ede..ab7069ac6dc5 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5312,7 +5312,7 @@ static int handle_invept(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u32 vmx_instruction_info, types;
-	unsigned long type, roots_to_free;
+	unsigned long type;
 	struct kvm_mmu *mmu;
 	gva_t gva;
 	struct x86_exception e;
@@ -5361,29 +5361,25 @@ static int handle_invept(struct kvm_vcpu *vcpu)
 			return nested_vmx_fail(vcpu,
 				VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
 
-		roots_to_free = 0;
 		if (nested_ept_root_matches(mmu->root_hpa, mmu->root_pgd,
 					    operand.eptp))
-			roots_to_free |= KVM_MMU_ROOT_CURRENT;
+			kvm_mmu_free_roots(vcpu, mmu, KVM_MMU_ROOT_CURRENT);
 
 		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
 			if (nested_ept_root_matches(mmu->prev_roots[i].hpa,
 						    mmu->prev_roots[i].pgd,
 						    operand.eptp))
-				roots_to_free |= KVM_MMU_ROOT_PREVIOUS(i);
+				mmu->prev_roots[i].need_sync = true;
 		}
 		break;
 	case VMX_EPT_EXTENT_GLOBAL:
-		roots_to_free = KVM_MMU_ROOTS_ALL;
+		kvm_mmu_free_roots(vcpu, mmu, KVM_MMU_ROOTS_ALL);
 		break;
 	default:
 		BUG();
 		break;
 	}
 
-	if (roots_to_free)
-		kvm_mmu_free_roots(vcpu, mmu, roots_to_free);
-
 	return nested_vmx_succeed(vcpu);
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bbc4e04e67ad..1f5617ec6b34 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11680,7 +11680,6 @@ int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva)
 	bool pcid_enabled;
 	struct x86_exception e;
 	unsigned i;
-	unsigned long roots_to_free = 0;
 	struct {
 		u64 pcid;
 		u64 gla;
@@ -11722,9 +11721,8 @@ int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva)
 		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
 			if (kvm_get_pcid(vcpu, vcpu->arch.mmu->prev_roots[i].pgd)
 			    == operand.pcid)
-				roots_to_free |= KVM_MMU_ROOT_PREVIOUS(i);
+				vcpu->arch.mmu->prev_roots[i].need_sync = true;
 
-		kvm_mmu_free_roots(vcpu, vcpu->arch.mmu, roots_to_free);
 		/*
 		 * If neither the current cr3 nor any of the prev_roots use the
 		 * given PCID, then nothing needs to be done here because a
@@ -11743,7 +11741,10 @@ int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva)
 
 		fallthrough;
 	case INVPCID_TYPE_ALL_INCL_GLOBAL:
-		kvm_make_request(KVM_REQ_MMU_RELOAD, vcpu);
+		kvm_mmu_sync_roots(vcpu);
+		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
+		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
+			vcpu->arch.mmu->prev_roots[i].need_sync = true;
 		return kvm_skip_emulated_instruction(vcpu);
 
 	default:
-- 
2.19.1.6.gb485710b

