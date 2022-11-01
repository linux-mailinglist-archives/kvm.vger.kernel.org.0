Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA0756149B3
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 12:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbiKALqk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 07:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231179AbiKALqY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 07:46:24 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83BBA248F0
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 04:38:24 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id n191so12011358iod.13
        for <kvm@vger.kernel.org>; Tue, 01 Nov 2022 04:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ky/gWvtBYvPIpbOlcN4uK3Zomv/BHXfuhu8FjvzMXKQ=;
        b=CCQ2rc2p16CHEZ+V92CJwAdUg8I/+7pcRVkfTlwPKexHwo14PXHy3Xm/aCQ1VhIzQT
         JjQaDRU18cD8j9bVl/AxPSoiB3daETOh6kudKM3RjCaMNWQfNxVjZRkpel2hhnYX2ujs
         Bh+0DjGzazBrTAOhpMiwQrbfFI18wwiLmXrZfJ84cQSuRS3wBsS9BAEIPwsumcMBLH31
         ts15KltSzeGqyBdStbQ9fpBbzCGNcrhIaOOvS/VUvjPJ+PitXseptYAoJPkGP7RyChaM
         I+WOyV/xfE7i7YWLc5ZJKJ3odtw/bYitSMAT3RaIejU/W03bD/jbbK4g1h1Y4D8tVsNh
         XWsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ky/gWvtBYvPIpbOlcN4uK3Zomv/BHXfuhu8FjvzMXKQ=;
        b=jWD/RsvqWK0KWOcX4fsZWfr9ue+3I7O+GWsxbspG9conb/WtikPIYeWzSAdM0SV7c5
         S0DJTqlIKv4V4I9HNfVvM4sIi1TlD3lkDTm/E/LSvZEZm4vwvrgXTTzcP5xbHa698JlN
         oRuQIoEWlJmr/4ghiL8hsIQfEosst2XSZRow3PP7ID82UlMYArJ+CEcFAPb8a4ZIEYON
         AaFB+XExAS/CYoHr1QrIr7DNmNc/A+kYnczcyA1Wr6JekaIkJnW6FkX5JBYPrgm3/ys+
         lNRAQZy6NkXRkQrpunt75spS9ETBM0knQpYvCpZ/En2OmUGU7w7GITmZcpfYXtoPTtsL
         k61g==
X-Gm-Message-State: ACrzQf1JsYxInbztWTuz5PygvC0Fh7RbhpddHAEPsBuFGfRUb6apqmc7
        dRiqabfTPP5oelu+F6RiObFp6w==
X-Google-Smtp-Source: AMsMyM4/EE1PgwK3gNjceM87zo5MbJfOkIoZuFV8T+BbTOpEXpureVjZXCEz/HvoV7BmJry4g4NWPA==
X-Received: by 2002:a05:6602:2b94:b0:6a4:7b57:ecfb with SMTP id r20-20020a0566022b9400b006a47b57ecfbmr11522617iov.8.1667302703947;
        Tue, 01 Nov 2022 04:38:23 -0700 (PDT)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id i4-20020a056e0212c400b00300bcda1de6sm959857ilm.35.2022.11.01.04.38.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 04:38:22 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1oppb3-003GxS-Bf;
        Tue, 01 Nov 2022 08:38:21 -0300
Date:   Tue, 1 Nov 2022 08:38:21 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Anthony DeRossi <ajderossi@gmail.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "abhsahu@nvidia.com" <abhsahu@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>
Subject: Re: [PATCH v2] vfio-pci: Accept a non-zero open_count on reset
Message-ID: <Y2EFLVYwWumB9JbL@ziepe.ca>
References: <20221026194245.1769-1-ajderossi@gmail.com>
 <BN9PR11MB52763B921748415B14FFB57D8C369@BN9PR11MB5276.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52763B921748415B14FFB57D8C369@BN9PR11MB5276.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 01, 2022 at 08:49:28AM +0000, Tian, Kevin wrote:
> > From: Anthony DeRossi <ajderossi@gmail.com>
> > Sent: Thursday, October 27, 2022 3:43 AM
> > 
> > -static bool vfio_pci_dev_set_needs_reset(struct vfio_device_set *dev_set)
> > +static bool vfio_pci_core_needs_reset(struct vfio_pci_core_device *vdev)
> >  {
> > +	struct vfio_device_set *dev_set = vdev->vdev.dev_set;
> >  	struct vfio_pci_core_device *cur;
> >  	bool needs_reset = false;
> > 
> > +	if (vdev->vdev.open_count > 1)
> > +		return false;
> 
> WARN_ON()
> 
> > +
> >  	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list) {
> > -		/* No VFIO device in the set can have an open device FD */
> > -		if (cur->vdev.open_count)
> > +		/* Only the VFIO device being reset can have an open FD */
> > +		if (cur != vdev && cur->vdev.open_count)
> >  			return false;
> 
> not caused by this patch but while at it...
> 
> open_count is defined not for driver use:
> 
> 	/* Members below here are private, not for driver use */
> 	unsigned int index;
> 	struct device device;   /* device.kref covers object life circle */
> 	refcount_t refcount;    /* user count on registered device*/
> 	unsigned int open_count;
> 	struct completion comp;
> 	struct list_head group_next;
> 	struct list_head iommu_entry;
> 
> prefer to a wrapper or move it to the public section of vfio_device.

I've been meaning to take a deeper look, but I'm thinking vfio_pci
doesn't need open_count at all any more.

open_count was from before we changed the core code to call
open_device only once. If we are only a call chain from
open_device/close_device then we know that the open_count must be 1.

Jason
