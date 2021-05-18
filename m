Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A40F38784B
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 14:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348993AbhERMDB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 08:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348968AbhERMCy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 08:02:54 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 158B8C061756;
        Tue, 18 May 2021 05:01:36 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id w1so4564338pfu.0;
        Tue, 18 May 2021 05:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+j3s61DfilBbdVnALbykcBci/7JJ6WTH2JZ9k+XRHnU=;
        b=JoYONhNC/crNh3EiW+c93OtVBpj0HK7UEZNWa7+op6Y46s/45mG2LQxvjZeOb20Zp6
         yz/dezxs45qjMBA4KvEMn62iF1Uonlb37c0JTrddjLa4CnVK+6o5DGiSGNWCiFAoV2A2
         YRaJrnBwb+UlSs+z5kc6uxUNQ+6a1IEE2BWsbVIERlQqZkjGtFcUFJ3At/gBJkdwMD3o
         cXUREVb2h0Z6tHaIatje+Z84bYjuGafvg/noM/WmxV+vPchX3+QasW3HzrVgHVZu1i3Z
         zbnu1XuziJY6RTFDsqP5CQe1x3hgEgP0di1jZRN/1LNaXAc7M61pB8x601joEt5Ws5cG
         LCdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+j3s61DfilBbdVnALbykcBci/7JJ6WTH2JZ9k+XRHnU=;
        b=mewptrc63s16TZcx1Ok9bNR3zvp25kcKnemG1M6TEAbta3VmBvj4PCQrOzccQixq1M
         oejhKeKftCAOerRHalCV9HXbbrPPsByGAI16JsFzPcRRGrlYY2AKBtym4JiGJgBrBGao
         mYN0YNScEv71uNk4nCc5eF7gyhlhkurcYGvIzkqU6sOlhkt1s8Be6pPlNhZ/w7FwcDNK
         ob42YwCwdtTZxL7vz8oWSQmGnyze8z3ki3jAIbG/y5/4cj4xBizhNj+d5OIh3MHMviG0
         Z8pSYhNxcpFee6F/7lylOFNrimuEvAIMzCBQuHWIsIjzORaJ282lTH39GxtFxBa0eaHz
         0v8Q==
X-Gm-Message-State: AOAM533mnUVfQgeOaVtWl6uRpJBcT7L59SPjTXn2uW3nP9LBF2jeHCri
        J8jfGQIPD5xiLJaYtooxGadyKWHRqoQ=
X-Google-Smtp-Source: ABdhPJzB4JhjqKUiQijF4pjiGVjvdSRJOxy7RYQ6tKSTMs1ehMQtVyroivlCYro1QV44ABOEAObA1w==
X-Received: by 2002:a05:6a00:1509:b029:2de:6765:276b with SMTP id q9-20020a056a001509b02902de6765276bmr2508738pfu.67.1621339295407;
        Tue, 18 May 2021 05:01:35 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.53])
        by smtp.googlemail.com with ESMTPSA id l20sm12757394pjq.38.2021.05.18.05.01.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 May 2021 05:01:34 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v4 2/5] KVM: X86: Bail out of direct yield in case of under-committed scenarios
Date:   Tue, 18 May 2021 05:00:32 -0700
Message-Id: <1621339235-11131-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1621339235-11131-1-git-send-email-wanpengli@tencent.com>
References: <1621339235-11131-1-git-send-email-wanpengli@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

In case of under-committed scenarios, vCPU can get scheduling easily,
kvm_vcpu_yield_to add extra overhead, we can observe a lot of race
between vcpu->ready is true and yield fails due to p->state is
TASK_RUNNING. Let's bail out in such scenarios by checking the length
of current cpu runqueue, it can be treated as a hint of under-committed
instead of guarantee of accuracy. The directed_yield_successful/attempted
ratio can be improved from 50+% to 80+% in the under-committed scenario.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v2 -> v3:
 * update patch description
v1 -> v2:
 * move the check after attempted counting
 * update patch description

 arch/x86/kvm/x86.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9b6bca616929..dfb7c320581f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8360,6 +8360,9 @@ static void kvm_sched_yield(struct kvm_vcpu *vcpu, unsigned long dest_id)
 
 	vcpu->stat.directed_yield_attempted++;
 
+	if (single_task_running())
+		goto no_yield;
+
 	rcu_read_lock();
 	map = rcu_dereference(vcpu->kvm->arch.apic_map);
 
-- 
2.25.1

