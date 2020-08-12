Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA7124254E
	for <lists+kvm@lfdr.de>; Wed, 12 Aug 2020 08:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbgHLGa6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Aug 2020 02:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbgHLGa5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Aug 2020 02:30:57 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7026CC06174A;
        Tue, 11 Aug 2020 23:30:57 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id d19so507812pgl.10;
        Tue, 11 Aug 2020 23:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=trdiW9zMK2+IQ+GVd+J+GTCed/wEwFJbqPAdAmO4NQc=;
        b=McWIxxwyUI5ufch4LIkF1S5bg//D2wlzd4FFDVqc5u2EhUYGX4lbN62eBnEo3RwTvQ
         yGnBt/WM2VMSnIf2SDHR1UqFKk2DcTtSHPzVwLlFkF1MUfrkAOYHzlRaNZ579TNhrtbJ
         MWAntXg0ohh5FuEhHgvk1py+VEbAXgLNlvSiFTSovAdvSy7ZurpIaOFOUAaYCN4/hRWu
         TILSkYMlHqSEuiS3CUYBmKSty54GDONwwYzpcOXrhBD57Ey0xXifvCINdkQ1SDRsePAz
         ileZlWUvN0OmCuQqqa1UXtMtgqFVztijFmoXNTvAlSaXRL9K38IJClQwq1iEpGFLmAZO
         1A8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=trdiW9zMK2+IQ+GVd+J+GTCed/wEwFJbqPAdAmO4NQc=;
        b=I94oniRWatmuKZOnJO70UGoiaWNDZxbtY/qpxYEhWNf/9PfaNvw0pLob/P9k1CQQQt
         QGYhOhHV+lw9a3KznmSDA8+0xikw46ddKIueqBatpoKzMoKmEzQ/9sP+seVB5fxyTZZD
         CtmKF+4mYn52lzR7eqlp2P+QONre1ZxouevOGHQQoDORaaDAm1V3zOsVOmN8PnMftkBj
         LKU9ElgrlVutZ5odvwwlW6oanpxYwgOhHsSLde0Hcc7oQ5M3LyOmO4vTk0muxosgHKtz
         SJiikO2w57Gcw0b7h5Jh/6JSZN6zuicua8iaQvppf/RX3gDUrpXY5Q2xnbbDGWqW3ApK
         7gFA==
X-Gm-Message-State: AOAM533yrbKDb/g/8bLcJXiTDJ84giwcFOB993DBLdC24sKrsqlclrJU
        XekYOuo6ba8PlqfTpnonYD9Ngg6C
X-Google-Smtp-Source: ABdhPJzL/MIq0NLmjZEk0XNv+fYrz44B+SR2oXueWwPzXe3QKuLLUU4KdBQM2nwd+mTArYONg34Tsg==
X-Received: by 2002:a63:e907:: with SMTP id i7mr3952408pgh.210.1597213856848;
        Tue, 11 Aug 2020 23:30:56 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id x20sm11117344pjp.3.2020.08.11.23.30.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Aug 2020 23:30:56 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2 2/2] KVM: LAPIC: Guarantee the timer is in tsc-deadline mode when setting
Date:   Wed, 12 Aug 2020 14:30:38 +0800
Message-Id: <1597213838-8847-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1597213838-8847-1-git-send-email-wanpengli@tencent.com>
References: <1597213838-8847-1-git-send-email-wanpengli@tencent.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Check apic_lvtt_tscdeadline() mode directly instead of apic_lvtt_oneshot()
and apic_lvtt_period() to guarantee the timer is in tsc-deadline mode when
wrmsr MSR_IA32_TSCDEADLINE.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v1 -> v2:
 * fix indentation

 arch/x86/kvm/lapic.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 79599af..abaf48e 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2193,8 +2193,7 @@ void kvm_set_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu, u64 data)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
-	if (!kvm_apic_present(vcpu) || apic_lvtt_oneshot(apic) ||
-			apic_lvtt_period(apic))
+	if (!kvm_apic_present(vcpu) || !apic_lvtt_tscdeadline(apic))
 		return;
 
 	hrtimer_cancel(&apic->lapic_timer.timer);
-- 
2.7.4

