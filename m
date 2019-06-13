Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59D0F4480E
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 19:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393368AbfFMREA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 13:04:00 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34868 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729846AbfFMRD7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 13:03:59 -0400
Received: by mail-wm1-f66.google.com with SMTP id c6so10920609wml.0;
        Thu, 13 Jun 2019 10:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=D05XCB43AmMAGX8K/cm0wW+/Mv9Bi6plTqQUFXXVKiY=;
        b=qpGWPUndyKmPvtXSEH4RDeQ99blFxIdl3O64V0rF0VPD8G5zejQVxIv7WLk6TytzJV
         n7lFtFR3TO3fGm9DPM+FioZuzB14zBJZhIcIkeD75ZwGf7zMKQ6e4VyaRzVQsuETepno
         ud0o+WCFyJRsbh8yKRBXZcYo2iGoGvuEl3jamNdGaatMb43o2QEVvPAz68UMUIbLYwXV
         FcejCrLH6tLhXAwUUDFVbFNWBbohxTqrbgM6VFYKV+H5nS/zL2VjpLi/XNBCXi93JczL
         EEnzV9fWDpUNa91ev7dM1laSnEtfwO5yKOXUYfofjXQoR76JPUBSEnsIGYaSzkb+K9DF
         P45w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=D05XCB43AmMAGX8K/cm0wW+/Mv9Bi6plTqQUFXXVKiY=;
        b=L3dTkwGCwRfPtrRz/RWZjItUxuKi8yA1UObx4SWGk2PYnlBRRovLFsHt1lvWF7dRjw
         cHwERdQ6TMg10Si12Vzipn5nwFIigJaZLoDa0sn8WfV2x3AIoet/Mhy8S30/mlUat7fT
         xtmhVhBWb2OIIf938OHU6NM1pHjU7VdRQu0YKQFNQCNPPuNRtGpZ0hLTb7Y6+jHUQe/H
         HgcH60KSltF98zqgLAORku5UVmUaWR+JSztAufp9zaZQt3omDl9xUQi9BHVqaCrCj/kK
         eeUp0S6h1/O2ouNm0hYq+8AOnOWuvqWdIs+eg2RG+81dNGfx9n0de8LjyncsXEajGIgk
         jvhQ==
X-Gm-Message-State: APjAAAWoIRVEP9IP41Z6W4l7ufF3H3SgWEmFmAElCZG/pea+zkvs8tT2
        co3TTGsa+GzIGb09ODNIIKQfsOaH
X-Google-Smtp-Source: APXvYqzn0sInf/hCOc7CkPqlmBS4yW6ksuDcQPWAl0+a+pPKiW7+pQuZy8un6U+5y3OVX1IshILoMw==
X-Received: by 2002:a1c:99c6:: with SMTP id b189mr4701844wme.57.1560445437762;
        Thu, 13 Jun 2019 10:03:57 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a10sm341856wrx.17.2019.06.13.10.03.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 10:03:57 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        vkuznets@redhat.com
Subject: [PATCH 24/43] KVM: nVMX: Don't speculatively write APIC-access page address
Date:   Thu, 13 Jun 2019 19:03:10 +0200
Message-Id: <1560445409-17363-25-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

If nested_get_vmcs12_pages() fails to map L1's APIC_ACCESS_ADDR into
L2, then it disables SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES in vmcs02.
In other words, the APIC_ACCESS_ADDR in vmcs02 is guaranteed to be
written with the correct value before being consumed by hardware, drop
the unneessary VMWRITE.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index d055bbc5cbde..a012118e6c8c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2083,14 +2083,6 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 			vmcs_write16(GUEST_INTR_STATUS,
 				vmcs12->guest_intr_status);
 
-		/*
-		 * Write an illegal value to APIC_ACCESS_ADDR. Later,
-		 * nested_get_vmcs12_pages will either fix it up or
-		 * remove the VM execution control.
-		 */
-		if (exec_control & SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES)
-			vmcs_write64(APIC_ACCESS_ADDR, -1ull);
-
 		vmcs_write32(SECONDARY_VM_EXEC_CONTROL, exec_control);
 	}
 
-- 
1.8.3.1


