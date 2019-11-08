Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEE2DF4E57
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 15:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbfKHOk6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 09:40:58 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:36366 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727291AbfKHOk5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 09:40:57 -0500
Received: by mail-qv1-f65.google.com with SMTP id f12so2283593qvu.3
        for <kvm@vger.kernel.org>; Fri, 08 Nov 2019 06:40:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4/BNGnBIaNhJmNyZQR6lxLMXT6d3Dv82/rwkvFOhWJk=;
        b=LxJbfBJhzJb4PqhllBvulv53F4EICAgMcbzWpDIfksRtWVI4Y2E4qbpeSL/gTbisGO
         L+FVEBYxOD96nMGB5KMQrC5m+nXmnd2tcl04bonNbj2MWEkExlFWQW4KK4g2auQyEgAx
         B+/KgCv+X0YeSONidnkazLrQECQR/Mr2hfhrn3hDzvrfipatOCyUJPypdN3mtiOIQbyQ
         bLEfHSJnFysyL2oLpmZA7lmTVEULmNvPwA2tDh9qSSekvYWa7GVVfvfl2a+P6VEcfR43
         Br7rI0WXOWYyHKLgNaHKK5pX8FvG9u0limoDeNL54dXTcggVRgnxZXSam+oRD4axZSOz
         255w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4/BNGnBIaNhJmNyZQR6lxLMXT6d3Dv82/rwkvFOhWJk=;
        b=lIbcyYuzVhKfu/csM8VuppXp5KT2WetyGvNbrk+nmcbVoHRi41HukZdIddNNpLY/qn
         UJJdrdd0bizeUEOxRY34AZ92H4593t9a6CgUWzYfGKgJ6BiH44kNgR+o1idNr+2sU34f
         I0jUO9OcayI5IGC8UnB62XJ7lePnspvrMBS0+B1abADFpISO1wTc7IGdpwgnjxBlDPDU
         ri61Ux4cJjic2NkX+p+me4dpzt4vklbxi9fT4H2ZpAVBUeRB8BGxJJD8BFwcYXLi+EO1
         ygppVP9jlSqOxp821hV6ygjdljUVheEnR+sMl58ESFcJ72W/YCgtOI1sf/eMloqOs+Rc
         eKwQ==
X-Gm-Message-State: APjAAAUgZDc2ZiBfcEJMzRQ2f5hxXwTjuz5zrFpVF8Jx3vwzJSN/0ymg
        oq/vHecbe/tGa3MnA8gcRRzrpw==
X-Google-Smtp-Source: APXvYqxu+Afc8RjTvb+fcKWQOy/aDi00JiHafoqZhTYMDVQXqcKgFn8Fxyj8hLqhWxhNal3o9uMgcQ==
X-Received: by 2002:a05:6214:170c:: with SMTP id db12mr9593409qvb.202.1573224055219;
        Fri, 08 Nov 2019 06:40:55 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id l14sm2995037qkj.61.2019.11.08.06.40.54
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Nov 2019 06:40:54 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iT5RW-0003PI-Ar; Fri, 08 Nov 2019 10:40:54 -0400
Date:   Fri, 8 Nov 2019 10:40:54 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jiri Pirko <jiri@resnulli.us>, Ertman@ziepe.ca,
        David M <david.m.ertman@intel.com>, gregkh@linuxfoundation.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Parav Pandit <parav@mellanox.com>, alex.williamson@redhat.com,
        davem@davemloft.net, kvm@vger.kernel.org, netdev@vger.kernel.org,
        saeedm@mellanox.com, kwankhede@nvidia.com, leon@kernel.org,
        cohuck@redhat.com, jiri@mellanox.com, linux-rdma@vger.kernel.org,
        Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Message-ID: <20191108144054.GC10956@ziepe.ca>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107153234.0d735c1f@cakuba.netronome.com>
 <20191108121233.GJ6990@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108121233.GJ6990@nanopsycho>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 08, 2019 at 01:12:33PM +0100, Jiri Pirko wrote:
> Thu, Nov 07, 2019 at 09:32:34PM CET, jakub.kicinski@netronome.com wrote:
> >On Thu,  7 Nov 2019 10:04:48 -0600, Parav Pandit wrote:
> >> Mellanox sub function capability allows users to create several hundreds
> >> of networking and/or rdma devices without depending on PCI SR-IOV support.
> >
> >You call the new port type "sub function" but the devlink port flavour
> >is mdev.
> >
> >As I'm sure you remember you nacked my patches exposing NFP's PCI 
> >sub functions which are just regions of the BAR without any mdev
> >capability. Am I in the clear to repost those now? Jiri?
> 
> Well question is, if it makes sense to have SFs without having them as
> mdev? I mean, we discussed the modelling thoroughtly and eventually we
> realized that in order to model this correctly, we need SFs on "a bus".
> Originally we were thinking about custom bus, but mdev is already there
> to handle this.

Did anyone consult Greg on this? 

The new intel driver has been having a very similar discussion about
how to model their 'multi function device' ie to bind RDMA and other
drivers to a shared PCI function, and I think that discussion settled
on adding a new bus?

Really these things are all very similar, it would be nice to have a
clear methodology on how to use the device core if a single PCI device
is split by software into multiple different functional units and
attached to different driver instances.

Currently there is alot of hacking in this area.. And a consistent
scheme might resolve the ugliness with the dma_ops wrappers.

We already have the 'mfd' stuff to support splitting platform devices,
maybe we need to create a 'pci-mfd' to support splitting PCI devices? 

I'm not really clear how mfd and mdev relate, I always thought mdev
was strongly linked to vfio.

At the very least if it is agreed mdev should be the vehicle here,
then it should also be able to solve the netdev/rdma hookup problem
too.

Jason
