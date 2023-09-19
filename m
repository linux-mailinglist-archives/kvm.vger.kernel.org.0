Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E09A7A566C
	for <lists+kvm@lfdr.de>; Tue, 19 Sep 2023 02:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbjISAC0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 20:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbjISACZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 20:02:25 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECDB79B
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 17:02:17 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id 6a1803df08f44-6563fe128efso13154646d6.3
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 17:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1695081737; x=1695686537; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CCJJzfg2EU4sdimz+f4BBAfZOdlEW4gvV76ebOvr24U=;
        b=ZoQvfRDm7IP+/rJcKtrAiSuUPUkCcVIHgYVHgxh1JSLa+HGcGw16W/uGelOoXpuLoZ
         okU9Io9iOZUcobE8aVSRxDJ/0ud7kiBrWbceB/641Jbk+X3J9PzI2W6UVfFQwpATHMay
         yvpfLhTQZAElo/0yrSp40YIlWxJ/ajZYVtMQ1nrauy55c8EeQ1Q/6UBfECCj45GATJtn
         vu1diTLINJ40zYZy7wfhz15ByA4zC4vTl+ZXgk+txKZrLwIvMtVBTlRj0iQD9PJ+fH+V
         tLgMvjW2lpb1VpkAVITq9oq8LJl+tn2su1A9+9gqiMr4r2cepsf5PY/dUutJMYDU5ZJf
         KCow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695081737; x=1695686537;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CCJJzfg2EU4sdimz+f4BBAfZOdlEW4gvV76ebOvr24U=;
        b=T9Lsb6lZzfJ9bX1kaC7rfEeudtMQnPg+9jeSKbD9kzRNS6qN3YIXvUgaVhjPUx/uWl
         Nn/cGBylPs7Nt3H/zSdB4bas1J+BBpmzaXDrIVbE/wh3JRYgmgIetyYvi7Zbm7CCgR+Q
         aLBzo0LqLi97vxUkKa/uwmr6PesiEoBykmRKaajZZOgDBIKKFZOFFVRbvDDV0+68KF9L
         6V7scui8sgL7ofl2WBb5tkS1cc0iYISydjY/6kXc0RQxpx8wXiGkwR2KgkJ+bxrkHRZI
         4i3P0nFZf454Zg5LQYQEZBO8c/ciX/76vmYME7oNVzMa/+gmYdxYZtnTaRDc731giHoG
         LXgw==
X-Gm-Message-State: AOJu0YyHCA1zezZQV+/hkXX8QJuxPB6EJALv2BjgNnvw58dvwK/4/kVs
        ryZJbXDVJf/Y0zEk0y1Du1egew==
X-Google-Smtp-Source: AGHT+IHZK8ksaku7q5ZtkfGk6zoccQ0ydOzYFNc+6AUv/DMAbyBo1Gk2KHg9BdSMNR0Nq+WthcCj4A==
X-Received: by 2002:a0c:db83:0:b0:657:5372:ac0d with SMTP id m3-20020a0cdb83000000b006575372ac0dmr5192825qvk.38.1695081736995;
        Mon, 18 Sep 2023 17:02:16 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-26-201.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.26.201])
        by smtp.gmail.com with ESMTPSA id n18-20020a0ce492000000b0064713c8fab7sm600289qvl.59.2023.09.18.17.02.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 17:02:16 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qiOBz-000834-UF;
        Mon, 18 Sep 2023 21:02:15 -0300
Date:   Mon, 18 Sep 2023 21:02:15 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Shannon Nelson <shannon.nelson@amd.com>,
        alex.williamson@redhat.com, kevin.tian@intel.com,
        reinette.chatre@intel.com, kvm@vger.kernel.org,
        brett.creeley@amd.com, linux-kernel@vger.kernel.org,
        Leon Romanovsky <leonro@nvidia.com>
Subject: Re: [PATCH vfio] vfio/pci: remove msi domain on msi disable
Message-ID: <20230919000215.GQ13795@ziepe.ca>
References: <20230914191406.54656-1-shannon.nelson@amd.com>
 <20230918141705.GE13795@ziepe.ca>
 <87led3xqye.ffs@tglx>
 <20230918233735.GP13795@ziepe.ca>
 <87a5tjxcva.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a5tjxcva.ffs@tglx>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 19, 2023 at 01:47:37AM +0200, Thomas Gleixner wrote:
> On Mon, Sep 18 2023 at 20:37, Jason Gunthorpe wrote:
> > On Mon, Sep 18, 2023 at 08:43:21PM +0200, Thomas Gleixner wrote:
> >> On Mon, Sep 18 2023 at 11:17, Jason Gunthorpe wrote:
> >> > On Thu, Sep 14, 2023 at 12:14:06PM -0700, Shannon Nelson wrote:
> >> >> The new MSI dynamic allocation machinery is great for making the irq
> >> >> management more flexible.  It includes caching information about the
> >> >> MSI domain which gets reused on each new open of a VFIO fd.  However,
> >> >> this causes an issue when the underlying hardware has flexible MSI-x
> >> >> configurations, as a changed configuration doesn't get seen between
> >> >> new opens, and is only refreshed between PCI unbind/bind cycles.
> >> >> 
> >> >> In our device we can change the per-VF MSI-x resource allocation
> >> >> without the need for rebooting or function reset.  For example,
> >> >> 
> >> >>   1. Initial power up and kernel boot:
> >> >> 	# lspci -s 2e:00.1 -vv | grep MSI-X
> >> >> 	        Capabilities: [a0] MSI-X: Enable+ Count=8 Masked-
> >> >> 
> >> >>   2. Device VF configuration change happens with no reset
> >> >
> >> > Is this an out of tree driver problem?
> >> >
> >> > The intree way to alter the MSI configuration is via
> >> > sriov_set_msix_vec_count, and there is only one in-tree driver that
> >> > uses it right now.
> >> 
> >> Right, but that only addresses the driver specific issues.
> >
> > Sort of.. sriov_vf_msix_count_store() is intended to be the entry
> > point for this and if the kernel grows places that cache the value or
> > something then this function should flush those caches too.
> 
> Sorry. What I wanted to say is that the driver callback is not the right
> place to reload the MSI domains after the change.

Oh, that isn't even what Shannon's patch does, it patched VFIO's main
PCI driver - not a sriov_set_msix_vec_count() callback :( Shannon's
scenario doesn't even use sriov_vf_msix_count_store() at all - the AMD
device just randomly changes its MSI count whenever it likes.

> > I suppose flushing happens implicitly because Shannon reports that
> > things work fine if the driver is rebound. Since
> > sriov_vf_msix_count_store() ensures there is no driver bound before
> > proceeding it probe/unprobe must be flushing out everything?
> 
> Correct. So sriov_set_msix_vec_count() could just do:
> 
> 	ret = pdev->driver->sriov_set_msix_vec_count(vf_dev, val);
>         if (!ret)
>         	teardown_msi_domain(pdev);
>
> Right?

It subtly isn't needed, sriov_vf_msix_count_store() already requires
no driver is associated with the device and this:

int msi_setup_device_data(struct device *dev)
{
	struct msi_device_data *md;
	int ret, i;

	if (dev->msi.data)
		return 0;

	md = devres_alloc(msi_device_data_release, sizeof(*md), GFP_KERNEL);
	if (!md)
		return -ENOMEM;

Already ensured that msi_remove_device_irq_domain() was called via
msi_device_data_release() triggering as part of the devm shutdown of
the bound driver.

So, the intree mechanism to change the MSI vector size works. The
crazy mechanism where the device just changes its value without
synchronizing to the OS does not.

I don't think we need to try and fix that..

Jason
