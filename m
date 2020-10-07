Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE2028660F
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 19:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728675AbgJGRgt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 13:36:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728661AbgJGRgt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Oct 2020 13:36:49 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64497C0613D2
        for <kvm@vger.kernel.org>; Wed,  7 Oct 2020 10:36:49 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id o21so2654679qtp.2
        for <kvm@vger.kernel.org>; Wed, 07 Oct 2020 10:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Ey3YmoFgPTHM+T5ZPwxICgQJ5vkBQ0KmdtsXuWxeC1c=;
        b=cJyTco0o/X8Gh9Q8b6BPp6IdcS7VSLvnWTh3xcYJUFHbyiLWErf+iW1RZDOm9F9oY9
         /RwR5IXcdjrLUU0OXhaPFgLG8k7+Ef0dgsBndQomBoI20I5BBA+wnVg9YgfgY6tlExhJ
         GPN2ezDwTEsFX7Xe+3JJt1NoTy3V47hbuQQqb7ZxOE7Qs0x6JByqIFVEOs9dTvPQsYQc
         +nn+8vC8beQAGn1ifDdDcXjK9JilYqUSZdSn09CEzYb0FcsMaf0UaNceKgfHSfMJtgrO
         99pbN8eZQwww8IKq9rj7gOuxBmgO7TGhqfnOfXjY30NDWc4Ox8v1+I3IrM8kLatmbFcA
         5EaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Ey3YmoFgPTHM+T5ZPwxICgQJ5vkBQ0KmdtsXuWxeC1c=;
        b=tc3V9Jot58+9nyzcgtZFkHgglP0Fhn6t5fREPRIEIy2e2YkE89HprA4k4gXTKXUXLy
         ZVT5SXJYJfMmrvkD6NwrCAZmN7HI+FdZwz6Q08xye2j5N5ymDEfyZ09+mEkaVL6zttFZ
         bPZN2Nn/UcWcVvkIlV1GmK0wYGdMtA6Kf5HSuqHjC99KDeHVc6L8OQvcP33WFSUNhn7J
         yoI9gqa75lQ7uEa/iWl1Kncmi5IG8lef5CS6qeg6Mongatj1rVlG4WvAKTFb5UAR8pFF
         yrApfP63G/jrjH+qhBTJ8VUQV7G0i4AOEDfIH/bVy/mA5B3fXKeKw4qqp7+phwkA+CLP
         R7aQ==
X-Gm-Message-State: AOAM531m0YyNijf1K6/9jr/CRukvv5QbWPOQIOyvcLn0qKHDmtQQSiWo
        +EkO/VgN592uXEsK26B5SM+XTQ==
X-Google-Smtp-Source: ABdhPJzIdI5AjZ18wbqTXo1CaYgRr7q4X6KZ4wyL31oqNFbKIHXkxY8LKkchscJ9sXfgT8LuTH1iOw==
X-Received: by 2002:ac8:33e8:: with SMTP id d37mr4225519qtb.310.1602092208628;
        Wed, 07 Oct 2020 10:36:48 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id o4sm2006223qko.120.2020.10.07.10.36.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 10:36:47 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1kQDMt-00110d-DV; Wed, 07 Oct 2020 14:36:47 -0300
Date:   Wed, 7 Oct 2020 14:36:47 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Daniel Vetter <daniel.vetter@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 11/13] mm: add unsafe_follow_pfn
Message-ID: <20201007173647.GW5177@ziepe.ca>
References: <20201007164426.1812530-1-daniel.vetter@ffwll.ch>
 <20201007164426.1812530-12-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201007164426.1812530-12-daniel.vetter@ffwll.ch>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 07, 2020 at 06:44:24PM +0200, Daniel Vetter wrote:
> Way back it was a reasonable assumptions that iomem mappings never
> change the pfn range they point at. But this has changed:
> 
> - gpu drivers dynamically manage their memory nowadays, invalidating
> ptes with unmap_mapping_range when buffers get moved
> 
> - contiguous dma allocations have moved from dedicated carvetouts to
> cma regions. This means if we miss the unmap the pfn might contain
> pagecache or anon memory (well anything allocated with GFP_MOVEABLE)
> 
> - even /dev/mem now invalidates mappings when the kernel requests that
> iomem region when CONFIG_IO_STRICT_DEVMEM is set, see 3234ac664a87
> ("/dev/mem: Revoke mappings when a driver claims the region")
> 
> Accessing pfns obtained from ptes without holding all the locks is
> therefore no longer a good idea.
> 
> Unfortunately there's some users where this is not fixable (like v4l
> userptr of iomem mappings) or involves a pile of work (vfio type1
> iommu). For now annotate these as unsafe and splat appropriately.
> 
> This patch adds an unsafe_follow_pfn, which later patches will then
> roll out to all appropriate places.
> 
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Jérôme Glisse <jglisse@redhat.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: linux-mm@kvack.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-samsung-soc@vger.kernel.org
> Cc: linux-media@vger.kernel.org
> Cc: kvm@vger.kernel.org
> ---
>  include/linux/mm.h |  2 ++
>  mm/memory.c        | 32 +++++++++++++++++++++++++++++++-
>  mm/nommu.c         | 17 +++++++++++++++++
>  security/Kconfig   | 13 +++++++++++++
>  4 files changed, 63 insertions(+), 1 deletion(-)

Makes sense to me.

I wonder if we could change the original follow_pfn to require the
ptep and then lockdep_assert_held() it against the page table lock?

> +int unsafe_follow_pfn(struct vm_area_struct *vma, unsigned long address,
> +	unsigned long *pfn)
> +{
> +#ifdef CONFIG_STRICT_FOLLOW_PFN
> +	pr_info("unsafe follow_pfn usage rejected, see
> CONFIG_STRICT_FOLLOW_PFN\n");

Wonder if we can print something useful here, like the current
PID/process name?

> diff --git a/security/Kconfig b/security/Kconfig
> index 7561f6f99f1d..48945402e103 100644
> --- a/security/Kconfig
> +++ b/security/Kconfig
> @@ -230,6 +230,19 @@ config STATIC_USERMODEHELPER_PATH
>  	  If you wish for all usermode helper programs to be disabled,
>  	  specify an empty string here (i.e. "").
>  
> +config STRICT_FOLLOW_PFN
> +	bool "Disable unsafe use of follow_pfn"
> +	depends on MMU

I would probably invert this CONFIG_ALLOW_UNSAFE_FOLLOW_PFN
default n

Jason
