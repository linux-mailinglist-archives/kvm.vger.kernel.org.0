Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB9B81D4D72
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 14:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbgEOMJr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 08:09:47 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58463 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726122AbgEOMJr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 May 2020 08:09:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589544585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U82JItAKHgJCOazsxj+11L8uC4svEo4DKJ3JMCEbMpU=;
        b=aI3MwCV+HkqRB19+kGNkNtYc8fqNd+l8OTUm49upNQuQ3nRzBnLYjAVG9x/romFZNgDXcy
        S63WndMZYQWqt/Fd71QPEXhBZwnMKHrSacwT3hiBT3hUsl6xKKrTB5J2xrLwpJbjgNzuZA
        GRuc69TbaOGXZPQBY9j2MF2kzaaEjKw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-5WNZdEIxNqmRa2gbRxrx3w-1; Fri, 15 May 2020 08:09:39 -0400
X-MC-Unique: 5WNZdEIxNqmRa2gbRxrx3w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 662AB460;
        Fri, 15 May 2020 12:09:38 +0000 (UTC)
Received: from work-vm (ovpn-114-149.ams2.redhat.com [10.36.114.149])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 500276E70D;
        Fri, 15 May 2020 12:09:29 +0000 (UTC)
Date:   Fri, 15 May 2020 13:09:27 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Juan Quintela <quintela@redhat.com>
Subject: Re: [PATCH v1 05/17] virtio-balloon: Rip out qemu_balloon_inhibit()
Message-ID: <20200515120927.GD2954@work-vm>
References: <20200506094948.76388-1-david@redhat.com>
 <20200506094948.76388-6-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506094948.76388-6-david@redhat.com>
User-Agent: Mutt/1.13.4 (2020-02-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* David Hildenbrand (david@redhat.com) wrote:
> The only remaining special case is postcopy. It cannot handle
> concurrent discards yet, which would result in requesting already sent
> pages from the source. Special-case it in virtio-balloon instead.
> 
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Juan Quintela <quintela@redhat.com>
> Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  balloon.c                  | 18 ------------------
>  hw/virtio/virtio-balloon.c | 12 +++++++++++-
>  include/sysemu/balloon.h   |  2 --
>  migration/postcopy-ram.c   | 23 -----------------------
>  4 files changed, 11 insertions(+), 44 deletions(-)
> 
> diff --git a/balloon.c b/balloon.c
> index c49f57c27b..354408c6ea 100644
> --- a/balloon.c
> +++ b/balloon.c
> @@ -36,24 +36,6 @@
>  static QEMUBalloonEvent *balloon_event_fn;
>  static QEMUBalloonStatus *balloon_stat_fn;
>  static void *balloon_opaque;
> -static int balloon_inhibit_count;
> -
> -bool qemu_balloon_is_inhibited(void)
> -{
> -    return atomic_read(&balloon_inhibit_count) > 0 ||
> -           ram_block_discard_is_broken();
> -}
> -
> -void qemu_balloon_inhibit(bool state)
> -{
> -    if (state) {
> -        atomic_inc(&balloon_inhibit_count);
> -    } else {
> -        atomic_dec(&balloon_inhibit_count);
> -    }
> -
> -    assert(atomic_read(&balloon_inhibit_count) >= 0);
> -}
>  
>  static bool have_balloon(Error **errp)
>  {
> diff --git a/hw/virtio/virtio-balloon.c b/hw/virtio/virtio-balloon.c
> index a4729f7fc9..aa5b89fb47 100644
> --- a/hw/virtio/virtio-balloon.c
> +++ b/hw/virtio/virtio-balloon.c
> @@ -29,6 +29,7 @@
>  #include "trace.h"
>  #include "qemu/error-report.h"
>  #include "migration/misc.h"
> +#include "migration/postcopy-ram.h"
>  
>  #include "hw/virtio/virtio-bus.h"
>  #include "hw/virtio/virtio-access.h"
> @@ -63,6 +64,15 @@ static bool virtio_balloon_pbp_matches(PartiallyBalloonedPage *pbp,
>      return pbp->base_gpa == base_gpa;
>  }
>  
> +static bool virtio_balloon_inhibited(void)
> +{
> +    PostcopyState ps = postcopy_state_get();
> +
> +    /* Postcopy cannot deal with concurrent discards (yet), so it's special. */
> +    return ram_block_discard_is_broken() ||
> +           (ps >= POSTCOPY_INCOMING_DISCARD && ps < POSTCOPY_INCOMING_END);

It's a shame this is open-coded here; it would be better to have
something in migration.c ; we have a migration_in_postcopy but that's
really the sending side; a 'migration_in_incoming_postcopy' would
perhaps be good.

Dave

> +}
> +
>  static void balloon_inflate_page(VirtIOBalloon *balloon,
>                                   MemoryRegion *mr, hwaddr mr_offset,
>                                   PartiallyBalloonedPage *pbp)
> @@ -360,7 +370,7 @@ static void virtio_balloon_handle_output(VirtIODevice *vdev, VirtQueue *vq)
>  
>              trace_virtio_balloon_handle_output(memory_region_name(section.mr),
>                                                 pa);
> -            if (!qemu_balloon_is_inhibited()) {
> +            if (!virtio_balloon_inhibited()) {
>                  if (vq == s->ivq) {
>                      balloon_inflate_page(s, section.mr,
>                                           section.offset_within_region, &pbp);
> diff --git a/include/sysemu/balloon.h b/include/sysemu/balloon.h
> index aea0c44985..20a2defe3a 100644
> --- a/include/sysemu/balloon.h
> +++ b/include/sysemu/balloon.h
> @@ -23,7 +23,5 @@ typedef void (QEMUBalloonStatus)(void *opaque, BalloonInfo *info);
>  int qemu_add_balloon_handler(QEMUBalloonEvent *event_func,
>                               QEMUBalloonStatus *stat_func, void *opaque);
>  void qemu_remove_balloon_handler(void *opaque);
> -bool qemu_balloon_is_inhibited(void);
> -void qemu_balloon_inhibit(bool state);
>  
>  #endif
> diff --git a/migration/postcopy-ram.c b/migration/postcopy-ram.c
> index a36402722b..b41a9fe2fd 100644
> --- a/migration/postcopy-ram.c
> +++ b/migration/postcopy-ram.c
> @@ -27,7 +27,6 @@
>  #include "qemu/notify.h"
>  #include "qemu/rcu.h"
>  #include "sysemu/sysemu.h"
> -#include "sysemu/balloon.h"
>  #include "qemu/error-report.h"
>  #include "trace.h"
>  #include "hw/boards.h"
> @@ -520,20 +519,6 @@ int postcopy_ram_incoming_init(MigrationIncomingState *mis)
>      return 0;
>  }
>  
> -/*
> - * Manage a single vote to the QEMU balloon inhibitor for all postcopy usage,
> - * last caller wins.
> - */
> -static void postcopy_balloon_inhibit(bool state)
> -{
> -    static bool cur_state = false;
> -
> -    if (state != cur_state) {
> -        qemu_balloon_inhibit(state);
> -        cur_state = state;
> -    }
> -}
> -
>  /*
>   * At the end of a migration where postcopy_ram_incoming_init was called.
>   */
> @@ -565,8 +550,6 @@ int postcopy_ram_incoming_cleanup(MigrationIncomingState *mis)
>          mis->have_fault_thread = false;
>      }
>  
> -    postcopy_balloon_inhibit(false);
> -
>      if (enable_mlock) {
>          if (os_mlock() < 0) {
>              error_report("mlock: %s", strerror(errno));
> @@ -1160,12 +1143,6 @@ int postcopy_ram_incoming_setup(MigrationIncomingState *mis)
>      }
>      memset(mis->postcopy_tmp_zero_page, '\0', mis->largest_page_size);
>  
> -    /*
> -     * Ballooning can mark pages as absent while we're postcopying
> -     * that would cause false userfaults.
> -     */
> -    postcopy_balloon_inhibit(true);
> -
>      trace_postcopy_ram_enable_notify();
>  
>      return 0;
> -- 
> 2.25.3
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

