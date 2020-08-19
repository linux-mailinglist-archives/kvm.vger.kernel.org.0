Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEF3A249B79
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 13:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbgHSLQU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 07:16:20 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:19327 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727120AbgHSLQR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Aug 2020 07:16:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1597835776; x=1629371776;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=tx8NKOeIHi4OG1RBAngIhoJfV9BEVh8dk0n6oBNFru4=;
  b=jp/6Yic49cmNDRybNfvm7U1dN9r7Z30Agfsbh8nScRy4kAneXmER6Zrh
   Zo+/MERhijohMGka5KfdkxvONbQGU6Jg/LMEDHeP57J5vXRVwQpQcHDIJ
   ysuLoijY3d/LSNJ02fCnX+ZSJJkWRA18LDzMubv9513kgDEWfdOrw6D9Z
   Q=;
X-IronPort-AV: E=Sophos;i="5.76,331,1592870400"; 
   d="scan'208";a="69142392"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 19 Aug 2020 11:16:09 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com (Postfix) with ESMTPS id 772E7C071A;
        Wed, 19 Aug 2020 11:16:07 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 19 Aug 2020 11:16:06 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.160.26) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 19 Aug 2020 11:16:01 +0000
Subject: Re: [PATCH v7 00/18] Add support for Nitro Enclaves
To:     Andra Paraschiv <andraprs@amazon.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "David Duncan" <davdunc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        "David Woodhouse" <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Karen Noel <knoel@redhat.com>,
        "Martin Pohlack" <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>
References: <20200817131003.56650-1-andraprs@amazon.com>
From:   Alexander Graf <graf@amazon.de>
Message-ID: <14477cc7-926e-383d-527b-b53d088ca13d@amazon.de>
Date:   Wed, 19 Aug 2020 13:15:59 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200817131003.56650-1-andraprs@amazon.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.26]
X-ClientProxiedBy: EX13D25UWC003.ant.amazon.com (10.43.162.129) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 17.08.20 15:09, Andra Paraschiv wrote:
> Nitro Enclaves (NE) is a new Amazon Elastic Compute Cloud (EC2) capability
> that allows customers to carve out isolated compute environments within E=
C2
> instances [1].
> =

> For example, an application that processes sensitive data and runs in a V=
M,
> can be separated from other applications running in the same VM. This
> application then runs in a separate VM than the primary VM, namely an enc=
lave.
> =

> An enclave runs alongside the VM that spawned it. This setup matches low =
latency
> applications needs. The resources that are allocated for the enclave, suc=
h as
> memory and CPUs, are carved out of the primary VM. Each enclave is mapped=
 to a
> process running in the primary VM, that communicates with the NE driver v=
ia an
> ioctl interface.
> =

> In this sense, there are two components:
> =

> 1. An enclave abstraction process - a user space process running in the p=
rimary
> VM guest that uses the provided ioctl interface of the NE driver to spawn=
 an
> enclave VM (that's 2 below).
> =

> There is a NE emulated PCI device exposed to the primary VM. The driver f=
or this
> new PCI device is included in the NE driver.
> =

> The ioctl logic is mapped to PCI device commands e.g. the NE_START_ENCLAV=
E ioctl
> maps to an enclave start PCI command. The PCI device commands are then
> translated into  actions taken on the hypervisor side; that's the Nitro
> hypervisor running on the host where the primary VM is running. The Nitro
> hypervisor is based on core KVM technology.
> =

> 2. The enclave itself - a VM running on the same host as the primary VM t=
hat
> spawned it. Memory and CPUs are carved out of the primary VM and are dedi=
cated
> for the enclave VM. An enclave does not have persistent storage attached.
> =

> The memory regions carved out of the primary VM and given to an enclave n=
eed to
> be aligned 2 MiB / 1 GiB physically contiguous memory regions (or multipl=
e of
> this size e.g. 8 MiB). The memory can be allocated e.g. by using hugetlbf=
s from
> user space [2][3]. The memory size for an enclave needs to be at least 64=
 MiB.
> The enclave memory and CPUs need to be from the same NUMA node.
> =

> An enclave runs on dedicated cores. CPU 0 and its CPU siblings need to re=
main
> available for the primary VM. A CPU pool has to be set for NE purposes by=
 an
> user with admin capability. See the cpu list section from the kernel
> documentation [4] for how a CPU pool format looks.
> =

> An enclave communicates with the primary VM via a local communication cha=
nnel,
> using virtio-vsock [5]. The primary VM has virtio-pci vsock emulated devi=
ce,
> while the enclave VM has a virtio-mmio vsock emulated device. The vsock d=
evice
> uses eventfd for signaling. The enclave VM sees the usual interfaces - lo=
cal
> APIC and IOAPIC - to get interrupts from virtio-vsock device. The virtio-=
mmio
> device is placed in memory below the typical 4 GiB.
> =

> The application that runs in the enclave needs to be packaged in an encla=
ve
> image together with the OS ( e.g. kernel, ramdisk, init ) that will run i=
n the
> enclave VM. The enclave VM has its own kernel and follows the standard Li=
nux
> boot protocol.
> =

> The kernel bzImage, the kernel command line, the ramdisk(s) are part of t=
he
> Enclave Image Format (EIF); plus an EIF header including metadata such as=
 magic
> number, eif version, image size and CRC.
> =

> Hash values are computed for the entire enclave image (EIF), the kernel a=
nd
> ramdisk(s). That's used, for example, to check that the enclave image tha=
t is
> loaded in the enclave VM is the one that was intended to be run.
> =

> These crypto measurements are included in a signed attestation document
> generated by the Nitro Hypervisor and further used to prove the identity =
of the
> enclave; KMS is an example of service that NE is integrated with and that=
 checks
> the attestation doc.
> =

> The enclave image (EIF) is loaded in the enclave memory at offset 8 MiB. =
The
> init process in the enclave connects to the vsock CID of the primary VM a=
nd a
> predefined port - 9000 - to send a heartbeat value - 0xb7. This mechanism=
 is
> used to check in the primary VM that the enclave has booted.
> =

> If the enclave VM crashes or gracefully exits, an interrupt event is rece=
ived by
> the NE driver. This event is sent further to the user space enclave proce=
ss
> running in the primary VM via a poll notification mechanism. Then the use=
r space
> enclave process can exit.
> =

> Thank you.
>

This version reads very well, thanks a lot Andra!

Greg, would you mind to have another look over it?

Reviewed-by: Alexander Graf <graf@amazon.com>


Alex



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



