Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC2F87A050F
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 15:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238721AbjINNKk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 09:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238601AbjINNKj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 09:10:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BD4951FD4
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 06:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694696995;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7ChIOmTfd7o/NKHWUFFWtkJ2XI7L7oPGwY6YJ68EaFI=;
        b=TjIJrYYBf5Up6Ev0vrqyzQwdqawLUFCwEQqSNhfL0x0e2J0oiZVrAlUe+qhpUwgkZO0hwh
        AYzvKqCfHOjH7AoWIgRaOEsB1GIY2OXfZaAvtxJVEfxnWr7ZFzBN0Qh22rF6Zt3tevUfBH
        KjXsZlXjPkKONYh/oei99abTlj6GRhg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-548-SeKij2w7MQOYwo2i8hQ4fw-1; Thu, 14 Sep 2023 09:09:50 -0400
X-MC-Unique: SeKij2w7MQOYwo2i8hQ4fw-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-40474c03742so2480405e9.3
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 06:09:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694696988; x=1695301788;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7ChIOmTfd7o/NKHWUFFWtkJ2XI7L7oPGwY6YJ68EaFI=;
        b=RwGgOnqntOZBmwqa4bYK27zrL1vLcQ9kpPzKxdWgRdEvcxmK3V2W96mRjsN0pLAXer
         KOwh/kRHldix6humghpJ1BXb1oaCD5TUS+6JLLAlxKRePthx5sXh8P+lqYxxUhxjp8HD
         NM8YT4+d1I7OFHuUMq0IUf1g2nKrDcppPoQ0N5cHruy4tR2LONzwoK90H217BLf8RI6T
         JuO8HusCBEtModlQvyuGt7ATPvX3i3yWGTRPR9QXnfvWB/XZCIwJcOGWsGPXkEr3RD1w
         xhNXxc/VSmBhFyUYi0dLb61SJMdUiuVZeD5m48d/P5We4pnNQ48/WLHRPmzK1tBPYJ0Q
         Lqzw==
X-Gm-Message-State: AOJu0Yxh07z0r+3WnMhHeyJEd7YVZJ6xl0SwE1i69U60RJ2kuVT74k8A
        +urAXaNCOlSDC5I1TGNh2P+tRnTR4nofCJV8xLNCuWdgG/s43UD+rYEP7EdF1ayFIJnUXCIdTCC
        PxNpqI+3Xukkf5tHpE/YP
X-Received: by 2002:a05:6000:1d83:b0:31f:e1b4:5846 with SMTP id bk3-20020a0560001d8300b0031fe1b45846mr1230569wrb.53.1694696988340;
        Thu, 14 Sep 2023 06:09:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEWujUSunuwo9Kqn3OnEp5AQVDiwQj77GqWQB/Z9xX2vzqdYchUWZp0OuKiR/MfisxVkzDOxw==
X-Received: by 2002:a05:6000:1d83:b0:31f:e1b4:5846 with SMTP id bk3-20020a0560001d8300b0031fe1b45846mr1230544wrb.53.1694696987868;
        Thu, 14 Sep 2023 06:09:47 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id t3-20020a05600001c300b003143b14848dsm1713172wrx.102.2023.09.14.06.09.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Sep 2023 06:09:46 -0700 (PDT)
Message-ID: <fe9f3d19-df01-01e6-a253-f7fe5bdea41f@redhat.com>
Date:   Thu, 14 Sep 2023 15:09:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Content-Language: en-US
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Michael Roth <michael.roth@amd.com>, isaku.yamahata@gmail.com,
        Sean Christopherson <seanjc@google.com>,
        Claudio Fontana <cfontana@suse.de>
References: <20230914035117.3285885-1-xiaoyao.li@intel.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [RFC PATCH v2 00/21] QEMU gmem implemention
In-Reply-To: <20230914035117.3285885-1-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14.09.23 05:50, Xiaoyao Li wrote:
> It's the v2 RFC of enabling KVM gmem[1] as the backend for private
> memory.
> 
> For confidential-computing, KVM provides gmem/guest_mem interfaces for
> userspace, like QEMU, to allocate user-unaccesible private memory. This
> series aims to add gmem support in QEMU's RAMBlock so that each RAM can
> have both hva-based shared memory and gmem_fd based private memory. QEMU
> does the shared-private conversion on KVM_MEMORY_EXIT and discards the
> memory.
> 
> It chooses the design that adds "private" property to hostmeory backend.
> If "private" property is set, QEMU will allocate/create KVM gmem when
> initialize the RAMbloch of the memory backend.
> 
> This sereis also introduces the first user of kvm gmem,
> KVM_X86_SW_PROTECTED_VM. A KVM_X86_SW_PROTECTED_VM with private KVM gmem
> can be created with
> 
>    $qemu -object sw-protected-vm,id=sp-vm0 \
> 	-object memory-backend-ram,id=mem0,size=1G,private=on \
> 	-machine q35,kernel_irqchip=split,confidential-guest-support=sp-vm0,memory-backend=mem0 \
> 	...
> 
> Unfortunately this patch series fails the boot of OVMF at very early
> stage due to triple fault, because KVM doesn't support emulating string IO
> to private memory.

Is support being added? Or have we figured out what it would take to 
make it work?

How does this interact with other features (memory ballooning, virtiofs, 
vfio/mdev/...)?

> 
> This version still leave some opens to be discussed:
> 1. whether we need "private" propery to be user-settable?
> 
>     It seems unnecessary because vm-type is determined. If the VM is
>     confidential-guest, then the RAM of the guest must be able to be
>     mapped as private, i.e., have kvm gmem backend. So QEMU can
>     determine the value of "private" property automatiacally based on vm
>     type.
> 
>     This also aligns with the board internal MemoryRegion that needs to
>     have kvm gmem backend, e.g., TDX requires OVMF to act as private
>     memory so bios memory region needs to have kvm gmem fd associated.
>     QEMU no doubt will do it internally automatically.

Would it make sense to have some regions without "pivate" semantics? 
Like NVDIMMs?

> 
> 2. hugepage support.
> 
>     KVM gmem can be allocated from hugetlbfs. How does QEMU determine
>     when to allocate KVM gmem with KVM_GUEST_MEMFD_ALLOW_HUGEPAGE. The
>     easiest solution is create KVM gmem with KVM_GUEST_MEMFD_ALLOW_HUGEPAGE
>     only when memory backend is HostMemoryBackendFile of hugetlbfs.

Good question.

Probably "if the memory backend uses huge pages, also use huge pages for 
the private gmem" makes sense.

... but it becomes a mess with preallocation ... which is what people 
should actually be using with hugetlb. Andeventual double 
memory-consumption ... but maybe that's all been taken care of already?

Probably it's best to leave hugetlb support as future work and start 
with something minimal.

> 
> 3. What is KVM_X86_SW_PROTECTED_VM going to look like? and do we need it?
> 

Why implement it when you have to ask others for a motivation? ;)

Personally, I'm not sure if it is really useful, especially in this state.

>     This series implements KVM_X86_SW_PROTECTED_VM because it's introduced
>     with gmem together on KVM side and it's supposed to be the first user
>     who requires KVM gmem. However the implementation is incomplete and
>     there lacks the definition of how KVM_X86_SW_PROTECTED_VM works.

Then it should not be included in this series such that you can make 
progress with the gmem implementation for TDX guests instead?

-- 
Cheers,

David / dhildenb

