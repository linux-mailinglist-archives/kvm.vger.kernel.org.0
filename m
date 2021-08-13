Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6D23EBA76
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 18:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236205AbhHMQxo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 12:53:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:58136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238052AbhHMQxg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Aug 2021 12:53:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B96EE60F57;
        Fri, 13 Aug 2021 16:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628873589;
        bh=dRZbOK5CYvAtvA7oK4N+gmqBFrUbdbrNmbtvCzj81q0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=hinIUm9cnOHoYfuj3yiVKb8JJC/XhLobRiwFSs+7F9Opql7IHSaB2Aa6d6dGcvHYl
         1wyBaW0nCmq1sT8lDzfP54NzgsqpIftoSPqd8CpFOWnd9qhgWgRBqd8bLU1beaQBqd
         /NsliUXLq6K0reVtYiyRupR93M3QtBoiUeYTbYecSZgDkEza5Zn/EpavNStYTEXlel
         m3swI0HxNvWtT+8jvwyVGz5CDMEvq2wqEHa8wR+ZCEX2wRmIYfZoEi+pZ95PJkQsEM
         VydqS+hb/kOFvFOXN8MQuyP7pJpeNSVycy09nqS6lb3WFP7qq5B912LPL8Kja6y5j+
         TS/LQpup3TjJQ==
Date:   Fri, 13 Aug 2021 11:53:07 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Idar Lund <idarlund@gmail.com>
Cc:     bjorn@helgaas.com, Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: vfio-pci problem
Message-ID: <20210813165307.GA2587844@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+enFJkL5AWjehFAHTMG5-+9zyR2eVxqFJ-9MoaJkavjwV+MfA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[+cc Alex, kvm, linux-pci]

On Fri, Aug 13, 2021 at 09:43:39AM +0200, Idar Lund wrote:
> Hi,
> 
> I've been struggling with an error in linux since 5.11. Please find my bug
> report here:
> https://bugzilla.redhat.com/show_bug.cgi?id=1945565
> 
> Then I stumbled upon this mail thread:
> https://www.spinics.net/lists/linux-pci/msg102243.html which seems related.
> 
> Is there another way to do this in 5.11+ or is this an unintentionally bug
> that got introduced in 5.11?

Hi Idar, sorry for the trouble and thanks for the report!  I cc'd some
VFIO experts who know more than I do about this.

If I understand correctly, you have a PCI XHCI controller:

  pci 0000:06:00.0: [1b73:1100] type 00 class 0x0c0330
  xhci_hcd 0000:06:00.0: xHCI Host Controller

and you want to unbind the xhci_hcd driver and bind vfio-pci instead:

  # echo '0000:06:00.0' > /sys/bus/pci/devices/0000\:06\:00.0/driver/unbind
  # echo 0x1b73 0x1100 > /sys/bus/pci/drivers/vfio-pci/new_id

In v5.10 (5.10.17-200.fc33.x86_64) this worked fine, but in v5.11
(5.11.9-200.fc33.x86_64) the "new_id" write returns -EEXIST and
binding to vfio-pci fails.

The patch you pointed out appeared in v5.11 as 3853f9123c18 ("PCI:
Avoid duplicate IDs in driver dynamic IDs list") [1], and I agree it
looks suspicious.  There haven't been any significant changes to
pci-driver.c since then.

Have you added "0x1b73 0x1100" to vfio-pci/new_id previously?  I think
in v5.10, that would silently work (possibly adding duplicate entries
to the dynamic ID list) and every write to vfio-pci/new_id would make
vfio-pci try to bind to the device.

In v5.11, if you write a duplicate ID to vfio-pci/new_id, you would
get -EEXIST and no attempt to bind.  As far as I know, the dynamic ID
list is not visible in sysfs, so it might be hard to avoid writing a
duplicate.

But if the vfio-pci dynamic ID list already contains "0x1b73 0x1100",
you should be able to ask vfio-pci to bind to the device like this:

  # echo 0000:06:00.0 > /sys/bus/pci/drivers/virtio-pci/bind

I don't know if that's a solution, but would be useful to know whether
it's a workaround.

[1] https://git.kernel.org/linus/3853f9123c18
