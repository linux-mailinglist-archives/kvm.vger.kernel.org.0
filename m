Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E59E442E197
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 20:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbhJNStn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 14:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231665AbhJNStm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 14:49:42 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0D96C061753
        for <kvm@vger.kernel.org>; Thu, 14 Oct 2021 11:47:37 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id e65so3958607pgc.5
        for <kvm@vger.kernel.org>; Thu, 14 Oct 2021 11:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Hj8bRKy7pZu0LuU2rxde5pixCOPmXQk4/dNn02p1KuE=;
        b=YE2ozOTtbvO87eeiyxNEc0u4/aJoVMGhsJWqnN19qxVb8fYWC2X5cqPwH2SZXD/J7M
         7kZe3YJisk75UscQwNJj2qdz6hNxEW9mwYtbrxCDK2VBFnYBz/kKSDBvKUb5UWdpggKl
         5ChPzE69Iv7n63+lwUkkw7CqOIgRpxbFPRK6XjTJA5RSJ8ckWYz354w4HUfK0m1JsF6t
         bur8aroImEqlkbzwXvpQQUy0zJXUbThHKC/SsEuiUcmlvHqrPkpUv7sylDDnaUolc2sA
         vKYqfCJbh7/jHnN4aRs+FVqrM5e1f8UR2e5dj09zIlanhpZPRN40wnGrSmrzf88lqmy2
         VzYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Hj8bRKy7pZu0LuU2rxde5pixCOPmXQk4/dNn02p1KuE=;
        b=EtTUQHjXj74M54cumkfnwBOq1gkRRNXmTrQVbnH26gVNWRkn0vpDekBQ3AplOZ2Mnw
         spZkbzVNuFWLIvrNiH6ljFCjBUxVa18aywgW1A744B+SQfKxERZspJzagHc4bxYSeOYY
         nzWKFRnQOJRzjcLcqFxXJhIwQ9Id/LurT1MeSAptlES4KNzSlJzuEfKQqQS6RvhVsZ70
         p6pwT2ohPAHD9nAKiJb/LAJu52fAR9TsMyPRE7wLfNdZJTbqX9efEhklXn4GSt37Ce2Q
         DXHu9e8vDvZY1cyhlx3CZ4bdrWyIZ3ysyJc2GLUJG1czAWElGQn6EZx5ccTwVkgGIAk9
         i7Bw==
X-Gm-Message-State: AOAM532VIeAvwpZXWv4OYV9sZhQT8pzXlFV1IrWWWh2ag++iemhR2Cyw
        BvFMgt50mkyqpLyMPYo2q/0aiuWw98o=
X-Google-Smtp-Source: ABdhPJwKwwDgP6zCaYZ98SKEUNfMxQgcFrUSWchh+ba86VQL1cLfobDJ+JaCO8xvAw8Lp8/1c7PqFw==
X-Received: by 2002:a62:760f:0:b0:44c:eb65:8574 with SMTP id r15-20020a62760f000000b0044ceb658574mr6985916pfc.37.1634237257014;
        Thu, 14 Oct 2021 11:47:37 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y2sm3095745pjl.6.2021.10.14.11.47.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 11:47:36 -0700 (PDT)
Date:   Thu, 14 Oct 2021 18:47:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] KVM: X86: Don't reset mmu context when X86_CR4_PCIDE
 1->0
Message-ID: <YWh7RH7HXQE34sFb@google.com>
References: <20210919024246.89230-1-jiangshanlai@gmail.com>
 <20210919024246.89230-2-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210919024246.89230-2-jiangshanlai@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Sep 19, 2021, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> X86_CR4_PCIDE doesn't participate in kvm_mmu_role, so the mmu context
> doesn't need to be reset.  It is only required to flush all the guest
> tlb.
> 
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> ---
>  arch/x86/kvm/x86.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 86539c1686fa..7494ea0e7922 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -116,6 +116,7 @@ static void enter_smm(struct kvm_vcpu *vcpu);
>  static void __kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
>  static void store_regs(struct kvm_vcpu *vcpu);
>  static int sync_regs(struct kvm_vcpu *vcpu);
> +static void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu);
>  
>  static int __set_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
>  static void __get_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
> @@ -1042,9 +1043,10 @@ EXPORT_SYMBOL_GPL(kvm_is_valid_cr4);
>  
>  void kvm_post_set_cr4(struct kvm_vcpu *vcpu, unsigned long old_cr4, unsigned long cr4)
>  {
> -	if (((cr4 ^ old_cr4) & KVM_MMU_CR4_ROLE_BITS) ||
> -	    (!(cr4 & X86_CR4_PCIDE) && (old_cr4 & X86_CR4_PCIDE)))
> +	if ((cr4 ^ old_cr4) & KVM_MMU_CR4_ROLE_BITS)
>  		kvm_mmu_reset_context(vcpu);
> +	else if (!(cr4 & X86_CR4_PCIDE) && (old_cr4 & X86_CR4_PCIDE))
> +		kvm_vcpu_flush_tlb_guest(vcpu);

Unless there's a corner case I'm missing, I would prefer this to use
kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu) instead of calling
kvm_vcpu_flush_tlb_guest() directly.  The odds of flushes actually being batched
is low, it's more to document that kvm_post_set_cr4() _isn't_ special.
