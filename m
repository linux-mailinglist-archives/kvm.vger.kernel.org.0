Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86819192708
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 12:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727286AbgCYLXt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 07:23:49 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:56299 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726906AbgCYLXs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Mar 2020 07:23:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585135427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=e4Tl6bQIkr3Iqlt21YwTz/ubUb2xT3zuSMPcl5tcUSk=;
        b=BPyVJ5+e2Q4+BViJayeYCTQbCp5ncLw833K7Z8PLjr1n2ozo913nrPA1opi8NxwRzjKHHD
        Wsjtfl91vFb2w+Uaoyf6RnXf0y0Z3oZYn2GSNOPqKXAewDeRvERrueYrFt4vqwTtXL5ZWv
        VaLb/ezPWCF04Cd6S/Y9mQceCH6I+PA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-y6ymdUoiMjWYitgVPqQlIQ-1; Wed, 25 Mar 2020 07:23:46 -0400
X-MC-Unique: y6ymdUoiMjWYitgVPqQlIQ-1
Received: by mail-wr1-f69.google.com with SMTP id m15so1011503wrb.0
        for <kvm@vger.kernel.org>; Wed, 25 Mar 2020 04:23:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=e4Tl6bQIkr3Iqlt21YwTz/ubUb2xT3zuSMPcl5tcUSk=;
        b=XBEQHY9YItmuMOV+TOWms940BjGKvNY/fMGxdU6NRF/Nm8yLqwMam1v4jL+iURiQ6m
         l8szLzHgAzIlmKZTJ5Taahe9u36DH3uHY7jxSI8RYGtp38VP4PQUgfDyLNEKdtedkdHD
         D9Fs2NKn/hNYneImB5gXn/+c0fmEft1iVFSuRa1nO3m24CpKblvmU/rXqK9Djpx6Pf+Y
         u9gQJp7s5M3woM5H4S8nC6ilIcJfONjx9RFHbGGrJUU3nXRtudNgPj7Z3votDLWq2zzU
         my3Y5iO2M6qdhtY00Ronbe2L1AxINPQ6+kY5vYibGYcfMyd3zGb2KPtELX8S7IEYgxxO
         6nFg==
X-Gm-Message-State: ANhLgQ2ZklnMquUhVHT3XwH9b5oo5u5jih96BATJ2ukR/uBg/qhnXP+x
        6Aq/xWaXn945mQWal3PZrqIrY6OavnvCaBr+sHPD4dyd199IjeQCMWoTUzE3tnTsHdm1ZkaPU5T
        404kCxPYDncoS
X-Received: by 2002:adf:e70d:: with SMTP id c13mr2967972wrm.306.1585135424949;
        Wed, 25 Mar 2020 04:23:44 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsTGX8GAStTOUZFTGqunGZzqjJERoFUpumo5ctf4JSurFppaOOIPB4yfJvxqIO223aQMv6PYQ==
X-Received: by 2002:adf:e70d:: with SMTP id c13mr2967939wrm.306.1585135424694;
        Wed, 25 Mar 2020 04:23:44 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id w9sm11681078wrk.18.2020.03.25.04.23.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 04:23:44 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        John Haxby <john.haxby@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v3 17/37] KVM: SVM: Wire up ->tlb_flush_guest() directly to svm_flush_tlb()
In-Reply-To: <20200320212833.3507-18-sean.j.christopherson@intel.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com> <20200320212833.3507-18-sean.j.christopherson@intel.com>
Date:   Wed, 25 Mar 2020 12:23:42 +0100
Message-ID: <87wo7865kx.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Use svm_flush_tlb() directly for kvm_x86_ops->tlb_flush_guest() now that
> the @invalidate_gpa param to ->tlb_flush() is gone, i.e. the wrapper for
> ->tlb_flush_guest() is no longer necessary.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/svm.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 62fa45dcb6a4..dfa3b53f8437 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -5643,11 +5643,6 @@ static void svm_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t gva)
>  	invlpga(gva, svm->vmcb->control.asid);
>  }
>  
> -static void svm_flush_tlb_guest(struct kvm_vcpu *vcpu)
> -{
> -	svm_flush_tlb(vcpu);
> -}
> -
>  static void svm_prepare_guest_switch(struct kvm_vcpu *vcpu)
>  {
>  }
> @@ -7405,7 +7400,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
>  
>  	.tlb_flush = svm_flush_tlb,
>  	.tlb_flush_gva = svm_flush_tlb_gva,
> -	.tlb_flush_guest = svm_flush_tlb_guest,
> +	.tlb_flush_guest = svm_flush_tlb,
>  
>  	.run = svm_vcpu_run,
>  	.handle_exit = handle_exit,

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

