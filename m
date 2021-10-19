Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4754330E4
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 10:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234718AbhJSIPw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 04:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234691AbhJSIPt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 04:15:49 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3324AC06161C;
        Tue, 19 Oct 2021 01:13:37 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id oa12-20020a17090b1bcc00b0019f715462a8so2026215pjb.3;
        Tue, 19 Oct 2021 01:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VL752dQ/ApTxdZicGQxzzNcLpxU27cNK3lNjF5txPOw=;
        b=WgpKJtaTfoyGk4NrJi0/ACPr965uwGZK0C2I3opbI50uwNhUSv8EMjJHdr/R/Ypr0d
         RosDVLkBc8aKr8F6caDHRuJtfUt/6/eWeNlSzXOBQGVsP9m6yEZ3xXkB5I05d/TwPLfi
         kwXIgQ1WtOe/RA5rAVVPDZhX8S+5SOvJ1z8Qbn+z2W4qkDTn3DU5E2r1I3i2vRCHmlwg
         ByPCmEYb4bAK8pz/rK9a6vhK3NhPM2b3n0k/v1SMHyvIpDWnzTava0NPWeoDd23o8Cuo
         CJmC9+BqK7+N4E6paos5B3hDCFYLW88evhXBW6zIHwTUzPGFo/SWMqhuguQSaVajNiJU
         SDWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VL752dQ/ApTxdZicGQxzzNcLpxU27cNK3lNjF5txPOw=;
        b=llyObr4o91NNLj+pY/qmLBCBHm/tRW9PiSeK+dYYhZ4CFsQ5qyy4eCETTBkkGGGWcx
         qG0JcsQ6EEQGJWXG5L2R/36JeJhoQHEosG/HM3a7vS4Gy+9c/eQX/g0f1xqkBpNQuAZT
         R0fMsQqO2U82LuCDOiDY5C2woZBPqqBjKt4kJM0TxzIy0OfwNhG226Zd2NsN0ZZTYgvA
         7/dNtQr8A9MThH1OZHqNukV9PdD/m7NkJJxzl/G8Z6kNncfVDX/u59yR9nAtdNZA9N8J
         1sPSHXT91Xc5+sfXQwqVMfMnk9yZUDU36VWoHd9jDk5/QYD/Eyrv6g6s82Jp8Ye5/BjY
         S3LQ==
X-Gm-Message-State: AOAM5338lRu7kDO2dTh2P10tk2FpLkQePnB1ESij5CaA+RaYnizWGmrx
        D70Y3fylHnVBGNthEkRnbtglZbxjuq9SJw==
X-Google-Smtp-Source: ABdhPJy6DCFdFFnNb4wPvjMEo8q12xi6dK403Ji6mA6X4dOS2YqjvAKt4Mu2492lgx703+8Ny3s7EQ==
X-Received: by 2002:a17:902:bb94:b0:13c:9113:5652 with SMTP id m20-20020a170902bb9400b0013c91135652mr32687269pls.70.1634631216561;
        Tue, 19 Oct 2021 01:13:36 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.110])
        by smtp.googlemail.com with ESMTPSA id f15sm3254064pfe.132.2021.10.19.01.13.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Oct 2021 01:13:36 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v3 3/3] KVM: vCPU kick tax cut for running vCPU
Date:   Tue, 19 Oct 2021 01:12:40 -0700
Message-Id: <1634631160-67276-3-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1634631160-67276-1-git-send-email-wanpengli@tencent.com>
References: <1634631160-67276-1-git-send-email-wanpengli@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Sometimes a vCPU kick is following a pending request, even if @vcpu is 
the running vCPU. It suffers from both rcuwait_wake_up() which has 
rcu/memory barrier operations and cmpxchg(). Let's check vcpu->wait 
before rcu_wait_wake_up() and whether @vcpu is the running vCPU before 
cmpxchg() to tax cut this overhead.

We evaluate the kvm-unit-test/vmexit.flat on an Intel ICX box, most of the 
scores can improve ~600 cpu cycles especially when APICv is disabled.

tscdeadline_immed
tscdeadline
self_ipi_sti_nop
..............
x2apic_self_ipi_tpr_sti_hlt

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v2 -> v3:
 * use kvm_arch_vcpu_get_wait()
v1 -> v2:
 * move checking running vCPU logic to kvm_vcpu_kick
 * check rcuwait_active(&vcpu->wait) etc

 virt/kvm/kvm_main.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7851f3a1b5f7..1bc52eab0a7d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3314,8 +3314,15 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
 {
 	int me, cpu;
 
-	if (kvm_vcpu_wake_up(vcpu))
-		return;
+	me = get_cpu();
+
+	if (rcuwait_active(kvm_arch_vcpu_get_wait(vcpu)) && kvm_vcpu_wake_up(vcpu))
+		goto out;
+
+	if (vcpu == __this_cpu_read(kvm_running_vcpu)) {
+		WARN_ON_ONCE(vcpu->mode == IN_GUEST_MODE);
+		goto out;
+	}
 
 	/*
 	 * Note, the vCPU could get migrated to a different pCPU at any point
@@ -3324,12 +3331,12 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
 	 * IPI is to force the vCPU to leave IN_GUEST_MODE, and migrating the
 	 * vCPU also requires it to leave IN_GUEST_MODE.
 	 */
-	me = get_cpu();
 	if (kvm_arch_vcpu_should_kick(vcpu)) {
 		cpu = READ_ONCE(vcpu->cpu);
 		if (cpu != me && (unsigned)cpu < nr_cpu_ids && cpu_online(cpu))
 			smp_send_reschedule(cpu);
 	}
+out:
 	put_cpu();
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_kick);
-- 
2.25.1

