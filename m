Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3F9B67F094
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 22:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbjA0VoE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 16:44:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231686AbjA0VoB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 16:44:01 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 310207AE75
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 13:44:01 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id k204-20020a256fd5000000b007b8b040bc50so6615209ybc.1
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 13:44:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ow7bHQQrk81H5p7MdEvUeMOlztu0LrzFJM8nKhppa2g=;
        b=iwERg0mlUIwCHJ34JdGmjSttyNSInsW2zsHwXq8EvlPTsyVQI8RzkremFBPOeIhfn9
         nlfQyfw5lJVMrTnx7M3vkW+yFQbA27E4KFRyD1aVDAsgK2qIb4w+UmF3SW0JeTw0uWaf
         toGYrTsfRQfxzlMVuCig9WgAJPIES5EvZCoZmNhnDv8VQRIyMNacDOwfntHKbZ4EmDP6
         misRjySTqXKgYwSqwGdUBElISIjBpUaw+vKPRHZ381WD9yUDaAkfJ8Ck6TYAj/fi7oBe
         M5Q+tnrEoM2hFdJUr9s1DvLbco67J0VSMhMy2HpzCgT/xnqP/t4Ovp5WXeoJzvFO49k6
         fdtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ow7bHQQrk81H5p7MdEvUeMOlztu0LrzFJM8nKhppa2g=;
        b=BcahKwECBg5taXc+9b1QCKfGpYNudMVDYI9pKXPHBA3U/Rnxr5dPHP6fEcJrV3xL9t
         CBQrHbw5RaToUE96hebJi80IE41/f4be4PoioBL8aC/s2RgHI3pu/mYItl+2l5XKTuOn
         hfK/xfiE8buHrCvDtfnWnaZd70gLUHwgdpHt5yqu5VAVIXlnBUezXoeVk6oxu7kaEWZC
         oh+GprTPUF1hnX9A27muyF/B6Qm7akx37D2D71JVWj5gHF/ETGk5vocTUsibF7ovqyYB
         cP9IThhcRJbWRUr8x3BoQC4oWhVSo3gOWm4ooipnc38Ylex9q+2qIhY9/2GGhodFAmSn
         L5vg==
X-Gm-Message-State: AFqh2kpHUmh9vIwIKHZActJWPXAkMIMQgf9+Opnp79bLxf/StSI0O7kn
        /2sjT2x5NpBndIYtBrYBrKDp+f0vQNbXc1VvhO8D5tPJ1/E//onTPAEqMR/YZdVjSozwVjHfH+Y
        ExUCtDAucxz5qcLbshEjhCvcOINgPwQPLvj875UMPKWN3gjPsq/+/lrtMwqRnQE0=
X-Google-Smtp-Source: AMrXdXvLxD9R2nwpuG/CYmx8tWVUDrbel8HTvFJ26X3Vr6vnt6OGPtFVeAvBzAo5+GrsgKzkMmMMltXrI4hh3w==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a81:6607:0:b0:501:539e:8b5e with SMTP id
 a7-20020a816607000000b00501539e8b5emr3435776ywc.112.1674855840276; Fri, 27
 Jan 2023 13:44:00 -0800 (PST)
Date:   Fri, 27 Jan 2023 21:43:52 +0000
In-Reply-To: <20230127214353.245671-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230127214353.245671-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230127214353.245671-4-ricarkol@google.com>
Subject: [PATCH v2 3/4] KVM: selftests: aarch64: Fix check of dirty log PT write
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oupton@google.com, yuzenghui@huawei.com,
        Ricardo Koller <ricarkol@google.com>
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

The dirty log checks are mistakenly testing the first page in the page
table (PT) memory region instead of the page holding the test data
page PTE.  This wasn't an issue before commit 406504c7b040 ("KVM:
arm64: Fix S1PTW handling on RO memslots") as all PT pages (including
the first page) were treated as writes.

Fix the page_fault_test dirty logging tests by checking for the right
page: the one for the PTE of the data test page.

Fixes: a4edf25b3e25 ("KVM: selftests: aarch64: Add dirty logging tests into page_fault_test")
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/aarch64/page_fault_test.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index 1a3bb2bd8657..2e2178a7d0d8 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -470,9 +470,12 @@ static bool handle_cmd(struct kvm_vm *vm, int cmd)
 {
 	struct userspace_mem_region *data_region, *pt_region;
 	bool continue_test = true;
+	uint64_t pte_gpa, pte_pg;
 
 	data_region = vm_get_mem_region(vm, MEM_REGION_TEST_DATA);
 	pt_region = vm_get_mem_region(vm, MEM_REGION_PT);
+	pte_gpa = addr_hva2gpa(vm, virt_get_pte_hva(vm, TEST_GVA));
+	pte_pg = (pte_gpa - pt_region->region.guest_phys_addr) / getpagesize();
 
 	if (cmd == CMD_SKIP_TEST)
 		continue_test = false;
@@ -485,13 +488,13 @@ static bool handle_cmd(struct kvm_vm *vm, int cmd)
 		TEST_ASSERT(check_write_in_dirty_log(vm, data_region, 0),
 			    "Missing write in dirty log");
 	if (cmd & CMD_CHECK_S1PTW_WR_IN_DIRTY_LOG)
-		TEST_ASSERT(check_write_in_dirty_log(vm, pt_region, 0),
+		TEST_ASSERT(check_write_in_dirty_log(vm, pt_region, pte_pg),
 			    "Missing s1ptw write in dirty log");
 	if (cmd & CMD_CHECK_NO_WRITE_IN_DIRTY_LOG)
 		TEST_ASSERT(!check_write_in_dirty_log(vm, data_region, 0),
 			    "Unexpected write in dirty log");
 	if (cmd & CMD_CHECK_NO_S1PTW_WR_IN_DIRTY_LOG)
-		TEST_ASSERT(!check_write_in_dirty_log(vm, pt_region, 0),
+		TEST_ASSERT(!check_write_in_dirty_log(vm, pt_region, pte_pg),
 			    "Unexpected s1ptw write in dirty log");
 
 	return continue_test;
-- 
2.39.1.456.gfc5497dd1b-goog

