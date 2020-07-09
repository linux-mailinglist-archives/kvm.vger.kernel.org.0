Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABFC021A29F
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 16:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728174AbgGIOyj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 10:54:39 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:58168 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728142AbgGIOyi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jul 2020 10:54:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594306477;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SJgs3cY8Qhm0LCXAIOI0OUHa7Tdn5qPMllixOPlffT4=;
        b=A/AaHBAzyYC9NJCs2+EjGWXUvibfnUzAu8ZPtmSmaH7U1wIn6JLPNMozGLUEJPBWjGu9p7
        yc+TSZ475uHOptwPvmSkeJRv1dp9Zl6/gKOoW0+jpMUQM/eGp2NSiv7aAaWflhw6f9Pw5Q
        jte/12AyVkOkMZBGocuZ8ji5ByVxVlY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-WTR0N3v8MyGqZEtKRej-Cw-1; Thu, 09 Jul 2020 10:54:32 -0400
X-MC-Unique: WTR0N3v8MyGqZEtKRej-Cw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 28F2E19200C5;
        Thu,  9 Jul 2020 14:54:31 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1B6A86106A;
        Thu,  9 Jul 2020 14:54:28 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Junaid Shahid <junaids@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 8/9] KVM: nSVM: use nested_svm_load_cr3() on guest->host switch
Date:   Thu,  9 Jul 2020 16:53:57 +0200
Message-Id: <20200709145358.1560330-9-vkuznets@redhat.com>
In-Reply-To: <20200709145358.1560330-1-vkuznets@redhat.com>
References: <20200709145358.1560330-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make nSVM code resemble nVMX where nested_vmx_load_cr3() is used on
both guest->host and host->guest transitions. Also, we can now
eliminate unconditional kvm_mmu_reset_context() and speed things up.

Note, nVMX has two different paths: load_vmcs12_host_state() and
nested_vmx_restore_host_state() and the later is used to restore from
'partial' switch to L2, it always uses kvm_mmu_reset_context().
nSVM doesn't have this yet. Also, nested_svm_vmexit()'s return value
is almost always ignored nowadays.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 5ddf20941cf9..9a137d3b3a1c 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -317,7 +317,7 @@ static inline bool nested_npt_enabled(struct vcpu_svm *svm)
 }
 
 /*
- * Load guest's cr3 at nested entry. @nested_npt is true if we are
+ * Load guest's/host's cr3 at nested entry. @nested_npt is true if we are
  * emulating VM-Entry into a guest with NPT enabled.
  */
 static int nested_svm_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
@@ -658,15 +658,12 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 
 	nested_svm_uninit_mmu_context(&svm->vcpu);
 
-	if (npt_enabled) {
-		svm->vmcb->save.cr3 = hsave->save.cr3;
-		svm->vcpu.arch.cr3 = hsave->save.cr3;
-	} else {
-		(void)kvm_set_cr3(&svm->vcpu, hsave->save.cr3);
-	}
+	rc = nested_svm_load_cr3(&svm->vcpu, hsave->save.cr3, false);
+	if (rc)
+		return 1;
 
-	kvm_mmu_reset_context(&svm->vcpu);
-	kvm_mmu_load(&svm->vcpu);
+	if (npt_enabled)
+		svm->vmcb->save.cr3 = hsave->save.cr3;
 
 	/*
 	 * Drop what we picked up for L2 via svm_complete_interrupts() so it
-- 
2.25.4

