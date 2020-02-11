Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96A48158D64
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 12:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728560AbgBKLTE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 06:19:04 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:44373 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727761AbgBKLTE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 06:19:04 -0500
Received: by mail-il1-f194.google.com with SMTP id s85so3083078ill.11;
        Tue, 11 Feb 2020 03:19:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rVhcVjlq8na3czw/tkwf6l6sePScsOfYU5Ogr7k0eCs=;
        b=jhM+87nIV3eGnOzI14WbJNrPKm1HIDv1USv22qODslUnAdL8F6u/kl61BxSpUOTnW4
         xZfVVaajACAOZw+wxOUBKyxBjupzu/ErjqCyQD0iSgVqVP7l2q8KOOSRFZIyT4JiBq6K
         NjNBWnlrJ7A0/ZnaU/nWC7qvGwzm6sEfZOKgzSncc1YwHqePggXpcG3QlQ9DiNQFINo8
         2qN3krHATdz6m5NZOlpfV47HNzgcMQ6XB9B291HeVn78wmzUayrPbTOaiTgUaBLHKkrX
         x/ajVJmuewSo2LRLOHlDcqkqJS1Jb5DhWnwimEEda3wtR4Ts7kxuu7G+n+4tu6ZuYfIi
         lC+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rVhcVjlq8na3czw/tkwf6l6sePScsOfYU5Ogr7k0eCs=;
        b=trBsuCdFfreE7U4bN2o5TgQZ4L0qjo0j5/F8GYHmEE5LHXh9fe/FYTPZeJuIkyGkqD
         nCvnM1WwN40uK/fcDYpTSd4YNa96CC0K+WRnucvuM6ueR8V4DKDRsbcNuy2ayLw3iBxH
         xTw9p8BLRQe2hVqQCIPoufLyv0PK5y6nbt0pBNbddXT35Q4oIRmdAQYM9DQQs+msedQ2
         9v0ptihqNp+hXx/qja68XmTpoZ66czkVy0iDeEtw0VQkk+bdy4chfF66We0JW+6S2wkr
         s9qushjV814HSu5+w59NkLsdRTJt0qJUQw7DFhaDnzJyRMJyMbxjNudx4rKlZRC8bRZF
         yCFQ==
X-Gm-Message-State: APjAAAXgNPEq4R3DNnLZAO+d5/iesGm+drpaCdE2QljuRB5+O6kNKSfp
        WxqKTbD3dAv7/NdNhaAzih6O3rP8nAkuDs90NHY=
X-Google-Smtp-Source: APXvYqwpJFGGow05e+peGMiccU09OXwxzA3q7JgF8vOUFvh3CVcgIle2N9uPDYB0Zu84nghhzJetQpekPDvKMOVQPjY=
X-Received: by 2002:a92:50a:: with SMTP id q10mr6210854ile.294.1581419943357;
 Tue, 11 Feb 2020 03:19:03 -0800 (PST)
MIME-Version: 1.0
References: <158085337582.9445.17682266437583505502.stgit@gimli.home>
In-Reply-To: <158085337582.9445.17682266437583505502.stgit@gimli.home>
From:   Jerin Jacob <jerinjacobk@gmail.com>
Date:   Tue, 11 Feb 2020 16:48:47 +0530
Message-ID: <CALBAE1Oz2u+cmoL8LhEZ-4paXEebKh3DzfWGLQLQx0oaW=tBXw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/7] vfio/pci: SR-IOV support
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, dpdk-dev <dev@dpdk.org>,
        mtosatti@redhat.com, Thomas Monjalon <thomas@monjalon.net>,
        Luca Boccassi <bluca@debian.org>,
        "Richardson, Bruce" <bruce.richardson@intel.com>,
        cohuck@redhat.com, Vamsi Attunuru <vattunuru@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 5, 2020 at 4:35 AM Alex Williamson
<alex.williamson@redhat.com> wrote:
>
> There seems to be an ongoing desire to use userspace, vfio-based
> drivers for both SR-IOV PF and VF devices.  The fundamental issue
> with this concept is that the VF is not fully independent of the PF
> driver.  Minimally the PF driver might be able to deny service to the
> VF, VF data paths might be dependent on the state of the PF device,
> or the PF my have some degree of ability to inspect or manipulate the
> VF data.  It therefore would seem irresponsible to unleash VFs onto
> the system, managed by a user owned PF.
>
> We address this in a few ways in this series.  First, we can use a bus
> notifier and the driver_override facility to make sure VFs are bound
> to the vfio-pci driver by default.  This should eliminate the chance
> that a VF is accidentally bound and used by host drivers.  We don't
> however remove the ability for a host admin to change this override.
>
> The next issue we need to address is how we let userspace drivers
> opt-in to this participation with the PF driver.  We do not want an
> admin to be able to unwittingly assign one of these VFs to a tenant
> that isn't working in collaboration with the PF driver.  We could use
> IOMMU grouping, but this seems to push too far towards tightly coupled
> PF and VF drivers.  This series introduces a "VF token", implemented
> as a UUID, as a shared secret between PF and VF drivers.  The token
> needs to be set by the PF driver and used as part of the device
> matching by the VF driver.  Provisions in the code also account for
> restarting the PF driver with active VF drivers, requiring the PF to
> use the current token to re-gain access to the PF.

Thanks Alex for the series. DPDK realizes this use-case through, an out of
tree igb_uio module, for non VFIO devices. Supporting this use case, with
VFIO, will be a great enhancement for DPDK as we are planning to
get rid of out of tree modules any focus only on userspace aspects.

From the DPDK perspective, we have following use-cases

1) VF representer or OVS/vSwitch  use cases where
DPDK PF acts as an HW switch to steer traffic to VF
using the rte_flow library backed by HW CAMs.

2) Unlike, other PCI class of devices, Network class of PCIe devices
would have additional
capability on the PF devices such as promiscuous mode support etc
leverage that in DPDK
PF and VF use cases.

That would boil down to the use of the following topology.
a)  PF bound to DPDK/VFIO  and  VF bound to Linux
b)  PF bound to DPDK/VFIO  and  VF bound to DPDK/VFIO

Tested the use case (a) and it works this patch. Tested use case(b), it
works with patch provided both PF and VF under the same application.

Regarding the use case where  PF bound to DPDK/VFIO and
VF bound to DPDK/VFIO are _two different_ processes then sharing the UUID
will be a little tricky thing in terms of usage. But if that is the
purpose of bringing
UUID to the equation then it fine.

Overall this series looks good to me.  We can test the next non-RFC
series and give
Tested-by by after testing with DPDK.


>
> The above solutions introduce a bit of a modification to the VFIO ABI
> and an additional ABI extension.  The modification is that the
> VFIO_GROUP_GET_DEVICE_FD ioctl is specified to require a char string
> from the user providing the device name.  For this solution, we extend
> the syntax to allow the device name followed by key/value pairs.  In
> this case we add "vf_token=3e7e882e-1daf-417f-ad8d-882eea5ee337", for
> example.  These options are expected to be space separated.  Matching
> these key/value pairs is entirely left to the vfio bus driver (ex.
> vfio-pci) and the internal ops structure is extended to allow this
> optional support.  This extension should be fully backwards compatible
> to existing userspace, such code will simply fail to open these newly
> exposed devices, as intended.
>
> I've been debating whether instead of the above we should allow the
> user to get the device fd as normal, but restrict the interfaces until
> the user authenticates, but I'm afraid this would be a less backwards
> compatible solution.  It would be just as unclear to the user why a
> device read/write/mmap/ioctl failed as it might be to why getting the
> device fd could fail.  However in the latter case, I believe we do a
> better job of restricting how far userspace code might go before they
> ultimately fail.  I'd welcome discussion in the space, and or course
> the extension of the GET_DEVICE_FD string.
>
> Finally, the user needs to be able to set a VF token.  I add a
> VFIO_DEVICE_FEATURE ioctl for this that's meant to be reusable for
> getting, setting, and probing arbitrary features of a device.
>
> I'll reply to this cover letter with a very basic example of a QEMU
> update to support this interface, though I haven't found a device yet
> that behaves well with the PF running in one VM with the VF in
> another, or really even just a PF running in a VM with SR-IOV enabled.
> I know these devices exist though, and I suspect QEMU will not be the
> primary user of this support for now, but this behavior reaffirms my
> concerns to prevent mis-use.
>
> Please comment.  In particular, does this approach meet the DPDK needs
> for userspace PF and VF drivers, with the hopefully minor hurdle of
> sharing a token between drivers.  The token is of course left to
> userspace how to manage, and might be static (and not very secret) for
> a given set of drivers.  Thanks,
>
> Alex
>
> ---
>
> Alex Williamson (7):
>       vfio: Include optional device match in vfio_device_ops callbacks
>       vfio/pci: Implement match ops
>       vfio/pci: Introduce VF token
>       vfio: Introduce VFIO_DEVICE_FEATURE ioctl and first user
>       vfio/pci: Add sriov_configure support
>       vfio/pci: Remove dev_fmt definition
>       vfio/pci: Cleanup .probe() exit paths
>
>
>  drivers/vfio/pci/vfio_pci.c         |  315 ++++++++++++++++++++++++++++++++---
>  drivers/vfio/pci/vfio_pci_private.h |   10 +
>  drivers/vfio/vfio.c                 |   19 ++
>  include/linux/vfio.h                |    3
>  include/uapi/linux/vfio.h           |   37 ++++
>  5 files changed, 356 insertions(+), 28 deletions(-)
>
