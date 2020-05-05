Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB02B1C646E
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 01:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729607AbgEEXW0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 19:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727989AbgEEXWZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 May 2020 19:22:25 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 699E9C061A0F
        for <kvm@vger.kernel.org>; Tue,  5 May 2020 16:22:24 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id v2so409341qvy.1
        for <kvm@vger.kernel.org>; Tue, 05 May 2020 16:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:cc;
        bh=KRCtvOQLMhB/Maooz9ShokLf3stfX6zzHEC/eolYhBA=;
        b=tt+/wqfJXh0jiLnXqUqhy1o+mh6qOux1fml0wG9CjZxzpolsvx0UVRbGzRvycssO7Y
         7yMLluHgTLA4j5jcvGuSti/PCiaVXHArfuTc08OKl7Dn+14e7sLE5WzE9QFTPH4Q47/R
         s5VgtyEv2FCR48whuvS/n237gAHL8PVI+EiScKAd4k/5xXRX+L0CQQOsz2uC1kSikVck
         sZHC0f7ymHPlTRUH4VC9MJnTHLyWfmW+Rn8u3OHquoSwDHafFZKA/khioAD4e+HL9lHp
         M8F6/reCe2F2keB9prXh6K+g+uh3el9Rau+nLOPG/OXaMH58BilYKStrwTzSf6Kkmto4
         wY3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:cc;
        bh=KRCtvOQLMhB/Maooz9ShokLf3stfX6zzHEC/eolYhBA=;
        b=LmVOjjXGq4Es1701jg+RP48FgNfr1mXGz066ZSelEfB3f2AmYr53PjdZKF9h6mzCVH
         uHGf38m2AQQxSYDi6YHUk41ES/fm4d21G3XpFGMUbThyVQpG0ztVHhwD7S+MtTr5x+oO
         igF6Q/6smi/pRIxgYhFe108X/ndgeu2ymI40idhhMSxuP9/HysBvA1rmWFzqBSn6VTD0
         Wi/yYQQ0Mp2k8LBLYdKqnHBJKMq8syY3x2eoCwlDQsXmUAY/N5Vccu/vAY05VPMPFJGR
         lIYj1KwhQLPrgKwf8AuEDz8cBaMwLI/Vj5Gs+iUrXv450ByroCrmSoJFRuqChIh5REOA
         W+dQ==
X-Gm-Message-State: AGi0PuadspuLI+DJnB/d/orTAEK2CHHCq6CVAtRrpLXyEAtX2p3iNwZ0
        3TBoEQxAFLYxGsyqc6VShilfPk2x2lg=
X-Google-Smtp-Source: APiQypJXD1WR+A4/O+bG7RxbVQDDvrz6M38ZTpeOVg1ILrSyZFxyBpSbjgRJyJJnXlKslaQJkeVB3JFN780=
X-Received: by 2002:a0c:b5c4:: with SMTP id o4mr5167285qvf.229.1588720943622;
 Tue, 05 May 2020 16:22:23 -0700 (PDT)
Date:   Tue,  5 May 2020 23:22:01 +0000
Message-Id: <20200505232201.923-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [PATCH] kvm: x86: get vmcs12 pages before checking pending interrupts
From:   Oliver Upton <oupton@google.com>
Cc:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
To:     unlisted-recipients:; (no To-header on input)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vmx_guest_apic_has_interrupt implicitly depends on the virtual APIC
page being present + mapped into the kernel address space. Normally,
upon VMLAUNCH/VMRESUME, we get the vmcs12 pages directly. However, if a
live migration were to occur before reaching vcpu_block, the virtual
APIC will not be restored on the target host.

Fix this by getting vmcs12 pages before inspecting the virtual APIC
page.

Cc: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
---

 Parent commit: 7c67f54661fc ("KVM: SVM: do not allow VMRUN inside SMM")

 arch/x86/kvm/x86.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8c0b77ac8dc6..edd3b75ad578 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8494,6 +8494,16 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
 {
+	/*
+	 * We must first get the vmcs12 pages before checking for interrupts
+	 * (done in kvm_arch_vcpu_runnable) in case L1 is using
+	 * virtual-interrupt delivery.
+	 */
+	if (kvm_check_request(KVM_REQ_GET_VMCS12_PAGES, vcpu)) {
+		if (unlikely(!kvm_x86_ops.nested_ops->get_vmcs12_pages(vcpu)))
+			return 0;
+	}
+
 	if (!kvm_arch_vcpu_runnable(vcpu) &&
 	    (!kvm_x86_ops.pre_block || kvm_x86_ops.pre_block(vcpu) == 0)) {
 		srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
-- 
2.26.2.526.g744177e7f7-goog

