Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22C2A310232
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 02:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232693AbhBEBZp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 20:25:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232684AbhBEBZo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 20:25:44 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 773EEC06178C
        for <kvm@vger.kernel.org>; Thu,  4 Feb 2021 17:25:04 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 11so5188645ybl.21
        for <kvm@vger.kernel.org>; Thu, 04 Feb 2021 17:25:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=4+ZJwerbDVsZaT3Nm4onzePXjuWx4rquZa0E2PQ0OPo=;
        b=Q5vYf6q7JlAbA40tkuiP2Ie3muwYhUzkhhXWdh+O5bh4/X/jzNBlkjC2c1/YRE6fOa
         XLgCwZaTgrGp3yDJLKxnT+dxotYylkrw6vjZtTcE4Z4u6X9ox1jxQLtQd9JPknqHCLGt
         kkCW/MNZGrDeNKAaSIG/FFFl2q4qsXt36iHgQ7eVZau44P/z0OwTkTyCdsz0A/56hJNN
         YQmJZ87sS1qn9pY3zpSEdxq9V9zI0xrYMX07iuEO5d5bTrYeHpQSy756hksx5fJp9II9
         d9Lj73Qt91qxlyeohOqO3TT6N8orOzq2bb9rg2hIea0u7wJOjAiNQLfPBixfMa0lZbiB
         xbgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=4+ZJwerbDVsZaT3Nm4onzePXjuWx4rquZa0E2PQ0OPo=;
        b=b6OuI9jADn3iFg3m/oLsKUxoAiPyz+sXgsFEbeIvL7Z3wwOQXx2lL/HCeevDRtcTMW
         GNLJ8vl8yXPXldZj6wQJQXsNZOqBzZky6N/tNbG/mNZakJBIC73/O9eaZfuoGlEghGUF
         bINBO6t+SquQkPSTC5jfV9JU1oH7U6VBMQPsoXpZbph5e7oIod5Tvp3dlyHbC/L/W6TM
         7fQj1G3DMtVMbATMDYTaWWIdjOunrsXGaAUAP7yDjAbkq1h1MoCmiPylexSTJits0uR2
         4zl9pCnOqbQTbaF/XVcsF3C6+7EnXpMsn6UXhwqhOP/Oqwx5Z4q1pBJZYLcNoB9mNlAA
         tQ7Q==
X-Gm-Message-State: AOAM533dqh3DZCq3n4ReFnGp73hAnpBKCUbEzIpH1h3V1BpyMLyhaayB
        pMAuQTTv2xfwio6vhhX9yc3tSBQ4Agg=
X-Google-Smtp-Source: ABdhPJxQbWPhpPQhhPoWTyDSVbXIZYVUrwa5vnhzf2uPGaQqfBgUdlrMSaWK6HgCbCrO0XrrT9/xvLpw+f8=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:f16f:a28e:552e:abea])
 (user=seanjc job=sendgmr) by 2002:a25:698d:: with SMTP id e135mr2856644ybc.281.1612488303713;
 Thu, 04 Feb 2021 17:25:03 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Feb 2021 17:24:57 -0800
In-Reply-To: <20210205012458.3872687-1-seanjc@google.com>
Message-Id: <20210205012458.3872687-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210205012458.3872687-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH 1/2] KVM: x86: Remove misleading DR6/DR7 adjustments from RSM emulation
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop the DR6/7 volatile+fixed bits adjustments in RSM emulation, which
are redundant and misleading.  The necessary adjustments are made by
kvm_set_dr(), which properly sets the fixed bits that are conditional
on the vCPU model.

Note, KVM incorrectly reads only bits 31:0 of the DR6/7 fields when
emulating RSM on x86-64.  On the plus side for this change, that bug
makes removing "& DRx_VOLATILE" a nop.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/emulate.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 9641cff06722..2e6e6c39922f 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2506,12 +2506,12 @@ static int rsm_load_state_32(struct x86_emulate_ctxt *ctxt,
 
 	val = GET_SMSTATE(u32, smstate, 0x7fcc);
 
-	if (ctxt->ops->set_dr(ctxt, 6, (val & DR6_VOLATILE) | DR6_FIXED_1))
+	if (ctxt->ops->set_dr(ctxt, 6, val))
 		return X86EMUL_UNHANDLEABLE;
 
 	val = GET_SMSTATE(u32, smstate, 0x7fc8);
 
-	if (ctxt->ops->set_dr(ctxt, 7, (val & DR7_VOLATILE) | DR7_FIXED_1))
+	if (ctxt->ops->set_dr(ctxt, 7, val))
 		return X86EMUL_UNHANDLEABLE;
 
 	selector =                 GET_SMSTATE(u32, smstate, 0x7fc4);
@@ -2566,12 +2566,12 @@ static int rsm_load_state_64(struct x86_emulate_ctxt *ctxt,
 
 	val = GET_SMSTATE(u32, smstate, 0x7f68);
 
-	if (ctxt->ops->set_dr(ctxt, 6, (val & DR6_VOLATILE) | DR6_FIXED_1))
+	if (ctxt->ops->set_dr(ctxt, 6, val))
 		return X86EMUL_UNHANDLEABLE;
 
 	val = GET_SMSTATE(u32, smstate, 0x7f60);
 
-	if (ctxt->ops->set_dr(ctxt, 7, (val & DR7_VOLATILE) | DR7_FIXED_1))
+	if (ctxt->ops->set_dr(ctxt, 7, val))
 		return X86EMUL_UNHANDLEABLE;
 
 	cr0 =                       GET_SMSTATE(u64, smstate, 0x7f58);
-- 
2.30.0.365.g02bc693789-goog

