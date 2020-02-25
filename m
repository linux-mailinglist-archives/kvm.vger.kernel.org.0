Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9ADF16E92B
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 15:59:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730500AbgBYO6d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 09:58:33 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43176 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729390AbgBYO6d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 09:58:33 -0500
Received: by mail-wr1-f67.google.com with SMTP id r11so15089779wrq.10;
        Tue, 25 Feb 2020 06:58:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0UgZMjEYrhnpUW+KD5jOXcu9LxkZxjWZEpMnARZ+WD0=;
        b=MylaM5lwByuabEvTygcD+1QRKk5kRjb20X/DxbvxUaWNvQhhe8CsPHC6iKGav02Z1v
         TRCUJ5i/Tm+3Scvp29RHgO4iaJqF5zTaO+XZ+14R/CYtvl+S4iYtZiilaYnQgQ4dbq2b
         TAWTCk9hhkaDsUxr/qlsptSWn9LqtmyMJbotO2LVpPwnLHURqKmvPRXcFpUq1HmjjMX1
         mAiEqAyj1WqKO7nGRiC4Gklzqi7hZWT4C3bTfLEu3oIV5M/hqmKOt4aM4Py4ApkeaA0b
         xqpTWROTLzyntbvDntJpcb3rPC03jKi5OFyqm2koLPFkDQzB2TyntPoXqoqvWbug/nWh
         uY5A==
X-Gm-Message-State: APjAAAVRKXe8LST7OBwYKavM6insKZucWjJadUu9P5YrwhjNYxHzYK7/
        PTrLimmndTSFDfQ+F9qJPZI=
X-Google-Smtp-Source: APXvYqzpdPx0S/Ay341l/1VLTiTEph73dZr8/CzTbfXsVdnLAYyHzJiSa2C64DI7Obv90MD62NKfOw==
X-Received: by 2002:adf:c445:: with SMTP id a5mr2759044wrg.14.1582642710508;
        Tue, 25 Feb 2020 06:58:30 -0800 (PST)
Received: from localhost (prg-ext-pat.suse.com. [213.151.95.130])
        by smtp.gmail.com with ESMTPSA id p5sm23820841wrt.79.2020.02.25.06.58.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 06:58:29 -0800 (PST)
Date:   Tue, 25 Feb 2020 15:58:29 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH RFC v4 12/13] mm/vmscan: Export drop_slab() and
 drop_slab_node()
Message-ID: <20200225145829.GW22443@dhcp22.suse.cz>
References: <20191212171137.13872-1-david@redhat.com>
 <20191212171137.13872-13-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212171137.13872-13-david@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu 12-12-19 18:11:36, David Hildenbrand wrote:
> We already have a way to trigger reclaiming of all reclaimable slab objects
> from user space (echo 2 > /proc/sys/vm/drop_caches). Let's allow drivers
> to also trigger this when they really want to make progress and know what
> they are doing.

I cannot say I would be fan of this. This is a global action with user
visible performance impact. I am worried that we will find out that all
sorts of drivers have a very good idea that dropping slab caches is
going to help their problem whatever it is. We have seen the same patter
in the userspace already and that is the reason we are logging the usage
to the log and count invocations in the counter.

> virtio-mem wants to use these functions when it failed to unplug memory
> for quite some time (e.g., after 30 minutes). It will then try to
> free up reclaimable objects by dropping the slab caches every now and
> then (e.g., every 30 minutes) as long as necessary. There will be a way to
> disable this feature and info messages will be logged.
> 
> In the future, we want to have a drop_slab_range() functionality
> instead. Memory offlining code has similar demands and also other
> alloc_contig_range() users (e.g., gigantic pages) could make good use of
> this feature. Adding it, however, requires more work/thought.

We already do have a memory_notify(MEM_GOING_OFFLINE) for that purpose
and slab allocator implements a callback (slab_mem_going_offline_callback).
The callback is quite dumb and it doesn't really try to free objects
from the given memory range or even try to drop active objects which
might turn out to be hard but this sounds like a more robust way to
achieve what you want.
 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  include/linux/mm.h | 4 ++--
>  mm/vmscan.c        | 2 ++
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 64799c5cb39f..483300f58be8 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2706,8 +2706,8 @@ int drop_caches_sysctl_handler(struct ctl_table *, int,
>  					void __user *, size_t *, loff_t *);
>  #endif
>  
> -void drop_slab(void);
> -void drop_slab_node(int nid);
> +extern void drop_slab(void);
> +extern void drop_slab_node(int nid);
>  
>  #ifndef CONFIG_MMU
>  #define randomize_va_space 0
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index c3e53502a84a..4e1cdaaec5e6 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -719,6 +719,7 @@ void drop_slab_node(int nid)
>  		} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
>  	} while (freed > 10);
>  }
> +EXPORT_SYMBOL(drop_slab_node);
>  
>  void drop_slab(void)
>  {
> @@ -728,6 +729,7 @@ void drop_slab(void)
>  		drop_slab_node(nid);
>  	count_vm_event(DROP_SLAB);
>  }
> +EXPORT_SYMBOL(drop_slab);
>  
>  static inline int is_page_cache_freeable(struct page *page)
>  {
> -- 
> 2.23.0

-- 
Michal Hocko
SUSE Labs
