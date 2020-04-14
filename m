Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03D111A84E4
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 18:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391624AbgDNQ3P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 12:29:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29050 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2391561AbgDNQ2v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 12:28:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586881729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mjWxSbfmmzPB+9cl5oT2tFJutn094jI8t91pgbfl/bY=;
        b=SDgTYE7CITTW+8WNLGjfkjBiW4fN/6j1RKaWmcTFos25abYlRlB8RkZx312yQnil3+p+HG
        KNpXTJymA1a7UdjXsMrOzreKuwAiyiyR+rI+mMfotNmXNJ6fXwzOZlFB8puVF38fDD5Fx1
        RtM2QNwBR6u4rVjp3802EXjtQQB0g44=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-237-No0p3P2wMeyBWsKLH4Mtmg-1; Tue, 14 Apr 2020 12:28:46 -0400
X-MC-Unique: No0p3P2wMeyBWsKLH4Mtmg-1
Received: by mail-qk1-f199.google.com with SMTP id a67so12257539qke.0
        for <kvm@vger.kernel.org>; Tue, 14 Apr 2020 09:28:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mjWxSbfmmzPB+9cl5oT2tFJutn094jI8t91pgbfl/bY=;
        b=ERKdFaSKwHBgjFt+la8OuFAsGaRrpQy9ZkJhvPfoE+UvEhcJluzjXzs0E3ysEZTHzK
         FsU0H8w6YuG6ZA6eKfdoVt8KiiUjMUCogXIA1kEqvKksxwDBVrYst7t9AvASQuTpeq1N
         DR1yG6lpEE801tZo5p8hUgKNk3YoypXgu+Wi3vh5CB6zf/EzobITS+dv/X078JMRh/0B
         6rRQpQLeu/M6LytGdE3WkmJt0YNJgDM+v4idljOE6cl/UZQKQZObo9Mlh7DxdzgkiEA/
         rOIB7px36lI75XzyfXRDDT++Gsi/GLjbmRID9k7wy7pHzJovU+8rxdfQJGpEGUhQkeDY
         YfvA==
X-Gm-Message-State: AGi0PuaE9T6R3OX9wBA0V9pg3TlWBwio47zQXyDKPAUC1uzBmN4ZUUEZ
        na56zMUJelUxsXCFUKfWWpCDhLEaubArelmDbLj4Syd2M/p94le3EiojZ4QapeCSH+LLN2Tl1as
        1LMSkRxkbMmxu
X-Received: by 2002:ac8:6043:: with SMTP id k3mr15295321qtm.99.1586881725609;
        Tue, 14 Apr 2020 09:28:45 -0700 (PDT)
X-Google-Smtp-Source: APiQypJ4y/Xa4C4HgHuCyuPRYI8NOYdTc8eSgKzUQlVgQoEI+PhLHm/qmH5N/f+tJAy3tV4SwX5BzQ==
X-Received: by 2002:ac8:6043:: with SMTP id k3mr15295280qtm.99.1586881725363;
        Tue, 14 Apr 2020 09:28:45 -0700 (PDT)
Received: from redhat.com (bzq-79-183-51-3.red.bezeqint.net. [79.183.51.3])
        by smtp.gmail.com with ESMTPSA id o22sm371970qtm.90.2020.04.14.09.28.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2020 09:28:44 -0700 (PDT)
Date:   Tue, 14 Apr 2020 12:28:35 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sebastien Boeuf <sebastien.boeuf@intel.com>,
        Samuel Ortiz <samuel.ortiz@intel.com>,
        Robert Bradford <robert.bradford@intel.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        teawater <teawaterz@linux.alibaba.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Alexander Potapenko <glider@google.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Anthony Yznaga <anthony.yznaga@oracle.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Young <dyoung@redhat.com>,
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
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Wei Yang <richard.weiyang@gmail.com>
Subject: Re: [PATCH v2 00/10] virtio-mem: paravirtualized memory
Message-ID: <20200414122716-mutt-send-email-mst@kernel.org>
References: <20200311171422.10484-1-david@redhat.com>
 <20200329084128-mutt-send-email-mst@kernel.org>
 <b9984195-bb48-e2a6-887d-0905692a7524@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9984195-bb48-e2a6-887d-0905692a7524@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 14, 2020 at 11:15:18AM +0200, David Hildenbrand wrote:
> On 29.03.20 14:42, Michael S. Tsirkin wrote:
> > On Wed, Mar 11, 2020 at 06:14:12PM +0100, David Hildenbrand wrote:
> >> This series is based on latest linux-next. The patches are located at:
> >>     https://github.com/davidhildenbrand/linux.git virtio-mem-v2
> >>
> >> I now have acks for all !virtio-mem changes. I'll be happy to get review
> >> feedback, testing reports, etc. for the virtio-mem changes. If there are
> >> no further comments, I guess this is good to go as a v1 soon.
> > 
> > I'd like to queue it for merge after the release. If you feel it's ready
> > please ping me after the release to help make sure it didn't get
> > dropped.  I see there were some reports about people having trouble
> > using this, pls keep working on this meanwhile.
> 
> Hi Michael,
> 
> I think this is ready to go as a first version. There are a couple of
> future work items related to kexec/kdump:
> - Teach kexec-tools/kexec_file_load() to not place the kexec
>   kernel/initrd onto virtio-mem added memory.
> - Teach kexec-tools/kdump to consider a bigger number of memory
>   resources for dumping.
> 
> In general, as virtio-mem adds a lot of memory resources, we might want
> to tweak performance in that area as well. Future stuff.
> 
> So I suggest queuing this. If you need a resend, please let me know.
> 
> Cheers!

Thanks!
I'll queue it for merge after the release. If possible please ping me
after the release to help make sure it didn't get dropped.




> -- 
> Thanks,
> 
> David / dhildenb

