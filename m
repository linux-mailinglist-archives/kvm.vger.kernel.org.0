Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECC14AF8D1
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 18:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238504AbiBIRyl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 12:54:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231628AbiBIRyk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 12:54:40 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B4CFC0613C9
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 09:54:43 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id y18so2850904plb.11
        for <kvm@vger.kernel.org>; Wed, 09 Feb 2022 09:54:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=bn+NqQc+WkBL0eCTGvSDZFvqDNmAbZwHfh1WyoVIqEU=;
        b=gDzGvDYK+kanW1ZjdlzJIIEDIOwcDawCy2/WkAvLy+okpF1wNXDa6i2bZo/mYN0yKl
         M5ofOfdjO8Zlz/FGkjY8tI9264lB59SUqwDecmo037jiNWuD7yV3+HyGvNqwV+YUv1CQ
         IEjipzEqzwTiYLOSJzKFRJrGEfAMC/H3Pg77gMNkdPN9y4qlO5U5nOU/w8vY13caF7WY
         v+VVu0DHZjZCxM9zhvhqhxB7jiU8Z7/e9TwkESuCrdgQGH/vkvA7Kv1bc+dWKYTuctmc
         RV8Ebzs/wibJzv/LKWZwTjEnWPi1DuTxW3OuAT7VLQ1toSc+6gROC0oD/hjzfjjSFKeh
         BD9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=bn+NqQc+WkBL0eCTGvSDZFvqDNmAbZwHfh1WyoVIqEU=;
        b=n2bPuaRFQvVsZIb4SZO5nL/OCUnsqhg2Xf9GBe/rKhpiVK2jcJimstx5yFkUzw5i4O
         bzGvlSXmRnrcuUFzOAcb/PZzoPWqcou+6Jh82Y6/sLswRhf8xHOo8CGSEy5I3ZGJ3CqD
         skLJCCRsDbpAmEN0i0AD3mNGwVgxho/aAEh73ED6k5k/CReqLWzrHQ+6xz8mC03Gu38w
         +x/wDf7vEKiKE6ke9wxGdcJG8l2g54ZStthD/WEjHsaDKocneqn4AQevcgVOeAq7Nfen
         ghSO/86/ow1EZZj0XSOR0UlvCxS+txStpi/y9jQ7g7FZsNMMCosMjN6VB9ALgsaFQvKz
         Na5w==
X-Gm-Message-State: AOAM530DtZ5d8we0GugiRiMr84q4yAQSpX/VOTu1oLdAdfsXjThVqd5Z
        exYSyCpQ4Kz6ftnjEUrwWH0ytQ==
X-Google-Smtp-Source: ABdhPJykGUyrR/mKjFE3vXyI8yjLyylaCf25jTwCP3hhwtnACLmb9FM8ZJUGa2VrGt/lbOLtgaRmnw==
X-Received: by 2002:a17:90b:1e50:: with SMTP id pi16mr4732745pjb.16.1644429282853;
        Wed, 09 Feb 2022 09:54:42 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h6sm20257216pfc.35.2022.02.09.09.54.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 09:54:42 -0800 (PST)
Date:   Wed, 9 Feb 2022 17:54:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        mlevitsk@redhat.com, pbonzini@redhat.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        peterz@infradead.org, hpa@zytor.com, jon.grimm@amd.com,
        wei.huang2@amd.com, terry.bowman@amd.com
Subject: Re: [PATCH v5] KVM: SVM: Allow AVIC support on system w/ physical
 APIC ID > 255
Message-ID: <YgP/3u2UjqzG4C/M@google.com>
References: <20220209152038.12303-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220209152038.12303-1-suravee.suthikulpanit@amd.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 09, 2022, Suravee Suthikulpanit wrote:
> AVIC physical APIC ID table entry contains host physical
> APIC ID field, which is used by the hardware to keep track of where
> each vCPU is running. Originally, this field is 8-bit when AVIC was
> introduced.
>
> The AMD64 Architecture Programmer’s Manual Volume 2 revision 3.38
> specify the physical APIC ID table entry bit [11:8] as reserved
> for older generation of AVIC hardware.

I'd prefer to explicitly call out that older versions of the APM were buggy, it's
easy to overlook the importance of the "revision 3.38" blurb.

> For newer hardware, this field is used to specify host physical APIC ID
> larger than 255.

For all intents and purposed the field was _architecturally_ always 12 bits, the
APM just did a poor job of documenting that the number of bits that are actually
consumed by the CPU is model specific behavior.

> Unfortunately, there is no CPUID bit to help determine if AVIC hardware
> can support 12-bit host physical APIC ID. For older system, since
> the reserved bits [11:8] is documented as should be zero, it should be safe

Please don't hedge, "it should be safe" implies we aren't confident about writing
zeroes, but KVM already writes zeroes to the reserved bits.  The changelog could
instead call out that KVM trusts hardware to (a) not generate bogus x2APIC IDs and
(b) to always support at least 8 bits.

> to increase the host physical ID mask to 12 bits and clear the field
> when programing new physical APIC ID.

E.g.

  Expand KVM's mask for the AVIC host physical ID to the full 12 bits defined
  by the architecture.  The number of bits consumed by hardware is model
  specific, e.g. early CPUs ignored bits 11:8, but there is no way for KVM
  to enumerate the "true" size.  So, KVM must allow using all bits, else it
  risks rejecting completely legal x2APIC IDs on newer CPUs.
 
  This means KVM relies on hardware to not assign x2APIC IDs that exceed the
  "true" width of the field, but presmuably hardware is smart enough to tie
  the width to the max x2APIC ID.  KVM also relies on hardware to support at
  least 8 bits, as the legacy xAPIC ID is writable by software.  But, those
  assumptions are unavoidable due to the lack of any way to enumerate the
  "true" width.

  Note, older versions of the APM state that bits 11:8 are reserved for
  legacy xAPIC, but consumed for x2APIC.  Revision 3.38 corrected this to
  state that bits 11:8 are "should be zero" on older hardware.

> Suggested-by: Sean Christopherson <seanjc@google.com>
> Cc: Maxim Levitsky <mlevitsk@redhat.com>

Cc: stable@vger.kernel.org
Fixes: 44a95dae1d22 ("KVM: x86: Detect and Initialize AVIC support")

> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/kvm/svm/avic.c | 8 ++------
>  arch/x86/kvm/svm/svm.h  | 2 +-
>  2 files changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 90364d02f22a..54ad98731181 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -19,6 +19,7 @@
>  #include <linux/amd-iommu.h>
>  #include <linux/kvm_host.h>
>  
> +#include <asm/apic.h>

Unnecessary new include.

With the above addressed,

Reviewed-by: Sean Christopherson <seanjc@google.com>
