Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12D362CA195
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 12:42:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbgLALil (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Dec 2020 06:38:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:48317 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726765AbgLALik (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Dec 2020 06:38:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606822633;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mEg2mvzmDJQWmGL7PYMzg8O29/2xQkUxKTa922eJt3k=;
        b=hsWlzNo1xft9BvIzlLVXhufY16PubIlDWx23oDlcsoSeR47CRZ3Y7e6ACUDmq7Val6rSTO
        2MBW/7p4kJxcZojND2PXar1p1HzTAfZuzySQlMg7aHlYYtEPz92hUuOnP7lNS81Wo+7AVI
        XcCD+NezxduwSVxp0Og+KlqTFG0GO5o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-IFLTQ76fNu2YwhjvsgGOKQ-1; Tue, 01 Dec 2020 06:37:12 -0500
X-MC-Unique: IFLTQ76fNu2YwhjvsgGOKQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 111C780364B;
        Tue,  1 Dec 2020 11:37:11 +0000 (UTC)
Received: from work-vm (ovpn-115-1.ams2.redhat.com [10.36.115.1])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 06679189CE;
        Tue,  1 Dec 2020 11:37:04 +0000 (UTC)
Date:   Tue, 1 Dec 2020 11:37:02 +0000
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     pbonzini@redhat.com, qemu-devel@nongnu.org, rth@twiddle.net,
        armbru@redhat.com, ehabkost@redhat.com, kvm@vger.kernel.org,
        mst@redhat.com, marcel.apfelbaum@gmail.com, mtosatti@redhat.com,
        Thomas.Lendacky@amd.com, brijesh.singh@amd.com,
        ssg.sos.patches@amd.com
Subject: Re: [PATCH 02/11] exec: Add new MemoryDebugOps.
Message-ID: <20201201113702.GE4338@work-vm>
References: <cover.1605316268.git.ashish.kalra@amd.com>
 <4393d426ae8f070c6be45ff0252bae2dca8bbd42.1605316268.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4393d426ae8f070c6be45ff0252bae2dca8bbd42.1605316268.git.ashish.kalra@amd.com>
User-Agent: Mutt/1.14.6 (2020-07-11)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Ashish Kalra (Ashish.Kalra@amd.com) wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Introduce new MemoryDebugOps which hook into guest virtual and physical
> memory debug interfaces such as cpu_memory_rw_debug, to allow vendor specific
> assist/hooks for debugging and delegating accessing the guest memory.
> This is required for example in case of AMD SEV platform where the guest
> memory is encrypted and a SEV specific debug assist/hook will be required
> to access the guest memory.
> 
> The MemoryDebugOps are used by cpu_memory_rw_debug() and default to
> address_space_read and address_space_write_rom.
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> ---
>  include/exec/memory.h | 11 +++++++++++
>  softmmu/physmem.c     | 24 ++++++++++++++++++++----
>  2 files changed, 31 insertions(+), 4 deletions(-)
> 
> diff --git a/include/exec/memory.h b/include/exec/memory.h
> index aff6ef7605..73deb4b456 100644
> --- a/include/exec/memory.h
> +++ b/include/exec/memory.h
> @@ -2394,6 +2394,17 @@ MemTxResult address_space_write_cached_slow(MemoryRegionCache *cache,
>                                              hwaddr addr, const void *buf,
>                                              hwaddr len);
>  
> +typedef struct MemoryDebugOps {
> +    MemTxResult (*read)(AddressSpace *as, hwaddr phys_addr,
> +                        MemTxAttrs attrs, void *buf,
> +                        hwaddr len);
> +    MemTxResult (*write)(AddressSpace *as, hwaddr phys_addr,
> +                         MemTxAttrs attrs, const void *buf,
> +                         hwaddr len);
> +} MemoryDebugOps;
> +
> +void address_space_set_debug_ops(const MemoryDebugOps *ops);
> +
>  static inline bool memory_access_is_direct(MemoryRegion *mr, bool is_write)
>  {
>      if (is_write) {
> diff --git a/softmmu/physmem.c b/softmmu/physmem.c
> index a9adedb9f8..057d6d4ce1 100644
> --- a/softmmu/physmem.c
> +++ b/softmmu/physmem.c
> @@ -166,6 +166,18 @@ struct DirtyBitmapSnapshot {
>      unsigned long dirty[];
>  };
>  
> +static const MemoryDebugOps default_debug_ops = {
> +    .read = address_space_read,
> +    .write = address_space_write_rom
> +};
> +
> +static const MemoryDebugOps *debug_ops = &default_debug_ops;
> +
> +void address_space_set_debug_ops(const MemoryDebugOps *ops)
> +{
> +    debug_ops = ops;
> +}
> +
>  static void phys_map_node_reserve(PhysPageMap *map, unsigned nodes)
>  {
>      static unsigned alloc_hint = 16;
> @@ -3407,6 +3419,10 @@ int cpu_memory_rw_debug(CPUState *cpu, target_ulong addr,
>          page = addr & TARGET_PAGE_MASK;
>          phys_addr = cpu_get_phys_page_attrs_debug(cpu, page, &attrs);
>          asidx = cpu_asidx_from_attrs(cpu, attrs);
> +
> +        /* set debug attrs to indicate memory access is from the debugger */
> +        attrs.debug = 1;
> +
>          /* if no physical page mapped, return an error */
>          if (phys_addr == -1)
>              return -1;
> @@ -3415,11 +3431,11 @@ int cpu_memory_rw_debug(CPUState *cpu, target_ulong addr,
>              l = len;
>          phys_addr += (addr & ~TARGET_PAGE_MASK);
>          if (is_write) {
> -            res = address_space_write_rom(cpu->cpu_ases[asidx].as, phys_addr,
> -                                          attrs, buf, l);
> +            res = debug_ops->write(cpu->cpu_ases[asidx].as, phys_addr,
> +                                   attrs, buf, l);
>          } else {
> -            res = address_space_read(cpu->cpu_ases[asidx].as, phys_addr,
> -                                     attrs, buf, l);
> +            res = debug_ops->read(cpu->cpu_ases[asidx].as, phys_addr,
> +                                  attrs, buf, l);
>          }
>          if (res != MEMTX_OK) {
>              return -1;
> -- 
> 2.17.1
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

