Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D90B484CB5
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 04:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237184AbiAEDLq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 22:11:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236041AbiAEDLp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 22:11:45 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31599C061761;
        Tue,  4 Jan 2022 19:11:45 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id q5so46673984ioj.7;
        Tue, 04 Jan 2022 19:11:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IMyyM+cm/4zgW6gK2Q24P1qUEMGMqSi4aV5povWdYxg=;
        b=DP7qEAGfFjeQnwkdkoB0rkJPG9gQk53cacaKnVDlaj6bcWfuXnPDEM6W+NkUmk7fgg
         jmrwSRkGuJf7mvQHYtgOWKIdQZMy0nxEgznlsqcuvoJt7qCVXfOkOipneNIN/DcDq66o
         9Wh/znA6XjFdg6ly77noe7YbG4bI7FOxmTY0vCCPfEJu4V7fGnpzvHFC+EXdSEWv3ai0
         FpsTxgZeDa/QAl5Ukx0oso7R42U/pxaIRNzQseaQqfCVuUACEJaSNVgG5ZE2Dyp0k28C
         wLYDLjJqsvbdUx8kEa7pdyYwWmgkwUF7pu5JaIEG50t4iPvWFMLZz8xJoWTwf3E/IGvD
         ef9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IMyyM+cm/4zgW6gK2Q24P1qUEMGMqSi4aV5povWdYxg=;
        b=AACGDLx6zQgVR+xFkn64ZIHoHMB82ySTsmgUpCpckrT9BXEbn3hWugo98PUp4UXITa
         i0f0do7jiRpO5pjUrNF8vUwWV6B4jTg8wb5grHLj1KisB/Hhy5sdkj/NSyvs9puWJbod
         WFyvSiDo7Kqgx0cNkTW1+uHwDNaRVr5TI3gjuumn0m2JtuTpYG5FNhrzbSTTjlnYWKMS
         5nsqN6nuvCvgj2BgGFlWQkM+L1k7eGRdfkYUxA1JpKxpJh2dn5TmnlPru545eGSSS04l
         /TkvHhR84Rg0N8DUaFa2c4xFHDd6l/64WPPu0BVC6H883hbT2pD3+a6Vr3KWonRe4Jz6
         S26Q==
X-Gm-Message-State: AOAM532imbAL+XyDSd814hBmca6Zc30WN6O5B+wK2fTCrT/6Fef1hwD5
        L/V6MLErzkbpHK77+3Y6edlNkXGD7qwEr0CW+fA=
X-Google-Smtp-Source: ABdhPJwFZuLTEcrDNVDLTQUmhJ5I01cER28bYtGD5fUJeXSq8GoX384iOZ2fnXXUeS6u7A2m1ed8SzDuiiuOyWVnxCI=
X-Received: by 2002:a02:114a:: with SMTP id 71mr17204247jaf.88.1641352304583;
 Tue, 04 Jan 2022 19:11:44 -0800 (PST)
MIME-Version: 1.0
References: <20211210092508.7185-1-jiangshanlai@gmail.com> <20211210092508.7185-6-jiangshanlai@gmail.com>
 <YdTCKoTgI5IgOvln@google.com>
In-Reply-To: <YdTCKoTgI5IgOvln@google.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Wed, 5 Jan 2022 11:11:33 +0800
Message-ID: <CAJhGHyAOyR6yGdyxsKydt_+HboGjxc-psbbSCqsrBo4WgUgQsQ@mail.gmail.com>
Subject: Re: [RFC PATCH 5/6] KVM: X86: Alloc pae_root shadow page
To:     Sean Christopherson <seanjc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 5, 2022 at 5:54 AM Sean Christopherson <seanjc@google.com> wrote:

> >
> > default_pae_pdpte is needed because the cpu expect PAE pdptes are
> > present when VMenter.
>
> That's incorrect.  Neither Intel nor AMD require PDPTEs to be present.  Not present
> is perfectly ok, present with reserved bits is what's not allowed.
>
> Intel SDM:
>   A VM entry that checks the validity of the PDPTEs uses the same checks that are
>   used when CR3 is loaded with MOV to CR3 when PAE paging is in use[7].  If MOV to CR3
>   would cause a general-protection exception due to the PDPTEs that would be loaded
>   (e.g., because a reserved bit is set), the VM entry fails.
>
>   7. This implies that (1) bits 11:9 in each PDPTE are ignored; and (2) if bit 0
>      (present) is clear in one of the PDPTEs, bits 63:1 of that PDPTE are ignored.

But in practice, the VM entry fails if the present bit is not set in
the PDPTE for
the linear address being accessed (when EPT enabled at least).  The host kvm
complains and dumps the vmcs state.

Setting a default pdpte is the simplest way to solve it.
