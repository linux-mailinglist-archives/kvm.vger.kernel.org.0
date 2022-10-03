Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CABCF5F2BBA
	for <lists+kvm@lfdr.de>; Mon,  3 Oct 2022 10:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbiJCI0c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Oct 2022 04:26:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbiJCI0J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Oct 2022 04:26:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C9DA1ADB7
        for <kvm@vger.kernel.org>; Mon,  3 Oct 2022 01:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664783941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WmztSdLxGLePdL68BUHnz4SzM/l/VKgoGqcyR7GOU3U=;
        b=GjKi2OuSrnnINNi0FZE2IWrQyDYg0DEXHvvBZZ64yItA9vy8F9nqCgxDo0j8M21dnOUQsa
        qld8A8YrkoVrOJ9DORGKfmY1J7tyQMucQMLQkFPuCAUYBAz7m0zWQn4HzuPWMTKXA5arRI
        jpGVQIzeGMkXiDPCo9ezyfrOl+pdYjk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-365-rDj1GlhuNzGvFkYvPvriTg-1; Mon, 03 Oct 2022 03:28:03 -0400
X-MC-Unique: rDj1GlhuNzGvFkYvPvriTg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C4AB28027ED;
        Mon,  3 Oct 2022 07:28:01 +0000 (UTC)
Received: from starship (unknown [10.40.193.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B9A621121314;
        Mon,  3 Oct 2022 07:27:54 +0000 (UTC)
Message-ID: <a80e2f92b4a93b00ad29f16944f2748eadbdda76.camel@redhat.com>
Subject: Re: Nested AVIC design (was:Re: [RFC PATCH v3 04/19] KVM: x86: mmu:
 allow to enable write tracking externally)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        intel-gfx@lists.freedesktop.org, Daniel Vetter <daniel@ffwll.ch>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        intel-gvt-dev@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Date:   Mon, 03 Oct 2022 10:27:53 +0300
In-Reply-To: <YzYeTCsNfQWccKJ9@google.com>
References: <20220427200314.276673-1-mlevitsk@redhat.com>
         <20220427200314.276673-5-mlevitsk@redhat.com> <YoZyWOh4NPA0uN5J@google.com>
         <5ed0d0e5a88bbee2f95d794dbbeb1ad16789f319.camel@redhat.com>
         <c22a18631c2067871b9ed8a9246ad58fa1ab8947.camel@redhat.com>
         <Yt6/9V0S9of7dueW@google.com>
         <7c4cf32dca42ab84bdb427a9e4862dbf5509f961.camel@redhat.com>
         <YugLc5LLPJkt89z6@google.com>
         <fe76ea902a38a10e2d8078fd9e5a71a0c7724d84.camel@redhat.com>
         <YzYeTCsNfQWccKJ9@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-09-29 at 22:38 +0000, Sean Christopherson wrote:
> On Mon, Aug 08, 2022, Maxim Levitsky wrote:
> > Hi Sean, Paolo, and everyone else who wants to review my nested AVIC work.
> 
> Before we dive deep into design details, I think we should first decide whether
> or not nested AVIC is worth pursing/supporting.
> 
>   - Rome has a ucode/silicon bug with no known workaround and no anticipated fix[*];
>     AMD's recommended "workaround" is to disable AVIC.
>   - AVIC is not available in Milan, which may or may not be related to the
>     aforementioned bug.
>   - AVIC is making a comeback on Zen4, but Zen4 comes with x2AVIC.
>   - x2APIC is likely going to become ubiquitous, e.g. Intel is effectively
>     requiring x2APIC to fudge around xAPIC bugs.
>   - It's actually quite realistic to effectively force the guest to use x2APIC,
>     at least if it's a Linux guest.  E.g. turn x2APIC on in BIOS, which is often
>     (always?) controlled by the host, and Linux will use x2APIC.
> 
> In other words, given that AVIC is well on its way to becoming a "legacy" feature,
> IMO there needs to be a fairly strong use case to justify taking on this much code
> and complexity.  ~1500 lines of code to support a feature that has historically
> been buggy _without_ nested support is going to require a non-trivial amount of
> effort to review, stabilize, and maintain.
> 
> [*] 1235 "Guest With AVIC (Advanced Virtual Interrupt Controller) Enabled May Fail
>     to Process IPI (Inter-Processor Interrupt) Until Guest Is Re-Scheduled" in
>     https://www.amd.com/system/files/TechDocs/56323-PUB_1.00.pdf
> 

I am afraid that you mixed things up:

You mistake is that x2avic is just a minor addition to AVIC. It is still for
all practical purposes the same feature.

 
1. The AVIC is indeed kind of broken on Zen2 (but AFAIK for all practical purposes,
   including nested it works fine, the errata only shows up in a unit test and/or
   under very specific workloads (most of the time a delayed wakeup doesn't cause a hang).
   Yet, I agree that for production Zen2 should not have AVIC enabled.
 

2. Zen3 does indeed have AVIC soft disabled in CPUID. AFAIK it works just fine,
   but I understand that customers won't use it against AMD's guidance.
 
 
3. On Zen4, AVIC is fully enabled and also extended to support x2apic mode.
   The fact that AVIC was extended to support X2apic mode also shows that AMD
   is committed to supporting it.
 
 
My nested AVIC code technically doesn't expose x2avic to the guest, but it
is pretty much trivial to add (I am only waiting to get my hands on Zen4 machine
to do it), and also even in its current form it would work just fine if the host
uses normal AVIC .
 
(or even doesn't use AVIC at all - the nested AVIC code works just fine
even if the host has its AVIC inhibited for some reason).
 
Adding nested x2avic support is literally about not passing through that MMIO address,
Enabling the x2avic bit in int_ctl, and opening up the access to x2apic msrs.
Plus I need to do some minor changes in unaccelerated IPI handler, dealing
With read-only logical ID and such.
 
Physid tables, apic backing pages, doorbell emulation, 
everything is pretty much unchanged.
 
So AVIC is nothing but a legacy feature, and my nested AVIC code will support
both nested AVIC and nested X2AVIC.
 
Best regards,
	Maxim Levitsky
 
 

