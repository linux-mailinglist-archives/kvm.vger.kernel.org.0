Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5F55F17B4
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 02:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiJAA7X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 20:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231955AbiJAA7V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 20:59:21 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BD761AF90F
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 17:59:20 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id c8-20020a170902d48800b0017cdfc41a38so1549153plg.15
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 17:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=pUJ8lsVIJf7TL6+xh2Qa1ktW0pNw9qF5SOtFc21ozc0=;
        b=EHxckeTL1GlAOvFEilkBQbLD6ds1ejPwB5HYa+q6bReCiccdbj6zC8h52WYChW07Hc
         eGpLZDyOes7qwgMhNdFpH7VkR4xSgnABSGvCIny9yMdtFaZG/iVLcyFn+isxJG+jB4cz
         rZc/c4GcKXGwR6P55J1vDqQbCW/9jMTJDFcbf6xYG2VqSR+/izOd++dhsFayfe1lP+mQ
         7MJOineUi9jmPQi8uqti3cCCu+S7uPZaUY4QQmYnxrc2k1rmPLZMD/vT1UyTE5OnTRRl
         Ph7MtLjXP+DhkurHFZTmGBqcH3BJA5SHK8kCBVpT/RKB+LZ5EQhEyZEG10ybziWuFyBi
         OFkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=pUJ8lsVIJf7TL6+xh2Qa1ktW0pNw9qF5SOtFc21ozc0=;
        b=ME6RwFQB1eWPCmL5Mpl1yptFEtlJ6O7/vMSVxJV7sMmnRGqEHDIxNEaeoDiWfD0Ono
         El6Sbn6kFOfOLXuZqdW4VVw5Ry58F5vjb2YtVWAC78IjuMSeJ8cHJzMGc8E3tLD6RWbg
         fG3Bsx/Hhpiat891Vd+I64Kbrtj+vwGmTZzLDJO69oTNIcwMN2ecn5suFP5f4fUGIQUP
         /fAkHz1i/2wfv9mi/XCQbfEz3Ga411qvc/DTVNJNgFDGTy9M/eID0pbHnT8AgdDKqrqo
         s47JjKsV5JYS5UuEcNkj5Mxyjw9qT9aouFxfmxbDOiZly5p/iZJdHdrkgZNqOquQ5rra
         MPcQ==
X-Gm-Message-State: ACrzQf1nSdn8B/77cMdYqLcTWpEkyJvpawKtYS7JqkYDj5b3+0UNwRAi
        5OVvJOpS46b/q73CGeHhY3ry2xhTlA0=
X-Google-Smtp-Source: AMsMyM427lSvL7dveKM7cWZJs9QN8HrabJ4Fbs51cuKCu4aVR61KKeLheiN/vjBxNQvc9SbyPcj+j9hU6sc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:c986:b0:205:f08c:a82b with SMTP id
 w6-20020a17090ac98600b00205f08ca82bmr517093pjt.1.1664585959605; Fri, 30 Sep
 2022 17:59:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  1 Oct 2022 00:58:44 +0000
In-Reply-To: <20221001005915.2041642-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221001005915.2041642-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221001005915.2041642-2-seanjc@google.com>
Subject: [PATCH v4 01/32] KVM: x86: Blindly get current x2APIC reg value on
 "nodecode write" traps
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
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

When emulating a x2APIC write in response to an APICv/AVIC trap, get the
the written value from the vAPIC page without checking that reads are
allowed for the target register.  AVIC can generate trap-like VM-Exits on
writes to EOI, and so KVM needs to get the written value from the backing
page without running afoul of EOI's write-only behavior.

Alternatively, EOI could be special cased to always write '0', e.g. so
that the sanity check could be preserved, but x2APIC on AMD is actually
supposed to disallow non-zero writes (not emulated by KVM), and the
sanity check was a byproduct of how the KVM code was written, i.e. wasn't
added to guard against anything in particular.

Fixes: 70c8327c11c6 ("KVM: x86: Bug the VM if an accelerated x2APIC trap occurs on a "bad" reg")
Fixes: 1bd9dfec9fd4 ("KVM: x86: Do not block APIC write for non ICR registers")
Reported-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index d7639d126e6c..05d079fc2c66 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2284,23 +2284,18 @@ void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	u64 val;
 
-	if (apic_x2apic_mode(apic)) {
-		if (KVM_BUG_ON(kvm_lapic_msr_read(apic, offset, &val), vcpu->kvm))
-			return;
-	} else {
-		val = kvm_lapic_get_reg(apic, offset);
-	}
-
 	/*
 	 * ICR is a single 64-bit register when x2APIC is enabled.  For legacy
 	 * xAPIC, ICR writes need to go down the common (slightly slower) path
 	 * to get the upper half from ICR2.
 	 */
 	if (apic_x2apic_mode(apic) && offset == APIC_ICR) {
+		val = kvm_lapic_get_reg64(apic, APIC_ICR);
 		kvm_apic_send_ipi(apic, (u32)val, (u32)(val >> 32));
 		trace_kvm_apic_write(APIC_ICR, val);
 	} else {
 		/* TODO: optimize to just emulate side effect w/o one more write */
+		val = kvm_lapic_get_reg(apic, offset);
 		kvm_lapic_reg_write(apic, offset, (u32)val);
 	}
 }
-- 
2.38.0.rc1.362.ged0d419d3c-goog

