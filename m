Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 432283B0F1E
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 23:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbhFVVDX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 17:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbhFVVDV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 17:03:21 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CD64C061574
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 14:01:05 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id q207-20020a3743d80000b02903ab34f7ef76so19654508qka.5
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 14:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=vLaSeuzytuR7vvw4yPwWOITjIwy09qA/AxiRyKDmw2U=;
        b=RPF6munACGVqz85nz8cT11Cns3fEt8lE/seqQA5Iy6csQ4n3EIVTIr7223ZJUktbOM
         fCRnWcxtjWhry4v8DxOGbvXi9ghJMmhC9A2kiovuB+v9q5xf1nNjee/i3EJVnMTMYK1A
         N3qpXZAmZEtlobUPJWOAuDS99DRD8vCgztKPIxnZzJb7QVQILeOhxYnC7Rh1MD8M9e6c
         zG3Cl6M1JwouvZTuQBuKrbqGHXerJtr1s7jCZhVQaGpNwRl3pmAhguRzyddXRhHWKQZq
         XjWhBaGOr8nOVrds3XUNKikeDXX5fsfobnOEkIFUnY7PGAcbNMXoy34CmLHqi8xfVcjj
         kcsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=vLaSeuzytuR7vvw4yPwWOITjIwy09qA/AxiRyKDmw2U=;
        b=sD8zLIxML3v45CpPcDIMIuk/MBOindw6KHrrEUSTofaxRYCkiBa5BV4kfcyfZOljAt
         guIZ2oNxdwJh0ec+HYrqSPrqzlOOdJVd7al2fRMu1Dt8FLhSCziyws0iHdgC4HCe0fWI
         TA0x68m4u1NsoNABay24qOWoA1eQr4DiHiB9yXnJrU+PoCEmgSeh50Y/6xB0jva1YQ1h
         RhWaYV61eoG/XFkvC8h2o3Upoyh0QeTG3FPuw8UGCT9kKf/VnV/wke5cn1Gt08Ozu9XH
         mlia6iPucekOt5pMjWITXUymumbJChjSzEcw24JzPwiBaEz/g5qpd7JMKHB2lFkLlCxq
         M7Wg==
X-Gm-Message-State: AOAM530EPtgfghivVM+K+aVkJfjGmfPxTkIsnd+tSEUfqMZmoeS6bdJ6
        mhPJA6L0pWY0rLZtnCU2DnSxEPiwETo=
X-Google-Smtp-Source: ABdhPJw66SsvmLyOqh5Un0sLfKmYW6HqAvR91NfK63Q2LGNtmOhFaxJBz6dhbkDQw11CUE+tGY1In+daQZ8=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:7d90:4528:3c45:18fb])
 (user=seanjc job=sendgmr) by 2002:a25:4805:: with SMTP id v5mr7178689yba.4.1624395664350;
 Tue, 22 Jun 2021 14:01:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 14:00:41 -0700
In-Reply-To: <20210622210047.3691840-1-seanjc@google.com>
Message-Id: <20210622210047.3691840-7-seanjc@google.com>
Mime-Version: 1.0
References: <20210622210047.3691840-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [kvm-unit-tests PATCH 06/12] nSVM: Stop forcing EFER.NX=1 for all tests
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't force EFER.NX=1 for SVM tests now that the one NPT test that needs
EFER.NX=1 does its own housekeeping.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/svm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/x86/svm.c b/x86/svm.c
index 6e5872d..0959189 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -295,7 +295,7 @@ static void set_additional_vcpu_msr(void *msr_efer)
 	void *hsave = alloc_page();
 
 	wrmsr(MSR_VM_HSAVE_PA, virt_to_phys(hsave));
-	wrmsr(MSR_EFER, (ulong)msr_efer | EFER_SVME | EFER_NX);
+	wrmsr(MSR_EFER, (ulong)msr_efer | EFER_SVME);
 }
 
 static void setup_svm(void)
@@ -306,7 +306,6 @@ static void setup_svm(void)
 
 	wrmsr(MSR_VM_HSAVE_PA, virt_to_phys(hsave));
 	wrmsr(MSR_EFER, rdmsr(MSR_EFER) | EFER_SVME);
-	wrmsr(MSR_EFER, rdmsr(MSR_EFER) | EFER_NX);
 
 	io_bitmap = (void *) ALIGN((ulong)io_bitmap_area, PAGE_SIZE);
 
-- 
2.32.0.288.g62a8d224e6-goog

