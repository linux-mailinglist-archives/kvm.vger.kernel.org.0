Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33621377E35
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 10:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbhEJIa6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 04:30:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34505 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230216AbhEJIa5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 04:30:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620635393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7EQ4vZLkNzKipHnk+EIka5PGObJDdPPscSMPWhaXeCg=;
        b=PNZs8FA8MiMTWqqCMm1FMxL2l9rp+kIB4aGeutx1sd/tNcO/FoEiQFqEXMVITi7gmbljaP
        sW1OuxfLZb280r4Hs50jb5bwmhdAzX9i9Oqq8GUjpHxDMHdA8iPDl5JP/wr09Abft0Lbng
        Ss7YBoz2GACVN8HrzipiAdDTQP3eaKk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-456-GzwQDWOwNwG8cZrE_7tCcA-1; Mon, 10 May 2021 04:29:51 -0400
X-MC-Unique: GzwQDWOwNwG8cZrE_7tCcA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 705BD818400;
        Mon, 10 May 2021 08:29:50 +0000 (UTC)
Received: from starship (unknown [10.40.194.86])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 507A310246F1;
        Mon, 10 May 2021 08:29:47 +0000 (UTC)
Message-ID: <4616405e483e3de185129a478a0ee576827bb6cf.camel@redhat.com>
Subject: Re: [PATCH 15/15] KVM: x86: Hide RDTSCP and RDPID if MSR_TSC_AUX
 probing failed
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
Date:   Mon, 10 May 2021 11:29:45 +0300
In-Reply-To: <20210504171734.1434054-16-seanjc@google.com>
References: <20210504171734.1434054-1-seanjc@google.com>
         <20210504171734.1434054-16-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-05-04 at 10:17 -0700, Sean Christopherson wrote:
> If probing MSR_TSC_AUX failed, hide RDTSCP and RDPID, and WARN if either
> feature was reported as supported.  In theory, such a scenario should
> never happen as both Intel and AMD state that MSR_TSC_AUX is available if
> RDTSCP or RDPID is supported.  But, KVM injects #GP on MSR_TSC_AUX
> accesses if probing failed, faults on WRMSR(MSR_TSC_AUX) may be fatal to
> the guest (because they happen during early CPU bringup), and KVM itself
> has effectively misreported RDPID support in the past.
> 
> Note, this also has the happy side effect of omitting MSR_TSC_AUX from
> the list of MSRs that are exposed to userspace if probing the MSR fails.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index c96f79c9fff2..bf0f74ce4974 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -567,6 +567,21 @@ void kvm_set_cpu_caps(void)
>  		F(ACE2) | F(ACE2_EN) | F(PHE) | F(PHE_EN) |
>  		F(PMM) | F(PMM_EN)
>  	);
> +
> +	/*
> +	 * Hide RDTSCP and RDPID if either feature is reported as supported but
> +	 * probing MSR_TSC_AUX failed.  This is purely a sanity check and
> +	 * should never happen, but the guest will likely crash if RDTSCP or
> +	 * RDPID is misreported, and KVM has botched MSR_TSC_AUX emulation in
> +	 * the past, e.g. the sanity check may fire if this instance of KVM is
> +	 * running as L1 on top of an older, broken KVM.
> +	 */
> +	if (WARN_ON((kvm_cpu_cap_has(X86_FEATURE_RDTSCP) ||
> +		     kvm_cpu_cap_has(X86_FEATURE_RDPID)) &&
> +		     !kvm_is_supported_user_return_msr(MSR_TSC_AUX))) {
> +		kvm_cpu_cap_clear(X86_FEATURE_RDTSCP);
> +		kvm_cpu_cap_clear(X86_FEATURE_RDPID);
> +	}
>  }
>  EXPORT_SYMBOL_GPL(kvm_set_cpu_caps);
>  
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

