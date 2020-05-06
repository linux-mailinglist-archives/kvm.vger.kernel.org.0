Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 444411C6F05
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 13:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728282AbgEFLKu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 07:10:50 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:32462 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728187AbgEFLKs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 May 2020 07:10:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588763447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=mr9x5PJcF7Hzoh5oRRsXaOLTGqKm4KfDRv0S4QUsVzI=;
        b=iFBfujRz6uojtsq4xnCSlAjRtn2y/nDLikPbE3Y7HWVJC8rUpag8xnKISj+roeX4M6NhKo
        HHcaZ0SGUYIl8bOoPNF2iKYkjN0HKtzbJqLJiMu7YvhWczbnpf8Q1Go1aQq5JNTXn8Y6MR
        Bccz6lP1hUPLbCVAT1VUUTWOa0+lzCI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-2wAHLa10Ne-IM6pVCPPVUA-1; Wed, 06 May 2020 07:10:45 -0400
X-MC-Unique: 2wAHLa10Ne-IM6pVCPPVUA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 194CC1899521;
        Wed,  6 May 2020 11:10:44 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 85C165C1D4;
        Wed,  6 May 2020 11:10:43 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterx@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 3/9] KVM: X86: Set RTM for DB_VECTOR too for KVM_EXIT_DEBUG
Date:   Wed,  6 May 2020 07:10:28 -0400
Message-Id: <20200506111034.11756-4-pbonzini@redhat.com>
In-Reply-To: <20200506111034.11756-1-pbonzini@redhat.com>
References: <20200506111034.11756-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Peter Xu <peterx@redhat.com>

RTM should always been set even with KVM_EXIT_DEBUG on #DB.

Signed-off-by: Peter Xu <peterx@redhat.com>
Message-Id: <20200505205000.188252-2-peterx@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index bb5a527e49d9..2384a2dbec44 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4683,7 +4683,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 			kvm_queue_exception_p(vcpu, DB_VECTOR, dr6);
 			return 1;
 		}
-		kvm_run->debug.arch.dr6 = dr6 | DR6_FIXED_1;
+		kvm_run->debug.arch.dr6 = dr6 | DR6_FIXED_1 | DR6_RTM;
 		kvm_run->debug.arch.dr7 = vmcs_readl(GUEST_DR7);
 		/* fall through */
 	case BP_VECTOR:
-- 
2.18.2


