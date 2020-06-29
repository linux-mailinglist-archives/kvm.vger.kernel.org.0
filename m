Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20C4220D21E
	for <lists+kvm@lfdr.de>; Mon, 29 Jun 2020 20:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728082AbgF2Sqo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jun 2020 14:46:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26319 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729308AbgF2Sqn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jun 2020 14:46:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593456401;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lmeklZemL80Q7lsiy/DTnr9n71S9umll3AkykzC+jhc=;
        b=jELQEPaTByRF52JD1NkVF/HAlxaFMnoUqkxDJHCmhrUgyJv37/aFjMB0ZrMBV/C8A5FGbg
        77ERASuOjnxp0ZtdN362hVpw7foWi1msxVMBPwgbh+YnlcTnQV8MwSaGWLBRODWZ7lW2Ks
        B4kgBLLhV/M9bniIF/RPvkHLTgqofYA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-qTZ19pRuPo682yuNxSFHLQ-1; Mon, 29 Jun 2020 09:44:50 -0400
X-MC-Unique: qTZ19pRuPo682yuNxSFHLQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 99FC6107ACF9;
        Mon, 29 Jun 2020 13:44:48 +0000 (UTC)
Received: from gondolin (ovpn-113-61.ams2.redhat.com [10.36.113.61])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6FDB35C1D4;
        Mon, 29 Jun 2020 13:44:42 +0000 (UTC)
Date:   Mon, 29 Jun 2020 15:44:39 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, mst@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, thomas.lendacky@amd.com,
        david@gibson.dropbear.id.au, linuxram@us.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v3 1/1] s390: virtio: let arch accept devices without
 IOMMU feature
Message-ID: <20200629154439.14cc5ae7.cohuck@redhat.com>
In-Reply-To: <7fe6e9ab-fd5a-3f92-1f3a-f9e6805d3730@linux.ibm.com>
References: <1592390637-17441-1-git-send-email-pmorel@linux.ibm.com>
        <1592390637-17441-2-git-send-email-pmorel@linux.ibm.com>
        <20200618002956.5f179de4.pasic@linux.ibm.com>
        <20200619112051.74babdb1.cohuck@redhat.com>
        <7fe6e9ab-fd5a-3f92-1f3a-f9e6805d3730@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 29 Jun 2020 15:14:04 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> On 2020-06-19 11:20, Cornelia Huck wrote:
> > On Thu, 18 Jun 2020 00:29:56 +0200
> > Halil Pasic <pasic@linux.ibm.com> wrote:
> >   
> >> On Wed, 17 Jun 2020 12:43:57 +0200
> >> Pierre Morel <pmorel@linux.ibm.com> wrote:  

> >>> @@ -179,6 +194,13 @@ int virtio_finalize_features(struct virtio_device *dev)
> >>>   	if (!virtio_has_feature(dev, VIRTIO_F_VERSION_1))
> >>>   		return 0;
> >>>   
> >>> +	if (arch_needs_virtio_iommu_platform(dev) &&
> >>> +		!virtio_has_feature(dev, VIRTIO_F_IOMMU_PLATFORM)) {
> >>> +		dev_warn(&dev->dev,
> >>> +			 "virtio: device must provide VIRTIO_F_IOMMU_PLATFORM\n");  

[Side note: wasn't there a patch renaming this bit on the list? I think
this name is only kept for userspace compat.]

> >>
> >> I'm not sure, divulging the current Linux name of this feature bit is a
> >> good idea, but if everybody else is fine with this, I don't care that  
> > 
> > Not sure if that feature name will ever change, as it is exported in
> > headers. At most, we might want to add the new ACCESS_PLATFORM define
> > and keep the old one, but that would still mean some churn.
> >   
> >> much. An alternative would be:
> >> "virtio: device falsely claims to have full access to the memory,
> >> aborting the device"  
> > 
> > "virtio: device does not work with limited memory access" ?
> > 
> > But no issue with keeping the current message.
> >   
> 
> If it is OK, I would like to specify that the arch is responsible to 
> accept or not the device.
> The reason why the device is not accepted without IOMMU_PLATFORM is arch 
> specific.

Hm, I'd think the reason is always the same (the device cannot access
the memory directly), just the way to figure out whether that is the
case or not is arch-specific, as with so many other things. No real
need to go into detail here, I think.

