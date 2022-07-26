Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5A55814EC
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 16:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235773AbiGZORS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 10:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbiGZORO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 10:17:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 80EA213E98
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 07:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658845031;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DAhZvikrASrN23qyYU3246auG+59bm1upEzCd4n56bQ=;
        b=UP8n/FJ3j4QjUaOtTKNDqXY6aSvet8A13wS5ClAORxVh/L/QqtQvpkBWAYMmZwwoqV2BD+
        fP4VjeR40+68rjQXkpe7mgky2E8hYgEuw3ocbnM+wr6lss5lO2qKKPmki87gOoydHiNtzE
        LJB9PZumzJVZT5SqPy5G6Gle5EJYy7E=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-537-oCJLjRZ-NPayAZzPEU0feQ-1; Tue, 26 Jul 2022 10:17:09 -0400
X-MC-Unique: oCJLjRZ-NPayAZzPEU0feQ-1
Received: by mail-il1-f200.google.com with SMTP id o9-20020a056e0214c900b002dc29c288bfso9271969ilk.3
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 07:17:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=DAhZvikrASrN23qyYU3246auG+59bm1upEzCd4n56bQ=;
        b=uhJklhKGcDO8dLFI6Ui67AR0g4akW2EtyoZk8+TzYxZDnngYes2WP1XIgDHiGZRW27
         u4XMByV7YOmRLfxCDbRCZqVr35PfDTaiBXWacYJemOacepo1cwXzYhc97Moerxl+/tuz
         EGuJu2wYj7R/jlzWWACWbCLvm0aTQkXb0dQFm0Bq5hAX7Iloh33mEHFEELt+Vi9iDNDM
         IOxroDJs0oGY3uQpf1/nuh1Q76P6SdgXK/ljsPL8Deec7FT6g0jbModJB+U6G3hPbGEI
         8ctjxkw2U7ThOv6JBJqalE6SHtleKbTo5GhSgeMyoI4tqOFnyR7X8bpOr5793DHuq6TU
         OM5Q==
X-Gm-Message-State: AJIora9IJF1HiqPuE+VUAPmsNMNfvlF2htUu5qPLGvCOmj1ztbBwY61h
        SDF5pZlWGg6bfjWJCkKyAb+kod0aV0YXje1S3oAE9Nv03Jw5sT5n+uPsnzPM2VwL+d6+B4IQCrm
        yK1IhDxYHODg/
X-Received: by 2002:a05:6e02:1a8c:b0:2dd:9385:11ce with SMTP id k12-20020a056e021a8c00b002dd938511cemr1292033ilv.20.1658845028634;
        Tue, 26 Jul 2022 07:17:08 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1s5/X9dVPD+dyYCJZFjLew2p0jfBUxNQogk3s+NDuyEK0gMxiEpyLK+TCa10p1IL7w2oqiRUg==
X-Received: by 2002:a05:6e02:1a8c:b0:2dd:9385:11ce with SMTP id k12-20020a056e021a8c00b002dd938511cemr1292011ilv.20.1658845028190;
        Tue, 26 Jul 2022 07:17:08 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id o3-20020a02b803000000b0033cc22c261fsm6541669jam.111.2022.07.26.07.17.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 07:17:07 -0700 (PDT)
Date:   Tue, 26 Jul 2022 08:17:06 -0600
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
Message-ID: <20220726081706.0d3bc6a5.alex.williamson@redhat.com>
In-Reply-To: <bd7bca18-ae07-c04a-23d3-bf71245da0cc@nvidia.com>
References: <20220719121523.21396-1-abhsahu@nvidia.com>
        <20220719121523.21396-2-abhsahu@nvidia.com>
        <20220721163445.49d15daf.alex.williamson@redhat.com>
        <aaef2e78-1ed2-fe8b-d167-8ea2dcbe45b6@nvidia.com>
        <20220725160928.43a17560.alex.williamson@redhat.com>
        <bd7bca18-ae07-c04a-23d3-bf71245da0cc@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 26 Jul 2022 18:17:18 +0530
Abhishek Sahu <abhsahu@nvidia.com> wrote:

> On 7/26/2022 3:39 AM, Alex Williamson wrote:
> > On Mon, 25 Jul 2022 20:10:44 +0530
> > Abhishek Sahu <abhsahu@nvidia.com> wrote:
> >   
> >> On 7/22/2022 4:04 AM, Alex Williamson wrote:  
> >>> On Tue, 19 Jul 2022 17:45:19 +0530
> >>> Abhishek Sahu <abhsahu@nvidia.com> wrote:
> >>>     
> >>>> This patch adds the following new device features for the low
> >>>> power entry and exit in the header file. The implementation for the
> >>>> same will be added in the subsequent patches.
> >>>>
> >>>> - VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY
> >>>> - VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP
> >>>> - VFIO_DEVICE_FEATURE_LOW_POWER_EXIT
> >>>>
> >>>> With the standard registers, all power states cannot be achieved. The    
> >>>
> >>> We're talking about standard PCI PM registers here, let's make that
> >>> clear since we're adding a device agnostic interface here.
> >>>     
> >>>> platform-based power management needs to be involved to go into the
> >>>> lowest power state. For doing low power entry and exit with
> >>>> platform-based power management, these device features can be used.
> >>>>
> >>>> The entry device feature has two variants. These two variants are mainly
> >>>> to support the different behaviour for the low power entry.
> >>>> If there is any access for the VFIO device on the host side, then the
> >>>> device will be moved out of the low power state without the user's
> >>>> guest driver involvement. Some devices (for example NVIDIA VGA or
> >>>> 3D controller) require the user's guest driver involvement for
> >>>> each low-power entry. In the first variant, the host can move the
> >>>> device into low power without any guest driver involvement while    
> >>>
> >>> Perhaps, "In the first variant, the host can return the device to low
> >>> power automatically.  The device will continue to attempt to reach low
> >>> power until the low power exit feature is called."
> >>>     
> >>>> in the second variant, the host will send a notification to the user
> >>>> through eventfd and then the users guest driver needs to move
> >>>> the device into low power.    
> >>>
> >>> "In the second variant, if the device exits low power due to an access,
> >>> the host kernel will signal the user via the provided eventfd and will
> >>> not return the device to low power without a subsequent call to one of
> >>> the low power entry features.  A call to the low power exit feature is
> >>> optional if the user provided eventfd is signaled."
> >>>      
> >>>> These device features only support VFIO_DEVICE_FEATURE_SET operation.    
> >>>
> >>> And PROBE.
> >>>     
> >>
> >>  Thanks Alex.
> >>  I will make the above changes in the commit message.
> >>  
> >>>> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
> >>>> ---
> >>>>  include/uapi/linux/vfio.h | 55 +++++++++++++++++++++++++++++++++++++++
> >>>>  1 file changed, 55 insertions(+)
> >>>>
> >>>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> >>>> index 733a1cddde30..08fd3482d22b 100644
> >>>> --- a/include/uapi/linux/vfio.h
> >>>> +++ b/include/uapi/linux/vfio.h
> >>>> @@ -986,6 +986,61 @@ enum vfio_device_mig_state {
> >>>>  	VFIO_DEVICE_STATE_RUNNING_P2P = 5,
> >>>>  };
> >>>>  
> >>>> +/*
> >>>> + * Upon VFIO_DEVICE_FEATURE_SET, move the VFIO device into the low power state
> >>>> + * with the platform-based power management.  This low power state will be    
> >>>
> >>> This is really "allow the device to be moved into a low power state"
> >>> rather than actually "move the device into" such a state though, right?
> >>>     
> >>  
> >>  Yes. It will just allow the device to be moved into a low power state.
> >>  I have addressed all your suggestions in the uAPI description and
> >>  added the updated description in the last.
> >>
> >>  Can you please check that once and check if it looks okay.
> >>    
> >>>> + * internal to the VFIO driver and the user will not come to know which power
> >>>> + * state is chosen.  If any device access happens (either from the host or
> >>>> + * the guest) when the device is in the low power state, then the host will
> >>>> + * move the device out of the low power state first.  Once the access has been
> >>>> + * finished, then the host will move the device into the low power state again.
> >>>> + * If the user wants that the device should not go into the low power state
> >>>> + * again in this case, then the user should use the
> >>>> + * VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP device feature for the    
> >>>
> >>> This should probably just read "For single shot low power support with
> >>> wake-up notification, see
> >>> VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP below."
> >>>     
> >>>> + * low power entry.  The mmap'ed region access is not allowed till the low power
> >>>> + * exit happens through VFIO_DEVICE_FEATURE_LOW_POWER_EXIT and will
> >>>> + * generate the access fault.
> >>>> + */
> >>>> +#define VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY 3    
> >>>
> >>> Note that Yishai's DMA logging set is competing for the same feature
> >>> entries.  We'll need to coordinate.
> >>>     
> >>
> >>  Since this is last week of rc, so will it possible to consider the updated
> >>  patches for next kernel (I can try to send them after complete testing the
> >>  by the end of this week). Otherwise, I can wait for next kernel and then
> >>  I can rebase my patches.  
> > 
> > I think we're close, though I would like to solicit uAPI feedback from
> > others on the list.  We can certainly sort out feature numbers
> > conflicts at commit time if Yishai's series becomes ready as well.  I'm
> > on PTO for the rest of the week starting tomorrow afternoon, but I'd
> > suggest trying to get this re-posted before the end of the week, asking
> > for more reviews for the uAPI, and we can evaluate early next week if
> > this is ready.
> >   
> 
>  Sure. I will re-post the updated patch series after the complete testing.
>  
> >>>> +
> >>>> +/*
> >>>> + * Upon VFIO_DEVICE_FEATURE_SET, move the VFIO device into the low power state
> >>>> + * with the platform-based power management and provide support for the wake-up
> >>>> + * notifications through eventfd.  This low power state will be internal to the
> >>>> + * VFIO driver and the user will not come to know which power state is chosen.
> >>>> + * If any device access happens (either from the host or the guest) when the
> >>>> + * device is in the low power state, then the host will move the device out of
> >>>> + * the low power state first and a notification will be sent to the guest
> >>>> + * through eventfd.  Once the access is finished, the host will not move back
> >>>> + * the device into the low power state.  The guest should move the device into
> >>>> + * the low power state again upon receiving the wakeup notification.  The
> >>>> + * notification will be generated only if the device physically went into the
> >>>> + * low power state.  If the low power entry has been disabled from the host
> >>>> + * side, then the device will not go into the low power state even after
> >>>> + * calling this device feature and then the device access does not require
> >>>> + * wake-up.  The mmap'ed region access is not allowed till the low power exit
> >>>> + * happens.  The low power exit can happen either through
> >>>> + * VFIO_DEVICE_FEATURE_LOW_POWER_EXIT or through any other access (where the
> >>>> + * wake-up notification has been generated).    
> >>>
> >>> Seems this could leverage a lot more from the previous, simply stating
> >>> that this has the same behavior as VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY
> >>> with the exception that the user provides an eventfd for notification
> >>> when the device resumes from low power and will not try to re-enter a
> >>> low power state without a subsequent user call to one of the low power
> >>> entry feature ioctls.  It might also be worth covering the fact that
> >>> device accesses by the user, including region and ioctl access, will
> >>> also trigger the eventfd if that access triggers a resume.
> >>>
> >>> As I'm thinking about this, that latter clause is somewhat subtle.
> >>> AIUI a user can call the low power entry with wakeup feature and
> >>> proceed to do various ioctl and region (not mmap) accesses that could
> >>> perpetually keep the device awake, or there may be dependent devices
> >>> such that the device may never go to low power.  It needs to be very
> >>> clear that only if the wakeup eventfd has the device entered into and
> >>> exited a low power state making the low power exit ioctl optional.
> >>>     
> >>
> >>  Yes. In my updated description, I have added more details.
> >>  Can you please check if that helps.
> >>  
> >>>> + */
> >>>> +struct vfio_device_low_power_entry_with_wakeup {
> >>>> +	__s32 wakeup_eventfd;
> >>>> +	__u32 reserved;
> >>>> +};
> >>>> +
> >>>> +#define VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP 4
> >>>> +
> >>>> +/*
> >>>> + * Upon VFIO_DEVICE_FEATURE_SET, move the VFIO device out of the low power
> >>>> + * state.    
> >>>
> >>> Any ioctl effectively does that, the key here is that the low power
> >>> state may not be re-entered after this ioctl.
> >>>     
> >>>>  This device feature should be called only if the user has previously
> >>>> + * put the device into the low power state either with
> >>>> + * VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY or
> >>>> + * VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP device feature.  If the    
> >>>
> >>> Doesn't really seem worth mentioning, we need to protect against misuse
> >>> regardless.
> >>>     
> >>>> + * device is not in the low power state currently, this device feature will
> >>>> + * return early with the success status.    
> >>>
> >>> This is an implementation detail, it doesn't need to be part of the
> >>> uAPI.  Thanks,
> >>>
> >>> Alex
> >>>     
> >>>> + */
> >>>> +#define VFIO_DEVICE_FEATURE_LOW_POWER_EXIT 5
> >>>> +
> >>>>  /* -------- API for Type1 VFIO IOMMU -------- */
> >>>>  
> >>>>  /**    
> >>>     
> >>
> >>  /*
> >>   * Upon VFIO_DEVICE_FEATURE_SET, allow the device to be moved into a low power
> >>   * state with the platform-based power management.  This low power state will
> >>   * be internal to the VFIO driver and the user will not come to know which
> >>   * power state is chosen.  If any device access happens (either from the host  
> > 
> > Couldn't the user look in sysfs to determine the power state?  There
> > might also be external hardware monitors of the power state, so this
> > statement is a bit overreaching.  Maybe something along the lines of...
> > 
> > "Device use of lower power states depend on factors managed by the
> > runtime power management core, including system level support and
> > coordinating support among dependent devices.  Enabling device low
> > power entry does not guarantee lower power usage by the device, nor is
> > a mechanism provided through this feature to know the current power
> > state of the device."
> >   
> >>   * or the guest) when the device is in the low power state, then the host will  
> > 
> > Let's not confine ourselves to a VM use case, "...from the host or
> > through the vfio uAPI".
> >   
> >>   * move the device out of the low power state first.  Once the access has been  
> > 
> > "move the device out of the low power state as necessary prior to the
> > access."
> >   
> >>   * finished, then the host will move the device into the low power state  
> > 
> > "Once the access is completed, the device may re-enter the low power
> > state."
> >   
> >>   * again.  For single shot low power support with wake-up notification, see
> >>   * VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP below.  The mmap'ed region
> >>   * access is not allowed till the low power exit happens through
> >>   * VFIO_DEVICE_FEATURE_LOW_POWER_EXIT and will generate the access fault.  
> > 
> > "Access to mmap'd device regions is disabled on LOW_POWER_ENTRY and
> > may only be resumed after calling LOW_POWER_EXIT."
> >   
> >>   */
> >>  #define VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY 3
> >>
> >>  /*
> >>   * This device feature has the same behavior as
> >>   * VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY with the exception that the user
> >>   * provides an eventfd for wake-up notification.  When the device moves out of
> >>   * the low power state for the wake-up, the host will not try to re-enter a  
> > 
> > "...will not allow the device to re-enter a low power state..."
> >   
> >>   * low power state without a subsequent user call to one of the low power
> >>   * entry device feature IOCTLs.  The low power exit can happen either through
> >>   * VFIO_DEVICE_FEATURE_LOW_POWER_EXIT or through any other access (where the
> >>   * wake-up notification has been generated).
> >>   *
> >>   * The notification through eventfd will be generated only if the device has
> >>   * gone into the low power state after calling this device feature IOCTL.  
> > 
> > "The notification through the provided eventfd will be generated only
> > when the device has entered and is resumed from a low power state after
> > calling this device feature IOCTL."
> > 
> >   
> >>   * There are various cases where the device will not go into the low power
> >>   * state after calling this device feature IOCTL (for example, the low power
> >>   * entry has been disabled from the host side, the user keeps the device busy
> >>   * after calling this device feature IOCTL, there are dependent devices which
> >>   * block the device low power entry, etc.) and in such cases, the device access
> >>   * does not require wake-up.  Also, the low power exit through  
> > 
> > "A device that has not entered low power state, as managed through the
> > runtime power management core, will not generate a notification through
> > the provided eventfd on access."
> >   
> >>   * VFIO_DEVICE_FEATURE_LOW_POWER_EXIT is mandatory for the cases where the
> >>   * wake-up notification has not been generated.  
> > 
> > "Calling the LOW_POWER_EXIT feature is optional in the case where
> > notification has been signaled on the provided eventfd that a resume
> > from low power has occurred."
> > 
> > We should also reiterate the statement above about mmap access because
> > it would be reasonable for a user to assume that if any access wakes
> > the device, that should include mmap faults and therefore a resume
> > notification should occur for such an event.  We could implement that
> > for the one-shot mode, but we're choosing not to.
> >   
> >>   */
> >>  struct vfio_device_low_power_entry_with_wakeup {
> >> 	 __s32 wakeup_eventfd;
> >> 	 __u32 reserved;
> >>  };
> >>
> >>  #define VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP 4
> >>
> >>  /*
> >>   * Upon VFIO_DEVICE_FEATURE_SET, prevent the VFIO device low power state entry
> >>   * which has been previously allowed with VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY
> >>   * or VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP device features.
> >>   */  
> > 
> > "Upon VFIO_DEVICE_FEATURE_SET, disallow use of device low power states
> > as previously enabled via VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY or
> > VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP device features.  This
> > device feature ioctl may itself generate a wakeup eventfd notification
> > in the latter case if the device has previously entered a low power
> > state."
> > 
> > Thanks,
> > Alex
> >   
> 
>  Thanks Alex for your thorough review of uAPI.
>  I have incorporated all the suggestions.
>  Following is the updated uAPI.
>  
>  /*
>   * Upon VFIO_DEVICE_FEATURE_SET, allow the device to be moved into a low power
>   * state with the platform-based power management.  Device use of lower power
>   * states depends on factors managed by the runtime power management core,
>   * including system level support and coordinating support among dependent
>   * devices.  Enabling device low power entry does not guarantee lower power
>   * usage by the device, nor is a mechanism provided through this feature to
>   * know the current power state of the device.  If any device access happens
>   * (either from the host or through the vfio uAPI) when the device is in the
>   * low power state, then the host will move the device out of the low power
>   * state as necessary prior to the access.  Once the access is completed, the
>   * device may re-enter the low power state.  For single shot low power support
>   * with wake-up notification, see
>   * VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP below.  Access to mmap'd
>   * device regions is disabled on LOW_POWER_ENTRY and may only be resumed after
>   * calling LOW_POWER_EXIT.
>   */
>  #define VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY 3
>  
>  /*
>   * This device feature has the same behavior as
>   * VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY with the exception that the user
>   * provides an eventfd for wake-up notification.  When the device moves out of
>   * the low power state for the wake-up, the host will not allow the device to
>   * re-enter a low power state without a subsequent user call to one of the low
>   * power entry device feature IOCTLs.  Access to mmap'd device regions is
>   * disabled on LOW_POWER_ENTRY_WITH_WAKEUP and may only be resumed after the
>   * low power exit.  The low power exit can happen either through LOW_POWER_EXIT
>   * or through any other access (where the wake-up notification has been
>   * generated).  The access to mmap'd device regions will not trigger low power
>   * exit.
>   *
>   * The notification through the provided eventfd will be generated only when
>   * the device has entered and is resumed from a low power state after
>   * calling this device feature IOCTL.  A device that has not entered low power
>   * state, as managed through the runtime power management core, will not
>   * generate a notification through the provided eventfd on access.  Calling the
>   * LOW_POWER_EXIT feature is optional in the case where notification has been
>   * signaled on the provided eventfd that a resume from low power has occurred.
>   */
>  struct vfio_device_low_power_entry_with_wakeup {
>  	__s32 wakeup_eventfd;
>  	__u32 reserved;
>  };
>  
>  #define VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP 4
>  
>  /*
>   * Upon VFIO_DEVICE_FEATURE_SET, disallow use of device low power states as
>   * previously enabled via VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY or
>   * VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP device features.
>   * This device feature IOCTL may itself generate a wakeup eventfd notification
>   * in the latter case if the device has previously entered a low power state.
>   */
>  #define VFIO_DEVICE_FEATURE_LOW_POWER_EXIT 5

Looks ok to me.  Thanks,

Alex

