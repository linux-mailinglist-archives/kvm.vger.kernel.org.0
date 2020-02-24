Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F413B16A7B6
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 14:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727498AbgBXNyq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 08:54:46 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:49822 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727401AbgBXNyq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Feb 2020 08:54:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582552485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LW+r1TS9T6Bhh7eIghSubKEoZWRqarxO5U8eaU3pP0c=;
        b=OzzecLN17B0sT3OqIpjSgboDkRYHmVXSDbVo4O6ChvfAk3ZzJI9IYlbUweDEEI7+8tusxN
        yTCim7S/Dti4XlFT0TUojX1h7wSgXPYPQw1ubFvNDnt5Jr/mREZvI2XrXKC7rzzjmdt+cf
        adO5jTUoUS8YPpWUVZCqCbAI61QTLhc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-92-hvfkBp3oP3m23j7t8z3kQg-1; Mon, 24 Feb 2020 08:54:41 -0500
X-MC-Unique: hvfkBp3oP3m23j7t8z3kQg-1
Received: by mail-wr1-f72.google.com with SMTP id z1so1973726wrs.9
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2020 05:54:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=LW+r1TS9T6Bhh7eIghSubKEoZWRqarxO5U8eaU3pP0c=;
        b=PREErhLh1kMIue0/0z23cSRznlsGz0sepSBMJJyq/r7WyUPSS2B0o0fx8PzOqxJg+9
         JIjxQPZm6pTG6a37KPrMnKScjGJpKnVxmqYfyU1Tzap0rqSGnZ0PBlkMvvyc05oQ3W43
         BLAVpoKKJKsxyMFrpYC84DzCqnHmhHxEKyo7p9C083Lx/FEH+rL4nQAuNtCJEyZS0QmQ
         d9Y6pGR5+4hiO75lKXDgYD0tgOzzMjJHklWzcu4H8Ekf4KrMxIGn9DaYEfUG06+1S4A4
         EfrdQg2EUvHoSjefBwSDdR5hetr4iw9T43pa4kIe5u7yPfe9TjmEpyW1GKX5/v55EWDZ
         KvmA==
X-Gm-Message-State: APjAAAXY7Klit2ZkdW2IJcImOAM+3A4qGHB2LpXIW8US7X16S7V6dimw
        BoU1qHQUFsQ8vWLXwHNGuc4PaEQhXrloIDOCRVwAleJv7BBh1LyLSrkMA9zhmb0cPhYbgz5RKEs
        23iMcRHhySCQJ
X-Received: by 2002:a1c:bdc5:: with SMTP id n188mr22278810wmf.124.1582552480073;
        Mon, 24 Feb 2020 05:54:40 -0800 (PST)
X-Google-Smtp-Source: APXvYqx2QsmhGaqPOGdx8xFP9PBNHbqyJ9KAYea4W3w+9lGzuHMzKWCmHi+jHkgDiddCLAHlIxIclQ==
X-Received: by 2002:a1c:bdc5:: with SMTP id n188mr22278791wmf.124.1582552479839;
        Mon, 24 Feb 2020 05:54:39 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id h18sm19458434wrv.78.2020.02.24.05.54.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 05:54:39 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 29/61] KVM: x86: Add Kconfig-controlled auditing of reverse CPUID lookups
In-Reply-To: <20200201185218.24473-30-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <20200201185218.24473-30-sean.j.christopherson@intel.com>
Date:   Mon, 24 Feb 2020 14:54:38 +0100
Message-ID: <87a758oztt.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Add WARNs in the low level __cpuid_entry_get_reg() to assert that the
> function and index of the CPUID entry and reverse CPUID entry match.
> Wrap the WARNs in a new Kconfig, KVM_CPUID_AUDIT, as the checks add
> almost no value in a production environment, i.e. will only detect
> blatant KVM bugs and fatal hardware errors.  Add a Kconfig instead of
> simply wrapping the WARNs with an off-by-default #ifdef so that syzbot
> and other automated testing can enable the auditing.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/Kconfig | 10 ++++++++++
>  arch/x86/kvm/cpuid.h |  5 +++++
>  2 files changed, 15 insertions(+)
>
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 840e12583b85..bbbc3258358e 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -96,6 +96,16 @@ config KVM_MMU_AUDIT
>  	 This option adds a R/W kVM module parameter 'mmu_audit', which allows
>  	 auditing of KVM MMU events at runtime.
>  
> +config KVM_CPUID_AUDIT
> +	bool "Audit KVM reverse CPUID lookups"
> +	depends on KVM
> +	help
> +	 This option enables runtime checking of reverse CPUID lookups in KVM
> +	 to verify the function and index of the referenced X86_FEATURE_* match
> +	 the function and index of the CPUID entry being accessed.
> +
> +	 If unsure, say N.
> +
>  # OK, it's a little counter-intuitive to do this, but it puts it neatly under
>  # the virtualization menu.
>  source "drivers/vhost/Kconfig"
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index 51f19eade5a0..41ff94a7d3e0 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -98,6 +98,11 @@ static __always_inline struct cpuid_reg x86_feature_cpuid(unsigned x86_feature)
>  static __always_inline u32 *__cpuid_entry_get_reg(struct kvm_cpuid_entry2 *entry,
>  						  const struct cpuid_reg *cpuid)
>  {
> +#ifdef CONFIG_KVM_CPUID_AUDIT
> +	WARN_ON_ONCE(entry->function != cpuid->function);
> +	WARN_ON_ONCE(entry->index != cpuid->index);
> +#endif
> +
>  	switch (cpuid->reg) {
>  	case CPUID_EAX:
>  		return &entry->eax;

Honestly, I was thinking we should BUG_ON() and even in production builds
but not everyone around is so rebellious I guess, so

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

