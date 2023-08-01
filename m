Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28C6276BAD4
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 19:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234302AbjHARKo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 13:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232631AbjHARKm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 13:10:42 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0BD12D5B
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 10:10:18 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 320391FD96;
        Tue,  1 Aug 2023 17:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1690909805; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7yNtEU9Zy261xZ3vbDMsFc4F01pjUVwn8FOxPvflC1M=;
        b=Mf4d+sBvRKqIg568KLnPQ2TyBgZnMcfDI6RGk2vMe9CLL1FxlmrgPCDQ7Ny6uPxpbOEynF
        gZeZoPCY/aBUWM2TqThqy2yhDXc5LBv7r6KKp/1Qbum//gOKrDQoHRctiTPwl+CyhOkBf2
        zaTTEedxE2pMpeJ59F5IQzbWJS4Idq4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1690909805;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7yNtEU9Zy261xZ3vbDMsFc4F01pjUVwn8FOxPvflC1M=;
        b=JUNrVyj/c5+JwcV5TPYCc2zRvuTT/6H93+FhagCdmes0CXsfLscM+DoevRXfLe+LQGFH58
        YYSmQgsfrtnVIpCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 57149139BD;
        Tue,  1 Aug 2023 17:10:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Z7ZjE2w8yWSENwAAMHmgww
        (envelope-from <cfontana@suse.de>); Tue, 01 Aug 2023 17:10:04 +0000
Message-ID: <abf251ad-12d5-fb05-d3af-5a6ecbf56bb4@suse.de>
Date:   Tue, 1 Aug 2023 19:10:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [RFC PATCH 05/19] kvm: Enable KVM_SET_USER_MEMORY_REGION2 for
 memslot
Content-Language: en-US
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Michael Roth <michael.roth@amd.com>, isaku.yamahata@gmail.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20230731162201.271114-1-xiaoyao.li@intel.com>
 <20230731162201.271114-6-xiaoyao.li@intel.com>
From:   Claudio Fontana <cfontana@suse.de>
In-Reply-To: <20230731162201.271114-6-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/31/23 18:21, Xiaoyao Li wrote:
> From: Chao Peng <chao.p.peng@linux.intel.com>
> 
> Switch to KVM_SET_USER_MEMORY_REGION2 when supported by KVM.
> 
> With KVM_SET_USER_MEMORY_REGION2, QEMU can set up memory region that
> backen'ed both by hva-based shared memory and gmem fd based private
> memory.
> 
> Signed-off-by: Chao Peng <chao.p.peng@linux.intel.com>
> Codeveloped-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  accel/kvm/kvm-all.c      | 57 +++++++++++++++++++++++++++++++++-------
>  accel/kvm/trace-events   |  2 +-
>  include/sysemu/kvm_int.h |  2 ++
>  3 files changed, 51 insertions(+), 10 deletions(-)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index d8eee405de24..7b1818334ba7 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -288,35 +288,68 @@ int kvm_physical_memory_addr_from_host(KVMState *s, void *ram,
>  static int kvm_set_user_memory_region(KVMMemoryListener *kml, KVMSlot *slot, bool new)
>  {
>      KVMState *s = kvm_state;
> -    struct kvm_userspace_memory_region mem;
> +    struct kvm_userspace_memory_region2 mem;
> +    static int cap_user_memory2 = -1;
>      int ret;
>  
> +    if (cap_user_memory2 == -1) {
> +        cap_user_memory2 = kvm_check_extension(s, KVM_CAP_USER_MEMORY2);
> +    }
> +
> +    if (!cap_user_memory2 && slot->fd >= 0) {
> +        error_report("%s, KVM doesn't support gmem!", __func__);
> +        exit(1);
> +    }

We handle this special error case here,
while the existing callers of kvm_set_user_memory_region handle the other error cases in different places.

Not that the rest of kvm-all does an excellent job at error handling, but maybe we can avoid compounding on the issue.

> +
>      mem.slot = slot->slot | (kml->as_id << 16);
>      mem.guest_phys_addr = slot->start_addr;
>      mem.userspace_addr = (unsigned long)slot->ram;
>      mem.flags = slot->flags;
> +    mem.gmem_fd = slot->fd;
> +    mem.gmem_offset = slot->ofs;
>  
> -    if (slot->memory_size && !new && (mem.flags ^ slot->old_flags) & KVM_MEM_READONLY) {
> +    if (slot->memory_size && !new && (slot->flags ^ slot->old_flags) & KVM_MEM_READONLY) {

Why the change if mem.flags == slot->flags ?

>          /* Set the slot size to 0 before setting the slot to the desired
>           * value. This is needed based on KVM commit 75d61fbc. */
>          mem.memory_size = 0;
> -        ret = kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION, &mem);
> +
> +        if (cap_user_memory2) {
> +            ret = kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION2, &mem);
> +        } else {
> +            ret = kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION, &mem);
> +	    }
>          if (ret < 0) {
>              goto err;
>          }
>      }
>      mem.memory_size = slot->memory_size;
> -    ret = kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION, &mem);
> +    if (cap_user_memory2) {
> +        ret = kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION2, &mem);
> +    } else {
> +        ret = kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION, &mem);
> +    }
>      slot->old_flags = mem.flags;
>  err:
>      trace_kvm_set_user_memory(mem.slot >> 16, (uint16_t)mem.slot, mem.flags,
>                                mem.guest_phys_addr, mem.memory_size,
> -                              mem.userspace_addr, ret);
> +                              mem.userspace_addr, mem.gmem_fd,
> +			      mem.gmem_offset, ret);
>      if (ret < 0) {
> -        error_report("%s: KVM_SET_USER_MEMORY_REGION failed, slot=%d,"
> -                     " start=0x%" PRIx64 ", size=0x%" PRIx64 ": %s",
> -                     __func__, mem.slot, slot->start_addr,
> -                     (uint64_t)mem.memory_size, strerror(errno));
> +        if (cap_user_memory2) {
> +                error_report("%s: KVM_SET_USER_MEMORY_REGION2 failed, slot=%d,"
> +                        " start=0x%" PRIx64 ", size=0x%" PRIx64 ","
> +                        " flags=0x%" PRIx32 ","
> +                        " gmem_fd=%" PRId32 ", gmem_offset=0x%" PRIx64 ": %s",
> +                        __func__, mem.slot, slot->start_addr,
> +                (uint64_t)mem.memory_size, mem.flags,
> +                        mem.gmem_fd, (uint64_t)mem.gmem_offset,
> +                        strerror(errno));
> +        } else {
> +                error_report("%s: KVM_SET_USER_MEMORY_REGION failed, slot=%d,"
> +                            " start=0x%" PRIx64 ", size=0x%" PRIx64 ": %s",
> +                __func__, mem.slot, slot->start_addr,
> +                (uint64_t)mem.memory_size, strerror(errno));
> +        }
>      }
>      return ret;
>  }
> @@ -472,6 +505,9 @@ static int kvm_mem_flags(MemoryRegion *mr)
>      if (readonly && kvm_readonly_mem_allowed) {
>          flags |= KVM_MEM_READONLY;
>      }
> +    if (memory_region_can_be_private(mr)) {
> +        flags |= KVM_MEM_PRIVATE;
> +    }
>      return flags;
>  }
>  
> @@ -1402,6 +1438,9 @@ static void kvm_set_phys_mem(KVMMemoryListener *kml,
>          mem->ram_start_offset = ram_start_offset;
>          mem->ram = ram;
>          mem->flags = kvm_mem_flags(mr);
> +        mem->fd = mr->ram_block->gmem_fd;
> +        mem->ofs = (uint8_t*)ram - mr->ram_block->host;
> +
>          kvm_slot_init_dirty_bitmap(mem);
>          err = kvm_set_user_memory_region(kml, mem, true);
>          if (err) {
> diff --git a/accel/kvm/trace-events b/accel/kvm/trace-events
> index 14ebfa1b991c..80694683acea 100644
> --- a/accel/kvm/trace-events
> +++ b/accel/kvm/trace-events
> @@ -15,7 +15,7 @@ kvm_irqchip_update_msi_route(int virq) "Updating MSI route virq=%d"
>  kvm_irqchip_release_virq(int virq) "virq %d"
>  kvm_set_ioeventfd_mmio(int fd, uint64_t addr, uint32_t val, bool assign, uint32_t size, bool datamatch) "fd: %d @0x%" PRIx64 " val=0x%x assign: %d size: %d match: %d"
>  kvm_set_ioeventfd_pio(int fd, uint16_t addr, uint32_t val, bool assign, uint32_t size, bool datamatch) "fd: %d @0x%x val=0x%x assign: %d size: %d match: %d"
> -kvm_set_user_memory(uint16_t as, uint16_t slot, uint32_t flags, uint64_t guest_phys_addr, uint64_t memory_size, uint64_t userspace_addr, int ret) "AddrSpace#%d Slot#%d flags=0x%x gpa=0x%"PRIx64 " size=0x%"PRIx64 " ua=0x%"PRIx64 " ret=%d"
> +kvm_set_user_memory(uint16_t as, uint16_t slot, uint32_t flags, uint64_t guest_phys_addr, uint64_t memory_size, uint64_t userspace_addr, uint32_t fd, uint64_t fd_offset, int ret) "AddrSpace#%d Slot#%d flags=0x%x gpa=0x%"PRIx64 " size=0x%"PRIx64 " ua=0x%"PRIx64 " gmem_fd=%d" " gmem_fd_offset=0x%" PRIx64 " ret=%d"
>  kvm_clear_dirty_log(uint32_t slot, uint64_t start, uint32_t size) "slot#%"PRId32" start 0x%"PRIx64" size 0x%"PRIx32
>  kvm_resample_fd_notify(int gsi) "gsi %d"
>  kvm_dirty_ring_full(int id) "vcpu %d"
> diff --git a/include/sysemu/kvm_int.h b/include/sysemu/kvm_int.h
> index 511b42bde5c4..48220c0793ac 100644
> --- a/include/sysemu/kvm_int.h
> +++ b/include/sysemu/kvm_int.h
> @@ -30,6 +30,8 @@ typedef struct KVMSlot
>      int as_id;
>      /* Cache of the offset in ram address space */
>      ram_addr_t ram_start_offset;
> +    int fd;
> +    hwaddr ofs;
>  } KVMSlot;
>  
>  typedef struct KVMMemoryUpdate {

