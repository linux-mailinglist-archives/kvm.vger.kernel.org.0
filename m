Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E35FE6220FB
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 01:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbiKIAxe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 19:53:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiKIAxd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 19:53:33 -0500
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 287652702
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 16:53:30 -0800 (PST)
Received: by mail-qv1-xf2e.google.com with SMTP id c8so11372821qvn.10
        for <kvm@vger.kernel.org>; Tue, 08 Nov 2022 16:53:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=d82Es4PSKkiioF1X1622Snj3lQ/kTMq5PpOjHENZGGY=;
        b=J3vDj+upaueE79jWlk3PKA5LX85CdOXFQvMLX4qY+W0fMzC7u+gRrfaXI7+s/1Jmsq
         lzEd68ZI0MU6WIBT48G8rN1SM0QEwirdTkJjDVgwtspLrX8Lg57NvzdY56QqiWugvpDY
         MltCztZhCY2b399VkNaVERgyZ2xl5DRVPLgTNv7/EuB70CzMjASU951inGt5Vbgj3uxb
         orIYRRLwCvE4yghw0ocWzqXr4MPSHJjX7c6r1fpW2he05ynMEeJwraGkPyVBFXeD0Qyd
         vrzGa/Hlc4xPzcHDWBTFEV3JjLsUNnDHqdZ4pXasjiikWHoLzOfFBVsWEStJVJ/DN/td
         nl6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d82Es4PSKkiioF1X1622Snj3lQ/kTMq5PpOjHENZGGY=;
        b=uQsXDegMr08t1ZUhYuEUKMa/fx7gfVNMPCRcxP9/8Pq5/m7cHMKs9A8QwVYEF2DM+G
         U8PEqmcI8BNhT/EiSfLC5CbEr5qFhOsiMuzGknPiZhQVZoSe3x2dTpUA0FbpJFIdOxBY
         nU6jFWYMY1DyeC5v68z1PsjeQHkQP9vaY5now1Yc+StQ1PExjbtHQM5OZAY3FpzEavUl
         zvQqontEBtPoscyRrOHYTczTXWEbqlOfGxcKw64AQLm4B3yl3YWtsvjZwFvNMRfba26V
         UeDwwVjwn8GqCO+KIiJAA/u/56wqpM5fnnfqnENOYVxQdn5NMrP8cYr+6UKcS3dlA16i
         2i2A==
X-Gm-Message-State: ACrzQf3cju0CUGp6hhTtfcov0+jq3l70NeENGZOwssu5SMMWxtLLEImR
        a0YdOp/Nm8WZTMNrgC1vRHnaAtjxpmH8NQ==
X-Google-Smtp-Source: AMsMyM77tLoFyaJo4abmmZhB9uAy4jPGIYwn6h5voAWkMt64Ks0PwWXTXOJuqtqsu7RehRY11AV3ww==
X-Received: by 2002:ad4:4ea3:0:b0:4bb:6b59:9785 with SMTP id ed3-20020ad44ea3000000b004bb6b599785mr50985137qvb.118.1667955209298;
        Tue, 08 Nov 2022 16:53:29 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-122-23.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.122.23])
        by smtp.gmail.com with ESMTPSA id ge17-20020a05622a5c9100b0039cc64bcb53sm9016176qtb.27.2022.11.08.16.53.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 16:53:28 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1osZLM-00HZwO-4P;
        Tue, 08 Nov 2022 20:53:28 -0400
Date:   Tue, 8 Nov 2022 20:53:28 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Anthony DeRossi <ajderossi@gmail.com>
Cc:     kvm@vger.kernel.org, alex.williamson@redhat.com, cohuck@redhat.com,
        kevin.tian@intel.com, abhsahu@nvidia.com, yishaih@nvidia.com
Subject: Re: [PATCH v5 3/3] vfio/pci: Check the device set open count on reset
Message-ID: <Y2r6CK0vECccN+sd@ziepe.ca>
References: <20221105224458.8180-1-ajderossi@gmail.com>
 <20221105224458.8180-4-ajderossi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221105224458.8180-4-ajderossi@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Nov 05, 2022 at 03:44:58PM -0700, Anthony DeRossi wrote:
> vfio_pci_dev_set_needs_reset() inspects the open_count of every device
> in the set to determine whether a reset is allowed. The current device
> always has open_count == 1 within vfio_pci_core_disable(), effectively
> disabling the reset logic. This field is also documented as private in
> vfio_device, so it should not be used to determine whether other devices
> in the set are open.
> 
> Checking for vfio_device_set_open_count() > 1 on the device set fixes
> both issues.
> 
> After commit 2cd8b14aaa66 ("vfio/pci: Move to the device set
> infrastructure"), failure to create a new file for a device would cause
> the reset to be skipped due to open_count being decremented after
> calling close_device() in the error path.
> 
> After commit eadd86f835c6 ("vfio: Remove calls to
> vfio_group_add_container_user()"), releasing a device would always skip
> the reset due to an ordering change in vfio_device_fops_release().
> 
> Failing to reset the device leaves it in an unknown state, potentially
> causing errors when it is accessed later or bound to a different driver.
> 
> This issue was observed with a Radeon RX Vega 56 [1002:687f] (rev c3)
> assigned to a Windows guest. After shutting down the guest, unbinding
> the device from vfio-pci, and binding the device to amdgpu:
> 
> [  548.007102] [drm:psp_hw_start [amdgpu]] *ERROR* PSP create ring failed!
> [  548.027174] [drm:psp_hw_init [amdgpu]] *ERROR* PSP firmware loading failed
> [  548.027242] [drm:amdgpu_device_fw_loading [amdgpu]] *ERROR* hw_init of IP block <psp> failed -22
> [  548.027306] amdgpu 0000:0a:00.0: amdgpu: amdgpu_device_ip_init failed
> [  548.027308] amdgpu 0000:0a:00.0: amdgpu: Fatal error during GPU init
> 
> Fixes: 2cd8b14aaa66 ("vfio/pci: Move to the device set infrastructure")
> Fixes: eadd86f835c6 ("vfio: Remove calls to vfio_group_add_container_user()")
> Signed-off-by: Anthony DeRossi <ajderossi@gmail.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
