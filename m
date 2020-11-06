Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B105F2AA154
	for <lists+kvm@lfdr.de>; Sat,  7 Nov 2020 00:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729101AbgKFXaE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 18:30:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31345 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729100AbgKFXaD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Nov 2020 18:30:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604705401;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CNqa8rLlNR/p/YGNQDszmC868RyLFwjPjKeEsnCQpCE=;
        b=a0LDroK8DnMvsgAZmi0FMiLZbI/KbTkeFJSjPbSTPqS909zERTZfqC3zqSb5Hd8n6L8QYT
        2jvQ1xQwR4Z3ziE/95q94pZagwHN83E8vBgLJIe5KLkcS68Dlz+4K0UcCZMmeiilsyJbac
        v/PfN4UwPzexwdsYLKMrLrcJ3MkF3GA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-iEbX96z9Mg-s24SOSMQm6g-1; Fri, 06 Nov 2020 18:29:59 -0500
X-MC-Unique: iEbX96z9Mg-s24SOSMQm6g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 69AD68049D0;
        Fri,  6 Nov 2020 23:29:57 +0000 (UTC)
Received: from x1.home (ovpn-112-213.phx2.redhat.com [10.3.112.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BB4215D9CD;
        Fri,  6 Nov 2020 23:29:56 +0000 (UTC)
Date:   Fri, 6 Nov 2020 16:29:56 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     David Woodhouse <dwmw2@infradead.org>,
        "Bonzini, Paolo" <pbonzini@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/3] vfio/virqfd: Drain events from eventfd in
 virqfd_wakeup()
Message-ID: <20201106162956.5821c536@x1.home>
In-Reply-To: <20201027135523.646811-3-dwmw2@infradead.org>
References: <1faa5405-3640-f4ad-5cd9-89a9e5e834e9@redhat.com>
 <20201027135523.646811-1-dwmw2@infradead.org>
 <20201027135523.646811-3-dwmw2@infradead.org>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 27 Oct 2020 13:55:22 +0000
David Woodhouse <dwmw2@infradead.org> wrote:

> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> Don't allow the events to accumulate in the eventfd counter, drain them
> as they are handled.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---

Acked-by: Alex Williamson <alex.williamson@redhat.com>

Paolo, I assume you'll add this to your queue.  Thanks,

Alex

>  drivers/vfio/virqfd.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/vfio/virqfd.c b/drivers/vfio/virqfd.c
> index 997cb5d0a657..414e98d82b02 100644
> --- a/drivers/vfio/virqfd.c
> +++ b/drivers/vfio/virqfd.c
> @@ -46,6 +46,9 @@ static int virqfd_wakeup(wait_queue_entry_t *wait, unsigned mode, int sync, void
>  	__poll_t flags = key_to_poll(key);
>  
>  	if (flags & EPOLLIN) {
> +		u64 cnt;
> +		eventfd_ctx_do_read(virqfd->eventfd, &cnt);
> +
>  		/* An event has been signaled, call function */
>  		if ((!virqfd->handler ||
>  		     virqfd->handler(virqfd->opaque, virqfd->data)) &&

