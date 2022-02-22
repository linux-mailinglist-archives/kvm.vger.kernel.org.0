Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B66944BF64D
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 11:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbiBVKmj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 05:42:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbiBVKmh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 05:42:37 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D50EF780;
        Tue, 22 Feb 2022 02:42:12 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id y5so11577865pfe.4;
        Tue, 22 Feb 2022 02:42:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cFyD+UgCrTcUW9G1yzwrnBI2RM1+18GRQxUARdZiYVI=;
        b=R06JlyETbL5bONA+qdLfLjl5gXLYW0sHJUrXUueGYXoJwJprAKtTXTRAmjfqj7Kvjn
         0MFBCIW9z83rn6iUJHu5UXObhc+cgrD1WARpsZ+WocTmbDFfymWOYo/cIoPD4cWmYIQx
         oM0uRSZrejlaFQ7zvyycQRY+YzXbXMcSwWDYAKLEqXttvQP1GEww95b4B32CWz/ixBzO
         TorxzLunYGNAD6k/Y0eZkF47WcH98+zMS7qenNXDwA7wZ918sTLUltuPRyifMqvCxkO1
         azONXbvhMOB1o1k7KnwDo90bXd9lCGIPVUv2EWrE2+0HMjFiK/u2KTlSuAeFC9m7ndwq
         3hkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cFyD+UgCrTcUW9G1yzwrnBI2RM1+18GRQxUARdZiYVI=;
        b=Q9pQ89EHRzBqPp1hLnNobsEX/JGmi4FP6ecWYLfncZFJKlzXyPpBSkduPj0l6P8or1
         v4ufKwqCvlIK9KFRLYy+eNfuvoJgcEFRM8vblyAyA75LjQCXermS+IymoexNelJ1Uu6f
         zHlbfeXQgT3ZZZsQH2wlqiWRSmENLsNUrWr5YfqwNNJ6e8thWyVAQc2sUhRXJdm37bht
         tpQUyFyW/MjST9CBXJH+cohVclJSSRJPk/RMJcX3Yf5TRKuW1IdU3xwyq+6ucahPNEvf
         VT+ZoZNKnGNr0x6XgC0PvrVrKVmd4s6bOmu60Onwb8SwUrIRDARS4B1VywrbBKa41yJB
         SEpA==
X-Gm-Message-State: AOAM531jR93kEvb0PzzpEs+KSiDywpWi0SBtC3NQ8QNiZ4iodoCczhlX
        BjSRk6ShimXR5GhnEqHUOG2gTXp8k3x0Uphs
X-Google-Smtp-Source: ABdhPJy6xALR3G9TRXkG0mmujcuIssNWrolD7ptOty5o4IR9YOo2qQxuZUPNgrg+yYk5OuBvDsKoBQ==
X-Received: by 2002:a62:7b8d:0:b0:4f1:2d08:5e90 with SMTP id w135-20020a627b8d000000b004f12d085e90mr8967401pfc.31.1645526532087;
        Tue, 22 Feb 2022 02:42:12 -0800 (PST)
Received: from FLYINGPENG-MB0.tencent.com ([103.7.29.30])
        by smtp.gmail.com with ESMTPSA id t9sm9192235pgp.5.2022.02.22.02.42.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 02:42:11 -0800 (PST)
From:   Peng Hao <flyingpenghao@gmail.com>
X-Google-Original-From: Peng Hao <flyingpeng@tencent.com>
To:     pbonzini@redhat.com, seanjc@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM:nVMX: Make setup/unsetup under the same conditions
Date:   Tue, 22 Feb 2022 18:40:54 +0800
Message-Id: <20220222104054.70286-1-flyingpeng@tencent.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Peng Hao <flyingpeng@tencent.com>

Make sure nested_vmx_hardware_setup/unsetup() are called in pairs under
the same conditions.  Calling nested_vmx_hardware_unsetup() when nested
is false "works" right now because it only calls free_page() on zero-
initialized pointers, but it's possible that more code will be added to
nested_vmx_hardware_unsetup() in the future.

Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Peng Hao <flyingpeng@tencent.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 75ed7d6f35cc..9fad3c73395a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7852,7 +7852,7 @@ static __init int hardware_setup(void)
 	vmx_set_cpu_caps();
 
 	r = alloc_kvm_area();
-	if (r)
+	if (r && nested)
 		nested_vmx_hardware_unsetup();
 
 	kvm_set_posted_intr_wakeup_handler(pi_wakeup_handler);
-- 
2.27.0

