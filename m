Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 531877ABA6D
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 22:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbjIVURC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 16:17:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjIVURB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 16:17:01 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7BE8CE
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 13:16:54 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-51e24210395so4399a12.0
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 13:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695413813; x=1696018613; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HOC7+7x0cT7EusVhBeEs7NRLBeFe6UyBAqNmtpMsudY=;
        b=mKT2spgZwiq8n+AnsgThvaCTStp3gZVPr4jMWg0oGr4CbK9Smp4F8HXaKQpgYYoaTZ
         O0nvuIgewdQ8Nr+gtYi69a+X+xfZ2i9fj3UiHP8iCGNlIvAFBg8MdrqvxQcCNZM+GnKW
         MRu5474e0QrVX4rmUN/xOmt+Y2+QsFDdXlrsNS8z9OBkVijnjj3uL/2xdL3Rpg/ckW4g
         TZmBUQDnb/priIFwd2krgGm99w2tYSZPGf8XsL0kWrIuzoFfo7mniHV3rAr9ns580H54
         /eucR3lOXcourn7+sR9RLVAlizK0uHmVP6Gzbbcx/7B59rNJ4CPQ1P54OfvcP6V7lGre
         zPnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695413813; x=1696018613;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HOC7+7x0cT7EusVhBeEs7NRLBeFe6UyBAqNmtpMsudY=;
        b=hqKNITM+9gTxoBb1KtfbCyivSNyd6Cx6ybBHyRfm2hvXJgy4sObBCOXbcIrNjBKWW9
         RtXMWJ+218dZp3DVfYsOJePIlKPHTuix6Ieaj2CfisnlyTsJjhhvZlrQ6wvspkHV/PNe
         WezUMAdYCN4MAriyh5VnXeGCQZg278BPfh7+WlO9vKKreNWN1b2o0f4+7zzSus35b7WM
         F206mt3XtPn2F3SaZfjD3Ez2qnSz4QtH9vVagoJR+gO2G3mfPqdcGWrJTez+b2Ts12Nr
         wMe4B8C1/zlSGQ4ifV4Iwc5AFmFEiUMQQaruNbZiMaJVtLHB38MyE90Lj1evW/wDN4Kd
         0fDg==
X-Gm-Message-State: AOJu0Yx0JoaL6kPbbqY3tPwNx/qjqZn6r1ONbiyDY9+DlBglVitqrdI6
        4sjwhC6LI8vNlm8/osMv4PVP2+bRRsDwJkFrBrwupw==
X-Google-Smtp-Source: AGHT+IH6haIxGqWvE9sikwn+KsesdI8zpa9j+kbH9o1Yqi5VL6kirGSokD7RZoh8B3B5VBWHvDmM8JaquIwpJVMHU1M=
X-Received: by 2002:a50:c302:0:b0:52e:f99a:b5f8 with SMTP id
 a2-20020a50c302000000b0052ef99ab5f8mr610edb.7.1695413813013; Fri, 22 Sep 2023
 13:16:53 -0700 (PDT)
MIME-Version: 1.0
References: <20230922164239.2253604-1-jmattson@google.com> <20230922164239.2253604-2-jmattson@google.com>
 <ZQ3NHv9Yok8Uybzo@google.com> <CALMp9eQKB5mxb=OpvkvZEBLXzekrBYaz9z016A9Xp3-QpMJpUg@mail.gmail.com>
 <ZQ3Z25cu5gnsedqr@google.com> <CALMp9eSQx5KWxDN97GTevxx-UkyAW8WCeVWbH0nAAnAY+phqKQ@mail.gmail.com>
 <ZQ3txHpC9XQ9mc8c@google.com>
In-Reply-To: <ZQ3txHpC9XQ9mc8c@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 22 Sep 2023 13:16:37 -0700
Message-ID: <CALMp9eQN=SMo00Xo-ekD4EF8fQjp6DqUrLedO9TbwXcPGwt3hg@mail.gmail.com>
Subject: Re: [PATCH 2/3] KVM: x86: Virtualize HWCR.TscFreqSel[bit 24]
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Fri, Sep 22, 2023 at 12:40=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Fri, Sep 22, 2023, Jim Mattson wrote:
> > Okay. What about the IA32_MISC_ENABLE bits above?
>
> One of the exceptions where I don't see a better option, and hopefully so=
mething
> that Intel won't repeat in the future.  Though I'm not exactly brimming w=
ith
> confidence that Intel won't retroactively add more "gotcha! unsupported!"=
 bits
> in the future when they realize they forgot add a useful CPUID feature bi=
t.

I don't understand the difference here. Why not make userspace
responsible for setting these bits as well?
