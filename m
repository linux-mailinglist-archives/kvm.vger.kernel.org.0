Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5931F6E89
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 22:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbgFKUL4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 16:11:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38696 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726119AbgFKUL4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jun 2020 16:11:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591906314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HNVvQ3IKC3IYeCH67dm2oiDX1bsqOcEeVIAvkuXpzIE=;
        b=TfrXjc666tWAW/a1ng+SPj/oy9F5vg0K/DfdenXeBFnjMcS5Dco/iHt1ixQfh4Gykxtp2I
        UTi8OFUt2cy3iMl+jCytkOGFAT7i4816ePsQpq2A9lHJ0W8mefn6eO8jll5Ez0A+8vdDDw
        trZdZbcDEQJUzo3h5TVu4yCIdHq63hs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-303-v0QRyMU7PmyT8YX8wX60ig-1; Thu, 11 Jun 2020 16:11:50 -0400
X-MC-Unique: v0QRyMU7PmyT8YX8wX60ig-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D1258018A7;
        Thu, 11 Jun 2020 20:11:49 +0000 (UTC)
Received: from starship (unknown [10.35.206.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 422137CCE7;
        Thu, 11 Jun 2020 20:11:48 +0000 (UTC)
Message-ID: <98d2c1c4ad3e23def8f9a7c71df6b90217b42a88.camel@redhat.com>
Subject: Re: [PATCH] KVM: check userspace_addr for all memslots
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 11 Jun 2020 23:11:47 +0300
In-Reply-To: <b97854bd-ff63-71ee-3c27-2602326a26b8@redhat.com>
References: <20200601082146.18969-1-pbonzini@redhat.com>
         <dde19d595336a5d79345f3115df26687871dfad5.camel@redhat.com>
         <b97854bd-ff63-71ee-3c27-2602326a26b8@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2020-06-11 at 17:27 +0200, Paolo Bonzini wrote:
> On 11/06/20 16:44, Maxim Levitsky wrote:
> > On Mon, 2020-06-01 at 04:21 -0400, Paolo Bonzini wrote:
> > > The userspace_addr alignment and range checks are not performed for private
> > > memory slots that are prepared by KVM itself.  This is unnecessary and makes
> > > it questionable to use __*_user functions to access memory later on.  We also
> > > rely on the userspace address being aligned since we have an entire family
> > > of functions to map gfn to pfn.
> > > 
> > > Fortunately skipping the check is completely unnecessary.  Only x86 uses
> > > private memslots and their userspace_addr is obtained from vm_mmap,
> > > therefore it must be below PAGE_OFFSET.  In fact, any attempt to pass
> > > an address above PAGE_OFFSET would have failed because such an address
> > > would return true for kvm_is_error_hva.
> > > 
> > > Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> > > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > 
> > I bisected this patch to break a VM on my AMD system (3970X)
> > 
> > The reason it happens, is because I have avic enabled (which uses
> > a private KVM memslot), but it is permanently disabled for that VM,
> > since I enabled nesting for that VM (+svm) and that triggers the code
> > in __x86_set_memory_region to set userspace_addr of the disabled
> > memslot to non canonical address (0xdeadull << 48) which is later rejected in __kvm_set_memory_region
> > after that patch, and that makes it silently not disable the memslot, which hangs the guest.
> > 
> > The call is from avic_update_access_page, which is called from svm_pre_update_apicv_exec_ctrl
> > which discards the return value.
> > 
> > 
> > I think that the fix for this would be to either make access_ok always return
> > true for size==0, or __kvm_set_memory_region should treat size==0 specially
> > and skip that check for it.
> 
> Or just set hva to 0.  Deletion goes through kvm_delete_memslot so that
> dummy hva is not used anywhere.  If we really want to poison the hva of
> deleted memslots we should not do it specially in
> __x86_set_memory_region.  I'll send a patch.

After checking exactly what access_ok does, I mostly agree with this.
There is still an implicit assumption that address 0 is a valid userspace address.
It is fair to assume that on x86 though.

Best regards,
	Maxim Levitsky

> 
> Paolo
> 


