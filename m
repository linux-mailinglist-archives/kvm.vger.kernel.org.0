Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2153C237B7
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 15:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732846AbfETM5o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 08:57:44 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52815 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728898AbfETM5o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 08:57:44 -0400
Received: by mail-wm1-f66.google.com with SMTP id y3so13210216wmm.2
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 05:57:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/cC7btuFt2AEdDzbkbHKWXushngypUeTsNKBzMYMkpg=;
        b=UXnuCd+surkY7lzc/2x3pGqSDKyesVMK/WFC4xLJnUhy0V/iJJ0KCobT5sABTo23Je
         yQZtZ8BfZTcJDMAVaGqIIaTwtLxanIZXqgdaKaoyIvVgXBJZ6fqxo+T1oYh2nlZAzk2K
         NLeobXWi42U2KTuVy+au2BqZjeIM5RrfoIXNMvFPQNIPYSYTXw2IYOvmlfxzc/Bx1sQX
         ewv2wwK+RjIQFpR4EMmQk4Fqefwn7l8eABzb3Zq0HjZ8rm5/DagvzlQP0L/0xML5Wyj8
         HcYzulsxk2yPILm/AkG9+kxksQUIEFA9W05uw9Ut1UsOCKLrRn/rAG/frgi3AOuhffYT
         Tm4g==
X-Gm-Message-State: APjAAAUZ708ecRZBknKRspV01nfaWePF5nQ7un4d605DEId/lmOLq28u
        17Ig4zf9Gg59xHi2ydtKaB/5Nw==
X-Google-Smtp-Source: APXvYqyrPTmAqzgSNfgXJz7ODDv23EPVzanPE7x9kSG55+1bhyRO3S17QQKIERsc+73jklRBFRpJFA==
X-Received: by 2002:a1c:9904:: with SMTP id b4mr31141197wme.1.1558357061890;
        Mon, 20 May 2019 05:57:41 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac04:eef9:b257:b844? ([2001:b07:6468:f312:ac04:eef9:b257:b844])
        by smtp.gmail.com with ESMTPSA id h12sm12616240wrq.95.2019.05.20.05.57.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 05:57:41 -0700 (PDT)
Subject: Re: [PATCH v2] svm/avic: Allow avic_vcpu_load logic to support host
 APIC ID 255
To:     "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "graf@amazon.com" <graf@amazon.com>
References: <1557848977-146396-1-git-send-email-suravee.suthikulpanit@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <035d681a-4ec6-05fd-a93b-a1bac2bfc0fe@redhat.com>
Date:   Mon, 20 May 2019 14:57:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1557848977-146396-1-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/05/19 17:49, Suthikulpanit, Suravee wrote:
> Current logic does not allow VCPU to be loaded onto CPU with
> APIC ID 255. This should be allowed since the host physical APIC ID
> field in the AVIC Physical APIC table entry is an 8-bit value,
> and APIC ID 255 is valid in system with x2APIC enabled.
> Instead, do not allow VCPU load if the host APIC ID cannot be
> represented by an 8-bit value.
> 
> Also, use the more appropriate AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK
> instead of AVIC_MAX_PHYSICAL_ID_COUNT. 
> 
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

Queued, with Cc to stable and using "kvm: svm/avic: fix off-by-one in
checking host APIC ID" as the subject.

Paolo

> ---
> 
> Change in V2:
>   * Use AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK instead of
>     AVIC_MAX_PHYSICAL_ID_COUNT. 
> 
>  arch/x86/kvm/svm.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 687767f..345fe9e 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -2071,7 +2071,11 @@ static void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  	if (!kvm_vcpu_apicv_active(vcpu))
>  		return;
>  
> -	if (WARN_ON(h_physical_id >= AVIC_MAX_PHYSICAL_ID_COUNT))
> +	/*
> +	 * Since the host physical APIC id is 8 bits,
> +	 * we can support host APIC ID upto 255.
> +	 */
> +	if (WARN_ON(h_physical_id > AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK))
>  		return;
>  
>  	entry = READ_ONCE(*(svm->avic_physical_id_cache));
> 

