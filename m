Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB3A326A31
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 23:48:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbhBZWrt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Feb 2021 17:47:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbhBZWrp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Feb 2021 17:47:45 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B8EC061574
        for <kvm@vger.kernel.org>; Fri, 26 Feb 2021 14:47:05 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id a4so7060748pgc.11
        for <kvm@vger.kernel.org>; Fri, 26 Feb 2021 14:47:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=FWfKwt6kX8wvyCzXU6S1wzKG11gxPLhSQUXPm/zfyRo=;
        b=BFoe7wL57k1glMCiP+TaTWRj6VJ5zCjEDlz8+lad9Fzz+M+mlAFI6XqQD6dF1v9HlB
         ZOfON2h9r/7U4alRF/PMshKlZ+ONIj+3+l9DUuT2dl/2+r+owhnr00JhXlqTR7q2mKeu
         ixt7ZQ50544Lgn3fQfJJsekG3jMOhzTHEAKPCN0L0iyDauUgjvQDcn+8/TKnXJtK1rkt
         iHs9d8cDsU3YyRxnJVhEFn2qFjsOVO0813bQXS2YeUDtPGT7Je6Quz8ZBee4nbdyIjDF
         A5Gsq92iZpx4cAspVOBYQKN4x1glYF9VrpoLum8/VKGhsW+5kzXLK9Sa6Zzihj9c6ine
         6mqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=FWfKwt6kX8wvyCzXU6S1wzKG11gxPLhSQUXPm/zfyRo=;
        b=VtpGg6yPdnq0EWZO8wtV5AbyYGf4Sw43E2rSYp8jlpRqLz+HshY4ea+zFkBS/NYesh
         kuR0zD7MOURPQxhs9rUNdeDUg07rEmKfWciLXi738Y/T3SPBAUb700QNgJYI10VHSx0f
         s/lcsklPXLid+25R//GxbdEiRzrNUOoXSl7CLPvSEPN9xd5vYkWRVmKn+xMyNvKr949t
         NTmcjK4ek7LQji6I/nqbsi+Slp0iy0Ro5f4/rKtig7lnXKpiJ++HBqHEkMxW0iZ1VFyv
         k2xu61BpkAN8ZnBclkqfyGxizTI18JmrIbAZs6T3nW8xJUVIp+LmPXlNzcz5oNfs1zpY
         irmQ==
X-Gm-Message-State: AOAM530/SBWUfcL9hmpnrLEQ25MqD0bypQ8HPGVZsVgwPEyNEGH85Ct7
        Oo2D66sxN5+eyA2uka5h+14ebA==
X-Google-Smtp-Source: ABdhPJysX1Gy5qQjxhZxEfRalgZ8Np1GGaCY1UR8vYL+V5Gxo7+xl49YaHAqcCOn+yAnbwJnn5Jp0Q==
X-Received: by 2002:a65:62c7:: with SMTP id m7mr4776831pgv.50.1614379624821;
        Fri, 26 Feb 2021 14:47:04 -0800 (PST)
Received: from google.com ([2620:15c:f:10:e190:bf4c:e355:6c55])
        by smtp.gmail.com with ESMTPSA id y72sm10658312pfg.126.2021.02.26.14.47.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 14:47:04 -0800 (PST)
Date:   Fri, 26 Feb 2021 14:46:57 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     "Xu, Like" <like.xu@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: vmx/pmu: Fix dummy check if lbr_desc->event is
 created
Message-ID: <YDl6YaJJqaApUALx@google.com>
References: <20210223013958.1280444-1-like.xu@linux.intel.com>
 <YDU4II6Jt+E5nFmG@google.com>
 <ca26c4e9-207a-2882-649d-fe82604f68f9@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ca26c4e9-207a-2882-649d-fe82604f68f9@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 24, 2021, Xu, Like wrote:
> On 2021/2/24 1:15, Sean Christopherson wrote:
> > On Tue, Feb 23, 2021, Like Xu wrote:
> > > If lbr_desc->event is successfully created, the intel_pmu_create_
> > > guest_lbr_event() will return 0, otherwise it will return -ENOENT,
> > > and then jump to LBR msrs dummy handling.
> > > 
> > > Fixes: 1b5ac3226a1a ("KVM: vmx/pmu: Pass-through LBR msrs when the guest LBR event is ACTIVE")
> > > Signed-off-by: Like Xu <like.xu@linux.intel.com>
> > > ---
> > >   arch/x86/kvm/vmx/pmu_intel.c | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> > > index d1df618cb7de..d6a5fe19ff09 100644
> > > --- a/arch/x86/kvm/vmx/pmu_intel.c
> > > +++ b/arch/x86/kvm/vmx/pmu_intel.c
> > > @@ -320,7 +320,7 @@ static bool intel_pmu_handle_lbr_msrs_access(struct kvm_vcpu *vcpu,
> > >   	if (!intel_pmu_is_valid_lbr_msr(vcpu, index))
> > >   		return false;
> > > -	if (!lbr_desc->event && !intel_pmu_create_guest_lbr_event(vcpu))
> > > +	if (!lbr_desc->event && intel_pmu_create_guest_lbr_event(vcpu))
> > >   		goto dummy;

...
 
> > AFAICT, event contention would lead to a #GP crash in the host due to
> > lbr_desc->event being dereferenced, no?
> 
> a #GP crash in the host ？Can you share more understanding about it ?

The original code is will dereference a null lbr_desc->event if
intel_pmu_create_guest_lbr_event() fails.

	if (!lbr_desc->event && intel_pmu_create_guest_lbr_event(vcpu))  <- falls through
		goto dummy;

	/*
	 * Disable irq to ensure the LBR feature doesn't get reclaimed by the
	 * host at the time the value is read from the msr, and this avoids the
	 * host LBR value to be leaked to the guest. If LBR has been reclaimed,
	 * return 0 on guest reads.
	 */
	local_irq_disable();
	if (lbr_desc->event->state == PERF_EVENT_STATE_ACTIVE) { <--------- kaboom
		if (read)
			rdmsrl(index, msr_info->data);
		else
			wrmsrl(index, msr_info->data);
		__set_bit(INTEL_PMC_IDX_FIXED_VLBR, vcpu_to_pmu(vcpu)->pmc_in_use);
		local_irq_enable();
		return true;
	}
