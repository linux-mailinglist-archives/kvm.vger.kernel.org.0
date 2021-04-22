Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6E8F3677AD
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 05:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234475AbhDVDFx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 23:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234409AbhDVDFu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 23:05:50 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA00C06138B
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 20:05:13 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id s34-20020a252d620000b02904e34d3a48abso18260114ybe.13
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 20:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=VekeEJpZiPwgxPOr5FnQtqIOMax6FYTSqbn7yUKIbiU=;
        b=Rj9vJ/mioslnaY4/4JPrizEckMCfI+1CWYcBIegamHb539S/6PUMaCMFcd6Xf6GLE5
         hf0uam+1ItAayJzVIUJLgjjFV/Q5hKCfBKk44sGwWiiOPYtFMM5lsk8azcQ9AB6Z6JmB
         QvZNH670znCh0LEqMBAJcCZQtQOUi4Qxk3F69tcf1KbWUY+pbz1AexizqhsXc49clkeS
         vXRYAQNljckNLI+W0CpH9EMCljumGbNtP5mqwKkT0w9ydT1h6APgR7B8o/pP44dFnpsd
         eaaWOQa07qghmmJDUiqDcHiwsuViwdFsH0iNNeyJst0xTcuojVXD6hrep0TvoyuVL2xc
         Tw+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=VekeEJpZiPwgxPOr5FnQtqIOMax6FYTSqbn7yUKIbiU=;
        b=uY1rF78w6swOyr2zeskevTELMOs9r+NdB91EqODDI8VgPOjXevC0RLs//3h1sSUHh9
         VkQA5Tz20nYkQZQdo8mkUCJSRJM+IHQwAqFcCSxwhl8tM+8c/4I7efXYL5Xrs7/hEwmf
         ZGTc9foi+LumZoFJh79qBA9kVvJrsIUte+gC2Ap7m1NgoVE+A5A4h7ZBnK/WGpPIU8vH
         wbDeGA95TWStsE5q1s2lD16/fFRTYJHKudN/S/nJHa+iieCFWj8BfHV6v5e53pZBip+f
         7jRY4/1gpdDIlLGhvqWKLaPgY1t6c0pWz2VjP3Vik8xvyVp82KHUQmSDIsyLslrrfrGM
         yTfg==
X-Gm-Message-State: AOAM532xy2+2iahKUDNirPr3/mvcU5+CNPVi0cZY04/K084Ecd0mMYQj
        BAbBQI4Z1PkxWO4IJuAx3GOl+UBVBhc=
X-Google-Smtp-Source: ABdhPJy57mAFQkl8U/EMjPJUT8aH/Vc9J0YUUo9k2QLbPYWa1OQfQKDlszVc4lWFm1l+vv7dwLDp1AWmaCM=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e012:374c:592:6194])
 (user=seanjc job=sendgmr) by 2002:a25:74c6:: with SMTP id p189mr1547430ybc.251.1619060713094;
 Wed, 21 Apr 2021 20:05:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 21 Apr 2021 20:04:52 -0700
In-Reply-To: <20210422030504.3488253-1-seanjc@google.com>
Message-Id: <20210422030504.3488253-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210422030504.3488253-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [kvm-unit-tests PATCH 02/14] x86: msr: Exclude GS/FS_BASE MSRs from
 32-bit builds
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't test GS/FS_BASE and KERNEL_GS_BASE on 32-bit builds, the MSRs are
64-bit only and should #GP when accessed on 32-bit vCPUs.

Fixes: 7d36db3 ("Initial commit from qemu-kvm.git kvm/test/")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/msr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/msr.c b/x86/msr.c
index ce5dabe..757156d 100644
--- a/x86/msr.c
+++ b/x86/msr.c
@@ -36,6 +36,7 @@ struct msr_info msr_info[] =
     { .index = 0x00000277, .name = "MSR_IA32_CR_PAT",
       .val_pairs = {{ .valid = 1, .value = 0x07070707, .expected = 0x07070707}}
     },
+#ifdef __x86_64__
     { .index = 0xc0000100, .name = "MSR_FS_BASE",
       .val_pairs = {{ .valid = 1, .value = addr_64, .expected = addr_64}}
     },
@@ -45,7 +46,6 @@ struct msr_info msr_info[] =
     { .index = 0xc0000102, .name = "MSR_KERNEL_GS_BASE",
       .val_pairs = {{ .valid = 1, .value = addr_64, .expected = addr_64}}
     },
-#ifdef __x86_64__
     { .index = 0xc0000080, .name = "MSR_EFER",
       .val_pairs = {{ .valid = 1, .value = 0xD00, .expected = 0xD00}}
     },
-- 
2.31.1.498.g6c1eba8ee3d-goog

