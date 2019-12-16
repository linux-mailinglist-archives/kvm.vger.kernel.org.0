Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88682120424
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 12:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727286AbfLPLkK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 06:40:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44793 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727230AbfLPLkK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 06:40:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576496408;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OYDDHez2+eQPnVZemBiQrMSGx/8BMcqXBE4o9nFHE48=;
        b=KBk/nbZoC62qgwq9OR0MytN0gQajn+nG//9G93J5YEduLMXncLh/BLze3xUIwKAiu/zE7z
        Qr7fSCRvbOAbh+nnAqZDq1vCgXpLs2Do3pfPwcnsMnyTEgpzxUZ5J3qPvLiAPhuY9K/Ou8
        CVKNZufRE3rJ6onWsLlVwXmlsFnERYQ=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-eAQTgS-5N32JWQj6OBJFDQ-1; Mon, 16 Dec 2019 06:40:05 -0500
X-MC-Unique: eAQTgS-5N32JWQj6OBJFDQ-1
Received: by mail-qv1-f71.google.com with SMTP id g6so910674qvp.0
        for <kvm@vger.kernel.org>; Mon, 16 Dec 2019 03:40:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OYDDHez2+eQPnVZemBiQrMSGx/8BMcqXBE4o9nFHE48=;
        b=QDN9RbIsPLOSoWSoLSveINuLv3o5zJ5ZgHF7rfDVVg6/u3pXrayGYQaWBZBFJO75L4
         mi3NJtRqM4lR/pjuVWMUBXSo+pbPBoIsOjx90c0/Xa4e6EK016eMzcjjrFIjBe8dUw6s
         Z0fgRwdl/DKNd1BOa5J4EMupdmUZXZDD6uMbaAbDmQ0/KjsaR3WCilqNz2hzxmPsHc1a
         8+jqiRGU4aSIBo+MpBfsUc6cbO/px6jlr0c9a93ySqNnvyJn8OLQZD6pA9ZhVIBlHTud
         m/9Hfa/kL+WYv6HVUG1vWQ1XQDIc4VuOUIhqy7QrhXKxcf6oAV/59NS5tQbG5OsFiQiV
         9IHw==
X-Gm-Message-State: APjAAAUfgNQu/PvDVHHOtz1n/PTqBd1wh3yo3VWuqV5li2XvOIKDXNVy
        jyDPoPRHDCttokytufWVxwiXij5jojdzI4AHbNjAze/IT7P8J9yyyegudFFm2BttcC3uZFRiJLq
        xulM4aWn2GBoa
X-Received: by 2002:aed:3be1:: with SMTP id s30mr24113989qte.163.1576496404872;
        Mon, 16 Dec 2019 03:40:04 -0800 (PST)
X-Google-Smtp-Source: APXvYqwXEbN84fE1lmg6l8FDj+7Ex2UZbgM0xB1RvZzIYTnBhmTSbs1wBzaphQsQXxfgMCt7496w3Q==
X-Received: by 2002:aed:3be1:: with SMTP id s30mr24113974qte.163.1576496404605;
        Mon, 16 Dec 2019 03:40:04 -0800 (PST)
Received: from redhat.com (bzq-111-168-31-5.red.bezeqint.net. [31.168.111.5])
        by smtp.gmail.com with ESMTPSA id u16sm5807903qku.19.2019.12.16.03.39.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 03:40:03 -0800 (PST)
Date:   Mon, 16 Dec 2019 06:39:56 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>,
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
Subject: Re: [PATCH 0/8] Simplify memory_region_add_subregion_overlap(...,
 priority=0)
Message-ID: <20191216063529-mutt-send-email-mst@kernel.org>
References: <20191214155614.19004-1-philmd@redhat.com>
 <CAFEAcA_QZtU9X4fxZk2oWAkN-zxXdQZejrSKZbDxPKLMwdFWgw@mail.gmail.com>
 <20191215044759-mutt-send-email-mst@kernel.org>
 <CAFEAcA9ZF3VTR7kG_D-cJ+vPFTgd8zjmt2VPfJC7urNemF-5AQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFEAcA9ZF3VTR7kG_D-cJ+vPFTgd8zjmt2VPfJC7urNemF-5AQ@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Dec 15, 2019 at 03:27:12PM +0000, Peter Maydell wrote:
> On Sun, 15 Dec 2019 at 09:51, Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Sat, Dec 14, 2019 at 04:28:08PM +0000, Peter Maydell wrote:
> > > (It doesn't actually assert that it doesn't
> > > overlap because we have some legacy uses, notably
> > > in the x86 PC machines, which do overlap without using
> > > the right function, which we've never tried to tidy up.)
> >
> > It's not exactly legacy uses.
> >
> > To be more exact, the way the non overlap versions
> > are *used* is to mean "I don't care what happens when they overlap"
> > as opposed to "will never overlap".
> 
> Almost all of the use of the non-overlap versions is
> for "these are never going to overlap" -- devices or ram at
> fixed addresses in the address space that can't
> ever be mapped over by anything else. If you want
> "can overlap but I don't care which one wins" then
> that would be more clearly expressed by using the _overlap()
> version but just giving everything that can overlap there
> the same priority.

Problem is device doesn't always know whether something can overlap it.
Imagine device A at a fixed address.
Guest can program device B to overlap the fixed address.
How is device A supposed to know this can happen?



> > There are lots of regions where guest can make things overlapping
> > but doesn't, e.g. PCI BARs can be programmed to overlap
> > almost anything.
> >
> > What happens on real hardware if you then access one of
> > the BARs is undefined, but programming itself is harmless.
> > That's why we can't assert.
> 
> Yeah, good point, for the special case where it's the
> guest that's determining the addresses where something's
> mapped we might want to allow the behaviour to fall out
> of the implementation. (You could instead specify set of
> priorities that makes the undefined-behaviour something
> specific, rather than just an emergent property of
> the implementation QEMU happens to have, but it seems
> a bit hard to justify.)
> 
> thanks
> -- PMM

