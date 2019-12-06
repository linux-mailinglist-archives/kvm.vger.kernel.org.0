Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B949E1159C0
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2019 00:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbfLFXqx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 18:46:53 -0500
Received: from mail-pj1-f73.google.com ([209.85.216.73]:42835 "EHLO
        mail-pj1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbfLFXqw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 18:46:52 -0500
Received: by mail-pj1-f73.google.com with SMTP id s19so4445218pjp.9
        for <kvm@vger.kernel.org>; Fri, 06 Dec 2019 15:46:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ThBm32fZpvVy6KLCvM0Dumk6qX4tmGYO+C0u99pX1vg=;
        b=il3XbSx7gWXfPRoNoZP5MmiYz3V1x5tbTrKh+WJWJEEPVqzTrFmZVZZgGnanlUQyrX
         QSAxH+9+9/d8DNWIU3FTYu4htzwRchY1LgziS1NzLpRCSzDAou3/DRaOMXMfuWFF1LHY
         hiZHjZOSeBE8hPxjoc9aMh0fvBFIVVt+GGYOWutuj5NxC8mdX7kHDTOc05el7T4KCwEB
         iXa8hc4RKiOuDhBdEPs5+GKaHv2abfV1YimvCjBCsfTa7iGqKo95u7tS9qzTTIPdSgPW
         DwOvwEWDS6R7mb1WTcQ1yVb2PAbqjrjnNPDTLYdgms7wiKnBGjkiFClOyLJkufOv55HU
         cyqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ThBm32fZpvVy6KLCvM0Dumk6qX4tmGYO+C0u99pX1vg=;
        b=avar19tsGzu5XVdTNyfdbGDm3J1Sb6tEk9KtiOXOoCUMm8psYWSuHpuQ3wIolomRKI
         cALozrb8YruyolVCYeazWRkpdaEUOinLnCVHpPUNxv5FEWwgqus+P3shG7R1Q2RA1OTY
         94NjAq6RLBqHc2nBHcfWsEv43bGsj453x9PLCzIESS8/pNLlL9xmLnUBIIh6VyZxdSNx
         DNVCfIxbg5rzyvJtsAX3QbLyVF6BmElA+sEjivOotupFnhUYTuoSyN/+ubquZ3sVCAVO
         zLNLLaFH5QuuYPVy7MM8xw9/xi/X/VIsSDJU4kxs9i4q/VeYyXemrHrN6jpISG2dfSzb
         gjKQ==
X-Gm-Message-State: APjAAAUKWxT/XY/2g5lSnQi9ammLKt9pW079GbFj6ifJxzIei/UthSqS
        PxRQHaoFzgwVWavrJsOpaQOkIpecYmtuPGNIEoUk1CQzwulPRcz3UFUQ3IHYKgfYN46fvVR9Z7X
        txOeYtiwR0LsTY+ZpATEvjIhd/+xbQROFIzSIE/MFnB03CixayL0cpzblEO9rNFM=
X-Google-Smtp-Source: APXvYqwxqIoqLTF/uSaniehTN+bNFLNirC9FoDHPkDof0TojVIINDMBZgFSMC+5jCXtbwge1f/3iJWsYMHywnA==
X-Received: by 2002:a63:334f:: with SMTP id z76mr6485745pgz.14.1575676011947;
 Fri, 06 Dec 2019 15:46:51 -0800 (PST)
Date:   Fri,  6 Dec 2019 15:46:36 -0800
In-Reply-To: <20191206234637.237698-1-jmattson@google.com>
Message-Id: <20191206234637.237698-2-jmattson@google.com>
Mime-Version: 1.0
References: <20191206234637.237698-1-jmattson@google.com>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
Subject: [PATCH v3 2/3] kvm: nVMX: VMWRITE checks unsupported field before
 read-only field
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        Jon Cargille <jcargill@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to the SDM, VMWRITE checks to see if the secondary source
operand corresponds to an unsupported VMCS field before it checks to
see if the secondary source operand corresponds to a VM-exit
information field and the processor does not support writing to
VM-exit information fields.

Fixes: 49f705c5324aa ("KVM: nVMX: Implement VMREAD and VMWRITE")
Signed-off-by: Jim Mattson <jmattson@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Peter Shier <pshier@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
Reviewed-by: Jon Cargille <jcargill@google.com>
---
v1 -> v2:
 * New commit in v2.
v2 -> v3:
 * No changes.

 arch/x86/kvm/vmx/nested.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index ee1bf9710e86..94ec089d6d1a 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4883,6 +4883,12 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 
 
 	field = kvm_register_readl(vcpu, (((vmx_instruction_info) >> 28) & 0xf));
+
+	offset = vmcs_field_to_offset(field);
+	if (offset < 0)
+		return nested_vmx_failValid(vcpu,
+			VMXERR_UNSUPPORTED_VMCS_COMPONENT);
+
 	/*
 	 * If the vCPU supports "VMWRITE to any supported field in the
 	 * VMCS," then the "read-only" fields are actually read/write.
@@ -4899,11 +4905,6 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 	if (!is_guest_mode(vcpu) && !is_shadow_field_rw(field))
 		copy_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
 
-	offset = vmcs_field_to_offset(field);
-	if (offset < 0)
-		return nested_vmx_failValid(vcpu,
-			VMXERR_UNSUPPORTED_VMCS_COMPONENT);
-
 	/*
 	 * Some Intel CPUs intentionally drop the reserved bits of the AR byte
 	 * fields on VMWRITE.  Emulate this behavior to ensure consistent KVM
-- 
2.24.0.393.g34dc348eaf-goog

