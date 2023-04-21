Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 332E06EB001
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 19:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbjDURCH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 13:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232848AbjDURCE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 13:02:04 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F7816B02
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 10:01:32 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-55605fd3e19so24417097b3.1
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 10:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682096459; x=1684688459;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2PAF8eecHjdHkncCHVDxnuwZD238/O/D5uX087DV6gk=;
        b=UVoNE8og/KSndrx7km5yiwGKXnvIFmtfcvry2Qewnw+cs6W4T9uxPcL0CEcyr/ZybK
         PhBFaKzva98hBl+ZVj26lKxHDHO/9yClIks5jUarsDMaG9k7RAiqVbab8UUqp+oGgOzU
         V36F5nwB4Fum5qgz8e4xiA/1VQNGo+X9wAN4eoUh49Gl0idGfuxdt+3v5S5ttbUC57jn
         TZJGRD6602B+GHKnLAQ5dtbQGCQsLb+iNufksU4DKvmA5VklAsw6zalzXJn4DA3q1D+K
         DpqStXfNZpzk186SD95GE7k73Iy04EngZtgTCfX+7Z1KyhvAJDfFyVkBP2zVLPxYMhZf
         TlQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682096459; x=1684688459;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2PAF8eecHjdHkncCHVDxnuwZD238/O/D5uX087DV6gk=;
        b=WV2INcnUfsmnlTJO4qkmi637Ay6tDxEKodwJViUZMCcHJpA8IrRpCOvSPSnvsnz8k7
         e9EdZnp1HWLacgU8Kkrxb26s6QyWemNMEyULf7UD/gOG+W4k+/67FmfNGcRMZcf524G9
         /sSqQvpP+Zy8b5Vkp4Ck0bmpbfkshJUA/ocB8LaNszKyPeDF3e3Rj5wNZVq4qkQcKtxe
         GnSYQ+Ti0YMW2zh5fiEShMb45+fhmgrJWV0CLgZt3ELJ88w+K2icx4tO3H1EYC7JXYtU
         qzD8zAQw6OWFXuqawKq1dSob8FkbKD4EoT0o3MWThncqkYmkLmrHoltzvyfbH/en5of3
         bQlA==
X-Gm-Message-State: AAQBX9c/avmiSecM0wbGjQF+dzXH+ATeVNkw3VDGBJ1d2y6RPc/3jPQK
        6P1RtpqW/tse/PR6YJYEx8ctIC3BaD5L
X-Google-Smtp-Source: AKy350ZhDTjaiDsWlopRxc48Dw1pNwwJqPHfzna6+NHQQh4Cp6jlmLNI1MOs2L3SqIF7smNjuMPM7IP//W/I
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:902:7b85:b0:1a0:4321:920e with SMTP id
 w5-20020a1709027b8500b001a04321920emr1816879pll.12.1682095994335; Fri, 21 Apr
 2023 09:53:14 -0700 (PDT)
Date:   Fri, 21 Apr 2023 09:52:59 -0700
In-Reply-To: <20230421165305.804301-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20230421165305.804301-1-vipinsh@google.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230421165305.804301-4-vipinsh@google.com>
Subject: [PATCH 3/9] KVM: selftests: Pass count of read and write accesses
 from guest to host
From:   Vipin Sharma <vipinsh@google.com>
To:     maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com,
        suzuki.poulose@arm.com, yuzenghui@huawei.com,
        catalin.marinas@arm.com, will@kernel.org, chenhuacai@kernel.org,
        aleksandar.qemu.devel@gmail.com, tsbogend@alpha.franken.de,
        anup@brainfault.org, atishp@atishpatra.org,
        paul.walmsley@sifive.com, palmer@dabbelt.com,
        aou@eecs.berkeley.edu, seanjc@google.com, pbonzini@redhat.com,
        dmatlack@google.com, ricarkol@google.com
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pass number of read and write accesses done in the memstress' guest code
to userspace.

These counts will be one way to measure vCPU performances during
memstress and dirty logging related tests. For example, in
dirty_log_perf_test this can be used to measure impact of dirty and
clear log APIs on vCPUs performances.

In current dirty_log_perf_test, each vCPU executes in lockstep to the
current iteration in userspace, therefore, these access counts will not
provide much useful information except for observing individual vCPUs
read vs write accesses.

However, in future commits, dirty_log_perf_test behavior will be changed
to allow vCPUs to execute independent of userspace iterations. This will
mimic real world workload where guest keeps on executing while VMM is
collecting and clearing dirty logs separately. With read and write
accesses known for each vCPU, impact of get and clear dirty log APIs can
be quantified. Note that these access counts will not be 100% reliable
in knowing vCPUs performances since vCPUs scheduling can impact
the progress.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 tools/testing/selftests/kvm/lib/memstress.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/memstress.c b/tools/testing/selftests/kvm/lib/memstress.c
index 483ecbc53a5b..9c2e360e610f 100644
--- a/tools/testing/selftests/kvm/lib/memstress.c
+++ b/tools/testing/selftests/kvm/lib/memstress.c
@@ -50,6 +50,8 @@ void memstress_guest_code(uint32_t vcpu_idx)
 	struct memstress_args *args = &memstress_args;
 	struct memstress_vcpu_args *vcpu_args = &args->vcpu_args[vcpu_idx];
 	struct guest_random_state rand_state;
+	uint64_t write_access;
+	uint64_t read_access;
 	uint64_t gva;
 	uint64_t pages;
 	uint64_t addr;
@@ -65,6 +67,8 @@ void memstress_guest_code(uint32_t vcpu_idx)
 	GUEST_ASSERT(vcpu_args->vcpu_idx == vcpu_idx);
 
 	while (true) {
+		write_access = 0;
+		read_access = 0;
 		for (i = 0; i < pages; i++) {
 			if (args->random_access)
 				page = guest_random_u32(&rand_state) % pages;
@@ -73,13 +77,16 @@ void memstress_guest_code(uint32_t vcpu_idx)
 
 			addr = gva + (page * args->guest_page_size);
 
-			if (guest_random_u32(&rand_state) % 100 < args->write_percent)
+			if (guest_random_u32(&rand_state) % 100 < args->write_percent) {
 				*(uint64_t *)addr = 0x0123456789ABCDEF;
-			else
+				write_access++;
+			} else {
 				READ_ONCE(*(uint64_t *)addr);
+				read_access++;
+			}
 		}
 
-		GUEST_SYNC(1);
+		GUEST_SYNC_ARGS(1, read_access, write_access, 0, 0);
 	}
 }
 
-- 
2.40.0.634.g4ca3ef3211-goog

