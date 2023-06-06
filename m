Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDF847250EA
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 01:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239898AbjFFXlc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 19:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234333AbjFFXl2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 19:41:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79125E5B;
        Tue,  6 Jun 2023 16:41:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E3A36312C;
        Tue,  6 Jun 2023 23:41:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B538C433EF;
        Tue,  6 Jun 2023 23:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686094886;
        bh=rrITP7p0FWQ2ewrkDnu1CPZRryxU1CRoRzlhmNWeEhI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=sohfO1j9PlzPojlxWhLFK57mTg9hXWvOJFkQsGNKTZT582RvooGmd/u5XKOEfseIa
         /UOzpYjREl+6vcboIzeJwQZdPD5FH7slqYWUxxX/PfE74ikpjhRUrnKMVyZvp2fa9I
         Qt5XD4v3I1C1NyWUcrs4Rb4wq+HqJPpbmOqFaOLYI6wz8FDKGxnHLkZYTnNSua1GI5
         5cG4vR11QRnApB6Ire/H7C/vgCLSrFA5VTurl9j9tgEC+MQ/OUZuSve/EAObnivniE
         AiHFhodDWKfme+8uqWduL7OLbr/F4pScxNEFlutODQoc71EW7xKbqCApApDwKfuDAt
         gVsxwU2Wv4eaA==
Date:   Tue, 6 Jun 2023 18:41:24 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     "Patel, Nirmal" <nirmal.patel@linux.intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        linux-acpi@vger.kernel.org, Bagas Sanjaya <bagasdotme@gmail.com>
Subject: Re: FW: [Bug 217472] New: ACPI _OSC features have different values
 in Host OS and Guest OS
Message-ID: <20230606234124.GA1147990@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c49ed344-f521-b4b9-8a7a-a70600002358@linux.intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[+cc Bagas]

On Thu, May 25, 2023 at 01:33:27PM -0700, Patel, Nirmal wrote:
> On 5/25/2023 1:19 PM, Patel, Nirmal wrote:
> >> On Tue, 23 May 2023 12:21:25 -0500
> >> Bjorn Helgaas <helgaas@kernel.org> wrote:
> >>> On Mon, May 22, 2023 at 04:32:03PM +0000, bugzilla-daemon@kernel.org wrote:
> >>>> https://bugzilla.kernel.org/show_bug.cgi?id=217472
> >>>> ...  
> >>>> Created attachment 304301  
> >>>>   --> 
> >>>> https://bugzilla.kernel.org/attachment.cgi?id=304301&action=edit
> >>>> Rhel9.1_Guest_dmesg
> >>>>
> >>>> Issue:
> >>>> NVMe Drives are still present after performing hotplug in guest
> >>>> OS.  We have tested with different combination of OSes, drives
> >>>> and Hypervisor. The issue is present across all the OSes.   
> >>>
> >>> Maybe attach the specific commands to reproduce the problem in one of 
> >>> these scenarios to the bugzilla?  I'm a virtualization noob, so I 
> >>> can't visualize all the usual pieces.
> >>>
> >>>> The following patch was added to honor ACPI _OSC values set by BIOS 
> >>>> and the patch helped to bring the issue out in VM/ Guest OS.
> >>>>
> >>>> https://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git/comm
> >>>> it/drivers/pci/controller/vmd.c?id=04b12ef163d10e348db664900ae7f611b
> >>>> 83c7a0e
> >>>>
> >>>>
> >>>> I also compared the values of the parameters in the patch in
> >>>> Host and Guest OS.  The parameters with different values in
> >>>> Host and Guest OS are:
> >>>>
> >>>> native_pcie_hotplug
> >>>> native_shpc_hotplug
> >>>> native_aer
> >>>> native_ltr
> >>>>
> >>>> i.e.
> >>>> value of native_pcie_hotplug in Host OS is 1.
> >>>> value of native_pcie_hotplug in Guest OS is 0.
> >>>>
> >>>> I am not sure why "native_pcie_hotplug" is changed to 0 in guest.
> >>>> Isn't it OSC_ managed parameter? If that is the case, it should have 
> >>>> same value in Host and Guest OS.
> >>>
> >>> From your dmesg:
> >>>  
> >>>   DMI: Red Hat KVM/RHEL, BIOS 1.16.0-4.el9 04/01/2014
> >>>   _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI EDR HPX-Type3]
> >>>   _OSC: platform does not support [PCIeHotplug LTR DPC]
> >>>   _OSC: OS now controls [SHPCHotplug PME AER PCIeCapability]
> >>>   acpiphp: Slot [0] registered
> >>>   virtio_blk virtio3: [vda] 62914560 512-byte logical blocks (32.2 
> >>> GB/30.0 GiB)
> >>>
> >>> So the DMI ("KVM/RHEL ...") is the BIOS seen by the guest.  Doesn't 
> >>> mean anything to me, but the KVM folks would know about it.  In any 
> >>> event, the guest BIOS is different from the host BIOS, so I'm not 
> >>> surprised that _OSC is different.
> >>
> >> Right, the premise of the issue that guest and host should have
> >> the same OSC features is flawed.  The guest is a virtual machine
> >> that can present an entirely different feature set from the host.
> >> A software hotplug on the guest can occur without any bearing to
> >> the slot status on the host.
> >>
> >>> That guest BIOS _OSC declined to grant control of PCIe native
> >>> hotplug to the guest OS, so the guest will use acpiphp (not
> >>> pciehp, which would be used if native_pcie_hotplug were set).
> >>>
> >>> The dmesg doesn't mention the nvme driver.  Are you using
> >>> something like virtio_blk with qemu pointed at an NVMe drive?
> >>> And you hot-remove the NVMe device, but the guest OS thinks it's
> >>> still present?
> >>>
> >>> Since the guest is using acpiphp, I would think a hot-remove of
> >>> a host NVMe device should be noticed by qemu and turned into an
> >>> ACPI notification that the guest OS would consume.  But I don't
> >>> know how those connections work.
> >>
> >> If vfio-pci is involved, a cooperative hot-unplug will attempt to
> >> unbind the host driver, which triggers a device request through
> >> vfio, which is ultimately seen as a hotplug eject operation by
> >> the guest.  Surprise hotplugs of assigned devices are not
> >> supported.  There's not enough info in the bz to speculate how
> >> this VM is wired or what actions are taken.  Thanks,
> 
> Thanks Bjorn and Alex for quick response.
> I agree with the analysis about guest BIOS not giving control of
> PCIe native hotplug to guest OS.

Can I back up and try to understand the problem better?  I'm sure I'm
asking dumb questions, so please correct me:

  - Can you add more details in the bz about what you're doing and
    what is failing?

  - I have the impression that the hotplug worked before 04b12ef163d1
    ("PCI: vmd: Honor ACPI _OSC on PCIe features") but fails after?

  - Can you attach dmesg logs from before and after 04b12ef163d1?

  - What sort of virtualized guest is this?  qemu?

  - How is the NVMe drive passed to the guest?  vfio-pci?

  - Apparently the problem is with a hot-remove in the guest?  How are
    you doing this?  Sysfs "remove" file?  qemu "device_del"?

  - I assume this hot-remove is only from the *guest* and there's no
    hotplug event for the *host*?

> Adding some background about the patch f611b83c7a0e PCI: vmd: Honor
> ACPI _OSC on PCIe features.

Tangent, "f611b83c7a0e" is not a valid SHA1, so I was lost for a minute :)
I guess you're referring to 04b12ef163d10e348db664900ae7f611b83c7a0e,
where f611b83c7a0e is at the *end* of the SHA1.  You can abbreviate
it, but you have to quote the *beginning*, not the end.  E.g., the
conventional style would be 04b12ef163d1 ("PCI: vmd: Honor ACPI _OSC
on PCIe features").

Bjorn
