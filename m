Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B40E318371
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 03:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbhBKCIH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 21:08:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbhBKCH6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 21:07:58 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58D0AC061756
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 18:07:18 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id e7so2667871pge.0
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 18:07:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uFmtLVGPRsu+efbO+P3fLDbMMK5+lkfvkJ1xncGvBr0=;
        b=AivknfLsO0hCCPPDsGkezVd/53chBqyt/2m+W0Zu1IzTWCwEgzLmqiH46zDo3CaS6n
         +vJwVZpeL6tg7eodNpxuHxJo1wthfiQxdIrEbsXHCWik2NAC2KilSAgEWCvnepGI6VR2
         RehLL8u2uZ7TmIqMNVWvX3S/+NYVYf8P6mw0lWIETbcBCbacoEGcKRHjcLHKFt4cO16Z
         7nrnE6N+mCtCVl6dWUw7QNXpfnKNYqicFc/CluBWLscbJKYNIZnnZEGNStAg4dgtvDaW
         vVQ9KM7u4tXlhZiLCuntTMrNs8zacPKpaXlypMh7IVll0c9pmXK+PhrGG2uU5t5+cBgc
         5Nyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uFmtLVGPRsu+efbO+P3fLDbMMK5+lkfvkJ1xncGvBr0=;
        b=JVYKZVMY7Hxl2kPmWduJqoukXYrsGngRlvlenqXjEox1uImBEt4ZI4DI9qtHiQNTHQ
         dpsL99kYEagvUzFF6zNXIVwG9mEA+PUpWPdL2DYJfOmHDWd/l7ELbDGjV3jL4O98ZsH1
         wWPsT1oq2eRUNj3BJpNSuUJ7AdPjNuNdzhpEW7KjgMa5rlqH46KlGvdNxmWEv0oGjqJa
         H6tB9PYK5w7lcSGrTcgc0YdyV8h4SBQR/Z1Mbq1sEEfVVuwErIohd9Bvhp8/c1lN+nol
         S3bnJLm+mKi5o07L747wGhWbLUfosEt+1FrnwhdPc+/hkV1HXq3tKtFo5C4WAhQiwtGg
         Bt0g==
X-Gm-Message-State: AOAM533bBEjdgmx/U7wm8WeR2+hhf02acrSlpAhkM7Vlrfe3lv3074bM
        FY/RMgRMItTL5Jk2zMk5Z+9gyw==
X-Google-Smtp-Source: ABdhPJx7nxrAcdnXE3p2lQH5pMA0Nuzh2z+IMHmA4tpsNMqK60zvOC9pRVOU16ea/vpcu+wpHDfggQ==
X-Received: by 2002:a62:7bd2:0:b029:1e5:3aed:34c with SMTP id w201-20020a627bd20000b02901e53aed034cmr5967082pfc.71.1613009233955;
        Wed, 10 Feb 2021 18:07:13 -0800 (PST)
Received: from google.com ([2620:15c:f:10:11fc:33d:bf1:4cb8])
        by smtp.gmail.com with ESMTPSA id j22sm3565885pff.57.2021.02.10.18.07.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 18:07:13 -0800 (PST)
Date:   Wed, 10 Feb 2021 18:07:06 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Makarand Sonare <makarandsonare@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, pshier@google.com, jmattson@google.com,
        Ben Gardon <bgardon@google.com>
Subject: Re: [RESEND PATCH ] KVM: VMX: Enable/disable PML when dirty logging
 gets enabled/disabled
Message-ID: <YCSRSiSNErkC6+9R@google.com>
References: <20210210212308.2219465-1-makarandsonare@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210210212308.2219465-1-makarandsonare@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 10, 2021, Makarand Sonare wrote:
> Currently, if enable_pml=1 PML remains enabled for the entire lifetime
> of the VM irrespective of whether dirty logging is enable or disabled.
> When dirty logging is disabled, all the pages of the VM are manually
> marked dirty, so that PML is effectively non-operational. Clearing
> the dirty bits is an expensive operation which can cause severe MMU
> lock contention in a performance sensitive path when dirty logging
> is disabled after a failed or canceled live migration. Also, this
> would break if some other code path clears the dirty bits in which
> case, PML will actually start logging dirty pages even when dirty
> logging is disabled incurring unnecessary vmexits when the PML buffer
> becomes full. In order to avoid this extra overhead, we should
> enable or disable PML in VMCS when dirty logging gets enabled
> or disabled instead of keeping it always enabled.

Breaking this up into a few paragraphs would be helpful.

> Tested:
> 	kvm-unit-tests
> 	dirty_log_test
> 	dirty_log_perf_test

Eh, I get that we like these for internal tracking, but for upstream there's an
assumption that you did your due diligence.  If there's something noteworthy
about your testing (or lack thereof), throw it in the cover letter or in the
part that's not recorded in the final commit.

> Signed-off-by: Makarand Sonare <makarandsonare@google.com>
> Reviewed-by: Ben Gardon <bgardon@google.com>
> ---

...

> @@ -7517,9 +7531,39 @@ static void vmx_slot_enable_log_dirty(struct kvm *kvm,
>  static void vmx_slot_disable_log_dirty(struct kvm *kvm,
>  				       struct kvm_memory_slot *slot)
>  {
> +	/*
> +	 * Check all slots and disable PML if dirty logging
> +	 * is being disabled for the last slot
> +	 *
> +	 */
> +	if (enable_pml &&
> +	    kvm->dirty_logging_enable_count == 0 &&
> +	    kvm->arch.pml_enabled) {
> +		kvm->arch.pml_enabled = false;
> +		kvm_make_all_cpus_request(kvm,
> +			KVM_REQ_UPDATE_VCPU_DIRTY_LOGGING_STATE);
> +	}
> +
>  	kvm_mmu_slot_set_dirty(kvm, slot);

The justification for dynamically toggling PML is that it means KVM can skip
setting all the dirty bits when logging is disabled, but that code is still here.
Is there a follow-up planned to reap the reward?

>  }
