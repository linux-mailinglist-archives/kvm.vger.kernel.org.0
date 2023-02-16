Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20B54699C68
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 19:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbjBPShT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 13:37:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbjBPShS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 13:37:18 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09531A488
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 10:37:11 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-4cddba76f55so29836687b3.23
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 10:37:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ksbzkRXE/JS/W0+wuWEP51+Px76UP+MTJknwcR2OxYA=;
        b=HOou0cn+O+Cn+zaA5Js8kqXP0pHL+tzhW3BZfhadB1+IT2Wvi5cFGLnJPjwNJyV1XL
         WGWiYPo0N7wgo7LG2uC+rtNrDw8a14+tquWecN4k3h+upfsRsTiSc6gTcYAORRfI8odw
         cuO0B0Pl7fCGoBbSEO/pgFbjXmzkfWho0RDT+6OBcAzXByCrPrEVfKp/K6dxNHEP5pyd
         4RvyNFYy8R8U+HMnKCYItQ2JmGqrEwHz/xWPan696rLLoM1xO21Nct2BzGqFBebF4jQi
         nQX7RxHLxSVTnNS17BR2yowmVhlbN4tDCvgxfaakrq8fXxytIKya0ZWNJlBEwT0z9Squ
         H39g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ksbzkRXE/JS/W0+wuWEP51+Px76UP+MTJknwcR2OxYA=;
        b=Z5Rsxa8ugz1wtKGhIVm81NJ9KKY5YBmAcz8ZFQg9c6hrh4h6KE9dZp5XAIKzuQHG06
         /lE1MSapar5G+BbDwInMBwCpcjlpmdqI08C2aIDXikC/Czw5Ous0vUvj6LIAsur/Xa6O
         eWS84/gDHnKL7vPhbLp9eJoaLlBhD5bwvJYMGganhB0Z/zOgxZNOci8OfgTBoAS2jic1
         tPTpln/WCiAUDDHh4L4Tzi59oJvF+7a/h0zMYjUFgLMqFaYDzGaDwWuEkD2k1q4Pjawj
         gDPL6jwR0wlU5tAmsJXgLOrpDjfgeAou2N6fUDTAhXTZZ7/tDUICNY18zD6od8eGHthM
         yG8Q==
X-Gm-Message-State: AO0yUKUjHmWvBZ0LzSVhKUx1OQFJXcdCDsa09Qm1hLf4YbZbk+0nAthC
        oRPwyboiBQSsVDyro2W8KEmMsx2Bnls=
X-Google-Smtp-Source: AK7set9FC37TETZLek6ManiQtw89cTALH4cPfGew4iMbQvxpHiSKs9rZtjcJmcWpnx/5yFRsj23JzcEeuxQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:9e0a:0:b0:8a0:96fa:f8f1 with SMTP id
 m10-20020a259e0a000000b008a096faf8f1mr1015418ybq.535.1676572631114; Thu, 16
 Feb 2023 10:37:11 -0800 (PST)
Date:   Thu, 16 Feb 2023 10:37:09 -0800
In-Reply-To: <BYAPR12MB3014D1E557077CB76DEA019DA0A09@BYAPR12MB3014.namprd12.prod.outlook.com>
Mime-Version: 1.0
References: <c0bf0011-a697-da29-c2d2-8c16e9df21cf@outlook.com>
 <BYAPR12MB301441A16CE6CFFE17147888A0A09@BYAPR12MB3014.namprd12.prod.outlook.com>
 <Y+52DQQT+N/4gWDb@google.com> <BYAPR12MB3014D1E557077CB76DEA019DA0A09@BYAPR12MB3014.namprd12.prod.outlook.com>
Message-ID: <Y+531ch/dAfdJbYV@google.com>
Subject: Re: Fwd: Windows 11 guest crashing supposedly in smm after some time
 of use
From:   Sean Christopherson <seanjc@google.com>
To:     "=?utf-8?Q?Micha=C5=82?= Zegan" <webczat@outlook.com>
Cc:     kvm@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Maxim

On Thu, Feb 16, 2023, Micha=C5=82 Zegan wrote:
> What these issues were? I don't have a quick ability to test kernel 6.2, =
but
> fedora will receive it, so I will definitely get a chance. Can you give m=
e
> any pointers so that I can see whether it could be related?

I don't know the details, we (Google) don't rely on emulating SMM to suppor=
t secure
boot.

Maxim, do you have any pointers for determining whether or not the KVM SMM =
issues
might be related?

> W dniu 16.02.2023 o=C2=A019:29, Sean Christopherson pisze:
> > On Thu, Feb 16, 2023, Micha=C5=82 Zegan wrote:
> > > Resending to kvm mailing list, in case someone here might help... Als=
o will
> > > try again with newer ovmf, but assume it happens.
> > > I have windows11 installed on a vm. This vm generally works properly,=
 but
> > > then might crash unexpectedly at any point, this includes situation l=
ike
> > > logging onto the system and leaving it intact for like an hour or les=
s. This
> > > can be reproduced by waiting long enough but there is no single known=
 action
> > > causing it.
> > >=20
> > > What could be the problem?
> > >=20
> > >=20
> > > Configuration and error details:
> > >=20
> > > My host is a msi vector gp76 laptop with intel core i7 12700h, 32gb o=
f
> > > memory, host os is fedora linux 37 with custom compiled linux kernel =
(fedora
> > > patches). Current kernel version is 6.1.10 but when I installed the v=
m it
> > > was 6.0 or less, don't quite remember exactly, and this bug was prese=
nt. Not
> > > sure if bios is up to date, but microcode is, if that matters.
> > ...
> >=20
> > > Guest is windows 11 pro 64 bit.
> > >=20
> > > What crashes is qemu itself, not that the guest is bsod'ing.
> > Can you try a 6.2 or later kernel?  E.g. Linus' HEAD, linux-next, kvm/q=
ueue, etc.
> > KVM had a pile of SMM fixes[*] merged for 6.2 specifically aimed at fix=
ing issues
> > with secure boot of Windows 11 guest.  They aren't likely to be backpor=
ted to LTS
> > kernels as they aren't easily consumable (though I'm guessing software =
vendors
> > will end up backporting to their supported kernels).
> >=20
> > [*] https://na01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2F=
lore.kernel.org%2Fall%2F20221025124741.228045-1-mlevitsk%40redhat.com&data=
=3D05%7C01%7C%7Ced887369e7a446c55aa208db104bc18f%7C84df9e7fe9f640afb435aaaa=
aaaaaaaa%7C1%7C0%7C638121689771499220%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wL=
jAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&sdata=
=3DoTa%2BDEScxiIn%2Fqd3KRUtqiegCv2J8p6RpZ%2Flnm%2F1f1I%3D&reserved=3D0
>=20
