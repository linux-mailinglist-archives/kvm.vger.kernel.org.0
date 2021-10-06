Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56C164244FC
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 19:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239801AbhJFRnq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 13:43:46 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53572 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239448AbhJFRmp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 13:42:45 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id BD3BF307CAEB;
        Wed,  6 Oct 2021 20:31:02 +0300 (EEST)
Received: from localhost (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 9FC14305FFA0;
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
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v12 23/77] KVM: x86: export kvm_vcpu_ioctl_x86_set_xsave()
Date:   Wed,  6 Oct 2021 20:30:19 +0300
Message-Id: <20211006173113.26445-24-alazar@bitdefender.com>
In-Reply-To: <20211006173113.26445-1-alazar@bitdefender.com>
References: <20211006173113.26445-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This function is needed for the KVMI_VCPU_SET_XSAVE command.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h | 2 ++
 arch/x86/kvm/x86.c              | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1d3a62536a93..43569a6fc776 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1742,6 +1742,8 @@ int kvm_emulate_rdpmc(struct kvm_vcpu *vcpu);
 
 void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
 				  struct kvm_xsave *guest_xsave);
+int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
+				 struct kvm_xsave *guest_xsave);
 
 bool kvm_inject_pending_exception(struct kvm_vcpu *vcpu);
 void kvm_queue_exception(struct kvm_vcpu *vcpu, unsigned nr);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0b88e05e94f7..b01d865f6047 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4811,8 +4811,8 @@ void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
 
 #define XSAVE_MXCSR_OFFSET 24
 
-static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
-					struct kvm_xsave *guest_xsave)
+int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
+				 struct kvm_xsave *guest_xsave)
 {
 	u64 xstate_bv;
 	u32 mxcsr;
