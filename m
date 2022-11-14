Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 192F562876F
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 18:50:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237654AbiKNRta (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 12:49:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237733AbiKNRt0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 12:49:26 -0500
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94AC2B7E0
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 09:49:25 -0800 (PST)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-13be3ef361dso13244500fac.12
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 09:49:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Gy/4M1xY3E/Nv94qXpiz5Pwp9jKQM56LN4NET3PIGVY=;
        b=qJnRV5eAseBRg8MH5K57Ws0/LuMMO/clqutEuW5BKj9XfOY6h9Tzv0Ue/ZOk2+fEM1
         +XRWCGEnA6dxU5KsceqNGqIG3XLae4OdNgsfG670mARw3nT6+ACxroClFuLkY4Bo867z
         TX0+JZSyfStkBwTvVFHo72iTabxRIz+YLZ9WyceWKSErM8C8PnEpOkK/+t3WcCrjPoM1
         +tu6HO+L3ClSeXXNapQAUBzESOHN5gXD5K85zu6cak4JSCxOuacr+psW0xZXWTv2tk04
         PuSsf+BtQ50+DRQCO7t+f335u0MkFD6JMmAfKCpLznewmaVYGheeTt6bBvZovIsHFuq7
         huZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Gy/4M1xY3E/Nv94qXpiz5Pwp9jKQM56LN4NET3PIGVY=;
        b=raW0kcPHM8NRY3PMa9k80TzGT37QEZURIhMyPuIrvquSdcHSqm5Azet2xM/CDBiLkx
         8UE++mgnrsaaM4PfxPO+dPjftKraLta1QhnPENwiZ+YMxiYhhSPm23Sre3x1jetSRwgf
         lqLqSu7Ep+iBd8iDxdLNjG4LEBCQIHtrrSGTXhhncX3MAkJP0AkZgv1j6evLBNKc2C33
         7UqEVoF31D0ldT9EPEgWllkk+vGv2jijIwvE7m2j2Z+S48aOk4rgIhYL/nLF1KU9YQ3z
         99lNle8W4IBMmk40Bkb0vACuZUKg1C5VGbUZeONZ9CWAqPtwf0w57j8SmVEZEfyBhEp/
         m2UA==
X-Gm-Message-State: ANoB5pmnBlQu67oorduojGlNrMihZZ1YhBkNh/w791KdZGdKsTdv+Ajq
        3xyDls/TCISiMrrIaYTJfGup8de/dI8AB7s32rIUGg==
X-Google-Smtp-Source: AA0mqf4YdJy6PHiN5TqFwP0W2ut7WqkhLIu2eCNfOqJSubHAejl6CcYMWv9zCVk8OoK8uAM5ubH8JtK8rjDSNa6vROg=
X-Received: by 2002:a05:6870:2e07:b0:132:af5d:e4eb with SMTP id
 oi7-20020a0568702e0700b00132af5de4ebmr7585231oab.112.1668448164637; Mon, 14
 Nov 2022 09:49:24 -0800 (PST)
MIME-Version: 1.0
References: <20221114164823.69555-1-hborghor@amazon.de>
In-Reply-To: <20221114164823.69555-1-hborghor@amazon.de>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 14 Nov 2022 09:49:13 -0800
Message-ID: <CALMp9eRZqbZoqcT0h5Bsw1Xj37eOsub+FMKKoy-a8fR1ESObew@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/vmx: Do not skip segment attributes if unusable
 bit is set
To:     Hendrik Borghorst <hborghor@amazon.de>
Cc:     graf@amazon.de, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
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

On Mon, Nov 14, 2022 at 8:50 AM Hendrik Borghorst <hborghor@amazon.de> wrote:
>
> When serializing and deserializing kvm_sregs, attributes of the segment
> descriptors are stored by user space. For unusable segments,
> vmx_segment_access_rights skips all attributes and sets them to 0.
>
> This means we zero out the DPL (Descriptor Privilege Level) for unusable
> entries.
>
> Unusable segments are - contrary to their name - usable in 64bit mode and
> are used by guests to for example create a linear map through the
> NULL selector.
>
> VMENTER checks if SS.DPL is correct depending on the CS segment type.
> For types 9 (Execute Only) and 11 (Execute Read), CS.DPL must be equal to
> SS.DPL [1].
>
> We have seen real world guests setting CS to a usable segment with DPL=3
> and SS to an unusable segment with DPL=3. Once we go through an sregs
> get/set cycle, SS.DPL turns to 0. This causes the virtual machine to crash
> reproducibly.
>
> This commit changes the attribute logic to always preserve attributes for
> unusable segments. According to [2] SS.DPL is always saved on VM exits,
> regardless of the unusable bit so user space applications should have saved
> the information on serialization correctly.
>
> [3] specifies that besides SS.DPL the rest of the attributes of the
> descriptors are undefined after VM entry if unusable bit is set. So, there
> should be no harm in setting them all to the previous state.
>
> [1] Intel SDM Vol 3C 26.3.1.2 Checks on Guest Segment Registers
> [2] Intel SDM Vol 3C 27.3.2 Saving Segment Registers and Descriptor-Table
> Registers
> [3] Intel SDM Vol 3C 26.3.2.2 Loading Guest Segment Registers and
> Descriptor-Table Registers
>
> Cc: Alexander Graf <graf@amazon.de>
> Signed-off-by: Hendrik Borghorst <hborghor@amazon.de>
> ---
>  arch/x86/kvm/vmx/vmx.c | 21 +++++++++------------
>  1 file changed, 9 insertions(+), 12 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 63247c57c72c..4ae248e87f5e 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3412,18 +3412,15 @@ static u32 vmx_segment_access_rights(struct kvm_segment *var)
>  {
>         u32 ar;
>
> -       if (var->unusable || !var->present)
> -               ar = 1 << 16;
> -       else {
> -               ar = var->type & 15;
> -               ar |= (var->s & 1) << 4;
> -               ar |= (var->dpl & 3) << 5;
> -               ar |= (var->present & 1) << 7;
> -               ar |= (var->avl & 1) << 12;
> -               ar |= (var->l & 1) << 13;
> -               ar |= (var->db & 1) << 14;
> -               ar |= (var->g & 1) << 15;
> -       }
> +       ar = var->type & 15;
> +       ar |= (var->s & 1) << 4;
> +       ar |= (var->dpl & 3) << 5;
> +       ar |= (var->present & 1) << 7;
> +       ar |= (var->avl & 1) << 12;
> +       ar |= (var->l & 1) << 13;
> +       ar |= (var->db & 1) << 14;
> +       ar |= (var->g & 1) << 15;
> +       ar |= (var->unusable || !var->present) << 16;
>
>         return ar;
>  }
Reviewed-by: Jim Mattson <jmattson@google.com>
