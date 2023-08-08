Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0436D774E3F
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 00:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbjHHW2G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 18:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbjHHW2F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 18:28:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3466CFD
        for <kvm@vger.kernel.org>; Tue,  8 Aug 2023 15:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691533641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LS2hQB9R/gfYolj4n3pgnprtQV1NYx7Ai3v+Uc3CcP4=;
        b=Kuk0aGjR7iKEX1yhHO/Er9Ph5lUdFVdgflhzwS9ysMXmMyr6U3hwPuI4rKaOl0xskvtu3q
        C/iWlT3vjsrAT7kZ1KRf6v1WJQG3BGqSDbZ3KtubS3BDXgf4wkJRQolXM/HY2XptT+HcOJ
        Ft3+J6kNbEI2sa4CT0zKtRgNJjtjxlo=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-299-J5p09ciuMLyGEIQYf_lBBw-1; Tue, 08 Aug 2023 18:27:20 -0400
X-MC-Unique: J5p09ciuMLyGEIQYf_lBBw-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-77e41268d40so556885539f.3
        for <kvm@vger.kernel.org>; Tue, 08 Aug 2023 15:27:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691533639; x=1692138439;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LS2hQB9R/gfYolj4n3pgnprtQV1NYx7Ai3v+Uc3CcP4=;
        b=gaS841Lt2J8knxQA18S9oqBkrR9WC6++d32OHBHWT6779ewmhMRhccUqGAahIobyi0
         Lj+woizKNWWkxr5KwA77xzAcx+FuUUjnGX74ISd3+2fKan6ZA6HqA0PIMK9CELYpXd4d
         VPcLNXYsk6xeNyQNBVRoPZpFD0tu9xTOpnAk0qRmMay5ZF0TEaxHjkYu83KmBk01U2tD
         C62ozK0TM/Cjm91z7F/+lS/tOGU3dI9kduZEEp43Xwx3kzypB3+LOl3cOA1rsXMQH2ff
         SMWtxjiq99EMVA1t9Ybbnn18MFviU6tc51LBmCjVAXEbGANZ9fuhnWPSCQ/61lVHx7Rn
         IHlQ==
X-Gm-Message-State: AOJu0YyVSoaUTfpcZKtNdiaRPi8yk/YuUEDKxq9QFd/xL9WS7jY9EBhM
        rqtJQHyW1xUgPpVk1qAlqzq7++dys9UVgDFD38ZVcnoJEXLSPiqPgUhDBL+GLPHDyDoiXcnk8jl
        ZGbo5kR6WQ6Oy
X-Received: by 2002:a6b:4001:0:b0:790:fef5:cfb9 with SMTP id k1-20020a6b4001000000b00790fef5cfb9mr923531ioa.17.1691533639430;
        Tue, 08 Aug 2023 15:27:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFlOuiai4O8jd3irmxcEONHOFmltNRIOgEgClBNjaAYXusMuIQ+KwHAmDtmBejNjjdLlJLpTw==
X-Received: by 2002:a6b:4001:0:b0:790:fef5:cfb9 with SMTP id k1-20020a6b4001000000b00790fef5cfb9mr923513ioa.17.1691533639189;
        Tue, 08 Aug 2023 15:27:19 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id f6-20020a02b786000000b0042b91ec7e31sm3465234jam.3.2023.08.08.15.27.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Aug 2023 15:27:18 -0700 (PDT)
Date:   Tue, 8 Aug 2023 16:27:18 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Brett Creeley <brett.creeley@amd.com>
Cc:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>, <horms@kernel.org>,
        <shannon.nelson@amd.com>
Subject: Re: [PATCH v14 vfio 6/8] vfio/pds: Add support for dirty page
 tracking
Message-ID: <20230808162718.2151e175.alex.williamson@redhat.com>
In-Reply-To: <20230807205755.29579-7-brett.creeley@amd.com>
References: <20230807205755.29579-1-brett.creeley@amd.com>
        <20230807205755.29579-7-brett.creeley@amd.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 7 Aug 2023 13:57:53 -0700
Brett Creeley <brett.creeley@amd.com> wrote:
...
> +static int pds_vfio_dirty_enable(struct pds_vfio_pci_device *pds_vfio,
> +				 struct rb_root_cached *ranges, u32 nnodes,
> +				 u64 *page_size)
> +{
> +	struct pci_dev *pdev = pds_vfio->vfio_coredev.pdev;
> +	struct device *pdsc_dev = &pci_physfn(pdev)->dev;
> +	struct pds_vfio_dirty *dirty = &pds_vfio->dirty;
> +	u64 region_start, region_size, region_page_size;
> +	struct pds_lm_dirty_region_info *region_info;
> +	struct interval_tree_node *node = NULL;
> +	u8 max_regions = 0, num_regions;
> +	dma_addr_t regions_dma = 0;
> +	u32 num_ranges = nnodes;
> +	u32 page_count;
> +	u16 len;
> +	int err;
> +
> +	dev_dbg(&pdev->dev, "vf%u: Start dirty page tracking\n",
> +		pds_vfio->vf_id);
> +
> +	if (pds_vfio_dirty_is_enabled(pds_vfio))
> +		return -EINVAL;
> +
> +	/* find if dirty tracking is disabled, i.e. num_regions == 0 */
> +	err = pds_vfio_dirty_status_cmd(pds_vfio, 0, &max_regions,
> +					&num_regions);
> +	if (err < 0) {
> +		dev_err(&pdev->dev, "Failed to get dirty status, err %pe\n",
> +			ERR_PTR(err));
> +		return err;
> +	} else if (num_regions) {
> +		dev_err(&pdev->dev,
> +			"Dirty tracking already enabled for %d regions\n",
> +			num_regions);
> +		return -EEXIST;
> +	} else if (!max_regions) {
> +		dev_err(&pdev->dev,
> +			"Device doesn't support dirty tracking, max_regions %d\n",
> +			max_regions);
> +		return -EOPNOTSUPP;
> +	}
> +
> +	/*
> +	 * Only support 1 region for now. If there are any large gaps in the
> +	 * VM's address regions, then this would be a waste of memory as we are
> +	 * generating 2 bitmaps (ack/seq) from the min address to the max
> +	 * address of the VM's address regions. In the future, if we support
> +	 * more than one region in the device/driver we can split the bitmaps
> +	 * on the largest address region gaps. We can do this split up to the
> +	 * max_regions times returned from the dirty_status command.
> +	 */

Isn't this a pretty unfortunately limitation given QEMU makes a 1TB
hole on AMD hosts?  Or maybe I misunderstand.

https://gitlab.com/qemu-project/qemu/-/commit/8504f129450b909c88e199ca44facd35d38ba4de

Thanks,
Alex

