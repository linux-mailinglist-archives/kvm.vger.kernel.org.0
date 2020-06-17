Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70CD91FD3CE
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 19:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgFQRzG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 13:55:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25861 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726496AbgFQRzG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jun 2020 13:55:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592416504;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9uliBsP0an46gPx+oD2wPLvOfI9JPxFlPTJ+G83rjdw=;
        b=VwhsHfMhCN1p2yzqf7hA0xVzF6E8Q/yrUuYAJqtshHfEDS+FS3uaVvZah2YbSX8DOtha7C
        VWJoQB0wHE9kp0S3j7p6n7kmrnAPWu/f8TVXyLGtYl2v+0ZyLLpJdvXTAIoMhm0PcVLzb5
        ZD5J/mRSf1vHFXE95VwwQCthnUfyNyA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-TpG8KuHNP8KlmTijxJmZOA-1; Wed, 17 Jun 2020 13:55:01 -0400
X-MC-Unique: TpG8KuHNP8KlmTijxJmZOA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 49F42BFC0;
        Wed, 17 Jun 2020 17:55:00 +0000 (UTC)
Received: from work-vm (ovpn-115-47.ams2.redhat.com [10.36.115.47])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E11E8512FE;
        Wed, 17 Jun 2020 17:54:53 +0000 (UTC)
Date:   Wed, 17 Jun 2020 18:54:50 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v4 13/21] hmp: Handle virtio-mem when printing memory
 device info
Message-ID: <20200617175450.GK2776@work-vm>
References: <20200610115419.51688-1-david@redhat.com>
 <20200610115419.51688-14-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200610115419.51688-14-david@redhat.com>
User-Agent: Mutt/1.14.0 (2020-05-02)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* David Hildenbrand (david@redhat.com) wrote:
> Print the memory device info just like for other memory devices.
> 
> Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> ---
>  monitor/hmp-cmds.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/monitor/hmp-cmds.c b/monitor/hmp-cmds.c
> index 9c61e769ca..afc9a28069 100644
> --- a/monitor/hmp-cmds.c
> +++ b/monitor/hmp-cmds.c
> @@ -1818,6 +1818,7 @@ void hmp_info_memory_devices(Monitor *mon, const QDict *qdict)
>      MemoryDeviceInfoList *info_list = qmp_query_memory_devices(&err);
>      MemoryDeviceInfoList *info;
>      VirtioPMEMDeviceInfo *vpi;
> +    VirtioMEMDeviceInfo *vmi;
>      MemoryDeviceInfo *value;
>      PCDIMMDeviceInfo *di;
>  
> @@ -1852,6 +1853,21 @@ void hmp_info_memory_devices(Monitor *mon, const QDict *qdict)
>                  monitor_printf(mon, "  size: %" PRIu64 "\n", vpi->size);
>                  monitor_printf(mon, "  memdev: %s\n", vpi->memdev);
>                  break;
> +            case MEMORY_DEVICE_INFO_KIND_VIRTIO_MEM:
> +                vmi = value->u.virtio_mem.data;
> +                monitor_printf(mon, "Memory device [%s]: \"%s\"\n",
> +                               MemoryDeviceInfoKind_str(value->type),
> +                               vmi->id ? vmi->id : "");
> +                monitor_printf(mon, "  memaddr: 0x%" PRIx64 "\n", vmi->memaddr);
> +                monitor_printf(mon, "  node: %" PRId64 "\n", vmi->node);
> +                monitor_printf(mon, "  requested-size: %" PRIu64 "\n",
> +                               vmi->requested_size);
> +                monitor_printf(mon, "  size: %" PRIu64 "\n", vmi->size);
> +                monitor_printf(mon, "  max-size: %" PRIu64 "\n", vmi->max_size);
> +                monitor_printf(mon, "  block-size: %" PRIu64 "\n",
> +                               vmi->block_size);
> +                monitor_printf(mon, "  memdev: %s\n", vmi->memdev);
> +                break;
>              default:
>                  g_assert_not_reached();
>              }
> -- 
> 2.26.2
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

