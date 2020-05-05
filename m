Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF3B1C5AF2
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 17:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729489AbgEEPXF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 11:23:05 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:21703 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729261AbgEEPXF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 May 2020 11:23:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588692184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xGX2KJ9vX1ibQ6yn0wPSitM9s4UBDa59NfCH4/27h40=;
        b=SWiXCdsevmMBv7ggT2vQwvZ3wG0p4lk/53i2O1NEtX0+kzMBGHda6YoKZXAzyUVRKr4PbT
        OX5gIxaELgIM8f8eSgLB8frLHAKMSKJBUMNV5me3+SDUlRQWI7b6Qzybs0louhvaThpRu0
        E421NkyjwQYUqiuzQBPP+gcfsD3MC+w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-113-CljtSOCiPW2IFU6WEmFjaw-1; Tue, 05 May 2020 11:23:01 -0400
X-MC-Unique: CljtSOCiPW2IFU6WEmFjaw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 65205800687;
        Tue,  5 May 2020 15:22:59 +0000 (UTC)
Received: from horse.redhat.com (ovpn-116-211.rdu2.redhat.com [10.10.116.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BD8431000327;
        Tue,  5 May 2020 15:22:58 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 2620B222F75; Tue,  5 May 2020 11:22:58 -0400 (EDT)
Date:   Tue, 5 May 2020 11:22:58 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH RFC 3/6] KVM: x86: interrupt based APF page-ready event
 delivery
Message-ID: <20200505152258.GB7155@redhat.com>
References: <20200429093634.1514902-1-vkuznets@redhat.com>
 <20200429093634.1514902-4-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429093634.1514902-4-vkuznets@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 29, 2020 at 11:36:31AM +0200, Vitaly Kuznetsov wrote:
> Concerns were expressed around APF delivery via synthetic #PF exception as
> in some cases such delivery may collide with real page fault. For type 2
> (page ready) notifications we can easily switch to using an interrupt
> instead. Introduce new MSR_KVM_ASYNC_PF2 mechanism.
> 
> One notable difference between the two mechanisms is that interrupt may not
> get handled immediately so whenever we would like to deliver next event
> (regardless of its type) we must be sure the guest had read and cleared
> previous event in the slot.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  Documentation/virt/kvm/msr.rst       | 38 +++++++++++---
>  arch/x86/include/asm/kvm_host.h      |  5 +-
>  arch/x86/include/uapi/asm/kvm_para.h |  6 +++
>  arch/x86/kvm/x86.c                   | 77 ++++++++++++++++++++++++++--
>  4 files changed, 113 insertions(+), 13 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.rst
> index 33892036672d..7433e55f7184 100644
> --- a/Documentation/virt/kvm/msr.rst
> +++ b/Documentation/virt/kvm/msr.rst
> @@ -203,14 +203,21 @@ data:
>  	the hypervisor at the time of asynchronous page fault (APF)
>  	injection to indicate type of asynchronous page fault. Value
>  	of 1 means that the page referred to by the page fault is not
> -	present. Value 2 means that the page is now available. Disabling
> -	interrupt inhibits APFs. Guest must not enable interrupt
> -	before the reason is read, or it may be overwritten by another
> -	APF. Since APF uses the same exception vector as regular page
> -	fault guest must reset the reason to 0 before it does
> -	something that can generate normal page fault.  If during page
> -	fault APF reason is 0 it means that this is regular page
> -	fault.
> +	present. Value 2 means that the page is now available.
> +
> +	Type 1 page (page missing) events are currently always delivered as
> +	synthetic #PF exception. Type 2 (page ready) are either delivered
> +	by #PF exception (when bit 3 of MSR_KVM_ASYNC_PF_EN is clear) or
> +	via an APIC interrupt (when bit 3 set). APIC interrupt delivery is
> +	controlled by MSR_KVM_ASYNC_PF2.
> +
> +	For #PF delivery, disabling interrupt inhibits APFs. Guest must
> +	not enable interrupt before the reason is read, or it may be
> +	overwritten by another APF. Since APF uses the same exception
> +	vector as regular page fault guest must reset the reason to 0
> +	before it does something that can generate normal page fault.
> +	If during pagefault APF reason is 0 it means that this is regular
> +	page fault.

Hi Vitaly,

Again, thinking about how errors will be delivered. Will these be using
same interrupt path? 

As you mentioned that if interrupts are disabled, APFs are blocked. That
means host will fall back to synchronous fault? If yes, that means we
will need a mechanism to report errors in synchronous path too.

Thanks
Vivek

