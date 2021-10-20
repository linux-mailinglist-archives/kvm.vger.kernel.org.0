Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8C9D4351BB
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 19:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbhJTRrx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 13:47:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27224 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231245AbhJTRrd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 13:47:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634751918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2hBP0Hfu21rfryuWwyspO9zl4oca+bH25WuLkT22wcc=;
        b=OGvo1JYIZpHrjIM3pTANYfRJwuYAHN/ZdgKgUAR6XI4ggBJCMjoQdTrDDHGY2NPlVmlJH5
        EQagJ7sd6Peg2AoxTZGwHaFVBp6dDn6YE/UTM7qNXwLWODzE4tOKpQP1ozO+4Q+yf0FA6q
        npRYwH0EOiUFsN9neeyur89BHO8PUQU=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-114-pP5g0sDGOGmMFK9coVOmyQ-1; Wed, 20 Oct 2021 13:45:17 -0400
X-MC-Unique: pP5g0sDGOGmMFK9coVOmyQ-1
Received: by mail-oi1-f200.google.com with SMTP id q132-20020acac08a000000b00298e2159ac7so4085726oif.17
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 10:45:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2hBP0Hfu21rfryuWwyspO9zl4oca+bH25WuLkT22wcc=;
        b=gGXnUsivMn7SRD6hLWMjkLXtfCc5vuPopskz6yjK5XQWnvYUqUSiDIXYvpXNjDMpm2
         aF3PFjM0X9kEdjE7jPO1FnR/l7xBntcVelzmowIlwz+OMZqMMMxag49Xu3Sr0bkY82mK
         Ocfc4N0NpgHf9xjR9/Eg8jleSeouhgMnK+BW9KPUXvBBsBBle/cngt/R0AGfzEo03oX1
         zPwxhM1ajFL9952gQJlxumnWmepbKi8ijVUQgjmxd0F7WIRLt/K4ExESE9AZx5Pv7TXX
         e0REh2mWT8cNnXlQlBD9+icZvElN9Bin0Tnwya4YMBYcaXpNjid6j0y1qOXWMTPY0MVC
         w5Nw==
X-Gm-Message-State: AOAM530lw80wUuK26233CCpgGMzq7iAnSBHBeUdl4D5IQQEOmC5euPlJ
        wws8+BeVLeCg87AO6lJJHvekl0QKtmB2hjwbpEzKlRvKvBVVej2O17/Q2v/L8z2RKmmXG9OlKlT
        HtTHNhDT2rc1p
X-Received: by 2002:aca:5f05:: with SMTP id t5mr764538oib.6.1634751916603;
        Wed, 20 Oct 2021 10:45:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxKoHj9L/+cPOQcjxZIt11pD2g7gRAhKD9GAn7fGM9xPBRn3QxFkpALYapm7VHjLzF9mQtvwA==
X-Received: by 2002:aca:5f05:: with SMTP id t5mr764508oib.6.1634751916398;
        Wed, 20 Oct 2021 10:45:16 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id n187sm538797oif.52.2021.10.20.10.45.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 10:45:16 -0700 (PDT)
Date:   Wed, 20 Oct 2021 11:45:14 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V2 mlx5-next 14/14] vfio/mlx5: Use its own PCI
 reset_done error handler
Message-ID: <20211020114514.560ce2fa.alex.williamson@redhat.com>
In-Reply-To: <20211020164629.GG2744544@nvidia.com>
References: <20211019105838.227569-1-yishaih@nvidia.com>
        <20211019105838.227569-15-yishaih@nvidia.com>
        <20211019125513.4e522af9.alex.williamson@redhat.com>
        <20211019191025.GA4072278@nvidia.com>
        <5cf3fb6c-2ca0-f54e-3a05-27762d29b8e2@nvidia.com>
        <20211020164629.GG2744544@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 20 Oct 2021 13:46:29 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Oct 20, 2021 at 11:46:07AM +0300, Yishai Hadas wrote:
> 
> > What is the expectation for a reasonable delay ? we may expect this system
> > WQ to run only short tasks and be very responsive.  
> 
> If the expectation is that qemu will see the error return and the turn
> around and issue FLR followed by another state operation then it does
> seem strange that there would be a delay.
> 
> On the other hand, this doesn't seem that useful. If qemu tries to
> migrate and the device fails then the migration operation is toast and
> possibly the device is wrecked. It can't really issue a FLR without
> coordinating with the VM, and it cannot resume the VM as the device is
> now irrecoverably messed up.
> 
> If we look at this from a RAS perspective would would be useful here
> is a way for qemu to request a fail safe migration data. This must
> always be available and cannot fail.
> 
> When the failsafe is loaded into the device it would trigger the
> device's built-in RAS features to co-ordinate with the VM driver and
> recover. Perhaps qemu would also have to inject an AER or something.
> 
> Basically instead of the device starting in an "empty ready to use
> state" it would start in a "failure detected, needs recovery" state.

The "fail-safe recovery state" is essentially the reset state of the
device.  If a device enters an error state during migration, I would
think the ultimate recovery procedure would be to abort the migration,
send an AER to the VM, whereby the guest would trigger a reset, and
the RAS capabilities of the guest would handle failing over to a
multipath device, ejecting the failing device, etc.

However, regardless of the migration recovery strategy, userspace needs
a means to get the device back into an initial state in a deterministic
way without closing and re-opening the device (or polling for an
arbitrary length of time).  That's the minimum viable product here.
Thanks,

Alex

