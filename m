Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3AEF1048E1
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 04:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfKUDRX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 22:17:23 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:38784 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfKUDRW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Nov 2019 22:17:22 -0500
Received: by mail-pj1-f68.google.com with SMTP id f7so789559pjw.5;
        Wed, 20 Nov 2019 19:17:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QoisCnfLv/ffzmjOdQd+UsoR7NAQmnSFonw4OyGwCJE=;
        b=KT3Y07VlnU6c5cTN1dMS4KTY7faKBBdJZMKS3HtwgFdG2SkXHqYwS1g0xYNImaVc/A
         nZkA3GQwOl0UVFBSa6zkQyx95zaE7asmcbirWv4Oatwt6crhAXlup/7K7gr6sgsYVJLH
         VPmcnRXlWJVYHJFz6foV99jI1ISWO3lcImfya2dgmzxkB5ARHrfAYB9ySqbKR+ErOzE2
         WEURAxr4hO4wJBsd63ioK5AxAvFHOz0rDgrVX7hy73cORcwx2XyBjajpz1YRjjqOu2R9
         XU+ts3eluhlPIyNjpUC+AGVfJf3X4XWhs7avtcEQH5cTjIwZg0pzTL9w+9n0h7dGRw3e
         y9CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QoisCnfLv/ffzmjOdQd+UsoR7NAQmnSFonw4OyGwCJE=;
        b=VZv7TKLTWMMAlnEizgrMek5sh0fKyBuE1mNPb0FJTjMYOTILjhBgamymFLRyQtJts5
         sQM4oV7b3YaigrCRfYtEM+n1agBNRvVMPmz3x9DMPerfiCi+m18BJ5V7rH4fpJjV3FlF
         Z4OoXT8/O8QYuGqbHoDigtrXY9xPqVwn2wKeUHCeuz5saBgn7eXVUhlaW+df+1xKAxuZ
         saZIm0+BjdCmpyg0ouW9J5ehE5C6Si71cG8fbX+/RDuKzSVUZjXC5o1VpqO8VD2irbBf
         JuaUaotkq9KJX6nP5aTy6ivb3xv/iSgVEvFlSfYOuF1PpBZIhVG3d5nBOTctqP6XfuH0
         Msow==
X-Gm-Message-State: APjAAAUrmkzqbXpb0QoTFGDhh8+fZI4sVMPZHbC/3j9OjDnzIqWEhnhm
        XC/MngXyz/Y34bWyTqwPAWcfGS/f
X-Google-Smtp-Source: APXvYqw58EMMSjmZPWIOZtlhaoHxKuX6HVc0skQrpbx8F2BqFKbLAHLw5tFEwki53HMNK+rX5v4pHA==
X-Received: by 2002:a17:90a:4fe6:: with SMTP id q93mr8277550pjh.88.1574306241222;
        Wed, 20 Nov 2019 19:17:21 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id q4sm639248pgp.30.2019.11.20.19.17.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 20 Nov 2019 19:17:20 -0800 (PST)
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
Subject: [PATCH v4 2/2] KVM: LAPIC: micro-optimize fixed mode ipi delivery
Date:   Thu, 21 Nov 2019 11:17:12 +0800
Message-Id: <1574306232-872-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1574306232-872-1-git-send-email-wanpengli@tencent.com>
References: <1574306232-872-1-git-send-email-wanpengli@tencent.com>
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

