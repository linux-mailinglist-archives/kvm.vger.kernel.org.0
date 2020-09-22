Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57235274ADC
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 23:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbgIVVKr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 17:10:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60887 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726608AbgIVVKq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 17:10:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600809045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/Foz+XYUa7ZklaXQpcdA4sOUwRgXBijhjYUcedH8z/g=;
        b=JkfwuQrGDZL6x5dpWQvaamcBISYop6tsWGV8L5pZKNH6jcBBVgI1/D0uobn0Msl1KKOBAi
        /IPUG8dupVPkpYaGMQYxVZ3gxzaUqpEBeclZFm35vVTSHDiIqwvdoQDhNDNE0u4dEWciP7
        vvJ2Ggc7Bd49X8HnkhZSY69f/voZULs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-TgGoGjdPN2ylSt-7G6NTGg-1; Tue, 22 Sep 2020 17:10:43 -0400
X-MC-Unique: TgGoGjdPN2ylSt-7G6NTGg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4534C64141;
        Tue, 22 Sep 2020 21:10:42 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.154])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9A09C55767;
        Tue, 22 Sep 2020 21:10:35 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v6 2/4] KVM: x86: report negative values from wrmsr emulation to userspace
Date:   Wed, 23 Sep 2020 00:10:23 +0300
Message-Id: <20200922211025.175547-3-mlevitsk@redhat.com>
In-Reply-To: <20200922211025.175547-1-mlevitsk@redhat.com>
References: <20200922211025.175547-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This will allow the KVM to report such errors (e.g -ENOMEM)
to the userspace.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/emulate.c | 7 +++++--
 arch/x86/kvm/x86.c     | 6 +++++-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 1d450d7710d63..d855304f5a509 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3702,13 +3702,16 @@ static int em_dr_write(struct x86_emulate_ctxt *ctxt)
 static int em_wrmsr(struct x86_emulate_ctxt *ctxt)
 {
 	u64 msr_data;
+	int ret;
 
 	msr_data = (u32)reg_read(ctxt, VCPU_REGS_RAX)
 		| ((u64)reg_read(ctxt, VCPU_REGS_RDX) << 32);
-	if (ctxt->ops->set_msr(ctxt, reg_read(ctxt, VCPU_REGS_RCX), msr_data))
+
+	ret = ctxt->ops->set_msr(ctxt, reg_read(ctxt, VCPU_REGS_RCX), msr_data);
+	if (ret > 0)
 		return emulate_gp(ctxt, 0);
 
-	return X86EMUL_CONTINUE;
+	return ret < 0 ? X86EMUL_UNHANDLEABLE : X86EMUL_CONTINUE;
 }
 
 static int em_rdmsr(struct x86_emulate_ctxt *ctxt)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 063d70e736f7f..e4b07be450d4e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1612,8 +1612,12 @@ int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
 {
 	u32 ecx = kvm_rcx_read(vcpu);
 	u64 data = kvm_read_edx_eax(vcpu);
+	int ret = kvm_set_msr(vcpu, ecx, data);
 
-	if (kvm_set_msr(vcpu, ecx, data)) {
+	if (ret < 0)
+		return ret;
+
+	if (ret > 0) {
 		trace_kvm_msr_write_ex(ecx, data);
 		kvm_inject_gp(vcpu, 0);
 		return 1;
-- 
2.26.2

