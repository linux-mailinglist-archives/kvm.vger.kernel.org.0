Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4BFD382E23
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 16:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237693AbhEQOC6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 10:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237645AbhEQOCw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 May 2021 10:02:52 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C51EC06175F;
        Mon, 17 May 2021 07:01:35 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id gm21so3719961pjb.5;
        Mon, 17 May 2021 07:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=tPPyKEGZVk5W3b/nB56WzLLuyaXrswVyUx1Ed/5o3O4=;
        b=atyrkP7BjqyHjY2IB7GyY0a5GmCwQFfhG0p/q6m54DEi0AY69wWhJgByPa8Y6nNmdy
         STirIna+BxQaUMp80+jQIflI7bvR3lrb3IdK++O4vUn80zYUvtsYDnLhGTDXlt9RiU64
         DyI5GDe+q9nXiprQ/HGX4de5LDWHvkjuVJIsxM+wxN8pyMGGoyw45u1v7SnGxt+fPxW9
         hA/B6NB8CIL/woWH3rS5X9cf0Pd3zvsHronm3N7st5cvEM2iAiwAxTuCEFqeOgnyBWcb
         FvGLmlHltyHvm/0v0zL6CD7AKbrDe68ov3uLQJaZh9oMAchqii2cqkJtSEEtTXy1mdYS
         Y35w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=tPPyKEGZVk5W3b/nB56WzLLuyaXrswVyUx1Ed/5o3O4=;
        b=NtcjQRIYnf0YTPuClgyD551zBeiIeU4B0GslxSVFwXh73+4lYywCrBiA/L5m9C8e4Q
         7a0RtBNtpVd9XucIxCcQoT8/lS+HIV0QdZaKUP9oix2j4kBp4aey5x/3eMgA0Vhs6i0k
         mM755pFFbK4HwDQ77JCPVfd5RvJz1LugJXbbtkKGb9vaX0BKR+ef5Lxt86ecwJ7RGh/O
         6kv6xF/dcK+U6VKU/Rc1slesktdHp6yEufFvYjm/iBjIYSINlBC2cz1b95GVUUSyIxJf
         LFPFMWeeQ/5UKnzIAiUrqRMZzqvQE8xd8fams5Tbl3KSECS1Aom1tWH4758+tajg1Lcq
         37Rg==
X-Gm-Message-State: AOAM532ib0hi8U3RNTsMLlc+JQfCop7UjLLg27DuK7N1a61zufaLlG1f
        5ODaue4sx4PuUU6Ki0pY7EPEnjsDUvY=
X-Google-Smtp-Source: ABdhPJzfvxgIpucSVaKIfaF+zi+C+hFNNk08SdZS9g9Piwygu4QotouqiXsKm/5X1dFpFRoTUqAnJg==
X-Received: by 2002:a17:90a:4404:: with SMTP id s4mr91755pjg.218.1621260094856;
        Mon, 17 May 2021 07:01:34 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.61])
        by smtp.googlemail.com with ESMTPSA id k10sm3074229pfu.175.2021.05.17.07.01.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 May 2021 07:01:34 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v3 5/5] KVM: LAPIC: Narrow the timer latency between wait_lapic_expire and world switch
Date:   Mon, 17 May 2021 07:00:28 -0700
Message-Id: <1621260028-6467-5-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1621260028-6467-1-git-send-email-wanpengli@tencent.com>
References: <1621260028-6467-1-git-send-email-wanpengli@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Let's treat lapic_timer_advance_ns automatically tune logic as hypervisor
overhead, move it before wait_lapic_expire instead of between wait_lapic_expire 
and the world switch, the wait duration should be calculated by the 
up-to-date guest_tsc after the overhead of automatically tune logic. This 
patch reduces ~30+ cycles for kvm-unit-tests/tscdeadline-latency when testing 
busy waits.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index c0ebef560bd1..552d2acf89ab 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1598,11 +1598,12 @@ static void __kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
 	guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
 	apic->lapic_timer.advance_expire_delta = guest_tsc - tsc_deadline;
 
-	if (guest_tsc < tsc_deadline)
-		__wait_lapic_expire(vcpu, tsc_deadline - guest_tsc);
-
 	if (lapic_timer_advance_dynamic)
 		adjust_lapic_timer_advance(vcpu, apic->lapic_timer.advance_expire_delta);
+
+	guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
+	if (guest_tsc < tsc_deadline)
+		__wait_lapic_expire(vcpu, tsc_deadline - guest_tsc);
 }
 
 void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
-- 
2.25.1

