Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4602CC439F
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2019 00:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbfJAWQt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 18:16:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59484 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728254AbfJAWQs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 18:16:48 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8B879B2DC4;
        Tue,  1 Oct 2019 22:16:48 +0000 (UTC)
Received: from localhost (ovpn-116-88.gru2.redhat.com [10.97.116.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 161E660619;
        Tue,  1 Oct 2019 22:16:47 +0000 (UTC)
Date:   Tue, 1 Oct 2019 19:16:46 -0300
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Jim Mattson <jmattson@google.com>, konrad.wilk@oracle.com
Subject: Re: [PATCH 2/3] KVM: x86: always expose VIRT_SSBD to guests
Message-ID: <20191001221646.GN4084@habkost.net>
References: <1566376002-17121-1-git-send-email-pbonzini@redhat.com>
 <1566376002-17121-3-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1566376002-17121-3-git-send-email-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Tue, 01 Oct 2019 22:16:48 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 21, 2019 at 10:26:41AM +0200, Paolo Bonzini wrote:
> Even though it is preferrable to use SPEC_CTRL (represented by
> X86_FEATURE_AMD_SSBD) instead of VIRT_SPEC, VIRT_SPEC is always
> supported anyway because otherwise it would be impossible to
> migrate from old to new CPUs.  Make this apparent in the
> result of KVM_GET_SUPPORTED_CPUID as well.
> 
> While at it, reuse X86_FEATURE_* constants for the SVM leaf too.
> 
> However, we need to hide the bit on Intel processors, so move
> the setting to svm_set_supported_cpuid.
> 
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Reported-by: Eduardo Habkost <ehabkost@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
[...]
> @@ -5944,6 +5944,11 @@ static void svm_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
>  		if (nested)
>  			entry->ecx |= (1 << 2); /* Set SVM bit */
>  		break;
> +	case 0x80000008:
> +		if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) ||
> +		     boot_cpu_has(X86_FEATURE_AMD_SSBD))
> +			entry->ebx |= F(VIRT_SSBD);
> +		break;

Wasn't the old code at arch/x86/kvm/cpuid.c:__do_cpuid_func()
supposed to be deleted?

               /*
                * The preference is to use SPEC CTRL MSR instead of the
                * VIRT_SPEC MSR.
                */
               if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) &&
                   !boot_cpu_has(X86_FEATURE_AMD_SSBD))
                       entry->ebx |= F(VIRT_SSBD);


-- 
Eduardo
