Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED922A825D
	for <lists+kvm@lfdr.de>; Thu,  5 Nov 2020 16:40:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731085AbgKEPkA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 10:40:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730721AbgKEPkA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Nov 2020 10:40:00 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E28C0613CF
        for <kvm@vger.kernel.org>; Thu,  5 Nov 2020 07:40:00 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id o23so2283955ejn.11
        for <kvm@vger.kernel.org>; Thu, 05 Nov 2020 07:40:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hKzXJuXdj/IoLTP+CpsVrEpWzHcfkNGl+YuHY/1Jvy8=;
        b=pjFQ8QiKJOgrwd2cGiIgLgb7mKVC4OxzunOl0Td8civHy1WMCLaDKZgcArKbUIgyEq
         2blMgWhVzGurwP4KsFwvigsa3q4P5wiM38UvIYBvDP6qs8l2mL47CO8lU3kyKNpDAusP
         4s3/MDTC9QUSUXgH25awNDYmqphXZIgNY+jjn8ns04KWR9ny25hEufvSV2coP7/Z5ARS
         zHwsYtODerieUgbuLuyAlKQoq4JnGIogMVKP99k0GM7BtOVfrLSdi1uT1ZuOHSGLDt0E
         Sxbf5VDlxNSFiT/FWr282NvSn8uToFhlnDqoC1CbZGa+ia8EgiC9nxeITNVCTK4aALAQ
         22YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hKzXJuXdj/IoLTP+CpsVrEpWzHcfkNGl+YuHY/1Jvy8=;
        b=PYdJ9muhmYgeLAkQ0jPL/CLeOmiFgz8IWTHXwRwo1SbUZeahch/t7alod9hC4STZPj
         6hpITqykJL7BMOZCAkrDOyyo8MTJbtUFTmfRE507broeyX5uhA6yGrj/Vqeyc2V1/pkw
         ojzYw+fs+i4q/V9ETy5GijyHnU4zZ66oGsetWfH+srQa5qjaXJOim3ng/jZY1yvvPXxP
         F3bq+rbCcOzoyfg1evrl1fr/nSyNdUPuYLwnUFRfg8a5lxLfy559f6MN7GOg/XklzVgy
         AV8l9w2jR8gsJPC0E2csvzoRTkF9EmV8K7Q8b9+AbyYv4evUfuWzBOOtqF4Gg5nupJdO
         gS8A==
X-Gm-Message-State: AOAM530c7jwMWBGj5ro5rKagq/5K001eUGjO5u/EUUFzoxxi641cA7nh
        Cf7JJ8i3vYGGctsMDtn0pHwXVnLJZZk=
X-Google-Smtp-Source: ABdhPJzyYoNJCSijbfTrV9Ypx3/c3I2yCSGAIGH0RUSZRyXg5DUh6CAuqE22gsP2e/abE+4p9DsVtA==
X-Received: by 2002:a17:906:7698:: with SMTP id o24mr2780041ejm.447.1604590798680;
        Thu, 05 Nov 2020 07:39:58 -0800 (PST)
Received: from lb01399.pb.local (p200300ca5719ac40c98ae5b6a31510db.dip0.t-ipconnect.de. [2003:ca:5719:ac40:c98a:e5b6:a315:10db])
        by smtp.gmail.com with ESMTPSA id b8sm1106481edv.20.2020.11.05.07.39.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 07:39:58 -0800 (PST)
From:   Pankaj Gupta <pankaj.gupta.linux@gmail.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        tglx@linutronix.de, oro@8bytes.org, mingo@redhat.com, bp@alien8.de,
        x86@kernel.org, hpa@zytor.com, pankaj.gupta.linux@gmail.com,
        Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
Subject: [PATCH] KVM: x86: handle MSR_IA32_DEBUGCTLMSR with report_ignored_msrs
Date:   Thu,  5 Nov 2020 16:39:32 +0100
Message-Id: <20201105153932.24316-1-pankaj.gupta.linux@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Pankaj Gupta <pankaj.gupta@cloud.ionos.com>

 Guest tries to enable LBR (last branch/interrupt/exception) repeatedly,
 thus spamming the host kernel logs. As MSR_IA32_DEBUGCTLMSR is not emulated by
 KVM, its better to add the error log only with "report_ignored_msrs".
 
Signed-off-by: Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
---
 arch/x86/kvm/x86.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f5ede41bf9e6..99c69ae43c69 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3063,9 +3063,9 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			/* Values other than LBR and BTF are vendor-specific,
 			   thus reserved and should throw a #GP */
 			return 1;
-		}
-		vcpu_unimpl(vcpu, "%s: MSR_IA32_DEBUGCTLMSR 0x%llx, nop\n",
-			    __func__, data);
+		} else if (report_ignored_msrs)
+			vcpu_unimpl(vcpu, "%s: MSR_IA32_DEBUGCTLMSR 0x%llx, nop\n",
+				    __func__, data);
 		break;
 	case 0x200 ... 0x2ff:
 		return kvm_mtrr_set_msr(vcpu, msr, data);
-- 
2.20.1

