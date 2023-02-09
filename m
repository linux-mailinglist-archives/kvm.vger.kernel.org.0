Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3FB69125C
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 22:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbjBIVEg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 16:04:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjBIVEe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 16:04:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 032A868AE2
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 13:03:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675976627;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qIdDl4sb/kHltyB1pTIsGIZn+V2R9TD3LTnjCz8KKnE=;
        b=iarT46TR3vQqD3OtZTuAYo3RyxZj5PUpu1Sup7dnWcokx87jKiX8Tn7iNJuvqQ5RUGX6cT
        RHqX6QTY3J4FlNWtfw99aj87k5yMGFQ31yJi2POfRQSyoSuim9PaL/7zmsdng9K93H0p9L
        iNp0qs3P8nM8AVdvgANxXcR9xBUqvEw=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-65-N1G8vYJGM0awX7QCZQxg_A-1; Thu, 09 Feb 2023 16:03:46 -0500
X-MC-Unique: N1G8vYJGM0awX7QCZQxg_A-1
Received: by mail-il1-f200.google.com with SMTP id 9-20020a056e0220c900b0030f1b0dfa9dso2502062ilq.4
        for <kvm@vger.kernel.org>; Thu, 09 Feb 2023 13:03:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qIdDl4sb/kHltyB1pTIsGIZn+V2R9TD3LTnjCz8KKnE=;
        b=lUfdDvTgiWmxBoW9lVsfcuJY6WmrNkqXyL+LRFFvGqECZ6eP4mvntMZpykjEJXdbjX
         Rvz5SRRiMoZRlqqlFhXOxaHUHXWLoe6efGIJPHq49z6Nd/wxBsaQOcMDCmrnyu0aYlOO
         9Nsjrc9UsLH5of/7Z7HY9rYJVVVvsa6IEHXCFzlXLm+7DEYbXHXOtCnonqLueLiz8fSe
         2gm3eWv+4yNyRwh9qnOnRXVZmaUzv+JsvU2ERRC+n/0dVQdGraAeJDk/yaEIdGKUpooY
         vdLxgo5CElHPN5iBjduDfVLIUR2V5MTogYo3ZZQNgo4pr/dKuANodxwJrEswUHrxP35+
         nUNw==
X-Gm-Message-State: AO0yUKVLdkjXIELy9kbjVUixxtfct3Zh7e3TFKzJCNLI6dVAvK7pgrlp
        GCj1pPMa0RQ9w96633R59n+EoZKZpCbtSoN0pLNnIMGtOHpnqaJqd81xWZ53CW9CK46O693l1iB
        BYywiQitx4asQ
X-Received: by 2002:a6b:4a12:0:b0:71b:5cd7:fcd9 with SMTP id w18-20020a6b4a12000000b0071b5cd7fcd9mr9507820iob.20.1675976625419;
        Thu, 09 Feb 2023 13:03:45 -0800 (PST)
X-Google-Smtp-Source: AK7set8DabN9nmtvkJJHBsDrNcO8eeXmNBjd8CKJ6pDlLRLG7qhvII9EZ+/XOXQYhxgLrBOwWtI17Q==
X-Received: by 2002:a6b:4a12:0:b0:71b:5cd7:fcd9 with SMTP id w18-20020a6b4a12000000b0071b5cd7fcd9mr9507808iob.20.1675976625137;
        Thu, 09 Feb 2023 13:03:45 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id c5-20020a5ea905000000b0071cbf191687sm698346iod.55.2023.02.09.13.03.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 13:03:44 -0800 (PST)
Date:   Thu, 9 Feb 2023 14:03:20 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <jgg@nvidia.com>, <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <maorg@nvidia.com>, <avihaih@nvidia.com>
Subject: Re: [PATCH vfio] vfio/mlx5: Fix range size calculation upon tracker
 creation
Message-ID: <20230209140320.3521cf73.alex.williamson@redhat.com>
In-Reply-To: <20230208152234.32370-1-yishaih@nvidia.com>
References: <20230208152234.32370-1-yishaih@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 8 Feb 2023 17:22:34 +0200
Yishai Hadas <yishaih@nvidia.com> wrote:

> Fix range size calculation to include the last byte of each range.
> 
> In addition, log round up the length of the total ranges to be stricter.
> 
> Fixes: c1d050b0d169 ("vfio/mlx5: Create and destroy page tracker object")
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  drivers/vfio/pci/mlx5/cmd.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
> index 5161d845c478..deed156e6165 100644
> --- a/drivers/vfio/pci/mlx5/cmd.c
> +++ b/drivers/vfio/pci/mlx5/cmd.c
> @@ -830,7 +830,7 @@ static int mlx5vf_create_tracker(struct mlx5_core_dev *mdev,
>  	node = interval_tree_iter_first(ranges, 0, ULONG_MAX);
>  	for (i = 0; i < num_ranges; i++) {
>  		void *addr_range_i_base = range_list_ptr + record_size * i;
> -		unsigned long length = node->last - node->start;
> +		unsigned long length = node->last - node->start + 1;
>  
>  		MLX5_SET64(page_track_range, addr_range_i_base, start_address,
>  			   node->start);
> @@ -840,7 +840,7 @@ static int mlx5vf_create_tracker(struct mlx5_core_dev *mdev,
>  	}
>  
>  	WARN_ON(node);
> -	log_addr_space_size = ilog2(total_ranges_len);
> +	log_addr_space_size = ilog2(roundup_pow_of_two(total_ranges_len));
>  	if (log_addr_space_size <
>  	    (MLX5_CAP_ADV_VIRTUALIZATION(mdev, pg_track_log_min_addr_space)) ||
>  	    log_addr_space_size >

Applied to vfio next branch for v6.3.  Thanks,

Alex

