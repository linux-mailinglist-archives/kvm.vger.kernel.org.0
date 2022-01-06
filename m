Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0CDD486B51
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 21:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243823AbiAFUmb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 15:42:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:53247 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232673AbiAFUma (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Jan 2022 15:42:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641501749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KgzHkaXLb7ol7cQTWhVobQEnPQtmJq3Kv9iwysu1jio=;
        b=VKUcogFdc1voOBl25+1h31XWm1dmUHHsADuYljYpkbfZnAcGINa0KTxoYJLVvZI8llZFu3
        gTH6kTBYakza4U0e0xn/J6y+Pgjf9RAlTGCtlzRGG5vzL3qxCg140Kzg1JjK7X8Uc4SFhe
        ce+z53alI5WqT58ZHtoy8SRBfmY5dYk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639-yFfF1PM_PDiCDjqWVmhWag-1; Thu, 06 Jan 2022 15:42:28 -0500
X-MC-Unique: yFfF1PM_PDiCDjqWVmhWag-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5948F64083;
        Thu,  6 Jan 2022 20:42:27 +0000 (UTC)
Received: from starship (unknown [10.40.192.177])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5A7FC5BE28;
        Thu,  6 Jan 2022 20:42:26 +0000 (UTC)
Message-ID: <a65362b846fa686ea3c4731c7e0ab32c88e41d87.camel@redhat.com>
Subject: Re: [Bug 215459] VM freezes starting with kernel 5.15
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     bugzilla-daemon@bugzilla.kernel.org, kvm@vger.kernel.org
Date:   Thu, 06 Jan 2022 22:42:24 +0200
In-Reply-To: <bug-215459-28872-TQlaXRXjPh@https.bugzilla.kernel.org/>
References: <bug-215459-28872@https.bugzilla.kernel.org/>
         <bug-215459-28872-TQlaXRXjPh@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-01-06 at 18:52 +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=215459
> 
> Sean Christopherson (seanjc@google.com) changed:
> 
>            What    |Removed                     |Added
> ----------------------------------------------------------------------------
>                  CC|                            |seanjc@google.com
> 
> --- Comment #4 from Sean Christopherson (seanjc@google.com) ---
> The fix Maxim is referring to is commit fdba608f15e2 ("KVM: VMX: Wake vCPU when
> delivering posted IRQ even if vCPU == this vCPU").  But the buggy commit was
> introduced back in v5.8, so it's unlikely that's the issue, or at least that
> it's the only issue.  And assuming the VM in question has multiple vCPUs (which
> I'm pretty sure is true based on the config), that bug is unlikely to cause the
> entire VM to freeze; the expected symptom is that a vCPU isn't awakened when it
> should be, and while it's possible multiple vCPUs could get unlucky, taking
> down the entire VM is highly improbable.  That said, it's worth trying that
> fix, I'm just not very optimistic :-)

Actually in my experience in both Linux and Windows, a stuck vCPU derails the whole VM.
That is how I found about the AVIC errata - only one vCPU got stuck and the whole VM froze,
and it was a a windows VM.

On Linux also these days things like RCU and such make everything freeze very fast.

> 
> Assuming this is something different, the biggest relevant changes in v5.15 are
> that the TDP MMU is enabled by default, and that the APIC access page memslot
> is not deleted when APICv is inhibited.

> 
> Can you try disabling the TDP MMU with APICv still enabled?  KVM allows that to
> be toggled without unloading, e.g. "echo N | sudo tee
> /sys/module/kvm/parameters/tdp_mmu", the VM just needs to be started after the
> param is toggled.

This is a very good idea. I keep on forgetting that TDP mmu is now the default.

> 
> Running v5.16 (or v5.16-rc8, as there are no KVM changes expected between rc8
> ad the final release) would also be very helpful.  If we get lucky and the
> issue is resolved in v5.16, then it would be nice to "reverse" bisect to
> understand exactly what fixed the problem.

Or just bisect it if not fixed. It would be very helpful!

> 
> > Assuming I really do have APICv: is there anything I need to change in my XML
> > to really make use of this feature or does it work "out of the box"?
> 
> APICv works out of the box, though lack of IOMMU support does mean that your
> system can't post interrupts from devices, which is usually the biggest
> performance benefit to APICv on Intel.

I haven't measured it formally, but with posted timer interrupts on AMD,
this does quite reduce the number of VM exits, even without any pass-through
devices.

For passthrough devices, also note that without IOMMU support, still,
while the device does send a regular interrupt to the host, then host
handler uses APICv to deliver it to the guest, so assuming that interrupt
is not pinned on one of vCPUs, the VM still doesn't get a VM exit.

I once benchmarked a pass-through nvme device on old Xeon which didn't had
IOMMU posted interrupts, and APICv still made quite a difference.

I so wish Intel would not disable this feature on consumer systems.
But then AVIC has bugs.. Oh well.

Best regards,
	Maxim Levitsky

