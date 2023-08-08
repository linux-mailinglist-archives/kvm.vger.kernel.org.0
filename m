Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6455C774F3F
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 01:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbjHHXVB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 19:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjHHXVA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 19:21:00 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EE9719B6
        for <kvm@vger.kernel.org>; Tue,  8 Aug 2023 16:21:00 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5868992ddd4so74226157b3.0
        for <kvm@vger.kernel.org>; Tue, 08 Aug 2023 16:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691536859; x=1692141659;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h31RifgLdWj/uBkkEanO2XNAftVRa4x/sEAr5Du6O7s=;
        b=3HkpHRvUGz0wWRT9OA2Ov4hn6J6IuWP0KypK80EvpNWkaxvw5xrqpgKSc6cN/pQUeS
         BTy0QrS4OgiVI2hc16+7oGnfLI3JzDXO3tZCfX3Ga31R7/IEG9HQVP49xveMYR2Sy096
         t+cBlH5TzUA4S+paOIda4LbGc2Mp/7c3DM7mNrOQuHOZ1W0Zhu/4Z4QjMaZuOF6vlKYt
         rJ3Wfol3W8ZzlZQEZ4/84C3qOsIssVV4BC+kcMmhQ28SBdY+slKFRYau7RtFnSaRpGUR
         y3JbWRiPUgHG0pZlHoQ8PusqX5v0e3hDdT90UCtfbztjJo/RI5+6Waht9EJSCMWPjTTM
         mEHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691536859; x=1692141659;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h31RifgLdWj/uBkkEanO2XNAftVRa4x/sEAr5Du6O7s=;
        b=TCXRj1aB6ZKOs8xYpXoRaKJv5gC6m70vYNOq6L4l8UUKKflBPospaIdp/Pv20S57WQ
         UuS0c+23GxmvWJeAhu6QJ88SwdPYLikpYRf2mGuIGQlgETvlkoLwTc3LqXrTxNPYXX0C
         whGVKHFMYyiIoVhJj2tEMpBaWouSUmQz6X8qTlQXtsbeknuw0N53grfvybKb/x4LUJdg
         0o4pmGvtV6C/Y3+IV98Phgs+SrAKb3MBV4EJOi6Qd5razDvjUm+r2CRmITxWSq1abTC0
         DNIcnMV/SeM3j+0L8+l0NoYT4HpN+4ff8YO2YVX4p0ORw63BQU0gpbOb3DGSRNhpF+bf
         o9Rw==
X-Gm-Message-State: AOJu0YwlwTfUUdWFoZny0BbySvrDFeSlNm7Qms+AJ/xRFHwnnUueL2jH
        96+EgJeklDZVZGoGY5mqrmRNilzWK9c=
X-Google-Smtp-Source: AGHT+IFacH1gV3EFOlAiXA5r13GnRn0tz4keJlj3GrBkHHQsxR2ixuO7JpkZvWdwq6OLOMIvvXHRz6bdj+I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b707:0:b0:586:a689:eb69 with SMTP id
 v7-20020a81b707000000b00586a689eb69mr25680ywh.2.1691536859434; Tue, 08 Aug
 2023 16:20:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  8 Aug 2023 16:20:57 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
Message-ID: <20230808232057.2498287-1-seanjc@google.com>
Subject: [PATCH] KVM: x86: Remove WARN sanity check on hypervisor timer vs.
 UNINITIALIZED vCPU
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yikebaer Aizezi <yikebaer61@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop the WARN in KVM_RUN that asserts that KVM isn't using the hypervisor
timer, a.k.a. the VMX preemption timer, for a vCPU that is in the
UNINITIALIZIED activity state.  The intent of the WARN is to sanity check
that KVM won't drop a timer interrupt due to an unexpected transition to
UNINITIALIZED, but unfortunately userspace can use various ioctl()s to
force the unexpected state.

Drop the sanity check instead of switching from the hypervisor timer to a
software based timer, as the only reason to switch to a software timer
when a vCPU is blocking is to ensure the timer interrupt wakes the vCPU,
but said interrupt isn't a valid wake event for vCPUs in UNINITIALIZED
state *and* the interrupt will be dropped in the end.

Reported-by: Yikebaer Aizezi <yikebaer61@gmail.com>
Closes: https://lore.kernel.org/all/CALcu4rbFrU4go8sBHk3FreP+qjgtZCGcYNpSiEXOLm==qFv7iQ@mail.gmail.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a6b9bea62fb8..fa7eeb45b8e3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11091,12 +11091,17 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 			r = -EINTR;
 			goto out;
 		}
+
 		/*
-		 * It should be impossible for the hypervisor timer to be in
-		 * use before KVM has ever run the vCPU.
+		 * Don't bother switching APIC timer emulation from the
+		 * hypervisor timer to the software timer, the only way for the
+		 * APIC timer to be active is if userspace stuffed vCPU state,
+		 * i.e. put the vCPU into a nonsensical state.  Only an INIT
+		 * will transition the vCPU out of UNINITIALIZED (without more
+		 * state stuffing from userspace), which will reset the local
+		 * APIC and thus smother the timer anyways, i.e. the APIC timer
+		 * IRQ(s) will be dropped no matter what.
 		 */
-		WARN_ON_ONCE(kvm_lapic_hv_timer_in_use(vcpu));
-
 		kvm_vcpu_srcu_read_unlock(vcpu);
 		kvm_vcpu_block(vcpu);
 		kvm_vcpu_srcu_read_lock(vcpu);

base-commit: fdf0eaf11452d72945af31804e2a1048ee1b574c
-- 
2.41.0.640.ga95def55d0-goog

