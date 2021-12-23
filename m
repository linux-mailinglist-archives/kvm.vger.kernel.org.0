Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0302C47E974
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 23:27:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350652AbhLWW0U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Dec 2021 17:26:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350473AbhLWWYz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Dec 2021 17:24:55 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D8A4C06137D
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:24:18 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id u13-20020a17090a450d00b001b1e6726fccso6269485pjg.0
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:24:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=JFtlBtomcDM/mOE9rf4RY2VzkMlwcz38nh6Jra8a7vQ=;
        b=IIM8HCEEXkjK2wABibtVd02wltmTvdnq19pbJ89croKvZSHb9ry7bNalx4Ow0ZE/Eq
         7CfQAzl65itDRQH97+RwBLToD05uzzfhkiDVVscd68gD902ihnPINsLlW/qegWlyO8qn
         315AK8mPp8C2uprSLFCE6hzoJm0zqVLqqFJ1pn/ALlRYMduSceoqeLoGf893JKYY5Ep/
         vgcZSLn8gVyODJ1lg+CAG6pkrUYnTYoPhXuTTY1EWedngPg58hTWxKPuvQduKK5XB3bQ
         XDKKK2sh+HFrFEJdXh4GcX8PyXO0MtbaFZ3ziOuicFfDMsD093wy7gVpCsrpNngGnnnx
         CRUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=JFtlBtomcDM/mOE9rf4RY2VzkMlwcz38nh6Jra8a7vQ=;
        b=yumw2uuEoJGrvF7p/h0lrl1pRZM9z0+vveVJxUuFZyuEqyHqkhihNm7MjT3S24ivhu
         chF7kQZBnCjqZkaBQB+jefyiHY1QjQjmqNRuX4qrvGiHgNQuiU2eoeYP/nvEuS4Vo5v2
         qD7HpT38ivvY9rBkjALZsux8J4nxXCEVGB5OnUE6OGt8dLAkd5AgDX+aKmBws/qKXoC9
         TOxxdTHfRD5dYgC/jBxuYDe9C+jLFkIZ/KhiHClN0mOn3dJ1rwfO2sgMxQyBdYVht93w
         /v5lHADK6fZWt3xmNlvhFs66QOIIrFsLoMFMQpdyQBT2WMRV0gMIu+fGwC0Ot0xADWFP
         0hnQ==
X-Gm-Message-State: AOAM533SjiHB82M7CrCtCW1xKbBEmIxL96MUijkJMwkUxT3X/TzFiZpr
        BzF5MAduYUk4e/my0DHmXi/pVZnGO/U=
X-Google-Smtp-Source: ABdhPJy8bLcApcuZH7n/dxygYs5t4abmOxKJJcdsud6/UPcB4ZwdmJX+b3mdekBpTjrziqo6YIhwsm9Irfs=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:c203:: with SMTP id
 e3mr739912pjt.0.1640298257550; Thu, 23 Dec 2021 14:24:17 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 23 Dec 2021 22:23:10 +0000
In-Reply-To: <20211223222318.1039223-1-seanjc@google.com>
Message-Id: <20211223222318.1039223-23-seanjc@google.com>
Mime-Version: 1.0
References: <20211223222318.1039223-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [PATCH v2 22/30] KVM: x86/mmu: Do remote TLB flush before dropping
 RCU in TDP MMU resched
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When yielding in the TDP MMU iterator, service any pending TLB flush
before dropping RCU protections in anticipation of using the callers RCU
"lock" as a proxy for vCPUs in the guest.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 21d015b38ac1..e7086eb35599 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -728,11 +728,11 @@ static inline bool __must_check tdp_mmu_iter_cond_resched(struct kvm *kvm,
 		return false;
 
 	if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
-		rcu_read_unlock();
-
 		if (flush)
 			kvm_flush_remote_tlbs(kvm);
 
+		rcu_read_unlock();
+
 		if (shared)
 			cond_resched_rwlock_read(&kvm->mmu_lock);
 		else
-- 
2.34.1.448.ga2b2bfdf31-goog

