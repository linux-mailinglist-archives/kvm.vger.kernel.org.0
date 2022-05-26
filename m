Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D568453556F
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 23:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235256AbiEZVY6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 17:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349149AbiEZVYe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 17:24:34 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24D2F644D9
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 14:24:31 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id i19-20020aa79093000000b0050d44b83506so1472179pfa.22
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 14:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=sjrWadd+U6s3AE9OlHKd1vSx1dK7nsNaDjQLzkoUXcg=;
        b=TQVt0Vq76cHTUEa2X6kDVHu+UhrNE6fY2WluDwgnGkC5IRYf796KPXGLhfr04Uy3YZ
         6kBFEBE021obJjvVQEwo/PWkRY+xLg5Z1XpTssEYByESOvro3h2/ts3s+hfAVhsAxFqn
         70IeBknD328cT/+s0eWCstTi2PBxxkLVBD6skaLODHTTWc58vzrIeMni8h4pEEr6iTFW
         fYzf6XTbKN6Lm9Kpw+ZG4tbsdEOKBd9GJnzIMzKjvgGXsggp+y8oQBokLA70b8+BylEg
         52jqDFIsfdKJVhJIl/iRCeWIcuUWUmsp1vtPsMFHjg7HQGHRRO/QCD7qildWl4DVyUWm
         M7OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=sjrWadd+U6s3AE9OlHKd1vSx1dK7nsNaDjQLzkoUXcg=;
        b=Z75OuJkvzp7VA9DqowgOfCOq2dsYC4RgUIQEczL0xxFlIKjeOxamnL3UGLdBQosZSN
         dDpN4BjWHAmbEMdJj+EX73TysEGZpqPn+XADUNxZRgw0CSejRquaeG9zZ0ssqKA/eC2W
         D4qMIGSEDHARCy9HGZEFu6c6+OL65yuq38J02rF06IDlfA4QE0NccK/vj23+HDiQDiOL
         215qzZdrPitka2poIwm0VXRVq5qzKnBPHchPe4aI+RgXxiFHdPrglDuprLAVAOI9M7MB
         t5ouiqalzYpM/17iSm9stX3jKnETcIwoUKCQFS3tBdPdtj5AnaTqxhdg0lsdcj0TTBPO
         BOiQ==
X-Gm-Message-State: AOAM531Ih4d+FULBTZNxIO6tCcInIFr8PeuSlu+x9ILoN7AsObViaiJW
        nCdKqTR5FOPEMtX8Xu5cMBHYQ3QTnOo=
X-Google-Smtp-Source: ABdhPJx8M0VoHr57nLlA/sX8zTDrVXkgT1bsVM9bmwFgKG11EQvIc6zvT1j59UbsqyEBKS3z3uAnVG+SZ80=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a62:e819:0:b0:518:6a98:b02 with SMTP id
 c25-20020a62e819000000b005186a980b02mr34100732pfi.74.1653600270603; Thu, 26
 May 2022 14:24:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 26 May 2022 21:08:17 +0000
In-Reply-To: <20220526210817.3428868-1-seanjc@google.com>
Message-Id: <20220526210817.3428868-9-seanjc@google.com>
Mime-Version: 1.0
References: <20220526210817.3428868-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 8/8] KVM: x86: Bug the VM on an out-of-bounds data read
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

Bug the VM and terminate emulation if an out-of-bounds read into the
emulator's data cache occurs.  Knowingly contuining on all but guarantees
that KVM will overwrite random kernel data, which is far, far worse than
killing the VM.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/emulate.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 2aa17462a9ac..39ea9138224c 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1373,7 +1373,8 @@ static int read_emulated(struct x86_emulate_ctxt *ctxt,
 	if (mc->pos < mc->end)
 		goto read_cached;
 
-	WARN_ON((mc->end + size) >= sizeof(mc->data));
+	if (KVM_EMULATOR_BUG_ON((mc->end + size) >= sizeof(mc->data), ctxt))
+		return X86EMUL_UNHANDLEABLE;
 
 	rc = ctxt->ops->read_emulated(ctxt, addr, mc->data + mc->end, size,
 				      &ctxt->exception);
-- 
2.36.1.255.ge46751e96f-goog

