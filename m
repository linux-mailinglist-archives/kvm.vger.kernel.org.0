Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C1D4139DC
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 20:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232600AbhIUSQw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 14:16:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28480 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232572AbhIUSQt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Sep 2021 14:16:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632248120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7Y+LZFJjnOBJ8l+4LgEza9wG6jZfQeGN1fAATCstXMA=;
        b=C3sFyEF/s7S8P4CMHXb2IK1lf5RKvbjiZXKiJAiDtU0xJ9ajhoazHhA77YIAGIER3aGcQy
        xG/53Y0xMcBgwnOGHLvojij7sukSfRyo1nlJ/TPEWaTR27Aye2QBv/PH4EyomGc4Cidr7Q
        XZuyvU6LDqTyKU60x2pdCT9KNJtSl0s=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-502-kyazWpfwNWqwZrq9g_2VMQ-1; Tue, 21 Sep 2021 14:15:19 -0400
X-MC-Unique: kyazWpfwNWqwZrq9g_2VMQ-1
Received: by mail-ed1-f69.google.com with SMTP id z6-20020a50cd06000000b003d2c2e38f1fso19887032edi.1
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 11:15:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7Y+LZFJjnOBJ8l+4LgEza9wG6jZfQeGN1fAATCstXMA=;
        b=5CjUioieqsHMpXDVqK0RH5s5FBofdlvsmX7v9/ZDVIItsDO3RS4am/cFPkpWrxpvEQ
         YRrXN9rth+aAQC0MRew0TMv3ZvsH8FuBboP/6UrRo6U/Wc1j31yLG5G6Yugh/gZuN7Qf
         p+EKvykL/QGNrsBfcJTWyhMii81/zELxLlmttadX5Ux2ApulCopCIrJAJBVntMJ6o9Gq
         wRay24rHCLAtHbbPU1/ywuLmBY4jfySLEaDUvis+B1Utstl/ecENBWHc/snIRLjQrIbK
         LsUfMFyhowXSC2bb+WCwAUe2czqoMA1nRr2/z/0xuxmWbe0jeCFHNuhpLs/8E+i7D2Yv
         Bv7Q==
X-Gm-Message-State: AOAM5308QGQehB2KkbZru8MjZ6D7xYqcxJKjHS5UvT0uce8MwIKbE+v9
        SjCTTi27m5oICvBTrJLnJLTUvSz4gFNg7l+/BYmfg9MRtxBizJO454dzUIr30XDyjwd0UV/aLSZ
        Dlh31qpZtBaKt
X-Received: by 2002:a50:bf0f:: with SMTP id f15mr22926555edk.196.1632248117828;
        Tue, 21 Sep 2021 11:15:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwfHWJ4wAe2ChpPcagdjNe/66n3H1pQckVdJn25bnW5kRCJAWG1M9fYCNrB0/pDsYWHus9+OQ==
X-Received: by 2002:a50:bf0f:: with SMTP id f15mr22926532edk.196.1632248117560;
        Tue, 21 Sep 2021 11:15:17 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
        by smtp.gmail.com with ESMTPSA id d15sm6112895ejo.4.2021.09.21.11.15.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 11:15:13 -0700 (PDT)
Date:   Tue, 21 Sep 2021 20:15:10 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH] selftests: KVM: Gracefully handle missing vCPU features
Message-ID: <20210921181510.senhdb3itkcjfonb@gator.home>
References: <20210818212940.1382549-1-oupton@google.com>
 <bd8abbac-925b-ff1e-f494-8f1c21fe7bd1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd8abbac-925b-ff1e-f494-8f1c21fe7bd1@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 21, 2021 at 08:00:02PM +0200, Paolo Bonzini wrote:
> On 18/08/21 23:29, Oliver Upton wrote:
> > An error of ENOENT for the KVM_ARM_VCPU_INIT ioctl indicates that one of
> > the requested feature flags is not supported by the kernel/hardware.
> > Detect the case when KVM doesn't support the requested features and skip
> > the test rather than failing it.
> > 
> > Cc: Andrew Jones <drjones@redhat.com>
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> > Applies to 5.14-rc6. Tested by running all selftests on an Ampere Mt.
> > Jade system.
> > 
> >   .../testing/selftests/kvm/lib/aarch64/processor.c | 15 ++++++++++++++-
> >   1 file changed, 14 insertions(+), 1 deletion(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > index 632b74d6b3ca..b1064a0c5e62 100644
> > --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > @@ -216,6 +216,7 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *ini
> >   {
> >   	struct kvm_vcpu_init default_init = { .target = -1, };
> >   	uint64_t sctlr_el1, tcr_el1;
> > +	int ret;
> >   	if (!init)
> >   		init = &default_init;
> > @@ -226,7 +227,19 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *ini
> >   		init->target = preferred.target;
> >   	}
> > -	vcpu_ioctl(vm, vcpuid, KVM_ARM_VCPU_INIT, init);
> > +	ret = _vcpu_ioctl(vm, vcpuid, KVM_ARM_VCPU_INIT, init);
> > +
> > +	/*
> > +	 * Missing kernel feature support should result in skipping the test,
> > +	 * not failing it.
> > +	 */
> > +	if (ret && errno == ENOENT) {
> > +		print_skip("requested vCPU features not supported; skipping test.");
> > +		exit(KSFT_SKIP);
> > +	}
> > +
> > +	TEST_ASSERT(!ret, "KVM_ARM_VCPU_INIT failed, rc: %i errno: %i (%s)",
> > +		    ret, errno, strerror(errno));
> >   	/*
> >   	 * Enable FP/ASIMD to avoid trapping when accessing Q0-Q15
> > 
> 
> Queued, thanks.
> 

I'd rather we don't queue this. It'd be better, IMO, for the unit test to
probe for features and then skip the test, if that's what it wants to do,
when they're not present. I'd rather not have test skipping decisions
made in the library code, which may not be what the unit test developer
expects. Anyway, the 'skipping test' substring would be printed twice with
this patch.

Thanks,
drew

