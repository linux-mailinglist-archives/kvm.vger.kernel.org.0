Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D18F51B25E
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 00:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379146AbiEDWyd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379291AbiEDWxt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:53:49 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C4A53B5B
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:50:04 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id t15-20020a17090a3b4f00b001d67e27715dso3588150pjf.0
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=X5ejK3ALymV3WJX0jLnTwZBvoVVn9CiBNagBWrKCE/c=;
        b=FQ5Y4G1jdMcxzC4YeAze9qmRTVA51vK7cwsOKwP2c+9bqfg7Y3ip3xUjqBbbqKF3U6
         hZL8jhuJsSotBGo5rOR/r9DyzkNYUIUivbyKzo9mRaYYCwEzUFhPkEQStsRVWE+AQkri
         IJQf8ib+efSe21JvQQS2CSGUCZccS7JQwyqd2qVxHkqwyvbB9PH++HnRp9x9++WTVbtk
         3DSSSSeErAN0k9X7fbrCRvlUmrnNE4NMW6uLjoFKzcOBZCSCxnvZqVCcKmp2Nf2hRr39
         TtlftgTN17otS9qlAi17mXG6OpzxE7bO7T3BP6WJxnQDyTntnss6nfqerKLgdtQFwBPO
         ghZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=X5ejK3ALymV3WJX0jLnTwZBvoVVn9CiBNagBWrKCE/c=;
        b=N0htjZeYcxKqE3wezdcFAwhxuIcfG9N/taQmyKae4IV3sJB+OdzcFJjDHNju1YWQlx
         Hi5+Buq4ikGpDvac9AsG6qKMZV8ZFxPtzA9nAm/tvbdqwzF9FgaFf6DiynCngzplYd2m
         +J7RyykFqstTTy8dKDo+ClAZuT/2dylIP4evfvzJjPav7ECWbfYQXG87inn2OvabJVsj
         41JrOZF5s3gX+jkDO+BNMK2Pz/tuNo0wXTCDjVwVPeLzyjVjUHuXClMA3/SLSk5PU9YT
         gxLF4VydnwrioD1QGIkeMU+7N72QIHffQ34Y5EO+RklnPcql5l/BN9TjEQBWUMAlisuo
         bDJw==
X-Gm-Message-State: AOAM533RqtAQQrKzTz7JO1X/C4SHSUnfCP8Edhc440HwiZn8UCVO3hWc
        tT4P2Dc5SFk+ZrxULurSwq4p+pmLc1g=
X-Google-Smtp-Source: ABdhPJwBGWVdCEp8FNBvPucswMVo2PWyvJN8pOvf7+umBXFwxnQLKA0HVK7Gr1tVT/6BlRctH96PiMxUG6M=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a62:8684:0:b0:50d:972b:d9d2 with SMTP id
 x126-20020a628684000000b0050d972bd9d2mr22697955pfd.4.1651704604041; Wed, 04
 May 2022 15:50:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:47:25 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-20-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 019/128] KVM: selftests: Make x86-64's register dump helpers static
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>,
        Sean Christopherson <seanjc@google.com>
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

Make regs_dump() and sregs_dump() static, they're only implemented by
x86 and only used internally.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/lib/kvm_util_internal.h     | 34 ------------------
 .../selftests/kvm/lib/x86_64/processor.c      | 36 ++-----------------
 2 files changed, 2 insertions(+), 68 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util_internal.h b/tools/testing/selftests/kvm/lib/kvm_util_internal.h
index 0c7c44499129..544b90df2f80 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util_internal.h
+++ b/tools/testing/selftests/kvm/lib/kvm_util_internal.h
@@ -88,40 +88,6 @@ struct vcpu *vcpu_get(struct kvm_vm *vm, uint32_t vcpuid);
  */
 void virt_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent);
 
-/*
- * Register Dump
- *
- * Input Args:
- *   stream - Output FILE stream
- *   regs   - Registers
- *   indent - Left margin indent amount
- *
- * Output Args: None
- *
- * Return: None
- *
- * Dumps the state of the registers given by @regs, to the FILE stream
- * given by @stream.
- */
-void regs_dump(FILE *stream, struct kvm_regs *regs, uint8_t indent);
-
-/*
- * System Register Dump
- *
- * Input Args:
- *   stream - Output FILE stream
- *   sregs  - System registers
- *   indent - Left margin indent amount
- *
- * Output Args: None
- *
- * Return: None
- *
- * Dumps the state of the system registers given by @sregs, to the FILE stream
- * given by @stream.
- */
-void sregs_dump(FILE *stream, struct kvm_sregs *sregs, uint8_t indent);
-
 struct userspace_mem_region *
 memslot2region(struct kvm_vm *vm, uint32_t memslot);
 
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 6113cf6bb238..93726d8cac44 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -19,8 +19,7 @@
 
 vm_vaddr_t exception_handlers;
 
-void regs_dump(FILE *stream, struct kvm_regs *regs,
-	       uint8_t indent)
+static void regs_dump(FILE *stream, struct kvm_regs *regs, uint8_t indent)
 {
 	fprintf(stream, "%*srax: 0x%.16llx rbx: 0x%.16llx "
 		"rcx: 0x%.16llx rdx: 0x%.16llx\n",
@@ -43,21 +42,6 @@ void regs_dump(FILE *stream, struct kvm_regs *regs,
 		regs->rip, regs->rflags);
 }
 
-/*
- * Segment Dump
- *
- * Input Args:
- *   stream  - Output FILE stream
- *   segment - KVM segment
- *   indent  - Left margin indent amount
- *
- * Output Args: None
- *
- * Return: None
- *
- * Dumps the state of the KVM segment given by @segment, to the FILE stream
- * given by @stream.
- */
 static void segment_dump(FILE *stream, struct kvm_segment *segment,
 			 uint8_t indent)
 {
@@ -75,21 +59,6 @@ static void segment_dump(FILE *stream, struct kvm_segment *segment,
 		segment->unusable, segment->padding);
 }
 
-/*
- * dtable Dump
- *
- * Input Args:
- *   stream - Output FILE stream
- *   dtable - KVM dtable
- *   indent - Left margin indent amount
- *
- * Output Args: None
- *
- * Return: None
- *
- * Dumps the state of the KVM dtable given by @dtable, to the FILE stream
- * given by @stream.
- */
 static void dtable_dump(FILE *stream, struct kvm_dtable *dtable,
 			uint8_t indent)
 {
@@ -99,8 +68,7 @@ static void dtable_dump(FILE *stream, struct kvm_dtable *dtable,
 		dtable->padding[0], dtable->padding[1], dtable->padding[2]);
 }
 
-void sregs_dump(FILE *stream, struct kvm_sregs *sregs,
-		uint8_t indent)
+static void sregs_dump(FILE *stream, struct kvm_sregs *sregs, uint8_t indent)
 {
 	unsigned int i;
 
-- 
2.36.0.464.gb9c8b46e94-goog

