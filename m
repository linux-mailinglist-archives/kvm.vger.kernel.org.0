Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89BA14C0AEC
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 05:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237529AbiBWETq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 23:19:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237659AbiBWETo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 23:19:44 -0500
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1934D3D499
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 20:19:17 -0800 (PST)
Received: by mail-il1-x149.google.com with SMTP id r2-20020a927602000000b002c1ebd3a6e0so7656422ilc.0
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 20:19:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=JyyyRU0Fb1h464jAcK6L7YZrRrm3og/rpFqGL6PF6iw=;
        b=bte3DLwmCbFrLIy8MAHoqmeLXkr2nx9dpQc8pX1REmlId81Kfp2wHiRVIjVzU597f3
         OJWSrDNi3Ibv3zKu2v6y+t8f+8TChmx2PeacGOBDpz56PvyeY42pBs8N4oMUhiZ+3y0Y
         9eLuBdhmX9YJGsIMj8YwVy83BSBhATRf19xNZuME2TdDtoVgm5SZlLGzmTpsG6Qx2RIN
         1PLCmR7bwhfPh6iC1DqpcYs7VaAeB5THDDu/mgUX08myQcPsUd9su1YOy1GYITH97p0u
         iEjt2sPDhWbnmuecOuJ3UJYPZZL3ddmic9VW5o0gSZaGdnWBHz6CCIQTcxN1tJj1MK9+
         kLWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=JyyyRU0Fb1h464jAcK6L7YZrRrm3og/rpFqGL6PF6iw=;
        b=ltqS73M822d9e02wFzFZTKxhSplaUk0DcqQiWPU47aAAocoEdNqHA4sEqP/0bx0O8M
         H3YJPYOOqaxVctG2d1F4nsfVRGz53+YBMyAC12qtfaZwKICXecX97SsrxWkKSVyjN/td
         kAktp9oHsyBVx2PfKT040QF4GkPwtcGE6u+aXPW7n4ulkIx3X+kfaRhioVrxJiizHE28
         ogVp6o8pArTkj/UosKAVODCmgmhWbCzXSE3XM63e+8AdxmSOSsDf3sQo2hDt6a16h0kW
         z4YflEJZMGCvCFyUuuOYsuuJ8ZzR/sr2dbKEg1hMFlRIeO1pjuwpp0Z48eN1CoI862Dy
         6mHg==
X-Gm-Message-State: AOAM531DC/8rgOUHXaDSnSXOSa10M4nNOOHDyp3R6o0xzD0nuod1JIah
        lDOMs7njk1xz5FJL2N9jOWTM8sQMs88=
X-Google-Smtp-Source: ABdhPJwjmsCO0/IWwha83kfQibq2v271bQNKm/fd9EQafKh+WjR98I1C7Cjw6nAxPvE1KhM8csV18OawS1E=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a92:7c12:0:b0:2be:155d:13fd with SMTP id
 x18-20020a927c12000000b002be155d13fdmr22504603ilc.162.1645589956441; Tue, 22
 Feb 2022 20:19:16 -0800 (PST)
Date:   Wed, 23 Feb 2022 04:18:32 +0000
In-Reply-To: <20220223041844.3984439-1-oupton@google.com>
Message-Id: <20220223041844.3984439-8-oupton@google.com>
Mime-Version: 1.0
References: <20220223041844.3984439-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v3 07/19] KVM: arm64: Rename the KVM_REQ_SLEEP handler
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Peter Shier <pshier@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Oliver Upton <oupton@google.com>,
        Andrew Jones <drjones@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The naming of the kvm_req_sleep function is confusing: the function
itself sleeps the vCPU, it does not request such an event. Rename the
function to make its purpose more clear.

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/kvm/arm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index b4987b891f38..6af680675810 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -665,7 +665,7 @@ void kvm_arm_resume_guest(struct kvm *kvm)
 	}
 }
 
-static void vcpu_req_sleep(struct kvm_vcpu *vcpu)
+static void kvm_vcpu_sleep(struct kvm_vcpu *vcpu)
 {
 	struct rcuwait *wait = kvm_arch_vcpu_get_wait(vcpu);
 
@@ -723,7 +723,7 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
 {
 	if (kvm_request_pending(vcpu)) {
 		if (kvm_check_request(KVM_REQ_SLEEP, vcpu))
-			vcpu_req_sleep(vcpu);
+			kvm_vcpu_sleep(vcpu);
 
 		if (kvm_check_request(KVM_REQ_VCPU_RESET, vcpu))
 			kvm_reset_vcpu(vcpu);
-- 
2.35.1.473.g83b2b277ed-goog

