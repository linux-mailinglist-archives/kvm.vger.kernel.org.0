Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2E3AEFDC
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 18:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436879AbfIJQqu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 12:46:50 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:46459 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436798AbfIJQqt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 12:46:49 -0400
Received: by mail-io1-f66.google.com with SMTP id d17so17150042ios.13
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2019 09:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Iik6ApNStlsVCIULPBT84kpOfksI6a2RGV5x7IOdHNQ=;
        b=XiAF+Ma+b7DXW8fItPzCAwZV2BY7R6DCjwIU8gP8Czh5N5Bzi1oI3kryFmQEWmzmsw
         YAdFozCP6YCwgSS00Yxa3TbJw/Dj70Tz+Y2Z8d19BQGeH/nG2g6EnMxU4hEld6iIHkJv
         KZHBRUp1n7CTdn9jS14c6kt/KPxpAyM71eq7su5HPcVtcq1nieJbPE0l25kuALZJ8PH0
         KmgoYk6F+Rd1jxLVxpHp7YX41UOkNzqCdk5FJQhhz23d+n3zE2pQiKHF9E1ZAWtyvx7H
         Gj5VMzbJVUW+S9yvNDTRsPRGm1UtVBl3kMo5P85s+h12tM8RscgG17XiBELS7f4F20T+
         2mIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Iik6ApNStlsVCIULPBT84kpOfksI6a2RGV5x7IOdHNQ=;
        b=gSAiFJDx/09tQBBdJbRxcc6LD4UbNECSA7/towk8CHx0jcCYAH8vVA1/xDW2va6pkU
         UmBFpEFCn9yHcEFg3Q4Wv0PvSNPxwAEjyREMCTHxQjb9MG6TnTdoXEScDOmJl3sgOJUQ
         7vv8N18bIArPgizyoCkTkkhwEQSCubcRL3O0qBBh+k73kfET8V+MAdk0/TpQZfs1R1P0
         ETrEDrDUEBgDmDY8zpj/y8GsXN5fSGS180b9gvZNck7d+BX/UyXw7bJBHTKGvMgwN8PX
         ++bfxKyU1M+jeb3SH0v9Sn6k0sIbRP/Wn0ZEoT/MdxFB/hPbfd8m7LfM26rSoC+yhkd6
         iQ7Q==
X-Gm-Message-State: APjAAAXLniqSbYm6rwRbOmhCTTh5DGL52xwxjGBVCcX6U418D6iCrTOB
        y0S8gJPdb8wzNF22oxyHYiHbo6pVrgH/BQ5xhJCfOA==
X-Google-Smtp-Source: APXvYqzzlqQLEOcmXPHsdz2FVUVRPUyd4sPdSA120DJodf788fo3XDXOGPYeGupwzn0JCBEyQK7AyMUCe7GFjUBZ/Gg=
X-Received: by 2002:a02:cad1:: with SMTP id f17mr18966174jap.18.1568134008410;
 Tue, 10 Sep 2019 09:46:48 -0700 (PDT)
MIME-Version: 1.0
References: <CAGG=3QWNQKejpwhbgDy-WSV1C2sw9Ms0TUGwVk8fgEbg9n0ryg@mail.gmail.com>
In-Reply-To: <CAGG=3QWNQKejpwhbgDy-WSV1C2sw9Ms0TUGwVk8fgEbg9n0ryg@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 10 Sep 2019 09:46:36 -0700
Message-ID: <CALMp9eSWpCWDSCgownxsMVTmJNjMvYMiH0K2ybD6yzGqJNiZrg@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: setjmp: ignore clang's
 "-Wsomtimes-uninitialized" flag
To:     Bill Wendling <morbo@google.com>
Cc:     kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 9, 2019 at 2:10 PM Bill Wendling <morbo@google.com> wrote:
>
> Clang complains that "i" might be uninitialized in the "printf"
> statement. This is a false negative, because it's set in the "if"
> statement and then incremented in the loop created by the "longjmp".
>
> Signed-off-by: Bill Wendling <morbo@google.com>
> ---
>  x86/setjmp.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/x86/setjmp.c b/x86/setjmp.c
> index 976a632..cf9adcb 100644
> --- a/x86/setjmp.c
> +++ b/x86/setjmp.c
> @@ -1,6 +1,10 @@
>  #include "libcflat.h"
>  #include "setjmp.h"
>
> +#ifdef __clang__
> +#pragma clang diagnostic ignored "-Wsometimes-uninitialized"
> +#endif
> +
>  int main(void)
>  {
>      volatile int i;

Can we just add an initializer here instead?
