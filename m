Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6A27D42B8
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 00:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231506AbjJWWgs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 18:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231873AbjJWWgq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 18:36:46 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5E2D10D0
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 15:36:42 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d9cb79eb417so3596698276.2
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 15:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698100602; x=1698705402; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ttWGlrffBrwY7IhgV2y0g5weERvwNo5srcxQizfmW8s=;
        b=htgYpHLbBqReVr6QGS1hlLZgrLnXOTw+AUtddS3d2zSfr1XcY/OJ2a2KhwPwMhOj4S
         H4ipgYOfA8iGhHQGXzFTzVhYoKdl6MsaZpxwAxhGNQrHCEEVQs1wOLKgdy1xiDwf/5r+
         LWLl85SoGETcAGHuee1RrFFJ+V/xdQ0CnYfRvOLUJbiYESX1R5UtRYotWtmU5t/CD3o5
         y6gG6qp5wf1pikHmkkVTpT7HHCtKRD43g5D7caqdo1ILDYj1nWlN9gtF9nAAlM1se1CY
         OUvjZuTYQ4qn+5QdIHyXIcD8lBifr0HkVDZyO0SpCSClfkpM3wSXqFbrYs1kwxwwZpNt
         WtJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698100602; x=1698705402;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ttWGlrffBrwY7IhgV2y0g5weERvwNo5srcxQizfmW8s=;
        b=YPugXmvbzQ/p4bfmTCLo/a+o9JSHEuNzhVhYbsnT9DYQh1UuDW6l9L99B2hyF6DXJc
         nsTUrbhTAgdD3bUK6ck6yNIkWx9enR97jRK2+xlRMOYhqSaqeuUGcDh0A6aIbid6Wun0
         D3KTQzWXxMjS8vEWVyeRmu62jgE/dPWRElnyIlm5IfqZnsNqZZiL7lbIsknRcoufuJt2
         0z6LcPb9T/53GIQSGWb/rtYyIosRuWvQyLiLglODjPES7orPBQhtsj1lrVwed3MdwUVK
         mxhhi7gULN3MlOEGzXyje51jg1JcIQUSE/7Dt2hxp17aH+193gmmNI77QpUdVCEongIY
         bgaA==
X-Gm-Message-State: AOJu0YzlxsKeJJaSbhSkSPPaIdqOT9SpGBq6aukYYjmyTVnqz/qOBQ0H
        7AJlLOMwCNacReQJGj8jubPTfILXpRM=
X-Google-Smtp-Source: AGHT+IELTIPmnhOx8eNyhluHVilWx0Ce4P1fhW2zfRPHK7DW2U+h+4Gzg6eZCkp/zq4wYdvE6e7D5Ee8M5M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:b322:0:b0:d86:5644:5d12 with SMTP id
 l34-20020a25b322000000b00d8656445d12mr208242ybj.4.1698100601818; Mon, 23 Oct
 2023 15:36:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 23 Oct 2023 15:36:39 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
Message-ID: <20231023223639.2487832-1-seanjc@google.com>
Subject: [PATCH gmem] KVM: guest_memfd: Point .owner at the module that
 exposes /dev/kvm
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set .owner for guest_memfd file operations so that the KVM module(s) is
is pinned until any files with callbacks back into KVM are completely
freed.

Note, file types that can call into sub-module code, e.g. kvm-intel.ko or
kvm-amd.ko on x86, must use the module pointer passed to kvm_init(), not
THIS_MODULE (which points at kvm.ko).  KVM assumes that if /dev/kvm is
reachable, e.g. VMs are active, then the vendor module is loaded.

Opportunistically clean up the kvm_gmem_{init,exit}() mess that got left
behind by commit 0f7e60a5f42a ("kvm: guestmem: do not use a file system").

Link: https://lore.kernel.org/all/20231018204624.1905300-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

See the link for details.  I'm going to eventually squash this so I put the
bare minimum copy+paste effort into the changelog.

 virt/kvm/guest_memfd.c |  7 ++++++-
 virt/kvm/kvm_main.c    |  2 ++
 virt/kvm/kvm_mm.h      | 10 ++--------
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 9ffce54555ae..94bc478c26f3 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -285,12 +285,17 @@ static struct file *kvm_gmem_get_file(struct kvm_memory_slot *slot)
 	return file;
 }
 
-static const struct file_operations kvm_gmem_fops = {
+static struct file_operations kvm_gmem_fops = {
 	.open		= generic_file_open,
 	.release	= kvm_gmem_release,
 	.fallocate	= kvm_gmem_fallocate,
 };
 
+void kvm_gmem_init(struct module *module)
+{
+	kvm_gmem_fops.owner = module;
+}
+
 static int kvm_gmem_migrate_folio(struct address_space *mapping,
 				  struct folio *dst, struct folio *src,
 				  enum migrate_mode mode)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 959e866c84f0..357b9d9d0225 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -6459,6 +6459,8 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 	if (WARN_ON_ONCE(r))
 		goto err_vfio;
 
+	kvm_gmem_init(module);
+
 	/*
 	 * Registration _must_ be the very last thing done, as this exposes
 	 * /dev/kvm to userspace, i.e. all infrastructure must be setup!
diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index 798f20d612bb..cca5372b9d5d 100644
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -38,19 +38,13 @@ static inline void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm,
 #endif /* HAVE_KVM_PFNCACHE */
 
 #ifdef CONFIG_KVM_PRIVATE_MEM
-int kvm_gmem_init(void);
-void kvm_gmem_exit(void);
+void kvm_gmem_init(struct module *module);
 int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args);
 int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 		  unsigned int fd, loff_t offset);
 void kvm_gmem_unbind(struct kvm_memory_slot *slot);
 #else
-static inline int kvm_gmem_init(void)
-{
-	return 0;
-}
-
-static inline void kvm_gmem_exit(void)
+static inline void kvm_gmem_init(struct module *module)
 {
 
 }

base-commit: 911b515af3ec5f53992b9cc162cf7d3893c2fbe2
-- 
2.42.0.758.gaed0368e0e-goog

