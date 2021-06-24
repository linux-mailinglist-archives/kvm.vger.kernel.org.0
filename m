Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED1C13B2A93
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 10:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbhFXIp1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 04:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbhFXIp0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 04:45:26 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD76C061574;
        Thu, 24 Jun 2021 01:43:06 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id u2so2596436plf.3;
        Thu, 24 Jun 2021 01:43:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=yhvFMq52QAZ9Grg2JNZMftQHgs3RA/23cRzSXZS17k0=;
        b=gAOPVlMk/C7twisLQPwKCNWWewikvdh3rxAsE3ZtniqnTTajI/NMXYxiFGdNgFsAb5
         HygkoSZIJ35Gv0csn5ROrHrh88J/UJu+eQftLB0ieYLqxUsTshCjLCXS6gCtoawRaivr
         09ywa3Xbj5hpxhL9dwXklJBlZskMpYTiquDzecxyLb9cNgD5q6A07FqSvRwXDFm8rCjX
         BNwM+/+ntQwzLzmsj9QUq7rwCh6LY1EpIQpDwzEMVK8zxcfbTYEjGD1dfARZQBO2ATzQ
         bXhbvn6/C4gpLxmOLhsNYYF/nPrsfEvzkHwVbcZduLr1uAs8pjNAgfhm1dhPRaqpCZmK
         qi+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=yhvFMq52QAZ9Grg2JNZMftQHgs3RA/23cRzSXZS17k0=;
        b=BU3nHJhNpbqzNyn2Kk9HrmtaroFtkm9XNqK5e5rbR+Z/NMmGxaFRQCbSavR9e0lgxi
         Fto6wNZ7gHIXsYpSxP7JsWapZEHQ7HstMj4Mok7pyhxT6U0JvAV4VjCJ8v1RPRUoUtaa
         QdA0PE126I/bgM2S3EOjE2wcFy9mVGyhCrymp5kPkN8rGn6AhtPYFFQUtDBce5xyhlpA
         HfRQsknWKQWdXZYWvm7l7SzIADJtcUP+wr4aZYOzjWrbBw2lg898vMPB+7nLlVOlc8hX
         yS4kaHsTLtjhHRdHBz5UNjEAlDm3mHWI41vcsDCosfydV+awa5iNsebEytBkmAfEvrQ7
         R4Lw==
X-Gm-Message-State: AOAM530FY2fKReHTCME6EoyzKwO3TJNySRwRM0XlkEd8kn6DDgZAo7Bc
        jhQpyZRVnO8q12Jf13WlELw=
X-Google-Smtp-Source: ABdhPJxPYtDJj0lFNs0Ok5TeYJmivmtsbDnnr/kiA2/ldwDSYWrbmF8IsiSMPIQHeLM0imoUnt26JQ==
X-Received: by 2002:a17:90b:793:: with SMTP id l19mr14007232pjz.111.1624524186360;
        Thu, 24 Jun 2021 01:43:06 -0700 (PDT)
Received: from localhost (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id 23sm1841779pjw.28.2021.06.24.01.43.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 01:43:06 -0700 (PDT)
Date:   Thu, 24 Jun 2021 18:43:00 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 1/6] KVM: x86/mmu: release audited pfns
To:     Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Stevens <stevensd@chromium.org>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        James Morse <james.morse@arm.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvmarm@lists.cs.columbia.edu,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Sean Christopherson <seanjc@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Will Deacon <will@kernel.org>
References: <20210624035749.4054934-1-stevensd@google.com>
        <20210624035749.4054934-2-stevensd@google.com>
In-Reply-To: <20210624035749.4054934-2-stevensd@google.com>
MIME-Version: 1.0
Message-Id: <1624524156.04etgk7zmz.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Excerpts from David Stevens's message of June 24, 2021 1:57 pm:
> From: David Stevens <stevensd@chromium.org>

Changelog? This looks like a bug, should it have a Fixes: tag?

Thanks,
Nick

>=20
> Signed-off-by: David Stevens <stevensd@chromium.org>
> ---
>  arch/x86/kvm/mmu/mmu_audit.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/arch/x86/kvm/mmu/mmu_audit.c b/arch/x86/kvm/mmu/mmu_audit.c
> index cedc17b2f60e..97ff184084b4 100644
> --- a/arch/x86/kvm/mmu/mmu_audit.c
> +++ b/arch/x86/kvm/mmu/mmu_audit.c
> @@ -121,6 +121,8 @@ static void audit_mappings(struct kvm_vcpu *vcpu, u64=
 *sptep, int level)
>  		audit_printk(vcpu->kvm, "levels %d pfn %llx hpa %llx "
>  			     "ent %llxn", vcpu->arch.mmu->root_level, pfn,
>  			     hpa, *sptep);
> +
> +	kvm_release_pfn_clean(pfn);
>  }
> =20
>  static void inspect_spte_has_rmap(struct kvm *kvm, u64 *sptep)
> --=20
> 2.32.0.93.g670b81a890-goog
>=20
>=20
