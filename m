Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBAE3BFBD9
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 01:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729029AbfIZXTQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 19:19:16 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:45742 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729000AbfIZXTQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 19:19:16 -0400
Received: by mail-pg1-f202.google.com with SMTP id x31so2342209pgl.12
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 16:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=pjsieQrVqzRo5zN4EmfN5iO0IfPCBNYoWVGBuyUs8Qg=;
        b=M1Z2oAMkPk6JfY68Hizv1Zgi11SrxKxsM+aC/SXiywqyr2sRFyDTGTvblWAwG1X/iM
         W2YMHZcx1SXFyy/ul87lZr+jBxxLaqNPBgGDaWr6dcY96W2gztU/u/fgfmHxZkf0BOXv
         RKI7SjnTfA51x9DDO5HBVg9aZRVM57i6urq3dgbEkKUYXE5Ev4gTo++4Ys1Zf8tevaSh
         v0sRnuJBFepPKbZO4YLmaIrBP/xh2v6DylcF/sKDHi0c7+B/QjXUxv78TqoI734EcLhk
         nn7jvgIkR+yXIL82hQ/F4m3jflNTo4XPX3m3iP1+K9UMGWFnqrK3KP0S5ppyx3kzsHMD
         lquw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=pjsieQrVqzRo5zN4EmfN5iO0IfPCBNYoWVGBuyUs8Qg=;
        b=n8IWgllDJ6inpBkP5GXhdTBHpTo+pkh1CidjLFP80ORoBcRVQ7yPAJ3mPmHVjFJwLW
         yzkzqVydTMOdhgegpZ3po8DMlA9Bwn2uTyZHFaxdFUEvGhjIbFDV1LJO6BGynRUMWUHP
         JJUDZvXVGz1u6KHIjv34TYx9xtjDW/felB9gjU3l9wck8xsl6kRCZOQZyzgqsLMibbro
         Sr9jjx3EehenkAl7RTvBsfV7L8TtEkEApWYZ6Vf8f7lwmbDKJQ1ku4rMp/I7SlYTR18Z
         PtMKqKzwtzFodxAbQFSvR6HfZIAW68P03hTgiax8xzprhJIRDN7G1jNlOHhvboxjHWJ+
         bgpg==
X-Gm-Message-State: APjAAAW8YyeVn3GdLLFRdApoRi+bdBEx/eLKomgLAKPAanOLvt0Wpa+l
        aGKti/RegdEZo3CurfscE7wee/RKFgk4ZQms9gfXQ/z2FgyHNL9b7JWxQ3zQuN92/hYFpF8EibD
        YY9I+Kd6Xa/de3B8B0Cm6iJsn5eh0cCzfS4IfgNI6NQP5ubS/eiLloolAYMxv
X-Google-Smtp-Source: APXvYqx7Faea5HKGs73dumpZ1D1T3gyHtvbcnqAcoCEIHi9dw7VbN5oB+yBP0Olfz1k48+/iGdL66ygWiojR
X-Received: by 2002:a63:ca06:: with SMTP id n6mr5863067pgi.17.1569539953221;
 Thu, 26 Sep 2019 16:19:13 -0700 (PDT)
Date:   Thu, 26 Sep 2019 16:18:16 -0700
In-Reply-To: <20190926231824.149014-1-bgardon@google.com>
Message-Id: <20190926231824.149014-21-bgardon@google.com>
Mime-Version: 1.0
References: <20190926231824.149014-1-bgardon@google.com>
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
Subject: [RFC PATCH 20/28] kvm: mmu: Implement the invalidation MMU notifiers
 for the direct MMU
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

Implements arch specific handler functions for the invalidation MMU
notifiers, using a paging structure iterator. These handlers are
responsible for zapping paging structure entries to enable the main MM
to safely remap memory that was used to back guest memory.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 32426536723c6..ca9b3f574f401 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2829,6 +2829,22 @@ static bool zap_direct_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
 	return direct_walk_iterator_end_traversal(&iter);
 }
 
+static int zap_direct_gfn_range_handler(struct kvm *kvm,
+					struct kvm_memory_slot *slot,
+					gfn_t start, gfn_t end,
+					unsigned long data)
+{
+	return zap_direct_gfn_range(kvm, slot->as_id, start, end,
+				    MMU_WRITE_LOCK);
+}
+
+static bool zap_direct_hva_range(struct kvm *kvm, unsigned long start,
+		unsigned long end)
+{
+	return kvm_handle_direct_hva_range(kvm, start, end, 0,
+					   zap_direct_gfn_range_handler);
+}
+
 static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
 			  unsigned long data,
 			  int (*handler)(struct kvm *kvm,
@@ -2842,7 +2858,13 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
 
 int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end)
 {
-	return kvm_handle_hva_range(kvm, start, end, 0, kvm_unmap_rmapp);
+	int r = 0;
+
+	if (kvm->arch.direct_mmu_enabled)
+		r |= zap_direct_hva_range(kvm, start, end);
+	if (!kvm->arch.pure_direct_mmu)
+		r |= kvm_handle_hva_range(kvm, start, end, 0, kvm_unmap_rmapp);
+	return r;
 }
 
 int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
-- 
2.23.0.444.g18eeb5a265-goog

