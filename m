Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D87834481D
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 19:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404684AbfFMREP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 13:04:15 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46192 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404666AbfFMREO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 13:04:14 -0400
Received: by mail-wr1-f66.google.com with SMTP id n4so21537613wrw.13;
        Thu, 13 Jun 2019 10:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=falAqpBCvs4GQzGRRi3ubvRYt1F+L9WaFtV97+WAQU0=;
        b=HZM8dRqdW1ZqtCd0d9Ya6Vh8MNY1VhCT37XqG7om/qn+W0qdjOr66vSsTakEqpl+p8
         CPUQf6+YERIqy+5gTJFaQnWCFq3au/lvCPAKHbNvRlgFMpnlQIbKjaPPQSjoNYTqNoqm
         AVsWiOPKLBhoHowNyhKazNC+Nbby3J49SBOgBoZgD+Ht3FV5RHMUZoog8DEfILp/vbvv
         7IaJJnhyusNU4KbNQ5VcAUozgzw/FCmF8SlPlV7TN+NfZBg+2DDZUZVPYkEHtlGM2l4S
         dnTGSyfv4hBBcL3zW82hnpVL9hCmiPnPln1hvrXIjZUbrJtrl12tGNi3/ZXFvjmcTDtr
         BxHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=falAqpBCvs4GQzGRRi3ubvRYt1F+L9WaFtV97+WAQU0=;
        b=KiXDU7/ow9dk8DP5o8E77kXXL/QTWv4b5lEJGxHfY72v9XpZ0Q+j1O7idPlCnNkqXX
         RLph+K4RoJCtXQY0HQuPkl+hWmKwBUy3eod6aC+1qZdAttOfycduqHmm4ogT8BfFI7ms
         87AJpYH3/GpjZ/Kye9Jqp7k1Z2c0iPmV3uTlRmILlf6MATemTsOZFtX7hr4pQ3zVX2/b
         UH2KAOkoMFugQBLyBgT3OsFwe1LbCp4KUrjLTa0IohJnLu+DDD8ApcyY2AyVrJj1pGWM
         3azRY2S/RedmqfW9kzMYzF0+ovcwz3RpBnWYv8CZLvFfsxX9Ftc4sy5PwvrgYTNnrqWq
         iIYg==
X-Gm-Message-State: APjAAAWnCM0EP4sSRjLoGaChqXfGsC8Oei+bQfS2O9RGG31jqAa8u0Nh
        bu+MOqukV0zPPrAOcXNzjWuB/lRz
X-Google-Smtp-Source: APXvYqwL8ZuL81zRw5ZJKMOA3ZlAsnbWgm5x85Wj5w81JRdtsllO0LHL7CD+GBnli1GxuKaekFyAvQ==
X-Received: by 2002:adf:ce03:: with SMTP id p3mr33869433wrn.94.1560445452682;
        Thu, 13 Jun 2019 10:04:12 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a10sm341856wrx.17.2019.06.13.10.04.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 10:04:12 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        vkuznets@redhat.com
Subject: [PATCH 40/43] KVM: nVMX: Preset *DT exiting in vmcs02 when emulating UMIP
Date:   Thu, 13 Jun 2019 19:03:26 +0200
Message-Id: <1560445409-17363-41-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

KVM dynamically toggles SECONDARY_EXEC_DESC to intercept (a subset of)
instructions that are subject to User-Mode Instruction Prevention, i.e.
VMCS.SECONDARY_EXEC_DESC == CR4.UMIP when emulating UMIP.  Preset the
VMCS control when preparing vmcs02 to avoid unnecessarily VMWRITEs,
e.g. KVM will clear VMCS.SECONDARY_EXEC_DESC in prepare_vmcs02_early()
and then set it in vmx_set_cr4().

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 14a8cfade50f..598540ce0f52 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2085,6 +2085,14 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 		/* VMCS shadowing for L2 is emulated for now */
 		exec_control &= ~SECONDARY_EXEC_SHADOW_VMCS;
 
+		/*
+		 * Preset *DT exiting when emulating UMIP, so that vmx_set_cr4()
+		 * will not have to rewrite the controls just for this bit.
+		 */
+		if (!boot_cpu_has(X86_FEATURE_UMIP) && vmx_umip_emulated() &&
+		    (vmcs12->guest_cr4 & X86_CR4_UMIP))
+			exec_control |= SECONDARY_EXEC_DESC;
+
 		if (exec_control & SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY)
 			vmcs_write16(GUEST_INTR_STATUS,
 				vmcs12->guest_intr_status);
-- 
1.8.3.1


