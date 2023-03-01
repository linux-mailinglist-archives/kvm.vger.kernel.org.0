Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 822426A6762
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 06:35:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbjCAFe6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 00:34:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbjCAFey (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 00:34:54 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64FB12F798
        for <kvm@vger.kernel.org>; Tue, 28 Feb 2023 21:34:51 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-536cb268ab8so262252477b3.17
        for <kvm@vger.kernel.org>; Tue, 28 Feb 2023 21:34:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677648891;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=G6nYnlLcyTdm/uK9hS3nWn446jGSSKDzz3oHNJyIs+4=;
        b=GuaHvVT7hudoJW9T/k6YDhaYWiJvN8iYDPbn+qtjn1BoL4DCIumoJ3fTwgkQ41hX3E
         pr9Fzd3oiQwNYrxYXEzvZzVkp6v1uyrLHsb9cGf+jFq2ffytcftqCyjT1VtaFczkd0Vs
         hyWxPzAVYQZDgqgUK4vqQGFqKmbblQjL8h+TEBbPK8ME21kH8RU3vQQhkYCUVW+LI+gj
         R6RFNODF3tCm4D3FBM3V9Bs+HfiBE5xS9xYNSevatpwz3YHbWEaCN4MuWYbRRUDq9ifT
         5E9jUi9LMBKgMXa4wqWibEZA1dMJh2vvIiIZgwCpry36hcR/wyrnqFYkkt+Lax4FRbBb
         W9+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677648891;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G6nYnlLcyTdm/uK9hS3nWn446jGSSKDzz3oHNJyIs+4=;
        b=qg5fUsNGZ7D78Wz60evlMJBGBHcSWD6UF3NsJ2TFvy0pDSOFp1hgOko8Dq/88YH5wy
         uGIS1QULiyspEku9sLKIc7ih7ssxhqCRvTOTCYnBmeLDFznExTGPIGecQoBOnqKWiFwo
         Hjz1WZ0FPuR1IIQjc2qPmHhGiywAvIBaCiAUDzqltAL18rqqgYAGmOnPKxg4PBpXEhd0
         JqRWhp24hoabg0uhse1dL0qPtTf2kxkq77YR7ZLEIoKu11puoY9UPoGtR6Q03wVQQ9UQ
         aUdY2izGooDX+nROV1tBxUfmzrr2eIBkYMCDB0+AH+5Rimef3G6Pkbm0msyrArgn5Z79
         ZDKQ==
X-Gm-Message-State: AO0yUKX9b5LxrrmKDH0YjLCd3iVverpRyF+JjNqLSqYxLNjyFVNBDgk3
        XPVEHP9+OOVyOM7cbAKaYhcVWS3rcZtzVEY8ibtroX/Tz0ljBiKcRQTtQE1LMm8ZdfnO/9I5ixR
        CKDEZnzS4vmDbuZX6/pZa8xgz+9s5716Q6bWef0xhhj/6e63KpL4ZEFkuUT+ZafbbAQOl
X-Google-Smtp-Source: AK7set+h6Q/ib4KSfkPzjNAv8OUxL38UbyTZL3GyNaWAFpoGDr4HR+66N/VrLfsBsGUzYVjMl21dPVGdY4gVG7Dq
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:519c])
 (user=aaronlewis job=sendgmr) by 2002:a05:6902:118c:b0:a06:538f:265f with
 SMTP id m12-20020a056902118c00b00a06538f265fmr12652719ybu.4.1677648891058;
 Tue, 28 Feb 2023 21:34:51 -0800 (PST)
Date:   Wed,  1 Mar 2023 05:34:24 +0000
In-Reply-To: <20230301053425.3880773-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230301053425.3880773-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230301053425.3880773-8-aaronlewis@google.com>
Subject: [PATCH 7/8] KVM: selftests: Add string formatting options to ucall
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
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

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 .../selftests/kvm/include/ucall_common.h      | 19 +++++++++++++++++++
 .../testing/selftests/kvm/lib/ucall_common.c  | 19 +++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
index 0b1fde23729b..2a4400b6761a 100644
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
 int ucall_header_size(void);
@@ -47,6 +51,7 @@ int ucall_header_size(void);
 #define GUEST_SYNC_ARGS(stage, arg1, arg2, arg3, arg4)	\
 				ucall(UCALL_SYNC, 6, "hello", stage, arg1, arg2, arg3, arg4)
 #define GUEST_SYNC(stage)	ucall(UCALL_SYNC, 2, "hello", stage)
+#define GUEST_PRINTF(fmt, _args...) ucall_fmt(UCALL_PRINTF, fmt, ##_args)
 #define GUEST_DONE()		ucall(UCALL_DONE, 0)
 
 enum guest_assert_builtin_args {
@@ -56,6 +61,18 @@ enum guest_assert_builtin_args {
 	GUEST_ASSERT_BUILTIN_NARGS
 };
 
+#define __GUEST_ASSERT_FMT(_condition, _condstr, format, _args...)	\
+do {									\
+	if (!(_condition))						\
+		ucall_fmt(UCALL_ABORT,					\
+		          "Failed guest assert: " _condstr		\
+		          " at %s:%ld\n  " format, 			\
+			  __FILE__, __LINE__, ##_args);			\
+} while (0)
+
+#define GUEST_ASSERT_FMT(_condition, format, _args...)	\
+	__GUEST_ASSERT_FMT(_condition, #_condition, format, ##_args)
+
 #define __GUEST_ASSERT(_condition, _condstr, _nargs, _args...)		\
 do {									\
 	if (!(_condition))						\
@@ -81,6 +98,8 @@ do {									\
 
 #define GUEST_ASSERT_EQ(a, b) __GUEST_ASSERT((a) == (b), #a " == " #b, 2, a, b)
 
+#define REPORT_GUEST_ASSERT_FMT(_ucall) TEST_FAIL("%s", _ucall.buffer)
+
 #define __REPORT_GUEST_ASSERT(_ucall, fmt, _args...)			\
 	TEST_FAIL("%s at %s:%ld\n" fmt,					\
 		  (const char *)(_ucall).args[GUEST_ERROR_STRING],	\
diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
index b6a75858fe0d..92ebc5db1c41 100644
--- a/tools/testing/selftests/kvm/lib/ucall_common.c
+++ b/tools/testing/selftests/kvm/lib/ucall_common.c
@@ -54,7 +54,9 @@ static struct ucall *ucall_alloc(void)
 	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
 		if (!test_and_set_bit(i, ucall_pool->in_use)) {
 			uc = &ucall_pool->ucalls[i];
+			uc->cmd = UCALL_NONE;
 			memset(uc->args, 0, sizeof(uc->args));
+			memset(uc->buffer, 0, sizeof(uc->buffer));
 			return uc;
 		}
 	}
@@ -75,6 +77,23 @@ static void ucall_free(struct ucall *uc)
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
+	vsprintf(uc->buffer, fmt, va);
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
2.40.0.rc0.216.gc4246ad0f0-goog

