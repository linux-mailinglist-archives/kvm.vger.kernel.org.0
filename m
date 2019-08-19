Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B53095175
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2019 01:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729006AbfHSXEb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Aug 2019 19:04:31 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:35401 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728894AbfHSXE3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Aug 2019 19:04:29 -0400
Received: by mail-pl1-f201.google.com with SMTP id s21so2841457plr.2
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2019 16:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=yvso1VMUv5HDW/FWRWW4aLcQc7dQhn5xX7myTuMzxOM=;
        b=Vj3S26QuOjsxQcqWZv2x1d1sJe1SuGuBsGjkgram6TdMUJOBdkigrttT8pumAYozyX
         cbZOjPfub6CCO9zMBScmBZdDQBxaPkinjmvSpAEJot73Ty883i1IRvl52wcCm+EoBmM4
         9np7OFo65LbNf1yybsZPcctyKC7N+WkjTavobcwpw/ClTqmgyi2unvGp+6fn6DQa7di4
         qXFzK4YsQ1J37H2pK7x0FSVakMvvQ8QWh2gRoNefui+YKAsSgNe/71/FHkdFJGnKLrtx
         W9I3RPv/H+8tdgzCJJBOe7Qb1eCn3BUB2Yvlz3tt5Dv64LN7+xkF4vzqMM2pZZLL9vhO
         KnLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=yvso1VMUv5HDW/FWRWW4aLcQc7dQhn5xX7myTuMzxOM=;
        b=ODaZKLM/7oE+msN7XgRVWcIQLErKiSAG8ctgfPkC8pOiKj8jMEQwczn+xI/AF4Qd0z
         g10nXg9KxXAx0vuo7nJ6hYGc3EEegxY5u1XjWBNwwcePdeNR+8wrvFh3E6rIQC5ApCVU
         0oa/7qoOLEg7d6xizVkLY4ZPvhUJJTjXd3YrM/bLjIOsknpKM/q0IDT25Tr1z1hQaguK
         pXnPmZ8ma9DYHyCPhG5MWXEDP7L0SilqWp2ACcMyzhSm6BRkjRK6zenQnT7obJwjJQ26
         n2poZtrbvAoj6Ur/47QGxz2Fsw3aki2Sn54xf9JxBQ9Wu6Dm8sZfTLjZqOCGMaEhtqhM
         U/JQ==
X-Gm-Message-State: APjAAAV59mTfbRz703Sc4Pj0pPdBvU+/v7HDSWq/5pYegL+1yS52eKO/
        BgzA8YYmf/ZT8fMuwziISbX9U6zmww==
X-Google-Smtp-Source: APXvYqz17SfaxDarP4cPp/OzAe0kryC+XSYGBc2IGWqxdB/hJbMYggEGwLNS58HQu2HNj1UTKQ39ZjcXZQ==
X-Received: by 2002:a63:6888:: with SMTP id d130mr21122501pgc.197.1566255868467;
 Mon, 19 Aug 2019 16:04:28 -0700 (PDT)
Date:   Mon, 19 Aug 2019 16:04:22 -0700
Message-Id: <20190819230422.244888-1-delco@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
Subject: [PATCH] KVM: lapic: restart counter on change to periodic mode
From:   Matt delco <delco@google.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com
Cc:     kvm@vger.kernel.org, Matt Delco <delco@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Matt Delco <delco@google.com>

Time seems to eventually stop in a Windows VM when using Skype.
Instrumentation shows that the OS is frequently switching the APIC
timer between one-shot and periodic mode.  The OS is typically writing
to both LVTT and TMICT.  When time stops the sequence observed is that
the APIC was in one-shot mode, the timer expired, and the OS writes to
LVTT (but not TMICT) to change to periodic mode.  No future timer events
are received by the OS since the timer is only re-armed on TMICT writes.

With this change time continues to advance in the VM.  TBD if physical
hardware will reset the current count if/when the mode is changed to
period and the current count is zero.

Signed-off-by: Matt Delco <delco@google.com>
---
 arch/x86/kvm/lapic.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 685d17c11461..fddd810eeca5 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1935,14 +1935,19 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 
 		break;
 
-	case APIC_LVTT:
+	case APIC_LVTT: {
+		u32 timer_mode = apic->lapic_timer.timer_mode;
 		if (!kvm_apic_sw_enabled(apic))
 			val |= APIC_LVT_MASKED;
 		val &= (apic_lvt_mask[0] | apic->lapic_timer.timer_mode_mask);
 		kvm_lapic_set_reg(apic, APIC_LVTT, val);
 		apic_update_lvtt(apic);
+		if (timer_mode == APIC_LVT_TIMER_ONESHOT &&
+		    apic_lvtt_period(apic) &&
+		    !hrtimer_active(&apic->lapic_timer.timer))
+			start_apic_timer(apic);
 		break;
-
+	}
 	case APIC_TMICT:
 		if (apic_lvtt_tscdeadline(apic))
 			break;
-- 
2.23.0.rc1.153.gdeed80330f-goog

