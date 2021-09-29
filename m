Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D16641C614
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 15:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344359AbhI2NwG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 09:52:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40368 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344335AbhI2NwF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 Sep 2021 09:52:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632923424;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FhEYkN6eSJLZP/cV07GjlQRPbO9M+hVC+ywwE/y96y8=;
        b=gQK76sl0FvYqaD1odf2Z2KuG6zgTpvNQwU4Zv+xKc05+2uDPRDyLibfjDUpcHJUAo4C6sq
        T74xunXtmbaH/8oIHNryXD4+f0SVPGuu8nsJ8otXKr8ClO1++r6LKk26TZkvLM+J0ZJU4G
        6svfH80RHrtOqX9S3H6Hyrgsg+euFek=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-391-5UgphUlAOP6gVWTj2Pi9IQ-1; Wed, 29 Sep 2021 09:50:22 -0400
X-MC-Unique: 5UgphUlAOP6gVWTj2Pi9IQ-1
Received: by mail-oo1-f70.google.com with SMTP id r82-20020a4a3755000000b002b5eb748127so2210453oor.19
        for <kvm@vger.kernel.org>; Wed, 29 Sep 2021 06:50:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=FhEYkN6eSJLZP/cV07GjlQRPbO9M+hVC+ywwE/y96y8=;
        b=HS/8kLKK1HgPIbQXg/oKhHTF3ztVsGER+oegIFNqUuv/MPe9wqsVxezu1liuiMGNTj
         pDdk6YU7papZ5+1ikWWAG0BJg/Ex0MQlPkOdy6GzkLqG0zEf5SPBDWscMHHNHCBmJISK
         xI+pJ1Owj+IPp6xEhCEnLzmbCCzFn3QznEwWEcESZEdW/sLc3aC9W0uJkJzWSVygXhYe
         o1rP7OClt0PxOkxeQqaCLe6jnkxoTyBAGjvrLwE5cKZ9ebIxXsGrYMUjpGT4zYGKGjOa
         blogiLMFHMitC55MMA1ZJckDBlU/I5VVYh1VDobmFSNFBM8XUz/HVXwfvfwONH9claCs
         GnHg==
X-Gm-Message-State: AOAM531XsNuzLat/FX8jpe4NhFnQ2KsBFXG/YDLAA9N/oRb41X/PaH0Y
        AQjXgHsDIVJQVEQOLW6j2ErarfDNp/YWYACtSViSwqMMTuntxeEi5Q5eD6Q4yhxrYoMFhl3yZTv
        yz8DpEiaNzY4+
X-Received: by 2002:aca:adc5:: with SMTP id w188mr8119143oie.40.1632923421714;
        Wed, 29 Sep 2021 06:50:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyBuOrTDixbcm+glLpv+7QenclxccxJ6UkYSq7KtnLZB5CHTBD74Coi0b7Um+05XIgMwgd7Pg==
X-Received: by 2002:aca:adc5:: with SMTP id w188mr8119119oie.40.1632923421462;
        Wed, 29 Sep 2021 06:50:21 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id p8sm458585oti.15.2021.09.29.06.50.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 06:50:21 -0700 (PDT)
Date:   Wed, 29 Sep 2021 07:50:19 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        "Doug Ledford" <dledford@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "Bjorn Helgaas" <bhelgaas@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH mlx5-next 2/7] vfio: Add an API to check migration state
 transition validity
Message-ID: <20210929075019.48d07deb.alex.williamson@redhat.com>
In-Reply-To: <1eba059c-4743-4675-9f72-1a26b8f3c0f6@nvidia.com>
References: <cover.1632305919.git.leonro@nvidia.com>
        <c87f55d6fec77a22b110d3c9611744e6b28bba46.1632305919.git.leonro@nvidia.com>
        <20210927164648.1e2d49ac.alex.williamson@redhat.com>
        <20210927231239.GE3544071@ziepe.ca>
        <25c97be6-eb4a-fdc8-3ac1-5628073f0214@nvidia.com>
        <20210929063551.47590fbb.alex.williamson@redhat.com>
        <1eba059c-4743-4675-9f72-1a26b8f3c0f6@nvidia.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 29 Sep 2021 16:26:55 +0300
Max Gurtovoy <mgurtovoy@nvidia.com> wrote:

> On 9/29/2021 3:35 PM, Alex Williamson wrote:
> > On Wed, 29 Sep 2021 13:44:10 +0300
> > Max Gurtovoy <mgurtovoy@nvidia.com> wrote:
> >  
> >> On 9/28/2021 2:12 AM, Jason Gunthorpe wrote:  
> >>> On Mon, Sep 27, 2021 at 04:46:48PM -0600, Alex Williamson wrote:  
> >>>>> +	enum { MAX_STATE = VFIO_DEVICE_STATE_RESUMING };
> >>>>> +	static const u8 vfio_from_state_table[MAX_STATE + 1][MAX_STATE + 1] = {
> >>>>> +		[VFIO_DEVICE_STATE_STOP] = {
> >>>>> +			[VFIO_DEVICE_STATE_RUNNING] = 1,
> >>>>> +			[VFIO_DEVICE_STATE_RESUMING] = 1,
> >>>>> +		},  
> >>>> Our state transition diagram is pretty weak on reachable transitions
> >>>> out of the _STOP state, why do we select only these two as valid?  
> >>> I have no particular opinion on specific states here, however adding
> >>> more states means more stuff for drivers to implement and more risk
> >>> driver writers will mess up this uAPI.  
> >> _STOP == 000b => Device Stopped, not saving or resuming (from UAPI).
> >>
> >> This is the default initial state and not RUNNING.
> >>
> >> The user application should move device from STOP => RUNNING or STOP =>
> >> RESUMING.
> >>
> >> Maybe we need to extend the comment in the UAPI file.  
> >
> > include/uapi/linux/vfio.h:
> > ...
> >   *  +------- _RESUMING
> >   *  |+------ _SAVING
> >   *  ||+----- _RUNNING
> >   *  |||
> >   *  000b => Device Stopped, not saving or resuming
> >   *  001b => Device running, which is the default state
> >                              ^^^^^^^^^^^^^^^^^^^^^^^^^^
> > ...
> >   * State transitions:
> >   *
> >   *              _RESUMING  _RUNNING    Pre-copy    Stop-and-copy   _STOP
> >   *                (100b)     (001b)     (011b)        (010b)       (000b)
> >   * 0. Running or default state
> >   *                             |
> >                   ^^^^^^^^^^^^^
> > ...
> >   * 0. Default state of VFIO device is _RUNNING when the user application starts.
> >        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >
> > The uAPI is pretty clear here.  A default state of _STOP is not
> > compatible with existing devices and userspace that does not support
> > migration.  Thanks,  
> 
> Why do you need this state machine for userspace that doesn't support 
> migration ?

For userspace that doesn't support migration, there's one state,
_RUNNING.  That's what we're trying to be compatible and consistent
with.  Migration is an extension, not a base requirement.

> What is the definition of RUNNING state for a paused VM that is waiting 
> for incoming migration blob ?

A VM supporting migration of the device would move the device to
_RESUMING to load the incoming data.  If the VM leaves the device in
_RUNNING, then it doesn't support migration of the device and it's out
of scope how it handles that device state.  Existing devices continue
running regardless of whether the VM state is paused, it's only devices
supporting migration where userspace could optionally have the device
run state follow the VM run state.  Thanks,

Alex

