Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB406662A6
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 19:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235650AbjAKST4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 13:19:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235843AbjAKSTp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 13:19:45 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF84392E2;
        Wed, 11 Jan 2023 10:19:36 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1673461175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=v9yLlw+CPPaFudmLWOnzXWazHzYK/LPnpzMb1fBBhH8=;
        b=qIkO8ofsmxcEhgHvSKYUo3KRpEnxCyaUcJAeHOCr57WMt9SO+scnZh75msdMhcBc71rb77
        TkRGVISwdV9ZHeDzGic5SqSMhkPrqHgkJagOxeBy8pgcD8awaHqQTMQnAzFKL8hQuVsVFi
        3Dsbkhob6qwN/WWaX67OGU52eaxSIlGmUzzrbop4drU8kCCHGuj9sfYgpumB0HW7jC301/
        5d94B/qZrL7IlZSZART3V/qapJqS4RQhiy2JNVKRfFLaKywUeRLYp8rFjDLEErJxUC0vcL
        5Euadn7w9Z5GuAg35KgUuKmqaoVQJYMcf5d3alB7vzEYNfoCxvslr3yDbIQEWw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1673461175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=v9yLlw+CPPaFudmLWOnzXWazHzYK/LPnpzMb1fBBhH8=;
        b=+HS771bu4wTJd8NyZ2Q0OZI+lfX2S4cwwJfn6qT9NPXQDhpNZT8oPhUU22ocg+lwT9jLiM
        PzkudHnDFis62OAg==
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Will Deacon <will@kernel.org>
Cc:     Bharat Bhushan <bharat.bhushan@nxp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tomasz Nowicki <tomasz.nowicki@caviumnetworks.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH iommufd v3 2/9] iommu: Add iommu_group_has_isolated_msi()
In-Reply-To: <2-v3-3313bb5dd3a3+10f11-secure_msi_jgg@nvidia.com>
References: <2-v3-3313bb5dd3a3+10f11-secure_msi_jgg@nvidia.com>
Date:   Wed, 11 Jan 2023 19:19:34 +0100
Message-ID: <87eds1hr2h.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 05 2023 at 15:33, Jason Gunthorpe wrote:
> +
> +	mutex_lock(&group->mutex);
> +	list_for_each_entry(group_dev, &group->devices, list)
> +		ret &= msi_device_has_isolated_msi(group_dev->dev) ||
> +		       device_iommu_capable(group_dev->dev,
> +					    IOMMU_CAP_INTR_REMAP);

Nit. This really wants brackets even if they are not required by the
language. Why?

Brackets can be omitted for a single line statement in the loop/if path,
but this

> +		ret &= msi_device_has_isolated_msi(group_dev->dev) ||
> +		       device_iommu_capable(group_dev->dev,
> +					    IOMMU_CAP_INTR_REMAP);

is visually a multi line statement. So having brackets makes visual
parsing of this construct way clearer:

	list_for_each_entry(group_dev, &group->devices, list) {
		ret &= msi_device_has_isolated_msi(group_dev->dev) ||
		       device_iommu_capable(group_dev->dev, IOMMU_CAP_INTR_REMAP);
	}

Also get rid of that extra line break. We lifted the 80 characters line
length quite some while ago and made it 100.

Thanks,

        tglx
