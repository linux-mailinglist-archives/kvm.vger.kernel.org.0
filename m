Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54E1AC1192
	for <lists+kvm@lfdr.de>; Sat, 28 Sep 2019 19:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729052AbfI1RY3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Sep 2019 13:24:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59544 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728705AbfI1RXZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Sep 2019 13:23:25 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6480F3091761;
        Sat, 28 Sep 2019 17:23:25 +0000 (UTC)
Received: from mail (ovpn-125-159.rdu2.redhat.com [10.10.125.159])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 436B360600;
        Sat, 28 Sep 2019 17:23:25 +0000 (UTC)
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 07/14] KVM: monolithic: x86: remove __init section prefix from kvm_x86_cpu_has_kvm_support
Date:   Sat, 28 Sep 2019 13:23:16 -0400
Message-Id: <20190928172323.14663-8-aarcange@redhat.com>
In-Reply-To: <20190928172323.14663-1-aarcange@redhat.com>
References: <20190928172323.14663-1-aarcange@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Sat, 28 Sep 2019 17:23:25 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Adjusts the section prefixes of some KVM x86 code function because
with the monolithic KVM model the section checker can now do a more
accurate static analysis at build time. This also allows to build
without CONFIG_SECTION_MISMATCH_WARN_ONLY=n.

The __init needs to be removed on vmx despite it's only svm calling it
from kvm_x86_hardware_enable which is eventually called by
hardware_enable_nolock() or there's a (potentially false positive)
warning (false positive because this function isn't called in the vmx
case). If this isn't needed the right cleanup isn't to put it in the
__init section, but to drop it. As long as it's defined in vmx as a
kvm_x86 operation, it's expectable that might eventually be called at
runtime while hot plugging new CPUs.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/vmx/vmx.c          | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0ae65148e5ed..75affbf7861b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1002,7 +1002,7 @@ struct kvm_lapic_irq {
 	bool msi_redir_hint;
 };
 
-extern __init int kvm_x86_cpu_has_kvm_support(void);
+extern int kvm_x86_cpu_has_kvm_support(void);
 extern __init int kvm_x86_disabled_by_bios(void);
 extern int kvm_x86_hardware_enable(void);
 extern void kvm_x86_hardware_disable(void);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2ae162eb082e..faccffc4709e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2094,7 +2094,7 @@ void kvm_x86_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
 	}
 }
 
-__init int kvm_x86_cpu_has_kvm_support(void)
+int kvm_x86_cpu_has_kvm_support(void)
 {
 	return cpu_has_vmx();
 }
