Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0B46CA5FC
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 15:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232532AbjC0NdI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 09:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232134AbjC0NdH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 09:33:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66FDC26A0
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 06:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679923942;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=45ANxRXv+CmKBORJQeZkZo556TyX4xY4z1xyvoQpf7s=;
        b=Trp5NM+np1pwYOEswT4IaywUulbTOIHN1zb8YCJfH0d1d5zfl9sU4lUTAx1P7nd90AQrCz
        D94dxVo5pWd9wM//VJENKYXR2ZQYrq5uRNLgvEZLM/bwOMfcMqEuzHJAoQCGyyzHLxz4UU
        sFDv1KQf4WQ95NSEBomexfVdgfsLaGE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-17-nzqvCAu7PaqjSP-wTB9XiA-1; Mon, 27 Mar 2023 09:32:21 -0400
X-MC-Unique: nzqvCAu7PaqjSP-wTB9XiA-1
Received: by mail-wr1-f71.google.com with SMTP id b9-20020a05600018a900b002cfe70737d2so758197wri.1
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 06:32:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679923940;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=45ANxRXv+CmKBORJQeZkZo556TyX4xY4z1xyvoQpf7s=;
        b=6ZUZVbG7+Rcz589/xwJAt017LylKadf8aIJRwEKruTS8G6Eil1mxkeaGIAos84w1KR
         v6QOxxi2hi0L9P3No6Lap7L3g8MCjFKITyg6JFOmmoQYpxfWlLOYcuyz8RNJdmRx43ip
         NeUXfbM3sxK3N0UQP68lsPkIvD0BqMthhZBDmADXEeW8Njo52BDTjyfs1izMDsSj0bYe
         2CGKOj0b7vzihkel+7L2Y7jks2QHktscLj7cU2m1JJsqJzNkH8c2sDokQGblCqzVJ70z
         9EVVuxt7rDavN/ea5bpZd8mgbeaY+RkwoYbkQjxeJp+cR4nGpElXy6MjTpCmn8R3Lr0P
         r74w==
X-Gm-Message-State: AO0yUKWcOn4hcoBSitHP+fa7qYVY70ySSUz2hKNt1xAZTQhjxidAyrPL
        uq+CSEkUlNRyAy5xsCxwJ1BIgRzRZZMeSoOSXjP+7xUc+WUFix0yhck58rjg5xdX0yFVuwCMlOI
        YASg+o630FD13
X-Received: by 2002:a7b:c7d6:0:b0:3e1:f8af:8772 with SMTP id z22-20020a7bc7d6000000b003e1f8af8772mr9393537wmk.9.1679923940255;
        Mon, 27 Mar 2023 06:32:20 -0700 (PDT)
X-Google-Smtp-Source: AK7set8gdRVPXdFw2VEM14Dq51u4OtBaddjJUio2jBLT7UtvdL6xG4rHCigflYhYz9nOXRbjvmAY9g==
X-Received: by 2002:a7b:c7d6:0:b0:3e1:f8af:8772 with SMTP id z22-20020a7bc7d6000000b003e1f8af8772mr9393524wmk.9.1679923940000;
        Mon, 27 Mar 2023 06:32:20 -0700 (PDT)
Received: from redhat.com ([2.52.153.142])
        by smtp.gmail.com with ESMTPSA id i6-20020a05600c354600b003ede6540190sm9086871wmq.0.2023.03.27.06.32.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 06:32:19 -0700 (PDT)
Date:   Mon, 27 Mar 2023 09:32:16 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        elic@nvidia.com
Subject: Re: [GIT PULL] vdpa: bugfix
Message-ID: <20230327093125-mutt-send-email-mst@kernel.org>
References: <20230327091947-mutt-send-email-mst@kernel.org>
 <20230327092909-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327092909-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

And the issue was that the author self-nacked the single fix here.
So we'll merge another fix, later.

On Mon, Mar 27, 2023 at 09:30:13AM -0400, Michael S. Tsirkin wrote:
> Looks like a sent a bad pull request. Sorry!
> Please disregard.
> 
> On Mon, Mar 27, 2023 at 09:19:50AM -0400, Michael S. Tsirkin wrote:
> > The following changes since commit e8d018dd0257f744ca50a729e3d042cf2ec9da65:
> > 
> >   Linux 6.3-rc3 (2023-03-19 13:27:55 -0700)
> > 
> > are available in the Git repository at:
> > 
> >   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
> > 
> > for you to fetch changes up to 8fc9ce051f22581f60325fd87a0fd0f37a7b70c3:
> > 
> >   vdpa/mlx5: Remove debugfs file after device unregister (2023-03-21 16:39:02 -0400)
> > 
> > ----------------------------------------------------------------
> > vdpa: bugfix
> > 
> > An error handling fix in mlx5.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> 
> 
> 
> > ----------------------------------------------------------------
> > Eli Cohen (1):
> >       vdpa/mlx5: Remove debugfs file after device unregister
> > 
> >  drivers/vdpa/mlx5/net/mlx5_vnet.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)

