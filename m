Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88CD42D1AEB
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 21:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbgLGUqz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 15:46:55 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:41872 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726733AbgLGUqy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 15:46:54 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 24F80305D4FA;
        Mon,  7 Dec 2020 22:46:12 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 018A13072784;
        Mon,  7 Dec 2020 22:46:11 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v11 02/81] KVM: add kvm_vcpu_kick_and_wait()
Date:   Mon,  7 Dec 2020 22:45:03 +0200
Message-Id: <20201207204622.15258-3-alazar@bitdefender.com>
In-Reply-To: <20201207204622.15258-1-alazar@bitdefender.com>
References: <20201207204622.15258-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This function is needed for the KVMI_VM_PAUSE_VCPU command, which sets
the introspection request flag, kicks the vCPU out of guest and returns
a success error code (0). The vCPU will send the KVMI_VCPU_EVENT_PAUSE
event as soon as possible. Once the introspection tool receives the event,
it knows that the vCPU doesn't run guest code and can handle introspection
commands (until the reply for the pause event is sent).

To implement the "pause VM" command, the introspection tool will send
a KVMI_VM_PAUSE_VCPU command for every vCPU. To know when the VM is
paused, userspace has to receive and "parse" all events. For example,
with a 4 vCPU VM, if "pause VM" was sent by userspace while handling
an event from vCPU0 and at the same time a new vCPU was hot-plugged
(which could send another event for vCPU4), the "pause VM" command has
to receive and check all events until it gets the pause events for vCPU1,
vCPU2 and vCPU3 before returning to the upper layer.

In order to make it easier for userspace to implement the "pause VM"
command, KVMI_VM_PAUSE_VCPU has an optional 'wait' parameter. If this is
set, kvm_vcpu_kick_and_wait() will be used instead of kvm_vcpu_kick().
Once a sequence of KVMI_VM_PAUSE_VCPU commands with the 'wait' flag set
is handled, the introspection tool can consider the VM paused, without
the need to wait and check events.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 10 ++++++++++
 2 files changed, 11 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f3b1013fb22c..1bbb07b87d1a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -841,6 +841,7 @@ void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu);
 bool kvm_vcpu_wake_up(struct kvm_vcpu *vcpu);
 void kvm_vcpu_kick(struct kvm_vcpu *vcpu);
+void kvm_vcpu_kick_and_wait(struct kvm_vcpu *vcpu);
 int kvm_vcpu_yield_to(struct kvm_vcpu *target);
 void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool usermode_vcpu_not_eligible);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3abcb2ce5b7d..069668b8afc2 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2887,6 +2887,16 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
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
