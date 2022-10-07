Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3D15F7BFC
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 19:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbiJGREg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 13:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiJGREe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 13:04:34 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F2A888A20
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 10:04:32 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id v186so5393170pfv.11
        for <kvm@vger.kernel.org>; Fri, 07 Oct 2022 10:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZUUzZIftjGJJ6CoH+q40cUT1QWxhIqNVVsnKaRyBuhg=;
        b=cIxEVVp2tRw8lX1Qj4mub7QKmuMxA6hlcpEiaoFNZosU9ukRGr4P7jMf7Ntajtim/7
         bRZ6aXc48CjkO1X7ciSxsCvMmD7OBZ2vTTKwBrjuEJTdlUcBhfvuDKiK1l+yFgkjc/Xz
         NaxiHoS4W8C66Dd1PwVD77v6tLsNSyfuBZVdN+ddoaBwPBUcoIwpxNP3rsptyju5dhli
         z9IVXu/mXs/uRsxMJrhDMB1mF6vKxRGevYEZNUXWgLEmDLgBzN4ZU9GRORpbkV08QRqA
         f3dCq8EZVXDC0MFzLaAAsqIFKuLWnp15GybYJZ7/eU76ih75VfhUa3XQ65NvfTeZdNYV
         20Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZUUzZIftjGJJ6CoH+q40cUT1QWxhIqNVVsnKaRyBuhg=;
        b=JWmRHV3wqYUFfl7O0V1BwT/3aAr1g5rwVGtZciQHVbfuYVgrs65NbZ0GfhGA7ajfVv
         lS+kOQ+WOmbx9uw0ahdefzgzvXkKOKtrOrROma1uP8OAyh0sob+E8wUMtjEDhCUTKpnq
         gcguQOurs2zwrqMqeYVtWwHKeA0OKyo1ftonBZ8saLv9EIWevb1YYE59mf4vu10mv1Py
         hKMO6ZLAAHyf+Fhx39Gc3KGal+t2nCRVEULRxIKgb2Lf53eJPItHD6L56e3FPsAq5zwd
         zq/QLi8T8B2MJLSoIeSzgm7hs6yVrW++RlndnOlFxR2nkcCuIqQnUBqecfSuL/TOhioT
         6JIg==
X-Gm-Message-State: ACrzQf3J2jNiwmwKy9ZeNiY05hao9KQDqkBvuIp5yg39ZnJrwBzL9Upt
        DCQQ/wLd3JMGvA6Tq7Vvc2BOtjKI7nqOhQ==
X-Google-Smtp-Source: AMsMyM60Jjxu72B5ImIXCbOhSGLRAo8ehy713AO2fvfXk9EHBoweOUPDSYhTleaJqCeg4spD3lqYrQ==
X-Received: by 2002:a63:120b:0:b0:43c:771b:4c52 with SMTP id h11-20020a63120b000000b0043c771b4c52mr5502813pgl.370.1665162271565;
        Fri, 07 Oct 2022 10:04:31 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id y75-20020a62ce4e000000b005613220346asm1832609pfg.205.2022.10.07.10.04.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 10:04:30 -0700 (PDT)
Date:   Fri, 7 Oct 2022 17:04:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Hao Peng <flyingpenghao@gmail.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH ] kvm: x86: Reduce unnecessary function call
Message-ID: <Y0BcGnabCp9ukxDs@google.com>
References: <CAPm50aK9oe-m5QWfrFjzGx_vvNveA+U6-Fs3KD5+Zq5RZ+UhDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPm50aK9oe-m5QWfrFjzGx_vvNveA+U6-Fs3KD5+Zq5RZ+UhDg@mail.gmail.com>
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

On Fri, Oct 07, 2022, Hao Peng wrote:
> From: Peng Hao <flyingpeng@tencent.com>
> 
> kvm->lock is held very close to mutex_is_locked(kvm->lock).
> Do not need to call mutex_is_locked.
> 
> Signed-off-by: Peng Hao <flyingpeng@tencent.com>
> ---
>  arch/x86/kvm/pmu.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 02f9e4f245bd..8a7dbe2c469a 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -601,8 +601,7 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm
> *kvm, void __user *argp)
>         sort(&filter->events, filter->nevents, sizeof(__u64), cmp_u64, NULL);
> 
>         mutex_lock(&kvm->lock);
> -       filter = rcu_replace_pointer(kvm->arch.pmu_event_filter, filter,
> -                                    mutex_is_locked(&kvm->lock));
> +       filter = rcu_replace_pointer(kvm->arch.pmu_event_filter, filter, 1);

I'd prefer to keep the mutex_is_locked() call, even though it's quite silly, as
it self-documents what is being used to protect writes to pmu_event_filter.
The third paramter is evaluated iff CONFIG_PROVE_RCU=y, which is the complete
oppositive of performance sensitive, so in practice there's no real downside to
the somewhat superfluous call.

>         mutex_unlock(&kvm->lock);
> 
>         synchronize_srcu_expedited(&kvm->srcu);
> --
> 2.27.0
