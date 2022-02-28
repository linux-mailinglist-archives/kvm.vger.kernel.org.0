Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87A894C7D6F
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 23:34:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbiB1Wet (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 17:34:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiB1Wer (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 17:34:47 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CEBF1110A2
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 14:34:08 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id r13so27789963ejd.5
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 14:34:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BNRCF8PYv/Se3Dr3g8bGB7rOq5xJ078NNrz5/g8pVZs=;
        b=dt8e270gTFsMBghtAbbkonO5HxcUHpTucVjLM44I0WLBir1+DS5PcrwF0Bw9+ee9lm
         965+PQ4wRV+mwWDNaGkOQQ5IAxY3Vx4Bshrfw+oOBUTtgx962QizQihbGL3AbIUeBIKm
         L8YqXSasf7TPu/bpERcs89moST2jhYnBb3D5BAOrxVQU5VsdNrPKmNRemkZW7d/EpAG+
         smG9WO/GaHV1ft4HmSsFnMUMWPPRYHJoBcX7Qhw06F6e8YKkPSXe7WYX6i4WpUnaFbF8
         R4D8Zlc99G2ZZtfi0XblTrVgEt3Qtb5hHlnAkZjgSsKYfeCQWF5ERn5NkJj9WxjkLM6K
         h2ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BNRCF8PYv/Se3Dr3g8bGB7rOq5xJ078NNrz5/g8pVZs=;
        b=jSmMQcev0C22/N7LFWpHpaged31+3xKyXU9CTKdZEl4x2zHjSYQHvNbs/hY2RH8fiN
         XeVILqAfMZ8Wss6YkD1VhURpB3TI19TBXPQW6iS6OqUfrZCv1uERgnuTSAlutFke5QjL
         1NH9ba1w0a9Xav/6e451spXNyjtiwGPxRKTU3DUBRSAh5VcaxmDajVysgzL+FDHwtDK2
         1EtGm4l1N8dusbnneKRdBF38XvPgwNWxzZRqcgM2U/2xqCO3bPJIwqYuK/FTfhqLLlpp
         Sw5owEhNgPWOYcUB+Aro2GfU0KVJSOyD6uDZM+lGjBdKjBEXJSbeAUf2TecO9ZtsQKlX
         vJYg==
X-Gm-Message-State: AOAM532Bqgu/TVW+AdZsr6V97C697mdWX3gLqIhToxzLEL9MKqfP2FRw
        1xclhVm+iQ5lU17bh8H5n976bh7iA9R3IHXQ5p62bA==
X-Google-Smtp-Source: ABdhPJwngHlPx9ydRJblMPz4TG+lF6p3K7Ue+OV+Kni8efT/czu0ibYYp8WmkQsyLtrsC2zxud83CjsQy0Xne76qDvw=
X-Received: by 2002:a17:906:d14e:b0:6cd:8d7e:eec9 with SMTP id
 br14-20020a170906d14e00b006cd8d7eeec9mr16860815ejb.28.1646087646642; Mon, 28
 Feb 2022 14:34:06 -0800 (PST)
MIME-Version: 1.0
References: <20220225182248.3812651-1-seanjc@google.com> <20220225182248.3812651-8-seanjc@google.com>
In-Reply-To: <20220225182248.3812651-8-seanjc@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 28 Feb 2022 14:33:55 -0800
Message-ID: <CANgfPd_zdQAu7m1M_g0wy0wsUpyHDtbE+tUZOKQN59y0ABpvPw@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] KVM: WARN if is_unsync_root() is called on a root
 without a shadow page
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 25, 2022 at 10:23 AM Sean Christopherson <seanjc@google.com> wrote:
>
> WARN and bail if is_unsync_root() is passed a root for which there is no
> shadow page, i.e. is passed the physical address of one of the special
> roots, which do not have an associated shadow page.  The current usage
> squeaks by without bug reports because neither kvm_mmu_sync_roots() nor
> kvm_mmu_sync_prev_roots() calls the helper with pae_root or pml4_root,
> and 5-level AMD CPUs are not generally available, i.e. no one can coerce
> KVM into calling is_unsync_root() on pml5_root.
>
> Note, this doesn't fix the mess with 5-level nNPT, it just (hopefully)
> prevents KVM from crashing.
>
> Cc: Lai Jiangshan <jiangshanlai@gmail.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 825996408465..3e7c8ad5bed9 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3634,6 +3634,14 @@ static bool is_unsync_root(hpa_t root)
>          */
>         smp_rmb();
>         sp = to_shadow_page(root);
> +
> +       /*
> +        * PAE roots (somewhat arbitrarily) aren't backed by shadow pages, the
> +        * PDPTEs for a given PAE root need to be synchronized individually.
> +        */
> +       if (WARN_ON_ONCE(!sp))
> +               return false;
> +

I was trying to figure out if this should be returning true or false,
but neither really seems correct. Since we never expect this to fire,
perhaps it doesn't matter and it's easier to just return false so the
callers don't need to be changed. If this did fire in a production
scenario, I'd want it to terminate the VM too.

>         if (sp->unsync || sp->unsync_children)
>                 return true;
>
> --
> 2.35.1.574.g5d30c73bfb-goog
>
