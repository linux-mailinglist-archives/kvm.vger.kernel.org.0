Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E843439892
	for <lists+kvm@lfdr.de>; Mon, 25 Oct 2021 16:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbhJYObZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Oct 2021 10:31:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:34489 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231295AbhJYObY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Oct 2021 10:31:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635172141;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LDsQ2FyfZYxCUBHDJ/Wy3aAR2LqJdJxwE0UoTGKu700=;
        b=CawGJTT3T8q9C1chUBmfIRcKG68glJOxAzwUxuMvXbFvCQNbcR/F7dyMzhmbgnVGGmXiMd
        jWeXA6/Md4WyB9pphEv0W9n/thFnZEmQnBZfJpIJ1YKR2avTUaLEAQWcj0g+2HsN7CJvC6
        Lra4YBGR3unSuCRlZ6ssF3msX2XYsmY=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-0Y5YqIZ5Mti6H6CBrCQpbA-1; Mon, 25 Oct 2021 10:29:00 -0400
X-MC-Unique: 0Y5YqIZ5Mti6H6CBrCQpbA-1
Received: by mail-oo1-f71.google.com with SMTP id g11-20020a4a924b000000b002b76277c71bso4240880ooh.22
        for <kvm@vger.kernel.org>; Mon, 25 Oct 2021 07:29:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LDsQ2FyfZYxCUBHDJ/Wy3aAR2LqJdJxwE0UoTGKu700=;
        b=kH41BZ50a2ruJU9CRnmC793keJRtHVjKmAyNZ1M7cg1Ta95jRsy9m/N+X4yEPJRpk0
         8zW13rR4BYbjgNBCAHougF3W4KxttmTqNkSzdH6WHedCQTsodPV4OCeg47i1u66TWUfH
         bOHVuHl5tKaa39UigksO5pnwmPs5c5nCUjLd1lfz9HDN0+my5dN7jBwGTAFH+ED62l7d
         PvHfiymGYA/tXVfxMd4jp4dficO/qHvrECyebZRtuuL+rm7fH+vp0d4IEG9ovVX+3HjW
         TlUrGD0Ryknb81u8ISoTha98fxG3Vf5Zq+HTDRE4NG2Ltx+dOCWJy558o459AHWJ2YQ0
         YHSA==
X-Gm-Message-State: AOAM5333t/oUjIxYolfm3b5JLH2akdkxmduMskMPkiy2NerJH3U+HXEG
        EX9UbhJdbxrBIExIPBVML+rUDD3ypil0y74a9tHAUidOuJAV7ITMgK1k3EqfDHEhYHeg4RZcsef
        15kVwOi1mVbdl
X-Received: by 2002:aca:ac0b:: with SMTP id v11mr22980382oie.155.1635172139862;
        Mon, 25 Oct 2021 07:28:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw0tBoMBSsPKFijiSIgVS8cQtM/i4EmqtLNvPHgvRIRjx7ycFadBpIonJi6b+CwH1sy0fFSWQ==
X-Received: by 2002:aca:ac0b:: with SMTP id v11mr22980358oie.155.1635172139646;
        Mon, 25 Oct 2021 07:28:59 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id l10sm3577102otj.9.2021.10.25.07.28.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 07:28:59 -0700 (PDT)
Date:   Mon, 25 Oct 2021 08:28:57 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <20211025082857.4baa4794.alex.williamson@redhat.com>
In-Reply-To: <20211025122938.GR2744544@nvidia.com>
References: <20211019124352.74c3b6ba.alex.williamson@redhat.com>
        <20211019192328.GZ2744544@nvidia.com>
        <20211019145856.2fa7f7c8.alex.williamson@redhat.com>
        <20211019230431.GA2744544@nvidia.com>
        <5a496713-ae1d-11f2-1260-e4c1956e1eda@nvidia.com>
        <20211020105230.524e2149.alex.williamson@redhat.com>
        <20211020185919.GH2744544@nvidia.com>
        <20211020150709.7cff2066.alex.williamson@redhat.com>
        <87o87isovr.fsf@redhat.com>
        <20211021154729.0e166e67.alex.williamson@redhat.com>
        <20211025122938.GR2744544@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 25 Oct 2021 09:29:38 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Thu, Oct 21, 2021 at 03:47:29PM -0600, Alex Williamson wrote:
> > I recall that we previously suggested a very strict interpretation of
> > clearing the _RUNNING bit, but again I'm questioning if that's a real
> > requirement or simply a nice-to-have feature for some undefined
> > debugging capability.  In raising the p2p DMA issue, we can see that a
> > hard stop independent of other devices is not really practical but I
> > also don't see that introducing a new state bit solves this problem any
> > more elegantly than proposed here.  Thanks,  
> 
> I still disagree with this - the level of 'frozenness' of a device is
> something that belongs in the defined state exposed to userspace, not
> as a hidden internal state that userspace can't see.
> 
> It makes the state transitions asymmetric between suspend/resume as
> resume does have a defined uAPI state for each level of frozeness and
> suspend does not.
> 
> With the extra bit resume does:
>   
>   0000, 0100, 1000, 0001
> 
> And suspend does:
> 
>   0001, 1001, 0010, 0000
> 
> However, without the extra bit suspend is only
>   
>   001,  010, 000
> 
> With hidden state inside the 010

And what is the device supposed to do if it receives a DMA while in
this strictly defined stopped state?  If it generates an unsupported
request, that can trigger a fatal platform error.  If it silently drops
the DMA, then we have data loss.  We're defining a catch-22 scenario
for drivers versus placing the onus on the user to quiesce the set of
devices in order to consider the migration status as valid.  Thanks,

Alex

