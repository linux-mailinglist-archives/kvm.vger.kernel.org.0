Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C655F3F0EA4
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 01:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234921AbhHRXdV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 19:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234860AbhHRXdV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 19:33:21 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4DD4C061764
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 16:32:45 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id az7so5117477qkb.5
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 16:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nE9cjjSEoRnF8T/+9HRtcKKOXVF1NLbesNH2RyQsbEg=;
        b=Z/Ryl++24tF1bgq599HlMwhTQYMa1XEFPHrcQ8M8uXBMJLMFt9chAA2FK7DkMacwcq
         w642vcAFgEWzzX2XR0krbw7xVLeglryj+1NTX4XN4f88s5S+UApZEdPn9nqyehMYEJQ7
         /uSJy8z1MZLrPsvDHubNN+gQ4GQn2ZFBQr0L0YlAruJtGe04b6ZnGbXc6hcFBrB+MiK0
         q+6OtWzyNRbTjdb4KryB3tnIlil+xp8gw4RIW2oX0AZaNFko7hymLJkI/5NLqtmv/x8r
         7UBosnD84UGfJ1uuRow5HWDWTtVXJakJhqcCZ6wI1xkQe6qH5oeKLwU9rEB+YfqMrk5o
         2v+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nE9cjjSEoRnF8T/+9HRtcKKOXVF1NLbesNH2RyQsbEg=;
        b=cylcBwxkKDzHMyIQMM+zxABEGujP9Dz6Dmk2M7YWKXRV0E6Nqv+PRvElXUE/AbH0uy
         AtKl4fgpi2WLjB4KTByi1WII2RxtNNX9Nmy5Ja1rUdFEJpR7YyPBshyiibBaSuSxeJ82
         uiUo8gzItRccDLi5fOkmAOg8/hdE8ZxtoNbMYBAr7HgQyi2erOqxF5S6AfLOqi9tXlPC
         iuj8+w+dxmjG2V1uJcJzfuWQ77F8onAkKmUpH8z0S6Ny422Bfd5NqPS6nbiMRalWpLU7
         r5cR90XUIJdJnB/Jucro3d32sUugKdJG74ordxOn5ln9YCcEwEzWBDFr0CKh7YJ4hV2D
         2yXA==
X-Gm-Message-State: AOAM531a8xoj1ojNzoKT6L36yQ/b+zgrpmLvNZzJvQ8mLzV0Ag27obYm
        WExb5dfg5grPd+Flz1kc498pew==
X-Google-Smtp-Source: ABdhPJyJBPQrkwDK9NQMUi3Ny8blaKsWFA7oVNhCDzATFnlLlvTyrhRX0GBW4X7GHtUujFBkm2ZdVg==
X-Received: by 2002:a05:620a:4151:: with SMTP id k17mr833143qko.51.1629329565086;
        Wed, 18 Aug 2021 16:32:45 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id q7sm713551qkm.68.2021.08.18.16.32.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 16:32:44 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1mGV35-000jme-7l; Wed, 18 Aug 2021 20:32:43 -0300
Date:   Wed, 18 Aug 2021 20:32:43 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 05/14] vfio: refactor noiommu group creation
Message-ID: <20210818233243.GO543798@ziepe.ca>
References: <20210811151500.2744-1-hch@lst.de>
 <20210811151500.2744-6-hch@lst.de>
 <20210811160341.573a5b82.alex.williamson@redhat.com>
 <20210812072617.GA28507@lst.de>
 <20210812095614.3299d7ab.alex.williamson@redhat.com>
 <20210815154834.GA325@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210815154834.GA325@lst.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Aug 15, 2021 at 05:48:34PM +0200, Christoph Hellwig wrote:
> Here is a version with the tain only on successful groip allocation:
> 
> http://git.infradead.org/users/hch/misc.git/commit/bdb5d2401ebd43ae6c069aeaa8a64e0c774dd104
> 
> I'm not going to spam the list with the whole series until a few more
> reviews are in.

I hope to look at it next week after I unbury my mailboxes..

Thanks,
Jason
