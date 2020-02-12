Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11E4315A73F
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 12:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbgBLLBT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 06:01:19 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42902 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725874AbgBLLBT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 06:01:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581505278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nnVLsLjJq61roZogZjlHcOZ1qVAeRKMJqRoGZW5TNvY=;
        b=LmfW1d0/Iq5ckREAv3HFFMQTL12MMpQ8zvlhVPoHpAniWP01csOPh1YVP3wTD9wmtDulem
        x7rPtKm6c7Fst7u8fMpZQ1fhvSzA/jtpV2R18h27td9eBpd0qhdO5LWuN9xpdrvr4El38Z
        F6fnXaFMSz+a/ysednIxBe9B9doF1uc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-ErmEXazlObG_pEgj0w6QGw-1; Wed, 12 Feb 2020 06:01:13 -0500
X-MC-Unique: ErmEXazlObG_pEgj0w6QGw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4B56318A6EC1;
        Wed, 12 Feb 2020 11:01:12 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5836390073;
        Wed, 12 Feb 2020 11:01:07 +0000 (UTC)
Date:   Wed, 12 Feb 2020 12:01:04 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH 35/35] DOCUMENTATION: Protected virtual machine
 introduction and IPL
Message-ID: <20200212120104.106e8ce2.cohuck@redhat.com>
In-Reply-To: <20200207113958.7320-36-borntraeger@de.ibm.com>
References: <20200207113958.7320-1-borntraeger@de.ibm.com>
        <20200207113958.7320-36-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  7 Feb 2020 06:39:58 -0500
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
>  Documentation/virt/kvm/s390-pv-boot.rst |  79 ++++++++++++++++
>  Documentation/virt/kvm/s390-pv.rst      | 116 ++++++++++++++++++++++++
>  MAINTAINERS                             |   1 +
>  4 files changed, 198 insertions(+)
>  create mode 100644 Documentation/virt/kvm/s390-pv-boot.rst
>  create mode 100644 Documentation/virt/kvm/s390-pv.rst
> 
(...)
> diff --git a/Documentation/virt/kvm/s390-pv-boot.rst b/Documentation/virt/kvm/s390-pv-boot.rst
> new file mode 100644
> index 000000000000..47814e53369a
> --- /dev/null
> +++ b/Documentation/virt/kvm/s390-pv-boot.rst
> @@ -0,0 +1,79 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +======================================
> +s390 (IBM Z) Boot/IPL of Protected VMs
> +======================================
> +
> +Summary
> +-------
> +Protected Virtual Machines (PVM) are not accessible by I/O or the
> +hypervisor.  When the hypervisor wants to access the memory of PVMs
> +the memory needs to be made accessible. When doing so, the memory will
> +be encrypted.  See :doc:`s390-pv` for details.

Maybe

"The memory of Protected Virtual Machines (PVMs) is not accessible to
I/O or the hypervisor. In those cases where the hypervisor needs to
access the memory of a PVM, that memory must be made accessible. Memory
made accessible to the hypervisor will be encrypted. See :doc:`s390-pv`
for details."

?

> +
> +On IPL a small plaintext bootloader is started which provides

"On IPL (boot), a small plaintext bootloader is started, which..."

?

> +information about the encrypted components and necessary metadata to
> +KVM to decrypt the protected virtual machine.

(...)

> +Diag308
> +-------
> +This diagnose instruction is the basis for VM IPL. The VM can set and

"This diagnose instruction is the basic mechanism to handle IPL and
related operations for virtual machines." ?

> +retrieve IPL information blocks, that specify the IPL method/devices
> +and request VM memory and subsystem resets, as well as IPLs.
> +
> +For PVs this concept has been extended with new subcodes:

s/For PVs/For PVMs,/

(...)

> +When running in protected mode some subcodes will result in exceptions

s/When running in protected mode/When running in protected virtualization mode,/

?

> +or return error codes.
> +
> +Subcodes 4 and 7 will result in specification exceptions as they would
> +not clear out the guest memory.
> +When removing a secure VM, the UV will clear all memory, so we can't
> +have non-clearing IPL subcodes.

"Subcodes 4 and 7, which specify operations that do not clear the guest
memory, will result in specification exceptions. This is because the UV
will clear all memory when a secure VM is removed, and therefore
non-clearing IPL subcodes are not allowed."

?

(...)
> diff --git a/Documentation/virt/kvm/s390-pv.rst b/Documentation/virt/kvm/s390-pv.rst
> new file mode 100644
> index 000000000000..dbe9110dfd1e
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
> +Protected virtual machines (PVM) are KVM VMs, where KVM can't access
> +the VM's state like guest memory and guest registers anymore. Instead,

"...are KVM VMs that do not allow KVM to access VM state like guest
memory or guest registers."

?

(...)

> +The Interception Parameters state description field still contains the
> +the bytes of the instruction text, but with pre-set register values
> +instead of the actual ones. I.e. each instruction always uses the same
> +instruction text, in order not to leak guest instruction text.
> +This also implies that the register content that a guest had in r<n>
> +may be in r<m> from the hypervisors point of view.

s/hypervisors/hypervisor's/

> +
> +The Secure Instruction Data Area contains instruction storage
> +data. Instruction data, i.e. data being referenced by an instruction
> +like the SCCB for sclp, is moved over the SIDA. When an instruction is

s/over/via/ ?

> +intercepted, the SIE will only allow data and program interrupts for
> +this instruction to be moved to the guest via the two data areas
> +discussed before. Other data is either ignored or results in validity
> +interceptions.

(...)

