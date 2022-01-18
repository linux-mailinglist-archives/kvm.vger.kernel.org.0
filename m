Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB27E492ECC
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 20:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245642AbiARTz3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 14:55:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:31599 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244963AbiARTz3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 14:55:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642535727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ofvV1R+RFDjMNO1WTV5A20W2QGm4IV1SZxFvX5NJtrs=;
        b=I3i3DU1VlDV9Np9tV1mG2jTX5YtaAlg38D2hyh+iCLFa0uWiUNZ6elv8IwT828BJ5h9k6S
        +gKV8X0qQwEr7yHLyPwsJfRhOIXgJa3YW4vh8NTwO9T9KCW2ZQxbXQjL2ECksLC0GvpPrO
        ISrLHGso77Ctc2NpSsRVOqNlSfFRiWM=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-655-Zr81ZR4EOqyzAV5ts7At2w-1; Tue, 18 Jan 2022 14:55:26 -0500
X-MC-Unique: Zr81ZR4EOqyzAV5ts7At2w-1
Received: by mail-oo1-f69.google.com with SMTP id z48-20020a4a9873000000b002c29a99164cso35467ooi.20
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 11:55:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ofvV1R+RFDjMNO1WTV5A20W2QGm4IV1SZxFvX5NJtrs=;
        b=j2XnOgMMMLycJMAUOgJnC/rB+iJBDGwB9NyIkO3OAANezmCzjU9E6IVyVpz+xhNQv/
         5OJ6y6fW5p6q3MkGfEV0fOjuA4VJB+G7Q5Kfe1gz6Ol8hKEQon/nC08JdEAAviDee8+e
         8HJrdRfCy5pa0Mwvp8imyiaUzWYLMNShnWBQAlz+91VpN5RsyxB+w0KygQNmu7Wj7gii
         6izdK6OOSeNincITIK65Wr4b5P1RD9luiUmIguozI0LcV58qm1JSDoYWvHvSRF5KPRfH
         /eEVMK20jZMuVKNY6OSpsVyi1AqCzc91mMVYwCa5MelcXsUZYPeDxYcySF8/3dga3Q2h
         p2qA==
X-Gm-Message-State: AOAM531POiNro6xbCkZ0k5Lx0CJpbokGfK44GcGukiGj7CYC5AYBMHmE
        H5DsNrNxZjdCWVWpVUn/RHS/cA1KZXhOGKo1NiuIDUtwjwsW+JSek3eI8S1AVqolueN0ilmuAzR
        MqvS0sHA5tdyN
X-Received: by 2002:a9d:c07:: with SMTP id 7mr12456524otr.221.1642535725054;
        Tue, 18 Jan 2022 11:55:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzeTYX7yM88pajuiK0pgjaeWJ15qIXzAFm1vGXMM2k+lWuqTcvvBM0m7tEG8H8bKGICPWgmtQ==
X-Received: by 2002:a9d:c07:: with SMTP id 7mr12456465otr.221.1642535724137;
        Tue, 18 Jan 2022 11:55:24 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id 64sm900310oif.8.2022.01.18.11.55.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 11:55:23 -0800 (PST)
Date:   Tue, 18 Jan 2022 12:55:22 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC] vfio: Revise and update the migration uAPI
 description
Message-ID: <20220118125522.6c6bb1bb.alex.williamson@redhat.com>
In-Reply-To: <0-v1-a4f7cab64938+3f-vfio_mig_states_jgg@nvidia.com>
References: <0-v1-a4f7cab64938+3f-vfio_mig_states_jgg@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 14 Jan 2022 15:35:14 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> Clarify how the migration API works by recasting its specification from a
> bunch of bits into a formal FSM. This describes the same functional
> outcome, with no practical ABI change.

I don't understand why we're so reluctant to drop the previous
specification and call this v2.  Yes, it's clever that the enum for the
FSM matches the bit definitions, but we're also inserting previously
invalid states as a standard part of the device flow... (see below)

> Compared to the clarification Alex proposed:
> 
> https://lore.kernel.org/r/163909282574.728533.7460416142511440919.stgit@omen
> 
> this has a few deliberate functional differences:
> 
>  - STOP_COPY -> PRE_COPY is made optional and to be defined in
>    future. This is motivated by the realization that mlx5 and other
>    devices that don't implement pre-copy cannot really achieve this
>    without a lot of work. We know of no user space that issues this
>    transition, so there is no practical ABI break to fail it.
> 
>  - ERROR arcs allow the device function to remain unchanged. Reviewing the
>    driver design in this series makes it clear there is no advantage to
>    putting more complexity in the kernel. If the device has a double
>    fault, then userspace already has all the necessary tools to clean it
>    up.
> 
>  - NDMA is redefined into two FSM states and is described in terms of the
>    desired P2P quiescent behavior, noting that halting all DMA is an
>    acceptable implementation.
> 
> First, each of the 6 existing valid values of device_state are recast into
> FSM states using the names from the current comment. The two new states
> for P2P are inserted in the two invalid numbers giving a packed definition
> of all 8 states. As the numbers match the existing ABI there is no change.
> 
> Next, we define a set of FSM arcs which the driver will directly
> implement. Each of the 15 FSM arcs is listed and Alex's clarification
> wording is substantially reused to describe how they should operate.
> 
> Finally, we define the remaining set of old/new device_state transitions
> as 'combination transitions' which are naturally defined as taking
> multiple FSM arcs along the shortest path within the FSM's digraph. Two
> rules are defined which result in an unambiguous specification.
> 
> The kernel will fully support all possible transitions automatically by
> either executing the FSM arc directly, or by following the defined path
> and executing each step's FSM arc. It allows all drivers to automatically
> and consistently support all device_state writes in the original 5 states,
> except for STOP_COPY -> PRE_COPY. This fulfills the original concept of
> the ABI of allowing all combinations of device_state transitions.
> 
> In terms of code, the driver is responsible to implement all of the FSM
> arcs and the core code implements the combination transitions. This
> ensures that every driver implements the combination transitions in the
> same way, and insulates the driver from this complexity. The shortest
> paths, with the ambiguity resolved, are all precomputed and stored in a 64
> byte lookup table.
> 
> Further, the complicated error unwind in the combination transitions is
> solved for all drivers by having the core code attempt to return back to
> the starting state through a natural sequence of FSM arcs. Should this be
> impossible, or a double fault happens, the ERROR state is invoked.
> 
> The FSM approach proves extensible in the future as new additional states
> and arcs can be added to the FSM. The combination transitions logic will
> automatically walk through these new arcs providing backwards
> compatibility, and it is easy for the core to insulate drivers that do not
> support new states from ever seeing them while still using a single FSM
> digraph as the behavioral specification. A separate patch, to be included
> with the first driver that requires it, demonstrates how this works for
> the optional P2P states.
> 
> A following patch in the series introduces a simple query IOCTL that
> identifies what FSM arcs the device supports allowing extensible
> discoverability.
> 
> The old uAPI definitions are removed from the header file. As per Linus's
> past remarks we do not have a hard requirement to retain compilation
> compatibility in uapi headers and qemu is already following Linus's
> preferred model of copying the kernel headers. As the ABI functionality is
> preserved this is only a compilation break.
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/vfio.c       | 236 +++++++++++++++++++
>  include/linux/vfio.h      |   5 +
>  include/uapi/linux/vfio.h | 461 +++++++++++++++++++++-----------------
>  3 files changed, 499 insertions(+), 203 deletions(-)
> 
> This is RFC because the full series is not fully tested yet, that should be
> done next week. The series can be previewed here:
> 
>   https://github.com/jgunthorpe/linux/commits/mlx5_vfio_pci
> 
> The mlx5 implementation of the state change:
> 
>   https://github.com/jgunthorpe/linux/blob/0a6416da226fe8ee888aa8026f1e363698e137a8/drivers/vfio/pci/mlx5/main.c#L264
> 
> Has turned out very clean. Compare this to the v5 version, which is full of
> subtle bugs:
> 
>   https://lore.kernel.org/kvm/20211027095658.144468-12-yishaih@nvidia.com/
> 
> This patch adds the VFIO_DEVICE_MIG_ARC_SUPPORTED ioctl:
> 
>   https://github.com/jgunthorpe/linux/commit/c92eff6c2afd1ecc9ed5c67a1f81c7f270f6e940
> 
> And this shows how the Huawei driver should opt out of P2P arcs:
> 
>   https://github.com/jgunthorpe/linux/commit/dd2571c481d27546a33ff4583ce8ad49847fe300

We've been bitten several times by device support that didn't come to
be in this whole vfio migration effort.  Let's imagine that all devices
initially support these P2P states and adding any sort of opt-out would
be dead code.  The specification below doesn't propose the
ARC_SUPPORTED ioctl and userspace is implemented with some vague notion
that these states may not be implemented, but has no means to test.
Userspace is written to support the P2P arcs and fail on state
transition failures.

At some point later hns support is ready, it supports the migration
region, but migration fails with all existing userspace written to the
below spec.  I can't imagine that a device advertising migration, but it
being essentially guaranteed to fail is a viable condition and we can't
retroactively add this proposed ioctl to existing userspace binaries.
I think our recourse here would be to rev the migration sub-type again
so that userspace that doesn't know about devices that lack P2P won't
enable migration support.

So I think this ends up being a poor example of how to extend the uAPI.
An opt-out for part of the base specification is hard, it's much easier
to opt-in P2P as a feature.

 
> Finally, this helper script was used to audit the FSM construction, the commit
> is informative to help understand the details:
> 
>   https://github.com/jgunthorpe/linux/commit/0a6416da226fe8ee888aa8026f1e363698e137a8
> 
> I think this should resolve all the disconnect. It keeps the uAPI practically
> unchanged while strongly defining it in precise terms of what arcs a driver
> must implement. The core code deals with the troublesome precedence and error
> issue in a way that is intuitive to understand. It is now actually easy to
> audit a driver for correct implementation.
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 735d1d344af9d4..96001f03bc39f1 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -1557,6 +1557,242 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
>  	return 0;
>  }
>  
> +enum {
> +	VFIO_MIG_FSM_MAX_STATE = VFIO_DEVICE_STATE_RUNNING_P2P + 1,
> +};

We have existing examples of using VFIO_foo_NUM_bar in the vfio uAPI
already, let's follow that lead.

> +
> +/*
> + * vfio_mig_get_next_state - Compute the next step in the FSM
> + * @cur_fsm - The current state the device is in
> + * @new_fsm - The target state to reach
> + *
> + * Return the next step in the state progression between cur_fsm and
> + * new_fsm. This breaks down requests for complex transitions into
> + * smaller steps and returns the next step to get to new_fsm. The
> + * function may need to be called up to four times before reaching new_fsm.
> + *
> + * VFIO_DEVICE_STATE_ERROR is returned if the state transition is not allowed.
> + */
> +static u32 vfio_mig_get_next_state(u32 cur_fsm, u32 new_fsm)

Can we use a typedef somewhere for type checking?

> +{
> +	/*
> +	 * The coding in this table requires the driver to implement 15
> +	 * FSM arcs:
> +	 *        PRE_COPY -> PRE_COPY_P2P
> +	 *        PRE_COPY -> RUNNING
> +	 *        PRE_COPY_P2P -> PRE_COPY
> +	 *        PRE_COPY_P2P -> RUNNING_P2P
> +	 *        PRE_COPY_P2P -> STOP_COPY
> +	 *        RESUMING -> STOP
> +	 *        RUNNING -> PRE_COPY
> +	 *        RUNNING -> RUNNING_P2P
> +	 *        RUNNING_P2P -> PRE_COPY_P2P
> +	 *        RUNNING_P2P -> RUNNING
> +	 *        RUNNING_P2P -> STOP
> +	 *        STOP -> RESUMING
> +	 *        STOP -> RUNNING_P2P
> +	 *        STOP -> STOP_COPY
> +	 *        STOP_COPY -> STOP
> +	 *
> +	 * The coding will step through multiple states for these combination
> +	 * transitions:
> +	 *        PRE_COPY -> PRE_COPY_P2P -> STOP_COPY
> +	 *        PRE_COPY -> RUNNING -> RUNNING_P2P
> +	 *        PRE_COPY -> RUNNING -> RUNNING_P2P -> STOP
> +	 *        PRE_COPY -> RUNNING -> RUNNING_P2P -> STOP -> RESUMING
> +	 *        PRE_COPY_P2P -> RUNNING_P2P -> RUNNING
> +	 *        PRE_COPY_P2P -> RUNNING_P2P -> STOP
> +	 *        PRE_COPY_P2P -> RUNNING_P2P -> STOP -> RESUMING
> +	 *        RESUMING -> STOP -> RUNNING_P2P
> +	 *        RESUMING -> STOP -> RUNNING_P2P -> PRE_COPY_P2P
> +	 *        RESUMING -> STOP -> RUNNING_P2P -> RUNNING
> +	 *        RESUMING -> STOP -> RUNNING_P2P -> RUNNING -> PRE_COPY
> +	 *        RESUMING -> STOP -> STOP_COPY
> +	 *        RUNNING -> RUNNING_P2P -> PRE_COPY_P2P
> +	 *        RUNNING -> RUNNING_P2P -> STOP
> +	 *        RUNNING -> RUNNING_P2P -> STOP -> RESUMING
> +	 *        RUNNING -> RUNNING_P2P -> STOP -> STOP_COPY
> +	 *        RUNNING_P2P -> RUNNING -> PRE_COPY
> +	 *        RUNNING_P2P -> STOP -> RESUMING
> +	 *        RUNNING_P2P -> STOP -> STOP_COPY
> +	 *        STOP -> RUNNING_P2P -> PRE_COPY_P2P
> +	 *        STOP -> RUNNING_P2P -> RUNNING
> +	 *        STOP -> RUNNING_P2P -> RUNNING -> PRE_COPY
> +	 *        STOP_COPY -> STOP -> RESUMING
> +	 *        STOP_COPY -> STOP -> RUNNING_P2P
> +	 *        STOP_COPY -> STOP -> RUNNING_P2P -> RUNNING
> +	 *
> +	 *  The following transitions are blocked:
> +	 *        STOP_COPY -> PRE_COPY
> +	 *        STOP_COPY -> PRE_COPY_P2P
> +	 */
> +	static const u8 vfio_from_fsm_table[VFIO_MIG_FSM_MAX_STATE][VFIO_MIG_FSM_MAX_STATE] = {
> +		[VFIO_DEVICE_STATE_STOP] = {
> +			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_STOP,
> +			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_RUNNING_P2P,
> +			[VFIO_DEVICE_STATE_PRE_COPY] = VFIO_DEVICE_STATE_RUNNING_P2P,
> +			[VFIO_DEVICE_STATE_PRE_COPY_P2P] = VFIO_DEVICE_STATE_RUNNING_P2P,
> +			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_STOP_COPY,
> +			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_RESUMING,
> +			[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_DEVICE_STATE_RUNNING_P2P,
> +			[VFIO_DEVICE_STATE_ERROR] = VFIO_DEVICE_STATE_ERROR,
> +		},
> +		[VFIO_DEVICE_STATE_RUNNING] = {
> +			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_RUNNING_P2P,
> +			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_RUNNING,
> +			[VFIO_DEVICE_STATE_PRE_COPY] = VFIO_DEVICE_STATE_PRE_COPY,
> +			[VFIO_DEVICE_STATE_PRE_COPY_P2P] = VFIO_DEVICE_STATE_RUNNING_P2P,
> +			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_RUNNING_P2P,
> +			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_RUNNING_P2P,
> +			[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_DEVICE_STATE_RUNNING_P2P,
> +			[VFIO_DEVICE_STATE_ERROR] = VFIO_DEVICE_STATE_ERROR,
> +		},
> +		[VFIO_DEVICE_STATE_PRE_COPY] = {
> +			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_RUNNING,
> +			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_RUNNING,
> +			[VFIO_DEVICE_STATE_PRE_COPY] = VFIO_DEVICE_STATE_PRE_COPY,
> +			[VFIO_DEVICE_STATE_PRE_COPY_P2P] = VFIO_DEVICE_STATE_PRE_COPY_P2P,
> +			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_PRE_COPY_P2P,
> +			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_RUNNING,
> +			[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_DEVICE_STATE_RUNNING,
> +			[VFIO_DEVICE_STATE_ERROR] = VFIO_DEVICE_STATE_ERROR,
> +		},
> +		[VFIO_DEVICE_STATE_PRE_COPY_P2P] = {
> +			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_RUNNING_P2P,
> +			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_RUNNING_P2P,
> +			[VFIO_DEVICE_STATE_PRE_COPY] = VFIO_DEVICE_STATE_PRE_COPY,
> +			[VFIO_DEVICE_STATE_PRE_COPY_P2P] = VFIO_DEVICE_STATE_PRE_COPY_P2P,
> +			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_STOP_COPY,
> +			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_RUNNING_P2P,
> +			[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_DEVICE_STATE_RUNNING_P2P,
> +			[VFIO_DEVICE_STATE_ERROR] = VFIO_DEVICE_STATE_ERROR,
> +		},
> +		[VFIO_DEVICE_STATE_STOP_COPY] = {
> +			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_STOP,
> +			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_STOP,
> +			[VFIO_DEVICE_STATE_PRE_COPY] = VFIO_DEVICE_STATE_ERROR,
> +			[VFIO_DEVICE_STATE_PRE_COPY_P2P] = VFIO_DEVICE_STATE_ERROR,
> +			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_STOP_COPY,
> +			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_STOP,
> +			[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_DEVICE_STATE_STOP,
> +			[VFIO_DEVICE_STATE_ERROR] = VFIO_DEVICE_STATE_ERROR,
> +		},
> +		[VFIO_DEVICE_STATE_RESUMING] = {
> +			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_STOP,
> +			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_STOP,
> +			[VFIO_DEVICE_STATE_PRE_COPY] = VFIO_DEVICE_STATE_STOP,
> +			[VFIO_DEVICE_STATE_PRE_COPY_P2P] = VFIO_DEVICE_STATE_STOP,
> +			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_STOP,
> +			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_RESUMING,
> +			[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_DEVICE_STATE_STOP,
> +			[VFIO_DEVICE_STATE_ERROR] = VFIO_DEVICE_STATE_ERROR,
> +		},
> +		[VFIO_DEVICE_STATE_RUNNING_P2P] = {
> +			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_STOP,
> +			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_RUNNING,
> +			[VFIO_DEVICE_STATE_PRE_COPY] = VFIO_DEVICE_STATE_RUNNING,
> +			[VFIO_DEVICE_STATE_PRE_COPY_P2P] = VFIO_DEVICE_STATE_PRE_COPY_P2P,
> +			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_STOP,
> +			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_STOP,
> +			[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_DEVICE_STATE_RUNNING_P2P,
> +			[VFIO_DEVICE_STATE_ERROR] = VFIO_DEVICE_STATE_ERROR,
> +		},
> +		[VFIO_DEVICE_STATE_ERROR] = {
> +			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_ERROR,
> +			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_ERROR,
> +			[VFIO_DEVICE_STATE_PRE_COPY] = VFIO_DEVICE_STATE_ERROR,
> +			[VFIO_DEVICE_STATE_PRE_COPY_P2P] = VFIO_DEVICE_STATE_ERROR,
> +			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_ERROR,
> +			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_ERROR,
> +			[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_DEVICE_STATE_ERROR,
> +			[VFIO_DEVICE_STATE_ERROR] = VFIO_DEVICE_STATE_ERROR,
> +		},
> +	};
> +	return vfio_from_fsm_table[cur_fsm][new_fsm];
> +}
> +
> +static bool vfio_mig_in_saving_group(u32 state)
> +{
> +	return state == VFIO_DEVICE_STATE_PRE_COPY ||
> +	       state == VFIO_DEVICE_STATE_PRE_COPY_P2P ||
> +	       state == VFIO_DEVICE_STATE_STOP_COPY;
> +}
> +
> +/*
> + * vfio_mig_set_device_state - Change the migration device_state
> + * @device - The VFIO device to act on
> + * @target_device_state - The new state from the uAPI
> + * @cur_state - Pointer to the drivers current migration FSM state
> + *
> + * This validates target_device_state and then calls
> + * ops->migration_step_device_state() enough times to achieve the target state.
> + * See vfio_mig_get_next_state() for the required arcs.
> + *
> + * If the op callback fails then the driver should leave the device state
> + * unchanged and return errno, should this not be possible then it should set
> + * cur_state to VFIO_DEVICE_STATE_ERROR and return errno.
> + *
> + * If a step fails then this attempts to reverse the FSM back to the original
> + * state, should that fail it is set to VFIO_DEVICE_STATE_ERROR and error is
> + * returned.
> + */
> +int vfio_mig_set_device_state(struct vfio_device *device, u32 target_state,
> +			      u32 *cur_state)
> +{
> +	u32 starting_state = *cur_state;
> +	u32 next_state;
> +	int ret;
> +
> +	if (target_state >= VFIO_MIG_FSM_MAX_STATE)
> +		return -EINVAL;
> +
> +	while (*cur_state != target_state) {
> +		next_state = vfio_mig_get_next_state(*cur_state, target_state);
> +		if (next_state == VFIO_DEVICE_STATE_ERROR) {
> +			ret = -EINVAL;
> +			goto out_restore_state;
> +		}
> +		ret = device->ops->migration_step_device_state(device,
> +							       next_state);
> +		if (ret)
> +			goto out_restore_state;
> +		*cur_state = next_state;
> +	}
> +	return 0;
> +
> +out_restore_state:
> +	if (*cur_state == VFIO_DEVICE_STATE_ERROR)
> +		return ret;
> +	/*
> +	 * If the window as initialized, and we closed the window, then we
> +	 * cannot recover the old state.
> +	 */
> +	if ((vfio_mig_in_saving_group(starting_state) &&
> +	     !vfio_mig_in_saving_group(*cur_state)) ||
> +	    (starting_state == VFIO_DEVICE_STATE_RESUMING &&
> +	     *cur_state != VFIO_DEVICE_STATE_RESUMING)) {
> +		*cur_state = VFIO_DEVICE_STATE_ERROR;
> +		return ret;
> +	}
> +
> +	/*
> +	 * Make a best effort to restore things back to where we started.
> +	 */
> +	while (*cur_state != starting_state) {
> +		next_state =
> +			vfio_mig_get_next_state(*cur_state, starting_state);
> +		if (next_state == VFIO_DEVICE_STATE_ERROR ||
> +		    device->ops->migration_step_device_state(device,
> +							     next_state)) {
> +			*cur_state = VFIO_DEVICE_STATE_ERROR;
> +			break;
> +		}
> +		*cur_state = next_state;
> +	}

Core code "transitioning" the device to ERROR seems a little suspect
here.  I guess you're imagining that driver code calling this with an
pointer to internal state that it also tests on a non-zero return.
Should we just step-device-state to ERROR to directly inform the driver?


> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(vfio_mig_set_device_state);
> +
>  static long vfio_device_fops_unl_ioctl(struct file *filep,
>  				       unsigned int cmd, unsigned long arg)
>  {
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 76191d7abed185..5c96ef5e8d5202 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -69,6 +69,8 @@ struct vfio_device_ops {
>  	int	(*mmap)(struct vfio_device *vdev, struct vm_area_struct *vma);
>  	void	(*request)(struct vfio_device *vdev, unsigned int count);
>  	int	(*match)(struct vfio_device *vdev, char *buf);
> +	int     (*migration_step_device_state)(struct vfio_device *device,
> +					       u32 next_state);
>  };
>  
>  void vfio_init_group_dev(struct vfio_device *device, struct device *dev,
> @@ -82,6 +84,9 @@ extern void vfio_device_put(struct vfio_device *device);
>  
>  int vfio_assign_device_set(struct vfio_device *device, void *set_id);
>  
> +int vfio_mig_set_device_state(struct vfio_device *device, u32 target_state,
> +			      u32 *cur_state);
> +
>  /*
>   * External user API
>   */
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index ef33ea002b0b31..42e0ab905d2df7 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -408,223 +408,278 @@ struct vfio_region_gfx_edid {
>  #define VFIO_REGION_SUBTYPE_MIGRATION           (1)
>  
>  /*
> - * The structure vfio_device_migration_info is placed at the 0th offset of
> - * the VFIO_REGION_SUBTYPE_MIGRATION region to get and set VFIO device related
> - * migration information. Field accesses from this structure are only supported
> - * at their native width and alignment. Otherwise, the result is undefined and
> - * vendor drivers should return an error.
> + * The structure vfio_device_migration_info is placed at the immediate start
> + * of the per-device VFIO_REGION_SUBTYPE_MIGRATION region to manage the device
> + * state and migration information for the device.  Field accesses for this
> + * structure are only supported using their native width and alignment,
> + * accesses otherwise are undefined, and the kernel migration driver should
> + * return an error.
>   *
>   * device_state: (read/write)
> - *      - The user application writes to this field to inform the vendor driver
> - *        about the device state to be transitioned to.
> - *      - The vendor driver should take the necessary actions to change the
> - *        device state. After successful transition to a given state, the
> - *        vendor driver should return success on write(device_state, state)
> - *        system call. If the device state transition fails, the vendor driver
> - *        should return an appropriate -errno for the fault condition.
> - *      - On the user application side, if the device state transition fails,
> - *	  that is, if write(device_state, state) returns an error, read
> - *	  device_state again to determine the current state of the device from
> - *	  the vendor driver.
> - *      - The vendor driver should return previous state of the device unless
> - *        the vendor driver has encountered an internal error, in which case
> - *        the vendor driver may report the device_state VFIO_DEVICE_STATE_ERROR.
> - *      - The user application must use the device reset ioctl to recover the
> - *        device from VFIO_DEVICE_STATE_ERROR state. If the device is
> - *        indicated to be in a valid device state by reading device_state, the
> - *        user application may attempt to transition the device to any valid
> - *        state reachable from the current state or terminate itself.
> - *
> - *      device_state consists of 3 bits:
> - *      - If bit 0 is set, it indicates the _RUNNING state. If bit 0 is clear,
> - *        it indicates the _STOP state. When the device state is changed to
> - *        _STOP, driver should stop the device before write() returns.
> - *      - If bit 1 is set, it indicates the _SAVING state, which means that the
> - *        driver should start gathering device state information that will be
> - *        provided to the VFIO user application to save the device's state.
> - *      - If bit 2 is set, it indicates the _RESUMING state, which means that
> - *        the driver should prepare to resume the device. Data provided through
> - *        the migration region should be used to resume the device.
> - *      Bits 3 - 31 are reserved for future use. To preserve them, the user
> - *      application should perform a read-modify-write operation on this
> - *      field when modifying the specified bits.
> - *
> - *  +------- _RESUMING
> - *  |+------ _SAVING
> - *  ||+----- _RUNNING
> - *  |||
> - *  000b => Device Stopped, not saving or resuming
> - *  001b => Device running, which is the default state
> - *  010b => Stop the device & save the device state, stop-and-copy state
> - *  011b => Device running and save the device state, pre-copy state
> - *  100b => Device stopped and the device state is resuming
> - *  101b => Invalid state
> - *  110b => Error state
> - *  111b => Invalid state
> - *
> - * State transitions:
> - *
> - *              _RESUMING  _RUNNING    Pre-copy    Stop-and-copy   _STOP
> - *                (100b)     (001b)     (011b)        (010b)       (000b)
> - * 0. Running or default state
> - *                             |
> - *
> - * 1. Normal Shutdown (optional)
> - *                             |------------------------------------->|
> - *
> - * 2. Save the state or suspend
> - *                             |------------------------->|---------->|
> - *
> - * 3. Save the state during live migration
> - *                             |----------->|------------>|---------->|
> - *
> - * 4. Resuming
> - *                  |<---------|
> - *
> - * 5. Resumed
> - *                  |--------->|
> - *
> - * 0. Default state of VFIO device is _RUNNING when the user application starts.
> - * 1. During normal shutdown of the user application, the user application may
> - *    optionally change the VFIO device state from _RUNNING to _STOP. This
> - *    transition is optional. The vendor driver must support this transition but
> - *    must not require it.
> - * 2. When the user application saves state or suspends the application, the
> - *    device state transitions from _RUNNING to stop-and-copy and then to _STOP.
> - *    On state transition from _RUNNING to stop-and-copy, driver must stop the
> - *    device, save the device state and send it to the application through the
> - *    migration region. The sequence to be followed for such transition is given
> - *    below.
> - * 3. In live migration of user application, the state transitions from _RUNNING
> - *    to pre-copy, to stop-and-copy, and to _STOP.
> - *    On state transition from _RUNNING to pre-copy, the driver should start
> - *    gathering the device state while the application is still running and send
> - *    the device state data to application through the migration region.
> - *    On state transition from pre-copy to stop-and-copy, the driver must stop
> - *    the device, save the device state and send it to the user application
> - *    through the migration region.
> - *    Vendor drivers must support the pre-copy state even for implementations
> - *    where no data is provided to the user before the stop-and-copy state. The
> - *    user must not be required to consume all migration data before the device
> - *    transitions to a new state, including the stop-and-copy state.
> - *    The sequence to be followed for above two transitions is given below.
> - * 4. To start the resuming phase, the device state should be transitioned from
> - *    the _RUNNING to the _RESUMING state.
> - *    In the _RESUMING state, the driver should use the device state data
> - *    received through the migration region to resume the device.
> - * 5. After providing saved device data to the driver, the application should
> - *    change the state from _RESUMING to _RUNNING.
> + *   The device_state field is the current state in a finite state machine
> + *   (FSM) that controls the migration function of the device. A write by the
> + *   user requests the FSM move to the new state. Some general rules govern
> + *   the FSM:
> + *     - The user may read or write the device state register at any time.
> + *     - The kernel migration driver must fully transition the device to the
> + *       new state value before the write(2) operation returns to the user.
> + *     - The kernel migration driver must not generate asynchronous device
> + *       state transitions outside of manipulation by the user or the
> + *       VFIO_DEVICE_RESET ioctl as described below.
> + *     - In the event of a device state transition failure, the kernel
> + *       migration driver must return a write(2) error with appropriate errno
> + *       to the user. Refer to the ERROR arc section below for additional detail
> + *       on error handling.
> + *     - Devices supporting migration via this specification must support the
> + *       VFIO_DEVICE_RESET ioctl and any use of that ioctl must return the
> + *       device migration state to the RUNNING state.
> + *
> + *   There are 6 mandatory states defined as STOP, RUNNING, STOP_COPY,
> + *   PRE_COPY, RESUMING and ERROR plus two optional states PRE_COPY_P2P and
> + *   RESUMING_P2P.
> + *
> + *   When the user writes to the device_state it triggers a transition from
> + *   the current value of device_state to the value written by the user. Some
> + *   transitions are called FSM arcs, and when requested, have the driver
> + *   behavior defined as follows:
> + *
> + *   RUNNING_P2P -> STOP
> + *   STOP_COPY -> STOP
> + *     While in STOP the device must stop the operation of the device.  The
> + *     device must not generate interrupts, DMA, or advance its internal
> + *     state. When stopped the device and kernel migration driver must accept
> + *     and respond to interaction to support external subsystems in the
> + *     STOP state, for example PCI MSI-X and PCI config pace. Failure by
> + *     the user to restrict device access while in STOP must not result in
> + *     error conditions outside the user context (ex. host system faults).
> + *
> + *     The STOP_COPY arc will close the data window.

These data window "sessions" should probably be described as a concept
first.

> + *
> + *   RESUMING -> STOP
> + *     Leaving RESUMING closes the migration region data window and indicates
> + *     the end of a resuming session for the device.  The kernel migration
> + *     driver should complete the incorporation of data written to the
> + *     migration data window into the device internal state and perform final
> + *     validity and consistency checking of the new device state.  If the user
> + *     provided data is found to be incomplete, inconsistent, or otherwise
> + *     invalid, the migration driver must indicate a write(2) error and
> + *     optionally go to the ERROR state as described below. The data window
> + *     is closed.
> + *
> + *     While in STOP the device has the same behavior as other STOP states
> + *     described above.

There is one STOP state, invariant of how the device arrives to it.
The reader can infer from the above statement that the behavior of a
state may be flexible to how the device arrives at the state unless
otherwise specified.

It seems like it would be more clear to describe each state
separately, describe the concept of data window sessions, then
present the valid state transitions.  Thanks,

Alex

> + *
> + *     To abort a RESUMING session the device must be reset.
> + *
> + *   PRE_COPY -> RUNNING
> + *   RUNNING_P2P -> RUNNING
> + *     While in RUNNING the device is fully operational, the device may
> + *     generate interrupts, DMA, respond to MMIO, all vfio device regions are
> + *     functional, and the device may advance its internal state.
> + *
> + *     The PRE_COPY arc will close the data window.
> + *
> + *   PRE_COPY_P2P -> RUNNING_P2P
> + *   RUNNING -> RUNNING_P2P
> + *   STOP -> RUNNING_P2P
> + *     While in RUNNING_P2P the device is partially running in the P2P quiescent
> + *     state defined below.
> + *
> + *     The PRE_COPY arc will close the data window.
> + *
> + *   RUNNING -> PRE_COPY
> + *   RUNNING_P2P -> PRE_COPY_P2P
> + *   STOP -> STOP_COPY
> + *     PRE_COPY, PRE_COPY_P2P and STOP_COPY form the "saving group" of states
> + *     which share the data window. Moving between these states alters what is
> + *     streamed in the data window, but does not close or otherwise effect the
> + *     state of the data window.
> + *
> + *     These arcs begin the process of saving the device state. The device
> + *     initializes the migration region data window and associated fields
> + *     within vfio_device_migration_info for capturing the migration data
> + *     stream for the device. The migration driver may perform actions such as
> + *     enabling dirty logging of device state when entering PRE_COPY or
> + *     PER_COPY_P2P.
> + *
> + *     Each arc does not change the device operation, the device remains RUNNING,
> + *     P2P quiesced or in STOP. The STOP_COPY state is described below in
> + *     PRE_COPY_P2P -> STOP_COPY.
> + *
> + *   PRE_COPY -> PRE_COPY_P2P
> + *     Entering PRE_COPY_P2P continues all the behaviors of PRE_COPY above.
> + *     However, while in the PRE_COPY_P2P state, the device is partially
> + *     running in the P2P quiescent state defined below, like RUNNING_P2P.
> + *
> + *   PRE_COPY_P2P -> PRE_COPY
> + *     This arc allows returning the device to a full RUNNING behavior while
> + *     continuing all the behaviors of PRE_COPY.
> + *
> + *   PRE_COPY_P2P -> STOP_COPY
> + *     While in the STOP_COPY state the device has the same behavior as STOP
> + *     with the addition that the data window continues to stream the
> + *     migration state. End of stream indicates the entire device state has
> + *     been transferred as detailed in the data window protocol below.
> + *
> + *     The user should take steps to restrict access to vfio device regions
> + *     other than the migration region while the device is in STOP_COPY or
> + *     risk corruption of the device migration data stream.
> + *
> + *   STOP -> RESUMING
> + *     Entering the RESUMING state enables and initializes the migration
> + *     region data window and associated fields within struct
> + *     vfio_device_migration_info for restoring the device from a migration
> + *     data stream captured from a COPY session with a compatible device. The
> + *     migration driver may alter/reset the internal device state for this arc
> + *     if required to prepare the device to receive the migration data.
> + *
> + *   STOP_COPY -> PRE_COPY
> + *   STOP_COPY -> PRE_COPY_P2P
> + *     These arcs are not permitted and return error if requested. Future
> + *     revisions of this API may define behaviors for these arcs.
> + *
> + *   any -> ERROR
> + *     ERROR cannot be specified as a device state, however any transition
> + *     request can be failed with an errno return and may then move the
> + *     device_state into ERROR. In this case the device was unable to execute
> + *     the requested arc and was also unable to restore the device to the
> + *     original device_state. The device behavior in ERROR can be any
> + *     combination of allowed behaviors from the FSM path between the current
> + *     and requested device_state. The user can detect the ERROR state by
> + *     reading the device_state after receiving an errno failure to a
> + *     device_state write. To recover from ERROR VFIO_DEVICE_RESET must be
> + *     used to return the device_state back to RUNNING.
> + *
> + *   The peer to peer (P2P) quiescent state is intended to be a quiescent
> + *   state for the device for the purposes of managing multiple devices within
> + *   a user context where peer-to-peer DMA between devices may be active. The
> + *   PRE_COPY_P2P and RUNNING_P2P states must prevent the device from
> + *   initiating any new P2P DMA transactions. If the device can identify P2P
> + *   transactions then it can stop only P2P DMA, otherwise it must stop all
> + *   DMA.  The migration driver must complete any such outstanding operations
> + *   prior to completing the FSM arc into either P2P state.
> + *
> + *   The remaining possible transitions are interpreted as combinations of the
> + *   above FSM arcs. As there are multiple paths through the FSM arcs the path
> + *   should be selected based on the following rules:
> + *     - Selet the shortest path
> + *     - The path can not have saving group states as interior arcs, only
> + *       starting/end states.
> + *   Refer to vfio_mig_get_next_state() for the result of the algorithm.
> + *
> + *   The automatic transit through the FSM arcs that make up the combination
> + *   transition is invisible to the user. The operation either succeeds and
> + *   sets device_state to the new value or fails and leaves it at the original
> + *   value or ERROR.
> + *
> + *   The PRE_COPY_P2P and RESUMING_P2P device_states are optional. If a device
> + *   does not support it then the state cannot be written or read from
> + *   device_state. For the purposes of specification, the state continues to
> + *   exist but modified so that the device is fully operational while in
> + *   either state. When not supported the user will have to request
> + *   combination transitions (ie PRE_COPY -> STOP_COPY / RESUMING -> RUNNING)
> + *   to avoid writing the unsupported device_state value.
>   *
>   * reserved:
> - *      Reads on this field return zero and writes are ignored.
> + *   Reads on this field return zero and writes are ignored.
>   *
>   * pending_bytes: (read only)
> - *      The number of pending bytes still to be migrated from the vendor driver.
> + *   The kernel migration driver uses this field to indicate an estimate of
> + *   the remaining data size (in bytes) for the user to copy while the data
> + *   window is used by the saving group of states. The value should be
> + *   considered volatile, especially while in the PRE_COPY[_P2P] states.
> + *   Userspace uses this field to test whether data is available to be read
> + *   from the data section described below.  Userspace should only consider
> + *   whether the value read is zero or non-zero for the purposes of the
> + *   protocol below.  The user may only consider the migration data stream to
> + *   be end of stream when pending_bytes reports a zero value while the device
> + *   is in STOP_COPY.  The kernel migration driver must not consider the state
> + *   of pending_bytes or the data window when executing arcs, and cannot fail
> + *   any arc because the data window has not reached end of stream. The value
> + *   of this field is undefined outside the saving group of states.
>   *
>   * data_offset: (read only)
> - *      The user application should read data_offset field from the migration
> - *      region. The user application should read the device data from this
> - *      offset within the migration region during the _SAVING state or write
> - *      the device data during the _RESUMING state. See below for details of
> - *      sequence to be followed.
> + *   This field indicates the offset relative to the start of the device
> + *   migration region for the user to collect (COPY) or store (RESUMING)
> + *   migration data for the device following the protocol described below. The
> + *   migration driver may provide sparse mmap support for the migration region
> + *   and use the data_offset field to direct user accesses as appropriate, but
> + *   must not require mmap access when provided.  The value of this field is
> + *   undefined when device_state is not in the saving group of states.
>   *
>   * data_size: (read/write)
> - *      The user application should read data_size to get the size in bytes of
> - *      the data copied in the migration region during the _SAVING state and
> - *      write the size in bytes of the data copied in the migration region
> - *      during the _RESUMING state.
> - *
> - * The format of the migration region is as follows:
> - *  ------------------------------------------------------------------
> - * |vfio_device_migration_info|    data section                      |
> - * |                          |     ///////////////////////////////  |
> - * ------------------------------------------------------------------
> - *   ^                              ^
> - *  offset 0-trapped part        data_offset
> - *
> - * The structure vfio_device_migration_info is always followed by the data
> - * section in the region, so data_offset will always be nonzero. The offset
> - * from where the data is copied is decided by the kernel driver. The data
> - * section can be trapped, mmapped, or partitioned, depending on how the kernel
> - * driver defines the data section. The data section partition can be defined
> - * as mapped by the sparse mmap capability. If mmapped, data_offset must be
> - * page aligned, whereas initial section which contains the
> - * vfio_device_migration_info structure, might not end at the offset, which is
> - * page aligned. The user is not required to access through mmap regardless
> - * of the capabilities of the region mmap.
> - * The vendor driver should determine whether and how to partition the data
> - * section. The vendor driver should return data_offset accordingly.
> - *
> - * The sequence to be followed while in pre-copy state and stop-and-copy state
> - * is as follows:
> - * a. Read pending_bytes, indicating the start of a new iteration to get device
> - *    data. Repeated read on pending_bytes at this stage should have no side
> - *    effects.
> - *    If pending_bytes == 0, the user application should not iterate to get data
> - *    for that device.
> - *    If pending_bytes > 0, perform the following steps.
> - * b. Read data_offset, indicating that the vendor driver should make data
> - *    available through the data section. The vendor driver should return this
> - *    read operation only after data is available from (region + data_offset)
> - *    to (region + data_offset + data_size).
> - * c. Read data_size, which is the amount of data in bytes available through
> - *    the migration region.
> - *    Read on data_offset and data_size should return the offset and size of
> - *    the current buffer if the user application reads data_offset and
> - *    data_size more than once here.
> - * d. Read data_size bytes of data from (region + data_offset) from the
> - *    migration region.
> - * e. Process the data.
> - * f. Read pending_bytes, which indicates that the data from the previous
> - *    iteration has been read. If pending_bytes > 0, go to step b.
> - *
> - * The user application can transition from the _SAVING|_RUNNING
> - * (pre-copy state) to the _SAVING (stop-and-copy) state regardless of the
> - * number of pending bytes. The user application should iterate in _SAVING
> - * (stop-and-copy) until pending_bytes is 0.
> - *
> - * The sequence to be followed while _RESUMING device state is as follows:
> - * While data for this device is available, repeat the following steps:
> - * a. Read data_offset from where the user application should write data.
> - * b. Write migration data starting at the migration region + data_offset for
> - *    the length determined by data_size from the migration source.
> - * c. Write data_size, which indicates to the vendor driver that data is
> - *    written in the migration region. Vendor driver must return this write
> - *    operations on consuming data. Vendor driver should apply the
> - *    user-provided migration region data to the device resume state.
> - *
> - * If an error occurs during the above sequences, the vendor driver can return
> - * an error code for next read() or write() operation, which will terminate the
> - * loop. The user application should then take the next necessary action, for
> - * example, failing migration or terminating the user application.
> - *
> - * For the user application, data is opaque. The user application should write
> - * data in the same order as the data is received and the data should be of
> - * same transaction size at the source.
> + *   This field indicates the length of the current data segment in
> + *   bytes. While COPY, the kernel migration driver uses this field to
> + *   indicate to the user the length of the migration data stream available at
> + *   data_offset. When RESUMING, the user writes this field with the length of
> + *   the data segment written at the migration driver provided
> + *   data_offset. The value of this field is undefined when device_state is
> + *   not in the saving group of states.
> + *
> + * The following protocol is used while the device is in the saving group of
> + * states:
> + *
> + * a) The user reads pending_bytes.  If the read value is zero, no data is
> + *    currently available for the device.  If the device is in STOP_COPY and a
> + *    zero value is read, this indicates the end of the device migration
> + *    stream and the device must not generate any new migration data.  If the
> + *    read value is non-zero, the user may proceed to collect device migration
> + *    data in step b).  Repeated reads of pending_bytes is allowed and must
> + *    not compromise the migration data stream provided the user does not
> + *    proceed to the following step.
> + * b) The user reads data_offset, which indicates to the migration driver to
> + *    make a segment of device migration data available to the user at the
> + *    provided offset.  This action commits the user to collect the data
> + *    segment.
> + * c) The user reads data_size to determine the extent of the currently
> + *    available migration data segment.
> + * d) The user collects the data_size segment of device migration data at the
> + *    previously provided data_offset using access methods compatible to those
> + *    for the migration region.  The user must not be required to collect the
> + *    data in a single operation.
> + * e) The user re-reads pending_bytes to indicate to the migration driver that
> + *    the provided data has been collected.  Provided the read pending_bytes
> + *    value is non-zero, the user may proceed directly to step b) for another
> + *    iteration.
> + *
> + * The following protocol is used while the device is in the RESUMING
> + * device_state:
> + *
> + * a) The user reads data_offset, which directs the user to the location
> + *    within the migration region to store the migration data segment.
> + * b) The user writes the migration data segment starting at the provided
> + *    data_offset.  The user must preserve the data segment size as used when
> + *    the segment was collected from the device when COPY.
> + * c) The user writes the data_size field with the number of bytes written to
> + *    the migration region in step b).  The kernel migration driver may use
> + *    this write to indicate the end of the current iteration.
> + * d) User proceeds to step a) so long as the migration data stream is not
> + *    complete.
> + *
> + * The kernel migration driver may indicate an error condition by returning a
> + * fault on read(2) or write(2) for any operation most approximate to the
> + * detection of the error.  Field accesses are provided within the protocol
> + * such that an opportunity exists to return a fault regardless of whether the
> + * data section is directly accessed via an mmap.
> + *
> + * The user must consider the migration data segments to be opaque and
> + * non-fungible. During RESUMING, the data segments must be written in the
> + * size and order as provided during any part of the saving group of states.
>   */
>  
> +enum {
> +	VFIO_DEVICE_STATE_STOP = 0,
> +	VFIO_DEVICE_STATE_RUNNING = 1,
> +	VFIO_DEVICE_STATE_STOP_COPY = 2,
> +	VFIO_DEVICE_STATE_PRE_COPY = 3,
> +	VFIO_DEVICE_STATE_RESUMING = 4,
> +	VFIO_DEVICE_STATE_PRE_COPY_P2P = 5,
> +	VFIO_DEVICE_STATE_ERROR = 6,
> +	VFIO_DEVICE_STATE_RUNNING_P2P = 7,
> +};
> +
>  struct vfio_device_migration_info {
>  	__u32 device_state;         /* VFIO device state */
> -#define VFIO_DEVICE_STATE_STOP      (0)
> -#define VFIO_DEVICE_STATE_RUNNING   (1 << 0)
> -#define VFIO_DEVICE_STATE_SAVING    (1 << 1)
> -#define VFIO_DEVICE_STATE_RESUMING  (1 << 2)
> -#define VFIO_DEVICE_STATE_MASK      (VFIO_DEVICE_STATE_RUNNING | \
> -				     VFIO_DEVICE_STATE_SAVING |  \
> -				     VFIO_DEVICE_STATE_RESUMING)
> -
> -#define VFIO_DEVICE_STATE_VALID(state) \
> -	(state & VFIO_DEVICE_STATE_RESUMING ? \
> -	(state & VFIO_DEVICE_STATE_MASK) == VFIO_DEVICE_STATE_RESUMING : 1)
> -
> -#define VFIO_DEVICE_STATE_IS_ERROR(state) \
> -	((state & VFIO_DEVICE_STATE_MASK) == (VFIO_DEVICE_STATE_SAVING | \
> -					      VFIO_DEVICE_STATE_RESUMING))
> -
> -#define VFIO_DEVICE_STATE_SET_ERROR(state) \
> -	((state & ~VFIO_DEVICE_STATE_MASK) | VFIO_DEVICE_SATE_SAVING | \
> -					     VFIO_DEVICE_STATE_RESUMING)
> -
>  	__u32 reserved;
>  	__u64 pending_bytes;
>  	__u64 data_offset;
> 
> base-commit: 40404a6ce71339d7bc0f0a0e185ad557bf421cec

