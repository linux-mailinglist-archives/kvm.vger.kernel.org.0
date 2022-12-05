Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69DFF6431A7
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 20:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233417AbiLETPj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 14:15:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232941AbiLETO5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 14:14:57 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C017524969
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 11:14:53 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id m1-20020a170902db0100b00188eec2726cso14289251plx.18
        for <kvm@vger.kernel.org>; Mon, 05 Dec 2022 11:14:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=haByyceKJWB+cgKcNzI60WZQl7ol6OvvP12PsU634AM=;
        b=UpTzq08wsqQJktYr+KIw6hw9sTIJkTLd7BjtKjqJFSpRyZLyqGIwJmzJagCzhVJgLT
         dz0i4deptTX/zT4qLeZhIHm87PjITHV2eLoz6vBGeKh2d67Kof0V3AMNg50MiLEriiZE
         30kB2AtEEbl0qUWyDM2PqdzZemtuy1P+D/KQYcyqvLg75Dfu8BTa0BeS6LqHW+8Fy5+J
         XH2QjiDqnQUp/lI356/4U6IQVR4I0xM56e41GN7a5ICrpH91J874fR0Bzo7QSQJFU6GB
         58vz+Gqz9ktFTuCKycU1HfweXL7tJ9v1Exsh+I4Vg4QHyHkOSu3ovcuZhguRJNwy7LWn
         dSmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=haByyceKJWB+cgKcNzI60WZQl7ol6OvvP12PsU634AM=;
        b=5mrWkUJ/sd9nTJAieulWF40UJ0dnOpGQ5cdjTSYkDMCWjKONQlfNjgIoc0iPIVPRYm
         8HkWymxc03sJ7sRLdCjjLCoVNPzqIB37sW3sXhO7PThGoJWHjAil/V3R1aLfV0e1EU3+
         aH5ykTAHu7nAeOjgc+cWhDzBhKR28g4Gld2zUsTGpjUUJqF042b1vN/SRk2N4vXjnBW9
         BXiwjMQ3izOWRMkC3qYRMCm3GQHAv+I956phHbZzV93/Nt80qjFr/uTFStuBpXtyyRml
         +Bpy/ubBAWYOvpfsIt6HHobkDv90cSxNnK6e02+qXV/aaYnjKCDtY1Q3xZMp7gUvGSPw
         FouQ==
X-Gm-Message-State: ANoB5pnzOYPqgiAQALM0+ApAEkekkELI12b7bn7aiZ8qYBaRDTkG3//T
        gF+Mfj5JXKnaA2sQ3Rb2QUqE/yX9vmj/
X-Google-Smtp-Source: AA0mqf5ZFHZNZ/bIMOAEPRAf99BvuefZXx0yUpSgNehJ0J7TK/xDchHHZphKcJTR/WV3CTgweVsl9NjDQRbS
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:90a:8b03:b0:213:16d2:4d4c with SMTP id
 y3-20020a17090a8b0300b0021316d24d4cmr91957773pjn.70.1670267693380; Mon, 05
 Dec 2022 11:14:53 -0800 (PST)
Date:   Mon,  5 Dec 2022 11:14:25 -0800
In-Reply-To: <20221205191430.2455108-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221205191430.2455108-1-vipinsh@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221205191430.2455108-9-vipinsh@google.com>
Subject: [Patch v3 08/13] KVM: x86: hyper-v: Use common code for hypercall
 userspace exit
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, vkuznets@redhat.com,
        dmatlack@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>
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

Remove duplicate code to exit to userspace for hyper-v hypercalls and
use a common place to exit.

No functional change intended.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

---
 arch/x86/kvm/hyperv.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 283b6d179dbe..2eb68533d188 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2521,14 +2521,7 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
 		}
-		vcpu->run->exit_reason = KVM_EXIT_HYPERV;
-		vcpu->run->hyperv.type = KVM_EXIT_HYPERV_HCALL;
-		vcpu->run->hyperv.u.hcall.input = hc.param;
-		vcpu->run->hyperv.u.hcall.params[0] = hc.ingpa;
-		vcpu->run->hyperv.u.hcall.params[1] = hc.outgpa;
-		vcpu->arch.complete_userspace_io =
-				kvm_hv_hypercall_complete_userspace;
-		return 0;
+		goto hypercall_userspace_exit;
 	case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST:
 		if (unlikely(hc.var_cnt)) {
 			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
@@ -2587,14 +2580,7 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 			ret = HV_STATUS_OPERATION_DENIED;
 			break;
 		}
-		vcpu->run->exit_reason = KVM_EXIT_HYPERV;
-		vcpu->run->hyperv.type = KVM_EXIT_HYPERV_HCALL;
-		vcpu->run->hyperv.u.hcall.input = hc.param;
-		vcpu->run->hyperv.u.hcall.params[0] = hc.ingpa;
-		vcpu->run->hyperv.u.hcall.params[1] = hc.outgpa;
-		vcpu->arch.complete_userspace_io =
-				kvm_hv_hypercall_complete_userspace;
-		return 0;
+		goto hypercall_userspace_exit;
 	}
 	default:
 		ret = HV_STATUS_INVALID_HYPERCALL_CODE;
@@ -2603,6 +2589,15 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 
 hypercall_complete:
 	return kvm_hv_hypercall_complete(vcpu, ret);
+
+hypercall_userspace_exit:
+	vcpu->run->exit_reason = KVM_EXIT_HYPERV;
+	vcpu->run->hyperv.type = KVM_EXIT_HYPERV_HCALL;
+	vcpu->run->hyperv.u.hcall.input = hc.param;
+	vcpu->run->hyperv.u.hcall.params[0] = hc.ingpa;
+	vcpu->run->hyperv.u.hcall.params[1] = hc.outgpa;
+	vcpu->arch.complete_userspace_io = kvm_hv_hypercall_complete_userspace;
+	return 0;
 }
 
 void kvm_hv_init_vm(struct kvm *kvm)
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

