Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 982B0229CAB
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 18:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730106AbgGVQBj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 12:01:39 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37952 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728956AbgGVQBi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Jul 2020 12:01:38 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 62B3C305D763;
        Wed, 22 Jul 2020 19:01:32 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.6])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 4C8A3305FFA1;
        Wed, 22 Jul 2020 19:01:32 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?=C8=98tefan=20=C8=98icleru?= <ssicleru@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v1 14/34] KVM: introspection: add 'view' field to struct kvmi_event_arch
Date:   Wed, 22 Jul 2020 19:01:01 +0300
Message-Id: <20200722160121.9601-15-alazar@bitdefender.com>
In-Reply-To: <20200722160121.9601-1-alazar@bitdefender.com>
References: <20200722160121.9601-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ștefan Șicleru <ssicleru@bitdefender.com>

Report the view a vCPU operates on when sending events to the
introspection tool.

Signed-off-by: Ștefan Șicleru <ssicleru@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/uapi/asm/kvmi.h | 4 +++-
 arch/x86/kvm/kvmi.c              | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/uapi/asm/kvmi.h b/arch/x86/include/uapi/asm/kvmi.h
index 3087c685c232..a13a98fa863f 100644
--- a/arch/x86/include/uapi/asm/kvmi.h
+++ b/arch/x86/include/uapi/asm/kvmi.h
@@ -12,7 +12,9 @@
 
 struct kvmi_event_arch {
 	__u8 mode;		/* 2, 4 or 8 */
-	__u8 padding[7];
+	__u8 padding1;
+	__u16 view;
+	__u32 padding2;
 	struct kvm_regs regs;
 	struct kvm_sregs sregs;
 	struct {
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index bd31809ff812..292606902338 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -102,6 +102,7 @@ void kvmi_arch_setup_event(struct kvm_vcpu *vcpu, struct kvmi_event *ev)
 	kvm_arch_vcpu_get_sregs(vcpu, &event->sregs);
 	ev->arch.mode = kvmi_vcpu_mode(vcpu, &event->sregs);
 	kvmi_get_msrs(vcpu, event);
+	event->view = kvm_get_ept_view(vcpu);
 }
 
 int kvmi_arch_cmd_vcpu_get_info(struct kvm_vcpu *vcpu,
