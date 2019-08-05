Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9B881020
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2019 04:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbfHECDg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Aug 2019 22:03:36 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45303 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbfHECDf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Aug 2019 22:03:35 -0400
Received: by mail-pf1-f196.google.com with SMTP id r1so38758746pfq.12;
        Sun, 04 Aug 2019 19:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Jyl7Q+fNfa4JowIqcItEgbQqxdMDKkuTAtedoCYt2UY=;
        b=FvtLpj1sIKat6dYZDCdBvSFKvcXW3Uzr84PPtyV93kaWXBpfrl0mFg4f1neMu+P9Em
         I4fQvEcqTuyi0x86KFVggzspCC7VOzaD0TIOapteN+A+KR6LwI5y+l9cLxR4n4Rc09a9
         I7vvBsLWOkbECEO2/Vwc+tAZGVv8EPoajf/CHljXF9KY5DSY6o78B1rorXDplCOTV4+L
         2fZYeRVqqrhdRT3bap2WHJRAr6i29xQAYKyBS5/O315xGBd/3v6TrUT/Qh32TldsY96q
         K+7fVqzqxtHppK8rPWIjeZG0Swen6j9v06MbEiRkj2L5FzrbR5ITOQ3fneyvn6XS6c5r
         6NCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Jyl7Q+fNfa4JowIqcItEgbQqxdMDKkuTAtedoCYt2UY=;
        b=RuUwGksfrIDE68rzrzgiiTBlhW0OL3vxWSkt3ZY9GyjhQ/4OFzMiuZynYMcAPY5DGG
         JVeOTyddu540vN54mjgKuShgIOreBbtuyeSt6s/SRmz7aT3Q2RUm9eKDdrLvPOA+0nVY
         LAj6NHD09cKZOKjtNETZg4u9P+RD6Glu0dQqOUOCB0OCSfAJKPqhvm5B2X+SyVym983t
         5WB7WUQfpTo4oA0LfyaBOBLzYDQiSaZlasH69fYrNDxEOKQh+9loTPEbaSt0HQGiZhGY
         yjXQQxWIR+9kd+WR720lFsADgRxWXnJnPmZ/9kYTuIjuURxUbtU7dYtPNBKpV3GvWJ8w
         xFUQ==
X-Gm-Message-State: APjAAAXjKAAF2selOS+6WTznxwnoI560Fsi0su4fg5pm/fk0t8Obafrv
        7VsJofvnHk/jLDMSA5ElAejXguip
X-Google-Smtp-Source: APXvYqwRqJB+jqVWCZuUvoalycZom+qF1VmCfkrl4I+LHUC3Ms2Glw+z/ecn2x+sAYTkrXOs8cxrUQ==
X-Received: by 2002:a63:e54f:: with SMTP id z15mr133763407pgj.4.1564970614483;
        Sun, 04 Aug 2019 19:03:34 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id o32sm14739365pje.9.2019.08.04.19.03.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 04 Aug 2019 19:03:34 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH v4 2/6] KVM: LAPIC: Don't need to wakeup vCPU twice afer timer fire
Date:   Mon,  5 Aug 2019 10:03:20 +0800
Message-Id: <1564970604-10044-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564970604-10044-1-git-send-email-wanpengli@tencent.com>
References: <1564970604-10044-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

kvm_set_pending_timer() will take care to wake up the sleeping vCPU which
has pending timer, don't need to check this in apic_timer_expired() again.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 0aa1586..685d17c 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1548,7 +1548,6 @@ static void kvm_apic_inject_pending_timer_irqs(struct kvm_lapic *apic)
 static void apic_timer_expired(struct kvm_lapic *apic)
 {
 	struct kvm_vcpu *vcpu = apic->vcpu;
-	struct swait_queue_head *q = &vcpu->wq;
 	struct kvm_timer *ktimer = &apic->lapic_timer;
 
 	if (atomic_read(&apic->lapic_timer.pending))
@@ -1566,13 +1565,6 @@ static void apic_timer_expired(struct kvm_lapic *apic)
 
 	atomic_inc(&apic->lapic_timer.pending);
 	kvm_set_pending_timer(vcpu);
-
-	/*
-	 * For x86, the atomic_inc() is serialized, thus
-	 * using swait_active() is safe.
-	 */
-	if (swait_active(q))
-		swake_up_one(q);
 }
 
 static void start_sw_tscdeadline(struct kvm_lapic *apic)
-- 
2.7.4

