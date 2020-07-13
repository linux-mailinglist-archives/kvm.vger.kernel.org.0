Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E212B21A5D2
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 19:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbgGIR2G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 13:28:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52720 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726758AbgGIR2G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jul 2020 13:28:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594315685;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=GfadFP0vLdHdZ4FwpCfHglgC68S6cIQIOSckhJEfNgY=;
        b=bscbuXmLi5cOdh2umI/+VRfpmr3m/zw8iLlklYNuATHw69nZpGWeJ/KxXa5RBhnls7oao9
        cFpj5Kj7/IUowM6mBJ984WnIU1XpjiiHUggicicZxQonAHQVZgnIkddUWPEyswgaXOx7sG
        xEXBBQZqKTIifEOVEa+8VCsqReNTbJc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-254-ZW040yRZNMCJDXcieKH_eQ-1; Thu, 09 Jul 2020 13:28:03 -0400
X-MC-Unique: ZW040yRZNMCJDXcieKH_eQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 354DF1081;
        Thu,  9 Jul 2020 17:28:02 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CB6477F8C2;
        Thu,  9 Jul 2020 17:28:01 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Makarand Sonare <makarandsonare@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH v2] KVM: nVMX: fixes for preemption timer migration
Date:   Thu,  9 Jul 2020 13:28:01 -0400
Message-Id: <20200709172801.2697-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
v1->v2: coding style [Jim]

 arch/x86/include/uapi/asm/kvm.h | 5 +++--
 arch/x86/kvm/vmx/nested.c       | 1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

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
index b26655104d4a..d4a4cec034d0 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6176,6 +6176,7 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 			goto error_guest_mode;
 	}
 
+	vmx->nested.has_preemption_timer_deadline = false;
 	if (kvm_state->hdr.vmx.flags & KVM_STATE_VMX_PREEMPTION_TIMER_DEADLINE) {
 		vmx->nested.has_preemption_timer_deadline = true;
 		vmx->nested.preemption_timer_deadline =
-- 
2.26.2

