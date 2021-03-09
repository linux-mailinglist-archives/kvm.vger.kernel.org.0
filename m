Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D509332EA0
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 19:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbhCIS6P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 13:58:15 -0500
Received: from mail.skyhub.de ([5.9.137.197]:33664 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231226AbhCIS5n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 13:57:43 -0500
Received: from zn.tnic (p200300ec2f0d1e00d0c5a693a55ce411.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:1e00:d0c5:a693:a55c:e411])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 69B591EC0472;
        Tue,  9 Mar 2021 19:57:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1615316261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=XORSsete5wDAuj0qz8rNhfE7ztUreCnJFjyEgtuEEKM=;
        b=azPU0PhRnMmVMUehnvtIjy9yn/D1YnQz5gJG/iSyo655LhqKHIlSxCuwCq1j715vh3uovh
        NFWAIPqleg2xfS2vuxq5ytUA3EO2hDYspG0gNDGondbClyxv39iE018r97NVYuPLrjYwrs
        2iCwWZ5mRvfKVA+fNRbyRBboOODaGyY=
Date:   Tue, 9 Mar 2021 19:57:37 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Juergen Gross <jgross@suse.com>
Cc:     xen-devel@lists.xenproject.org, x86@kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
        Deep Shah <sdeep@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>,
        Russell King <linux@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v6 02/12] x86/paravirt: switch time pvops functions to
 use static_call()
Message-ID: <20210309185737.GE699@zn.tnic>
References: <20210309134813.23912-1-jgross@suse.com>
 <20210309134813.23912-3-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210309134813.23912-3-jgross@suse.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 09, 2021 at 02:48:03PM +0100, Juergen Gross wrote:
> @@ -167,6 +168,17 @@ static u64 native_steal_clock(int cpu)
>  	return 0;
>  }
>  
> +DEFINE_STATIC_CALL(pv_steal_clock, native_steal_clock);
> +DEFINE_STATIC_CALL(pv_sched_clock, native_sched_clock);
> +
> +bool paravirt_using_native_sched_clock = true;
> +
> +void paravirt_set_sched_clock(u64 (*func)(void))
> +{
> +	static_call_update(pv_sched_clock, func);
> +	paravirt_using_native_sched_clock = (func == native_sched_clock);
> +}

What's the point of this function if there's a global
paravirt_using_native_sched_clock variable now?

Looking how the bit of information whether native_sched_clock is used,
is needed in tsc.c, it probably would be cleaner if you add a

set_sched_clock_native(void);

or so, to tsc.c instead and call that here and make that long var name a
a shorter and static one in tsc.c instead.

Hmm?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
