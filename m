Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35EF77BA3FD
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 18:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234423AbjJEQDV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 12:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233514AbjJEQCV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 12:02:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76CCE2728
        for <kvm@vger.kernel.org>; Thu,  5 Oct 2023 06:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696513861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xzJsIbEdC1wOEGvDx6w4HMSs5sdtsVv5hyJaAp9aFTU=;
        b=Dmt72+eq1GVZrly8ySQuKI5E4jLSD8ZWcUz8pOy+D+oxXgM9JZRuxP/odIaCIhML4ORkoz
        KxU886IRflku7oDyBFmCiAvyO51cJjnsqyUpr0fEV0KqMiB3pCJtfVkBCc+769LIXOFsw4
        JlH71pb+HKAD+jLclDu2eOWS0ZM7TjM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-471-Aq-MWV2VMMGA7zstvJHpKg-1; Thu, 05 Oct 2023 08:50:00 -0400
X-MC-Unique: Aq-MWV2VMMGA7zstvJHpKg-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3fef5403093so4890635e9.0
        for <kvm@vger.kernel.org>; Thu, 05 Oct 2023 05:50:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696510199; x=1697114999;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xzJsIbEdC1wOEGvDx6w4HMSs5sdtsVv5hyJaAp9aFTU=;
        b=fZ+8z841wYqhJBwBH5sZvrQcbboirXZ7ry5W7Fz5P8ynaLLvd5EPrJNGQOuPCVHss+
         hgSrtkAtrStki3H2IbJ23nJ/toiFSzVtcDi5mrN6bZ2ReROVcsiB2rCob4H3FpmhGj0a
         dpZo/Jl0QStnFr6X/AceSmh2pam/Eyw8frIjIMtwLR7hUDKC23hF+dFqc2XyrSxfXJ6R
         cr0CYhX1jA2TWmNSbkA3cv1aTwWZ2noNNgchNYo89vDkVt8I7UjtBbHEY0WJfq6XdXpQ
         jXXkE8wf+DiWDu6ugJLSSTzTPLXt+pbtbh2OpkzmuZXppkYAmzwcEIDWE/N69E/ZVkW2
         dveA==
X-Gm-Message-State: AOJu0YxbHj964VhGOzr9quQocdq1eVVrp0O1VKGfl0n7lrsuMeOqLDI2
        FqyfIgCyRoqZ6zSUcKBvDgy5MZV5JfP6Jx+P9NvjN+nCjpyeR2VrITejwG4+48kP08TB4vrRWYB
        2g03Nx+aUWmUo
X-Received: by 2002:a05:600c:1c96:b0:405:3622:382c with SMTP id k22-20020a05600c1c9600b004053622382cmr1352352wms.17.1696510199508;
        Thu, 05 Oct 2023 05:49:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEH/NInPYmO1UfH7A7RZ9fUuJQjy8h9hg0sJsC7opG/J+MuehyjgG03sU18g5lM4H7ISOKsIQ==
X-Received: by 2002:a05:600c:1c96:b0:405:3622:382c with SMTP id k22-20020a05600c1c9600b004053622382cmr1352337wms.17.1696510199189;
        Thu, 05 Oct 2023 05:49:59 -0700 (PDT)
Received: from starship ([89.237.100.246])
        by smtp.gmail.com with ESMTPSA id v5-20020a05600c214500b003fbe791a0e8sm1486081wml.0.2023.10.05.05.49.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Oct 2023 05:49:58 -0700 (PDT)
Message-ID: <74477cff348512fd88da8bb8fa901207fa29e316.camel@redhat.com>
Subject: Re: [PATCH 02/10] KVM: SVM: Use AVIC_HPA_MASK when initializing
 vCPU's Physical ID entry
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     kvm@vger.kernel.org, iommu@lists.linux.dev,
        linux-kernel@vger.kernel.org
Date:   Thu, 05 Oct 2023 15:49:57 +0300
In-Reply-To: <20230815213533.548732-3-seanjc@google.com>
References: <20230815213533.548732-1-seanjc@google.com>
         <20230815213533.548732-3-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

У вт, 2023-08-15 у 14:35 -0700, Sean Christopherson пише:
> Use AVIC_HPA_MASK instead of AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK when
> initializing a vCPU's Physical ID table entry, the two masks are identical.

Masks are identical, but they refer to different things. 
AVIC_HPA_MASK is about avic's fields in vmcb, while AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK
is about the portion of the physical id entry which has the address.

They are the same currently but for documentation purposes I don't understand
why removal of one of them makes sense.

IMHO, it's best to define them to the same value, e.g:

#define AVIC_HPA_MASK	GENMASK_ULL(51, 12)

#define AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK GENMASK_ULL(51, 12)

Best regards,
	Maxim Levitsky


> Keep both #defines for now, along with a few new static asserts.  A future
> change will clean up the entire mess (spoiler alert, the masks are
> pointless).
> 
> Opportunisitically move the bitwise-OR of AVIC_PHYSICAL_ID_ENTRY_VALID_MASK
> outside of the call to __sme_set(), again to pave the way for code
> deduplication.  __sme_set() is purely additive, i.e. ORing in the valid
> bit before or after the C-bit does not change the end result.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/svm.h | 2 ++
>  arch/x86/kvm/svm/avic.c    | 5 ++---
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 1e70600e84f7..609c9b596399 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -285,6 +285,8 @@ static_assert((AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == AVIC_MAX_
>  static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_MAX_PHYSICAL_ID);
>  
>  #define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
> +static_assert(AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK == AVIC_HPA_MASK);
> +static_assert(AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK == GENMASK_ULL(51, 12));
>  
>  #define SVM_SEV_FEAT_DEBUG_SWAP                        BIT(5)
>  
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 7062164e4041..442c58ef8158 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -308,9 +308,8 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
>  	if (!entry)
>  		return -EINVAL;
>  
> -	new_entry = __sme_set((page_to_phys(svm->avic_backing_page) &
> -			      AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK) |
> -			      AVIC_PHYSICAL_ID_ENTRY_VALID_MASK);
> +	new_entry = __sme_set(page_to_phys(svm->avic_backing_page) & AVIC_HPA_MASK) |
> +		    AVIC_PHYSICAL_ID_ENTRY_VALID_MASK;
>  	WRITE_ONCE(*entry, new_entry);
>  
>  	svm->avic_physical_id_cache = entry;






