Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5F19364E69
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 01:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbhDSXGv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 19:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbhDSXGu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Apr 2021 19:06:50 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC38DC061763
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 16:06:18 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id u14-20020a17090a1f0eb029014e38011b09so14556355pja.5
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 16:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SzoMt02xB+IM5Y+KxKGbqZm8/xbvG0jOKZlggth5PIs=;
        b=E1qS4D++2l4G9fajSw0T62ci6CoUeiHxfmA/tLUezo2EszftDorf8bxVpOJadeTKkC
         FrEHKQ9loblmSFFSgKV6P4VxcG/P0pxMPHQL+4wKmCqTbJPlaozy3FmJSqoAH5lpzMCT
         yNcAofwqhjkqeElco4sKPS9X/GaAARkbA+CdkdP2lR3blD3T58lIGiy2P4HubIlxxFLC
         XnzW/xW+oFq3W3c+tMgnpp81T8VN+/qsUu1g2fwxofMGf7KzihffmvebZzTVCvej1xxc
         XiDtQyYN/nPPSU/rskvbWFbQCEsubrWABKUqawWv/pFYH6Snot1AjeA0caKcp7Tw2TmC
         6O+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SzoMt02xB+IM5Y+KxKGbqZm8/xbvG0jOKZlggth5PIs=;
        b=B7fiVhddp4Ls2Zveh4387TKGYLh1Gws848NSSBWeqZmY/7fAcih9+hMzuKPjn5FO76
         lkLy5orQx5naMj08umDQW0KQJ0dUsazU40BKApEQI0cEhPzCRtrduBSCGzPYXNa9KYh6
         KTcdlOw3J8I4Z4Iubs/rmyx2uGKXOOxBVBIa62PK5FlqZQ1iVFHtLraYIbqRnPpjvItP
         UCZth0vBlrM/E3KD81J5FMUbtuttouAYV1FQ4aR134Cd8FuVPP+3+wD68TCrnVOGlM0Q
         mJ792F0qRcgudlv14uqfF29BBIwDWHN+LN7YpuFOlE7i4Vntt7KziIH2ZENRMmw71Th4
         iwCA==
X-Gm-Message-State: AOAM530E8XPyrnV9CrskJII53Pi1eZqYAKsLdLkInVka6PHdIXGn1h2f
        lOR/+bcQdxApk+P1OeRp+/0idQ==
X-Google-Smtp-Source: ABdhPJy7zVjpEXRzsf8Vl3Aoz0SBUXlmlsLF5aGTLcIMsb5GlCHdHcUyRsujuw7gmdUUbQ7f3SlQ3g==
X-Received: by 2002:a17:902:a9c2:b029:e7:147f:76a1 with SMTP id b2-20020a170902a9c2b02900e7147f76a1mr26246175plr.5.1618873578173;
        Mon, 19 Apr 2021 16:06:18 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id gt22sm449230pjb.7.2021.04.19.16.06.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 16:06:17 -0700 (PDT)
Date:   Mon, 19 Apr 2021 23:06:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: Re: [PATCH v13 10/12] KVM: x86: Introduce new
 KVM_FEATURE_SEV_LIVE_MIGRATION feature & Custom MSR.
Message-ID: <YH4M5guOafToCWd7@google.com>
References: <cover.1618498113.git.ashish.kalra@amd.com>
 <3232806199b2f4b307d28f6fd4f756d487b4e482.1618498113.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3232806199b2f4b307d28f6fd4f756d487b4e482.1618498113.git.ashish.kalra@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 15, 2021, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Add new KVM_FEATURE_SEV_LIVE_MIGRATION feature for guest to check
> for host-side support for SEV live migration. Also add a new custom
> MSR_KVM_SEV_LIVE_MIGRATION for guest to enable the SEV live migration
> feature.
> 
> MSR is handled by userspace using MSR filters.
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Reviewed-by: Steve Rutherford <srutherford@google.com>
> ---
>  Documentation/virt/kvm/cpuid.rst     |  5 +++++
>  Documentation/virt/kvm/msr.rst       | 12 ++++++++++++
>  arch/x86/include/uapi/asm/kvm_para.h |  4 ++++
>  arch/x86/kvm/cpuid.c                 |  3 ++-
>  4 files changed, 23 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
> index cf62162d4be2..0bdb6cdb12d3 100644
> --- a/Documentation/virt/kvm/cpuid.rst
> +++ b/Documentation/virt/kvm/cpuid.rst
> @@ -96,6 +96,11 @@ KVM_FEATURE_MSI_EXT_DEST_ID        15          guest checks this feature bit
>                                                 before using extended destination
>                                                 ID bits in MSI address bits 11-5.
>  
> +KVM_FEATURE_SEV_LIVE_MIGRATION     16          guest checks this feature bit before
> +                                               using the page encryption state
> +                                               hypercall to notify the page state
> +                                               change

Hrm, I think there are two separate things being intertwined: the hypercall to
communicate private/shared pages, and the MSR to control live migration.  More
thoughts below.

>  KVM_FEATURE_CLOCKSOURCE_STABLE_BIT 24          host will warn if no guest-side
>                                                 per-cpu warps are expected in
>                                                 kvmclock
> diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.rst
> index e37a14c323d2..020245d16087 100644
> --- a/Documentation/virt/kvm/msr.rst
> +++ b/Documentation/virt/kvm/msr.rst
> @@ -376,3 +376,15 @@ data:
>  	write '1' to bit 0 of the MSR, this causes the host to re-scan its queue
>  	and check if there are more notifications pending. The MSR is available
>  	if KVM_FEATURE_ASYNC_PF_INT is present in CPUID.
> +
> +MSR_KVM_SEV_LIVE_MIGRATION:
> +        0x4b564d08
> +
> +	Control SEV Live Migration features.
> +
> +data:
> +        Bit 0 enables (1) or disables (0) host-side SEV Live Migration feature,
> +        in other words, this is guest->host communication that it's properly
> +        handling the shared pages list.
> +
> +        All other bits are reserved.
> diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
> index 950afebfba88..f6bfa138874f 100644
> --- a/arch/x86/include/uapi/asm/kvm_para.h
> +++ b/arch/x86/include/uapi/asm/kvm_para.h
> @@ -33,6 +33,7 @@
>  #define KVM_FEATURE_PV_SCHED_YIELD	13
>  #define KVM_FEATURE_ASYNC_PF_INT	14
>  #define KVM_FEATURE_MSI_EXT_DEST_ID	15
> +#define KVM_FEATURE_SEV_LIVE_MIGRATION	16
>  
>  #define KVM_HINTS_REALTIME      0
>  
> @@ -54,6 +55,7 @@
>  #define MSR_KVM_POLL_CONTROL	0x4b564d05
>  #define MSR_KVM_ASYNC_PF_INT	0x4b564d06
>  #define MSR_KVM_ASYNC_PF_ACK	0x4b564d07
> +#define MSR_KVM_SEV_LIVE_MIGRATION	0x4b564d08
>  
>  struct kvm_steal_time {
>  	__u64 steal;
> @@ -136,4 +138,6 @@ struct kvm_vcpu_pv_apf_data {
>  #define KVM_PV_EOI_ENABLED KVM_PV_EOI_MASK
>  #define KVM_PV_EOI_DISABLED 0x0
>  
> +#define KVM_SEV_LIVE_MIGRATION_ENABLED BIT_ULL(0)

Even though the intent is to "force" userspace to intercept the MSR, I think KVM
should at least emulate the legal bits as a nop.  Deferring completely to
userspace is rather bizarre as there's not really anything to justify KVM
getting involved.  It would also force userspace to filter the MSR just to
support the hypercall.

Somewhat of a nit, but I think we should do something like s/ENABLED/READY,
or maybe s/ENABLED/SAFE, in the bit name so that the semantics are more along
the lines of an announcement from the guest, as opposed to a command.  Treating
the bit as a hint/announcement makes it easier to bundle the hypercall and the
MSR together under a single feature, e.g. it's slightly more obvious that
userspace can ignore the MSR if it knows its use case doesn't need migration or
that it can't migrate its guest at will.

I also think we should drop the "SEV" part, especially since it sounds like the
feature flag also enumerates that the hypercall is available.

E.g. for the WRMSR side

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index eca63625ae..10f90f8491 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3229,6 +3229,13 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)

                vcpu->arch.msr_kvm_poll_control = data;
                break;
+       case MSR_KVM_LIVE_MIGRATION_CONTROL:
+               if (!guest_pv_has(vcpu, KVM_FEATURE_LIVE_MIGRATION_CONTROL))
+                       return 1;
+
+               if (data & ~KVM_LIVE_MIGRATION_READY)
+                       return 1;
+               break;

        case MSR_IA32_MCG_CTL:
        case MSR_IA32_MCG_STATUS:

