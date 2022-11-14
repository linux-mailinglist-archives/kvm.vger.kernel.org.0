Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF0366279B4
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 10:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236825AbiKNJ5r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 04:57:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236749AbiKNJ4x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 04:56:53 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0AF31EC4E;
        Mon, 14 Nov 2022 01:56:40 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id s196so9828553pgs.3;
        Mon, 14 Nov 2022 01:56:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Epb28JUv2/E4MT6KWLm8hPFpYfNx380cSmfNBWjUaXY=;
        b=kkwra97tiBy7QaRptCYB1p+uZUwKFVrLTxMHeN5WBgTK7NRwWxzaM+udt+5vNcc6J4
         sMf3TKM7jYEhawkt6UTZBeyzIgSbZ6TKJzlq/+5sYrZEe9KXSt2VVNQUWq0aewLx6OA4
         m335IcCgQAna5lXGfwFK4JbmyHWlszmp0nw6fvqrdsN6BpVvvGFVfSnAkRX+qvvGfqRL
         PnoVkem39EhkW1Zpt5PnOb97SY+ERzDkvX1Zz/gmhVRS15xn3TMWo02wF7R8wIGIVcMz
         ZOqxO45BDVLtOh8zXO2Cl0fPhnNGU4tzH9IsHuYr4/EYqRIQqN0/CAWOEV7x6weNdxNM
         kG8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Epb28JUv2/E4MT6KWLm8hPFpYfNx380cSmfNBWjUaXY=;
        b=pPzHJpgmU6bxnKTj0BNjt+fDMBbuEIPB7dz/m2A1iKRUB4DXCQBiO/oglmDGSSISYF
         KiGgPiOP5cBPoyyG8TKXRE/zkPXwz8oXKECOQd0U2oRk5iE9DsJZ83FMFTDu93Sw2jNR
         IegncB8EH1WjAOlq56C24L52din1/Zz3sseeo33oiSonNsHSkDZ06rbYOc5WW0XP6uOY
         UsF1eKpyDmQ7GY/YLIVHaXV/Z+v3KvtCWtRtppOFtkJ+nV0RSXmpjag42ut14TEZVENV
         BrH/uDncMFQ6jrvBPFLcd5/+uMka1OqE9Pbb4mSCp10MVXbPIvYyq7G0FD3W4NZRaAtZ
         3IPA==
X-Gm-Message-State: ANoB5plt77TI+6w+ddmclZJzt9TLbNOQtiSy+aw31wFYEaNj8/6PAzni
        dsfhIP+xsLupoW732VtFo5k=
X-Google-Smtp-Source: AA0mqf4taJ0tuBhBX9p99SZ9/fAPB5BcZs6J4EbbrbYCE2f75pVjfbgugJU2XmHBB89EURtMburQZA==
X-Received: by 2002:a65:4d0e:0:b0:439:3b80:615d with SMTP id i14-20020a654d0e000000b004393b80615dmr11498561pgt.255.1668419800344;
        Mon, 14 Nov 2022 01:56:40 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id d29-20020aa797bd000000b0056c6e59fb69sm6266472pfq.83.2022.11.14.01.56.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 01:56:40 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 05/14] KVM: x86: Remove unnecessary export of kvm_inject_page_fault()
Date:   Mon, 14 Nov 2022 17:55:57 +0800
Message-Id: <20221114095606.39785-6-likexu@tencent.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114095606.39785-1-likexu@tencent.com>
References: <20221114095606.39785-1-likexu@tencent.com>
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

From: Like Xu <likexu@tencent.com>

Don't export x86's kvm_inject_page_fault(), the helper isn't used by
KVM x86's vendor modules. Add declaration to header file out of
existing callers' need.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/x86.c | 1 -
 arch/x86/kvm/x86.h | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 38a42ca86ab2..818aff135261 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -774,7 +774,6 @@ void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault)
 		kvm_queue_exception_e_p(vcpu, PF_VECTOR, fault->error_code,
 					fault->address);
 }
-EXPORT_SYMBOL_GPL(kvm_inject_page_fault);
 
 void kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
 				    struct x86_exception *fault)
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 9de72586f406..69811b4f3eac 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -307,6 +307,7 @@ int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,
 int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			    int emulation_type, void *insn, int insn_len);
 fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu);
+void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault);
 
 extern u64 host_xcr0;
 extern u64 host_xss;
-- 
2.38.1

