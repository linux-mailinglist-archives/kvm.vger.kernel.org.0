Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA6787F66
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437146AbfHIQQ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:16:27 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:52920 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437064AbfHIQPA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:15:00 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id C10A8305D349;
        Fri,  9 Aug 2019 19:01:18 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 77BCD305B7A1;
        Fri,  9 Aug 2019 19:01:18 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?q?Samuel=20Laur=C3=A9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>, Zhang@vger.kernel.org,
        Yu C <yu.c.zhang@intel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v6 48/92] kvm: add kvm_vcpu_kick_and_wait()
Date:   Fri,  9 Aug 2019 19:00:03 +0300
Message-Id: <20190809160047.8319-49-alazar@bitdefender.com>
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This function is needed for the KVMI_PAUSE_VCPU command. There are
cases when it is easier for the introspection tool if it knows that
the vCPU doesn't run guest code when the command is completed, without
waiting for the KVMI_EVENT_PAUSE_VCPU event.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 10 ++++++++++
 2 files changed, 11 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ae4106aae16e..09bc06747642 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -738,6 +738,7 @@ void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu);
 bool kvm_vcpu_wake_up(struct kvm_vcpu *vcpu);
 void kvm_vcpu_kick(struct kvm_vcpu *vcpu);
+void kvm_vcpu_kick_and_wait(struct kvm_vcpu *vcpu);
 int kvm_vcpu_yield_to(struct kvm_vcpu *target);
 void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool usermode_vcpu_not_eligible);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2e11069b9565..5256d7321d0e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2370,6 +2370,16 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
 EXPORT_SYMBOL_GPL(kvm_vcpu_kick);
 #endif /* !CONFIG_S390 */
 
+void kvm_vcpu_kick_and_wait(struct kvm_vcpu *vcpu)
+{
+	if (kvm_vcpu_wake_up(vcpu))
+		return;
+
+	if (kvm_request_needs_ipi(vcpu, KVM_REQUEST_WAIT))
+		smp_call_function_single(vcpu->cpu, ack_flush, NULL, 1);
+}
+EXPORT_SYMBOL_GPL(kvm_vcpu_kick_and_wait);
+
 int kvm_vcpu_yield_to(struct kvm_vcpu *target)
 {
 	struct pid *pid;
