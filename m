Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E06113A8648
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 18:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbhFOQXA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 12:23:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53088 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229493AbhFOQW7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Jun 2021 12:22:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623774054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5YLb7ACF6OGDsiDttoNGN/jmPZF5LwN2Lq0fsg6CwmA=;
        b=Qs3aJ88PkO0RPqXAO1YSgA1uKqwKZS94Y031QcN8YimbnRfeFvIlD1KrbTCz3Gy2xxj4Nj
        VXlLnBJuHqTHlnsx/+HBPNmR9Mx0RtzGWdsj8SjtVDziplh7kGFvpzgOLMrch8ZnOyITpF
        LvQKD95VNF9AqVvCCw+/gdTqezfM934=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-436-zUsWF_vcPpmV7wbj-geFMg-1; Tue, 15 Jun 2021 12:20:52 -0400
X-MC-Unique: zUsWF_vcPpmV7wbj-geFMg-1
Received: by mail-oo1-f71.google.com with SMTP id e25-20020a4ab9990000b029024aa2670b1cso6760197oop.21
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 09:20:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=5YLb7ACF6OGDsiDttoNGN/jmPZF5LwN2Lq0fsg6CwmA=;
        b=A86B1IS0GRqT3tjfiumzt3wjmI7+k2JCKhCD71JVBIzdXSHcYYN8VnbeDNxXGT6Ej8
         2v44y7ywU3/5KpA9qsOVRqVa0P6kIeIgdR0Qn4Q6Rzh9MKeKkVvz8P/whb8Ej6fjRZdU
         kdJTmyJr5vNpzrW8w1wIlDcq0rAoYoZEDKxHN20x3GGY4LBK311yc/6EFh+HqFFx3/yk
         ik3qtuOQRP8dtlf2HDg6LOOT9dTNzsVTBuU2/V5TzlPaL6mUWaUD7hhiyrT1uIj0eRq/
         k7cyqNEwtZsLdq3nLv9HCOfE2f8K7kT0TJMal+xdVIrr3P9qOC20Wqrj4OQAVLCKmGw7
         PYCQ==
X-Gm-Message-State: AOAM532etGpssVHiKZnkT0lHJ7Bws+AHNB3NzAE3Zk/ew8mQvA4ZtYnU
        90ngataOUI8xfUE3hh7ds6C83hhswrb7fYdv8hY3d92eds2ZpNpoxOSdrQLj3+mFmDbD4wrOe7H
        tuCLbfJgpzoSt
X-Received: by 2002:a05:6830:1b6e:: with SMTP id d14mr103329ote.186.1623774052214;
        Tue, 15 Jun 2021 09:20:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyia4e+2A6jNajuBcsHnPXEmwnB7xgOKEtv+OceRghWjC+MtI4+dG+D2ydJXrE/Pzhxmdxkfw==
X-Received: by 2002:a05:6830:1b6e:: with SMTP id d14mr103321ote.186.1623774052047;
        Tue, 15 Jun 2021 09:20:52 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id f63sm4221750otb.36.2021.06.15.09.20.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 09:20:51 -0700 (PDT)
Date:   Tue, 15 Jun 2021 10:20:49 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Max Gurtovoy <mgurtovoy@nvidia.com>, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        aviadye@nvidia.com, oren@nvidia.com, shahafs@nvidia.com,
        parav@nvidia.com, artemp@nvidia.com, kwankhede@nvidia.com,
        ACurrid@nvidia.com, cjia@nvidia.com, yishaih@nvidia.com,
        kevin.tian@intel.com, hch@infradead.org, targupta@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, liulongfang@huawei.com,
        yan.y.zhao@intel.com
Subject: Re: [PATCH 09/11] PCI: add matching checks for driver_override
 binding
Message-ID: <20210615102049.71a3c125.alex.williamson@redhat.com>
In-Reply-To: <20210615150458.GR1002214@nvidia.com>
References: <20210603160809.15845-1-mgurtovoy@nvidia.com>
        <20210603160809.15845-10-mgurtovoy@nvidia.com>
        <20210608152643.2d3400c1.alex.williamson@redhat.com>
        <20210608224517.GQ1002214@nvidia.com>
        <20210608192711.4956cda2.alex.williamson@redhat.com>
        <117a5e68-d16e-c146-6d37-fcbfe49cb4f8@nvidia.com>
        <20210614124250.0d32537c.alex.williamson@redhat.com>
        <70a1b23f-764d-8b3e-91a4-bf5d67ac9f1f@nvidia.com>
        <20210615090029.41849d7a.alex.williamson@redhat.com>
        <20210615150458.GR1002214@nvidia.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 15 Jun 2021 12:04:58 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Jun 15, 2021 at 09:00:29AM -0600, Alex Williamson wrote:
> 
> > "vfio" override in PCI-core plays out for other override types.  Also I
> > don't think dynamic IDs should be handled uniquely, new_id_store()
> > should gain support for flags and userspace should be able to add new
> > dynamic ID with override-only matches to the table.  Thanks,  
> 
> Why? Once all the enforcement is stripped out the only purpose of the
> new flag is to signal a different prepration of modules.alias - which
> won't happen for the new_id path anyhow

Because new_id allows the admin to insert a new pci_device_id which has
been extended to include a flags field and intentionally handling
dynamic IDs differently from static IDs seems like generally a bad
thing.  For example, maybe the admin wants to specify nouveau as only
an override match for all 10de: class vga devices.  Thanks,

Alex

