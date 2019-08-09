Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7D6587F4E
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437226AbfHIQPq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:15:46 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:52910 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437124AbfHIQPH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:15:07 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id A22CB305D356;
        Fri,  9 Aug 2019 19:01:28 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 58C85305B7A3;
        Fri,  9 Aug 2019 19:01:28 +0300 (EEST)
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
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>
Subject: [RFC PATCH v6 65/92] kvm: introspection: add KVMI_EVENT_SINGLESTEP
Date:   Fri,  9 Aug 2019 19:00:20 +0300
Message-Id: <20190809160047.8319-66-alazar@bitdefender.com>
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nicușor Cîțu <ncitu@bitdefender.com>

This event is sent when the current instruction has been single stepped
as a result of a KVMI_EVENT_PF event to which the introspection tool
set the singlestep field and responded with CONTINUE.

Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virtual/kvm/kvmi.rst | 25 +++++++++++++++++++
 virt/kvm/kvmi.c                    | 40 ++++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+)

diff --git a/Documentation/virtual/kvm/kvmi.rst b/Documentation/virtual/kvm/kvmi.rst
index 8721a470de87..572abab1f6ef 100644
--- a/Documentation/virtual/kvm/kvmi.rst
+++ b/Documentation/virtual/kvm/kvmi.rst
@@ -1574,3 +1574,28 @@ introspection has been enabled for this event (see **KVMI_CONTROL_EVENTS**).
 	KVMI_DESC_TR
 
 ``write`` is 1 if the descriptor was written, 0 otherwise.
+
+12. KVMI_EVENT_SINGLESTEP
+-------------------------
+
+:Architectures: x86
+:Versions: >= 1
+:Actions: CONTINUE, CRASH
+:Parameters:
+
+::
+
+	struct kvmi_event;
+
+:Returns:
+
+::
+
+	struct kvmi_vcpu_hdr;
+	struct kvmi_event_reply;
+
+This event is sent when the current instruction has been executed
+(as a result of a *KVMI_EVENT_PF* event to which the introspection
+tool set the ``singlestep`` field and responded with *CONTINUE*)
+and the introspection has been enabled for this event
+(see **KVMI_CONTROL_EVENTS**).
diff --git a/virt/kvm/kvmi.c b/virt/kvm/kvmi.c
index a3a5af9080a9..3dfedf3ae739 100644
--- a/virt/kvm/kvmi.c
+++ b/virt/kvm/kvmi.c
@@ -1182,6 +1182,44 @@ void kvmi_trap_event(struct kvm_vcpu *vcpu)
 	kvmi_put(vcpu->kvm);
 }
 
+static u32 kvmi_send_singlestep(struct kvm_vcpu *vcpu)
+{
+	int err, action;
+
+	err = kvmi_send_event(vcpu, KVMI_EVENT_SINGLESTEP, NULL, 0,
+			      NULL, 0, &action);
+	if (err)
+		return KVMI_EVENT_ACTION_CONTINUE;
+
+	return action;
+}
+
+static void __kvmi_singlestep_event(struct kvm_vcpu *vcpu)
+{
+	u32 action;
+
+	action = kvmi_send_singlestep(vcpu);
+	switch (action) {
+	case KVMI_EVENT_ACTION_CONTINUE:
+		break;
+	default:
+		kvmi_handle_common_event_actions(vcpu, action, "SINGLESTEP");
+	}
+}
+
+static void kvmi_singlestep_event(struct kvm_vcpu *vcpu)
+{
+	struct kvmi_vcpu *ivcpu = IVCPU(vcpu);
+
+	if (!ivcpu->ss_requested)
+		return;
+
+	if (is_event_enabled(vcpu, KVMI_EVENT_SINGLESTEP))
+		__kvmi_singlestep_event(vcpu);
+
+	ivcpu->ss_requested = false;
+}
+
 static bool __kvmi_create_vcpu_event(struct kvm_vcpu *vcpu)
 {
 	u32 action;
@@ -1616,6 +1654,8 @@ void kvmi_stop_ss(struct kvm_vcpu *vcpu)
 
 	ivcpu->ss_owner = false;
 
+	kvmi_singlestep_event(vcpu);
+
 out:
 	kvmi_put(kvm);
 }
