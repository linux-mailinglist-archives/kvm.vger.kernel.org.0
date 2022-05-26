Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85B9253556E
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 23:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348392AbiEZVYq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 17:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349184AbiEZVYd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 17:24:33 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9611AE8B82
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 14:24:29 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id b20-20020a62a114000000b0050a6280e374so1484521pff.13
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 14:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=yRrqKfhB5+m3QmsLeXBaT/5o9hpC8Ubit1ecnTTsekU=;
        b=lsgx9HK0wPTF3d3oLuZSwn2QvIXYw7zGXYU/qK+/MCKvUxHdMKonxc+4ZAI5gXX3At
         hZWh6YSpu2kFwSJxMiWyYxW4o2lMk3zH93qR+BQh+a6cvq5p+JEeeCoZYrbDZ0XKVHhi
         bRp8VGk2WbRyqeil3jdolhmHL2V683AYIECZMDKNIasbtmly1txRKFRxKHs//c6+cU9O
         CuMayZC96EUsuLCAwjB+Vl8L3+afQkUS91zpda9vYKJ5nvFquoyE0UXKw6UZG05k0Xw8
         juausBaUpbBHS6kE8sNFO8pwRDpKO0Jxqr/o/DbiyDtJlVQJbgQ12W+k4dHjM+/lXhCi
         56jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=yRrqKfhB5+m3QmsLeXBaT/5o9hpC8Ubit1ecnTTsekU=;
        b=Vvq8hFG15aCkt00WyslTjq8+usn5cSgZ3LWZekaoqsIiyJvlflxlFMpg/6dGaX7Thv
         NMmMcnW9ImfquKZPx4HRJ40ts7x2aqmXlYrEu9UGWrRIKgMngQvfe51zhJ26rrm+NPPp
         R5/WyTCFQJC4rYR1IIqfcGXpNBdf3bFsAm0vSe2NzzP+XOgAOWTzqLMcezjthYTSAvtB
         lWAE5ba7iwJ+3rcDWf9/XIolz5xJ06hrTPIJsORqH1hrSWUAC4THfbMBC8wIxrF5000o
         5Jc+2jegU3spGy57XX2ZWfwbi4Zea+6JxYEQ16ZmoGw/rL9f5aoOdJbQ+JpeTFgI90Xt
         jLHQ==
X-Gm-Message-State: AOAM5314zPora9h8g6X1qXOjdEK4A3SaClArAJGIdoRPI1x5Sc724d3q
        RQ1dbymRgyxdoyX7xqN0PWC/Z+5NV6w=
X-Google-Smtp-Source: ABdhPJyQ9jXsajtTuovYsAdXjyK+leKO3tYRFooS2NToE+scEfyRfA0JXUwXmnW1/Sh99NOkWmbBlpuKCuQ=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a65:5188:0:b0:3fa:6081:7393 with SMTP id
 h8-20020a655188000000b003fa60817393mr17689624pgq.72.1653600269102; Thu, 26
 May 2022 14:24:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 26 May 2022 21:08:16 +0000
In-Reply-To: <20220526210817.3428868-1-seanjc@google.com>
Message-Id: <20220526210817.3428868-8-seanjc@google.com>
Mime-Version: 1.0
References: <20220526210817.3428868-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 7/8] KVM: x86: Bug the VM if the emulator generates a bogus
 exception vector
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Robert Dinse <nanook@eskimo.com>
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

Bug the VM if KVM's emulator attempts to inject a bogus exception vector.
The guest is likely doomed even if KVM continues on, and propagating a
bad vector to the rest of KVM runs the risk of breaking other assumptions
in KVM and thus triggering a more egregious bug.

All existing users of emulate_exception() have hardcoded vector numbers
(__load_segment_descriptor() uses a few different vectors, but they're
all hardcoded), and future users are likely to follow suit, i.e. the
change to emulate_exception() is a glorified nop.

As for the ctxt->exception.vector check in x86_emulate_insn(), the few
known times the WARN has been triggered in the past is when the field was
not set when synthesizing a fault, i.e. for all intents and purposes the
check protects against consumption of uninitialized data.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/emulate.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 70a8e0cd9fdc..2aa17462a9ac 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -624,7 +624,9 @@ static unsigned long seg_base(struct x86_emulate_ctxt *ctxt, int seg)
 static int emulate_exception(struct x86_emulate_ctxt *ctxt, int vec,
 			     u32 error, bool valid)
 {
-	WARN_ON(vec > 0x1f);
+	if (KVM_EMULATOR_BUG_ON(vec > 0x1f, ctxt))
+		return X86EMUL_UNHANDLEABLE;
+
 	ctxt->exception.vector = vec;
 	ctxt->exception.error_code = error;
 	ctxt->exception.error_code_valid = valid;
@@ -5728,7 +5730,8 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
 
 done:
 	if (rc == X86EMUL_PROPAGATE_FAULT) {
-		WARN_ON(ctxt->exception.vector > 0x1f);
+		if (KVM_EMULATOR_BUG_ON(ctxt->exception.vector > 0x1f, ctxt))
+			return EMULATION_FAILED;
 		ctxt->have_exception = true;
 	}
 	if (rc == X86EMUL_INTERCEPTED)
-- 
2.36.1.255.ge46751e96f-goog

