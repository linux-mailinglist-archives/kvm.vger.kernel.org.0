Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83D51207770
	for <lists+kvm@lfdr.de>; Wed, 24 Jun 2020 17:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404199AbgFXPcz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jun 2020 11:32:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45522 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2403982AbgFXPcy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jun 2020 11:32:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593012773;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MibKmJVV6AzB2R1mLnJ2GOBtIl06faeNTGVd30Li320=;
        b=WP4taYk7Ny4f0THH/zUkU3vBKb1iIIG9Gjn13NhJMQpptwEe6YCzwh91QUXfFFD46nL0Xt
        md6Gg7wwrdQtUBqBNQwImARiu2/o67bip5Q6SyiYvg9BSurDGNTpB1CApsSZyRl13JZRMj
        5e6japMk1lpCdRtnUvM20plJDDY3S7w=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-433-q-o87wEmMfGCgtzMp02Y3g-1; Wed, 24 Jun 2020 11:32:46 -0400
X-MC-Unique: q-o87wEmMfGCgtzMp02Y3g-1
Received: by mail-wm1-f72.google.com with SMTP id v6so780115wmg.1
        for <kvm@vger.kernel.org>; Wed, 24 Jun 2020 08:32:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MibKmJVV6AzB2R1mLnJ2GOBtIl06faeNTGVd30Li320=;
        b=DqJRma4ri0Brkpmhv3+gnvmnUb6Tla9vbkQLGZhODheHDgPw75w3G5967XGByU2w/3
         srXCTzkwST2sgXWNpA7LOBckkZA56PWsMXZcdX7SZXxDWubMA9eiyH8SUrgZYG0kgnY/
         AeFAHc+ZAmY+GzGmrZocivH55rrPXQjTITvAe5SaCOycsumGAJ3A8u+Qa7YOMF0g/7NZ
         M+5AaEtkOryO3OQ+qlrPUZqzC0oRkWjZDDZ6gn2ZsWnoSgGU1DPEgnyba6gL2C803RSJ
         p41UP6a7FSLl+mpqQbvRGqjaWXRTQ3f7FuOA9jXSxK2UUDWUWmdMbIClUr6DxgFx4IEg
         XfBA==
X-Gm-Message-State: AOAM531PAVK7BRdqst5Cu84I2iE/kidUaSpEAFikzztCf0Ll3iD0tort
        hyIUefFnatOKLagHHRWPUUr+mpl7AY1P0kdZTNjNVW2B6nSRokbLvvAM1qe4NH3j8uOqqi0kBOf
        1w270fV5R6hTS
X-Received: by 2002:adf:f504:: with SMTP id q4mr11265605wro.163.1593012765355;
        Wed, 24 Jun 2020 08:32:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzjQ1giey2rjFIGqUYOyS8zbZ1r3MZGwvheZnK8Zv8ooRQ2AgTuN5mogTvExqdQmETyr7SaSw==
X-Received: by 2002:adf:f504:: with SMTP id q4mr11265591wro.163.1593012765147;
        Wed, 24 Jun 2020 08:32:45 -0700 (PDT)
Received: from redhat.com ([82.166.20.53])
        by smtp.gmail.com with ESMTPSA id z16sm17870134wrr.35.2020.06.24.08.32.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 08:32:44 -0700 (PDT)
Date:   Wed, 24 Jun 2020 11:32:41 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Juan Quintela <quintela@redhat.com>
Subject: Re: [PATCH v4 05/21] virtio-balloon: Rip out qemu_balloon_inhibit()
Message-ID: <20200624113236-mutt-send-email-mst@kernel.org>
References: <20200610115419.51688-1-david@redhat.com>
 <20200610115419.51688-6-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200610115419.51688-6-david@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 10, 2020 at 01:54:03PM +0200, David Hildenbrand wrote:
> The only remaining special case is postcopy. It cannot handle
> concurrent discards yet, which would result in requesting already sent
> pages from the source. Special-case it in virtio-balloon instead.
> 
> Introduce migration_in_incoming_postcopy(), to find out if incoming
> postcopy is active.
> 
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Juan Quintela <quintela@redhat.com>
> Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  balloon.c                  | 18 ------------------
>  hw/virtio/virtio-balloon.c |  8 +++++++-
>  include/migration/misc.h   |  2 ++
>  include/sysemu/balloon.h   |  2 --
>  migration/migration.c      |  7 +++++++
>  migration/postcopy-ram.c   | 23 -----------------------
>  6 files changed, 16 insertions(+), 44 deletions(-)
> 
> diff --git a/balloon.c b/balloon.c
> index 5fff79523a..354408c6ea 100644
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
> -           ram_block_discard_is_disabled();
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
> index 065cd450f1..5ce2f956df 100644
> --- a/hw/virtio/virtio-balloon.c
> +++ b/hw/virtio/virtio-balloon.c
> @@ -63,6 +63,12 @@ static bool virtio_balloon_pbp_matches(PartiallyBalloonedPage *pbp,
>      return pbp->base_gpa == base_gpa;
>  }
>  
> +static bool virtio_balloon_inhibited(void)
> +{
> +    /* Postcopy cannot deal with concurrent discards, so it's special. */
> +    return ram_block_discard_is_disabled() || migration_in_incoming_postcopy();
> +}
> +
>  static void balloon_inflate_page(VirtIOBalloon *balloon,
>                                   MemoryRegion *mr, hwaddr mr_offset,
>                                   PartiallyBalloonedPage *pbp)
> @@ -360,7 +366,7 @@ static void virtio_balloon_handle_output(VirtIODevice *vdev, VirtQueue *vq)
>  
>              trace_virtio_balloon_handle_output(memory_region_name(section.mr),
>                                                 pa);
> -            if (!qemu_balloon_is_inhibited()) {
> +            if (!virtio_balloon_inhibited()) {
>                  if (vq == s->ivq) {
>                      balloon_inflate_page(s, section.mr,
>                                           section.offset_within_region, &pbp);
> diff --git a/include/migration/misc.h b/include/migration/misc.h
> index d2762257aa..34e7d75713 100644
> --- a/include/migration/misc.h
> +++ b/include/migration/misc.h
> @@ -69,6 +69,8 @@ bool migration_has_failed(MigrationState *);
>  /* ...and after the device transmission */
>  bool migration_in_postcopy_after_devices(MigrationState *);
>  void migration_global_dump(Monitor *mon);
> +/* True if incomming migration entered POSTCOPY_INCOMING_DISCARD */
> +bool migration_in_incoming_postcopy(void);
>  
>  /* migration/block-dirty-bitmap.c */
>  void dirty_bitmap_mig_init(void);
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
> diff --git a/migration/migration.c b/migration/migration.c
> index b63ad91d34..14856cc930 100644
> --- a/migration/migration.c
> +++ b/migration/migration.c
> @@ -1772,6 +1772,13 @@ bool migration_in_postcopy_after_devices(MigrationState *s)
>      return migration_in_postcopy() && s->postcopy_after_devices;
>  }
>  
> +bool migration_in_incoming_postcopy(void)
> +{
> +    PostcopyState ps = postcopy_state_get();
> +
> +    return ps >= POSTCOPY_INCOMING_DISCARD && ps < POSTCOPY_INCOMING_END;
> +}
> +
>  bool migration_is_idle(void)
>  {
>      MigrationState *s = current_migration;
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
> 2.26.2

