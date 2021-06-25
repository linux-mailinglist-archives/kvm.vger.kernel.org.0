Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA9F3B3A1D
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 02:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232957AbhFYAVV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 20:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232933AbhFYAVU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 20:21:20 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D2AFC061756
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 17:18:59 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id l12-20020a25ad4c0000b029055444b6e99bso1708899ybe.5
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 17:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=6fjzUtku/PtRujaCxglb2g16yONAmo5V2De3zOjXjoc=;
        b=qpcFFW0RGwSColAnhc/3Iy3uEck2HZTjVCBNLgz4JdCOAAd/9YXF7I2xAPgKIazivh
         4AJPvqK51r9HiW1ZqGa/sHvXsLYOoerJv7r0D33alsqvPpjqtMIJfLgDiTSOa1leGXSy
         BcjwmikeAthbKD6Mwe9T/XGoPNDeWXWg3jwqFfVpta6+1b0cQpwJsVGAhT5+bk8z+gpt
         sczX8FKOW044HHSuLV9VdbfjjE8Qw3xVIne4RypNx5bRpbF+2mJUbUWXq1fojtEPOL4l
         a8B1JTKN4F4bEbkUiByeI+c05DTMgIuI/01b+5vEn/9I24QLogLql9GqAFYaxMll/CcL
         GcFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=6fjzUtku/PtRujaCxglb2g16yONAmo5V2De3zOjXjoc=;
        b=bnnn2KV9KSI4lwsa3d9pBx75RD/tduQj/gh2j7WUwbllWNna9Syf5viYEQTifCWeQ2
         Uyj3Wr9DdVwu6ToEGpmU+hUqwXd5tJ9P1OJO1uvRROLMrR4+l4iZp6faF+MK3fPaUBwN
         7jHZ2ZfychRrYsiEsepfC/q30KitDjinYd8AaNZD+jYTEFvzsPrrcL68Z7DHH0WANzi4
         QTE8nljslDD9FWewzUsdT3nkps2bO1ha2L07yrrGR3zABNWaDBvIkx5TBT9avpcm14We
         OC/ou+rx/Wi9zBDaigdTJK6DUvU1qtJO0axAXiemM5h2DJjvUZJfdfSLfPKNOOP3WS0Y
         T9lA==
X-Gm-Message-State: AOAM531E/FLiqXTX/2cr3X1ch6OvySUB185tHTCRKDx5o4zcCIAAz1Pd
        fHhesMyL+wH23ZHgwBxm9Wr5qcZOBas=
X-Google-Smtp-Source: ABdhPJymk4k2ITDoivLr/PI7hmMnTloV0UNdYLa/stFT1YkFD9JtUH1c4jIUTrrEu0OrsZQOJWxIjbc4PAI=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:7c83:7704:b3b6:754c])
 (user=seanjc job=sendgmr) by 2002:a25:74cc:: with SMTP id p195mr9042062ybc.109.1624580338507;
 Thu, 24 Jun 2021 17:18:58 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 24 Jun 2021 17:18:53 -0700
Message-Id: <20210625001853.318148-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH] Revert "KVM: x86: WARN and reject loading KVM if NX is
 supported but not enabled"
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let KVM load if EFER.NX=0 even if NX is supported, the analysis and
testing (or lack thereof) for the non-PAE host case was garbage.

If the kernel won't be using PAE paging, .Ldefault_entry in head_32.S
skips over the entire EFER sequence.  Hopefully that can be changed in
the future to allow KVM to require EFER.NX, but the motivation behind
KVM's requirement isn't yet merged.  Reverting and revisiting the mess
at a later date is by far the safest approach.

This reverts commit 8bbed95d2cb6e5de8a342d761a89b0a04faed7be.

Fixes: 8bbed95d2cb6 ("KVM: x86: WARN and reject loading KVM if NX is supported but not enabled")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

Hopefully it's not too late to just drop the original patch...

 arch/x86/kvm/x86.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4a597aafe637..1cc02a3685d0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10981,9 +10981,6 @@ int kvm_arch_hardware_setup(void *opaque)
 	int r;
 
 	rdmsrl_safe(MSR_EFER, &host_efer);
-	if (WARN_ON_ONCE(boot_cpu_has(X86_FEATURE_NX) &&
-			 !(host_efer & EFER_NX)))
-		return -EIO;
 
 	if (boot_cpu_has(X86_FEATURE_XSAVES))
 		rdmsrl(MSR_IA32_XSS, host_xss);
-- 
2.32.0.93.g670b81a890-goog

