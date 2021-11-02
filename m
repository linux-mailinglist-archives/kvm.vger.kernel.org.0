Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7229844344A
	for <lists+kvm@lfdr.de>; Tue,  2 Nov 2021 18:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234758AbhKBRJB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Nov 2021 13:09:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48768 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229806AbhKBRJA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Nov 2021 13:09:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635872784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Xd9OP13HrszSg6dpANSLXHBMip4qKz84tpPndl2POUM=;
        b=To28IjSgHzyEu5R/6nwZdJ6Wg9w7p2BsG0vVxdIdqBH6sMoSJ5c9GDzLcRfaRQoVdqy3yC
        9tRHVH8S+YgDlzuzYI6yBD9HdmsR7e+P748V9yzC4D3CVg+bEGwKl/R/aIi5d2ie1k6ETc
        lppUKdGmx5lh8FupdHFINKy7Xq49xd4=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-NKEBruYWNZCemsdAbuKSmA-1; Tue, 02 Nov 2021 13:06:23 -0400
X-MC-Unique: NKEBruYWNZCemsdAbuKSmA-1
Received: by mail-ed1-f69.google.com with SMTP id m8-20020a056402510800b003e29de5badbso4201546edd.18
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 10:06:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Xd9OP13HrszSg6dpANSLXHBMip4qKz84tpPndl2POUM=;
        b=pO1tVTuihj6KsVNNg/hzd0PeR0ovCihtoO8HH8uHWTeH1g3XwMy7u4RGebxIAyVFhA
         3IdIbOfTWMrvD4eht4B/LnduHUzyL8Lr7Jyyf/a+cek7AhkaVQKOf8ckLHWa86AlVPZz
         mSUv0T66N/C1/9M4Yg8EyE7BHJUhtZKsLGNw8BfyBe6brdYHyR2lqiXJY1c9FCuARif3
         Iau3ALmfaqBNFDdJS0w/YJv0XmuTm1fAV913iQeK7JMr9RndkGJTP7tMNv3CL4ty78kY
         mOvJ35YI+xrb6VShy7a+r4n0MF5DPqdrFwyG9bkMNO2hL8zjch67x/idq9Yc+9IstWAM
         p23w==
X-Gm-Message-State: AOAM533H6H6LnPHCmvqXO9+qzaucHiufziXlP9vWSYHTH3THKoJPDKUB
        OpbWOkN3vP1tBT/wrcdFtc2Z9K5VWuU/ic7KohaK8FVVD+PDafBPO024wLPKb+0rAyiRhv8vozu
        tqAjXNFFVZVnl
X-Received: by 2002:aa7:cd99:: with SMTP id x25mr7748283edv.249.1635872781618;
        Tue, 02 Nov 2021 10:06:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxoCFjx5agNfL7+P2Z10UjLjkgCtogz6su4lWXdZsqYEUrGIj8xKLzPR6gGlbBVLURar+RlCg==
X-Received: by 2002:aa7:cd99:: with SMTP id x25mr7748237edv.249.1635872781334;
        Tue, 02 Nov 2021 10:06:21 -0700 (PDT)
Received: from redhat.com ([2.55.17.31])
        by smtp.gmail.com with ESMTPSA id ga1sm8709229ejc.100.2021.11.02.10.06.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 10:06:20 -0700 (PDT)
Date:   Tue, 2 Nov 2021 13:06:15 -0400
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
Message-ID: <20211102111228-mutt-send-email-mst@kernel.org>
References: <20211027124531.57561-1-david@redhat.com>
 <20211101181352-mutt-send-email-mst@kernel.org>
 <a5c94705-b66d-1b19-1c1f-52e99d9dacce@redhat.com>
 <20211102072843-mutt-send-email-mst@kernel.org>
 <171c8ed0-d55e-77ef-963b-6d836729ef4b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171c8ed0-d55e-77ef-963b-6d836729ef4b@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 02, 2021 at 12:55:17PM +0100, David Hildenbrand wrote:
> On 02.11.21 12:35, Michael S. Tsirkin wrote:
> > On Tue, Nov 02, 2021 at 09:33:55AM +0100, David Hildenbrand wrote:
> >> On 01.11.21 23:15, Michael S. Tsirkin wrote:
> >>> On Wed, Oct 27, 2021 at 02:45:19PM +0200, David Hildenbrand wrote:
> >>>> This is the follow-up of [1], dropping auto-detection and vhost-user
> >>>> changes from the initial RFC.
> >>>>
> >>>> Based-on: 20211011175346.15499-1-david@redhat.com
> >>>>
> >>>> A virtio-mem device is represented by a single large RAM memory region
> >>>> backed by a single large mmap.
> >>>>
> >>>> Right now, we map that complete memory region into guest physical addres
> >>>> space, resulting in a very large memory mapping, KVM memory slot, ...
> >>>> although only a small amount of memory might actually be exposed to the VM.
> >>>>
> >>>> For example, when starting a VM with a 1 TiB virtio-mem device that only
> >>>> exposes little device memory (e.g., 1 GiB) towards the VM initialliy,
> >>>> in order to hotplug more memory later, we waste a lot of memory on metadata
> >>>> for KVM memory slots (> 2 GiB!) and accompanied bitmaps. Although some
> >>>> optimizations in KVM are being worked on to reduce this metadata overhead
> >>>> on x86-64 in some cases, it remains a problem with nested VMs and there are
> >>>> other reasons why we would want to reduce the total memory slot to a
> >>>> reasonable minimum.
> >>>>
> >>>> We want to:
> >>>> a) Reduce the metadata overhead, including bitmap sizes inside KVM but also
> >>>>    inside QEMU KVM code where possible.
> >>>> b) Not always expose all device-memory to the VM, to reduce the attack
> >>>>    surface of malicious VMs without using userfaultfd.
> >>>
> >>> I'm confused by the mention of these security considerations,
> >>> and I expect users will be just as confused.
> >>
> >> Malicious VMs wanting to consume more memory than desired is only
> >> relevant when running untrusted VMs in some environments, and it can be
> >> caught differently, for example, by carefully monitoring and limiting
> >> the maximum memory consumption of a VM. We have the same issue already
> >> when using virtio-balloon to logically unplug memory. For me, it's a
> >> secondary concern ( optimizing a is much more important ).
> >>
> >> Some users showed interest in having QEMU disallow access to unplugged
> >> memory, because coming up with a maximum memory consumption for a VM is
> >> hard. This is one step into that direction without having to run with
> >> uffd enabled all of the time.
> > 
> > Sorry about missing the memo - is there a lot of overhead associated
> > with uffd then?
> 
> When used with huge/gigantic pages, we don't particularly care.
> 
> For other memory backends, we'll have to route any population via the
> uffd handler: guest accesses a 4k page -> place a 4k page from user
> space. Instead of the kernel automatically placing a THP, we'd be
> placing single 4k pages and have to hope the kernel will collapse them
> into a THP later.

How much value there is in a THP given it's not present?


> khugepagd will only collapse into a THP if all affected page table
> entries are present and don't map the zero page, though.
> 
> So we'll most certainly use less THP for our VM and VM startup time
> ("first memory access after plugging memory") can be slower.
> 
> I have prototypes for it, with some optimizations (e.g., on 4k guest
> access, populate the whole THP area), but we might not want to enable it
> all of the time. (interaction with postcopy has to be fixed, but it's
> not a fundamental issue)
> 
> 
> Extending uffd-based protection for virtio-mem to other processes
> (vhost-user), is a bit more complicated, and I am not 100% sure if it's
> worth the trouble for now. memslots provide at least some high-level
> protection for the important case of having a virtio-mem device to
> eventually hotplug a lot of memory later.
> 
> > 
> >> ("security is somewhat the wrong word. we won't be able to steal any
> >> information from the hypervisor.)
> > 
> > Right. Let's just spell it out.
> > Further, removing memory still requires guest cooperation.
> 
> Right.
> 
> 
> -- 
> Thanks,
> 
> David / dhildenb

