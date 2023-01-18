Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2BCE672047
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 15:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbjAROyd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 09:54:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231544AbjAROyD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 09:54:03 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89D3F1ABFE
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 06:48:53 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id b4so30429544edf.0
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 06:48:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1X9cKTEOns6mbPxiAJGzCLzAUmWNA4hlvu/w3TuUZPU=;
        b=XIcJS96oA67Hn1nXDnoKQbHuH4zcVXwA50Mjy6FlCanCgJYtLRHrD8yqDVgbDh6z+p
         1I8ZymV+22mLjRbNpwIbZt99snoyWphLUFE+CVd+7gbAinmHhJ+RBTbocHZ3XQiud8yP
         ukeMOSSnCGg3l//ciBp5SHyqmZ5CGHmlemY2A+SP54cAImPLvsUpH2jG3b2A6W4UjvHC
         lHXz1ZBsjSmZLeuJhMuO/xk2ztPc1Q4k6fLxSHMG4aW518ZIJjm46LqKi1a+SoNzpKvz
         hes3dNC0ovt5IEsubdBtgmMHyFnKhwLrIcv4/2pYj0uJgLxy8icT5CGlqtxmWUIKPFWb
         6RZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1X9cKTEOns6mbPxiAJGzCLzAUmWNA4hlvu/w3TuUZPU=;
        b=qnA0xj9PQBwGP2hlphavXWZXJfnYnAb8FlcZDbgg6kF4MrewIf1uaRjjmw0H64blhk
         LxI3PuUC3zswcXUG+X0bzaLDpeb/jWHgY1z4nWlTETbcVLm0BwJYNi1CyzehCBiAxEHE
         XMxtWCTTShgk75Dlyg9Mk2NlSP2TXTZ3Ty8Q2qiEoNq9uSrUy/vX2IFi/HtI7Dcf4zEP
         qMi0opIK4np2s6FTQNfw/ki2uUXqwWcn1LoqGfA5+jwVhOwagJXVwhiSYgYJIKf35e+4
         Tjq+25xTp4VsfR//taQlDFhkZxKQ4s6+VrWFuDqIW96dy55WrKrJXjdZPQoCfht3IQ+C
         EOPA==
X-Gm-Message-State: AFqh2krT8doGrKSSTMDzhldDbwbaW7ImJAB18L87rB5ueum8uAzlfLs6
        uOhBBIisq06ulSB7srYoAIm+fxjUHWFjvs6a
X-Google-Smtp-Source: AMrXdXtuGGFVNg9IigFu/jLBfkzvoyZVQlHooZu1GXXr6MADvaqWl+M62LJ9y0qGiQ3iYYzQP5VWkQ==
X-Received: by 2002:a50:fa8f:0:b0:49e:31d5:6769 with SMTP id w15-20020a50fa8f000000b0049e31d56769mr6624614edr.41.1674053332988;
        Wed, 18 Jan 2023 06:48:52 -0800 (PST)
Received: from nuc.fritz.box (p200300f6af03d2006e0fc0b921f9db5c.dip0.t-ipconnect.de. [2003:f6:af03:d200:6e0f:c0b9:21f9:db5c])
        by smtp.gmail.com with ESMTPSA id p11-20020a05640243cb00b0049e19136c22sm3627509edc.95.2023.01.18.06.48.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 06:48:52 -0800 (PST)
From:   Mathias Krause <minipli@grsecurity.net>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH v2 3/3] KVM: x86: do not unload MMU roots when only toggling CR0.WP
Date:   Wed, 18 Jan 2023 15:50:30 +0100
Message-Id: <20230118145030.40845-4-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118145030.40845-1-minipli@grsecurity.net>
References: <20230118145030.40845-1-minipli@grsecurity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is no need to unload the MMU roots for a direct MMU role when only
CR0.WP has changed -- the paging structures are still valid, only the
permission bitmap needs to be updated.

One heavy user of toggling CR0.WP is grsecurity's KERNEXEC feature to
implement kernel W^X.

The optimization brings a huge performance gain for this case as the
following micro-benchmark running 'ssdd 10 50000' from rt-tests[1] on a
grsecurity L1 VM shows (runtime in seconds, lower is better):

                       legacy     TDP    shadow
kvm.git/queue          11.55s   13.91s    75.2s
kvm.git/queue+patch     7.32s    7.31s    74.6s

For legacy MMU this is ~36% faster, for TTP MMU even ~47% faster. Also
TDP and legacy MMU now both have around the same runtime which vanishes
the need to disable TDP MMU for grsecurity.

Shadow MMU sees no measurable difference and is still slow, as expected.

[1] https://git.kernel.org/pub/scm/utils/rt-tests/rt-tests.git

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
v2: handle the CR0.WP case directly in kvm_post_set_cr0() and only for
the direct MMU role -- Sean

I re-ran the benchmark and it's even faster than with my patch, as the
critical path is now the first one handled and is now inline. Thanks a
lot for the suggestion, Sean!

 arch/x86/kvm/x86.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 508074e47bc0..f09bfc0a3cc1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -902,6 +902,15 @@ EXPORT_SYMBOL_GPL(load_pdptrs);
 
 void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned long cr0)
 {
+	/*
+	 * Toggling just CR0.WP doesn't invalidate page tables per se, only the
+	 * permission bits.
+	 */
+	if (vcpu->arch.mmu->root_role.direct && (cr0 ^ old_cr0) == X86_CR0_WP) {
+		kvm_init_mmu(vcpu);
+		return;
+	}
+
 	if ((cr0 ^ old_cr0) & X86_CR0_PG) {
 		kvm_clear_async_pf_completion_queue(vcpu);
 		kvm_async_pf_hash_reset(vcpu);
-- 
2.39.0

