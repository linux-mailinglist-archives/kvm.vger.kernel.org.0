Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDD5319790B
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 12:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729327AbgC3KVF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 06:21:05 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:43776 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729633AbgC3KUD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 06:20:03 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id AC2A5305FFAD;
        Mon, 30 Mar 2020 13:12:57 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 6F084305B7A0;
        Mon, 30 Mar 2020 13:12:57 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v8 55/81] KVM: introspection: add crash action handling on event reply
Date:   Mon, 30 Mar 2020 13:12:42 +0300
Message-Id: <20200330101308.21702-56-alazar@bitdefender.com>
In-Reply-To: <20200330101308.21702-1-alazar@bitdefender.com>
References: <20200330101308.21702-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

This action is used in extreme cases such as blocking the spread of
malware as quickly as possible.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 virt/kvm/introspection/kvmi.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 2b8e6910e57b..517e77ab39c2 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -707,10 +707,38 @@ void kvmi_run_jobs(struct kvm_vcpu *vcpu)
 	}
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
 void kvmi_handle_common_event_actions(struct kvm *kvm,
 				      u32 action, const char *str)
 {
 	switch (action) {
+	case KVMI_EVENT_ACTION_CRASH:
+		kvmi_vm_shutdown(kvm);
+		break;
+
 	default:
 		kvmi_err(KVMI(kvm), "Unsupported action %d for event %s\n",
 			 action, str);
