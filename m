Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44FFD1C88EA
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 13:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbgEGLvD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 07:51:03 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54723 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726268AbgEGLuU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 May 2020 07:50:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588852219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=W5riBzVUKkB6NCjOr6EGGlpf0G4S730RIG+n0MmRaKg=;
        b=dwD1U4HTDgJH7wIFijCg12OFeBwQtRcRG8hzPLk4HX+7dCUZuGM1/CdD9NoF61157UO5Fn
        ctFEy273JeQToDwS3GyN85fro2rBoKzDAopYHEPjp1AfnoaJqa9kkn4j9Nfmblygb3EkmR
        93YdJxLQ8PcpvGwY5QWPSfKSuXd2Fho=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-56-TJb7pl3RPT-5ooEXlXW90g-1; Thu, 07 May 2020 07:50:17 -0400
X-MC-Unique: TJb7pl3RPT-5ooEXlXW90g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 03490107ACF6;
        Thu,  7 May 2020 11:50:17 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9883A1C933;
        Thu,  7 May 2020 11:50:16 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterx@redhat.com
Subject: [PATCH v2 4/9] KVM: X86: Fix single-step with KVM_SET_GUEST_DEBUG
Date:   Thu,  7 May 2020 07:50:06 -0400
Message-Id: <20200507115011.494562-5-pbonzini@redhat.com>
In-Reply-To: <20200507115011.494562-1-pbonzini@redhat.com>
References: <20200507115011.494562-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Peter Xu <peterx@redhat.com>

When single-step triggered with KVM_SET_GUEST_DEBUG, we should fill in the pc
value with current linear RIP rather than the cached singlestep address.

Signed-off-by: Peter Xu <peterx@redhat.com>
Message-Id: <20200505205000.188252-3-peterx@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 109115c96897..f7628555f036 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6662,7 +6662,7 @@ static int kvm_vcpu_do_singlestep(struct kvm_vcpu *vcpu)
 
 	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
 		kvm_run->debug.arch.dr6 = DR6_BS | DR6_FIXED_1 | DR6_RTM;
-		kvm_run->debug.arch.pc = vcpu->arch.singlestep_rip;
+		kvm_run->debug.arch.pc = kvm_get_linear_rip(vcpu);
 		kvm_run->debug.arch.exception = DB_VECTOR;
 		kvm_run->exit_reason = KVM_EXIT_DEBUG;
 		return 0;
-- 
2.18.2


