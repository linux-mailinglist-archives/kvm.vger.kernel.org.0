Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 943E34136F5
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 18:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233846AbhIUQIi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 12:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233701AbhIUQIg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 12:08:36 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E4CC061575
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 09:07:08 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id il14-20020a17090b164e00b0019c7a7c362dso2213218pjb.0
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 09:07:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+yaNmgvsiESc7IiB6Ymx0XAIJbChKanMkmnZdgmFdkU=;
        b=QUnXc5te73TZeM855tFB/l31Ta6mcTXPiz5tVoqOE7BlgBjO4urgCVOc3XetZo+GHC
         HRhOIpw7ZNtWjMXWTaTFPDhCWp2jYOgofK2uaTBBeV3rseD81Tg7wQW19rbZ2dNO4O26
         6R9C/XDv13Kl7vxPjZv1eX5J0wA6YPFiivnHOVyVWMr2DPtxW4rRw4RWYNmpR5Tb/gC9
         lBITriOdyf62JqI8baHsctzKM3L2VyrrAsk+fdcwcbSfvWaQmVfrdzG07O21IImXKlnm
         rxuXlIeEXjn+1fvkY8NSSdU5ADKuoOU3SgMKl02OQVmPyrnG3swToL+QOWzM3i9lCWsb
         y6jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+yaNmgvsiESc7IiB6Ymx0XAIJbChKanMkmnZdgmFdkU=;
        b=LfgyF2ZASHTWilEzjN4rGAFwUyexg6RPBg9d74FnDMUUfLCJLdFuPOVaYHxgB/Qcqr
         cOr85bWV96a9hhAVSvRxDb07HyJAxFaBXXkcclRQynUxhlbG0nff4tUT5sFweYMdpxN0
         67mk6UPLR2X3qGgHtJL63xW3PO+EDxSEv4DANdCmxRx54VPJl9+gSN+Sb1nKRpwMUjqA
         qO7NAFOyohwxHd7g5oQ2+OOJ91YSXK5MZYsLmKSl9AvPTZvuDlZXIWzanT2wwwFECWZk
         maXX578UnPOREjzdzOCzLgZ0U6C7i90nZUbwFPGmNKz5TepF0dJ5WjJyFcTv7DvM8uhy
         Ks/w==
X-Gm-Message-State: AOAM531vaWpcHY41z8PrkGOiWFHokYJXsALfYeCYSbDcc89z5RxfV+nz
        m/YZyVoc3gXq18tSOoMr6kXONQ==
X-Google-Smtp-Source: ABdhPJzMNi+Gqwx8N+bL2yocKBd5bfg06DkoIFpcHluHQbcc7rPrK/XXCurkWYUw0vDTWLH2JCS54Q==
X-Received: by 2002:a17:90b:3ec1:: with SMTP id rm1mr4178683pjb.179.1632240427435;
        Tue, 21 Sep 2021 09:07:07 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id v6sm18516777pfv.83.2021.09.21.09.07.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 09:07:06 -0700 (PDT)
Date:   Tue, 21 Sep 2021 16:07:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Ashish Kalra <ashish.kalra@amd.com>,
        Steve Rutherford <srutherford@google.com>, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, thomas.lendacky@amd.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        brijesh.singh@amd.com, dovmurik@linux.ibm.com, tobin@linux.ibm.com,
        jejb@linux.ibm.com, dgilbert@redhat.com
Subject: Re: [PATCH v6 1/5] x86/kvm: Add AMD SEV specific Hypercall3
Message-ID: <YUoDJxfNZgNjY8zh@google.com>
References: <cover.1629726117.git.ashish.kalra@amd.com>
 <6fd25c749205dd0b1eb492c60d41b124760cc6ae.1629726117.git.ashish.kalra@amd.com>
 <CABayD+fnZ+Ho4qoUjB6YfWW+tFGUuftpsVBF3d=-kcU0-CEu0g@mail.gmail.com>
 <YUixqL+SRVaVNF07@google.com>
 <20210921095838.GA17357@ashkalra_ubuntu_server>
 <YUnjEU+1icuihmbR@google.com>
 <YUnxa2gy4DzEI2uY@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUnxa2gy4DzEI2uY@zn.tnic>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 21, 2021, Borislav Petkov wrote:
> On Tue, Sep 21, 2021 at 01:50:09PM +0000, Sean Christopherson wrote:
> > apply_alternatives() is a generic helper that can work on any struct alt_instr
> > array, e.g. KVM_HYPERCALL can put its alternative into a different section that's
> > patched as soon as the VMM is identified.
> 
> Where exactly in the boot process you wanna move it?

init_hypervisor_platform(), after x86_init.hyper.init_platform() so that the
PV support can set the desired feature flags.  Since kvm_hypercall*() is only
used by KVM guests, set_cpu_cap(c, X86_FEATURE_VMMCALL) can be moved out of
early_init_amd/hygon() and into kvm_init_platform().

> As Ashish says, you need the boot_cpu_data bits properly set before it
> runs.

Another option would be to refactor apply_alternatives() to allow the caller to
provide a different feature check mechanism than boot_cpu_has(), which I think
would let us drop X86_FEATURE_VMMCALL, X86_FEATURE_VMCALL, and X86_FEATURE_VMW_VMMCALL
from cpufeatures.  That might get more than a bit gross though.

But like I said, if others think I'm over-engineering this...
