Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18B094AEF44
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 11:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiBIK1t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 05:27:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiBIK1s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 05:27:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E41FFE093C07
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 02:19:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644401919;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kaUJ6qEuteh5GGwH67WPHciL8en/0JCq6czS6mHZN8U=;
        b=Ti2WAr2IxEsLv2HVnZeDThZECXTDoaT1l2Z00G4PUtaQJGx/dP16iHhhlgMCcj5KciUVw4
        XmDC4uUB9Zqc1Hw5uCUTkoKBeXI2gRk7m3ZoSquwqFKb4UZY30fuyU0tG+kSNnTMFLI0a4
        5STFpsKZQEMbNPAkf1nT90I2daEAcPs=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-Js4jy-FzO7aJVWh0hGD1SA-1; Wed, 09 Feb 2022 05:18:38 -0500
X-MC-Unique: Js4jy-FzO7aJVWh0hGD1SA-1
Received: by mail-ed1-f70.google.com with SMTP id l19-20020a056402231300b0040f2d6b4ec4so1136210eda.0
        for <kvm@vger.kernel.org>; Wed, 09 Feb 2022 02:18:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kaUJ6qEuteh5GGwH67WPHciL8en/0JCq6czS6mHZN8U=;
        b=Pq/QoJ88+Zx/x/qYEx/cVN41t8LyO9/SiZERAxwfEBHIEiIp4Rm5Z3OzRVxZ+1wfQE
         QclvHtgoG4sxjEoq/IGG/xyQe/cb5qdzai3kdt1VTrjFGzdwyoOHjEx/sKlwD18dsgij
         uN3FIC3R+2ELwEmerI3pG48rr3dvvHJmAYCp3Xe/PEI7F9QAsfKXV6Jpk+3e0hsKi4aY
         s4MtsqkZKXxrVXvyfKhBwdFdtrPasTJQ+S2/d98xmoIfQKuwh5gLAnecJFFVUU/sj4Sk
         OQa3iXvQuXsngWgHIErSS/AbKzomFXtlDuMCWYkKYNB/UGpueczdIW+VI2r2w0IPnJCY
         gHRQ==
X-Gm-Message-State: AOAM532FJWQfTjm2epIPqMyg/t0qc9HmxHx0uCXh+PCivC5L6/QwsNkP
        CuDZu+i5EstroGu0OPEjg9R7iU+m0vUGZqsdSHWcQghVNxvpYdSJaTmxqICjUrHBcGlt44zsu/D
        bELTIIdnmrH35b/ukdpKY+qdolLhYBjvCycY/9WQMaebdUscF826WPUhFFVyIfyo=
X-Received: by 2002:aa7:db01:: with SMTP id t1mr1641540eds.394.1644401917291;
        Wed, 09 Feb 2022 02:18:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJziDxadqrItbl1r2J6cFl0MQLh+K8TQm1MvvcmlaHtt9TnfzJwlirA3Dqy1vyUM8+xzPvnG4Q==
X-Received: by 2002:aa7:db01:: with SMTP id t1mr1641525eds.394.1644401917108;
        Wed, 09 Feb 2022 02:18:37 -0800 (PST)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id z1sm431412edd.75.2022.02.09.02.18.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 02:18:36 -0800 (PST)
Date:   Wed, 9 Feb 2022 11:18:34 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, thuth@redhat.com
Subject: Re: [PATCH kvm-unit-tests v2] arm64: Fix compiling with ancient
 compiler
Message-ID: <20220209101834.5szyipomjvky32bn@gator>
References: <20220203151344.437113-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220203151344.437113-1-drjones@redhat.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 03, 2022 at 04:13:44PM +0100, Andrew Jones wrote:
> When compiling with an ancient compiler (gcc-4.8.5-36.el7_6.2.aarch64)
> the build fails with
> 
>   lib/libcflat.a(alloc.o): In function `mult_overflow':
>   /home/drjones/kvm-unit-tests/lib/alloc.c:19: undefined reference to `__multi3'
> 
> According to kernel commit fb8722735f50 ("arm64: support __int128 on
> gcc 5+") gcc older than 5 will emit __multi3 for __int128 multiplication.
> To fix this, let's just use check_mul_overflow(), which does overflow
> checking with GCC7.1+ and nothing for older gcc. We lose the fallback
> for older gcc, but oh, well, the heavily negative diffstat is just too
> tempting to go for another solution.
> 
> While we're cleaning up lib/alloc.c with the function deletion also take
> the opportunity to clean up the include style and add an SPDX header.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  lib/alloc.c | 41 ++++++-----------------------------------
>  1 file changed, 6 insertions(+), 35 deletions(-)
>

Applied to misc/queue
https://gitlab.com/rhdrjones/kvm-unit-tests/-/commits/misc/queue

Thanks,
drew

