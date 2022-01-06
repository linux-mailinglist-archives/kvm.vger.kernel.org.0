Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B544486427
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 13:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238347AbiAFMNn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 07:13:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232358AbiAFMNn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 07:13:43 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1AE8C061245;
        Thu,  6 Jan 2022 04:13:42 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id i30so2418320pgl.0;
        Thu, 06 Jan 2022 04:13:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=n9CcsNCWBTa4xdrApzau9Q0lOnY7SOIkREDarH9emtg=;
        b=oTLMa6RROOhPwA0ore16aFe09DXejIGtJ6t4rvBKx+1UdbxQ/kCyYi7G7YYp77GsAD
         xC1g58gdgkyEk25f5JJs+bc0Q+a/PtSTZeDAsn54Ej5jBu/Hc2lHmgp9Ln2To0NG4LH/
         2RVe50Mjujt4wKy7zdBh2TOjlybIjjz1UFiu0PB+OU1qsvvk9r8NeFQM0HZmL+ActfcF
         gZpEf+ouYMLLxOKl/p8EV8urUKmWkWOUlGZOoDg+xZidc+5ASPyaOEYOTZihfrJuXs/v
         Daz11b67MLZxquYfDKR/z1lfgN9lNarmkh+CHg5UoyxgaaDF4s5RJumaa0EmME+7HusJ
         Gtog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=n9CcsNCWBTa4xdrApzau9Q0lOnY7SOIkREDarH9emtg=;
        b=XkaP2bSII6qUpb+hsjPwwepIj6MaherIPm1HmeniPrxHb9TkD2MexUgSVDdyGjMMlI
         JAglj4k7zICqorx06pfmB0DJRm1+jQYAa4nl9GfHpvPs0z8K/z3hjms7xNe6PBoZhSth
         Jp6p1JBh24ofBXIQ36JZKAd8M8eNGXJgMTfcN6hvI9Pd/KDf/JOeUG5K7rXYmXI06wEA
         jIFg9a46vWB7WcNxTUSNvDseVkeEwHuDTddh/JJZxBM0xpeuhvv8VbZXyc6Y1cfdBnU2
         MJJO+jvAzZTfXX0MqmRfKwiiQsekcRl/nsth+wRXlAxBA8JTE+fM7CIEpDKTNfPI3lm2
         k7GA==
X-Gm-Message-State: AOAM531jUS1vXc4CKWbFimkUpwNi5KQaGixtaSZoM8xSrOCKZ87iKyGl
        GuG/CwViOu54p5Jpwv2AzTyeCleme8mqsA==
X-Google-Smtp-Source: ABdhPJxE6ewu2Qs+deoXVSNGSXzMb9lf4oRl9MEqGqEmzwBFMfHSxO+XB16ozHocCUNXGX4CAOxW2w==
X-Received: by 2002:a05:6a00:2286:b0:4bb:3358:7ea0 with SMTP id f6-20020a056a00228600b004bb33587ea0mr59719126pfe.35.1641471222212;
        Thu, 06 Jan 2022 04:13:42 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.112])
        by smtp.googlemail.com with ESMTPSA id b19sm1952983pgk.44.2022.01.06.04.13.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jan 2022 04:13:41 -0800 (PST)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH] KVM: VMX: Dont' deliver posted IRQ if vCPU == this vCPU and vCPU is IN_GUEST_MODE
Date:   Thu,  6 Jan 2022 04:12:51 -0800
Message-Id: <1641471171-34232-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Commit fdba608f15e2 (KVM: VMX: Wake vCPU when delivering posted IRQ even 
if vCPU == this vCPU) fixes wakeup event is missing when it is not from 
synchronous kvm context by dropping vcpu == running_vcpu checking completely.
However, it will break the original goal to optimise timer fastpath, let's 
move the checking under vCPU is IN_GUEST_MODE to restore the performance.

Suggested-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/vmx/vmx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fe06b02..71e8afc 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3932,7 +3932,8 @@ static inline void kvm_vcpu_trigger_posted_interrupt(struct kvm_vcpu *vcpu,
 		 * which has no effect is safe here.
 		 */
 
-		apic->send_IPI_mask(get_cpu_mask(vcpu->cpu), pi_vec);
+		if (vcpu != kvm_get_running_vcpu())
+			apic->send_IPI_mask(get_cpu_mask(vcpu->cpu), pi_vec);
 		return;
 	}
 #endif
-- 
2.7.4

