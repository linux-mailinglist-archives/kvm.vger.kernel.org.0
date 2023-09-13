Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA4D79E828
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 14:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240666AbjIMMhE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 08:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240672AbjIMMhC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 08:37:02 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 304C61BC8
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 05:36:58 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id af79cd13be357-76f17eab34eso418358185a.0
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 05:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1694608617; x=1695213417; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=x+9MtCGEueIzcQpF/feyfAWnqDz9Etq09hyqW4Rc828=;
        b=CUziXboxV4nwEAAXEV3v0b+3PiIKWbY1l6afchqbO8zc/CsHUs2BvM8LoUzagcgCqL
         xOqrHoEtDMEztkvBSA4hUx4cYlDeNZ+Gb1km/02+g0dUZ9KDRmgp5zu/HZJo24k3ZUNn
         1Sjq+NHwOeLpvDql0g/dSjGNCiypX36qBM+d2wp3DBsVYR3ssOI9aDsvdsheuWV1q9N4
         3enfHfjPNyT0KiV603VJTljcMBV9UTJ64N0toTmtGvkzZIBuA2Qoog5fuU0OOivmo+/4
         utux3/SUCNH2Axu0T4IJZkfBXIJdkB+CDc0qladQD7fyohX9L3uol8ny8OTlwCf6Eg5P
         Tfdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694608617; x=1695213417;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x+9MtCGEueIzcQpF/feyfAWnqDz9Etq09hyqW4Rc828=;
        b=TLDTwpa6agj6cYTf0nXcHwbmA/xzf8UCMCUi1dBMWKgq3wCs121qMmWpuUbn61hdRg
         BTIbHKswbw8fzpwIzSTLKvO6EMt76Fhp6lftrS9ciEiJbl7J3LzhOOimvTFCrGzuA3qK
         77AMTeJfq7nRMKcaI1Rdh4cmduqB5D0CGc7E9bF8SkbCBVSZ9QhLWMl5ZlEaQe5qHoYO
         U1r3yGebyCdsBnq7WmT03Q7p7ZRg0sKBL7TLqI4Pm4lmkF2Ypto2Y4wprDWP2580qa6b
         XhSKuiTYeQGqVD+sXuwjesnOlJn6P4Sh+xV2JEYtnu/9uQbLB+doBgfuJ3SoiXxC/hBK
         aTFg==
X-Gm-Message-State: AOJu0YxvX55b0I4fHgL0rY18stPETmGStObpi1ZpfsmsIVpK1qI3URjE
        tg4ndTr76nsC5wriVCHOOjJqMg7Z9AOne9fxmqQ=
X-Google-Smtp-Source: AGHT+IHja35eyM2w6DM8prbQrCFJxW9MQxkLI97jHjz96wdOf2zYulupSJPYBTFWVCdbAhq5aUfc6Q==
X-Received: by 2002:a05:620a:3881:b0:76e:e352:667a with SMTP id qp1-20020a05620a388100b0076ee352667amr1775918qkn.35.1694608617245;
        Wed, 13 Sep 2023 05:36:57 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-134-41-202-196.dhcp-dynamic.fibreop.ns.bellaliant.net. [134.41.202.196])
        by smtp.gmail.com with ESMTPSA id o14-20020ae9f50e000000b0076cdb0afbc4sm3870133qkg.118.2023.09.13.05.36.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Sep 2023 05:36:56 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qgP72-002Rzs-3w;
        Wed, 13 Sep 2023 09:36:56 -0300
Date:   Wed, 13 Sep 2023 09:36:56 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Cong Liu <liucong2@kylinos.cn>
Cc:     alex.williamson@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix build error in function vfio_combine_iova_ranges
Message-ID: <ZQGs6F5y3YzlAJaL@ziepe.ca>
References: <20230911124431.5e09f53b.alex.williamson@redhat.com>
 <20230912010736.19481-1-liucong2@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230912010736.19481-1-liucong2@kylinos.cn>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 12, 2023 at 09:07:36AM +0800, Cong Liu wrote:
> when compiling with smatch check, the following errors were encountered:
> 
> drivers/vfio/vfio_main.c:957 vfio_combine_iova_ranges() error: uninitialized symbol 'last'.
> drivers/vfio/vfio_main.c:978 vfio_combine_iova_ranges() error: potentially dereferencing uninitialized 'comb_end'.
> drivers/vfio/vfio_main.c:978 vfio_combine_iova_ranges() error: potentially dereferencing uninitialized 'comb_start'.
> 
> this patch fix these error.
> 
> Signed-off-by: Cong Liu <liucong2@kylinos.cn>
> ---
>  drivers/vfio/vfio_main.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 40732e8ed4c6..68a0a5081161 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -938,12 +938,13 @@ static int vfio_ioctl_device_feature_migration(struct vfio_device *device,
>  void vfio_combine_iova_ranges(struct rb_root_cached *root, u32 cur_nodes,
>  			      u32 req_nodes)
>  {
> -	struct interval_tree_node *prev, *curr, *comb_start, *comb_end;
> +	struct interval_tree_node *prev, *curr;
> +	struct interval_tree_node *comb_start = NULL, *comb_end = NULL;
>  	unsigned long min_gap, curr_gap;
>  
>  	/* Special shortcut when a single range is required */
>  	if (req_nodes == 1) {
> -		unsigned long last;
> +		unsigned long last = 0;
>  
>  		comb_start = interval_tree_iter_first(root, 0, ULONG_MAX);
>  		curr = comb_start;

These are not possible unless the list is empty, and assigning
zero/null isn't an improvement for that case it will just crash

Jason
