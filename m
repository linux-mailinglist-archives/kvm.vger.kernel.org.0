Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67F3F101978
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 07:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727696AbfKSGib (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 01:38:31 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45407 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbfKSGib (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Nov 2019 01:38:31 -0500
Received: by mail-pf1-f195.google.com with SMTP id z4so11628357pfn.12;
        Mon, 18 Nov 2019 22:38:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Yo5NqpRNVc9ZCV4HkeJ+w2OSLgctRXbOy2yPUqbQZMs=;
        b=ARYxvPe47zKdIYN64R1iqFts1fP2tj8/oIVw8RJxb+pgK0CIbk8IdUD9bNFlf3TzHZ
         Fjepjg7LgCSbTO24YXSfE9D/GMjvn7jIfxU7ZI09lZP/pNMm3fSFubuMwBCGq9TIeMqi
         W3/EuDw9qM1kUo53C9Nab7h6iwl0jI5OoqZm5lzxoDCg/cGwpnwkz/3eRemf05f8Yn5N
         H10wMJZtkiDbjnbQb/j+89WC2aaMizfr1Tzb5WNogdNGpuAjZXPurLelOjZDSn+CCvbG
         71hPvlkSBiAXKxZVvOfw/zcKLH1Vu+v8V0Hg8p7JeMvyTqm7nWAo6CqG5qHYgkmLYeBp
         E3Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Yo5NqpRNVc9ZCV4HkeJ+w2OSLgctRXbOy2yPUqbQZMs=;
        b=asFoe54WNk7mzIUbmVXwHWYkBBpATXU3+QX/yuA7YD0nmySWG5ZvmpRzP4NfFMvTWI
         TR3NctpUVu9kwQdbnCnxREYiUqjssnUTltLMqec3kESwwsf6NiXm+CLNWh7QjI9rcjF3
         YEM86QccAAWdgSZC4F8hc01v/zBmCZ9UDE+PTVKzUKjV/21iGtpVpsexscT5Ysrb71UA
         gITdn/jziBL5aWWhYrMYERTBIKX3JkZQuS9ifj3HXwOOnCj+TD0JzunD2evBxD5fb5Wl
         5UCinNB7GpKpYWKcbZol9v2FMzue5iNH9id1TJPR70gKd5iVOyEeeeC/Z4YdWOsLixxS
         u3jg==
X-Gm-Message-State: APjAAAUoWRqDHculCheOYAExY5RWeZ/q8smsE5at95bFuTm/H4gn97Bu
        s494YdMBAOKviIt5bIUG0OhMS5O0
X-Google-Smtp-Source: APXvYqzcaf4rPrSliyQJfm8yYWB/cEQC7D6HoipGCjxkqd/pd9dpTUq4a1lTSDITBtutd8xyZU7Ziw==
X-Received: by 2002:a62:7643:: with SMTP id r64mr3677392pfc.191.1574145510728;
        Mon, 18 Nov 2019 22:38:30 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id y17sm8307055pfl.92.2019.11.18.22.38.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 18 Nov 2019 22:38:30 -0800 (PST)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2 2/2] KVM: LAPIC: micro-optimize fixed mode ipi delivery
Date:   Tue, 19 Nov 2019 14:38:25 +0800
Message-Id: <1574145505-12273-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

This patch optimizes redundancy logic before fixed mode ipi is delivered 
in the fast path, broadcast handling needs to go slow path, so the delivery 
mode repair can be delayed to before slow path.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v1 -> v2:
 * don't touch the irq->shorthand check

 arch/x86/kvm/irq_comm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index 8ecd48d..aa88156 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -52,15 +52,15 @@ int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 	unsigned long dest_vcpu_bitmap[BITS_TO_LONGS(KVM_MAX_VCPUS)];
 	unsigned int dest_vcpus = 0;
 
+	if (kvm_irq_delivery_to_apic_fast(kvm, src, irq, &r, dest_map))
+		return r;
+
 	if (irq->dest_mode == 0 && irq->dest_id == 0xff &&
 			kvm_lowest_prio_delivery(irq)) {
 		printk(KERN_INFO "kvm: apic: phys broadcast and lowest prio\n");
 		irq->delivery_mode = APIC_DM_FIXED;
 	}
 
-	if (kvm_irq_delivery_to_apic_fast(kvm, src, irq, &r, dest_map))
-		return r;
-
 	memset(dest_vcpu_bitmap, 0, sizeof(dest_vcpu_bitmap));
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-- 
2.7.4

