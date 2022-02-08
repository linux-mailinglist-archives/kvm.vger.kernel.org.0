Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6B484ACCF4
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 02:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238241AbiBHBFO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 20:05:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344101AbiBHAlc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 19:41:32 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06749C0612A4
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 16:41:31 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id e28so15964910pfj.5
        for <kvm@vger.kernel.org>; Mon, 07 Feb 2022 16:41:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tnW+AMT0bzmJt9s/qVFSN3WYeENH2dyykBrGoab/BrM=;
        b=o9dyHhiSKKS1oD48nFCm6E5qNlZ7J7/EoAyK9sbp16tYtQOjrwF0XCFkihCikwViiW
         WI0+wyey2Lg5ukHD6jb2gyoRFm5fBevFZJYZHnFiy0Y9bO0AGpb+krQkpmW962nd3PQ3
         dx57tGM137LsMgNMEQP7iUeUQPuyDGkbsvvOTcBvFeGCnJbHGB1FEFjiV7aks1L00TCS
         IdXY9jrjzmZOT2MkJDnEDuGFJcVbtRHUogNJZV1aB9fkTBtgWp3GhFGUTqPhw1CVJR3R
         8bMvcHptBPpbDE0fy533/yC9fSShi49kxPxIFTXby8mJ0uOx6OGIddk6UGKhHnx+zP50
         e25Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tnW+AMT0bzmJt9s/qVFSN3WYeENH2dyykBrGoab/BrM=;
        b=zyP0zaw/Oq15YPtfLGJfOPbA3d/Jsq7wHbOF4UAcJj5DCI1oqPiK5o8MgWqe3G+VaW
         2mp4CF5HTHGlYiVC8aXsQlloGb75RKN4K2AODXXwaE67siIuPsf4e2IXKQdVZBMHt5Sg
         QxjqjmrAq5exEVnHXcFIr+qmW1GH8k9Rp8B5nTAqG7k3biPPkoKEJbi9jKt7BiPSPfYB
         VocfDEf9e8h74jtYQ3YyG5k1ZS7UeA4SuYuN6/Q1UehQbu8ke2NCezzBhLYrvgLnbG9P
         dTeWt7PiQlYWeUq/BwZYA2E2ppSnQdUJkDyqhjvylAymSE+moEhlRz7FyjQvPj/P0+1l
         VnoQ==
X-Gm-Message-State: AOAM532Z1Uz6FAwEypsQt+xkLlhmtt3qqlmCNp/9g0thOaS9ueeXDPpo
        VABm8D6XFTHPfDDnq60xSmHJVA==
X-Google-Smtp-Source: ABdhPJyXwpSFwRk5+HqDL0kuIPNcLN8f838l8FWl7PO8Fk1ddjxhboaJnB02Lx8r6hmtEazU5nPSsA==
X-Received: by 2002:a63:8b42:: with SMTP id j63mr1523035pge.551.1644280891124;
        Mon, 07 Feb 2022 16:41:31 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h10sm13604853pfc.103.2022.02.07.16.41.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 16:41:30 -0800 (PST)
Date:   Tue, 8 Feb 2022 00:41:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 0/5] kvm: x86: better handling of NULL-able kvm_x86_ops
Message-ID: <YgG8NoP1FaVLcj0C@google.com>
References: <20220202181813.1103496-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220202181813.1103496-1-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 02, 2022, Paolo Bonzini wrote:
> This series is really two changes:
> 
> - patch 1 to 4 clean up NULLable kvm_x86_ops so that they are marked
>   in kvm-x86-ops.h and the non-NULLable ones WARN if used incorrectly.
>   As an additional outcome of the review, a few more uses of
>   static_call_cond are introduced.
> 
> - patch 5 allows to NULL a few kvm_x86_ops that return a value, by
>   using __static_call_ret0.
> 
> Paolo Bonzini (5):
>   KVM: x86: use static_call_cond for optional callbacks
>   KVM: x86: mark NULL-able kvm_x86_ops
>   KVM: x86: warn on incorrectly NULL static calls
>   KVM: x86: change hwapic_{irr,isr}_update to NULLable calls
>   KVM: x86: allow defining return-0 static calls

I belatedly remembered the other thing about "NULL" that I don't like:

        #define KVM_X86_OP(func)                                             \
                DEFINE_STATIC_CALL_NULL(kvm_x86_##func,                      \
                                        *(((struct kvm_x86_ops *)0)->func));
        #define KVM_X86_OP_NULL KVM_X86_OP

That's bound to be confusing for folks that aren't already familiar with the
code, especially if they don't have a good handle on static_call() magic.

Side topic, the above doesn't handle KVM_X86_OP_RET0, no idea how that doesn't
fail at link time.  The BUILD_BUG_ON(1) in kvm-x86-ops.h also needs to be updated,
and the comment too.

Anyways, back to NULL.  KVM_X86_OP_RET0 also doesn't capture that the hook can
be NULL in that case; if the reader is familiar with static_call() then they'll
understand the full meaning, but I doubt that covers the majority of readers.

TL;DR: what about using more verbose names KVM_X86_OP_OPTIONAL and
KVM_X86_OP_OPTIONAL_RET0[*]?  And also tweak kvm_ops_static_call_update()'s
defines so that KVM_X86_OP never routes through KVM_X86_OP_OPTIONAL (as syntactic
sugar to avoid confusion.

Other than that, I like the WARN on KVM_X86_OPS with a NULL implementation.

[*] The OP_OPTIONAL kills me, but I can't think of a better alternative.


E.g. sans the kvm-x86-ops.h changes...

---
 arch/x86/include/asm/kvm_host.h | 11 ++++++-----
 arch/x86/kvm/x86.c              | 11 +++++++++--
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e7e5bd9a984d..055b3a2419f7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1539,17 +1539,18 @@ extern struct kvm_x86_ops kvm_x86_ops;

 #define KVM_X86_OP(func) \
 	DECLARE_STATIC_CALL(kvm_x86_##func, *(((struct kvm_x86_ops *)0)->func));
-#define KVM_X86_OP_NULL KVM_X86_OP
-#define KVM_X86_OP_RET0 KVM_X86_OP
+#define KVM_X86_OP_OPTIONAL KVM_X86_OP
+#define KVM_X86_OP_OPTIONAL_RET0 KVM_X86_OP
 #include <asm/kvm-x86-ops.h>

 static inline void kvm_ops_static_call_update(void)
 {
-#define KVM_X86_OP_NULL(func) \
+#define __KVM_X86_OP(func) \
 	static_call_update(kvm_x86_##func, kvm_x86_ops.func);
 #define KVM_X86_OP(func) \
-	WARN_ON(!kvm_x86_ops.func); KVM_X86_OP_NULL(func)
-#define KVM_X86_OP_RET0(func) \
+	WARN_ON(!kvm_x86_ops.func); __KVM_X86_OP(func)
+#define KVM_X86_OP_OPTIONAL __KVM_X86_OP
+#define KVM_X86_OP_OPTIONAL_RET0(func) \
 	static_call_update(kvm_x86_##func, kvm_x86_ops.func ? : \
 			   (typeof(kvm_x86_ops.func)) __static_call_return0);
 #include <asm/kvm-x86-ops.h>
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 657aa646871e..337e39dec3c4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -125,11 +125,18 @@ static void __get_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);

 struct kvm_x86_ops kvm_x86_ops __read_mostly;

+/*
+ * All ops are filled by vendor code, thus the default function is NULL for
+ * both mandatory and optional hooks.  The exception are optional RET0 hooks,
+ * which obviously default to __static_call_return0.
+ */
 #define KVM_X86_OP(func)					     \
 	DEFINE_STATIC_CALL_NULL(kvm_x86_##func,			     \
 				*(((struct kvm_x86_ops *)0)->func));
-#define KVM_X86_OP_NULL KVM_X86_OP
-#define KVM_X86_OP_RET0 KVM_X86_OP
+#define KVM_X86_OP_OPTIONAL KVM_X86_OP
+#define KVM_X86_OP_OPTIONAL_RET0(func)				     \
+	DEFINE_STATIC_CALL_RET0(kvm_x86_##func,			     \
+				*(((struct kvm_x86_ops *)0)->func));
 #include <asm/kvm-x86-ops.h>
 EXPORT_STATIC_CALL_GPL(kvm_x86_get_cs_db_l_bits);
 EXPORT_STATIC_CALL_GPL(kvm_x86_cache_reg);

base-commit: 347f6a965596211726c39eb6bc320e8375f80b52
--


