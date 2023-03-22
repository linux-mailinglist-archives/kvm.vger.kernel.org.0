Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 810B46C3FA2
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 02:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbjCVBQb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 21:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbjCVBQD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 21:16:03 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 505815A18D
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 18:15:38 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id b1-20020a63d301000000b0050726979a86so2616637pgg.4
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 18:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679447726;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=R3Ju8+L4fgF6abYzf02i1EjyBRNep0dilDxdCj7Ur6o=;
        b=a2vwCmIpZZBVMlv8zgK50uxkIS0xyvGrcbb26ooiKRDtEuoeDMNLY6bOohAPGj6Wlx
         2NnVJOjsLYTD3ZqBMs+ROUq33YaZWKwMLnjmyVbpvPv5gy89EbkBhZfD1r7vdOkSs+uv
         zPrTSZw/8EF8Md12lugEYzIWbquJESphU/VIWTXHmjT+OUkKW4/UpTtYBK//8g/W8i0d
         SGUWnmJU4A/AzbgvQXXygK4KrBVn+wkTWLRzSGy40vGVnlDmzLQJOJO/fDnZ3ED2hFES
         Zk9QVxtFz8G+YTDi6az4IydhtKPbdd8AZbFiU22II4Psb5KaepFptGo6J0c2cVWyNbyr
         SaYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679447726;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R3Ju8+L4fgF6abYzf02i1EjyBRNep0dilDxdCj7Ur6o=;
        b=ajWB7m7h5sAGGFiBotIcdqIgQkHB5GWr/wQ2YztttPUjFtRlqGClK6rVYp3yFPCoW4
         FXgpAe9E/ME0nW0q/zAXSQk4HXCo3S+5srfDpe1wzmnvR2g2HnNophQ4hlk5pJD7rPQy
         vsS7Z79/kB9RpKYF7UkVHv0s3YAeW9opS7Oze0IEjiq9u62qcrPE7+dyLYScUVwQbnSz
         RlWqGXlbLOUfaeF0yxfc5C2fka1yVcAryNJgDIryoxDCsWIuoJtj9BJEKl6LEdtc45hc
         H5+9vFKC3DggxQ3rw9QsaJETcI4XKN95tpzrSNec6sxm5gVPRqWZJ9YoqmLhcws9pvP8
         MDlw==
X-Gm-Message-State: AO0yUKXmBbXa9IUXqQW05YnKJBF42Q4hmvzopg2rPxxW9MDzSI2RwrNZ
        ApkBf6XqpkkRK2RVpdlX2AKAon/F+qw=
X-Google-Smtp-Source: AK7set8/rqQSOxX9RrLUOnnpg5r8vmhnjOz/0JynQasAjavBKAhr2J8mL71LNgEZ0KoBWyHP3YQsjBDlMSw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:ca8d:b0:234:ac9c:5daf with SMTP id
 y13-20020a17090aca8d00b00234ac9c5dafmr621856pjt.2.1679447726571; Tue, 21 Mar
 2023 18:15:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 21 Mar 2023 18:14:40 -0700
In-Reply-To: <20230322011440.2195485-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230322011440.2195485-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230322011440.2195485-7-seanjc@google.com>
Subject: [PATCH 6/6] KVM: SVM: Return the local "r" variable from svm_set_msr()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename "r" to "ret" and actually return it from svm_set_msr() to reduce
the probability of repeating the mistake of commit 723d5fb0ffe4 ("kvm:
svm: Add IA32_FLUSH_CMD guest support"), which set "r" thinking that it
would be propagated to the caller.

Alternatively, the declaration of "r" could be moved into the handling of
MSR_TSC_AUX, but that risks variable shadowing in the future.  A wrapper
for kvm_set_user_return_msr() would allow eliding a local variable, but
that feels like delaying the inevitable.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b32edaf5a74b..57f241c5a371 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2873,7 +2873,7 @@ static int svm_set_vm_cr(struct kvm_vcpu *vcpu, u64 data)
 static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	int r;
+	int ret = 0;
 
 	u32 ecx = msr->index;
 	u64 data = msr->data;
@@ -2995,10 +2995,10 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		 * guest via direct_access_msrs, and switch it via user return.
 		 */
 		preempt_disable();
-		r = kvm_set_user_return_msr(tsc_aux_uret_slot, data, -1ull);
+		ret = kvm_set_user_return_msr(tsc_aux_uret_slot, data, -1ull);
 		preempt_enable();
-		if (r)
-			return 1;
+		if (ret)
+			break;
 
 		svm->tsc_aux = data;
 		break;
@@ -3056,7 +3056,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 	default:
 		return kvm_set_msr_common(vcpu, msr);
 	}
-	return 0;
+	return ret;
 }
 
 static int msr_interception(struct kvm_vcpu *vcpu)
-- 
2.40.0.rc2.332.ga46443480c-goog

