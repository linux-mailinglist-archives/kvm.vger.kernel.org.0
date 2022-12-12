Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 385A564A73B
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 19:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233684AbiLLSiR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 13:38:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233595AbiLLShi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 13:37:38 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E120B13CDC
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 10:37:37 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 203-20020a2502d4000000b006f94ab02400so13763666ybc.2
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 10:37:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vf/4eKFN2BbTxHb9vSu7n9IRkdIgNgMrNUGeFPcCE4E=;
        b=BLucr3TOr4Bc81H7R2ZUt5urqtyzKGHpHVmCLY3m5X8tCgclyt7rcfkYgPpZKVyhDI
         ccWWN5ADIFdK/w4cH9XNqcJYyQSbbzzcjhP/o+UoDov7EtvOasfnQhOspHFDk19FqsJQ
         rAX+tZe/9NBgVMPYwg+WQhMhadIBmZxsovpzHXT3OpQa9UfgjviRGMeIjtWiifN3P7OP
         6JwROifeI4hBy9qxiZdbku/6HsGFZewkr32tdt6KTThRUrFeXi6nAgV/kIlbi3ZSZn37
         CP47IoogJE3psblBjwdEBahqr7ipUpKAMvE6Ah+b5wEj5gPVqDdAVqRFMyh4uraC5cc6
         gQ4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vf/4eKFN2BbTxHb9vSu7n9IRkdIgNgMrNUGeFPcCE4E=;
        b=ul7dG4wFukvzwXSBzu67xT7Leii+FQmEAccnKLiAnxucUKnufT0mEJrStB3LG4/wee
         8zNA24IJxbBuptlaRmn0iDCzv9b8JFduWmtVNddwWIEfBUGVOU3R1GzoSOVi3uzRHpuX
         n5OVU2XkGRvQGHsNpL+PnpqrMLg7uXlZgAx3YI2GY+qxdCz5M4aJTx1KpFNIYSuX7Tih
         odhPCkizmv/oZjxMe9RVyQOOiyUlMrgtg8mS1zwqZdV65KpDDsUoTum9gXXLi++Elv6V
         7ITx+PrFrWOgERgSsY6/aQ+9ei2BJgEWMe7HJuGHyiYXE+ZFzLtz/vzOdJyOugy8KW3h
         sdlg==
X-Gm-Message-State: ANoB5plWAHwAEVPo+E7oFFCBTmDMuKB8heYLUmFBRoLkt8cCrLuosEH5
        ctoblYbrzKdY8Rm8HvlDKbNQrPbGkmvW
X-Google-Smtp-Source: AA0mqf5LJkMrFemYHXdnf93jGHta9bxWD79MNL5HSG+3JVISIbOn4b2wQCsBbDKuTNzb5haaQiD5GGA+PGwm
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a05:6902:91b:b0:6dd:313b:9b30 with SMTP id
 bu27-20020a056902091b00b006dd313b9b30mr95149913ybb.618.1670870257178; Mon, 12
 Dec 2022 10:37:37 -0800 (PST)
Date:   Mon, 12 Dec 2022 10:37:15 -0800
In-Reply-To: <20221212183720.4062037-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221212183720.4062037-1-vipinsh@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221212183720.4062037-9-vipinsh@google.com>
Subject: [Patch v4 08/13] KVM: x86: hyper-v: Use common code for hypercall
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
2.39.0.rc1.256.g54fd8350bd-goog

