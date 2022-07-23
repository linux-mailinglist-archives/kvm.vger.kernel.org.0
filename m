Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3369F57EAC3
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 02:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236722AbiGWAwL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 20:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236535AbiGWAv5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 20:51:57 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF168AEEE
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 17:51:52 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-31e55518830so51101687b3.23
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 17:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=CRV49EpunAiwzO7EUQf5uuxbCrNu29jLzCse2H7RuXc=;
        b=c4OhMoRdJJpj8Re9fEOkPZtmzB/dBJ4KFgrGtN3LWRpkWFBvNcpeCZBSL4aAWcYCki
         Qb6HSQ6WlUba6RIm/3e1UASfPJC/8qojnfgyNJP9KmikUVumKKNenZr/WzD9hCcaz37+
         gQzL0XjuNZh0gdojlMcl4VoDcQvE9bM99Zaxckc9m3aUQitP6RQ+veZOltTqHhZU+7zb
         tOZD3DgnOzvc9He0UpgCBz91rH0vkzt1WOOMHstLoRkCsfEdre8wXI13KPJJCYxYTHFD
         rtj2qjZSAmxccJJ3hruDF5+KTBhvT8mkXb3Ymr+DUJ2ZOonaMlnlqvtl47uZXs6boHAd
         +Vbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=CRV49EpunAiwzO7EUQf5uuxbCrNu29jLzCse2H7RuXc=;
        b=kRME9HAjTELthFfksJdFLs8riuRow8cNEjYMXWNkNcZ1CL3YKwCax4fSHjh+P875ft
         Dum0lWIm+ejLRw2bCG3SMwTlt0hAMIjjxhz/NxSvxFF3QrTOVgVikIxWRH2uHfQ4dAzs
         aZ0Xro4mzN+Ae3Zoh7l1kknsardOFD4MszUtNlhhCq79LncDyDvz9afVRe2XjJaKHv6W
         8gACfxbH5VyXgafbh2uCP8LEQbffYq//qJ62ztCqh3S+XeN1CjAh6hXLQPCnbJtfeO5Z
         JK+7p+zQKiTciljNgKSybQVzf2Qa3A3rrZdBDMQh2pocTF0OS0eudud3JjNXDb+zXfTa
         hoBA==
X-Gm-Message-State: AJIora+inwtKvKEwXhWrtGiWu57Gyc2HXS0tPa5xAtzPItfX2c+MHWkc
        IUx1ZmVE4D5cZuiubLinpfgsx9MbTYM=
X-Google-Smtp-Source: AGRyM1uHvgXaZ2c/91aauxBZFNtIhC3sObIgwcUCYoFubQr5z9HKWdAhXjdpatBXsBJXAt9u8lVwIUReu5g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:d909:0:b0:31e:6adb:95f4 with SMTP id
 b9-20020a0dd909000000b0031e6adb95f4mr2072072ywe.355.1658537511856; Fri, 22
 Jul 2022 17:51:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 23 Jul 2022 00:51:19 +0000
In-Reply-To: <20220723005137.1649592-1-seanjc@google.com>
Message-Id: <20220723005137.1649592-7-seanjc@google.com>
Mime-Version: 1.0
References: <20220723005137.1649592-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v4 06/24] KVM: x86: Treat #DBs from the emulator as fault-like
 (code and DR7.GD=1)
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a dedicated "exception type" for #DBs, as #DBs can be fault-like or
trap-like depending the sub-type of #DB, and effectively defer the
decision of what to do with the #DB to the caller.

For the emulator's two calls to exception_type(), treat the #DB as
fault-like, as the emulator handles only code breakpoint and general
detect #DBs, both of which are fault-like.

For event injection, which uses exception_type() to determine whether to
set EFLAGS.RF=1 on the stack, keep the current behavior of not setting
RF=1 for #DBs.  Intel and AMD explicitly state RF isn't set on code #DBs,
so exempting by failing the "== EXCPT_FAULT" check is correct.  The only
other fault-like #DB is General Detect, and despite Intel and AMD both
strongly implying (through omission) that General Detect #DBs should set
RF=1, hardware (multiple generations of both Intel and AMD), in fact does
not.  Through insider knowledge, extreme foresight, sheer dumb luck, or
some combination thereof, KVM correctly handled RF for General Detect #DBs.

Fixes: 38827dbd3fb8 ("KVM: x86: Do not update EFLAGS on faulting emulation")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/x86.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 566f9512b4a3..68fb6393c96f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -529,6 +529,7 @@ static int exception_class(int vector)
 #define EXCPT_TRAP		1
 #define EXCPT_ABORT		2
 #define EXCPT_INTERRUPT		3
+#define EXCPT_DB		4
 
 static int exception_type(int vector)
 {
@@ -539,8 +540,14 @@ static int exception_type(int vector)
 
 	mask = 1 << vector;
 
-	/* #DB is trap, as instruction watchpoints are handled elsewhere */
-	if (mask & ((1 << DB_VECTOR) | (1 << BP_VECTOR) | (1 << OF_VECTOR)))
+	/*
+	 * #DBs can be trap-like or fault-like, the caller must check other CPU
+	 * state, e.g. DR6, to determine whether a #DB is a trap or fault.
+	 */
+	if (mask & (1 << DB_VECTOR))
+		return EXCPT_DB;
+
+	if (mask & ((1 << BP_VECTOR) | (1 << OF_VECTOR)))
 		return EXCPT_TRAP;
 
 	if (mask & ((1 << DF_VECTOR) | (1 << MC_VECTOR)))
@@ -8791,6 +8798,12 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		unsigned long rflags = static_call(kvm_x86_get_rflags)(vcpu);
 		toggle_interruptibility(vcpu, ctxt->interruptibility);
 		vcpu->arch.emulate_regs_need_sync_to_vcpu = false;
+
+		/*
+		 * Note, EXCPT_DB is assumed to be fault-like as the emulator
+		 * only supports code breakpoints and general detect #DB, both
+		 * of which are fault-like.
+		 */
 		if (!ctxt->have_exception ||
 		    exception_type(ctxt->exception.vector) == EXCPT_TRAP) {
 			kvm_pmu_trigger_event(vcpu, PERF_COUNT_HW_INSTRUCTIONS);
@@ -9714,6 +9727,16 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
 
 	/* try to inject new event if pending */
 	if (vcpu->arch.exception.pending) {
+		/*
+		 * Fault-class exceptions, except #DBs, set RF=1 in the RFLAGS
+		 * value pushed on the stack.  Trap-like exception and all #DBs
+		 * leave RF as-is (KVM follows Intel's behavior in this regard;
+		 * AMD states that code breakpoint #DBs excplitly clear RF=0).
+		 *
+		 * Note, most versions of Intel's SDM and AMD's APM incorrectly
+		 * describe the behavior of General Detect #DBs, which are
+		 * fault-like.  They do _not_ set RF, a la code breakpoints.
+		 */
 		if (exception_type(vcpu->arch.exception.nr) == EXCPT_FAULT)
 			__kvm_set_rflags(vcpu, kvm_get_rflags(vcpu) |
 					     X86_EFLAGS_RF);
-- 
2.37.1.359.gd136c6c3e2-goog

