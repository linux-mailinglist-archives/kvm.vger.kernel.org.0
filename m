Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9F237157D
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 14:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233943AbhECM4A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 08:56:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36429 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233915AbhECMzz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 May 2021 08:55:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620046501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mIEpsQd6XZSOwmDS5jk+XOTkhwLc0GrdWpfAAXyyA/g=;
        b=IYhNmoMO2WW1sjYF1Hf+tg192o0fAuZQByuptRLVTDvxbMVhnBGVCcTjKXQjIBLIsez6T8
        eh6lRzrP4t+zbJpCRqSoFC/6FZ5pVbYTI14Z6f3vo5vE88diG/F0fjjxbGDlHwXYEQHFiA
        FX2/iKjsT0hsLF4apCItjmi0903rC+k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-7kkZE34_Pb6zu7pHlgclHw-1; Mon, 03 May 2021 08:54:58 -0400
X-MC-Unique: 7kkZE34_Pb6zu7pHlgclHw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DD33E80ED96;
        Mon,  3 May 2021 12:54:56 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.193.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C3F7CBA6F;
        Mon,  3 May 2021 12:54:52 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Sean Christopherson <seanjc@google.com>,
        Cathy Avery <cavery@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 1/5] KVM: nSVM: fix a typo in svm_leave_nested
Date:   Mon,  3 May 2021 15:54:42 +0300
Message-Id: <20210503125446.1353307-2-mlevitsk@redhat.com>
In-Reply-To: <20210503125446.1353307-1-mlevitsk@redhat.com>
References: <20210503125446.1353307-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When forcibly leaving the nested mode, we should switch to vmcb01

Fixes: 4995a3685f1b ("KVM: SVM: Use a separate vmcb for the nested L2 guest")

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 540d43ba2cf4..3321220f3deb 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -886,7 +886,7 @@ void svm_leave_nested(struct vcpu_svm *svm)
 		svm->nested.nested_run_pending = 0;
 		leave_guest_mode(vcpu);
 
-		svm_switch_vmcb(svm, &svm->nested.vmcb02);
+		svm_switch_vmcb(svm, &svm->vmcb01);
 
 		nested_svm_uninit_mmu_context(vcpu);
 		vmcb_mark_all_dirty(svm->vmcb);
-- 
2.26.2

