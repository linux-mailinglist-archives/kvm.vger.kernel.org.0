Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1365C38B9F5
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 01:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232919AbhETXFS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 19:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232898AbhETXFS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 19:05:18 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52ACFC061574
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 16:03:56 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id b66-20020a25cb450000b02905076ea039f1so23777316ybg.1
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 16:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=9PMOzhvayBX52a9vOLmHYU5NNHfiPeZ8GQXS4Aphbho=;
        b=H8M8T33kzx+V2jSG4TklCEeaRbJl+LGoM2hOV7n80WMHw9zgckMDcuEbX79CAjJ4Zk
         7t8uup46BqhvOT3k44SFSRLD/8KEFUJmStreNNaMfDArrJY0xdcy3hqB2ITalDJ8yd0s
         qkfoERemklnYpB69lt7hkI28fU8Kj91Mfg1zAKF+I7uHPCMhd+q5BpSEGrwdLDeswpbu
         Nz3QIBhM9zm9A6bGPPJlKLusEABW3bUaOzHv7c3AsrOYoeLMETmJV7sVaeMSJIuRfZRy
         gNH2ZO546DtUV5bgY3EvAJAwiD7mgKS2hJwFvJaJ5EfX+FFFcK6CNEM+9DWBSmTirh3H
         zWMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=9PMOzhvayBX52a9vOLmHYU5NNHfiPeZ8GQXS4Aphbho=;
        b=M0LbyJ8SGmMggeoYgFnBvUx0zsFLW8oq7ST03bjB9COqeGk/j4JcOd8X/takx5tLEZ
         SjcoVViIEmtI6UOKtEE9t+UcY8LjjFEC1RrRA4Z3coixsEDhSvzhpx2nj00RwlNNPnVU
         h0T76AWPppiG+v6Aqt/b6FwjN7uEdzqeFn31WdNe1JgQU7jUDplqY9OodoyeiMyzXSix
         NwKV8W3O71OkSaJWh+PjrTaz40R7FyDDB0wmU6fZZfoN9IehIlld7k+875xECjIX8ggq
         7SrVbRgOSi0vloxBX5+xGhBSvRqvCog0NX7Kbk3r/GoupmTNVq8aja3bRxrIUgRE4c7/
         sMog==
X-Gm-Message-State: AOAM5314IFIF0ROogrgMRl50YaPgcLoJgVO7pWuhUaCLA4vSxhT1W94t
        DQ6B1nKTUJbJT+N6AAHPLSAmSA6gZkEXc9/ZDRFqH34g0S7xRIEIK1wTU+OZEwZMAkt7ctDEGbX
        Q7G/coAoHtDkMd9rwyfJNLgCpvEM0KbRoBIZBxphwhlAPA6/gIRxIA8omV/YVoKc=
X-Google-Smtp-Source: ABdhPJzz786O7RQWj/Altb3OK/dSPBpCKX8SNgBK2GKGePrZV7LFAUGixTUKGoYsxoGM77tX8q29rhEpUgCvEQ==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a5b:448:: with SMTP id
 s8mr10525642ybp.363.1621551835480; Thu, 20 May 2021 16:03:55 -0700 (PDT)
Date:   Thu, 20 May 2021 16:03:29 -0700
In-Reply-To: <20210520230339.267445-1-jmattson@google.com>
Message-Id: <20210520230339.267445-3-jmattson@google.com>
Mime-Version: 1.0
References: <20210520230339.267445-1-jmattson@google.com>
X-Mailer: git-send-email 2.31.1.818.g46aad6cb9e-goog
Subject: [PATCH 02/12] KVM: x86: Wake up a vCPU when kvm_check_nested_events fails
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Jim Mattson <jmattson@google.com>, Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

At present, there are two reasons why kvm_check_nested_events may
return a non-zero value:

1) we just emulated a shutdown VM-exit from L2 to L1.
2) we need to perform an immediate VM-exit from vmcs02.

In either case, transition the vCPU to "running."

Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/x86.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d517460db413..d3fea8ea3628 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9468,8 +9468,8 @@ static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
 
 static inline bool kvm_vcpu_running(struct kvm_vcpu *vcpu)
 {
-	if (is_guest_mode(vcpu))
-		kvm_check_nested_events(vcpu);
+	if (is_guest_mode(vcpu) && kvm_check_nested_events(vcpu))
+		return true;
 
 	return (vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE &&
 		!vcpu->arch.apf.halted);
-- 
2.31.1.818.g46aad6cb9e-goog

