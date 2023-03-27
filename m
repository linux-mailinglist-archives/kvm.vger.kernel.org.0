Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC9666CA5F6
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 15:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbjC0Nbm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 09:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbjC0Nbl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 09:31:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D2CD59C4
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 06:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679923816;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rnHz54xfyL+gglmIyJKJy5abDhVgwniJPLQmnnklQbc=;
        b=M/HTGz5NHKZSbeJ5b8tW+y33uqKEugCkdDBLfY3b04x/lR1IUtCLPWtmRMAGKW62wa4s4m
        qaAmGyz2wZsTD2SK8EsWqIhMvPKn7I3zbUIGJhpTzUUDL2sHXsuGdvLOCpW6//8FuAM2jr
        SFHAvzSHxJve1lD+Jr98dY5rkupNCcY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-295-MvRGAINQPcitUXXUjwN9xA-1; Mon, 27 Mar 2023 09:30:14 -0400
X-MC-Unique: MvRGAINQPcitUXXUjwN9xA-1
Received: by mail-wm1-f72.google.com with SMTP id bi7-20020a05600c3d8700b003edecc610abso5732866wmb.7
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 06:30:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679923813;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rnHz54xfyL+gglmIyJKJy5abDhVgwniJPLQmnnklQbc=;
        b=x/6LeQntewTFPbTr8iM9PFzC6MVHjvsJJ7a6c08K+yUo4KQJKT/eAhTydrgpuw25Wp
         ixEEXBR1cyaj+Ydi8TvzPjJpaMb00nkOvlUlV2ml3p+oQ7Mm8sv8WPUr+pL4+nn5hc/H
         MT8kjB4TXbE6/4nMyx06z1MZgUXZmuk9z6Kht64z/BVydBQnu88UkOvCaNX93K969Q1V
         uk/nRzMJ+JHZPswyMFX3pqZmEGiqPwy0dxmpwA/cuLLPsCoQtV/YomwEpkZlEA+zYqBK
         Ljw44E7yZxeWwlZkPxZYDyfjdk+JBVPigHqG48fLRpWyRMKmRG8x6a0ruD183uYiOOBo
         Vt7w==
X-Gm-Message-State: AO0yUKVMdwrbhPocPuLl3Ep8k5qjJ9GvN31khYK84l1xysXhJ39tNBv4
        enaPfSXyZybBWHiIQMO/HL2jd2BdRIUN0Y3nLK1tjePE4Zkhu+jM+PCmE3wUfTiGTAwocleQZYK
        NZIsUXQXKCA2R
X-Received: by 2002:a05:600c:2114:b0:3ed:492f:7f37 with SMTP id u20-20020a05600c211400b003ed492f7f37mr8747291wml.10.1679923813048;
        Mon, 27 Mar 2023 06:30:13 -0700 (PDT)
X-Google-Smtp-Source: AK7set9UiwP8XvEO+pMF2nbKcdfIrVKf+Fs5lq6Q+1t1gZjOUKhdS1XmGs2yy9FXpB/ck95uX2096g==
X-Received: by 2002:a05:600c:2114:b0:3ed:492f:7f37 with SMTP id u20-20020a05600c211400b003ed492f7f37mr8747274wml.10.1679923812717;
        Mon, 27 Mar 2023 06:30:12 -0700 (PDT)
Received: from redhat.com ([2.52.153.142])
        by smtp.gmail.com with ESMTPSA id g8-20020a05600c310800b003ee610d1ce9sm8981395wmo.34.2023.03.27.06.30.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 06:30:12 -0700 (PDT)
Date:   Mon, 27 Mar 2023 09:30:09 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        elic@nvidia.com
Subject: Re: [GIT PULL] vdpa: bugfix
Message-ID: <20230327092909-mutt-send-email-mst@kernel.org>
References: <20230327091947-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327091947-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Looks like a sent a bad pull request. Sorry!
Please disregard.

On Mon, Mar 27, 2023 at 09:19:50AM -0400, Michael S. Tsirkin wrote:
> The following changes since commit e8d018dd0257f744ca50a729e3d042cf2ec9da65:
> 
>   Linux 6.3-rc3 (2023-03-19 13:27:55 -0700)
> 
> are available in the Git repository at:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
> 
> for you to fetch changes up to 8fc9ce051f22581f60325fd87a0fd0f37a7b70c3:
> 
>   vdpa/mlx5: Remove debugfs file after device unregister (2023-03-21 16:39:02 -0400)
> 
> ----------------------------------------------------------------
> vdpa: bugfix
> 
> An error handling fix in mlx5.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>




> ----------------------------------------------------------------
> Eli Cohen (1):
>       vdpa/mlx5: Remove debugfs file after device unregister
> 
>  drivers/vdpa/mlx5/net/mlx5_vnet.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

