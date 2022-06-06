Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8E3353F2A2
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 01:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbiFFXiN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 19:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbiFFXiM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 19:38:12 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2596AF310
        for <kvm@vger.kernel.org>; Mon,  6 Jun 2022 16:38:10 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id az35so4880049qkb.3
        for <kvm@vger.kernel.org>; Mon, 06 Jun 2022 16:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ewFcKPOa+2x6RXhVIR+v/VURcDtYVPRav4oUF2Rq3Fg=;
        b=hI01O5N11a+OWG1HisFkBQQWBXV1w6StkkZG9lXxvx7pzAsflSoBkrnnIt8qVcLeZX
         QpKb+uW+AUIFqqFs5Jzomqg/B47cQ2LYJKT5bdMgCXEwoaqctUc4IqQnw3yh6zgZ7X28
         lo23+1PCLig/vrVM3kbEbK48GIF2JeDaLiu6FPpw95BYJw9qp8jpZB8Gy0kRx0dYfNib
         2ML1mQIuoBQnZ1b45+il30LtIeeOScKxr8Kri0+EXFkLswIqeAjulzgb21a0KaJMtIdn
         7gLl7d9IzgsEjbMk3wgL151ZaHyv57BO9K1jI6BZLt8PBeVkRuh/iIsIzmWNTqq/7E6W
         hRPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ewFcKPOa+2x6RXhVIR+v/VURcDtYVPRav4oUF2Rq3Fg=;
        b=XtagV1TNdbWtfXmHa6kEYn3dHY62VkBRAQO9/2BHpi9LXqY+FsHgktBF5TfYSaZeJy
         Pl1BV0NCw+Cl53QPrwc6zXEx3v2kep0AEe4TLuFPtFdctTnv7B/WfE+lW8nRm/xO0kZc
         QDrdlLqu06h/HBY3ki7xlmrIRLETnt8bGYYYZ16mfGvze0CPbt2gT4xvnaOFtxw/JE5G
         Xnxcr+l+3V2pafIbxaPIuJKRQ3/wE+dyP6iPHegQN8vgZkIIV+w6gPmBxnE0Y5KjbOqa
         5NF5mRdFlhIUin7A+ympSWiH3U2t8kTuwFeTBs2mjcjxP3rmMeEFFta8Rru9qAXto9CE
         /eLg==
X-Gm-Message-State: AOAM5313DPHoH4oood93NnCgWa9NQMj5vVTUufdkSl17htm5fPgGJnJu
        ChsRrA5VOOwE/LsaS9Fai10knvSqwRnwOw==
X-Google-Smtp-Source: ABdhPJzf37dz4Rqa77kSjV+oZpBSb6XWF30qEzih0C5uqAelmaT+JRLEKFfxjiPEZKYVgGEeLV8wig==
X-Received: by 2002:a05:620a:370f:b0:6a6:d7c3:a7f2 with SMTP id de15-20020a05620a370f00b006a6d7c3a7f2mr178760qkb.644.1654558689919;
        Mon, 06 Jun 2022 16:38:09 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id a25-20020ac87219000000b00304eaca5e5csm3784236qtp.73.2022.06.06.16.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 16:38:09 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1nyMIS-002prR-Pq; Mon, 06 Jun 2022 20:38:08 -0300
Date:   Mon, 6 Jun 2022 20:38:08 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org
Subject: Re: [PATCH 3/8] vfio/mdev: simplify mdev_type handling
Message-ID: <20220606233808.GD3932382@ziepe.ca>
References: <20220603063328.3715-1-hch@lst.de>
 <20220603063328.3715-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220603063328.3715-4-hch@lst.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 03, 2022 at 08:33:23AM +0200, Christoph Hellwig wrote:

> @@ -112,9 +88,10 @@ int mdev_register_parent(struct mdev_parent *parent, struct device *dev,
>  			return -ENOMEM;
>  	}
>  
> -	ret = parent_create_sysfs_files(parent);
> -	if (ret)
> -		return ret;
> +	parent->mdev_types_kset = kset_create_and_add("mdev_supported_types",
> +					       NULL, &parent->dev->kobj);
> +	if (!parent->mdev_types_kset)
> +		return -ENOMEM;
>  
>  	ret = class_compat_create_link(mdev_bus_compat_class, dev, NULL);
>  	if (ret)
[..]
	kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);

This changes the ordering with respect to this udev event, now the
mdev_supported_types directory is created but the directory is empty,
then the driver fills it after the KOBJ_CHANGE event is triggered.

Granted this whole abusing some other struct device's sysfs thing is
inherently wrong - I'm not really sure what impact this has. Though at
least someone seemed to care since their is this uevent here...

Maybe we need a 'finish register' call to trigger the uevent? Or
perhaps trigger the uevent when each add_type is done?

Everything else looks fine though, I looked at this for a while a long
time ago and didn't see this nice final arrangement :\

Jason
