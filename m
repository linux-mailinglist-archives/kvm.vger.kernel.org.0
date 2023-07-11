Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1218C74EB69
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 12:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbjGKKD4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 06:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbjGKKDm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 06:03:42 -0400
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E02F412E;
        Tue, 11 Jul 2023 03:03:38 -0700 (PDT)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-1b449890ef5so4267656fac.1;
        Tue, 11 Jul 2023 03:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689069818; x=1691661818;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f+EdWg+i/tz1eYpH9ck9/qmxGmzdGcH8THqJbinUddk=;
        b=NyI0NAaMqg06KA6hwBSQgBEB85LCB8gClAXi9s9KdtyJxX2aBORKelElCulIdppHS6
         B2KpbjTxVS2+wUc9g/u+o+ZwR99AGXRU021BosfNDYuk/lbxfTcwf4poeCIl1pjSfmvJ
         5jkEpuK/djrhv1A7k5tWeHiTtBppXhqwoEPSSNpCFuvfRbFDru0owVW8nZGMH4e28CJA
         37otT/of6vfb688RtJjgE4uuPquRo2iO+FPZYJPBc0xkoWD8nJuSeik7gJXt88UxhuU5
         ynGI8Mdwz40F9nADl3/OzgmP0F+m9xzz5dHEj+Nekn9xjmNXbRk7FYYufVHEanQb1xEP
         DNog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689069818; x=1691661818;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f+EdWg+i/tz1eYpH9ck9/qmxGmzdGcH8THqJbinUddk=;
        b=DKtFHwI4mNYoktvamMJLiGBJsqpCY93EK9gWGWO10vn2JMIvQNDT/Rj/cl8I84rs63
         Rcxz8M7GSP+5VkEgNcGlr1xDilPjTDjJrohMQciOsVJwcBLrfecx3sQbe0GkgH3fxLXz
         PiakuBuepb7i52GHEjoMMAXMhlokEdb851OAffuZBc3b4MbmM6IMTs+H60iR9zRwJYE/
         5PwBzAsA9ML7Javyk2+G3r8HJNxzGkA1l+rP5evhgPZhcB8ORqWLo5QSg4+0AYJRUuau
         VgrkDaLyb19strSLRCBPafLA/9K0eoIBzBcZQvABDiU5YyTagILGctjtD3J1+Gfx5fz8
         3bMA==
X-Gm-Message-State: ABy/qLa0mi2bB/HsgkcvRIOdss77wEjB7kFexQvYoFJQTE/H0NVtzovP
        MG/wDDcLjwjycMI0l92EVdQwH1o1k420cwygTJU=
X-Google-Smtp-Source: APBJJlGGsUuf+V3qoT11Pogf+mqcTAutGtQX8L+sFbR9xMxcqCOg1dWiYkpNfhV8TDJxJAkM3OI/WYW3QCrNv2zauGo=
X-Received: by 2002:a05:6870:420f:b0:1a5:4e57:e5d1 with SMTP id
 u15-20020a056870420f00b001a54e57e5d1mr19457972oac.49.1689069818163; Tue, 11
 Jul 2023 03:03:38 -0700 (PDT)
MIME-Version: 1.0
References: <20230710130113.14563-1-tzimmermann@suse.de> <20230710130113.14563-10-tzimmermann@suse.de>
 <CANiq72=9PoV3FOcXx9FdiSLePKXDG4BSY_5-jddBkqDL=ua3FA@mail.gmail.com>
 <733273ad-89e1-d952-37ee-bb75c3ab8188@suse.de> <CANiq72kPh2KE=ADUxhPyyr7noWhC0fkzmDu8EBn_20focnZqtw@mail.gmail.com>
 <745347ca-a369-eb01-eac4-75c09cf9e67f@suse.de>
In-Reply-To: <745347ca-a369-eb01-eac4-75c09cf9e67f@suse.de>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Tue, 11 Jul 2023 12:03:27 +0200
Message-ID: <CANiq72kg_2PxmSnyj_X7Rak0-fmPP+W-+2EKFjyXCetw7w+mGA@mail.gmail.com>
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
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 11, 2023 at 8:10=E2=80=AFAM Thomas Zimmermann <tzimmermann@suse=
.de> wrote:
>
> I'd like to take the patchset into drm-misc. It's part of a larger
> cleanup of the fbdev modules and its interfaces.

Sounds good, thanks!

Cheers,
Miguel
