Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B664B388071
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 21:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351800AbhERTXH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 15:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237739AbhERTXG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 15:23:06 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A196C061760
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 12:21:48 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id x188so8152438pfd.7
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 12:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9yb6X9WCq6ingF8cwtbx1O7/WjF/mpD5c/jdXsDaiW8=;
        b=gFus+75BX7d39Z9zBEPrdYyp79FrQv1jUMPYm2ohAEJtCBHKTsJ1GqCIzPrKBl3QUz
         Q1T0JWWgL3GlIbuGhpOcHFlaUuT6zzUtFwSFsYdUpiYcSV6+tQQpFs4KyH5vB+sw3i8v
         RbYtaOy9+KQ3pQtOzXb8DvCMdQBnrQc5WOqaUd0fIsYYlyVBrySVf05ZA3awm5lS0gBh
         rYb9Ia1yuY5szSvQddMu+sBq+JgxSlkM4vSmOyDe7PXVUjHUXncr7ynLwjCI44MdLIlM
         Mln1juREPPPbXVkNHh5yuzLiF91QanUBhmnZWT6zz24VkOYci18iKrJbag3oG4wnGB1g
         iTUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9yb6X9WCq6ingF8cwtbx1O7/WjF/mpD5c/jdXsDaiW8=;
        b=gSot89a9RwwuokP1dHLuX2/XsZnWxDSomske3e7dCYLZ9sfwLzit+MONsrZeIR9dPk
         +YtEjGsOKJmXKwUy1/mFEASOwen00DYyC2R20LWxxkSKmOOzcIVznTsQ1hihl3ivmIPR
         kmzYG+8oLLPQd/2Dxpmh58TKb/TfC3m71BNFr7wsLW4CvOPY1tzV/dQ6JA6SZePfsSHd
         mkiA4qoAAdiyC9BW9ocrh2vLuwAPUrYNnsAekzrCvcxHj9vO588MMQShTe2U2VmHKD5D
         iEzE5boC0aZ+5e9yMYBe59EnaWz4DGZ2nsi871d+0+kwcxQepZHNQYtMg5dOCSLVzxx0
         gYFQ==
X-Gm-Message-State: AOAM531JIu2x6AKClS5oZ9nmfIAEzpxHegQVVC3OjQCEPwydesgAEXB8
        cGCnXqxGoYgTGjk4iovp8M6dOx3CJt4zIA==
X-Google-Smtp-Source: ABdhPJzf8Ouo/hZUfYP5y0VJIHPSShivzx5pKHMPDqldN5TT7V69LbUHeGgsVLYRNabdRSSjVXbTtQ==
X-Received: by 2002:a63:f245:: with SMTP id d5mr6584667pgk.416.1621365707487;
        Tue, 18 May 2021 12:21:47 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id o4sm12990504pfk.15.2021.05.18.12.21.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 12:21:46 -0700 (PDT)
Date:   Tue, 18 May 2021 19:21:43 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v4 2/5] KVM: X86: Bail out of direct yield in case of
 under-committed scenarios
Message-ID: <YKQTx381CGPp7uZY@google.com>
References: <1621339235-11131-1-git-send-email-wanpengli@tencent.com>
 <1621339235-11131-2-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1621339235-11131-2-git-send-email-wanpengli@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 18, 2021, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> In case of under-committed scenarios, vCPU can get scheduling easily,
> kvm_vcpu_yield_to add extra overhead, we can observe a lot of race
> between vcpu->ready is true and yield fails due to p->state is
> TASK_RUNNING. Let's bail out in such scenarios by checking the length
> of current cpu runqueue, it can be treated as a hint of under-committed
> instead of guarantee of accuracy. The directed_yield_successful/attempted
> ratio can be improved from 50+% to 80+% in the under-committed scenario.

The "50+% to 80+%" comment will be a bit confusing for future readers now that
the single_task_running() case counts as an attempt.  I think the new comment
would be something like "30%+ of directed-yield attempts can avoid the expensive
lookups in kvm_sched_yield() in an under-committed scenario."  That would also
provide the real justification, as bumping the success ratio isn't the true goal
of this path.

> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> v2 -> v3:
>  * update patch description
> v1 -> v2:
>  * move the check after attempted counting
>  * update patch description
> 
>  arch/x86/kvm/x86.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9b6bca616929..dfb7c320581f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8360,6 +8360,9 @@ static void kvm_sched_yield(struct kvm_vcpu *vcpu, unsigned long dest_id)
>  
>  	vcpu->stat.directed_yield_attempted++;
>  
> +	if (single_task_running())
> +		goto no_yield;
> +
>  	rcu_read_lock();
>  	map = rcu_dereference(vcpu->kvm->arch.apic_map);
>  
> -- 
> 2.25.1
> 
