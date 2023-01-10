Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10FBC663745
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 03:24:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237819AbjAJCYt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 21:24:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237802AbjAJCYo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 21:24:44 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1D7C1EEEE
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 18:24:43 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id d2-20020a170902cec200b001899479b1d8so7527337plg.22
        for <kvm@vger.kernel.org>; Mon, 09 Jan 2023 18:24:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Sb/UL9N+TdW3lyMm25d4vAkbjgvwAOnK9Fl+rduzRIA=;
        b=rEqCGz6t8QyQlPEI0NMPzk1i6EQpUrqa6XyEDrHbO0wHyeOeEfrPcIfaXWhoIk77s+
         UJd9yLZ6nX5O36ou5ENtRg9HtJXknlVeiIy+PS0zgiJiZGktSr6V9oILhwEYoP/Rzv/9
         rF1qj27evW3vgFYHed2IJLijv0bCseAxNKZq4DGaJRc/huiFJjonxXEIaFpoFPQGlYaE
         206m63B4RZrIiKDikwfEW5iyncqvQUyQxqNe2td0EivnsXeT8nQkZsqYNgUBcInnikzD
         BY+oKQJy7tU376nIBOiivhwFpd0AB+RuDVOYNx1jICIJU/s3lQB36RVg3j22zWX2b1GG
         je8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Sb/UL9N+TdW3lyMm25d4vAkbjgvwAOnK9Fl+rduzRIA=;
        b=z5Rv4FifSTdfthIAk+Rd1V4VgiqhibON5PiMpEPna/7sNfjGWy3mGJlPpno9E6vOE1
         U05YvT3M0Hlza8EUz3RAG9M4iruajVEGb0jza3raaczwgKwmtId8+tPxsAWvDywk7GlP
         2AYCwNWkaDNKsJOpHAw5iR4nSXz6MosWj1tBCG+WqWioKEuK7yTuSigYcJmg/EY6jcVF
         phbAsTlRu98vOaLYD51EH2UQYkSvZM//qGM1aVenp+FsYAsunbnIanJCGwCQsRv3IZsX
         xzbDhg3r18OOE4sb3V6pSd5ZvM6zVlWFi/HwCmFwhM33hutD6Mnbpo7qFYl5nUkZH7Fs
         K2DQ==
X-Gm-Message-State: AFqh2krYlmCHsLPHv7e7JH5BjLcKim6YdpPYH2wPpzqiiBittuJzl/vJ
        EwSRP88K8HhXhGTrzQruughyhR1Q9NTc+CUQ9JEM3IFSfECukqHmFTha8vB7VG0tZYMAupJYloY
        kIalOsPJQGqFHJzkVvsLRgc92p0dCWybXHNy1gMO4ETadX86rQGS0kphtkeFuTao=
X-Google-Smtp-Source: AMrXdXvlWGEjWfWcZbHDWIm9NmwSybJsE2rgL2m0oZSh7/z6aEYi0sv6dlvDGgg3uUUT97CYCNP50UyE+Oc6NA==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:a0f:b0:581:366c:64ff with SMTP
 id p15-20020a056a000a0f00b00581366c64ffmr3772266pfh.85.1673317483224; Mon, 09
 Jan 2023 18:24:43 -0800 (PST)
Date:   Tue, 10 Jan 2023 02:24:32 +0000
In-Reply-To: <20230110022432.330151-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230110022432.330151-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230110022432.330151-5-ricarkol@google.com>
Subject: [PATCH 4/4] KVM: selftests: aarch64: Test read-only PT memory regions
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

Extend the read-only memslot tests in page_fault_test to test read-only PT
(Page table) memslots. Note that this was not allowed before commit "KVM:
arm64: Fix handling of S1PTW S2 fault on RO memslots" as all S1PTW faults
were treated as writes which resulted in an (unrecoverable) exception
inside the guest.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/aarch64/page_fault_test.c        | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index 2e2178a7d0d8..2f81d68e876c 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -831,6 +831,7 @@ static void help(char *name)
 {										\
 	.name			= SCAT3(ro_memslot, _access, _with_af),		\
 	.data_memslot_flags	= KVM_MEM_READONLY,				\
+	.pt_memslot_flags	= KVM_MEM_READONLY,				\
 	.guest_prepare		= { _PREPARE(_access) },			\
 	.guest_test		= _access,					\
 	.mmio_handler		= _mmio_handler,				\
@@ -841,6 +842,7 @@ static void help(char *name)
 {										\
 	.name			= SCAT2(ro_memslot_no_syndrome, _access),	\
 	.data_memslot_flags	= KVM_MEM_READONLY,				\
+	.pt_memslot_flags	= KVM_MEM_READONLY,				\
 	.guest_test		= _access,					\
 	.fail_vcpu_run_handler	= fail_vcpu_run_mmio_no_syndrome_handler,	\
 	.expected_events	= { .fail_vcpu_runs = 1 },			\
@@ -851,7 +853,7 @@ static void help(char *name)
 {										\
 	.name			= SCAT3(ro_memslot, _access, _with_af),		\
 	.data_memslot_flags	= KVM_MEM_READONLY | KVM_MEM_LOG_DIRTY_PAGES,	\
-	.pt_memslot_flags	= KVM_MEM_LOG_DIRTY_PAGES,			\
+	.pt_memslot_flags	= KVM_MEM_READONLY | KVM_MEM_LOG_DIRTY_PAGES,	\
 	.guest_prepare		= { _PREPARE(_access) },			\
 	.guest_test		= _access,					\
 	.guest_test_check	= { _test_check },				\
@@ -863,7 +865,7 @@ static void help(char *name)
 {										\
 	.name			= SCAT2(ro_memslot_no_syn_and_dlog, _access),	\
 	.data_memslot_flags	= KVM_MEM_READONLY | KVM_MEM_LOG_DIRTY_PAGES,	\
-	.pt_memslot_flags	= KVM_MEM_LOG_DIRTY_PAGES,			\
+	.pt_memslot_flags	= KVM_MEM_READONLY | KVM_MEM_LOG_DIRTY_PAGES,	\
 	.guest_test		= _access,					\
 	.guest_test_check	= { _test_check },				\
 	.fail_vcpu_run_handler	= fail_vcpu_run_mmio_no_syndrome_handler,	\
@@ -875,6 +877,7 @@ static void help(char *name)
 {										\
 	.name			= SCAT2(ro_memslot_uffd, _access),		\
 	.data_memslot_flags	= KVM_MEM_READONLY,				\
+	.pt_memslot_flags	= KVM_MEM_READONLY,				\
 	.mem_mark_cmd		= CMD_HOLE_DATA | CMD_HOLE_PT,			\
 	.guest_prepare		= { _PREPARE(_access) },			\
 	.guest_test		= _access,					\
@@ -890,6 +893,7 @@ static void help(char *name)
 {										\
 	.name			= SCAT2(ro_memslot_no_syndrome, _access),	\
 	.data_memslot_flags	= KVM_MEM_READONLY,				\
+	.pt_memslot_flags	= KVM_MEM_READONLY,				\
 	.mem_mark_cmd		= CMD_HOLE_DATA | CMD_HOLE_PT,			\
 	.guest_test		= _access,					\
 	.uffd_data_handler	= _uffd_data_handler,				\
@@ -1024,7 +1028,7 @@ static struct test_desc tests[] = {
 				guest_check_write_in_dirty_log,
 				guest_check_s1ptw_wr_in_dirty_log),
 	/*
-	 * Try accesses when the data memory region is marked read-only
+	 * Access when both the PT and data regions are marked read-only
 	 * (with KVM_MEM_READONLY). Writes with a syndrome result in an
 	 * MMIO exit, writes with no syndrome (e.g., CAS) result in a
 	 * failed vcpu run, and reads/execs with and without syndroms do
@@ -1040,7 +1044,7 @@ static struct test_desc tests[] = {
 	TEST_RO_MEMSLOT_NO_SYNDROME(guest_st_preidx),
 
 	/*
-	 * Access when both the data region is both read-only and marked
+	 * The PT and data regions are both read-only and marked
 	 * for dirty logging at the same time. The expected result is that
 	 * for writes there should be no write in the dirty log. The
 	 * readonly handling is the same as if the memslot was not marked
@@ -1065,7 +1069,7 @@ static struct test_desc tests[] = {
 						  guest_check_no_write_in_dirty_log),
 
 	/*
-	 * Access when the data region is both read-only and punched with
+	 * The PT and data regions are both read-only and punched with
 	 * holes tracked with userfaultfd.  The expected result is the
 	 * union of both userfaultfd and read-only behaviors. For example,
 	 * write accesses result in a userfaultfd write fault and an MMIO
-- 
2.39.0.314.g84b9a713c41-goog

