Return-Path: <kvm+bounces-59400-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DCEE1BB33F5
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 10:43:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9DBEE7B5055
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 08:41:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 249632EE5FE;
	Thu,  2 Oct 2025 08:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E0GO3D5K"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BE7313E0E
	for <kvm@vger.kernel.org>; Thu,  2 Oct 2025 08:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759394356; cv=none; b=HNH2j2e6IgZKpcU3VxUiCEKlcKdN7Ova6zsOa9oQ4Q5XQHvgmvt7P1+2NvG6ezqZjnyNpRHppz/3ToXMZ/B3H66cB7wZVkTrcBP0n7H3nq4Lb1AvACknFsfaukceHOR4LStPbZ18eT5x3BgfA6WKGqZyWgo1A0kahZZuoye2Hcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759394356; c=relaxed/simple;
	bh=4eTtro6b7OjP60irCFwL2FrReG+5iSar6gb/10IaDsY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZmdOmGUpqr2yG7zXhwzNq0Wz+ptgYh6Jt/TAXn6E7ZopjZrjDmzH6pzx9TKKSKOMIBRvfANJxnWXZGOxqByAqkn+3KEynHx3TEQhmlZq974JYWOfgV60hnwy4kG+VQ6oxTI64zpT3Jwevs56NuOEOwdN6iV2XbGHBEReplxjC9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E0GO3D5K; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759394352;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=l/viV02I/SrNrd23XIMXrxiJgAbNSjhYSvqGXZ6mj3A=;
	b=E0GO3D5KcLmLwHf2XoONUr+cTQJx6aNaCfbP5vo0JVFB+Bzxx2V54BnYbp9sbiYokcfOve
	USHhmgIiQi2lFD6MPrf5OxnYL8hOB/zq1SOr1sCj0ER/1GZKkVpcpofikUbnQGwRPfuo7b
	Eo++8DzpZDulOMFyRXn1z4k31P88UMk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-232-8EIjjUeNOciVmKGHNBWrCw-1; Thu, 02 Oct 2025 04:39:10 -0400
X-MC-Unique: 8EIjjUeNOciVmKGHNBWrCw-1
X-Mimecast-MFC-AGG-ID: 8EIjjUeNOciVmKGHNBWrCw_1759394350
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3ece14b9231so320551f8f.0
        for <kvm@vger.kernel.org>; Thu, 02 Oct 2025 01:39:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759394350; x=1759999150;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l/viV02I/SrNrd23XIMXrxiJgAbNSjhYSvqGXZ6mj3A=;
        b=ddsRLrjkqd5P42RH5RRPkVgJnRRSoKyq49dVBxGsm6VP9jAYLc2ujicxKBRbK5fv7m
         lhdg1FhhhFO/E6ek16VjyN8VImZQT4lyuuiNk/M4KcFjz45Wh7blWBI5w+XegHrWn5Oj
         YhiIgcZ+j2e8+JZdz4Vwb7bByoNI3d4TBFF/kJ2QkrE6UWhNPcCg251VE++Qx9PyEB4j
         topHPH563LEIViWJwQB/7jWsTrSGSOJa5rsHxR9lak+IZn5+qGhMW5ycVVm8OOWfAeg/
         5qz3BebYguFtYrRMCwLbRDHFiDJdRU3PVQQd+L16CHD/IjmxDnkv7QQFkAc8fCXpd7u4
         uFRA==
X-Forwarded-Encrypted: i=1; AJvYcCWoXZ4WkuQkZhNmLz3jDBwBI49W2rBioulyg5WF9YD/5tvaic4Jch4IBHYIOTOrUn2JqHY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwlmxD+V1R+S1z8gyiLMYya2kczh+VQV8KQf0H9fJb55Z9ViGZC
	wvZ1la7DgXAbY8zrYOV5vdzW1qkIjXHYLYS0xRzKO3IaH+G6d2EIOkA4q+h4jbGW3neG3NoZbt5
	tGwP1lc7GZakVddAs8CWCMvCAWqV2iOB9L/HolymE8JZjot+qad/Dfg==
X-Gm-Gg: ASbGncts0PIuBK9ysZYqCXm6HVBoibk0Wmej/lz7uyoR/0gUDylaNEGm2n+lqRaKI1k
	netiQtUHIJ8FCVSCE4OdG3Pk7ZR4Rs4Z98W61ogHjUjQvv+FvAtyZtx5/8FuxJaz7zyDfuCEqf9
	cRoh4am2/aUd4Sbt6G+BbtwdPzv106ezkdJdPcprhx4epWt6pOpCLbM26CNj815ItO+iJxY5/6c
	NM4B7/+fUjwP2Riq3BsPjT0PicxE8K7q5X7ZEgH3X7dD5I5ax4wL5Uy84HgIRg+zJuOiKke6ULJ
	UA4VEESsxjbGBTIn8fckG8NKJ+CAClnQbXj4qU7TvEBYbtfE3Qd41R70l91GQHUxREvGzjW8VpU
	JW6xaor0v
X-Received: by 2002:a05:6000:1acb:b0:3e9:9282:cfdf with SMTP id ffacd0b85a97d-42557824f13mr4200132f8f.41.1759394349520;
        Thu, 02 Oct 2025 01:39:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF6vn86WptEkq5ZlU8sLA8Oey8vc8CHXGnMmcTXDLvHLbd40JO9yOuMsVvEZcNI0T9OZbwARA==
X-Received: by 2002:a05:6000:1acb:b0:3e9:9282:cfdf with SMTP id ffacd0b85a97d-42557824f13mr4200102f8f.41.1759394348984;
        Thu, 02 Oct 2025 01:39:08 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:280:24f0:576b:abc6:6396:ed4a? ([2a01:e0a:280:24f0:576b:abc6:6396:ed4a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e6917a577sm24701915e9.1.2025.10.02.01.39.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Oct 2025 01:39:08 -0700 (PDT)
Message-ID: <15650274-b16a-487b-9cad-0c34a8c0a8a3@redhat.com>
Date: Thu, 2 Oct 2025 10:39:07 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 17/18] system/physmem: Drop 'cpu_' prefix in Physical
 Memory API
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
 Jagannathan Raman <jag.raman@oracle.com>, qemu-ppc@nongnu.org,
 Ilya Leoshkevich <iii@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
 Jason Herne <jjherne@linux.ibm.com>, Peter Xu <peterx@redhat.com>,
 kvm@vger.kernel.org, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Halil Pasic <pasic@linux.ibm.com>, Matthew Rosato <mjrosato@linux.ibm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Elena Ufimtseva <elena.ufimtseva@oracle.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>, Fabiano Rosas <farosas@suse.de>,
 Eric Farman <farman@linux.ibm.com>, qemu-arm@nongnu.org,
 qemu-s390x@nongnu.org, David Hildenbrand <david@redhat.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 Nicholas Piggin <npiggin@gmail.com>
References: <20251001175448.18933-1-philmd@linaro.org>
 <20251001175448.18933-18-philmd@linaro.org>
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Content-Language: en-US, fr
Autocrypt: addr=clg@redhat.com; keydata=
 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
 uVKe8BVz4atMOoktmt0GWTOC8P4=
In-Reply-To: <20251001175448.18933-18-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/1/25 19:54, Philippe Mathieu-Daudé wrote:
> The functions related to the Physical Memory API declared
> in "system/ram_addr.h" do not operate on vCPU. Remove the
> 'cpu_' prefix.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> ---
>   include/system/ram_addr.h   | 24 +++++++++----------
>   accel/kvm/kvm-all.c         |  2 +-
>   accel/tcg/cputlb.c          | 12 +++++-----
>   hw/vfio/container-legacy.c  |  8 +++----
>   hw/vfio/container.c         |  4 ++--
>   migration/ram.c             |  4 ++--
>   system/memory.c             |  8 +++----
>   system/physmem.c            | 48 ++++++++++++++++++-------------------
>   target/arm/tcg/mte_helper.c |  2 +-
>   system/memory_ldst.c.inc    |  2 +-
>   tests/tsan/ignore.tsan      |  4 ++--
>   11 files changed, 59 insertions(+), 59 deletions(-)



For vfio,


Reviewed-by: Cédric Le Goater <clg@redhat.com>

Thanks,

C.


> 
> diff --git a/include/system/ram_addr.h b/include/system/ram_addr.h
> index d2d088bbea6..3894a84fb9c 100644
> --- a/include/system/ram_addr.h
> +++ b/include/system/ram_addr.h
> @@ -136,39 +136,39 @@ static inline void qemu_ram_block_writeback(RAMBlock *block)
>   #define DIRTY_CLIENTS_ALL     ((1 << DIRTY_MEMORY_NUM) - 1)
>   #define DIRTY_CLIENTS_NOCODE  (DIRTY_CLIENTS_ALL & ~(1 << DIRTY_MEMORY_CODE))
>   
> -bool cpu_physical_memory_get_dirty_flag(ram_addr_t addr, unsigned client);
> +bool physical_memory_get_dirty_flag(ram_addr_t addr, unsigned client);
>   
> -bool cpu_physical_memory_is_clean(ram_addr_t addr);
> +bool physical_memory_is_clean(ram_addr_t addr);
>   
> -uint8_t cpu_physical_memory_range_includes_clean(ram_addr_t start,
> +uint8_t physical_memory_range_includes_clean(ram_addr_t start,
>                                                    ram_addr_t length,
>                                                    uint8_t mask);
>   
> -void cpu_physical_memory_set_dirty_flag(ram_addr_t addr, unsigned client);
> +void physical_memory_set_dirty_flag(ram_addr_t addr, unsigned client);
>   
> -void cpu_physical_memory_set_dirty_range(ram_addr_t start, ram_addr_t length,
> +void physical_memory_set_dirty_range(ram_addr_t start, ram_addr_t length,
>                                            uint8_t mask);
>   
>   /*
> - * Contrary to cpu_physical_memory_sync_dirty_bitmap() this function returns
> + * Contrary to physical_memory_sync_dirty_bitmap() this function returns
>    * the number of dirty pages in @bitmap passed as argument. On the other hand,
> - * cpu_physical_memory_sync_dirty_bitmap() returns newly dirtied pages that
> + * physical_memory_sync_dirty_bitmap() returns newly dirtied pages that
>    * weren't set in the global migration bitmap.
>    */
> -uint64_t cpu_physical_memory_set_dirty_lebitmap(unsigned long *bitmap,
> +uint64_t physical_memory_set_dirty_lebitmap(unsigned long *bitmap,
>                                                   ram_addr_t start,
>                                                   ram_addr_t pages);
>   
> -void cpu_physical_memory_dirty_bits_cleared(ram_addr_t start, ram_addr_t length);
> +void physical_memory_dirty_bits_cleared(ram_addr_t start, ram_addr_t length);
>   
> -bool cpu_physical_memory_test_and_clear_dirty(ram_addr_t start,
> +bool physical_memory_test_and_clear_dirty(ram_addr_t start,
>                                                 ram_addr_t length,
>                                                 unsigned client);
>   
> -DirtyBitmapSnapshot *cpu_physical_memory_snapshot_and_clear_dirty
> +DirtyBitmapSnapshot *physical_memory_snapshot_and_clear_dirty
>       (MemoryRegion *mr, hwaddr offset, hwaddr length, unsigned client);
>   
> -bool cpu_physical_memory_snapshot_get_dirty(DirtyBitmapSnapshot *snap,
> +bool physical_memory_snapshot_get_dirty(DirtyBitmapSnapshot *snap,
>                                               ram_addr_t start,
>                                               ram_addr_t length);
>   
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 08b2b5a371c..a7ece7db964 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -758,7 +758,7 @@ static void kvm_slot_sync_dirty_pages(KVMSlot *slot)
>       ram_addr_t start = slot->ram_start_offset;
>       ram_addr_t pages = slot->memory_size / qemu_real_host_page_size();
>   
> -    cpu_physical_memory_set_dirty_lebitmap(slot->dirty_bmap, start, pages);
> +    physical_memory_set_dirty_lebitmap(slot->dirty_bmap, start, pages);
>   }
>   
>   static void kvm_slot_reset_dirty_pages(KVMSlot *slot)
> diff --git a/accel/tcg/cputlb.c b/accel/tcg/cputlb.c
> index 2a6aa01c57c..a721235dea6 100644
> --- a/accel/tcg/cputlb.c
> +++ b/accel/tcg/cputlb.c
> @@ -858,7 +858,7 @@ void tlb_flush_page_bits_by_mmuidx_all_cpus_synced(CPUState *src_cpu,
>      can be detected */
>   void tlb_protect_code(ram_addr_t ram_addr)
>   {
> -    cpu_physical_memory_test_and_clear_dirty(ram_addr & TARGET_PAGE_MASK,
> +    physical_memory_test_and_clear_dirty(ram_addr & TARGET_PAGE_MASK,
>                                                TARGET_PAGE_SIZE,
>                                                DIRTY_MEMORY_CODE);
>   }
> @@ -867,7 +867,7 @@ void tlb_protect_code(ram_addr_t ram_addr)
>      tested for self modifying code */
>   void tlb_unprotect_code(ram_addr_t ram_addr)
>   {
> -    cpu_physical_memory_set_dirty_flag(ram_addr, DIRTY_MEMORY_CODE);
> +    physical_memory_set_dirty_flag(ram_addr, DIRTY_MEMORY_CODE);
>   }
>   
>   
> @@ -1085,7 +1085,7 @@ void tlb_set_page_full(CPUState *cpu, int mmu_idx,
>           if (prot & PAGE_WRITE) {
>               if (section->readonly) {
>                   write_flags |= TLB_DISCARD_WRITE;
> -            } else if (cpu_physical_memory_is_clean(iotlb)) {
> +            } else if (physical_memory_is_clean(iotlb)) {
>                   write_flags |= TLB_NOTDIRTY;
>               }
>           }
> @@ -1341,7 +1341,7 @@ static void notdirty_write(CPUState *cpu, vaddr mem_vaddr, unsigned size,
>   
>       trace_memory_notdirty_write_access(mem_vaddr, ram_addr, size);
>   
> -    if (!cpu_physical_memory_get_dirty_flag(ram_addr, DIRTY_MEMORY_CODE)) {
> +    if (!physical_memory_get_dirty_flag(ram_addr, DIRTY_MEMORY_CODE)) {
>           tb_invalidate_phys_range_fast(cpu, ram_addr, size, retaddr);
>       }
>   
> @@ -1349,10 +1349,10 @@ static void notdirty_write(CPUState *cpu, vaddr mem_vaddr, unsigned size,
>        * Set both VGA and migration bits for simplicity and to remove
>        * the notdirty callback faster.
>        */
> -    cpu_physical_memory_set_dirty_range(ram_addr, size, DIRTY_CLIENTS_NOCODE);
> +    physical_memory_set_dirty_range(ram_addr, size, DIRTY_CLIENTS_NOCODE);
>   
>       /* We remove the notdirty callback only if the code has been flushed. */
> -    if (!cpu_physical_memory_is_clean(ram_addr)) {
> +    if (!physical_memory_is_clean(ram_addr)) {
>           trace_memory_notdirty_set_dirty(mem_vaddr);
>           tlb_set_dirty(cpu, mem_vaddr);
>       }
> diff --git a/hw/vfio/container-legacy.c b/hw/vfio/container-legacy.c
> index 3a710d8265c..eb9911eaeaf 100644
> --- a/hw/vfio/container-legacy.c
> +++ b/hw/vfio/container-legacy.c
> @@ -92,7 +92,7 @@ static int vfio_dma_unmap_bitmap(const VFIOLegacyContainer *container,
>       bitmap = (struct vfio_bitmap *)&unmap->data;
>   
>       /*
> -     * cpu_physical_memory_set_dirty_lebitmap() supports pages in bitmap of
> +     * physical_memory_set_dirty_lebitmap() supports pages in bitmap of
>        * qemu_real_host_page_size to mark those dirty. Hence set bitmap_pgsize
>        * to qemu_real_host_page_size.
>        */
> @@ -108,7 +108,7 @@ static int vfio_dma_unmap_bitmap(const VFIOLegacyContainer *container,
>   
>       ret = ioctl(container->fd, VFIO_IOMMU_UNMAP_DMA, unmap);
>       if (!ret) {
> -        cpu_physical_memory_set_dirty_lebitmap(vbmap.bitmap,
> +        physical_memory_set_dirty_lebitmap(vbmap.bitmap,
>                   iotlb->translated_addr, vbmap.pages);
>       } else {
>           error_report("VFIO_UNMAP_DMA with DIRTY_BITMAP : %m");
> @@ -284,7 +284,7 @@ static int vfio_legacy_query_dirty_bitmap(const VFIOContainer *bcontainer,
>       range->size = size;
>   
>       /*
> -     * cpu_physical_memory_set_dirty_lebitmap() supports pages in bitmap of
> +     * physical_memory_set_dirty_lebitmap() supports pages in bitmap of
>        * qemu_real_host_page_size to mark those dirty. Hence set bitmap's pgsize
>        * to qemu_real_host_page_size.
>        */
> @@ -503,7 +503,7 @@ static void vfio_get_iommu_info_migration(VFIOLegacyContainer *container,
>                               header);
>   
>       /*
> -     * cpu_physical_memory_set_dirty_lebitmap() supports pages in bitmap of
> +     * physical_memory_set_dirty_lebitmap() supports pages in bitmap of
>        * qemu_real_host_page_size to mark those dirty.
>        */
>       if (cap_mig->pgsize_bitmap & qemu_real_host_page_size()) {
> diff --git a/hw/vfio/container.c b/hw/vfio/container.c
> index 41de3439246..3fb19a1c8ad 100644
> --- a/hw/vfio/container.c
> +++ b/hw/vfio/container.c
> @@ -255,7 +255,7 @@ int vfio_container_query_dirty_bitmap(const VFIOContainer *bcontainer,
>       int ret;
>   
>       if (!bcontainer->dirty_pages_supported && !all_device_dirty_tracking) {
> -        cpu_physical_memory_set_dirty_range(translated_addr, size,
> +        physical_memory_set_dirty_range(translated_addr, size,
>                                               tcg_enabled() ? DIRTY_CLIENTS_ALL :
>                                               DIRTY_CLIENTS_NOCODE);
>           return 0;
> @@ -280,7 +280,7 @@ int vfio_container_query_dirty_bitmap(const VFIOContainer *bcontainer,
>           goto out;
>       }
>   
> -    dirty_pages = cpu_physical_memory_set_dirty_lebitmap(vbmap.bitmap,
> +    dirty_pages = physical_memory_set_dirty_lebitmap(vbmap.bitmap,
>                                                            translated_addr,
>                                                            vbmap.pages);
>   
> diff --git a/migration/ram.c b/migration/ram.c
> index 52bdfec91d9..d09591c0600 100644
> --- a/migration/ram.c
> +++ b/migration/ram.c
> @@ -976,7 +976,7 @@ static uint64_t physical_memory_sync_dirty_bitmap(RAMBlock *rb,
>               }
>           }
>           if (num_dirty) {
> -            cpu_physical_memory_dirty_bits_cleared(start, length);
> +            physical_memory_dirty_bits_cleared(start, length);
>           }
>   
>           if (rb->clear_bmap) {
> @@ -995,7 +995,7 @@ static uint64_t physical_memory_sync_dirty_bitmap(RAMBlock *rb,
>           ram_addr_t offset = rb->offset;
>   
>           for (addr = 0; addr < length; addr += TARGET_PAGE_SIZE) {
> -            if (cpu_physical_memory_test_and_clear_dirty(
> +            if (physical_memory_test_and_clear_dirty(
>                           start + addr + offset,
>                           TARGET_PAGE_SIZE,
>                           DIRTY_MEMORY_MIGRATION)) {
> diff --git a/system/memory.c b/system/memory.c
> index cf8cad69611..dd045da60c0 100644
> --- a/system/memory.c
> +++ b/system/memory.c
> @@ -2275,7 +2275,7 @@ void memory_region_set_dirty(MemoryRegion *mr, hwaddr addr,
>                                hwaddr size)
>   {
>       assert(mr->ram_block);
> -    cpu_physical_memory_set_dirty_range(memory_region_get_ram_addr(mr) + addr,
> +    physical_memory_set_dirty_range(memory_region_get_ram_addr(mr) + addr,
>                                           size,
>                                           memory_region_get_dirty_log_mask(mr));
>   }
> @@ -2379,7 +2379,7 @@ DirtyBitmapSnapshot *memory_region_snapshot_and_clear_dirty(MemoryRegion *mr,
>       DirtyBitmapSnapshot *snapshot;
>       assert(mr->ram_block);
>       memory_region_sync_dirty_bitmap(mr, false);
> -    snapshot = cpu_physical_memory_snapshot_and_clear_dirty(mr, addr, size, client);
> +    snapshot = physical_memory_snapshot_and_clear_dirty(mr, addr, size, client);
>       memory_global_after_dirty_log_sync();
>       return snapshot;
>   }
> @@ -2388,7 +2388,7 @@ bool memory_region_snapshot_get_dirty(MemoryRegion *mr, DirtyBitmapSnapshot *sna
>                                         hwaddr addr, hwaddr size)
>   {
>       assert(mr->ram_block);
> -    return cpu_physical_memory_snapshot_get_dirty(snap,
> +    return physical_memory_snapshot_get_dirty(snap,
>                   memory_region_get_ram_addr(mr) + addr, size);
>   }
>   
> @@ -2426,7 +2426,7 @@ void memory_region_reset_dirty(MemoryRegion *mr, hwaddr addr,
>                                  hwaddr size, unsigned client)
>   {
>       assert(mr->ram_block);
> -    cpu_physical_memory_test_and_clear_dirty(
> +    physical_memory_test_and_clear_dirty(
>           memory_region_get_ram_addr(mr) + addr, size, client);
>   }
>   
> diff --git a/system/physmem.c b/system/physmem.c
> index ad9705c7726..1a075da2bdd 100644
> --- a/system/physmem.c
> +++ b/system/physmem.c
> @@ -901,7 +901,7 @@ void tlb_reset_dirty_range_all(ram_addr_t start, ram_addr_t length)
>       }
>   }
>   
> -void cpu_physical_memory_dirty_bits_cleared(ram_addr_t start, ram_addr_t length)
> +void physical_memory_dirty_bits_cleared(ram_addr_t start, ram_addr_t length)
>   {
>       if (tcg_enabled()) {
>           tlb_reset_dirty_range_all(start, length);
> @@ -947,17 +947,17 @@ static bool physical_memory_get_dirty(ram_addr_t start, ram_addr_t length,
>       return dirty;
>   }
>   
> -bool cpu_physical_memory_get_dirty_flag(ram_addr_t addr, unsigned client)
> +bool physical_memory_get_dirty_flag(ram_addr_t addr, unsigned client)
>   {
>       return physical_memory_get_dirty(addr, 1, client);
>   }
>   
> -bool cpu_physical_memory_is_clean(ram_addr_t addr)
> +bool physical_memory_is_clean(ram_addr_t addr)
>   {
> -    bool vga = cpu_physical_memory_get_dirty_flag(addr, DIRTY_MEMORY_VGA);
> -    bool code = cpu_physical_memory_get_dirty_flag(addr, DIRTY_MEMORY_CODE);
> +    bool vga = physical_memory_get_dirty_flag(addr, DIRTY_MEMORY_VGA);
> +    bool code = physical_memory_get_dirty_flag(addr, DIRTY_MEMORY_CODE);
>       bool migration =
> -        cpu_physical_memory_get_dirty_flag(addr, DIRTY_MEMORY_MIGRATION);
> +        physical_memory_get_dirty_flag(addr, DIRTY_MEMORY_MIGRATION);
>       return !(vga && code && migration);
>   }
>   
> @@ -1000,7 +1000,7 @@ static bool physical_memory_all_dirty(ram_addr_t start, ram_addr_t length,
>       return dirty;
>   }
>   
> -uint8_t cpu_physical_memory_range_includes_clean(ram_addr_t start,
> +uint8_t physical_memory_range_includes_clean(ram_addr_t start,
>                                                    ram_addr_t length,
>                                                    uint8_t mask)
>   {
> @@ -1021,7 +1021,7 @@ uint8_t cpu_physical_memory_range_includes_clean(ram_addr_t start,
>       return ret;
>   }
>   
> -void cpu_physical_memory_set_dirty_flag(ram_addr_t addr, unsigned client)
> +void physical_memory_set_dirty_flag(ram_addr_t addr, unsigned client)
>   {
>       unsigned long page, idx, offset;
>       DirtyMemoryBlocks *blocks;
> @@ -1039,7 +1039,7 @@ void cpu_physical_memory_set_dirty_flag(ram_addr_t addr, unsigned client)
>       set_bit_atomic(offset, blocks->blocks[idx]);
>   }
>   
> -void cpu_physical_memory_set_dirty_range(ram_addr_t start, ram_addr_t length,
> +void physical_memory_set_dirty_range(ram_addr_t start, ram_addr_t length,
>                                            uint8_t mask)
>   {
>       DirtyMemoryBlocks *blocks[DIRTY_MEMORY_NUM];
> @@ -1091,7 +1091,7 @@ void cpu_physical_memory_set_dirty_range(ram_addr_t start, ram_addr_t length,
>   }
>   
>   /* Note: start and end must be within the same ram block.  */
> -bool cpu_physical_memory_test_and_clear_dirty(ram_addr_t start,
> +bool physical_memory_test_and_clear_dirty(ram_addr_t start,
>                                                 ram_addr_t length,
>                                                 unsigned client)
>   {
> @@ -1133,7 +1133,7 @@ bool cpu_physical_memory_test_and_clear_dirty(ram_addr_t start,
>       }
>   
>       if (dirty) {
> -        cpu_physical_memory_dirty_bits_cleared(start, length);
> +        physical_memory_dirty_bits_cleared(start, length);
>       }
>   
>       return dirty;
> @@ -1141,12 +1141,12 @@ bool cpu_physical_memory_test_and_clear_dirty(ram_addr_t start,
>   
>   static void physical_memory_clear_dirty_range(ram_addr_t addr, ram_addr_t length)
>   {
> -    cpu_physical_memory_test_and_clear_dirty(addr, length, DIRTY_MEMORY_MIGRATION);
> -    cpu_physical_memory_test_and_clear_dirty(addr, length, DIRTY_MEMORY_VGA);
> -    cpu_physical_memory_test_and_clear_dirty(addr, length, DIRTY_MEMORY_CODE);
> +    physical_memory_test_and_clear_dirty(addr, length, DIRTY_MEMORY_MIGRATION);
> +    physical_memory_test_and_clear_dirty(addr, length, DIRTY_MEMORY_VGA);
> +    physical_memory_test_and_clear_dirty(addr, length, DIRTY_MEMORY_CODE);
>   }
>   
> -DirtyBitmapSnapshot *cpu_physical_memory_snapshot_and_clear_dirty
> +DirtyBitmapSnapshot *physical_memory_snapshot_and_clear_dirty
>       (MemoryRegion *mr, hwaddr offset, hwaddr length, unsigned client)
>   {
>       DirtyMemoryBlocks *blocks;
> @@ -1193,14 +1193,14 @@ DirtyBitmapSnapshot *cpu_physical_memory_snapshot_and_clear_dirty
>           }
>       }
>   
> -    cpu_physical_memory_dirty_bits_cleared(start, length);
> +    physical_memory_dirty_bits_cleared(start, length);
>   
>       memory_region_clear_dirty_bitmap(mr, offset, length);
>   
>       return snap;
>   }
>   
> -bool cpu_physical_memory_snapshot_get_dirty(DirtyBitmapSnapshot *snap,
> +bool physical_memory_snapshot_get_dirty(DirtyBitmapSnapshot *snap,
>                                               ram_addr_t start,
>                                               ram_addr_t length)
>   {
> @@ -1221,7 +1221,7 @@ bool cpu_physical_memory_snapshot_get_dirty(DirtyBitmapSnapshot *snap,
>       return false;
>   }
>   
> -uint64_t cpu_physical_memory_set_dirty_lebitmap(unsigned long *bitmap,
> +uint64_t physical_memory_set_dirty_lebitmap(unsigned long *bitmap,
>                                                   ram_addr_t start,
>                                                   ram_addr_t pages)
>   {
> @@ -1314,7 +1314,7 @@ uint64_t cpu_physical_memory_set_dirty_lebitmap(unsigned long *bitmap,
>                       page_number = (i * HOST_LONG_BITS + j) * hpratio;
>                       addr = page_number * TARGET_PAGE_SIZE;
>                       ram_addr = start + addr;
> -                    cpu_physical_memory_set_dirty_range(ram_addr,
> +                    physical_memory_set_dirty_range(ram_addr,
>                                          TARGET_PAGE_SIZE * hpratio, clients);
>                   } while (c != 0);
>               }
> @@ -2082,7 +2082,7 @@ int qemu_ram_resize(RAMBlock *block, ram_addr_t newsize, Error **errp)
>   
>       physical_memory_clear_dirty_range(block->offset, block->used_length);
>       block->used_length = newsize;
> -    cpu_physical_memory_set_dirty_range(block->offset, block->used_length,
> +    physical_memory_set_dirty_range(block->offset, block->used_length,
>                                           DIRTY_CLIENTS_ALL);
>       memory_region_set_size(block->mr, unaligned_size);
>       if (block->resized) {
> @@ -2287,7 +2287,7 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
>       ram_list.version++;
>       qemu_mutex_unlock_ramlist();
>   
> -    cpu_physical_memory_set_dirty_range(new_block->offset,
> +    physical_memory_set_dirty_range(new_block->offset,
>                                           new_block->used_length,
>                                           DIRTY_CLIENTS_ALL);
>   
> @@ -3136,19 +3136,19 @@ static void invalidate_and_set_dirty(MemoryRegion *mr, hwaddr addr,
>       addr += ramaddr;
>   
>       /* No early return if dirty_log_mask is or becomes 0, because
> -     * cpu_physical_memory_set_dirty_range will still call
> +     * physical_memory_set_dirty_range will still call
>        * xen_modified_memory.
>        */
>       if (dirty_log_mask) {
>           dirty_log_mask =
> -            cpu_physical_memory_range_includes_clean(addr, length, dirty_log_mask);
> +            physical_memory_range_includes_clean(addr, length, dirty_log_mask);
>       }
>       if (dirty_log_mask & (1 << DIRTY_MEMORY_CODE)) {
>           assert(tcg_enabled());
>           tb_invalidate_phys_range(NULL, addr, addr + length - 1);
>           dirty_log_mask &= ~(1 << DIRTY_MEMORY_CODE);
>       }
> -    cpu_physical_memory_set_dirty_range(addr, length, dirty_log_mask);
> +    physical_memory_set_dirty_range(addr, length, dirty_log_mask);
>   }
>   
>   void memory_region_flush_rom_device(MemoryRegion *mr, hwaddr addr, hwaddr size)
> diff --git a/target/arm/tcg/mte_helper.c b/target/arm/tcg/mte_helper.c
> index 7d80244788e..077ff4b2b2c 100644
> --- a/target/arm/tcg/mte_helper.c
> +++ b/target/arm/tcg/mte_helper.c
> @@ -189,7 +189,7 @@ uint8_t *allocation_tag_mem_probe(CPUARMState *env, int ptr_mmu_idx,
>        */
>       if (tag_access == MMU_DATA_STORE) {
>           ram_addr_t tag_ra = memory_region_get_ram_addr(mr) + xlat;
> -        cpu_physical_memory_set_dirty_flag(tag_ra, DIRTY_MEMORY_MIGRATION);
> +        physical_memory_set_dirty_flag(tag_ra, DIRTY_MEMORY_MIGRATION);
>       }
>   
>       return memory_region_get_ram_ptr(mr) + xlat;
> diff --git a/system/memory_ldst.c.inc b/system/memory_ldst.c.inc
> index 7f32d3d9ff3..333da209d1a 100644
> --- a/system/memory_ldst.c.inc
> +++ b/system/memory_ldst.c.inc
> @@ -287,7 +287,7 @@ void glue(address_space_stl_notdirty, SUFFIX)(ARG1_DECL,
>   
>           dirty_log_mask = memory_region_get_dirty_log_mask(mr);
>           dirty_log_mask &= ~(1 << DIRTY_MEMORY_CODE);
> -        cpu_physical_memory_set_dirty_range(memory_region_get_ram_addr(mr) + addr,
> +        physical_memory_set_dirty_range(memory_region_get_ram_addr(mr) + addr,
>                                               4, dirty_log_mask);
>           r = MEMTX_OK;
>       }
> diff --git a/tests/tsan/ignore.tsan b/tests/tsan/ignore.tsan
> index 423e482d2f9..8fa00a2c49b 100644
> --- a/tests/tsan/ignore.tsan
> +++ b/tests/tsan/ignore.tsan
> @@ -4,7 +4,7 @@
>   # The eventual goal would be to fix these warnings.
>   
>   # TSan is not happy about setting/getting of dirty bits,
> -# for example, cpu_physical_memory_set_dirty_range,
> -# and cpu_physical_memory_get_dirty.
> +# for example, physical_memory_set_dirty_range,
> +# and physical_memory_get_dirty.
>   src:bitops.c
>   src:bitmap.c


