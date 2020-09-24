Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B49327733A
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 15:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728042AbgIXN6e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 09:58:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47129 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727749AbgIXN6b (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Sep 2020 09:58:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600955909;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rt+Besgwpg21SJzUwapMWwzM0VO0ut62JWHcPON2ClI=;
        b=OIMnOSUlLTzniM2ApWMuv3SWl+U8IFrvIuHjpXinmr3IFBf9SDQP/Vi+cN+RxDZY/jAwRI
        OhDTTlNp124bg1GXHMCAIUdr4oppEkm3ESZQwyk0L2F+boEQlntQH85zOr+X268P4t8yct
        IfT2u42rIUAI7UeS7siqf1akz6bIs2c=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-291-Yb057yXLO0O4q56A-XTmbg-1; Thu, 24 Sep 2020 09:58:28 -0400
X-MC-Unique: Yb057yXLO0O4q56A-XTmbg-1
Received: by mail-wm1-f72.google.com with SMTP id 23so889812wmk.8
        for <kvm@vger.kernel.org>; Thu, 24 Sep 2020 06:58:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=rt+Besgwpg21SJzUwapMWwzM0VO0ut62JWHcPON2ClI=;
        b=A/2xsHAO3pNCz7KnfPFQlyPqmpR0I08KfgUe481BwF/TbOV5M+zyJT16oMGYiYugh1
         161vGf9o8c7qUNuxwWmfSeHMBr3wxOV4OViKxV6SYrHKS8IhloQF8GLPWQpoNMxd2RNQ
         5eVr2EbshTB5VYSV2yS3zlxyZEbUxy6PUYfHPg44w9sBT3topV9NhYSzVMKXoGOxF+wx
         rDqijU2QkV0mNyEJ+xn11jvY4U7GfwXOQHWDx364fgg3IYYaTvzxDrHflIzOU4aUKA0Y
         bfSl4ooDMMA2rNq5GcgYZQK9Hq51szVxFstmLE16v+VR9ZksJ9+zZTWPaTT8WsNSh6lq
         PRsg==
X-Gm-Message-State: AOAM530ohho3F/LGBvIZp/9PtWjCA/CyAjw33T5S5Y/khJHe8wTQXMkp
        r7zIFvyYqdQXFfPngJzHIRIEfzX6wkbyQWj9BP2/d3za2yIoSeJppg63P/JUzIjw9EIb3SfNYvy
        oH+TiRoe56DWe
X-Received: by 2002:adf:e601:: with SMTP id p1mr5719516wrm.172.1600955907076;
        Thu, 24 Sep 2020 06:58:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzlaWIRXmBbQZ+n14IysdDc215me66FtlZnphMJYVG2klb0XeMv2+Shm3kpTqpenL8Yr5XoaA==
X-Received: by 2002:adf:e601:: with SMTP id p1mr5719495wrm.172.1600955906896;
        Thu, 24 Sep 2020 06:58:26 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id p3sm3320298wmm.40.2020.09.24.06.58.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2020 06:58:25 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: SVM: Add a dedicated INVD intercept routine
In-Reply-To: <16f36f9a51608758211c54564cd17c8b909372f1.1600892859.git.thomas.lendacky@amd.com>
References: <16f36f9a51608758211c54564cd17c8b909372f1.1600892859.git.thomas.lendacky@amd.com>
Date:   Thu, 24 Sep 2020 15:58:24 +0200
Message-ID: <87zh5fcm4f.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Tom Lendacky <thomas.lendacky@amd.com> writes:

> From: Tom Lendacky <thomas.lendacky@amd.com>
>
> The INVD instruction intercept performs emulation. Emulation can't be done
> on an SEV guest because the guest memory is encrypted.
>
> Provide a dedicated intercept routine for the INVD intercept. Within this
> intercept routine just skip the instruction for an SEV guest, since it is
> emulated as a NOP anyway.
>
> Fixes: 1654efcbc431 ("KVM: SVM: Add KVM_SEV_INIT command")
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  arch/x86/kvm/svm/svm.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index c91acabf18d0..332ec4425d89 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2183,6 +2183,17 @@ static int iret_interception(struct vcpu_svm *svm)
>  	return 1;
>  }
>  
> +static int invd_interception(struct vcpu_svm *svm)
> +{
> +	/*
> +	 * Can't do emulation on an SEV guest and INVD is emulated
> +	 * as a NOP, so just skip the instruction.
> +	 */
> +	return (sev_guest(svm->vcpu.kvm))
> +		? kvm_skip_emulated_instruction(&svm->vcpu)
> +		: kvm_emulate_instruction(&svm->vcpu, 0);
> +}
> +
>  static int invlpg_interception(struct vcpu_svm *svm)
>  {
>  	if (!static_cpu_has(X86_FEATURE_DECODEASSISTS))
> @@ -2774,7 +2785,7 @@ static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
>  	[SVM_EXIT_RDPMC]			= rdpmc_interception,
>  	[SVM_EXIT_CPUID]			= cpuid_interception,
>  	[SVM_EXIT_IRET]                         = iret_interception,
> -	[SVM_EXIT_INVD]                         = emulate_on_interception,
> +	[SVM_EXIT_INVD]                         = invd_interception,
>  	[SVM_EXIT_PAUSE]			= pause_interception,
>  	[SVM_EXIT_HLT]				= halt_interception,
>  	[SVM_EXIT_INVLPG]			= invlpg_interception,

Out of pure curiosity,

does it sill make sense to intercept INVD when we just skip it? Would it
rather make sense to disable INVD intercept for SEV guests completely?

-- 
Vitaly

