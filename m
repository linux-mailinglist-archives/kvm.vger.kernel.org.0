Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19ACD5BF11F
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 01:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbiITXcF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 19:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbiITXbq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 19:31:46 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FC5272843
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:31:45 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id z7-20020a170903018700b0017835863686so2649122plg.11
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=dYLN9GBGgw9bb1ictRproowJt/YAf1zd5j5g6hcPFfg=;
        b=kNqSYhb/HAnrt536HOs7xUAP4Z2+7GGcDgLkQVMvZqfyl5tPjooDHiqOcT+hrnFN6E
         NV+klM1GvU8zWTdvsAQPfxnB+k72U8P3S9vAPn593sWkyBbLZDqrAJIah2qCIk8MQA5B
         BkKg+IbnGJ+iA+FRSstmyq2M2O3FKSbjt55t+bsFKCJDFGDdZ6gqnjh258gvh4GES1iP
         LL3NjesyU1IelEuHxXvC3J5TdXwm/79ao2Z4a9goLw5SEceUmR3aJDsQovaB6mP6Y36u
         GRPh+4hn6t9TEiGYM0/7cWKn7NzoNbjVzISOiJQvdJxAM7rW7tvReOt6UJMUrZCm0rmT
         tKSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=dYLN9GBGgw9bb1ictRproowJt/YAf1zd5j5g6hcPFfg=;
        b=Bn6ZzvTsdSKij+/ljra75da4Qmt/rtnNdV5nD/08BqIWuUdL5T/j58m42SaBB44fUN
         HybLsdEY7yPrkYYyurIgbNYRJhGkfLXFOA4S0N07tEuycIcAvIC5JafcYThHgIjCmd2z
         7XKT4f2oMkf9wfQWjDOsLNgc7rfP8c8mHM9s9FxRMl8O3Szare0y0KQYFwLMcnXPoxAC
         th6JFjmhrF6igRzu/XI8wAVhw00aKy45csFxVFsM2I1AZ0bFTzGYAxt7HNh7m7I0hpSR
         qYwGDg5MHs8Bjmy3P8giilWtlIdHL6BKRYvF1xfZqZPESUubzpniZ2Qb9+NU/XzoMHHX
         vo3Q==
X-Gm-Message-State: ACrzQf27wnQkuYKKlzQvcqA3okc6f/x2hT5JlHE6Y/3+5ToxAndJR16N
        IWf+moUBhMFq7KBJcisRG+Ljnkv9ybQ=
X-Google-Smtp-Source: AMsMyM68+xmkQUernGEuZHH60GWob96nzK2+b7JDn2jZj9scVDx7yQG4DjR+nvfV9+T5ZlLt3sFaV2nltFg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:a407:b0:202:e6eb:4b7c with SMTP id
 y7-20020a17090aa40700b00202e6eb4b7cmr6297652pjp.15.1663716705161; Tue, 20 Sep
 2022 16:31:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 20 Sep 2022 23:31:11 +0000
In-Reply-To: <20220920233134.940511-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220920233134.940511-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920233134.940511-6-seanjc@google.com>
Subject: [PATCH v3 05/28] KVM: x86: Don't inhibit APICv/AVIC if xAPIC ID
 mismatch is due to 32-bit ID
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Truncate the vcpu_id, a.k.a. x2APIC ID, to an 8-bit value when comparing
it against the xAPIC ID to avoid false positives (sort of) on systems
with >255 CPUs, i.e. with IDs that don't fit into a u8.  The intent of
APIC_ID_MODIFIED is to inhibit APICv/AVIC when the xAPIC is changed from
it's original value,

The mismatch isn't technically a false positive, as architecturally the
xAPIC IDs do end up being aliased in this scenario, and neither APICv
nor AVIC correctly handles IPI virtualization when there is aliasing.
However, KVM already deliberately does not honor the aliasing behavior
that results when an x2APIC ID gets truncated to an xAPIC ID.  I.e. the
resulting APICv/AVIC behavior is aligned with KVM's existing behavior
when KVM's x2APIC hotplug hack is effectively enabled.

If/when KVM provides a way to disable the hotplug hack, APICv/AVIC can
piggyback whatever logic disables the optimized APIC map (which is what
provides the hotplug hack), i.e. so that KVM's optimized map and APIC
virtualization yield the same behavior.

For now, fix the immediate problem of APIC virtualization being disabled
for large VMs, which is a much more pressing issue than ensuring KVM
honors architectural behavior for APIC ID aliasing.

Fixes: 3743c2f02517 ("KVM: x86: inhibit APICv/AVIC on changes to APIC ID or APIC base")
Reported-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index adac6ca9b7dc..a02defa3f7b5 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2075,7 +2075,12 @@ static void kvm_lapic_xapic_id_updated(struct kvm_lapic *apic)
 	if (KVM_BUG_ON(apic_x2apic_mode(apic), kvm))
 		return;
 
-	if (kvm_xapic_id(apic) == apic->vcpu->vcpu_id)
+	/*
+	 * Deliberately truncate the vCPU ID when detecting a modified APIC ID
+	 * to avoid false positives if the vCPU ID, i.e. x2APIC ID, is a 32-bit
+	 * value.
+	 */
+	if (kvm_xapic_id(apic) == (u8)apic->vcpu->vcpu_id)
 		return;
 
 	kvm_set_apicv_inhibit(apic->vcpu->kvm, APICV_INHIBIT_REASON_APIC_ID_MODIFIED);
-- 
2.37.3.968.ga6b4b080e4-goog

