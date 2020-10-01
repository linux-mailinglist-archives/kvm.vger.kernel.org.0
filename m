Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4B427FE6E
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 13:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732100AbgJALau (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Oct 2020 07:30:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38779 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731990AbgJALaZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Oct 2020 07:30:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601551824;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H5EAIW0Xly/NV15swdFEF2p3VZ5gRKnltxC/TTKS1mQ=;
        b=XJkFPT7RaClkl4Exm2E1slCVaLnqdrc89qZ9eT5y+uSCCccxdPqVaMT/UhxQdmDJ61NU4K
        KAvnN7UdApKMM3k30Rx6xZ4mljlV1XenU1ZknZZYVWcZYRMXT3uNMV29m9aAlSJS/BcQC3
        hKilll3zbPpasX3wLM97rmiG5weAp8E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-308-AnWcZoqnMv6fGQd3pUJXGQ-1; Thu, 01 Oct 2020 07:30:19 -0400
X-MC-Unique: AnWcZoqnMv6fGQd3pUJXGQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D57B106B82B;
        Thu,  1 Oct 2020 11:30:17 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C71CB55772;
        Thu,  1 Oct 2020 11:30:13 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Borislav Petkov <bp@alien8.de>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v7 2/4] KVM: x86: report negative values from wrmsr emulation to userspace
Date:   Thu,  1 Oct 2020 14:29:52 +0300
Message-Id: <20201001112954.6258-3-mlevitsk@redhat.com>
In-Reply-To: <20201001112954.6258-1-mlevitsk@redhat.com>
References: <20201001112954.6258-1-mlevitsk@redhat.com>
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
 arch/x86/kvm/emulate.c | 4 ++--
 arch/x86/kvm/x86.c     | 9 ++++++---
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 0cc0db500f718..0d917eb703194 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3712,10 +3712,10 @@ static int em_wrmsr(struct x86_emulate_ctxt *ctxt)
 	if (r == X86EMUL_IO_NEEDED)
 		return r;
 
-	if (r)
+	if (r > 0)
 		return emulate_gp(ctxt, 0);
 
-	return X86EMUL_CONTINUE;
+	return r < 0 ? X86EMUL_UNHANDLEABLE : X86EMUL_CONTINUE;
 }
 
 static int em_rdmsr(struct x86_emulate_ctxt *ctxt)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 09a0cad49af51..7af04f9e20b48 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1737,13 +1737,16 @@ int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
 	r = kvm_set_msr(vcpu, ecx, data);
 
 	/* MSR write failed? See if we should ask user space */
-	if (r && kvm_set_msr_user_space(vcpu, ecx, data, r)) {
+	if (r && kvm_set_msr_user_space(vcpu, ecx, data, r))
 		/* Bounce to user space */
 		return 0;
-	}
+
+	/* Signal all other negative errors to userspace */
+	if (r < 0)
+		return r;
 
 	/* MSR write failed? Inject a #GP */
-	if (r) {
+	if (r > 0) {
 		trace_kvm_msr_write_ex(ecx, data);
 		kvm_inject_gp(vcpu, 0);
 		return 1;
-- 
2.26.2

