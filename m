Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1D0E44806
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 19:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404419AbfFMRDq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 13:03:46 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38146 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393300AbfFMRDo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 13:03:44 -0400
Received: by mail-wm1-f66.google.com with SMTP id s15so10903963wmj.3;
        Thu, 13 Jun 2019 10:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=V8BJHL7Q+mh0xFfqaBxLJCVQXPvBEVTr2C45cHaGtrU=;
        b=UuDwTwQF/KPNHfbocSdfae0HFtTsp3YzqOTlY4iWxv0VeLE8if//rkPi8z8FQQejmz
         3TeobjTo4tbOYH3UirfMsCemcaBe3GnAMLzB1D84pA7h2cIBOFpwb+amw2y3ev3iPTlo
         Pjl0RdxYt+jbkzj033NQ8U6B4DpOIFoX+RfOLsUo6OlqYtEKwcAN1nrx+DkbUPleua4V
         2TqWw4VDbvVJgmNX791s6ljtUGQk1m/CjQNsd2gdwGm2FL27PhP0+9PmUgO0niQDy1LJ
         3XhD8G+AxC/IeMEM/naIBXgH50uo7V1g5jJ64kv6+rxcCQlB/m5OwIdrK+HM2jearv4a
         sAQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=V8BJHL7Q+mh0xFfqaBxLJCVQXPvBEVTr2C45cHaGtrU=;
        b=AY4njgkaRfQhphsA7cOzFVpQeuRz7NKKt6PlBv6PJLVsL80WlYzQ9pVKTIB2NB9DpY
         rX2uYXFzW2wa5NjxbB+Co7YrkIRAH1SXtdw41RMlOXdz2V26tYStwRr475DGV1x8khGv
         CR1rls+zUGxP1cgaQpoPTNnCE4X+I3hKdJzJjRzRwPr5xx4Ls1yB5FapuJ5DQAxPfENv
         UP8whr7Fe9zX4EQMEQJ4wpqp89g/cGQ+6hnkQRUUbxZYBUb7wQ7xQHtax1xm1i/vuw04
         qn8QUpDw5RKx0tQOcJymWPt55e54UvZSvaOimXnNhOTSc8r1LRRWzrEEm35YAXDB5D6l
         vUlA==
X-Gm-Message-State: APjAAAX7oBG7jrxR21CgYqgGAJ8fmfwt56SwWeMWJ9UbzvR+GoiG3kfQ
        pI6AXJIQAyqeDpE8LbZale2utln1
X-Google-Smtp-Source: APXvYqzFDXlxqpFC4bXVrKED8uUQNNU4juFoxe+7KQWvaFVvHt2FmfiLq6x6fY5DEas74oby3fjhWg==
X-Received: by 2002:a1c:c011:: with SMTP id q17mr4668004wmf.105.1560445421536;
        Thu, 13 Jun 2019 10:03:41 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a10sm341856wrx.17.2019.06.13.10.03.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 10:03:39 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        vkuznets@redhat.com
Subject: [PATCH 10/43] KVM: nVMX: Lift sync_vmcs12() out of prepare_vmcs12()
Date:   Thu, 13 Jun 2019 19:02:56 +0200
Message-Id: <1560445409-17363-11-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

... to make it more obvious that sync_vmcs12() is invoked on all nested
VM-Exits, e.g. hiding sync_vmcs12() in prepare_vmcs12() makes it appear
that guest state is NOT propagated to vmcs12 for a normal VM-Exit.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 376fd9eabe42..bdaf49d9260f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3500,11 +3500,7 @@ static void prepare_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 			   u32 exit_reason, u32 exit_intr_info,
 			   unsigned long exit_qualification)
 {
-	/* update guest state fields: */
-	sync_vmcs12(vcpu, vmcs12);
-
 	/* update exit information fields: */
-
 	vmcs12->vm_exit_reason = exit_reason;
 	vmcs12->exit_qualification = exit_qualification;
 	vmcs12->vm_exit_intr_info = exit_intr_info;
@@ -3865,9 +3861,9 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
 		vcpu->arch.tsc_offset -= vmcs12->tsc_offset;
 
 	if (likely(!vmx->fail)) {
-		if (exit_reason == -1)
-			sync_vmcs12(vcpu, vmcs12);
-		else
+		sync_vmcs12(vcpu, vmcs12);
+
+		if (exit_reason != -1)
 			prepare_vmcs12(vcpu, vmcs12, exit_reason, exit_intr_info,
 				       exit_qualification);
 
-- 
1.8.3.1


