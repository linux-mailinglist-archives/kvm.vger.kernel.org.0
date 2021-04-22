Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22B7736773E
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 04:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234866AbhDVCMw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 22:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234636AbhDVCMb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 22:12:31 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19392C061348
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 19:11:53 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 135-20020a25048d0000b02904e4ed8b411bso18427903ybe.20
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 19:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=9FTkqe36BRI/gipCYRepnZSpLm1Jj8+DXD4OAejjwDk=;
        b=tdxpEit4hTqZAjq5Uan7G+ZYbUeY8vleV7S9D2L82o0kqTm6weZ4AScDOZBS5fUsX7
         JAOT/zpBZjmIV6mzN18RQNjdo/vVSaVzqQVn6WmkwoiFHVtPxzVRM6J5zRb7263SaoXJ
         LqMvRrK4DI7UIVZQoPjpcqTBJq+77NFStU04xT3TNg/QcFa5L0zww7BRNpajztD0z/Pp
         Ov+dbCiKHg6BYdpC72RYwjmApHXfwkDFhc5hS2LkMqDb7GSFUVHpCa7xXyt8ickY6xc4
         q5y7TXuOg8SaMCUrSVKaS0jhEzWRFsz1tYTH7pk5ArOjbFV6tDSj5ir2ZF8+PoMeSG6V
         HSPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=9FTkqe36BRI/gipCYRepnZSpLm1Jj8+DXD4OAejjwDk=;
        b=WHRYsJRP9nzMobsg9lCwWwq7LNG3IKWsKBNzM/vcy11Nzsm7RB32HGvsas4jLut74u
         h5ICC/Bj+Bjkg6OiiwIryK0f92f+jvtnAu0+ut3bgASP7FzAZPU5PXi5AY7Ozuo44C+t
         Zum89ToKifkbNqBMWq7oclmuWLVfgSZN+Gz5yEnR26plt7Gq/l8SU4gejKJEe7IuIJhC
         l/gM5dUIWjyYHOTD4f41c8VdeKlO2CHTLY/f1wgN1FPaP0ULWN3GVzSGlGTco9L3qr1g
         i5VHMCdorhjJHsUchnvW53n1ucGnoDnJddQgutP12OjahRM4JtBYuFJSXo0oVyJFXrRM
         u9wA==
X-Gm-Message-State: AOAM531DPaSB3/bhUQ4ftgXDYAEfPnCeGxX7udT3z9eRuRcVUKGTDQIL
        hlLr+QR3kw7QtI72Ev3IWg6yHhRk0To=
X-Google-Smtp-Source: ABdhPJymK9oWkzr6AMQs+TKPEE8KeRfEhEYo3VfkZ+3meOKRYTJVn6Nr5G1dVUnbbIk6dGl60Dv1Hx7tAW8=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e012:374c:592:6194])
 (user=seanjc job=sendgmr) by 2002:a25:d4d2:: with SMTP id m201mr1276145ybf.301.1619057512219;
 Wed, 21 Apr 2021 19:11:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 21 Apr 2021 19:11:21 -0700
In-Reply-To: <20210422021125.3417167-1-seanjc@google.com>
Message-Id: <20210422021125.3417167-12-seanjc@google.com>
Mime-Version: 1.0
References: <20210422021125.3417167-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH v5 11/15] KVM: SVM: Explicitly check max SEV ASID during sev_hardware_setup()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Query max_sev_asid directly after setting it instead of bouncing through
its wrapper, svm_sev_enabled().  Using the wrapper is unnecessary
obfuscation.

No functional change intended.

Reviewed by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index bd26e564549c..8efbd23f771b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1799,8 +1799,7 @@ void __init sev_hardware_setup(void)
 
 	/* Maximum number of encrypted guests supported simultaneously */
 	max_sev_asid = ecx;
-
-	if (!svm_sev_enabled())
+	if (!max_sev_asid)
 		goto out;
 
 	/* Minimum ASID value that should be used for SEV guest */
-- 
2.31.1.498.g6c1eba8ee3d-goog

