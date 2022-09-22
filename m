Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1118C5E5995
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 05:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiIVDWk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 23:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiIVDVo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 23:21:44 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDAFE915F3
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 20:19:06 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-345188a7247so67665297b3.22
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 20:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=tN5R5SopzaHGArjvbV8A2BOgjZV2vImyuFPHiE9aLpQ=;
        b=F3bSBt1mXoBPajVvYMos+K94ptUrfcP4FWvHQiN0vHTDk8pYY340hBvmInSWC0ntNX
         1EpkU+4Y4eyjAQyOrGF2iBeyaPoIgRr/G282HQH+3dF67nMELaO1MM9TWfduo7ro8XL6
         km8cY3+M9ENDKoaPVxdkOIRTCbQZ+Wm+VcIeXA4leEMRnV6xfLU5m1+CX9O6x7+ogWJR
         cnkIDbK8/WIZ8JsvyGUDn4BV/03M1eCPV7GHNwebdvyv1hJoBlcLVn3LWKxQNZ4jdLqw
         2h5O/ZOP7oKp/1ZMM/os+zpnZdnhdZdtgfua9eAH5nzktAjSjxDgjcuJKQtwaPqZ0vkB
         Vxbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=tN5R5SopzaHGArjvbV8A2BOgjZV2vImyuFPHiE9aLpQ=;
        b=Lx2oht962lxNfufCz5aYhhUkIvocnE2xrgS9hdUf4H4gZUCMo9OCZJ3dWb9wk8wgNF
         UKJy2IuvnNkExFHPt5SEmmaOf+3Y13RnsdPm15ow8qAFZwtuMoO9FwPwKIi7nsx9iknn
         v30CVu79tohHROojX4IVDBFTGK6XjMaNq0GAh4K0BzWPwaXIXKoU/LmgomHb7OVcnMKO
         Jn7O6pfaIMiOdhMze7Q2rkQlKfGOSSn0oOHznLf8l6dLpJQMUXaOpmB/ryU6lpZFDXQ+
         CQbMJXdgtvMuzS9o6bl1u4Xwm1JsEAjf4REsX+XXMLQR53Y2lJu3gfmegGIB9ZzcvXFe
         E4Yw==
X-Gm-Message-State: ACrzQf06vD/4YbBQpj4ud3e7pMi1EvQZyeEX5F/wqZG24NqeHazwqm/v
        /QbI2zs4T+iCBbcaYMk+Qq5TIaipg6qofHoZp/5oxNCTynaeRQf5z5TCpKuvWGh/3juZehFRKXQ
        s1V7aSqq0TuNHWdZZ/DBhXSYrqFAokSKpZC8WrvSDg59qlm4iAW9ppVje17BYMo0=
X-Google-Smtp-Source: AMsMyM4Mc1QJGVbsNnZ9OIYOMXXEL+AsNyytFGwL2Buust7Yvgrdi2fjgrKIfN1139XADivytE7pvuCEAICzyQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:5cd:0:b0:6ae:a4be:ab42 with SMTP id
 196-20020a2505cd000000b006aea4beab42mr1516140ybf.323.1663816746060; Wed, 21
 Sep 2022 20:19:06 -0700 (PDT)
Date:   Thu, 22 Sep 2022 03:18:47 +0000
In-Reply-To: <20220922031857.2588688-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20220922031857.2588688-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220922031857.2588688-5-ricarkol@google.com>
Subject: [PATCH v8 04/14] KVM: selftests: aarch64: Construct DEFAULT_MAIR_EL1
 using sysreg.h macros
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, seanjc@google.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatlack@google.com, axelrasmussen@google.com,
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

Define macros for memory type indexes and construct DEFAULT_MAIR_EL1
with macros from asm/sysreg.h.  The index macros can then be used when
constructing PTEs (instead of using raw numbers).

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Reviewed-by: Oliver Upton <oupton@google.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/include/aarch64/processor.h | 25 ++++++++++++++-----
 .../selftests/kvm/lib/aarch64/processor.c     |  2 +-
 2 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index df4bfac69551..c1ddca8db225 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -38,12 +38,25 @@
  * NORMAL             4     1111:1111
  * NORMAL_WT          5     1011:1011
  */
-#define DEFAULT_MAIR_EL1 ((0x00ul << (0 * 8)) | \
-			  (0x04ul << (1 * 8)) | \
-			  (0x0cul << (2 * 8)) | \
-			  (0x44ul << (3 * 8)) | \
-			  (0xfful << (4 * 8)) | \
-			  (0xbbul << (5 * 8)))
+
+/* Linux doesn't use these memory types, so let's define them. */
+#define MAIR_ATTR_DEVICE_GRE	UL(0x0c)
+#define MAIR_ATTR_NORMAL_WT	UL(0xbb)
+
+#define MT_DEVICE_nGnRnE	0
+#define MT_DEVICE_nGnRE		1
+#define MT_DEVICE_GRE		2
+#define MT_NORMAL_NC		3
+#define MT_NORMAL		4
+#define MT_NORMAL_WT		5
+
+#define DEFAULT_MAIR_EL1							\
+	(MAIR_ATTRIDX(MAIR_ATTR_DEVICE_nGnRnE, MT_DEVICE_nGnRnE) |		\
+	 MAIR_ATTRIDX(MAIR_ATTR_DEVICE_nGnRE, MT_DEVICE_nGnRE) |		\
+	 MAIR_ATTRIDX(MAIR_ATTR_DEVICE_GRE, MT_DEVICE_GRE) |			\
+	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL_NC, MT_NORMAL_NC) |			\
+	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL, MT_NORMAL) |				\
+	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL_WT, MT_NORMAL_WT))
 
 #define MPIDR_HWID_BITMASK (0xff00fffffful)
 
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 63ef3c78e55e..26f0eccff6fe 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -133,7 +133,7 @@ static void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 
 void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 {
-	uint64_t attr_idx = 4; /* NORMAL (See DEFAULT_MAIR_EL1) */
+	uint64_t attr_idx = MT_NORMAL;
 
 	_virt_pg_map(vm, vaddr, paddr, attr_idx);
 }
-- 
2.37.3.968.ga6b4b080e4-goog

