Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA216C9F01
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 11:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbjC0JJV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 05:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232847AbjC0JI6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 05:08:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D9840F6
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 02:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679908087;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q/jHqPQ9labkDpwONGksLRLwMhvFcLpODPDEk10PFbM=;
        b=egFnyBmLWK7vSZ5qOEFIQ+fb/ZaTblvB1ETaEGP46U4Q36p6YUdXZ40cW6DlBTweriIRxu
        3XDbYUWMO0fcOuwSx8mh8JofiMzkQ2m+OgChgFglmhB/VfavL9kGCtABrr2togNz8826z3
        L+yOJtHdWr4EE/X0TK/5YhWfR+srPlI=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-658-xqI4_E83Mdqu52b51dFEfg-1; Mon, 27 Mar 2023 05:08:05 -0400
X-MC-Unique: xqI4_E83Mdqu52b51dFEfg-1
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-545d027103eso39337147b3.5
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 02:08:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679908084;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q/jHqPQ9labkDpwONGksLRLwMhvFcLpODPDEk10PFbM=;
        b=0ODXr22NC/wkLzFHKguYTityUDJYvamLXzadT0T0KKjuNkC57GHc50B8f2Jn6mjYD3
         7+rtxS08bGagokDPZZ5cZdbKlWGG9rC7AkVvJKk3vxOVtyQX7uoCO4irVUXI1MzXx9tb
         K6oGAtkPOWUvCP7VAKIeKpu2IaNkOpAcjJqSsl8lU+QYfC3D7+nWqEp31MGvIx8zrqMp
         AJ+f1BqROjq9Bfw7+fkrJHM6QsPYnboFhCeRiRXYQlQrCgVCnTqyMmD1iN/0AVvnpNlx
         8wceeOwJhJHkR2U4A/d4psMeCSXK6/5H25Ox7kAreirGvhyT5nZXbl0FXF2i2EspJ4YM
         C/NA==
X-Gm-Message-State: AAQBX9cCHPjTOq5C1weGjdG6ttY2ZzT56Wtlbw+Pdekvwui4VgBtBFhG
        GUOvSjckym6Nr4sRl+lEAB52eclDi+eK+b4UeuPecSSk1rfoN9AxzkYYRAbBGjQPMt+CNbJ3r3N
        YgmuLt1MwMAZotdHmhA2e6qboVUvH
X-Received: by 2002:a05:6902:168d:b0:b6d:1483:bc18 with SMTP id bx13-20020a056902168d00b00b6d1483bc18mr6595372ybb.7.1679908084553;
        Mon, 27 Mar 2023 02:08:04 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZK4A0vkFV+Fi54XXazb/aOmFl65dPrh+4dL2oYcZ2EWPZ/YWITfHG4vrrsNYo/PRnSdXQDyk1J9i2vTaifXNI=
X-Received: by 2002:a05:6902:168d:b0:b6d:1483:bc18 with SMTP id
 bx13-20020a056902168d00b00b6d1483bc18mr6595359ybb.7.1679908084346; Mon, 27
 Mar 2023 02:08:04 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000075bebb05f79acfde@google.com> <CAGxU2F4jxdzK8Y-jaoKRaX_bDhoMtomOT6TyMek+un-Bp8RX3g@mail.gmail.com>
 <ZBUGp5bvNuE3sK5g@bullseye>
In-Reply-To: <ZBUGp5bvNuE3sK5g@bullseye>
From:   Stefano Garzarella <sgarzare@redhat.com>
Date:   Mon, 27 Mar 2023 11:07:52 +0200
Message-ID: <CAGxU2F6StMA+Dp77thrC-Tdq+GMiA802yCgxpE5atDn3RiVA1w@mail.gmail.com>
Subject: Re: [syzbot] [net?] [virt?] [io-uring?] [kvm?] BUG: soft lockup in vsock_connect
To:     Bobby Eshleman <bobbyeshleman@gmail.com>
Cc:     Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Bobby Eshleman <bobby.eshleman@gmail.com>,
        syzbot <syzbot+0bc015ebddc291a97116@syzkaller.appspotmail.com>,
        axboe@kernel.dk, davem@davemloft.net, edumazet@google.com,
        io-uring@vger.kernel.org, kuba@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, stefanha@redhat.com,
        syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Krasnov Arseniy Vladimirovich <AVKrasnov@sberdevices.ru>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Mar 25, 2023 at 1:44=E2=80=AFAM Bobby Eshleman <bobbyeshleman@gmail=
.com> wrote:
>
> On Fri, Mar 24, 2023 at 09:38:38AM +0100, Stefano Garzarella wrote:
> > Hi Bobby,
> > FYI we have also this one, but it seems related to
> > syzbot+befff0a9536049e7902e@syzkaller.appspotmail.com
> >
> > Thanks,
> > Stefano
> >
>
> Got it, I'll look into it.

I think it is related to
syzbot+befff0a9536049e7902e@syzkaller.appspotmail.com, so I tested the
same patch and syzbot seems happy.
I marked this as duplicated, but feel free to undup if it is not the case.

Thanks,
Stefano

