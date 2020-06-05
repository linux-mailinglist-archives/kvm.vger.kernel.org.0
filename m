Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E45371EF4F6
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 12:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgFEKGU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 06:06:20 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:56292 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726324AbgFEKGU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Jun 2020 06:06:20 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=alex.shi@linux.alibaba.com;NM=1;PH=DS;RN=39;SR=0;TI=SMTPD_---0U-djnUn_1591351570;
Received: from IT-FVFX43SYHV2H.local(mailfrom:alex.shi@linux.alibaba.com fp:SMTPD_---0U-djnUn_1591351570)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 05 Jun 2020 18:06:11 +0800
Subject: Re: [PATCH RFC v4 00/13] virtio-mem: paravirtualized memory
To:     David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sebastien Boeuf <sebastien.boeuf@intel.com>,
        Samuel Ortiz <samuel.ortiz@intel.com>,
        Robert Bradford <robert.bradford@intel.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Alexander Potapenko <glider@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Anthony Yznaga <anthony.yznaga@oracle.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Young <dyoung@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Juergen Gross <jgross@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Len Brown <lenb@kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Michal Hocko <mhocko@suse.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Oscar Salvador <osalvador@suse.com>,
        Oscar Salvador <osalvador@suse.de>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Pavel Tatashin <pavel.tatashin@microsoft.com>,
        Pingfan Liu <kernelfans@gmail.com>, Qian Cai <cai@lca.pw>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Wei Yang <richard.weiyang@gmail.com>
References: <20191212171137.13872-1-david@redhat.com>
 <9acc5d04-c8e9-ef53-85e4-709030997ca6@redhat.com>
 <1cfa9edb-47ea-1495-4e28-4cf391eab44c@linux.alibaba.com>
 <d6cd1870-1012-cb3d-7d29-8e5ad2703717@redhat.com>
From:   Alex Shi <alex.shi@linux.alibaba.com>
Message-ID: <fe476535-3e98-0682-559c-73adde22e7ab@linux.alibaba.com>
Date:   Fri, 5 Jun 2020 18:06:10 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <d6cd1870-1012-cb3d-7d29-8e5ad2703717@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2020/6/5 下午5:08, David Hildenbrand 写道:
> Please use the virtio-mem-v4 branch for now, v5 is still under
> construction (and might be scrapped completely if v4 goes upstream as is).
> 
> Looks like a DMA issue. Your're hotplugging 1GB, which should not really
> eat too much memory. There was a similar issue reported by Hui in [1],
> which boiled down to wrong usage of the swiotlb parameter.

I have no swiotbl=noforce set, and sometime no swiotlb error reported, like
(qemu) [   41.591308] e1000 0000:00:03.0: dma_direct_map_page: overflow 0x000000011fd470da+54 of device mask ffffffff
[   41.592431] e1000 0000:00:03.0: TX DMA map failed
[   41.593031] e1000 0000:00:03.0: dma_direct_map_page: overflow 0x000000011fd474da+54 of device mask ffffff
...
[   63.049464] ata_piix 0000:00:01.1: dma_direct_map_sg: overflow 0x0000000107db2000+4096 of device mask ffffffff
[   63.068297] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   63.069057] ata1.00: failed command: READ DMA
[   63.069580] ata1.00: cmd c8/00:20:40:bd:d2/00:00:00:00:00/e0 tag 0 dma 16384 in
[   63.069580]          res 50/00:00:3f:30:80/00:00:00:00:00/a0 Emask 0x40 (internal error) 
> 
> In such cases you should always try to reproduce with hotplug of a
> sam-sized DIMM. E.g., hotplugging a 1GB DIMM should result in the same
> issue.
> 
> What does your .config specify for CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE?

Yes, it's set. 

I had tried the v2/v4 version, which has the same issue.
Is this related with virtio-mem start address too low?

Thanks a lot!
> 
> I'll try to reproduce with v4 briefly.
> 
> [1]
> https://lkml.kernel.org/r/9708F43A-9BD2-4377-8EE8-7FB1D95C6F69@linux.alibaba.com
