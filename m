Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC2481AD17
	for <lists+kvm@lfdr.de>; Sun, 12 May 2019 18:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbfELQro (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 May 2019 12:47:44 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:32964 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726478AbfELQro (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 May 2019 12:47:44 -0400
Received: by mail-qt1-f195.google.com with SMTP id m32so9142897qtf.0
        for <kvm@vger.kernel.org>; Sun, 12 May 2019 09:47:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7o3LEQCQPDtmFSsmSC3vipKIcty8VWe+hgkqS93xaSo=;
        b=CLZZFl2NOUZ9xM/ISCCCU7d5Gg15w2qohlXpRmz7s+GbvRftf1koRZqzGlMKX8/g2k
         +EtdGH7EUS/+ijcnqOTvqHlroHDQrk9OWky1pCEDYW++OMfXoAoAwd9y+c47a5Kgz+32
         IDxJweplIsy8q0T7oAeyImdIr9b/vQl2dT3vB28vNAlZVVQhogrNQhTIOjNRCw+vDK6A
         8nOcmzqIwOlqyy9z62dRLKTd6+NYKIakibQOktoFur/PqxqZA6BxN9yfIchPvLEVGMvd
         zwLyLif3P0UQ5Jcri3Qr29eYKKSA/oCy1MiesJa6dDtRREcb9nSL8iTvejUUrFxE4kq8
         HNSA==
X-Gm-Message-State: APjAAAW3O7/SaC6XOfuaJ9QXhG837hTfCWHdV/EyGA+znJ8mbLeKbW7C
        4OQ7mZ+zI3XnYP1oyjXb2R1qvw==
X-Google-Smtp-Source: APXvYqyv5kOot3ZFPGxLHODMB/9bBhskS0nJjpF7PYJWBTsondGf/CRT2l9A/oiQkR/k1B/FZNlcsg==
X-Received: by 2002:aed:3aaa:: with SMTP id o39mr19851952qte.100.1557679663489;
        Sun, 12 May 2019 09:47:43 -0700 (PDT)
Received: from redhat.com (pool-173-76-105-71.bstnma.fios.verizon.net. [173.76.105.71])
        by smtp.gmail.com with ESMTPSA id e3sm6940655qkn.93.2019.05.12.09.47.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 12 May 2019 09:47:42 -0700 (PDT)
Date:   Sun, 12 May 2019 12:47:39 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sebastian Ott <sebott@linux.ibm.com>,
        virtualization@lists.linux-foundation.org,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Huth <thuth@redhat.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>
Subject: Re: [PATCH 01/10] virtio/s390: use vring_create_virtqueue
Message-ID: <20190512124730-mutt-send-email-mst@kernel.org>
References: <20190426183245.37939-1-pasic@linux.ibm.com>
 <20190426183245.37939-2-pasic@linux.ibm.com>
 <20190503111724.70c6ec37.cohuck@redhat.com>
 <20190503160421-mutt-send-email-mst@kernel.org>
 <20190504160340.29f17b98.pasic@linux.ibm.com>
 <20190505131523.159bec7c.cohuck@redhat.com>
 <ed6cbf63-f2ff-f259-ccb0-3b9ba60f2b35@de.ibm.com>
 <20190510160744.00285367.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190510160744.00285367.cohuck@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 10, 2019 at 04:07:44PM +0200, Cornelia Huck wrote:
> On Tue, 7 May 2019 15:58:12 +0200
> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> 
> > On 05.05.19 13:15, Cornelia Huck wrote:
> > > On Sat, 4 May 2019 16:03:40 +0200
> > > Halil Pasic <pasic@linux.ibm.com> wrote:
> > >   
> > >> On Fri, 3 May 2019 16:04:48 -0400
> > >> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > >>  
> > >>> On Fri, May 03, 2019 at 11:17:24AM +0200, Cornelia Huck wrote:    
> > >>>> On Fri, 26 Apr 2019 20:32:36 +0200
> > >>>> Halil Pasic <pasic@linux.ibm.com> wrote:
> > >>>>     
> > >>>>> The commit 2a2d1382fe9d ("virtio: Add improved queue allocation API")
> > >>>>> establishes a new way of allocating virtqueues (as a part of the effort
> > >>>>> that taught DMA to virtio rings).
> > >>>>>
> > >>>>> In the future we will want virtio-ccw to use the DMA API as well.
> > >>>>>
> > >>>>> Let us switch from the legacy method of allocating virtqueues to
> > >>>>> vring_create_virtqueue() as the first step into that direction.
> > >>>>>
> > >>>>> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> > >>>>> ---
> > >>>>>  drivers/s390/virtio/virtio_ccw.c | 30 +++++++++++-------------------
> > >>>>>  1 file changed, 11 insertions(+), 19 deletions(-)    
> > >>>>
> > >>>> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> > >>>>
> > >>>> I'd vote for merging this patch right away for 5.2.    
> > >>>
> > >>> So which tree is this going through? mine?
> > >>>     
> > >>
> > >> Christian, what do you think? If the whole series is supposed to go in
> > >> in one go (which I hope it is), via Martin's tree could be the simplest
> > >> route IMHO.  
> > > 
> > > 
> > > The first three patches are virtio(-ccw) only and the those are the ones
> > > that I think are ready to go.
> > > 
> > > I'm not feeling comfortable going forward with the remainder as it
> > > stands now; waiting for some other folks to give feedback. (They are
> > > touching/interacting with code parts I'm not so familiar with, and lack
> > > of documentation, while not the developers' fault, does not make it
> > > easier.)
> > > 
> > > Michael, would you like to pick up 1-3 for your tree directly? That
> > > looks like the easiest way.  
> > 
> > Agreed. Michael please pick 1-3.
> > We will continue to review 4- first and then see which tree is best.
> 
> Michael, please let me know if you'll pick directly or whether I should
> post a series.
> 
> [Given that the patches are from one virtio-ccw maintainer and reviewed
> by the other, picking directly would eliminate an unnecessary
> indirection :)]

picked them
