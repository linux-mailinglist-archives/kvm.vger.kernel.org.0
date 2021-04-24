Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADC71369E2D
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 02:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244403AbhDXAyi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 20:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244469AbhDXAxN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 20:53:13 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B704C061288
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:48:16 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id d89-20020a25a3620000b02904dc8d0450c6so26112534ybi.2
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=thJRe/zksywSokv9ZmTCndjiPPjEmBU1CAnUpNcr8ss=;
        b=cHaqKGZ0l7MVStxsR4rYVHgGZ2z01asm7gZWaBduBDDkFmUj6dfL07QN1zqBjxx8JT
         SUL5ugEMLYkbiX1iF/FZO28Z8ygEf8sZfZf6zQ8ibXrQDR8N7KCDowMJ8FPq2xPFiCt4
         NesaxKfH/Io25cj+IT/bgWh0pB3AHsU5WL+SKdgozzefTt+lSUkYKQvtuySidncFgxcg
         c3kpQRLrvTVOokNCiHLg68EHDRDW0sETL47HTMf8bXDolpud/6dfxiTYn6MC9uhSaTYx
         vzADYJrJ41W3Qv7pZPuuesMxZJKguolq3gJ/TCAG1ZTzCTj40NamknX+I98ng0DOTla/
         zinw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=thJRe/zksywSokv9ZmTCndjiPPjEmBU1CAnUpNcr8ss=;
        b=NG1YhOgHU++gvYkaQCrN/6VKWxixdX3DFJmR2bySoDSHpa4Wfpuk8dujydsxtdLSD5
         sgNFgPX/kqS0da+/3def31RkCGT/HRm6UzVRPO4irQq+YPdWeGQ7TgTBZFuVMSrSDRvf
         fds29T1peqOyeLYUZx+k3spdynSQn3pnRaS5PO8lIo+0iXtyh44lRbBV9/yBX/uzmjVh
         a/Hbcp0lCmpZyyMu6LkjrKCOBnmdr6j4etNJey6ixPszrtCAx2c212r+k+yB/SSKEAT2
         A91MIqV2NeC0bcRHtLyCc3XmnX6Yr+XFfF9cHD2BsAUq0UjFfYn8q2ayQr9MEFuRlUgv
         wCpg==
X-Gm-Message-State: AOAM5322AOvasLmFADxkTSrLJFY8XTnuWo7haKGgoFr1SusJBe9o3S7w
        c+KzeU6mUHJ6BZbOb0CoqvH6XfgE0aw=
X-Google-Smtp-Source: ABdhPJy2gKSZmcqpJXKP2OVfsSIMNONflhb75V2hptd/0tJpdTQzlaVYkT3ExAFdPKH/IdY2XmjJCAFvAgg=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:ad52:3246:e190:f070])
 (user=seanjc job=sendgmr) by 2002:a25:38cf:: with SMTP id f198mr9254733yba.21.1619225295684;
 Fri, 23 Apr 2021 17:48:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Apr 2021 17:46:36 -0700
In-Reply-To: <20210424004645.3950558-1-seanjc@google.com>
Message-Id: <20210424004645.3950558-35-seanjc@google.com>
Mime-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 34/43] KVM: VMX: Don't _explicitly_ reconfigure user return
 MSRs on vCPU INIT
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

When emulating vCPU INIT, do not unconditionally refresh the list of user
return MSRs that need to be loaded into hardware when running the guest.
Unconditionally refreshing the list is confusing, as the vast majority of
MSRs are not modified on INIT.  The real motivation is to handle the case
where an INIT during long mode obviates the need to load the SYSCALL MSRs,
and that is handled as needed by vmx_set_efer().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 57cabef3ffd9..8c982e049cbb 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4509,6 +4509,8 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 		vmx->pt_desc.guest.output_mask = 0x7F;
 		vmcs_write64(GUEST_IA32_RTIT_CTL, 0);
 	}
+
+	vmx_setup_uret_msrs(vmx);
 }
 
 static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
@@ -4570,8 +4572,6 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	if (kvm_mpx_supported())
 		vmcs_write64(GUEST_BNDCFGS, 0);
 
-	vmx_setup_uret_msrs(vmx);
-
 	if (cpu_has_vmx_msr_bitmap())
 		vmx_update_msr_bitmap(&vmx->vcpu);
 
-- 
2.31.1.498.g6c1eba8ee3d-goog

