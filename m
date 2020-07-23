Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6386222B312
	for <lists+kvm@lfdr.de>; Thu, 23 Jul 2020 17:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728482AbgGWP7h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jul 2020 11:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbgGWP7h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jul 2020 11:59:37 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28669C0619DC
        for <kvm@vger.kernel.org>; Thu, 23 Jul 2020 08:59:37 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id d27so4753488qtg.4
        for <kvm@vger.kernel.org>; Thu, 23 Jul 2020 08:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2EtxXZTz1kWJ0O2qTRyRyFGBjpXTKARYoyOSnP+i+Z8=;
        b=VJOz/w2ybxBPDrWIucdRYvA/77lMC2/FtrhIlZAdU9I2iWr+k05fQkXhmW6/gHmMBI
         fPGi0hVS8Q2oNReoMRsf5TMZGWAkU+BAwL3shApQsP7X2RUSBCkngA8mfmGEfhVc4gI1
         HHtuf8I0aJSr6RnGJ7RVYgJwzoPbLour7hSbzfIGLMzoUM1zjp0jQcNlD0O9oQC97Gsi
         cLsXUnH/e4mAW/th0+cLZdRjXRTW86gXySMbDMrYeyPlZy1Hdtk2wv5znnc4CzaHxNLx
         pM7Wa+xwhOnOR4Sce/ht00bCm4CF1gys0Yp5wuSO+wr52pcpxnEot5xpwqvAJJEJ2hml
         0zlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2EtxXZTz1kWJ0O2qTRyRyFGBjpXTKARYoyOSnP+i+Z8=;
        b=NNiM7R79lwaabww9uOu+ynfpDYigp/ytH1J88naLzmzCwXzasKIdulj2Tof47rJe9i
         +GSDgy4xsWNL+LzRH7QVi1hTOKDNfdpE9R0Cax2Sm0AGjm/1vLLqigdDR90q7E6ecuXz
         fcFBAG3Dlx/AkERum31DcXgt3b6LtZ1lENwNFODTov6StBm5L/OGYd1qa0P06CAWd2ZK
         IGKTtML97sY3cQ8M8TNrY5aEFafzIOVXn3OjwaUUH1QSMIh3rjcnaKCjXGbQ6YK84b+V
         ScRYO8EK+8/kHFlPCO81ul/XEA//ko7Tv52MOI9dxh4KsUkcNHADVS+BHvcJGQZbM6Of
         tm2g==
X-Gm-Message-State: AOAM532o8Em5IUq7mlojq4uhBSxH5jIX1QkiR3rftJW5pW3cdUnU//QI
        r74Yejz2amcpTQ7iq1LUS8Q=
X-Google-Smtp-Source: ABdhPJxN1siVEMQTxmAZmPE5w2CdYkPu1C7QJuy61MtFQ71rjCZxMEOLNGHX4IkN9Sarmpsnt1p9Nw==
X-Received: by 2002:ac8:345c:: with SMTP id v28mr4912521qtb.171.1595519976114;
        Thu, 23 Jul 2020 08:59:36 -0700 (PDT)
Received: from ubuntu-n2-xlarge-x86 ([2604:1380:45d1:2600::1])
        by smtp.gmail.com with ESMTPSA id v58sm1841331qtj.56.2020.07.23.08.59.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 08:59:35 -0700 (PDT)
Date:   Thu, 23 Jul 2020 08:59:34 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, kernel-team@android.com,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH] KVM: arm64: Prevent vcpu_has_ptrauth from generating OOL
 functions
Message-ID: <20200723155934.GA3929837@ubuntu-n2-xlarge-x86>
References: <20200722162231.3689767-1-maz@kernel.org>
 <20200723025142.GA361584@ubuntu-n2-xlarge-x86>
 <0fab73670fa24d1c08711991133e4255@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0fab73670fa24d1c08711991133e4255@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 23, 2020 at 09:17:15AM +0100, Marc Zyngier wrote:
> Hi Nathan,
> 
> On 2020-07-23 03:51, Nathan Chancellor wrote:
> > On Wed, Jul 22, 2020 at 05:22:31PM +0100, Marc Zyngier wrote:
> > > So far, vcpu_has_ptrauth() is implemented in terms of
> > > system_supports_*_auth()
> > > calls, which are declared "inline". In some specific conditions (clang
> > > and SCS), the "inline" very much turns into an "out of line", which
> > > leads to a fireworks when this predicate is evaluated on a non-VHE
> > > system (right at the beginning of __hyp_handle_ptrauth).
> > > 
> > > Instead, make sure vcpu_has_ptrauth gets expanded inline by directly
> > > using the cpus_have_final_cap() helpers, which are __always_inline,
> > > generate much better code, and are the only thing that make sense when
> > > running at EL2 on a nVHE system.
> > > 
> > > Fixes: 29eb5a3c57f7 ("KVM: arm64: Handle PtrAuth traps early")
> > > Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> > > Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > 
> > Thank you for the quick fix! I have booted a mainline kernel with this
> > patch with Shadow Call Stack enabled and verified that using KVM no
> > longer causes a panic.
> 
> Great! I'll try and ferry this to mainline  as quickly as possible.

Awesome, I will keep an eye out.

> > Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
> > Tested-by: Nathan Chancellor <natechancellor@gmail.com>
> > 
> > For the future, is there an easy way to tell which type of system I am
> > using (nVHE or VHE)? I am new to the arm64 KVM world but it is something
> > that I am going to continue to test with various clang technologies now
> > that I have actual hardware capable of it that can run a mainline
> > kernel.
> 
> ARMv8.0 CPUs are only capable of running non-VHE. So if you have
> something based on older ARM CPUs (such as A57, A72, A53, A73, A35...),
> or licensee CPUs (ThunderX, XGene, EMag...), this will only run
> non-VHE (the host kernel runs at EL1, while the hypervisor runs at
> EL2.
> 
> From ARMv8.1 onward, VHE is normally present, and the host kernel
> can run at EL2 directly. ARM CPUs include A55, A65, A75, A76, A77,
> N1, while licensee CPUs include TX2, Kunpeng 920, and probably some
> more.
> 
> As pointed out by Zenghui in another email, KVM shows which mode
> it is using. Even without KVM, the kernel prints very early on:
> 
> [    0.000000] CPU features: detected: Virtualization Host Extensions
> 
> Note that this is only a performance difference, and that most
> features that are supported by the CPU can be used by KVM in either
> mode.
> 
> Thanks again,
> 
>         M.
> -- 
> Jazz is not dead. It just smells funny...

Excellent, thank you both for the in-depth explanation. Hopefully my
test farm continues to grow so I can stay on top of testing this stuff.

Cheers,
Nathan
