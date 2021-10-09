Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 488AA42754C
	for <lists+kvm@lfdr.de>; Sat,  9 Oct 2021 03:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244048AbhJIBDj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 21:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232095AbhJIBDi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 21:03:38 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E048FC061762
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 18:01:41 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id q17-20020a25b591000000b005a07d27bbdaso14821485ybj.3
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 18:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=SFTOsCD2fLbfCOpXgpJNz0YV7VaZgcPTwQZKs+/RiZg=;
        b=INhEx0aHocRJIKUfy17arUjZbG4Z1fUL01B/tSss7d45qbojh+sJscLUPYCLQOjqKO
         k+bTTPouGSj5oku4lc+lVLEHhXAx05lrJWQZTx18FF/obwXeULeDsYhiBCXq/1bJo6Ib
         G5kNPJlqUtZKWtUUcRgKu19442TbSeGHUHBwnIORDVRyMTeQFnopS5LrKqpLsJfNbc03
         5pOR0tc5VlI82fX6uCx3xWJUUVnTYULT32DIHcttClFyHD2gItVVIXr7Zi5Xkm7elSoN
         ZtrRNcUF31BaBhuUgGb6nYU5v2tI1tH1wl8M9PYYd7XLCIW1FM4m8KQ+4zOEQmKjn6Tk
         3wEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=SFTOsCD2fLbfCOpXgpJNz0YV7VaZgcPTwQZKs+/RiZg=;
        b=PvBreUdwA9lNOPnvF6MG1+SQSex6wliTGUqzFG9UP7LjPd3ZTHa/jjNOqpOaOzrcq0
         KptdEwpfw4QF7xDus5SIXCbqcMhnSZEaSTu87kozbtA52cQH7K+lky7alFF5InKGYBWh
         i52XPQNR1MANbqwusS+KwXMUccpaSUuh3TcM/zDN/geGg39WHMTB/y5TXpsY0zFUTTps
         pB63O7UUBKnjnkH5vbpy05fmtBCpQTy+LECRSdQ6rQqtAdE5jIP+a6OKsT4Pl2DFngCg
         vtHcWVZ8ZAbvapPoGa+9oD8uroBuxPrSUka5ccOn5KpndpxSdiQGvy5KDk8Ay3gNXjho
         vC8g==
X-Gm-Message-State: AOAM5308/N5OOzzsrhdgo4sLsm5DX5/uf2KXyBTkRRLgVCOpOmZaU8AC
        QuLzv5y4BlC21Z0ahYC8ABpyAYyh21Y=
X-Google-Smtp-Source: ABdhPJxYynAqY2pZXjNxz5n0Wf5R/VHZFGNQAxKMkEMoM4wxKpMIR8LjH7nMVxQ1ekk9EDonFbnziobBfxY=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a05:6902:120a:: with SMTP id
 s10mr7342143ybu.224.1633741301116; Fri, 08 Oct 2021 18:01:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  8 Oct 2021 18:01:34 -0700
In-Reply-To: <20211009010135.4031460-1-seanjc@google.com>
Message-Id: <20211009010135.4031460-2-seanjc@google.com>
Mime-Version: 1.0
References: <20211009010135.4031460-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH 1/2] KVM: x86/mmu: Use vCPU's APICv status when handling
 APIC_ACCESS memslot
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Query the vCPU's APICv status, not the overall VM's status, when handling
a page fault that hit the APIC Access Page memslot.  If an APICv status
update is pending, using the VM's status is non-deterministic as the
initiating vCPU may or may not have updated overall VM's status.  E.g. if
a vCPU hits an APIC Access page fault with APICv disabled and a different
vCPU is simultaneously performing an APICv update, the page fault handler
will incorrectly skip the special APIC access page MMIO handling.

Using the vCPU's status in the page fault handler is correct regardless
of any pending APICv updates, as the vCPU's status is accurate with
respect to the last VM-Enter, and thus reflects the context in which the
page fault occurred.

Cc: Maxim Levitsky <mlevitsk@redhat.com>
Fixes: 9cc13d60ba6b ("KVM: x86/mmu: allow APICv memslot to be enabled but invisible")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 24a9f4c3f5e7..d36e205b90a5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3853,7 +3853,7 @@ static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 		 * when the AVIC is re-enabled.
 		 */
 		if (slot && slot->id == APIC_ACCESS_PAGE_PRIVATE_MEMSLOT &&
-		    !kvm_apicv_activated(vcpu->kvm)) {
+		    !kvm_vcpu_apicv_active(vcpu)) {
 			*r = RET_PF_EMULATE;
 			return true;
 		}
-- 
2.33.0.882.g93a45727a2-goog

