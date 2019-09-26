Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0E7ABFBDC
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 01:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729071AbfIZXTV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 19:19:21 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:54436 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729048AbfIZXTV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 19:19:21 -0400
Received: by mail-pg1-f201.google.com with SMTP id m17so2321066pgh.21
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 16:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=p5p3XErJyYwp3TttwsaCpTh9txi10KL45ED980LPgg0=;
        b=GMFf7MPW942Con3/Rc2iJn8yCbxcqfm+v7lFZxdo86jyIW8VfsL43BcRgFVD2Ah715
         dyQGfyf1ZOEXSobzfHyG3xt2MARUQtM8o3xx6SH4UEUYg1H88kmCjneD0dUv+FTJqZc9
         O4jYISq6cfpSPzboZgcckHlbvtsAiF8hJ50qa25imoQ5eIIWjeUuWn2vtorO2p+J1Yv9
         fgkmMgS5FArtQ0/C2VjpGlw5EdWNVUYOGq/LBa5+Gsq1elhsuqw50+qfzLnVaBP0Lduq
         HSaFT/UOixGHKnYuBwU3YjfFdnXz0/DUkUywcCatgkeQmNiKiP5eYtRntErqOvI2Vsm3
         xDqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=p5p3XErJyYwp3TttwsaCpTh9txi10KL45ED980LPgg0=;
        b=nG5fdv0ru2EUS3gR/qXj4ZQEXEwaqF9IqwIQ2nYgxd23+OWkMhjqk9Qd0djbbfYuJ6
         cHX1ELTY4/u4xOF3QyoQu1rquPyhJZ0E3UiuPxg7YCBAuQBmCPFwq/2NnEZP2NJo2N/X
         cCXMeOuHLK+ms22Lg2End4HjPwH1Xl3y3M/8taaYsaG39+aN1c+qRkeB4FAqp4TqBryZ
         s2O4dkiEU/3+YIK3Cosvj79Q/dZQzKlnzHtOIYxSUpBtFI4CaZ7rYUtZWeBMpZt38e/K
         5CL4HY5k6zpsdu2AEMjqUFTd2AhINRe3daHI9ng9fgURdtkVJgYSwFFxp5T75B4FyqEm
         6skg==
X-Gm-Message-State: APjAAAXeiFjJ/0EPGCJuKwJdwz1wCVhj6XxdBxqGAAYe/+zDAUABx7EV
        VbnaiAO/FyTuh8rL4kVnVMAy+wgn3tvmE3nQYp05NHGp6BU1UJk3zqQIqjDTjCJYb+L0sRpm0iR
        OYNXhzXHKAyht5lP2Y6XR1klgCrH30j5WrHDKRAHO7ktT5gUTdNzyfP9jotBi
X-Google-Smtp-Source: APXvYqx/tRFyJsYEGQZ+9leVtfPKHme5XskASyrx5EnjXQ6VY6WPrRUn5jYo8an8xbCeop9PnyfltsgTBxkc
X-Received: by 2002:a63:6d0:: with SMTP id 199mr5758315pgg.299.1569539960545;
 Thu, 26 Sep 2019 16:19:20 -0700 (PDT)
Date:   Thu, 26 Sep 2019 16:18:19 -0700
In-Reply-To: <20190926231824.149014-1-bgardon@google.com>
Message-Id: <20190926231824.149014-24-bgardon@google.com>
Mime-Version: 1.0
References: <20190926231824.149014-1-bgardon@google.com>
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
Subject: [RFC PATCH 23/28] kvm: mmu: Make mark_page_dirty_in_slot usable from
 outside kvm_main
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

When operating on PTEs within a memslot, the dirty status of the page
must be recorded for dirty logging. Currently the only mechanism for
marking pages dirty in mmu.c is mark_page_dirty, which assumes address
space 0. This means that dirty pages in other address spaces will be lost.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 include/linux/kvm_host.h | 1 +
 virt/kvm/kvm_main.c      | 6 ++----
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ce6b22fcb90f3..1212d5c8a3f6d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -753,6 +753,7 @@ int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len);
 struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn);
 bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn);
 unsigned long kvm_host_page_size(struct kvm *kvm, gfn_t gfn);
+void mark_page_dirty_in_slot(struct kvm_memory_slot *memslot, gfn_t gfn);
 void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
 
 struct kvm_memslots *kvm_vcpu_memslots(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 771e159d6bea9..ffc6951f2bc93 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -130,8 +130,6 @@ static void hardware_disable_all(void);
 
 static void kvm_io_bus_destroy(struct kvm_io_bus *bus);
 
-static void mark_page_dirty_in_slot(struct kvm_memory_slot *memslot, gfn_t gfn);
-
 __visible bool kvm_rebooting;
 EXPORT_SYMBOL_GPL(kvm_rebooting);
 
@@ -2214,8 +2212,7 @@ int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len)
 }
 EXPORT_SYMBOL_GPL(kvm_clear_guest);
 
-static void mark_page_dirty_in_slot(struct kvm_memory_slot *memslot,
-				    gfn_t gfn)
+void mark_page_dirty_in_slot(struct kvm_memory_slot *memslot, gfn_t gfn)
 {
 	if (memslot && memslot->dirty_bitmap) {
 		unsigned long rel_gfn = gfn - memslot->base_gfn;
@@ -2223,6 +2220,7 @@ static void mark_page_dirty_in_slot(struct kvm_memory_slot *memslot,
 		set_bit_le(rel_gfn, memslot->dirty_bitmap);
 	}
 }
+EXPORT_SYMBOL_GPL(mark_page_dirty_in_slot);
 
 void mark_page_dirty(struct kvm *kvm, gfn_t gfn)
 {
-- 
2.23.0.444.g18eeb5a265-goog

