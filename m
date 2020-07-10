Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD40921BE4D
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 22:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728044AbgGJUHu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 16:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726867AbgGJUHs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 16:07:48 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C45D6C08C5DC
        for <kvm@vger.kernel.org>; Fri, 10 Jul 2020 13:07:48 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id h4so5186638qkl.23
        for <kvm@vger.kernel.org>; Fri, 10 Jul 2020 13:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=FVH+v8HzQyzETJqb9dafvh70k/tYeKPadkHfj/gZ8uY=;
        b=X8nGX66tPgsH9r+ZUHD6jL6iz11V2diBlCRrAa1VCDeZw7NVd6TujfGoL8YqP7nCdu
         DM2AEHPLuyNld+PGwl+SNWxBc1mdNa7jWa5cw2fZN5/Pa7BFyr3eT4qtBWrKMw0eXQWL
         0IQfg0A7c1t+owwtF9QflYrXa0sXdxqQiZG+eEBz0vJKEzqfBhsjiwoR12U/ZUbcciU+
         0BDKaXMGOpcG7Jl4HuUjNKFw6lmMqsK9lqnY1vMZFQr9VH3hgamtVvMt/Y1SXoO9rAZ/
         WQYMQXkfPRe4sBgySIEiXAkZwCi54IUU0m4wdgJihg3/0VS8gk2lCaS0nC5o1jNb27Jk
         hABw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=FVH+v8HzQyzETJqb9dafvh70k/tYeKPadkHfj/gZ8uY=;
        b=cLByD7tTPxOPKpfaA+K9WWgrVY/YjvbfmS/MmAvWBa3F2Wp7tK9pcu/tq4/rdueyaX
         wfHiGAH9yfEJ3220xFBGuJORls7ki7tP5M0VfmKH8UpYmj0oLAqqRNKhEKfbDs1gG0ES
         SwUrnUVaigRUHMBuc2frKnulUKCHXs+yb5qs67cTqP+plQmoigwDCysV1MGUWUduJTf8
         z4ydyXqVLH7WH8IggENtCnIQy+6nAqNYvE7FrrEP1msZRuB68Fp4aRaWFE2Bonn5o7/m
         T4bVcktXM7+tiCjQih0IcuYSeYdQbyu9o31lqGjE4emqA6REgc0dyIXLSGRU05fqTqXs
         PlTQ==
X-Gm-Message-State: AOAM533SMbqvAwxst4lj3Qfn1dlnkBcVK4KUMdCSi8rmnHpRxp27m8d2
        wStFcoIIuhJHerGoxmqQqckEWK8Q2+l+OK6z3VcyBQJMcALCMr2HVH8LKBjui1EnMyN5fqu73b9
        Q7ZC9rfBeM3cdAYSSKBwBqax0Ht8SO24pASSedzb4VuA4gOE5C8rzCARuVA==
X-Google-Smtp-Source: ABdhPJx5fc1/qVuXFG2IQYJzv/qjKEqY3Eux/Jb3c6HBvfLj6Lu/L0tV+p5loEfdXW5riiphe4rCcHmXMm4=
X-Received: by 2002:a0c:e551:: with SMTP id n17mr65537359qvm.151.1594411667939;
 Fri, 10 Jul 2020 13:07:47 -0700 (PDT)
Date:   Fri, 10 Jul 2020 20:07:41 +0000
In-Reply-To: <20200710200743.3992127-1-oupton@google.com>
Message-Id: <20200710200743.3992127-2-oupton@google.com>
Mime-Version: 1.0
References: <20200710200743.3992127-1-oupton@google.com>
X-Mailer: git-send-email 2.27.0.383.g050319c2ae-goog
Subject: [PATCH 2/4] kvm: vmx: check tsc offsetting with nested_cpu_has()
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Hornyack <peterhornyack@google.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No functional change intended.

Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2b41d987b101..fa201010dbe0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1775,7 +1775,7 @@ static u64 vmx_write_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 	 * to the newly set TSC to get L2's TSC.
 	 */
 	if (is_guest_mode(vcpu) &&
-	    (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING))
+	    nested_cpu_has(vmcs12, CPU_BASED_USE_TSC_OFFSETTING))
 		g_tsc_offset = vmcs12->tsc_offset;
 
 	trace_kvm_write_tsc_offset(vcpu->vcpu_id,
-- 
2.27.0.383.g050319c2ae-goog

