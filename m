Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D20D6ED83E
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 00:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232384AbjDXW7J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 18:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232614AbjDXW7H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 18:59:07 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E17D27AA3
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 15:59:05 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1a6ee59714aso32363405ad.0
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 15:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682377145; x=1684969145;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7pGoz+Bqh9o5ewll2j0pCufns/tQJxlKIWLlecHHcHQ=;
        b=FN03f9IGQjmYwOkFRkjbK4Q1TQXK7uOPGXHHJNGacGJ9RORpedCQtMxDS7paEZDUlR
         CE52/h4hpeVBh8R4dLSjiU40rVd7WnNjy3JpS3TsH2yV6lu8akDxXvAf0nf9XsenjCzd
         jJlYxCdnSqFITGOF3uL1ZsqyXuHHwl8vJjtl3R77+CZUlalViYlv7xLkN6WD0iyl6Q0s
         UOJFkWjRRTDiSERbcfC5XVjBVAba626vYVpT80lYaTY9ppAKtlpZcOLMDwYbRy1PTHg6
         689OUy9ojWZBWFSMdIHimZ6EVJgVUCQmSvDSPFk3Pl3M8Rlf40ZOWWUpU5uLRNNBgliZ
         vRHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682377145; x=1684969145;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7pGoz+Bqh9o5ewll2j0pCufns/tQJxlKIWLlecHHcHQ=;
        b=I8K04GmTB1D6YOBGyaI5cz0lgVFyTF10cGbfjSi3y62FyqQrKwL4Ywo/FsMRf8dkf5
         a8slfvok+Cjbu3UoN2H93W2OyUbVoOj7QNgwlp8SbMBRk3uFkjeoXSbG55QgH12X04Ru
         9ctR57EQTlZOxUxMi2N5O2z78sZS1yPuNtzcYMW40FKUoWaFvIaAs+ee9iz/PrSUziWh
         T8J1U5YawGAX/YjMCGmXB23Dbj90V64TW6HM38PMhaGeOBQSG7KnQdjqQNlazpECjJOP
         zFYftTdQQsVIeph9+HOse2Bdoxkx+YHzT73o2RC4fxm5ifzIN8DNKAGybCYqoCBkb873
         QDGg==
X-Gm-Message-State: AAQBX9e/AJVuLmGvsdAazi7kVhot7S/0XK3DsH3CEyxmFvjWI/GaJfdC
        VU+8VSSGM9/8ci4t8F8MuKqI0WFLrRzjvvyB+O3Qr2Q4dTnyS7gfZ1g9dw8RINWJzk727087BzJ
        Tc4G5Gtn+MRX0BRN+VS+48FP+giplNZk2rxoGwLTvVIYutlxRVp61uKnzr7kmOehKOxhq
X-Google-Smtp-Source: AKy350b4pfh/YlMsuaW4rZYYpj+dNsTeLX7ThDimiW3q1dl4TEbtQOjEsR1jlHbRhJh4oeTWGHERtrvifYCWb9N4
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:519c])
 (user=aaronlewis job=sendgmr) by 2002:a17:902:d151:b0:1a1:e48b:98b8 with SMTP
 id t17-20020a170902d15100b001a1e48b98b8mr4387408plt.10.1682377145113; Mon, 24
 Apr 2023 15:59:05 -0700 (PDT)
Date:   Mon, 24 Apr 2023 22:58:52 +0000
In-Reply-To: <20230424225854.4023978-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230424225854.4023978-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230424225854.4023978-5-aaronlewis@google.com>
Subject: [PATCH v2 4/6] KVM: selftests: Add string formatting options to ucall
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
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

Add more flexibility to guest debugging and testing by adding
GUEST_PRINTF() and GUEST_ASSERT_FMT() to the ucall framework.

A buffer to hold the formatted string was added to the ucall struct.
That allows the guest/host to avoid the problem of passing an
arbitrary number of parameters between themselves when resolving the
string.  Instead, the string is resolved in the guest then passed
back to the host to be logged.

The formatted buffer is set to 1024 bytes which increases the size
of the ucall struct.  As a result, this will increase the number of
pages requested for the guest.

The buffer size was chosen to accommodate most use cases, and based on
similar usage.  E.g. printf() uses the same size buffer in
arch/x86/boot/printf.c.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 .../selftests/kvm/include/ucall_common.h       | 18 ++++++++++++++++++
 tools/testing/selftests/kvm/lib/ucall_common.c | 18 ++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
index bcbb362aa77f..7281a6892779 100644
--- a/tools/testing/selftests/kvm/include/ucall_common.h
+++ b/tools/testing/selftests/kvm/include/ucall_common.h
@@ -13,15 +13,18 @@ enum {
 	UCALL_NONE,
 	UCALL_SYNC,
 	UCALL_ABORT,
+	UCALL_PRINTF,
 	UCALL_DONE,
 	UCALL_UNHANDLED,
 };
 
 #define UCALL_MAX_ARGS 7
+#define UCALL_BUFFER_LEN 1024
 
 struct ucall {
 	uint64_t cmd;
 	uint64_t args[UCALL_MAX_ARGS];
+	char buffer[UCALL_BUFFER_LEN];
 
 	/* Host virtual address of this struct. */
 	struct ucall *hva;
@@ -32,6 +35,7 @@ void ucall_arch_do_ucall(vm_vaddr_t uc);
 void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu);
 
 void ucall(uint64_t cmd, int nargs, ...);
+void ucall_fmt(uint64_t cmd, const char *fmt, ...);
 uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
 void ucall_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa);
 int ucall_nr_pages_required(uint64_t page_size);
@@ -47,6 +51,7 @@ int ucall_nr_pages_required(uint64_t page_size);
 #define GUEST_SYNC_ARGS(stage, arg1, arg2, arg3, arg4)	\
 				ucall(UCALL_SYNC, 6, "hello", stage, arg1, arg2, arg3, arg4)
 #define GUEST_SYNC(stage)	ucall(UCALL_SYNC, 2, "hello", stage)
+#define GUEST_PRINTF(_fmt, _args...) ucall_fmt(UCALL_PRINTF, _fmt, ##_args)
 #define GUEST_DONE()		ucall(UCALL_DONE, 0)
 
 enum guest_assert_builtin_args {
@@ -56,6 +61,17 @@ enum guest_assert_builtin_args {
 	GUEST_ASSERT_BUILTIN_NARGS
 };
 
+#define __GUEST_ASSERT_FMT(_condition, _condstr, _fmt, _args...)		  \
+do {										  \
+	if (!(_condition))							  \
+		ucall_fmt(UCALL_ABORT,						  \
+			  "Failed guest assert: " _condstr " at %s:%ld\n  " _fmt, \
+			  , __FILE__, __LINE__, ##_args);			  \
+} while (0)
+
+#define GUEST_ASSERT_FMT(_condition, _fmt, _args...)	\
+	__GUEST_ASSERT_FMT(_condition, #_condition, _fmt, ##_args)
+
 #define __GUEST_ASSERT(_condition, _condstr, _nargs, _args...)		\
 do {									\
 	if (!(_condition))						\
@@ -81,6 +97,8 @@ do {									\
 
 #define GUEST_ASSERT_EQ(a, b) __GUEST_ASSERT((a) == (b), #a " == " #b, 2, a, b)
 
+#define REPORT_GUEST_ASSERT_FMT(_ucall) TEST_FAIL("%s", _ucall.buffer)
+
 #define __REPORT_GUEST_ASSERT(_ucall, fmt, _args...)			\
 	TEST_FAIL("%s at %s:%ld\n" fmt,					\
 		  (const char *)(_ucall).args[GUEST_ERROR_STRING],	\
diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
index 77ada362273d..c09e57c8ef77 100644
--- a/tools/testing/selftests/kvm/lib/ucall_common.c
+++ b/tools/testing/selftests/kvm/lib/ucall_common.c
@@ -55,6 +55,7 @@ static struct ucall *ucall_alloc(void)
 		if (!test_and_set_bit(i, ucall_pool->in_use)) {
 			uc = &ucall_pool->ucalls[i];
 			memset(uc->args, 0, sizeof(uc->args));
+			memset(uc->buffer, 0, sizeof(uc->buffer));
 			return uc;
 		}
 	}
@@ -75,6 +76,23 @@ static void ucall_free(struct ucall *uc)
 	clear_bit(uc - ucall_pool->ucalls, ucall_pool->in_use);
 }
 
+void ucall_fmt(uint64_t cmd, const char *fmt, ...)
+{
+	struct ucall *uc;
+	va_list va;
+
+	uc = ucall_alloc();
+	uc->cmd = cmd;
+
+	va_start(va, fmt);
+	kvm_vsnprintf(uc->buffer, UCALL_BUFFER_LEN, fmt, va);
+	va_end(va);
+
+	ucall_arch_do_ucall((vm_vaddr_t)uc->hva);
+
+	ucall_free(uc);
+}
+
 void ucall(uint64_t cmd, int nargs, ...)
 {
 	struct ucall *uc;
-- 
2.40.0.634.g4ca3ef3211-goog

