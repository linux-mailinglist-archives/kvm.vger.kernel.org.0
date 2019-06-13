Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B73854481F
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 19:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404726AbfFMRES (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 13:04:18 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34918 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732657AbfFMRER (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 13:04:17 -0400
Received: by mail-wm1-f68.google.com with SMTP id c6so10921676wml.0;
        Thu, 13 Jun 2019 10:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=w2YvRin0khft70/HQkufh77cwGHzqtMRSykd+mBeVCQ=;
        b=g0/oQJsu0HiNM3pzjMAX7Ncl32l44dSFd3BKII/9rbhvbMHJFehjI0alIdOutkE9Jj
         Rv5CauhjQGF6Awnix2AvWfhOSUM3ooJ04fp66s1RhqpK5yhDLvpyaRLJ2tVxpfu7Kelo
         wrHQRfxkgtUta/XtLwIBnq3ZjZr+i0bfU4G059Sysc/4/0P5bOevglHP7q07S53XeuaB
         sJugrjBrcuRIcBO26uL0E02IFQBFtv+h15IO6iJziN0+BLYlgrKZMeyAYqVAja+0DqWr
         LIeg5NWRAgDFrB7pLwbQqk4rHa+se1/jCExE2/OQyqPXgXmycOmtws2ivESGgoNtWJW7
         ABGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=w2YvRin0khft70/HQkufh77cwGHzqtMRSykd+mBeVCQ=;
        b=XQgIFMnY7pyNmDuSEq8Nz0larN60ZwkqLcbTgqZm4LjxmYHlJpPwiqva0vThtNkRp+
         /IFdVsFbEpiW3BXj00E70P2RTfScYm42cAd48EsHF6pSU4VOIUD8KONv8QKr107a3YR+
         g5z6ssU4d7hUfdUdYlab5/UfIO8se93UKYFk5p6nWn0i10t48IkcLZ5H4Mgn7UL4jBb1
         rLIm/uGx6ygLRkffB4pGBj0bP0SaWJQGWRgDtSveN2LEjoypMmbVf0vnPShaN/+G1HUC
         OQ7hqTESrJxG2xlKA+FupOgW2UR7h9tg2eAOfRDP2yfNB9AQlEUrdVpkqyhTh6Wd3rcY
         WE6A==
X-Gm-Message-State: APjAAAXXffgMR5otsGrQ2H0GwBhG60P1H+XnUemre+8VX30xXB0CQGQP
        mBCmC/H5ySM27eqd8H+AFiJN7KC8
X-Google-Smtp-Source: APXvYqzIoPIJYVmxr0OxCqDzPCOX/Uq5rOqQsi6JQPJTUCi1PcDr0F/NU/r/FIG4Xnm0P66EYC9fYw==
X-Received: by 2002:a1c:f916:: with SMTP id x22mr4790174wmh.81.1560445455471;
        Thu, 13 Jun 2019 10:04:15 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a10sm341856wrx.17.2019.06.13.10.04.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 10:04:14 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        vkuznets@redhat.com
Subject: [PATCH 43/43] KVM: nVMX: shadow pin based execution controls
Date:   Thu, 13 Jun 2019 19:03:29 +0200
Message-Id: <1560445409-17363-44-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The VMX_PREEMPTION_TIMER flag may be toggled frequently, though not
*very* frequently.  Since it does not affect KVM's dirty logic, e.g.
the preemption timer value is loaded from vmcs12 even if vmcs12 is
"clean", there is no need to mark vmcs12 dirty when L1 writes pin
controls, and shadowing the field achieves that.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/vmcs_shadow_fields.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/vmx/vmcs_shadow_fields.h b/arch/x86/kvm/vmx/vmcs_shadow_fields.h
index 4cea018ba285..eb1ecd16fd22 100644
--- a/arch/x86/kvm/vmx/vmcs_shadow_fields.h
+++ b/arch/x86/kvm/vmx/vmcs_shadow_fields.h
@@ -47,6 +47,7 @@
 SHADOW_FIELD_RO(GUEST_CS_AR_BYTES, guest_cs_ar_bytes)
 SHADOW_FIELD_RO(GUEST_SS_AR_BYTES, guest_ss_ar_bytes)
 SHADOW_FIELD_RW(CPU_BASED_VM_EXEC_CONTROL, cpu_based_vm_exec_control)
+SHADOW_FIELD_RW(PIN_BASED_VM_EXEC_CONTROL, pin_based_vm_exec_control)
 SHADOW_FIELD_RW(EXCEPTION_BITMAP, exception_bitmap)
 SHADOW_FIELD_RW(VM_ENTRY_EXCEPTION_ERROR_CODE, vm_entry_exception_error_code)
 SHADOW_FIELD_RW(VM_ENTRY_INTR_INFO_FIELD, vm_entry_intr_info_field)
-- 
1.8.3.1

