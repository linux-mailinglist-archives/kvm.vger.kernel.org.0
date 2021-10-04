Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16DB9421A12
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 00:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235831AbhJDWdk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 18:33:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27429 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233633AbhJDWdk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Oct 2021 18:33:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633386710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k6a7Mk6masvQrG2jLXSsH1TBnPfgw5I+N+EIPzAog1I=;
        b=crG0NxoGeVcWmRtSmTb1QRiu7LcsD2MGnTEisyaKBqEkWrtiyRIKONwBhnroSfJET9L8U9
        2C9j2WZpn/GyHYM5xJ7P4vnalXhNqkNlhOteo5EjET6i3vgMusXNAror5jYqMnPA9LVFmn
        fzzmbk8YMnOHHtSnMsNoUmJT0ChH4DA=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-447-7aDMJZ7KPr2xa6b31xVmCQ-1; Mon, 04 Oct 2021 18:31:49 -0400
X-MC-Unique: 7aDMJZ7KPr2xa6b31xVmCQ-1
Received: by mail-io1-f70.google.com with SMTP id s21-20020a6bdc15000000b005db56ae6275so16974337ioc.5
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 15:31:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=k6a7Mk6masvQrG2jLXSsH1TBnPfgw5I+N+EIPzAog1I=;
        b=IDM5OIgIlHSfoX1BtQdXhYaLSi+TyCDXOJXTUt8//ZOfHDM02Ws1SC7JxIw9I2VgU5
         A3p3wFjX6X+FcRFLVwFsOzKwVMBNffRCKnPpOdtTDBv45nYjnQuChF50HME220YzUbWG
         Iyps6ECDerAJRCGlsBPn9YBHGnTeAbL0WE/Wz7kjIrxh032ndp4Lg0BLU9I7VB37NWab
         l1UXjz5MnHqfZDxQMy05pVs/B3uZM6xgijkW1Emsh6RcMs+ZYGOozFmhLodrfrUzcH61
         TR6IAWB5GzjsjBRjQXkUbX7fmhk3p7pHZDd6DuIY6fyh5KVbNgW5FiklFCJq/mqOtC3H
         64wQ==
X-Gm-Message-State: AOAM531xVY+lQExPwx7ltQXgJWIOXpOVacBtAdNfffLsc5XsGKyLcqiC
        otQUk85X/EM5CQ5Q+ix7N67wHKM6zX0iLWmu2IHEX5qZInDt1WNDz0onZxbOdgjFMOf2mcBaDdo
        UK+zcGFlhKoMT
X-Received: by 2002:a05:6e02:8ad:: with SMTP id a13mr486968ilt.136.1633386708710;
        Mon, 04 Oct 2021 15:31:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy0L83MvMLkr/6+IdyIY0rPwtfBHAvQdPfMp3mBYCUa8IZHMaQLCDaoD7TjRxtwh23+H0xxUw==
X-Received: by 2002:a05:6e02:8ad:: with SMTP id a13mr486960ilt.136.1633386708578;
        Mon, 04 Oct 2021 15:31:48 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id l1sm9952807ilc.65.2021.10.04.15.31.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 15:31:48 -0700 (PDT)
Date:   Mon, 4 Oct 2021 16:31:46 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Ajay Garg <ajaygargnsit@gmail.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] iommu: intel: remove flooding of non-error logs, when
 new-DMA-PTE is the same as old-DMA-PTE.
Message-ID: <20211004163146.6b34936b.alex.williamson@redhat.com>
In-Reply-To: <CAHP4M8Us753hAeoXL7E-4d29rD9+FzUwAqU6gKNmgd8G0CaQQw@mail.gmail.com>
References: <20211002124012.18186-1-ajaygargnsit@gmail.com>
        <b9afdade-b121-cc9e-ce85-6e4ff3724ed9@linux.intel.com>
        <CAHP4M8Us753hAeoXL7E-4d29rD9+FzUwAqU6gKNmgd8G0CaQQw@mail.gmail.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2 Oct 2021 22:48:24 +0530
Ajay Garg <ajaygargnsit@gmail.com> wrote:

> Thanks Lu for the reply.
> 
> >
> > Isn't the domain should be switched from a default domain to an
> > unmanaged domain when the device is assigned to the guest?
> >
> > Even you want to r-setup the same mappings, you need to un-map all
> > existing mappings, right?
> >  
> 
> Hmm, I guess that's a (design) decision the KVM/QEMU/VFIO communities
> need to take.
> May be the patch could suppress the flooding till then?

No, this is wrong.  The pte values should not exist, it doesn't matter
that they're the same.  Is the host driver failing to remove mappings
and somehow they persist in the new vfio owned domain?  There's
definitely a bug beyond logging going on here.  Thanks,

Alex

