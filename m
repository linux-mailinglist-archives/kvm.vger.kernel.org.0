Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4501D783600
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 00:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbjHUWyM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 18:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231393AbjHUWyL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 18:54:11 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D7A1197
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 15:53:59 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-3fef2fafee2so41235e9.0
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 15:53:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692658437; x=1693263237;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jdLYxza4od6gtfHAM+EKsHvl605mqzT8tcnqgOrPUzA=;
        b=RokrMkjekVqjOnn9Z5xHiQxIHN9kLHJ6H8rzRfsK+Xj5idR0sdE9f/fF2Ler+geLaz
         rQH9qEONLh4rVXprtQwrFtbF2v7nLjBoQOjk4iptd2KSYuCRQ392xHbEr68//5pzLyZY
         mnyXI+dXDHSDA7CxLPtE7A8xDxMaGF35osHsxaRy/yHUHUhn8mAcAwUpyMpvhrsxdnDo
         WJImf5bfjbV4JDhGS0eGg63FJU8cZ+Soy3UeIdvZKkG2cmIKBlrpEsS8doDtJAcgbwbq
         ynT0l5Q7WmKwPyg8a9/jvNz3pZIWx12Cklci4DWkz1ca5VCTH3zRJ4xZh1JgcvW7kkwf
         sGow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692658437; x=1693263237;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jdLYxza4od6gtfHAM+EKsHvl605mqzT8tcnqgOrPUzA=;
        b=QO078rn/52BngVI0bsC+st29frjINUqT33bSKYEJ0kl1pudQJAemGciNDMS8w3Vwfn
         CcBHGkYp5m+NdTWEpyiazXL8XPYRre1mKqER06VMzB5VJLsqJ1pQFjjRW9ME4WLk9Jqb
         DIgiSj/Pa4sVgLEk9m3BiaQwuPxIVktN8aPBR36s3HteDzSVFCqFPwLEHw8YLh0JLxPM
         k5VhdvDnTLCLt5UIaZRaKg8zOvX0fS42ZQizORs/GFnXTAOoXLvbWpM9ZnUdxubwHpmZ
         TAWTHorBAId9OhAWmvAi682IDYPhzJ568w+rJwn0+nlpJe6lMSLBya0O1+2QQkejSvvZ
         cXoQ==
X-Gm-Message-State: AOJu0Ywj6cnxJcJqys53tBKCjjUPxBK9f812gjyJECyvnHH5uIIq7ANd
        irhXUKlmqJueLVghMgCadsVwOngp1i3pWebyV6neWw==
X-Google-Smtp-Source: AGHT+IEt1yHPSnbsDH0JcIPR06bqqs+Xcl1PuGluizf8cCRswFgsVE2EkEzXk6qD8Ekw6ub0BuDNTl+fLRqjNmCT/rg=
X-Received: by 2002:a05:600c:260d:b0:3f6:f4b:d4a6 with SMTP id
 h13-20020a05600c260d00b003f60f4bd4a6mr19299wma.7.1692658437564; Mon, 21 Aug
 2023 15:53:57 -0700 (PDT)
MIME-Version: 1.0
References: <20230818233451.3615464-1-srutherford@google.com>
 <08418fc0-839a-f2fb-1c2e-b4f077d2647b@amd.com> <CABayD+cw3s1UDSN7oR4gWfRT4-snWEqOgAN-y4rzOpe-8D=KdA@mail.gmail.com>
 <2a391d50-d474-eec5-76ea-e5dc5590609c@amd.com> <CABayD+f3BLjg4ekO=b4yweqsV4-kA3nfDjKh7MieMh+=zvkA=Q@mail.gmail.com>
 <303d2eb7-d337-8516-1120-13c4c2443d2e@amd.com>
In-Reply-To: <303d2eb7-d337-8516-1120-13c4c2443d2e@amd.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Mon, 21 Aug 2023 15:53:21 -0700
Message-ID: <CABayD+d7imAX98rPp3LKdv0nPFhFkS-r2zJkiacBjQe2tZBQUg@mail.gmail.com>
Subject: Re: [PATCH] x86/sev: Make early_set_memory_decrypted() calls page aligned
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David.Kaplan@amd.com,
        jacobhxu@google.com, patelsvishal@google.com, bhillier@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 21, 2023 at 1:24=E2=80=AFPM Tom Lendacky <thomas.lendacky@amd.c=
om> wrote:
>
> I like the fix for the hypercall being in early_set_memory_enc_dec(). Thi=
s
> way the behavior doesn't change for existing callers and doesn't require
> adding a WARN.
>
> Thanks,
> Tom

I uploaded a version based on your earlier advice to have
early_set_mem_enc_dec_hypercall() take a size. I was hesitant since I
thought I'd have to change a ton of callsites, but the line count was
a lot shorter than I expected. This seems like the right way to go
since it directly fixes the problematic rounding.

Thanks,
Steve
