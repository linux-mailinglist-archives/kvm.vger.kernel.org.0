Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4946E49BE
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 15:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbjDQNTQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 09:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjDQNTP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 09:19:15 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A96EAF02
        for <kvm@vger.kernel.org>; Mon, 17 Apr 2023 06:18:46 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id v9so30881765pjk.0
        for <kvm@vger.kernel.org>; Mon, 17 Apr 2023 06:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1681737526; x=1684329526;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dVWUzJnRy08VVgMndpn0WdUv18W2Qb6Bz4zHOVYFwYs=;
        b=LjHiIXIoSC7KnPtzz18g3IvlyAxMo9XWmIpjRVqmn45bMUfDETMVByhWaXEMLdTTUM
         mwekRDx/bT4o0pAG3AuDLmUd7qUAlq9sXJ+IkPy+hrGdTjQPGoFX5eucRj9C/1bU/xnK
         25IWGiZyoPZptHZlBZy6impX2Pns0ufaBwMQEXAfVeUzY8XZFOHXxNhBPDYbUAWPzt6g
         Uscz998bMGfH/Mhud8KqytGqj92Lfi+1rvWIBFOuieFpodAoMQuPd1fpdxzhMllmz/Ii
         NWgPMTtFTU/DnT1bt+8vAEeEVYLwxutJGBg3LuXcdWPaDwu/Xf7p6y6HuTNNOvG8ZDX2
         7YUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681737526; x=1684329526;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dVWUzJnRy08VVgMndpn0WdUv18W2Qb6Bz4zHOVYFwYs=;
        b=lQKM6COyUOLQbBIdEaSNLXbCAJJkzYS08PFnQ9XWw9r1t4wZDHmeJSKAPfAObKBukq
         sybsgR5oaQB8CXd6KzrByp3CvyGZiMrW3n3BeDmWu06gvHj98Bec7FG1I1zPUcsTMUhu
         KaqFZJZuoHhrYG5n6if0BqN/xf+48FCtyTWLQtsa4M7ifPYpCwdEEofzkd7fDUIsIdPY
         YIWBSmJbeAdq9PqiQPuon7OLRIy8BmEnARO4fD4Qvqg3SngzJHsdmDJAc8D3EUmgnBuY
         pJeKfZhcmja/VJCaQMCUPOvCYpCYRdfSGmY106jEjby4iX/+pm1JexegSPEHd2x3bUZN
         g1EA==
X-Gm-Message-State: AAQBX9cPBu4h5rsF/QCx8HLEEzhfFoGAzVe6LiJuGWYljCqaZRCDG2hQ
        Zdi7TI20P/+UOtkWYhxKbpAb8g==
X-Google-Smtp-Source: AKy350YthD2proY9eoZOcxK2BGjfWERoUiti6sZaSv+Mm8UQqtYvMOoGyMZwiExJZo7f2GGSB2SY2Q==
X-Received: by 2002:a05:6a20:291e:b0:ec:7cc:2da3 with SMTP id t30-20020a056a20291e00b000ec07cc2da3mr13372596pzf.15.1681737525782;
        Mon, 17 Apr 2023 06:18:45 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-25-194.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.25.194])
        by smtp.gmail.com with ESMTPSA id d11-20020aa7868b000000b0063b7331a4easm4923224pfo.154.2023.04.17.06.18.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 06:18:43 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1poOkk-00BQEU-7J;
        Mon, 17 Apr 2023 10:18:42 -0300
Date:   Mon, 17 Apr 2023 10:18:42 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Nipun Gupta <nipun.gupta@amd.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, masahiroy@kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, nicolas@fjasle.eu, git@amd.com,
        harpreet.anand@amd.com, pieter.jansen-van-vuuren@amd.com,
        nikhil.agarwal@amd.com, michal.simek@amd.com
Subject: Re: [PATCH v2] vfio/cdx: add support for CDX bus
Message-ID: <ZD1HMkbdhQpAYs7P@ziepe.ca>
References: <20230414123414.21645-1-nipun.gupta@amd.com>
 <20230414153614.3b72e659.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230414153614.3b72e659.alex.williamson@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 14, 2023 at 03:36:14PM -0600, Alex Williamson wrote:

> > +static int vfio_cdx_init_device(struct vfio_device *core_vdev)
> > +{
> > +	struct vfio_cdx_device *vdev =
> > +		container_of(core_vdev, struct vfio_cdx_device, vdev);
> > +	struct cdx_device *cdx_dev = to_cdx_device(core_vdev->dev);
> > +
> > +	vdev->cdx_dev = cdx_dev;
> > +	vdev->dev = &cdx_dev->dev;
> 
> Both of these seem trivial to factor out of this patch, cdx_device is
> always available via to_cdx_device(core_vdev->dev) and the struct
> device is always available via core_vdev->dev.  vdev->dev isn't even
> used anywhere yet.  Both the init and release functions here could be
> dropped afaict.

Yes please, I have a series someplace that gets rid of all these
redundent ->devs we keep around everwhere.

to_cdx_device(core_vdev->dev) is a good solution, maybe with a static
inline.

Jason
