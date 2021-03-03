Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09EE132C684
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346218AbhCDA3H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:29:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49543 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240184AbhCCQZ0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Mar 2021 11:25:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614788615;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZZNr5bceBUM/gk+WOJoUFQhb4V6dpeoGZW+3Tl4Vl7k=;
        b=Eok5pkFkKfDHSqSx3w/fy10d8rAED46TxgpcFa1IJRSKda/NAqvfEKypbGkFuEwqnBWpsK
        lxo6tsdg4hnO+tsmUZFw4PGhntmDiBbb7wk1z0NaIs5807GUBsM/v+sttsHDtPk/LzrJCB
        d2zGWiXl11rckb+MJFIgnobZK+jey04=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-RAejwn62MKiYt1g9lDimRQ-1; Wed, 03 Mar 2021 11:18:21 -0500
X-MC-Unique: RAejwn62MKiYt1g9lDimRQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E09E7106BB23;
        Wed,  3 Mar 2021 16:18:19 +0000 (UTC)
Received: from MiWiFi-RA69-srv (unknown [10.40.208.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5ABD663B8C;
        Wed,  3 Mar 2021 16:18:09 +0000 (UTC)
Date:   Wed, 3 Mar 2021 17:18:08 +0100
From:   Igor Mammedov <imammedo@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     qemu-devel@nongnu.org, Thomas Huth <thuth@redhat.com>,
        kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        qemu-s390x@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH v1 2/2] exec: Get rid of phys_mem_set_alloc()
Message-ID: <20210303171808.4822e880@MiWiFi-RA69-srv>
In-Reply-To: <20210303130916.22553-3-david@redhat.com>
References: <20210303130916.22553-1-david@redhat.com>
        <20210303130916.22553-3-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  3 Mar 2021 14:09:16 +0100
David Hildenbrand <david@redhat.com> wrote:

> As the last user is gone, we can get rid of phys_mem_set_alloc() and
> simplify.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Richard Henderson <rth@twiddle.net>
> Cc: Halil Pasic <pasic@linux.ibm.com>
> Cc: Cornelia Huck <cohuck@redhat.com>
> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> Cc: Thomas Huth <thuth@redhat.com>
> Cc: Igor Mammedov <imammedo@redhat.com>
> Cc: Peter Xu <peterx@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Igor Mammedov <imammedo@redhat.com>

> ---
>  include/sysemu/kvm.h |  4 ----
>  softmmu/physmem.c    | 36 +++---------------------------------
>  2 files changed, 3 insertions(+), 37 deletions(-)
> 
> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
> index 687c598be9..a1ab1ee12d 100644
> --- a/include/sysemu/kvm.h
> +++ b/include/sysemu/kvm.h
> @@ -249,10 +249,6 @@ int kvm_update_guest_debug(CPUState *cpu, unsigned long reinject_trap);
>  int kvm_on_sigbus_vcpu(CPUState *cpu, int code, void *addr);
>  int kvm_on_sigbus(int code, void *addr);
>  
> -/* interface with exec.c */
> -
> -void phys_mem_set_alloc(void *(*alloc)(size_t, uint64_t *align, bool shared));
> -
>  /* internal API */
>  
>  int kvm_ioctl(KVMState *s, int type, ...);
> diff --git a/softmmu/physmem.c b/softmmu/physmem.c
> index 19e0aa9836..141fce79e8 100644
> --- a/softmmu/physmem.c
> +++ b/softmmu/physmem.c
> @@ -1144,19 +1144,6 @@ static int subpage_register(subpage_t *mmio, uint32_t start, uint32_t end,
>                              uint16_t section);
>  static subpage_t *subpage_init(FlatView *fv, hwaddr base);
>  
> -static void *(*phys_mem_alloc)(size_t size, uint64_t *align, bool shared) =
> -                               qemu_anon_ram_alloc;
> -
> -/*
> - * Set a custom physical guest memory alloator.
> - * Accelerators with unusual needs may need this.  Hopefully, we can
> - * get rid of it eventually.
> - */
> -void phys_mem_set_alloc(void *(*alloc)(size_t, uint64_t *align, bool shared))
> -{
> -    phys_mem_alloc = alloc;
> -}
> -
>  static uint16_t phys_section_add(PhysPageMap *map,
>                                   MemoryRegionSection *section)
>  {
> @@ -1962,8 +1949,9 @@ static void ram_block_add(RAMBlock *new_block, Error **errp, bool shared)
>                  return;
>              }
>          } else {
> -            new_block->host = phys_mem_alloc(new_block->max_length,
> -                                             &new_block->mr->align, shared);
> +            new_block->host = qemu_anon_ram_alloc(new_block->max_length,
> +                                                  &new_block->mr->align,
> +                                                  shared);
>              if (!new_block->host) {
>                  error_setg_errno(errp, errno,
>                                   "cannot set up guest memory '%s'",
> @@ -2047,17 +2035,6 @@ RAMBlock *qemu_ram_alloc_from_fd(ram_addr_t size, MemoryRegion *mr,
>          return NULL;
>      }
>  
> -    if (phys_mem_alloc != qemu_anon_ram_alloc) {
> -        /*
> -         * file_ram_alloc() needs to allocate just like
> -         * phys_mem_alloc, but we haven't bothered to provide
> -         * a hook there.
> -         */
> -        error_setg(errp,
> -                   "-mem-path not supported with this accelerator");
> -        return NULL;
> -    }
> -
>      size = HOST_PAGE_ALIGN(size);
>      file_size = get_file_size(fd);
>      if (file_size > 0 && file_size < size) {
> @@ -2247,13 +2224,6 @@ void qemu_ram_remap(ram_addr_t addr, ram_addr_t length)
>                      area = mmap(vaddr, length, PROT_READ | PROT_WRITE,
>                                  flags, block->fd, offset);
>                  } else {
> -                    /*
> -                     * Remap needs to match alloc.  Accelerators that
> -                     * set phys_mem_alloc never remap.  If they did,
> -                     * we'd need a remap hook here.
> -                     */
> -                    assert(phys_mem_alloc == qemu_anon_ram_alloc);
> -
>                      flags |= MAP_PRIVATE | MAP_ANONYMOUS;
>                      area = mmap(vaddr, length, PROT_READ | PROT_WRITE,
>                                  flags, -1, 0);

