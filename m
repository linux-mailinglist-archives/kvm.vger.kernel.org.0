Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3891D7A4D03
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 17:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbjIRPpn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 11:45:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjIRPpl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 11:45:41 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D86319A
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 08:44:09 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id 6a1803df08f44-65641c171cbso12423436d6.3
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 08:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1695051593; x=1695656393; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nmpxNm78kWfejPgZcglZLNttpcA+aOzIbjCglm6BlEY=;
        b=L/H1BY7MEKDSgPZ1aYSNrvoDsl93Ly57Hsb248T15VI5Sd8rgPxPu7TyfW4I67UxAH
         c+6UVT8R6MdGiom9tmHz8Xig1JWaQ09/qaU9j8shaXKq24z7w7IWQfWWvn365R5dl+9o
         Htmrjumtwoz9u0t7olLn0xuwSyZ/KVJaTAmmFc2H/AaZBsSax9okHL6PfNEv8sW5bk6r
         kIS+yomP9fnCi6k1jgfIzi8SG7t7fpm6uyfz5xAnVaO1Ul+wZ3+AEPt0nKoW7lAE046Y
         zMfHlXEYUbtuW6PQnM3MhmvVcI80L9+rAxqwZz32mxSTkliSmmSw2uuBvjw+nYV7WwMU
         KtdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695051593; x=1695656393;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nmpxNm78kWfejPgZcglZLNttpcA+aOzIbjCglm6BlEY=;
        b=kVPQCgYTX9ttoTx+m46d99N1sBlgJAe0RYd5VxBhe+sQYLm87uUqJ0Voy9jHjkl/Jv
         xKtXn+YexxWDaeQTh/bIbrV6bSzU1v1WKS4CKBsqY8GnOhcPGCYw04VOedi7IN2nvT6f
         NBfr22Se0FLp6RiIQeuYF+wR92wgrfSZrjFJnLszN+32CHn9rpi7MCv3S2ru/mo8cbH8
         sbExRX4JE9SC1WKDLcyqcCDQ7HnSKi9z9iKrlDjk65S4f2ixSt1mAaegZLPGhT8zAvep
         cfBcyqPW5WNYFFTwlzUgkflBzZcUNcbEBePkvLpjfahE3XPDNpu5gASvLskUAIBksOki
         3sRQ==
X-Gm-Message-State: AOJu0Yx/5DhvAqCpxHzBoD3qQArQvrne8WG1EfVeak7jUBsMnWj/QmIt
        fFg+6dFoR653BFeCIZ3wFUlzE189xnGjCAyEDBI=
X-Google-Smtp-Source: AGHT+IE5R1x821mq0T9l2iChMZP/v62/zLl2heVXzUEZigk+bm+oq/r6FG+m4/T/InbSxJxTjGr9mw==
X-Received: by 2002:a05:620a:2887:b0:76d:aa93:2e3c with SMTP id j7-20020a05620a288700b0076daa932e3cmr11157815qkp.24.1695050987781;
        Mon, 18 Sep 2023 08:29:47 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-26-201.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.26.201])
        by smtp.gmail.com with ESMTPSA id s4-20020a05620a16a400b0076d0312b8basm3183843qkj.131.2023.09.18.08.29.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 08:29:47 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qiGC2-0005S2-Ku;
        Mon, 18 Sep 2023 12:29:46 -0300
Date:   Mon, 18 Sep 2023 12:29:46 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Anish Ghulati <aghulati@google.com>,
        Venkatesh Srinivas <venkateshs@chromium.org>,
        Andrew Thornton <andrewth@google.com>
Subject: Re: [PATCH 06/26] KVM: Drop CONFIG_KVM_VFIO and just look at KVM+VFIO
Message-ID: <20230918152946.GJ13795@ziepe.ca>
References: <20230916003118.2540661-1-seanjc@google.com>
 <20230916003118.2540661-7-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230916003118.2540661-7-seanjc@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 15, 2023 at 05:30:58PM -0700, Sean Christopherson wrote:
> Drop KVM's KVM_VFIO Kconfig, and instead compile in VFIO support if
> and only if VFIO itself is enabled.  Similar to the recent change to have
> VFIO stop looking at HAVE_KVM, compiling in support for talking to VFIO
> just because the architecture supports VFIO is nonsensical.
> 
> This fixes a bug where RISC-V doesn't select KVM_VFIO, i.e. would silently
> fail to do connect KVM and VFIO, even though RISC-V supports VFIO.  The
> bug is benign as the only driver in all of Linux that actually uses the
> KVM reference provided by VFIO is KVM-GT, which is x86/Intel specific.

Hmm, I recall that all the S390 drivers need it as well.

static int vfio_ap_mdev_open_device(struct vfio_device *vdev)
{
        struct ap_matrix_mdev *matrix_mdev =
                container_of(vdev, struct ap_matrix_mdev, vdev);

        if (!vdev->kvm)
                return -EINVAL;

        return vfio_ap_mdev_set_kvm(matrix_mdev, vdev->kvm);


I wonder if we should be making the VFIO drivers that need the kvm to
ask for it? 'select CONFIG_NEED_VFIO_KVM' or something?

Regardless, I fully agree with getting rid of the arch flag.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

> --- a/virt/kvm/Makefile.kvm
> +++ b/virt/kvm/Makefile.kvm
> @@ -6,7 +6,9 @@
>  KVM ?= ../../../virt/kvm
>  
>  kvm-y := $(KVM)/kvm_main.o $(KVM)/eventfd.o $(KVM)/binary_stats.o
> -kvm-$(CONFIG_KVM_VFIO) += $(KVM)/vfio.o
> +ifdef CONFIG_VFIO
> +kvm-y += $(KVM)/vfio.o
> +endif

I wonder if kvm-m magically works in kbuild so you don't need the ifdef?

Jason
