Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0487624B93
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 21:18:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbiKJUSH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 15:18:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231869AbiKJURx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 15:17:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04F374E41E
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 12:16:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668111411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xNZnBBwxqdz55xyBEv8EplCF9EAqS9cAxN7EJmgLjio=;
        b=JTnfwhVWxCErHTcu8qg3rPZN34xwr7US2sws3X9Wmy4qYJXbagUR3c23xBW4AbX8ie8wpe
        rrTCspzoSZZtfntboWBNmvgPbH4vVVQpBIv1gm0RDPOYOcLIpcfxOVqDPsz/CnCzfjFPZF
        PDc7QVvg1s9WVuY9Ll2ilxHSxx4SmQ0=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-480-f4WgTMzEN_SsQ3815cwt8Q-1; Thu, 10 Nov 2022 15:16:47 -0500
X-MC-Unique: f4WgTMzEN_SsQ3815cwt8Q-1
Received: by mail-il1-f200.google.com with SMTP id s4-20020a056e02216400b003021b648144so2371633ilv.19
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 12:16:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xNZnBBwxqdz55xyBEv8EplCF9EAqS9cAxN7EJmgLjio=;
        b=6TPUFwdWVzrCWGzi+yRT8wXODhbTrhnxCFAhLJjTHm84sYc7/IrkUZswrlg+p90Hfn
         jefQgGwtUBFalnQm0wMzLLm84vOsApCjKM1GMOJbs31brSZrMIyvrefQsoZO5p/8pXH/
         NDPdamxc2cJgsmXWZxduakscWPvXO+eywT0bC+TYxrqjOJhHSryISl8HcCRMAPBfGOrx
         Hk0CktXtLwZLGuJIq9hpOcqV+wYcmfe27eholh6YQFBbXkDUReXo2pB8eydkjgcpgHqt
         GeaKq2HN7FN1rwXaKU1BgfrMJ9a2jdi6WuQj0yAly9vyAW8UUMKj8GejfdL9n1H/xbFd
         4Qzw==
X-Gm-Message-State: ACrzQf3J+WrEaVWnXD/ZumP78G1mpZCLVEfOnZNVNVjvYMS3EvpcUCqH
        dtT+R+/MXAGTgHuU245iHgBepgJOCIXMgdB8jTtm4MhC8Qdphj+1WTy0ZB8/ZFsdYqPbKZbTjwM
        bbmVDBDjo/UHp
X-Received: by 2002:a02:9107:0:b0:363:b95b:78eb with SMTP id a7-20020a029107000000b00363b95b78ebmr3411535jag.61.1668111406710;
        Thu, 10 Nov 2022 12:16:46 -0800 (PST)
X-Google-Smtp-Source: AMsMyM46QISdBm8HoAfl0XrYqD15zWrKQL8y0/oWFYAOUECDGBAOUcW0Q3OMtaqrd2AkP2pYXiqs+A==
X-Received: by 2002:a02:9107:0:b0:363:b95b:78eb with SMTP id a7-20020a029107000000b00363b95b78ebmr3411525jag.61.1668111406517;
        Thu, 10 Nov 2022 12:16:46 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id i7-20020a0566022c8700b006bbea9f45cesm25981iow.38.2022.11.10.12.16.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 12:16:45 -0800 (PST)
Date:   Thu, 10 Nov 2022 13:16:33 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Avihai Horon <avihaih@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH v1 0/2] vfio/iova_bitmap: bug fixes
Message-ID: <20221110131633.535bbe42.alex.williamson@redhat.com>
In-Reply-To: <20221025193114.58695-1-joao.m.martins@oracle.com>
References: <20221025193114.58695-1-joao.m.martins@oracle.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 25 Oct 2022 20:31:12 +0100
Joao Martins <joao.m.martins@oracle.com> wrote:

> Hey,
> 
> This small series addresses one small improvement and one bug fix:
> 
> 1) Avoid obscurity into how I use slab helpers yet I was
> never include it directly. And it wasn't detected thanks to a unrelated
> commit in v5.18 that lead linux/mm.h to indirectly include slab.h.
> 
> 2) A bug reported by Avihai reported during migration testing where
> we weren't handling correctly PAGE_SIZE unaligned bitmaps, which lead
> to miss dirty marked correctly on some IOVAs.
> 
> Comments appreciated
> 
> Thanks,
> 	Joao
> 
> Joao Martins (2):
>   vfio/iova_bitmap: Explicitly include linux/slab.h
>   vfio/iova_bitmap: Fix PAGE_SIZE unaligned bitmaps
> 
>  drivers/vfio/iova_bitmap.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 

Applied to vfio next branch for v6.2.  Thanks,

Alex

