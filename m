Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 923F5634B9F
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 01:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235220AbiKWAUm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 19:20:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234723AbiKWAUl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 19:20:41 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B2B8657C7
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 16:20:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=2cdSSkt8hVjZTzlfdglHAos1iiy8w/MTdW54y5x5CRk=; b=CjrRZgNXmw11cLaDnHJuhZS8I3
        ecE9ytLxQFN3hG6t+hhHORcHkN1KYcRpjdxCL+ricjIP1Rz8aGJN3OD/Rq4cuvtGjUsnOoD1I6pnx
        rhYeLL15rlX+u5yLjC8e3f9JhG8wMGA97amyDoTVNAHtkpC4AL/k9PnGjDLTRJlIeMT3cexSrAefb
        Fj9QlPyQsW7pb6HEXl83M4qhlq4jjkk5z8s4fgvGhLuExb6xSbweXeAGKh4zmOlbPwrdPgWz7vwcb
        Cnpil3ytjdy1ozw/b19cV1QGlE3tu42Qfd4hthbtbd83SXdE10pZxq7eAo6F5NjlrsNCEk+YWyrrL
        7GCRWh0Q==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oxdV8-003dA4-QA; Wed, 23 Nov 2022 00:20:31 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oxdV8-000O7h-HU; Wed, 23 Nov 2022 00:20:30 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Michal Luczaj <mhal@rbox.co>, kvm@vger.kernel.org
Subject: [PATCH 2/3] KVM: x86/xen: Only do in-kernel acceleration of hypercalls for guest CPL0
Date:   Wed, 23 Nov 2022 00:20:29 +0000
Message-Id: <20221123002030.92716-2-dwmw2@infradead.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20221123002030.92716-1-dwmw2@infradead.org>
References: <20221123002030.92716-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

There are almost no hypercalls which are valid from CPL > 0, and definitely
none which are handled by the kernel.

Fixes: 2fd6df2f2b47 ("KVM: x86/xen: intercept EVTCHNOP_send from guests")
Reported-by: Michal Luczaj <mhal@rbox.co>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Cc: stable@kernel.org
---
 arch/x86/kvm/xen.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index dc2f304f2e69..f3098c0e386a 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -1227,6 +1227,7 @@ int kvm_xen_hypercall(struct kvm_vcpu *vcpu)
 	bool longmode;
 	u64 input, params[6], r = -ENOSYS;
 	bool handled = false;
+	u8 cpl;
 
 	input = (u64)kvm_register_read(vcpu, VCPU_REGS_RAX);
 
@@ -1254,9 +1255,17 @@ int kvm_xen_hypercall(struct kvm_vcpu *vcpu)
 		params[5] = (u64)kvm_r9_read(vcpu);
 	}
 #endif
+	cpl = static_call(kvm_x86_get_cpl)(vcpu);
 	trace_kvm_xen_hypercall(input, params[0], params[1], params[2],
 				params[3], params[4], params[5]);
 
+	/*
+	 * Only allow hypercall acceleration for CPL0. The rare hypercalls that
+	 * are permitted in guest userspace can be handled by the VMM.
+	 */
+	if (unlikely(cpl > 0))
+		goto handle_in_userspace;
+
 	switch (input) {
 	case __HYPERVISOR_xen_version:
 		if (params[0] == XENVER_version && vcpu->kvm->arch.xen.xen_version) {
@@ -1291,10 +1300,11 @@ int kvm_xen_hypercall(struct kvm_vcpu *vcpu)
 	if (handled)
 		return kvm_xen_hypercall_set_result(vcpu, r);
 
+handle_in_userspace:
 	vcpu->run->exit_reason = KVM_EXIT_XEN;
 	vcpu->run->xen.type = KVM_EXIT_XEN_HCALL;
 	vcpu->run->xen.u.hcall.longmode = longmode;
-	vcpu->run->xen.u.hcall.cpl = static_call(kvm_x86_get_cpl)(vcpu);
+	vcpu->run->xen.u.hcall.cpl = cpl;
 	vcpu->run->xen.u.hcall.input = input;
 	vcpu->run->xen.u.hcall.params[0] = params[0];
 	vcpu->run->xen.u.hcall.params[1] = params[1];
-- 
2.35.3

