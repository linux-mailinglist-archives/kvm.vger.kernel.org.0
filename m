Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF64774D6F8
	for <lists+kvm@lfdr.de>; Mon, 10 Jul 2023 15:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbjGJNI7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 09:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231383AbjGJNH5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 09:07:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95C3310E5
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 06:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688994333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cSSXjKtHNo2g+s4fKQO8ycwZ9VSR9y5qDmg/kPz0J+8=;
        b=NDekGdoVFuvPxqBPm/p8URYHUEwrlee7pnACszE4CztEXS8QClMi+uhA/7W5iKi6rNAU7A
        ImwAW4o9H6riexZj7hlloOSE6AgNJcBLna4YcmqgtWhnM3Q8sxoa2otZsO/plrPDDIJjjv
        S03AAqBX54a0A6gBqFiIzhASVHqu3NQ=
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com
 [209.85.219.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-487-5azR2XT7POy6aYmWVqL_PQ-1; Mon, 10 Jul 2023 09:05:32 -0400
X-MC-Unique: 5azR2XT7POy6aYmWVqL_PQ-1
Received: by mail-yb1-f199.google.com with SMTP id 3f1490d57ef6-c0f35579901so5453172276.0
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 06:05:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688994331; x=1691586331;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cSSXjKtHNo2g+s4fKQO8ycwZ9VSR9y5qDmg/kPz0J+8=;
        b=Ue/2VdnNzcvvg7ubEnuROoHluEsJZvbLnmMA5Ekg1mol9JB5jhz2LoauOTJkhVG1/7
         okJjXZoLnptQZ+R8/Dxk+m1u9ZrMh/mSHr65/Hst75ce+Mx3CLnyFA+eo7GEUTrHJnJo
         YXMFdXemIKCOTQgx599zV+oXGmlNmsTFHxvTkspScoJu4+05pblSOcQ46DBLGgBa9L4R
         N9lwTbShnIYRJJ2hWKrofeFRIjCj4R7oqx9+8SJGs10W9d46kKbdJH8o4fK235WIm+cR
         3mq2KkMzAhAgVkE2xoDsn4YGhXJPc2vVwh0yNyslcAi3a0yvm6n4FAry7EcbV2gZfMcC
         5vPg==
X-Gm-Message-State: ABy/qLaqQoKvqLxFueIEhnUKeG+X1EkE/ZKnSe2/tM+jtmLiQd46eIya
        FqtpPKMMg94aMHO2MBTeDzq5p1kUDvJCxJ7qej9K1vEIlF0jB0gY2lgBpuiGIq47Cx27n8hqUP1
        /MTLa0kCUnCYeDYXwO92Bi5/u3WL8
X-Received: by 2002:a25:1f02:0:b0:c67:8903:532b with SMTP id f2-20020a251f02000000b00c678903532bmr9557475ybf.44.1688994331566;
        Mon, 10 Jul 2023 06:05:31 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFYCDVRqXESu2lKlw5OOq57+bm9EWCrFUc3sqkdq7rbGFO3X2AFRnXejnh8LqRK8eFbanSG74Fa5+uKsOptTgw=
X-Received: by 2002:a25:1f02:0:b0:c67:8903:532b with SMTP id
 f2-20020a251f02000000b00c678903532bmr9557452ybf.44.1688994331376; Mon, 10 Jul
 2023 06:05:31 -0700 (PDT)
MIME-Version: 1.0
References: <20230710130113.14563-1-tzimmermann@suse.de> <20230710130113.14563-11-tzimmermann@suse.de>
In-Reply-To: <20230710130113.14563-11-tzimmermann@suse.de>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Mon, 10 Jul 2023 15:05:19 +0200
Message-ID: <CAO-hwJLvBpNu1z4qM9+331-oUroh4g5HORL=EZS0nb+HHe+fdw@mail.gmail.com>
Subject: Re: [PATCH 10/17] hid/picolcd: Remove flag FBINFO_FLAG_DEFAULT from
 fbdev driver
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     deller@gmx.de, javierm@redhat.com, linux-sh@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, linux-input@vger.kernel.org,
        linux-media@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-staging@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org,
        linux-geode@lists.infradead.org, linux-nvidia@lists.surfsouth.com,
        linux-hyperv@vger.kernel.org, linux-omap@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        =?UTF-8?Q?Bruno_Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
        Jiri Kosina <jikos@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 10, 2023 at 3:01=E2=80=AFPM Thomas Zimmermann <tzimmermann@suse=
.de> wrote:
>
> The flag FBINFO_FLAG_DEFAULT is 0 and has no effect, as struct
> fbinfo.flags has been allocated to zero by framebuffer_alloc(). So do
> not set it.
>
> Flags should signal differences from the default values. After cleaning
> up all occurences of FBINFO_FLAG_DEFAULT, the token can be removed.
>
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: "Bruno Pr=C3=A9mont" <bonbons@linux-vserver.org>
> Cc: Jiri Kosina <jikos@kernel.org>
> Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Acked-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Feel free to take this through the DRI tree (or any other that handles
FB) with the rest of the series if you want.

Cheers,
Benjamin

> ---
>  drivers/hid/hid-picolcd_fb.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/hid/hid-picolcd_fb.c b/drivers/hid/hid-picolcd_fb.c
> index dabcd054dad9..d726aaafb146 100644
> --- a/drivers/hid/hid-picolcd_fb.c
> +++ b/drivers/hid/hid-picolcd_fb.c
> @@ -527,7 +527,6 @@ int picolcd_init_framebuffer(struct picolcd_data *dat=
a)
>         info->var =3D picolcdfb_var;
>         info->fix =3D picolcdfb_fix;
>         info->fix.smem_len   =3D PICOLCDFB_SIZE*8;
> -       info->flags =3D FBINFO_FLAG_DEFAULT;
>
>         fbdata =3D info->par;
>         spin_lock_init(&fbdata->lock);
> --
> 2.41.0
>

