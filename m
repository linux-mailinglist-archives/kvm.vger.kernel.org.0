Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ECD07206EB
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 18:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236424AbjFBQJd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 12:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236598AbjFBQJb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 12:09:31 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 555EF1BD
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 09:09:26 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-2566b668cc5so1567373a91.0
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 09:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685722166; x=1688314166;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=U16a7SsqQ7yjyv5J8Y2N4u7Ylkl11H9qatwpuhmZUgo=;
        b=636YoGkhL1EaD07rsMfPK9rB926Ht76M8pVZszNcRp8cSFBaHFxW4ESJErvKH1m1wQ
         b8SVVb+49Lm4c7lpuGUxvabzksatMUh3aHtTfXuucGjqsfAbB7x8jB5X+IIkfWd/B+pM
         hI1Jypk91JlkfEFB2dbGzi8Bjd9QmphZBvbPzeFfXopwyd64oFIEk7hcFeTi49fzsYb0
         jMhjapC0h8n44W4QCQ7q/RI4lKIJPywJjobPFbGliUK4+jwpyLj3v9rdAbRrHTavotzv
         jSbTLKdo3Rd++6WRrKKX3ZluUSmLDy9wL6sxwwb/x/fXUrLPPNX7BCJ2JivFRXiwGY+V
         XR9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685722166; x=1688314166;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U16a7SsqQ7yjyv5J8Y2N4u7Ylkl11H9qatwpuhmZUgo=;
        b=Ivqlij2MD525PZ/Q+5eDSoLs1jFoBdhrC5NevtcY4+djYHXlSkRdAblBVDrmLIvFHt
         uRRVQR2dM9pX12VA0LuhUM6mP4TV+907tPDZbDCKXaQb2owG9Tn+dSgPuGCP+h5osNo6
         fvLZjjV0/sJf/FKHEYxRAsCpn8qnys48BmVFy8QhJSji1eLVRy/Yt0I8rVv0b+aLfHnm
         WxjMBwZ42cJHKkd4TRk3USZGaPg41EgLCW13pcl88wSoCwEwoDu8HUvoS59tHfbqlnpI
         irWy3ID4IXxkKeyd2Y9/j3m8DJGfQEMrVFeP5UNxvw8eA7wMwUPn8Vzr6NYLvz7IEDvK
         VEcQ==
X-Gm-Message-State: AC+VfDzz4wHalV60sdUTMTBlF7kp3TJzThR9AbM9zZ5dZlJ1GkMkk/Ii
        puy6w7YqBCD9FrM/4Iw6MVJOuk1Qr75U
X-Google-Smtp-Source: ACHHUZ5ZPLDaNjdv6ql0/d9oDMUgHRd2fE1fBqzKriMYD3yXbiA53bpGux4rVDyMUkeRamgRC/kjMfQm5qU6
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:90a:de04:b0:24e:18ff:5bad with SMTP id
 m4-20020a17090ade0400b0024e18ff5badmr42850pjv.0.1685722165847; Fri, 02 Jun
 2023 09:09:25 -0700 (PDT)
Date:   Fri,  2 Jun 2023 09:09:01 -0700
In-Reply-To: <20230602160914.4011728-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20230602160914.4011728-1-vipinsh@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602160914.4011728-4-vipinsh@google.com>
Subject: [PATCH v2 03/16] KVM: selftests: Pass the count of read and write
 accesses from guest to host
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

Pass the number of read and write accesses done in the memstress guest
code to userspace.

These counts will provide a  way to measure vCPUs performance during
memstress and dirty logging related tests. For example, in
dirty_log_perf_test this can be used to measure how much progress vCPUs
are able to do while VMM is getting and clearing dirty logs.

In dirty_log_perf_test, each vCPU runs once and then waits until
iteration value is incremented by main thread, therefore, these access
counts will not provide much useful information except for observing
read vs write counts.

However, in future commits, dirty_log_perf_test behavior will be changed
to allow vCPUs to execute independent of userspace iterations. This will
mimic real world workload where guest keeps on executing while VMM is
collecting and clearing dirty logs separately. With read and write
accesses known for each vCPU, impact of get and clear dirty log APIs can
be quantified.

Note that access counts will not be 100% reliable in knowing vCPUs
performances. Few things which can affect vCPU progress:
1. vCPUs are scheduled less by host
2. Userspace operations run for longer time which end up giving vCPUs
   more time to execute.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 tools/testing/selftests/kvm/lib/memstress.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/memstress.c b/tools/testing/selftests/kvm/lib/memstress.c
index 5f1d3173c238..ac53cc6e36d7 100644
--- a/tools/testing/selftests/kvm/lib/memstress.c
+++ b/tools/testing/selftests/kvm/lib/memstress.c
@@ -49,6 +49,8 @@ void memstress_guest_code(uint32_t vcpu_idx)
 	struct memstress_args *args = &memstress_args;
 	struct memstress_vcpu_args *vcpu_args = &args->vcpu_args[vcpu_idx];
 	struct guest_random_state rand_state;
+	uint64_t write_access;
+	uint64_t read_access;
 	uint64_t gva;
 	uint64_t pages;
 	uint64_t addr;
@@ -64,6 +66,8 @@ void memstress_guest_code(uint32_t vcpu_idx)
 	GUEST_ASSERT(vcpu_args->vcpu_idx == vcpu_idx);
 
 	while (true) {
+		write_access = 0;
+		read_access = 0;
 		for (i = 0; i < pages; i++) {
 			if (args->random_access)
 				page = guest_random_u32(&rand_state) % pages;
@@ -72,13 +76,16 @@ void memstress_guest_code(uint32_t vcpu_idx)
 
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
2.41.0.rc0.172.g3f132b7071-goog

