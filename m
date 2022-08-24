Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9D6259F1B9
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 05:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234527AbiHXDEO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 23:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234326AbiHXDDd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 23:03:33 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B55ED81B34
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:10 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id q6-20020a17090311c600b0017266460b8fso10123996plh.4
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=YM7JSeVcS+HwQdrx/vBWzPhi0KTmrUluEtn+awxo6AQ=;
        b=nz1PVYqvFMt9vNH/OnwmO+jkIyK4grXfn7MjvxSyvJUqwg3ICWzYG4a5F/xBR9Mg9t
         1TKmniazUdE/xP5lzkeAWsCJB5C88Njfx0cXcYPsdyMZjboFD3BHrbQN7jHWEw8HlTwu
         ii1xyA8cQT4RbyiMnZ6URV/ZQEQmSYhO3V8lq0b856WwIatEdnZQq2EryVv8gGdTMF3l
         b9FkHBCIEzZXE5nL/CUeIhmk6fMOcpSp6ExuEwPH4ZRLSDbQZqkzoAdYJFxDd/l1+i9Y
         D09m8H+Gw+4TWpfu18bQVbLEZDzDk5T+akQV1KNETWv0wX8VGcGskAuDP7G9OQCsIb8F
         uiGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=YM7JSeVcS+HwQdrx/vBWzPhi0KTmrUluEtn+awxo6AQ=;
        b=nCJAR6+EEeUpvq/U4PNQbSsFtYbx/zDSKP5c8uRXfcSsMs5QsGDL29bxCyFbyJOFm4
         IOtTfSd3ObqkkToa5112/zWDTl9grUGKbNDoutjY9OtNqHR+Pk4vHpQThiLtOs3ShxDo
         5J2C/C99blXB5mOG6P3aXISFDPhPmqUVrteD6LhyuaXiKb1tVqITKFtAH1NxYcKECKDk
         AhP483QPw07IL8QJ/tyugaAj2g8OUVM5kYgF/a0bDn2auVoeEZGBLHFiNIC4UW5HXGH9
         Jwa0SJhXhcuk4LO2uN92Hv5GZQLtK1uMMIZ14e0kI7UuXQJIZtBjNu2NV2X+/Ns1wuqG
         y2Lw==
X-Gm-Message-State: ACgBeo1dCMwnTfxg322bEzWxfYleb0uGgrNfk/Xa/tAlyu4rLKv7+8tg
        M7snGIh5HdX2ytGIUtV0vcV4j2nyR24=
X-Google-Smtp-Source: AA6agR4ismyR8tcM7v3iIG+Y4p7YUQbe+jeFc5trchChOk0L2qUE7cuYbY4g00pV+ZPJteJKiL8rd0ixQ+Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:708b:b0:172:5267:ed95 with SMTP id
 z11-20020a170902708b00b001725267ed95mr26352404plk.3.1661310129997; Tue, 23
 Aug 2022 20:02:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 24 Aug 2022 03:01:19 +0000
In-Reply-To: <20220824030138.3524159-1-seanjc@google.com>
Message-Id: <20220824030138.3524159-18-seanjc@google.com>
Mime-Version: 1.0
References: <20220824030138.3524159-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [RFC PATCH v6 17/36] KVM: nVMX: Support TSC scaling with enlightened VMCS
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

From: Vitaly Kuznetsov <vkuznets@redhat.com>

Enlightened VMCS v1 got updated and now includes the required fields for
TSC scaling, enable TSC scaling for both KVM-on-HyperV and HyperV-on-KVM
simply by dropping the relevant fields from the unsupported controls.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
[sean: split to separate patch (from PERF_GLOBAL_CTRL)]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/evmcs.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
index 35b326386c50..a2e21bdd17bb 100644
--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/evmcs.h
@@ -38,8 +38,6 @@ DECLARE_STATIC_KEY_FALSE(enable_evmcs);
  *	EPTP_LIST_ADDRESS               = 0x00002024,
  *	VMREAD_BITMAP                   = 0x00002026,
  *	VMWRITE_BITMAP                  = 0x00002028,
- *
- *	TSC_MULTIPLIER                  = 0x00002032,
  *	PLE_GAP                         = 0x00004020,
  *	PLE_WINDOW                      = 0x00004022,
  *	VMX_PREEMPTION_TIMER_VALUE      = 0x0000482E,
@@ -57,7 +55,6 @@ DECLARE_STATIC_KEY_FALSE(enable_evmcs);
 	 SECONDARY_EXEC_ENABLE_PML |					\
 	 SECONDARY_EXEC_ENABLE_VMFUNC |					\
 	 SECONDARY_EXEC_SHADOW_VMCS |					\
-	 SECONDARY_EXEC_TSC_SCALING |					\
 	 SECONDARY_EXEC_PAUSE_LOOP_EXITING)
 #define EVMCS1_UNSUPPORTED_VMEXIT_CTRL					\
 	(VM_EXIT_SAVE_VMX_PREEMPTION_TIMER)
-- 
2.37.1.595.g718a3a8f04-goog

