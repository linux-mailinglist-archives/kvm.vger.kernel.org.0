Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8D3B369DEB
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 02:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244147AbhDXArv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 20:47:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244088AbhDXArr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 20:47:47 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30585C06174A
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:47:07 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id g184-20020a3784c10000b02902e385de9adaso15314212qkd.3
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=WDHyTgGjim6hk3/xd8JtlILQjW4Wl2Ft0fupXNYGdHc=;
        b=rvQnQvoP00Y7thOgQbkMO45k+pLyOLGgPtLCI27QOGyOOacF6s5jSWo7yThwKATN2j
         gRoqPUOPIg6AkpXdKzh/EdXAzIXyvJAbL3JyWI6e7MEPDQe5Y6KR/cpJzkbmQOo7Cv2g
         oqNuv3Vq4fCHXKP1dWMvFDgnu/lWiDStPzq0RDOJbXuuCyLYDo5CAX0P8NQM4GHHYW1C
         PSqUlcNQ7Ytju04V1UQmEuoFBdp8VIBcbY9o33dP8BY10NLdCjeURq/0yAP+zgFk/BMk
         OQYvtHz1eU0ypNg/RkrzVRr0Oi3Cht4n0S9STEhnJV+sNJ2/Bh8c9qaK9rP4cD83Lpgm
         pm/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=WDHyTgGjim6hk3/xd8JtlILQjW4Wl2Ft0fupXNYGdHc=;
        b=WCY8Y5jOlx3owyErdEFcjV5odqdV4iZYQZuZmYW1Qaff0A4uZMkfEVXQnauyDVYURS
         PnMF4jyKzifzcmTBt+KfCUuAvIt34Bn385IeXBKgZivTdoRoQSxsrq4Lns8M9qkQbHlF
         1/8llX7wZTPXKF/tCrsT3KyvIOQHPVZNF5Q7XXOwB3cvXjgJLJpHT/JuAk+KgwDEFw8y
         XeA4Q5vB0/aIdmN2vRttzszkOo2kTEzIH5KhllM+q0inGlMw/Joh2P3u/OdRYC7IlLm/
         MPgYDmPgFKS28SjZhOQZUWK6ClViQysPtJFs/nWfJ5GGfEjbXQakk+fNbNCuhcMRhlCr
         lbKA==
X-Gm-Message-State: AOAM532cngI9yIa2BhgH+H7BtzsBtsZLn2WSj20whxrMqz41C8Sub0GT
        Ul1r5xgP/Gk0RMT7+S3Ii7LTut7D3sI=
X-Google-Smtp-Source: ABdhPJxba3jkQY8JoBg2/bwM1Z2vQB+NWcrsdv6irr9VK+VHqlDgSN7t9llZT/MKf+h1RoPbe5u8rIhrzM8=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:ad52:3246:e190:f070])
 (user=seanjc job=sendgmr) by 2002:a0c:f247:: with SMTP id z7mr7230997qvl.24.1619225226439;
 Fri, 23 Apr 2021 17:47:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Apr 2021 17:46:05 -0700
In-Reply-To: <20210424004645.3950558-1-seanjc@google.com>
Message-Id: <20210424004645.3950558-4-seanjc@google.com>
Mime-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 03/43] KVM: SVM: Require exact CPUID.0x1 match when stuffing
 EDX at INIT
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

Do not allow an inexact CPUID "match" when querying the guest's CPUID.0x1
to stuff EDX during INIT.  In the common case, where the guest CPU model
is an AMD variant, allowing an inexact match is a nop since KVM doesn't
emulate Intel's goofy "out-of-range" logic for AMD and Hygon.  If the
vCPU model happens to be an Intel variant, an inexact match is possible
if and only if the max CPUID leaf is precisely '0'. Aside from the fact
that there's probably no CPU in existence with a single CPUID leaf, if
the max CPUID leaf is '0', that means that CPUID.0.EAX is '0', and thus
an inexact match for CPUID.0x1.EAX will also yield '0'.

So, with lots of twisty logic, no functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 14ff7f0963e9..b9e3229ddc27 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1299,7 +1299,7 @@ static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	}
 	init_vmcb(vcpu);
 
-	kvm_cpuid(vcpu, &eax, &dummy, &dummy, &dummy, false);
+	kvm_cpuid(vcpu, &eax, &dummy, &dummy, &dummy, true);
 	kvm_rdx_write(vcpu, eax);
 
 	if (kvm_vcpu_apicv_active(vcpu) && !init_event)
-- 
2.31.1.498.g6c1eba8ee3d-goog

