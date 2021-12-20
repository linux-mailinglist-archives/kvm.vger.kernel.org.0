Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D912647AFEC
	for <lists+kvm@lfdr.de>; Mon, 20 Dec 2021 16:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238959AbhLTPWp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Dec 2021 10:22:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60852 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239771AbhLTPV4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Dec 2021 10:21:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640013715;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FioMabO3Q6ai30iKL6S6jRmIFesbf0VG5A9s16QQUJM=;
        b=gJYmDie9P3p81CW2Z8jgrKKLu16LEyHuIZ9qEyrPfDfmbUlt+fMsjnvWwM9/iMc+gWlHQr
        p4sLUZNJCjj+cHbv43Z+Cgl4xKqE5sk37G5lxPu2zaD+XyxplnEZBMNYEOPg4rd5ZgTZFb
        ADUD9F2ESRkkKOVnPKnHe8WxyTroWGs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-56-84GXhBVmO3ezw2W7vxYIfg-1; Mon, 20 Dec 2021 10:21:52 -0500
X-MC-Unique: 84GXhBVmO3ezw2W7vxYIfg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 150C61937FC0;
        Mon, 20 Dec 2021 15:21:51 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CCBFE7B6CE;
        Mon, 20 Dec 2021 15:21:48 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Vineeth Pillai <viremana@linux.microsoft.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] KVM: SVM: hyper-v: Enable Enlightened MSR-Bitmap support for real
Date:   Mon, 20 Dec 2021 16:21:36 +0100
Message-Id: <20211220152139.418372-3-vkuznets@redhat.com>
In-Reply-To: <20211220152139.418372-1-vkuznets@redhat.com>
References: <20211220152139.418372-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit c4327f15dfc7 ("KVM: SVM: hyper-v: Enlightened MSR-Bitmap support")
introduced enlightened MSR-Bitmap support for KVM-on-Hyper-V but it didn't
actually enable the support. Similar to enlightened NPT TLB flush and
direct TLB flush features, the guest (KVM) has to tell L0 (Hyper-V) that
it's using the feature by setting the appropriate feature fit in VMCB
control area (sw reserved fields).

Fixes: c4327f15dfc7 ("KVM: SVM: hyper-v: Enlightened MSR-Bitmap support")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/svm/svm_onhyperv.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhyperv.h
index cdbcfc63d171..489ca56212c6 100644
--- a/arch/x86/kvm/svm/svm_onhyperv.h
+++ b/arch/x86/kvm/svm/svm_onhyperv.h
@@ -46,6 +46,9 @@ static inline void svm_hv_init_vmcb(struct vmcb *vmcb)
 	if (npt_enabled &&
 	    ms_hyperv.nested_features & HV_X64_NESTED_ENLIGHTENED_TLB)
 		hve->hv_enlightenments_control.enlightened_npt_tlb = 1;
+
+	if (ms_hyperv.nested_features & HV_X64_NESTED_MSR_BITMAP)
+		hve->hv_enlightenments_control.msr_bitmap = 1;
 }
 
 static inline void svm_hv_hardware_setup(void)
-- 
2.33.1

