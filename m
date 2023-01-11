Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02598665081
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 01:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235786AbjAKAph (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 19:45:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235787AbjAKApM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 19:45:12 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF6215931E
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 16:45:10 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id p14-20020a170902e74e00b00192f6d0600eso9416088plf.3
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 16:45:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PX8UiuFYQddlQ3Zi3Fq3jepSo0WH3i4y4Cc6Sow5OTs=;
        b=Oqamwob+bracVV31tO4Byc/4xcU17K6kTSgsURRNdFy6S3AkpeeNTJ/DG7GSP9MVUQ
         ssb6MDSj0icWFBiBMYdqzMtXssoHAqQWs3RwAqV5Rtv952qBfCJinSf6dqGj1nfdZcNV
         FULgkBjC44B0SMZGytGkEFkfG12F+fYfy1lxhAX8v5kM9XuBlysTo5DoVHN4ldla731c
         VMolQtxzmmx73HT8uVtey4rFUpInifgHjU9xceIx/xs1oTb1BlyqUa+MwgNe1pwDv1H8
         kk6hcG8dgNaAuNjA/P5GftP4DIwHwgTsVV2t/gsrD9LR4YAUvsXHUa0LaJlaH6eIHdAn
         gxgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PX8UiuFYQddlQ3Zi3Fq3jepSo0WH3i4y4Cc6Sow5OTs=;
        b=kDqwIUkpwOgsCc0UkwZSImPzHHQ0kcpWUbj3MZudOoWjXFAkhSWeafNTnprMrraHmm
         7HmubQoor8tGNLQ1xwFAL32USAyH4KrtWquPTYMzstHlmPrlsRt22atink4e0s3XAppr
         aM4YCz+MyANadf7oevjDYlBMC97MrClb8kPKAqP7zPY3Rnd2KeAmoMdIVAPExolV6J0o
         13FMvGs5WCGjGR6xAjxR8oEUEWZbgC/wSE69cekbq1xVVRGGP41Odu/CDZMr9tay0h1b
         NrTtL224aqjngxhsoU53ri1jy1nxBHycAeNpzgoBkWIKGMGSkGWtGuy1MkxRPowt02As
         vFLA==
X-Gm-Message-State: AFqh2kq6TGDGrk3gRgd04uKS77nNyDYtK8PZ1DuzdLNhmYlRy9SuMm8s
        5Se1ihZqAHCOfQsp93uaTUcVCh+YROy/Hda5
X-Google-Smtp-Source: AMrXdXuUm1Tc46Pwdhv3IFsz2ym7S+82krRj3N/z3c4mUDRf+qRR2j8Pm7YIgx+dwLGQxStbWRwdu34aZVC7s8j1
X-Received: from vannapurve2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:41f8])
 (user=vannapurve job=sendgmr) by 2002:a17:90a:aa12:b0:226:a257:8dca with SMTP
 id k18-20020a17090aaa1200b00226a2578dcamr2374775pjq.55.1673397910474; Tue, 10
 Jan 2023 16:45:10 -0800 (PST)
Date:   Wed, 11 Jan 2023 00:44:45 +0000
In-Reply-To: <20230111004445.416840-1-vannapurve@google.com>
Mime-Version: 1.0
References: <20230111004445.416840-1-vannapurve@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230111004445.416840-4-vannapurve@google.com>
Subject: [V5 PATCH 3/3] KVM: selftests: x86: Use host's native hypercall
 instruction in kvm_hypercall()
From:   Vishal Annapurve <vannapurve@google.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     pbonzini@redhat.com, shuah@kernel.org, bgardon@google.com,
        seanjc@google.com, oupton@google.com, peterx@redhat.com,
        vkuznets@redhat.com, dmatlack@google.com, pgonda@google.com,
        andrew.jones@linux.dev, Vishal Annapurve <vannapurve@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the host CPU's native hypercall instruction, i.e. VMCALL vs. VMMCALL,
in kvm_hypercall(), as relying on KVM to patch in the native hypercall on
a #UD for the "wrong" hypercall requires KVM_X86_QUIRK_FIX_HYPERCALL_INSN
to be enabled and flat out doesn't work if guest memory is encrypted with
a private key, e.g. for SEV VMs.

Suggested-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Vishal Annapurve <vannapurve@google.com>
---
 tools/testing/selftests/kvm/lib/x86_64/processor.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 84915bc7d689..ae1e573d94ce 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1144,9 +1144,15 @@ uint64_t kvm_hypercall(uint64_t nr, uint64_t a0, uint64_t a1, uint64_t a2,
 {
 	uint64_t r;
 
-	asm volatile("vmcall"
+	asm volatile("test %[use_vmmcall], %[use_vmmcall]\n\t"
+		     "jnz 1f\n\t"
+		     "vmcall\n\t"
+		     "jmp 2f\n\t"
+		     "1: vmmcall\n\t"
+		     "2:"
 		     : "=a"(r)
-		     : "a"(nr), "b"(a0), "c"(a1), "d"(a2), "S"(a3));
+		     : "a"(nr), "b"(a0), "c"(a1), "d"(a2), "S"(a3),
+		       [use_vmmcall] "r" (host_cpu_is_amd));
 	return r;
 }
 
-- 
2.39.0.314.g84b9a713c41-goog

