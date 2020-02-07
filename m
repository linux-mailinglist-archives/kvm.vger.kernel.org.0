Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0B2155AD3
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 16:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbgBGPiI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 10:38:08 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:50880 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727009AbgBGPiI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 10:38:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581089887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yeuGyx1LYp/9evwWS6l3a4ujN4qYmz2YKlJpVfSsUqE=;
        b=SRK/Sf1OZkLy9D/LubGT9bGv3D+1TATw/Rl35bpGAtWVPOS2PyVI7hrydfXgQJNGwkY28+
        V5ZBFgaHQZVL4vSLXXeckU0uVqphtEG00nmuurL5ohnMdp9BUQqiK0J6TUm/+i+9y/DYRh
        MYIE+7oPzdIQJ7Iiqio0TtIiRidO0M8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-10-hpd1NqM3Pq2UvkAqxDtf-A-1; Fri, 07 Feb 2020 10:38:05 -0500
X-MC-Unique: hpd1NqM3Pq2UvkAqxDtf-A-1
Received: by mail-wm1-f71.google.com with SMTP id a10so888452wme.9
        for <kvm@vger.kernel.org>; Fri, 07 Feb 2020 07:38:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=yeuGyx1LYp/9evwWS6l3a4ujN4qYmz2YKlJpVfSsUqE=;
        b=Jup7AiFaQZXyXRAOuj+XrnT1wOEUn68zTOQNFoMMBAF/h8Z/TRpxiuf4To2Np4kgnh
         DbutUNMwKjsG9Y2j0PT3erHwW+M89M/5VVKZYBnmnQnXg2PGzBvQrWu9+l/uTz+3dRbH
         fpoBMKoshgO7WMMZ1yYke1wifkyV/zOjAqGfM8A1TCJyr1FugGatogT7mpAxw4imPGv/
         UEVakNAY+yhbfTQLki1KAuw0QEC+Z1BgpIGyNMcuJg4CYw/1xmMXojkELbWCel57MJ8S
         C/KHZhRXPnfuB5gvTsKffcbNSB7vIudv3pNsRw7j7n6yaqcH/Z6kQlCvPSAnR4I0evhj
         LV/Q==
X-Gm-Message-State: APjAAAXf0Akoi+onPKWpq3iVj2AhMw9+Za9qfnwp0sm4CHG4tq16+NMT
        mtitl0Y1/+l1idDfO9hwpyytb2fY/tsB9ka2vODiDBqGbegNT2+DiTZjae3ZTahOT8sJsTTxjcd
        Zwy2ptQ5yuDb1
X-Received: by 2002:a05:600c:214f:: with SMTP id v15mr5062944wml.110.1581089884200;
        Fri, 07 Feb 2020 07:38:04 -0800 (PST)
X-Google-Smtp-Source: APXvYqxZ7AtqIkIwnjLWqR7E9sRTStC/xqmTP4CD5tgC2/SP8tFzBECx2Eupzy1OBKXCZC0jlLXNEQ==
X-Received: by 2002:a05:600c:214f:: with SMTP id v15mr5062923wml.110.1581089883895;
        Fri, 07 Feb 2020 07:38:03 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id v8sm3845601wrw.2.2020.02.07.07.38.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2020 07:38:03 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 06/61] KVM: x86: Move CPUID 0xD.1 handling out of the index>0 loop
In-Reply-To: <20200201185218.24473-7-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <20200201185218.24473-7-sean.j.christopherson@intel.com>
Date:   Fri, 07 Feb 2020 16:38:02 +0100
Message-ID: <87h802qug5.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Mov the sub-leaf 1 handling for CPUID 0xD out of the index>0 loop so
> that the loop only handles index>2.  Sub-leafs 2+ have identical
> semantics, whereas sub-leaf 1 is effectively a feature sub-leaf.
>
> Moving sub-leaf 1 out of the loop does duplicate a bit of code, but
> the nent/maxnent code will be consolidated in a future patch, and
> duplicating the clear of ECX/EDX is arguably a good thing as the reasons
> for clearing said registers are completely different.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/cpuid.c | 37 ++++++++++++++++++++++---------------
>  1 file changed, 22 insertions(+), 15 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index e5cf1e0cf84a..fc8540596386 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -653,26 +653,33 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
>  		if (!supported)
>  			break;
>  
> -		for (idx = 1, i = 1; idx < 64; ++idx) {
> +		if (*nent >= maxnent)
> +			goto out;
> +
> +		do_host_cpuid(&entry[1], function, 1);
> +		++*nent;
> +
> +		entry[1].eax &= kvm_cpuid_D_1_eax_x86_features;
> +		cpuid_mask(&entry[1].eax, CPUID_D_1_EAX);
> +		if (entry[1].eax & (F(XSAVES)|F(XSAVEC)))
> +			entry[1].ebx = xstate_required_size(supported, true);
> +		else
> +			entry[1].ebx = 0;
> +		/* Saving XSS controlled state via XSAVES isn't supported. */
> +		entry[1].ecx = 0;
> +		entry[1].edx = 0;
> +
> +		for (idx = 2, i = 2; idx < 64; ++idx) {
>  			u64 mask = ((u64)1 << idx);
> +
>  			if (*nent >= maxnent)
>  				goto out;
>  
>  			do_host_cpuid(&entry[i], function, idx);
> -			if (idx == 1) {
> -				entry[i].eax &= kvm_cpuid_D_1_eax_x86_features;
> -				cpuid_mask(&entry[i].eax, CPUID_D_1_EAX);
> -				entry[i].ebx = 0;
> -				if (entry[i].eax & (F(XSAVES)|F(XSAVEC)))
> -					entry[i].ebx =
> -						xstate_required_size(supported,
> -								     true);
> -			} else {
> -				if (entry[i].eax == 0 || !(supported & mask))
> -					continue;
> -				if (WARN_ON_ONCE(entry[i].ecx & 1))
> -					continue;
> -			}
> +			if (entry[i].eax == 0 || !(supported & mask))
> +				continue;
> +			if (WARN_ON_ONCE(entry[i].ecx & 1))
> +				continue;
>  			entry[i].ecx = 0;
>  			entry[i].edx = 0;
>  			++*nent;

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

