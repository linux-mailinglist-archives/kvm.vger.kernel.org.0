Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3076D44840
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 19:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732246AbfFMRGM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 13:06:12 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52771 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404537AbfFMRED (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 13:04:03 -0400
Received: by mail-wm1-f67.google.com with SMTP id s3so10999425wms.2;
        Thu, 13 Jun 2019 10:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=w6bG0pJ76K9bXtOea02n5IpzqcS7M9AOgHnuTysxzu8=;
        b=tWssK9rY785TD06VtGe9Pjy5hEzYB8vYCR4vdT/SHvmDW8UdX3XI2LvQrW/hcdxFCR
         njoQi0g4Rkj/tBD4Ey9lPEUeDoUCDSiK20+2IcW+Rgva2tt7VDR0eHnk18fyq6oqJRVm
         SqqHnbDlS/2v7uFlYooXRcTTObPl3IAXKSNZvsJV99A4OXG9hhgE/2exyvNwy0zi3Ers
         inBwIFFWv7GFDLR9eMEGd0dV2KoiAmxUV9RMM8OEgGNparzsaBIbUqAc1JjyHWP9kOhH
         FFsN3umXXOyTs/UoM9GXoqdf0jKkAqRQa8SpFIZ6vstWwR55ACUeOUEERDonszIAAQeW
         wC7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=w6bG0pJ76K9bXtOea02n5IpzqcS7M9AOgHnuTysxzu8=;
        b=L+VTjOSu8aqkpGdvfx+kFBO8/n29uU/im7UezCk9di0BuBkaC3b6K3x86Y8ffQ8O0b
         GDt5RGt2uuYOSH7YcBTV+WCc/0lqZLHTEFpbzvZEh1BgDJj6rWwa8Iau57UDDX3SYY4k
         9+LADIg+ABhyG0Z4ZcsfqWE4BjP4+Qg/zjK6//jzA4BvfxTvLqjg65uEYhCGBlw9x0mH
         dEQthKC5PzJxOkecyBq1w1+2wXQyKjXV2uzSxndCb7rpmxXYKvcKFW4twD9XNgs4266c
         Ec04nhDddAVmYrxWfD2+n2L4uvsYjPyQSM0WZmNVKfcxhW2b5bM4YiwCfIfrg05J3ZPu
         P2Ng==
X-Gm-Message-State: APjAAAX/Rhp9TGFz7KC3W8lGEY24x6JuNRDJIxwa3OjTLPsho7ZxNPOy
        FigQducMm0DdgyFZCY4/5OGd1ip2
X-Google-Smtp-Source: APXvYqwwpPLK0ZK8ICO5YzewDN1wtSzywWsI8uUqk+TR385jGDycsCTW0B2xoMG0UjBqzqYwJT9qxw==
X-Received: by 2002:a7b:c5d1:: with SMTP id n17mr4648266wmk.84.1560445441231;
        Thu, 13 Jun 2019 10:04:01 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a10sm341856wrx.17.2019.06.13.10.04.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 10:04:00 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        vkuznets@redhat.com
Subject: [PATCH 28/43] KVM: nVMX: Don't update GUEST_BNDCFGS if it's clean in HV eVMCS
Date:   Thu, 13 Jun 2019 19:03:14 +0200
Message-Id: <1560445409-17363-29-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

L1 is responsible for dirtying GUEST_GRP1 if it writes GUEST_BNDCFGS.

Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 138f27597c91..d5bfe0cbc4fb 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2197,6 +2197,10 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 			vmcs_write64(GUEST_PDPTR2, vmcs12->guest_pdptr2);
 			vmcs_write64(GUEST_PDPTR3, vmcs12->guest_pdptr3);
 		}
+
+		if (kvm_mpx_supported() && vmx->nested.nested_run_pending &&
+		    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
+			vmcs_write64(GUEST_BNDCFGS, vmcs12->guest_bndcfgs);
 	}
 
 	if (nested_cpu_has_xsaves(vmcs12))
@@ -2232,10 +2236,6 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, vmx->msr_autoload.guest.nr);
 
 	set_cr4_guest_host_mask(vmx);
-
-	if (kvm_mpx_supported() && vmx->nested.nested_run_pending &&
-	    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
-		vmcs_write64(GUEST_BNDCFGS, vmcs12->guest_bndcfgs);
 }
 
 /*
-- 
1.8.3.1


