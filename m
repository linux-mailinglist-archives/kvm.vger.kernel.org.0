Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 557253B2AD5
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 10:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbhFXJA1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 05:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbhFXJAZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 05:00:25 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD4AFC061574;
        Thu, 24 Jun 2021 01:58:06 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id s14so3323219pfg.0;
        Thu, 24 Jun 2021 01:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=tKGKGI76BKfQVO8CY1clLxpyySv3vaB3aNh7NWcPhFU=;
        b=hr3gPiWSs1kzsoT0RN4D0/9u1oAQb1rzWVWLp59xVCkmpZThGbP8ZZHdbz3ZoRByYE
         Q+bBx6g9vlzubm3xmDqrFRZB2+oF9y38fRVeD/lgeXJbzeuitriXAAYQ0N8Gc/HydmS9
         h/5/U9gCncS2FPi6hlzNOXRrtw9yomYF3Wegfa7y5BMTxxqMjVRS/4Rtc+vsfYrwyiXs
         LyEAUsbj+aFGjgwEVS9b0hjW6sOv/s+/X+xMkec2Brf1nwlIC4mUivbzM9KBmc/1CmOo
         TCEnNnCh1Rmp7Wm6gBzXbz6S+8yTRr+T+rSaRDpuwEYfFxSOn4uIuwntNiH62vmZwJdo
         +iuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=tKGKGI76BKfQVO8CY1clLxpyySv3vaB3aNh7NWcPhFU=;
        b=ks5V5HoFfYHrZqnvVUP3SZpsCYaSwBSX8Tkf8LynNcGR2I7B8anfGvu9jIpNNn07Cc
         2fvBB7QXPs2olhF3NYIH6wOB0xMZWEcMbdhW2Xyj36BabeMF/p41BXG2wEbgh93qS6fm
         JvZz+Jc89Opb/TUaYjvP1pVzgNlNIwmWJO9yChnVjLJxfXOnu3ahEe2zmKJH/8YkHg7u
         M47b5E4GnIrGU+MvnPRaMu3smhSGwzK5bs7xEuI3AMRnOxg3fTsg3kuK4ErjTDGA+Bde
         22SMOA+qhngfUzR7adjDi4U0An6nps/khed6YjZjTNFsVsm2x4PkSrXfx8b6mpScKQo6
         YWoA==
X-Gm-Message-State: AOAM53224IMDWWPPmWgUVNhFaFXO7G1uaj2T4V34ytRMdyrE+d78jl1L
        Jciy/UEvTH/xvEW5LU3tdxQ=
X-Google-Smtp-Source: ABdhPJw6tjizzTpMBwm3ffTzeTydtLNTRDVWzEX8o5A/u6n7JmgIJ0z9ctLYNOtrV24IDSrsfT+37Q==
X-Received: by 2002:a63:4e4c:: with SMTP id o12mr3895360pgl.95.1624525086186;
        Thu, 24 Jun 2021 01:58:06 -0700 (PDT)
Received: from localhost (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id u12sm2003479pjc.0.2021.06.24.01.58.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 01:58:05 -0700 (PDT)
Date:   Thu, 24 Jun 2021 18:58:00 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 3/6] KVM: x86/mmu: avoid struct page in MMU
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
        <20210624035749.4054934-4-stevensd@google.com>
In-Reply-To: <20210624035749.4054934-4-stevensd@google.com>
MIME-Version: 1.0
Message-Id: <1624524744.2sr7o7ix86.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Excerpts from David Stevens's message of June 24, 2021 1:57 pm:
> From: David Stevens <stevensd@chromium.org>
>  out_unlock:
>  	if (is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa))
>  		read_unlock(&vcpu->kvm->mmu_lock);
>  	else
>  		write_unlock(&vcpu->kvm->mmu_lock);
> -	kvm_release_pfn_clean(pfn);
> +	if (pfnpg.page)
> +		put_page(pfnpg.page);
>  	return r;
>  }

How about

  kvm_release_pfn_page_clean(pfnpg);

Thanks,
Nick
