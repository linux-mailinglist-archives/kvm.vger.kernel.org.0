Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBF35E8071
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 19:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbiIWRKw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Sep 2022 13:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232239AbiIWRKt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Sep 2022 13:10:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E12C127C95
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 10:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663953046;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gpVlJhDRpZFuHYz2lX9398HPhHAv7CsLmej6MEUwRz0=;
        b=Uon8AbufnoBdXR7PCMdLr/dLl4Lqfmwem99WkTyc1H5UmwN3JNjbSPpcsfYmiVLyipdw/e
        u8wKoxtrHBX7YCK4imkNZ938KrAc9qipjGNswzi16yyho5vj7zKcLJWdYdepYKaYC6Y7FP
        m3Jl0cM307aZY9upDWlMfNiCAj+Ou58=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-322-ufUBc2HKPQiEKFsfqpKTdw-1; Fri, 23 Sep 2022 13:10:45 -0400
X-MC-Unique: ufUBc2HKPQiEKFsfqpKTdw-1
Received: by mail-io1-f72.google.com with SMTP id e14-20020a6b500e000000b006a13488a320so298428iob.12
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 10:10:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=gpVlJhDRpZFuHYz2lX9398HPhHAv7CsLmej6MEUwRz0=;
        b=aLzuF62bFSI0pOcseTRB/gNHmRuQ9gn9jWxO68EomRGHK9P04IY4J5Skc8+OcuLXLZ
         t/ZHX0nhwWk/T6wwDCPeTkB8uwa8MI8NhAqUON80k93UaJEPoUM3nlYRVWNUFqZl98M7
         j036T0Uj/xtKppK0xt+ohK+05GqREWNQMYhqdbIt2fKqL7Q5u57qD/F7WFCHradFSQ7N
         dQNM/v+9v/9wp7xYph9nwWvC5PON7MZlyELehnqwDtzZ1t7p8ZSgoFKb9xl6JgvMcjQ0
         aqe/5Wx27jopxaJlFgVqW7C35oW9gg2pbaZU8PuB3hsep7CUDzXEOfMZOqVMf/47uXcK
         XW+g==
X-Gm-Message-State: ACrzQf3vVUwnxqjfi/OUdt0ZywwVyzJvYc0C8X49uJ87H1ZOnJOkkhDf
        lVR7PwqDKYydmZnurGr2odoqwJSWr19GiFVRCeh+PbFYZHSbA3A5R0rRO6fp+0SFqqpzVAJdYUd
        e1w6bdTFkqIKS
X-Received: by 2002:a05:6e02:1bc9:b0:2f1:9ee8:246d with SMTP id x9-20020a056e021bc900b002f19ee8246dmr4549870ilv.246.1663953043509;
        Fri, 23 Sep 2022 10:10:43 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6Z6PSUFs3jJ7OpdxBuW1He2A86Ksrbau+TlvkmyKJTR1wlmsmvPQ69NNP1iyuynZ7fDyE+vg==
X-Received: by 2002:a05:6e02:1bc9:b0:2f1:9ee8:246d with SMTP id x9-20020a056e021bc900b002f19ee8246dmr4549858ilv.246.1663953043320;
        Fri, 23 Sep 2022 10:10:43 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id w28-20020a02cf9c000000b0035a648fd47csm3646532jar.61.2022.09.23.10.10.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 10:10:43 -0700 (PDT)
Date:   Fri, 23 Sep 2022 11:10:41 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH v3 0/8] vfio: Split the container code into a clean
 layer and dedicated file
Message-ID: <20220923111041.72b12833.alex.williamson@redhat.com>
In-Reply-To: <0-v3-297af71838d2+b9-vfio_container_split_jgg@nvidia.com>
References: <0-v3-297af71838d2+b9-vfio_container_split_jgg@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 22 Sep 2022 16:20:18 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> This creates an isolated layer around the container FD code and everything
> under it, including the VFIO iommu drivers. All this code is placed into
> container.c, along with the "struct vfio_container" to compartmentalize
> it.
> 
> Future patches will provide an iommufd based layer that gives the same API
> as the container layer and choose which layer to go to based on how
> userspace operates.
> 
> The patches continue to split up existing functions and finally the last
> patch just moves every function that is a "container" function to the new
> file and creates the global symbols to link them together.
> 
> Cross-file container functions are prefixed with vfio_container_* for
> clarity.
> 
> The last patch can be defered and queued during the merge window to manage
> conflicts. The earlier patches should be fine immediately conflicts wise.
> 
> This is the last big series I have to enable basic iommufd functionality.
> As part of the iommufd series the entire container.c becomes conditionally
> compiled:
> 
> https://github.com/jgunthorpe/linux/commits/vfio_iommufd
> 
> v3:
>  - Rebase over the vfio struct device series

Applied to vfio next branch for v6.1.  Thanks,

Alex

