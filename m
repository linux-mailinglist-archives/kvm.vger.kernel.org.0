Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 810F11E2A06
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 20:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729163AbgEZS1w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 14:27:52 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:55077 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728223AbgEZS1v (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 May 2020 14:27:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590517670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fTfuSLK8l7yf827i5HRrDisUdVS6BhwSrBx7ZY2jZJ0=;
        b=EvEDyo0IAKoSIJT7pJYjC5f9hr95GX/RZTfeJRmY24XwCguItKkFEWT/d4IdrXKJTjXYRR
        DxXc7G1TuVcDcTdk54v3IcGhP6wKuWQcxY5jCj9I8wMm/TSVbS6xmzC0eYR+vi2YGQYV8F
        kO6Lw2ZNQYyw0Fo/tnZSFHyTXkdC0M4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-503-ltoyGel0O1WcgDHsCfcWLA-1; Tue, 26 May 2020 14:27:48 -0400
X-MC-Unique: ltoyGel0O1WcgDHsCfcWLA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CC4B1107ACF2;
        Tue, 26 May 2020 18:27:46 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-102.rdu2.redhat.com [10.10.115.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 365111CA;
        Tue, 26 May 2020 18:27:46 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id A91E322036E; Tue, 26 May 2020 14:27:45 -0400 (EDT)
Date:   Tue, 26 May 2020 14:27:45 -0400
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
Subject: Re: [PATCH v2 02/10] KVM: x86: extend struct kvm_vcpu_pv_apf_data
 with token info
Message-ID: <20200526182745.GA114395@redhat.com>
References: <20200525144125.143875-1-vkuznets@redhat.com>
 <20200525144125.143875-3-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200525144125.143875-3-vkuznets@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 25, 2020 at 04:41:17PM +0200, Vitaly Kuznetsov wrote:
> 

[..]
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 0a6b35353fc7..c195f63c1086 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -767,7 +767,7 @@ struct kvm_vcpu_arch {
>  		u64 msr_val;
>  		u32 id;
>  		bool send_user_only;
> -		u32 host_apf_reason;
> +		u32 host_apf_flags;

Hi Vitaly,

What is host_apf_reason used for. Looks like it is somehow used in
context of nested guests. I hope by now you have been able to figure
it out.

Is it somehow the case of that L2 guest takes a page fault exit
and then L0 injects this event in L1 using exception. I have been
trying to read this code but can't wrap my head around it.

I am still concerned about the case of nested kvm. We have discussed
apf mechanism but never touched nested part of it. Given we are
touching code in nested kvm part, want to make sure it is not broken
in new design.

Thanks
Vivek

