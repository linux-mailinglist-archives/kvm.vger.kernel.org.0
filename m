Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1153208AB
	for <lists+kvm@lfdr.de>; Thu, 16 May 2019 15:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727642AbfEPNyy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 May 2019 09:54:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36442 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726769AbfEPNyy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 May 2019 09:54:54 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E8F4C882FB;
        Thu, 16 May 2019 13:54:53 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6CADA60BE5;
        Thu, 16 May 2019 13:54:46 +0000 (UTC)
Date:   Thu, 16 May 2019 15:54:44 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     "Jason J. Herne" <jjherne@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sebastian Ott <sebott@linux.ibm.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>
Subject: Re: [PATCH 06/10] s390/cio: add basic protected virtualization
 support
Message-ID: <20190516155444.158867ac.cohuck@redhat.com>
In-Reply-To: <20190516154245.4a0a84f7.pasic@linux.ibm.com>
References: <20190426183245.37939-1-pasic@linux.ibm.com>
        <20190426183245.37939-7-pasic@linux.ibm.com>
        <20190513114136.783c851c.cohuck@redhat.com>
        <d0ffefec-a14e-ee83-0aae-df288c3ffda4@linux.ibm.com>
        <20190515230817.2f8a8a5d.pasic@linux.ibm.com>
        <20190516083228.0cc5b489.cohuck@redhat.com>
        <20190516154245.4a0a84f7.pasic@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Thu, 16 May 2019 13:54:54 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 16 May 2019 15:42:45 +0200
Halil Pasic <pasic@linux.ibm.com> wrote:

> On Thu, 16 May 2019 08:32:28 +0200
> Cornelia Huck <cohuck@redhat.com> wrote:
> 
> > On Wed, 15 May 2019 23:08:17 +0200
> > Halil Pasic <pasic@linux.ibm.com> wrote:
> >   
> > > On Tue, 14 May 2019 10:47:34 -0400
> > > "Jason J. Herne" <jjherne@linux.ibm.com> wrote:  
> >   
> > > > Are we 
> > > > worried that virtio data structures are going to be a burden on the 31-bit address space?
> > > > 
> > > >     
> > > 
> > > That is a good question I can not answer. Since it is currently at least
> > > a page per queue (because we use dma direct, right Mimu?), I am concerned
> > > about this.
> > > 
> > > Connie, what is your opinion?  
> > 
> > Yes, running into problems there was one of my motivations for my
> > question. I guess it depends on the number of devices and how many
> > queues they use. The problem is that it affects not only protected virt
> > guests, but all guests.
> >   
> 
> Unless things are about to change only devices that have
> VIRTIO_F_IOMMU_PLATFORM are affected. So it does not necessarily affect
> not protected virt guests. (With prot virt we have to use
> VIRTIO_F_IOMMU_PLATFORM.)
> 
> If it were not like this, I would be much more worried.

If we go forward with this approach, documenting this side effect of
VIRTIO_F_IOMMU_PLATFORM is something that needs to happen.

> 
> @Mimu: Could you please discuss this problem with the team? It might be
> worth considering to go back to the design of the RFC (i.e. cio/ccw stuff
> allocated from a common cio dma pool which gives you 31 bit addressable
> memory, and 64 bit dma mask for a ccw device of a virtio device).
> 
> Regards,
> Halil
> 

