Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43B7D4C5288
	for <lists+kvm@lfdr.de>; Sat, 26 Feb 2022 01:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240875AbiBZAST (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 19:18:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241451AbiBZARz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 19:17:55 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2C22177E8
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 16:16:55 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id j204-20020a6280d5000000b004e107ad3488so3950670pfd.15
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 16:16:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ZivJE8MVPu2+0VJQHIQDwCaX4QVLks+DVDCy+33e+r8=;
        b=mMU4YwGqseNPZMpoNYmxFxG4jtTHTrOwwNMMtFmvF5gU3KuAfnYwOTnZjRQMZCj6LL
         2ge/6ljDTmTYz3JDy0ObU/z3MurRyM4S2ySEh38mtjBgB2XRzbyeuZTTOp3RhFmupm4L
         hqWf+267+WCsN3maMGLfrNA5cJadn3cyBsIsP//FOmbObzbe2kwKkbhShHvXyFYHGtIB
         gzcBXLaCiu4Fs3dVHuhYG49cqGvgJS09YjKP7bL3eyZvuADi+p3cNlB8sYDMxemp4whB
         7XNLvyCKA6a6OtGvEBjRJKc6U4Io5PQjLJxHYjZencIXDE5DItvB0wddFu726/RY/Bp8
         b3Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ZivJE8MVPu2+0VJQHIQDwCaX4QVLks+DVDCy+33e+r8=;
        b=lF00+e8swHR0iWEB0BonYcLH88OpWJNZbx3ft7Qrb+/sBIRgBs8Z5Y00dcXhYB/Y+N
         Z4zBw+SNZpGnKEjj1o+HciRPpodz6L8MqXlpkl3pUcWESVE8z3z2kYof8AyB2co3h/SV
         TaTkE+c7S3UtSr4CUZWeL3I4WHeZteI8YIsE+X+wT+3k7PRX+WPZudUhx8YPHJR9OyB8
         nz0lVL3ctBezvgZbKWePVoNjOAhTTsf+seRiB3LOJuFIi7sIY2+CfqvbMzT/jy6jwyEc
         e0nunjboKv9PaFuc+vfEzv3zMKAykMfXRPws8859A6IhrswMKFwGNwsm8zHkbnpdXjCh
         bNJQ==
X-Gm-Message-State: AOAM53244nXPooAd4oX1KtE5rR/rsWObiYz61jlRUny/syuEiUNjF+3B
        yfiK/0me9LJZ3YPVcyNoz54zp8Kk2GM=
X-Google-Smtp-Source: ABdhPJy1aQwG7FMFmonazVOqZZykIl+8MuBlSYKEV1ch4e6+SOFabB6zEO+fnjaBZuxd70dpPtyEts027Es=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a62:1d42:0:b0:4c7:f78d:6f62 with SMTP id
 d63-20020a621d42000000b004c7f78d6f62mr9946549pfd.33.1645834605317; Fri, 25
 Feb 2022 16:16:45 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 26 Feb 2022 00:15:44 +0000
In-Reply-To: <20220226001546.360188-1-seanjc@google.com>
Message-Id: <20220226001546.360188-27-seanjc@google.com>
Mime-Version: 1.0
References: <20220226001546.360188-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v3 26/28] KVM: selftests: Split out helper to allocate guest
 mem via memfd
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extract the code for allocating guest memory via memfd out of
vm_userspace_mem_region_add() and into a new helper, kvm_memfd_alloc().
A future selftest to populate a guest with the maximum amount of guest
memory will abuse KVM's memslots to alias guest memory regions to a
single memfd-backed host region, i.e. needs to back a guest with memfd
memory without a 1:1 association between a memslot and a memfd instance.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    | 42 +++++++++++--------
 2 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 573de0354175..92cef0ffb19e 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -123,6 +123,7 @@ int kvm_memcmp_hva_gva(void *hva, struct kvm_vm *vm, const vm_vaddr_t gva,
 		       size_t len);
 
 void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename);
+int kvm_memfd_alloc(size_t size, bool hugepages);
 
 void vm_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent);
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index dcb8e96c6a54..1665a220abcb 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -718,6 +718,27 @@ void kvm_vm_free(struct kvm_vm *vmp)
 	free(vmp);
 }
 
+int kvm_memfd_alloc(size_t size, bool hugepages)
+{
+	int memfd_flags = MFD_CLOEXEC;
+	int fd, r;
+
+	if (hugepages)
+		memfd_flags |= MFD_HUGETLB;
+
+	fd = memfd_create("kvm_selftest", memfd_flags);
+	TEST_ASSERT(fd != -1, "memfd_create() failed, errno: %i (%s)",
+		    errno, strerror(errno));
+
+	r = ftruncate(fd, size);
+	TEST_ASSERT(!r, "ftruncate() failed, errno: %i (%s)", errno, strerror(errno));
+
+	r = fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE, 0, size);
+	TEST_ASSERT(!r, "fallocate() failed, errno: %i (%s)", errno, strerror(errno));
+
+	return fd;
+}
+
 /*
  * Memory Compare, host virtual to guest virtual
  *
@@ -970,24 +991,9 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 		region->mmap_size += alignment;
 
 	region->fd = -1;
-	if (backing_src_is_shared(src_type)) {
-		int memfd_flags = MFD_CLOEXEC;
-
-		if (src_type == VM_MEM_SRC_SHARED_HUGETLB)
-			memfd_flags |= MFD_HUGETLB;
-
-		region->fd = memfd_create("kvm_selftest", memfd_flags);
-		TEST_ASSERT(region->fd != -1,
-			    "memfd_create failed, errno: %i", errno);
-
-		ret = ftruncate(region->fd, region->mmap_size);
-		TEST_ASSERT(ret == 0, "ftruncate failed, errno: %i", errno);
-
-		ret = fallocate(region->fd,
-				FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE, 0,
-				region->mmap_size);
-		TEST_ASSERT(ret == 0, "fallocate failed, errno: %i", errno);
-	}
+	if (backing_src_is_shared(src_type))
+		region->fd = kvm_memfd_alloc(region->mmap_size,
+					     src_type == VM_MEM_SRC_SHARED_HUGETLB);
 
 	region->mmap_start = mmap(NULL, region->mmap_size,
 				  PROT_READ | PROT_WRITE,
-- 
2.35.1.574.g5d30c73bfb-goog

