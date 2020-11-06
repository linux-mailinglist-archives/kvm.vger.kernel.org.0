Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E50E22A9B93
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 19:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbgKFSGQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 13:06:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27221 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726034AbgKFSGQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Nov 2020 13:06:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604685975;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=I0pHHCkh8h1ZrxEhKDliX3OCq4ruCPd3+x0l3KQUgGU=;
        b=IZLVqyHbA3Q2R3YcnMWZpt9vZwXP6g4X2YsFJLClWB+djQmZc+C4M6tXcDNhgxu/J4f8+t
        3+x5lPtVdh+rjNXYSqp943I/EdAzykLAyYOORzM8az2jxLp9qbvgW+ty9ESRdh3uS0+yAW
        YJjxv/M8drpum3Bor+2CN7Q6/HyK6bc=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-520-XvvJVrIOPPmlhXNLNKKoTQ-1; Fri, 06 Nov 2020 13:06:13 -0500
X-MC-Unique: XvvJVrIOPPmlhXNLNKKoTQ-1
Received: by mail-qk1-f198.google.com with SMTP id y8so1255179qki.12
        for <kvm@vger.kernel.org>; Fri, 06 Nov 2020 10:06:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=I0pHHCkh8h1ZrxEhKDliX3OCq4ruCPd3+x0l3KQUgGU=;
        b=H6bQpwvjV0gb2iIIeZJHu0082G2hieWM/NxL7jbaDPuYUIFqNNA9ZUxRt/gfxde5j+
         f9dRshvgzlbZ04WbbZ2tsZn+mxAQYTpxGCt3JlWDlfIUbnjifka4/YMj0cYvdBWvaasI
         0hC87PoX15Q8Ot803RZ8Sh2KIi7IDyvEkRwU27uFw+jeaYcoz9/JX0yzWSQhM5zXCabC
         nhkYkXuvyX2YlzDJkngaOd95U03vlGhoCij6fiWCJ5xHpjOS4usfD8+V44iVJrq3G9LK
         GWQyYICNDW4ehXChi+btWgFvVHjPPo6VoBOEWpaOaCYw3g2egDEVA4/Oe3hy4i74vkUk
         lXjQ==
X-Gm-Message-State: AOAM532qmv/Oe99B6SHAnYZLMWGs7LeUhVcDiPtSwaOuv6JcTfK7fVGA
        EW5VbHWgL4NBEcfft2nZdSAkZe9ljbAGsiFLggcDUM+rTEPqEQo4y2VjKBQOYJow78PPOhGsT7P
        TsGJ0BzMPMKmc
X-Received: by 2002:ac8:8c7:: with SMTP id y7mr2650793qth.278.1604685973241;
        Fri, 06 Nov 2020 10:06:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyWT3/EkzB1mX6LhVONygniIZnUOQZ1LF3NKmOlnmVvJ9+64XP0m9y9W4ZrQ8JA4RXLNIG+BQ==
X-Received: by 2002:ac8:8c7:: with SMTP id y7mr2650770qth.278.1604685972976;
        Fri, 06 Nov 2020 10:06:12 -0800 (PST)
Received: from xz-x1 (bras-vprn-toroon474qw-lp130-20-174-93-89-196.dsl.bell.ca. [174.93.89.196])
        by smtp.gmail.com with ESMTPSA id g11sm1011865qkl.30.2020.11.06.10.06.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 10:06:12 -0800 (PST)
Date:   Fri, 6 Nov 2020 13:06:10 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v13 13/14] KVM: selftests: Let dirty_log_test async for
 dirty ring test
Message-ID: <20201106180610.GC138364@xz-x1>
References: <20201001012044.5151-1-peterx@redhat.com>
 <20201001012239.6159-1-peterx@redhat.com>
 <6d5eb99e-e068-e5a6-522f-07ef9c33127f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6d5eb99e-e068-e5a6-522f-07ef9c33127f@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 06, 2020 at 12:27:54PM +0100, Paolo Bonzini wrote:
> On 01/10/20 03:22, Peter Xu wrote:
> > +
> > +static void vcpu_sig_handler(int sig)
> > +{
> > +	TEST_ASSERT(sig == SIG_IPI, "unknown signal: %d", sig);
> > +}
> > +
> 
> Unless you also use run->immediate_exit in vcpu_kick, this is racy.  The
> alternative is to _not_ set up a signal handler and instead block the
> signal.  KVM_SET_SIGNAL_MASK unblocks the signal inside the VM and on -EINTR
> sigwait accepts the signal (removes it from the set of pending signal).

Thanks for picking up the series!

I think you're right.  One trivial comment below:

> 
> This is a bit more complicated, but I think it's a good idea to do it this
> way for documentation purposes.  Here is the patch:
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c
> b/tools/testing/selftests/kvm/dirty_log_test.c
> index 4b404dfdc2f9..9a5b876b74af 100644
> --- a/tools/testing/selftests/kvm/dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> @@ -172,11 +172,6 @@ static pthread_t vcpu_thread;
>  /* Only way to pass this to the signal handler */
>  static struct kvm_vm *current_vm;
> 
> -static void vcpu_sig_handler(int sig)
> -{
> -	TEST_ASSERT(sig == SIG_IPI, "unknown signal: %d", sig);
> -}
> -
>  static void vcpu_kick(void)
>  {
>  	pthread_kill(vcpu_thread, SIG_IPI);
> @@ -484,13 +479,26 @@ static void *vcpu_worker(void *data)
>  	struct kvm_vm *vm = data;
>  	uint64_t *guest_array;
>  	uint64_t pages_count = 0;
> -	struct sigaction sigact;
> +	struct kvm_signal_mask *sigmask = alloca(offsetof(struct kvm_signal_mask,
> sigset)
> +						 + sizeof(sigset_t));
> +	sigset_t *sigset = (sigset_t *) &sigmask->sigset;
> 
>  	current_vm = vm;
>  	vcpu_fd = vcpu_get_fd(vm, VCPU_ID);
> -	memset(&sigact, 0, sizeof(sigact));
> -	sigact.sa_handler = vcpu_sig_handler;
> -	sigaction(SIG_IPI, &sigact, NULL);
> +
> +	/*
> +	 * SIG_IPI is unblocked atomically while in KVM_RUN.  It causes the
> +	 * ioctl to return with -EINTR, but it is still pending and we need
> +	 * to accept it with the sigwait.
> +	 */
> +	sigmask->len = 8;
> +	pthread_sigmask(0, NULL, sigset);

Not extremely important, but still better with SIG_BLOCK imho, since it seems
not all archs defined SIG_BLOCK as zero.

> +	vcpu_ioctl(vm, VCPU_ID, KVM_SET_SIGNAL_MASK, sigmask);
> +	sigaddset(sigset, SIG_IPI);
> +	pthread_sigmask(SIG_BLOCK, sigset, NULL);
> +
> +	sigemptyset(sigset);
> +	sigaddset(sigset, SIG_IPI);
> 
>  	guest_array = addr_gva2hva(vm, (vm_vaddr_t)random_array);
> 
> @@ -500,6 +508,11 @@ static void *vcpu_worker(void *data)
>  		pages_count += TEST_PAGES_PER_LOOP;
>  		/* Let the guest dirty the random pages */
>  		ret = ioctl(vcpu_fd, KVM_RUN, NULL);
> +		if (ret == -EINTR) {
> +			int sig = -1;
> +			sigwait(sigset, &sig);
> +			assert(sig == SIG_IPI);
> +		}
>  		log_mode_after_vcpu_run(vm, ret, errno);
>  	}
> 

-- 
Peter Xu

