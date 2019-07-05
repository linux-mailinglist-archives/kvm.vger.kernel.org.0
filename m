Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4BA60939
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2019 17:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727624AbfGEPXt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jul 2019 11:23:49 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41033 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726978AbfGEPXt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jul 2019 11:23:49 -0400
Received: by mail-pg1-f194.google.com with SMTP id q4so4453864pgj.8;
        Fri, 05 Jul 2019 08:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6+TO8x752f6vXrFXdGdKz2ORTM7cjlLRwSUng/658nA=;
        b=DIE7h60jObGRoVc47IG9ZiNF+Bhmp2bJPyIuQ86xCO7ud4uMZiZZ4pxIEgtPMTBs3c
         o/VPeTbK7TQ+HE3OBIYwNt6w3vtzZDpHyps/w9JbDFsvFjLO4AqEJhAFhKGadjg/8iEN
         pVf2mgnFOnVye/zBr7JO76dYtZ5NoXA2x070oyH6YnL05qr3+WuVPi5lRTB9w7gMGE+W
         qBJOt0KFZR1UlVlVYCUBcLUJ9R2zdP4f/yM7d2tDh1cfZlM7neowt+1fto46TM2zII4/
         sAMVAiEV+chBWUHPjD0/ivvM5CiShDokuUa5b9UbaVbMWH6dwbMx1IZSvuwaOEzA9OaN
         D66A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6+TO8x752f6vXrFXdGdKz2ORTM7cjlLRwSUng/658nA=;
        b=VfF2LTfv/mdwtD4RWt/PFLO93ipxucPLJAE3v2veBdsQsZiN3KnzaS6Lp7Ylm+0y2w
         neXlyy5s1hEMvSILMUupMLXXVTJ3AZXvlR8DCQGm9cU+jhzK3UIrhx0AtoHyNKH3iapl
         siFlDLYYqDcXDuvnfOcztApRpCrpkePOABVza4KokqwzDeSvUdx9ebW8SJ2WlQkjBKZ2
         23vNzhJUH2yeYu1WjCP7sZkl66Ru4sgQYQg3gke6IbSHxoz4wieHB0fctuhTthC9iYqm
         sjx3q8Gw6hHaFJKjWMLWZgHhipXfu4kb2FxUeJtGMCHWFnmD7zRG4K5wXxpFN69/uqrj
         CBpQ==
X-Gm-Message-State: APjAAAVO3RSJC39O+YkscB9qmdzR2HZHyGSCqyK46i7mog9kUguRg8oH
        9dESbVbLDg0SW6HmllffFWAhuxhSiyw=
X-Google-Smtp-Source: APXvYqyG08eDSggmR81KJmQCvANkOaJgsaRUJUgQWnwXRNNC55d6FkcuXzynZsoxQjurdCOkrt9Ojg==
X-Received: by 2002:a63:5107:: with SMTP id f7mr6113640pgb.266.1562340228531;
        Fri, 05 Jul 2019 08:23:48 -0700 (PDT)
Received: from localhost ([2409:8a00:7815:93e0:4a4d:7eff:feb0:5c9a])
        by smtp.gmail.com with ESMTPSA id h1sm12203284pfg.55.2019.07.05.08.23.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 08:23:47 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH v2] KVM: LAPIC: Retry tune per-vCPU timer_advance_ns if adaptive tuning goes insane
Date:   Fri,  5 Jul 2019 23:23:42 +0800
Message-Id: <1562340222-31324-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Retry tune per-vCPU timer_advance_ns if adaptive tuning goes insane which 
can happen sporadically in product environment.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v1 -> v2:
 * retry max 10 times if adaptive tuning goes insane

 arch/x86/kvm/lapic.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 95affa5..bd0dbe5 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1538,6 +1538,7 @@ static inline void adjust_lapic_timer_advance(struct kvm_vcpu *vcpu,
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	u32 timer_advance_ns = apic->lapic_timer.timer_advance_ns;
 	u64 ns;
+	uint retry_count = 0;
 
 	/* too early */
 	if (advance_expire_delta < 0) {
@@ -1556,8 +1557,10 @@ static inline void adjust_lapic_timer_advance(struct kvm_vcpu *vcpu,
 	if (abs(advance_expire_delta) < LAPIC_TIMER_ADVANCE_ADJUST_DONE)
 		apic->lapic_timer.timer_advance_adjust_done = true;
 	if (unlikely(timer_advance_ns > 5000)) {
-		timer_advance_ns = 0;
-		apic->lapic_timer.timer_advance_adjust_done = true;
+		timer_advance_ns = 1000;
+		apic->lapic_timer.timer_advance_adjust_done = false;
+		if (++retry_count > 10)
+			apic->lapic_timer.timer_advance_adjust_done = true;
 	}
 	apic->lapic_timer.timer_advance_ns = timer_advance_ns;
 }
-- 
1.8.3.1

