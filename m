Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73CE6417ECB
	for <lists+kvm@lfdr.de>; Sat, 25 Sep 2021 02:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346306AbhIYA5O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 20:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346190AbhIYA5M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 20:57:12 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37559C0614ED
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 17:55:38 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id j4-20020ad454c4000000b0037a900dda7aso43166003qvx.14
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 17:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=1tsfKS32dF2lOop6Q8UszZBRwEC1JoDP5uy22kEXik0=;
        b=tJRFGMXxcfK7pjn1+YX8rDDAthpdiwDmAlAoR2O4LLVHkl7MoFkfnuCmTDY6MHO1AC
         aU5DlddWuaqvJAQ2CEADWDeGHvUIp0FI39I8iy3P4amF9cNUWQNgM57HmTykWDcy+8dY
         Mvu71xxPYDUZ2+A3pWrg86E9wAuN+QDmT67xFTEgcecgyMJgcjVmXEjzTnAcaMkNUYaw
         /ZRnegcxQxaUe1Qca+BGV3DDCVscs5r4gu+tlHzecUaMdV03kKXd/csNW6uPtiB/uByL
         0CzeZSzGROfkTu8PuYQOHZZQRRU/J1vbhU3wMhBJTHe4WQm7fS0zEQ9aK+6AU0nSmeBC
         32Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=1tsfKS32dF2lOop6Q8UszZBRwEC1JoDP5uy22kEXik0=;
        b=ClDwAId4pJSOFtLnfYSG9QWMmn28ENQ1OPtL6Cv3WIX6ysh3+5XR1zMr8+HiEDpq9X
         rYIT32JJkFluoGYAc1vpVuEiXSlrAIEYmvuIGXuHKzNAUAbb2sPrznLUXrGZGrUT2prV
         gGKC8w9n2NsGJVGjuEri0vy8K77t3Z5ImUdTwwd6FAL1o+t02I61piFqoUOf4kcVEUaQ
         2v1kdK1aoBcmy3P1oQUstc0Px+vYrsyclnu/jTep5j1EdDL+nasMrYrZI8NPpfG+Ijyo
         Hon7+eKr09y3YFJExPFCpvaALbWTKEVKTxDZGvvIkJ/sYhWCXArksu9AH/talY7MXJi3
         bHsw==
X-Gm-Message-State: AOAM533FNs3EM/l/zhoIZWnmFM01YiZetwValXhpFION1GIpfRjgYb8H
        cuBWUV7k37mW9k1lPMH8klTHKubqZLg=
X-Google-Smtp-Source: ABdhPJwPQKNSl/89/W6mMga+Zk98xyYbngE63RzqoPcRph2DGAKR41ssH/CZTrknnPOD67N3xW0Inpq3BFE=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:4c72:89be:dba3:2bcb])
 (user=seanjc job=sendgmr) by 2002:a05:6214:1593:: with SMTP id
 m19mr13005135qvw.36.1632531337323; Fri, 24 Sep 2021 17:55:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 24 Sep 2021 17:55:17 -0700
In-Reply-To: <20210925005528.1145584-1-seanjc@google.com>
Message-Id: <20210925005528.1145584-4-seanjc@google.com>
Mime-Version: 1.0
References: <20210925005528.1145584-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH 03/14] KVM: Refactor and document halt-polling stats update helper
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a comment to document that halt-polling is considered successful even
if the polling loop itself didn't detect a wake event, i.e. if a wake
event was detect in the final kvm_vcpu_check_block().  Invert the param
to the update helper so that the helper is a dumb function that is "told"
whether or not polling was successful, as opposed to having it determinine
success/failure based on blocking behavior.

Opportunistically tweak the params to the update helper to reduce the
line length for the call site so that it fits on a single line, and so
that the prototype conforms to the more traditional kernel style.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8b33f5045b4d..12fe91a0a4c8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3199,13 +3199,15 @@ static int kvm_vcpu_check_block(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
-static inline void
-update_halt_poll_stats(struct kvm_vcpu *vcpu, u64 poll_ns, bool waited)
+static inline void update_halt_poll_stats(struct kvm_vcpu *vcpu, ktime_t start,
+					  ktime_t end, bool success)
 {
-	if (waited)
-		vcpu->stat.generic.halt_poll_fail_ns += poll_ns;
-	else
+	u64 poll_ns = ktime_to_ns(ktime_sub(end, start));
+
+	if (success)
 		vcpu->stat.generic.halt_poll_success_ns += poll_ns;
+	else
+		vcpu->stat.generic.halt_poll_fail_ns += poll_ns;
 }
 
 /*
@@ -3274,9 +3276,13 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	kvm_arch_vcpu_unblocking(vcpu);
 	block_ns = ktime_to_ns(cur) - ktime_to_ns(start);
 
+	/*
+	 * Note, halt-polling is considered successful so long as the vCPU was
+	 * never actually scheduled out, i.e. even if the wake event arrived
+	 * after of the halt-polling loop itself, but before the full wait.
+	 */
 	if (do_halt_poll)
-		update_halt_poll_stats(
-			vcpu, ktime_to_ns(ktime_sub(poll_end, start)), waited);
+		update_halt_poll_stats(vcpu, start, poll_end, !waited);
 
 	if (halt_poll_allowed) {
 		if (!vcpu_valid_wakeup(vcpu)) {
-- 
2.33.0.685.g46640cef36-goog

