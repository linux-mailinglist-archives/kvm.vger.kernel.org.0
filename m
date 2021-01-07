Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9F8C2ECCFD
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 10:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727727AbhAGJkx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 04:40:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41604 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727610AbhAGJkw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Jan 2021 04:40:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610012366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/rUDn4iUvZuPv1RG4V69vuqnelYUdquiGujPqeCfAnA=;
        b=YE4wXhDitRzgVI7IN80dJzghK65AZ2Scem55IwuCJ0+Mfj0gxmUYmYiRxz3C+z6zooLFN4
        /FC//A8fX5hxNNmKSHq87hdGOgPTjKHv6idJB15pqWi2OeHsW64Xsarf0VKbXGu/Wi6C8z
        N1LXv0N0BbJ7mLHexE2Ldo+TLJ6IWug=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-231-m098VikkMHCG-6o0mpOXiA-1; Thu, 07 Jan 2021 04:39:24 -0500
X-MC-Unique: m098VikkMHCG-6o0mpOXiA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C1BDA10054FF;
        Thu,  7 Jan 2021 09:39:22 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2375E19D7D;
        Thu,  7 Jan 2021 09:39:18 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Ingo Molnar <mingo@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 4/4] KVM: nSVM: mark vmcb as dirty when forcingly leaving the guest mode
Date:   Thu,  7 Jan 2021 11:38:54 +0200
Message-Id: <20210107093854.882483-5-mlevitsk@redhat.com>
In-Reply-To: <20210107093854.882483-1-mlevitsk@redhat.com>
References: <20210107093854.882483-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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
index e91d40c8d8c91..c340fbad88566 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -760,6 +760,7 @@ void svm_leave_nested(struct vcpu_svm *svm)
 		leave_guest_mode(&svm->vcpu);
 		copy_vmcb_control_area(&vmcb->control, &hsave->control);
 		nested_svm_uninit_mmu_context(&svm->vcpu);
+		vmcb_mark_all_dirty(svm->vmcb);
 	}
 
 	kvm_clear_request(KVM_REQ_GET_NESTED_STATE_PAGES, &svm->vcpu);
-- 
2.26.2

