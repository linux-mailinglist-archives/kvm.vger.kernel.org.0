Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD4B53F8642
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 13:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234392AbhHZLTf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 07:19:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35071 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234381AbhHZLTe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Aug 2021 07:19:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629976727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KtqkKinc5BBHuRvRZLIoBDIL9gVbSQYSxvVb+auc13A=;
        b=HTyOhnoCpE7J0JhujKfycM1XCEtDGPRTRY/YVmg5aWbW5BUApD5KamN4m/Z6PVr7spVmhr
        GNy8fXfMZTpW/zqek6yrGwSdHNYLumIug9C+2w9LheShv89CL3aZCboYx1Cpyfm6jTigja
        CXjbVSgs/6CAb5F0fkWWoj6E3gfHv78=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-450-oa3sg7oWOS6WUC9FVo2-rw-1; Thu, 26 Aug 2021 07:18:46 -0400
X-MC-Unique: oa3sg7oWOS6WUC9FVo2-rw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A5C11026200;
        Thu, 26 Aug 2021 11:18:44 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.91])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B888A6B541;
        Thu, 26 Aug 2021 11:18:40 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 5CC0418003AA; Thu, 26 Aug 2021 13:18:38 +0200 (CEST)
Date:   Thu, 26 Aug 2021 13:18:38 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     isaku.yamahata@gmail.com
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com, kvm@vger.kernel.org,
        isaku.yamahata@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Min M . Xu" <min.m.xu@intel.com>
Subject: Re: [RFC PATCH v2 20/44] i386/tdx: Parse tdx metadata and store the
 result into TdxGuestState
Message-ID: <20210826111838.fgbp6v6gd5wzbnho@sirius.home.kraxel.org>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
 <acaf651389c3f407a9d6d0a2e943daf0a85bb5fc.1625704981.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acaf651389c3f407a9d6d0a2e943daf0a85bb5fc.1625704981.git.isaku.yamahata@intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  Hi,

> +        /*
> +         * If TDVF temp memory describe in TDVF metadata lays in RAM, reserve
> +         * the region property.
> +         */
> +        if (entry->address >= 4 * GiB + x86ms->above_4g_mem_size ||
> +            entry->address + entry->size >= 4 * GiB + x86ms->above_4g_mem_size) {
> +            error_report("TDVF type %u address 0x%" PRIx64 " size 0x%" PRIx64
> +                         " above high memory",
> +                         entry->type, entry->address, entry->size);
> +            exit(1);
> +        }

I think you can simply use dma_memory_map() API, then just work with
guest physical addresses and drop the messy and error-prone memory
region offset calculations.

> +    entry->mem_ptr = memory_region_get_ram_ptr(entry->mr);
> +    if (entry->data_len) {
> +        /*
> +         * The memory_region api doesn't allow partial file mapping, create
> +         * ram and copy the contents
> +         */
> +        if (lseek(fd, entry->data_offset, SEEK_SET) != entry->data_offset) {
> +            error_report("can't seek to 0x%x %s", entry->data_offset, filename);
> +            exit(1);
> +        }
> +        if (read(fd, entry->mem_ptr, entry->data_len) != entry->data_len) {
> +            error_report("can't read 0x%x %s", entry->data_len, filename);
> +            exit(1);
> +        }
> +    }

Wouldn't a simple rom_add_blob work here?

> +int load_tdvf(const char *filename)
> +{

> +    for_each_fw_entry(fw, entry) {
> +        if (entry->address < x86ms->below_4g_mem_size ||
> +            entry->address > 4 * GiB) {
> +            tdvf_init_ram_memory(ms, entry);
> +        } else {
> +            tdvf_init_bios_memory(fd, filename, entry);
> +        }
> +    }

Why there are two different ways to load the firmware?

Also: why is all this firmware volume parsing needed?  The normal ovmf
firmware can simply be mapped just below 4G, why can't tdvf work the
same way?

thanks,
  Gerd

