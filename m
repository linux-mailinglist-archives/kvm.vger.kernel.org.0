Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B18358F1CA
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2019 19:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731971AbfHORO6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 13:14:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38572 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731965AbfHORO4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 13:14:56 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7306446672;
        Thu, 15 Aug 2019 17:14:56 +0000 (UTC)
Received: from localhost (ovpn-116-32.gru2.redhat.com [10.97.116.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 02AB6841E7;
        Thu, 15 Aug 2019 17:14:55 +0000 (UTC)
Date:   Thu, 15 Aug 2019 14:14:54 -0300
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 2/2] KVM: x86: always expose VIRT_SSBD to guests
Message-ID: <20190815171454.GV3908@habkost.net>
References: <1565854883-27019-1-git-send-email-pbonzini@redhat.com>
 <1565854883-27019-3-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1565854883-27019-3-git-send-email-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Thu, 15 Aug 2019 17:14:56 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 15, 2019 at 09:41:23AM +0200, Paolo Bonzini wrote:
> Even though it is preferrable to use SPEC_CTRL (represented by
> X86_FEATURE_AMD_SSBD) instead of VIRT_SPEC, VIRT_SPEC is always
> supported anyway because otherwise it would be impossible to
> migrate from old to new CPUs.  Make this apparent in the
> result of KVM_GET_SUPPORTED_CPUID as well.
> 
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Reported-by: Eduardo Habkost <ehabkost@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/cpuid.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 145ec050d45d..5865bc73bbb5 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -747,11 +747,13 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
>  		entry->ebx &= kvm_cpuid_8000_0008_ebx_x86_features;
>  		cpuid_mask(&entry->ebx, CPUID_8000_0008_EBX);
>  		/*
> -		 * The preference is to use SPEC CTRL MSR instead of the
> -		 * VIRT_SPEC MSR.
> +		 * VIRT_SPEC is only implemented for AMD processors,
> +		 * but the host could set AMD_SSBD if it wanted even
> +		 * for Intel processors.
>  		 */
> -		if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) &&
> -		    !boot_cpu_has(X86_FEATURE_AMD_SSBD))
> +		if ((boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) ||
> +		     boot_cpu_has(X86_FEATURE_AMD_SSBD)) &&
> +		    boot_cpu_has(X86_FEATURE_SVM))

Would it be desirable to move this code to
svm_set_supported_cpuid(), or is there a reason for keeping this
in cpuid.c?


>  			entry->ebx |= F(VIRT_SSBD);
>  		break;
>  	}
> -- 
> 1.8.3.1
> 

-- 
Eduardo
