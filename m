Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0DC43408BB
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 16:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbhCRPYA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 11:24:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59774 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230416AbhCRPXl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 11:23:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616081020;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tps+uQhGA1NEN/bUWbQt+rDgfELACn9s+1vPKZFrxrY=;
        b=UAbgYwclWJN1n6vyekyrZLDFB2VV89khX53ymvGz27Pfof5QY9veCyVq5uE5C3+t5grVZi
        Il7zmDrlumfjopDz8GW8OciZAtFfZ4gTOSsvE2qbGWqq9/jqr7tnKlkZCSY200+/E2/L4t
        FPxVfRsCVeY80GHVPEc4rMdKOE1mklU=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298--lDQJE9NNjOwRIKDTXOY2w-1; Thu, 18 Mar 2021 11:23:38 -0400
X-MC-Unique: -lDQJE9NNjOwRIKDTXOY2w-1
Received: by mail-ej1-f71.google.com with SMTP id t21so8854335ejf.14
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 08:23:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=tps+uQhGA1NEN/bUWbQt+rDgfELACn9s+1vPKZFrxrY=;
        b=KMvPVNz6+JGvgWlvGA7uE8FCtv1z/Dumplf3e1koC0qm9tCohpHQ6agfMb7n33mCxd
         VyCjpo4s5wSN7DklfWord4zeDh0HD1rR6LtN1PYUtXn4V8xzUimXyyx2OM7E3yfrANne
         QoevnAZFmUaStcuKnPUvbUdYbt0p1FMrEHeAHMwILePZ7I2zdRN736c8nFqpYkXh0tu8
         xiVcsvO91yTb1V6kP3T1NnoK194QBPsodXYNMFXmh8LK5+7I0HDl+zhz+3cPaRpLsK1/
         8XSWB1u13mRS9MF1h4JaXxkO1AXI6anK4J15Ds0QOOFjAFmP1UG6CAbBJxB+j2K8OfTi
         TPTQ==
X-Gm-Message-State: AOAM532Xo+WaALiYcv/L9vMoIS/r0TY1cc6TDuayhQuF9EZtv7oRQj2t
        D/6rTRBMM0pCQneucGvD6M4Ar1FGLl8S5HGzcIDTrVJBh3j4I9oalAbvaSMqU5q/uoUPZ0CEVia
        4fnM0Lsv4z9/q
X-Received: by 2002:a17:906:c08f:: with SMTP id f15mr41758628ejz.318.1616081017311;
        Thu, 18 Mar 2021 08:23:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxyqgVAYjCyuDBOopKmRIaHM19vzpeP9vfiK0ysp/jEKGqYWCBL9TlgztOOatw6Gj11Dx5oQw==
X-Received: by 2002:a17:906:c08f:: with SMTP id f15mr41758609ejz.318.1616081017117;
        Thu, 18 Mar 2021 08:23:37 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id p9sm2372944edu.79.2021.03.18.08.23.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 08:23:36 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v2 6/4] selftests: kvm: Add basic Hyper-V clocksources
 tests
In-Reply-To: <41897f61-9d1a-519b-e1cb-e19efa34ab55@redhat.com>
References: <20210316143736.964151-1-vkuznets@redhat.com>
 <20210318140949.1065740-1-vkuznets@redhat.com>
 <1176f351-220d-003e-2cae-65f0b42c8f18@redhat.com>
 <8735ws7bva.fsf@vitty.brq.redhat.com>
 <41897f61-9d1a-519b-e1cb-e19efa34ab55@redhat.com>
Date:   Thu, 18 Mar 2021 16:23:35 +0100
Message-ID: <87zgz05vuw.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--=-=-=
Content-Type: text/plain

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 18/03/21 15:52, Vitaly Kuznetsov wrote:
>> Paolo Bonzini <pbonzini@redhat.com> writes:
>> 
>>> On 18/03/21 15:09, Vitaly Kuznetsov wrote:
>>>> +static inline void check_tsc_msr_tsc_page(struct ms_hyperv_tsc_page *tsc_page)
>>>> +{
>>>> +	u64 r1, r2, t1, t2;
>>>> +	s64 delta_ns;
>>>> +
>>>> +	/* Compare TSC page clocksource with HV_X64_MSR_TIME_REF_COUNT */
>>>> +	t1 = mul_u64_u64_shr64(rdtsc(), tsc_page->tsc_scale) + tsc_page->tsc_offset;
>>>> +	r1 = rdmsr(HV_X64_MSR_TIME_REF_COUNT);
>>>> +	nop_loop();
>>>> +	t2 = mul_u64_u64_shr64(rdtsc(), tsc_page->tsc_scale) + tsc_page->tsc_offset;
>>>> +	r2 = rdmsr(HV_X64_MSR_TIME_REF_COUNT);
>>>> +
>>>> +	delta_ns = ((r2 - r1) - (t2 - t1)) * 100;
>>>> +	if (delta_ns < 0)
>>>> +		delta_ns = -delta_ns;
>>>> +
>>>> +	/* 1% tolerance */
>>>> +	GUEST_ASSERT(delta_ns * 100 < (t2 - t1) * 100);
>>>> +}
>>>> +
>>>
>>> I think you should also be able to check r1 and r2 individually, not
>>> just r1 and r2.  Is that correct?
>> 
>> Right, we could've checked r1 == t1 and r2 == t2 actually (with some
>> tiny margin of course). Let me try that.
>
> np, I can do that too.  Just checking my recollection of the TLFS.
>

I already hacked it, patch attached :-) Feel free to squash it or put
your own version in.

-- 
Vitaly


--=-=-=
Content-Type: text/x-patch
Content-Disposition: inline;
 filename=0001-selftests-KVM-hyper-v-check_tsc_msr_tsc_page-fix.patch

From dae56d5d5c5fc7442d4dabf96a9c322acb42f458 Mon Sep 17 00:00:00 2001
From: Vitaly Kuznetsov <vkuznets@redhat.com>
Date: Thu, 18 Mar 2021 16:21:18 +0100
Subject: [PATCH] selftests: KVM: hyper-v: check_tsc_msr_tsc_page() fix.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../selftests/kvm/x86_64/hyperv_clock.c       | 25 ++++++++++---------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_clock.c b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
index 39d6491d8458..aacb6d2697da 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
@@ -82,22 +82,23 @@ static inline void check_tsc_msr_rdtsc(void)
 
 static inline void check_tsc_msr_tsc_page(struct ms_hyperv_tsc_page *tsc_page)
 {
-	u64 r1, r2, t1, t2;
-	s64 delta_ns;
+	u64 t1, t2;
 
-	/* Compare TSC page clocksource with HV_X64_MSR_TIME_REF_COUNT */
-	t1 = mul_u64_u64_shr64(rdtsc(), tsc_page->tsc_scale) + tsc_page->tsc_offset;
-	r1 = rdmsr(HV_X64_MSR_TIME_REF_COUNT);
+	/*
+	 * Make TSC run for a while to make sure clocksources don't diverge
+	 * over time.
+	 */
 	nop_loop();
-	t2 = mul_u64_u64_shr64(rdtsc(), tsc_page->tsc_scale) + tsc_page->tsc_offset;
-	r2 = rdmsr(HV_X64_MSR_TIME_REF_COUNT);
 
-	delta_ns = ((r2 - r1) - (t2 - t1)) * 100;
-	if (delta_ns < 0)
-		delta_ns = -delta_ns;
+	/*
+	 * Get readings from TSC page and Reference TSC clocksources and make
+	 * sure they match.
+	 */
+	t1 = mul_u64_u64_shr64(rdtsc(), tsc_page->tsc_scale) + tsc_page->tsc_offset;
+	t2 = rdmsr(HV_X64_MSR_TIME_REF_COUNT);
 
-	/* 1% tolerance */
-	GUEST_ASSERT(delta_ns * 100 < (t2 - t1) * 100);
+	/* 10us tolerance */
+	GUEST_ASSERT(t2 - t1 <= 100);
 }
 
 static void guest_main(struct ms_hyperv_tsc_page *tsc_page, vm_paddr_t tsc_page_gpa)
-- 
2.30.2


--=-=-=--

