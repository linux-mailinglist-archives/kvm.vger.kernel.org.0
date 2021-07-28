Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA0273D949C
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 19:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbhG1Rxv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 13:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbhG1Rxs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 13:53:48 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A350C061764
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 10:53:46 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id t3so1518049plg.9
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 10:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=F0nfLIWex2nYIAdgmaA4PfWdNKPPyHwYjZqUwzWJZwk=;
        b=E2elqaalbjarENcmpdpYs/H0rnvbvY4kHDiIUFuVpCGMXvFdX+eeK/ycJJw3lNO6op
         buI43s3r/iBRBdNE4hKPlnc15MWjmhJOh8Xm9O4NhSPi4vcinDDsSvxC1AkXMQZV5iNK
         0vIM1nuS/gmliUo0p5UcAo7CNwZY+IaNi6X8ZVCX560bIf9IvNkFFb83C0DQ8xtxcwdx
         lNJjH0SfZ97XuAuI4MSGUum38QohEl4K9YcM+Nq53vBed6GC0EUbligaGO1NaonibOYh
         DimHFhvPV7jTzxxrUf3Km42Rc4F3mrGnGilq+MDM1abPMeGt7TJqWEx7EIdXTigm+ETU
         yFIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=F0nfLIWex2nYIAdgmaA4PfWdNKPPyHwYjZqUwzWJZwk=;
        b=ORSx+C55bRwSg7u7okyx/4VIcY4TS15NPrcXEzJlpyMnukUFN8RR6pvxDklah5koAO
         i9STIEuLM5VJkUuduVd6AKulHzXfqJ5zFASw9DFGE9GDjbRa5JtsGnCtbzh6NQGEgsMM
         qglW0Wg/eEeK+XotyYs7dM2hyHeALLx/ITsh3go/ORDfhW510KNb/XoQIK756F02wKm2
         G+fx34hGMc9LCbp63nI8GOpEj7xig3y9fDqXvjqcZOSeMYtADDf48lzM3pRLWmqN7yFs
         OWUDzJyAvSp4jsFtOQ5LfHy5VX0ElJHNbeM17/g9V4Gr6vWgbI1Jlao3eem0eTsDBp94
         yhkg==
X-Gm-Message-State: AOAM531pbaiKXJi9C0GbXhxD7NbmJP5oOrivSxHyjLW1sGPYt3rmFZdS
        i0ymERW9BLZaCJPYUVQOQ4LX7XtGORa1fA==
X-Google-Smtp-Source: ABdhPJzILQm3R5QpaDyC8cMDeYnp2fvQpyidqpavQckIPsDjW/hghWGiyIxPKVAw3tvixBbUHxN6eQ==
X-Received: by 2002:a17:90a:be16:: with SMTP id a22mr909615pjs.169.1627494825462;
        Wed, 28 Jul 2021 10:53:45 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id w2sm5966190pjf.2.2021.07.28.10.53.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 10:53:44 -0700 (PDT)
Date:   Wed, 28 Jul 2021 17:53:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Exit to userspace when kvm_check_nested_events
 fails
Message-ID: <YQGZpPUC5TViIRih@google.com>
References: <20210728115317.1930332-1-pbonzini@redhat.com>
 <87o8am62ac.fsf@vitty.brq.redhat.com>
 <73c45041-6bb3-801c-bd80-f48b2e525548@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73c45041-6bb3-801c-bd80-f48b2e525548@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 28, 2021, Paolo Bonzini wrote:
> On 28/07/21 14:39, Vitaly Kuznetsov wrote:
> > Shouldn't we also change kvm_arch_vcpu_runnable() and check
> > 'kvm_vcpu_running() > 0' now?
> 
> I think leaving kvm_vcpu_block on error is the better choice, so it should
> be good with returning true if kvm_vcpu_running(vcpu) < 0.

Blech.  This is all gross.  There is a subtle bug lurking in both Jim's approach
and in this approach.  It's not detected because the selftest exercises a bad PI
descriptor, not a bad vAPIC page.

In Jim's approach of returning 'true' from kvm_vcpu_running() if
kvm_check_nested_events() fails due to vmx_complete_nested_posted_interrupt()
detecting a bad vAPIC page, the resulting KVM_EXIT_INTERNAL_ERROR will be "lost"
due to vmx->nested.pi_pending being cleared.  KVM runs the vCPU, but skips over
the PI check in inject_pending_event() due to vmx->nested.pi_pending==false.
The selftest works because the bad PI descriptor case is handled _before_
pi_pending is cleared.

This approach mostly fixes that bug by virtue of returning immediately in the
vcpu_run() case, but if the bad vAPIC page is encountered via
kvm_arch_vcpu_runnable(), KVM will effectively drop the error.  This can be
hack-a-fixed by pre-checking the vAPIC page.  That's arguably architecturally
wrong as the vAPIC emulation access shouldn't occur until after PI.ON is cleared,
but from KVM's perspective I think it's the least awful "fix" given the current
train wreck.

Alternatively, what about punting all of this in favor of targeting the full
cleanup[*] for 5.15?  I believe I have the bandwidth to pick that up.

[*] https://lkml.kernel.org/r/YKWI1GPdNc4shaCt@google.com

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 0d0dd6580cfd..8d1c8217954a 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3707,6 +3707,10 @@ static int vmx_complete_nested_posted_interrupt(struct kvm_vcpu *vcpu)
        if (!vmx->nested.pi_desc)
                goto mmio_needed;

+       vapic_page = vmx->nested.virtual_apic_map.hva;
+       if (!vapic_page)
+               goto mmio_needed;
+
        vmx->nested.pi_pending = false;

        if (!pi_test_and_clear_on(vmx->nested.pi_desc))
@@ -3714,10 +3718,6 @@ static int vmx_complete_nested_posted_interrupt(struct kvm_vcpu *vcpu)

        max_irr = find_last_bit((unsigned long *)vmx->nested.pi_desc->pir, 256);
        if (max_irr != 256) {
-               vapic_page = vmx->nested.virtual_apic_map.hva;
-               if (!vapic_page)
-                       goto mmio_needed;
-
                __kvm_apic_update_irr(vmx->nested.pi_desc->pir,
                        vapic_page, &max_irr);
                status = vmcs_read16(GUEST_INTR_STATUS);

[*] 
