Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71DAE28A61F
	for <lists+kvm@lfdr.de>; Sun, 11 Oct 2020 09:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728891AbgJKH3U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Oct 2020 03:29:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24976 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726461AbgJKH3U (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 11 Oct 2020 03:29:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602401358;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EukZMor/4zhpLBCTClJNKoCARtZ10v2yP3vMMY5YbeQ=;
        b=PpiH5UAohajJupE5P53CcRUx/o+7EJgHCPLpWufdaSdXTFidvJrh2pJ1lDLDyiV9duEunF
        JZkUrjfK3tkHaSzqs1l5GKIV4wOsNWuVbOiCDgNnp8YlDvj3iD3tawQWhi7CnaaIVCtQ21
        Zmzvy7OdVNRWo+Mv5hCIrZqYJW0o6es=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105-sFvNnduiOL-dcplo7VOcwQ-1; Sun, 11 Oct 2020 03:29:16 -0400
X-MC-Unique: sFvNnduiOL-dcplo7VOcwQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 580AA80F044;
        Sun, 11 Oct 2020 07:29:15 +0000 (UTC)
Received: from starship (unknown [10.35.206.144])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F55946;
        Sun, 11 Oct 2020 07:29:06 +0000 (UTC)
Message-ID: <47ead258320536d00f9f32891da3810040875aff.camel@redhat.com>
Subject: Re: Why guest physical addresses are not the same as the
 corresponding host virtual addresses in QEMU/KVM? Thanks!
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     harry harry <hiharryharryharry@gmail.com>, qemu-devel@nongnu.org,
        mathieu.tarral@protonmail.com, stefanha@redhat.com,
        libvir-list@redhat.com, kvm@vger.kernel.org, pbonzini@redhat.com
Date:   Sun, 11 Oct 2020 10:29:05 +0300
In-Reply-To: <CA+-xGqMd4_58_+QKetjOsubBqrDnaYF+YWE3TC3kEcNGxPiPfg@mail.gmail.com>
References: <CA+-xGqMd4_58_+QKetjOsubBqrDnaYF+YWE3TC3kEcNGxPiPfg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 2020-10-11 at 01:26 -0400, harry harry wrote:
> Hi QEMU/KVM developers,
> 
> I am sorry if my email disturbs you. I did an experiment and found the
> guest physical addresses (GPAs) are not the same as the corresponding
> host virtual addresses (HVAs). I am curious about why; I think they
> should be the same. I am very appreciated if you can give some
> comments and suggestions about 1) why GPAs and HVAs are not the same
> in the following experiment; 2) are there any better experiments to
> look into the reasons? Any other comments/suggestions are also very
> welcome. Thanks!
> 
> The experiment is like this: in a single vCPU VM, I ran a program
> allocating and referencing lots of pages (e.g., 100*1024) and didn't
> let the program terminate. Then, I checked the program's guest virtual
> addresses (GVAs) and GPAs through parsing its pagemap and maps files
> located at /proc/pid/pagemap and /proc/pid/maps, respectively. At
> last, in the host OS, I checked the vCPU's pagemap and maps files to
> find the program's HVAs and host physical addresses (HPAs); I actually
> checked the new allocated physical pages in the host OS after the
> program was executed in the guest OS.
> 
> With the above experiment, I found GPAs of the program are different
> from its corresponding HVAs. BTW, Intel EPT and other related Intel
> virtualization techniques were enabled.
> 
> Thanks,
> Harry
> 
The fundemental reason is that some HVAs (e.g. QEMU's virtual memory addresses) are already allocated
for qemu's own use (e.g qemu code/heap/etc) prior to the guest starting up. 

KVM does though use quite effiecient way of mapping HVA's to GPA. It uses an array of arbitrary sized HVA areas
(which we call memslots) and for each such area/memslot you specify the GPA to map to. In theory QEMU 
could allocate the whole guest's memory in one contiguous area and map it as single memslot to the guest. 
In practice there are MMIO holes, and various other reasons why there will be more that 1 memslot.
 
Best regards,
	Maxim Levitsky

