Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F959369E39
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 02:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244667AbhDXAzp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 20:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244669AbhDXAyW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 20:54:22 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C9BC0612A5
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:48:24 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 7-20020a5b01070000b02904ed6442e5f6so3085037ybx.23
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=oyVUQsNf2XbjaOTtJporiUactMrDu8dgH9+VujzngIc=;
        b=i2htVs7R+LB4UeHXF7qO4pwcNIptJJ2+4/sMOE4V28rul7Vr3jf37UUAx9N08ahTtq
         v/MjJRGHgVPMSPSz+RTrfc+dZE2UWQOXKgsoSEpipjHh3FjnOeq2mO/KKSIGIL6Bg5Eh
         lyao12REP5QCPRsqu0O1nK4+xpCGupMZ/nNVeIUPYFKZsEnOnm/RbtxufQJB1qn7bSgn
         B4eAqoSQium9JVDnDY6qhcvuedHreP/rTEhJKptxS0eZW0yGjEGagcV9KGujZrC7hfpL
         Bwg4B9+f+OecO3j8HnoT2/K54seMd79FF3Fo0ZEGPG0u1JhGkdht5HrEqj0+NF/TOD+3
         PDnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=oyVUQsNf2XbjaOTtJporiUactMrDu8dgH9+VujzngIc=;
        b=jB7/z9G8LgXtaZhm1bWjao90qEH3Tei4vKUDW3Zx/r8z/dpXtYr9y0v9E3W+6rF3PG
         ECNFiC7hgk58IMbaT+ab+PMj5PuHWr1+IUkoWr+rBkmi9CttdMHcq30Zqb8pHRQDZgki
         2JyBPFZ1XFWOFAJ4ZAsZv3ZOw+i+carWUxxIuxqyp1dTcLjFOvaqAKgoj4RkkuQj4hqN
         ff3EEKajsnQi11AeB2IU36EM4spHDLHt+rifYvVe8esFXPWRy0gHBusMnSaXd21qeFXX
         28jVDPP3YfJYSLftEMA9gR7PMiRDbbtBXgf2SlwDYr7NSHSrSfBgJQqN5DCzWvuhGd52
         VeGw==
X-Gm-Message-State: AOAM531GPwVGNvYnNLy2zE+ckw/dH00j1pzt4cnjtSI9QAoO2otv7rCy
        +/f7gWVu0Dgg29AD2e4cpHmCuoBaQKU=
X-Google-Smtp-Source: ABdhPJzHBq0sbNM2r7DOXFRJi+6RJhB/VG+TDbd1QTSuIvUr1Dy5UE8zNRs1SBS7+weybKMIxtBBMirt5sE=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:ad52:3246:e190:f070])
 (user=seanjc job=sendgmr) by 2002:a25:a265:: with SMTP id b92mr9083215ybi.486.1619225304165;
 Fri, 23 Apr 2021 17:48:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Apr 2021 17:46:40 -0700
In-Reply-To: <20210424004645.3950558-1-seanjc@google.com>
Message-Id: <20210424004645.3950558-39-seanjc@google.com>
Mime-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 38/43] KVM: VMX: Don't redo x2APIC MSR bitmaps when userspace
 filter is changed
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

Drop an explicit call to update the x2APIC MSRs when the userspace MSR
filter is modified.  The x2APIC MSRs are deliberately exempt from
userspace filtering.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 45a013631f63..beaf9fefddad 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4055,7 +4055,6 @@ static void vmx_msr_filter_changed(struct kvm_vcpu *vcpu)
 	}
 
 	pt_update_intercept_for_msr(vcpu);
-	vmx_update_msr_bitmap_x2apic(vcpu, vmx_msr_bitmap_mode(vcpu));
 }
 
 static inline bool kvm_vcpu_trigger_posted_interrupt(struct kvm_vcpu *vcpu,
-- 
2.31.1.498.g6c1eba8ee3d-goog

