Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0664150A0D
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 16:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbgBCPnK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 10:43:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60683 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727148AbgBCPnJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Feb 2020 10:43:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580744587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5Iqxz/ywxXHZdC2CIm3Fd2PCPomfzfHbJW4F+u4So+0=;
        b=Q0J/fucdoqI8n8ZuflhLZd4rskAY0QehRKKQjordHrxhsi+JBSOTXFOeYEsyhBNGDEHhD/
        eJ3+Z4Nt6/itqU9iG6UJBLvIedGNv320jD2YVCEXIPHfqTah6yh3cgbYTOXr32DpapmK7f
        JJ7TjUDEDtFKQTTtp9PUBE9Ilp3uclo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-jf-SA-UZPYCfyJ8O6wWSxA-1; Mon, 03 Feb 2020 10:43:00 -0500
X-MC-Unique: jf-SA-UZPYCfyJ8O6wWSxA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0038518C8C2E;
        Mon,  3 Feb 2020 15:42:59 +0000 (UTC)
Received: from gondolin (ovpn-117-79.ams2.redhat.com [10.36.117.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B4E5B87ECB;
        Mon,  3 Feb 2020 15:42:53 +0000 (UTC)
Date:   Mon, 3 Feb 2020 16:42:50 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFCv2 01/37] DOCUMENTATION: protvirt: Protected virtual
 machine introduction
Message-ID: <20200203164250.7a2fd5a6.cohuck@redhat.com>
In-Reply-To: <20200203131957.383915-2-borntraeger@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
        <20200203131957.383915-2-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  3 Feb 2020 08:19:21 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> From: Janosch Frank <frankja@linux.ibm.com>
> 
> Add documentation about protected KVM guests.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  Documentation/virt/kvm/s390-pv.rst | 103 +++++++++++++++++++++++++++++
>  MAINTAINERS                        |   1 +
>  2 files changed, 104 insertions(+)
>  create mode 100644 Documentation/virt/kvm/s390-pv.rst
> 
> diff --git a/Documentation/virt/kvm/s390-pv.rst b/Documentation/virt/kvm/s390-pv.rst
> new file mode 100644
> index 000000000000..5ef7e6cc2180
> --- /dev/null
> +++ b/Documentation/virt/kvm/s390-pv.rst
> @@ -0,0 +1,103 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +============================
> +Ultravisor and Protected VMs
> +============================
> +
> +Summary
> +-------
> +Protected virtual machines (PVM) are KVM VMs, where KVM can't access
> +the VM's state like guest memory and guest registers anymore. Instead,
> +the PVMs are mostly managed by a new entity called Ultravisor
> +(UV). The UV provides an API that can be used by PVMs and KVM to
> +request management actions.
> +
> +Each guest starts in the non-protected mode and then may make a
> +request to transition into protected mode. On transition, KVM
> +registers the guest and its VCPUs with the Ultravisor and prepares
> +everything for running it.
> +
> +The Ultravisor will secure and decrypt the guest's boot memory
> +(i.e. kernel/initrd). It will safeguard state changes like VCPU
> +starts/stops and injected interrupts while the guest is running.
> +
> +As access to the guest's state, such as the SIE state description, is
> +normally needed to be able to run a VM, some changes have been made in
> +SIE behavior. A new format 4 state description has been introduced,
> +where some fields have different meanings for a PVM. SIE exits are
> +minimized as much as possible to improve speed and reduce exposed
> +guest state.

Suggestion: Can you include some ASCII art here describing the
relationship of KVM, PVMs, and the UV? I think there was something in
the KVM Forum talk.

> +
> +
> +Interrupt injection
> +-------------------
> +Interrupt injection is safeguarded by the Ultravisor. As KVM doesn't
> +have access to the VCPUs' lowcores, injection is handled via the
> +format 4 state description.
> +
> +Machine check, external, IO and restart interruptions each can be
> +injected on SIE entry via a bit in the interrupt injection control
> +field (offset 0x54). If the guest cpu is not enabled for the interrupt
> +at the time of injection, a validity interception is recognized. The
> +format 4 state description contains fields in the interception data
> +block where data associated with the interrupt can be transported.
> +
> +Program and Service Call exceptions have another layer of
> +safeguarding; they can only be injected for instructions that have
> +been intercepted into KVM. The exceptions need to be a valid outcome

s/valid/possible/ ?

> +of an instruction emulation by KVM, e.g. we can never inject a
> +addressing exception as they are reported by SIE since KVM has no
> +access to the guest memory.
> +
> +
> +Mask notification interceptions
> +-------------------------------
> +As a replacement for the lctl(g) and lpsw(e) instruction
> +interceptions, two new interception codes have been introduced. One
> +indicating that the contents of CRs 0, 6 or 14 have been changed. And
> +one indicating PSW bit 13 changes.

Hm, I think I already commented on this last time... here is my current
suggestion :)

"In order to be notified when a PVM enables a certain class of
interrupt, KVM cannot intercept lctl(g) and lpsw(e) anymore. As a
replacement, two new interception codes have been introduced: One
indicating that the contents of CRs 0, 6, or 14 have been changed,
indicating different interruption subclasses; and one indicating that
PSW bit 13 has been changed, indicating whether machine checks are
enabled."


> +
> +Instruction emulation
> +---------------------
> +With the format 4 state description for PVMs, the SIE instruction already
> +interprets more instructions than it does with format 2. As it is not
> +able to interpret every instruction, the SIE and the UV safeguard KVM's
> +emulation inputs and outputs.

"It is not able to interpret every instruction, but needs to hand some
tasks to KVM; therefore, the SIE and the UV safeguard..."

?

> +
> +Guest GRs and most of the instruction data, such as I/O data structures,
> +are filtered. Instruction data is copied to and from the Secure
> +Instruction Data Area. Guest GRs are put into / retrieved from the
> +Interception-Data block.

These areas are in the SIE control block, right?

> +
> +The Interception-Data block from the state description's offset 0x380
> +contains GRs 0 - 16. Only GR values needed to emulate an instruction
> +will be copied into this area.
> +
> +The Interception Parameters state description field still contains the
> +the bytes of the instruction text, but with pre-set register values
> +instead of the actual ones. I.e. each instruction always uses the same
> +instruction text, in order not to leak guest instruction text.

This also implies that the register content that a guest had in r<n>
may be in r<m> in the interception data block if <m> is the default
register used for that instruction?

> +
> +The Secure Instruction Data Area contains instruction storage
> +data. Instruction data, i.e. data being referenced by an instruction
> +like the SCCB for sclp, is moved over the SIDA When an instruction is

Maybe move the introduction of the 'SIDA' acronym up to the
introduction of the Secure Instruction Data Area?

Also, s/moved over the SIDA/moved over to the SIDA./ ?


> +intercepted, the SIE will only allow data and program interrupts for
> +this instruction to be moved to the guest via the two data areas
> +discussed before. Other data is either ignored or results in validity
> +interceptions.
> +
> +
> +Instruction emulation interceptions
> +-----------------------------------
> +There are two types of SIE secure instruction intercepts: the normal
> +and the notification type. Normal secure instruction intercepts will
> +make the guest pending for instruction completion of the intercepted
> +instruction type, i.e. on SIE entry it is attempted to complete
> +emulation of the instruction with the data provided by KVM. That might
> +be a program exception or instruction completion.
> +
> +The notification type intercepts inform KVM about guest environment
> +changes due to guest instruction interpretation. Such an interception
> +is recognized for example for the store prefix instruction to provide

s/ for example/, for example,/

> +the new lowcore location. On SIE reentry, any KVM data in the data
> +areas is ignored, program exceptions are not injected and execution
> +continues, as if no intercept had happened.

So, KVM putting stuff there does not cause any exception, it is simply
discarded?

> diff --git a/MAINTAINERS b/MAINTAINERS
> index 56765f542244..90da412bebd9 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -9106,6 +9106,7 @@ L:	kvm@vger.kernel.org
>  W:	http://www.ibm.com/developerworks/linux/linux390/
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git
>  S:	Supported
> +F:	Documentation/virt/kvm/s390*
>  F:	arch/s390/include/uapi/asm/kvm*
>  F:	arch/s390/include/asm/gmap.h
>  F:	arch/s390/include/asm/kvm*

