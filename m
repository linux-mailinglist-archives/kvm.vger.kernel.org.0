Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C40C83582A0
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 14:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbhDHMBd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 08:01:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55864 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231341AbhDHMBb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Apr 2021 08:01:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617883280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zWfFSpWGFp11S+v5Pnk2LNZUzDm7DSVLpGFzZCfF4Do=;
        b=hf+z7jEjeYzsejqg45nL2NQwuUXsb5TpEAnvFjvnVzLibrMjPevNhX5mKsdSXfwvSRlgCC
        cMfSFM8cCWFpgGrlm2EC0jfIJC11cNlo9UV7UBUaYdECAuCDPC6eAmKDlNKi+6zD1B/rf+
        k31pj27ULCYufiLf7rx0RbWdJYrVbgg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-lUxhqULDOW2UihqoZlIxzA-1; Thu, 08 Apr 2021 08:01:17 -0400
X-MC-Unique: lUxhqULDOW2UihqoZlIxzA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DE6BC10074D3;
        Thu,  8 Apr 2021 12:00:58 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-5.gru2.redhat.com [10.97.112.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8BBDF17B2B;
        Thu,  8 Apr 2021 12:00:58 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 9011F41807CE; Thu,  8 Apr 2021 09:00:21 -0300 (-03)
Date:   Thu, 8 Apr 2021 09:00:21 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, dwmw@amazon.co.uk
Subject: Re: [PATCH 1/2] KVM: x86: reduce pvclock_gtod_sync_lock critical
 sections
Message-ID: <20210408120021.GA65315@fuller.cnet>
References: <20210330165958.3094759-1-pbonzini@redhat.com>
 <20210330165958.3094759-2-pbonzini@redhat.com>
 <20210407174021.GA30046@fuller.cnet>
 <51cae826-8973-5113-7e12-8163eab36cb7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51cae826-8973-5113-7e12-8163eab36cb7@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

On Thu, Apr 08, 2021 at 10:15:16AM +0200, Paolo Bonzini wrote:
> On 07/04/21 19:40, Marcelo Tosatti wrote:
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index fe806e894212..0a83eff40b43 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -2562,10 +2562,12 @@ static void kvm_gen_update_masterclock(struct kvm *kvm)
> > >   	kvm_hv_invalidate_tsc_page(kvm);
> > > -	spin_lock(&ka->pvclock_gtod_sync_lock);
> > >   	kvm_make_mclock_inprogress_request(kvm);
> > > +
> > Might be good to serialize against two kvm_gen_update_masterclock
> > callers? Otherwise one caller could clear KVM_REQ_MCLOCK_INPROGRESS,
> > while the other is still at pvclock_update_vm_gtod_copy().
> 
> Makes sense, but this stuff has always seemed unnecessarily complicated to
> me.
>
> KVM_REQ_MCLOCK_INPROGRESS is only needed to kick running vCPUs out of the
> execution loop; 

We do not want vcpus with different system_timestamp/tsc_timestamp
pair:

 * To avoid that problem, do not allow visibility of distinct
 * system_timestamp/tsc_timestamp values simultaneously: use a master
 * copy of host monotonic time values. Update that master copy
 * in lockstep.

So KVM_REQ_MCLOCK_INPROGRESS also ensures that no vcpu enters 
guest mode (via vcpu->requests check before VM-entry) with a 
different system_timestamp/tsc_timestamp pair.

> clearing it in kvm_gen_update_masterclock is unnecessary,
> because KVM_REQ_CLOCK_UPDATE takes pvclock_gtod_sync_lock too and thus will
> already wait for pvclock_update_vm_gtod_copy to end.
> 
> I think it's possible to use a seqcount in KVM_REQ_CLOCK_UPDATE instead of
> KVM_REQ_MCLOCK_INPROGRESS.  Both cause the vCPUs to spin. I'll take a look.
> 
> Paolo

