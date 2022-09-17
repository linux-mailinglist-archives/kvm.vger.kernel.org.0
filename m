Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 212B45BB4E0
	for <lists+kvm@lfdr.de>; Sat, 17 Sep 2022 02:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbiIQAKa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Sep 2022 20:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiIQAK3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Sep 2022 20:10:29 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8588540BCC;
        Fri, 16 Sep 2022 17:10:28 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id b23so22694420pfp.9;
        Fri, 16 Sep 2022 17:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=st4MEcOvTkhck1tSpFNsKlNFDJyyWZ5FpD/I8fpUQ68=;
        b=fDr22VEMkyqvttZV9XtL7P/FGOpxQ6ELukAOb4IHJB4r7GaHQ+aA6gb512MY36f0sD
         kZP6KSqsigBgdw3el8Ef4aZeiky/5aaI1RVz5Fj4PLqvLxpDor7k80L6g1DaWcVRwX4y
         wIj3p4vg7PboiDcdzd2dgDErdPTDKSk8lwxTlj9AWYjX5oukgQDzARoCSyXneDhJK8UH
         xpo+lDvUjvRxCcqKQIYJGUw8gox9LP8qovFmW0T51M+EBUqbXbimXSFYjm5jVTb1g//o
         76YBHZcg0uOeb/MR0KGK73Mtsb6MqggrsOKjvhxT4VOwYNp3ho4dgIWaWeN3QIEB1JKh
         SjQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=st4MEcOvTkhck1tSpFNsKlNFDJyyWZ5FpD/I8fpUQ68=;
        b=31usD0c4A1Y1XBiTWX7QXjaUWhBKniM9KRxC80XkHQ+zWZJE1mLjdJLLslaLaiOqBM
         suUjowGoBVL7kEKx1KUMlrZwG+E9wJPZ8xlMhVakjSKnxiKX2jZR/hRSnLUmfkN2K2PK
         9wHVWKyAVqfg0Onns1hZiN139wZKVOZV5AKsIu1+yxv32Q8BJvNwx8h+Y82Mqctq8Sux
         39bJIwKa1vrSxuir25Lt6u2lgLOywnmRgTdm1c1QpcN6xwI37AOJ/09uRF4oddbEVU+E
         IhXaeMCuL7WKB0V59WoKCjVW9w3VIjNszSFoXA7OJ4HwMGvkGHu2qy3EtDu5lOUOxyCS
         u7Vg==
X-Gm-Message-State: ACrzQf2T680pIq9F3EhKR/M8vHEzsJHbHm4Utit5WqHNUkKyotzPkSjY
        ESPVKoUuDOaV7s/NBhktu+mn0LTO57i8jg==
X-Google-Smtp-Source: AMsMyM5up6yDvtq/TY27KYfyfyZvkyLzt6jP5CmmlJR+jFWa/bRhscdC/MY+c5rnvnQIZoVdEbUpWg==
X-Received: by 2002:a65:6955:0:b0:439:a99b:bca5 with SMTP id w21-20020a656955000000b00439a99bbca5mr6640218pgq.80.1663373427909;
        Fri, 16 Sep 2022 17:10:27 -0700 (PDT)
Received: from localhost.localdomain (c-24-5-142-105.hsd1.ca.comcast.net. [24.5.142.105])
        by smtp.gmail.com with ESMTPSA id f4-20020a170902ce8400b0016dc6279ab7sm15524940plg.149.2022.09.16.17.10.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 17:10:27 -0700 (PDT)
From:   Justinien Bouron <justinien.bouron@gmail.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Cc:     Justinien Bouron <justinien.bouron@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: Handle MXCSR in kvm_arch_vcpu_ioctl_{get,set}_fpu.
Date:   Sat, 17 Sep 2022 00:09:28 +0000
Message-Id: <20220917000928.118-1-justinien.bouron@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_arch_vcpu_ioctl_get_fpu does not set the mxcsr in the kvm_fpu
struct; conversely kvm_arch_vcpu_ioctl_set_fpu does not set the mxcsr
value in the fxregs_state struct of the vcpu.
This leads to the KVM_GET_FPU ioctl returning 0 as the mxcsr value,
regardless of the actual value on the vcpu; while KVM_SET_FPU leaves the
MXCSR on the vcpu untouched.

Fix kvm_arch_vcpu_ioctl_{get,set}_fpu to properly handle MXCSR.

Signed-off-by: Justinien Bouron <justinien.bouron@gmail.com>
---
 arch/x86/kvm/x86.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 43a6a7efc6ec..c33a2599a497 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11462,6 +11462,7 @@ int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 	fpu->last_ip = fxsave->rip;
 	fpu->last_dp = fxsave->rdp;
 	memcpy(fpu->xmm, fxsave->xmm_space, sizeof(fxsave->xmm_space));
+	fpu->mxcsr = fxsave->mxcsr;
 
 	vcpu_put(vcpu);
 	return 0;
@@ -11486,6 +11487,7 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 	fxsave->rip = fpu->last_ip;
 	fxsave->rdp = fpu->last_dp;
 	memcpy(fxsave->xmm_space, fpu->xmm, sizeof(fxsave->xmm_space));
+	fxsave->mxcsr = fpu->mxcsr;
 
 	vcpu_put(vcpu);
 	return 0;
-- 
2.25.1

