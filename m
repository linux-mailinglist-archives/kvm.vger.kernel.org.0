Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69D2D59F1B8
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 05:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234512AbiHXDEL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 23:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234405AbiHXDD1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 23:03:27 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BBC681695
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:06 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id a21-20020a62bd15000000b005360da6b25aso5509259pff.23
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=91ku6RdHYBVIaVIyy/W5J3MfuUKqpZqv38drWe4lttw=;
        b=cQD/3UZPCHVctBss2P9faccqu201X9id+2CcOrsoc7jc7da6SnbyTyGdPn3uOFckNL
         QfvjIYXk+m1BTF5skHwXrgBNQ1EwaRIDIEk7SDWe7g5xnLWi7fsI3QgWlXJ++MUeuZjr
         GFX026uaosgJpd637LTmw8dhK9Ap4zprYBOH9VebMyyHLhkUXsqZCcrcpSsF9Qruxs63
         UVHDGFyI+XimJFcPsgZ/67RHhadLS8RXnlbT2u4n00eg5Cpp29hCZe4zyB66e27bzFeG
         pGG1vgYqMgloayDkLbbGytAogaBShSXtZtFV4BrgFTyCffRcJMt3+deWBK1nGGVanFui
         Z5Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=91ku6RdHYBVIaVIyy/W5J3MfuUKqpZqv38drWe4lttw=;
        b=dRbKu8kk8hkWONj2SAV/0T5SZWLyECy2TbGAK6l5oHRaNOwtNfZABme+6KiQPSn3MJ
         sjZ6GX6Ume6t7LNfQ+67uWRsJ8yfgsl4ziWfg7hIF05qdjsOFnZC4Rquxxf0Q9Fa2QaH
         9KUPxGg6mNHrUB1wOu9riKktkpPLFy5NgTXWOHcqNQ5YjWfg2jeYQAGk/TOmqLMlf/O8
         syTzdUAzjT/uwbBXQN0COaMZuToFPGhCPY2ov+FHrNKtdkLBUHIitGPclZnf/77OaljG
         xelJxIhas+CI+YogClzS5ssgwFzdYG5IGn+SyhJNFcMBCp2vsyXqhSfuJTV97rL0LY3I
         OcxA==
X-Gm-Message-State: ACgBeo3vBvO4q+QS5GAo71KWip6B9MVvZ9fVxZm7XYFeuvf+ZV4Ei5Is
        2TOcHxhqJLlWmzmr7qtrUIw8G+NBupU=
X-Google-Smtp-Source: AA6agR5Q5fNAf++EwcnGT+aUtNbo5VR4lcoJFKOiZDUzNHDq2SQdbUFAoXX/hZmTLTGpCI9mIh0iG0iegj8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:1854:0:b0:41d:e04b:44fc with SMTP id
 20-20020a631854000000b0041de04b44fcmr22683994pgy.237.1661310126559; Tue, 23
 Aug 2022 20:02:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 24 Aug 2022 03:01:17 +0000
In-Reply-To: <20220824030138.3524159-1-seanjc@google.com>
Message-Id: <20220824030138.3524159-16-seanjc@google.com>
Mime-Version: 1.0
References: <20220824030138.3524159-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [RFC PATCH v6 15/36] KVM: nVMX: WARN once and fail VM-Enter if eVMCS
 sees VMFUNC[63:32] != 0
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org
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

WARN and reject nested VM-Enter if KVM is using eVMCS and manages to
allow a non-zero value in the upper 32 bits of VM-function controls.  The
eVMCS code assumes all inputs are 32-bit values and subtly drops the
upper bits.  WARN instead of adding proper "support", it's unlikely the
upper bits will be defined/used in the next decade.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/evmcs.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index ce358b13b75b..bd1dcc077c85 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -486,6 +486,14 @@ int nested_evmcs_check_controls(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 					       vmcs12->vm_entry_controls)))
 		return -EINVAL;
 
+	/*
+	 * VM-Func controls are 64-bit, but KVM currently doesn't support any
+	 * controls in bits 63:32, i.e. dropping those bits on the consistency
+	 * check is intentional.
+	 */
+	if (WARN_ON_ONCE(vmcs12->vm_function_control >> 32))
+		return -EINVAL;
+
 	if (CC(!nested_evmcs_is_valid_controls(vcpu, EVMCS_VMFUNC,
 					       vmcs12->vm_function_control)))
 		return -EINVAL;
-- 
2.37.1.595.g718a3a8f04-goog

