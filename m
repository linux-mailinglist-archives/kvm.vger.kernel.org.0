Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E16EC735691
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 14:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbjFSMUR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 08:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbjFSMUL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 08:20:11 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C5F6E65
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 05:20:10 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-519b771f23aso4651210a12.1
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 05:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687177208; x=1689769208;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yDYZb4o9XOdkmRjG7w7LjTTpmTBjUr2xgA3AghCByUk=;
        b=q9so1MiYdIvbrw830FlHq7SdI+u36PCaPuYI6Pf1+lGkCNtZ3Wzc0FGmV/0subM015
         hT/CfQxe369TzoL3RGYWK9f1MSQyRvhS4IP3SL3e5KcZ7HzJ24V/5jkIGstDdG/PUOUZ
         EBYEgUHuHxSwWNrUCKrLFILwN746UtaRUnDL6RdUOaqagmdUwEj/ccoryvUieX8Z28Lu
         +YXGQXga1TGIsZXlOCw2T0EF4I+6Uza6uvAuLTF3NGaP/p/qYt4KU4fudYDIRUx8NYOc
         ItEx/jYdnCCFHD4qj/+wk8Wyf7AO0Iyb9olZekAR9BvYAvZTiG9Woc1HT8vJoaJmk1GE
         QRug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687177208; x=1689769208;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yDYZb4o9XOdkmRjG7w7LjTTpmTBjUr2xgA3AghCByUk=;
        b=SXxzRP45KYMIHtmFAUIlTGZD8EQbEfcOtl2qzlr/oMn5xgrQwswkJuwofSHNK3ttkM
         v9jN/yC/iqlo44rjGqrhGkJ0GMTte7C2c5SWTQRSiH1tHZROnaRiVk/qoGWzch+AYqvi
         30DZ8hup3EaSIv79DGIBKUE96Km3LHrBNC8DaOtdxkzIQLFP9QRlc966Ikh6y13LAGjZ
         PSwVe+v6/N9OD5cS6ax7z7OqO9oDo8PuC6Pga9o6Bu1kthCpDiAIOxHbeMtx/yGgLRe+
         ENMB06ZYWeCvGLj+S1e7HvVhz4oIV7M9NCnimuhJURzKa6ZydaWcTY2kLJJx0SAzvOuI
         7WaA==
X-Gm-Message-State: AC+VfDygXutCfJ6fnJe7OAG2vdVTK+mU8VA/PvDYP2HoNAfkGL90Uh7c
        AP8o9lagBF41ro87JotUrtBM6spUn70UO9bDYZ3ZjA==
X-Google-Smtp-Source: ACHHUZ4bJ1vmLJq8bN74jdINdAEtrYZ8Jjqxc+bXjaQGfQ0vZkYS1MEDn+pOTQ4t+7BtCv4UX6QVcRTDm4/6Na7w5e4=
X-Received: by 2002:aa7:d901:0:b0:518:4a5b:56a with SMTP id
 a1-20020aa7d901000000b005184a5b056amr5912611edr.32.1687177208591; Mon, 19 Jun
 2023 05:20:08 -0700 (PDT)
MIME-Version: 1.0
References: <20221201102728.69751-1-akihiko.odaki@daynix.com>
 <CAFEAcA_ORM9CpDCvPMs1XcZVhh_4fKE2wnaS_tp1s4DzZCHsXQ@mail.gmail.com>
 <a3cc1116-272d-a8e5-a131-7becf98115e0@daynix.com> <ed62645a-ec48-14ff-4b7e-15314a0da30e@daynix.com>
In-Reply-To: <ed62645a-ec48-14ff-4b7e-15314a0da30e@daynix.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Mon, 19 Jun 2023 13:19:57 +0100
Message-ID: <CAFEAcA-pOKf1r+1BzURpv5FnFS79D2V=SSeY_a2Wene1wf+P1A@mail.gmail.com>
Subject: Re: [PATCH] accel/kvm/kvm-all: Handle register access errors
To:     Akihiko Odaki <akihiko.odaki@daynix.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 10 Jun 2023 at 04:51, Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>
> On 2022/12/01 20:00, Akihiko Odaki wrote:
> > On 2022/12/01 19:40, Peter Maydell wrote:
> >> On Thu, 1 Dec 2022 at 10:27, Akihiko Odaki <akihiko.odaki@daynix.com>
> >> wrote:
> >>>
> >>> A register access error typically means something seriously wrong
> >>> happened so that anything bad can happen after that and recovery is
> >>> impossible.
> >>> Even failing one register access is catastorophic as
> >>> architecture-specific code are not written so that it torelates such
> >>> failures.
> >>>
> >>> Make sure the VM stop and nothing worse happens if such an error occurs.
> >>>
> >>> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> >>
> >> In a similar vein there was also
> >> https://lore.kernel.org/all/20220617144857.34189-1-peterx@redhat.com/
> >> back in June, which on the one hand was less comprehensive but on
> >> the other does the plumbing to pass the error upwards rather than
> >> reporting it immediately at point of failure.
> >>
> >> I'm in principle in favour but suspect we'll run into some corner
> >> cases where we were happily ignoring not-very-important failures
> >> (eg if you're running Linux as the host OS on a Mac M1 and your
> >> host kernel doesn't have this fix:
> >> https://lore.kernel.org/all/YnHz6Cw5ONR2e+KA@google.com/T/
> >> then QEMU will go from "works by sheer luck" to "consistently
> >> hits this error check"). So we should aim to land this extra
> >> error checking early in the release cycle so we have plenty of
> >> time to deal with any bug reports we get about it.

> > Actually I found this problem when I tried to run QEMU with KVM on M2
> > MacBook Air and encountered a failure described and fixed at:
> > https://lore.kernel.org/all/20221201104914.28944-2-akihiko.odaki@daynix.com/
> >
> > Although the affected register was not really important, QEMU couldn't
> > run the guest well enough because kvm_arch_put_registers for ARM64 is
> > written in a way that it fails early. I guess the situation is not so
> > different for other architectures as well.
> >
> > I still agree that this should be postponed until a new release cycle
> > starts as register saving/restoring is too important to fail.

> Hi,
>
> QEMU 8.0 is already released so I think it's time to revisit this.

Two months ago would have been a better time :-) We're heading up
towards softfreeze for 8.1 in about three weeks from now.

thanks
-- PMM
