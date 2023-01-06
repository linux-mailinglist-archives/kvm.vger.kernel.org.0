Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ADC565F8BA
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 02:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236656AbjAFBN0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 20:13:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236741AbjAFBNR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 20:13:17 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67CDA72D07
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 17:13:16 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id r17-20020a17090aa09100b0021903e75f14so34803pjp.9
        for <kvm@vger.kernel.org>; Thu, 05 Jan 2023 17:13:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=O/yK9t38GUx7xAC8BnI1OsbEu+wskTkGWc8pHxjCI1M=;
        b=XC1QRawbtqcuGIvkyZGXfO4dWvKusbHvx7Ceuk2s9f1EDWyGwTXKxmEF/7/RoIyTQl
         83ZnpCeWlNJvN0EszGtRNrqExAEYtasediUZNG+ehmTQiMkhoIjKnQhWX+hIoogU83y5
         xCHw6f+G8TqjvtBXoV0fhoUCuqOQwLxYgvCx9gO1Yv6C08Kbd4rG0qe2BBVTMw5geDsF
         YPuiC4gu1ZtesL5MNl+S7dkrBrISA94kw1YYFc7EnChdP1MFnbPrSXyA/2qtyEzjSHcX
         TfB3JBGQsJtAUeyHu6mN2XX8OUtEzSnJzI4Mv2SeSy55WQ4uXyfv6rzWDVYiIitmKYhS
         xNBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O/yK9t38GUx7xAC8BnI1OsbEu+wskTkGWc8pHxjCI1M=;
        b=2wCVWN9Y3BBvWy+hSss3HB4Y+RsDGqSZ/j7vAupZUlBUE3Sm2HxmhDVKdp2A5UC4Kx
         Cze4JFN49er9vCWprzmgGfCps50eHHI51YpkB4SJ2mwC4mUSvOwh0iU8qgaT6p3eYoBZ
         E6+yctGkxyA0VY+Yk+VJaQuJGTFiNTvIBI3ExZ8Ju7jvuzriAYw+vrq+asLJXDcJkNTD
         bpMi1ZQa17h8w0p831Cr+Iz6Lh3Gs1QJJOcfKjXmDDBqCqzA+oGNeAepX72RyPwqGEsx
         Uj7zXnI8w5nDlW0yUz2b3b/PfUZ9idgo+PmTDkmwDXVauyDFmuPRqIF5rbbHbin6uVZP
         /eNw==
X-Gm-Message-State: AFqh2koUO0rxUfzMe3iiF9rX60N+YBef30lOQ+iRm2SzEyA7robRtsZC
        ofrxyEx1Ttrc9EJi6BseUfTS3i60kVE=
X-Google-Smtp-Source: AMrXdXsgyShRZdisFO/emIevEQAlXI6bCsWIdDxxcLZDMha/PDisLDjL6Hp3/hVg7Q3rpOuUTqoyPIwEZ98=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:40c8:b0:189:7a15:134b with SMTP id
 t8-20020a17090340c800b001897a15134bmr2814877pld.143.1672967595896; Thu, 05
 Jan 2023 17:13:15 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  6 Jan 2023 01:12:34 +0000
In-Reply-To: <20230106011306.85230-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230106011306.85230-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230106011306.85230-2-seanjc@google.com>
Subject: [PATCH v5 01/33] KVM: x86: Blindly get current x2APIC reg value on
 "nodecode write" traps
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>,
        Greg Edwards <gedwards@ddn.com>
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
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 4efdb4a4d72c..5c0f93fc073a 100644
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
2.39.0.314.g84b9a713c41-goog

