Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F00F5C1185
	for <lists+kvm@lfdr.de>; Sat, 28 Sep 2019 19:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbfI1RX0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Sep 2019 13:23:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51154 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728717AbfI1RXZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Sep 2019 13:23:25 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 72035C057E9F;
        Sat, 28 Sep 2019 17:23:25 +0000 (UTC)
Received: from mail (ovpn-125-159.rdu2.redhat.com [10.10.125.159])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D8015C223;
        Sat, 28 Sep 2019 17:23:25 +0000 (UTC)
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 05/14] KVM: monolithic: add more section prefixes in the KVM common code
Date:   Sat, 28 Sep 2019 13:23:14 -0400
Message-Id: <20190928172323.14663-6-aarcange@redhat.com>
In-Reply-To: <20190928172323.14663-1-aarcange@redhat.com>
References: <20190928172323.14663-1-aarcange@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Sat, 28 Sep 2019 17:23:25 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add more section prefixes of some KVM common code function because
with the monolithic KVM model the section checker can now do a more
accurate static analysis at build time and this allows to build
without CONFIG_SECTION_MISMATCH_WARN_ONLY=n.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 arch/x86/kvm/x86.c       | 4 ++--
 include/linux/kvm_host.h | 4 ++--
 virt/kvm/kvm_main.c      | 6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8e593d28ff95..601190de4f87 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9206,7 +9206,7 @@ void kvm_arch_hardware_disable(void)
 	drop_user_return_notifiers();
 }
 
-int kvm_arch_hardware_setup(void)
+__init int kvm_arch_hardware_setup(void)
 {
 	int r;
 
@@ -9237,7 +9237,7 @@ void kvm_arch_hardware_unsetup(void)
 	kvm_x86_hardware_unsetup();
 }
 
-int kvm_arch_check_processor_compat(void)
+__init int kvm_arch_check_processor_compat(void)
 {
 	return kvm_x86_check_processor_compatibility();
 }
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index fcb46b3374c6..8621916998e1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -867,9 +867,9 @@ void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu);
 
 int kvm_arch_hardware_enable(void);
 void kvm_arch_hardware_disable(void);
-int kvm_arch_hardware_setup(void);
+__init int kvm_arch_hardware_setup(void);
 void kvm_arch_hardware_unsetup(void);
-int kvm_arch_check_processor_compat(void);
+__init int kvm_arch_check_processor_compat(void);
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu);
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e6de3159e682..9aa448ea688f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4235,13 +4235,13 @@ static void kvm_sched_out(struct preempt_notifier *pn,
 	kvm_arch_vcpu_put(vcpu);
 }
 
-static void check_processor_compat(void *rtn)
+static __init void check_processor_compat(void *rtn)
 {
 	*(int *)rtn = kvm_arch_check_processor_compat();
 }
 
-int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
-		  struct module *module)
+__init int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
+		    struct module *module)
 {
 	int r;
 	int cpu;
