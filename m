Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37B656863B
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 11:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729534AbfGOJWk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 05:22:40 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:42887 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729428AbfGOJWk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 05:22:40 -0400
Received: by mail-oi1-f195.google.com with SMTP id s184so12089539oie.9;
        Mon, 15 Jul 2019 02:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HGv0/Y6Q5CSW+TZXfS+KyRIDJhAZnzyXylJ4U0lSago=;
        b=HR4T2wGmTxjwrjCuPorRbzw/ZPhpKnX/xnnZQC4pGlnpqhlFohBdpQ54QQJ1Fen2s4
         lztzFKUEA3FGyG6RwR178O5YUnVC9+aMIguQBV9wO1MWDEiVz1bOAd505niFavjGF3Fd
         9jBD4OEUZNKSHAL6kFBmkx1/2garlpWxH1Uv2oNqKyh+nNRR31f3gPOMb0D8blg4Rse5
         0xP1aKF5BTamURAVWQKyo9Fh/mIUHTjyYsXV85H8W6Pgc9vogtF3XDHNw/lWN6kJq09M
         F7BUv+e9Vyacg5LcMxVVX6rw+otdZyZYLGV5uCkeQ7hjC9XJ3bwkyf4ENGhj0yHOvrXz
         L69g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HGv0/Y6Q5CSW+TZXfS+KyRIDJhAZnzyXylJ4U0lSago=;
        b=VBLw1a7ZPlQRuV8AYndOljTQUskvYQNl0IOj9sG42MAGjFIiJKPNEKHYjp1Db3ZYBy
         XHfcETbMD+I6A3VWjAkKTnLlw6U+8BKBBikas1o+1OLk4Fax5vacQH6VXKsVVaC6wSyZ
         9P4iwoSrJD4DpNRt1fGza2VxAaayKZHIxF0f8cOe3v7itu4lWv5eurLCIVCafhC+Y9zR
         DVYV/PUcgmofzWva/MFaZiiwJwJ2T5CnSK2kQGceYKcLFBjdMXm+ZSHUYPoDxAc7zQRX
         EFigV7Km7bdYNW4BJblDbbJTwPyd61/oiEsGrFSG2mYniMZf1BlrJuv34BdwRewe8Rye
         menA==
X-Gm-Message-State: APjAAAWXpXEQNgKpeD9vNZTi/FkxMPGBPtrtlgtH0y3C0t15KbSoVypY
        j/yoDmh1yF5x4734lXBr1Hz+mySEVcNKAswyMFk=
X-Google-Smtp-Source: APXvYqx1cIOihWaijqt2/tEXzIt846Zv+/y3YtZ34qXZd0yq6TQMvItvUP6Z/a8OlQtd2+l9pCPpvE/4zp3LqWpWGo4=
X-Received: by 2002:aca:544b:: with SMTP id i72mr13225758oib.174.1563182559186;
 Mon, 15 Jul 2019 02:22:39 -0700 (PDT)
MIME-Version: 1.0
References: <1563154124-18579-1-git-send-email-wanpengli@tencent.com> <ba3ae595-7f82-d17b-e8ed-6e86e9195ce5@redhat.com>
In-Reply-To: <ba3ae595-7f82-d17b-e8ed-6e86e9195ce5@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 15 Jul 2019 17:22:30 +0800
Message-ID: <CANRm+Cyo9A5VsRRhgjzO9wkRRbTfc1xdzd=74f_bxGcu8+5hww@mail.gmail.com>
Subject: Re: [PATCH RESEND] i386/kvm: support guest access CORE cstate
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 15 Jul 2019 at 17:16, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 15/07/19 03:28, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Allow guest reads CORE cstate when exposing host CPU power management c=
apabilities
> > to the guest. PKG cstate is restricted to avoid a guest to get the whol=
e package
> > information in multi-tenant scenario.
> >
> > Cc: Eduardo Habkost <ehabkost@redhat.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
>
> Hi,
>
> QEMU is in hard freeze now.  This will be applied after the release.

Thanks for the information. :)

Regards,
Wanpeng Li
