Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C048D5F1668
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 01:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232051AbiI3XAO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 19:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232112AbiI3XAL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 19:00:11 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F662B266
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 16:00:10 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id y16-20020a17090322d000b0017848b6f556so4071444plg.19
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 16:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date;
        bh=1QSMu8aoY/jEAF1lKG7WvfOseFpqZMOSl6wmTYMBwPw=;
        b=fB4GwKZ3OMfwNycXcUfmgNlsB5fkbITfuIiSzVyxjrjCnmFGoQ9yGeFuEqC7AF3tde
         sKjAwEZdoLGIrwafW409XwahL3n/tQhVOGaZTc7ebO6iFanmT1OOtaKRfWfU+MpsXdtV
         kM2BqjKGCYc1JXRnL3CiF5X1Bdc4n+42Uxv3PWr5g2ZwQUWfAb+BDKavskp61HJliaHW
         0oLW5diKtYrZwmEgauM4RwquTl/D30iEpVIgZ+ajwEKr8Kb1YWgxXvyFbxTtwa1JSYPq
         jckIyRHVJkRZaI8l3JdRPYUpsoX8m1lJ3mGcodeXtI3f4jRIi9MIsWoIF6KfC8fgYHoY
         xvOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date;
        bh=1QSMu8aoY/jEAF1lKG7WvfOseFpqZMOSl6wmTYMBwPw=;
        b=jZQGnNDONucbWVpqFvQ2psBBmHCfs9IO+HgBFDxPbrGRKHjcz0qdYwEva6A95hp3bW
         F2LNy5M5s9Xg38iVWQup14eHP8H7+1dqmQCYHsH+7MgGV2TUlOD7dP6J1KjlGk8TWHfG
         6M+OdGWMYKRyy789VEWkfdAtZ8MIGVYJxgjPu2FZ8u18o+drGBWR6H0doRyfI0s3f7j2
         HR6Ld57roKSNrgWY9oYha/HHFTEe55mBngpDDZ8mF/Vke87TsS0VPNzi3T+qWScD6e2t
         orMRihnyEX1ySqANDvdhr6vJ4f5IW7NxG4UvOOjbG6bAXPfmQCuNRO7Ul8xdzfLsz8xY
         pUWg==
X-Gm-Message-State: ACrzQf3LWaJFy9aVOUc3LIPA8wMUizV5WzXAFA/gwPvESlhiKkMDLeUX
        zBhE9lGYd+2kfaw2kfKbyhIyQxZ0gbE=
X-Google-Smtp-Source: AMsMyM4e3iRj0bwKPO4Mh0i367Pha65uA54RGjkwlD/8HnUiJhQHesqQ3gBkhZQI37PJu0xq5u8PtFdNRxI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2cb:b0:171:4f0d:beb6 with SMTP id
 s11-20020a17090302cb00b001714f0dbeb6mr10909525plk.53.1664578810206; Fri, 30
 Sep 2022 16:00:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 30 Sep 2022 23:00:08 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20220930230008.1636044-1-seanjc@google.com>
Subject: [PATCH] KVM: x86: Exempt pending triple fault from event injection
 sanity check
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel test robot <yujie.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Exempt pending triple faults, a.k.a. KVM_REQ_TRIPLE_FAULT, when asserting
that KVM didn't attempt to queue a new exception during event injection.
KVM needs to emulate the injection itself when emulating Real Mode due to
lack of unrestricted guest support (VMX) and will queue a triple fault if
that emulation fails.

Ideally the assertion would more precisely filter out the emulated Real
Mode triple fault case, but rmode.vm86_active is buried in vcpu_vmx and
can't be queried without a new kvm_x86_ops.  And unlike "regular"
exceptions, triple fault cannot put the vCPU into an infinite loop; the
triple fault will force either an exit to userspace or a nested VM-Exit,
and triple fault after nested VM-Exit will force an exit to userspace.
I.e. there is no functional issue, so just suppress the warning for
triple faults.

Opportunistically convert the warning to a one-time thing, when it
fires, it fires _a lot_, and is usually user triggerable, i.e. can be
used to spam the kernel log.

Fixes: 7055fb113116 ("KVM: x86: Treat pending TRIPLE_FAULT requests as pending exceptions")
Reported-by: kernel test robot <yujie.liu@intel.com>
Link: https://lore.kernel.org/r/202209301338.aca913c3-yujie.liu@intel.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index eb9d2c23fb04..20497685e6d1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9972,7 +9972,20 @@ static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu,
 	    kvm_x86_ops.nested_ops->has_events(vcpu))
 		*req_immediate_exit = true;
 
-	WARN_ON(kvm_is_exception_pending(vcpu));
+	/*
+	 * KVM must never queue a new exception while injecting an event; KVM
+	 * is done emulating and should only propagate the to-be-injected event
+	 * to the VMCS/VMCB.  Queueing a new exception can put the vCPU into an
+	 * infinite loop as KVM will bail from VM-Enter to inject the pending
+	 * exception and start the cycle all over.
+	 *
+	 * Exempt triple faults as they have special handling and won't put the
+	 * vCPU into an infinite loop.  Triple fault can be queued when running
+	 * VMX without unrestricted guest, as that requires KVM to emulate Real
+	 * Mode events (see kvm_inject_realmode_interrupt()).
+	 */
+	WARN_ON_ONCE(vcpu->arch.exception.pending ||
+		     vcpu->arch.exception_vmexit.pending);
 	return 0;
 
 out:

base-commit: c59fb127583869350256656b7ed848c398bef879
-- 
2.38.0.rc1.362.ged0d419d3c-goog

