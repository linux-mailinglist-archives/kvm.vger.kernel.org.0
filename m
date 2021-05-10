Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12812379681
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 19:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233199AbhEJRzH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 13:55:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22639 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231512AbhEJRzH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 13:55:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620669241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Q8zrkY6i3GGCRRRcvyXkvs2AXr+SVRkrm6eJ5LBI7P0=;
        b=Bs//1v0dNI03pw1cRiWGj9IPTNnQ7Y2ODTRikJRmQTq31Kq930RtA97kvMvVEhry0gdIQ4
        7lswbJwVf2TVRJzhK+67IgWr3ocxPeA28tbBENdCP4NqxFt3DjllursilNKdpkp1nLGX88
        biSaGHkPtrP2yfpy8jz+dqMexIrSekM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-4hNSdJaNM2614DnodBB8Gw-1; Mon, 10 May 2021 13:54:00 -0400
X-MC-Unique: 4hNSdJaNM2614DnodBB8Gw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F33B6107ACC7;
        Mon, 10 May 2021 17:53:58 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-8.gru2.redhat.com [10.97.112.8])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D799361094;
        Mon, 10 May 2021 17:53:51 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 197D1406E9D9; Mon, 10 May 2021 14:53:46 -0300 (-03)
Date:   Mon, 10 May 2021 14:53:46 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [patch 1/4] KVM: x86: add start_assignment hook to kvm_x86_ops
Message-ID: <20210510175346.GA48272@fuller.cnet>
References: <20210507130609.269153197@redhat.com>
 <20210507130923.438255076@redhat.com>
 <YJWR8G+2RSESOQyS@t490s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJWR8G+2RSESOQyS@t490s>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 07, 2021 at 03:16:00PM -0400, Peter Xu wrote:
> On Fri, May 07, 2021 at 10:06:10AM -0300, Marcelo Tosatti wrote:
> > Add a start_assignment hook to kvm_x86_ops, which is called when 
> > kvm_arch_start_assignment is done.
> > 
> > The hook is required to update the wakeup vector of a sleeping vCPU
> > when a device is assigned to the guest.
> > 
> > Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> > 
> > Index: kvm/arch/x86/include/asm/kvm_host.h
> > ===================================================================
> > --- kvm.orig/arch/x86/include/asm/kvm_host.h
> > +++ kvm/arch/x86/include/asm/kvm_host.h
> > @@ -1322,6 +1322,7 @@ struct kvm_x86_ops {
> >  
> >  	int (*update_pi_irte)(struct kvm *kvm, unsigned int host_irq,
> >  			      uint32_t guest_irq, bool set);
> > +	void (*start_assignment)(struct kvm *kvm, int device_count);
> 
> I'm thinking what the hook could do with the device_count besides comparing it
> against 1...
> 
> If we can't think of any, perhaps we can directly make it an enablement hook
> instead (so we avoid calling the hook at all when count>1)?
> 
>    /* Called when the first assignment registers (count from 0 to 1) */
>    void (*enable_assignment)(struct kvm *kvm);

Sure, sounds good, just kept the original name...

