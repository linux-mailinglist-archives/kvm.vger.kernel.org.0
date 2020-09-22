Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6435F27438A
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 15:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgIVNwW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 09:52:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49739 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726593AbgIVNwW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 09:52:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600782740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UfJX+wYYmH/wK4kLLTxGKgaWCNaGjgdbMHRevMH7+TA=;
        b=E0lN7WbJfWER8Ts2/AiHVK37G8fx8HJSXZ49leCuEpw/zeI/wM25cQiqJlRoKGAnTmf6C2
        nmvHK9MZVHSbZ+cTcpCb9FnM/sLCH0UL37koxns7sr5zbz3dz/s2KVgLvOp6ZOA8zdf2Mk
        SuScuRNMiP4/pIPELZkYsat+UcBEWFI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-H3nD2MN6NjyofoI5V7ocbg-1; Tue, 22 Sep 2020 09:52:19 -0400
X-MC-Unique: H3nD2MN6NjyofoI5V7ocbg-1
Received: by mail-wr1-f71.google.com with SMTP id a10so7382962wrw.22
        for <kvm@vger.kernel.org>; Tue, 22 Sep 2020 06:52:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UfJX+wYYmH/wK4kLLTxGKgaWCNaGjgdbMHRevMH7+TA=;
        b=ck3t7tBNq0WGh3+k34WDBjfrQQfdJEkVIGPWW212DuTmaXQL3dkfiH/7R7teoQtob/
         ryetNN5hwUCxQ5quf1dvpkzPDQV04w8wdF3P+VjwXeJG26btGOscwTNqIYj0U3u1iQhg
         LiNCPYTDMhpb0sQpp8gLxH7hTYFMlcJIV/+ye/d/VusKp1uIzlubv1d2MN8a/cc2Nqcu
         IDuVTBqS/ocfHOcUeaf9kdcTNp7AEf7PQpNC7dGLlsgF2GzFeNsMpSfm693Z+1X5LkO5
         Gz9IBLB+HX1WL33FgtsRMTs7G88GjW7yXsjBkWNUSStptlCUai4yK4Tj2/pO6uvQsKio
         EbaA==
X-Gm-Message-State: AOAM530DEh/uaw4gPPuxGoDM7OMWH0Z0jrnivvWpSIaSObBUdGW7+QzS
        Db/g/VPVSIHSQYewKgNQ1cbVj/n8MhUOlO0hOTsNjbilLsXld+cwinR/ngVQ6li8+SnCaDQWsjR
        naZa8yZnXyRm6
X-Received: by 2002:a1c:9cd3:: with SMTP id f202mr1187573wme.148.1600782737964;
        Tue, 22 Sep 2020 06:52:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwA4/2LFfWxU8NUoke6X3tzAXQxbMT++c6m4LRcHMg/WZ6CRi0/J2NuZBapW4USmj+BNJiNDQ==
X-Received: by 2002:a1c:9cd3:: with SMTP id f202mr1187547wme.148.1600782737763;
        Tue, 22 Sep 2020 06:52:17 -0700 (PDT)
Received: from redhat.com (bzq-109-65-116-225.red.bezeqint.net. [109.65.116.225])
        by smtp.gmail.com with ESMTPSA id y1sm4650054wmi.36.2020.09.22.06.52.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 06:52:16 -0700 (PDT)
Date:   Tue, 22 Sep 2020 09:52:12 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Pierre Morel <pmorel@linux.ibm.com>, linux-kernel@vger.kernel.org,
        pasic@linux.ibm.com, frankja@linux.ibm.com, jasowang@redhat.com,
        cohuck@redhat.com, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, thomas.lendacky@amd.com,
        david@gibson.dropbear.id.au, linuxram@us.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v12 0/2] s390: virtio: let arch validate VIRTIO features
Message-ID: <20200922095158-mutt-send-email-mst@kernel.org>
References: <1599728030-17085-1-git-send-email-pmorel@linux.ibm.com>
 <de191c4d-cfe3-1414-53b8-e7a09cc15e32@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de191c4d-cfe3-1414-53b8-e7a09cc15e32@de.ibm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Will do for the next Linux.

On Tue, Sep 22, 2020 at 02:15:17PM +0200, Christian Borntraeger wrote:
> Michael,
> 
> are you going to pick this series?
> 
> 
> On 10.09.20 10:53, Pierre Morel wrote:
> > Hi all,
> > 
> > The goal of the series is to give a chance to the architecture
> > to validate VIRTIO device features.
> > 
> > I changed VIRTIO_F_IOMMU_PLATFORM to VIRTIO_F_ACCESS_PLATFORM
> > I forgot in drivers/virtio/Kconfig, and put back the inclusion
> > of virtio_config.h for the definition of the callback in
> > arch/s390/mm/init.c I wrongly removed in the last series.
> > 
> > Regards,
> > Pierre
> > 
> > 
> > Pierre Morel (2):
> >   virtio: let arch advertise guest's memory access restrictions
> >   s390: virtio: PV needs VIRTIO I/O device protection
> > 
> >  arch/s390/Kconfig             |  1 +
> >  arch/s390/mm/init.c           | 11 +++++++++++
> >  drivers/virtio/Kconfig        |  6 ++++++
> >  drivers/virtio/virtio.c       | 15 +++++++++++++++
> >  include/linux/virtio_config.h | 10 ++++++++++
> >  5 files changed, 43 insertions(+)
> > 

