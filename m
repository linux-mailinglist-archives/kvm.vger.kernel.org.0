Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB6BC455F37
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 16:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231694AbhKRPVs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 10:21:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39693 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229583AbhKRPVs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 10:21:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637248727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=INCjZFk/dRFHQEXGl4wGgmHmqgk0czQ/SLR2ImWk3XM=;
        b=aYwAm3UX4UFueMxjpsVkf+9OUgM2bwAgpKFHvXYjcq4fivTRw6dhSq1ssp//22N0vmag2F
        LrgF3nhonNj0Ukay+ukBEqc6hXT7bg3sIyglOLqeK4glZbdUUfhTw6fNmcFZnXV/0ZqOMU
        vbofYOBEyJaYtxBIH1yZZkialbBJ1ZY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-490-1xSqo1LAOAetmjP36VnSVA-1; Thu, 18 Nov 2021 10:18:43 -0500
X-MC-Unique: 1xSqo1LAOAetmjP36VnSVA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 353228042E6;
        Thu, 18 Nov 2021 15:18:41 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 83E841048129;
        Thu, 18 Nov 2021 15:17:57 +0000 (UTC)
Message-ID: <bf732349-b7b3-ff4e-d6a4-b9755d26e378@redhat.com>
Date:   Thu, 18 Nov 2021 16:17:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 09/15] KVM: SVM: Remove the unneeded code to mark
 available for CR3
Content-Language: en-US
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
References: <20211108124407.12187-1-jiangshanlai@gmail.com>
 <20211108124407.12187-10-jiangshanlai@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211108124407.12187-10-jiangshanlai@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/8/21 13:44, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> VCPU_EXREG_CR3 is never cleared from vcpu->arch.regs_avail in SVM so
> marking available for CR3 is mere an NOP, just remove it.
> 
> And it is not required to mark it dirty since VCPU_EXREG_CR3 is neither
> never cleared from vcpu->arch.regs_dirty and SVM doesn't use the dirty
> information of VCPU_EXREG_CR3.
> 
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> ---
>   arch/x86/kvm/svm/nested.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 13a58722e097..2d88ff584d61 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -444,7 +444,6 @@ static int nested_svm_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
>   		kvm_mmu_new_pgd(vcpu, cr3);
>   
>   	vcpu->arch.cr3 = cr3;
> -	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
>   
>   	/* Re-initialize the MMU, e.g. to pick up CR4 MMU role changes. */
>   	kvm_init_mmu(vcpu);
> 

These two patches can be merged, I think, with a commit message like

     VCPU_EXREG_CR3 is never cleared from vcpu->arch.regs_avail or
     vcpu->arch.regs_dirty in SVM; therefore, marking CR3 as available is
     merely a NOP, and testing it will likewise always succeed.

Paolo

