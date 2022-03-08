Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CEA64D1CEE
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 17:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346371AbiCHQOt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 11:14:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244605AbiCHQOr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 11:14:47 -0500
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F3CF5005E;
        Tue,  8 Mar 2022 08:13:50 -0800 (PST)
Received: by mail-io1-f45.google.com with SMTP id q11so6914226iod.6;
        Tue, 08 Mar 2022 08:13:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OiqyeB0b6J0rfF+qZiyPdJHBNMRJKO0i7S5FsGcKn6U=;
        b=XJlIo8W6fhvylzMQQVW/0LXUccx8jyc4J7GNCQgtZZwxwz/fIpARi5Q/TJ9B4PjNmA
         lHNWLUR27jPmh+nQhqCiBxOrXcBHmVzKHPk+xPnjJ8xJVghPkeupdwte7e9LBbzIp4Zg
         gH/B8cFATPT0HEjqOx4cA1hjbPmHbC/FXTfOH/dFGFBj6J5TbZYLP1zf4iBIl7ezH0z1
         TTtJtubulvLvV9RmPuwK4dD57B2UMX++NuwJBb8FJyTJPYM151PleUYlrCbnTdHGdlei
         ffd+HIVTp8RJGHGEk5kU9GQIEZuaBqRGl0R+JGGXH2oPQmNzFz82F/jVno3hvko4m6vk
         UxcA==
X-Gm-Message-State: AOAM533u0dVUwv0StUdcUTwsKgX95OrYq2UQZK633uQ8aoKm++zn0sFQ
        6LP+5RTTplZKW1pGSwDfF7ax27T8yPk=
X-Google-Smtp-Source: ABdhPJxytH+Vzy+XUhqK4aPlSOSdpfI/yqmuWdQLh4Blw4P30hNSOKPzT3mOi/OUY1LF78hwilclag==
X-Received: by 2002:a05:6638:3012:b0:317:9a63:ecd3 with SMTP id r18-20020a056638301200b003179a63ecd3mr16838924jak.210.1646756028135;
        Tue, 08 Mar 2022 08:13:48 -0800 (PST)
Received: from fedora (216-241-34-136.static.forethought.net. [216.241.34.136])
        by smtp.gmail.com with ESMTPSA id x7-20020a056e021ca700b002c5f9136a2dsm12453334ill.36.2022.03.08.08.13.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 08:13:47 -0800 (PST)
Date:   Tue, 8 Mar 2022 11:13:44 -0500
From:   Dennis Zhou <dennis@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH 2/3] mm: use vmalloc_array and vcalloc for array
 allocations
Message-ID: <YieAuCGMRrJjEHMR@fedora>
References: <20220308105918.615575-1-pbonzini@redhat.com>
 <20220308105918.615575-3-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220308105918.615575-3-pbonzini@redhat.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

On Tue, Mar 08, 2022 at 05:59:17AM -0500, Paolo Bonzini wrote:
> Instead of using array_size or just a multiply, use a function that
> takes care of both the multiplication and the overflow checks.
> 
> Cc: linux-mm@kvack.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  mm/percpu-stats.c | 2 +-
>  mm/swap_cgroup.c  | 4 +---
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/percpu-stats.c b/mm/percpu-stats.c
> index c6bd092ff7a3..e71651cda2de 100644
> --- a/mm/percpu-stats.c
> +++ b/mm/percpu-stats.c
> @@ -144,7 +144,7 @@ static int percpu_stats_show(struct seq_file *m, void *v)
>  	spin_unlock_irq(&pcpu_lock);
>  
>  	/* there can be at most this many free and allocated fragments */
> -	buffer = vmalloc(array_size(sizeof(int), (2 * max_nr_alloc + 1)));
> +	buffer = vmalloc_array(2 * max_nr_alloc + 1, sizeof(int));
>  	if (!buffer)
>  		return -ENOMEM;
>  
> diff --git a/mm/swap_cgroup.c b/mm/swap_cgroup.c
> index 7f34343c075a..5a9442979a18 100644
> --- a/mm/swap_cgroup.c
> +++ b/mm/swap_cgroup.c
> @@ -167,14 +167,12 @@ unsigned short lookup_swap_cgroup_id(swp_entry_t ent)
>  int swap_cgroup_swapon(int type, unsigned long max_pages)
>  {
>  	void *array;
> -	unsigned long array_size;
>  	unsigned long length;
>  	struct swap_cgroup_ctrl *ctrl;
>  
>  	length = DIV_ROUND_UP(max_pages, SC_PER_PAGE);
> -	array_size = length * sizeof(void *);
>  
> -	array = vzalloc(array_size);
> +	array = vcalloc(length, sizeof(void *));
>  	if (!array)
>  		goto nomem;
>  
> -- 
> 2.31.1
> 

Acked-by: Dennis Zhou <dennis@kernel.org>

Thanks,
Dennis
