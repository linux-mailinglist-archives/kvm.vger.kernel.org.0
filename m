Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B66941B9EB
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 00:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243038AbhI1WKT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 18:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242626AbhI1WKS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 18:10:18 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D522C061746
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 15:08:38 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id h3so528270pgb.7
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 15:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7rZGZtXj4Kjef8XTrbQn+IEWHZmecIVKI32pSog3bGg=;
        b=Gu0/C+e+W8WPTJ9kWJuQrZyoELFPICJgw72WckzL3ovfDopNe/Y4j2IPagVtUNhWwr
         9Qjfpn7SXH4wDFaqEdg5HJLXeLxphcPK9HcAugMDnWCpp68Xe6/ys1kzGwvSk+KcGCM4
         H64DJ7Tp5uRS7wp3aWTm1GhwRjDkRVaP2QPSIltqiZGDJzmU5Y11dt/buGH/9lHZ3SWJ
         bNi0rTAatQvQMs/Fb32BQ7aRL6utqOVWshzHxUOyBU70FP8VoWG62/RzZsJ4kBiRc9ua
         EQxp57U7HkBAHrtePs5fCEn33r7qnlM/POKA5AQ8Js4rYnMiBHo1lKgjrUm4AiUxx6TO
         BFlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7rZGZtXj4Kjef8XTrbQn+IEWHZmecIVKI32pSog3bGg=;
        b=PjEgAJktqu8ZNI1+UzsPxpKku4Tzabe7ZO7yu9gLjE156SPFDAxPOjvFYjvWDzkfjB
         N02W8SjzoGNqB7XpM0/2q1llzyeCLpsjfIHBGEbQE6SvfpW009etM8AZtYmXVicVZv9B
         19CEgLGKel0PIdJ0x8M+Iy2J/AzQPj90DVjaDqH+VuGCvon7lgCexdYNAJT2vmfSSIpg
         /ptFxOgXTzCujtMn9zPaob7qcgHK0YqNlCM/mjE6AHzPdb1LSeQFSAy1QxkgzZ6odVVr
         YBiNqeNvvdQgAugT8bpcr9asnM0/bWhKUzZqwwzS+Pa2/Oz61IIsqubKOZSgkqVrZoWK
         fgPg==
X-Gm-Message-State: AOAM531SsB8FNjq752hUZPskRE2xdRDmt+/XtxAwkeVpqWizGUWFvigN
        O4qO6ifOor4SUVmozZCq/2CCFQ==
X-Google-Smtp-Source: ABdhPJzadyVUO8UyxBHsA0YYc+iUIbEvRB9U2t+kYPdczvOjLMgOq7SgcZR4mYDt3YnbOWn2xcwTMQ==
X-Received: by 2002:a05:6a00:26cc:b0:440:51c6:fa38 with SMTP id p12-20020a056a0026cc00b0044051c6fa38mr7862566pfw.45.1632866917363;
        Tue, 28 Sep 2021 15:08:37 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id v6sm132638pfv.83.2021.09.28.15.08.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 15:08:36 -0700 (PDT)
Date:   Tue, 28 Sep 2021 22:08:33 +0000
From:   David Matlack <dmatlack@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH 12/14] KVM: Don't redo ktime_get() when calculating
 halt-polling stop/deadline
Message-ID: <YVOSYaNx0vd4SYHk@google.com>
References: <20210925005528.1145584-1-seanjc@google.com>
 <20210925005528.1145584-13-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210925005528.1145584-13-seanjc@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 24, 2021 at 05:55:26PM -0700, Sean Christopherson wrote:
> Calculate the halt-polling "stop" time using "cur" instead of redoing
> ktime_get().  In the happy case where hardware correctly predicts
> do_halt_poll, "cur" is only a few cycles old.  And if the branch is
> mispredicted, arguably that extra latency should count toward the
> halt-polling time.
> 
> In all likelihood, the numbers involved are in the noise and either
> approach is perfectly ok.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  virt/kvm/kvm_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 2980d2b88559..80f78daa6b8d 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3267,7 +3267,7 @@ void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
>  
>  	start = cur = poll_end = ktime_get();
>  	if (do_halt_poll) {
> -		ktime_t stop = ktime_add_ns(ktime_get(), vcpu->halt_poll_ns);
> +		ktime_t stop = ktime_add_ns(cur, vcpu->halt_poll_ns);
>  
>  		do {
>  			/*
> -- 
> 2.33.0.685.g46640cef36-goog
> 
