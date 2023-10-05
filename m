Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 719877BA6FE
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 18:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbjJEQok (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 12:44:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233288AbjJEQm0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 12:42:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD597469B
        for <kvm@vger.kernel.org>; Thu,  5 Oct 2023 06:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696513926;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gz/nfygGmbnXJsd+IS1AZ3tkRriknqzPVzuD8/FrAdY=;
        b=aw7E3EQ+bnFK59AZrPAoEwp8uVcX41B8GO1phZqvB4xVntMD/3zxN64oDTI+8OzFoe7zc9
        +7ZnMyxp3KtBH8LziOU3PKLkku2LUho++LoI16Tr1nKWxXuVdoO7E/nNK+94kWg+RQRobp
        I04zJ9Mh6wkkyCgUtLfjUsjAtcJuZUI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-586-kdsZBkBDPuesPouiqZ-iOQ-1; Thu, 05 Oct 2023 08:50:48 -0400
X-MC-Unique: kdsZBkBDPuesPouiqZ-iOQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4066e59840eso5624705e9.1
        for <kvm@vger.kernel.org>; Thu, 05 Oct 2023 05:50:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696510248; x=1697115048;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gz/nfygGmbnXJsd+IS1AZ3tkRriknqzPVzuD8/FrAdY=;
        b=ky/n//kOnk7uaExAyQKBX1rHdtUK03zqpKPQo8jA4sws1Y+C2qIJV3iIiQfShJTLsG
         WF0oMSytf/ErhpftHox5zgt93c14PEpH5PZ6DH1g21FPR8lU5eVsG6n303enHiJWHITv
         hq0eoofFbLv4cxxRBqNVtlzFFxqw41HDZ9wA3E1dNM3o9o2ba+FsktJB1+YdLzr8RrxU
         Tr+CHUW7uT3XuRsUmWc/7RnTJnnYj8ojtNzXotud3KYlpWVJnU1f9wbeSnPNG1b4RrJp
         gqnx5SibPPmvh+xbkpeZiuOrOJ4mVZQLNbHwIx4dkFwEXcviT+DlJu//4mli5CS7qvVl
         mXfQ==
X-Gm-Message-State: AOJu0YxP+eYRBakSdyNO1jUC+LTmRiYzBsttirnADUBR3+uI0MK8sPxw
        dGonfI8k0XKy3i32mCiY20CknM3XvNe4k/ylUvKAgMVdX7ca4n9T8lx2zEmwaxWiT5Mqj7sI1IS
        X1dTPhw7D9oII
X-Received: by 2002:a7b:cbd5:0:b0:3ff:ca80:eda3 with SMTP id n21-20020a7bcbd5000000b003ffca80eda3mr4776376wmi.10.1696510247889;
        Thu, 05 Oct 2023 05:50:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE/SJNiXj3XatMAFFcAo+yGfpoct1qUkwh1sePQUc9yGeKWgR2qxGA7p6oIQPZObYy145GAeA==
X-Received: by 2002:a7b:cbd5:0:b0:3ff:ca80:eda3 with SMTP id n21-20020a7bcbd5000000b003ffca80eda3mr4776365wmi.10.1696510247529;
        Thu, 05 Oct 2023 05:50:47 -0700 (PDT)
Received: from starship ([89.237.100.246])
        by smtp.gmail.com with ESMTPSA id c11-20020a7bc84b000000b0040648217f4fsm3706589wml.39.2023.10.05.05.50.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Oct 2023 05:50:47 -0700 (PDT)
Message-ID: <4ae1b1aeae6662c56c982c916e550ddcd8543aa7.camel@redhat.com>
Subject: Re: [PATCH 06/10] iommu/amd: KVM: SVM: Use pi_desc_addr to derive
 ga_root_ptr
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     kvm@vger.kernel.org, iommu@lists.linux.dev,
        linux-kernel@vger.kernel.org
Date:   Thu, 05 Oct 2023 15:50:45 +0300
In-Reply-To: <20230815213533.548732-7-seanjc@google.com>
References: <20230815213533.548732-1-seanjc@google.com>
         <20230815213533.548732-7-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

У вт, 2023-08-15 у 14:35 -0700, Sean Christopherson пише:
> Use vcpu_data.pi_desc_addr instead of amd_iommu_pi_data.base to get the
> GA root pointer.  KVM is the only source of amd_iommu_pi_data.base, and
> KVM's one and only path for writing amd_iommu_pi_data.base computes the
> exact same value for vcpu_data.pi_desc_addr and amd_iommu_pi_data.base,
> and fills amd_iommu_pi_data.base if and only if vcpu_data.pi_desc_addr is
> valid, i.e. amd_iommu_pi_data.base is fully redundant.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/avic.c   | 1 -
>  drivers/iommu/amd/iommu.c | 2 +-
>  include/linux/amd-iommu.h | 1 -
>  3 files changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index e49b682c8469..bd81e3517838 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -919,7 +919,6 @@ int avic_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
>  			struct amd_iommu_pi_data pi;
>  
>  			/* Try to enable guest_mode in IRTE */
> -			pi.base = avic_get_backing_page_address(svm);
>  			pi.ga_tag = AVIC_GATAG(to_kvm_svm(kvm)->avic_vm_id,
>  						     svm->vcpu.vcpu_id);
>  			pi.is_guest_mode = true;
> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index c3b58a8389b9..9814df73b9a7 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -3622,7 +3622,7 @@ static int amd_ir_set_vcpu_affinity(struct irq_data *data, void *vcpu_info)
>  
>  	pi_data->prev_ga_tag = ir_data->cached_ga_tag;
>  	if (pi_data->is_guest_mode) {
> -		ir_data->ga_root_ptr = (pi_data->base >> 12);
> +		ir_data->ga_root_ptr = (vcpu_pi_info->pi_desc_addr >> 12);
>  		ir_data->ga_vector = vcpu_pi_info->vector;
>  		ir_data->ga_tag = pi_data->ga_tag;
>  		ret = amd_iommu_activate_guest_mode(ir_data);
> diff --git a/include/linux/amd-iommu.h b/include/linux/amd-iommu.h
> index 953e6f12fa1c..30d19ad0e8a9 100644
> --- a/include/linux/amd-iommu.h
> +++ b/include/linux/amd-iommu.h
> @@ -20,7 +20,6 @@ struct amd_iommu;
>  struct amd_iommu_pi_data {
>  	u32 ga_tag;
>  	u32 prev_ga_tag;
> -	u64 base;

I think that a comment describing where the base address of the apic register page is taken now is needed, 
because before your patch the 'amd_iommu_pi_data' was self documenting, since it had all the info 
about the PI remap entry, but now it doesn't.


>  	bool is_guest_mode;
>  	struct vcpu_data *vcpu_data;
>  	void *ir_data;


Best regards,
	Maxim Levitsky





