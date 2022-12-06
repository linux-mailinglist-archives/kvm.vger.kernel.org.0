Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A26D4643FC1
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 10:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234995AbiLFJXO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 04:23:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234973AbiLFJWu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 04:22:50 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B4C022B2E;
        Tue,  6 Dec 2022 01:20:28 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id f18so22549561wrj.5;
        Tue, 06 Dec 2022 01:20:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vPKqXWw7xsVHLyBN+EDFkZ4J8uiiHRqUm/YEFJcGYLU=;
        b=j/S97HK7WE0fQCAFzc+ivVICdJxs+QEfktSh/NcVfZne5yHKLlkG98Z/Fq21EMorUg
         aEHmAjijyugb9nmoW65LE1q1OhezYiI3/Kv/eEHAwgOtfVhdANEQT7HzH70awa61h8JH
         XZJHefgcM7w20qDJGSbgS3hfCEP0o7Se8nI+tx7t7FTyj4qIWff/H1r5VPl2fhuONq05
         +U4nr05Kzb9fgaZLH3HHbzXdWxxkxFyV71D0LztT3SBTjXkQQ2dugXlPUS1uhaYSdU/L
         AoX2dA5Bu0GVGLVhiYpTWzWQXlxvACj88INjZNKEMdymf/OuxZjNuNQUozlBGXKVRZbI
         j8Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vPKqXWw7xsVHLyBN+EDFkZ4J8uiiHRqUm/YEFJcGYLU=;
        b=uTb5THpmYuEGXgW/LR8LG0GGeiNNHFSNzh7uQJS4hAcFX8gDCDva/dKgJSNbZyA+ud
         HoNwOz+EFlApwMw2HYarSOmWULk3Y4OKci9w2c47Z+CfE8AWUPxevrFopsqmePZJ2g+s
         F/4QL0uh97Rjy5tjHq47l4hmuRii94JsW7FdWlkXNz9xcomXlpqq0iFhv/mOKd+4ptO1
         RbyPNXw75o6pd6itCmh4km/O77HfFU0OM9cI8zPNiTIawx+qcCVDRzoY/bmM+6UHRLYB
         XmSTS718kmdYV0N/GdEEXwNouGpJh7pN7PbWaBUY77Pujs5fJXOGi0IsKwmhxjYY5Xw6
         R9cQ==
X-Gm-Message-State: ANoB5pkvigWza3dxSf6TaxRQQqQgPbg5e7d4eUb46pwzp3H8BdOAss9H
        bbDMMnDpHjmPEjuammnpdP9nnLrR8qSnJCVrM8NnvmkgEqM=
X-Google-Smtp-Source: AA0mqf4OGm51HT1f2vYNDcuC9b/Q0EBFF0gHPQWoe/I9nnBEXla1eFjv6qPUChwffz/gSpQwzC0vysILgpt7DQ/P3y4=
X-Received: by 2002:adf:e28b:0:b0:241:c2c3:26c8 with SMTP id
 v11-20020adfe28b000000b00241c2c326c8mr48984132wri.278.1670318426619; Tue, 06
 Dec 2022 01:20:26 -0800 (PST)
MIME-Version: 1.0
From:   Hao Peng <flyingpenghao@gmail.com>
Date:   Tue, 6 Dec 2022 17:20:15 +0800
Message-ID: <CAPm50aJ=BLXNWT11+j36Dd6d7nz2JmOBk4u7o_NPQ0N61ODu1g@mail.gmail.com>
Subject: [PATCH] KVM: x86: Simplify kvm_apic_hw_enabled
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Peng Hao <flyingpeng@tencent.com>

kvm_apic_hw_enabled() only needs to return bool, there is no place
to use the return value of MSR_IA32_APICBASE_ENABLE.

Signed-off-by: Peng Hao <flyingpeng@tencent.com>
---
 arch/x86/kvm/lapic.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 28e3769066e2..58c3242fcc7a 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -188,11 +188,11 @@ static inline bool lapic_in_kernel(struct kvm_vcpu *vcpu)

 extern struct static_key_false_deferred apic_hw_disabled;

-static inline int kvm_apic_hw_enabled(struct kvm_lapic *apic)
+static inline bool kvm_apic_hw_enabled(struct kvm_lapic *apic)
 {
        if (static_branch_unlikely(&apic_hw_disabled.key))
                return apic->vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE;
-       return MSR_IA32_APICBASE_ENABLE;
+       return true;
 }

 extern struct static_key_false_deferred apic_sw_disabled;
--
2.27.0
