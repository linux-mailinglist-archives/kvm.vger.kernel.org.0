Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43D76FBCEF
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 01:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbfKNARo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 19:17:44 -0500
Received: from mail-pg1-f202.google.com ([209.85.215.202]:56309 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbfKNARn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 19:17:43 -0500
Received: by mail-pg1-f202.google.com with SMTP id a12so3109343pgl.22
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 16:17:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=r9ABbPLQvpTdNAbSvMBeBdD/m/CKWVMiKZBTu76R2fE=;
        b=bKI31gmhlLeDbHg+DSZdU//6xaRQ1h6AzvIPJSUi6vv99EUEczBPCEmdBKA60Bu4ss
         xKLA/vGeoIpRKnl5LX+K1dezLRB3BxE6Zll4DpZ6Y56HgKIDYZMl0637kj8eXt6gRpmR
         b0KsAXbt6AbufquZjAFMExVzEez+LAGhAPwcOxkW2Hu9I++CNNY/LLAIiIRgmk3y5+c+
         nPalBYaSQXp6jGlIBUvcEELzx60D7w6yY2j6n+nQotsc5OTENUw6rkbzsJh/Anua5RdB
         7IZVfoJ/7UE//5hpr9vWjV1cU48OEJdTds1jpEnhTgB5lDSDR3MEWxFqWLKUEYIsqRyO
         cyMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=r9ABbPLQvpTdNAbSvMBeBdD/m/CKWVMiKZBTu76R2fE=;
        b=L+b7RkH4LZKAFtTarPNitEQYemP8q78Afm0JSN+hJUpafMtw91A3hQvNnLJa9JS/uO
         WyV8yVe/7q6W1PYeq+SUhsHcKLo2buAjTDNj9Li2MLRiVoU/mpVCOIwXVHvB35y3TiQ3
         a/2Jt1v927rckYgX5OQfXqisNKn5yOI5jSOIIs818fIyTJpdr8XYizu8vPgWtVKYFy2+
         x90ysf6N4BHlbexHmlod2HBw7TxGGELUfI5RG08bXtekhFEBfTFQjTD/9JWjB9cAuZNi
         1wP4WbWV+Fi5SX/gbKxRUq4hWDBD/nIgunAvnsV5yQ94qAYBz8KGt9mElz1OTmD793f0
         B9cg==
X-Gm-Message-State: APjAAAUu4LwvPjDvhnWg7xjZ+yuq559FFbJQnlAEpgHS1eHCAUBvNnTT
        2EO37WX+OMs5ozNZLB+AS5yKka50oJSgsmSyyoOtkIhPJ5PuEwaBZxyyl30MA45l5JiQfSy6kcr
        zocl9BQAF5hg8uZPexsfqofR1tSy9+APzDVypMtXQJyYwlHkmlQJvdfVnMA==
X-Google-Smtp-Source: APXvYqyyMTDvv7DIkP69M3lMJr80wo/cYAicteS0zHq7eTrZfatVFTKfOl4jlify/Mk3CbCfvwbM++BAb8w=
X-Received: by 2002:a65:66c5:: with SMTP id c5mr7014645pgw.12.1573690662818;
 Wed, 13 Nov 2019 16:17:42 -0800 (PST)
Date:   Wed, 13 Nov 2019 16:17:19 -0800
In-Reply-To: <20191114001722.173836-1-oupton@google.com>
Message-Id: <20191114001722.173836-6-oupton@google.com>
Mime-Version: 1.0
References: <20191114001722.173836-1-oupton@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH v5 5/8] KVM: nVMX: Load GUEST_IA32_PERF_GLOBAL_CTRL MSR on VM-Entry
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?=" <rkrcmar@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add condition to prepare_vmcs02 which loads IA32_PERF_GLOBAL_CTRL on
VM-entry if the "load IA32_PERF_GLOBAL_CTRL" bit on the VM-entry control
is set. Use SET_MSR_OR_WARN() rather than directly writing to the field
to avoid overwrite by atomic_switch_perf_msrs().

Suggested-by: Jim Mattson <jmattson@google.com>
Co-developed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
---
 arch/x86/kvm/vmx/nested.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index ecdc706f171b..64e15c6f6944 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2441,6 +2441,11 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	if (!enable_ept)
 		vcpu->arch.walk_mmu->inject_page_fault = vmx_inject_page_fault_nested;
 
+	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL) &&
+	    SET_MSR_OR_WARN(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
+			    vmcs12->guest_ia32_perf_global_ctrl))
+		return -EINVAL;
+
 	kvm_rsp_write(vcpu, vmcs12->guest_rsp);
 	kvm_rip_write(vcpu, vmcs12->guest_rip);
 	return 0;
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

