Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 014825A7192
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 01:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbiH3XRk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 19:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231634AbiH3XRE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 19:17:04 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD2965645
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:16:24 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id h5-20020a636c05000000b00429fa12cb65so6216086pgc.21
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=oyW7O7dkTIafWDUZOYrTaY9ovl5H6kG4zyO9ErNBcPI=;
        b=hwErrU1ofUzrYXdyH0PkH68mxDp8A9BaOVU+rzLX5I4bY2Z5eqvshEjY4dJhn+a2aD
         Gvhl8y3skY8RsUeN+iq6ql/3LQKpiGlMYg0gCdif2IaOgdIDz6bcwgiSdRxE3HdA5xNd
         w3PONsSumD+65Ksda4OOHNgOzhsmF6C3e82m+rzYXPYruvp1QVhuZI5HeGbh+L0VfQpk
         X2Lr0I/RKwaFoeOo169mfJ+f+5A8kftH9M27MVeCsF//iO5eMJCUGIN0jJAWMN0PDR1Q
         oxO4xAupt6PcgQEiOIIh7jdYdlq97TurBpC4HHP29dYI7qS+G+XmqL7VZx5Cpznj6zkF
         0oJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=oyW7O7dkTIafWDUZOYrTaY9ovl5H6kG4zyO9ErNBcPI=;
        b=ns7hgQKF4VXOTZ+lICVu3KqeSYO79VZMnXxjOHOIGOIvwo/DYJZaXx1jJUyUKcqDOu
         so2MInmG9typlsknPOzXE2cpSv3QbzvZgZlmPpLyAp8aR8I+F2I4vWp7uO9eojJpT7PI
         4hUmDYoMHnzwHANHJwdG1OSvczksmWKpTS6itqUC5EIMvM8QRil3nyK3YaUUZ6AWaa48
         UHdYhFvDlrKq54GC1ErGOGD0jTLaLmN3CMx+rWQbJe2hN6qSq155D67Ek2IFnbl1c3uj
         1cLQ3CrKV1/BVTDxzsZ5A32obUnmUB/dBQyXsmbGqjp0NTC3V+voNCgaQ+O3kXF+CmrI
         ud2g==
X-Gm-Message-State: ACgBeo35YcWGw2g1dA6UY4O/AWhaxcNnBoleTSR543oubmxRRhinaim7
        gqim1ULzOePuMEFO38hB9yYVvGcI9SM=
X-Google-Smtp-Source: AA6agR7eQvqhd8VBnSv0zbkGPCB4IhAa75nWv7zObskXK/ex2k3GyizECsiOOHH/Isvxfi5+eU9jJws7lqo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:8248:0:b0:42b:b607:f74f with SMTP id
 w69-20020a638248000000b0042bb607f74fmr13880045pgd.70.1661901383579; Tue, 30
 Aug 2022 16:16:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 30 Aug 2022 23:15:51 +0000
In-Reply-To: <20220830231614.3580124-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220830231614.3580124-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220830231614.3580124-5-seanjc@google.com>
Subject: [PATCH v5 04/27] KVM: x86: Allow clearing RFLAGS.RF on forced
 emulation to test code #DBs
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extend force_emulation_prefix to an 'int' and use bit 1 as a flag to
indicate that KVM should clear RFLAGS.RF before emulating, e.g. to allow
tests to force emulation of code breakpoints in conjunction with MOV/POP
SS blocking, which is impossible without KVM intervention as VMX
unconditionally sets RFLAGS.RF on intercepted #UD.

Make the behavior controllable so that tests can also test RFLAGS.RF=1
(again in conjunction with code #DBs).

Note, clearing RFLAGS.RF won't create an infinite #DB loop as the guest's
IRET from the #DB handler will return to the instruction and not the
prefix, i.e. the restart won't force emulation.

Opportunistically convert the permissions to the preferred octal format.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fead0e8cd3e3..7403221c868e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -173,8 +173,13 @@ bool __read_mostly enable_vmware_backdoor = false;
 module_param(enable_vmware_backdoor, bool, S_IRUGO);
 EXPORT_SYMBOL_GPL(enable_vmware_backdoor);
 
-static bool __read_mostly force_emulation_prefix = false;
-module_param(force_emulation_prefix, bool, S_IRUGO);
+/*
+ * Flags to manipulate forced emulation behavior (any non-zero value will
+ * enable forced emulation).
+ */
+#define KVM_FEP_CLEAR_RFLAGS_RF	BIT(1)
+static int __read_mostly force_emulation_prefix;
+module_param(force_emulation_prefix, int, 0444);
 
 int __read_mostly pi_inject_timer = -1;
 module_param(pi_inject_timer, bint, S_IRUGO | S_IWUSR);
@@ -7255,6 +7260,8 @@ int handle_ud(struct kvm_vcpu *vcpu)
 	    kvm_read_guest_virt(vcpu, kvm_get_linear_rip(vcpu),
 				sig, sizeof(sig), &e) == 0 &&
 	    memcmp(sig, kvm_emulate_prefix, sizeof(sig)) == 0) {
+		if (force_emulation_prefix & KVM_FEP_CLEAR_RFLAGS_RF)
+			kvm_set_rflags(vcpu, kvm_get_rflags(vcpu) & ~X86_EFLAGS_RF);
 		kvm_rip_write(vcpu, kvm_rip_read(vcpu) + sizeof(sig));
 		emul_type = EMULTYPE_TRAP_UD_FORCED;
 	}
-- 
2.37.2.672.g94769d06f0-goog

