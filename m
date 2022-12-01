Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86BF763FC0B
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 00:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbiLAX27 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 18:28:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231863AbiLAX2Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 18:28:24 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84340CF783
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 15:27:27 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id b17-20020a25b851000000b006e32b877068so3327217ybm.16
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 15:27:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Sg9CsRxM4jZa0E7/KgshS4sdVS6EzlxV440C3ZXBs0s=;
        b=rYmAuULP73HrorSXL/MXkPO2BOATv/miT4OfDFVrD8TkA1qSe6/IIl8YrljhxYVpYH
         YwsWmcYp1eSR4JNDQ2YGoIJdEhu1rDp37/CF+HbhwLUN65HbY0WGBFa5ctKoY79gc0ef
         JDhgX4BKJI/y7kAOm1tQe0DyfyVKKCc+vwpJktXvrTD9/e7fexqQ258M0oKiEKrWf2e5
         kr6+lUd1xeyAEBE/yV2MYvZHUncP1Xp+C4RY9HVn8RnATVHHs9GDjuoxCC1PHFavaKQl
         glgmwU6SVos0A27SE07k1IR8yDx4s9WboVRX0zWUVbkd4pJs0St7c5abpQqZq3hxqlRU
         TjmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Sg9CsRxM4jZa0E7/KgshS4sdVS6EzlxV440C3ZXBs0s=;
        b=njfj9TM5K1QoqdfCqzzcIE87ildT9bY+afJyOHIMRw1OYICmoelm8MDsZ+v1AFuXn1
         zeu5cJ2OtiXcHZEUUckxo7PdVSGRbhvAdLOrz+2Myq3i565ewS0lqMjML1aqyZ4sWk8j
         5Svc2ER/wZ4lBESpDzxYWrTTRzN8XjnG0tikrmVOnyWEbEkVJcgUjhKJln3AJ4vyvB9Y
         6L/QrHdKt0cWfT9FzZ6BbEvpthmUG8+6wF72Sh0jVcQcvseA+F5mQGkiulaUKFSNx1sI
         Lcmpt/Embt4ZshxezgQ6I2wrkLDAiKkUTd6oYNE80Bng/kBbMXYSdAhITbPnRHvHQMAz
         wEVQ==
X-Gm-Message-State: ANoB5plzgnJxyCC+0aRWaXR38qgQw+AKGICPgcW/qCkbCeMb46bdXDly
        Vt3ihyeUSPOWvlpMlwAbfGASr3cUIy8=
X-Google-Smtp-Source: AA0mqf4Vb7jVCySVqyHIb2RgwHxQmPFL3B44Hbkl8hGjWW/Knam+udRj69vxcylPzQTcX5+lQQ+iVC126vI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:c0d:0:b0:6fb:935d:bcc7 with SMTP id
 f13-20020a5b0c0d000000b006fb935dbcc7mr6530196ybq.130.1669937247256; Thu, 01
 Dec 2022 15:27:27 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  1 Dec 2022 23:26:54 +0000
In-Reply-To: <20221201232655.290720-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221201232655.290720-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221201232655.290720-16-seanjc@google.com>
Subject: [PATCH 15/16] KVM: x86: Force kvm_rebooting=true during emergency reboot/crash
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Andrew Cooper <Andrew.Cooper3@citrix.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set kvm_rebooting when virtualization is disabled in an emergency so that
KVM eats faults on virtualization instructions even if kvm_reboot() isn't
reached.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 2 ++
 arch/x86/kvm/vmx/vmx.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2aec27b34487..08ed4679903a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -592,6 +592,8 @@ static inline void kvm_cpu_svm_disable(void)
 
 static void svm_emergency_disable(void)
 {
+	kvm_rebooting = true;
+
 	kvm_cpu_svm_disable();
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8be99651dcc9..7f8147a7d126 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -770,6 +770,8 @@ static void vmx_emergency_disable(void)
 	int cpu = raw_smp_processor_id();
 	struct loaded_vmcs *v;
 
+	kvm_rebooting = true;
+
 	list_for_each_entry(v, &per_cpu(loaded_vmcss_on_cpu, cpu),
 			    loaded_vmcss_on_cpu_link)
 		vmcs_clear(v->vmcs);
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

