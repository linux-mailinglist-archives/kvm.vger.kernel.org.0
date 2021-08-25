Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D97F03F7E0E
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 00:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233073AbhHYV61 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 17:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbhHYV61 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 17:58:27 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B81C061757
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 14:57:40 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id t1so1054020pgv.3
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 14:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aY2Omr8i3Z9RwPbY54XXhXLRfUqWVte3e22E3NiG+6A=;
        b=FNb6SF3dWu5bz3CZwYjIHyp/Ad372Ye+fDKa95pqLlnZVKUBrBChVl4trOAAEsnfCs
         ynmibgEKUJ/jyhCDTvIQeHjFSVj45VngNJLjfy6ovC2CU1BMQ9iCaxehKxrX5VGPnO6A
         oFsiqLkv31ymPKBE4kHFicXJckjQ4JoKUsCqp+Sy/QApqhgwC596vQEi2e93ZoMUHkVJ
         P8IwujeB2vSyfuE3boY73apirKocGkCEKg8JNq6OHja9w6HozdsW22fzzAwrICtH2BS9
         gx0jnwyQsa/eAS/1jowbZ6cjvVSRFsbQ68pKxMRx9sPVflJqOM4LlkukjAuz8zu9W170
         NLkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aY2Omr8i3Z9RwPbY54XXhXLRfUqWVte3e22E3NiG+6A=;
        b=o0si78Glz/WF2vDJc9oapKGXR7qymzaNhiioWgrVX4RoAB4rUbDxbSQjAtWXBbYqyS
         o+TsqU16aBQJwt+eH577mt87myIkleb0RE14hdhL2Vkxnd/CxIPez1aKc1bdCwKZmAlt
         zRj12pOegs7QnFgXW5WRGcZRo/vvpGcbksoqTlq7Lpl6iUoq4OWQWcXriHEET7LowEXo
         VTjlVfZcQOyv5IvV2X5oza8xBSrZxRztpudHMiPE3Ut9XByBNDfScMh1L4Vc3yxaIKau
         NPK1G1HCTbzs20UeKOqc2jylaPQlC9+LjyD44rIilgQEGDRd9jjzW0JwZRNPnUeAZw7A
         1fWQ==
X-Gm-Message-State: AOAM531u0CT3k3Rswuwy0f0EFIvJVh/GCYy/uSlxfShguOewWcq//CsU
        PVRz98JGyk2mOYgsh4lygvRa0Q==
X-Google-Smtp-Source: ABdhPJx35HhsxvEq8d26HAearzhLATVZmQWASK01NsxB79Vfv7kp3LIb0fMMn26+jwwn+WXje9OZzA==
X-Received: by 2002:a63:62c7:: with SMTP id w190mr295791pgb.105.1629928660133;
        Wed, 25 Aug 2021 14:57:40 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id v63sm918511pgv.59.2021.08.25.14.57.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 14:57:39 -0700 (PDT)
Date:   Wed, 25 Aug 2021 21:57:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai+lkml@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Venkatesh Srinivas <venkateshs@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH 2/2] KVM: Guard cpusmask NULL check with
 CONFIG_CPUMASK_OFFSTACK
Message-ID: <YSa8z5vQKbFuLtew@google.com>
References: <20210821000501.375978-1-seanjc@google.com>
 <20210821000501.375978-3-seanjc@google.com>
 <CAJhGHyB1RjBLRLtaS80XQSTb0g35smxnBQPjEp-BwieKu1cwXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhGHyB1RjBLRLtaS80XQSTb0g35smxnBQPjEp-BwieKu1cwXw@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 25, 2021, Lai Jiangshan wrote:
> On Sat, Aug 21, 2021 at 8:09 AM Sean Christopherson <seanjc@google.com> wrote:
> > @@ -277,6 +277,14 @@ bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
> >                 if (!(req & KVM_REQUEST_NO_WAKEUP) && kvm_vcpu_wake_up(vcpu))
> >                         continue;
> >
> > +               /*
> > +                * tmp can be NULL if cpumasks are allocated off stack, as
> > +                * allocation of the mask is deliberately not fatal and is
> > +                * handled by falling back to kicking all online CPUs.
> > +                */
> > +               if (IS_ENABLED(CONFIG_CPUMASK_OFFSTACK) && !tmp)
> > +                       continue;
> > +
> 
> Hello, Sean
> 
> I don't think it is a good idea to reinvent the cpumask_available().

Using cpumask_available() is waaaay better, thanks!

Vitaly / Paolo, take this one instead?

From deff3e168c0612a2947d1ef29e488282631a788c Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Fri, 20 Aug 2021 13:36:21 -0700
Subject: [PATCH] KVM: Use cpumask_available() to check for NULL cpumask when
 kicking vCPUs

Check for a NULL cpumask_var_t when kicking multiple vCPUs via
cpumask_available(), which performs a !NULL check if and only if cpumasks
are configured to be allocated off-stack.  This is a meaningless
optimization, e.g. avoids a TEST+Jcc and TEST+CMOV on x86, but more
importantly helps document that the NULL check is necessary even though
all callers pass in a local variable.

No functional change intended.

Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 786b914db98f..2082aceffbf6 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -245,9 +245,13 @@ static void ack_flush(void *_completed)
 {
 }

-static inline bool kvm_kick_many_cpus(const struct cpumask *cpus, bool wait)
+static inline bool kvm_kick_many_cpus(cpumask_var_t tmp, bool wait)
 {
-	if (unlikely(!cpus))
+	const struct cpumask *cpus;
+
+	if (likely(cpumask_available(tmp)))
+		cpus = tmp;
+	else
 		cpus = cpu_online_mask;

 	if (cpumask_empty(cpus))
@@ -277,6 +281,14 @@ bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
 		if (!(req & KVM_REQUEST_NO_WAKEUP) && kvm_vcpu_wake_up(vcpu))
 			continue;

+		/*
+		 * tmp can be "unavailable" if cpumasks are allocated off stack
+		 * as allocation of the mask is deliberately not fatal and is
+		 * handled by falling back to kicking all online CPUs.
+		 */
+		if (!cpumask_available(tmp))
+			continue;
+
 		/*
 		 * Note, the vCPU could get migrated to a different pCPU at any
 		 * point after kvm_request_needs_ipi(), which could result in
@@ -288,7 +300,7 @@ bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
 		 * were reading SPTEs _before_ any changes were finalized.  See
 		 * kvm_vcpu_kick() for more details on handling requests.
 		 */
-		if (tmp != NULL && kvm_request_needs_ipi(vcpu, req)) {
+		if (kvm_request_needs_ipi(vcpu, req)) {
 			cpu = READ_ONCE(vcpu->cpu);
 			if (cpu != -1 && cpu != me)
 				__cpumask_set_cpu(cpu, tmp);
--
