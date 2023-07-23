Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8544B75E3F2
	for <lists+kvm@lfdr.de>; Sun, 23 Jul 2023 18:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbjGWQyX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Jul 2023 12:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbjGWQyV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Jul 2023 12:54:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63FF8E51
        for <kvm@vger.kernel.org>; Sun, 23 Jul 2023 09:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690131216;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MXAEtruEOpek6DTOxbT0kKpGf6aur2WifjckG9zBiIY=;
        b=UXUhurlioYO3ISc76aGB/q+8OEnPCDxAQo8MdzzL2z02N6hjQOIggHsAej/ly1EnF6sf7m
        6ubGimlU3iD1n5Je56rRL+pjPbSXbLFGzBi1gB6Hs1orhXGeQ5c1tAlDprWYBKxfNPbk0F
        FqVzXQxrHDeephZwcjq7t1xvwb6ah7A=
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com
 [209.85.217.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-635-gLY-I3hdOjm33kkH76CYyA-1; Sun, 23 Jul 2023 12:53:35 -0400
X-MC-Unique: gLY-I3hdOjm33kkH76CYyA-1
Received: by mail-vs1-f70.google.com with SMTP id ada2fe7eead31-440c41fd28eso502271137.2
        for <kvm@vger.kernel.org>; Sun, 23 Jul 2023 09:53:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690131214; x=1690736014;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MXAEtruEOpek6DTOxbT0kKpGf6aur2WifjckG9zBiIY=;
        b=CBpsY0mLyT6OufrB5hdJQ5Sr6tUxOMvFenmVIuDBbrUF5VGOvCcbRD6LQOqpjDFwJl
         7sM0fFSM0Jk4DdGy95RiTka5/Bc0jIZHMf9qrNINSK6SUk0sT5Kst/zyXwBvr/8iM/Gl
         wY2epd+4muwgPCp3PWe3vOkB4JYDXh96gAtoxcIWC6qaVwUSpySQsth9Ey2miFJN2AkP
         LKNCIW9x8SYbegVFmgevdiBabpgAbXCKpsYNa0Y7ymflBHQfcQLmog0oeo1AyAuM/PU/
         nvfyrvLDcsE6M2J5EtABvGsDwwVcnhQybYjEM2xcggwOWRtPumrH/pkQV2aFcmQ/AB6q
         0GHA==
X-Gm-Message-State: ABy/qLaCn/A4ZvbE1OLPJkQk67jlB5lCsJfxYbgfJDIIWpdvEH4NehQa
        +QKaIFTN60u/5Edhf005m5+fYHZ3DFQK54j7DKD6Xz0RQM9UEOdHJ4ppW27jp9iHOtq6r31nRzn
        8k1NGw6TQiaKOFqvACPF1zKU4iP7d
X-Received: by 2002:a05:6102:34e3:b0:443:8549:163e with SMTP id bi3-20020a05610234e300b004438549163emr1681704vsb.34.1690131214618;
        Sun, 23 Jul 2023 09:53:34 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGPjxmZApydLJ4h1+i8A/2WOOirRu4Yg0pFTCJxr7FyC1UYCFWOzhga0Hm2IJntT9NLSoBiu0xUrsvUMuw7GAw=
X-Received: by 2002:a05:6102:34e3:b0:443:8549:163e with SMTP id
 bi3-20020a05610234e300b004438549163emr1681702vsb.34.1690131214370; Sun, 23
 Jul 2023 09:53:34 -0700 (PDT)
MIME-Version: 1.0
References: <20230718132300.34947-1-imbrenda@linux.ibm.com>
In-Reply-To: <20230718132300.34947-1-imbrenda@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Sun, 23 Jul 2023 18:53:21 +0200
Message-ID: <CABgObfbN+vgoVS2ZrqAh+9mNYs9fun7R0durvgst6H0EenWR1Q@mail.gmail.com>
Subject: Re: [GIT PULL 0/2] KVM: s390: pv: Two small fixes for 6.5
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, borntraeger@de.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 18, 2023 at 3:23=E2=80=AFPM Claudio Imbrenda <imbrenda@linux.ib=
m.com> wrote:
>
> Hi Paolo,
>
> just two small bugfixes for asynchronous destroy.
>
>
> please pull, thanks!

Done, thanks.

Paolo

>
> Claudio
>
>
> The following changes since commit fdf0eaf11452d72945af31804e2a1048ee1b57=
4c:
>
>   Linux 6.5-rc2 (2023-07-16 15:10:37 -0700)
>
> are available in the Git repository at:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/=
kvm-s390-master-6.5-1
>
> for you to fetch changes up to c2fceb59bbda16468bda82b002383bff59de89ab:
>
>   KVM: s390: pv: fix index value of replaced ASCE (2023-07-18 11:21:51 +0=
200)
>
> ----------------------------------------------------------------
> Two fixes for asynchronous destroy
>
> ----------------------------------------------------------------
> Claudio Imbrenda (2):
>       KVM: s390: pv: simplify shutdown and fix race
>       KVM: s390: pv: fix index value of replaced ASCE
>
>  arch/s390/kvm/pv.c  | 8 ++++++--
>  arch/s390/mm/gmap.c | 1 +
>  2 files changed, 7 insertions(+), 2 deletions(-)
>
> --
> 2.41.0
>

