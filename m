Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8CC11344C
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 22:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbfECUEw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 16:04:52 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:34046 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfECUEw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 16:04:52 -0400
Received: by mail-qt1-f196.google.com with SMTP id j6so8194591qtq.1
        for <kvm@vger.kernel.org>; Fri, 03 May 2019 13:04:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9X9Yn//uNc4nUt79TMtyqufL6vACayUvlMnGmpMumpM=;
        b=iYgvLJCLnIyus9QcDMtTDlBSDJoxbnpim8Wf2g/OGn4tsLrhLDs9ekztIyZVX5kdQN
         RTg6S2ru6qDgUwhnh5uDtHI2AxxhjO2SVU3tC+isILa9ssSYR8wxp5sFvamitvOvZ4dy
         WwsNyW2lCi6SVYG0Q7UmM8tbfPjKKdNJSGLkJDFF4pSGTlfsNrkYQZ+riFShoxlG8bRu
         DsXtZsvh+mRO1VtBAdzNrfEvvSkA+qWBBSkUoIg3NEV/AAFVhV2TkJzzP/5V8eedp1yW
         XkwPG0GPulEbpF4Uou07xafMR76VNURP1Gm1flHytEw2Cwz92+g1jssZSTQ0btyJNeZN
         /HIw==
X-Gm-Message-State: APjAAAUMmLM3FaLzzeBZUOEKnLVQ2qoCRnOzQMJf6Bz2Qy16zL6rNmjE
        VGJR+Th+dEzKDwzpkPtXVHKHTg==
X-Google-Smtp-Source: APXvYqxJqgC9JI6r+i5mLL7IPh0JnKywe0jyA2dWegR16gGx/T8GcVix3ycZOigW7QFKPasTYegZZA==
X-Received: by 2002:a0c:d928:: with SMTP id p37mr9920668qvj.45.1556913891689;
        Fri, 03 May 2019 13:04:51 -0700 (PDT)
Received: from redhat.com (pool-173-76-105-71.bstnma.fios.verizon.net. [173.76.105.71])
        by smtp.gmail.com with ESMTPSA id e131sm1882716qkb.80.2019.05.03.13.04.50
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 03 May 2019 13:04:50 -0700 (PDT)
Date:   Fri, 3 May 2019 16:04:48 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sebastian Ott <sebott@linux.ibm.com>,
        virtualization@lists.linux-foundation.org,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>
Subject: Re: [PATCH 01/10] virtio/s390: use vring_create_virtqueue
Message-ID: <20190503160421-mutt-send-email-mst@kernel.org>
References: <20190426183245.37939-1-pasic@linux.ibm.com>
 <20190426183245.37939-2-pasic@linux.ibm.com>
 <20190503111724.70c6ec37.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190503111724.70c6ec37.cohuck@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 03, 2019 at 11:17:24AM +0200, Cornelia Huck wrote:
> On Fri, 26 Apr 2019 20:32:36 +0200
> Halil Pasic <pasic@linux.ibm.com> wrote:
> 
> > The commit 2a2d1382fe9d ("virtio: Add improved queue allocation API")
> > establishes a new way of allocating virtqueues (as a part of the effort
> > that taught DMA to virtio rings).
> > 
> > In the future we will want virtio-ccw to use the DMA API as well.
> > 
> > Let us switch from the legacy method of allocating virtqueues to
> > vring_create_virtqueue() as the first step into that direction.
> > 
> > Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> > ---
> >  drivers/s390/virtio/virtio_ccw.c | 30 +++++++++++-------------------
> >  1 file changed, 11 insertions(+), 19 deletions(-)
> 
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> 
> I'd vote for merging this patch right away for 5.2.

So which tree is this going through? mine?

-- 
MST
