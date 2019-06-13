Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 817234488A
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 19:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393214AbfFMRI0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 13:08:26 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40924 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729728AbfFMRDx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 13:03:53 -0400
Received: by mail-wm1-f66.google.com with SMTP id v19so10887170wmj.5;
        Thu, 13 Jun 2019 10:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ePv84bl3LONQijVs8R1uvqK3iY+gH1mMWEz3/sRHNh4=;
        b=iG+jB85IqiXtij8iEpdwh2V+oesMsHGhbgK14yUbaqF6wx3NosHX1fOFHGp2IeL0DN
         It6wkkhKa/eJLYq1dKPQiQGsJO3BzUOvfvNbXGiJWft/TphMxJDtURXseifwmD1cvFdJ
         8S9wxVRhpdvytylc00Gpm7ywrLpMk+RIH/qtXzbXXgXK/HyLWX5Tbji6a1MkUj+Ryplo
         8mrkHNGl05s2WZ0+lkbnP8euyIgrEVEJsLVhSQINWFFINhkAURkHRpZPwLCABkeRAvvZ
         Ome8dtrL/QIN/G7uBG57HIsAujp29FNm2c59Me1fCFmBsrvBp3GksQ7kXq0qBBD+iPN7
         lzNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=ePv84bl3LONQijVs8R1uvqK3iY+gH1mMWEz3/sRHNh4=;
        b=SoK7BhPS61aOzBVVL3V6RaTZlRrNoPjMXIQxetAdMACbe+LSEK0oD2ckbslCY/HEqi
         +QDcFtEzw8kMCjDxszok3CO3wtWhdl5hltSnLQdWYEuH0lyaXJ5WuLewC5FvQqTMk8Yf
         kGxO6zLDsXehKf/GZ8EMcCY1nag7K1EQ7/Y+siZu59AbnI/Vs3SQ2rvQ6i0LUApkThw7
         T8WmD9mqfe3TaDu71837a6OiqAdzWxrlR7lrHVoYJdbceyl2Aa3oHMkORMe0sSfWrGEH
         f8Q5P5LGFDyDxWAZ1peludugTiomEiwtciFGExPmqUItOGmqKvUJiGyDbXZrkwrGkEbD
         BXpQ==
X-Gm-Message-State: APjAAAVQpUacbJz9gk47Fa/VVECv94/N7JjdZ8UXwbgYIw20SfvMJwfI
        4FEAyr0rMuK97jbKHIMHx/jC1VXn
X-Google-Smtp-Source: APXvYqzqCUPESyKwv5Pnv2qSpaLUg9Xw9KxBR66l9YtqfS5C2p4xhOBYcDDC8jNQ99F14YveLCnEUw==
X-Received: by 2002:a1c:be0a:: with SMTP id o10mr4530228wmf.91.1560445431583;
        Thu, 13 Jun 2019 10:03:51 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a10sm341856wrx.17.2019.06.13.10.03.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 10:03:51 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        vkuznets@redhat.com
Subject: [PATCH 17/43] KVM: nVMX: Write ENCLS-exiting bitmap once per vmcs02
Date:   Thu, 13 Jun 2019 19:03:03 +0200
Message-Id: <1560445409-17363-18-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

KVM doesn't yet support SGX virtualization, i.e. writes a constant value
to ENCLS_EXITING_BITMAP so that it can intercept ENCLS and inject a #UD.

Fixes: 0b665d3040281 ("KVM: vmx: Inject #UD for SGX ENCLS instruction in guest")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f2be64256f15..fee297a5edda 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1943,6 +1943,9 @@ static void prepare_vmcs02_constant_state(struct vcpu_vmx *vmx)
 	if (enable_pml)
 		vmcs_write64(PML_ADDRESS, page_to_phys(vmx->pml_pg));
 
+	if (cpu_has_vmx_encls_vmexit())
+		vmcs_write64(ENCLS_EXITING_BITMAP, -1ull);
+
 	/*
 	 * Set the MSR load/store lists to match L0's settings.  Only the
 	 * addresses are constant (for vmcs02), the counts can change based
@@ -2065,9 +2068,6 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 		if (exec_control & SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES)
 			vmcs_write64(APIC_ACCESS_ADDR, -1ull);
 
-		if (exec_control & SECONDARY_EXEC_ENCLS_EXITING)
-			vmcs_write64(ENCLS_EXITING_BITMAP, -1ull);
-
 		vmcs_write32(SECONDARY_VM_EXEC_CONTROL, exec_control);
 	}
 
-- 
1.8.3.1


