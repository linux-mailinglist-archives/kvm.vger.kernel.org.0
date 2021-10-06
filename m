Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D04CE424501
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 19:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238934AbhJFRoT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 13:44:19 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53574 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239464AbhJFRmq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 13:42:46 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 4E48F307CAEA;
        Wed,  6 Oct 2021 20:31:02 +0300 (EEST)
Received: from localhost (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 2AF00305FFA0;
        Wed,  6 Oct 2021 20:31:02 +0300 (EEST)
X-Is-Junk-Enabled: fGZTSsP0qEJE2AIKtlSuFiRRwg9xyHmJ
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v12 22/77] KVM: x86: export kvm_vcpu_ioctl_x86_get_xsave()
Date:   Wed,  6 Oct 2021 20:30:18 +0300
Message-Id: <20211006173113.26445-23-alazar@bitdefender.com>
In-Reply-To: <20211006173113.26445-1-alazar@bitdefender.com>
References: <20211006173113.26445-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nicușor Cîțu <nicu.citu@icloud.com>

This function is needed for the KVMI_VCPU_GET_XSAVE command.

Signed-off-by: Nicușor Cîțu <nicu.citu@icloud.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h | 3 +++
 arch/x86/kvm/x86.c              | 4 ++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 681e27c2065d..1d3a62536a93 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1740,6 +1740,9 @@ unsigned long kvm_get_rflags(struct kvm_vcpu *vcpu);
 void kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
 int kvm_emulate_rdpmc(struct kvm_vcpu *vcpu);
 
+void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
+				  struct kvm_xsave *guest_xsave);
+
 bool kvm_inject_pending_exception(struct kvm_vcpu *vcpu);
 void kvm_queue_exception(struct kvm_vcpu *vcpu, unsigned nr);
 void kvm_queue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0cd329622e1e..0b88e05e94f7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4791,8 +4791,8 @@ static void load_xsave(struct kvm_vcpu *vcpu, u8 *src)
 	}
 }
 
-static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
-					 struct kvm_xsave *guest_xsave)
+void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
+				  struct kvm_xsave *guest_xsave)
 {
 	if (!vcpu->arch.guest_fpu)
 		return;
