Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B40C4330E0
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 10:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234596AbhJSIPr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 04:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231758AbhJSIPo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 04:15:44 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 505BEC06161C;
        Tue, 19 Oct 2021 01:13:32 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id 21so13119929plo.13;
        Tue, 19 Oct 2021 01:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=nrwJfAi/R4MCqc2SCM/CIDlwla93uArbuS4T7Qr7MDU=;
        b=n7+1b8sqtq4TZ4k799pbGGFf4yXRbnC6ecffo1LKOGV90rkGwY7dFoeRW1ueokQ3+/
         964adZi3lRp6QH/D5ikC9HuArRYmELUfJgwe3GqbLg3+mw1gKBa1meHvo2PvyA2Lh09w
         bjQaIEzcuNt7mKTZOtaR86KX+DPwVuA1H/VdaCnih8V+ZqK0Vsg/UnwBOeBtJJw84f7W
         IPj7H+iW9LffV6xYwdyjM37b5KvYnFN5uetaIO1ZxE0GIWtHbPI3/7Y4AlqrE8mDDzGy
         66OjvUwgGWkoHr/3sgbMHp/9lH5pu1h0mMVzd5Knb62LagyXTCZ/VSUSPC/UibFCDDab
         1AJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=nrwJfAi/R4MCqc2SCM/CIDlwla93uArbuS4T7Qr7MDU=;
        b=Rb+Iu6FZIHQVVQWlJLcON4Zn+taaLjYlujtnvElTOYJ4J8TFfS2x03iRTlkRVM/OtI
         +kKTxK2MnUAoal019F68pTMd6XlPHd/8TZokvvKAmpeA1T3EpE8KCb0Z0798MsQKy9Tg
         tLnYI2Pt87ExUXOSN87ujXNN7XJBFTfQrfMtKKJSwDnoLOoh6hC9fHAy1OmvEtaD8O47
         j2TRPJo6nAIfjQRpBr1JoOAWhZhEmZpVpGqQ006fQQj0wIdcrJmbMKVsXIU6iYG70GsA
         J7pqoMT+YpqQv+9Om3xGlZbO4b8h342zQL9xyM4HM0M/0qUCVw7HnrUo07Xnmxzud7AM
         1SSw==
X-Gm-Message-State: AOAM533Ycj4jBVsRCFzd7TnStbpG33VNZHbg0K3509gB3SkPi+BGQRiP
        PAWzzGjunmg6S/Bt2H7M7QutTxtbmWUlww==
X-Google-Smtp-Source: ABdhPJxwgEqdFRLfExGUJSBDQf3HUnPJ0BiFNJ7c2wXdpDabewi/o6rfyQiH1VvJ9cl4byx/3BW/xA==
X-Received: by 2002:a17:902:8682:b0:13f:8e12:c977 with SMTP id g2-20020a170902868200b0013f8e12c977mr25730185plo.62.1634631211164;
        Tue, 19 Oct 2021 01:13:31 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.110])
        by smtp.googlemail.com with ESMTPSA id f15sm3254064pfe.132.2021.10.19.01.13.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Oct 2021 01:13:30 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v3 1/3] KVM: emulate: Don't inject #GP when emulating RDMPC if CR0.PE=0
Date:   Tue, 19 Oct 2021 01:12:38 -0700
Message-Id: <1634631160-67276-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

SDM mentioned that, RDPMC:

  IF (((CR4.PCE = 1) or (CPL = 0) or (CR0.PE = 0)) and (ECX indicates a supported counter))
      THEN
          EAX := counter[31:0];
          EDX := ZeroExtend(counter[MSCB:32]);
      ELSE (* ECX is not valid or CR4.PCE is 0 and CPL is 1, 2, or 3 and CR0.PE is 1 *)
          #GP(0);
  FI;

Let's add the CR0.PE is 1 checking to rdpmc emulate, though this isn't
strictly necessary since it's impossible for CPL to be >0 if CR0.PE=0.

Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v2 -> v3:
 * add the missing 'S'
v1 -> v2:
 * update patch description

 arch/x86/kvm/emulate.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 9a144ca8e146..ab7ec569e8c9 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4213,6 +4213,7 @@ static int check_rdtsc(struct x86_emulate_ctxt *ctxt)
 static int check_rdpmc(struct x86_emulate_ctxt *ctxt)
 {
 	u64 cr4 = ctxt->ops->get_cr(ctxt, 4);
+	u64 cr0 = ctxt->ops->get_cr(ctxt, 0);
 	u64 rcx = reg_read(ctxt, VCPU_REGS_RCX);
 
 	/*
@@ -4222,7 +4223,7 @@ static int check_rdpmc(struct x86_emulate_ctxt *ctxt)
 	if (enable_vmware_backdoor && is_vmware_backdoor_pmc(rcx))
 		return X86EMUL_CONTINUE;
 
-	if ((!(cr4 & X86_CR4_PCE) && ctxt->ops->cpl(ctxt)) ||
+	if ((!(cr4 & X86_CR4_PCE) && ctxt->ops->cpl(ctxt) && (cr0 & X86_CR0_PE)) ||
 	    ctxt->ops->check_pmc(ctxt, rcx))
 		return emulate_gp(ctxt, 0);
 
-- 
2.25.1

