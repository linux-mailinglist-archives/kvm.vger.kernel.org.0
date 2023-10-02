Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8937B5D40
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 00:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236211AbjJBWmD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 18:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbjJBWmC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 18:42:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AA6FDC
        for <kvm@vger.kernel.org>; Mon,  2 Oct 2023 15:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696286469;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D2xSQEtCd68G1aNCSdlDa+WBRr7EoF27nGR3sk77yQY=;
        b=IGgFjnOXtmRo0xzfVE+82rUCESvOw/53xUHLRb1y0sHsMNILhseTigvpu/zezxacb+GdFd
        6LbXtafFc63QSjUGnosDl/Exrbcwczfp4BehYlgoZLQ6RL+TeYQeYeKStXjhyZlutuKCYN
        tA+VUzoU0JElFh9WJZcArt6ZL3Ve+zE=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-67-PoQO6lAYMpuGoxPDCWyXEA-1; Mon, 02 Oct 2023 18:41:07 -0400
X-MC-Unique: PoQO6lAYMpuGoxPDCWyXEA-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3527034eb90so975705ab.0
        for <kvm@vger.kernel.org>; Mon, 02 Oct 2023 15:41:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696286467; x=1696891267;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=D2xSQEtCd68G1aNCSdlDa+WBRr7EoF27nGR3sk77yQY=;
        b=OgTH0d6obp96GkTusy4iWzQEQXqZRTCVJE0Vpnt6/TVp24cmpRD9z0LoVLVAqopMIV
         vptmBa7WP6kAagn2t2xR5c4q+PHAOLqXw1rbGo2uVR5NynEBh3Jz3voqZBF3XNwOF9Xm
         0NcS4+AWItEnNtN1r3un2gUBWYOg49ARhu6ol3sq+cHLw4wOEYiiGjDYMrYe50yEvcp7
         YNKMBo8SQ8O9NCXI/gxJFzJQqujGu9tu8y7igtEysIcB0B8U7Ps9mN4XRherMvcFVgXL
         r/1zxCyKasPUAKyVmdMuezNpwzrzD3az+bzzjn3d/Itv2ErbITx2TlpYJ+Kw97dOfbIf
         wKRA==
X-Gm-Message-State: AOJu0YwQP6GApd3twaqKix/PQlUm+pbOZ0unhgIP7YmDDxj+ZlI0Bi7D
        iMu7BdkpVBSyh2ZTe5WieVstfqMd4613MQB/RpLQFDfM3bPodfPVh1cK+WdnV+OqdDtfX8uLEHm
        1PEPrpUPLaUR7
X-Received: by 2002:a05:6e02:1aa7:b0:34f:20d9:74a9 with SMTP id l7-20020a056e021aa700b0034f20d974a9mr810377ilv.11.1696286467168;
        Mon, 02 Oct 2023 15:41:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF3uJ6+Xij+3uBSfC791cYGnO46dgm8Cm3qv4Z8476efJ67xSep+o3RkXpHAOv27ZbeNdhmkg==
X-Received: by 2002:a05:6e02:1aa7:b0:34f:20d9:74a9 with SMTP id l7-20020a056e021aa700b0034f20d974a9mr810362ilv.11.1696286466776;
        Mon, 02 Oct 2023 15:41:06 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id i14-20020a056638380e00b0043cec02791bsm4042088jav.96.2023.10.02.15.41.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Oct 2023 15:41:06 -0700 (PDT)
Date:   Mon, 2 Oct 2023 16:41:03 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Cong Liu <liucong2@kylinos.cn>
Cc:     jgg@ziepe.ca, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] vfio: Fix uninitialized symbol and potential
 dereferencing errors in vfio_combine_iova_ranges
Message-ID: <20231002164103.56e6a2b4.alex.williamson@redhat.com>
In-Reply-To: <20230920095532.88135-1-liucong2@kylinos.cn>
References: <20230919120456.1a68dc4d.alex.williamson@redhat.com>
        <20230920095532.88135-1-liucong2@kylinos.cn>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 20 Sep 2023 17:55:31 +0800
Cong Liu <liucong2@kylinos.cn> wrote:

> when compiling with smatch check, the following errors were encountered:
> 
> drivers/vfio/vfio_main.c:957 vfio_combine_iova_ranges() error: uninitialized symbol 'last'.
> drivers/vfio/vfio_main.c:978 vfio_combine_iova_ranges() error: potentially dereferencing uninitialized 'comb_end'.
> drivers/vfio/vfio_main.c:978 vfio_combine_iova_ranges() error: potentially dereferencing uninitialized 'comb_start'.
> 
> This patch initializes the variables last, comb_end, and comb_start
> to avoid compiler warnings and add proper argument checks to ensure
> interval_tree_iter_first() does not return NULL.
> 
> Signed-off-by: Cong Liu <liucong2@kylinos.cn>
> ---
>  drivers/vfio/vfio_main.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 40732e8ed4c6..ecd4dd8e6b05 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -938,12 +938,17 @@ static int vfio_ioctl_device_feature_migration(struct vfio_device *device,
>  void vfio_combine_iova_ranges(struct rb_root_cached *root, u32 cur_nodes,
>  			      u32 req_nodes)
>  {
> -	struct interval_tree_node *prev, *curr, *comb_start, *comb_end;
> +	if (!cur_nodes || cur_nodes <= req_nodes ||
> +		WARN_ON(!req_nodes || !root->rb_root.rb_node))
> +		return;

Code should not precede variable declaration.  The wrapped line should
align inside the parenthesis of the previous line.

> +
> +	struct interval_tree_node *prev, *curr;
> +	struct interval_tree_node *comb_start = NULL, *comb_end = NULL;

These only mask the issue reported by smatch, should we encounter the
condition where these are used uninitialized, derefencing NULL is only
marginally better.

>  	unsigned long min_gap, curr_gap;
>  
>  	/* Special shortcut when a single range is required */
>  	if (req_nodes == 1) {
> -		unsigned long last;
> +		unsigned long last = 0;

This also masks the actual error, which can only occur from an empty
list which still results in a NULL pointer derefence.  Should we even
make use of @last, a zero value is arbitrary.

I'll follow-up with a patch that I believe better resolves the report.
Thanks,

Alex

>  
>  		comb_start = interval_tree_iter_first(root, 0, ULONG_MAX);
>  		curr = comb_start;

