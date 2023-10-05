Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0BE07BA3F8
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 18:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234257AbjJEQDT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 12:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234238AbjJEQCV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 12:02:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C3D730F0
        for <kvm@vger.kernel.org>; Thu,  5 Oct 2023 06:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696513875;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rHlDcpYqvRVbBwfdymZ9aLtHILbpbHaMo9iVj1JrDzc=;
        b=gQ0z959sConFIVpmjA999kDsPnFsebZ556fbZN2CAZZz0Htchr1vnXNOLyupKrJ30ay0yY
        h7RMIgnlcGLLrzabZwbe/QLcluLVJzyG9ltWaiWssgcL+5xpj/1whxBmhhX46zoLgorfbD
        Y4s9r+BUyK788ZD7n7zA7+ytvBpN/to=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-693-8IFCELs7MwmyItGp7dSWNA-1; Thu, 05 Oct 2023 08:49:52 -0400
X-MC-Unique: 8IFCELs7MwmyItGp7dSWNA-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-40590e6bd67so6418525e9.2
        for <kvm@vger.kernel.org>; Thu, 05 Oct 2023 05:49:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696510192; x=1697114992;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rHlDcpYqvRVbBwfdymZ9aLtHILbpbHaMo9iVj1JrDzc=;
        b=L3o/GXDalrRyV0YzTD41BKnTwz6QWbwr5cFGzW/5Zg2Z++YCr7tYUaRqDY/b3SJpCa
         WQm6rLk8pVYrtF3TMbscJ7izMM6vIEkjlMXlsYkeZVzNKafwDhW2KlZeCbWsUc9ucaqj
         b23YngzrczeyXbxUcQXko2cIzcEsBSzg+pm8lOi7DRmW+KxQflpSLsSQ3lbtlfvXaycD
         x1Jj3Fy6QtXP2B9SqCbpoaiy0F8lMNr9JQ+L9vMrl7yl+1rs+xCU2gk0nAdVk23MNxU8
         sC8Usq13mqB2/f/DG9rjjTRiNILW2cakWZb5XfuuXmgjp0cu+SdH1BfU7Bp3bEoRMYfn
         t/BA==
X-Gm-Message-State: AOJu0YxLYcuypw5T98HEfKOnD6IFR02ID9N8TYFmbQ8OMG7JY3LjWovp
        eBa9duSiGmlOVfkj/msygzvLE92SJLZCALakT5qdA3BmMqZqWIChiKWUsDAdNFVU/M8q/ljkDKd
        I0HZGhttJAFYR
X-Received: by 2002:adf:d0cc:0:b0:325:1a1:1052 with SMTP id z12-20020adfd0cc000000b0032501a11052mr5064650wrh.29.1696510191838;
        Thu, 05 Oct 2023 05:49:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGZHJVnS3AX4sTAeuTlcu+imxj8xColT0TARU2HpMGu+8c9DPPYsxChjGTAZorisoDDrTSayw==
X-Received: by 2002:adf:d0cc:0:b0:325:1a1:1052 with SMTP id z12-20020adfd0cc000000b0032501a11052mr5064632wrh.29.1696510191545;
        Thu, 05 Oct 2023 05:49:51 -0700 (PDT)
Received: from starship ([89.237.100.246])
        by smtp.gmail.com with ESMTPSA id y8-20020a7bcd88000000b00406447b798bsm3709768wmj.37.2023.10.05.05.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Oct 2023 05:49:51 -0700 (PDT)
Message-ID: <8dfb288e02cdd34e777061e725a5da55ebec6cf1.camel@redhat.com>
Subject: Re: [PATCH 01/10] KVM: SVM: Drop pointless masking of default APIC
 base when setting V_APIC_BAR
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     kvm@vger.kernel.org, iommu@lists.linux.dev,
        linux-kernel@vger.kernel.org
Date:   Thu, 05 Oct 2023 15:49:49 +0300
In-Reply-To: <20230815213533.548732-2-seanjc@google.com>
References: <20230815213533.548732-1-seanjc@google.com>
         <20230815213533.548732-2-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

У вт, 2023-08-15 у 14:35 -0700, Sean Christopherson пише:
> Drop VMCB_AVIC_APIC_BAR_MASK, it's just a regurgitation of the maximum
> theoretical 4KiB-aligned physical address, i.e. is not novel in any way,
> and its only usage is to mask the default APIC base, which is 4KiB aligned
> and (obviously) a legal physical address.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/svm.h | 2 --
>  arch/x86/kvm/svm/avic.c    | 2 +-
>  2 files changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 72ebd5e4e975..1e70600e84f7 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -257,8 +257,6 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
>  
>  #define AVIC_DOORBELL_PHYSICAL_ID_MASK			GENMASK_ULL(11, 0)
>  
> -#define VMCB_AVIC_APIC_BAR_MASK				0xFFFFFFFFFF000ULL

While this mask is indeed not needed now because AVIC doesn't support non default APIC base,
this mask will be needed in my upcoming nested AVIC support, because nested hypervisor can
ask for any apic base it wishes for.

> -
>  #define AVIC_UNACCEL_ACCESS_WRITE_MASK		1
>  #define AVIC_UNACCEL_ACCESS_OFFSET_MASK		0xFF0
>  #define AVIC_UNACCEL_ACCESS_VECTOR_MASK		0xFFFFFFFF
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index cfc8ab773025..7062164e4041 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -251,7 +251,7 @@ void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb)
>  	vmcb->control.avic_backing_page = bpa & AVIC_HPA_MASK;
>  	vmcb->control.avic_logical_id = lpa & AVIC_HPA_MASK;
>  	vmcb->control.avic_physical_id = ppa & AVIC_HPA_MASK;
> -	vmcb->control.avic_vapic_bar = APIC_DEFAULT_PHYS_BASE & VMCB_AVIC_APIC_BAR_MASK;
> +	vmcb->control.avic_vapic_bar = APIC_DEFAULT_PHYS_BASE;

Here I agree that the '&' is functionally pointless, 
although I am not sure that removing it makes the code more readable.


Best regards,
	Maxim Levitsky

>  
>  	if (kvm_apicv_activated(svm->vcpu.kvm))
>  		avic_activate_vmcb(svm);





