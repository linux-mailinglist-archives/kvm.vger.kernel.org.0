Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7926270E3C7
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 19:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237931AbjEWRVr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 13:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237736AbjEWRVp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 13:21:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E74FCBF;
        Tue, 23 May 2023 10:21:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BC2B634FD;
        Tue, 23 May 2023 17:21:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC00CC433D2;
        Tue, 23 May 2023 17:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684862487;
        bh=Mlb70fPzSp44IfyqduXQkVQtlmfOh88KwIwDwATPXzo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=NbQWIb186lkngXgl31wbkSXEHdu2tTTAcq/u7WaYhqcsZyQF/JWdg3RqGgIGjKe5o
         8e6Q2DdpbMyw/vVP3dpfs03F+ljNuPsPUS8xrWDRizmMT2fzOUA1GgxgA6AALl0S6x
         7acE+Zc6ImBOtMBTbTwT6xeqlhHyNVhxMZIUii1LVHaMIYFPhEpckIxaxvo98U3hug
         9T/Cu24Q3s2bzdTQyfhAWTfsGSVB1yKxuWILeCwTpI30C+zKCY0FrkIr8NpHqP08gY
         kQyAzR5XhD/c6JFAzT8ifYl5K9bqFP+fGyNh3PHBIKIezJTxJR1gN3DjLIqlAnTz69
         AAK4kGmcgXsAQ==
Date:   Tue, 23 May 2023 12:21:25 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        linux-acpi@vger.kernel.org
Cc:     Nirmal Patel <nirmal.patel@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [Bug 217472] New: ACPI _OSC features have different values in
 Host OS and Guest OS
Message-ID: <ZGz2FQpHPKYgcc0+@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-217472-41252@https.bugzilla.kernel.org/>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Nirmal, thanks for the report!

On Mon, May 22, 2023 at 04:32:03PM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=217472
> ...

> Created attachment 304301
>   --> https://bugzilla.kernel.org/attachment.cgi?id=304301&action=edit
> Rhel9.1_Guest_dmesg
> 
> Issue:
> NVMe Drives are still present after performing hotplug in guest OS. We have
> tested with different combination of OSes, drives and Hypervisor. The issue is
> present across all the OSes. 

Maybe attach the specific commands to reproduce the problem in one of
these scenarios to the bugzilla?  I'm a virtualization noob, so I
can't visualize all the usual pieces.

> The following patch was added to honor ACPI _OSC values set by BIOS and the
> patch helped to bring the issue out in VM/ Guest OS.
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git/commit/drivers/pci/controller/vmd.c?id=04b12ef163d10e348db664900ae7f611b83c7a0e
> 
> 
> I also compared the values of the parameters in the patch in Host and Guest OS.
> The parameters with different values in Host and Guest OS are:
> 
> native_pcie_hotplug
> native_shpc_hotplug
> native_aer
> native_ltr
> 
> i.e.
> value of native_pcie_hotplug in Host OS is 1.
> value of native_pcie_hotplug in Guest OS is 0.
> 
> I am not sure why "native_pcie_hotplug" is changed to 0 in guest.
> Isn't it OSC_ managed parameter? If that is the case, it should
> have same value in Host and Guest OS.

From your dmesg:

  DMI: Red Hat KVM/RHEL, BIOS 1.16.0-4.el9 04/01/2014
  _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI EDR HPX-Type3]
  _OSC: platform does not support [PCIeHotplug LTR DPC]
  _OSC: OS now controls [SHPCHotplug PME AER PCIeCapability]
  acpiphp: Slot [0] registered
  virtio_blk virtio3: [vda] 62914560 512-byte logical blocks (32.2 GB/30.0 GiB)

So the DMI ("KVM/RHEL ...") is the BIOS seen by the guest.  Doesn't
mean anything to me, but the KVM folks would know about it.  In any
event, the guest BIOS is different from the host BIOS, so I'm not
surprised that _OSC is different.

That guest BIOS _OSC declined to grant control of PCIe native hotplug
to the guest OS, so the guest will use acpiphp (not pciehp, which
would be used if native_pcie_hotplug were set).

The dmesg doesn't mention the nvme driver.  Are you using something
like virtio_blk with qemu pointed at an NVMe drive?  And you
hot-remove the NVMe device, but the guest OS thinks it's still
present?

Since the guest is using acpiphp, I would think a hot-remove of a host
NVMe device should be noticed by qemu and turned into an ACPI
notification that the guest OS would consume.  But I don't know how
those connections work.

Bjorn
