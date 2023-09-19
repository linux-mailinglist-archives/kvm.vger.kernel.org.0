Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4DBE7A568B
	for <lists+kvm@lfdr.de>; Tue, 19 Sep 2023 02:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbjISAZk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 20:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjISAZk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 20:25:40 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C58108E;
        Mon, 18 Sep 2023 17:25:34 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1695083133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UtdQF5K+1l0ENXntUVNj4BS3SxZvs83N54x6+7JhxdQ=;
        b=VPWQdq3yXUWysjn6WiIh+IrT0eDRKqnKbp/TjGW24UoIUG4R+SIscUN1KsaFwBoCC6VCpp
        hOw7iNJmLCcyBj/I//sUIoU5Jtzackmjsvhz059Tf0CYoJhYWjgnnLLfQQ/Ol1e4+zS7MP
        KPLmo/wnLulki9pM9ZFOfbvU1bCai6KIk/o0PsIkhM1lQmpcYX0hTa1QsRLFeidj+1iLSQ
        kl6YEE6/omuaEQE1rYBDTi6KEIq8Lnbzky/eJhZGec+ytWrEHwJDNK/ylH63Cz7rKJ3QDG
        0qOnSp4aNo75gw4gwipnU9OR3Cqb8l/zrFISMp2Uf8PAaM0zsowNtZjG8gUoyw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1695083133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UtdQF5K+1l0ENXntUVNj4BS3SxZvs83N54x6+7JhxdQ=;
        b=rcJB7qjlq6ul/jZ8EG1DAn0R4wg74zv0IkkxKnuf8uML/MnZgPVLhR846BiiPsjSiUPJnd
        V6FzqugZuNBURXDQ==
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Shannon Nelson <shannon.nelson@amd.com>,
        alex.williamson@redhat.com, kevin.tian@intel.com,
        reinette.chatre@intel.com, kvm@vger.kernel.org,
        brett.creeley@amd.com, linux-kernel@vger.kernel.org,
        Leon Romanovsky <leonro@nvidia.com>
Subject: Re: [PATCH vfio] vfio/pci: remove msi domain on msi disable
In-Reply-To: <20230919000215.GQ13795@ziepe.ca>
References: <20230914191406.54656-1-shannon.nelson@amd.com>
 <20230918141705.GE13795@ziepe.ca> <87led3xqye.ffs@tglx>
 <20230918233735.GP13795@ziepe.ca> <87a5tjxcva.ffs@tglx>
 <20230919000215.GQ13795@ziepe.ca>
Date:   Tue, 19 Sep 2023 02:25:32 +0200
Message-ID: <874jjrxb43.ffs@tglx>
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

On Mon, Sep 18 2023 at 21:02, Jason Gunthorpe wrote:
> On Tue, Sep 19, 2023 at 01:47:37AM +0200, Thomas Gleixner wrote:
>> >> > The intree way to alter the MSI configuration is via
>> >> > sriov_set_msix_vec_count, and there is only one in-tree driver that
>> >> > uses it right now.
>> >> 
>> >> Right, but that only addresses the driver specific issues.
>> >
>> > Sort of.. sriov_vf_msix_count_store() is intended to be the entry
>> > point for this and if the kernel grows places that cache the value or
>> > something then this function should flush those caches too.
>> 
>> Sorry. What I wanted to say is that the driver callback is not the right
>> place to reload the MSI domains after the change.
>
> Oh, that isn't even what Shannon's patch does, it patched VFIO's main
> PCI driver - not a sriov_set_msix_vec_count() callback :( Shannon's
> scenario doesn't even use sriov_vf_msix_count_store() at all - the AMD
> device just randomly changes its MSI count whenever it likes.

Ooops. When real hardware changes things behind the kernels back we
consider it a hardware bug. The same applies to virtualization muck.

So all we should do is add some code which yells when the "hardware"
plays silly buggers.

>> > I suppose flushing happens implicitly because Shannon reports that
>> > things work fine if the driver is rebound. Since
>> > sriov_vf_msix_count_store() ensures there is no driver bound before
>> > proceeding it probe/unprobe must be flushing out everything?
>> 
>> Correct. So sriov_set_msix_vec_count() could just do:
>> 
>> 	ret = pdev->driver->sriov_set_msix_vec_count(vf_dev, val);
>>         if (!ret)
>>         	teardown_msi_domain(pdev);
>>
>> Right?
>
> It subtly isn't needed, sriov_vf_msix_count_store() already requires
> no driver is associated with the device and this:
>
> int msi_setup_device_data(struct device *dev)
> {
> 	struct msi_device_data *md;
> 	int ret, i;
>
> 	if (dev->msi.data)
> 		return 0;
>
> 	md = devres_alloc(msi_device_data_release, sizeof(*md), GFP_KERNEL);
> 	if (!md)
> 		return -ENOMEM;
>
> Already ensured that msi_remove_device_irq_domain() was called via
> msi_device_data_release() triggering as part of the devm shutdown of
> the bound driver.

Indeed.

> So, the intree mechanism to change the MSI vector size works. The
> crazy mechanism where the device just changes its value without
> synchronizing to the OS does not.
>
> I don't think we need to try and fix that..

We might want to detect it and yell about it, right?

Thanks,

        tglx
