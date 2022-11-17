Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E50A062E159
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 17:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239685AbiKQQRm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 11:17:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238685AbiKQQRi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 11:17:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43ED078D76
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 08:16:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668701798;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u3PWRpS+bffTLYuv/Qxx9GsRiKqhW7HNhUb6XRLSH4M=;
        b=H3bTz4/Qde3lCJt7HD3He0/ZmO6zYMnAgube6nju061qRn4ElHxZPRQ2hvb+v3UuVpPoQk
        ZxbxUpr9tMN5qh1QYdbb3F5+Fq+pVhFL0xitdt67YnPA9UrvqBuRUa4ubV/w+XwdwjDxoC
        E8LvsptgizAVwmqrkjO5bkEajkH2b+Q=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-288-Ty5rg3ZvNnSUX70ZlpV54w-1; Thu, 17 Nov 2022 11:16:36 -0500
X-MC-Unique: Ty5rg3ZvNnSUX70ZlpV54w-1
Received: by mail-ed1-f72.google.com with SMTP id f20-20020a0564021e9400b00461ea0ce17cso1525238edf.16
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 08:16:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u3PWRpS+bffTLYuv/Qxx9GsRiKqhW7HNhUb6XRLSH4M=;
        b=1qfdhz4VgkB3twCxNUYdj2Za7jgV3ppRmVRdcFSmuz8QxK5x81fIZAQZy/kr7JNXKu
         i8udPxbnG7G4eZtFStHA5oXd83l+VtOzwcbLwezcNNDY50VbsvV3v8IoWzOqkhcC5XSd
         xn/CvBdZ7fh4vvUd/TLzEPfQ9rFosgWOIswBP9Ui4Rlwzg3vzqP40D4qryOaLi4AlqWD
         GZ88V2zjmr9QPU2e1lQQZRbrAXXITOS9tevv6zUVO0dOrdJogCGWeIOljHGyG2yV9y7g
         bn7wwCUlfL2S1doGN46bRQF/VEfcRVLYfRaCX1qwk01Tm98oBFzxAXrejV0t96/Z6rGT
         5www==
X-Gm-Message-State: ANoB5pmOkgbBUu2FEPs+EsdaenXiE9YrGwthPzbiKBBp7PaN7AFiryib
        3bXOsEPg+Ihvl2Ajkgz4lFtZfqIlT3D4EJzNfYDGgDIZ88fAD/xNSaENqFED2Qrug11paf/7/dZ
        wFifHYwvj+kH3
X-Received: by 2002:a05:6402:399a:b0:468:fdf2:477f with SMTP id fk26-20020a056402399a00b00468fdf2477fmr572902edb.329.1668701795548;
        Thu, 17 Nov 2022 08:16:35 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5BebFRdEI64VE5TiIPR970/txnWP2TLCSmBzu5qu5cuhFtPIOf+DVszVQe760Cp6h1pMK2Eg==
X-Received: by 2002:a05:6402:399a:b0:468:fdf2:477f with SMTP id fk26-20020a056402399a00b00468fdf2477fmr572884edb.329.1668701795302;
        Thu, 17 Nov 2022 08:16:35 -0800 (PST)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id p13-20020a17090653cd00b007ade5cc6e7asm557007ejo.39.2022.11.17.08.16.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Nov 2022 08:16:34 -0800 (PST)
Message-ID: <4f0153bc-d565-f5b1-064d-4f881c56c232@redhat.com>
Date:   Thu, 17 Nov 2022 17:16:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v3 2/2] KVM: x86/mmu: Split huge pages mapped by the TDP
 MMU on fault
Content-Language: en-US
To:     Robert Hoo <robert.hu@linux.intel.com>,
        David Matlack <dmatlack@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        Mingwei Zhang <mizhang@google.com>
References: <20221109185905.486172-1-dmatlack@google.com>
 <20221109185905.486172-3-dmatlack@google.com>
 <3f5459350a091e13093691584fd974d2ab86b844.camel@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <3f5459350a091e13093691584fd974d2ab86b844.camel@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/17/22 01:59, Robert Hoo wrote:
> After break out, it immediately checks is_removed_spte(iter.old_spte)
> and return, why not return here directly to avoid duplicated check and
> another branch prediction?
> 
> 	/*
> 	 * Force the guest to retry the access if the upper level SPTEs
> aren't
> 	 * in place, or if the target leaf SPTE is frozen by another
> CPU.
> 	 */
> 	if (iter.level != fault->goal_level ||
> is_removed_spte(iter.old_spte)) {
> 		rcu_read_unlock();
> 		return RET_PF_RETRY;
> 	}

Good idea, more for readability than for efficiency.  Another small 
issue in David's patch is that

> +		if (is_shadow_present_pte(iter.old_spte))
> +			ret = tdp_mmu_split_huge_page(kvm, &iter, sp, true);
> +		else
> +			ret = tdp_mmu_link_sp(kvm, &iter, sp, true);

is assigning a 0/-EBUSY return value to ret, rather than RET_PF_* that 
is assigned everywhere else in the function.

I sent a small patch to rectify both.

Paolo

