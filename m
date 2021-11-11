Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0EA44CE10
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 01:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234320AbhKKAGO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 19:06:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234298AbhKKAGL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 19:06:11 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF48C061766
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 16:03:23 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id e12-20020aa7980c000000b0049fa3fc29d0so2851431pfl.10
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 16:03:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=B8cm2qYWROOtIl5gOndE9XoYMKnnSnuEUS9XIYWaW0E=;
        b=FGHd0rNtDhbC8/teZ4SMfK2SKHrj53ddkDEogPUQBPaSz4rKwtmYvw6fAaIkct9S0m
         EKy8ppo+R2/+mKhy6gNq8AxXEE1oB8AI3gC/TMQd3/ovpFk/v1hZoEEVhrAeaWA+LxCH
         F0+p2xd/jdmIOeKmgPusxz3Job9oz+p/nAWfRxsZP7Vq3uO84jyn1AuYyPW89nZNc9lO
         MoyPw8tixKYol2PcFzmZ6ymm2uS9o8pRj6eCJ61mgLWh6XrQpjXIz0f9gDYi9U4V693F
         cctox7c0L9wB3S+l6HOHmqwfXQNINPLpRBldZDT3rHPFXajNiFg84ZdQtE8mQ/ZSIGiG
         o9qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=B8cm2qYWROOtIl5gOndE9XoYMKnnSnuEUS9XIYWaW0E=;
        b=KYYFNDfyC9cEVm9pvr/mt5CMUj/z88o/u6bs9dl/DgcJI2yfTnD0GrwbhxOVPSsR4t
         7Alt054LA3TlpgDVSmNmAqngPDG9JBBt11jsJWrdann6OGTjwx7wkjbzI4vifg94PE8H
         LBNLdd0Q2yHdMIVJ6mA2kr443znFIDBTe9Cdc/rvEHze8epU8Du3shgysFBhGUQrbWT2
         KuJO9cxSsIW0K53MmJznJdB+Xrhiy9x3Ggd2jinU4bDrKiQ0d/xQibM8EfW9KsK1M/gI
         r3Q4I320ppcRV+WOCygYkjYu55VoYZj1HovcxUevvLR28mzaynAU9qxhudmoomPBoU6l
         FwSw==
X-Gm-Message-State: AOAM533YhxrFp10rjBuUJAfBqriVBPx/G+F4z8H4C1ZeT5OvIocvgvpw
        QYXKk7PMteis6A0Jl2Rok6eJCHeejQjEXw==
X-Google-Smtp-Source: ABdhPJym0I4bUp2j9QUcsaaLlRS1m9gACZ5l/RAWeIUiMUtptxbNufJmNCRzjfkLtdm0LbWzOH7gBXuqoLM1dA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:3045:: with SMTP id
 q5mr3492640pjl.58.1636589002881; Wed, 10 Nov 2021 16:03:22 -0800 (PST)
Date:   Thu, 11 Nov 2021 00:03:02 +0000
In-Reply-To: <20211111000310.1435032-1-dmatlack@google.com>
Message-Id: <20211111000310.1435032-5-dmatlack@google.com>
Mime-Version: 1.0
References: <20211111000310.1435032-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [PATCH v2 04/12] KVM: selftests: Require GPA to be aligned when
 backed by hugepages
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Peter Xu <peterx@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Assert that the GPA for a memslot backed by a hugepage is aligned to
the hugepage size and fix perf_test_util accordingly.  Lack of GPA
alignment prevents KVM from backing the guest with hugepages, e.g. x86's
write-protection of hugepages when dirty logging is activated is
otherwise not exercised.

Add a comment explaining that guest_page_size is for non-huge pages to
try and avoid confusion about what it actually tracks.

Cc: Ben Gardon <bgardon@google.com>
Cc: Yanan Wang <wangyanan55@huawei.com>
Cc: Andrew Jones <drjones@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Aaron Lewis <aaronlewis@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
[Used get_backing_src_pagesz() to determine alignment dynamically.]
Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c       | 2 ++
 tools/testing/selftests/kvm/lib/perf_test_util.c | 7 ++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 07f37456bba0..1f6a01c33dce 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -875,6 +875,8 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 	if (src_type == VM_MEM_SRC_ANONYMOUS_THP)
 		alignment = max(backing_src_pagesz, alignment);
 
+	ASSERT_EQ(guest_paddr, align_up(guest_paddr, backing_src_pagesz));
+
 	/* Add enough memory to align up if necessary */
 	if (alignment > 1)
 		region->mmap_size += alignment;
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 6b8d5020dc54..a015f267d945 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -55,11 +55,16 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 {
 	struct kvm_vm *vm;
 	uint64_t guest_num_pages;
+	uint64_t backing_src_pagesz = get_backing_src_pagesz(backing_src);
 	int i;
 
 	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
 
 	perf_test_args.host_page_size = getpagesize();
+	/*
+	 * Snapshot the non-huge page size.  This is used by the guest code to
+	 * access/dirty pages at the logging granularity.
+	 */
 	perf_test_args.guest_page_size = vm_guest_mode_params[mode].page_size;
 
 	guest_num_pages = vm_adjust_num_guest_pages(mode,
@@ -92,7 +97,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 
 	guest_test_phys_mem = (vm_get_max_gfn(vm) - guest_num_pages) *
 			      perf_test_args.guest_page_size;
-	guest_test_phys_mem = align_down(guest_test_phys_mem, perf_test_args.host_page_size);
+	guest_test_phys_mem = align_down(guest_test_phys_mem, backing_src_pagesz);
 #ifdef __s390x__
 	/* Align to 1M (segment size) */
 	guest_test_phys_mem = align_down(guest_test_phys_mem, 1 << 20);
-- 
2.34.0.rc1.387.gb447b232ab-goog

