Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 258E02EBCC6
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 11:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbhAFKwD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 05:52:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43254 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726297AbhAFKwC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Jan 2021 05:52:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609930236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YDYoI+1izS8kEjpnJc2IN2ub+FMPEVAdBoF2mPHSuIU=;
        b=WUihY+NJb0Zr6EXnvEBQRV8oFULpUuYoM63pnkK80aH71aWtnYclFcuICSHA3mcH89/r+k
        8eks3vr7z7JzrK2Jls7I0XU2xWsoI8K2M0vRRhl1SovpdVKY5j9WUIsAKpjevD2M+gi4YU
        IUAU2sqtmZSYE1iQWuCoViy8GibjqTc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-450-a6U8CuxrO-il0UXi-igYtg-1; Wed, 06 Jan 2021 05:50:35 -0500
X-MC-Unique: a6U8CuxrO-il0UXi-igYtg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AF7F71005513;
        Wed,  6 Jan 2021 10:50:33 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BBDF5669FC;
        Wed,  6 Jan 2021 10:50:29 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 6/6] KVM: nSVM: mark vmcb as dirty when forcingly leaving the guest mode
Date:   Wed,  6 Jan 2021 12:50:01 +0200
Message-Id: <20210106105001.449974-7-mlevitsk@redhat.com>
In-Reply-To: <20210106105001.449974-1-mlevitsk@redhat.com>
References: <20210106105001.449974-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We overwrite most of vmcb fields while doing so, so we must
mark it as dirty.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 3aa18016832d0..de3dbb5407206 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -763,6 +763,7 @@ void svm_leave_nested(struct vcpu_svm *svm)
 		leave_guest_mode(&svm->vcpu);
 		copy_vmcb_control_area(&vmcb->control, &hsave->control);
 		nested_svm_uninit_mmu_context(&svm->vcpu);
+		vmcb_mark_all_dirty(svm->vmcb);
 	}
 
 	kvm_clear_request(KVM_REQ_GET_NESTED_STATE_PAGES, &svm->vcpu);
-- 
2.26.2

