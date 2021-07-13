Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA9B3C74D7
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 18:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235709AbhGMQh5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 12:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234911AbhGMQhl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 12:37:41 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD1DC06119D
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:34:28 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id c13-20020a25880d0000b029055492c8987bso27621700ybl.19
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=cW8BIVTxIgKroIq7kMrutoUZpTyYwV90yWvpiIBilPc=;
        b=kjC+N6ZAjKJ76JOx9gw1poeBnbs7f2TUs96FtDfxukpM4jgMbWSbGEY4ji86iiS3da
         KjaDmuQnpnv9YMt0GJJ5mLcyddJ7cyucks0rzrSCc97QJHriPtUTLgcgZQhXR/wREnsB
         Hi8yzV5oxqD0ZATDXTpeX9dFpPq/SOKOg8i+1OyvFYVtItvfEhM7UWBJVwYyd4IHtA3C
         xrFrNdRpDpeBZT95BiCTp8u2oyOjjhaGXDOgpVf2RS/8KwKEahNN5ih+bY0W8Ufey0J6
         hrYhTvbqsehiS8KNt5AnCLByJtyZ3T99WFm7TuCPhZl6eakojNa4eikhhB847boP3n5s
         gI/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=cW8BIVTxIgKroIq7kMrutoUZpTyYwV90yWvpiIBilPc=;
        b=MlAcgpP5o0L1Mm48VB/lWgFDpJCf9OTs30ELJZiO6wFNqupd+tZeY9XYwbOPm3W/PZ
         gbaB0AW7TdKEPM5WGHbSnGsQKAOx/wkQzN+Ua4s28IaDZG8R9jGLWfvElMYHPM/MUoMb
         dfVOc/T7VW+nD5Y1S0if00xR7aUNXrtV84y32Iad+8uq5nQt84PKoMCPVe6JxDvtYGIl
         egBOCBZHdkH+ps6cl2U9ndSwVM86+fLqGYpR6F4E8oJMdqGpeX9hvY8TBinAgLBVSOWl
         a9O8GuFa80gS/7LCGagAsQRG0Aq7Org95zciJed0psjTVxW1Z8cQzHD2xPR0QhCGgcTC
         5ImA==
X-Gm-Message-State: AOAM530TdO2cciC6LerJxV6uJGGsPiHJhDhkMCeFgoUyo0vSPHdS2PyH
        gmTCfNpZNVgYv+Knqr5Ag4CQYDa9JDs=
X-Google-Smtp-Source: ABdhPJxxEY5h40hwjxnBrqRbvxMDcqYn0Pq1pp/svYskxe9JHvsyD6AN1JmqX+UdGZbHRnRL801DTneK6PU=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:825e:11a1:364b:8109])
 (user=seanjc job=sendgmr) by 2002:a25:1e57:: with SMTP id e84mr7107672ybe.308.1626194067266;
 Tue, 13 Jul 2021 09:34:27 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Jul 2021 09:33:06 -0700
In-Reply-To: <20210713163324.627647-1-seanjc@google.com>
Message-Id: <20210713163324.627647-29-seanjc@google.com>
Mime-Version: 1.0
References: <20210713163324.627647-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v2 28/46] KVM: VMX: Skip emulation required checks during
 pmode/rmode transitions
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't refresh "emulation required" when stuffing segments during
transitions to/from real mode when running without unrestricted guest.
The checks are unnecessary as vmx_set_cr0() unconditionally rechecks
"emulation required".  They also happen to be broken, as enter_pmode()
and enter_rmode() run with a stale vcpu->arch.cr0.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 45b123bb5aaa..7ab493708b06 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2719,6 +2719,8 @@ static __init int alloc_kvm_area(void)
 	return 0;
 }
 
+static void __vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
+
 static void fix_pmode_seg(struct kvm_vcpu *vcpu, int seg,
 		struct kvm_segment *save)
 {
@@ -2735,7 +2737,7 @@ static void fix_pmode_seg(struct kvm_vcpu *vcpu, int seg,
 		save->dpl = save->selector & SEGMENT_RPL_MASK;
 		save->s = 1;
 	}
-	vmx_set_segment(vcpu, save, seg);
+	__vmx_set_segment(vcpu, save, seg);
 }
 
 static void enter_pmode(struct kvm_vcpu *vcpu)
@@ -2756,7 +2758,7 @@ static void enter_pmode(struct kvm_vcpu *vcpu)
 
 	vmx->rmode.vm86_active = 0;
 
-	vmx_set_segment(vcpu, &vmx->rmode.segs[VCPU_SREG_TR], VCPU_SREG_TR);
+	__vmx_set_segment(vcpu, &vmx->rmode.segs[VCPU_SREG_TR], VCPU_SREG_TR);
 
 	flags = vmcs_readl(GUEST_RFLAGS);
 	flags &= RMODE_GUEST_OWNED_EFLAGS_BITS;
@@ -3291,7 +3293,7 @@ static u32 vmx_segment_access_rights(struct kvm_segment *var)
 	return ar;
 }
 
-void vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
+static void __vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	const struct kvm_vmx_segment_field *sf = &kvm_vmx_segment_fields[seg];
@@ -3304,7 +3306,7 @@ void vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
 			vmcs_write16(sf->selector, var->selector);
 		else if (var->s)
 			fix_rmode_seg(seg, &vmx->rmode.segs[seg]);
-		goto out;
+		return;
 	}
 
 	vmcs_writel(sf->base, var->base);
@@ -3326,9 +3328,13 @@ void vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
 		var->type |= 0x1; /* Accessed */
 
 	vmcs_write32(sf->ar_bytes, vmx_segment_access_rights(var));
+}
 
-out:
-	vmx->emulation_required = emulation_required(vcpu);
+void vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
+{
+	__vmx_set_segment(vcpu, var, seg);
+
+	to_vmx(vcpu)->emulation_required = emulation_required(vcpu);
 }
 
 static void vmx_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l)
-- 
2.32.0.93.g670b81a890-goog

