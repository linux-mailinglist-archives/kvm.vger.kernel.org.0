Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C88B3E7C1A
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 17:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243023AbhHJPZQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 11:25:16 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:44166 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240233AbhHJPZQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Aug 2021 11:25:16 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1628609093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UpPdbmK+IyY5b5MzF5Ojzi80tfkkf5xlvxuGJkfoOdc=;
        b=p7iZreD5Rooz9Hwo4NcdHy+AB3YrgKdPG3BybQlUdZ/E+o0/FF0gQPvYkWExkwej+IwiDC
        9cOCYnbYj0aeE6H8gah+koP1rUDamZqtXDavXuGnEFWSH9iBp2067Y5X/4LJ2L5zp+yysi
        tRDjiCnAW75JMK7bLCx9jXekkqqyFNTUcUD6eLL9uruF1UCnsgkaabJZLLmhvdloc6ySL7
        M/poFZp8pOG4gU6R/R/vmRYdQ84n0NRnwmrxohM8oeTGks53BMMbVFt3q/KMK3MSYk6DNW
        69JfZWOvhMPEYxs0AXYEJTnfAGnJvBbRF2lclvorr7TXbyfdvp3YIEhpGl3E1Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1628609093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UpPdbmK+IyY5b5MzF5Ojzi80tfkkf5xlvxuGJkfoOdc=;
        b=NszASky6GtZ0Ep4P8nZEE3cXwhjEbHy0eSd75nfCqxXLGGLDlSQB7L/IBZUbWVtwfz+uWK
        0KcKEWYF3ULr4UCQ==
To:     Hikaru Nishida <hikalium@chromium.org>,
        linux-kernel@vger.kernel.org, dme@dme.org, mlevitsk@redhat.com
Cc:     suleiman@google.com, Hikaru Nishida <hikalium@chromium.org>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        John Stultz <john.stultz@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        x86@kernel.org
Subject: Re: [v2 PATCH 3/4] x86/kvm: Add host side support for virtual
 suspend time injection
In-Reply-To: <20210806190607.v2.3.Ib0cb8ecae99f0ccd0e2814b310adba00b9e81d94@changeid>
References: <20210806100710.2425336-1-hikalium@chromium.org>
 <20210806190607.v2.3.Ib0cb8ecae99f0ccd0e2814b310adba00b9e81d94@changeid>
Date:   Tue, 10 Aug 2021 17:24:52 +0200
Message-ID: <87o8a5qq4b.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 06 2021 at 19:07, Hikaru Nishida wrote:
>  
> +#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING
> +void kvm_arch_timekeeping_inject_sleeptime(const struct timespec64 *delta)
> +{
> +	struct kvm_vcpu *vcpu;
> +	u64 suspend_time_ns;
> +	struct kvm *kvm;
> +	s64 adj;
> +	int i;
> +
> +	suspend_time_ns = timespec64_to_ns(delta);
> +	adj = tsc_khz * (suspend_time_ns / 1000000);
> +	/*
> +	 * Adjust TSCs on all vcpus and kvmclock as if they are stopped
> +	 * during host's suspension.
> +	 * Also, cummulative suspend time is recorded in kvm structure and
> +	 * the update will be notified via an interrupt for each vcpu.
> +	 */
> +	mutex_lock(&kvm_lock);

This is invoked from with timekeeper_lock held with interrupts
disabled. How is a mutex_lock() supposed to work here?

Thanks,

        tglx
