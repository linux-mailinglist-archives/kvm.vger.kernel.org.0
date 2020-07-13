Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D06121A597
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 19:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbgGIRPS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 13:15:18 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60336 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726758AbgGIRPR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jul 2020 13:15:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594314916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=rxmyluFqhYgjlE8gknBB9LIu9DuavODGBVATYaytN8k=;
        b=Fw/KKrPXCsMBCym8yze/fJOhxcpIMJKHYTrB6z+1zIyHX3Mfu1ugE6fCGPKQnWVAlifgmn
        Da0Uo9E9ZoWgjpL+hjiYD+HDE30eXtn9QCst2gAoiJhJAM8p9MBcPfMVdvmQXlp0H0WtB7
        9Yf1a5OBOoiD7LiGOY01Uf7GySszTDg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-yE6sFXMCM8qmyFHsuVY5lw-1; Thu, 09 Jul 2020 13:15:14 -0400
X-MC-Unique: yE6sFXMCM8qmyFHsuVY5lw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2C3E810059A2;
        Thu,  9 Jul 2020 17:15:13 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C4CF8610F2;
        Thu,  9 Jul 2020 17:15:08 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     bsd@redhat.com, Makarand Sonare <makarandsonare@google.com>
Subject: [PATCH] KVM: nVMX: fixes for preemption timer migration
Date:   Thu,  9 Jul 2020 13:15:07 -0400
Message-Id: <20200709171507.1819-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 850448f35aaf ("KVM: nVMX: Fix VMX preemption timer migration",
2020-06-01) accidentally broke nVMX live migration from older version
by changing the userspace ABI.  Restore it and, while at it, ensure
that vmx->nested.has_preemption_timer_deadline is always initialized
according to the KVM_STATE_VMX_PREEMPTION_TIMER_DEADLINE flag.

Cc: Makarand Sonare <makarandsonare@google.com>
Fixes: 850448f35aaf ("KVM: nVMX: Fix VMX preemption timer migration")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/uapi/asm/kvm.h | 5 +++--
 arch/x86/kvm/vmx/nested.c       | 3 ++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 17c5a038f42d..0780f97c1850 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -408,14 +408,15 @@ struct kvm_vmx_nested_state_data {
 };
 
 struct kvm_vmx_nested_state_hdr {
-	__u32 flags;
 	__u64 vmxon_pa;
 	__u64 vmcs12_pa;
-	__u64 preemption_timer_deadline;
 
 	struct {
 		__u16 flags;
 	} smm;
+
+	__u32 flags;
+	__u64 preemption_timer_deadline;
 };
 
 struct kvm_svm_nested_state_data {
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b26655104d4a..3fc2411edc92 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6180,7 +6180,8 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 		vmx->nested.has_preemption_timer_deadline = true;
 		vmx->nested.preemption_timer_deadline =
 			kvm_state->hdr.vmx.preemption_timer_deadline;
-	}
+	} else
+		vmx->nested.has_preemption_timer_deadline = false;
 
 	if (nested_vmx_check_controls(vcpu, vmcs12) ||
 	    nested_vmx_check_host_state(vcpu, vmcs12) ||
-- 
2.26.2

