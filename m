Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4245C2D1B1C
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 21:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727285AbgLGUs2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 15:48:28 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:42572 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727304AbgLGUs2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 15:48:28 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id CD9AF305D472;
        Mon,  7 Dec 2020 22:46:20 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id AB5133072785;
        Mon,  7 Dec 2020 22:46:20 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v11 51/81] KVM: introspection: add the crash action handling on the event reply
Date:   Mon,  7 Dec 2020 22:45:52 +0200
Message-Id: <20201207204622.15258-52-alazar@bitdefender.com>
In-Reply-To: <20201207204622.15258-1-alazar@bitdefender.com>
References: <20201207204622.15258-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

This action is used in extreme cases such as blocking the spread of
malware as fast as possible.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 virt/kvm/introspection/kvmi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index ded791e97de1..699d0db09537 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -752,6 +752,10 @@ void kvmi_handle_common_event_actions(struct kvm_vcpu *vcpu, u32 action)
 	struct kvm *kvm = vcpu->kvm;
 
 	switch (action) {
+	case KVMI_EVENT_ACTION_CRASH:
+		vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
+		break;
+
 	default:
 		kvmi_handle_unsupported_event_action(kvm);
 	}
