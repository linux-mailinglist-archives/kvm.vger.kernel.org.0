Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF9C23266B
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 22:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgG2Urm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 16:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbgG2Urm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jul 2020 16:47:42 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5852BC0619D2
        for <kvm@vger.kernel.org>; Wed, 29 Jul 2020 13:47:42 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id t18so20672657ilh.2
        for <kvm@vger.kernel.org>; Wed, 29 Jul 2020 13:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XoJlKZaLXbUuLV4nosYhBKGNv2CAMoP0UIqUb30Ie3A=;
        b=Y3SIw4LskqRgpE5LgviYVSqSY/tsY3kr0cGoeYpoSrb/hJFhZYg+3dksqJxt5TnNVg
         +kd/B2h0bHIex0pJlfbkVupUVGjKPkcfXCQsBRd29pMsENwEr0RcO3nh6B/51Zsc+Aqw
         g196Yk+hPQGkHyI/Qrq6mbc/E5XFXIFTt0Wt8OExHcXRv6bArhgpMbzGTtWO1rbleXWf
         pHBpCDNR69Q9H8CL1mfd6ont/outxJCZSOCcju4df3bumqlpZj4K6a5JQ9BpFT/wIZO5
         i5ormwI5TjDN5YGwVrFbFlo1rrILQ6/pdlJEtsAX5t5uwu8R2LwZwYL92n/44xP2Tg5b
         8ZYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XoJlKZaLXbUuLV4nosYhBKGNv2CAMoP0UIqUb30Ie3A=;
        b=p4s/UIfMSDAeqoLKpAtCOJTOF/1vRel7uE0iY2sMekD92BRD37glStPdWKTLoZt+hP
         wLoXv9eWUh/maejRXYWyf32lbgRgMOv4FQrQbZ7sJQSiXDdwf1JxrjEaGdj3dfAmJqi/
         q3GzY1t/cAA1QbkzwuhxIkyvKLIOcZTrgCiqxm6Ct4ncr/YnRXk3XGNMnRkVU0JrL1Mv
         A2rVsDcMl8b8UnLN51EJ/BB3Kq+giV9OjrE3LWdyRemBFRbJAJzzstFjas+H5bz/yV2L
         /dX4wFtl9apmaG1I0axhTWYOxCTgECwjSdMoaO4po5z3tLm8pmOSCPyO/MYu8CfWv3zB
         17oA==
X-Gm-Message-State: AOAM533uz0boHxSteMt5NrZHa9ZoSESSv2y2WebueOQMmd6qP6AiCsuw
        GFR8pvhJA9WSoL3GXmkmcsT70j6qdt0jreoukEs/Hw==
X-Google-Smtp-Source: ABdhPJxnn1nGoFy9ElsyLRQgWdscrHapUJ1Bb7Gtsqx96+CKmabOpGB+seMqVJ940AENql5HW66eqKFs2WUDC/shPiA=
X-Received: by 2002:a92:b60a:: with SMTP id s10mr28883334ili.119.1596055661499;
 Wed, 29 Jul 2020 13:47:41 -0700 (PDT)
MIME-Version: 1.0
References: <159597929496.12744.14654593948763926416.stgit@bmoger-ubuntu> <159597949343.12744.9555364824745485311.stgit@bmoger-ubuntu>
In-Reply-To: <159597949343.12744.9555364824745485311.stgit@bmoger-ubuntu>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 29 Jul 2020 13:47:30 -0700
Message-ID: <CALMp9eTO-Det6u3Fa2Lrzkgw7SRj=Jbf2kJ1YuokZRmCEpj=EA@mail.gmail.com>
Subject: Re: [PATCH v3 04/11] KVM: SVM: Modify intercept_exceptions to generic intercepts
To:     Babu Moger <babu.moger@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 28, 2020 at 4:38 PM Babu Moger <babu.moger@amd.com> wrote:
>
> Modify intercept_exceptions to generic intercepts in vmcb_control_area.
> Use the generic __set_intercept, __clr_intercept and __is_intercept to
> set the intercept_exceptions bits.
>
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> ---

> @@ -52,6 +54,25 @@ enum {
>         INTERCEPT_DR5_WRITE,
>         INTERCEPT_DR6_WRITE,
>         INTERCEPT_DR7_WRITE,
> +       /* Byte offset 008h (Vector 2) */
> +       INTERCEPT_DE_VECTOR = 64 + DE_VECTOR,
> +       INTERCEPT_DB_VECTOR,
> +       INTERCEPT_BP_VECTOR = 64 + BP_VECTOR,
> +       INTERCEPT_OF_VECTOR,
> +       INTERCEPT_BR_VECTOR,
> +       INTERCEPT_UD_VECTOR,
> +       INTERCEPT_NM_VECTOR,
> +       INTERCEPT_DF_VECTOR,
> +       INTERCEPT_TS_VECTOR = 64 + TS_VECTOR,
> +       INTERCEPT_NP_VECTOR,
> +       INTERCEPT_SS_VECTOR,
> +       INTERCEPT_GP_VECTOR,
> +       INTERCEPT_PF_VECTOR,
> +       INTERCEPT_MF_VECTOR = 64 + MF_VECTOR,
> +       INTERCEPT_AC_VECTOR,
> +       INTERCEPT_MC_VECTOR,
> +       INTERCEPT_XM_VECTOR,
> +       INTERCEPT_VE_VECTOR,
>  };

I think it's demanding a lot of the reader to know where there are and
are not gaps in the allocated hardware exception vectors. Perhaps all
of the above enumeration definitions could have initializers? Either
way...

Reviewed-by: Jim Mattson <jmattson@google.com>
