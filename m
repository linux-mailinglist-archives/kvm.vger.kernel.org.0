Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6556D5914C5
	for <lists+kvm@lfdr.de>; Fri, 12 Aug 2022 19:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239332AbiHLR1k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Aug 2022 13:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239300AbiHLR1Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Aug 2022 13:27:25 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECF7AB24AB
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 10:27:23 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id k26so3142244ejx.5
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 10:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=ChOW1PQzKsYV5AuJvIO5rrdP9iRv4CAXA2GkbHvGLP8=;
        b=AcuJfCLjjk/3yWDj6vISld0k0uJ+mzaUGVzwSXP5TW12cs+txfc9d62ah873KGN1h9
         S9JB3+nbjF5MOah9t/4LendfkWFi9hj208a455CsFjsib04F5n9fiE0jaUacbeVLavPM
         k5Mi2DA6Wwvrd99Zd1zwv/yXnVQ3ZozTK8JSs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=ChOW1PQzKsYV5AuJvIO5rrdP9iRv4CAXA2GkbHvGLP8=;
        b=Qgi+u2P62ihZF2/UJFYxqqBfv6+H/S1Q3yZYWGVgG3fq7cf2NiwyXryoUrjGwJfDl9
         gd+n0bW/qJmfUU1QKhoP9GcjNwDsFqrIq0AXsibiTe/UZJmCg46fj1Ec+h+07CEMwvAC
         X4BGynxyIJ2/6RqCQxdVoOxWuetyF7svhfb4rRAbBQG2y2OLWlbsFHdcDAHd9GkRQIpM
         cGOhERN1K5kOATFTALGbX5Cjkl5dZTaWDpAuKJoKRIC8/CIppxPWR9t7Ts13IrH6p7yv
         uPQQQSAk1A+9DIG3NFBfdExHYn/Ud97L4p9VaigiQjqx7vrt5kYQpY8HQ8xelKR1/JwR
         8KWg==
X-Gm-Message-State: ACgBeo2/jzt4WJczIHzjMGLLjrd4R3bSdlW4TslBE9tTU5P1j8wMvHnL
        xkD8R71UFJWoMoxKfc6OOpGOyE+6nXoXWQed
X-Google-Smtp-Source: AA6agR6XaDpF+eoms/EuRYcFzhKbMDHca7G3OmwC/eaGZiTPQpzTmEvygKdrkEVS5k4Cgi0NXkeQ/A==
X-Received: by 2002:a17:907:1b1b:b0:72f:4445:3c11 with SMTP id mp27-20020a1709071b1b00b0072f44453c11mr3260983ejc.714.1660325242216;
        Fri, 12 Aug 2022 10:27:22 -0700 (PDT)
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com. [209.85.221.43])
        by smtp.gmail.com with ESMTPSA id f11-20020a05640214cb00b0043a5bcf80a2sm1627315edx.60.2022.08.12.10.27.20
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Aug 2022 10:27:20 -0700 (PDT)
Received: by mail-wr1-f43.google.com with SMTP id n4so1861627wrp.10
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 10:27:20 -0700 (PDT)
X-Received: by 2002:a5d:56cf:0:b0:21e:ce64:afe7 with SMTP id
 m15-20020a5d56cf000000b0021ece64afe7mr2686887wrw.281.1660325240290; Fri, 12
 Aug 2022 10:27:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220811153632.0ce73f72.alex.williamson@redhat.com>
 <CAHk-=wgfqqMMQG+woPEpAOyn8FkMQDqxq6k0OLKajZNGa7Jsfg@mail.gmail.com> <YvaGrD94Ttd8lGWi@nvidia.com>
In-Reply-To: <YvaGrD94Ttd8lGWi@nvidia.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 12 Aug 2022 10:27:04 -0700
X-Gmail-Original-Message-ID: <CAHk-=whXbDkQQUjF1mLPoMkhbJpv1jQtsazWwDGMF9vw1tx+vA@mail.gmail.com>
Message-ID: <CAHk-=whXbDkQQUjF1mLPoMkhbJpv1jQtsazWwDGMF9vw1tx+vA@mail.gmail.com>
Subject: Re: [GIT PULL] VFIO updates for v6.0-rc1 (part 2)
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000029088505e60e9807"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--00000000000029088505e60e9807
Content-Type: text/plain; charset="UTF-8"

On Fri, Aug 12, 2022 at 9:58 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> I think this is partly a historical artifact because each of the files
> in the directory are compiling to actual kernel modules so the file
> name has to have vfio_ in it to fit into the global module namespace.
>
> Now, there is no reason I can see for all these files to be different
> modules, but that is how it is, and because we have some module
> parameters changing it is API breaking..

Oh, the module name issue is absolutely real.

But we actually have good tools for that in the kernel build system,
because we've had that issue for so long, and because it's not at all
uncommon that one single kernel module needs to be built up from
multiple different object files.

I guess it does require an extra lines in the Makefile. Maybe we could
improve on that, but that extra line does end up having real
advantages in that it makes for a lot of flexibility (see below).

Attached is a truly *stupid* patch just to show the concept. I
literally just picked one vfio file at random to convert. The point
being that this approach

 (a) makes it very easy to have the file naming you like

 (b) makes it *very* easy to have common helper libraries that get
linked into the modules

 (c) also means that it's now basically trivial to split any of these
drivers into multiple files, exactly because the file name isn't tied
to the module name

where that extra line is exactly what makes (b) and (c) so trivial.

Now, don't get me wrong: this patch is *not* meant to be a "please do
this". If people really like the current odd file naming policy, it's
really not a lot of skin off my nose.

So the attached patch is literally meant to be a "look, if you want to
do this, it's really this simple".

And you can easily do it one driver at a time, possibly when  you have
a "oops, this one driver is getting a bit large, so I'd like to split
it up".

Also, it should go without mention that I've not actually *tested*
this patch. I did do a full build, and that full build results in a
vfio_iommu_type1.ko module as expected, but there might be something I
overlooked.

There's also some build overhead from the indirection, but hey, what
else is new. Our Makefiles are actually quite powerful, but they do
make 'GNU make' spend a *lot* of time doing various string tricks.

                    Linus

--00000000000029088505e60e9807
Content-Type: text/x-patch; charset="US-ASCII"; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_l6qqrda10>
X-Attachment-Id: f_l6qqrda10

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmZpby9NYWtlZmlsZSBiL2RyaXZlcnMvdmZpby9NYWtlZmls
ZQppbmRleCAxYTMyMzU3NTkyZTMuLjQxZWQ1MjhjNzU4NyAxMDA2NDQKLS0tIGEvZHJpdmVycy92
ZmlvL01ha2VmaWxlCisrKyBiL2RyaXZlcnMvdmZpby9NYWtlZmlsZQpAQCAtMyw2ICszLDggQEAg
dmZpb192aXJxZmQteSA6PSB2aXJxZmQubwogCiB2ZmlvLXkgKz0gdmZpb19tYWluLm8KIAordmZp
b19pb21tdV90eXBlMS15ID0gaW9tbXVfdHlwZTEubworCiBvYmotJChDT05GSUdfVkZJTykgKz0g
dmZpby5vCiBvYmotJChDT05GSUdfVkZJT19WSVJRRkQpICs9IHZmaW9fdmlycWZkLm8KIG9iai0k
KENPTkZJR19WRklPX0lPTU1VX1RZUEUxKSArPSB2ZmlvX2lvbW11X3R5cGUxLm8KZGlmZiAtLWdp
dCBhL2RyaXZlcnMvdmZpby92ZmlvX2lvbW11X3R5cGUxLmMgYi9kcml2ZXJzL3ZmaW8vaW9tbXVf
dHlwZTEuYwpzaW1pbGFyaXR5IGluZGV4IDEwMCUKcmVuYW1lIGZyb20gZHJpdmVycy92ZmlvL3Zm
aW9faW9tbXVfdHlwZTEuYwpyZW5hbWUgdG8gZHJpdmVycy92ZmlvL2lvbW11X3R5cGUxLmMK
--00000000000029088505e60e9807--
