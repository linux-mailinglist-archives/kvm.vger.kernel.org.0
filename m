Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE0407DA059
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 20:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346554AbjJ0S0P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 14:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346570AbjJ0S0H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 14:26:07 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB5826A5
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 11:23:33 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-da1176f3d96so917480276.2
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 11:23:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698431009; x=1699035809; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=rHCSEdVT91A5ySy8HWpIrikDyrYgztwmDmnD7EhGGWM=;
        b=ct+ZvQnqfpDvR1VShXo/aKJjIzKWImnxYQCrcLfAs6kKFEKTaJHyZppFFbPKOUpDl6
         xwzjcL5/lG4xYhwe8c5bbcPcEqCgwAuucB/DZf3sbS13OwbqbnlAZAMp10FlTLUdbF14
         88iOnCapUzXKVjbl7Pl4Muq2SdgtrbxHWJpJ+Etxt58KiFY9LwoRWbvH/am6Twu7eFMI
         EkSKKz6YDJsBgihddcTfnaPmz5s924QsjAh+1hfPB+BXCHZhgg8UhroTj3OCKgl7sUsc
         3lMjRk2kYqiIJ7TE+Q5p36brA3/isWJhXiSMEIcX2GVUnQfD/dtQUXsSIuJtXJuqfGpA
         xaYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698431009; x=1699035809;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rHCSEdVT91A5ySy8HWpIrikDyrYgztwmDmnD7EhGGWM=;
        b=IdsoP1ZQcATBAfiMxcG48ozVSKoi4zpObH4Wxlq/BeaOmqSwC+JZf6Z6Rfrf8egauH
         AcHJHG7Izjrq1Afa0SQ5M8KTToV4Fz5LVSFehoW9YIH/jATJLW96cystfV++ailFzdlu
         sOcy72m+E4nqYivGFGytyKSazfXhhyPGL7xHhVRVox5dJizkDOrvW2eeBrp41aKpy8JB
         pnfPtMuzpJPROueaN/gL8p8f3F+X3iO4fPreihEzViR1eRjjWy02xfpDHqD6Y8CV6hap
         ICKwgXL7xB/cPgXDokWbbXGF62wNdeo2AfI3nghc66yJXPU5rMM7e7paxsKc3dKBot1H
         mfvw==
X-Gm-Message-State: AOJu0YxPrwL1paHIZWLkGFGfz5KiumdpuuZTZ/ZVWaH9g6Zyoz7eToP3
        YnL9opxdnBUxxUEmjSoVh59RCO3djA4=
X-Google-Smtp-Source: AGHT+IGBlPG7wn0887XfDb8cENXXLGU58G9yJP5jBeCkKIucbC9oYDwWXkdT4FgaevehYCQITd+4fshLciA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:565:b0:da0:c979:fd70 with SMTP id
 a5-20020a056902056500b00da0c979fd70mr69913ybt.9.1698431009012; Fri, 27 Oct
 2023 11:23:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 27 Oct 2023 11:22:14 -0700
In-Reply-To: <20231027182217.3615211-1-seanjc@google.com>
Mime-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.820.g83a721a137-goog
Message-ID: <20231027182217.3615211-33-seanjc@google.com>
Subject: [PATCH v13 32/35] KVM: selftests: Add KVM_SET_USER_MEMORY_REGION2 helper
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.linux.dev, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Xu Yilun <yilun.xu@intel.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Fuad Tabba <tabba@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Anish Moorthy <amoorthy@google.com>,
        David Matlack <dmatlack@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        "=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?=" <mic@digikod.net>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Maciej Szmigiero <mail@maciej.szmigiero.name>,
        David Hildenbrand <david@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Wang <wei.w.wang@intel.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Chao Peng <chao.p.peng@linux.intel.com>

Add helpers to invoke KVM_SET_USER_MEMORY_REGION2 directly so that tests
can validate of features that are unique to "version 2" of "set user
memory region", e.g. do negative testing on gmem_fd and gmem_offset.

Provide a raw version as well as an assert-success version to reduce
the amount of boilerplate code need for basic usage.

Signed-off-by: Chao Peng <chao.p.peng@linux.intel.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  7 +++++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 29 +++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 157508c071f3..8ec122f5fcc8 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -522,6 +522,13 @@ void vm_set_user_memory_region(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
 			       uint64_t gpa, uint64_t size, void *hva);
 int __vm_set_user_memory_region(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
 				uint64_t gpa, uint64_t size, void *hva);
+void vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
+				uint64_t gpa, uint64_t size, void *hva,
+				uint32_t guest_memfd, uint64_t guest_memfd_offset);
+int __vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
+				 uint64_t gpa, uint64_t size, void *hva,
+				 uint32_t guest_memfd, uint64_t guest_memfd_offset);
+
 void vm_userspace_mem_region_add(struct kvm_vm *vm,
 	enum vm_mem_backing_src_type src_type,
 	uint64_t guest_paddr, uint32_t slot, uint64_t npages,
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 52b131e3aca5..1620452c1cf7 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -873,6 +873,35 @@ void vm_set_user_memory_region(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
 		    errno, strerror(errno));
 }
 
+int __vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
+				 uint64_t gpa, uint64_t size, void *hva,
+				 uint32_t guest_memfd, uint64_t guest_memfd_offset)
+{
+	struct kvm_userspace_memory_region2 region = {
+		.slot = slot,
+		.flags = flags,
+		.guest_phys_addr = gpa,
+		.memory_size = size,
+		.userspace_addr = (uintptr_t)hva,
+		.guest_memfd = guest_memfd,
+		.guest_memfd_offset = guest_memfd_offset,
+	};
+
+	return ioctl(vm->fd, KVM_SET_USER_MEMORY_REGION2, &region);
+}
+
+void vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
+				uint64_t gpa, uint64_t size, void *hva,
+				uint32_t guest_memfd, uint64_t guest_memfd_offset)
+{
+	int ret = __vm_set_user_memory_region2(vm, slot, flags, gpa, size, hva,
+					       guest_memfd, guest_memfd_offset);
+
+	TEST_ASSERT(!ret, "KVM_SET_USER_MEMORY_REGION2 failed, errno = %d (%s)",
+		    errno, strerror(errno));
+}
+
+
 /* FIXME: This thing needs to be ripped apart and rewritten. */
 void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 		uint64_t guest_paddr, uint32_t slot, uint64_t npages,
-- 
2.42.0.820.g83a721a137-goog

