Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4256C2D7803
	for <lists+kvm@lfdr.de>; Fri, 11 Dec 2020 15:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394585AbgLKOg5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Dec 2020 09:36:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28618 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389968AbgLKOgk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Dec 2020 09:36:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607697314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OJMP31tePBJjjh6Q77mzSRtZF5z0111CoyEfOWh0hbo=;
        b=QD2bUKnE4V1q4WpzeYbUlozog0WvZPKdU/FxmZcEG58Gwo5uCa+PFPoL+Guevhwz9FsQ2U
        fRbb+NciMsn5AzAX7/G6T+D+MDiQOtA75HQqz04vU/XuR7WU1lrAhCuAP7dM6FiK4ILGbn
        DXwqFVMW85fwxCwWBQ4ES32A3Rtnzck=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-5b1P3Kg2PIGV1v3YQoie7A-1; Fri, 11 Dec 2020 09:35:12 -0500
X-MC-Unique: 5b1P3Kg2PIGV1v3YQoie7A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 833FA107ACFE;
        Fri, 11 Dec 2020 14:35:10 +0000 (UTC)
Received: from gondolin (ovpn-112-240.ams2.redhat.com [10.36.112.240])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2C0F360BF1;
        Fri, 11 Dec 2020 14:35:04 +0000 (UTC)
Date:   Fri, 11 Dec 2020 15:35:01 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@de.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/4] vfio-pci/zdev: Fixing s390 vfio-pci ISM support
Message-ID: <20201211153501.7767a603.cohuck@redhat.com>
In-Reply-To: <ce9d4ef2-2629-59b7-99ed-4c8212cb004f@linux.ibm.com>
References: <1607545670-1557-1-git-send-email-mjrosato@linux.ibm.com>
        <20201210133306.70d1a556.cohuck@redhat.com>
        <ce9d4ef2-2629-59b7-99ed-4c8212cb004f@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 10 Dec 2020 10:51:23 -0500
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> On 12/10/20 7:33 AM, Cornelia Huck wrote:
> > On Wed,  9 Dec 2020 15:27:46 -0500
> > Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> >   
> >> Today, ISM devices are completely disallowed for vfio-pci passthrough as
> >> QEMU will reject the device due to an (inappropriate) MSI-X check.
> >> However, in an effort to enable ISM device passthrough, I realized that the
> >> manner in which ISM performs block write operations is highly incompatible
> >> with the way that QEMU s390 PCI instruction interception and
> >> vfio_pci_bar_rw break up I/O operations into 8B and 4B operations -- ISM
> >> devices have particular requirements in regards to the alignment, size and
> >> order of writes performed.  Furthermore, they require that legacy/non-MIO
> >> s390 PCI instructions are used, which is also not guaranteed when the I/O
> >> is passed through the typical userspace channels.  
> > 
> > The part about the non-MIO instructions confuses me. How can MIO
> > instructions be generated with the current code, and why does changing  
> 
> So to be clear, they are not being generated at all in the guest as the 
> necessary facility is reported as unavailable.
> 
> Let's talk about Linux in LPAR / the host kernel:  When hardware that 
> supports MIO instructions is available, all userspace I/O traffic is 
> going to be routed through the MIO variants of the s390 PCI 
> instructions.  This is working well for other device types, but does not 
> work for ISM which does not support these variants.  However, the ISM 
> driver also does not invoke the userspace I/O routines for the kernel, 
> it invokes the s390 PCI layer directly, which in turn ensures the proper 
> PCI instructions are used -- This approach falls apart when the guest 
> ISM driver invokes those routines in the guest -- we (qemu) pass those 
> non-MIO instructions from the guest as memory operations through 
> vfio-pci, traversing through the vfio I/O layer in the guest 
> (vfio_pci_bar_rw and friends), where we then arrive in the host s390 PCI 
> layer -- where the MIO variant is used because the facility is available.
> 
> Per conversations with Niklas (on CC), it's not trivial to decide by the 
> time we reach the s390 PCI I/O layer to switch gears and use the non-MIO 
> instruction set.
> 
> > the write pattern help?  
> 
> The write pattern is a separate issue from non-MIO instruction 
> requirements...  Certain address spaces require specific instructions to 
> be used (so, no substituting PCISTG for PCISTB - that happens too by 
> default for any writes coming into the host s390 PCI layer that are 
> <=8B, and they all are when the PCISTB is broken up into 8B memory 
> operations that travel through vfio_pci_bar_rw, which further breaks 
> those up into 4B operations).  There's also a requirement for some 
> writes that the data, if broken up, be written in a certain order in 
> order to properly trigger events. :(  The ability to pass the entire 
> PCISTB payload vs breaking it into 8B chunks is also significantly faster.

Let me summarize this to make sure I understand this new region
correctly:

- some devices may have relaxed alignment/length requirements for
  pcistb (and friends?)
- some devices may actually require writes to be done in a large chunk
  instead of being broken up (is that a strict subset of the devices
  above?)
- some devices do not support the new MIO instructions (is that a
  subset of the relaxed alignment devices? I'm not familiar with the
  MIO instructions)

The patchsets introduce a new region that (a) is used by QEMU to submit
writes in one go, and (b) makes sure to call into the non-MIO
instructions directly; it's basically killing two birds with one stone
for ISM devices. Are these two requirements (large writes and non-MIO)
always going hand-in-hand, or is ISM just an odd device?

If there's an expectation that the new region will always use the
non-MIO instructions (in addition to the changed write handling), it
should be noted in the description for the region as well.

