Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD5A8493F2E
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 18:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356466AbiASRk0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 12:40:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243884AbiASRkZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 12:40:25 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4100C06161C
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 09:40:25 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id h12so3100751pjq.3
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 09:40:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TkCPJ5rTo0uF59bfdAd3GqFt3FGsGKqeHq3FuhHr0Dw=;
        b=pOVmACCHhoZBlvWm+GzZoQ1q/ot6ZfDPb8RoVjO9K4d1w1/4bNUlwelRel1FqMpHHy
         urjxnaAAS7e6BbmyWlvEl59ZS0hE/KavrVqhqeDNRvn3vXzYhUiSIaNyYrKIdKTwDSnV
         iSDY3GhJMc5R3h0aa7cIb2ctyWMVNBaQE4vo2QcyU7nN6NhAKjkDTR8gFnukaDWcOCP2
         X2iaOqOMOwADpwgQxStGn7uxSRTYw21xlZiUIapIyTTxb5lYhe8OuVPH20xYUna2xdjL
         rM46iIAmPV7Ct4tkO+tZ/PBNKbvyzzBIJTkOnXSRcMI8kQBbUXRkvUWEylLjoVHfyl4K
         W/Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TkCPJ5rTo0uF59bfdAd3GqFt3FGsGKqeHq3FuhHr0Dw=;
        b=xHxCn36Dm6DyFS1tCTcVhHC/Vr1PzUoyaHYQLDY/nb93t34a/AOy/diJgrwCtO/zb9
         9si9c/Cxn14AHyAYwRiwYTg2eIJ1+Xu0RRW3G4+1TwxvpGJN0ODKIJqoRSst9Cj+8u/U
         Ok23jSGZw6u2E1ZoVEgfC9/gyfMSE9z7z8xu89G2PINUUjwCoM/As37+DcJSoV15LR8i
         xGRQ502O78TU7bs/IbNqm+9C7KBmBhBOTcJGcs2mCYiqIxdOnntudrl/2W0iSRTfcK+e
         v96Es+h16y9bqTixAiPeGwkNnpeXEhSU2QeZOL2/shzs23+P1AyDklOYbPwvnjEUkFMF
         sWIQ==
X-Gm-Message-State: AOAM531Wg2wq5mAnzbjuoojsh03vntAhDQG7hXVKnvshQxzMONSZSPxr
        m7g/XmS8vSD3S8OTUDoKdNNOKgswlP16cQ==
X-Google-Smtp-Source: ABdhPJxAWPyLuDuvfz1a/S+HH8TNH9UpCakDiPZ6DAznKAyeg2V3AkPuN6zZs6zDAB9ttd92kqniPQ==
X-Received: by 2002:a17:90b:3ecd:: with SMTP id rm13mr5592097pjb.49.1642614024832;
        Wed, 19 Jan 2022 09:40:24 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id w9sm319511pfu.42.2022.01.19.09.40.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 09:40:24 -0800 (PST)
Date:   Wed, 19 Jan 2022 17:40:20 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/4] KVM: x86: Partially allow KVM_SET_CPUID{,2} after
 KVM_RUN
Message-ID: <YehNBCRosuQVJFEU@google.com>
References: <20220118141801.2219924-1-vkuznets@redhat.com>
 <20220118141801.2219924-3-vkuznets@redhat.com>
 <Yebs21Vnt4WBQBw5@google.com>
 <878rvckpq4.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878rvckpq4.fsf@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 19, 2022, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> >> @@ -313,6 +335,20 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
> >>  
> >>  	__kvm_update_cpuid_runtime(vcpu, e2, nent);
> >> +	/*
> >> +	 * KVM does not correctly handle changing guest CPUID after KVM_RUN, as
> >> +	 * MAXPHYADDR, GBPAGES support, AMD reserved bit behavior, etc.. aren't
> >> +	 * tracked in kvm_mmu_page_role.  As a result, KVM may miss guest page
> >> +	 * faults due to reusing SPs/SPTEs. In practice no sane VMM mucks with
> >> +	 * the core vCPU model on the fly. It would've been better to forbid any
> >> +	 * KVM_SET_CPUID{,2} calls after KVM_RUN altogether but unfortunately
> >> +	 * some VMMs (e.g. QEMU) reuse vCPU fds for CPU hotplug/unplug and do
> >> +	 * KVM_SET_CPUID{,2} again. To support this legacy behavior, check
> >> +	 * whether the supplied CPUID data is equal to what's already set.
> >
> > This is misleading/wrong. KVM_RUN isn't the only problematic ioctl(),
> 
> Well, it wasn't me who wrote the comment about KVM_RUN :-) My addition
> can be improved of course.

Don't^W^W^W shoot the messenger?  :-)

> > it's just the one that we decided to use to detect that userspace is
> > being stupid.  And forbidding KVM_SET_CPUID after KVM_RUN (or even all
> > problematic ioctls()) wouldn't solve problem as providing different
> > CPUID configurations for vCPUs in a VM will also cause the MMU to fall
> > on its face.
> 
> True, but how do we move forward? We can either let userspace do stupid
> things and (potentially) create hard-to-debug problems or we try to
> cover at least some use-cases with checks (like the one we introduce
> here).

I completely agree, and if this were an internal API or a KVM module param I
would be jumping all over the idea of restricing how it can be used.  What I don't
like is bolting on restrictions to a set of ioctl()s that have been in use for years.

> Different CPUID configurations for different vCPUs is actually an
> interesting case. It makes me (again) think about the
> allowlist/blocklist approaches: we can easily enhance the
> 'vcpu->arch.last_vmentry_cpu != -1' check below and start requiring
> CPUIDs to [almost] match. The question then is how to change CPUID for a
> multi-vCPU guest as it will become effectively forbidden. BTW, is there
> a good use-case for changing CPUIDs besides testing purposes?

No idea.  That's a big reason for my concern; we've really only got input from
QEMU, and there are plenty of users beyond QEMU.

> >> +	if (vcpu->arch.last_vmentry_cpu != -1)
> >> +		return kvm_cpuid_check_equal(vcpu, e2, nent);
> >
> > And technically, checking last_vmentry_cpu doesn't forbid changing CPUID after
> > KVM_RUN, it forbids changing CPUID after successfully entering the guest (or
> > emulating instructions on VMX).
> >
> > I realize I'm being very pedantic, as a well-intended userspace is obviously not
> > going to change CPUID after -EINTR or whatever.  But I do want to highlight that
> > this approach is by no means bulletproof, and that what is/isn't allowed with
> > respect to guest CPUID isn't necessarily associated with what is/isn't "safe".
> > In other words, this check doesn't guarantee that userspace can't misuse KVM_SET_CPUID,
> > and on the flip side it disallows using KVM_SET_CPUID in ways that are perfectly ok
> > (if userspace is careful and deliberate).
> 
> All true but I don't see a 'bulletproof' approach here unless we start
> designing new KVM API for userspace and I don't think the problem here
> is a good enough justification for that.

Yeah, agreed.

> Another approach would be to name the "don't change CPUIDs after KVM_RUN at
> will" comment in the code a good enough sentinel and hope that no real world
> userspace actually does such things.

I'm ok with that, so long as the KVM code is kept simple (a single memcmp() 
qualifies) and we are quick to revert the whole thing if it turns out there's an
existing user and/or valid use case.
