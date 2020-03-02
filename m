Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1E9B175ACC
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 13:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbgCBMs5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 07:48:57 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54958 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727107AbgCBMs5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 07:48:57 -0500
Received: by mail-wm1-f66.google.com with SMTP id z12so11017454wmi.4;
        Mon, 02 Mar 2020 04:48:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=s+VyaNhmOd6f42VIDi6KHAKXCWAclUlFckZ+VTZz/lc=;
        b=Vr/hs2LPI9BKFj3/9zTPftIyRnfRcK70ijX+0AqL84q9w7UEhnH1nH9AFzrqgaKNJ4
         UoUAFN1FADPY7dSaIKlEG2WjfZXG0ka5/JW+zhThkP2oLVL4iTzDpvBlQfl0eWwmd6XF
         Z39kQqwk5Fxy5DJLhA9bdS9BDzDstPXnYiGrlDg23/6XjMeo/o4faYyTY/O1VObwwW7Q
         pM3GPrTEY/5cQA3Mj3lDDChuW0zok7B9saW8Cf35V3ezq9kDIKKiquL/JGa6e2jc2MGA
         znaACA4QBHGRllLwtqVqCI66Onf4m6Zp/C9hCZoftV1KA/hnUO+Xwts5Sas4AyhsCUBM
         F1pw==
X-Gm-Message-State: ANhLgQ1WZDYq3CMNLVT6MBazmJZBdCArITeCOOu/XkSqQo8l0X10d6JX
        W/ktNXv8t+/CbztMYGs/zfc=
X-Google-Smtp-Source: ADFU+vu2qgToohf1Ho0XOtqDdOYGWkWtP/VPHfRQw8HJnTcjtKh7DPXkwvVpSUhS0/HRLDYCsIxTfA==
X-Received: by 2002:a7b:cc69:: with SMTP id n9mr2851092wmj.175.1583153333837;
        Mon, 02 Mar 2020 04:48:53 -0800 (PST)
Received: from localhost (prg-ext-pat.suse.com. [213.151.95.130])
        by smtp.gmail.com with ESMTPSA id z14sm28071107wru.31.2020.03.02.04.48.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 04:48:53 -0800 (PST)
Date:   Mon, 2 Mar 2020 13:48:52 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Oscar Salvador <osalvador@suse.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Wei Yang <richard.weiyang@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>, Qian Cai <cai@lca.pw>
Subject: Re: [PATCH RFC v4 08/13] mm/memory_hotplug: Introduce
 offline_and_remove_memory()
Message-ID: <20200302124852.GJ4380@dhcp22.suse.cz>
References: <20191212171137.13872-1-david@redhat.com>
 <20191212171137.13872-9-david@redhat.com>
 <20200225141134.GU22443@dhcp22.suse.cz>
 <d1dbb687-7959-f4f1-6a64-33ee039782ef@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1dbb687-7959-f4f1-6a64-33ee039782ef@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue 25-02-20 15:27:28, David Hildenbrand wrote:
> On 25.02.20 15:11, Michal Hocko wrote:
> > On Thu 12-12-19 18:11:32, David Hildenbrand wrote:
> >> virtio-mem wants to offline and remove a memory block once it unplugged
> >> all subblocks (e.g., using alloc_contig_range()). Let's provide
> >> an interface to do that from a driver. virtio-mem already supports to
> >> offline partially unplugged memory blocks. Offlining a fully unplugged
> >> memory block will not require to migrate any pages. All unplugged
> >> subblocks are PageOffline() and have a reference count of 0 - so
> >> offlining code will simply skip them.
> >>
> >> All we need an interface to trigger the "offlining" and the removing in a
> >> single operation - to make sure the memory block cannot get onlined by
> >> user space again before it gets removed.
> > 
> > Why does that matter? Is it really likely that the userspace would
> > interfere? What would be the scenario?
> 
> I guess it's not that relevant after all (I think this comment dates
> back to the times where we didn't have try_remove_memory() and could
> actually BUG_ON() in remove_memory() if there would have been a race).
> Can drop that part.
> 
> > 
> > Or is still mostly about not requiring callers to open code this general
> > patter?
> 
> From kernel module context, I cannot get access to the actual memory
> block device (find_memory_block()) and call the device_unregister().
> 
> Especially, also the device hotplug lock is not exported. So this is a
> clean helper function to be used from kernel module context. (e.g., also
> hyper-v showed interest for using that)

Fair enough.
-- 
Michal Hocko
SUSE Labs
