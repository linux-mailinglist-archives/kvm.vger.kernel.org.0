Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFA051D16E1
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 16:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388776AbgEMODO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 10:03:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25809 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388667AbgEMODL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 May 2020 10:03:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589378590;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H0VwXgXDRwfKbDIjTqIx4tI86RnceSX/HZFFQNPbyc4=;
        b=PyzwlcaoHYnVx8o6SxQYUvhKtheB255z8emyeqkN9m/K3vVlAm1b7rHQ8QzrUX6rN4P2/9
        mTOInk4njGKlixtRke6qzWyMS4PgNYXuligbgvlaPyCXJhGd/42Uq9uOsMgFL2t6Ev98Q+
        yhuDfSRsbPDzTpTtCEgSxWeZYEOSORo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-225-yczyfFHANK6jOKMPiiiAvQ-1; Wed, 13 May 2020 10:03:08 -0400
X-MC-Unique: yczyfFHANK6jOKMPiiiAvQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 773221841925;
        Wed, 13 May 2020 14:03:06 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-240.rdu2.redhat.com [10.10.115.240])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 287EA12A4D;
        Wed, 13 May 2020 14:03:05 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id A9553220206; Wed, 13 May 2020 10:03:04 -0400 (EDT)
Date:   Wed, 13 May 2020 10:03:04 -0400
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
Message-ID: <20200513140304.GC173965@redhat.com>
References: <20200511164752.2158645-1-vkuznets@redhat.com>
 <20200511164752.2158645-5-vkuznets@redhat.com>
 <20200512142411.GA138129@redhat.com>
 <87lflxm9sy.fsf@vitty.brq.redhat.com>
 <20200512180704.GE138129@redhat.com>
 <877dxgmcjv.fsf@vitty.brq.redhat.com>
 <20200513135350.GB173965@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513135350.GB173965@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 13, 2020 at 09:53:50AM -0400, Vivek Goyal wrote:

[..]
> > > And this notion of same structure being shared across multiple events
> > > at the same time is just going to create more confusion, IMHO. If we
> > > can decouple it by serializing it, that definitely feels simpler to
> > > understand.
> > 
> > What if we just add sub-structures to the structure, e.g. 
> > 
> > struct kvm_vcpu_pv_apf_data {
> >         struct {
> >             __u32 apf_flag;
> >         } legacy_apf_data;
> >         struct {
> >             __u32 token;
> >         } apf_interrupt_data;
> >         ....
> >         __u8 pad[56];                                                                                  |
> >         __u32 enabled;                                                                                 |
> > };    
> > 
> > would it make it more obvious?

On a second thought, given we are not planning to use
this structure for synchrous events anymore, I think defining
struct might be overkill. May be a simple comment will do.

struct kvm_vcpu_pv_apf_data {
	/* Used by page fault based page not present notifications. Soon
	 * it will be legacy
	 */
	__u32 apf_flag;
	/* Used for interrupt based page ready notifications */
	__u32 token;
	...
	...
}

Thanks
Vivek

