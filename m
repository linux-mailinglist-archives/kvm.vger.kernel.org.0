Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6457338976B
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 22:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232912AbhESUFb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 16:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232824AbhESUFW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 16:05:22 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7036C061760
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 13:04:00 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id j4-20020a2523040000b029050d0d623dccso14373054ybj.15
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 13:04:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+vH9NHuZobMNOBjiXwWKSpovgFGP7trM8WRzRJ/VRx4=;
        b=q8ppyhS5xrnmYCkA0DF/PWE6zwOmQ8XfGoSUSXC+uHfRxBj7Tjq6PR1g9Y4in96e+w
         hW/Acm5ZWWGlteimLk6FW3+3936AwCaO8eFDI0qudA3fGQ8YacDePz45fJsQdSMbSFnQ
         YnCpG7jC/fDysXx31BkV2fk5/NRPwdTAp0fFgSVNm3lG0875H2pigLIOPNCqdtSdl+eF
         i9WUnuc1r74WlNBWZ6fyD+uYLVuHMGw1DZDE1qXcLoAIuLESnXAAWz6DnLZgC+K576ui
         LG9fW+RBBpzWboPy+8mP1q1eFL4LjxOt7YN1lw5yFLYO8S0x/VSEECzyq2f8ul+kCWX8
         ZWcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+vH9NHuZobMNOBjiXwWKSpovgFGP7trM8WRzRJ/VRx4=;
        b=F9cOH0F4FeDzBulGS2j+5+7jlNow12ak+nupKYzhi1WqIh/kO8Li1xnK0h9zn5Ryno
         LktJlAsTRb+ImIkvjP9eW0Jkdc6rRiujOFjQ6u0gtzs/dvz9upyWHCTLNuGFQ2SE0vCO
         5jf7JMtAPbkUidPwYPFy9/3T0YEwAx63JfbjN8qgAEG3//jh7PICckG1c+jA6zjNonvx
         imHeHrP1zf9QJg3ymqtHDC/jfMyT8ig5Ae8H3DqYYVQ/9tG3cKL/mNKrU6izQaKO9U9Z
         yxxnL8oW2+On0wsytUL3qW7lDKqDkmgYcvtadZA2X+EIPtpfOJb63EoJA+Js9D3hAmxP
         Ekgg==
X-Gm-Message-State: AOAM533ki8SXyuAtVllnyYvyi2rBS7fmJ2frPJlIFexIU1JiWrseiOOJ
        MFASbj/s5WeQPCOm4ZhhjCQYBw7U5VSDXorg5C9v
X-Google-Smtp-Source: ABdhPJwHYMyECmpSr3A5TbsZ6+n3J2NfFGIPiB9M6tWP02nSuwwmyrOmuhOgsH9zzCmbtmWH3vxPPlUV2uyLZ9xQWh4N
X-Received: from ajr0.svl.corp.google.com ([2620:15c:2cd:203:7eb5:10bb:834a:d5ec])
 (user=axelrasmussen job=sendgmr) by 2002:a5b:7c5:: with SMTP id
 t5mr1874753ybq.190.1621454640072; Wed, 19 May 2021 13:04:00 -0700 (PDT)
Date:   Wed, 19 May 2021 13:03:35 -0700
In-Reply-To: <20210519200339.829146-1-axelrasmussen@google.com>
Message-Id: <20210519200339.829146-7-axelrasmussen@google.com>
Mime-Version: 1.0
References: <20210519200339.829146-1-axelrasmussen@google.com>
X-Mailer: git-send-email 2.31.1.751.gd2f1c929bd-goog
Subject: [PATCH v2 06/10] KVM: selftests: refactor vm_mem_backing_src_type flags
From:   Axel Rasmussen <axelrasmussen@google.com>
To:     Aaron Lewis <aaronlewis@google.com>,
        Alexander Graf <graf@amazon.com>,
        Andrew Jones <drjones@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ben Gardon <bgardon@google.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jacob Xu <jacobhxu@google.com>,
        Makarand Sonare <makarandsonare@google.com>,
        Oliver Upton <oupton@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Yanan Wang <wangyanan55@huawei.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Axel Rasmussen <axelrasmussen@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Each struct vm_mem_backing_src_alias has a flags field, which denotes
the flags used to mmap() an area of that type. Previously, this field
never included MAP_PRIVATE | MAP_ANONYMOUS, because
vm_userspace_mem_region_add assumed that *all* types would always use
those flags, and so it hardcoded them.

In a follow-up commit, we'll add a new type: shmem. Areas of this type
must not have MAP_PRIVATE | MAP_ANONYMOUS, and instead they must have
MAP_SHARED.

So, refactor things. Make it so that the flags field of
struct vm_mem_backing_src_alias really is a complete set of flags, and
don't add in any extras in vm_userspace_mem_region_add. This will let us
easily tack on shmem.

Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c  |  5 ++-
 tools/testing/selftests/kvm/lib/test_util.c | 35 +++++++++++----------
 2 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 0d6ddee429b9..bc405785ac8b 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -759,9 +759,8 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 
 	region->mmap_start = mmap(NULL, region->mmap_size,
 				  PROT_READ | PROT_WRITE,
-				  MAP_PRIVATE | MAP_ANONYMOUS
-				  | vm_mem_backing_src_alias(src_type)->flag,
-				  -1, 0);
+				  vm_mem_backing_src_alias(src_type)->flag,
+				  region->fd, 0);
 	TEST_ASSERT(region->mmap_start != MAP_FAILED,
 		    "test_malloc failed, mmap_start: %p errno: %i",
 		    region->mmap_start, errno);
diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
index 63d2bc7d757b..06ddde068736 100644
--- a/tools/testing/selftests/kvm/lib/test_util.c
+++ b/tools/testing/selftests/kvm/lib/test_util.c
@@ -168,70 +168,73 @@ size_t get_def_hugetlb_pagesz(void)
 
 const struct vm_mem_backing_src_alias *vm_mem_backing_src_alias(uint32_t i)
 {
+	static const int anon_flags = MAP_PRIVATE | MAP_ANONYMOUS;
+	static const int anon_huge_flags = anon_flags | MAP_HUGETLB;
+
 	static const struct vm_mem_backing_src_alias aliases[] = {
 		[VM_MEM_SRC_ANONYMOUS] = {
 			.name = "anonymous",
-			.flag = 0,
+			.flag = anon_flags,
 		},
 		[VM_MEM_SRC_ANONYMOUS_THP] = {
 			.name = "anonymous_thp",
-			.flag = 0,
+			.flag = anon_flags,
 		},
 		[VM_MEM_SRC_ANONYMOUS_HUGETLB] = {
 			.name = "anonymous_hugetlb",
-			.flag = MAP_HUGETLB,
+			.flag = anon_huge_flags,
 		},
 		[VM_MEM_SRC_ANONYMOUS_HUGETLB_16KB] = {
 			.name = "anonymous_hugetlb_16kb",
-			.flag = MAP_HUGETLB | MAP_HUGE_16KB,
+			.flag = anon_huge_flags | MAP_HUGE_16KB,
 		},
 		[VM_MEM_SRC_ANONYMOUS_HUGETLB_64KB] = {
 			.name = "anonymous_hugetlb_64kb",
-			.flag = MAP_HUGETLB | MAP_HUGE_64KB,
+			.flag = anon_huge_flags | MAP_HUGE_64KB,
 		},
 		[VM_MEM_SRC_ANONYMOUS_HUGETLB_512KB] = {
 			.name = "anonymous_hugetlb_512kb",
-			.flag = MAP_HUGETLB | MAP_HUGE_512KB,
+			.flag = anon_huge_flags | MAP_HUGE_512KB,
 		},
 		[VM_MEM_SRC_ANONYMOUS_HUGETLB_1MB] = {
 			.name = "anonymous_hugetlb_1mb",
-			.flag = MAP_HUGETLB | MAP_HUGE_1MB,
+			.flag = anon_huge_flags | MAP_HUGE_1MB,
 		},
 		[VM_MEM_SRC_ANONYMOUS_HUGETLB_2MB] = {
 			.name = "anonymous_hugetlb_2mb",
-			.flag = MAP_HUGETLB | MAP_HUGE_2MB,
+			.flag = anon_huge_flags | MAP_HUGE_2MB,
 		},
 		[VM_MEM_SRC_ANONYMOUS_HUGETLB_8MB] = {
 			.name = "anonymous_hugetlb_8mb",
-			.flag = MAP_HUGETLB | MAP_HUGE_8MB,
+			.flag = anon_huge_flags | MAP_HUGE_8MB,
 		},
 		[VM_MEM_SRC_ANONYMOUS_HUGETLB_16MB] = {
 			.name = "anonymous_hugetlb_16mb",
-			.flag = MAP_HUGETLB | MAP_HUGE_16MB,
+			.flag = anon_huge_flags | MAP_HUGE_16MB,
 		},
 		[VM_MEM_SRC_ANONYMOUS_HUGETLB_32MB] = {
 			.name = "anonymous_hugetlb_32mb",
-			.flag = MAP_HUGETLB | MAP_HUGE_32MB,
+			.flag = anon_huge_flags | MAP_HUGE_32MB,
 		},
 		[VM_MEM_SRC_ANONYMOUS_HUGETLB_256MB] = {
 			.name = "anonymous_hugetlb_256mb",
-			.flag = MAP_HUGETLB | MAP_HUGE_256MB,
+			.flag = anon_huge_flags | MAP_HUGE_256MB,
 		},
 		[VM_MEM_SRC_ANONYMOUS_HUGETLB_512MB] = {
 			.name = "anonymous_hugetlb_512mb",
-			.flag = MAP_HUGETLB | MAP_HUGE_512MB,
+			.flag = anon_huge_flags | MAP_HUGE_512MB,
 		},
 		[VM_MEM_SRC_ANONYMOUS_HUGETLB_1GB] = {
 			.name = "anonymous_hugetlb_1gb",
-			.flag = MAP_HUGETLB | MAP_HUGE_1GB,
+			.flag = anon_huge_flags | MAP_HUGE_1GB,
 		},
 		[VM_MEM_SRC_ANONYMOUS_HUGETLB_2GB] = {
 			.name = "anonymous_hugetlb_2gb",
-			.flag = MAP_HUGETLB | MAP_HUGE_2GB,
+			.flag = anon_huge_flags | MAP_HUGE_2GB,
 		},
 		[VM_MEM_SRC_ANONYMOUS_HUGETLB_16GB] = {
 			.name = "anonymous_hugetlb_16gb",
-			.flag = MAP_HUGETLB | MAP_HUGE_16GB,
+			.flag = anon_huge_flags | MAP_HUGE_16GB,
 		},
 	};
 	_Static_assert(ARRAY_SIZE(aliases) == NUM_SRC_TYPES,
-- 
2.31.1.751.gd2f1c929bd-goog

