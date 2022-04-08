Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0664F9EC9
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 23:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239735AbiDHVIL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 17:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239741AbiDHVIH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 17:08:07 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 155D113CCE7
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 14:06:03 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id b6-20020a62a106000000b0050564d6fd75so3820597pff.22
        for <kvm@vger.kernel.org>; Fri, 08 Apr 2022 14:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=p+6J5avDF84ftaGe39tTHRoP/NBW8772y66wg1YfZYw=;
        b=l0FXhWa/6YJKcTE5WGzDyEC+UrLkSpJwQDJkJsDVyNCbeKa+j011f+nnEMfM/d7Yn2
         vqnoDRBaNf9IoPd4xNvbP9KSD58R/Fp3gNuGLjKhyxKStwtunD0MB37DqfQP0LW7PGrq
         slph68rE/UdnBwzmZ+mNKfL9TSUcXXMOOj04cUVMIxtdTSnhJT9Y1XLA8FHGfPARTd0U
         JaTa3xOyWnbW51pC/QiY87Gd0W4v4IY+IrQrJUW29R/ZPK4CuLQ8gsy0K56vhahESAbU
         osOkiuhnjdio/riFZgIMbrFuClGk0cxmaxxxQCCZ9VD3bSQ4uOtdMM9lNNNKshoMx3X0
         xcBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=p+6J5avDF84ftaGe39tTHRoP/NBW8772y66wg1YfZYw=;
        b=lO5jGvl52JeI2rr4oY3Ly1xTqZFRSeLhPZ9e8SXHVbRC0WKPMigJx4S+OYZk/7+/Cn
         BxENTpQvzVvyJzz9i+kfVuZuipw/aQGT72e9T46g1JbTjJrk6C7xrv65Ncq9T7KWqaSB
         SjFo8pzP8t3bFP0HZxIM3/Vg48uL1xZNpVPbnAOAicrPCUIpO0dzKqzdv7unozmf5Ixb
         gcSDY4Wn1uq+j9xFUj5JwTtIsUTeTbtzW0eY+P0e4nAKO4UOi0tUZblsaD6eENFvYrWj
         Jgx4duOSDSf3NUBIdFphW9nzqYqf15hVJl31Vs/jsF3zG9VV/zggxpQGh2hjAs7c+GWE
         atsQ==
X-Gm-Message-State: AOAM533xS/+h6FeWOOi5FsnAY54/KLR4IghmydwlZUnnV/OmqJRdJL7J
        tB3x/Jr6InqeWkbrXkw495zh44rntB/XFL9T
X-Google-Smtp-Source: ABdhPJwkd3il5WzGjYKAv2n2CphkdVejN98fg/wNCluE/8xZWC50B6gLsb61B6viCzpZYwi6CRhlp5PWQl3rD8L2
X-Received: from vannapurve2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:41f8])
 (user=vannapurve job=sendgmr) by 2002:a05:6a00:846:b0:4fb:3b79:fc94 with SMTP
 id q6-20020a056a00084600b004fb3b79fc94mr21231620pfk.76.1649451962533; Fri, 08
 Apr 2022 14:06:02 -0700 (PDT)
Date:   Fri,  8 Apr 2022 21:05:44 +0000
In-Reply-To: <20220408210545.3915712-1-vannapurve@google.com>
Message-Id: <20220408210545.3915712-5-vannapurve@google.com>
Mime-Version: 1.0
References: <20220408210545.3915712-1-vannapurve@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [RFC V1 PATCH 4/5] selftests: kvm: priv_memfd_test: Add support for
 memory conversion
From:   Vishal Annapurve <vannapurve@google.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, shauh@kernel.org, yang.zhong@intel.com,
        drjones@redhat.com, ricarkol@google.com, aaronlewis@google.com,
        wei.w.wang@intel.com, kirill.shutemov@linux.intel.com,
        corbet@lwn.net, hughd@google.com, jlayton@kernel.org,
        bfields@fieldses.org, akpm@linux-foundation.org,
        chao.p.peng@linux.intel.com, yu.c.zhang@linux.intel.com,
        jun.nakajima@intel.com, dave.hansen@intel.com,
        michael.roth@amd.com, qperret@google.com, steven.price@arm.com,
        ak@linux.intel.com, david@redhat.com, luto@kernel.org,
        vbabka@suse.cz, marcorr@google.com, erdemaktas@google.com,
        pgonda@google.com, seanjc@google.com, diviness@google.com,
        Vishal Annapurve <vannapurve@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add handling of explicit private/shared memory conversion using
KVM_HC_MAP_GPA_RANGE and implicit memory conversion by handling
KVM_EXIT_MEMORY_ERROR.

Signed-off-by: Vishal Annapurve <vannapurve@google.com>
---
 tools/testing/selftests/kvm/priv_memfd_test.c | 87 +++++++++++++++++++
 1 file changed, 87 insertions(+)

diff --git a/tools/testing/selftests/kvm/priv_memfd_test.c b/tools/testing/selftests/kvm/priv_memfd_test.c
index 11ccdb853a84..0e6c19501f27 100644
--- a/tools/testing/selftests/kvm/priv_memfd_test.c
+++ b/tools/testing/selftests/kvm/priv_memfd_test.c
@@ -129,6 +129,83 @@ static struct test_run_helper priv_memfd_testsuite[] = {
 	},
 };
 
+static void handle_vm_exit_hypercall(struct kvm_run *run,
+	uint32_t test_id)
+{
+	uint64_t gpa, npages, attrs;
+	int priv_memfd =
+		priv_memfd_testsuite[test_id].priv_memfd;
+	int ret;
+	int fallocate_mode;
+
+	if (run->hypercall.nr != KVM_HC_MAP_GPA_RANGE) {
+		TEST_FAIL("Unhandled Hypercall %lld\n",
+					run->hypercall.nr);
+	}
+
+	gpa = run->hypercall.args[0];
+	npages = run->hypercall.args[1];
+	attrs = run->hypercall.args[2];
+
+	if ((gpa >= TEST_MEM_GPA) && ((gpa +
+		(npages << MIN_PAGE_SHIFT)) <= TEST_MEM_END)) {
+		TEST_FAIL("Unhandled gpa 0x%lx npages %ld\n",
+			gpa, npages);
+	}
+
+	if (attrs & KVM_MAP_GPA_RANGE_ENCRYPTED)
+		fallocate_mode = 0;
+	else {
+		fallocate_mode = (FALLOC_FL_PUNCH_HOLE |
+			FALLOC_FL_KEEP_SIZE);
+	}
+	pr_info("Converting off 0x%lx pages 0x%lx to %s\n",
+		(gpa - TEST_MEM_GPA), npages,
+		fallocate_mode ?
+			"shared" : "private");
+	ret = fallocate(priv_memfd, fallocate_mode,
+		(gpa - TEST_MEM_GPA),
+		npages << MIN_PAGE_SHIFT);
+	TEST_ASSERT(ret != -1,
+		"fallocate failed in hc handling");
+	run->hypercall.ret = 0;
+}
+
+static void handle_vm_exit_memory_error(struct kvm_run *run,
+	uint32_t test_id)
+{
+	uint64_t gpa, size, flags;
+	int ret;
+	int priv_memfd =
+		priv_memfd_testsuite[test_id].priv_memfd;
+	int fallocate_mode;
+
+	gpa = run->memory.gpa;
+	size = run->memory.size;
+	flags = run->memory.flags;
+
+	if ((gpa < TEST_MEM_GPA) || ((gpa + size)
+					> TEST_MEM_END)) {
+		TEST_FAIL("Unhandled gpa 0x%lx size 0x%lx\n",
+			gpa, size);
+	}
+
+	if (flags & KVM_MEMORY_EXIT_FLAG_PRIVATE)
+		fallocate_mode = 0;
+	else {
+		fallocate_mode = (FALLOC_FL_PUNCH_HOLE |
+				FALLOC_FL_KEEP_SIZE);
+	}
+	pr_info("Converting off 0x%lx size 0x%lx to %s\n",
+		(gpa - TEST_MEM_GPA), size,
+		fallocate_mode ?
+			"shared" : "private");
+	ret = fallocate(priv_memfd, fallocate_mode,
+		(gpa - TEST_MEM_GPA), size);
+	TEST_ASSERT(ret != -1,
+		"fallocate failed in memory error handling");
+}
+
 static void vcpu_work(struct kvm_vm *vm, uint32_t test_id)
 {
 	struct kvm_run *run;
@@ -155,6 +232,16 @@ static void vcpu_work(struct kvm_vm *vm, uint32_t test_id)
 			continue;
 		}
 
+		if (run->exit_reason == KVM_EXIT_HYPERCALL) {
+			handle_vm_exit_hypercall(run, test_id);
+			continue;
+		}
+
+		if (run->exit_reason == KVM_EXIT_MEMORY_ERROR) {
+			handle_vm_exit_memory_error(run, test_id);
+			continue;
+		}
+
 		TEST_FAIL("Unhandled VCPU exit reason %d\n", run->exit_reason);
 		break;
 	}
-- 
2.35.1.1178.g4f1659d476-goog

