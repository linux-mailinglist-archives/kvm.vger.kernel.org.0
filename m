Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B173A442CB4
	for <lists+kvm@lfdr.de>; Tue,  2 Nov 2021 12:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbhKBLiP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Nov 2021 07:38:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22133 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229778AbhKBLiN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Nov 2021 07:38:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635852939;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LmMvfElX6M+0WYCPcYmQMWdPiGm8k07IOEcDvgd1SxY=;
        b=UmhKxuQ+q4gKOZSX6rAiOeZQ5fMp4qqstKeZdwa7QKlSQGMQUR6GS2TGN/XLohjXfAMQty
        eP3uS9+lbWmKGRlxe614JzMgRa+liFGEp8hdhGpJtyvrvKp445usbGXzntpQ/WnzB0Hnem
        uvzLWywB9gubFclQm2sg1U7arJMwRBY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-231-Y_o2DdGuOZasxzJLq8LDAw-1; Tue, 02 Nov 2021 07:35:38 -0400
X-MC-Unique: Y_o2DdGuOZasxzJLq8LDAw-1
Received: by mail-wm1-f72.google.com with SMTP id o22-20020a1c7516000000b0030d6f9c7f5fso6825390wmc.1
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 04:35:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LmMvfElX6M+0WYCPcYmQMWdPiGm8k07IOEcDvgd1SxY=;
        b=ZzMa9U/qu4iSGPUH2Ro1WNdquRSRB8JYxzIWtUpkmRx+cAAUI5OVx/m4qOGkSq9oBR
         6LF3EV8toRiuMvGHXewFeM4CcvFlCzF6qGNzrEe2Uo0IFNnF13grSjn74MQ11ojLdjd3
         qaFJy8bjkVNbE0JLrfSaElVorxqiQAE8bG8PA/BXuTUy1c8uAV79EPEaAmgxQ7vynZrb
         JAqjofeBMYhk5YQrbiYpsWtBQ/XSUWr96pvmt0ETGnK/0Auy5lX8IxN4ZjVQZacEBQjd
         p76tVpl2V7TYLiH5Mb49av35Pt5Bn85LruYUH1tujEYCKSkaw2MQP6TuDbE4UwKJJKg3
         PHrQ==
X-Gm-Message-State: AOAM531MoI2xuW1N6jFua9E+yRk/I6/h40WCPSz5L3Je6Xg/ZZXYR4qA
        f+CYBRsm53ejG3xowIpMGxReSdEo7nw93CEUnXbWj80WL5J9hSGpfB9XJ9E2Qf9VAZG+1uKUpuU
        njxeo5dGm9vbJ
X-Received: by 2002:a5d:4e81:: with SMTP id e1mr47330391wru.242.1635852936892;
        Tue, 02 Nov 2021 04:35:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzPGl4SyFSPG9ZM0E/Oj2KRRGHWrzU20lxdKAhKtxgtI9RAzppH5ex8ctP1VZa3BxTTX/bRIQ==
X-Received: by 2002:a5d:4e81:: with SMTP id e1mr47330357wru.242.1635852936676;
        Tue, 02 Nov 2021 04:35:36 -0700 (PDT)
Received: from redhat.com ([2a03:c5c0:207e:c1:107d:c1da:65:fcb8])
        by smtp.gmail.com with ESMTPSA id o20sm2145924wmq.47.2021.11.02.04.35.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 04:35:36 -0700 (PDT)
Date:   Tue, 2 Nov 2021 07:35:31 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <ani@anisinha.ca>, Peter Xu <peterx@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <f4bug@amsat.org>,
        Hui Zhu <teawater@gmail.com>,
        Sebastien Boeuf <sebastien.boeuf@intel.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v1 00/12] virtio-mem: Expose device memory via multiple
 memslots
Message-ID: <20211102072843-mutt-send-email-mst@kernel.org>
References: <20211027124531.57561-1-david@redhat.com>
 <20211101181352-mutt-send-email-mst@kernel.org>
 <a5c94705-b66d-1b19-1c1f-52e99d9dacce@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5c94705-b66d-1b19-1c1f-52e99d9dacce@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 02, 2021 at 09:33:55AM +0100, David Hildenbrand wrote:
> On 01.11.21 23:15, Michael S. Tsirkin wrote:
> > On Wed, Oct 27, 2021 at 02:45:19PM +0200, David Hildenbrand wrote:
> >> This is the follow-up of [1], dropping auto-detection and vhost-user
> >> changes from the initial RFC.
> >>
> >> Based-on: 20211011175346.15499-1-david@redhat.com
> >>
> >> A virtio-mem device is represented by a single large RAM memory region
> >> backed by a single large mmap.
> >>
> >> Right now, we map that complete memory region into guest physical addres
> >> space, resulting in a very large memory mapping, KVM memory slot, ...
> >> although only a small amount of memory might actually be exposed to the VM.
> >>
> >> For example, when starting a VM with a 1 TiB virtio-mem device that only
> >> exposes little device memory (e.g., 1 GiB) towards the VM initialliy,
> >> in order to hotplug more memory later, we waste a lot of memory on metadata
> >> for KVM memory slots (> 2 GiB!) and accompanied bitmaps. Although some
> >> optimizations in KVM are being worked on to reduce this metadata overhead
> >> on x86-64 in some cases, it remains a problem with nested VMs and there are
> >> other reasons why we would want to reduce the total memory slot to a
> >> reasonable minimum.
> >>
> >> We want to:
> >> a) Reduce the metadata overhead, including bitmap sizes inside KVM but also
> >>    inside QEMU KVM code where possible.
> >> b) Not always expose all device-memory to the VM, to reduce the attack
> >>    surface of malicious VMs without using userfaultfd.
> > 
> > I'm confused by the mention of these security considerations,
> > and I expect users will be just as confused.
> 
> Malicious VMs wanting to consume more memory than desired is only
> relevant when running untrusted VMs in some environments, and it can be
> caught differently, for example, by carefully monitoring and limiting
> the maximum memory consumption of a VM. We have the same issue already
> when using virtio-balloon to logically unplug memory. For me, it's a
> secondary concern ( optimizing a is much more important ).
> 
> Some users showed interest in having QEMU disallow access to unplugged
> memory, because coming up with a maximum memory consumption for a VM is
> hard. This is one step into that direction without having to run with
> uffd enabled all of the time.

Sorry about missing the memo - is there a lot of overhead associated
with uffd then?

> ("security is somewhat the wrong word. we won't be able to steal any
> information from the hypervisor.)

Right. Let's just spell it out.
Further, removing memory still requires guest cooperation.

> 
> > So let's say user wants to not be exposed. What value for
> > the option should be used? What if a lower option is used?
> > Is there still some security advantage?
> 
> My recommendation will be to use 1 memslot per gigabyte as default if
> possible in the configuration. If we have a virtio-mem devices with a
> maximum size of 128 GiB, the suggestion will be to use memslots=128.
> Some setups will require less (e.g., vhost-user until adjusted, old
> KVM), some setups can allow for more. I assume that most users will
> later set "memslots=0", to enable auto-detection mode.
> 
> 
> Assume we have a virtio-mem device with a maximum size of 1 TiB and we
> hotplugged 1 GiB to the VM. With "memslots=1", the malicious VM could
> actually access the whole 1 TiB. With "memslots=1024", the malicious VM
> could only access additional ~ 1 GiB. With "memslots=512", ~ 2 GiB.
> That's the reduced attack surface.
> 
> Of course, it's different after we hotunplugged memory, before we have
> VIRTIO_MEM_F_UNPLUGGED_INACCESSIBLE support in QEMU, because all memory
> inside the usable region has to be accessible and we cannot "unplug" the
> memslots.
> 
> 
> Note: With upcoming VIRTIO_MEM_F_UNPLUGGED_INACCESSIBLE changes in QEMU,
> one will be able to disallow any access for malicious VMs by setting the
> memblock size just as big as the device block size.
> 
> So with a 128 GiB virtio-mem device with memslots=128,block-size=1G, or
> with memslots=1024,block-size=128M we could make it impossible for a
> malicious VM to consume more memory than intended. But we lose
> flexibility due to the block size and the limited number of available
> memslots.
> 
> But again, for "full protection against malicious VMs" I consider
> userfaultfd protection more flexible. This approach here gives some
> advantage, especially when having large virtio-mem devices that start
> out small.
> 
> -- 
> Thanks,
> 
> David / dhildenb

