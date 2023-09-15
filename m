Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 856807A1EAD
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 14:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234888AbjIOM0s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 08:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234882AbjIOM0p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 08:26:45 -0400
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14E2B186;
        Fri, 15 Sep 2023 05:26:36 -0700 (PDT)
Received: by mail-vs1-xe2c.google.com with SMTP id ada2fe7eead31-45106d2b5f8so772261137.2;
        Fri, 15 Sep 2023 05:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1694780795; x=1695385595; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kHElfVadtdeNXyKByLJb9K0voGTVAFQ8JwtjncMHuUE=;
        b=mwnRj1vdsx5yeOgA4nH2WUZOyB81aEVa6Xxz30qM1GZ+qVPUh16IbY2mxYTGBCQ86H
         I2tRqjJ+56TctM2Sr7DbAcXK/CIY6IgNx3uYsBKWa0rNv+WBa/IaxaZGafiPMYdk4ykw
         BWZVUUX3ydTYlop1hCqntJJjapIEbfh79M6dpBpWCKjEEetUM0pMvPJauWx7bynjdM1v
         0UzKM/cvEgk14caOM4BFtE0Ozzb0os8mhlYqR50DQ3qVX7t9fN8npolyu2e6SLFsH8io
         OZYppffBJ+8HMeISbABMQjfjn98rzcCogu20AHH7xstWzx3MszXu1lCxnFCYMcWVsg9o
         Wurw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694780795; x=1695385595;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kHElfVadtdeNXyKByLJb9K0voGTVAFQ8JwtjncMHuUE=;
        b=j88zxkg2cr4MciNc3lbVqiXKlcZg2RTm5Nym1//w5bxfUSN9yrHh8F+fxLtV05398Z
         9brH5flVnHZdciqddhPbx5CtKjg7D3N0YvD+dkmdvg0ApWryD5/R0JhIHic0OFJ3W97T
         pz1dIGmnS6JOY/lc476m1X8uGfAPiN0aQiJ8d/cLrKt9uKubpfBmivWoOJ4dWVj25XYi
         kNYfJmIgqW7cOB1LPYGKw/xBOnE0UM7MVVUnXjy4Uaj2TnKyFE+BKyY8FRofZY2e98lK
         Up1mW7uOxte4r7ssbDomf6qXLvi3X/2VN1cwkgJ9OETAOGAisTD2B6q5QC5TnBT4CZrQ
         4cmQ==
X-Gm-Message-State: AOJu0Yzk8a/uOdUzN9bPhcnPTvX27gV+xiXkv6TTCYlCccnEslCvsTe9
        yqZwQg+Cu1ZDMvi5tAj2FO4=
X-Google-Smtp-Source: AGHT+IEqyfCln0MI+0FEx+rL5pOXul0ADYwpkkHaDWIywOehi5BqQX9ftWEB0d4eS+Q6nScZOV5TkQ==
X-Received: by 2002:a67:ea86:0:b0:44e:8773:8c72 with SMTP id f6-20020a67ea86000000b0044e87738c72mr1606437vso.0.1694780794961;
        Fri, 15 Sep 2023 05:26:34 -0700 (PDT)
Received: from luigi.stachecki.net (pool-108-14-234-238.nycmny.fios.verizon.net. [108.14.234.238])
        by smtp.gmail.com with ESMTPSA id a7-20020a0ca987000000b0063f88855ef2sm1232563qvb.101.2023.09.15.05.26.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Sep 2023 05:26:34 -0700 (PDT)
Date:   Fri, 15 Sep 2023 08:27:06 -0400
From:   Tyler Stachecki <stachecki.tyler@gmail.com>
To:     Leonardo Bras <leobras@redhat.com>
Cc:     Dongli Zhang <dongli.zhang@oracle.com>, kvm@vger.kernel.org,
        seanjc@google.com, pbonzini@redhat.com, dgilbert@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
        bp@alien8.de, Tyler Stachecki <tstachecki@bloomberg.net>,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86/kvm: Account for fpstate->user_xfeatures changes
Message-ID: <ZQRNmsWcOM1xbNsZ@luigi.stachecki.net>
References: <20230914010003.358162-1-tstachecki@bloomberg.net>
 <ZQKzKkDEsY1n9dB1@redhat.com>
 <ZQLOVjLtFnGESG0S@luigi.stachecki.net>
 <93592292-ab7e-71ac-dd72-74cc76e97c74@oracle.com>
 <ZQOsQjsa4bEfB28H@luigi.stachecki.net>
 <ZQQKoIEgFki0KzxB@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZQQKoIEgFki0KzxB@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 15, 2023 at 04:41:20AM -0300, Leonardo Bras wrote:
> Other than that, all I can think of is removing the features from guest:
> 
> As you commented, there may be some features that would not be a problem 
> to be removed, and also there may be features which are not used by the 
> workload, and could be removed. But this would depend on the feature, and 
> the workload, beind a custom solution for every case.

Yes, the "fixup back" should be refined to pointed and verified cases.
 
> For this (removing guest features), from kernel side, I would suggest using 
> SystemTap (and eBPF, IIRC). The procedures should be something like:
> - Try to migrate VM from host with older kernel: fail
> - Look at qemu error, which features are missing?
> - Are those features safely removable from guest ? 
>   - If so, get an SystemTap / eBPF script masking out the undesired bits.
>   - Try the migration again, it should succeed.
> 
> IIRC, this could also be done in qemu side, with a custom qemu:
> - Try to migrate VM from host with older kernel: fail
> - Look at qemu error, which features are missing?
> - Are those features safely removable from guest ?
>   - If so, get a custom qemu which mask-out the desired flags before the VM 
>     starts
>   - Live migrate (can be inside the source host) to the custom qemu
>   - Live migrate from custom qemu to target host.
> - The custom qemu could be on a auxiliary host, and used only for this
> 
> Yes, it's hard, takes time, and may not solve every case, but it gets a 
> higher chance of the VM surviving in the long run.

Thank you for taking the time to throughly consider the issue and suggest some
ways out - I really appreciate it.

> But keep in mind this is a hack.
> Taking features from a live guest is not supported in any way, and has a 
> high chance of crashing the VM.

OK - if there's no interest in the below, I will not push for including this
patch in the kernel tree any longer. I do think the specific case below is what
a vast majority of KVM users will struggle with in the near future, though:

I have a test environment with Broadwell-based (have only AVX-256) guests
running under Skylake (PKRU, AVX512, ...) hypervisors.

I added some pr_debug statements to a guest kernel running under a hypervisor,
with said hypervisor containing neither your nor my patches, and printed the
guests view of `fpu_kernel_cfg.max_features` at boot. It was 0x7, or:
  XFEATURE_MASK_FP, XFEATURE_MASK_SSE, XFEATURE_MASK_YMM

Thus, I'm pretty sure that all that's happening here is that the guest's FP
context is having PKRU/ZMM. saved and restored needlessly by the hypervisor.
Stripping it on a live-migration does not seem to have any ill-effects in
all the testing I have done.

Cheers,
Tyler
