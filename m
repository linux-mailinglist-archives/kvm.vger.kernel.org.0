Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39E1C1B8407
	for <lists+kvm@lfdr.de>; Sat, 25 Apr 2020 09:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbgDYHCU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Apr 2020 03:02:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58543 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726303AbgDYHCH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Apr 2020 03:02:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587798126;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=eX6H79K52YklTNgCmP3prwtALtJImflR75Cxxh6oi+8=;
        b=MsQ7Hmq9vF/0YwCmj5tR1IP0LD/efMvjay177xIpSuRvT8bbrU/tGRarx7m+hk2yPXQ+Bv
        55bEkhh7CHcwW82dvSYPLzs4B0T3tEHZvqF0WjKM9Tthb0klqXWvDRBeQLLIcG+k7N9JCw
        3LpzVQYLvVGqWaTLpJj3KXwyLWYaJy4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-to2DLAhsMW6MYLaVz8JyoA-1; Sat, 25 Apr 2020 03:02:02 -0400
X-MC-Unique: to2DLAhsMW6MYLaVz8JyoA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B8381054F93;
        Sat, 25 Apr 2020 07:02:01 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 50B4A5D9C5;
        Sat, 25 Apr 2020 07:02:00 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     wei.huang2@amd.com, cavery@redhat.com, vkuznets@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH v2 16/22] KVM: nVMX: Prioritize SMI over nested IRQ/NMI
Date:   Sat, 25 Apr 2020 03:01:48 -0400
Message-Id: <20200425070154.251290-7-pbonzini@redhat.com>
In-Reply-To: <20200424172416.243870-1-pbonzini@redhat.com>
References: <20200424172416.243870-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Check for an unblocked SMI in vmx_check_nested_events() so that pending
SMIs are correctly prioritized over IRQs and NMIs when the latter events
will trigger VM-Exit.  This also fixes an issue where an SMI that was
marked pending while processing a nested VM-Enter wouldn't trigger an
immediate exit, i.e. would be incorrectly delayed until L2 happened to
take a VM-Exit.

Fixes: 64d6067057d96 ("KVM: x86: stubs for SMM support")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Message-Id: <20200423022550.15113-10-sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 188ff4cfdbaf..2c36f3f53108 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3750,6 +3750,12 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 		return 0;
 	}
 
+	if (vcpu->arch.smi_pending && !is_smm(vcpu)) {
+		if (block_nested_events)
+			return -EBUSY;
+		goto no_vmexit;
+	}
+
 	if (vcpu->arch.nmi_pending && !vmx_nmi_blocked(vcpu)) {
 		if (block_nested_events)
 			return -EBUSY;
-- 
2.18.2


