Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0CAD11F872
	for <lists+kvm@lfdr.de>; Sun, 15 Dec 2019 16:28:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbfLOP1Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Dec 2019 10:27:24 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:34180 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbfLOP1Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Dec 2019 10:27:24 -0500
Received: by mail-ot1-f67.google.com with SMTP id a15so5621724otf.1
        for <kvm@vger.kernel.org>; Sun, 15 Dec 2019 07:27:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7RRaL3Yvu+i2tlgto54WRPCcxOMll246e8ITYnRGwDI=;
        b=afNFnLcrQzgm3wKSvboSfSwxBBar1xP6aIEXir1TfRJQmEcuWTD8m3Prm2Zq1+sUXn
         mufCXi5v4RO9S72Bxj7dEdCY5OMGgbnL9SHZPMT4lPDfwGWZCW6xGMjfFKwSSeGp468G
         YRwhcW4YLUfvSJhZ/z/W9In99fNBrOcoAY+fPrMzi6LvpiP9gaH4MLQ3TmKbVl/mG5dC
         gNafKso8pqii1V/qe69nCCWYxcY7r/G0x7cTtKThfdT3IrXKQMmv1S5zO/bcFFPL3gQk
         ennG+TzktZvgs3k5QvrL37Gf+inJjSzJTez2gfFOsECR4j63ThkjNmuSzGA84iPqgYQy
         GofA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7RRaL3Yvu+i2tlgto54WRPCcxOMll246e8ITYnRGwDI=;
        b=kTyRxjci76yYPxAw4eqDb6AkogXWAHM6J7/tLs5lf38Ds/Ce2UxatKSs6Ul1TPspb4
         oNtBjEBGmUEbK/jlM3AMHNSJL9HbyIXHR6vRLE7IOHvhi03D5sD+N09+nZzO1CeuHxkV
         7O+j3XvX40BlayGGhh5ysCH55w1erlt3c6uEsYpXYaAj5JE9NyIF+I9Rs2aOAp68jLLc
         0z+ZQiQcuWhRBd0YmzqArMK1h/GB4ZSzrf+ir22EcZhvAl8wT9vcLr5eiVu0Nq5Et5UV
         aFVqB1HCop5woHPICdymI6gKfHnlAjTs+SBzR+nGyoCdpq2M12migV1LOy8L0LFXQCs3
         19nQ==
X-Gm-Message-State: APjAAAWGap7gsvvWZjBmz/mmhPbCSo3twVRUN04ZTlLIlra4VxEQncuo
        qVVF8cCz8RC72x8q28etkl3KmoFtmH+upP2nggdHaw==
X-Google-Smtp-Source: APXvYqzcSSJVTCjIUsx/inzBCCcsnE8pmcRF5dwcpzLSHO9Pe90yz4G+qrRUaeTTS0bQzZw43vk7O2hwjIga6wmmd6k=
X-Received: by 2002:a05:6830:2001:: with SMTP id e1mr25512778otp.97.1576423643528;
 Sun, 15 Dec 2019 07:27:23 -0800 (PST)
MIME-Version: 1.0
References: <20191214155614.19004-1-philmd@redhat.com> <CAFEAcA_QZtU9X4fxZk2oWAkN-zxXdQZejrSKZbDxPKLMwdFWgw@mail.gmail.com>
 <20191215044759-mutt-send-email-mst@kernel.org>
In-Reply-To: <20191215044759-mutt-send-email-mst@kernel.org>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Sun, 15 Dec 2019 15:27:12 +0000
Message-ID: <CAFEAcA9ZF3VTR7kG_D-cJ+vPFTgd8zjmt2VPfJC7urNemF-5AQ@mail.gmail.com>
Subject: Re: [PATCH 0/8] Simplify memory_region_add_subregion_overlap(..., priority=0)
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@redhat.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        Andrew Baumann <Andrew.Baumann@microsoft.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        kvm-devel <kvm@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Aleksandar Markovic <amarkovic@wavecomp.com>,
        Joel Stanley <joel@jms.id.au>, qemu-arm <qemu-arm@nongnu.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Alistair Francis <alistair@alistair23.me>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Aleksandar Rikalo <aleksandar.rikalo@rt-rk.com>,
        Paul Burton <pburton@wavecomp.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 15 Dec 2019 at 09:51, Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Sat, Dec 14, 2019 at 04:28:08PM +0000, Peter Maydell wrote:
> > (It doesn't actually assert that it doesn't
> > overlap because we have some legacy uses, notably
> > in the x86 PC machines, which do overlap without using
> > the right function, which we've never tried to tidy up.)
>
> It's not exactly legacy uses.
>
> To be more exact, the way the non overlap versions
> are *used* is to mean "I don't care what happens when they overlap"
> as opposed to "will never overlap".

Almost all of the use of the non-overlap versions is
for "these are never going to overlap" -- devices or ram at
fixed addresses in the address space that can't
ever be mapped over by anything else. If you want
"can overlap but I don't care which one wins" then
that would be more clearly expressed by using the _overlap()
version but just giving everything that can overlap there
the same priority.

> There are lots of regions where guest can make things overlapping
> but doesn't, e.g. PCI BARs can be programmed to overlap
> almost anything.
>
> What happens on real hardware if you then access one of
> the BARs is undefined, but programming itself is harmless.
> That's why we can't assert.

Yeah, good point, for the special case where it's the
guest that's determining the addresses where something's
mapped we might want to allow the behaviour to fall out
of the implementation. (You could instead specify set of
priorities that makes the undefined-behaviour something
specific, rather than just an emergent property of
the implementation QEMU happens to have, but it seems
a bit hard to justify.)

thanks
-- PMM
