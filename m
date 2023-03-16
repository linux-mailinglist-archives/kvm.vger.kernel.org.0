Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1236BCF94
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 13:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbjCPMga (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 08:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbjCPMg2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 08:36:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A0D9A17EA
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 05:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678970139;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Axi3VeZSqh5zTSMWs1D0aJQSfcusrG43A8R7AMzfyZo=;
        b=MMr9bswiS0l8BRQPTsNP2k0B9cMa5XpSH0OX4qEiJJSKyVdsiTWzd4Pswcwya8O3rfi1uz
        jLQMrJP6YegCnY5dwi3CyHzhMu8J1LsxQTOLbQt6S2a4dXXq73RuhI8eX0Dfi4iH11+4/M
        CzCNO9PJlxdygI2V2rceg+DlPpg2fm8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-638-thyTUwBlNs6lwXYm9ONLLQ-1; Thu, 16 Mar 2023 08:35:38 -0400
X-MC-Unique: thyTUwBlNs6lwXYm9ONLLQ-1
Received: by mail-wr1-f72.google.com with SMTP id h18-20020adfa4d2000000b002cea098a651so247727wrb.3
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 05:35:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678970137;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Axi3VeZSqh5zTSMWs1D0aJQSfcusrG43A8R7AMzfyZo=;
        b=EAnWZyW3ZEPl92jSpFf86ciDQ+uNHqlR9UsdfCIPZ+DiC463FDBVFSjbnGm6QKQJih
         PYlpvEv1iUJ+M+QjDW33YbOjJY2a/GbqOaqLRASvpYpJKWspyhKPptjDI+mD35THN0fa
         0aRDYWDAEPpjnoH2UIVijicTW1cy7AlZP41jVqRvgaV+vC1hGmmWqMIgxQ7n6pyFKpp7
         +zq67yjheXDUp732ZW+WSffOw7tdgs1WayW9N8mSiYHeoA1RYwZDUTbwLZkSGz0zgB5G
         St2DzQykbantrgs2Z8Lxn8DmeSLKkT4R5mGjlFxhiO9wYZJUaPiZNgJ5wTiJBJ12foJv
         ATJg==
X-Gm-Message-State: AO0yUKXHXi8ncTCeZihRmPQxIusxJYoO9HPl9Smcwa9aT9XaUoT6dM8f
        wXpiouyWy/luw9rQ4qnDIvBTkna3M1AEB60TGOJ4R/g7U4IanA2VjMGJJiPYJkCj4EvtFS9OmYa
        KocWsqiCd2vrN
X-Received: by 2002:a1c:4c19:0:b0:3ed:64eb:5379 with SMTP id z25-20020a1c4c19000000b003ed64eb5379mr984136wmf.39.1678970137200;
        Thu, 16 Mar 2023 05:35:37 -0700 (PDT)
X-Google-Smtp-Source: AK7set9MjXFCuOZxZVa0Uj03RwiMu9ET665RDsPpD8wECxHGvHiraM4DtuooY0eCfTgM+1G3rOd8ew==
X-Received: by 2002:a1c:4c19:0:b0:3ed:64eb:5379 with SMTP id z25-20020a1c4c19000000b003ed64eb5379mr984113wmf.39.1678970136784;
        Thu, 16 Mar 2023 05:35:36 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id k3-20020a7bc403000000b003ed1f69c967sm4946903wmi.9.2023.03.16.05.35.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 05:35:36 -0700 (PDT)
Message-ID: <12597014-f920-df75-d516-db871aedbc8c@redhat.com>
Date:   Thu, 16 Mar 2023 13:35:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, dave.hansen@intel.com, peterz@infradead.org,
        tglx@linutronix.de, seanjc@google.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        kirill.shutemov@linux.intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, ak@linux.intel.com, isaku.yamahata@intel.com,
        chao.gao@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
References: <cover.1678111292.git.kai.huang@intel.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v10 00/16] TDX host kernel support
In-Reply-To: <cover.1678111292.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06.03.23 15:13, Kai Huang wrote:
> Intel Trusted Domain Extensions (TDX) protects guest VMs from malicious
> host and certain physical attacks.  TDX specs are available in [1].

I'm afraid there is no [1], probably got lost while resending :)

> 
> This series is the initial support to enable TDX with minimal code to
> allow KVM to create and run TDX guests.  KVM support for TDX is being
> developed separately[2].  A new "userspace inaccessible memfd" approach
> to support TDX private memory is also being developed[3].  The KVM will
> only support the new "userspace inaccessible memfd" as TDX guest memory.

Same with [2].

> 
> This series doesn't aim to support all functionalities, and doesn't aim
> to resolve all things perfectly.  For example, memory hotplug is handled
> in simple way (please refer to "Kernel policy on TDX memory" and "Memory
> hotplug" sections below).
> 
> (For memory hotplug, sorry for broadcasting widely but I cc'ed the
> linux-mm@kvack.org following Kirill's suggestion so MM experts can also
> help to provide comments.)
> 
> And TDX module metadata allocation just uses alloc_contig_pages() to
> allocate large chunk at runtime, thus it can fail.  It is imperfect now
> but _will_ be improved in the future.

Good enough for now I guess. Reserving it via memblock might be better, 
though.

> 
> Also, the patch to add the new kernel comline tdx="force" isn't included
> in this initial version, as Dave suggested it isn't mandatory.  But I
> _will_ add one once this initial version gets merged.

What would be the main purpose of that option?

> 
> All other optimizations will be posted as follow-up once this initial
> TDX support is upstreamed.
> 


[...]

> == Background ==
> 
> TDX introduces a new CPU mode called Secure Arbitration Mode (SEAM)
> and a new isolated range pointed by the SEAM Ranger Register (SEAMRR).
> A CPU-attested software module called 'the TDX module' runs in the new
> isolated region as a trusted hypervisor to create/run protected VMs.
> 
> TDX also leverages Intel Multi-Key Total Memory Encryption (MKTME) to
> provide crypto-protection to the VMs.  TDX reserves part of MKTME KeyIDs
> as TDX private KeyIDs, which are only accessible within the SEAM mode.
> 
> TDX is different from AMD SEV/SEV-ES/SEV-SNP, which uses a dedicated
> secure processor to provide crypto-protection.  The firmware runs on the
> secure processor acts a similar role as the TDX module.
> 
> The host kernel communicates with SEAM software via a new SEAMCALL
> instruction.  This is conceptually similar to a guest->host hypercall,
> except it is made from the host to SEAM software instead.
> 
> Before being able to manage TD guests, the TDX module must be loaded
> and properly initialized.  This series assumes the TDX module is loaded
> by BIOS before the kernel boots.
> 
> How to initialize the TDX module is described at TDX module 1.0
> specification, chapter "13.Intel TDX Module Lifecycle: Enumeration,
> Initialization and Shutdown".
> 
> == Design Considerations ==
> 
> 1. Initialize the TDX module at runtime
> 
> There are basically two ways the TDX module could be initialized: either
> in early boot, or at runtime before the first TDX guest is run.  This
> series implements the runtime initialization.
> 
> This series adds a function tdx_enable() to allow the caller to initialize
> TDX at runtime:
> 
>          if (tdx_enable())
>                  goto no_tdx;
> 	// TDX is ready to create TD guests.
> 
> This approach has below pros:
> 
> 1) Initializing the TDX module requires to reserve ~1/256th system RAM as
> metadata.  Enabling TDX on demand allows only to consume this memory when
> TDX is truly needed (i.e. when KVM wants to create TD guests).

Let's be clear: nobody is going to run encrypted VMs "out of the blue".

You can expect a certain hypervisor setup to be required, for example, 
enabling it on the cmdline and then allocating that metadata from 
memblock during boot.

IIRC s390x handles it similarly with protected VMs and required metadata.

> 
> 2) SEAMCALL requires CPU being already in VMX operation (VMXON has been
> done).  So far, KVM is the only user of TDX, and it already handles VMXON.
> Letting KVM to initialize TDX avoids handling VMXON in the core kernel.
> 
> 3) It is more flexible to support "TDX module runtime update" (not in
> this series).  After updating to the new module at runtime, kernel needs
> to go through the initialization process again.
> 
> 2. CPU hotplug
> 
> TDX module requires the per-cpu initialization SEAMCALL (TDH.SYS.LP.INIT)
> must be done on one cpu before any other SEAMCALLs can be made on that
> cpu, including those involved during the module initialization.
> 
> The kernel provides tdx_cpu_enable() to let the user of TDX to do it when
> the user wants to use a new cpu for TDX task.
> 
> TDX doesn't support physical (ACPI) CPU hotplug.  A non-buggy BIOS should
> never support hotpluggable CPU devicee and/or deliver ACPI CPU hotplug
> event to the kernel.  This series doesn't handle physical (ACPI) CPU
> hotplug at all but depends on the BIOS to behave correctly.
> 
> Note TDX works with CPU logical online/offline, thus this series still
> allows to do logical CPU online/offline.
> 
> 3. Kernel policy on TDX memory
> 
> The TDX module reports a list of "Convertible Memory Region" (CMR) to
> indicate which memory regions are TDX-capable.  The TDX architecture
> allows the VMM to designate specific convertible memory regions as usable
> for TDX private memory.
> 
> The initial support of TDX guests will only allocate TDX private memory
> from the global page allocator.  This series chooses to designate _all_
> system RAM in the core-mm at the time of initializing TDX module as TDX
> memory to guarantee all pages in the page allocator are TDX pages.
> 
> 4. Memory Hotplug
> 
> After the kernel passes all "TDX-usable" memory regions to the TDX
> module, the set of "TDX-usable" memory regions are fixed during module's
> runtime.  No more "TDX-usable" memory can be added to the TDX module
> after that.
> 
> To achieve above "to guarantee all pages in the page allocator are TDX
> pages", this series simply choose to reject any non-TDX-usable memory in
> memory hotplug.
> 
> This _will_ be enhanced in the future after first submission.

What's the primary reason to enhance that? Are there reasonable use 
cases? Why would be expect to have other (!TDX capable) memory in the 
system?

> 
> A better solution, suggested by Kirill, is similar to the per-node memory
> encryption flag in this series [4].  We can allow adding/onlining non-TDX
> memory to separate NUMA nodes so that both "TDX-capable" nodes and
> "TDX-capable" nodes can co-exist.  The new TDX flag can be exposed to
> userspace via /sysfs so userspace can bind TDX guests to "TDX-capable"
> nodes via NUMA ABIs.
> 
> 5. Physical Memory Hotplug
> 
> Note TDX assumes convertible memory is always physically present during
> machine's runtime.  A non-buggy BIOS should never support hot-removal of
> any convertible memory.  This implementation doesn't handle ACPI memory
> removal but depends on the BIOS to behave correctly.

-- 
Thanks,

David / dhildenb

