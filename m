Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE6D643FBE
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 10:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235050AbiLFJVd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 04:21:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235035AbiLFJVL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 04:21:11 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C1322B04;
        Tue,  6 Dec 2022 01:19:04 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id bx10so22616620wrb.0;
        Tue, 06 Dec 2022 01:19:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jJMgiKd2XNibQKoHS6dMA5mcxNwiLlQqohpVTG4yEvg=;
        b=OHlvvYyjf6WEmkicR9mvIaGgcBZAiO6CvyjItEOFveufSSWXeOqw41B2sFokuPgu/p
         dKS/AbtBKbKtUjH/3eAes0wzCG49OQLf7vfT6RpzuVL+B2/CTEWjWtzkNlnihVhiCbgq
         JzWelkfVevkyBDAnesR3QF325WYpqMr/U5TwolRn625W2SxFvip7LHm9R7kRFGJ/4RkH
         FSShQboeD1Cba2VUWNnAAGpLP2tR1UPQ6XXEiybWj9zWIWBgiWWaaMjqbdaHdnql1Gt0
         QG6BgO+KrhdM3GTpszrWW//gLErNDpsvzeyKNa/9y4intWohB9IkA/WhD/Zs4qMwG6XX
         FTdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jJMgiKd2XNibQKoHS6dMA5mcxNwiLlQqohpVTG4yEvg=;
        b=OjspmWinUbH7LQHAcN/LxJwTARK1Tr49aF6PEFQM33Jft7rErijmdaOv3IrlPw47YU
         jlr5uYM/LaUl9T6wXww/SVWk0J0T7ej8gRcHBvfgPlo8+GthguqOXIhHOG5adBQWvKP4
         gKLXkSpUgo41rz8bYMvzerm7ROa1mcnubCW22CmY9LqlLytIBXy8CAwSQOt0fbsyeY0M
         8IZ2MHK8Ud9uz1pC8191lfb5MJ5oG2Rp4OwgaD2wweyhwCWfT1JZSmVIoMB+3fpSTir5
         bfDEO7ineKJrbcI/1SpcSUfHjOZWTbulKFQNPpAUGXY90vLK+O0+VXLhYOOxCwat+8qg
         l4AQ==
X-Gm-Message-State: ANoB5plN9r9GlHYTJ+YRtFtUJA1JguJpNzIxLeUfUSHxBJ0Nep6ceA9W
        U0jUhNNq+dHoANV/qBgJBhr+A9XCJJcEtw8gIe2FPtpKTmw=
X-Google-Smtp-Source: AA0mqf78WVZHcIQYT6aXUhPw0a8ULZXFfwHCOJ5Ycn6dQdyDdsfvW/g4bEkhyhxnomRUpQ2pl2slFhK9LJlzjC7UihE=
X-Received: by 2002:a5d:4d07:0:b0:242:4ab7:5a19 with SMTP id
 z7-20020a5d4d07000000b002424ab75a19mr9516888wrt.389.1670318343301; Tue, 06
 Dec 2022 01:19:03 -0800 (PST)
MIME-Version: 1.0
From:   Hao Peng <flyingpenghao@gmail.com>
Date:   Tue, 6 Dec 2022 17:18:51 +0800
Message-ID: <CAPm50aKbzsMtgb3Cfux2nXOrOcHRZ5MP0ndKg9T0OQCqOsCa_w@mail.gmail.com>
Subject: [PATCH] KVM: x86: hyper-v: Restore function kvm_hv_assist_page_enabled
 to export
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
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

kvm_hv_assist_page_enabled() is called in export function
kvm_hv_get_assist_page().

Fixes: 0c2a04128f50 ("KVM: x86: remove unnecessary exports")
Signed-off-by: Peng Hao <flyingpeng@tencent.com>
---
 arch/x86/kvm/hyperv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index cc3e8c7d0850..2c7f2a26421e 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -898,6 +898,7 @@ bool kvm_hv_assist_page_enabled(struct kvm_vcpu *vcpu)
                return false;
        return vcpu->arch.pv_eoi.msr_val & KVM_MSR_ENABLED;
 }
+EXPORT_SYMBOL_GPL(kvm_hv_assist_page_enabled);

 int kvm_hv_get_assist_page(struct kvm_vcpu *vcpu)
 {
--
2.27.0
