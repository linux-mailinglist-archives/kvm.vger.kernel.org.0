Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF4E357363
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 19:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236534AbhDGRo2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 13:44:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60705 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236195AbhDGRo1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Apr 2021 13:44:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617817457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UvND0sWUEksMahT4ZPQuH/6oLpAcsH6szOWfFSbWLtI=;
        b=R2JRTSjVCdu1kjI8FCjntilqtDqn3X8EZvMhNcB3MLd1258ZldFjOEk5jwbwKSOqNOu6eB
        62BLrJiWki9YWS4G3ANfIl0C7Igk1S+O53nMN4T61NP1gFZZ3LEAKDLep+hfKnCkJfh3rB
        N7KERDrigdjnIKOkgASNAzpcIf0a9ps=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-110-nwAaVmILO-qKnyBKyfuaZQ-1; Wed, 07 Apr 2021 13:44:03 -0400
X-MC-Unique: nwAaVmILO-qKnyBKyfuaZQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0A42B807352;
        Wed,  7 Apr 2021 17:44:02 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-5.gru2.redhat.com [10.97.112.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C3B022C167;
        Wed,  7 Apr 2021 17:44:01 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 5134341486C6; Wed,  7 Apr 2021 14:40:21 -0300 (-03)
Date:   Wed, 7 Apr 2021 14:40:21 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, dwmw@amazon.co.uk
Subject: Re: [PATCH 1/2] KVM: x86: reduce pvclock_gtod_sync_lock critical
 sections
Message-ID: <20210407174021.GA30046@fuller.cnet>
References: <20210330165958.3094759-1-pbonzini@redhat.com>
 <20210330165958.3094759-2-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330165958.3094759-2-pbonzini@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 30, 2021 at 12:59:57PM -0400, Paolo Bonzini wrote:
> There is no need to include changes to vcpu->requests into
> the pvclock_gtod_sync_lock critical section.  The changes to
> the shared data structures (in pvclock_update_vm_gtod_copy)
> already occur under the lock.
> 
> Cc: David Woodhouse <dwmw@amazon.co.uk>
> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fe806e894212..0a83eff40b43 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2562,10 +2562,12 @@ static void kvm_gen_update_masterclock(struct kvm *kvm)
>  
>  	kvm_hv_invalidate_tsc_page(kvm);
>  
> -	spin_lock(&ka->pvclock_gtod_sync_lock);
>  	kvm_make_mclock_inprogress_request(kvm);
> +

Might be good to serialize against two kvm_gen_update_masterclock
callers? Otherwise one caller could clear KVM_REQ_MCLOCK_INPROGRESS,
while the other is still at pvclock_update_vm_gtod_copy().

Otherwise, looks good.

