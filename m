Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D361052070D
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 23:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbiEIVyo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 17:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbiEIVx6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 17:53:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8C0F02CC107
        for <kvm@vger.kernel.org>; Mon,  9 May 2022 14:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652132929;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DcVqPnR4yfNuBX29cmJBJeKrZJe4vFv8KIRm9I909H8=;
        b=J9UvcoZyZgV2TZRFJoF/6u+GKyPqM2Da+RnGaCHPzxDMTeDwzwSg6mLgtmreM26XcO6Wrr
        YoTxVI7LOuUMfEnl4M04gRB3Klu8rCsE797ah8+TNgi8DIhS8Yn5vcb2zIfGj9V75cjd8t
        Tq6sn72e35G5TnVntb7Tey8ztRzEHxw=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-558-UGBiXZ7UNLy4dgGNQSWmog-1; Mon, 09 May 2022 17:48:48 -0400
X-MC-Unique: UGBiXZ7UNLy4dgGNQSWmog-1
Received: by mail-il1-f198.google.com with SMTP id m11-20020a056e020deb00b002cbde7e7dcfso8349471ilj.2
        for <kvm@vger.kernel.org>; Mon, 09 May 2022 14:48:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DcVqPnR4yfNuBX29cmJBJeKrZJe4vFv8KIRm9I909H8=;
        b=ca+WSESVFFGXCInSBk8uxGWXx8yxAnQ2uZykbGfbTM5FHD+wkJbR3/zgzX25STDPcN
         eW61woT9l+JPIgLOnBEZhVOZHG1MKw4/3FUui02FOyzrJNnVMMfXEvyYXGVK6/CrDONs
         8BLup6LotfVQemwogKMR5SIGz/zRA3trihUf9ehKuTGtHwRkewX5X9xFRsLXZbljikdO
         zsXKsFNfoJjKolmFWkn69PBGOistIkcqvmZF5vyVkEaBP/9NoWkekocpcf/knMgRqB+v
         QnEhmuXikxWwfscE+cdWh6j/weYTMciBXNeWGrotgoU/xJj3MpUc3BWgcuyo1u5KSdr7
         FWHQ==
X-Gm-Message-State: AOAM530pSSyJcjdJ+N+rUjsuDfDNuDSLiGGRM6VCLbP3KthdGzmZDprp
        PWDfrvDHKoNsqFgf1dALLUslaCaqSnujuinUfJAgGIch81sF8TPA43q9wx4H35DLH0H4VlNtn4Q
        oytmwhMIQB6aV
X-Received: by 2002:a05:6638:270b:b0:32b:d0c5:9c79 with SMTP id m11-20020a056638270b00b0032bd0c59c79mr7291269jav.297.1652132927052;
        Mon, 09 May 2022 14:48:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyem3iwJXiips8hOomJxOM0pvo4a7Qt+3ue636lpVaZ0bJcOOTTU3uMa7kbZMmSnOZZF2LbWg==
X-Received: by 2002:a05:6638:270b:b0:32b:d0c5:9c79 with SMTP id m11-20020a056638270b00b0032bd0c59c79mr7291251jav.297.1652132926500;
        Mon, 09 May 2022 14:48:46 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id b19-20020a056638151300b0032b3a7817c6sm3921534jat.138.2022.05.09.14.48.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 14:48:46 -0700 (PDT)
Date:   Mon, 9 May 2022 15:48:44 -0600
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
Subject: Re: [PATCH v3 8/8] vfio/pci: Add the support for PCI D3cold state
Message-ID: <20220509154844.79e4915b.alex.williamson@redhat.com>
In-Reply-To: <9e44e9cc-a500-ab0d-4785-5ae26874b3eb@nvidia.com>
References: <20220425092615.10133-1-abhsahu@nvidia.com>
        <20220425092615.10133-9-abhsahu@nvidia.com>
        <20220504134551.70d71bf0.alex.williamson@redhat.com>
        <9e44e9cc-a500-ab0d-4785-5ae26874b3eb@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 5 May 2022 17:46:20 +0530
Abhishek Sahu <abhsahu@nvidia.com> wrote:

> On 5/5/2022 1:15 AM, Alex Williamson wrote:
> > On Mon, 25 Apr 2022 14:56:15 +0530
> > Abhishek Sahu <abhsahu@nvidia.com> wrote:
> >  =20
> >> Currently, if the runtime power management is enabled for vfio pci
> >> based device in the guest OS, then guest OS will do the register
> >> write for PCI_PM_CTRL register. This write request will be handled in
> >> vfio_pm_config_write() where it will do the actual register write
> >> of PCI_PM_CTRL register. With this, the maximum D3hot state can be
> >> achieved for low power. If we can use the runtime PM framework,
> >> then we can achieve the D3cold state which will help in saving
> >> maximum power.
> >>
> >> 1. Since D3cold state can't be achieved by writing PCI standard
> >>    PM config registers, so this patch adds a new feature in the
> >>    existing VFIO_DEVICE_FEATURE IOCTL. This IOCTL can be used
> >>    to change the PCI device from D3hot to D3cold state and
> >>    then D3cold to D0 state. The device feature uses low power term
> >>    instead of D3cold so that if other vfio driver wants to implement
> >>    low power support, then the same IOCTL can be used. =20
> >=20
> > How does this enable you to handle the full-off vs memory-refresh modes
> > for NVIDIA GPUs?
> >  =20
> =20
>  Thanks Alex.
>=20
>  This patch series will just enable the full-off for nvidia GPU.
>  The self-refresh mode won't work.
>=20
>  The self-refresh case is nvidia specific and needs driver
>  involvement each time before going into d3cold. We are evaluating
>  internally if we have enough use case for self-refresh mode and then
>  I will plan separate patch series to support self-refresh mode use
>  case, if required. But that will be independent of this patch series.
>=20
>  At the high level, we need some way to disable the PCI device access
>  from the host side or forward the event to VM for every access on the
>  host side if we want to support NVIDIA self-refresh use case inside VM.
>  Otherwise, from the driver side, we can disable self-refresh mode if
>  driver is running inside VM. In that case, if memory usage is higher than
>  threshold then we don=E2=80=99t engage RTD3 itself.=20

Disabling PCI access on the host seems impractical to me, but PM and
PCI folks are welcome to weigh in.

We've also discussed that the GPU memory could exceed RAM + swap for a
VM, leaving them with no practical means to make use of d3cold if we
don't support this capability.  Also, existing drivers expect to have
this capability and it's not uncommon for those in the gaming community
making use of GPU assignment to attempt to hide the fact that they're
running in a VM to avoid falsely triggering anti-cheat detection, DRM,
or working around certain GPU vendors who previously restricted use of
consumer GPUs in VMs.

That seems to suggest to me that our only option is along the lines of
notifying the VM when the device returns to D0 and by default only
re-entering d3cold under the direction of the VM.  We might also do some
sort of negotiation based on device vendor and class code where we
could enable the kernel to perform the transition back to d3cold.
There's a fair chance that an AMD GPU might have similar requirements,
do we know if they do?

I'd suggest perhaps splitting this patch series so that we can start
taking advantage of using d3cold for idle devices while we figure out
how to make use of VM directed d3cold without creating scenarios that
don't break existing drivers.
=20
> > The feature ioctl supports a probe, but here the probe only indicates
> > that the ioctl is available, not what degree of low power support
> > available.  Even if the host doesn't support d3cold for the device, we
> > can still achieve root port d3hot, but can we provide further
> > capability info to the user?
> > =20
>=20
>  I wanted to add more information here but was not sure which
>  information will be helpful for user. There is no certain way to
>  predict that the runtime suspend will use D3cold state only even
>  on the supported systems. User can disable runtime power management from=
=20
>=20
>  /sys/bus/pci/devices/=E2=80=A6/power/control
>=20
>  Or disable d3cold itself=20
>=20
>  /sys/bus/pci/devices/=E2=80=A6/d3cold_allowed
>=20
>=20
>  Even if all these are allowed, then platform_pci_choose_state()
>  is the main function where the target low power state is selected
>  in runtime.
>=20
>  Probably we can add pci_pr3_present() status to user which gives
>  hint to user that required ACPI methods for d3cold is present in
>  the platform.=20

I expected that might be the answer.  The proposed interface name also
avoids tying us directly to an ACPI implementation, so I imagine there
could be a variety of backends supporting runtime power management in
the host kernel.

In the VM I think the ACPI controls are at the root port, so we
probably need to add power control to each root port regardless of what
happens to be plugged into it at the time.  Maybe that means we can't
really take advantage of knowing the degree of device support, we just
need to wire it up as if it works regardless.

We might also want to consider parallels to device hotplug here.  For
example, if QEMU could know that a device does not retain state in
d3cold, it might choose to unplug the device backend so that the device
could be used elsewhere in the interim, or simply use the idle device
handling for d3cold in vfio-pci.  That opens up a lot of questions
regarding SLA contracts with management tools to be able to replace the
device with a fungible substitute on demand, but I can imagine data
center logistics might rather have that problem than VMs sitting on
powered-off devices.

> >> 2. The hypervisors can implement virtual ACPI methods. For
> >>    example, in guest linux OS if PCI device ACPI node has _PR3 and _PR0
> >>    power resources with _ON/_OFF method, then guest linux OS makes the
> >>    _OFF call during D3cold transition and then _ON during D0 transitio=
n.
> >>    The hypervisor can tap these virtual ACPI calls and then do the D3c=
old
> >>    related IOCTL in the vfio driver.
> >>
> >> 3. The vfio driver uses runtime PM framework to achieve the
> >>    D3cold state. For the D3cold transition, decrement the usage count =
and
> >>    for the D0 transition, increment the usage count.
> >>
> >> 4. For D3cold, the device current power state should be D3hot.
> >>    Then during runtime suspend, the pci_platform_power_transition() is
> >>    required for D3cold state. If the D3cold state is not supported, th=
en
> >>    the device will still be in D3hot state. But with the runtime PM, t=
he
> >>    root port can now also go into suspended state. =20
> >=20
> > Why do we create this requirement for the device to be in d3hot prior
> > to entering low power  =20
>=20
>  This is mainly to make integration in the hypervisor with
>  the PCI power management code flow.
>=20
>  If we see the power management steps, then following 2 steps
>  are involved=20
>=20
>  1. First move the device from D0 to D3hot state by writing
>     into config register.
>  2. Then invoke ACPI routines (mainly _PR3 OFF method) to
>     move from D3hot to D3cold.
>=20
>  So, in the guest side, we can follow the same steps. The guest can
>  do the config register write and then for step 2, the hypervisor
>  can implement the virtual ACPI with _PR3/_PR0 power resources.
>  Inside this virtual ACPI implementation, the hypervisor can invoke
>  the power management IOCTL.
>=20
>  Also, if runtime PM has been disabled from the host side,
>  then also the device will be in d3hot state.=20

That's true regardless of us making it a requirement.  I don't see what
it buys us to make this a requirement though.  If I trigger the _PR3
method on bare metal, does ACPI care if the device is in D3hot first?
At best that seems dependent on the ACPI implementation.
=20
> > when our pm ops suspend function wakes the device do d0? =20
>=20
>  The changing to D0 here is happening due to 2 reasons here,
>=20
>  1. First to preserve device state for the NoSoftRst-.
>  2. To make use of PCI core layer generic code for runtime suspend,
>     otherwise we need to do all handling here which is present in
>     pci_pm_runtime_suspend().

What problem do we cause if we allow the user to trigger this ioctl
from D0?  The restriction follows the expected use case, but otherwise
imposing the restriction is arbitrary.

=20
> >> 5. For most of the systems, the D3cold is supported at the root
> >>    port level. So, when root port will transition to D3cold state, then
> >>    the vfio PCI device will go from D3hot to D3cold state during its
> >>    runtime suspend. If root port does not support D3cold, then the root
> >>    will go into D3hot state.
> >>
> >> 6. The runtime suspend callback can now happen for 2 cases: there
> >>    are no users of vfio device and the case where user has initiated
> >>    D3cold. The 'platform_pm_engaged' flag can help to distinguish
> >>    between these 2 cases. =20
> >=20
> > If this were the only use case we could rely on vfio_device.open_count
> > instead.  I don't think it is though.   =20
>=20
>  platform_pm_engaged is mainly to track the user initiated
>  low power entry with the IOCTL. So even if we use vfio_device.open_count
>  here, we will still require platform_pm_engaged.
>=20
> >> 7. In D3cold, all kind of BAR related access needs to be disabled
> >>    like D3hot. Additionally, the config space will also be disabled in
> >>    D3cold state. To prevent access of config space in D3cold state, do
> >>    increment the runtime PM usage count before doing any config space
> >>    access. =20
> >=20
> > Or we could actually prevent access to config space rather than waking
> > the device for the access.  Addressed in further comment below.
> >   =20
> >> 8. If user has engaged low power entry through IOCTL, then user should
> >>    do low power exit first. The user can issue config access or IOCTL
> >>    after low power entry. We can add an explicit error check but since
> >>    we are already waking-up device, so IOCTL and config access can be
> >>    fulfilled. But 'power_state_d3' won't be cleared without issuing
> >>    low power exit so all BAR related access will still return error ti=
ll
> >>    user do low power exit. =20
> >=20
> > The fact that power_state_d3 no longer tracks the device power state
> > when platform_pm_engaged is set is a confusing discontinuity.
> >  =20
>=20
>  If we refer the power management steps (as mentioned in the above),
>  then these 2 variable tracks different things.
>=20
>  1. power_state_d3 tracks the config space write. =20
>  2. platform_pm_engaged tracks the IOCTL call. In the IOCTL, we decrement
>     the runtime usage count so we need to track that we have decremented
>     it.=20
>=20
> >> 9. Since multiple layers are involved, so following is the high level
> >>    code flow for D3cold entry and exit.
> >>
> >> D3cold entry:
> >>
> >> a. User put the PCI device into D3hot by writing into standard config
> >>    register (vfio_pm_config_write() -> vfio_lock_and_set_power_state()=
 ->
> >>    vfio_pci_set_power_state()). The device power state will be D3hot a=
nd
> >>    power_state_d3 will be true.
> >> b. Set vfio_device_feature_power_management::low_power_state =3D
> >>    VFIO_DEVICE_LOW_POWER_STATE_ENTER and call VFIO_DEVICE_FEATURE IOCT=
L.
> >> c. Inside vfio_device_fops_unl_ioctl(), pm_runtime_resume_and_get()
> >>    will be called first which will make the usage count as 2 and then
> >>    vfio_pci_core_ioctl_feature() will be invoked.
> >> d. vfio_pci_core_feature_pm() will be called and it will go inside
> >>    VFIO_DEVICE_LOW_POWER_STATE_ENTER switch case. platform_pm_engaged =
will
> >>    be true and pm_runtime_put_noidle() will decrement the usage count
> >>    to 1.
> >> e. Inside vfio_device_fops_unl_ioctl() while returning the
> >>    pm_runtime_put() will make the usage count to 0 and the runtime PM
> >>    framework will engage the runtime suspend entry.
> >> f. pci_pm_runtime_suspend() will be called and invokes driver runtime
> >>    suspend callback.
> >> g. vfio_pci_core_runtime_suspend() will change the power state to D0
> >>    and do the INTx mask related handling.
> >> h. pci_pm_runtime_suspend() will take care of saving the PCI state and
> >>    all power management handling for D3cold.
> >>
> >> D3cold exit:
> >>
> >> a. Set vfio_device_feature_power_management::low_power_state =3D
> >>    VFIO_DEVICE_LOW_POWER_STATE_EXIT and call VFIO_DEVICE_FEATURE IOCTL.
> >> b. Inside vfio_device_fops_unl_ioctl(), pm_runtime_resume_and_get()
> >>    will be called first which will make the usage count as 1.
> >> c. pci_pm_runtime_resume() will take care of moving the device into D0
> >>    state again and then vfio_pci_core_runtime_resume() will be called.
> >> d. vfio_pci_core_runtime_resume() will do the INTx unmask related
> >>    handling.
> >> e. vfio_pci_core_ioctl_feature() will be invoked.
> >> f. vfio_pci_core_feature_pm() will be called and it will go inside
> >>    VFIO_DEVICE_LOW_POWER_STATE_EXIT switch case. platform_pm_engaged a=
nd
> >>    power_state_d3 will be cleared and pm_runtime_get_noresume() will m=
ake
> >>    the usage count as 2.
> >> g. Inside vfio_device_fops_unl_ioctl() while returning the
> >>    pm_runtime_put() will make the usage count to 1 and the device will
> >>    be in D0 state only.
> >>
> >> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
> >> ---
> >>  drivers/vfio/pci/vfio_pci_config.c |  11 ++-
> >>  drivers/vfio/pci/vfio_pci_core.c   | 131 ++++++++++++++++++++++++++++-
> >>  include/linux/vfio_pci_core.h      |   1 +
> >>  include/uapi/linux/vfio.h          |  18 ++++
> >>  4 files changed, 159 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfi=
o_pci_config.c
> >> index af0ae80ef324..65b1bc9586ab 100644
> >> --- a/drivers/vfio/pci/vfio_pci_config.c
> >> +++ b/drivers/vfio/pci/vfio_pci_config.c
> >> @@ -25,6 +25,7 @@
> >>  #include <linux/uaccess.h>
> >>  #include <linux/vfio.h>
> >>  #include <linux/slab.h>
> >> +#include <linux/pm_runtime.h>
> >> =20
> >>  #include <linux/vfio_pci_core.h>
> >> =20
> >> @@ -1936,16 +1937,23 @@ static ssize_t vfio_config_do_rw(struct vfio_p=
ci_core_device *vdev, char __user
> >>  ssize_t vfio_pci_config_rw(struct vfio_pci_core_device *vdev, char __=
user *buf,
> >>  			   size_t count, loff_t *ppos, bool iswrite)
> >>  {
> >> +	struct device *dev =3D &vdev->pdev->dev;
> >>  	size_t done =3D 0;
> >>  	int ret =3D 0;
> >>  	loff_t pos =3D *ppos;
> >> =20
> >>  	pos &=3D VFIO_PCI_OFFSET_MASK;
> >> =20
> >> +	ret =3D pm_runtime_resume_and_get(dev);
> >> +	if (ret < 0)
> >> +		return ret; =20
> >=20
> > Alternatively we could just check platform_pm_engaged here and return
> > -EINVAL, right?  Why is waking the device the better option?
> >  =20
>=20
>  This is mainly to prevent race condition where config space access
>  happens parallelly with IOCTL access. So, lets consider the following ca=
se.
>=20
>  1. Config space access happens and vfio_pci_config_rw() will be called.
>  2. The IOCTL to move into low power state is called.
>  3. The IOCTL will move the device into d3cold.
>  4. Exit from vfio_pci_config_rw() happened.
>=20
>  Now, if we just check platform_pm_engaged, then in the above
>  sequence it won=E2=80=99t work. I checked this parallel access by writing
>  a small program where I opened the 2 instances and then
>  created 2 threads for config space and IOCTL.
>  In my case, I got the above sequence.
>=20
>  The pm_runtime_resume_and_get() will make sure that device
>  usage count keep incremented throughout the config space
>  access (or IOCTL access in the previous patch) and the
>  runtime PM framework will not move the device into suspended
>  state.

I think we're inventing problems here.  If we define that config space
is not accessible while the device is in low power and the only way to
get the device out of low power is via ioctl, then we should be denying
access to the device while in low power.  If the user races exiting the
device from low power and a config space access, that's their problem.

> >> +
> >>  	while (count) {
> >>  		ret =3D vfio_config_do_rw(vdev, buf, count, &pos, iswrite);
> >> -		if (ret < 0)
> >> +		if (ret < 0) {
> >> +			pm_runtime_put(dev);
> >>  			return ret;
> >> +		}
> >> =20
> >>  		count -=3D ret;
> >>  		done +=3D ret;
> >> @@ -1953,6 +1961,7 @@ ssize_t vfio_pci_config_rw(struct vfio_pci_core_=
device *vdev, char __user *buf,
> >>  		pos +=3D ret;
> >>  	}
> >> =20
> >> +	pm_runtime_put(dev);
> >>  	*ppos +=3D done;
> >> =20
> >>  	return done;
> >> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_=
pci_core.c
> >> index 05a68ca9d9e7..beac6e05f97f 100644
> >> --- a/drivers/vfio/pci/vfio_pci_core.c
> >> +++ b/drivers/vfio/pci/vfio_pci_core.c
> >> @@ -234,7 +234,14 @@ int vfio_pci_set_power_state(struct vfio_pci_core=
_device *vdev, pci_power_t stat
> >>  	ret =3D pci_set_power_state(pdev, state);
> >> =20
> >>  	if (!ret) {
> >> -		vdev->power_state_d3 =3D (pdev->current_state >=3D PCI_D3hot);
> >> +		/*
> >> +		 * If 'platform_pm_engaged' is true then 'power_state_d3' can
> >> +		 * be cleared only when user makes the explicit request to
> >> +		 * move out of low power state by using power management ioctl.
> >> +		 */
> >> +		if (!vdev->platform_pm_engaged)
> >> +			vdev->power_state_d3 =3D
> >> +				(pdev->current_state >=3D PCI_D3hot); =20
> >=20
> > power_state_d3 is essentially only used as a secondary test to
> > __vfio_pci_memory_enabled() to block r/w access to device regions and
> > generate a fault on mmap access.  Its existence already seems a little
> > questionable when we could just look at vdev->pdev->current_state, and
> > we could incorporate that into __vfio_pci_memory_enabled().  So rather
> > than creating this inconsistency, couldn't we just make that function
> > return:
> >=20
> > !vdev->platform_pm_enagaged && pdev->current_state < PCI_D3hot &&
> > (pdev->no_command_memory || (cmd & PCI_COMMAND_MEMORY))
> >  =20
>=20
>  The main reason for power_state_d3 is to get it under
>  memory_lock semaphore. But pdev->current_state is not
>  protected with any lock. So, will use of pdev->current_state
>  here be safe?

If we're only testing and modifying pdev->current_state under
memory_lock, isn't it equivalent?
=20
> >> =20
> >>  		/* D3 might be unsupported via quirk, skip unless in D3 */
> >>  		if (needs_save && pdev->current_state >=3D PCI_D3hot) {
> >> @@ -266,6 +273,25 @@ static int vfio_pci_core_runtime_suspend(struct d=
evice *dev)
> >>  {
> >>  	struct vfio_pci_core_device *vdev =3D dev_get_drvdata(dev);
> >> =20
> >> +	down_read(&vdev->memory_lock);
> >> +
> >> +	/* 'platform_pm_engaged' will be false if there are no users. */
> >> +	if (!vdev->platform_pm_engaged) {
> >> +		up_read(&vdev->memory_lock);
> >> +		return 0;
> >> +	}
> >> +
> >> +	/*
> >> +	 * The user will move the device into D3hot state first before invok=
ing
> >> +	 * power management ioctl. Move the device into D0 state here and th=
en
> >> +	 * the pci-driver core runtime PM suspend will move the device into
> >> +	 * low power state. Also, for the devices which have NoSoftRst-,
> >> +	 * it will help in restoring the original state (saved locally in
> >> +	 * 'vdev->pm_save').
> >> +	 */
> >> +	vfio_pci_set_power_state(vdev, PCI_D0);
> >> +	up_read(&vdev->memory_lock);
> >> +
> >>  	/*
> >>  	 * If INTx is enabled, then mask INTx before going into runtime
> >>  	 * suspended state and unmask the same in the runtime resume.
> >> @@ -395,6 +421,19 @@ void vfio_pci_core_disable(struct vfio_pci_core_d=
evice *vdev)
> >> =20
> >>  	/*
> >>  	 * This function can be invoked while the power state is non-D0.
> >> +	 * This non-D0 power state can be with or without runtime PM.
> >> +	 * Increment the usage count corresponding to pm_runtime_put()
> >> +	 * called during setting of 'platform_pm_engaged'. The device will
> >> +	 * wake up if it has already went into suspended state. Otherwise,
> >> +	 * the next vfio_pci_set_power_state() will change the
> >> +	 * device power state to D0.
> >> +	 */
> >> +	if (vdev->platform_pm_engaged) {
> >> +		pm_runtime_resume_and_get(&pdev->dev);
> >> +		vdev->platform_pm_engaged =3D false;
> >> +	}
> >> +
> >> +	/*
> >>  	 * This function calls __pci_reset_function_locked() which internally
> >>  	 * can use pci_pm_reset() for the function reset. pci_pm_reset() will
> >>  	 * fail if the power state is non-D0. Also, for the devices which
> >> @@ -1192,6 +1231,80 @@ long vfio_pci_core_ioctl(struct vfio_device *co=
re_vdev, unsigned int cmd,
> >>  }
> >>  EXPORT_SYMBOL_GPL(vfio_pci_core_ioctl);
> >> =20
> >> +#ifdef CONFIG_PM
> >> +static int vfio_pci_core_feature_pm(struct vfio_device *device, u32 f=
lags,
> >> +				    void __user *arg, size_t argsz)
> >> +{
> >> +	struct vfio_pci_core_device *vdev =3D
> >> +		container_of(device, struct vfio_pci_core_device, vdev);
> >> +	struct pci_dev *pdev =3D vdev->pdev;
> >> +	struct vfio_device_feature_power_management vfio_pm =3D { 0 };
> >> +	int ret =3D 0;
> >> +
> >> +	ret =3D vfio_check_feature(flags, argsz,
> >> +				 VFIO_DEVICE_FEATURE_SET |
> >> +				 VFIO_DEVICE_FEATURE_GET,
> >> +				 sizeof(vfio_pm));
> >> +	if (ret !=3D 1)
> >> +		return ret;
> >> +
> >> +	if (flags & VFIO_DEVICE_FEATURE_GET) {
> >> +		down_read(&vdev->memory_lock);
> >> +		vfio_pm.low_power_state =3D vdev->platform_pm_engaged ?
> >> +				VFIO_DEVICE_LOW_POWER_STATE_ENTER :
> >> +				VFIO_DEVICE_LOW_POWER_STATE_EXIT;
> >> +		up_read(&vdev->memory_lock);
> >> +		if (copy_to_user(arg, &vfio_pm, sizeof(vfio_pm)))
> >> +			return -EFAULT;
> >> +		return 0;
> >> +	}
> >> +
> >> +	if (copy_from_user(&vfio_pm, arg, sizeof(vfio_pm)))
> >> +		return -EFAULT;
> >> +
> >> +	/*
> >> +	 * The vdev power related fields are protected with memory_lock
> >> +	 * semaphore.
> >> +	 */
> >> +	down_write(&vdev->memory_lock);
> >> +	switch (vfio_pm.low_power_state) {
> >> +	case VFIO_DEVICE_LOW_POWER_STATE_ENTER:
> >> +		if (!vdev->power_state_d3 || vdev->platform_pm_engaged) {
> >> +			ret =3D EINVAL;
> >> +			break;
> >> +		}
> >> +
> >> +		vdev->platform_pm_engaged =3D true;
> >> +
> >> +		/*
> >> +		 * The pm_runtime_put() will be called again while returning
> >> +		 * from ioctl after which the device can go into runtime
> >> +		 * suspended.
> >> +		 */
> >> +		pm_runtime_put_noidle(&pdev->dev);
> >> +		break;
> >> +
> >> +	case VFIO_DEVICE_LOW_POWER_STATE_EXIT:
> >> +		if (!vdev->platform_pm_engaged) {
> >> +			ret =3D EINVAL;
> >> +			break;
> >> +		}
> >> +
> >> +		vdev->platform_pm_engaged =3D false;
> >> +		vdev->power_state_d3 =3D false;
> >> +		pm_runtime_get_noresume(&pdev->dev);
> >> +		break;
> >> +
> >> +	default:
> >> +		ret =3D EINVAL;
> >> +		break;
> >> +	}
> >> +
> >> +	up_write(&vdev->memory_lock);
> >> +	return ret;
> >> +}
> >> +#endif
> >> +
> >>  static int vfio_pci_core_feature_token(struct vfio_device *device, u3=
2 flags,
> >>  				       void __user *arg, size_t argsz)
> >>  {
> >> @@ -1226,6 +1339,10 @@ int vfio_pci_core_ioctl_feature(struct vfio_dev=
ice *device, u32 flags,
> >>  	switch (flags & VFIO_DEVICE_FEATURE_MASK) {
> >>  	case VFIO_DEVICE_FEATURE_PCI_VF_TOKEN:
> >>  		return vfio_pci_core_feature_token(device, flags, arg, argsz);
> >> +#ifdef CONFIG_PM
> >> +	case VFIO_DEVICE_FEATURE_POWER_MANAGEMENT:
> >> +		return vfio_pci_core_feature_pm(device, flags, arg, argsz);
> >> +#endif
> >>  	default:
> >>  		return -ENOTTY;
> >>  	}
> >> @@ -2189,6 +2306,15 @@ static int vfio_pci_dev_set_hot_reset(struct vf=
io_device_set *dev_set,
> >>  		goto err_unlock;
> >>  	}
> >> =20
> >> +	/*
> >> +	 * Some of the devices in the dev_set can be in the runtime suspended
> >> +	 * state. Increment the usage count for all the devices in the dev_s=
et
> >> +	 * before reset and decrement the same after reset.
> >> +	 */
> >> +	ret =3D vfio_pci_dev_set_pm_runtime_get(dev_set);
> >> +	if (ret)
> >> +		goto err_unlock;
> >> +
> >>  	list_for_each_entry(cur_vma, &dev_set->device_list, vdev.dev_set_lis=
t) {
> >>  		/*
> >>  		 * Test whether all the affected devices are contained by the
> >> @@ -2244,6 +2370,9 @@ static int vfio_pci_dev_set_hot_reset(struct vfi=
o_device_set *dev_set,
> >>  		else
> >>  			mutex_unlock(&cur->vma_lock);
> >>  	}
> >> +
> >> +	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list)
> >> +		pm_runtime_put(&cur->pdev->dev);
> >>  err_unlock:
> >>  	mutex_unlock(&dev_set->lock);
> >>  	return ret;
> >> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_co=
re.h
> >> index e84f31e44238..337983a877d6 100644
> >> --- a/include/linux/vfio_pci_core.h
> >> +++ b/include/linux/vfio_pci_core.h
> >> @@ -126,6 +126,7 @@ struct vfio_pci_core_device {
> >>  	bool			needs_pm_restore;
> >>  	bool			power_state_d3;
> >>  	bool			pm_intx_masked;
> >> +	bool			platform_pm_engaged;
> >>  	struct pci_saved_state	*pci_saved_state;
> >>  	struct pci_saved_state	*pm_save;
> >>  	int			ioeventfds_nr;
> >> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> >> index fea86061b44e..53ff890dbd27 100644
> >> --- a/include/uapi/linux/vfio.h
> >> +++ b/include/uapi/linux/vfio.h
> >> @@ -986,6 +986,24 @@ enum vfio_device_mig_state {
> >>  	VFIO_DEVICE_STATE_RUNNING_P2P =3D 5,
> >>  };
> >> =20
> >> +/*
> >> + * Use platform-based power management for moving the device into low=
 power
> >> + * state.  This low power state is device specific.
> >> + *
> >> + * For PCI, this low power state is D3cold.  The native PCI power man=
agement
> >> + * does not support the D3cold power state.  For moving the device in=
to D3cold
> >> + * state, change the PCI state to D3hot with standard configuration r=
egisters
> >> + * and then call this IOCTL to setting the D3cold state.  Similarly, =
if the
> >> + * device in D3cold state, then call this IOCTL to exit from D3cold s=
tate.
> >> + */
> >> +struct vfio_device_feature_power_management {
> >> +#define VFIO_DEVICE_LOW_POWER_STATE_EXIT	0x0
> >> +#define VFIO_DEVICE_LOW_POWER_STATE_ENTER	0x1
> >> +	__u64	low_power_state;
> >> +};
> >> +
> >> +#define VFIO_DEVICE_FEATURE_POWER_MANAGEMENT	3 =20
> >=20
> > __u8 seems more than sufficient here.  Thanks,
> >=20
> > Alex
> > =20
>=20
>  I have used __u64 mainly to get this structure 64 bit aligned.
>  I was impression that the ioctl structure should be 64 bit aligned
>  but in this case since we will have just have __u8 member so
>  alignment should not be required?

We can add a directive to enforce an alignment regardless of the field
size.  I believe the feature ioctl header is already going to be eight
byte aligned, so it's probably not strictly necessary, but Jason seems
to be adding more of these directives elsewhere, so probably a good
idea regardless.  Thanks,

Alex

