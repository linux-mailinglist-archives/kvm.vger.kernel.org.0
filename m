Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75D5A7A564E
	for <lists+kvm@lfdr.de>; Tue, 19 Sep 2023 01:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbjIRXrq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 19:47:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjIRXrp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 19:47:45 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81D4890;
        Mon, 18 Sep 2023 16:47:39 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1695080858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zoPrsSaT29FlvfJy1a7+Tv5EMLFoI3yK58qV6pzrQU0=;
        b=PcNpWXyRLqtfgKxGwS3RjJmw8mKIoehQ28WqW/nSnu8PcULPs/9bgk/U5Wv8T2RFOmcxBw
        G8JOscsI6gyYAnfk9AkLfyYe8nrO/+UBS+yuHoW1XT++/o49JTHrhzz0Btuxgmi1UyRwCN
        ncvBBvqmaYf5L32IIvbTFSgXtQHp0+PaKpp+68E02RV6Cw/JsHgkNPcX0VdfLpdz3NWw9u
        4FbcGo2QCEdxAwVIyWtT7sonOeNvMPN8UcJuE9kh749VsYOtfOnMecslg8gRTCKUAQiJEa
        xc97v9uQHYWx5vk2eB0ZbDxs4mv2BG1gPAkZmk/elPSZmWBgw0tJfHDaN4wRww==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1695080858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zoPrsSaT29FlvfJy1a7+Tv5EMLFoI3yK58qV6pzrQU0=;
        b=KrDZUpg4xWw9c5L6hoeA9PpnHq/wBo4OOWV+Y48eEgzi4zdat8V0DRpd+O/vVeOrXbzam6
        rhwYgn4l9dm1yjCw==
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Shannon Nelson <shannon.nelson@amd.com>,
        alex.williamson@redhat.com, kevin.tian@intel.com,
        reinette.chatre@intel.com, kvm@vger.kernel.org,
        brett.creeley@amd.com, linux-kernel@vger.kernel.org,
        Leon Romanovsky <leonro@nvidia.com>
Subject: Re: [PATCH vfio] vfio/pci: remove msi domain on msi disable
In-Reply-To: <20230918233735.GP13795@ziepe.ca>
References: <20230914191406.54656-1-shannon.nelson@amd.com>
 <20230918141705.GE13795@ziepe.ca> <87led3xqye.ffs@tglx>
 <20230918233735.GP13795@ziepe.ca>
Date:   Tue, 19 Sep 2023 01:47:37 +0200
Message-ID: <87a5tjxcva.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 18 2023 at 20:37, Jason Gunthorpe wrote:
> On Mon, Sep 18, 2023 at 08:43:21PM +0200, Thomas Gleixner wrote:
>> On Mon, Sep 18 2023 at 11:17, Jason Gunthorpe wrote:
>> > On Thu, Sep 14, 2023 at 12:14:06PM -0700, Shannon Nelson wrote:
>> >> The new MSI dynamic allocation machinery is great for making the irq
>> >> management more flexible.  It includes caching information about the
>> >> MSI domain which gets reused on each new open of a VFIO fd.  However,
>> >> this causes an issue when the underlying hardware has flexible MSI-x
>> >> configurations, as a changed configuration doesn't get seen between
>> >> new opens, and is only refreshed between PCI unbind/bind cycles.
>> >> 
>> >> In our device we can change the per-VF MSI-x resource allocation
>> >> without the need for rebooting or function reset.  For example,
>> >> 
>> >>   1. Initial power up and kernel boot:
>> >> 	# lspci -s 2e:00.1 -vv | grep MSI-X
>> >> 	        Capabilities: [a0] MSI-X: Enable+ Count=8 Masked-
>> >> 
>> >>   2. Device VF configuration change happens with no reset
>> >
>> > Is this an out of tree driver problem?
>> >
>> > The intree way to alter the MSI configuration is via
>> > sriov_set_msix_vec_count, and there is only one in-tree driver that
>> > uses it right now.
>> 
>> Right, but that only addresses the driver specific issues.
>
> Sort of.. sriov_vf_msix_count_store() is intended to be the entry
> point for this and if the kernel grows places that cache the value or
> something then this function should flush those caches too.

Sorry. What I wanted to say is that the driver callback is not the right
place to reload the MSI domains after the change.

> I suppose flushing happens implicitly because Shannon reports that
> things work fine if the driver is rebound. Since
> sriov_vf_msix_count_store() ensures there is no driver bound before
> proceeding it probe/unprobe must be flushing out everything?

Correct. So sriov_set_msix_vec_count() could just do:

	ret = pdev->driver->sriov_set_msix_vec_count(vf_dev, val);
        if (!ret)
        	teardown_msi_domain(pdev);

Right?

Thanks,

        tglx
