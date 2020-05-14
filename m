Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8E751D3152
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 15:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbgENNcH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 09:32:07 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:58102 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726011AbgENNcG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 May 2020 09:32:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589463124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g/nCRkuyNaXAXNqjpWErasCkRfXCzT/klwC/USw0eGw=;
        b=RfAxDubG4ZQuJTgqHaRhJ3FHJxhhlmoTSRp6oolXWUFuKiD/t/KufhOSvcLJci2Jfq23fk
        YOlTvHnmXYfuihkC2usCBfcV26Bqt/otFGQPkcUsdF9mfwfl4AIDqOhu4KiGIQDzm6AbCT
        wr3s2aLxuKI2Bx7h++ItNAoac2kQ+OI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-486-zew_sHqfPiWLNdzseJ9lRQ-1; Thu, 14 May 2020 09:32:01 -0400
X-MC-Unique: zew_sHqfPiWLNdzseJ9lRQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1871F461;
        Thu, 14 May 2020 13:31:59 +0000 (UTC)
Received: from horse.redhat.com (ovpn-117-0.rdu2.redhat.com [10.10.117.0])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7F7F576E64;
        Thu, 14 May 2020 13:31:58 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id E9FB3220206; Thu, 14 May 2020 09:31:57 -0400 (EDT)
Date:   Thu, 14 May 2020 09:31:57 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Gavin Shan <gshan@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] KVM: x86: interrupt based APF page-ready event
 delivery
Message-ID: <20200514133157.GB206709@redhat.com>
References: <20200511164752.2158645-1-vkuznets@redhat.com>
 <20200511164752.2158645-5-vkuznets@redhat.com>
 <20200512142411.GA138129@redhat.com>
 <87lflxm9sy.fsf@vitty.brq.redhat.com>
 <20200512180704.GE138129@redhat.com>
 <877dxgmcjv.fsf@vitty.brq.redhat.com>
 <20200513135350.GB173965@redhat.com>
 <87ftc3lxqc.fsf@vitty.brq.redhat.com>
 <20200513184641.GF173965@redhat.com>
 <87zhabdjlm.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zhabdjlm.fsf@vitty.brq.redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 14, 2020 at 10:08:37AM +0200, Vitaly Kuznetsov wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > On Wed, May 13, 2020 at 04:23:55PM +0200, Vitaly Kuznetsov wrote:
> >
> > [..]
> >> >> Also,
> >> >> kdump kernel may not even support APF so it will get very confused when
> >> >> APF events get delivered.
> >> >
> >> > New kernel can just ignore these events if it does not support async
> >> > pf? 
> >> >
> >> > This is somewhat similar to devices still doing interrupts in new
> >> > kernel. And solution for that seemed to be doing a "reset" of devices
> >> > in new kernel. We probably need similar logic where in new kernel
> >> > we simply disable "async pf" so that we don't get new notifications.
> >> 
> >> Right and that's what we're doing - just disabling new notifications.
> >
> > Nice.
> >
> > So why there is a need to deliver "page ready" notifications
> > to guest after guest has disabled async pf. Atleast kdump does not
> > seem to need it. It will boot into second kernel anyway, irrespective
> > of the fact whether it receives page ready or not.
> 
> We don't deliver anything to the guest after it disables APF (neither
> 'page ready' for what was previously missing, nor 'page not ready' for
> new faults), kvm_arch_can_inject_async_page_present() is just another
> misnomer, it should be named something like
> 'kvm_arch_can_unqueue_async_page_present()' meaning that 'page ready'
> notification can be 'unqueued' from internal KVM queue. We will either
> deliver it (when guest has APF enabled) or just drop it (when guest has
> APF disabled). The only case when it has to stay in the queue is when
> guest has APF enabled and the slot is still busy (so it didn't get to
> process a previously delivered notification). We will try to deliver it
> again after guest writes to MSR_KVM_ASYNC_PF_ACK.

This makes sense. Renaming this function to make it more clear will
help understanding code better.

Vivek

