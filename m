Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA92E6C579A
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 21:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232271AbjCVUan (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 16:30:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbjCVUa3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 16:30:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFAE89AFCF;
        Wed, 22 Mar 2023 13:21:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97B7A622B1;
        Wed, 22 Mar 2023 20:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D548C4339C;
        Wed, 22 Mar 2023 20:20:09 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="PIpcYJJX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1679516405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z5+SwuPswYL3502uLq6hayJyZoDC1sf3E/Ormc16ROU=;
        b=PIpcYJJX9hptjh826y5Zn1hijTEsvDVh/1kxhA5t7yY8jKbnkGW/3rbZoRKDCRTbCTys4P
        3QZp7sJr5kpsH2zTiTTlMjtJqloSLUXN+PQif21I15YKfofGKoVtnBSR+AkwAO7vyKxz9L
        MfjhDwRthXZ3JvuQdpcHb0/LNa2VkB8=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 0ebc3581 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 22 Mar 2023 20:20:05 +0000 (UTC)
Received: by mail-yb1-f176.google.com with SMTP id x198so12782054ybe.9;
        Wed, 22 Mar 2023 13:20:04 -0700 (PDT)
X-Gm-Message-State: AAQBX9djBjCx14eZKEtWsV3hhRjPdd0gj18vCqaem6DxT20O9wZ7LhB9
        4RxkkLy2BwwoWnhuzMNf1/S0bd57viisYcINlbI=
X-Google-Smtp-Source: AKy350bWxTp/xybNZinLNHP3Psjfx3ze++rR/f/Zifi7U6qVfp5MpEnhwyDwi6qNcOLgfT72uieS4Q5S4dRvTCc87PU=
X-Received: by 2002:a05:6902:1081:b0:b21:a3b8:45cd with SMTP id
 v1-20020a056902108100b00b21a3b845cdmr765321ybu.0.1679516401893; Wed, 22 Mar
 2023 13:20:01 -0700 (PDT)
MIME-Version: 1.0
References: <ZBruFRwt3rUVngPu@zx2c4.com> <20230322120907.2968494-1-Jason@zx2c4.com>
 <20230322124631.7p67thzeblrawsqj@orel> <1884bd96-2783-4556-bc57-8b733758baff@spud>
 <20230322192610.sad42xau33ye5ayn@orel> <2a3b08ce-5ab1-41b6-ad58-edbeff7b1acb@spud>
 <ad445951-3d13-4644-94d9-e0989cda39c3@spud>
In-Reply-To: <ad445951-3d13-4644-94d9-e0989cda39c3@spud>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 22 Mar 2023 21:19:50 +0100
X-Gmail-Original-Message-ID: <CAHmME9qEbUP7cq-iofN=ruSWhsHUva+qqavfEpNzDK_BjQVqxw@mail.gmail.com>
Message-ID: <CAHmME9qEbUP7cq-iofN=ruSWhsHUva+qqavfEpNzDK_BjQVqxw@mail.gmail.com>
Subject: Re: [PATCH] riscv: require alternatives framework when selecting FPU support
To:     Conor Dooley <conor@kernel.org>
Cc:     Andrew Jones <ajones@ventanamicro.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Conor Dooley <conor.dooley@microchip.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        regressions@leemhuis.info, regressions@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 22, 2023 at 9:05=E2=80=AFPM Conor Dooley <conor@kernel.org> wro=
te:
>
> On Wed, Mar 22, 2023 at 07:44:13PM +0000, Conor Dooley wrote:
> > On Wed, Mar 22, 2023 at 08:26:10PM +0100, Andrew Jones wrote:
> > > On Wed, Mar 22, 2023 at 03:17:13PM +0000, Conor Dooley wrote:
> > > > On Wed, Mar 22, 2023 at 01:46:31PM +0100, Andrew Jones wrote:
> >
> > > > > (It's tempting to just select RISCV_ALTERNATIVE from RISCV, but m=
aybe we
> > > > >  can defer that wedding a bit longer.)
> > > >
> > > > At that point, the config option should just go away entirely, no?
> > >
> > > Ah, yes, and that makes the idea even more attractive, as we could re=
move
> > > several ifdefs.
> >
> > I went and did the cursory check, it's not compatible with XIP_KERNEL s=
o
> > dropping the option entirely probably isn't a possibility :/
>
> What I said is only now sinking in. We're now going to be disabling FPU
> support on XIP kernels with this patch.
> Well, technically not this patch since it wouldn't have built without
> Jason's changes, but that doesn't seem like the right thing to do...

I suppose you could have riscv_has_extension_*() fall back to
something that doesn't use alternatives on XIP kernels.
