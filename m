Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 211CB656FEF
	for <lists+kvm@lfdr.de>; Tue, 27 Dec 2022 22:23:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbiL0VXr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Dec 2022 16:23:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbiL0VXp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Dec 2022 16:23:45 -0500
Received: from mail-oo1-xc30.google.com (mail-oo1-xc30.google.com [IPv6:2607:f8b0:4864:20::c30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C04F4C
        for <kvm@vger.kernel.org>; Tue, 27 Dec 2022 13:23:44 -0800 (PST)
Received: by mail-oo1-xc30.google.com with SMTP id m23-20020a4abc97000000b004bfe105c580so2409469oop.4
        for <kvm@vger.kernel.org>; Tue, 27 Dec 2022 13:23:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LJmVkOnb6rX3XrBrgRu585wdYWYx//ek9uXDwJrERMw=;
        b=DwXyxPre28aJdMG2QS26vFZsvWhG0+8ty+Uh0h6Jl+AmUYw7slOXAnvRdtk3mXP+tg
         gFG5h30SGx1Cn/06EnmI/vBW1QyFLaEG33C8Tt37bjCFake+8Ml7nLDw4PyFk4/EJt4S
         Z79aL3paffMBtlvvfVZ4z5dFre6D28Irx/3ALcZ7d7t6C6vv4zeabnPVoFViH+I/HLej
         4MsswXLZ7T2y2PjtprPTz13dRtBbQ2VDpO3HtTxXtUq2nVLmKB4VfmFR0mYMIbCi5Y/T
         MDvhlicnTTHyblIv1vm/sRGiLw2ef+iW9PT5BNK9g1IuF9910BC1ShrhKKMLpegLFVZA
         ZfSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LJmVkOnb6rX3XrBrgRu585wdYWYx//ek9uXDwJrERMw=;
        b=xKT7AHxhBqscv6L8sdAwv4lZRxZE2fzkK+fKCxN0qFzANY4QpPnL3JpazSuCeCkfiA
         Jz4SivZbzp0Bo/zpZrUi0TJiMl4L6r6jjc6pd8m16kVmdiwwDu8iTBUTEe2Q0SvXkZhh
         gbxDiqyIl3Zw95jP+gz1dBYcK+AwhOnSCHcmdHL16scGivatH2igBv6SGSA20x5JYLBH
         6s1HDjrqOl2AmRresQsrG+XyOcpCs7QYN0cXpJZvtVQhq/FNzdLPia7Vz2sA0iE5UQWf
         hVSGk6OJgwLJaYqP6l0JLN4ZvSkqHRSjnHU1IJbGjLImtSanLOnNP3Jg7ynCb2vt3ydq
         bjSA==
X-Gm-Message-State: AFqh2kpjcVtAUuGeM0QbU/TaiJpl98Th82iTuygKqqirWYTJ2bkwJhia
        EKCMYOFKCt8M8FV8advz2LMcxkjN51Dcj2pl2lWCLg==
X-Google-Smtp-Source: AMrXdXuRGOArMnueFus0lZK0ZT18dXjB5OBpHcE7H/zIk3iT6c3GpfUxZvm9vatsVtfnwtWdDh+uP1Vv8f67DfqWdPk=
X-Received: by 2002:a4a:e7d2:0:b0:4a3:e23d:4e2a with SMTP id
 y18-20020a4ae7d2000000b004a3e23d4e2amr1021814oov.7.1672176223860; Tue, 27 Dec
 2022 13:23:43 -0800 (PST)
MIME-Version: 1.0
References: <20221227183713.29140-1-aaronlewis@google.com> <20221227183713.29140-3-aaronlewis@google.com>
In-Reply-To: <20221227183713.29140-3-aaronlewis@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 27 Dec 2022 13:23:32 -0800
Message-ID: <CALMp9eS1Tap_fF4Yn-5yyqBPZQ0XBnzmUVThjDSQPfR8giqCmA@mail.gmail.com>
Subject: Re: [PATCH 2/3] KVM: selftests: Hoist XGETBV and XSETBV to make them
 more accessible
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
        like.xu.linux@gmail.com
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

On Tue, Dec 27, 2022 at 10:38 AM Aaron Lewis <aaronlewis@google.com> wrote:
>
> The instructions XGETBV and XSETBV are useful to other tests.  Move
> them to processor.h to make them available to be used more broadly.
>
> No functional change intended.
>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  .../selftests/kvm/include/x86_64/processor.h  | 19 +++++++++++++++
>  tools/testing/selftests/kvm/x86_64/amx_test.c | 24 +++----------------
>  2 files changed, 22 insertions(+), 21 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index b1a31de7108ac..34957137be375 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -492,6 +492,25 @@ static inline void set_cr4(uint64_t val)
>         __asm__ __volatile__("mov %0, %%cr4" : : "r" (val) : "memory");
>  }
>
> +static inline u64 xgetbv(u32 index)
> +{
> +       u32 eax, edx;
> +
> +       __asm__ __volatile__("xgetbv;"
> +                    : "=a" (eax), "=d" (edx)
> +                    : "c" (index));
> +       return eax | ((u64)edx << 32);
> +}
> +
> +static inline void xsetbv(u32 index, u64 value)
> +{
> +       u32 eax = value;
> +       u32 edx = value >> 32;
> +
> +       __asm__ __volatile__("xsetbv" :: "a" (eax), "d" (edx), "c" (index));
> +}
> +
> +

Not your change, but shouldn't both of these asm statements have
artificial "memory" clobbers, to prevent reordering?

Reviewed-by: Jim Mattson <jmattson@google.com>
