Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A35C496278
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 16:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381725AbiAUP7I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 10:59:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350816AbiAUP7H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jan 2022 10:59:07 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CAB6C06173B
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 07:59:07 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id p7-20020a1709026b8700b0014a8d8fbf6fso1704937plk.23
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 07:59:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=OSc06xfKYUAuvW5ciiOedpL/kcEug72EnhuZ2g11vE4=;
        b=dzXKKZ19dnDIF5EhZCsiEvW+w2TAi3Qnub1rV0jyVX8FAXZD5mxzwsKOn+wm6f9xhF
         JXeGzMyVkzz1DTCS5sJIRDwuROBhvgCWroBG4YoFxNn7pcTxFtgsrdcmnTDoHv7+hxt0
         XZg4w427lfDGbLQ4FZhzJDTVfP00AeV3/iclv5CVu1k3sIWveBlnXPF65lhHuFZ52YKz
         nmehgfAjy9indgffnXDm/4MnlsNIl5lo2as25pPuqh2E+MpU9szc4jLvJHigLbH1OjJf
         dm7lLKNHaU84YDlNhOK/tPJSlBPMFx6G1dnL6LDe/w82a8zWBaeapjgALWVuKBsbWTJe
         1eNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=OSc06xfKYUAuvW5ciiOedpL/kcEug72EnhuZ2g11vE4=;
        b=Tx1hEdqu4zkbE9JGHh74lJknRh1IwhQCsOhUD+lF+vOCgxJD4a9NwBCF4V+Bl4K39a
         piY67mI4KiR+4kiMNlF5UqHglsK4YwBN4slQmDcONa8C92Zmpkb2MPaQ+PFdQSQtiSQN
         x7JZBnxdBNV26d4nlcwmTKxx444wVxL2xDQh0/1WxPQJIKiCcUpOapPR7ky8wiKgqEEA
         Wr/tFnU6eXVQNjOKiSJjgn1Mc4C7947LR1J4qT0+C0Yixxryf4ZODk+WghY5u56XwSuU
         2JgO6M07CBnqzTpW3r8WZ7meyXK/neSTBaSjcok+1ssQHw+olWiVWBfp2o5k912Kx0kR
         PH+w==
X-Gm-Message-State: AOAM531SOkxzC3zV8obm9zk+WnlIcw0kpFickxQxk2ifa6Q+lEk/aBMv
        jmu7egNOJ0HuI4rm05huw2UwPnPf6Ii8kN8tbRny0gy5VurQG+afxBx5rozS26Lo/PY7FO9Qojq
        mIohQ+1V8gGTLyux/aECEsxfj+NC6/L8l/qWRLJQmuOHEXzOnrxZc76MAFxYo2POJMGxD
X-Google-Smtp-Source: ABdhPJztK1kLgxC283f6p6V3YtiiwBIyh5BEfKy3ApQx23vaJek6n9BHHKRpoxWSHHWejPjchhpiU6iorbAw4Yig
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:903:41cf:b0:14b:5b0:484b with SMTP
 id u15-20020a17090341cf00b0014b05b0484bmr4633550ple.155.1642780746495; Fri,
 21 Jan 2022 07:59:06 -0800 (PST)
Date:   Fri, 21 Jan 2022 15:58:53 +0000
In-Reply-To: <20220121155855.213852-1-aaronlewis@google.com>
Message-Id: <20220121155855.213852-2-aaronlewis@google.com>
Mime-Version: 1.0
References: <20220121155855.213852-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [kvm-unit-tests PATCH v4 1/3] x86: Make exception_mnemonic() visible
 to the tests
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

exception_mnemonic() is a useful function for more than just desc.c.
Make it global, so it can be used in other KUT tests.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 lib/x86/desc.c | 2 +-
 lib/x86/desc.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index 16b7256..c2eb16e 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -91,7 +91,7 @@ struct ex_record {
 
 extern struct ex_record exception_table_start, exception_table_end;
 
-static const char* exception_mnemonic(int vector)
+const char* exception_mnemonic(int vector)
 {
 	switch(vector) {
 	case 0: return "#DE";
diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index 9b81da0..ad6277b 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -224,6 +224,7 @@ void set_intr_alt_stack(int e, void *fn);
 void print_current_tss_info(void);
 handler handle_exception(u8 v, handler fn);
 void unhandled_exception(struct ex_regs *regs, bool cpu);
+const char* exception_mnemonic(int vector);
 
 bool test_for_exception(unsigned int ex, void (*trigger_func)(void *data),
 			void *data);
-- 
2.35.0.rc0.227.g00780c9af4-goog

