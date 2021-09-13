Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A161A4092EA
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 16:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344390AbhIMOQa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 10:16:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32277 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344133AbhIMOL3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Sep 2021 10:11:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631542213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HAk+4Ryawj4Ec+KIX3poPsHgTj+9jieC8UMzgx7uXjw=;
        b=Mm8IxDsewHkMKv2zrcbIYf3zDCiyw/dMwBI1DRRw6wGY2f9r3us2QFy6aQTYuIjgQxZxD+
        PCVO+ZwiCEwAx8JjwJaJQUOvY/HK74n5Q48Xq1luz63CIhR4Y37doyNodqhT4yjMBCKF3a
        DSYZ4cdxTqe9TmNls3Eei3rx1ydr1tE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-90-4Qrtf2jiMEW5I7DLZYFJCg-1; Mon, 13 Sep 2021 10:10:09 -0400
X-MC-Unique: 4Qrtf2jiMEW5I7DLZYFJCg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A22C21006AA4;
        Mon, 13 Sep 2021 14:10:07 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4A7B319724;
        Mon, 13 Sep 2021 14:10:04 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v3 2/7] KVM: x86: nSVM: restore the L1 host state prior to resuming nested guest on SMM exit
Date:   Mon, 13 Sep 2021 17:09:49 +0300
Message-Id: <20210913140954.165665-3-mlevitsk@redhat.com>
In-Reply-To: <20210913140954.165665-1-mlevitsk@redhat.com>
References: <20210913140954.165665-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Otherwise guest entry code might see incorrect L1 state (e.g paging state).

Fixes: 37be407b2ce8 ("KVM: nSVM: Fix L1 state corruption upon return from SMM")

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a75dafbfa4a6..e3b092a3a2e1 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4358,10 +4358,6 @@ static int svm_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 	if (svm_allocate_nested(svm))
 		goto unmap_save;
 
-	vmcb12 = map.hva;
-	nested_load_control_from_vmcb12(svm, &vmcb12->control);
-	ret = enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12);
-
 	/*
 	 * Restore L1 host state from L1 HSAVE area as VMCB01 was
 	 * used during SMM (see svm_enter_smm())
@@ -4369,6 +4365,14 @@ static int svm_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 
 	svm_copy_vmrun_state(&svm->vmcb01.ptr->save, map_save.hva + 0x400);
 
+	/*
+	 * Enter the nested guest now
+	 */
+
+	vmcb12 = map.hva;
+	nested_load_control_from_vmcb12(svm, &vmcb12->control);
+	ret = enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12);
+
 unmap_save:
 	kvm_vcpu_unmap(vcpu, &map_save, true);
 unmap_map:
-- 
2.26.3

