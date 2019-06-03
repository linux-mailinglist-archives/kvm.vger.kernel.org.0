Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7CB33143
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2019 15:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728870AbfFCNkR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jun 2019 09:40:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20341 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727506AbfFCNkQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jun 2019 09:40:16 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7438D308FBA9;
        Mon,  3 Jun 2019 13:40:16 +0000 (UTC)
Received: from gondolin (ovpn-204-96.brq.redhat.com [10.40.204.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9798C608A7;
        Mon,  3 Jun 2019 13:40:06 +0000 (UTC)
Date:   Mon, 3 Jun 2019 15:40:02 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Michael Mueller <mimu@linux.ibm.com>,
        KVM Mailing List <kvm@vger.kernel.org>,
        Linux-S390 Mailing List <linux-s390@vger.kernel.org>,
        Sebastian Ott <sebott@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>
Subject: Re: [PATCH v3 2/8] s390/cio: introduce DMA pools to cio
Message-ID: <20190603154002.6da0186f.cohuck@redhat.com>
In-Reply-To: <20190603144706.2d458ccc.pasic@linux.ibm.com>
References: <20190529122657.166148-1-mimu@linux.ibm.com>
        <20190529122657.166148-3-mimu@linux.ibm.com>
        <20190603133745.240c00a7.cohuck@redhat.com>
        <20190603144706.2d458ccc.pasic@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Mon, 03 Jun 2019 13:40:16 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 3 Jun 2019 14:47:06 +0200
Halil Pasic <pasic@linux.ibm.com> wrote:

> On Mon, 3 Jun 2019 13:37:45 +0200
> Cornelia Huck <cohuck@redhat.com> wrote:
> 
> > On Wed, 29 May 2019 14:26:51 +0200
> > Michael Mueller <mimu@linux.ibm.com> wrote:

> > > diff --git a/arch/s390/include/asm/cio.h b/arch/s390/include/asm/cio.h
> > > index 1727180e8ca1..43c007d2775a 100644
> > > --- a/arch/s390/include/asm/cio.h
> > > +++ b/arch/s390/include/asm/cio.h
> > > @@ -328,6 +328,17 @@ static inline u8 pathmask_to_pos(u8 mask)
> > >  void channel_subsystem_reinit(void);
> > >  extern void css_schedule_reprobe(void);
> > >  
> > > +extern void *cio_dma_zalloc(size_t size);
> > > +extern void cio_dma_free(void *cpu_addr, size_t size);
> > > +extern struct device *cio_get_dma_css_dev(void);
> > > +
> > > +struct gen_pool;  
> > 
> > That forward declaration is a bit ugly...   
> 
> Can you explain to me what is ugly about it so I can avoid similar
> mistakes in the future?
> 
> >I guess the alternative was
> > include hell?
> >   
> 
> What do you mean by include hell?
> 
> I decided to use a forward declaration because the guys that include
> "cio.h" are not expected to require the interfaces defined in
> linux/genalloc.h. My motivation to do it like this was the principle of
> encapsulation.

My personal rule-of-thumb is to include the header if it is
straightforward enough (e.g. if adding a basic header is enough). If
you need to include a header together with all of its friends and
family, a forward declaration is probably nicer. And of course,
sometimes it is simply needed.
