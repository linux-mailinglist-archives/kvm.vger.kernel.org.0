Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8671BA0DF
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 12:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgD0KOY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 06:14:24 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35662 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726537AbgD0KOY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 06:14:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587982463;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3IW9HgfDujbab/+/11CmfGM+MNOg/XBECn0ldR8KooQ=;
        b=U8XM0XurW+xysnDQrkldYu6iSwjr2HM19BWCGawY/uukpLvOzNTOdfjXFy67remV+IUr9S
        N5dn+/q9hC6lwe1gKKLYhpvJoWRJJSQl6t130pBCltM/KxM4Td384T4FlkUXfMsz9Ik5G0
        yuSJBOMqwdj0vZZhVuNHQXycTJ4KAAc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-XQ_xfmDFOyGf6Y0mMKxeCQ-1; Mon, 27 Apr 2020 06:14:21 -0400
X-MC-Unique: XQ_xfmDFOyGf6Y0mMKxeCQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 81AFA100A8EC
        for <kvm@vger.kernel.org>; Mon, 27 Apr 2020 10:14:20 +0000 (UTC)
Received: from paraplu.localdomain (unknown [10.36.110.49])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4999A5D70C;
        Mon, 27 Apr 2020 10:14:20 +0000 (UTC)
Received: by paraplu.localdomain (Postfix, from userid 1001)
        id 35EC33E048A; Mon, 27 Apr 2020 12:14:18 +0200 (CEST)
Date:   Mon, 27 Apr 2020 12:14:18 +0200
From:   Kashyap Chamarthy <kchamart@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, cohuck@redhat.com, dgilbert@redhat.com,
        vkuznets@redhat.com
Subject: Re: [PATCH v2] docs/virt/kvm: Document running nested guests
Message-ID: <20200427101418.GA25403@paraplu>
References: <20200420111755.2926-1-kchamart@redhat.com>
 <c35b6a07-0e5c-fef7-2a39-b0f498eea36c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c35b6a07-0e5c-fef7-2a39-b0f498eea36c@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 21, 2020 at 12:35:21PM +0200, Paolo Bonzini wrote:
> Mostly looks good except for kernel parameters:

[Just noticed this; somehow the KVM e-mails, which I explicitly Cced
myself, aren't arriving in my Inbox.]

> On 20/04/20 13:17, Kashyap Chamarthy wrote:
> > +Enabling "nested" (x86)
> > +-----------------------
> > +
> > +From Linux kernel v4.19 onwards, the ``nested`` KVM parameter is enabled
> > +by default for Intel x86, but *not* for AMD.  (Though your Linux
> > +distribution might override this default.)
> 
> It is enabled for AMD as well.

Ah, thanks.  Will correct.

> > +
> > +If your hardware is sufficiently advanced (Intel Haswell processor or
> > +above which has newer hardware virt extensions), you might want to
> > +enable additional features: "Shadow VMCS (Virtual Machine Control
> > +Structure)", APIC Virtualization on your bare metal host (L0).
> > +Parameters for Intel hosts::
> > +
> > +    $ cat /sys/module/kvm_intel/parameters/enable_shadow_vmcs
> > +    Y
> > +
> > +    $ cat /sys/module/kvm_intel/parameters/enable_apicv
> > +    N
> > +
> > +    $ cat /sys/module/kvm_intel/parameters/ept
> > +    Y
> 
> 
> These are enabled by default if you have them, on all kernel versions.
> So you may instead tell people to check them (especially
> enable_shadow_vmcs and ept) if their L2 guests run slower.

Noted, will amend.

> > 
> > +Starting a nested guest (x86)
> > +-----------------------------
> > +
> > +Once your bare metal host (L0) is configured for nesting, you should be
> > +able to start an L1 guest with::
> > +
> > +    $ qemu-kvm -cpu host [...]
> > +
> > +The above will pass through the host CPU's capabilities as-is to the
> > +gues); or for better live migration compatibility, use a named CPU
> > +model supported by QEMU. e.g.::
> > +
> > +    $ qemu-kvm -cpu Haswell-noTSX-IBRS,vmx=on
> > +
> > +then the guest hypervisor will subsequently be capable of running a
> > +nested guest with accelerated KVM.
> > +
> 
> The latter is only on QEMU 4.2 and newer.  Also, you should group by
> architecture and use third-level headings within an architecture.

Okay, will adjust the structure.

Thanks for the review.


-- 
/kashyap

