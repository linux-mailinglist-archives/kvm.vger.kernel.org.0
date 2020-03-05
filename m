Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A29517A2E7
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 11:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbgCEKNz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 05:13:55 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45595 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbgCEKNy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 05:13:54 -0500
Received: by mail-wr1-f68.google.com with SMTP id v2so6233311wrp.12;
        Thu, 05 Mar 2020 02:13:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=N8hO5OsCpxWuOROH3axUS5MYcS8LdG5MKkBcvb8lPiI=;
        b=k7VCsKw36KHwV++K8F4b0/Ji76zJCnV+jm7l6g7L9fch4EzkCd0ZmEZKIxW/5LxowI
         r9TYDLVpBcHcNM3xoHfCHMWaAB1ylrVOZ4wrrtLToqQYWDVzubYWqM14kePDG4F/j9sy
         LJgA0n5tLzcvKZGNtTpnmw4F6bEyMaqus/IpJh6lNVyQHgSDKZj1NyG2uHhXlprIOzgB
         TY61lVEP6KoT7oKBgbq6qbIM8fLGZSAwQ2Z56BrWAY1vEav4BiBzmMEXkZ0MbWSV0w7Z
         ei+Y0KwbJ/jAuB2XwzDzHkrdo8S8JK7Dawv1uca/0m87PZgx1xls6hq+2h726WB47mun
         Py/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=N8hO5OsCpxWuOROH3axUS5MYcS8LdG5MKkBcvb8lPiI=;
        b=qfcW6+kDj/w9cWSCn0DVrvsOOuyzYxISFlYCZUliCftkFKVEDEdFgAHTdRkvadxgOP
         Q2frFncXUWJHaTtUrOEKcfYsHPssa4iwYzt/DmV6X9/vJJcYoxY1eb9ihy6Ao/S3gqyu
         18Y2sCpv6H/f2bGLfJVqkxLgCIsarXXLZBVvU1fQ3rMT0+h90qzN4ilBvIPoYlPuMU6k
         uB5odjVYHafES/8fLhSjMTzizVtnTz8eTDRpX77ZMaujoiAoHKuFRzPirGACzCIG8Lsj
         4kJ+5LE2fhr8NwHffNSSlsWwfsXHVabuUiPX6XqhiLfSiuGWWljwIQ6FbkIVypEc+Gig
         kIYw==
X-Gm-Message-State: ANhLgQ1H9mZJcFs8fAQ4sXC+/reTouRVDM0ZoufgPLVxHzJMGNIKeDhe
        kIb0wQ3N7wF01NbOT5/cDfRuqlrp
X-Google-Smtp-Source: ADFU+vu1GR7uwsHOWLQOZhzN5rk63Bcdi98Dk/283VeBS36I6xrBrZLZ4VLn8guP/UUC8RmFGJ94zA==
X-Received: by 2002:adf:a50b:: with SMTP id i11mr10151797wrb.60.1583403231224;
        Thu, 05 Mar 2020 02:13:51 -0800 (PST)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id p15sm8331066wma.40.2020.03.05.02.13.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Mar 2020 02:13:50 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     cavery@redhat.com, vkuznets@redhat.com, jan.kiszka@siemens.com,
        wei.huang2@amd.com
Subject: [PATCH 1/4] KVM: nSVM: do not change host intercepts while nested VM is running
Date:   Thu,  5 Mar 2020 11:13:44 +0100
Message-Id: <1583403227-11432-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1583403227-11432-1-git-send-email-pbonzini@redhat.com>
References: <1583403227-11432-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instead of touching the host intercepts so that the bitwise OR in
recalc_intercepts just works, mask away uninteresting intercepts
directly in recalc_intercepts.

This is cleaner and keeps the logic in one place even for intercepts
that can change even while L2 is running.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 247e31d21b96..14cb5c194008 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -519,10 +519,24 @@ static void recalc_intercepts(struct vcpu_svm *svm)
 	h = &svm->nested.hsave->control;
 	g = &svm->nested;
 
-	c->intercept_cr = h->intercept_cr | g->intercept_cr;
-	c->intercept_dr = h->intercept_dr | g->intercept_dr;
-	c->intercept_exceptions = h->intercept_exceptions | g->intercept_exceptions;
-	c->intercept = h->intercept | g->intercept;
+	c->intercept_cr = h->intercept_cr;
+	c->intercept_dr = h->intercept_dr;
+	c->intercept_exceptions = h->intercept_exceptions;
+	c->intercept = h->intercept;
+
+	if (svm->vcpu.arch.hflags & HF_VINTR_MASK) {
+		/* We only want the cr8 intercept bits of L1 */
+		c->intercept_cr &= ~(1U << INTERCEPT_CR8_READ);
+		c->intercept_cr &= ~(1U << INTERCEPT_CR8_WRITE);
+	}
+
+	/* We don't want to see VMMCALLs from a nested guest */
+	c->intercept &= ~(1ULL << INTERCEPT_VMMCALL);
+
+	c->intercept_cr |= g->intercept_cr;
+	c->intercept_dr |= g->intercept_dr;
+	c->intercept_exceptions |= g->intercept_exceptions;
+	c->intercept |= g->intercept;
 }
 
 static inline struct vmcb *get_host_vmcb(struct vcpu_svm *svm)
@@ -3590,15 +3604,6 @@ static void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
 	else
 		svm->vcpu.arch.hflags &= ~HF_VINTR_MASK;
 
-	if (svm->vcpu.arch.hflags & HF_VINTR_MASK) {
-		/* We only want the cr8 intercept bits of the guest */
-		clr_cr_intercept(svm, INTERCEPT_CR8_READ);
-		clr_cr_intercept(svm, INTERCEPT_CR8_WRITE);
-	}
-
-	/* We don't want to see VMMCALLs from a nested guest */
-	clr_intercept(svm, INTERCEPT_VMMCALL);
-
 	svm->vcpu.arch.tsc_offset += nested_vmcb->control.tsc_offset;
 	svm->vmcb->control.tsc_offset = svm->vcpu.arch.tsc_offset;
 
-- 
1.8.3.1


