Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C35A7ADE09
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 19:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbjIYRwT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 13:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbjIYRwR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 13:52:17 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 746E89B
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 10:52:11 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-59f8439a250so33420827b3.3
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 10:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695664330; x=1696269130; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xwtabOILnRbm1S1bansxkRjSqy6X1y7X1zW3DO+l2dQ=;
        b=uKDRSiXW9WTM2I+lNJmv/zcE8ux7VzL0hmLgGO2ZpaWwWxj/jR+gkulY+lG7fMuuPD
         Led3euO9hHRvjF06YsdGr+uB0G55ZIn0E5CxdYxuqmOw49e41wboHSGUaps3GT/qJpzo
         S598GOj07VhBFm4TuM9ZLtIATvpwitZVOcWnng/onr9PUZZGJIIEWH1BEVMPfr3tdqxK
         wDOxukCspQjPTPXp3rRRlU/uHD+o/UidVjsC60Ykns7srxb0VqRzB7yDv57ABW6xKxZp
         t+LGUcl6+XDy+lsgzZnd19N1zCmyLGfA2XDFVl3FQbsb8FPJQNH6uGCTK6Fyl9xvlwFa
         7drw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695664330; x=1696269130;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xwtabOILnRbm1S1bansxkRjSqy6X1y7X1zW3DO+l2dQ=;
        b=jRKfNN/gg9XR0fdtmA97X4ElkPLSTsG18taaShhSZ1yfBac7wgfPz/ool6ngTW0y3i
         I+FWbIwn3ZiD/y0RdPmXKbz3aQxQjvIcYSI9o32B0PlMFc/1mNDxBmSO5hPsGr4xIL2v
         eAJyEqwOR1kQOssMCN8cPkyzDtqrw5GHt31g+xzq3BixMNkyOV6+J/bW/Vrc2e8wbgWm
         YJw9jR8dfyCOes2YHUpzfzHXVpKkNs/AzXY6eHSxKUf3wGazOq8UDa5MXTouqk8Fg9w5
         ZDCDXJtzK0nqYM6rM8GTFYn7g9epKox2RhQs2tPjFnpBw1sIX3HZHdo6Iuhq4372YKXT
         +iCQ==
X-Gm-Message-State: AOJu0YymzadiANPa7HO2v9HxG7WN/YhG+wuwfvOJmByyfNOTlfZ9rAuZ
        uKlmgNz0SSLVIMEpIezoi2p3PmID43U=
X-Google-Smtp-Source: AGHT+IGMCxoYYjlsby/3TkrnKyNMbXZVi8P2B3hrc+nEK9RGzqOsug/VxBijCqfw+gGQ7bIh7lZuWGjl/Rc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:d003:0:b0:59b:ccba:1249 with SMTP id
 v3-20020a81d003000000b0059bccba1249mr100541ywi.10.1695664330689; Mon, 25 Sep
 2023 10:52:10 -0700 (PDT)
Date:   Mon, 25 Sep 2023 10:52:09 -0700
In-Reply-To: <20230925173448.3518223-3-mizhang@google.com>
Mime-Version: 1.0
References: <20230925173448.3518223-1-mizhang@google.com> <20230925173448.3518223-3-mizhang@google.com>
Message-ID: <ZRHIyUEUeXnw7hii@google.com>
Subject: Re: [PATCH 2/2] KVM: x86: Mask LVTPC when handling a PMI
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Dapeng Mi <dapeng1.mi@linux.intel.com>,
        Like Xu <likexu@tencent.com>, Roman Kagan <rkagan@amazon.de>,
        Kan Liang <kan.liang@intel.com>,
        Dapeng1 Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 25, 2023, Mingwei Zhang wrote:
> From: Jim Mattson <jmattson@google.com>
> 
> Per the SDM, "When the local APIC handles a performance-monitoring
> counters interrupt, it automatically sets the mask flag in the LVT
> performance counter register."
> 
> Add this behavior to KVM's local APIC emulation, to reduce the
> incidence of "dazed and confused" spurious NMI warnings in Linux
> guests (at least, those that use a PMI handler with "late_ack").
> 
> Fixes: 23930f9521c9 ("KVM: x86: Enable NMI Watchdog via in-kernel PIT source")

This Fixes is wrong.  Prior to commit f5132b01386b ("KVM: Expose a version 2
architectural PMU to a guests"), KVM didn't ever deliver interrupts via the LVTPC
entry.  E.g. prior to that commit, the only reference to APIC_LVTPC is in
kvm_lapic_reg_write:

  arch/x86/kvm $ git grep APIC_LVTPC f5132b01386b^
  f5132b01386b^:lapic.c:  case APIC_LVTPC:

Commit 23930f9521c9 definitely set the PMU support up to fail, but the bug would
never have existed if kvm_deliver_pmi() had been written as:

void kvm_deliver_pmi(struct kvm_vcpu *vcpu)
{
	struct kvm_lapic *apic = vcpu->arch.apic;

	if (apic && kvm_apic_local_deliver(apic, APIC_LVTPC))
		kvm_lapic_set_reg(apic, APIC_LVTPC,
				  kvm_lapic_get_reg(apic, LVTPC) | APIC_LVT_MASKED);
}

And this needs an explicit Cc: to stable because KVM opts out of AUTOSEL.

So

  Fixes: f5132b01386b ("KVM: Expose a version 2 architectural PMU to a guests")
  Cc: stable@vger.kernel.org

> Signed-off-by: Jim Mattson <jmattson@google.com>
> Tested-by: Mingwei Zhang <mizhang@google.com>

When posting patches on behalf of others, you need to provide your SoB.

> ---
>  arch/x86/kvm/lapic.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 113ca9661ab2..1f3d56a1f45f 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2729,13 +2729,17 @@ int kvm_apic_local_deliver(struct kvm_lapic *apic, int lvt_type)
>  {
>  	u32 reg = kvm_lapic_get_reg(apic, lvt_type);
>  	int vector, mode, trig_mode;
> +	int r;
>  
>  	if (kvm_apic_hw_enabled(apic) && !(reg & APIC_LVT_MASKED)) {
>  		vector = reg & APIC_VECTOR_MASK;
>  		mode = reg & APIC_MODE_MASK;
>  		trig_mode = reg & APIC_LVT_LEVEL_TRIGGER;
> -		return __apic_accept_irq(apic, mode, vector, 1, trig_mode,
> -					NULL);
> +
> +		r = __apic_accept_irq(apic, mode, vector, 1, trig_mode, NULL);
> +		if (r && lvt_type == APIC_LVTPC)
> +			kvm_lapic_set_reg(apic, lvt_type, reg | APIC_LVT_MASKED);

Belated feedback, I think I'd prefer to write this as

			kvm_lapic_set_reg(apic, APIC_LVTPC, reg | APIC_LVT_MASKED);

so that this code will show up when searching for APIC_LVTPC.

> +		return r;
>  	}
>  	return 0;
>  }
> -- 
> 2.42.0.515.g380fc7ccd1-goog
> 
