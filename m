Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9038C0118
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 10:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbfI0I1J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 04:27:09 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:33283 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfI0I1J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 04:27:09 -0400
Received: by mail-pl1-f195.google.com with SMTP id d22so796726pls.0;
        Fri, 27 Sep 2019 01:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=6FZld6NyLvsWL2o4u7zTXB1hPtoeXTwRo8zEqYJfiKE=;
        b=l52EV2R5p6/wbHuZ7Du1+8xPCkXqUWWl864aST5vKDXKUTBIqq3H8Ft+uF3hmPZSlP
         nswHPvtegQrcrpzU0b+0j0PTNrQtFPyXxSQYRZ2hqnKU81L4TkaiXkTH15wy17ggAKhG
         A9Fkf4n9pAijobJf5+L6tupEp0mALV9v2yP2A+/uX3fJqvtZogTOa8pudagklRN8GSOH
         dcmgS+bdUiaFitQDifUxzjJP5sgKvQPejcCLC+21NNg9bsqr5J6u0F/wqHn7/WitwGnC
         mzmwDK83aQUp8neoaimuZoaMmPIjQ86l5+6i7a29NkCT1fGXkFT/Igg61ldxv4FfFeed
         YXOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6FZld6NyLvsWL2o4u7zTXB1hPtoeXTwRo8zEqYJfiKE=;
        b=dDWiXhxs4zKIzSHAAM5r10l5H6XW+yy6nPMTuub4FPFCP4Z2PBxHmpTs//40HC0e0W
         sJL8jeZ2H8NqgBggT6njJTRsUfumBxoe6rL3GGmQ5MFDtnA7qRdGvpS1iyUZjvm3ZVGu
         DB4lptAgK03RDrR/AJD3kZetOTO5PpYg73ZIIXWqZ/QZbI/PsNOnwbBthuFZf+AnJdHk
         C6pEocIZ+6bPgY1fH6ir6X2O3WUr3wHJGnix/+JCrPWBBNq2PI06j0+7LDo7mYWNws6s
         4oX3RUtG6qAsRk53hnHdwdMGd16D9QTzdYC7nT8DRQnj33llhF9xYBk7NelUFSDCn36W
         iUbg==
X-Gm-Message-State: APjAAAVukFWyOUwrU0B+dfGyFgwAavi9Y59xLaKZijEJAbpIBaKpwxIe
        aHivzULd2OqKGnkdVSvzzC6kBJbd
X-Google-Smtp-Source: APXvYqwzQglXoBTLIXgWxvQEeHnO8e7mA5or1UPjqdtSwLWyYE0B3CH2DugF5ttzoumQoESutBZ4Fw==
X-Received: by 2002:a17:902:d201:: with SMTP id t1mr3117240ply.337.1569572828338;
        Fri, 27 Sep 2019 01:27:08 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id d24sm2168594pfn.86.2019.09.27.01.27.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 27 Sep 2019 01:27:07 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH] KVM: Don't shrink/grow vCPU halt_poll_ns if host side polling is disabled
Date:   Fri, 27 Sep 2019 16:27:02 +0800
Message-Id: <1569572822-28942-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Don't waste cycles to shrink/grow vCPU halt_poll_ns if host 
side polling is disabled.

Cc: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 virt/kvm/kvm_main.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e6de315..b368be4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2359,20 +2359,22 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	kvm_arch_vcpu_unblocking(vcpu);
 	block_ns = ktime_to_ns(cur) - ktime_to_ns(start);
 
-	if (!vcpu_valid_wakeup(vcpu))
-		shrink_halt_poll_ns(vcpu);
-	else if (halt_poll_ns) {
-		if (block_ns <= vcpu->halt_poll_ns)
-			;
-		/* we had a long block, shrink polling */
-		else if (vcpu->halt_poll_ns && block_ns > halt_poll_ns)
+	if (!kvm_arch_no_poll(vcpu)) {
+		if (!vcpu_valid_wakeup(vcpu))
 			shrink_halt_poll_ns(vcpu);
-		/* we had a short halt and our poll time is too small */
-		else if (vcpu->halt_poll_ns < halt_poll_ns &&
-			block_ns < halt_poll_ns)
-			grow_halt_poll_ns(vcpu);
-	} else
-		vcpu->halt_poll_ns = 0;
+		else if (halt_poll_ns) {
+			if (block_ns <= vcpu->halt_poll_ns)
+				;
+			/* we had a long block, shrink polling */
+			else if (vcpu->halt_poll_ns && block_ns > halt_poll_ns)
+				shrink_halt_poll_ns(vcpu);
+			/* we had a short halt and our poll time is too small */
+			else if (vcpu->halt_poll_ns < halt_poll_ns &&
+				block_ns < halt_poll_ns)
+				grow_halt_poll_ns(vcpu);
+		} else
+			vcpu->halt_poll_ns = 0;
+	}
 
 	trace_kvm_vcpu_wakeup(block_ns, waited, vcpu_valid_wakeup(vcpu));
 	kvm_arch_vcpu_block_finish(vcpu);
-- 
2.7.4

