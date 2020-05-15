Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B18951D584B
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 19:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726206AbgEORvW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 13:51:22 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:30629 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726144AbgEORvV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 May 2020 13:51:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589565080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vanYtfZyXcbovVUz0PsUuXeLhO3F7puLUyYiB1U7kYE=;
        b=hQnrwFUDXi53z1m00k89XyTxpvIv/5uQcAwN9UgD2eoHDQ7OonZgTwDeIU1JDtqA+WtzRm
        L4/+cJ0PfXyQrEDYGO3yRRFypdaoo2KflcoyNG/6lWBGCDB43cCbdS1Z9ey4LUT9eb8ET4
        nyzFPBe1hDq0VB9IAAOFmJjZGa2jfuk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-GmCtVheaNcGmxf-ZPupsmw-1; Fri, 15 May 2020 13:51:17 -0400
X-MC-Unique: GmCtVheaNcGmxf-ZPupsmw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 26E9780183C;
        Fri, 15 May 2020 17:51:16 +0000 (UTC)
Received: from work-vm (ovpn-114-149.ams2.redhat.com [10.36.114.149])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2019E5D9C9;
        Fri, 15 May 2020 17:51:08 +0000 (UTC)
Date:   Fri, 15 May 2020 18:51:05 +0100
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
Message-ID: <20200515175105.GL2954@work-vm>
References: <20200506094948.76388-1-david@redhat.com>
 <20200506094948.76388-8-david@redhat.com>
 <20200515124501.GE2954@work-vm>
 <96a58e88-2629-f2ee-5884-38d11e571548@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96a58e88-2629-f2ee-5884-38d11e571548@redhat.com>
User-Agent: Mutt/1.13.4 (2020-02-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* David Hildenbrand (david@redhat.com) wrote:
> On 15.05.20 14:45, Dr. David Alan Gilbert wrote:
> > * David Hildenbrand (david@redhat.com) wrote:
> >> RDMA will pin all guest memory (as documented in docs/rdma.txt). We want
> >> to mark RAM block discards to be broken - however, to keep it simple
> >> use ram_block_discard_is_required() instead of inhibiting.
> > 
> > Should this be dependent on whether rdma->pin_all is set?
> > Even with !pin_all some will be pinned at any given time
> > (when it's registered with the rdma stack).
> 
> Do you know how much memory this is? Is such memory only temporarily pinned?

With pin_all not set, only a subset of memory, I think multiple 1MB
chunks, are pinned at any one time.

> At least with special-cases of vfio, it's acceptable if some memory is
> temporarily pinned - we assume it's only the working set of the driver,
> which guests will not inflate as long as they don't want to shoot
> themselves in the foot.
> 
> This here sounds like the guest does not know the pinned memory is
> special, right?

Right - for RDMA it's all of memory that's being transferred, and the
guest doesn't see when each part is transferred.

Dave

> -- 
> Thanks,
> 
> David / dhildenb
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

