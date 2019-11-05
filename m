Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA450F0359
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 17:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390289AbfKEQp3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 11:45:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22682 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390179AbfKEQp3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 11:45:29 -0500
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7683FC049E17
        for <kvm@vger.kernel.org>; Tue,  5 Nov 2019 16:45:28 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id f14so4855wmc.0
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2019 08:45:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jdYpSx2fv35lwEDQsxW/nJKQ15ZD+jtULvUxT5NCflg=;
        b=JFkIlxE+ONHPdTTh2ux5Q7fAA9NyLZBxCThxmEV0CDsJITx5xW5IiAubFIU9O9hE0X
         Acr+Hr525iKtPw4yXwRlMaovqqEPqnIaUTBJ7h9QUP/VkuUX03O9R8TPKgnxUGP80mLs
         SR9xEqKngn9cPdqyJviQCLkFq43CogRwO9gmHPdh1H21wWC+H+8REtjxfkZgbb0tb/HM
         8/k+DZMcoATG+w15dZjRmfbUvwFP8tP1q7PFRNIweYEWpj5vv756p0DLu4S4sg8K3QBP
         RMzu/O91tvTIV4rYy0gVYrH8vRIgRNckeOVXb39purWlH8H3t+hgf4gUtJHgXbNEdHN5
         AJiw==
X-Gm-Message-State: APjAAAVSI2iho4rbQPSpllITcJMr/vKPXKaDuhgokqJnz0OIgwWAV+PI
        FlXgtKh1Qpu9H6jXg54BeEBvaxCb/nEcCrMbEn7hwwqt7+t4bpnbW8r9mIwcOFUQjcd9GR1TehO
        ZDQLLKwAuDzic
X-Received: by 2002:adf:b1dc:: with SMTP id r28mr25786748wra.363.1572972326699;
        Tue, 05 Nov 2019 08:45:26 -0800 (PST)
X-Google-Smtp-Source: APXvYqyiGRXprkbiwQ5tmKEpKhpMrPCwGQ9GWpq+cEuolVCUmSsS4lfle12P1pyke5oaGahJMUGeyA==
X-Received: by 2002:adf:b1dc:: with SMTP id r28mr25786733wra.363.1572972326364;
        Tue, 05 Nov 2019 08:45:26 -0800 (PST)
Received: from [192.168.182.3] (net-93-146-44-156.cust.vodafonedsl.it. [93.146.44.156])
        by smtp.gmail.com with ESMTPSA id b1sm14226332wrw.77.2019.11.05.08.45.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Nov 2019 08:45:25 -0800 (PST)
Subject: Re: [PATCH kvm-unit-tests] svm: Verify a pending interrupt queued
 before entering the guest is not lost
To:     Cathy Avery <cavery@redhat.com>, kvm@vger.kernel.org
References: <20191105151234.28160-1-cavery@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <8f2763c0-138e-6a05-a3c1-ed1043356c3f@redhat.com>
Date:   Tue, 5 Nov 2019 17:45:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191105151234.28160-1-cavery@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/11/19 16:12, Cathy Avery wrote:
> +static void pending_event_prepare(struct test *test)
> +{
> +    int ipi_vector = 0xf1;
> +
> +    default_prepare(test);
> +

I think this test should call VMRUN with EFLAGS.IF=1.  The GIF/IF
interaction is as follows:

- in the host, IF is simply ignored with GIF=0.  VMRUN atomically sets
GIF to 1. Therefore, interrupts are wholly masked between CLGI and VMRUN
and between VMRUN and STGI, but not during VMRUN.  Currently, interrupts
are masked during all of VMRUN actually, because default_prepare clears
the interrupt flag.

- in the guest, if VINTR_MASKING=0 (in kvm-unit-tests: bit 24 of
int_ctl), IF governs whether host interrupts are delivered even while
the guest is running.

- if VINTR_MASKING=1, however, the pre-VMRUN value of IF (that's stored
in HF_HIF_MASK, let's call it HIF from now on) governs whether host
interrupts are delivered.

Actually, I think HIF=1 is a good default for most tests, so I would
start with something like

diff --git a/x86/svm.c b/x86/svm.c
index 4ddfaa4..7db3798 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -254,6 +255,7 @@ static void test_run(struct test *test,
     u64 vmcb_phys = virt_to_phys(vmcb);
     u64 guest_stack[10000];

+    irq_disable();
     test->vmcb = vmcb;
     test->prepare(test);
     vmcb->save.rip = (ulong)test_thunk;
@@ -269,7 +271,9 @@ static void test_run(struct test *test,
             "mov regs, %%r15\n\t"       // rax
             "mov %%r15, 0x1f8(%0)\n\t"
             LOAD_GPR_C
+            "sti \n\t"		// only used if V_INTR_MASKING=1
             "vmrun \n\t"
+            "cli \n\t"
             SAVE_GPR_C
             "mov 0x170(%0), %%r15\n\t"  // rflags
             "mov %%r15, regs+0x80\n\t"
@@ -284,6 +288,7 @@ static void test_run(struct test *test, struct vmcb
*vmcb)
 	tsc_end = rdtsc();
         ++test->exits;
     } while (!test->finished(test));
+    irq_enable();

     report("%s", test->succeeded(test), test->name);
 }
@@ -301,7 +306,6 @@ static bool default_supported(void)
 static void default_prepare(struct test *test)
 {
     vmcb_ident(test->vmcb);
-    cli();
 }

 static bool default_finished(struct test *test)

and see if it breaks something.  Then, it's probably useful to modify
your prepare callback to set IF=1 in the regs.rflags, since otherwise
the interrupts shouldn't be processed anyway.

> +        test->vmcb->control.intercept &= ~(1ULL << INTERCEPT_INTR);
> +        test->vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
> +

I think these adjustments are not needed.  However, you could add two
other tests:

- one which runs with V_INTR_MASKING=1 and HIF=0.  In that case, the
VMMCALL should be reached without a prior SVM_EXIT_INTR vmexit.

- one which runs with V_INTR_MASKING=0 and EFLAGS.IF=1.  In that case,
the VMMCALL should be reached without a prior SVM_EXIT_INTR vmexit, and
the interrupt should be delivered while in guest mode, before
pending_event_guest_run is set.

Thanks,

Paolo
