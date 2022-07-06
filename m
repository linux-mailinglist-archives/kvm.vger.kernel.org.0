Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD6FB56917C
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 20:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234364AbiGFSNy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 14:13:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234374AbiGFSNt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 14:13:49 -0400
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C4F3B7D6
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 11:13:48 -0700 (PDT)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-10bec750eedso14694254fac.8
        for <kvm@vger.kernel.org>; Wed, 06 Jul 2022 11:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7fWRDNeX9MMfp7ZEnj1zISls/i3Z9E63XbcmRmnrtV4=;
        b=LSY5fpPHj4ODjWxLFsQ9CCFHdMccQXXVWbagQg8W6sKSpRG79C61MjDBvwdytJYiP1
         v/sOP4TlMEi9u8iCMRIvpNMnk5MDT30+cGLjsGLXmiI2SiSk+7ojKAmmRyYdGZWz/gKH
         jyRYhjWDLxcCB4tk8HADZx8VemvH77M4nBLeqNxfXlkrDsVzmXIYbSVch2LVL5RzMDXF
         vgDLZUpSMPj2TdbmuXkGJ+Q5hphs9i9pMD+RX2jt5UxnqjSeof3u1cu4LqnFJDTTEb9j
         +RIB3tV1O8+E3L3JcHABdZKK4JPWtxLMy0cLIOjyQdvA5UCtCUCXZ860tRxOYl3nVMLM
         Yt/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7fWRDNeX9MMfp7ZEnj1zISls/i3Z9E63XbcmRmnrtV4=;
        b=7SMKaN+dGnIQjQy/8RSxHo0/XG6arMMR0DCrcXJkz+9mqP6Wy3jJ4b1F7GZWDgR+Hx
         8dHFiyvai/t2LTiX4Z+CWtbFnqNnRdTaP6+607vsACyz8DPsiaN6oaK74cwouKGHR13N
         szMQqAbi/LslFbZG8uRRgy84LJRfjCamhf+JiKBkvsOvoyPOfAJjc/b/b+Texx5dONB6
         YCFDErK/jNbRySYlCpwG1dYYQ25gXlK0cLyDK8Qyt1olZbXrcqzvqZqniQtftLSW++nj
         ksmdTH+hD3vtzPpgE+PgGzNkDnBv4PAc7KQnNNHw4aEuClhEmBsYvMZZ/jggR0EhAItS
         PwZQ==
X-Gm-Message-State: AJIora8n0g77Nt2cgas6uPs164nGK30yYACprNeUy+3zCdHj7TmXIkBL
        /v9c7AU2bpoeGwFN4+5Zt3uC5ifeET16BBobtVfeyg==
X-Google-Smtp-Source: AGRyM1sMShOFtGknX+KfS0VwLuvS48QVMtsbgqt5zd+qQNVYk34Z62nVt80xNGcx+pAMuQL76YDfGHMvR1Efkb0SOic=
X-Received: by 2002:a05:6870:56aa:b0:10b:f4fb:8203 with SMTP id
 p42-20020a05687056aa00b0010bf4fb8203mr11908251oao.181.1657131227362; Wed, 06
 Jul 2022 11:13:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220621150902.46126-1-mlevitsk@redhat.com> <20220621150902.46126-12-mlevitsk@redhat.com>
 <CALMp9eSe5jtvmOPWLYCcrMmqyVBeBkg90RwtR4bwxay99NAF3g@mail.gmail.com>
 <42da1631c8cdd282e5d9cfd0698b6df7deed2daf.camel@redhat.com>
 <CALMp9eRNZ8D5aRyUEkc7CORz-=bqzfVCSf6nOGZhqQfWfte0dw@mail.gmail.com> <289c2dd941ecbc3c32514fc0603148972524b22d.camel@redhat.com>
In-Reply-To: <289c2dd941ecbc3c32514fc0603148972524b22d.camel@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 6 Jul 2022 11:13:36 -0700
Message-ID: <CALMp9eS2gxzWU1+OpfBTqCZsmyq8qoCW_Qs84xv=rGo1ranG1Q@mail.gmail.com>
Subject: Re: [PATCH v2 11/11] KVM: x86: emulator/smm: preserve interrupt
 shadow in SMRAM
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        x86@kernel.org, Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 5, 2022 at 6:38 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:

> Most of the SMI save state area is reserved, and the handler has no way of knowing
> what CPU stored there, it can only access the fields that are reserved in the spec.
>
> Yes, if the SMI handler really insists it can see that the saved RIP points to an
> instruction that follows the STI, but does that really matter? It is allowed by the
> spec explicitly anyway.

I was just pointing out that the difference between blocking SMI and
not blocking SMI is, in fact, observable.

> Plus our SMI layout (at least for 32 bit) doesn't confirm to the X86 spec anyway,
> we as I found out flat out write over the fields that have other meaning in the X86 spec.

Shouldn't we fix that?

> Also I proposed to preserve the int shadow in internal kvm state and migrate
> it in upper 4 bits of the 'shadow' field of struct kvm_vcpu_events.
> Both Paolo and Sean proposed to store the int shadow in the SMRAM instead,
> and you didn't object to this, and now after I refactored and implemented
> the whole thing you suddently do.

I did not see the prior conversations. I rarely get an opportunity to
read the list.

> However AMD just recently posted a VNMI patch series to avoid
> single stepping the CPU when NMI is blocked due to the same reason, because
> it is fragile.

The vNMI feature isn't available in any shipping processor yet, is it?

> Do you really want KVM to single step the guest in this case, to deliver the #SMI?
> I can do it, but it is bound to cause lot of trouble.

Perhaps you could document this as a KVM erratum...one of many
involving virtual SMI delivery.
