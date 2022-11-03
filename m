Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 937A26182E0
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 16:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbiKCPav (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 11:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbiKCPac (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 11:30:32 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4A031C436
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 08:30:02 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id b29so1907547pfp.13
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 08:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UyUe+HbRzSrTdJquQCMiaXWC2coZG28I37xguDaJaYg=;
        b=JxP3em5mMEo8M/seyYjwqQClKWueZhrkefM7iopEbtJ9U0ARhXsBBlBaHvB0YZ+mCq
         7I2lDIbzgsTnUJXXFFd+Mf2MRkvMQ3d/mi120+0k+co+feliF2fGnlDGLipP3oo4jHIs
         yhCQnzB0LNdLsoCiyP2ThdGCDug/wevVBzx4ZCIoRVJzM62ULFanZrMyKnrfoLhgGw7L
         LE3NJVvLI80qGdb5QUdNBUYtcEfD6sTxNonp/rLGuh5no7R8ACiBwreWQkoFJnyoE1Nq
         joZ/uzznkWHqO7mwwbSR52gm1kYa+vf+hliw2Y9f1o05+cN6N5swUWJ7vJszMr5BEKoW
         HTcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UyUe+HbRzSrTdJquQCMiaXWC2coZG28I37xguDaJaYg=;
        b=J21F+4UsrSlE/rDbYLw25rkqoRtF2BgDjl5KfOjuk22eSEjE1aQYJ69Dnsbn4XVSDf
         S0xDmlNNHBacW3oRIhMxvydgfiE3RShiys8B1YvbYZFZtTtDY91KycsjKup9nc+4wQGF
         wEiiOq/CmhKLy5/G8YOvHoTe8FJMmvqCveFZh9/8hyaNlN1XNXUSwm5D3d2+5Ru80r9R
         6WNGztKR9qx3wgeRiIqZE8jDWYW3wCZPhvgAkitAZXHyemWxhY5CTu2yO4/WO2CdHGUM
         0SOaRvhZTx5UW++NnVAmg+8Zv7duEkAekNCVk0YaIL2bsXCDAAW+n5Z4SWK9f7bQWVoE
         cGww==
X-Gm-Message-State: ACrzQf09JlEsReiDjUI7xZYTxUEGfjagsHZAVGf6Rh6gK4VnPrv09Dv/
        4umI9nY1BxIeg5hPIMhXjrGAzg==
X-Google-Smtp-Source: AMsMyM6by5WQXi0G4lBZGaavWsGrxKC8DeWyAUbAtvZsM8BboB9ucyemIyMYLKoI4FadI1MlyxYOPw==
X-Received: by 2002:a05:6a00:1996:b0:56d:a845:5789 with SMTP id d22-20020a056a00199600b0056da8455789mr17697890pfl.59.1667489402026;
        Thu, 03 Nov 2022 08:30:02 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id f3-20020a170902f38300b0017a018221e2sm835452ple.70.2022.11.03.08.30.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 08:30:01 -0700 (PDT)
Date:   Thu, 3 Nov 2022 15:29:58 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Chao Gao <chao.gao@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuan Yao <yuan.yao@intel.com>
Subject: Re: [PATCH 17/44] KVM: arm64: Do arm/arch initialiation without
 bouncing through kvm_init()
Message-ID: <Y2Pedr1MYt/P1uL0@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-18-seanjc@google.com>
 <dd59d579-4a4e-6db2-eac4-6c5c3ab71fd3@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dd59d579-4a4e-6db2-eac4-6c5c3ab71fd3@linaro.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 03, 2022, Philippe Mathieu-Daudé wrote:
> Hi Sean,
> 
> On 3/11/22 00:18, Sean Christopherson wrote:
> > Move arm/arch specific initialization directly in arm's module_init(),
> > now called kvm_arm_init(), instead of bouncing through kvm_init() to
> > reach kvm_arch_init().  Invoking kvm_arch_init() is the very first action
> > performed by kvm_init(), i.e. this is a glorified nop.
> > 
> > Making kvm_arch_init() a nop will allow dropping it entirely once all
> > other architectures follow suit.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   arch/arm64/kvm/arm.c | 25 ++++++++++++++++---------
> >   1 file changed, 16 insertions(+), 9 deletions(-)
> 
> >   /* NOP: Compiling as a module not supported */
> >   void kvm_arch_exit(void)
> >   {
> > -	kvm_unregister_perf_callbacks();
> 
> Doesn't this belong to the previous patch?

No, but the above changelog is a lie, there is very much a functional change here.

The goal of the previous patch is to fix the error paths in kvm_arch_init(), a.k.a.
kvm_arm_init().  After fixing kvm_arch_init(), there are still bugs in the sequence
as a whole because kvm_arch_exit() doesn't unwind other state, e.g. kvm_arch_exit()
should really look something like:

  void kvm_arch_exit(void)
  {
	teardown_subsystems();

	if (!is_kernel_in_hyp_mode())
		teardown_hyp_mode();

	kvm_arm_vmid_alloc_free();

	if (is_protected_kvm_enabled())
		???	
  }

Becuase although the comment "NOP: Compiling as a module not supported" is correct
about KVM ARM always having to be built into the kernel, kvm_arch_exit() can still
be called if a later stage of kvm_init() fails.

But rather than add a patch to fix kvm_arch_exit(), I chose to fix the bug by
moving code out of kvm_arch_init() so that the unwind sequence established in the
previous patch could be reused.

Except I managed to forget those details when writing the changelog.  The changelog
should instead be:

  KVM: arm64: Do arm/arch initialization without bouncing through kvm_init()
  
  Do arm/arch specific initialization directly in arm's module_init(), now
  called kvm_arm_init(), instead of bouncing through kvm_init() to reach
  kvm_arch_init().  Invoking kvm_arch_init() is the very first action
  performed by kvm_init(), so from a initialization perspective this is a
  glorified nop.
  
  Avoiding kvm_arch_init() also fixes a mostly benign bug as kvm_arch_exit()
  doesn't properly unwind if a later stage of kvm_init() fails.  While the
  soon-to-be-deleted comment about compiling as a module being unsupported
  is correct, kvm_arch_exit() can still be called by kvm_init() if any step
  after the call to kvm_arch_init() succeeds.

  Add a FIXME to call out that pKVM initialization isn't unwound if
  kvm_init() fails, which is a pre-existing problem inherited from
  kvm_arch_exit().

  Making kvm_arch_init() a nop will also allow dropping kvm_arch_init() and
  kvm_arch_exit() entirely once all other architectures follow suit.
