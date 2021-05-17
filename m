Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65597383BAF
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 19:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236683AbhEQRwk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 13:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236575AbhEQRwj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 May 2021 13:52:39 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5B7CC061756
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 10:51:21 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id m124so5143784pgm.13
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 10:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ciacKr636GewtgsdE94vzZWJiDRA/jOYAWlm7tYbsAM=;
        b=jhr8KXpG3ATpqaLg3GYGyGOVhrqPv2QGXPeWxrmPsAyeUeaLjh49AEP/r3E5bH9eDQ
         fne7rlNXAdGPuOzqR2kfv0JZGQfYznRpXyjQG7erzg67bvJlnGubu68ey8ZEVm6vMP7N
         r/lAYYFVtytYdzKhqFG1lWo05USsTCLOKkN6PgNjs8gvjXhegiSrZIl+ZVaoEUyRez9F
         JmUfbzSdy2AEb+4CcKvafS+h3vMg0EwdBTfXryVSnLks754c9ymD9bIrytIsiJ8FX8w9
         pnx0nzh/Uo/4TmKVxImg822u9idfaU05KDiGBKb1pPO/1mM284SKTOstpI+S1QiXc7aN
         ilUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ciacKr636GewtgsdE94vzZWJiDRA/jOYAWlm7tYbsAM=;
        b=an78FiD7Vy4+QvXVoqTJKF02M4SXU4WRW5uLyc97DFZHbyKz9/h+DwVE7q3iAtnUFA
         R30ChyU5ZOh6MKHRe/5VXVRzRZHqchEgtU2ARKD+N71gL9seKy9bXt1J6iStVOZX/me7
         ZSS/najf+7LTYPKFUB2iWXTlJZY6d/x0Vh/CZHjS8XseXzZRR8Duc9i2OXqbjU4IwBvm
         QzqoP9qADR4oYokPc8XRUr8SJinTYIYCQ3Mj2yPbeOc3A7+C6XL30ddjdB5SSJU+0h5O
         MTnsjBsU485JI4K4ZSRiqOwBrlvTu5jHybpYWVDPvmJVcdPkf/z9xOmzAU8U5gdzf6pf
         qOig==
X-Gm-Message-State: AOAM531I2MJadUo3d9ez4FoW1Fzgf/2D77NT7jp/DxuoBPb21MQGyEca
        Ex5rqx+WDfaD8DZoi717y/EBsQ==
X-Google-Smtp-Source: ABdhPJwZP3EtD+A7BoLpz/XlT/ZgJtw1J+xYsFpN4wG23HIhBmO3CcSW0LLoYcrJ6ex93FoTc10Qgw==
X-Received: by 2002:a63:5160:: with SMTP id r32mr705352pgl.83.1621273881285;
        Mon, 17 May 2021 10:51:21 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id k1sm4452219pfa.30.2021.05.17.10.51.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 10:51:20 -0700 (PDT)
Date:   Mon, 17 May 2021 17:51:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v3 5/5] KVM: LAPIC: Narrow the timer latency between
 wait_lapic_expire and world switch
Message-ID: <YKKtFOl3oklFp1lW@google.com>
References: <1621260028-6467-1-git-send-email-wanpengli@tencent.com>
 <1621260028-6467-5-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1621260028-6467-5-git-send-email-wanpengli@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 17, 2021, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Let's treat lapic_timer_advance_ns automatically tune logic as hypervisor
> overhead, move it before wait_lapic_expire instead of between wait_lapic_expire 
> and the world switch, the wait duration should be calculated by the 
> up-to-date guest_tsc after the overhead of automatically tune logic. This 
> patch reduces ~30+ cycles for kvm-unit-tests/tscdeadline-latency when testing 
> busy waits.
> 
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/lapic.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index c0ebef560bd1..552d2acf89ab 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1598,11 +1598,12 @@ static void __kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
>  	guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
>  	apic->lapic_timer.advance_expire_delta = guest_tsc - tsc_deadline;
>  
> -	if (guest_tsc < tsc_deadline)
> -		__wait_lapic_expire(vcpu, tsc_deadline - guest_tsc);
> -
>  	if (lapic_timer_advance_dynamic)
>  		adjust_lapic_timer_advance(vcpu, apic->lapic_timer.advance_expire_delta);
> +
> +	guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());

This is redundant and unnecessary if automatic tuning is disabled, or if the
timer did not arrive early.  A comment would also be helpful.  E.g. I think this
would micro-optimize all paths:

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index c0ebef560bd1..5d91f2367c31 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1598,11 +1598,19 @@ static void __kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
        guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
        apic->lapic_timer.advance_expire_delta = guest_tsc - tsc_deadline;

+       if (lapic_timer_advance_dynamic) {
+               adjust_lapic_timer_advance(vcpu, apic->lapic_timer.advance_expire_delta);
+               /*
+                * If the timer fired early, reread the TSC to account for the
+                * overhead of the above adjustment to avoid waiting longer
+                * than is necessary.
+                */
+               if (guest_tsc < tsc_deadline)
+                       guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
+       }
+
        if (guest_tsc < tsc_deadline)
                __wait_lapic_expire(vcpu, tsc_deadline - guest_tsc);
-
-       if (lapic_timer_advance_dynamic)
-               adjust_lapic_timer_advance(vcpu, apic->lapic_timer.advance_expire_delta);
 }

 void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)

> +	if (guest_tsc < tsc_deadline)
> +		__wait_lapic_expire(vcpu, tsc_deadline - guest_tsc);
>  }
>  
>  void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
> -- 
> 2.25.1
> 
