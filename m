Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F82C5EB607
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 01:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiIZX5N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 19:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiIZX5L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 19:57:11 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF5C861D66
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 16:57:10 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id i15-20020a17090a4b8f00b0020073b4ac27so8484155pjh.3
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 16:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=zQPuagMIbE4cikFM2iPxB5TsnSzTvczOnRg0dvLUmOw=;
        b=NSQKM1A1vUHmLmcwr2oVQqHUQtYQoAKrGw4fNN87UyXeN+Rbw9IIft4sQUtZmv19rw
         NIFpDcFQLTDBVFWg3DHt+9M9niJzV7iOJLFZVj5ZDFhSrnksvz7KdbzQ1xXAdto4u+jR
         /MgS2JRAGFzLdHQoCZfrRLzQnTFE9W2I0uBXzNOI2onE6VPI5HnaNdEoKDCS661gzAEB
         mPktQ9B4N072nWuwOJ0cPXM3u21i3w+hWROiZ8kC7iZkDrKlIqEULSu0/5SuSLrHRTKl
         F6NroSiBSZ2tg7aGEm7Phjp3Lrp0p1/Ol6hb+tQpBzifzH3QXRdPAJ/5G0roZyjTXDJ6
         xE0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=zQPuagMIbE4cikFM2iPxB5TsnSzTvczOnRg0dvLUmOw=;
        b=pFmHOoXcmLlBXmbrQKWsPnHOvR1UBaNWLwuFlQd6TQmjdjiZYq4+WMgJOpPir+2y35
         QaQakpHqRhZdvNbnheRBOF9zeQ0Qnnsal6+buPawchNmKJMte99DDJCGyasaKZO4y1GF
         PjgLg9AQzZHKVa4jwepGACSICfIDLGHHoRYYlzXGEoEfqFzBjmuQ1+51DYMWDuQ9neyj
         Wz9h/ILMl9fxnOKWUqXMz5bSDulThJbcVzoU73sSAkgO4VPVVGLoNGIyXW5H6G7BBjPp
         rFrW3WELkjTpSVbyodmuCt3s/jbuVAEv0L1k1rdvn0oiSfYGImxDY5hWAVX2Ld/d5oXn
         BcTQ==
X-Gm-Message-State: ACrzQf1KfNGUdSNL5tb/0LKMxekySmcsfFUGoNza9Ig8tvvWlvHyrc0Y
        FoPeBkBznjjleNuOimMxCL0Pbg==
X-Google-Smtp-Source: AMsMyM4/nHDlLd4Fiw+6AxnfW3bOGZKp46G7Iyi/kIXuDW7YAPGzy5QiRWxTcThmB862XuSVxdij5w==
X-Received: by 2002:a17:90b:1e44:b0:202:b347:2daf with SMTP id pi4-20020a17090b1e4400b00202b3472dafmr1381068pjb.34.1664236630344;
        Mon, 26 Sep 2022 16:57:10 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i1-20020aa796e1000000b00540c3b6f32fsm98533pfq.49.2022.09.26.16.57.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 16:57:10 -0700 (PDT)
Date:   Mon, 26 Sep 2022 23:57:06 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        kvm list <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: selftests: Skip tests that require EPT when it is
 not available
Message-ID: <YzI8UrIOpnnqnCkZ@google.com>
References: <20220926171457.532542-1-dmatlack@google.com>
 <YzIdfkovobW3w/zk@google.com>
 <CALzav=d-4a8yPxPUuHNh1884Z4Pe_0ewMwnunGK_jAAvr9L-vw@mail.gmail.com>
 <YzInp2jRH7Bq41gV@google.com>
 <CALzav=dcFTB=ikZQH9OEZVT27iXSntuOH3NV1jr91JaYzVMVkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=dcFTB=ikZQH9OEZVT27iXSntuOH3NV1jr91JaYzVMVkA@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 26, 2022, David Matlack wrote:
> On Mon, Sep 26, 2022 at 3:29 PM Sean Christopherson <seanjc@google.com> wrote:
> > If someone wants to improve the memstress framework, a hook can be added for probing
> > nested requirements.  In other words, IMO this is a shortcoming of the memstress code,
> > not a valid reason to shove the requirement down in common code.
> 
> Sorry I forgot to ask this in my previous reply... Why do you prefer
> to decouple test requirements from the test setup code? There is a
> maintenance burden to such an approach, so I want to understand the
> benefit. e.g. I forsee myself having to send patches in the future to
> add TEST_REQUIRE(kvm_cpu_has_ept()), because someone added a new VMX
> test and forgot to test with ept=N.

I don't necessarily prefer decoupling, what I really dislike is having the TEST_REQUIRE()
buried deep down, because it's not clear from the reader whether or not TDP/EPT
is truly required, and if it is a hard requirement, it's not easily visible to
the reader.  The print_skip() output helps, but that obviously requires actually
trying to run the test.

E.g. I wouldn't object as much if perf_test_setup_nested() looked like this:

  void perf_test_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu *vcpus[])
  {
	struct vmx_pages *vmx, *vmx0 = NULL;
	struct kvm_regs regs;
	vm_vaddr_t vmx_gva;
	int vcpu_id;

	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));
	TEST_REQUEST(perf_test_setup_ept(vm));

	for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++) {
		vmx = vcpu_alloc_vmx(vm, &vmx_gva);

		...
	}
  }

I'd still object to some extent, because that obfuscates that the requirement is
that KVM supports nested EPT, e.g. one might wonder why EPT setup can fail, and
because there's really no need for prepare_eptp() to exist.  If/when "struct vmx_page"
is a thing[*], then prepare_eptp() goes away and becomes

	vm_alloc_vmx_page(<pointer to a struct vmx_page>);

and so there's not even a real place to shove the TEST_REQUIRE().

And I 100% agree there's a maintenance burden, but it's fairly small and it's
only paid once per test, whereas making it even the tiniest bit difficult to
understand a test's requirements incurs some amount of cost every time someone
reads the code.

E.g. the memstress code ends up looking something like this:

  void perf_test_setup_ept(struct vmx_page *eptp, struct kvm_vm *vm)
  {
	uint64_t start, end;

	vm_alloc_vmx_page(eptp)

	/*
	 * Identity map the first 4G and the test region with 1G pages so that
	 * KVM can shadow the EPT12 with the maximum huge page size supported
	 * by the backing source.
	 */
	nested_identity_map_1g(eptp, vm, 0, 0x100000000ULL);

	start = align_down(perf_test_args.gpa, PG_SIZE_1G);
	end = align_up(perf_test_args.gpa + perf_test_args.size, PG_SIZE_1G);
	nested_identity_map_1g(eptp, vm, start, end - start);
  }

  void perf_test_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu *vcpus[])
  {
	struct vmx_pages *vmx;
	struct vmx_page eptp;
	struct kvm_regs regs;
	vm_vaddr_t vmx_gva;
	int vcpu_id;

	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));
	TEST_REQUEST(kvm_cpu_has_ept());

	perf_test_setup_ept(eptp, vm);

	for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++) {
		vmx = vcpu_alloc_vmx(vm, &vmx_gva);

		memcpy(vmx->eptp, &eptp, sizeof(eptp));

		/*
		 * Override the vCPU to run perf_test_l1_guest_code() which will
		 * bounce it into L2 before calling perf_test_guest_code().
		 */
		vcpu_regs_get(vcpus[vcpu_id], &regs);
		regs.rip = (unsigned long) perf_test_l1_guest_code;
		vcpu_regs_set(vcpus[vcpu_id], &regs);
		vcpu_args_set(vcpus[vcpu_id], 2, vmx_gva, vcpu_id);
	}
  }

and at that point, IMO adding a helper to assert/require EPT is contrived and not
necessarily a net positive.

[*] https://lore.kernel.org/all/YwznLAqRb2i4lHiH@google.com
