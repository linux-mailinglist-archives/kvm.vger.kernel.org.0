Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3AC16EB4B
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 17:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730478AbgBYQXI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 11:23:08 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24954 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729992AbgBYQXI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 11:23:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582647786;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j/IjXhdVlr5pZ8Jhv/yD2ubdhQC1M9yGGOPP9+zVvv0=;
        b=UCFAbEnM0ZDmOXXmAPzJzFJxQf1uzpnzf8ohaGmjXu2Kr0HjNX0/eCzLTjXFqfG5v1rNg1
        era3nYK2Qhwqc65PJScAeNwpfVk+cWyiJJdTOpm1micXZrQbOE0h4tt8JDh2b/tugKEhkS
        E5EitzCN563niaLiC6/+0u1bVDyBMZE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-68-5cK85T5iPG6pZvj0jeEtsA-1; Tue, 25 Feb 2020 11:23:04 -0500
X-MC-Unique: 5cK85T5iPG6pZvj0jeEtsA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6FD7118A6EC0;
        Tue, 25 Feb 2020 16:23:02 +0000 (UTC)
Received: from gondolin (dhcp-192-175.str.redhat.com [10.33.192.175])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EBBA588859;
        Tue, 25 Feb 2020 16:22:57 +0000 (UTC)
Date:   Tue, 25 Feb 2020 17:22:55 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v4 33/36] DOCUMENTATION: Protected virtual machine
 introduction and IPL
Message-ID: <20200225172255.6ec8e7ac.cohuck@redhat.com>
In-Reply-To: <20200224114107.4646-34-borntraeger@de.ibm.com>
References: <20200224114107.4646-1-borntraeger@de.ibm.com>
        <20200224114107.4646-34-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 24 Feb 2020 06:41:04 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> From: Janosch Frank <frankja@linux.ibm.com>
> 
> Add documentation about protected KVM guests and description of changes
> that are necessary to move a KVM VM into Protected Virtualization mode.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> [borntraeger@de.ibm.com: fixing and conversion to rst]
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  Documentation/virt/kvm/index.rst        |   2 +
>  Documentation/virt/kvm/s390-pv-boot.rst |  83 +++++++++++++++++
>  Documentation/virt/kvm/s390-pv.rst      | 116 ++++++++++++++++++++++++
>  MAINTAINERS                             |   1 +
>  4 files changed, 202 insertions(+)
>  create mode 100644 Documentation/virt/kvm/s390-pv-boot.rst
>  create mode 100644 Documentation/virt/kvm/s390-pv.rst
> 
(...)
> diff --git a/Documentation/virt/kvm/s390-pv-boot.rst b/Documentation/virt/kvm/s390-pv-boot.rst
> new file mode 100644
> index 000000000000..b762df206ab7
> --- /dev/null
> +++ b/Documentation/virt/kvm/s390-pv-boot.rst
> @@ -0,0 +1,83 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +======================================
> +s390 (IBM Z) Boot/IPL of Protected VMs
> +======================================
> +
> +Summary
> +-------
> +The memory of Protected Virtual Machines (PVMs) is not accessible to
> +I/O or the hypervisor. In those cases where the hypervisor needs to
> +access the memory of a PVM, that memory must be made accessible.
> +Memory made accessible to the hypervisor will be encrypted. See
> +:doc:`s390-pv` for details."
> +
> +On IPL (boot) a small plaintext bootloader is started, which provides
> +information about the encrypted components and necessary metadata to
> +KVM to decrypt the protected virtual machine.
> +
> +Based on this data, KVM will make the protected virtual machine known
> +to the Ultravisor(UV) and instruct it to secure the memory of the PVM,

s/Ultravisor(UV)/Ultravisor (UV)/

> +decrypt the components and verify the data and address list hashes, to
> +ensure integrity. Afterwards KVM can run the PVM via the SIE
> +instruction which the UV will intercept and execute on KVM's behalf.
(...)
> +Subcodes 4 and 7, which specify operations that do not clear the guest
> +memory, will result in specification exceptions. This is because the
> +UV will clear all memory when a secure VM is removed, and therefore
> +non-clearing IPL subcodes are not allowed."

stray '"'

(...)
> diff --git a/Documentation/virt/kvm/s390-pv.rst b/Documentation/virt/kvm/s390-pv.rst
> new file mode 100644
> index 000000000000..27fe03eaeaad
> --- /dev/null
> +++ b/Documentation/virt/kvm/s390-pv.rst
> @@ -0,0 +1,116 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=========================================
> +s390 (IBM Z) Ultravisor and Protected VMs
> +=========================================
> +
> +Summary
> +-------
> +Protected virtual machines (PVM) are KVM VMs that do not allow KVM to
> +access VM state like guest memory or guest registers. Instead, the
> +PVMs are mostly managed by a new entity called Ultravisor (UV). The UV
> +provides an API that can be used by PVMs and KVM to request management
> +actions.
> +
> +Each guest starts in the non-protected mode and then may make a

s/in the/in/

> +request to transition into protected mode. On transition, KVM
> +registers the guest and its VCPUs with the Ultravisor and prepares
> +everything for running it.
(...)
> +
> +Mask notification interceptions
> +-------------------------------
> +In order to be notified when a PVM enables a certain class of
> +interrupt, KVM cannot intercept lctl(g) and lpsw(e) anymore. As a

"KVM cannot intercept (...) in order to notified..." might read a bit
better.

> +replacement, two new interception codes have been introduced: One
> +indicating that the contents of CRs 0, 6, or 14 have been changed,
> +indicating different interruption subclasses; and one indicating that
> +PSW bit 13 has been changed, indicating that a machine check
> +intervention was requested and those are now enabled.
> +
> +Instruction emulation
> +---------------------
> +With the format 4 state description for PVMs, the SIE instruction already
> +interprets more instructions than it does with format 2. It is not able
> +to interpret every instruction, but needs to hand some tasks to KVM;
> +therefore, the SIE and the ultravisor safeguard emulation inputs and outputs.
> +
> +The control structures associated with SIE provide the Secure
> +Instruction Data Area (SIDA), the Interception Parameters (IP) and the
> +Secure Interception General Register Save Area.  Guest GRs and most of
> +the instruction data, such as I/O data structures, are filtered.
> +Instruction data is copied to and from the Secure Instruction Data
> +Area (SIDA) when needed.  Guest GRs are put into / retrieved from the

I think you can use 'SIDA' directly the second time.

> +Secure Interception General Register Save Area.

(...)

Otherwise,
Reviewed-by: Cornelia Huck <cohuck@redhat.com>

