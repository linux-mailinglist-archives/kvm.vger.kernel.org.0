Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65200497CF1
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 11:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237038AbiAXKY6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 05:24:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:29506 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232375AbiAXKY6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Jan 2022 05:24:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643019897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=m4y16S8IeNkxkScT7hzZzOysWTzXtiqK7iQjC6ZMAhY=;
        b=VJXTizfdA3EE9LRDX7ppM4qGudoNsjuFfb31szNjT5rpaDfy31kup7SdeWZ/VbZXiv/0RT
        V7/6BHSH3W8rkuws+bT0M513/CXnvMwpUp7E5WafYpu1nxl3aGG/hPVg4LMCe6ZMnQKlVF
        GMxgnGZRiU1vDHe8fUSTkLgV5CPKzmM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-447-7w37MSyGO_yJYsJyRE5PMA-1; Mon, 24 Jan 2022 05:24:53 -0500
X-MC-Unique: 7w37MSyGO_yJYsJyRE5PMA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3F7D61006AA6;
        Mon, 24 Jan 2022 10:24:52 +0000 (UTC)
Received: from localhost (unknown [10.39.193.230])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 911201059A42;
        Mon, 24 Jan 2022 10:24:34 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC] vfio: Revise and update the migration uAPI description
In-Reply-To: <20220120001923.GR84788@nvidia.com>
Organization: Red Hat GmbH
References: <0-v1-a4f7cab64938+3f-vfio_mig_states_jgg@nvidia.com>
 <20220118125522.6c6bb1bb.alex.williamson@redhat.com>
 <20220118210048.GG84788@nvidia.com>
 <20220119083222.4dc529a4.alex.williamson@redhat.com>
 <20220119154028.GO84788@nvidia.com>
 <20220119090614.5f67a9e7.alex.williamson@redhat.com>
 <20220119163821.GP84788@nvidia.com>
 <20220119100217.4aee7451.alex.williamson@redhat.com>
 <20220120001923.GR84788@nvidia.com>
User-Agent: Notmuch/0.34 (https://notmuchmail.org)
Date:   Mon, 24 Jan 2022 11:24:32 +0100
Message-ID: <87fspdl9cv.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 19 2022, Jason Gunthorpe <jgg@nvidia.com> wrote:

> So, OK, I drafted a new series that just replaces the whole v1
> protocol. If we are agreed on breaking everything then I'd like to
> clean the other troublesome bits too, already we have some future
> topics on our radar that will benefit from doing this.

Can you share something about those "future topics"? It will help us
understand what you are trying to do, and maybe others might be going
into that direction as well.

>
> The net result is a fairly stunning removal of ~300 lines of ugly
> kernel driver code, which is significant considering the whole mlx5
> project is only about 1000 lines.
>
> The general gist is to stop abusing a migration region as a system
> call interface and instead define two new migration specific ioctls
> (set_state and arc_supported). Data transfer flows over a dedicated FD
> created for each transfer session with a clear lifecycle instead of
> through the region. qemu will discover the new protocol by issuing the
> arc_supported ioctl. (or if we prefer the other shed colour, using the
> VFIO_DEVICE_FEATURE ioctl instead of arc_supported)
>
> Aside from being a more unixy interface, an FD can be used with
> poll/io_uring/splice/etc and opens up better avenues to optimize for
> operating migrations of multiple devices in parallel. It kills a wack
> of goofy tricky driver code too.

Cleaner code certainly sounds compelling. It will be easier to review a
more concrete proposal, though, so I'll reserve judgment until then.

