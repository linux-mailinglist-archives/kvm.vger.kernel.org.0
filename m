Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E26D81D1DD8
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 20:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390174AbgEMSqt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 14:46:49 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30913 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389392AbgEMSqs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 May 2020 14:46:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589395607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kmVswhhUfzJrVfazGuns3TDSU4rliVl1t7Fe7MJ2Xjk=;
        b=QNUHh62X6Hxqex+YARrTp8r+Ig6ceH3+SubSKZvACJ18Wg/J9nIfDxNP6pGYO6Q5e5CN23
        +4W+soCAzrbMY0coGS+gpm6JDX1/iBYWEHtK+YL6xLp0lRgWfJkzPhvdBGme6rUEq0XaDY
        sx313dtW/8NhG7jEVxl6zGuLipsDjn0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-3FG-WDhRPhC2M-vzl3GMaQ-1; Wed, 13 May 2020 14:46:45 -0400
X-MC-Unique: 3FG-WDhRPhC2M-vzl3GMaQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4480F474;
        Wed, 13 May 2020 18:46:43 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-240.rdu2.redhat.com [10.10.115.240])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5DC75196AE;
        Wed, 13 May 2020 18:46:41 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 79601220206; Wed, 13 May 2020 14:46:41 -0400 (EDT)
Date:   Wed, 13 May 2020 14:46:41 -0400
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
Message-ID: <20200513184641.GF173965@redhat.com>
References: <20200511164752.2158645-1-vkuznets@redhat.com>
 <20200511164752.2158645-5-vkuznets@redhat.com>
 <20200512142411.GA138129@redhat.com>
 <87lflxm9sy.fsf@vitty.brq.redhat.com>
 <20200512180704.GE138129@redhat.com>
 <877dxgmcjv.fsf@vitty.brq.redhat.com>
 <20200513135350.GB173965@redhat.com>
 <87ftc3lxqc.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ftc3lxqc.fsf@vitty.brq.redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 13, 2020 at 04:23:55PM +0200, Vitaly Kuznetsov wrote:

[..]
> >> Also,
> >> kdump kernel may not even support APF so it will get very confused when
> >> APF events get delivered.
> >
> > New kernel can just ignore these events if it does not support async
> > pf? 
> >
> > This is somewhat similar to devices still doing interrupts in new
> > kernel. And solution for that seemed to be doing a "reset" of devices
> > in new kernel. We probably need similar logic where in new kernel
> > we simply disable "async pf" so that we don't get new notifications.
> 
> Right and that's what we're doing - just disabling new notifications.

Nice.

So why there is a need to deliver "page ready" notifications
to guest after guest has disabled async pf. Atleast kdump does not
seem to need it. It will boot into second kernel anyway, irrespective
of the fact whether it receives page ready or not.

Thanks
Vivek

