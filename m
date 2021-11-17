Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDDCB455030
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 23:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241088AbhKQWRf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 17:17:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231929AbhKQWRe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 17:17:34 -0500
X-Greylist: delayed 3878 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 17 Nov 2021 14:14:35 PST
Received: from twosheds.infradead.org (unknown [IPv6:2001:8b0:10b:1:aaa1:59ff:fe2f:55f7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D2EC061570;
        Wed, 17 Nov 2021 14:14:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=twosheds.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:Cc:To:From:Subject:Date:References:In-Reply-To:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=PY24mY1Y2geRmk7LjuGhOiKBHR3iZW7SC/NuUGtVeMM=; b=fInAvRfbXmsj2mRaAOMhBYLcLy
        rNV3j1Ejy+5tp8+gefj0Ci1K8wUw/TqCwo4phGfDDq1OEX+zE3T5+9J+WUu8XZ68WvfujlJMgRUdq
        fxcgLANbQ0bA5uHCFb8tfnVZy19nrvr3qujLNM1CEy+eRbFuppcsu+2Gu1haaPtMH2OZeBT48dIJ+
        MgZ7cnFoCPvFUVHKjy+wj1KRDU0pwv46XKxGiQF5msM9UIjM+UBm/pQusxMLzB2JKBaHEMNFaf1cY
        EwEp9WOb3Jf2IfUCshGJH9Upz2d6mUreD3M3e/7okHzoEyb/daAOFczuRJZBRtYk6sazwxlVM7FPi
        Qu9mdBIA==;
Received: from localhost ([127.0.0.1] helo=twosheds.infradead.org)
        by twosheds.infradead.org with esmtp (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mnSBT-00FV0l-BJ; Wed, 17 Nov 2021 21:09:35 +0000
Received: from 2001:8b0:10b:1:d129:67c1:5868:c3aa
        (SquirrelMail authenticated user dwmw2)
        by twosheds.infradead.org with HTTP;
        Wed, 17 Nov 2021 21:09:35 -0000
Message-ID: <85d9fec17f32c3eb9e100e56b91af050.squirrel@twosheds.infradead.org>
In-Reply-To: <20211117174003.297096-9-dwmw2@infradead.org>
References: <20211117174003.297096-1-dwmw2@infradead.org>
    <20211117174003.297096-9-dwmw2@infradead.org>
Date:   Wed, 17 Nov 2021 21:09:35 -0000
Subject: Re: [PATCH v3 08/12] KVM: Propagate vcpu explicitly to
 mark_page_dirty_in_slot()
From:   "David Woodhouse" <dwmw2@infradead.org>
To:     "David Woodhouse" <dwmw2@infradead.org>
Cc:     "Paolo Bonzini" <pbonzini@redhat.com>, "kvm" <kvm@vger.kernel.org>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        "Joao Martins" <joao.m.martins@oracle.com>,
        "jmattson @ google . com" <jmattson@google.com>,
        "wanpengli @ tencent . com" <wanpengli@tencent.com>,
        "seanjc @ google . com" <seanjc@google.com>,
        "vkuznets @ redhat . com" <vkuznets@redhat.com>,
        "mtosatti @ redhat . com" <mtosatti@redhat.com>,
        "joro @ 8bytes . org" <joro@8bytes.org>, karahmed@amazon.com,
        "Marc Zyngier" <maz@kernel.org>,
        "James Morse" <james.morse@arm.com>,
        "Alexandru Elisei" <alexandru.elisei@arm.com>,
        "Suzuki K Poulose" <suzuki.poulose@arm.com>,
        "Catalin Marinas" <catalin.marinas@arm.com>,
        "Will Deacon" <will@kernel.org>,
        "Huacai Chen" <chenhuacai@kernel.org>,
        "Aleksandar Markovic" <aleksandar.qemu.devel@gmail.com>,
        "Michael Ellerman" <mpe@ellerman.id.au>,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        "Anup Patel" <anup.patel@wdc.com>,
        "Christian Borntraeger" <borntraeger@de.ibm.com>,
        kvmarm@lists.cs.columbia.edu,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org
User-Agent: SquirrelMail/1.4.23 [SVN]-5.fc33.20190710
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by twosheds.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> From: David Woodhouse <dwmw@amazon.co.uk>
>
> The kvm_dirty_ring_get() function uses kvm_get_running_vcpu() to work out
> which dirty ring to use, but there are some use cases where that doesn't
> work.
>
> There's one in setting the Xen shared info page, introduced in commit
> 629b5348841a ("KVM: x86/xen: update wallclock region") and reported by
> "butt3rflyh4ck" <butterflyhuangxx@gmail.com> in
> https://lore.kernel.org/kvm/CAFcO6XOmoS7EacN_n6v4Txk7xL7iqRa2gABg3F7E3Naf5uG94g@mail.gmail.com/
>
> There's also about to be another one when the newly-reintroduced
> gfn_to_pfn_cache needs to mark a page as dirty from the MMU notifier
> which invalidates the mapping. In that case, we will *know* the vcpu
> that can be 'blamed' for dirtying the page, and we just need to be
> able to pass it in as an explicit argument when doing so.
>
> This patch preemptively resolves the second issue, and paves the way
> for resolving the first. A complete fix for the first issue will need
> us to switch the Xen shinfo to be owned by a particular vCPU, which
> will happen in a separate patch.
>
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>



> --- a/virt/kvm/dirty_ring.c
> +++ b/virt/kvm/dirty_ring.c
> @@ -36,12 +36,16 @@ static bool kvm_dirty_ring_full(struct kvm_dirty_ring
> *ring)
>  	return kvm_dirty_ring_used(ring) >= ring->size;
>  }
>
> -struct kvm_dirty_ring *kvm_dirty_ring_get(struct kvm *kvm)
> +struct kvm_dirty_ring *kvm_dirty_ring_get(struct kvm *kvm, struct
> kvm_vcpu *vcpu)
>  {
> -	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
> +	struct kvm_vcpu *running_vcpu = kvm_get_running_vcpu();
>
> +	WARN_ON_ONCE(vcpu && vcpu != running_vcpu);
>  	WARN_ON_ONCE(vcpu->kvm != kvm);

Ah, that one needs to be changed to check running_vcpu instead. Or this
needs to go first:

I think I prefer making the vCPU a required argument. If anyone's going to
pull a vCPU pointer out of their posterior, let the caller do it.

> +	if (!vcpu)
> +		vcpu = running_vcpu;
> +
>  	return &vcpu->dirty_ring;
>  }
>

-- 
dwmw2

