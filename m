Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3CC83B0C60
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 20:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233034AbhFVSHp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 14:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232520AbhFVSGv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 14:06:51 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3747AC06114C
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:59:58 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id t144-20020a3746960000b02903ad9c5e94baso19000965qka.16
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=7ggmnZk0ZzA95oYgw0v8Eh/QeJL7koCtTmvSi5/Mn+Y=;
        b=GSPSKBn/mQa9joamTAFl6zMOdhYEESRbgOqd8UHPNjOXCoC9+Z1jdQ4U/r5IvhektS
         MLuT3lGf/XSxaElBtNmnnrySdVZu1INpWQValxhEfHROzGlKnz2yen8L7mtACUKRr8iD
         A0/OOst/h6JBkoE/FScuXq8Tq/o6/ZKTJfBelTvAIwLgymmPYiQSb8fNqOfOVJTiUO37
         nIk6jAqWv7TjYZdswnskjommFAq4N4g4Vr5u6gVHwsOjQ0q/WUjHbRcT+SIGl/YwYsDK
         hzx+CNhm0FqMv2dDXXQZ8pjFeMFxT1MK2JrEywcLQitJNttAe9Ith9Knta4EJC3WpZip
         6I+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=7ggmnZk0ZzA95oYgw0v8Eh/QeJL7koCtTmvSi5/Mn+Y=;
        b=NeRRPSnDcSL48dv2mnTpJ+dEKpK+SVHuSo4sENQUhqQg7Srhz5y1/0+0mpHKcstS+Y
         2ttgFqO7MrSUAgFm3sTeSohndciH5bod3cYyzBlOlbuwxmDMKZhC5glHmhUjSMIBJ/xr
         25oDCk35D0XtclCwUta/nVop3iVBn/1oo0uFI3mMLsoUXbMX78IL57HRnMtJ8TtlcOtc
         JUxQt7P7GvsTnjrwehbNcDX9gAJSPIl8SCWoPc2L677tVGQcgV4sFnSB9PeP4d+tUih8
         AcHUyZVcJeTINVziMlHZ5DnEazjsUtuywl6s6C9/nRdFJcgRkZ0ZETQwnzreDJ0Z75Ui
         6vDw==
X-Gm-Message-State: AOAM531zJgRoTEpdVEHETrjwiysqFAOwRQsgJZktxgJOfNQr3jtoUc6B
        F6L1Q1xZoSvYdAA23tEhVT9mXpWMuQI=
X-Google-Smtp-Source: ABdhPJysNMvdkS/WTlKJMwsHbXLxcAJ6RVqXZDGyfoX7iGnHKFJcn3s93O9i2ByNOSLGPeju8fo4etFNxnU=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:5722:92ce:361f:3832])
 (user=seanjc job=sendgmr) by 2002:a25:2d41:: with SMTP id s1mr6221176ybe.120.1624384797315;
 Tue, 22 Jun 2021 10:59:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 10:57:38 -0700
In-Reply-To: <20210622175739.3610207-1-seanjc@google.com>
Message-Id: <20210622175739.3610207-54-seanjc@google.com>
Mime-Version: 1.0
References: <20210622175739.3610207-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 53/54] KVM: x86/mmu: Get CR4.SMEP from MMU, not vCPU, in
 shadow page fault
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the current MMU instead of vCPU state to query CR4.SMEP when handling
a page fault.  In the nested NPT case, the current CR4.SMEP reflects L2,
whereas the page fault is shadowing L1's NPT, which uses L1's hCR4.
Practically speaking, this is a nop a NPT walks are always user faults,
i.e. this code will never be reached, but fix it up for consistency.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 260a9c06d764..a79353fc6efd 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -903,7 +903,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 		 * then we should prevent the kernel from executing it
 		 * if SMEP is enabled.
 		 */
-		if (kvm_read_cr4_bits(vcpu, X86_CR4_SMEP))
+		if (is_cr4_smep(vcpu->arch.mmu))
 			walker.pte_access &= ~ACC_EXEC_MASK;
 	}
 
-- 
2.32.0.288.g62a8d224e6-goog

