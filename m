Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46DE64D58E4
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 04:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346020AbiCKD3O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 22:29:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346006AbiCKD3I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 22:29:08 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E5BEEAC83
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 19:28:06 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id p15-20020a17090a748f00b001bf3ba2ae95so4514096pjk.9
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 19:28:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=05/9tl1rLPgUBreYUw7eEtnH71YqeV4kQqIYEJJG048=;
        b=mTFhxyAL3l7jFh6smGX49alsnQYJtzV77gVFS1xKNxi+Ww+Y4j3A4/X0QodMpGbt3h
         nzocS9cCTkxKrB4aI/RpCWlONph10GWM+igP3L2vZj+8dBxmt5R2Qx7UUaYidHLbMSME
         5HgxOL+4uS4+ZF4bVTYTow3BtyBBN+z9UTVgK4eh6++p+5tKhwoUzchO1BkQsBVXLcO6
         aKeqa18iXa1g8o9OGezwfdUfGFxMnGJD0GFjJzcZ+eAwjK04cdNPg7KQn3pNCC/Z6h76
         YAmuYiFnn1C4MXcESZi4iHNgDRA+AoaYYCXAgX3vEr2NeCzun+u5/w/1xoz3GRJI3FLi
         QBNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=05/9tl1rLPgUBreYUw7eEtnH71YqeV4kQqIYEJJG048=;
        b=tMGx2+WZeEw4p2uWRP9uGBBB8fA4oleownLXhsEM41rC64VuMSmqV04sCctj+TU/Z1
         qDFh/lcJ7YRdLfIHX4iOGcBa0cCkiiK9V6N1kVDtF6P72Ve4BJuVROhvExrQO+/woJ0U
         by+wj3ixl7cZ9DlRLgG8Mg4Ws90GEk9oteCwlt20/s58GlIndTJP17xkQoNb9/aDLsB3
         +vgPTUBCAa14SJyk38K5CWwjxWPnZxQCiaDm+IXn6kloAdFE8GvcMW4zyxfW63bRx0mi
         9Yp3mW/7aUY0mJb064fTrBWpJL4uCC+vAvhkuy8/XF5uxTTZTzOEaSSD4LEjHcLt1DAf
         qFwQ==
X-Gm-Message-State: AOAM531dCk2ujoCq0IxYGNx9xG6HNgNTR6lRFZzwNv4qzbRgmiUly06C
        nHwcTe3BC/qT9igmldARog9NWHZ1aTI=
X-Google-Smtp-Source: ABdhPJxHI4xHm2rn6sArcUXsyJPhkn5IvKDkgnSWCGlQa5SEghkMuvBVwOq39SUscIuYo0+UjDC5n6k72NI=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4d81:b0:1bf:8ce4:4f51 with SMTP id
 oj1-20020a17090b4d8100b001bf8ce44f51mr404030pjb.0.1646969285541; Thu, 10 Mar
 2022 19:28:05 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 11 Mar 2022 03:27:41 +0000
In-Reply-To: <20220311032801.3467418-1-seanjc@google.com>
Message-Id: <20220311032801.3467418-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220311032801.3467418-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH 01/21] KVM: x86: Return immediately from x86_emulate_instruction()
 on code #DB
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
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

Return immediately if a code #DB is encountered during instruction
emulation, code #DBs have fault-like behavior and are higher priority
than any exceptions that occur on the code fetch itself, and obviously
should prevent decode/execution.

Fixes: 4aa2691dcbd3 ("KVM: x86: Factor out x86 instruction emulation with decoding")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4fa4d8269e5b..feacc0901c24 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8212,7 +8212,7 @@ int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_skip_emulated_instruction);
 
-static bool kvm_vcpu_check_breakpoint(struct kvm_vcpu *vcpu, int *r)
+static bool kvm_vcpu_check_code_breakpoint(struct kvm_vcpu *vcpu, int *r)
 {
 	if (unlikely(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) &&
 	    (vcpu->arch.guest_debug_dr7 & DR7_BP_EN_MASK)) {
@@ -8281,25 +8281,23 @@ static bool is_vmware_backdoor_opcode(struct x86_emulate_ctxt *ctxt)
 }
 
 /*
- * Decode to be emulated instruction. Return EMULATION_OK if success.
+ * Decode an instruction for emulation.  The caller is responsible for handling
+ * code breakpoints.  Note, manually detecting code breakpoints is unnecessary
+ * (and wrong) when emulating on an intercepted fault-like exception[*], as
+ * code breakpoints have higher priority and thus have already been done by
+ * hardware.
+ *
+ * [*] Except #MC, which is higher priority, but KVM should never emulate in
+ *     response to a machine check.
  */
 int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,
 				    void *insn, int insn_len)
 {
-	int r = EMULATION_OK;
 	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
+	int r;
 
 	init_emulate_ctxt(vcpu);
 
-	/*
-	 * We will reenter on the same instruction since we do not set
-	 * complete_userspace_io. This does not handle watchpoints yet,
-	 * those would be handled in the emulate_ops.
-	 */
-	if (!(emulation_type & EMULTYPE_SKIP) &&
-	    kvm_vcpu_check_breakpoint(vcpu, &r))
-		return r;
-
 	r = x86_decode_insn(ctxt, insn, insn_len, emulation_type);
 
 	trace_kvm_emulate_insn_start(vcpu);
@@ -8332,6 +8330,15 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	if (!(emulation_type & EMULTYPE_NO_DECODE)) {
 		kvm_clear_exception_queue(vcpu);
 
+		/*
+		 * Return immediately if RIP hits a code breakpoint, such #DBs
+		 * are fault-like and are higher priority than any faults on
+		 * the code fetch itself.
+		 */
+		if (!(emulation_type & EMULTYPE_SKIP) &&
+		    kvm_vcpu_check_code_breakpoint(vcpu, &r))
+			return r;
+
 		r = x86_decode_emulated_instruction(vcpu, emulation_type,
 						    insn, insn_len);
 		if (r != EMULATION_OK)  {
-- 
2.35.1.723.g4982287a31-goog

