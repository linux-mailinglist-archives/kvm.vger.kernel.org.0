Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D822463232
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 12:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238724AbhK3LXA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 06:23:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238708AbhK3LWl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 06:22:41 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D75F3C061746
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 03:19:22 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id v23so25448088iom.12
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 03:19:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G9k5ttvheQZ7XCgPQsOVjadQf9e0m2Yq+Z4vNX+4tyM=;
        b=RtAG8N1bigjEX1NnUcI3PR8xai/dCOT3sSuB2ucpHff7ZXtd1Rh9XLtFiafXQ5ndwC
         xoHgHek1lnHtoVd2FUKJC82z2m5+7hY66q/MoVQ/8/NyKUYyUe0tyPuBhsVJYirZdf55
         fjMzF1WsUNQRIhmbrCNmsYO6mCPk6+eD9dNQw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G9k5ttvheQZ7XCgPQsOVjadQf9e0m2Yq+Z4vNX+4tyM=;
        b=a880xhlMvW7SnY5LJg0cNhswrhFZI9az4DDkuUVtvGSphPByT9RGIZGjqhfJUL9AOW
         P1WPnP7ZPHKWiDVVIv7WussxzGoQbtqethuBg/FfYNadgDAXRpLUL0zF/XzlYQR6iGCl
         BZcv0t77xveSEMku9UIZb3TwoWKZHIu5+eT8OeS+nQvt8VMngIz7O+6QSagEu1X8La/x
         sqJouw/rr93b79TRJbrOnGPThYsKctT1CB7lV/XwB25BTSqkoMkTazFcBDttY7EZ21Ho
         txp5KkJab/MUJADqFaw73y+cxrUZhp2FxIE4RGxK8fR6m/kOXg//Yk2M7bjbuGTLEE/z
         hnhg==
X-Gm-Message-State: AOAM533VDQUvpe2r8MfSbMbNdKQvlejrC9S8Slqt8J8h3hnWaXPorAIL
        WFdBxtW/K5iqIRvv1JgdVQ2IzSdPmH7MOyCa/cLNWA==
X-Google-Smtp-Source: ABdhPJx6prJSnER1Xuq460zyn6em+OV8GocEcLbZlYkw90BvodR9Xlr6GGiVjrMKeHX6vEQ6yg0bLlBr2Qzlu9nOl2w=
X-Received: by 2002:a02:ab8f:: with SMTP id t15mr75894253jan.147.1638271162226;
 Tue, 30 Nov 2021 03:19:22 -0800 (PST)
MIME-Version: 1.0
References: <CALrw=nEaWhpG1y7VNTGDFfF1RWbPvm5ka5xWxD-YWTS3U=r9Ng@mail.gmail.com>
 <d49e157a-5915-fbdc-8103-d7ba2621aea9@redhat.com> <CALrw=nHTJpoSFFadmDL2EL95D2kAiH5G-dgLvU0L7X=emxrP2A@mail.gmail.com>
 <041803a2-e7cc-4c0a-c04a-af30d6502b45@redhat.com>
In-Reply-To: <041803a2-e7cc-4c0a-c04a-af30d6502b45@redhat.com>
From:   Ignat Korchagin <ignat@cloudflare.com>
Date:   Tue, 30 Nov 2021 11:19:11 +0000
Message-ID: <CALrw=nHFy7rG4FbUf+sGMWbWfWzzDizjPonrUEqN89SQNdWTWg@mail.gmail.com>
Subject: Re: Potential bug in TDP MMU
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     stevensd@chromium.org, kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 30, 2021 at 11:11 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 11/30/21 11:58, Ignat Korchagin wrote:
> > I have managed to reliably reproduce the issue on a QEMU VM (on a host
> > with nested virtualisation enabled). Here are the steps:
> >
> > 1. Install gvisor as per
> > https://gvisor.dev/docs/user_guide/install/#install-latest
> > 2. Run
> > $ for i in $(seq 1 100); do sudo runsc --platform=kvm --network=none
> > do echo ok; done
> >
> > I've tried to recompile the kernel with the above patch, but
> > unfortunately it does fix the issue. I'm happy to try other
> > patches/fixes queued for 5.16-rc4
>
> You can find them already in the "for-linus" tag of kvm.git as well as
> in the master branch, but there isn't much else.
>
> Paolo

Thanks. I've tried to compile the kernel from kvm.git "for-linus" tag,
but the issue is still there, so probably no commits address the
problem.
Will keep digging.

Ignat
