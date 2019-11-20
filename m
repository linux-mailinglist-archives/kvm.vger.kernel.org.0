Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1209D103214
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 04:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727549AbfKTDm3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 22:42:29 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:33725 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727264AbfKTDm2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Nov 2019 22:42:28 -0500
Received: by mail-pj1-f65.google.com with SMTP id o14so3547217pjr.0;
        Tue, 19 Nov 2019 19:42:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QoisCnfLv/ffzmjOdQd+UsoR7NAQmnSFonw4OyGwCJE=;
        b=VyHcXq+3Xbl+VQAneuUwXtlR/XjQed7nkhvdfFHHI+xxxvFJQDGnGhI0MD70+gW0Eu
         WJXIvlAYYgn5FiPy7bkYfjOsCEHLMDboqAm3Jn4b1czHHUJNC1LWAioSuvunvEBYRVsu
         QBbcRCJ3FEFlsEiapKyyavEtfXUkITiri+jptnq0LlDExW17fwY2ptkRVAt1FA3zNgm1
         HrqcaqS7rCKSFoGK1oaUMzxg2fYYraAcMxcDnBwDFnjeIuqt/ZsoEZUrMranIH4N8WhK
         NrPyMLpA2rhVLsiKHFGm7M32V47fSbFV9Nr3TT3pl5uHcT2GGMOnEQzlGncho8Vn8UdR
         rV2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QoisCnfLv/ffzmjOdQd+UsoR7NAQmnSFonw4OyGwCJE=;
        b=cR3c7jfch22znRC7HExImHag1UHPVE+hHePNGmVlzqdrY5QOG6nV/sEAJqQ2DNkljB
         WHmml8q/CLVhJIQjLV9aUDZZ5VJJLnbfqeRlpSeJGLOy2lCmjZi7LlmIpv3P5GTjUjmS
         VIRpjj/3zjjMFSdqs6YyrtN3Rt4jf8ebMUjfqC0jBeKNFKl6dnJZWzDlSObRwtztM1SZ
         QFB9In4hKL37lMN7svoBVGsLtMBKBzEYPWu/4W/6HXMqFE7t077QcM6fHGYtZgJaXQKm
         qJIVi+/uBSHMygp9Ty/ss3Etq8qnypR3qOX7988gzrru/J2uY3+GBsDdsvXW33QbWLX8
         iA+w==
X-Gm-Message-State: APjAAAV8KcsyAkavxxM4wrUlCtqIOHd6+s928zXd4/WmU8Kv2bEmSaK4
        lS5y7dTNhsCtKfO71Pu5yhAirl16
X-Google-Smtp-Source: APXvYqweNjNrrD4StHAvcjhP5p1I7NOnMWrAdfN9rPgJbgZBOxs/g14ocpCeEPRf1Rvme0Gc8qnX+Q==
X-Received: by 2002:a17:90a:fc85:: with SMTP id ci5mr1278738pjb.17.1574221347686;
        Tue, 19 Nov 2019 19:42:27 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id w27sm25916842pgc.20.2019.11.19.19.42.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 19 Nov 2019 19:42:27 -0800 (PST)
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
Subject: [PATCH v3 2/2] KVM: LAPIC: micro-optimize fixed mode ipi delivery
Date:   Wed, 20 Nov 2019 11:42:09 +0800
Message-Id: <1574221329-12370-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1574221329-12370-1-git-send-email-wanpengli@tencent.com>
References: <1574221329-12370-1-git-send-email-wanpengli@tencent.com>
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

