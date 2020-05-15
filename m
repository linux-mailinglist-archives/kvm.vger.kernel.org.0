Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFDC11D4FAA
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 15:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726257AbgEON66 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 09:58:58 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:45777 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726255AbgEON66 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 May 2020 09:58:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589551136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YC0+HeJZZLS3s6YpYlY6qQx+znWjeBMmEoJi+7Lxseo=;
        b=E3PORlAF4d6NFs1gHhSHIasxHJs3LQ7HsNZWVnv6F+PRVK1hvx4eqmDQycyjk7DR2LkcCf
        nMjpIxKKPtNOIpY3y5tvSm2icjuWGI5Khdgz7q/aNa6PJ6CYqM59AeKsWyMZKxVl7LbrtD
        qr6a+JmugnGj7EluiJYYpthoCSjV9wo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-16WZiDSCP0-pzg4_PF_kQQ-1; Fri, 15 May 2020 09:58:55 -0400
X-MC-Unique: 16WZiDSCP0-pzg4_PF_kQQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B46BE1005510;
        Fri, 15 May 2020 13:58:53 +0000 (UTC)
Received: from work-vm (ovpn-114-149.ams2.redhat.com [10.36.114.149])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 728C41943D;
        Fri, 15 May 2020 13:58:43 +0000 (UTC)
Date:   Fri, 15 May 2020 14:58:41 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Hailiang Zhang <zhang.zhanghailiang@huawei.com>,
        Juan Quintela <quintela@redhat.com>
Subject: Re: [PATCH v1 08/17] migration/colo: Use
 ram_block_discard_set_broken()
Message-ID: <20200515135841.GF2954@work-vm>
References: <20200506094948.76388-1-david@redhat.com>
 <20200506094948.76388-9-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506094948.76388-9-david@redhat.com>
User-Agent: Mutt/1.13.4 (2020-02-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* David Hildenbrand (david@redhat.com) wrote:
> COLO will copy all memory in a RAM block, mark discarding of RAM broken.
> 
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Hailiang Zhang <zhang.zhanghailiang@huawei.com>
> Cc: Juan Quintela <quintela@redhat.com>
> Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  include/migration/colo.h |  2 +-
>  migration/migration.c    |  8 +++++++-
>  migration/savevm.c       | 11 +++++++++--
>  3 files changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/include/migration/colo.h b/include/migration/colo.h
> index 1636e6f907..768e1f04c3 100644
> --- a/include/migration/colo.h
> +++ b/include/migration/colo.h
> @@ -25,7 +25,7 @@ void migrate_start_colo_process(MigrationState *s);
>  bool migration_in_colo_state(void);
>  
>  /* loadvm */
> -void migration_incoming_enable_colo(void);
> +int migration_incoming_enable_colo(void);
>  void migration_incoming_disable_colo(void);
>  bool migration_incoming_colo_enabled(void);
>  void *colo_process_incoming_thread(void *opaque);
> diff --git a/migration/migration.c b/migration/migration.c
> index 177cce9e95..f6830e4620 100644
> --- a/migration/migration.c
> +++ b/migration/migration.c
> @@ -338,12 +338,18 @@ bool migration_incoming_colo_enabled(void)
>  
>  void migration_incoming_disable_colo(void)
>  {
> +    ram_block_discard_set_broken(false);
>      migration_colo_enabled = false;
>  }
>  
> -void migration_incoming_enable_colo(void)
> +int migration_incoming_enable_colo(void)
>  {
> +    if (ram_block_discard_set_broken(true)) {
> +        error_report("COLO: cannot set discarding of RAM broken");

I'd prefer 'COLO: cannot disable RAM discard'

'broken' suggests the user has to go and fix something or report a bug
or something.

Other than that:


Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

Dave

> +        return -EBUSY;
> +    }
>      migration_colo_enabled = true;
> +    return 0;
>  }
>  
>  void migrate_add_address(SocketAddress *address)
> diff --git a/migration/savevm.c b/migration/savevm.c
> index c00a6807d9..19b4f9600d 100644
> --- a/migration/savevm.c
> +++ b/migration/savevm.c
> @@ -2111,8 +2111,15 @@ static int loadvm_handle_recv_bitmap(MigrationIncomingState *mis,
>  
>  static int loadvm_process_enable_colo(MigrationIncomingState *mis)
>  {
> -    migration_incoming_enable_colo();
> -    return colo_init_ram_cache();
> +    int ret = migration_incoming_enable_colo();
> +
> +    if (!ret) {
> +        ret = colo_init_ram_cache();
> +        if (ret) {
> +            migration_incoming_disable_colo();
> +        }
> +    }
> +    return ret;
>  }
>  
>  /*
> -- 
> 2.25.3
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

