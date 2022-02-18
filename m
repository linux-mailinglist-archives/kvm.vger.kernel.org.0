Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76C824BB5BF
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 10:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233656AbiBRJjv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 04:39:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232295AbiBRJjt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 04:39:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 49FA6340CA
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 01:39:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645177172;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Obp/3P/YntHm9ocFl4YwHP5HJm8oyeC8MIRC6l9Ax8s=;
        b=NEUbGfnINLeGSSDDx4Huea4NygYbdaGYCe2tFHJe1bYZax3Ic+vgtYX5AUrLbCFyXaoDFO
        6B1GcmWn0OBsIxRXt+9MyNIVcA5pkzN/H9BimzDkFugrx1svtVLQpxFufttfKmlEe6QqmY
        02l4T9roMT9aopnaTggISt2yP59+O+k=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-271-oJfQ9NfQPOi33aWqPkBeVg-1; Fri, 18 Feb 2022 04:39:30 -0500
X-MC-Unique: oJfQ9NfQPOi33aWqPkBeVg-1
Received: by mail-ej1-f69.google.com with SMTP id sa22-20020a1709076d1600b006ce78cacb85so2809107ejc.2
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 01:39:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=Obp/3P/YntHm9ocFl4YwHP5HJm8oyeC8MIRC6l9Ax8s=;
        b=0T35/34KzvncBy8daALdtky8h5PiEZ/ZJVZAXfmyMMaoGTsm8opytZMNCnEDrQxbPU
         KKZJJ1X/0/UfEyQlQ4fEJzFb2elq1KxnzMRuNi9B2GHKy/PHziQwd6beIi31r+TxoUGO
         IQbRtnlpS3QQjXJdMAdDb4OraJGx1rlMy8Dp4BEHgLenyHNOMnY/gZDmDOm/7T+qRdgZ
         hwxRdWpgy5lN6ix+LcJmxY9GcHYdGG8EMH++X8omVL3KQxDx/PbjpabqRHbVqBm+8aT8
         0GXAhKK8TEI57SYyVvSrn2Lm+KV2SIMqpQ8UksmYdmCrxJ7CMiHOUc9mxl2YRkJX6yvV
         iefQ==
X-Gm-Message-State: AOAM532CAZ0GVW1EUw9u5bqmrk82UH3mm9ykBCCCrFkfMM+FGGPf+n4l
        jVGl2EThT01yRgBmLotH8OnYz5BfwmQVIfLeM7+IYojHs8dKw6xswgnh9K2O/JrLMgLTz2B94Rr
        eunYedSvmEMn+
X-Received: by 2002:a17:906:b348:b0:6cf:8cfe:d729 with SMTP id cd8-20020a170906b34800b006cf8cfed729mr5829788ejb.622.1645177169738;
        Fri, 18 Feb 2022 01:39:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzsQgeByHWmzavyroqAH+uOkZX2kTCEu6+B9SI3r3i/w0xANhQwhSTELVFDuaiU5za1cf6+mA==
X-Received: by 2002:a17:906:b348:b0:6cf:8cfe:d729 with SMTP id cd8-20020a170906b34800b006cf8cfed729mr5829773ejb.622.1645177169472;
        Fri, 18 Feb 2022 01:39:29 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id m17sm4698742edc.2.2022.02.18.01.39.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Feb 2022 01:39:28 -0800 (PST)
Message-ID: <ae3002da-e931-1e08-7a23-8cd296bf8313@redhat.com>
Date:   Fri, 18 Feb 2022 10:39:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 15/18] KVM: x86/mmu: rename kvm_mmu_new_pgd, introduce
 variant that calls get_guest_pgd
Content-Language: en-US
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
References: <20220217210340.312449-1-pbonzini@redhat.com>
 <20220217210340.312449-16-pbonzini@redhat.com>
In-Reply-To: <20220217210340.312449-16-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/17/22 22:03, Paolo Bonzini wrote:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index adcee7c305ca..9800c8883a48 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1189,7 +1189,7 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
>   		return 1;
>   
>   	if (cr3 != kvm_read_cr3(vcpu))
> -		kvm_mmu_new_pgd(vcpu, cr3);
> +		kvm_mmu_update_root(vcpu);
>   
>   	vcpu->arch.cr3 = cr3;
>   	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);

Uh-oh, this has to become:

  	vcpu->arch.cr3 = cr3;
  	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
	if (!is_pae_paging(vcpu))
		kvm_mmu_update_root(vcpu);

The regression would go away after patch 16, but this is more tidy apart
from having to check is_pae_paging *again*.

Incremental patch:

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index adcee7c305ca..0085e9fba372 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1188,11 +1189,11 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
  	if (is_pae_paging(vcpu) && !load_pdptrs(vcpu, cr3))
  		return 1;
  
-	if (cr3 != kvm_read_cr3(vcpu))
-		kvm_mmu_update_root(vcpu);
-
  	vcpu->arch.cr3 = cr3;
  	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
+	if (!is_pae_paging(vcpu))
+		kvm_mmu_update_root(vcpu);
+
  	/* Do not call post_set_cr3, we do not get here for confidential guests.  */
  

An alternative is to move the vcpu->arch.cr3 update in load_pdptrs.
Reviewers, let me know if you prefer that, then I'll send v3.

Paolo

