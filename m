Return-Path: <kvm+bounces-11987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C4CA187EB83
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 15:59:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E49371C2117D
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 14:59:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C72B54EB46;
	Mon, 18 Mar 2024 14:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UQNFWBC5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD784EB34
	for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 14:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710773936; cv=none; b=DKe1SKygFSqGLS6QW8CBpL5OsZAGXq7ug+jtdbNisPeXZCyIZdJJGUkRB6BaqU2lm3zS+GGc/k8OFHzlhHlaEFmhpLL2YzJLvKQQdzFiAvfH3z0xbQVlQbRoUzVw7KoDOeYGo0lN4Q6tYM0tRRZTFDs9o9juhZ8tWTIbFbxex3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710773936; c=relaxed/simple;
	bh=tefFIE10PHxJSPH6VfNiRa6rB3vTb3pQBRowyAkqk5c=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZSn4QiCRmOGImVqOemjEFIN4BRt+Zf+6as5mmGObis6J7OhkDSRk+Rr4k8XIUpdT6b8gVIIJE8h/Ml5v7z5Htn4uZPyQ0A3er+Po42nhZvQT4gn7ZRA5EDknwlfHVHhejlOhWv7ShOzFFkknF9IHbs3kSEO5Gut9XXHFW3plhEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UQNFWBC5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710773933;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S5rXb9xskSAldFvBiaq7cgnCXNtAJE0ee8Udzzx+frU=;
	b=UQNFWBC5MSFk9HKIPyj83Xi+w6bOk/n1ngEhLvbzsj9P2WZJSLGEqg/mcif5qkg7LzhsEF
	OXvA42cDeWtfVdU/iH06ajgsZBQdVCw/M3bVkPYi4Ml05FUhp+AgwZOs7YN3qpUHfZj5oj
	y02KKwlv0l0eTzecbMEjiHDBxvOhe9g=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-342-j9y7-6TfMXyYm-7ugfS79g-1; Mon, 18 Mar 2024 10:58:51 -0400
X-MC-Unique: j9y7-6TfMXyYm-7ugfS79g-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-367858dd387so5856765ab.1
        for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 07:58:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710773931; x=1711378731;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S5rXb9xskSAldFvBiaq7cgnCXNtAJE0ee8Udzzx+frU=;
        b=jLTy0sWSdRfvdEJoBzPO/bo0LZG7QZnpSrdUtLSBCQVKEu/kENdF2khKNgUf7zaxl2
         8sAwQ+b9nu65JrE0epFwwkM/AJ+EjMF7x2LvY6hEGRBVh2n3YysL/xi8QxUUtrqboXln
         bUq6lHHTjxV3b7T66MarWzZ3OeyUt4ASJF+ZVqMohAT+Gy6BF1GlQ26lPQDtIV65CCP2
         2Xi4BBGrnT0gYpFDAMrG7Rj8MBqNhqq7yBsHD4WWITBrhmH0EPW13TKGkSKDIOwFelsz
         /yTcGRR+42FiEA2I6cg/vj4uwSdcx03MeVo8Ijmidj4fuYt4/7GDconLYej3Qa84rBib
         EHEA==
X-Forwarded-Encrypted: i=1; AJvYcCVTS7X3CAfcNueno0cgeRU6DjomNCgtGwWRXJR8Zgk9FGnxJBTg/bMFQmq35DrX43lp94J7sthqMMOjE2mJjp2OkMgb
X-Gm-Message-State: AOJu0Yz5LOBKpGDJHUo08mgKY10Ood2dEk3W/5QSZFeG/2+z8k4erTic
	MEVpKDiKU4uHb+neIbldw4Y8EZx9TBUN88cwd6+ga4uSYkFIIPcoO8e7c4YY8cLMjEmk/wQ8QpE
	A5//1JPZ9hTznKTQvLQMXvjm71NI0J/Kl1vXSwqV36NstoWtoNw==
X-Received: by 2002:a92:d14c:0:b0:366:8ce0:6db with SMTP id t12-20020a92d14c000000b003668ce006dbmr10139633ilg.32.1710773931079;
        Mon, 18 Mar 2024 07:58:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFeJFZUt/ODouk/j4XHwc1OHH4vDt8B5VkLETdQd2fGKfXHAvefPy2DYLdrQT0ZUXWN0EnZeA==
X-Received: by 2002:a92:d14c:0:b0:366:8ce0:6db with SMTP id t12-20020a92d14c000000b003668ce006dbmr10139611ilg.32.1710773930732;
        Mon, 18 Mar 2024 07:58:50 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id s4-20020a02ad04000000b00476df803a46sm2354740jan.21.2024.03.18.07.58.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 07:58:50 -0700 (PDT)
Date: Mon, 18 Mar 2024 08:58:48 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Vinayak Kale <vkale@nvidia.com>
Cc: qemu-devel@nongnu.org, mst@redhat.com, marcel.apfelbaum@gmail.com,
 avihaih@nvidia.com, acurrid@nvidia.com, cjia@nvidia.com, zhiw@nvidia.com,
 targupta@nvidia.com, kvm@vger.kernel.org
Subject: Re: [PATCH v2] vfio/pci: migration: Skip config space check for
 vendor specific capability during restore/load
Message-ID: <20240318085848.32b34594.alex.williamson@redhat.com>
In-Reply-To: <7cab7d27-0ad2-4cb5-9757-a837a6fd13a9@nvidia.com>
References: <20240311121519.1481732-1-vkale@nvidia.com>
	<20240311090242.229b80ec.alex.williamson@redhat.com>
	<7cab7d27-0ad2-4cb5-9757-a837a6fd13a9@nvidia.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 15 Mar 2024 23:22:22 +0530
Vinayak Kale <vkale@nvidia.com> wrote:

> On 11/03/24 8:32 pm, Alex Williamson wrote:
> > External email: Use caution opening links or attachments
> > 
> > 
> > On Mon, 11 Mar 2024 17:45:19 +0530
> > Vinayak Kale <vkale@nvidia.com> wrote:
> >   
> >> In case of migration, during restore operation, qemu checks config space of the
> >> pci device with the config space in the migration stream captured during save
> >> operation. In case of config space data mismatch, restore operation is failed.
> >>
> >> config space check is done in function get_pci_config_device(). By default VSC
> >> (vendor-specific-capability) in config space is checked.
> >>
> >> Ideally qemu should not check VSC for VFIO-PCI device during restore/load as
> >> qemu is not aware of VSC ABI.  
> > 
> > It's disappointing that we can't seem to have a discussion about why
> > it's not the responsibility of the underlying migration support in the
> > vfio-pci variant driver to make the vendor specific capability
> > consistent across migration.  
> 
> I think it is device vendor driver's responsibility to ensure that VSC 
> is consistent across migration. Here consistency could mean that VSC 
> format should be same on source and destination, however actual VSC 
> contents may not be byte-to-byte identical.
> 
> If a vfio-pci device is migration capable and if vfio-pci vendor driver 
> is OK with volatile VSC contents as long as consistency is maintained 
> for VSC format then QEMU should exempt config space check for VSC contents.

I tend to agree that ultimately the variant driver is responsible for
making the device consistent during migration and QEMU's policy that
even vendor defined ABI needs to be byte for byte identical is somewhat
arbitrary.

> > Also, for future maintenance, specifically what device is currently
> > broken by this and under what conditions?  
> 
> Under certain conditions VSC contents vary for NVIDIA vGPU devices in 
> case of live migration. Due to QEMU's current config space check for 
> VSC, live migration is broken across NVIDIA vGPU devices.

This is incredibly vague.  We've been testing NVIDIA vGPU migration and
have not experienced a migration failure due to VSC mismatch.  Does this
require a specific device?  A specific workload?  What specific
conditions trigger this problem?

While as above, I agree in theory that the responsibility lies on the
migration support in the variant driver, there are risks involved,
particularly if new dependencies on the VSC contents are developed in
the guest.  For future maintenance and development in this space, the
commit log should describe exactly the scenario that requires this
policy change.  Thanks,

Alex

> >> This patch skips the check for VFIO-PCI device by clearing pdev->cmask[] for VSC
> >> offsets. If cmask[] is not set for an offset, then qemu skips config space check
> >> for that offset.
> >>
> >> Signed-off-by: Vinayak Kale <vkale@nvidia.com>
> >> ---
> >> Version History
> >> v1->v2:
> >>      - Limited scope of change to vfio-pci devices instead of all pci devices.
> >>
> >>   hw/vfio/pci.c | 19 +++++++++++++++++++
> >>   1 file changed, 19 insertions(+)
> >>
> >> diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
> >> index d7fe06715c..9edaff4b37 100644
> >> --- a/hw/vfio/pci.c
> >> +++ b/hw/vfio/pci.c
> >> @@ -2132,6 +2132,22 @@ static void vfio_check_af_flr(VFIOPCIDevice *vdev, uint8_t pos)
> >>       }
> >>   }
> >>
> >> +static int vfio_add_vendor_specific_cap(VFIOPCIDevice *vdev, int pos,
> >> +                                        uint8_t size, Error **errp)
> >> +{
> >> +    PCIDevice *pdev = &vdev->pdev;
> >> +
> >> +    pos = pci_add_capability(pdev, PCI_CAP_ID_VNDR, pos, size, errp);
> >> +    if (pos < 0) {
> >> +        return pos;
> >> +    }
> >> +
> >> +    /* Exempt config space check for VSC during restore/load  */
> >> +    memset(pdev->cmask + pos, 0, size);  
> > 
> > This excludes the entire capability from comparison, including the
> > capability ID, next pointer, and capability length.  Even if the
> > contents of the capability are considered volatile vendor information,
> > the header is spec defined ABI which must be consistent.  Thanks,  
> 
> This makes sense, I'll address this in V3. Thanks.
> 
> > 
> > Alex
> >   
> >> +
> >> +    return pos;
> >> +}
> >> +
> >>   static int vfio_add_std_cap(VFIOPCIDevice *vdev, uint8_t pos, Error **errp)
> >>   {
> >>       PCIDevice *pdev = &vdev->pdev;
> >> @@ -2199,6 +2215,9 @@ static int vfio_add_std_cap(VFIOPCIDevice *vdev, uint8_t pos, Error **errp)
> >>           vfio_check_af_flr(vdev, pos);
> >>           ret = pci_add_capability(pdev, cap_id, pos, size, errp);
> >>           break;
> >> +    case PCI_CAP_ID_VNDR:
> >> +        ret = vfio_add_vendor_specific_cap(vdev, pos, size, errp);
> >> +        break;
> >>       default:
> >>           ret = pci_add_capability(pdev, cap_id, pos, size, errp);
> >>           break;  
> >   
> 


