Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E26A2EA148
	for <lists+kvm@lfdr.de>; Tue,  5 Jan 2021 01:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbhAEAH2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jan 2021 19:07:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726974AbhAEAH1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jan 2021 19:07:27 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC65C061793
        for <kvm@vger.kernel.org>; Mon,  4 Jan 2021 16:06:42 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id a12so68640656lfl.6
        for <kvm@vger.kernel.org>; Mon, 04 Jan 2021 16:06:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=dtfbCjxo+5cbIU7/zANgM3ErdTiEw3LvQQnQM2kgHrg=;
        b=pT8uS0riSGPOon/6wWIN+SoA6jkP1rhTpYbNvPF0EvnkP6yBfPi57mYut3LYCk80TE
         RO/wY5MxQep/ku+pVmcMGRmH/PQgSCLiZ/kITw5Bu1rbY2eoLlTJ103XF155k1swOm+N
         JdJ2D7peZR/HDwZKxWeZxMzShF92Tc0JQNisFtomf3CxA2P0paXapTC7MFNUJgOGMjbQ
         xA8SWFy+vyrsD5mdHtSjkgXUdaqDn7TTVW5X09x4xBG+d+MkO37InV4bGfVF6xqdF5zC
         VIImvszQhUyZgahncQxshNTpL2tUXQ7XigSlCA0PjUjqXO+2qMvwqTR3YP0GjcdhyfeU
         clXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=dtfbCjxo+5cbIU7/zANgM3ErdTiEw3LvQQnQM2kgHrg=;
        b=s/Bta+ShB2DktJRfvBA7v6fmUL8WR5L6rjko95Zqz8zbBqqLACGRC+XYIBDkrVzjBU
         m6ta9bgmYyNfp2PXsJFHXTY8zi/mQXrI3pqwWbShFxlMZLGQDie/4V0ZVioYuUdYvkbZ
         3KeL2Qbq/E/hlxN/nhHV01mjWyxeWUIvrOjXcwYSajc8VP7zc4WGWvG8bmToaGiXwGvu
         blyVUkDmGUc1OSjU3rMQjZo4Dr7HxxAx+0hV3cwNBwA8WhjH2CkH12JS+HMt4FLj4Hq2
         2upPnSCcmh9W4nWrdczNguTRBSbeku4u5wjECu0ox4laaDcFL6GAy8/YjzFnD/5tz8H6
         JUFQ==
X-Gm-Message-State: AOAM533Yy07FZtz/tl7mC/XxOEnNLtuFG+yHTl/gAvJd8Td4Cvayndtp
        TRm82z42wzx5zuyDuX04SH4=
X-Google-Smtp-Source: ABdhPJz7lDQQWpD7e8Odp9HveWUxzF8GwcXeD2V9HifekwUdYVAluqxHawF6yjMvbdjeeW58Z7iQRg==
X-Received: by 2002:a05:651c:3db:: with SMTP id f27mr38722962ljp.494.1609805198370;
        Mon, 04 Jan 2021 16:06:38 -0800 (PST)
Received: from [192.168.167.128] (37-145-186-126.broadband.corbina.ru. [37.145.186.126])
        by smtp.gmail.com with ESMTPSA id n8sm7476534lfi.48.2021.01.04.16.06.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 16:06:37 -0800 (PST)
Message-ID: <18093b808face7696a07a66ac55bafbaa6a98424.camel@gmail.com>
Subject: Re: [RFC 2/2] KVM: add initial support for ioregionfd blocking
 read/write operations
From:   Elena Afanasova <eafanasova@gmail.com>
To:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org
Cc:     stefanha@redhat.com, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com
Date:   Mon, 04 Jan 2021 16:06:23 -0800
In-Reply-To: <9c1a10a5-2863-02af-bd9f-8a7b77f7e382@redhat.com>
References: <cover.1609231373.git.eafanasova@gmail.com>
         <a13b23ca540a8846891895462d2fb139ec597237.1609231374.git.eafanasova@gmail.com>
         <72556405-8501-26bc-4939-69e312857e91@redhat.com>
         <90e04958a3f57bbc1b0fcee4810942f031640a05.camel@gmail.com>
         <9c1a10a5-2863-02af-bd9f-8a7b77f7e382@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-01-04 at 13:37 +0800, Jason Wang wrote:
> On 2021/1/4 上午4:37, Elena Afanasova wrote:
> > On Thu, 2020-12-31 at 11:46 +0800, Jason Wang wrote:
> > > On 2020/12/29 下午6:02, Elena Afanasova wrote:
> > > > Signed-off-by: Elena Afanasova<eafanasova@gmail.com>
> > > > ---
> > > >    virt/kvm/ioregion.c | 157
> > > > ++++++++++++++++++++++++++++++++++++++++++++
> > > >    1 file changed, 157 insertions(+)
> > > > 
> > > > diff --git a/virt/kvm/ioregion.c b/virt/kvm/ioregion.c
> > > > index a200c3761343..8523f4126337 100644
> > > > --- a/virt/kvm/ioregion.c
> > > > +++ b/virt/kvm/ioregion.c
> > > > @@ -4,6 +4,33 @@
> > > >    #include <kvm/iodev.h>
> > > >    #include "eventfd.h"
> > > >    
> > > > +/* Wire protocol */
> > > > +struct ioregionfd_cmd {
> > > > +	__u32 info;
> > > > +	__u32 padding;
> > > > +	__u64 user_data;
> > > > +	__u64 offset;
> > > > +	__u64 data;
> > > > +};
> > > > +
> > > I wonder do we need a seq in the protocol. It might be useful if
> > > we
> > > allow a pair of file descriptors to be used for multiple
> > > different
> > > ranges.
> > > 
> > I think it might be helpful in the case of out-of-order requests.
> > In the case of in order requests seq field seems not to be
> > necessary
> > since there will be cmds/replies serialization. I’ll include the
> > synchronization code in a RFC v2 series.
> 
> See my reply to V1. It might be helpful for the case of using single 
> ioregionfd for multiple ranges.
> 
Ok, thank you!

> Thanks
> 
> 
> > > Thanks
> > > 
> > > 
> > > > +struct ioregionfd_resp {
> > > > +	__u64 data;
> > > > +	__u8 pad[24];
> > > > +};

