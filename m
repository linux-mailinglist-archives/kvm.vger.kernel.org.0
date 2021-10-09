Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E92F427489
	for <lists+kvm@lfdr.de>; Sat,  9 Oct 2021 02:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243997AbhJIANM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 20:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243974AbhJIANJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 20:13:09 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF352C061755
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 17:11:13 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id u9-20020a0cf889000000b003834c01c6e8so2913141qvn.4
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 17:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Jpbo+B/GhwXgwxD1by7/DXTldt+Mb436guJudBghH8A=;
        b=C8410r5ajEijJDUgktftizTQ2SFhw825HDX8x4RMiSyJDTLrbUC7tx9Q5aLXxnfm+l
         msNYG80c9PcM3gKhl5ayhrxTDm/3M4hf2CsQEC3juu0lxJSF0Ue+Rm4r8fMraYSSms/Y
         fQnnhcjtr/0tpVg3bED+ZM8BxcEi1ABpHyVhOriyWd9gCz6BTZ91pHwVk16b4mrfhhgq
         hgeK8F3oD17jRUT0OBQyJZ/mg3oJECgTeCUvLAOZ09BvqGNgkvwOdrSr9k4M0H6e2qNQ
         hsxK11/1GniyFj+JsUSswG4Vxcz1wDQJsfBct0fZaG0Wk+CDfjyspOgs4mZVrFZLJaKy
         ppJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Jpbo+B/GhwXgwxD1by7/DXTldt+Mb436guJudBghH8A=;
        b=z+ZhmfIeluyAZ7vvxnBwa0Z46LrBMkJNsxUlySMND/4/IAo6g1bH0U2x776GdxdT37
         KGFZv/BwsgV0X2h+4cjM39lXXjH1p3twalhqBGxulA0rZ/Rg28YkGakSnPfZK+k00OTP
         Ta+nWIPTUA+1G9ac7nRKvtRs+3vmmIN7plbknloOnzs8LL3h8rlxuS34XlJwI4GWOQp4
         2MVuh4WpA5war0x4boK4agAsolPGD1v98PZhPT6mnCem81vxf/C28hXukLf6mHGvKFuy
         OThMhdPo8DLh6ztGwdn2fMvpjjrXwpOVLNQH6Tyb9Huo+uim1oHAiAMuV/CPfxCiRXVB
         lKQg==
X-Gm-Message-State: AOAM532kGHuyyCsS05v65IpoMLF1dgeDuU+PSTkA8dLJeWO1XL7HfVtd
        A+zmXwU+Sg6nzU76PDPFskUpFjtLJ/c=
X-Google-Smtp-Source: ABdhPJwi03qK1ZV9VOpWwjVXNzCrboIXvkE07AK1H+8yFhag5kzKnREdL38PD0yNe4Pzbm7Qg5F6nGLc5oU=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:ac8:430e:: with SMTP id z14mr1441247qtm.208.1633738272984;
 Fri, 08 Oct 2021 17:11:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  8 Oct 2021 17:11:04 -0700
In-Reply-To: <20211009001107.3936588-1-seanjc@google.com>
Message-Id: <20211009001107.3936588-2-seanjc@google.com>
Mime-Version: 1.0
References: <20211009001107.3936588-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH 1/4] x86/irq: Ensure PI wakeup handler is unregistered before
 module unload
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a synchronize_rcu() after setting the posted interrupt wakeup handler
to ensure all readers, i.e. in-flight IRQ handlers, see the new handler
before returning to the caller.  If the caller is an exiting module and
is unregistering its handler, failure to wait could result in the IRQ
handler jumping into an unloaded module.

Fixes: f6b3c72c2366 ("x86/irq: Define a global vector for VT-d Posted-Interrupts")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kernel/irq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index e28f6a5d14f1..20773d315308 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -293,6 +293,7 @@ void kvm_set_posted_intr_wakeup_handler(void (*handler)(void))
 		kvm_posted_intr_wakeup_handler = handler;
 	else
 		kvm_posted_intr_wakeup_handler = dummy_handler;
+	synchronize_rcu();
 }
 EXPORT_SYMBOL_GPL(kvm_set_posted_intr_wakeup_handler);
 
-- 
2.33.0.882.g93a45727a2-goog

