Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CAE0FB422
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 16:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbfKMPuP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 10:50:15 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39493 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbfKMPuP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 10:50:15 -0500
Received: by mail-wr1-f68.google.com with SMTP id l7so2937352wrp.6
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 07:50:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=krjU2hd3ztP4woKuJblHI3QSV2BYpHLjvcUu9d/lsaQ=;
        b=U62KbEfDIt3WvEiheY2lcYb/enkEtZlPwnKf0Mq+wdLpaXfRIMM0nHpTsFlR3J1YDl
         8nrL8GLPfjRVb80/RIUYbuWzOaVHC6P7G3qJALuRJbjSuWzjniv1R/+Yas38N5uYOBJF
         Mh2d6q4zyumHh0qdn/2meStlvd/EVO4N5kaoweGSOdCVGycD4WVyAN1lIBMd8S9EEO5H
         Cq1gQwAucima49HsKI3IZ92ppjlOXe3RX+ZvainSh1pYUHch0YQlv1S8OUcnuqFH2RP8
         xMtYjPVrlUhsLIlqog94BrTtvulR6c+cBxz3bxsCBEyMVlOsE9h8H9v6tmYAb6bHc+Tr
         1xSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=krjU2hd3ztP4woKuJblHI3QSV2BYpHLjvcUu9d/lsaQ=;
        b=cC+UfG3XTiq7Vhg74ka8uKbeFEgtClTDs3Mg/q5B01bDeUWsWJpffOZa+fOvZesZ7Z
         4LTod4rXxtvJTJu8CEJfktPE5O+iDaoQBQUYKwDPJ1XkCPzZgHDE+vNSpZRvQ2WwIadd
         k8LKpDOtx0sbK9dNkE3dtZ/mau/kWi5cKikP90a7RNgIKvObUIzxO6OSny+6Q7iB9UiF
         3Fy+vENyA1Go0sAoIy5BB+9Ao6hwIIgQtl0kF2XKyN+F4mFUfG8Pxfa85d83O8yhECOh
         3JF9mYXby4kj024N3nU6bvmdQOBKq3lUj927IBjHibwIRK8wFyKoGt0X24L2/LJeS6N/
         Iq4w==
X-Gm-Message-State: APjAAAW2/Dqc89IVwh+74KeHNbP+SXDyo+uBIdzZ5XXVdGrGCx4G+CtZ
        tlP0k+RVrloYtNKTYTNgpzmJukPp
X-Google-Smtp-Source: APXvYqxiQMJNxDNZkEFnRUM1RCnttAfg3vmIqygChNm2My+pAYzU2l3qB4hSOA9t/jneqeaMH/x0GA==
X-Received: by 2002:adf:8543:: with SMTP id 61mr3693887wrh.171.1573660212458;
        Wed, 13 Nov 2019 07:50:12 -0800 (PST)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id t134sm2992999wmt.24.2019.11.13.07.50.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Nov 2019 07:50:11 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     cavery@redhat.com
Subject: [PATCH kvm-unit-tests] svm: run tests with host IF=1
Date:   Wed, 13 Nov 2019 16:50:09 +0100
Message-Id: <1573660209-26331-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Tests should in general call VMRUN with EFLAGS.IF=1 (if there are
exceptions in the future we can add a cmp/jz in test_run).  This is
because currently interrupts are masked during all of VMRUN, while
we usually want interrupts during a test to cause a vmexit.
This is similar to how PIN_EXTINT and PIN_NMI are included by
default in the VMCS used by vmx.flat.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/svm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/x86/svm.c b/x86/svm.c
index 4ddfaa4..097a296 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -254,6 +254,7 @@ static void test_run(struct test *test, struct vmcb *vmcb)
     u64 vmcb_phys = virt_to_phys(vmcb);
     u64 guest_stack[10000];
 
+    irq_disable();
     test->vmcb = vmcb;
     test->prepare(test);
     vmcb->save.rip = (ulong)test_thunk;
@@ -269,7 +270,9 @@ static void test_run(struct test *test, struct vmcb *vmcb)
             "mov regs, %%r15\n\t"       // rax
             "mov %%r15, 0x1f8(%0)\n\t"
             LOAD_GPR_C
+            "sti \n\t"		// only used if V_INTR_MASKING=1
             "vmrun \n\t"
+            "cli \n\t"
             SAVE_GPR_C
             "mov 0x170(%0), %%r15\n\t"  // rflags
             "mov %%r15, regs+0x80\n\t"
@@ -284,6 +287,7 @@ static void test_run(struct test *test, struct vmcb *vmcb)
 	tsc_end = rdtsc();
         ++test->exits;
     } while (!test->finished(test));
+    irq_enable();
 
     report("%s", test->succeeded(test), test->name);
 }
@@ -301,7 +305,6 @@ static bool default_supported(void)
 static void default_prepare(struct test *test)
 {
     vmcb_ident(test->vmcb);
-    cli();
 }
 
 static bool default_finished(struct test *test)
-- 
1.8.3.1

