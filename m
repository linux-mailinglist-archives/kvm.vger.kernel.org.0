Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C89A228AEA
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731286AbgGUVSH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:18:07 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37794 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731253AbgGUVQC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:16:02 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 8E10D305D4EE;
        Wed, 22 Jul 2020 00:09:27 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 6FF30304FA15;
        Wed, 22 Jul 2020 00:09:27 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v9 54/84] KVM: introspection: add the crash action handling on the event reply
Date:   Wed, 22 Jul 2020 00:08:52 +0300
Message-Id: <20200721210922.7646-55-alazar@bitdefender.com>
In-Reply-To: <20200721210922.7646-1-alazar@bitdefender.com>
References: <20200721210922.7646-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

This action is used in extreme cases such as blocking the spread of
malware as fast as possible.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 virt/kvm/introspection/kvmi.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 02a866ca8d8c..9e0014bbf9a6 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -749,9 +749,37 @@ static void kvmi_handle_unsupported_event_action(struct kvm *kvm)
 	kvmi_sock_shutdown(KVMI(kvm));
 }
 
+static int kvmi_vcpu_kill(int sig, struct kvm_vcpu *vcpu)
+{
+	struct kernel_siginfo siginfo[1] = {};
+	int err = -ESRCH;
+	struct pid *pid;
+
+	rcu_read_lock();
+	pid = rcu_dereference(vcpu->pid);
+	if (pid)
+		err = kill_pid_info(sig, siginfo, pid);
+	rcu_read_unlock();
+
+	return err;
+}
+
+static void kvmi_vm_shutdown(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu;
+	int i;
+
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		kvmi_vcpu_kill(SIGTERM, vcpu);
+}
+
 void kvmi_handle_common_event_actions(struct kvm *kvm, u32 action)
 {
 	switch (action) {
+	case KVMI_EVENT_ACTION_CRASH:
+		kvmi_vm_shutdown(kvm);
+		break;
+
 	default:
 		kvmi_handle_unsupported_event_action(kvm);
 	}
