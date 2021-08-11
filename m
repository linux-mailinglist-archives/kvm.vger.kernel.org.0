Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 378D93EA511
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 15:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237594AbhHLNCr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 09:02:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57844 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237588AbhHLNCm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Aug 2021 09:02:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628773335;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=I0o2GOEc9/KMi1SER/cjjSaITjzoyiWUx6kLFBgBu8I=;
        b=JaWlluFw/ppMheN1L5vhBau2U2Nlm97PzkgrdBt49cNVdyHzv9TxyMHCkxc56j52DB2CO+
        CljJHXR81w5Zcoos59oLs0pGS5VVlVJrNwEuFV/koixe1s0n1tjQGQ2mG/3DTlrXIMbplt
        0Sc5Hm635M247zfUexEcLW374KD7TLg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-372-2oAr3Q33OG62MXmosbJwyQ-1; Thu, 12 Aug 2021 09:02:13 -0400
X-MC-Unique: 2oAr3Q33OG62MXmosbJwyQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B252A802C88;
        Thu, 12 Aug 2021 13:01:13 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-4.gru2.redhat.com [10.97.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6F0015D9DE;
        Thu, 12 Aug 2021 13:01:13 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 04B9941752AF; Wed, 11 Aug 2021 15:03:23 -0300 (-03)
Date:   Wed, 11 Aug 2021 15:03:22 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com
Subject: Re: [PATCH 1/2] KVM: KVM-on-hyperv: shorten no-entry section on
 reenlightenment
Message-ID: <20210811180322.GA178399@fuller.cnet>
References: <20210811102356.3406687-1-pbonzini@redhat.com>
 <20210811102356.3406687-2-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811102356.3406687-2-pbonzini@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 11, 2021 at 06:23:55AM -0400, Paolo Bonzini wrote:
> During re-enlightenment, update kvmclock a VM at a time instead of
> raising KVM_REQ_MASTERCLOCK_UPDATE for all VMs.  Because the guests
> can now run after TSC emulation has been disabled, invalidate
> their TSC page so that they refer to the reference time counter
> MSR while the update is in progress.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index bab8eb3e0a47..284afaa1db86 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8111,7 +8111,7 @@ static void kvm_hyperv_tsc_notifier(void)
>  
>  	mutex_lock(&kvm_lock);
>  	list_for_each_entry(kvm, &vm_list, vm_list)
> -		kvm_make_mclock_inprogress_request(kvm);
> +		kvm_hv_invalidate_tsc_page(kvm);
>  
>  	hyperv_stop_tsc_emulation();

        hyperv_stop_tsc_emulation();

        /* TSC frequency always matches when on Hyper-V */
        for_each_present_cpu(cpu)
                per_cpu(cpu_tsc_khz, cpu) = tsc_khz;
        kvm_max_guest_tsc_khz = tsc_khz; 

Is this safe with a running guest? Why?

