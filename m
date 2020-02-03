Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADE615064A
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 13:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727509AbgBCMmX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 07:42:23 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:27206 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727188AbgBCMmX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 Feb 2020 07:42:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580733742;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TYmvaWdfWIY2CO2m0YyjXtoTDOMMJedRMMAbCyAuU5U=;
        b=Bf2k9Iu0CICu5AAYKJ9DyPpablKXQu/9OvhfQ7qJi4BpsMQfy6/VMZ9P7nEweUX4k0C3Fy
        UuKC3q6JsruQR+OGnSBYTUE4Z05sN3mi1TVZ8Bne/BgQ91MOQWcWKQGHC+7UeMhGL7z7Of
        tdWa0pgw5Q3er9dY5xKi6bnICpiIcoA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-177-A0DG2HksPamgib_XAem8eA-1; Mon, 03 Feb 2020 07:42:17 -0500
X-MC-Unique: A0DG2HksPamgib_XAem8eA-1
Received: by mail-wm1-f70.google.com with SMTP id p5so4751691wmc.4
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2020 04:42:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=TYmvaWdfWIY2CO2m0YyjXtoTDOMMJedRMMAbCyAuU5U=;
        b=iRXWyLtUotdUpO106HpcWUAAeGY+cXXWl781jP8r6MvTtAsCd0GfgPqnwKOIg8gco7
         GdPd4C0pEm1FnOkHHrtdaQnpkRsAgfS9A8NDD3nRv3K3sclHKfoMOHYkbN0a63Hw+6qb
         DRxx9SXA/IkvmdkEBdv94BoJaIHdtNwGrwNrn39wW0etLWWwV9LfEL4V3Lo+nOXySRT3
         BhuPKSvaqm8nMg3F/Bp85YeGzUf4P3f44ASP5W+VKEaZaFP9rwgE28mxevCchRilCBYm
         3WIYc2elR+b0Hdvak3bLNGQgTHelJDHb2ZDGLRyrSDs21toBAIbESmEvNBFfHR+lymU/
         QAjQ==
X-Gm-Message-State: APjAAAXSclPVQSUfxbeQUD13heulQ06EKUDf0lrti6d9f7bPs7EdH/Ts
        giOTfHlHbuXKDVIpDmNZ1r1dQczjn3mB9CqYJX1hBsqhoVR+sgHGm0fc8M7Sk6fb//bQppcHcPv
        65q/dGN0oYk9I
X-Received: by 2002:a7b:c0d9:: with SMTP id s25mr4276781wmh.98.1580733736463;
        Mon, 03 Feb 2020 04:42:16 -0800 (PST)
X-Google-Smtp-Source: APXvYqwdm4k8EedzgClLA+MN0ll3YAa2bCfhF2w/sjiLgqXACvp+q6FVH7riajO76FmIcSp3p77YNw==
X-Received: by 2002:a7b:c0d9:: with SMTP id s25mr4276733wmh.98.1580733736187;
        Mon, 03 Feb 2020 04:42:16 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id n3sm23352349wmc.27.2020.02.03.04.42.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 04:42:15 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] x86/kvm: do not setup pv tlb flush when not paravirtualized
In-Reply-To: <20200203101514.GG40679@calabresa>
References: <20200131155655.49812-1-cascardo@canonical.com> <87wo94ng9d.fsf@vitty.brq.redhat.com> <20200203101514.GG40679@calabresa>
Date:   Mon, 03 Feb 2020 13:42:14 +0100
Message-ID: <87r1zbona1.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thadeu Lima de Souza Cascardo <cascardo@canonical.com> writes:

> On Mon, Feb 03, 2020 at 10:59:10AM +0100, Vitaly Kuznetsov wrote:
>> Thadeu Lima de Souza Cascardo <cascardo@canonical.com> writes:
>> 
>> > kvm_setup_pv_tlb_flush will waste memory and print a misguiding message
>> > when KVM paravirtualization is not available.
>> >
>> > Intel SDM says that the when cpuid is used with EAX higher than the
>> > maximum supported value for basic of extended function, the data for the
>> > highest supported basic function will be returned.
>> >
>> > So, in some systems, kvm_arch_para_features will return bogus data,
>> > causing kvm_setup_pv_tlb_flush to detect support for pv tlb flush.
>> >
>> > Testing for kvm_para_available will work as it checks for the hypervisor
>> > signature.
>> >
>> > Besides, when the "nopv" command line parameter is used, it should not
>> > continue as well, as kvm_guest_init will no be called in that case.
>> >
>> > Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
>> > ---
>> >  arch/x86/kernel/kvm.c | 3 +++
>> >  1 file changed, 3 insertions(+)
>> >
>> > diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
>> > index 81045aabb6f4..d817f255aed8 100644
>> > --- a/arch/x86/kernel/kvm.c
>> > +++ b/arch/x86/kernel/kvm.c
>> > @@ -736,6 +736,9 @@ static __init int kvm_setup_pv_tlb_flush(void)
>> >  {
>> >  	int cpu;
>> >  
>> > +	if (!kvm_para_available() || nopv)
>> > +		return 0;
>> > +
>> >  	if (kvm_para_has_feature(KVM_FEATURE_PV_TLB_FLUSH) &&
>> >  	    !kvm_para_has_hint(KVM_HINTS_REALTIME) &&
>> >  	    kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
>> 
>> The patch will fix the immediate issue, but why kvm_setup_pv_tlb_flush()
>> is just an arch_initcall() which will be executed regardless of the fact
>> if we are running on KVM or not?
>> 
>> In Hyper-V we setup PV TLB flush from ms_hyperv_init_platform() -- which
>> only happens if Hyper-V platform was detected. Why don't we do it from
>> kvm_init_platform() in KVM?
>> 
>> -- 
>> Vitaly
>> 
>
> Because we can't call the allocator that early.
>
> Also, see the thread where this was "decided", the v6 of the original patch:
>
> https://lore.kernel.org/kvm/20171129162118.GA10661@flask/

Ok, I see, it's basically about what we prioritize: shorter boot time vs
smaller memory footprint. I'd personally vote for the former but the
opposite opinion is equally valid. Let's preserve the status quo.

-- 
Vitaly

