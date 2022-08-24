Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0C1359F1CE
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 05:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234337AbiHXDFO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 23:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234505AbiHXDED (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 23:04:03 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7761A58514
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:41 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 92-20020a17090a09e500b001d917022847so6795661pjo.1
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=csCbCxIReP761ib0zT+oUGx1HfGHgD0Oi0ert9+tdiQ=;
        b=XI/+o4a4lmQd0rP4+Xz51pinZ7zlj/xGWnMklfu8ZaUxVpkoaUy8MTttECeGCE2jnG
         qEnj+dugnb0difCsRLAxIM7b03X3lJOOKln2DEOJBcBpICPfH8UUAHFDBR3tAiUHE5fz
         roJOtgZSoojjckp0WXzZWPkRtO2sk7h/A9Sp0PJqGsZsvn6Cqt53GrdhakUEw4giBN7Z
         wHSSKU0oaHf5hz+0O3ZLRV7oRg/bRPwg10w7693Ma2kdxR6gl+6N6PS9KdWmp3dxXnxB
         oSMI2xfvol88Sp+uR6DpD2YVrxtcH0M7qBnPAeLCVH6oq2S2kGxHXPccn4L7lBiEnlP1
         QCMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=csCbCxIReP761ib0zT+oUGx1HfGHgD0Oi0ert9+tdiQ=;
        b=hW3dVVw0vddHU1EPkjKVE+RqKIaKdVs5JKQwvkinV3eP3/809BaEpu3Zk9qAqDQDw0
         1xzjc/kJSlAMG29uONR+dfxjFk9pquz5YFA+mOm5SCk1detwkMMfbbo89/KXJ/jT0bIP
         iVO6phMpFe4HnvH9RJPmjGb4ii4vrdXs/GjC39mWG7n8Aoi7Bk7KFZnwEO3xyOfOItQH
         c0vC0PZMRiVBhNcaZjkTG7eOSYuHxkcXlETVU7tBGpMg0YxxzqJb31fm0FBD9ikOYhqP
         xE9KzpAjNPz3nr1Z9RzIzZiEjcLbYHBQWVhycKgvW7rwbIXVt8B0htbcS+Ph9dPAUley
         /haA==
X-Gm-Message-State: ACgBeo0MkZLqxIxdUgvORnVYM5shEBig33fpm4GyTkjh9EMA5vn8MW/p
        kMbSiibRQadKnU+yAaBTKZkjiI+QSUo=
X-Google-Smtp-Source: AA6agR42B79jEwtImhmcYslnftcjYQNCm3oyo6VBDFMcYQEm5srRDerjiqXvgJ2oFxhDfAeyu9zDYx+b8h0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f68d:b0:16f:2314:7484 with SMTP id
 l13-20020a170902f68d00b0016f23147484mr26131962plg.136.1661310161228; Tue, 23
 Aug 2022 20:02:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 24 Aug 2022 03:01:38 +0000
In-Reply-To: <20220824030138.3524159-1-seanjc@google.com>
Message-Id: <20220824030138.3524159-37-seanjc@google.com>
Mime-Version: 1.0
References: <20220824030138.3524159-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [RFC PATCH v6 36/36] KVM: nVMX: Use cached host MSR_IA32_VMX_MISC
 value for setting up nested MSR
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

vmcs_config has cached host MSR_IA32_VMX_MISC value, use it for setting
up nested MSR_IA32_VMX_MISC in nested_vmx_setup_ctls_msrs() and avoid the
redundant rdmsr().

No (real) functional change intended.

Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 6208cdebd173..a9d51afde502 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6757,10 +6757,7 @@ void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
 		msrs->secondary_ctls_high |= SECONDARY_EXEC_ENCLS_EXITING;
 
 	/* miscellaneous data */
-	rdmsr(MSR_IA32_VMX_MISC,
-		msrs->misc_low,
-		msrs->misc_high);
-	msrs->misc_low &= VMX_MISC_SAVE_EFER_LMA;
+	msrs->misc_low = (u32)vmcs_conf->misc & VMX_MISC_SAVE_EFER_LMA;
 	msrs->misc_low |=
 		MSR_IA32_VMX_MISC_VMWRITE_SHADOW_RO_FIELDS |
 		VMX_MISC_EMULATED_PREEMPTION_TIMER_RATE |
-- 
2.37.1.595.g718a3a8f04-goog

