Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16B7665344C
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 17:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232605AbiLUQqT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 11:46:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbiLUQqP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 11:46:15 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6101425290
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 08:46:11 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id t11-20020a17090a024b00b0021932afece4so2868860pje.5
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 08:46:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/xhayUM09y+ZXkaefEQPLGoTgYMpgE5lLfkO6NlZMBU=;
        b=QCvDwK5FjbmQvOiJuj2zxc8Oa1rz2Yu78OqFocJv6CanVYNjnPbah9ov8nbShuRWDQ
         GEpvd1BTv8GIJZbN36C3J1JHbPn9KCxRvGUHAvuVREtOfD2cVln6gk9tIY8N7Ff6BbyX
         qNFOwZ0tL2SwZNi24EkuX6SR0/uivMfrO1vywdBdkQQ091/ER+8zS/fO2+FrfeHAcQYe
         02n92amozT1TB0F+qteRuKaeah6c1m0vioFp0K1Q2wacQKF0i7tROr/edNtg353F9ROL
         97i7jUujGMKAD5RaCBTOUgBCHemgJbL29f8vBV/zmCytkKvbpN6NtYldxhmY03ryufLH
         BGOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/xhayUM09y+ZXkaefEQPLGoTgYMpgE5lLfkO6NlZMBU=;
        b=WwMgzxYlX1c17rISPHJ/sbRjvyeURRZe29fH7bJ0R/IQGitUoVXpBLi1mNcPpuOBFd
         +pfxn4nq14lu13T0nTqhZx8PMgKm/V//lsGJznPgaYwEl0YSgJErD7G1R3tXhMUSREyu
         QXXAfbfqXhXxOdq9sK/oN+BsSIYa50/5/vu5dBIvV4EATlEisw4c/rll3e0dYPjOAPZM
         OSXOLXpFCZxUiVeCfsfJkuoOHk1xXL/TfhUVXN4P2GGetTpvtZOcyYrTS/Z8kb4S8X7D
         MusVBjmsGu0dVYYuiUmKvqDaUq1yhGSXmOVQZlJVBOlaLtLIBPzylh+TC6UuBkKvK5uF
         ojWg==
X-Gm-Message-State: AFqh2krRxXYqSPSqTZiOHzbx44mJSIKg+8jxzOqUjwtitxohrEEXNENn
        Dj2bR3m5NFZoIZ5no+6ToLplTq+f8UC9hhUF
X-Google-Smtp-Source: AMrXdXvIIJVNCjKCV3QQDpqvp6TKJUzqhghFDBvd/XDbEipk7sf/BNcw0BrnEsk/ZWXhVmg3MEql+w==
X-Received: by 2002:a17:902:9a87:b0:189:858f:b5c0 with SMTP id w7-20020a1709029a8700b00189858fb5c0mr689825plp.0.1671641170727;
        Wed, 21 Dec 2022 08:46:10 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id z14-20020a170903018e00b00174c0dd29f0sm11728058plg.144.2022.12.21.08.46.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Dec 2022 08:46:10 -0800 (PST)
Date:   Wed, 21 Dec 2022 08:46:06 -0800
From:   Ricardo Koller <ricarkol@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH 2/3] KVM: arm64: Handle S1PTW translation with TCR_HA set
 as a write
Message-ID: <Y6M4TqvJytAEq2ID@google.com>
References: <20221220200923.1532710-1-maz@kernel.org>
 <20221220200923.1532710-3-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221220200923.1532710-3-maz@kernel.org>
X-Spam-Status: No, score=-15.7 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        URI_DOTEDU,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

On Tue, Dec 20, 2022 at 08:09:22PM +0000, Marc Zyngier wrote:
> As a minor optimisation, we can retrofit the "S1PTW is a write
> even on translation fault" concept *if* the vcpu is using the
> HW-managed Access Flag, as setting TCR_EL1.HA is guaranteed
> to result in an update of the PTE.
> 
> However, we cannot do the same thing for DB, as it would require
> us to parse the PTs to find out if the DBM bit is set there.
> This is not going to happen.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_emulate.h | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index fd6ad8b21f85..4ee467065042 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -374,6 +374,9 @@ static __always_inline int kvm_vcpu_sys_get_rt(struct kvm_vcpu *vcpu)
>  static inline bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
>  {
>  	if (kvm_vcpu_abt_iss1tw(vcpu)) {
> +		unsigned int afdb;
> +		u64 mmfr1;
> +
>  		/*
>  		 * Only a permission fault on a S1PTW should be
>  		 * considered as a write. Otherwise, page tables baked
> @@ -385,12 +388,27 @@ static inline bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
>  		 * to map the page containing the PT (read only at
>  		 * first), then a permission fault to allow the flags
>  		 * to be set.
> +		 *
> +		 * We can improve things if the guest uses AF, as this
> +		 * is guaranteed to result in a write to the PTE. For
> +		 * DB, however, we'd need to parse the guest's PTs,
> +		 * and that's not on. DB is crap anyway.
>  		 */
>  		switch (kvm_vcpu_trap_get_fault_type(vcpu)) {

Nit: fault_status is calculated once when taking the fault, and passed
around to all users (like user_mem_abort()). Not sure if this is because
of the extra cycles needed to get it, or just style. Anyway, maybe it
applies here.

>  		case ESR_ELx_FSC_PERM:
>  			return true;
>  		default:
> -			return false;
> +			/* Can't introspect TCR_EL1 with pKVM */
> +			if (kvm_vm_is_protected(vcpu->kvm))
> +				return false;
> +
> +			mmfr1 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
> +			afdb = cpuid_feature_extract_unsigned_field(mmfr1, ID_AA64MMFR1_EL1_HAFDBS_SHIFT);
> +
> +			if (afdb == ID_AA64MMFR1_EL1_HAFDBS_NI)
> +				return false;
> +
> +			return (vcpu_read_sys_reg(vcpu, TCR_EL1) & TCR_HA);

Also tested this specific case using page_fault_test when the PT page is
marked for dirty logging with and without AF. In both cases there's a
single _FSC_FAULT (no PERM_FAUT) as expected, and the PT page is marked dirty
in the AF case. The RO and UFFD cases also work as expected.

Need to send some changes for page_fault_test as many tests assume that
any S1PTW is always a PT write, and are failing. Also need to add some new
tests for PTs in RO memslots (as it didn't make much sense before this
change).

>  		}
>  	}
>  
> -- 
> 2.34.1
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Reviewed-by: Ricardo Koller <ricarkol@google.com>

Thanks,
Ricardo
