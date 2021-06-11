Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F37AF3A48DA
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 20:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbhFKSwL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 14:52:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20741 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229540AbhFKSwK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Jun 2021 14:52:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623437411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=roTUteXHqjpSedCzqHsMThZGFyhCsglA/t3yAGivQNQ=;
        b=LOSf7hvBeknTVriCwe3qCB4rnL7jzJQQfThn1/G0aTPSebTPi5iyaLv6HkyMiitPxDLUyx
        mwpeSe/SRbSEnehTI/XN/kOz08IJjIjOt0Vj8MsjZ0/xcw93DtywjL2a0xu81MhBER6/sG
        p3In19iMgQhoTytrBa7J+So09AsvHs4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-UoBMM9UUMl2TnYOXBU-soQ-1; Fri, 11 Jun 2021 14:50:07 -0400
X-MC-Unique: UoBMM9UUMl2TnYOXBU-soQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 740B3100C661;
        Fri, 11 Jun 2021 18:50:05 +0000 (UTC)
Received: from starship (unknown [10.40.194.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1B5E31001281;
        Fri, 11 Jun 2021 18:50:02 +0000 (UTC)
Message-ID: <f294faba4e5d25aba8773f36170d1309236edd3b.camel@redhat.com>
Subject: Re: [PATCH v3 0/4] KVM: x86: hyper-v: Conditionally allow SynIC
 with APICv/AVIC
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Date:   Fri, 11 Jun 2021 21:50:01 +0300
In-Reply-To: <20210609150911.1471882-1-vkuznets@redhat.com>
References: <20210609150911.1471882-1-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-06-09 at 17:09 +0200, Vitaly Kuznetsov wrote:
> Changes since v2:
> - First two patches got merged, rebase.
> - Use 'enable_apicv = avic = ...' in PATCH1 [Paolo]
> - Collect R-b tags for PATCH2 [Sean, Max]
> - Use hv_apicv_update_work() to get out of SRCU lock [Max]
> - "KVM: x86: Check for pending interrupts when APICv is getting disabled"
>   added.
> 
> Original description:
> 
> APICV_INHIBIT_REASON_HYPERV is currently unconditionally forced upon
> SynIC activation as SynIC's AutoEOI is incompatible with APICv/AVIC. It is,
> however, possible to track whether the feature was actually used by the
> guest and only inhibit APICv/AVIC when needed.
> 
> The series can be tested with the followin hack:
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 9a48f138832d..65a9974f80d9 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -147,6 +147,13 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
>                                            vcpu->arch.ia32_misc_enable_msr &
>                                            MSR_IA32_MISC_ENABLE_MWAIT);
>         }
> +
> +       /* Dirty hack: force HV_DEPRECATING_AEOI_RECOMMENDED. Not to be merged! */
> +       best = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_ENLIGHTMENT_INFO, 0);
> +       if (best) {
> +               best->eax &= ~HV_X64_APIC_ACCESS_RECOMMENDED;
> +               best->eax |= HV_DEPRECATING_AEOI_RECOMMENDED;
> +       }
>  }
>  EXPORT_SYMBOL_GPL(kvm_update_cpuid_runtime);
>  
> Vitaly Kuznetsov (4):
>   KVM: x86: Use common 'enable_apicv' variable for both APICv and AVIC
>   KVM: x86: Drop vendor specific functions for APICv/AVIC enablement
>   KVM: x86: Check for pending interrupts when APICv is getting disabled
>   KVM: x86: hyper-v: Deactivate APICv only when AutoEOI feature is in
>     use
> 
>  arch/x86/include/asm/kvm_host.h |  9 +++++-
>  arch/x86/kvm/hyperv.c           | 51 +++++++++++++++++++++++++++++----
>  arch/x86/kvm/svm/avic.c         | 14 ++++-----
>  arch/x86/kvm/svm/svm.c          | 22 ++++++++------
>  arch/x86/kvm/svm/svm.h          |  2 --
>  arch/x86/kvm/vmx/capabilities.h |  1 -
>  arch/x86/kvm/vmx/vmx.c          |  2 --
>  arch/x86/kvm/x86.c              | 18 ++++++++++--
>  8 files changed, 86 insertions(+), 33 deletions(-)
> 

Hi!

I hate to say it, but at least one of my VMs doesn't boot amymore
with avic=1, after the recent updates. I'll bisect this soon,
but this is likely related to this series.

I will also review this series very soon.

When the VM fails, it hangs on the OVMF screen and I see this
in qemu logs:

KVM: injection failed, MSI lost (Operation not permitted)
KVM: injection failed, MSI lost (Operation not permitted)
KVM: injection failed, MSI lost (Operation not permitted)
KVM: injection failed, MSI lost (Operation not permitted)
KVM: injection failed, MSI lost (Operation not permitted)
KVM: injection failed, MSI lost (Operation not permitted)

Best regards,
	Maxim Levitsky

