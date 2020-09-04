Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88C2825DF77
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 18:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgIDQNV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Sep 2020 12:13:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:56526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726184AbgIDQNT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Sep 2020 12:13:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F159E2074D;
        Fri,  4 Sep 2020 16:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599235998;
        bh=O3v40fHorMwtnwvbGMybc4FYTYLXBSNyiFd8GU0oUKE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tZzZBzTYb7AVqt4XQTysBH9SyYqKPSISkvml+UkoDpHBtxQdZLcoaIYJk2xq/KjUx
         JSQXERH5uQ+QKf1sPCcM1h7VHoAFiRt1NknPKQI693XF3jb3zkIV51fepbXjqOZqhh
         KVErXZNVjtwQXdjwy8H1WGY1ZPWaHxyONVD1LTT4=
Date:   Fri, 4 Sep 2020 18:13:39 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        David Duncan <davdunc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Karen Noel <knoel@redhat.com>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>,
        Alexander Graf <graf@amazon.de>
Subject: Re: [PATCH v7 00/18] Add support for Nitro Enclaves
Message-ID: <20200904161339.GA3824396@kroah.com>
References: <20200817131003.56650-1-andraprs@amazon.com>
 <14477cc7-926e-383d-527b-b53d088ca13d@amazon.de>
 <20200819112657.GA475121@kroah.com>
 <7727faf5-1c13-f7f1-ede3-64cf131c7dc7@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7727faf5-1c13-f7f1-ede3-64cf131c7dc7@amazon.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 31, 2020 at 11:19:19AM +0300, Paraschiv, Andra-Irina wrote:
> 
> 
> On 19/08/2020 14:26, Greg KH wrote:
> > 
> > On Wed, Aug 19, 2020 at 01:15:59PM +0200, Alexander Graf wrote:
> > > 
> > > On 17.08.20 15:09, Andra Paraschiv wrote:
> > > > Nitro Enclaves (NE) is a new Amazon Elastic Compute Cloud (EC2) capability
> > > > that allows customers to carve out isolated compute environments within EC2
> > > > instances [1].
> > > > 
> > > > For example, an application that processes sensitive data and runs in a VM,
> > > > can be separated from other applications running in the same VM. This
> > > > application then runs in a separate VM than the primary VM, namely an enclave.
> > > > 
> > > > An enclave runs alongside the VM that spawned it. This setup matches low latency
> > > > applications needs. The resources that are allocated for the enclave, such as
> > > > memory and CPUs, are carved out of the primary VM. Each enclave is mapped to a
> > > > process running in the primary VM, that communicates with the NE driver via an
> > > > ioctl interface.
> > > > 
> > > > In this sense, there are two components:
> > > > 
> > > > 1. An enclave abstraction process - a user space process running in the primary
> > > > VM guest that uses the provided ioctl interface of the NE driver to spawn an
> > > > enclave VM (that's 2 below).
> > > > 
> > > > There is a NE emulated PCI device exposed to the primary VM. The driver for this
> > > > new PCI device is included in the NE driver.
> > > > 
> > > > The ioctl logic is mapped to PCI device commands e.g. the NE_START_ENCLAVE ioctl
> > > > maps to an enclave start PCI command. The PCI device commands are then
> > > > translated into  actions taken on the hypervisor side; that's the Nitro
> > > > hypervisor running on the host where the primary VM is running. The Nitro
> > > > hypervisor is based on core KVM technology.
> > > > 
> > > > 2. The enclave itself - a VM running on the same host as the primary VM that
> > > > spawned it. Memory and CPUs are carved out of the primary VM and are dedicated
> > > > for the enclave VM. An enclave does not have persistent storage attached.
> > > > 
> > > > The memory regions carved out of the primary VM and given to an enclave need to
> > > > be aligned 2 MiB / 1 GiB physically contiguous memory regions (or multiple of
> > > > this size e.g. 8 MiB). The memory can be allocated e.g. by using hugetlbfs from
> > > > user space [2][3]. The memory size for an enclave needs to be at least 64 MiB.
> > > > The enclave memory and CPUs need to be from the same NUMA node.
> > > > 
> > > > An enclave runs on dedicated cores. CPU 0 and its CPU siblings need to remain
> > > > available for the primary VM. A CPU pool has to be set for NE purposes by an
> > > > user with admin capability. See the cpu list section from the kernel
> > > > documentation [4] for how a CPU pool format looks.
> > > > 
> > > > An enclave communicates with the primary VM via a local communication channel,
> > > > using virtio-vsock [5]. The primary VM has virtio-pci vsock emulated device,
> > > > while the enclave VM has a virtio-mmio vsock emulated device. The vsock device
> > > > uses eventfd for signaling. The enclave VM sees the usual interfaces - local
> > > > APIC and IOAPIC - to get interrupts from virtio-vsock device. The virtio-mmio
> > > > device is placed in memory below the typical 4 GiB.
> > > > 
> > > > The application that runs in the enclave needs to be packaged in an enclave
> > > > image together with the OS ( e.g. kernel, ramdisk, init ) that will run in the
> > > > enclave VM. The enclave VM has its own kernel and follows the standard Linux
> > > > boot protocol.
> > > > 
> > > > The kernel bzImage, the kernel command line, the ramdisk(s) are part of the
> > > > Enclave Image Format (EIF); plus an EIF header including metadata such as magic
> > > > number, eif version, image size and CRC.
> > > > 
> > > > Hash values are computed for the entire enclave image (EIF), the kernel and
> > > > ramdisk(s). That's used, for example, to check that the enclave image that is
> > > > loaded in the enclave VM is the one that was intended to be run.
> > > > 
> > > > These crypto measurements are included in a signed attestation document
> > > > generated by the Nitro Hypervisor and further used to prove the identity of the
> > > > enclave; KMS is an example of service that NE is integrated with and that checks
> > > > the attestation doc.
> > > > 
> > > > The enclave image (EIF) is loaded in the enclave memory at offset 8 MiB. The
> > > > init process in the enclave connects to the vsock CID of the primary VM and a
> > > > predefined port - 9000 - to send a heartbeat value - 0xb7. This mechanism is
> > > > used to check in the primary VM that the enclave has booted.
> > > > 
> > > > If the enclave VM crashes or gracefully exits, an interrupt event is received by
> > > > the NE driver. This event is sent further to the user space enclave process
> > > > running in the primary VM via a poll notification mechanism. Then the user space
> > > > enclave process can exit.
> > > > 
> > > > Thank you.
> > > > 
> > > This version reads very well, thanks a lot Andra!
> > > 
> > > Greg, would you mind to have another look over it?
> > Will do, it's in my to-review queue, behind lots of other patches...
> > 
> 
> I have a set of updates that can be included in a new revision, v8 e.g. new
> NE custom error codes for invalid flags / enclave CID, "shutdown" function
> for the NE PCI device driver, a couple more checks wrt invalid flags and
> enclave vsock CID, documentation and sample updates. There is also the
> option to have these updates as follow-up patches.
> 
> Greg, let me know what would work fine for you with regard to the review of
> the patch series.

A new series is always fine with me...

thanks,

greg k-h
