Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED54369E34
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 02:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244615AbhDXAzW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 20:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbhDXAx6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 20:53:58 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1C2FC061348
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:48:20 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id z8-20020a2566480000b02904e0f6f67f42so26643170ybm.15
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=BcYmgJLXkQJJcYxDhmV+A4GdpBicTf4J3kxojsPseyo=;
        b=CkSStvVOFxviRKV+zeGALhdHXccSceIl2sr98P3tZy650GVaj0sQy5ieQPo/t2KLJo
         5v1FpyJ0OMXg6VXwre4dIh5nrK3KgRXukeHn6zm8sZEoSK2ByrWKFN/dUvy/Jbs+Spvu
         jMCGW1jwHMYaxR0heiH7N5RQMqKqzu0gTxikWQqbpEbYmWM7SzxHYstdrFYD79txgbwj
         dxxn0jTwkmjRFnYyub1TsVNZP8oGXmYQxYyQbUn5kNzrWsj+xpX/Tmzcvde1twUk9DCr
         x/IV3jz3b5CVtNgXRaLSyCRdP7CQWi0xst3mfobqRB1r4PbibfTNL5JSF3GTgH04Upoo
         93zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=BcYmgJLXkQJJcYxDhmV+A4GdpBicTf4J3kxojsPseyo=;
        b=ZwTo8oq3pQz1yZYZI23g/yeo7gkDSG66rMZKp0MvNFa1g+zp62qDPIBGYZtM4HTDe6
         RIOmj48xUvZ1JxH5HVArCaZ+QGIB3rdN/KytiIW1xHy6PvvYf7ozqYupSYBy+Uy/p5Be
         j7KQxiXH8x8Swr44Dx6mQh1uaviVHWLtwdThiHCSlXvtrkDNS/ADQh1i0+8sjBH4C50w
         02XfCXR1HKvxo09pxQbLMq11IhoXgimNe2ygB7h8TSgEA56CnsnGkvlr8v8w1k+TC//f
         fZzLYF/iIhdahVv5tzAOybmtR7etQzVVhqebqft949ikEJT9/ZzxQsUrmvdyhD4NsSAB
         uSpQ==
X-Gm-Message-State: AOAM5316Vuvvg2eHhez2gwCHXoklt8TJ9/kJDrTGwPSYwlpmD+noY/pt
        qKS0xz1/cMSTbVQELYDAdH+4qka6ZnE=
X-Google-Smtp-Source: ABdhPJxPz+ZvsI4LIrFC6DUqitf0LoKkGuy4DdYbdSzXPOowIoEHdn/pCCh8TRClkQta0zaSCIJ+pF8yshQ=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:ad52:3246:e190:f070])
 (user=seanjc job=sendgmr) by 2002:a05:6902:687:: with SMTP id
 i7mr8699935ybt.310.1619225299999; Fri, 23 Apr 2021 17:48:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Apr 2021 17:46:38 -0700
In-Reply-To: <20210424004645.3950558-1-seanjc@google.com>
Message-Id: <20210424004645.3950558-37-seanjc@google.com>
Mime-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 36/43] KVM: VMX: Remove obsolete MSR bitmap refresh at vCPU RESET/INIT
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

Remove an unnecessary MSR bitmap refresh during vCPU RESET/INIT.  In both
cases, the MSR bitmap already has the desired values and state.

At RESET, the vCPU is guaranteed to be running with x2APIC disabled, the
x2APIC MSRs are guaranteed to be intercepted due to the MSR bitmap being
initialized to all ones by alloc_loaded_vmcs(), and vmx->msr_bitmap_mode
is guaranteed to be zero, i.e. reflecting x2APIC disabled.

At INIT, the APIC_BASE MSR is not modified, thus there can't be any
change in x2APIC state.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d8afca144e11..acfb87f30979 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4569,9 +4569,6 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	if (kvm_mpx_supported())
 		vmcs_write64(GUEST_BNDCFGS, 0);
 
-	if (cpu_has_vmx_msr_bitmap())
-		vmx_update_msr_bitmap(&vmx->vcpu);
-
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, 0);  /* 22.2.1 */
 
 	if (cpu_has_vmx_tpr_shadow() && !init_event) {
-- 
2.31.1.498.g6c1eba8ee3d-goog

