Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D02AAB9901
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2019 23:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393996AbfITV0Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Sep 2019 17:26:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53098 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392265AbfITVZN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Sep 2019 17:25:13 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6A1707F743;
        Fri, 20 Sep 2019 21:25:13 +0000 (UTC)
Received: from mail (ovpn-120-159.rdu2.redhat.com [10.10.120.159])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 49FD210013D9;
        Fri, 20 Sep 2019 21:25:13 +0000 (UTC)
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 14/17] KVM: monolithic: x86: inline more exit handlers in vmx.c
Date:   Fri, 20 Sep 2019 17:25:06 -0400
Message-Id: <20190920212509.2578-15-aarcange@redhat.com>
In-Reply-To: <20190920212509.2578-1-aarcange@redhat.com>
References: <20190920212509.2578-1-aarcange@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.71]); Fri, 20 Sep 2019 21:25:13 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

They can be called directly more efficiently, so we can as well mark
some of them inline in case gcc doesn't decide to inline them.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ff46008dc514..a6e597025011 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4588,7 +4588,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-static int handle_external_interrupt(struct kvm_vcpu *vcpu)
+static __always_inline int handle_external_interrupt(struct kvm_vcpu *vcpu)
 {
 	++vcpu->stat.irq_exits;
 	return 1;
@@ -4860,7 +4860,7 @@ static void vmx_set_dr7(struct kvm_vcpu *vcpu, unsigned long val)
 	vmcs_writel(GUEST_DR7, val);
 }
 
-static int handle_cpuid(struct kvm_vcpu *vcpu)
+static __always_inline int handle_cpuid(struct kvm_vcpu *vcpu)
 {
 	return kvm_emulate_cpuid(vcpu);
 }
@@ -4891,7 +4891,7 @@ static int handle_interrupt_window(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
-static int handle_halt(struct kvm_vcpu *vcpu)
+static __always_inline int handle_halt(struct kvm_vcpu *vcpu)
 {
 	return kvm_emulate_halt(vcpu);
 }
