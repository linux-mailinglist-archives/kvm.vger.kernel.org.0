Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF26260DA8
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 10:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730123AbgIHIfk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 04:35:40 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:29830 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729799AbgIHIfh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Sep 2020 04:35:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599554136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+MY+j0iaLoq2hQdX3yS+SdSeiGMuMtARblbd8qJTfIk=;
        b=KYobp+izMjIsLYbetyGO8qyRENFEdEg4kk9uSq/1MtELgCj+boPgqz/TgJzDv51kOTqt/X
        6p20QeGLhZrKJ2AN8czM8Cprxm3dVsdpvU6aEdR4FgOT4yDCqNd0SpC4xFCcNMk8E32a0p
        UKqGxhlU3dFs60xRABAVMb80lChMzv8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-419-4ymbWIa0NPyEbS2dBDAVog-1; Tue, 08 Sep 2020 04:35:35 -0400
X-MC-Unique: 4ymbWIa0NPyEbS2dBDAVog-1
Received: by mail-wr1-f72.google.com with SMTP id g6so6722010wrv.3
        for <kvm@vger.kernel.org>; Tue, 08 Sep 2020 01:35:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+MY+j0iaLoq2hQdX3yS+SdSeiGMuMtARblbd8qJTfIk=;
        b=abkdeB4BXaVWgQ/w+gYiN1gyDdv+1tWPlweQv/wCpOWazLzVdHWQ7jNCKLdLVRkvqx
         HqePpKHKsPmWDNftrK2hq6AIE+jU93A51GiW28WyQVYSsVUERBawuTj57earH8cP0/z0
         xNKP9WS4Sa7G3e6z/QFhFn6nd6dKYvTLSV/pB+yKgG/eAqXMNi0Urbpy+iX/X71VidcA
         hDiiK1JEk9qgvIPYIinN5xLPlHGJAFWcy1iUi/oorNOL7aIWvpVM1/xhWv/521rmno2w
         zRD3cb3EmR+vFdmt/YoBMp18uc4693kHxdpfOZ/IVo2gM+jWTFa/INLz3mDyKfH40Tsm
         2PfA==
X-Gm-Message-State: AOAM530+KsjU8x+drx1osSXyev0j/jfg0UHbog7DsC379Ehr4uVrwkvr
        +POnfKuJ/0tlRBr2a3BYe9jmZ5vAyO/BH9+c+7u3SOKGkvzD55uN5wveeCKd/JAzKUrD883kuNq
        UkU5GYeBDpw5N
X-Received: by 2002:a7b:c059:: with SMTP id u25mr3173544wmc.103.1599554133720;
        Tue, 08 Sep 2020 01:35:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxI7qjqWRvqDDMKuSEyexs2ZtKt48S7kwb/PYSoSmDiwm5Mm57vBJ7GtHojpCcdWEA5RCWEdA==
X-Received: by 2002:a7b:c059:: with SMTP id u25mr3173527wmc.103.1599554133531;
        Tue, 08 Sep 2020 01:35:33 -0700 (PDT)
Received: from redhat.com ([147.161.15.98])
        by smtp.gmail.com with ESMTPSA id z203sm34774917wmc.31.2020.09.08.01.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 01:35:32 -0700 (PDT)
Date:   Tue, 8 Sep 2020 04:35:25 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, jasowang@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, thomas.lendacky@amd.com,
        david@gibson.dropbear.id.au, linuxram@us.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v11 0/2] s390: virtio: let arch validate VIRTIO features
Message-ID: <20200908043503-mutt-send-email-mst@kernel.org>
References: <1599471547-28631-1-git-send-email-pmorel@linux.ibm.com>
 <20200908003951.233e47f3.pasic@linux.ibm.com>
 <20200908085521.4db22680.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200908085521.4db22680.cohuck@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 08, 2020 at 08:55:21AM +0200, Cornelia Huck wrote:
> On Tue, 8 Sep 2020 00:39:51 +0200
> Halil Pasic <pasic@linux.ibm.com> wrote:
> 
> > On Mon,  7 Sep 2020 11:39:05 +0200
> > Pierre Morel <pmorel@linux.ibm.com> wrote:
> > 
> > > Hi all,
> > > 
> > > The goal of the series is to give a chance to the architecture
> > > to validate VIRTIO device features.  
> > 
> > Michael, is this going in via your tree?
> > 
> 
> I believe Michael's tree is the right place for this, but I can also
> queue it if I get an ack on patch 1.

I think Halil pointed out some minor issues, so a new version is in
order.

-- 
MST

