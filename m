Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEB5D5B2405
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 18:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231685AbiIHQ4C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 12:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbiIHQze (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 12:55:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B65FEEA612
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 09:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662656029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jM/4652ZU+ilVOa2VHytxd0Y/6mr00fBnuvbs8bYj04=;
        b=N0aOXGfqg3S0hTNZAmU/RDZ08+tSlbFs8zkGWndRcaJ126Dg756kLwS4sNvo0EZMPd3paf
        7aCH0P7neweC8YU/vPL1RlI5ZbzuyWVlV5z96tRTYC6msoX9ohWSOJZmjqQSJ1Z/IfRGN2
        UwHjI1lqlsXPszvhKNheqlNcFbg/eSA=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-437-9M-Lj376OQW-Rg4qXbaPwg-1; Thu, 08 Sep 2022 12:53:48 -0400
X-MC-Unique: 9M-Lj376OQW-Rg4qXbaPwg-1
Received: by mail-io1-f71.google.com with SMTP id y10-20020a5d914a000000b00688fa7b2252so11734334ioq.0
        for <kvm@vger.kernel.org>; Thu, 08 Sep 2022 09:53:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=jM/4652ZU+ilVOa2VHytxd0Y/6mr00fBnuvbs8bYj04=;
        b=57ghbo8EyiV9jJGHR1wtTW1RdzkZYMMiB0T9PEXdOmvq/YQV4LafGAzTy5XER5egVO
         +NH8f87U/iWRPTf36AIVklqpMLTJGaQ7+QN+mQA88o19N7um9iMbvAuJuLu4tnakZURE
         0nN/69fvwPdRakU9jyVF21s+/wk/W0mPDzWTL8MCawxTgB6mCWo4shYuFu8pTlydOzfz
         Cai5gimJFURIzQx/pS6bxgt572mw0HMliR4w5Ei8r7AJPMmwJ6epoXkIQHuvYJJNQ5nH
         yBk13QORsdLhkqgddsu9eE9XF4R5dWBNaoiM8uo0g3Hx/uXYJD+JI2XhTI04QGDSJkOP
         6kvA==
X-Gm-Message-State: ACgBeo19k8/SicAWaN3DlFmLx0FbnOK5Ic4xTc8CVs8B6Ihr7dAU+3nh
        VAu3Bn0CCo6ewwAATeIKQJk+lTPttL7uhxf7lRKKaue7wJygr7ZXpy3GknZncGIp4n+jZCnwLym
        Ia93VVxow19IV
X-Received: by 2002:a05:6602:2c95:b0:689:e4e2:2c02 with SMTP id i21-20020a0566022c9500b00689e4e22c02mr4502054iow.94.1662656027339;
        Thu, 08 Sep 2022 09:53:47 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4C0Z1a3e1j36Z0x3OLIC8ipRTXLsZlmpzmGPoLTlCAR7z8o7PJmPC/zPVvPBR23LI13B82fg==
X-Received: by 2002:a05:6602:2c95:b0:689:e4e2:2c02 with SMTP id i21-20020a0566022c9500b00689e4e22c02mr4502042iow.94.1662656027114;
        Thu, 08 Sep 2022 09:53:47 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id g8-20020a92d7c8000000b002e67267b4bfsm1025299ilq.70.2022.09.08.09.53.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 09:53:46 -0700 (PDT)
Date:   Thu, 8 Sep 2022 10:53:45 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     saeedm@nvidia.com, kvm@vger.kernel.org, netdev@vger.kernel.org,
        kuba@kernel.org, kevin.tian@intel.com, joao.m.martins@oracle.com,
        yishaih@nvidia.com, maorg@nvidia.com, cohuck@redhat.com
Subject: Re: [GIT PULL] Please pull mlx5 vfio changes
Message-ID: <20220908105345.28da7c98.alex.williamson@redhat.com>
In-Reply-To: <YxmMMR3u1VRedWdK@unreal>
References: <20220907094344.381661-1-leon@kernel.org>
        <20220907132119.447b9219.alex.williamson@redhat.com>
        <YxmMMR3u1VRedWdK@unreal>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 8 Sep 2022 09:31:13 +0300
Leon Romanovsky <leon@kernel.org> wrote:

> On Wed, Sep 07, 2022 at 01:21:19PM -0600, Alex Williamson wrote:
> > On Wed,  7 Sep 2022 12:43:44 +0300
> > Leon Romanovsky <leon@kernel.org> wrote:
> >   
> > > Hi Alex,
> > > 
> > > This series is based on clean 6.0-rc4 as such it causes to two small merge
> > > conficts whis vfio-next. One is in thrird patch where you should take whole
> > > chunk for include/uapi/linux/vfio.h as is. Another is in vfio_main.c around
> > > header includes, which you should take too.  
> > 
> > Is there any reason you can't provide a topic branch for the two
> > net/mlx5 patches and the remainder are rebased and committed through
> > the vfio tree?    
> 
> You added your Acked-by to vfio/mlx5 patches and for me it is a sign to
> prepare clean PR with whole series.
> 
> I reset mlx5-vfio topic to have only two net/mlx5 commits without
> special tag.
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git topic/mlx5-vfio
> Everything else can go directly to your tree without my intervention.

Sorry, I knew the intention initially was to send a PR and I didn't
think about the conflicts we'd have versus the base you'd use.  Thanks
for splitting this out, I think it'll make for a cleaner upstream path
given the clear code split.

Yishai, can you post a v7 rebased on the vfio next branch?  The comment
I requested is now ephemeral since it only existed in the commits Leon
dropped.  Also feel free to drop my Acks since I'll add new Sign-offs.
Thanks,

Alex

