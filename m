Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E65C3B69C3
	for <lists+kvm@lfdr.de>; Mon, 28 Jun 2021 22:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235042AbhF1Uku (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 16:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234575AbhF1Ukt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Jun 2021 16:40:49 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 119F2C061760
        for <kvm@vger.kernel.org>; Mon, 28 Jun 2021 13:38:23 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id k11so23927941ioa.5
        for <kvm@vger.kernel.org>; Mon, 28 Jun 2021 13:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S2IN8Z+sIZlGv6g5jbxKMc3TDU/gH2bfUrQ5chPxP8A=;
        b=Ie/uAPjKe+SAVEb99c07SDXehZOV7xkesFAzpljdesiolQA7N5HAv3IcaRFVrIqKGk
         MkYTKeZuoz5X6xafhC4e82mT9IzBdZwskrLqKSDTHwRsVnX1KAJgVyea++4VZ3qaXFzD
         4WvEXmUqC4LVXKm/1zUlS9/6ZgzZw3fzil+Ap7H47nFxhwh5P1W3+yA3wSRDJ6e3IoUu
         yjWA4OK2QnQrLO9X6l2hNmIYqSHJ7KtzFsk9iAjijOzornnVc/twfE+T1vDmtkAQi89M
         C676feJP+sSR7/YNZgMtny4d7wkrArgGVWD79Ad5mgtoh+nGY4XeiVx/Qe9aSzHBl/TF
         JmBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S2IN8Z+sIZlGv6g5jbxKMc3TDU/gH2bfUrQ5chPxP8A=;
        b=mut1Af90663o/8vYpRv0HufXAZ99EIAIYGGnbb8Io/ijrE5LYh3EhaxF1I5CzEoP05
         fETKrn82TTzFnhjaItYibohbruvkzpy7iy1c5r7LGKXRuRkeNruuwBT2BH7F94nte3FV
         PnRyIXqWZas5QqWmSZ739XawZdxffxvFxJ8peOmzY6S08urdij2LjyRGZsipLpqK/ukc
         Bug2V9cKu7AlMN+A3k8xeSbZuSRnVOrrCBk1ej00IxUQl5wz8oNNssDNDDV3hi/EeuX8
         aHc/IzEhCSh0zVKEfjkWpnWIvSqztGjXLGIlXNqhv4QixTnCeHSJSIyslMUgTVGUn9/0
         yrXQ==
X-Gm-Message-State: AOAM533zKlYZUUl1hE1295PvFTjoY38Bq/79tW3DF4Kg28eRWDvs5L4J
        M1dL28lzteGXlf9MAeoOt2SIVaBMUSIsqOwELYR4wQ==
X-Google-Smtp-Source: ABdhPJy4bIpkvfhQXmKg7hXoiT4mdXx5NrgDmTmRoIgofDOHTgMABtx/f8l6gLuZgi/rTHFgJiBsY6n8wqEKbURXFuw=
X-Received: by 2002:a02:77d1:: with SMTP id g200mr1248012jac.132.1624912702185;
 Mon, 28 Jun 2021 13:38:22 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1623421410.git.ashish.kalra@amd.com> <8c581834c77284d5b9465b3388f07fa100f9fc4e.1623421410.git.ashish.kalra@amd.com>
 <CABayD+ckOsM4+sab00SggrH3_iFaiV-7h9tHHuL1J-o6_YQVKA@mail.gmail.com>
 <YNZXPEPxv54UmzNj@zn.tnic> <20210628193441.GB23232@ashkalra_ubuntu_server>
In-Reply-To: <20210628193441.GB23232@ashkalra_ubuntu_server>
From:   Steve Rutherford <srutherford@google.com>
Date:   Mon, 28 Jun 2021 13:37:46 -0700
Message-ID: <CABayD+e2n+7YB5a9he2VKLKSA80kXVteBMFQgtTG2-oNqqPDYA@mail.gmail.com>
Subject: Re: [PATCH v4 5/5] x86/kvm: Add guest support for detecting and
 enabling SEV Live Migration feature.
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     Borislav Petkov <bp@alien8.de>, pbonzini@redhat.com,
        seanjc@google.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        brijesh.singh@amd.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 28, 2021 at 12:34 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
>
> Hello Steve,
>
> Do you have any final thoughts on this ?

Hi Ashish,

Don't block this because of my lack of understanding.  I'm still
curious about the interactions between SEV and kexec
--preserved-state. If you have concerns about --preserved-state
breaking live-migration (when returning to the original kernel), you
could have kexec's with that flag return an error on Live Migratable
SEV kernels.

Thanks,
Steve
