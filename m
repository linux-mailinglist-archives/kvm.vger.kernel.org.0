Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36C751D5921
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 20:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbgEOShI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 14:37:08 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42145 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726227AbgEOShI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 May 2020 14:37:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589567826;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iS2BZEZhYnHE5mi0Tf0cUE2Vbxbk8ajM07NE1jWnMoA=;
        b=HG4DgOUIcBLWUcwjmssNuVyPsSwcepB0oWK4PhVdXwZyMbrSSKtpzCSiA4EFK5+ALHrZI9
        zQQ9kY6p+UlHaLjRo72vi/3HJWWvkDp8leJqL4LioG6yi9G5qIl1Eks3LUdS+cRckv663a
        vgc4H9vPChxswmC8Tlu667GqHf7PuFs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466-Zy5vaWusMkeTl9eED5XF2g-1; Fri, 15 May 2020 14:37:04 -0400
X-MC-Unique: Zy5vaWusMkeTl9eED5XF2g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9B7B480B73A;
        Fri, 15 May 2020 18:37:03 +0000 (UTC)
Received: from work-vm (ovpn-114-149.ams2.redhat.com [10.36.114.149])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0F3725C3E7;
        Fri, 15 May 2020 18:36:54 +0000 (UTC)
Date:   Fri, 15 May 2020 19:36:52 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Juan Quintela <quintela@redhat.com>
Subject: Re: [PATCH v1 07/17] migration/rdma: Use
 ram_block_discard_set_broken()
Message-ID: <20200515183652.GM2954@work-vm>
References: <20200506094948.76388-1-david@redhat.com>
 <20200506094948.76388-8-david@redhat.com>
 <20200515124501.GE2954@work-vm>
 <96a58e88-2629-f2ee-5884-38d11e571548@redhat.com>
 <20200515175105.GL2954@work-vm>
 <1cac6cb0-7804-bab2-4ecf-044c369c1135@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1cac6cb0-7804-bab2-4ecf-044c369c1135@redhat.com>
User-Agent: Mutt/1.13.4 (2020-02-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* David Hildenbrand (david@redhat.com) wrote:
> On 15.05.20 19:51, Dr. David Alan Gilbert wrote:
> > * David Hildenbrand (david@redhat.com) wrote:
> >> On 15.05.20 14:45, Dr. David Alan Gilbert wrote:
> >>> * David Hildenbrand (david@redhat.com) wrote:
> >>>> RDMA will pin all guest memory (as documented in docs/rdma.txt). We want
> >>>> to mark RAM block discards to be broken - however, to keep it simple
> >>>> use ram_block_discard_is_required() instead of inhibiting.
> >>>
> >>> Should this be dependent on whether rdma->pin_all is set?
> >>> Even with !pin_all some will be pinned at any given time
> >>> (when it's registered with the rdma stack).
> >>
> >> Do you know how much memory this is? Is such memory only temporarily pinned?
> > 
> > With pin_all not set, only a subset of memory, I think multiple 1MB
> > chunks, are pinned at any one time.
> > 
> >> At least with special-cases of vfio, it's acceptable if some memory is
> >> temporarily pinned - we assume it's only the working set of the driver,
> >> which guests will not inflate as long as they don't want to shoot
> >> themselves in the foot.
> >>
> >> This here sounds like the guest does not know the pinned memory is
> >> special, right?
> > 
> > Right - for RDMA it's all of memory that's being transferred, and the
> > guest doesn't see when each part is transferred.
> 
> 
> Okay, so all memory will eventually be pinned, just not at the same
> time, correct?
> 
> I think this implies that any memory that was previously discarded will
> be backed my new pages, meaning we will consume more memory than intended.
> 
> If so, always disabling discarding of RAM seems to be the right thing to do.

Yeh that's probably true, although there's a check for 'buffer_is_zero'
in the !rdma->pin_all case, if the entire area is zero (or probably if
unmapped) then it sends a notification rather than registering; see
qemu_rdma_write_one and search for 'This chunk has not yet been
registered, so first check to see'

Dave

> 
> -- 
> Thanks,
> 
> David / dhildenb
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

