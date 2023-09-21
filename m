Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21E447A9BF5
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 21:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbjIUTFS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 15:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231411AbjIUTEu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 15:04:50 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87A3B8333E
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:50:52 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id 38308e7fff4ca-2bff776fe0bso21492641fa.0
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695318649; x=1695923449; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SLFyIa4pNfHrRrFVoK4W/7yOB5ezN6IY3vzVujeQWwk=;
        b=eFntXSh/F4hKdahKgzMe5D0dOIwBNLMarnlFvWooPG3SbMSFfyRWzuDmgLU+AINGYY
         CC0i8UC3ue9twJ2WZrPiHdEBSj1NbbPAHZJcy9xXAfRxDYClImR6tbe4ArB1YnTWLJbv
         JaSx6fOvf4UNazVj1W5Z4G/Fa/q0/ZRfo/NYUiW/PxoWcw2boISz85PIS07y3pltVlFV
         XukkJhyB4wHOVaPfrPsrF46bQnONpR7zKfRvPXcKUZ6deayWVfo5+hR9V0CJts2dxuad
         f93uK4SLkjiokLRLWG1ZhNtW7Rdr0NSQU/L0+C3DsmFvDrdMs1im4U5d9lqQ0ZNa80LQ
         S9qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695318649; x=1695923449;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SLFyIa4pNfHrRrFVoK4W/7yOB5ezN6IY3vzVujeQWwk=;
        b=QXx5X4DIkm/480vXzfnGxtAyILhFIrMNXjfvnawqQ2gi+AF1/Nw22MeaLG2v2e3EwM
         wsQ2xqLGfN9pWyuwNuhnpxd/knmqLbkfW8pGcuvu6PU0bEVOGyRT3TUFLuzeu7MP15Lo
         gjA2dTCQvBKFGPtuURong8JwrC25IjaQ76jcjGe/Wg4Fd19XQRprWCUcjBXWJtBPc3TR
         fLS7wOlT69iwPcnLCPr1d22JOsbWZchwMloTpy9XWay0LCMavbqXWevHLyZTEY7SWLhD
         gDuYK4+3BIlVLiIwL9dS8VrgyijBQGhithis8RFin82nLlE9/BYuqxoPF+arr33PGR7Z
         +9uA==
X-Gm-Message-State: AOJu0YzHQPcZ/pc+I3Da4sBxhxDCEeHkr37EodY+5b+zlgforC87KhMC
        KTrA97hfXGYl5mHuRnhbB68Belxi06FvBMyYpnYUusbsO/dNJGlLVTs=
X-Google-Smtp-Source: AGHT+IHSkQ8f8dAM1bbBde2nHASKpT8QXWY5hcVmzsVUDmW/7AlposkLeqWQB5YEfDT9yRQHRvNIKem8/RqCHbNikX8=
X-Received: by 2002:a05:6402:3d7:b0:52c:9f89:4447 with SMTP id
 t23-20020a05640203d700b0052c9f894447mr4590180edw.4.1695303248906; Thu, 21 Sep
 2023 06:34:08 -0700 (PDT)
MIME-Version: 1.0
References: <20221201102728.69751-1-akihiko.odaki@daynix.com>
 <CAFEAcA_ORM9CpDCvPMs1XcZVhh_4fKE2wnaS_tp1s4DzZCHsXQ@mail.gmail.com>
 <a3cc1116-272d-a8e5-a131-7becf98115e0@daynix.com> <ed62645a-ec48-14ff-4b7e-15314a0da30e@daynix.com>
 <CAFEAcA-pOKf1r+1BzURpv5FnFS79D2V=SSeY_a2Wene1wf+P1A@mail.gmail.com> <a5cd5a46-7f33-42b6-99eb-b09159af42d7@daynix.com>
In-Reply-To: <a5cd5a46-7f33-42b6-99eb-b09159af42d7@daynix.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Thu, 21 Sep 2023 14:33:49 +0100
Message-ID: <CAFEAcA9cfrS4bqUX6G9qL8jNhJw0z2nMbqiHxYOutnqVOyb2yQ@mail.gmail.com>
Subject: Re: [PATCH] accel/kvm/kvm-all: Handle register access errors
To:     Akihiko Odaki <akihiko.odaki@daynix.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 21 Sept 2023 at 08:25, Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
> On 2023/06/19 21:19, Peter Maydell wrote:
> > On Sat, 10 Jun 2023 at 04:51, Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
> >> On 2022/12/01 20:00, Akihiko Odaki wrote:
> >>> On 2022/12/01 19:40, Peter Maydell wrote:
> >>>> On Thu, 1 Dec 2022 at 10:27, Akihiko Odaki <akihiko.odaki@daynix.com>
> >>>> wrote:
> >>>>> A register access error typically means something seriously wrong
> >>>>> happened so that anything bad can happen after that and recovery is
> >>>>> impossible.
> >>>>> Even failing one register access is catastorophic as
> >>>>> architecture-specific code are not written so that it torelates such
> >>>>> failures.
> >>>>>
> >>>>> Make sure the VM stop and nothing worse happens if such an error occurs.
> >>>>>
> >>>>> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>

> >> QEMU 8.0 is already released so I think it's time to revisit this.
> >
> > Two months ago would have been a better time :-) We're heading up
> > towards softfreeze for 8.1 in about three weeks from now.

> Hi Peter,
>
> Please apply this.

Looking again at the patch I see it hasn't been reviewed by
anybody on the KVM side of things. Paolo, does this seem like
the right way to handle errors from kvm_arch_get_registers()
and kvm_arch_put_registers() ?

The original patch is at:
https://patchew.org/QEMU/20221201102728.69751-1-akihiko.odaki@daynix.com/

thanks
-- PMM
