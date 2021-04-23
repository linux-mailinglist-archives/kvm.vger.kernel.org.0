Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6960368DB7
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 09:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241033AbhDWHMO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 03:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240743AbhDWHMO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 03:12:14 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC723C061574;
        Fri, 23 Apr 2021 00:11:36 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id lr7so6497008pjb.2;
        Fri, 23 Apr 2021 00:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=HqJMjNWqtxCZEtFIyBmota7lpGm+rHS29SEa78vm9uw=;
        b=nKpRcIzrlcMWE/JIaAcQTt+sIk18JhHn3VNFy/+7A9crEFQKaRl/4ybysLR+RyzWLv
         JADj1GVyf+KH+Urzx3u5AYD/LI3Am90W0VLjwrlqt1MjdYsxAFsNg6wRnBOldXFZU6op
         pjdemQY94oHgbZbVAKj7ozhdOvRP1FBzfUuQekdQroOA4QtwScShv5ana/u+uckRBjjq
         NuJMKjOA0AGJii22hwhKlFmiql0z2ZNaQjCiH2+qSTfElfbYBC6oFqSeNBptRfzyR1mf
         HP6rCBZDhI6XTyQOMpc/OrXgtVfp0CEmEjd+zeLTrUNlmOpIysxCHKhEvkvOyO476Jwv
         h0rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=HqJMjNWqtxCZEtFIyBmota7lpGm+rHS29SEa78vm9uw=;
        b=qdDK7zNTxo6uR5OV0rzMfXfeBFsIMUnoFNygU4NRVJpkZ/2rU7xMcNDYZugKcDNYcH
         6wDP49raSaGd8hPyJGRcxHZ/DNSN/P997XIuuy5g2uncfIJ4HOQuqHSzT/RGyhRTzwQ8
         vx5CZDws/JlvohgZWs7bJPtbNjr+22bKAU9PBXQwQ2PdhEthtHuQl7DGyXzZ/0rxpI5+
         CBwLh5oLuhHV7ikqWJCXMk0VFVqxoJnxU8OpESnXpywtEEpeJVi+yijW4x/g/uXdPpmm
         BQQtnWQyEJgE9UtvizNuH6T6TxeYP+56p5vUzg8TFHMn3s8UJX9XhkK4hrP3+io/06qL
         8Ttg==
X-Gm-Message-State: AOAM530+Qv7OphOFLrhmPZwrq9fe2t36HcaxCIID36CgjN4Q2Pgc2scG
        2287NhsCo9hxkFNWk0eqH1T4g1BW7pM=
X-Google-Smtp-Source: ABdhPJwD5pvvAJW0GH6EobdDrhDTk3dYtqLbuFADme2Js6GZdjV8gfbMGPInO9bDebAZqhHaFrR4hQ==
X-Received: by 2002:a17:90b:e0b:: with SMTP id ge11mr4219103pjb.127.1619161896302;
        Fri, 23 Apr 2021 00:11:36 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id gj13sm6605427pjb.57.2021.04.23.00.11.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Apr 2021 00:11:35 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH] KVM: x86/xen: Take srcu lock when accessing kvm_memslots()
Date:   Fri, 23 Apr 2021 15:11:23 +0800
Message-Id: <1619161883-5963-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

kvm_memslots() will be called by kvm_write_guest_offset_cached() so 
take the srcu lock.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/xen.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index ae17250..d0df782 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -96,6 +96,7 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
 	struct kvm_vcpu_xen *vx = &v->arch.xen;
 	uint64_t state_entry_time;
 	unsigned int offset;
+	int idx;
 
 	kvm_xen_update_runstate(v, state);
 
@@ -133,10 +134,16 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
 	BUILD_BUG_ON(sizeof(((struct compat_vcpu_runstate_info *)0)->state_entry_time) !=
 		     sizeof(state_entry_time));
 
+	/*
+	 * Take the srcu lock as memslots will be accessed to check the gfn
+	 * cache generation against the memslots generation.
+	 */
+	idx = srcu_read_lock(&v->kvm->srcu);
+
 	if (kvm_write_guest_offset_cached(v->kvm, &v->arch.xen.runstate_cache,
 					  &state_entry_time, offset,
 					  sizeof(state_entry_time)))
-		return;
+		goto out;
 	smp_wmb();
 
 	/*
@@ -154,7 +161,7 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
 					  &vx->current_runstate,
 					  offsetof(struct vcpu_runstate_info, state),
 					  sizeof(vx->current_runstate)))
-		return;
+		goto out;
 
 	/*
 	 * Write the actual runstate times immediately after the
@@ -173,7 +180,7 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
 					  &vx->runstate_times[0],
 					  offset + sizeof(u64),
 					  sizeof(vx->runstate_times)))
-		return;
+		goto out;
 
 	smp_wmb();
 
@@ -186,7 +193,10 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
 	if (kvm_write_guest_offset_cached(v->kvm, &v->arch.xen.runstate_cache,
 					  &state_entry_time, offset,
 					  sizeof(state_entry_time)))
-		return;
+		goto out;
+
+out:
+	srcu_read_unlock(&v->kvm->srcu, idx);
 }
 
 int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
-- 
2.7.4

