Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8D549CF18
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 17:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235524AbiAZQCo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 11:02:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234531AbiAZQCn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jan 2022 11:02:43 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 180B9C06161C
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 08:02:43 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id z10-20020a17090acb0a00b001b520826011so4804563pjt.5
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 08:02:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2IfSXw9nL+nORiatmKtgy9CzQGOYYGNdKe3zwh1wqUQ=;
        b=hIWNHemPUaZS9d4TqwNxEXXX6uy5wQM+sgQZchBZJ/10uXILZuMYLxBXaEAMAHaLft
         YLUSwY1iL6NmN3NBfR4nRvkcCjNO07qV1ITwZC1rcmuQleqYOp+erOUAlOUWQ9ZvzAAS
         iFB/pEJuX09u4uv/j1Bb4Mb1dOnMLJCvQ3qCwfwybq/dKOYUK9lHDJGPbjgz2I1eYwZq
         AcwZMQYe9TkQf++ywwQgE/bGkV0CEzpcTxmlt8j1UqWIjBr6yCi4Ztw8Bs9YWu22aP+8
         nwqW5N3LHqGf9Zj6mnhmJzCd9ZBnbnIa/OP48hrFKtOdQjRq5y1RRtvX5t/3dNsqOeK2
         SicQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2IfSXw9nL+nORiatmKtgy9CzQGOYYGNdKe3zwh1wqUQ=;
        b=2y3/zi2nzs8R0Gx52sZIAiR32jl1I8jshDoikI4FXCgtyHfZNbnnGa9LsmtDeh821W
         ZGV0sMVCxcAFCCq0XY5KTOiS3D8d6wc3FifWlEzOpWrCnYPr+JsFl52aoSxU8zX75Poh
         AYWnrFZjNmovJGHoeiSfNwjSsDAp7uBjjKvGzTs3TwABnEbtUY1D1kx0D6B7ClHLn4EX
         1ac+gKpXrmWmHFP8P6uKWbXHWMfU0ylCHXtE+o2/K/rAQIvyB+jcSgzM+fZPInBgbaVa
         V2ayPq2c8fL1sVyPEq91X0na7TTuR4jiRaho69/wkm+a+xZrvqTNjfC19Av9oxGBr4G8
         6NlQ==
X-Gm-Message-State: AOAM532y6butf6cLUnptmBPKwDcGPsyIYmEG9frPQthtNjyQOSU+DAbO
        ihqrjyUwp5dQr8gvqiUYRDKrow==
X-Google-Smtp-Source: ABdhPJxsAXA1pkhB3NsCjYQJQFS7ORIMGxFAGg6JVacCZMA/CkYRb+db2dBV0gTkxRpI0+0/3BPs+w==
X-Received: by 2002:a17:902:d505:b0:14b:ce9:800e with SMTP id b5-20020a170902d50500b0014b0ce9800emr23513976plg.1.1643212962275;
        Wed, 26 Jan 2022 08:02:42 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id oo2sm2287317pjb.31.2022.01.26.08.02.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 08:02:41 -0800 (PST)
Date:   Wed, 26 Jan 2022 16:02:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Joe Perches <joe@perches.com>, Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 2/2] KVM: x86: Use memcmp in kvm_cpuid_check_equal()
Message-ID: <YfFwnm3Vp0eOPElp@google.com>
References: <20220124103606.2630588-1-vkuznets@redhat.com>
 <20220124103606.2630588-3-vkuznets@redhat.com>
 <864dfbfdc44e288e99cf7baa3aa8f7c8568db507.camel@perches.com>
 <878rv2izjp.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878rv2izjp.fsf@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 26, 2022, Vitaly Kuznetsov wrote:
> Joe Perches <joe@perches.com> writes:
> 
> > On Mon, 2022-01-24 at 11:36 +0100, Vitaly Kuznetsov wrote:
> >> kvm_cpuid_check_equal() should also check .flags equality but instead
> >> of adding it to the existing check, just switch to using memcmp() for
> >> the whole 'struct kvm_cpuid_entry2'.
> >
> > Is the struct padding guaranteed to be identical ?
> >
> 
> Well, yes (or we're all doomeed):
> - 'struct kvm_cpuid_entry2' is part of KVM userspace ABI, it is supposed
> to be stable.
> - Here we compare structs which come from the same userspace during one
> session (vCPU fd stays open), I can't imagine how structure layout can
> change on-the-fly.

I'm pretty sure Joe was asking if the contents of the padding field would be
identical, i.e. if KVM can guarnatee there won't be false positives on mismatches,
which is the same reason Paolo passed on this patch.  Though I still think we
should roll the dice :-)
