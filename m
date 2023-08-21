Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA959782F04
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 19:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236903AbjHUREn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 13:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236867AbjHUREn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 13:04:43 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC15EC
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 10:04:41 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id 6a1803df08f44-6490c2c4702so18261936d6.2
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 10:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1692637480; x=1693242280;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=N09QE0C3lW8oGWF50bQOxZXPyK36qtYOYonsxv0HH8c=;
        b=W8UiYFg+/p47ajmvb6c1GFVVsTww14hmsjS5g9VC4iS2FHmq5Kh2J4UXCkjHEV2psl
         wOnx7oxSVJMPy87Jhn+p/NmwbERhsnldbAJss4S/NI39ueJJE3zW0AlKAPZ1xL7/5RWE
         ZmAKI6n90zrXzrNKDL22m3mDMYky5E6pY9IDza2nNh92AXqoQQtwzfBMGtLzId4zpzf6
         cqqfU6USK+z9/mpRopcvcmWHGSCak6EZxzEUMDK0bepYk8UrqpqCrsO9h4NhxMJm0Ri6
         BYJy5qoIh2ZLiXuISwm8iYIwh/bXAZRTBxunmW2e1/CZcg/8bpG+tPoRTTHRR+susG1M
         6gCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692637480; x=1693242280;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N09QE0C3lW8oGWF50bQOxZXPyK36qtYOYonsxv0HH8c=;
        b=MPJXcWOwOp3cu099ZQLXKgHBKUvg8TRF4FTDPEhzRU5L3XIB0mhzrwTmuXeDzEF4SL
         YviDvXQ2uhVRvj6hZxFv1qYsNfglzoEUbrKXeX9LVCMccg5jk4cX35WupS4CZdop8i1w
         uE9AGzTf59cwWhnqedaewtGkpC4n3y0tFuPh+y0F42JoYGi0+/IjeMhI6HkRYKmj7eIT
         NcrT7EC0JYFg8GC4rFina/Flg0MCIICLYAE8y2jZZQN+9MNsGqc9GKnhR7CcP0RbzPFq
         8cg9MZQ05nCq2UEHeNwa9QJbqmVSjsrg3896mzBJzdwbW3i8C7T58aDy//I+INqoy+BE
         Yspw==
X-Gm-Message-State: AOJu0YxHaAoOkTDeYCYg7BEhfRtNy2XRhQ4jwKDbRM9k0QrG77wvS2II
        6h3N1u22GdwUuL7AKFdVO3syGA==
X-Google-Smtp-Source: AGHT+IFE3U9YWvQ4iNtyRxFqDyhWmNE+Ii8wn6FvWBNTRn+lXBSa2bgUJEP4lLxtiNKJjpRUuW8z8w==
X-Received: by 2002:a0c:a9d8:0:b0:64f:3b07:c50b with SMTP id c24-20020a0ca9d8000000b0064f3b07c50bmr5161926qvb.43.1692637480297;
        Mon, 21 Aug 2023 10:04:40 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-25-194.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.25.194])
        by smtp.gmail.com with ESMTPSA id i26-20020a05620a145a00b00767b0c35c15sm2590622qkl.91.2023.08.21.10.04.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Aug 2023 10:04:39 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qY8KV-00Duwr-Bb;
        Mon, 21 Aug 2023 14:04:39 -0300
Date:   Mon, 21 Aug 2023 14:04:39 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 05/11] iommu: Merge iopf_device_param into
 iommu_fault_param
Message-ID: <ZOOZJ/aQNKY2UDxj@ziepe.ca>
References: <20230817234047.195194-1-baolu.lu@linux.intel.com>
 <20230817234047.195194-6-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230817234047.195194-6-baolu.lu@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 18, 2023 at 07:40:41AM +0800, Lu Baolu wrote:
> @@ -472,21 +473,31 @@ struct iommu_fault_event {
>   * struct iommu_fault_param - per-device IOMMU fault data
>   * @handler: Callback function to handle IOMMU faults at device level
>   * @data: handler private data
> - * @faults: holds the pending faults which needs response
>   * @lock: protect pending faults list
> + * @dev: the device that owns this param
> + * @queue: IOPF queue
> + * @queue_list: index into queue->devices
> + * @partial: faults that are part of a Page Request Group for which the last
> + *           request hasn't been submitted yet.
> + * @faults: holds the pending faults which needs response
>   */
>  struct iommu_fault_param {
>  	iommu_dev_fault_handler_t handler;
>  	void *data;
> -	struct list_head faults;
> -	struct mutex lock;
> +	struct mutex			lock;
> +
> +	struct device			*dev;
> +	struct iopf_queue		*queue;
> +	struct list_head		queue_list;
> +
> +	struct list_head		partial;
> +	struct list_head		faults;
>  };

Don't add the horizontal spaces

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
-
