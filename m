Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC4902FF31E
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 19:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728527AbhAUS0s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 13:26:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51183 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389276AbhAUSPu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 13:15:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611252863;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lEgMkUTOCJsoedIDEpBA2hjPtpKSlnIAkYz8Z2MMNg0=;
        b=HhV9sQ15u8xtMOCvc5f7XYyaKls4zmWZ3XnrKGBi8SLVsOj0ainwS2r11PbitDq/PEEzgD
        EE2r0OTfgQI7XSyaey4DEEolQZQK7q73EAJFV4O+cZdnE5kR1jFKNnNreppBZcyS+lSnkI
        4BgDr7WmTT+vV4pVuOb0T52Anx48y6E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-4sowHxENOA-jNF3X_XPxfw-1; Thu, 21 Jan 2021 13:14:19 -0500
X-MC-Unique: 4sowHxENOA-jNF3X_XPxfw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 87956107ACE3;
        Thu, 21 Jan 2021 18:14:16 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1251139A63;
        Thu, 21 Jan 2021 18:14:15 +0000 (UTC)
Date:   Thu, 21 Jan 2021 11:14:14 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Keqian Zhu <zhukeqian1@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <iommu@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Will Deacon <will@kernel.org>, "Marc Zyngier" <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        "Robin Murphy" <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Suzuki K Poulose" <suzuki.poulose@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        <wanghaibin.wang@huawei.com>, <jiangkunkun@huawei.com>
Subject: Re: [PATCH v2 2/2] vfio/iommu_type1: Sanity check pfn_list when
 remove vfio_dma
Message-ID: <20210121111414.143e3e4e@omen.home.shazbot.org>
In-Reply-To: <32f8b347-587a-1a9a-bee8-569f09a03a15@huawei.com>
References: <20210115092643.728-1-zhukeqian1@huawei.com>
        <20210115092643.728-3-zhukeqian1@huawei.com>
        <20210115121447.54c96857@omen.home.shazbot.org>
        <32f8b347-587a-1a9a-bee8-569f09a03a15@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 18 Jan 2021 21:16:08 +0800
Keqian Zhu <zhukeqian1@huawei.com> wrote:

> On 2021/1/16 3:14, Alex Williamson wrote:
> > On Fri, 15 Jan 2021 17:26:43 +0800
> > Keqian Zhu <zhukeqian1@huawei.com> wrote:
> >   
> >> vfio_sanity_check_pfn_list() is used to check whether pfn_list of
> >> vfio_dma is empty when remove the external domain, so it makes a
> >> wrong assumption that only external domain will add pfn to dma pfn_list.
> >>
> >> Now we apply this check when remove a specific vfio_dma and extract
> >> the notifier check just for external domain.  
> > 
> > The page pinning interface is gated by having a notifier registered for
> > unmaps, therefore non-external domains would also need to register a
> > notifier.  There's currently no other way to add entries to the
> > pfn_list.  So if we allow pinning for such domains, then it's wrong to
> > WARN_ON() when the notifier list is not-empty when removing an external
> > domain.  Long term we should probably extend page {un}pinning for the
> > caller to pass their notifier to be validated against the notifier list
> > rather than just allowing page pinning if *any* notifier is registered.
> > Thanks,  
> I was misled by the code comments. So when the commit a54eb55045ae is
> added, the only user of pin interface is mdev vendor driver, but now
> we also allow iommu backed group to use this interface to constraint
> dirty scope. Is vfio_iommu_unmap_unpin_all() a proper place to put
> this WARN()?

vfio_iommu_unmap_unpin_all() deals with removing vfio_dmas, it's
logically unrelated to whether any driver is registered to receive
unmap notifications.  Thanks,

Alex

