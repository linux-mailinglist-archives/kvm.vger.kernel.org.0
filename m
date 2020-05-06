Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC99F1C6F06
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 13:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728295AbgEFLKv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 07:10:51 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:46313 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728212AbgEFLKs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 May 2020 07:10:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588763447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=W5riBzVUKkB6NCjOr6EGGlpf0G4S730RIG+n0MmRaKg=;
        b=bGuoBMBqMy0nhPz9wt6Ey8a6LlHKWEHI+20GPdRPnqwFtcmdlyJFdrcj4U/QiUUjU/eCj6
        z6GUCoROn0ExpTnoh+ExeDUQNmgwD9g0HvHrzYrsx80ZC0s12aWI5nb/bU285WS393Y4Tc
        5yqKEfn7L7ddr1AKfn0rX5rnyKiOev4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-ktfJFPYsM5mnAeO_sj8lSA-1; Wed, 06 May 2020 07:10:45 -0400
X-MC-Unique: ktfJFPYsM5mnAeO_sj8lSA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C570480183C;
        Wed,  6 May 2020 11:10:44 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3F1CB5C1D4;
        Wed,  6 May 2020 11:10:44 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterx@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 4/9] KVM: X86: Fix single-step with KVM_SET_GUEST_DEBUG
Date:   Wed,  6 May 2020 07:10:29 -0400
Message-Id: <20200506111034.11756-5-pbonzini@redhat.com>
In-Reply-To: <20200506111034.11756-1-pbonzini@redhat.com>
References: <20200506111034.11756-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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


