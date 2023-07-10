Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A46EE74D8F1
	for <lists+kvm@lfdr.de>; Mon, 10 Jul 2023 16:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233207AbjGJOYf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 10:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233175AbjGJOYc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 10:24:32 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C13F1AC;
        Mon, 10 Jul 2023 07:24:24 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id 3f1490d57ef6-bc379e4c1cbso5775768276.2;
        Mon, 10 Jul 2023 07:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688999063; x=1691591063;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xfaw5NXpBN+ToDeNW38gue7dW1/lsMjnYJ8JVvMgX/M=;
        b=QzKFYEuEyJBmyVNrCTuM3xu2kiOzdJ733dpATnK2KIsTftxaxQrkFSHDoRvXkS62Q1
         ZzwxUIDQFUGUncjgMsGBUdc5tMOXaMH7dl8GnPzoL/6n9pZw09b0ZmaNjHrbLutDuZJh
         a/IGw3N3kW+LesbGXy/lgYCtStCtLi8WbADaDxdcgg/i72vh0e80Elo65bRMQQIf0Aii
         gN8CYJcj/oLYPQitrqhEbeCC8Dqly+59rFrVMMzcHkBCY8kPruGJfjOthtbaTFipQd0Y
         imjIM+aDF60N/+bSFzJQShrBYNXK2Y2WrWcLMYmFYY7kegF/rtNVJpKE8Vnnw/jKXqh9
         IERA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688999063; x=1691591063;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xfaw5NXpBN+ToDeNW38gue7dW1/lsMjnYJ8JVvMgX/M=;
        b=dkgjvQQbA7Bsa6FPocWWyxfKBRHldYn6njLAJw5UlyV79tnp4Aan3WCL2GUGgbS4WC
         5LQvl/wpMZl94lngkgg381DgQ7M4hOoCCplP9fCRw7xHz/2uWKAzD5i5wbfbqY9NvVgl
         RcP1u6fU5kdzFfgApXRKHA5eCv4zpGyHhaOU/Ai0aDSGtPmskf52e7nTiTVgplqncYYz
         6ToH6Hdo7+fDbDfx99aIyN8n//ZXDV5QWB3tmz/tMmfTFMZVQKMjg3DPKmVsHprZducs
         CHwEbTr1hFE9SWDghmjfbkeWTyfTYAXbwSeQw/SE9sQpWXgHbvPSiBCSSIKPEaZMyNno
         LBIQ==
X-Gm-Message-State: ABy/qLZV8tDV+voM+Hrr2imJKR76niApN022Qt5cJxDP4uQD9mBtPCIh
        tS2cCTC4oo2od924Dl/ho8kJXsaes2MxyYSH+nA=
X-Google-Smtp-Source: APBJJlFF/ZPZBeFTUlJJsVw6gvqSC+NnftxoKLaqOH3sDOKdvIyhB4DTRi4Sp3yg5NFbGfCt55R+jTwkG5L/EeefwtY=
X-Received: by 2002:a25:842:0:b0:bd7:6810:6646 with SMTP id
 63-20020a250842000000b00bd768106646mr12374371ybi.44.1688999063346; Mon, 10
 Jul 2023 07:24:23 -0700 (PDT)
MIME-Version: 1.0
References: <20230710130113.14563-1-tzimmermann@suse.de> <20230710130113.14563-10-tzimmermann@suse.de>
In-Reply-To: <20230710130113.14563-10-tzimmermann@suse.de>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Mon, 10 Jul 2023 16:24:12 +0200
Message-ID: <CANiq72=9PoV3FOcXx9FdiSLePKXDG4BSY_5-jddBkqDL=ua3FA@mail.gmail.com>
Subject: Re: [PATCH 09/17] auxdisplay: Remove flag FBINFO_FLAG_DEFAULT from
 fbdev drivers
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
        Miguel Ojeda <ojeda@kernel.org>,
        Robin van der Gracht <robin@protonic.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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

`framebuffer_alloc()` does indeed use `kzalloc()`, but the docs do not
mention the zeroing. Should that guarantee be documented?

> Flags should signal differences from the default values. After cleaning
> up all occurences of FBINFO_FLAG_DEFAULT, the token can be removed.

occurences -> occurrences

can -> will maybe? Since the intention of the patch series is to
remove it (them) altogether).

Thanks!

Cheers,
Miguel
