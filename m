Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 726EB751F1
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2019 16:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388738AbfGYO5t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jul 2019 10:57:49 -0400
Received: from mga17.intel.com ([192.55.52.151]:22392 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387834AbfGYO5t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jul 2019 10:57:49 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Jul 2019 07:57:48 -0700
X-IronPort-AV: E=Sophos;i="5.64,307,1559545200"; 
   d="scan'208";a="164199993"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Jul 2019 07:57:48 -0700
Message-ID: <d9357c2b6ed9e1499703a562199cc28d1b57383e.camel@linux.intel.com>
Subject: Re: [PATCH v2 QEMU] virtio-balloon: Provide a interface for "bubble
 hinting"
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        david@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, yang.zhang.wz@gmail.com,
        pagupta@redhat.com, riel@surriel.com, konrad.wilk@oracle.com,
        lcapitulino@redhat.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com
Date:   Thu, 25 Jul 2019 07:57:47 -0700
In-Reply-To: <bbfe0fbb-dd23-ed5c-01b3-493ae804942f@redhat.com>
References: <20190724165158.6685.87228.stgit@localhost.localdomain>
         <20190724171050.7888.62199.stgit@localhost.localdomain>
         <20190724150224-mutt-send-email-mst@kernel.org>
         <6218af96d7d55935f2cf607d47680edc9b90816e.camel@linux.intel.com>
         <bbfe0fbb-dd23-ed5c-01b3-493ae804942f@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2019-07-25 at 07:57 -0400, Nitesh Narayan Lal wrote:
> On 7/24/19 4:18 PM, Alexander Duyck wrote:
> > On Wed, 2019-07-24 at 15:02 -0400, Michael S. Tsirkin wrote:
> > > On Wed, Jul 24, 2019 at 10:12:10AM -0700, Alexander Duyck wrote:
> > > > From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > > > 
> > > > Add support for what I am referring to as "bubble hinting". Basically the
> > > > idea is to function very similar to how the balloon works in that we
> > > > basically end up madvising the page as not being used. However we don't
> > > > really need to bother with any deflate type logic since the page will be
> > > > faulted back into the guest when it is read or written to.
> > > > 
> > > > This is meant to be a simplification of the existing balloon interface
> > > > to use for providing hints to what memory needs to be freed. I am assuming
> > > > this is safe to do as the deflate logic does not actually appear to do very
> > > > much other than tracking what subpages have been released and which ones
> > > > haven't.
> > > > 
> > > > Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > > > ---
> > > >  hw/virtio/virtio-balloon.c                      |   40 +++++++++++++++++++++++
> > > >  include/hw/virtio/virtio-balloon.h              |    2 +
> > > >  include/standard-headers/linux/virtio_balloon.h |    1 +
> > > >  3 files changed, 42 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/hw/virtio/virtio-balloon.c b/hw/virtio/virtio-balloon.c
> > > > index 2112874055fb..70c0004c0f88 100644
> > > > --- a/hw/virtio/virtio-balloon.c
> > > > +++ b/hw/virtio/virtio-balloon.c
> > > > @@ -328,6 +328,39 @@ static void balloon_stats_set_poll_interval(Object *obj, Visitor *v,
> > > >      balloon_stats_change_timer(s, 0);
> > > >  }
> > > >  
> > > > +static void virtio_bubble_handle_output(VirtIODevice *vdev, VirtQueue *vq)
> > > > +{
> > > > +    VirtQueueElement *elem;
> > > > +
> > > > +    while ((elem = virtqueue_pop(vq, sizeof(VirtQueueElement)))) {
> > > > +    	unsigned int i;
> > > > +
> > > > +        for (i = 0; i < elem->in_num; i++) {
> > > > +            void *addr = elem->in_sg[i].iov_base;
> > > > +            size_t size = elem->in_sg[i].iov_len;
> > > > +            ram_addr_t ram_offset;
> > > > +            size_t rb_page_size;
> > > > +            RAMBlock *rb;
> > > > +
> > > > +            if (qemu_balloon_is_inhibited())
> > > > +                continue;
> > > > +
> > > > +            rb = qemu_ram_block_from_host(addr, false, &ram_offset);
> > > > +            rb_page_size = qemu_ram_pagesize(rb);
> > > > +
> > > > +            /* For now we will simply ignore unaligned memory regions */
> > > > +            if ((ram_offset | size) & (rb_page_size - 1))
> > > > +                continue;
> > > > +
> > > > +            ram_block_discard_range(rb, ram_offset, size);
> > > I suspect this needs to do like the migration type of
> > > hinting and get disabled if page poisoning is in effect.
> > > Right?
> > Shouldn't something like that end up getting handled via
> > qemu_balloon_is_inhibited, or did I miss something there? I assumed cases
> > like that would end up setting qemu_balloon_is_inhibited to true, if that
> > isn't the case then I could add some additional conditions. I would do it
> > in about the same spot as the qemu_balloon_is_inhibited check.
> 
> Just wondering if you have tried running these patches in an environment with
> directly assigned devices? Ideally, I would expect qemu_balloon_is_inhibited()
> to take care of it.

Yes, I have run that as a test to actually benchmark the effect of things
without the madvise bits since it essentially disables the hinting in the
hypervisor but not the guest.

