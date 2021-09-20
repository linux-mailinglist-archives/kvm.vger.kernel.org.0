Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFC841171E
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 16:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240569AbhITOe1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 10:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240471AbhITOeZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Sep 2021 10:34:25 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54A08C061760
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 07:32:58 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id j14so4069987plx.4
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 07:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nL5TmwxPTvhZweAL7Y0qoF71j04RAvcJALk7EraXAg8=;
        b=DJsXCQaYfz1mZOh4nQHkuTTUQnScERyCBlvFTYx99Oexy0Na3xjXj/EqIBEp9hMnXo
         x+19D5CNiOgmX1Rbpf5SFs+L6BA5BodiGbHV2ABgsD0DiLpSppK411Rpru+6RyfRGFg4
         /PWE25izSBPfVkLmgPpZ66aMoBo/exwK35d0S3yt4cPx5JE1N2Pmej2eMMOnZkLCvCLc
         hVek83h8+ncFmAASX6gN2m2KMgpXGVDs3HXmiLPktHY500d7/3WPLsspgfxfRavboMuI
         0mdPzzqKK89StK7DXoBCJo8627Up1M75Yt0Y08tO9N1EukgQtDYE+wHAov81bUZlj89q
         P0TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nL5TmwxPTvhZweAL7Y0qoF71j04RAvcJALk7EraXAg8=;
        b=z/xqQvTuc33HEYhlMoIjz6dZEhGp2xB+S22kn0b9fRudVatjhtYFN7AwGNLhynutox
         em3zzEecm1d77xednhs+INQN7QZcimdIGA9b8tb2cKrRxlsIiMM1Lsx6QPXQXh+g6Ht+
         U+hN6xesnFPKpxOu6dHCfnxsHzRPix9co2sQTWfMTLCqcchlvctd6nNNdIlTr0g0gJmK
         TFwXZuGqoFPLSLGnUJsbIn5EozOpvJn7FT/iBvPqqDma2ZjAXnCEdrkQaQLoM1EZ1SCO
         Y4Z1NTi8OdUCUa0g9bIGDixlewd+CXflwC/4IF/7MsVxVqFGAuQIH1k6hGXrNtiyIPIz
         /Izw==
X-Gm-Message-State: AOAM532X0dWYjJSdZlAtvdYFiLkQsjNmGs7BaBrkBwKnKOSSxjIy2Y0/
        wfe/Y6VuI20kSjckWFgzagvl5w==
X-Google-Smtp-Source: ABdhPJyYoGAPanf2H3zZRj8cGFPIuPjesscOredIZovbCkbVgkr4UMGOFG9NDNYM8w9zeMFmR1tTrA==
X-Received: by 2002:a17:90b:1c08:: with SMTP id oc8mr16263050pjb.138.1632148377565;
        Mon, 20 Sep 2021 07:32:57 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j6sm14995699pgh.17.2021.09.20.07.32.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 07:32:57 -0700 (PDT)
Date:   Mon, 20 Sep 2021 14:32:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Hao Sun <sunhao.th@gmail.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        bp@alien8.de, hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org
Subject: Re: general protection fault in rcu_segcblist_enqueue
Message-ID: <YUiblFnBdSs8CwA+@google.com>
References: <CACkBjsbiT96KTK2Cjf0PxyOFRs8w0GPUWdR=97oVxSJMvDxNJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACkBjsbiT96KTK2Cjf0PxyOFRs8w0GPUWdR=97oVxSJMvDxNJQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Sep 18, 2021, Hao Sun wrote:
> Hello,
> 
> When using Healer to fuzz the latest Linux kernel, the following crash
> was triggered.
> 
> HEAD commit: ff1ffd71d5f0 Merge tag 'hyperv-fixes-signed-20210915
> git tree: upstream
> console output:
> https://drive.google.com/file/d/1I3q-rH7yJXxmr16cI418avyA_tHdoOVE/view?usp=sharing
> kernel config: https://drive.google.com/file/d/1zXpDhs-IdE7tX17B7MhaYP0VGUfP6m9B/view?usp=sharing
> 
> Sorry, I don't have a reproducer for this crash, hope the symbolized
> report can help.
> If you fix this issue, please add the following tag to the commit:
> Reported-by: Hao Sun <sunhao.th@gmail.com>
> 
> general protection fault, probably for non-canonical address

...

>  srcu_gp_start_if_needed+0x145/0xbf0 kernel/rcu/srcutree.c:823
>  __synchronize_srcu+0x1f4/0x270 kernel/rcu/srcutree.c:929

Duplicate of https://lkml.kernel.org/r/CACkBjsZ55MKvOBGYJyQxwHBCQOTP=Lz=yfYwJtdOzNiT59E38g@mail.gmail.com

>  kvm_mmu_uninit_vm+0x18/0x30 arch/x86/kvm/mmu/mmu.c:5711
>  kvm_arch_destroy_vm+0x42b/0x5b0 arch/x86/kvm/x86.c:11331
>  kvm_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:1094 [inline]
>  kvm_dev_ioctl_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:4583 [inline]
>  kvm_dev_ioctl+0x1508/0x1aa0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4638
