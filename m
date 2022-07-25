Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0E2058071D
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 00:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237177AbiGYWJi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 18:09:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237125AbiGYWJg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 18:09:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D5E4A2495D
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 15:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658786973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hOZ7r2oy9AX1vMyxFELJKktYMoZeM1XBlORL1TBs1Ck=;
        b=KEzCeu5A+F7xPnJBn3k44S36y0vwzp6v6x4M2JM7UWtN3ElKRmJ/pRfQKhmQaaKPjTgh25
        dcay0AGVFc7rAZGndr4CVb2T++En96eQwiQyONryHW4LXhhoVeZp2kyLXLiiT92QgllL8+
        NSEejvl0knIw8L/7bGNeluHnRDT3jmk=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-544-_K7wvVqtPVKFBjfeF4-yFA-1; Mon, 25 Jul 2022 18:09:31 -0400
X-MC-Unique: _K7wvVqtPVKFBjfeF4-yFA-1
Received: by mail-io1-f72.google.com with SMTP id v14-20020a6b5b0e000000b0067bc967a6c0so4765214ioh.5
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 15:09:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=hOZ7r2oy9AX1vMyxFELJKktYMoZeM1XBlORL1TBs1Ck=;
        b=MpSlhcVTAdgOJ3QSYlKQmn/BiZcHkXjwoduB0TXOxh8repiOeuq4vE1I7zRJ3mIcn4
         SU1ucUHbzBcNBenNrIyJNLDrEUmOWGj60yWVmGNGuK9K9pcCGWLS5/w+by/mRl2uhV5t
         r1wEIivx0ZJUDe5gMxiOcZhi1nnMGZM/7mQ1PqpqYMfhVBkQVjcDLa7PhVhHPMqwIs5u
         PBnIVGnaDM7s7TNubzk+Bjoj4wAO58h6LB7fqLX1gCJSA1tWSpnrIMTgnCr30CwoxxeR
         VgHM3akzB7929A5sJKSi4oviYl4LYUxYBL3pr/bBLnxAQJ675Yb1skne0yhDuAgHHnpi
         htQQ==
X-Gm-Message-State: AJIora9ujSGYibCrkrwUcPejK+H2ya5ahrQowtffHmuuALUUJrfX2nPt
        D+T2m95BbvrSNHMxTSiXcXZlhvga3dPdC2l4lCrtdCPKGiqUFuOeqIi8JNom+PjmnyV4WdVqmql
        lmihC1rmFb71G
X-Received: by 2002:a92:d0d0:0:b0:2dd:46e7:f250 with SMTP id y16-20020a92d0d0000000b002dd46e7f250mr3227228ila.269.1658786970576;
        Mon, 25 Jul 2022 15:09:30 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sH71Eg7gxykUfQ2urKwfQ4M+ElVA62dpggaBPdNJOh2SPq016q64D876CaGXhtoCRoUT16lQ==
X-Received: by 2002:a92:d0d0:0:b0:2dd:46e7:f250 with SMTP id y16-20020a92d0d0000000b002dd46e7f250mr3227211ila.269.1658786970221;
        Mon, 25 Jul 2022 15:09:30 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id h6-20020a05660208c600b0067bf99ea25bsm6506042ioz.44.2022.07.25.15.09.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 15:09:29 -0700 (PDT)
Date:   Mon, 25 Jul 2022 16:09:28 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Abhishek Sahu <abhsahu@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v5 1/5] vfio: Add the device features for the low power
 entry and exit
Message-ID: <20220725160928.43a17560.alex.williamson@redhat.com>
In-Reply-To: <aaef2e78-1ed2-fe8b-d167-8ea2dcbe45b6@nvidia.com>
References: <20220719121523.21396-1-abhsahu@nvidia.com>
        <20220719121523.21396-2-abhsahu@nvidia.com>
        <20220721163445.49d15daf.alex.williamson@redhat.com>
        <aaef2e78-1ed2-fe8b-d167-8ea2dcbe45b6@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 25 Jul 2022 20:10:44 +0530
Abhishek Sahu <abhsahu@nvidia.com> wrote:

> On 7/22/2022 4:04 AM, Alex Williamson wrote:
> > On Tue, 19 Jul 2022 17:45:19 +0530
> > Abhishek Sahu <abhsahu@nvidia.com> wrote:
> >   
> >> This patch adds the following new device features for the low
> >> power entry and exit in the header file. The implementation for the
> >> same will be added in the subsequent patches.
> >>
> >> - VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY
> >> - VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP
> >> - VFIO_DEVICE_FEATURE_LOW_POWER_EXIT
> >>
> >> With the standard registers, all power states cannot be achieved. The  
> > 
> > We're talking about standard PCI PM registers here, let's make that
> > clear since we're adding a device agnostic interface here.
> >   
> >> platform-based power management needs to be involved to go into the
> >> lowest power state. For doing low power entry and exit with
> >> platform-based power management, these device features can be used.
> >>
> >> The entry device feature has two variants. These two variants are mainly
> >> to support the different behaviour for the low power entry.
> >> If there is any access for the VFIO device on the host side, then the
> >> device will be moved out of the low power state without the user's
> >> guest driver involvement. Some devices (for example NVIDIA VGA or
> >> 3D controller) require the user's guest driver involvement for
> >> each low-power entry. In the first variant, the host can move the
> >> device into low power without any guest driver involvement while  
> > 
> > Perhaps, "In the first variant, the host can return the device to low
> > power automatically.  The device will continue to attempt to reach low
> > power until the low power exit feature is called."
> >   
> >> in the second variant, the host will send a notification to the user
> >> through eventfd and then the users guest driver needs to move
> >> the device into low power.  
> > 
> > "In the second variant, if the device exits low power due to an access,
> > the host kernel will signal the user via the provided eventfd and will
> > not return the device to low power without a subsequent call to one of
> > the low power entry features.  A call to the low power exit feature is
> > optional if the user provided eventfd is signaled."
> >    
> >> These device features only support VFIO_DEVICE_FEATURE_SET operation.  
> > 
> > And PROBE.
> >   
> 
>  Thanks Alex.
>  I will make the above changes in the commit message.
> 
> >> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
> >> ---
> >>  include/uapi/linux/vfio.h | 55 +++++++++++++++++++++++++++++++++++++++
> >>  1 file changed, 55 insertions(+)
> >>
> >> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> >> index 733a1cddde30..08fd3482d22b 100644
> >> --- a/include/uapi/linux/vfio.h
> >> +++ b/include/uapi/linux/vfio.h
> >> @@ -986,6 +986,61 @@ enum vfio_device_mig_state {
> >>  	VFIO_DEVICE_STATE_RUNNING_P2P = 5,
> >>  };
> >>  
> >> +/*
> >> + * Upon VFIO_DEVICE_FEATURE_SET, move the VFIO device into the low power state
> >> + * with the platform-based power management.  This low power state will be  
> > 
> > This is really "allow the device to be moved into a low power state"
> > rather than actually "move the device into" such a state though, right?
> >   
>  
>  Yes. It will just allow the device to be moved into a low power state.
>  I have addressed all your suggestions in the uAPI description and
>  added the updated description in the last.
> 
>  Can you please check that once and check if it looks okay.
>  
> >> + * internal to the VFIO driver and the user will not come to know which power
> >> + * state is chosen.  If any device access happens (either from the host or
> >> + * the guest) when the device is in the low power state, then the host will
> >> + * move the device out of the low power state first.  Once the access has been
> >> + * finished, then the host will move the device into the low power state again.
> >> + * If the user wants that the device should not go into the low power state
> >> + * again in this case, then the user should use the
> >> + * VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP device feature for the  
> > 
> > This should probably just read "For single shot low power support with
> > wake-up notification, see
> > VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP below."
> >   
> >> + * low power entry.  The mmap'ed region access is not allowed till the low power
> >> + * exit happens through VFIO_DEVICE_FEATURE_LOW_POWER_EXIT and will
> >> + * generate the access fault.
> >> + */
> >> +#define VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY 3  
> > 
> > Note that Yishai's DMA logging set is competing for the same feature
> > entries.  We'll need to coordinate.
> >   
> 
>  Since this is last week of rc, so will it possible to consider the updated
>  patches for next kernel (I can try to send them after complete testing the
>  by the end of this week). Otherwise, I can wait for next kernel and then
>  I can rebase my patches.

I think we're close, though I would like to solicit uAPI feedback from
others on the list.  We can certainly sort out feature numbers
conflicts at commit time if Yishai's series becomes ready as well.  I'm
on PTO for the rest of the week starting tomorrow afternoon, but I'd
suggest trying to get this re-posted before the end of the week, asking
for more reviews for the uAPI, and we can evaluate early next week if
this is ready.

> >> +
> >> +/*
> >> + * Upon VFIO_DEVICE_FEATURE_SET, move the VFIO device into the low power state
> >> + * with the platform-based power management and provide support for the wake-up
> >> + * notifications through eventfd.  This low power state will be internal to the
> >> + * VFIO driver and the user will not come to know which power state is chosen.
> >> + * If any device access happens (either from the host or the guest) when the
> >> + * device is in the low power state, then the host will move the device out of
> >> + * the low power state first and a notification will be sent to the guest
> >> + * through eventfd.  Once the access is finished, the host will not move back
> >> + * the device into the low power state.  The guest should move the device into
> >> + * the low power state again upon receiving the wakeup notification.  The
> >> + * notification will be generated only if the device physically went into the
> >> + * low power state.  If the low power entry has been disabled from the host
> >> + * side, then the device will not go into the low power state even after
> >> + * calling this device feature and then the device access does not require
> >> + * wake-up.  The mmap'ed region access is not allowed till the low power exit
> >> + * happens.  The low power exit can happen either through
> >> + * VFIO_DEVICE_FEATURE_LOW_POWER_EXIT or through any other access (where the
> >> + * wake-up notification has been generated).  
> > 
> > Seems this could leverage a lot more from the previous, simply stating
> > that this has the same behavior as VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY
> > with the exception that the user provides an eventfd for notification
> > when the device resumes from low power and will not try to re-enter a
> > low power state without a subsequent user call to one of the low power
> > entry feature ioctls.  It might also be worth covering the fact that
> > device accesses by the user, including region and ioctl access, will
> > also trigger the eventfd if that access triggers a resume.
> > 
> > As I'm thinking about this, that latter clause is somewhat subtle.
> > AIUI a user can call the low power entry with wakeup feature and
> > proceed to do various ioctl and region (not mmap) accesses that could
> > perpetually keep the device awake, or there may be dependent devices
> > such that the device may never go to low power.  It needs to be very
> > clear that only if the wakeup eventfd has the device entered into and
> > exited a low power state making the low power exit ioctl optional.
> >   
> 
>  Yes. In my updated description, I have added more details.
>  Can you please check if that helps.
> 
> >> + */
> >> +struct vfio_device_low_power_entry_with_wakeup {
> >> +	__s32 wakeup_eventfd;
> >> +	__u32 reserved;
> >> +};
> >> +
> >> +#define VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP 4
> >> +
> >> +/*
> >> + * Upon VFIO_DEVICE_FEATURE_SET, move the VFIO device out of the low power
> >> + * state.  
> > 
> > Any ioctl effectively does that, the key here is that the low power
> > state may not be re-entered after this ioctl.
> >   
> >>  This device feature should be called only if the user has previously
> >> + * put the device into the low power state either with
> >> + * VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY or
> >> + * VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP device feature.  If the  
> > 
> > Doesn't really seem worth mentioning, we need to protect against misuse
> > regardless.
> >   
> >> + * device is not in the low power state currently, this device feature will
> >> + * return early with the success status.  
> > 
> > This is an implementation detail, it doesn't need to be part of the
> > uAPI.  Thanks,
> > 
> > Alex
> >   
> >> + */
> >> +#define VFIO_DEVICE_FEATURE_LOW_POWER_EXIT 5
> >> +
> >>  /* -------- API for Type1 VFIO IOMMU -------- */
> >>  
> >>  /**  
> >   
> 
>  /*
>   * Upon VFIO_DEVICE_FEATURE_SET, allow the device to be moved into a low power
>   * state with the platform-based power management.  This low power state will
>   * be internal to the VFIO driver and the user will not come to know which
>   * power state is chosen.  If any device access happens (either from the host

Couldn't the user look in sysfs to determine the power state?  There
might also be external hardware monitors of the power state, so this
statement is a bit overreaching.  Maybe something along the lines of...

"Device use of lower power states depend on factors managed by the
runtime power management core, including system level support and
coordinating support among dependent devices.  Enabling device low
power entry does not guarantee lower power usage by the device, nor is
a mechanism provided through this feature to know the current power
state of the device."

>   * or the guest) when the device is in the low power state, then the host will

Let's not confine ourselves to a VM use case, "...from the host or
through the vfio uAPI".

>   * move the device out of the low power state first.  Once the access has been

"move the device out of the low power state as necessary prior to the
access."

>   * finished, then the host will move the device into the low power state

"Once the access is completed, the device may re-enter the low power
state."

>   * again.  For single shot low power support with wake-up notification, see
>   * VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP below.  The mmap'ed region
>   * access is not allowed till the low power exit happens through
>   * VFIO_DEVICE_FEATURE_LOW_POWER_EXIT and will generate the access fault.

"Access to mmap'd device regions is disabled on LOW_POWER_ENTRY and
may only be resumed after calling LOW_POWER_EXIT."

>   */
>  #define VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY 3
> 
>  /*
>   * This device feature has the same behavior as
>   * VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY with the exception that the user
>   * provides an eventfd for wake-up notification.  When the device moves out of
>   * the low power state for the wake-up, the host will not try to re-enter a

"...will not allow the device to re-enter a low power state..."

>   * low power state without a subsequent user call to one of the low power
>   * entry device feature IOCTLs.  The low power exit can happen either through
>   * VFIO_DEVICE_FEATURE_LOW_POWER_EXIT or through any other access (where the
>   * wake-up notification has been generated).
>   *
>   * The notification through eventfd will be generated only if the device has
>   * gone into the low power state after calling this device feature IOCTL.

"The notification through the provided eventfd will be generated only
when the device has entered and is resumed from a low power state after
calling this device feature IOCTL."


>   * There are various cases where the device will not go into the low power
>   * state after calling this device feature IOCTL (for example, the low power
>   * entry has been disabled from the host side, the user keeps the device busy
>   * after calling this device feature IOCTL, there are dependent devices which
>   * block the device low power entry, etc.) and in such cases, the device access
>   * does not require wake-up.  Also, the low power exit through

"A device that has not entered low power state, as managed through the
runtime power management core, will not generate a notification through
the provided eventfd on access."

>   * VFIO_DEVICE_FEATURE_LOW_POWER_EXIT is mandatory for the cases where the
>   * wake-up notification has not been generated.

"Calling the LOW_POWER_EXIT feature is optional in the case where
notification has been signaled on the provided eventfd that a resume
from low power has occurred."

We should also reiterate the statement above about mmap access because
it would be reasonable for a user to assume that if any access wakes
the device, that should include mmap faults and therefore a resume
notification should occur for such an event.  We could implement that
for the one-shot mode, but we're choosing not to.

>   */
>  struct vfio_device_low_power_entry_with_wakeup {
> 	 __s32 wakeup_eventfd;
> 	 __u32 reserved;
>  };
> 
>  #define VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP 4
> 
>  /*
>   * Upon VFIO_DEVICE_FEATURE_SET, prevent the VFIO device low power state entry
>   * which has been previously allowed with VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY
>   * or VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP device features.
>   */

"Upon VFIO_DEVICE_FEATURE_SET, disallow use of device low power states
as previously enabled via VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY or
VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP device features.  This
device feature ioctl may itself generate a wakeup eventfd notification
in the latter case if the device has previously entered a low power
state."

Thanks,
Alex

