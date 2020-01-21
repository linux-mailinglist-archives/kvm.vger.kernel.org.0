Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 757411441C3
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 17:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729398AbgAUQLL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 11:11:11 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39879 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726555AbgAUQLL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jan 2020 11:11:11 -0500
Received: by mail-wm1-f66.google.com with SMTP id 20so3714930wmj.4;
        Tue, 21 Jan 2020 08:11:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:subject:date:message-id;
        bh=0r9HTQo0HlkDjaCMRvg6avAGNtQXXo1BGS+PSpMF/rg=;
        b=o8ADRwszU8umz6tgcM1h3UdSiPzo+mhb6aukx2pasJOBSGTU3zMsRqdHVJfIWBiqX1
         Bfw46uRQ2EmUosxSyJeoOPjE5Hxwdf0sSEo7MiU1EBQMaHEVDpHLVWgmIIVzcsyZB8tr
         91Rwk0x9EFfNnh4Df39hN9XK1G+loTMHr7mq0xldzz655I3T3j84pQwX7cjkxHTsOexB
         laYIDvmaqat3QODRpUAaJs1lwcVK+YCf+DccwGh6qKa4OjXfgQ7TgrHYAlZOkqIZJRO/
         eq115/iNAA/75Cq/VpNQ1/c4KQuFg/rVaXbSPH6r9KSTuR7YMdWIliJKgUu+TKGkappr
         D8Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:subject:date:message-id;
        bh=0r9HTQo0HlkDjaCMRvg6avAGNtQXXo1BGS+PSpMF/rg=;
        b=feRnbM+KNpzjrtdUJdVg3oRubF7NyQT5eaTFsrb8Qz3/MRNHggFvsHF1hCADNYCt9Q
         Lv272LMEg8GcMO07AVeb4k/15MIojcSCa0pBt5ul+7EFdy56C9AtUOrTuOWOSAJMzwxL
         BsnaHm6wtCZNYTymLH8gOiLML6LEC380s81cb88GrvUqaTsJrah5f5ulQw8nIARGzCcQ
         bDePtEvT/8NhTcfQEITOw+cBdXdUU2ZS3C5dcA6IWLWOrVfbv7ue6Qc2gEinGOfgjdHV
         T4GJF4duHKuH6HWECgsjpVVO+nC6n9ZunXN2aUFNESbSOJnmmk2OR0dRWaw7/HbnEPgm
         eHMQ==
X-Gm-Message-State: APjAAAXYW8N8wiG4XU4i8g5Tva+/FETD2l7054wx/AjmH4tdTZe6QaXb
        44sWRLM9StBlY9yC8MJSH+tYJ9vZ
X-Google-Smtp-Source: APXvYqzVexiF8edJY6JhT2eTC61P3ZXm04IQoJfkwi4v0wI6o/A9Rh/EFnhCXkqXNUYu13FSve02nw==
X-Received: by 2002:a05:600c:298:: with SMTP id 24mr4931157wmk.141.1579623068933;
        Tue, 21 Jan 2020 08:11:08 -0800 (PST)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id l6sm4648584wmf.21.2020.01.21.08.11.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Jan 2020 08:11:08 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] KVM: x86: inline memslot_valid_for_gpte
Date:   Tue, 21 Jan 2020 17:11:07 +0100
Message-Id: <1579623067-47221-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The function now has a single caller, so there is no point
in keeping it separate.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7a17591b28d2..497c9384acf9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1267,17 +1267,6 @@ static void unaccount_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 	list_del(&sp->lpage_disallowed_link);
 }
 
-static inline bool memslot_valid_for_gpte(struct kvm_memory_slot *slot,
-					  bool no_dirty_log)
-{
-	if (!slot || slot->flags & KVM_MEMSLOT_INVALID)
-		return false;
-	if (no_dirty_log && slot->dirty_bitmap)
-		return false;
-
-	return true;
-}
-
 static struct kvm_memory_slot *
 gfn_to_memslot_dirty_bitmap(struct kvm_vcpu *vcpu, gfn_t gfn,
 			    bool no_dirty_log)
@@ -1285,8 +1274,10 @@ static inline bool memslot_valid_for_gpte(struct kvm_memory_slot *slot,
 	struct kvm_memory_slot *slot;
 
 	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
-	if (!memslot_valid_for_gpte(slot, no_dirty_log))
-		slot = NULL;
+	if (!slot || slot->flags & KVM_MEMSLOT_INVALID)
+		return NULL;
+	if (no_dirty_log && slot->dirty_bitmap)
+		return NULL;
 
 	return slot;
 }
-- 
1.8.3.1

