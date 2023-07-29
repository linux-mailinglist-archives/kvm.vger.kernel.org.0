Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F246C7679B6
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 02:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236353AbjG2Aht (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 20:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235836AbjG2AhS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 20:37:18 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E04B046BE
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:37:00 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1bba5626342so24247885ad.2
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591019; x=1691195819;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ELXU1ozQzdRVu6Pw/o2mcwSfwjzxGjCFC9TkVEz9ZVQ=;
        b=JXtcg+1ByHrhsMnwuvWSktPaXMMguvcz07wHpELDSVv6jhZ3yrEl0JvsbHqBi5Lg2x
         OmX5Eimu/ODFnq3VaAjn8vXO1K17rz8y6EpesxllWzQRPUfsavJkfM4At0ImL4pderV8
         fvgM9Bge1BI96MVbtQDXU+64v48qE3nq1HyrYE9zFRgPRHo+Wg2XKMo2Sc5iGJCqFUhY
         FPfQU4uIVpdGn2QFHpgCsDRaEnqFriANA72+NhczhR8B6xGQYtfwAurIWtQuSJ8qMWVA
         Ml4BO52nX87ezdWgvfx/qbYHGyhUaBoVsxUYpnpeEXRxWOxYM7y18KJ85RhTqqTsk3lN
         JNRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591019; x=1691195819;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ELXU1ozQzdRVu6Pw/o2mcwSfwjzxGjCFC9TkVEz9ZVQ=;
        b=XNm0RNCxsTfrNvsQ6SJvlof75+vS/6LKVpH7W+ru+DO0Ki6MG0apMR/A61NFIaEwGF
         CB4PDnAhcf73aiCVUu92ky98o3BDTQPKywGyw+cQzuqppZ6fERtVD5quSFAGWKBKRB0h
         VuDB5C3LwbfSnzo58hl9Nk+23Ff8YiskIVZP5dIGsNy2jts45d0KKNKyXt2JfTPNcxNj
         Ccz2Slygiii/NBRuwH4EiyVLdOWMK/YZSJu0pPM+uOZKZtMIfPcBUtXf2gVCIUBmYmUg
         di5q4Ixiy8+IYtGVJX2+LIw2k0O/+FAR2pZwXrNyS+9TztwwQW2melq1CbTX1tJTObgk
         Hjhg==
X-Gm-Message-State: ABy/qLZqMrz8JeCVLctqaJT6SN/duPZPueBEYx+KyhgTf/PvWtNbDP2Q
        mpmrkscJqT5XNOzENvHOG7+sy5Gkg1M=
X-Google-Smtp-Source: APBJJlFaQWpQ9EmvDFhoqjrlvd9ghhe4hfSspLAxYVt7vmgNKcaTBWdjzzZ7FvjaiMwdSLF+VQ/4xTSUS1M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:fa0d:b0:1bb:a13a:c21e with SMTP id
 la13-20020a170902fa0d00b001bba13ac21emr11796plb.10.1690591019608; Fri, 28 Jul
 2023 17:36:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 17:36:16 -0700
In-Reply-To: <20230729003643.1053367-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-8-seanjc@google.com>
Subject: [PATCH v4 07/34] KVM: selftests: Add string formatting options to ucall
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Thomas Huth <thuth@redhat.com>,
        "=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>,
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

From: Aaron Lewis <aaronlewis@google.com>

Add more flexibility to guest debugging and testing by adding
GUEST_PRINTF() and GUEST_ASSERT_FMT() to the ucall framework.

Add a sized buffer to the ucall structure to hold the formatted string,
i.e. to allow the guest to easily resolve the string, and thus avoid the
ugly pattern of the host side having to make assumptions about the desired
format, as well as having to pass around a large number of parameters.

The buffer size was chosen to accommodate most use cases, and based on
similar usage.  E.g. printf() uses the same size buffer in
arch/x86/boot/printf.c.  And 1KiB ought to be enough for anybody.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
[sean: massage changelog, wrap macro param in ()]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/ucall_common.h        |  7 +++++++
 tools/testing/selftests/kvm/lib/ucall_common.c  | 17 +++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
index bcbb362aa77f..b5548aeba9f0 100644
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
@@ -47,8 +51,11 @@ int ucall_nr_pages_required(uint64_t page_size);
 #define GUEST_SYNC_ARGS(stage, arg1, arg2, arg3, arg4)	\
 				ucall(UCALL_SYNC, 6, "hello", stage, arg1, arg2, arg3, arg4)
 #define GUEST_SYNC(stage)	ucall(UCALL_SYNC, 2, "hello", stage)
+#define GUEST_PRINTF(_fmt, _args...) ucall_fmt(UCALL_PRINTF, _fmt, ##_args)
 #define GUEST_DONE()		ucall(UCALL_DONE, 0)
 
+#define REPORT_GUEST_PRINTF(ucall) pr_info("%s", (ucall).buffer)
+
 enum guest_assert_builtin_args {
 	GUEST_ERROR_STRING,
 	GUEST_FILE,
diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
index 77ada362273d..b507db91139b 100644
--- a/tools/testing/selftests/kvm/lib/ucall_common.c
+++ b/tools/testing/selftests/kvm/lib/ucall_common.c
@@ -75,6 +75,23 @@ static void ucall_free(struct ucall *uc)
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
+	guest_vsnprintf(uc->buffer, UCALL_BUFFER_LEN, fmt, va);
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
2.41.0.487.g6d72f3e995-goog

