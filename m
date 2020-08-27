Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D71A254BC4
	for <lists+kvm@lfdr.de>; Thu, 27 Aug 2020 19:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbgH0RMu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Aug 2020 13:12:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31157 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727959AbgH0RMo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 Aug 2020 13:12:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598548362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3ROoCGGpTRrb/9L2mOI1+wpaSOaUSIzU0RUeWqIshIE=;
        b=FqjoyOY8x+Suc7MloE/NaJBvkvZunOYUugM8IhScL6iDgD2SYJ4YSmJ/CCBMYjXwTs7IyA
        jLXJcJ/aGM2gcKiivvT1Ujf+P84ecNdD8mQFsvodYXaSuidk6RPmCP+dmN4849NkNQnyXm
        W2v8kP2oKvfwTn+rZ4FK9hESmb85tno=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-QE59aHs2P3CcbT05BHkdSA-1; Thu, 27 Aug 2020 13:12:41 -0400
X-MC-Unique: QE59aHs2P3CcbT05BHkdSA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2D88E10ABDBF;
        Thu, 27 Aug 2020 17:12:39 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA2105D9E8;
        Thu, 27 Aug 2020 17:12:35 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v3 7/8] KVM: emulator: more strict rsm checks.
Date:   Thu, 27 Aug 2020 20:11:44 +0300
Message-Id: <20200827171145.374620-8-mlevitsk@redhat.com>
In-Reply-To: <20200827171145.374620-1-mlevitsk@redhat.com>
References: <20200827171145.374620-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't ignore return values in rsm_load_state_64/32 to avoid
loading invalid state from SMM state area if it was tampered with
by the guest.

This is primarly intended to avoid letting guest set bits in EFER
(like EFER.SVME when nesting is disabled) by manipulating SMM save area.

The DR checks are probably redundant, since the code sets them to fixed
value, but it won't hurt to have them

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/emulate.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index d0e2825ae6174..1d450d7710d63 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2505,9 +2505,14 @@ static int rsm_load_state_32(struct x86_emulate_ctxt *ctxt,
 		*reg_write(ctxt, i) = GET_SMSTATE(u32, smstate, 0x7fd0 + i * 4);
 
 	val = GET_SMSTATE(u32, smstate, 0x7fcc);
-	ctxt->ops->set_dr(ctxt, 6, (val & DR6_VOLATILE) | DR6_FIXED_1);
+
+	if (ctxt->ops->set_dr(ctxt, 6, (val & DR6_VOLATILE) | DR6_FIXED_1))
+		return X86EMUL_UNHANDLEABLE;
+
 	val = GET_SMSTATE(u32, smstate, 0x7fc8);
-	ctxt->ops->set_dr(ctxt, 7, (val & DR7_VOLATILE) | DR7_FIXED_1);
+
+	if (ctxt->ops->set_dr(ctxt, 7, (val & DR7_VOLATILE) | DR7_FIXED_1))
+		return X86EMUL_UNHANDLEABLE;
 
 	selector =                 GET_SMSTATE(u32, smstate, 0x7fc4);
 	set_desc_base(&desc,       GET_SMSTATE(u32, smstate, 0x7f64));
@@ -2560,16 +2565,23 @@ static int rsm_load_state_64(struct x86_emulate_ctxt *ctxt,
 	ctxt->eflags = GET_SMSTATE(u32, smstate, 0x7f70) | X86_EFLAGS_FIXED;
 
 	val = GET_SMSTATE(u32, smstate, 0x7f68);
-	ctxt->ops->set_dr(ctxt, 6, (val & DR6_VOLATILE) | DR6_FIXED_1);
+
+	if (ctxt->ops->set_dr(ctxt, 6, (val & DR6_VOLATILE) | DR6_FIXED_1))
+		return X86EMUL_UNHANDLEABLE;
+
 	val = GET_SMSTATE(u32, smstate, 0x7f60);
-	ctxt->ops->set_dr(ctxt, 7, (val & DR7_VOLATILE) | DR7_FIXED_1);
+
+	if (ctxt->ops->set_dr(ctxt, 7, (val & DR7_VOLATILE) | DR7_FIXED_1))
+		return X86EMUL_UNHANDLEABLE;
 
 	cr0 =                       GET_SMSTATE(u64, smstate, 0x7f58);
 	cr3 =                       GET_SMSTATE(u64, smstate, 0x7f50);
 	cr4 =                       GET_SMSTATE(u64, smstate, 0x7f48);
 	ctxt->ops->set_smbase(ctxt, GET_SMSTATE(u32, smstate, 0x7f00));
 	val =                       GET_SMSTATE(u64, smstate, 0x7ed0);
-	ctxt->ops->set_msr(ctxt, MSR_EFER, val & ~EFER_LMA);
+
+	if (ctxt->ops->set_msr(ctxt, MSR_EFER, val & ~EFER_LMA))
+		return X86EMUL_UNHANDLEABLE;
 
 	selector =                  GET_SMSTATE(u32, smstate, 0x7e90);
 	rsm_set_desc_flags(&desc,   GET_SMSTATE(u32, smstate, 0x7e92) << 8);
-- 
2.26.2

