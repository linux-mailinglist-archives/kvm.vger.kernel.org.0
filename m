Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 757721A8520
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 18:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391789AbgDNQfW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 12:35:22 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53310 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2391745AbgDNQfP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 12:35:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586882113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=a+z0V7RnGWnuMpMvNgwDiJGASaPb4ctVzlcABrxuV4A=;
        b=IYW8ewKU4uhcM8rcB4EdFu7tsMh9y+ergjepQJIMULG0WSCujseGGzHnGtj+gHVbRGpf81
        0mqIWU3rka5PJr3fX8SNaS8hIJK6U7XfoGlN9ohyT/YkIP5IajncroCMenX4XEbTFKnDvi
        YVHEjx0iCw4jPy+PViePvUpQM8vvc88=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-3mBEoONCN1m3ylH3yMEFmw-1; Tue, 14 Apr 2020 12:35:08 -0400
X-MC-Unique: 3mBEoONCN1m3ylH3yMEFmw-1
Received: by mail-qv1-f72.google.com with SMTP id z14so320835qvv.6
        for <kvm@vger.kernel.org>; Tue, 14 Apr 2020 09:35:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=a+z0V7RnGWnuMpMvNgwDiJGASaPb4ctVzlcABrxuV4A=;
        b=SAZjlH41MgfgjyPmTo3xM+t/xPpC/jbWEJMZr0EsnJ6lIrnbzrCJcv0R2evtHSPqnX
         53Qd1upg0FrtQRd+UPgMM3pqDu7rg/CvDj5D8RyFdOA+ZqToPXOxj0e0PGq5Js7frJvt
         +wRzIEFWgIUF4Uzf6uhkH9r+dexIO6ldY/DzwsbLjpa/URclhTE5PNfKRnneWwZjuITU
         /uhIJeXtNNTKAqeKzRq2UFjyZjn+lkMILVvXtzLNr5w4kNuOQOppYXRzjpD6kazPbk7o
         jE1XUvHxikuHzQaYpxLDaMDLcOj6it4L8gpHEV7Iw9TAW0I9lMsWxVNnKo0wQYkp0L/q
         GgdA==
X-Gm-Message-State: AGi0PuaRU5NuSROvuLhtg+tkFsRolVrlTsLWYkjpt0M7o8tByWPhnXHz
        CI9AjhOWFawQZQiMoNsi9xK+iUeQVCpnWWHLVkhLaYrHiW6lVbtrk0WPxQ6IZLLqLkVt9w+tzku
        XqyIwjpjbBTMS
X-Received: by 2002:ac8:1a8a:: with SMTP id x10mr16745181qtj.154.1586882108243;
        Tue, 14 Apr 2020 09:35:08 -0700 (PDT)
X-Google-Smtp-Source: APiQypIakUO2krHIWdvhEXYjqdm92gTrXC3mv7zDEqds8YLz1XE2H5AqLw7LE95UTq5xyYwXK4VCyA==
X-Received: by 2002:ac8:1a8a:: with SMTP id x10mr16745153qtj.154.1586882108008;
        Tue, 14 Apr 2020 09:35:08 -0700 (PDT)
Received: from redhat.com (bzq-79-183-51-3.red.bezeqint.net. [79.183.51.3])
        by smtp.gmail.com with ESMTPSA id f1sm10297177qkl.91.2020.04.14.09.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2020 09:35:07 -0700 (PDT)
Date:   Tue, 14 Apr 2020 12:35:02 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oscar Salvador <osalvador@suse.com>,
        Michal Hocko <mhocko@suse.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Wei Yang <richard.weiyang@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>, Qian Cai <cai@lca.pw>
Subject: Re: [PATCH v2 07/10] mm/memory_hotplug: Introduce
 offline_and_remove_memory()
Message-ID: <20200414123438-mutt-send-email-mst@kernel.org>
References: <20200311171422.10484-1-david@redhat.com>
 <20200311171422.10484-8-david@redhat.com>
 <156601a9-e919-b88f-2278-97ecee554d21@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156601a9-e919-b88f-2278-97ecee554d21@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 11, 2020 at 06:19:04PM +0100, David Hildenbrand wrote:
> On 11.03.20 18:14, David Hildenbrand wrote:
> > virtio-mem wants to offline and remove a memory block once it unplugged
> > all subblocks (e.g., using alloc_contig_range()). Let's provide
> > an interface to do that from a driver. virtio-mem already supports to
> > offline partially unplugged memory blocks. Offlining a fully unplugged
> > memory block will not require to migrate any pages. All unplugged
> > subblocks are PageOffline() and have a reference count of 0 - so
> > offlining code will simply skip them.
> > 
> > All we need is an interface to offline and remove the memory from kernel
> > module context, where we don't have access to the memory block devices
> > (esp. find_memory_block() and device_offline()) and the device hotplug
> > lock.
> > 
> > To keep things simple, allow to only work on a single memory block.
> > 
> 
> Lost the ACK from Michael
> 
> Acked-by: Michal Hocko <mhocko@suse.com> [1]
> 
> [1] https://lkml.kernel.org/r/20200302142737.GP4380@dhcp22.suse.cz


Andrew, could you pls ack merging this through the vhost tree,
with the rest of the patchset?

> -- 
> Thanks,
> 
> David / dhildenb

