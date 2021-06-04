Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9593839C2CC
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 23:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231542AbhFDVrD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 17:47:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50070 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230175AbhFDVrC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Jun 2021 17:47:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622843114;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zSr4NtU9kRyTYI9vJXKuouCcXbXTwJvBiHy5x/6JVcU=;
        b=LLi9NUx5i5PV0eugR563YdKkRUW8ey6iBXaUXXuO+JES7uyifQCdpKqiI/fmQ52aQTOEFF
        JLkheET0X8bwIX5gLuKt6iHl5PwuISTp4cZc7jQabOteXMMZUDF3DYPGCPNe4qvOhVGK/z
        Ao8d0qi8dfyV1v5GDSOC6BS9d/3enBU=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-KFl41s1wNKuDPZVTfheG9w-1; Fri, 04 Jun 2021 17:45:13 -0400
X-MC-Unique: KFl41s1wNKuDPZVTfheG9w-1
Received: by mail-oo1-f71.google.com with SMTP id m22-20020a0568200356b0290248e4270f00so3641193ooe.14
        for <kvm@vger.kernel.org>; Fri, 04 Jun 2021 14:45:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=zSr4NtU9kRyTYI9vJXKuouCcXbXTwJvBiHy5x/6JVcU=;
        b=cEZyOv8P248Ei5VUsUKM0d+UVNa5xV44N37OVev1YjMNFsCTlJDSJMkD89R94wLxUj
         1/ppO83WFu8Iqm/IUuo+bOu5HI/9BvBfW2BgCkXqe3ly7NypS5uypbCZKsE6SnvJpmmY
         UG5eAKwaGXB53EBJ6+czZKr1CE4kqWKo6K54qL23++mFR/BFwEqwpztDKwvdi5XDQQdq
         12v2S/QspxTXKNqUpfVRhGg5vZes9HtrOiLaG6PNLnEtao/NNkh+zSKVlh89Rli1jW2I
         nstanrcL5yH9Jhejh1sfxo198XfLPTHHNwTRnUEC1al/WUrIELzqQjb1bm2masnJYsB9
         msYA==
X-Gm-Message-State: AOAM530qjOR3pg2PNFpOLBd2DOMLAZlbX5yymn1HKzqVcS0NT3Wt8nrE
        l+B0vc0Q3Gr4cgm2x6Q43Py3xyRanulXodmHf+5qzoIp3X8bMLMoVJ8z1y+ZZKd+cu5r2damHQ9
        z52E5dtKnhRj2
X-Received: by 2002:a4a:b544:: with SMTP id s4mr5214641ooo.62.1622843113070;
        Fri, 04 Jun 2021 14:45:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyXMJF5jgtVADecJNiiiu5bWXOc0GxXvl+uaj344NIz3ZPmM3VepTqHL8yFOEd8Ck092h+X+Q==
X-Received: by 2002:a4a:b544:: with SMTP id s4mr5214626ooo.62.1622843112930;
        Fri, 04 Jun 2021 14:45:12 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id l10sm752196ots.32.2021.06.04.14.45.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jun 2021 14:45:12 -0700 (PDT)
Date:   Fri, 4 Jun 2021 15:45:11 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210604154511.2bcb48dc.alex.williamson@redhat.com>
In-Reply-To: <20210604121337.GJ1002214@nvidia.com>
References: <20210602120111.5e5bcf93.alex.williamson@redhat.com>
        <20210602180925.GH1002214@nvidia.com>
        <20210602130053.615db578.alex.williamson@redhat.com>
        <20210602195404.GI1002214@nvidia.com>
        <20210602143734.72fb4fa4.alex.williamson@redhat.com>
        <20210602224536.GJ1002214@nvidia.com>
        <20210602205054.3505c9c3.alex.williamson@redhat.com>
        <MWHPR11MB1886DC8ECF5D56FE485D13D58C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210603124036.GU1002214@nvidia.com>
        <20210603144136.2b68c5c5.alex.williamson@redhat.com>
        <20210604121337.GJ1002214@nvidia.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 4 Jun 2021 09:13:37 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Thu, Jun 03, 2021 at 02:41:36PM -0600, Alex Williamson wrote:
> 
> > Could you clarify "vfio_driver"?    
> 
> This is the thing providing the vfio_device_ops function pointers.
> 
> So vfio-pci can't know anything about this (although your no-snoop
> control probing idea makes sense to me)
> 
> But vfio_mlx5_pci can know
> 
> So can mdev_idxd
> 
> And kvmgt

A capability on VFIO_DEVICE_GET_INFO could provide a hint to userspace.
Stock vfio-pci could fill it out to the extent advertising if the
device is capable of non-coherent DMA based on the Enable No-snoop
probing, the device specific vfio_drivers could set it based on
knowledge of the device behavior.  Another bit might indicate a
preference to not suppress non-coherent DMA at the IOMMU.  Thanks,

Alex

