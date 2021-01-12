Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 018322F3D71
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 01:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406646AbhALVgw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 16:36:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437013AbhALUmG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 15:42:06 -0500
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13393C0617A2
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 12:40:56 -0800 (PST)
Received: by mail-oo1-xc34.google.com with SMTP id o5so900803oop.12
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 12:40:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GOqyNTF7gtUKPVXIMkVFT3geI3snsFvpWMRi06NItYY=;
        b=ZhmlJV62BeU9fJsGlfyvETF+LCKlVC2NajZUVYu+YTBpcA7oEZg+f+cRZvbeGR/wRn
         OE8OA5J2WD9Pyviogsk4vAUx0oNQmVzR8vJjuNxc6R/JAdYYrMuliwJOKaeispULA4s3
         Paz/kpI+jzpctNP+2Igp6sNge3FY1sSX/OxQO1Mm77d4BSdi0VixLEpB9NM9zsJDNE17
         nTGyKfNHi0f22Ba4gFcYkm4igDeQKN59JTV5QfhwG9iHkwNEih7lMpfyyre20lo295AS
         5hblNfZ5Rfz6/jFNkOzYEb9rWjcEeyiCbtE5JTqFWgE0Ik2pVEOWGwT+0JfXpFcHqAKJ
         wqOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GOqyNTF7gtUKPVXIMkVFT3geI3snsFvpWMRi06NItYY=;
        b=MDy3padRQGUE2w7bAA08GvtLpPq8e/pavdq+2agDSrWn7eM81J75pAmFMlHkyRAd+v
         E4FpWdAFjKrZXsSYZYJ2oXAZbIX+i6iLGMb02b6zeDBrYzMuoS+7Vehndlcb9vG0pzBM
         eOnT8a5Q4+mJj6gPxJ6uA8Sn7wO+uAoxFtdwGTWPZJHeJXlXut1e+dmkwwVamYqtip3Z
         ri8NwV4HahG7UrFavPTquUlrTCcb9mAFKJzlaApAEonZPKRfybA2YZJLWI+pLZqs/Nea
         OqYv4Z5TK1aGb0DSwpRo1ePR2DYkLRP9V/KxMpuTdedlcLMKBIN9/UHwlbDChXqEb+gP
         +OUA==
X-Gm-Message-State: AOAM530+WiDLKNFVq30BGmxCyprdpTBT1R0A3k4CPj5RajE+wgWd6a3L
        qqWn2DiMqBz7gluE8JBFfRSdxg/mlf2DsXYFHDmjhQ==
X-Google-Smtp-Source: ABdhPJz/+VG3D8S0Su6wBVIT9oU9vLMwvxqzB/oumqqIsu0lWVXQRoNiE9y/Wv8b1dAsLKpTLLAHvt9lQNMSp/UwXic=
X-Received: by 2002:a4a:d396:: with SMTP id i22mr552498oos.55.1610484054385;
 Tue, 12 Jan 2021 12:40:54 -0800 (PST)
MIME-Version: 1.0
References: <20210112194143.1494-1-yuri.benditovich@daynix.com> <20210112194143.1494-4-yuri.benditovich@daynix.com>
In-Reply-To: <20210112194143.1494-4-yuri.benditovich@daynix.com>
From:   Yuri Benditovich <yuri.benditovich@daynix.com>
Date:   Tue, 12 Jan 2021 22:40:42 +0200
Message-ID: <CAOEp5Ocz-xGq5=e=WY0aipEYHEhN-wxekNaAiqAS+HsOF8TcDQ@mail.gmail.com>
Subject: Re: [RFC PATCH 3/7] tun: allow use of BPF_PROG_TYPE_SCHED_CLS program type
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, rdunlap@infradead.org,
        willemb@google.com, gustavoars@kernel.org,
        herbert@gondor.apana.org.au, steffen.klassert@secunet.com,
        pablo@netfilter.org, decui@microsoft.com, cai@lca.pw,
        jakub@cloudflare.com, elver@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        bpf@vger.kernel.org
Cc:     Yan Vugenfirer <yan@daynix.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 12, 2021 at 9:42 PM Yuri Benditovich
<yuri.benditovich@daynix.com> wrote:
>
> This program type can set skb hash value. It will be useful
> when the tun will support hash reporting feature if virtio-net.
>
> Signed-off-by: Yuri Benditovich <yuri.benditovich@daynix.com>
> ---
>  drivers/net/tun.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 7959b5c2d11f..455f7afc1f36 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -2981,6 +2981,8 @@ static int tun_set_ebpf(struct tun_struct *tun, struct tun_prog __rcu **prog_p,
>                 prog = NULL;
>         } else {
>                 prog = bpf_prog_get_type(fd, BPF_PROG_TYPE_SOCKET_FILTER);
> +               if (IS_ERR(prog))
> +                       prog = bpf_prog_get_type(fd, BPF_PROG_TYPE_SCHED_CLS);
>                 if (IS_ERR(prog))
>                         return PTR_ERR(prog);
>         }

Comment from Alexei Starovoitov:
Patches 1 and 2 are missing for me, so I couldn't review properly,
but this diff looks odd.
It allows sched_cls prog type to attach to tun.
That means everything that sched_cls progs can do will be done from tun hook?
sched_cls assumes l2 and can modify the packet.
I think crashes are inevitable.

> --
> 2.17.1
>
