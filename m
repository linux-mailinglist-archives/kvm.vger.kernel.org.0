Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90B39744D1
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2019 07:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390541AbfGYFVQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jul 2019 01:21:16 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:36717 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387743AbfGYFVQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jul 2019 01:21:16 -0400
Received: by mail-qt1-f196.google.com with SMTP id z4so47942109qtc.3
        for <kvm@vger.kernel.org>; Wed, 24 Jul 2019 22:21:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ij2gAdKa9zJFg927gRyeBU4x4qxEHqTLEtL3Pad0Y1Q=;
        b=O0ISOnlks2VM4H8IjXEq2FZTYvorvVosHBdFh4+nG/BAboRE7lVQHIWv2HZukey2CZ
         bd0TxsqeLat6GcX2DpEVz9qxwMNSCCS5BJx/cIHSz+3Hp9RIFmoph+lv0N+BmDNTWz9P
         LA09mbjW58JIUSmwKnrucrZyqqS+UyOpyXbDCez+JkZW4dopyP4WkfFyKi1V6INhhCiY
         DGuWU5sIVJoiGgGPO9J//1KaaGAIhO9LPEcX5vzuJm0bFN10Oc2RnlfgAwvIp3vhsXmO
         OoR+FRSmJeg/Zl6b1YJAQbWH7TTA+aqBwkqtNNh3Gd3tnLx6CES4OXWfiDVrbH2I6sTd
         GF7w==
X-Gm-Message-State: APjAAAUfhnRr63c4C6VJ0L0pUlJpuVYtBv+zzNWJY1ZyBZjL89FyjH1a
        pMor1tAPfRxgntY9VAu0wGIQrA==
X-Google-Smtp-Source: APXvYqyH+kPPC/RgJkqmP3mhZoKYk3W8Vnv5UNtxePT9Ese+Du9AfXK1iHcVJ8tRRtEs2NQhD73WwA==
X-Received: by 2002:ac8:2409:: with SMTP id c9mr60774507qtc.145.1564032075057;
        Wed, 24 Jul 2019 22:21:15 -0700 (PDT)
Received: from redhat.com (bzq-79-181-91-42.red.bezeqint.net. [79.181.91.42])
        by smtp.gmail.com with ESMTPSA id e1sm24011738qtb.52.2019.07.24.22.21.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 22:21:13 -0700 (PDT)
Date:   Thu, 25 Jul 2019 01:21:09 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] vhost: mark dirty pages during map uninit
Message-ID: <20190725010944-mutt-send-email-mst@kernel.org>
References: <20190723075718.6275-1-jasowang@redhat.com>
 <20190723075718.6275-6-jasowang@redhat.com>
 <20190723041702-mutt-send-email-mst@kernel.org>
 <a670cd0d-581d-1aba-41bd-c643c19f9604@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a670cd0d-581d-1aba-41bd-c643c19f9604@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 23, 2019 at 09:19:33PM +0800, Jason Wang wrote:
> 
> On 2019/7/23 下午5:17, Michael S. Tsirkin wrote:
> > On Tue, Jul 23, 2019 at 03:57:17AM -0400, Jason Wang wrote:
> > > We don't mark dirty pages if the map was teared down outside MMU
> > > notifier. This will lead untracked dirty pages. Fixing by marking
> > > dirty pages during map uninit.
> > > 
> > > Reported-by: Michael S. Tsirkin<mst@redhat.com>
> > > Fixes: 7f466032dc9e ("vhost: access vq metadata through kernel virtual address")
> > > Signed-off-by: Jason Wang<jasowang@redhat.com>
> > > ---
> > >   drivers/vhost/vhost.c | 22 ++++++++++++++++------
> > >   1 file changed, 16 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > > index 89c9f08b5146..5b8821d00fe4 100644
> > > --- a/drivers/vhost/vhost.c
> > > +++ b/drivers/vhost/vhost.c
> > > @@ -306,6 +306,18 @@ static void vhost_map_unprefetch(struct vhost_map *map)
> > >   	kfree(map);
> > >   }
> > > +static void vhost_set_map_dirty(struct vhost_virtqueue *vq,
> > > +				struct vhost_map *map, int index)
> > > +{
> > > +	struct vhost_uaddr *uaddr = &vq->uaddrs[index];
> > > +	int i;
> > > +
> > > +	if (uaddr->write) {
> > > +		for (i = 0; i < map->npages; i++)
> > > +			set_page_dirty(map->pages[i]);
> > > +	}
> > > +}
> > > +
> > >   static void vhost_uninit_vq_maps(struct vhost_virtqueue *vq)
> > >   {
> > >   	struct vhost_map *map[VHOST_NUM_ADDRS];
> > > @@ -315,8 +327,10 @@ static void vhost_uninit_vq_maps(struct vhost_virtqueue *vq)
> > >   	for (i = 0; i < VHOST_NUM_ADDRS; i++) {
> > >   		map[i] = rcu_dereference_protected(vq->maps[i],
> > >   				  lockdep_is_held(&vq->mmu_lock));
> > > -		if (map[i])
> > > +		if (map[i]) {
> > > +			vhost_set_map_dirty(vq, map[i], i);
> > >   			rcu_assign_pointer(vq->maps[i], NULL);
> > > +		}
> > >   	}
> > >   	spin_unlock(&vq->mmu_lock);
> > > @@ -354,7 +368,6 @@ static void vhost_invalidate_vq_start(struct vhost_virtqueue *vq,
> > >   {
> > >   	struct vhost_uaddr *uaddr = &vq->uaddrs[index];
> > >   	struct vhost_map *map;
> > > -	int i;
> > >   	if (!vhost_map_range_overlap(uaddr, start, end))
> > >   		return;
> > > @@ -365,10 +378,7 @@ static void vhost_invalidate_vq_start(struct vhost_virtqueue *vq,
> > >   	map = rcu_dereference_protected(vq->maps[index],
> > >   					lockdep_is_held(&vq->mmu_lock));
> > >   	if (map) {
> > > -		if (uaddr->write) {
> > > -			for (i = 0; i < map->npages; i++)
> > > -				set_page_dirty(map->pages[i]);
> > > -		}
> > > +		vhost_set_map_dirty(vq, map, index);
> > >   		rcu_assign_pointer(vq->maps[index], NULL);
> > >   	}
> > >   	spin_unlock(&vq->mmu_lock);
> > OK and the reason it's safe is because the invalidate counter
> > got incremented so we know page will not get mapped again.
> > 
> > But we*do*  need to wait for page not to be mapped.
> > And if that means waiting for VQ processing to finish,
> > then I worry that is a very log time.
> > 
> 
> I'm not sure I get you here. If we don't have such map, we will fall back to
> normal uaccess helper. And in the memory accessor, the rcu critical section
> is pretty small.
> 
> Thanks
> 

OK. So the trick is that page_mkclean invokes mmu notifiers.

-- 
MST
