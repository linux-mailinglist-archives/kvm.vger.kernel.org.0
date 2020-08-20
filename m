Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFC1524BEEA
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 15:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728787AbgHTNev (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 09:34:51 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:28469 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729958AbgHTNeO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Aug 2020 09:34:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597930453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HaHLFqVAiDxW08W+ogm9NGXchWMuf3jTiZHBgyves6g=;
        b=RzFC59K3n7++qV+UDhaWuqs0JSSb45uEFCauhuCuqL7IU78qyDUW8zF5+cQRYh7pgOM4tA
        UE+OS8VOYndKg4kzyGke/uWQh0MSOUt4HjshKW8eVju4EtY6cwOJh8NreeiTxNQIKq0ZZC
        qXn9Cu8pfyrmYYGxhR2CbhzzxVPnolc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-450-GfrCRxDYNrSjK6pwOlLl0g-1; Thu, 20 Aug 2020 09:34:09 -0400
X-MC-Unique: GfrCRxDYNrSjK6pwOlLl0g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D1FD8014D8;
        Thu, 20 Aug 2020 13:34:07 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.173])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3817916D40;
        Thu, 20 Aug 2020 13:34:04 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Jim Mattson <jmattson@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 6/7] KVM: emulator: more strict rsm checks.
Date:   Thu, 20 Aug 2020 16:33:38 +0300
Message-Id: <20200820133339.372823-7-mlevitsk@redhat.com>
In-Reply-To: <20200820133339.372823-1-mlevitsk@redhat.com>
References: <20200820133339.372823-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't ignore return values in rsm_load_state_64/32 to avoid
loading invalid state from SMM state area if it was tampered with
by the guest.

This is primarly intended to avoid letting guest bad bits in EFER
(like EFER.SVME when nesting is disabled) by manipulating SMM save area.

The DR checks are probably redundant, since the code sets them to fixed
value, but it won't hurt to have them

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/emulate.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index d0e2825ae617..1d450d7710d6 100644
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

