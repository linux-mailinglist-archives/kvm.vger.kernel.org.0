Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1DCF5BF234
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 02:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231529AbiIUAdv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 20:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbiIUAdC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 20:33:02 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5756E79681
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 17:32:58 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 126-20020a630284000000b0043942ef3ac7so2541854pgc.11
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 17:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=MbPfwZWv+I6kc3yY72JCQSO5yCJ8JCb5ELGKfLOjwok=;
        b=grJuuh2+k9rqNemRgEr/i3C9qelUa8pmjrIwpZzOZWsob4m9BMj0id2HZJEYNqX2vk
         IyiBqggCegoMniVIEZ7ve0Pcy1+h2jKB9+MbFtK10I6z6o71JeWojaaos6m7WE8fir0j
         heFLVTWw3UN27mkc0NRFrTsxNKdJe5TptRVjlgbhxvmnLYxPIxj71ZtTzy+8U9psEbMq
         /DJvRQaVwnNJl+52DMbtmS4ycyYoramkBPdq9kNpcRPXozDD2tMcpY+VTWl4f/e0cZ1u
         xUxifAHZRm7LM+0f4tqB8q/MJPB9s8lTaVH0t++C99WkByoXTjU2cYt2Zh/7y53Gwmu9
         hSqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=MbPfwZWv+I6kc3yY72JCQSO5yCJ8JCb5ELGKfLOjwok=;
        b=r2JzNNlKeZal+9rEsI0IZHPn3KgtSE4FsNLhs4iBd5yUuEggqCffN9z7GGVuUyz3GT
         CCDngd/Do14UjCBHK42llrLFBOCNl9KjNQI2Eo8LL3A7ypwYbfnX35pE/VR1X0lyeiXS
         jwvwXg6BEiHmHg5HxdOSTayViUGSIHHdi8DrFcdz4LR8OuFcIcKrUEfvrjaB/F7lxJk/
         Lf7Zla8dl/dzHTVIn3N1hc8FO58t2Wzlnvwe9Oe9U7IgByUt3UI9HU59x7SBtRVZlzof
         T1fPWe+IDn1xB5Sj+3itp6nwQGQvB2CJ78fLwXP/B2H5QD3RDt35mB71ZIOV61qBQOLA
         i26g==
X-Gm-Message-State: ACrzQf1826v1cA7ur4B34+U2nxjJSimI7bxnFJiS0s/qnRfo1MFRVytw
        kT3T/ygxZWsAoitOVIMZWvEnnJYk2JI=
X-Google-Smtp-Source: AMsMyM7f/RJC1MtdX6LkmKjLrG4mZov+EsK6V2BR+rQVSc6X+vDgdbpWXXujI7vaEWcw3mjY8BTW5lUZVRw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:dac7:b0:178:b5e0:3627 with SMTP id
 q7-20020a170902dac700b00178b5e03627mr2094501plx.147.1663720377687; Tue, 20
 Sep 2022 17:32:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 21 Sep 2022 00:31:55 +0000
In-Reply-To: <20220921003201.1441511-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220921003201.1441511-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220921003201.1441511-7-seanjc@google.com>
Subject: [PATCH v4 06/12] KVM: SVM: Make an event request if INIT or SIPI is
 pending when GIF is set
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
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

Set KVM_REQ_EVENT if INIT or SIPI is pending when the guest enables GIF.
INIT in particular is blocked when GIF=0 and needs to be processed when
GIF is toggled to '1'.  This bug has been masked by (a) KVM calling
->check_nested_events() in the core run loop and (b) hypervisors toggling
GIF from 0=>1 only when entering guest mode (L1 entering L2).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index dd599afc85f5..58f0077d9357 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2339,7 +2339,8 @@ void svm_set_gif(struct vcpu_svm *svm, bool value)
 		enable_gif(svm);
 		if (svm->vcpu.arch.smi_pending ||
 		    svm->vcpu.arch.nmi_pending ||
-		    kvm_cpu_has_injectable_intr(&svm->vcpu))
+		    kvm_cpu_has_injectable_intr(&svm->vcpu) ||
+		    kvm_apic_has_pending_init_or_sipi(&svm->vcpu))
 			kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
 	} else {
 		disable_gif(svm);
-- 
2.37.3.968.ga6b4b080e4-goog

