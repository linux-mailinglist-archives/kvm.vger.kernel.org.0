Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 220E764766A
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 20:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbiLHTje (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 14:39:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiLHTj3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 14:39:29 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ABCA82FA9
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 11:39:21 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id f11-20020a5b01cb000000b0070374b66537so2540571ybp.14
        for <kvm@vger.kernel.org>; Thu, 08 Dec 2022 11:39:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SSdGxEhCr0RqVU7mTEekOKbILUbkr12FLBfwU71mUxI=;
        b=ASwdiNISwi39e3pN7oE2KNZFMmRKqmr3VYiit4wIyv47H88t6EbCKRpQMvgIGjb8Ee
         rJVPUEvW73NAo8aFV+BbV0Vr3OSkq29yA95vS5SMRxjzWXbnV3DZI/1DBZWOB8qdIrDl
         W6zsADUJr9yTIozq12aJEIz0+DdiTk+hebpQwi9Spbwq0O7+Rp/AhyZ8kHc6W7GbLEQQ
         W0hWYQM1VKgOje1FPxZ4mA6ztD8KMzpQNn+h5VJfv3SoW4uFDeXDtliLmzD104DdQ5jS
         RPnONZy1sj8iUseTf5J8a4CjaI/8JgGCw7ZrAZK92Qp419zeHoy00JFMymW+m0ow9uJP
         AA4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SSdGxEhCr0RqVU7mTEekOKbILUbkr12FLBfwU71mUxI=;
        b=Grqd/gvPaBZnt+aD7U2HmHxRu8itdk8iqdanshrBLTWvXigjco+jwtVw9O1WaHtl6N
         HWNZ0rNhKuqG/+18Ui+2d8gvs4s27A2CLoW3eXTCesM5ST/zvgnxF4gg6uk8mgjeuaTB
         CjE2eNx2oAVn5i/jc3Iew0ftcmQCUlw9XiEUZDlvqj7bqaaLSwJMb9fyjoB8PRVHl17e
         Xwbbt5jLc9kkcRYSmgEl5OCf5BLDtABGFjiaaGGU5YRxbve3ybvM4FmjjK4mtmzR72Aa
         Wq48N16S5EW+gI8hf8KcGf/c5KbE5OOjl7O7q63XHxVTsvmUH8EUxccSBPVbBLhdAyNr
         ZqjQ==
X-Gm-Message-State: ANoB5pn5KJmbDMsT13DpNmOlsfjGeQ/KeLLdq2EyxXhUrOJBt5OlcMvG
        eshGPwp0TOTQ0gyASzE9EJS2kPbDpcwAtg==
X-Google-Smtp-Source: AA0mqf47fCCsz8lLNEesw2/yjinjmb5c0Q+BVTcOByCxMnOsH1R3SmOt/A4xjy4bk2xWJgLDn+u8z1uj6TTwRA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a81:9943:0:b0:3b6:79b0:c10e with SMTP id
 q64-20020a819943000000b003b679b0c10emr62215766ywg.87.1670528360357; Thu, 08
 Dec 2022 11:39:20 -0800 (PST)
Date:   Thu,  8 Dec 2022 11:38:28 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-9-dmatlack@google.com>
Subject: [RFC PATCH 08/37] KVM: selftests: Stop assuming stats are contiguous
 in kvm_binary_stats_test
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Matlack <dmatlack@google.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Nadav Amit <namit@vmware.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Peter Xu <peterx@redhat.com>, xu xin <cgel.zte@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Yu Zhao <yuzhao@google.com>,
        Colin Cross <ccross@google.com>,
        Hugh Dickins <hughd@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org
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

From: Jing Zhang <jingzhangos@google.com>

Remove the assumption from kvm_binary_stats_test that all stats are
laid out contiguously in memory. The KVM stats ABI specifically allows
holes in the stats data, since each stat exposes its own offset.

While here drop the check that each stats' offset is less than
size_data, as that is now always true by construction.

Fixes: 0b45d58738cd ("KVM: selftests: Add selftest for KVM statistics data binary interface")
Signed-off-by: Jing Zhang <jingzhangos@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
[Re-worded the commit message.]

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/kvm_binary_stats_test.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
index 894417c96f70..46a66ece29fd 100644
--- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
+++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
@@ -134,7 +134,8 @@ static void stats_test(int stats_fd)
 				    "Bucket size of stats (%s) is not zero",
 				    pdesc->name);
 		}
-		size_data += pdesc->size * sizeof(*stats_data);
+		size_data = max(size_data,
+			pdesc->offset + pdesc->size * sizeof(*stats_data));
 	}
 
 	/*
@@ -149,14 +150,6 @@ static void stats_test(int stats_fd)
 	TEST_ASSERT(size_data >= header.num_desc * sizeof(*stats_data),
 		    "Data size is not correct");
 
-	/* Check stats offset */
-	for (i = 0; i < header.num_desc; ++i) {
-		pdesc = get_stats_descriptor(stats_desc, i, &header);
-		TEST_ASSERT(pdesc->offset < size_data,
-			    "Invalid offset (%u) for stats: %s",
-			    pdesc->offset, pdesc->name);
-	}
-
 	/* Allocate memory for stats data */
 	stats_data = malloc(size_data);
 	TEST_ASSERT(stats_data, "Allocate memory for stats data");
-- 
2.39.0.rc1.256.g54fd8350bd-goog

