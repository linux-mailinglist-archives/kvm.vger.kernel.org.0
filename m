Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84E7A2A9E92
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 21:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728410AbgKFU3e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 15:29:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728237AbgKFU3e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Nov 2020 15:29:34 -0500
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C46F3C0613D2
        for <kvm@vger.kernel.org>; Fri,  6 Nov 2020 12:29:33 -0800 (PST)
Received: by mail-qt1-x849.google.com with SMTP id e19so1725637qtq.17
        for <kvm@vger.kernel.org>; Fri, 06 Nov 2020 12:29:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=ULc2QwdCH5im+pfEGHCAJt9dFDUjORAmMg0iMDdD/ZE=;
        b=qxK63C85+mLWqUM6fF6ufmuq09cUwYZSbRvdqXOVlKWkYTVHLWgKHZPW23Sgbbpsut
         J/dtITSGF8n2ylyWL2J9oazEIkmB5z36lETuij7i6T4x90ka4hoRiMp+aJSiHe5hR7Qm
         cYwBLWMnyNt7WRI+pi7pWUPKuW5krdqFEjpBcH9aLwC3eZv4Mlwd+483rDk01xUiWOPA
         YOboDY+r4fchGJs6SogwqO9pRRdrR/wihlrcAt3wzN7FILrUxhYUpL5uDNEEDCicu449
         vkBz2bGesJpH1iphht0MRywvktZwKa/xSxTJh38piWQ4q5tWgTV+bb+bGUip3QSEVU9v
         vFgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=ULc2QwdCH5im+pfEGHCAJt9dFDUjORAmMg0iMDdD/ZE=;
        b=rhEoR/6D8vX4TOQ+2LkzcUbZQu9R+ryjMgPUtvgJ9qFB2KWtm6yakUUmR5vtmPMzHZ
         cysb9XetbzHSlLK3aePDzubUCV4MVrriRPZMFAsXYvyDnqkN8Sggkyry6I10j65324gJ
         B9hACiPC9nlwgqww/Fp0ASz7yYxdH8b4qBHXpLba2+WuDE1sveHmM3y31BDEerEmi70e
         9koyYEdcGYYthgLymStCQL+6ZvHDwGFIccwM932G2W4qA4EbetfyM0pCNkWudRSXrGEG
         EOx52GUkKFAQlPXz4L4pC8Iu2PtEms2bGUgBycEPOXRDuBLfjcWzKgTc7ZWVY4gRNDrv
         d5Iw==
X-Gm-Message-State: AOAM530zqDtkpddlp0vSF9TwOUHDgJzKO8dtiMd4YSpVD8SiUY3l1qyz
        3ebLdoqNMbYYCPjq+jOb+yk9SAEDU3vouQ==
X-Google-Smtp-Source: ABdhPJzRtuBmM7hT4n/AykR+FlOUggYbVMe/LDkuyotS0xBuSPRCU2hzDublBhwIcsnZ8iR6EFpEw7C4KtLO4Q==
Sender: "shakeelb via sendgmr" <shakeelb@shakeelb.svl.corp.google.com>
X-Received: from shakeelb.svl.corp.google.com ([2620:15c:2cd:202:a28c:fdff:fee8:36f0])
 (user=shakeelb job=sendgmr) by 2002:ac8:6e8b:: with SMTP id
 c11mr3303614qtv.2.1604694572860; Fri, 06 Nov 2020 12:29:32 -0800 (PST)
Date:   Fri,  6 Nov 2020 12:29:23 -0800
Message-Id: <20201106202923.2087414-1-shakeelb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.1.341.ge80a0c044ae-goog
Subject: [PATCH] mm, kvm: account kvm_vcpu_mmap to kmemcg
From:   Shakeel Butt <shakeelb@google.com>
To:     Roman Gushchin <guro@fb.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Shakeel Butt <shakeelb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A VCPU of a VM can allocate couple of pages which can be mmap'ed by the
user space application. At the moment this memory is not charged to the
memcg of the VMM. On a large machine running large number of VMs or
small number of VMs having large number of VCPUs, this unaccounted
memory can be very significant. So, charge this memory to the memcg of
the VMM. Please note that lifetime of these allocations corresponds to
the lifetime of the VMM.

Signed-off-by: Shakeel Butt <shakeelb@google.com>
---

This patch has dependency on Roman's patch series "mm: allow mapping
accounted kernel pages to userspace".

 arch/s390/kvm/kvm-s390.c  | 2 +-
 arch/x86/kvm/x86.c        | 2 +-
 virt/kvm/coalesced_mmio.c | 2 +-
 virt/kvm/kvm_main.c       | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 6b74b92c1a58..8364c5ee91a5 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3243,7 +3243,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	int rc;
 
 	BUILD_BUG_ON(sizeof(struct sie_page) != 4096);
-	sie_page = (struct sie_page *) get_zeroed_page(GFP_KERNEL);
+	sie_page = (struct sie_page *) get_zeroed_page(GFP_KERNEL_ACCOUNT);
 	if (!sie_page)
 		return -ENOMEM;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 397f599b20e5..d37acf3ce17f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9829,7 +9829,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	r = -ENOMEM;
 
-	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+	page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 	if (!page)
 		goto fail_free_lapic;
 	vcpu->arch.pio_data = page_address(page);
diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index e2c197fd4f9d..62bd908ecd58 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -111,7 +111,7 @@ int kvm_coalesced_mmio_init(struct kvm *kvm)
 {
 	struct page *page;
 
-	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+	page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 	if (!page)
 		return -ENOMEM;
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2541a17ff1c4..f69357a29688 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3116,7 +3116,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 	}
 
 	BUILD_BUG_ON(sizeof(struct kvm_run) > PAGE_SIZE);
-	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+	page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 	if (!page) {
 		r = -ENOMEM;
 		goto vcpu_free;
-- 
2.29.1.341.ge80a0c044ae-goog

