Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19A1D572F31
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 09:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234329AbiGMH1v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 03:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbiGMH1p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 03:27:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5B826E304A
        for <kvm@vger.kernel.org>; Wed, 13 Jul 2022 00:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657697263;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dhZTYpLxnL2bZiylFvckcQJP6YV2ZgP2bcqRIrr9Yeg=;
        b=XskLZE+onCDJqPnvdz5ozpXtaAWU9iv5fzBs3RgR9KKSch49ozSuz6rFfU8EOP2uDA/14t
        uRfk3N4EKFxY8sFqAtHbJWAmbQBdP7YfkDsjxu3OE4MYzeU2rGDKI/3P3yym7K/y/CsbOu
        A+6dpxWq4aL5m/OTuUEBgKjuhifl0q4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-473-a1weE9MINgS_qVTVtkLiDg-1; Wed, 13 Jul 2022 03:27:42 -0400
X-MC-Unique: a1weE9MINgS_qVTVtkLiDg-1
Received: by mail-ed1-f71.google.com with SMTP id z20-20020a05640240d400b0043a82d9d65fso7719065edb.0
        for <kvm@vger.kernel.org>; Wed, 13 Jul 2022 00:27:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dhZTYpLxnL2bZiylFvckcQJP6YV2ZgP2bcqRIrr9Yeg=;
        b=dmJGYco1Lpl/LXv4uOV3IREZp4jmFFGn5lMVJRtbjdu9arrbJfOrjWa5TcA/hEDMbJ
         oC7qOG8TTlSqPyv1GelZoMR3KUXFceG+0akFWfy+Q8x4k+ijL6Qeqd9PTd6ROH7MnOAv
         aeeWYBdwzlU6E5OwpX/I6VxneTwbaoz7Rk31tx+NZStKL6JAMj4V9XvI+1Ux8er9TdXN
         NpMdNa6oYqMkR+GtlKZouEIPay0DUkde1H5sxNNCeJ7YJnrL0yeApK8YH3bACp5x1mJu
         G2TCb52KgqKbIh3qsso1/e/Vb+0okWQtWpg8UNPoH1oaQjhRZZmuQgLgy7EAyQKtVZqA
         /GNg==
X-Gm-Message-State: AJIora8p41eWPCLuUG1cjSd+UI05isH8bx/jEPsloFTIO/OABBJnQvc9
        +fPoy3rkJYxTmc6kud1a9gwWxelgqV58bcy4P71VGY3sOCQ0OJ8fC0Kul51jxK/qcLV0Ufqcm+H
        7ZWKWy217St2D
X-Received: by 2002:a17:906:604f:b0:718:e9e8:9d2a with SMTP id p15-20020a170906604f00b00718e9e89d2amr2007864ejj.315.1657697260862;
        Wed, 13 Jul 2022 00:27:40 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1viPdgz1OQQGbA5i2sFD4rjvppVT3kLlNuMm2yZyN2OpoiNndAz/uOwH0Gal0wbA7eTVo3Nmw==
X-Received: by 2002:a17:906:604f:b0:718:e9e8:9d2a with SMTP id p15-20020a170906604f00b00718e9e89d2amr2007854ejj.315.1657697260658;
        Wed, 13 Jul 2022 00:27:40 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id y25-20020a170906471900b0072b91a3d7e9sm736295ejq.28.2022.07.13.00.27.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jul 2022 00:27:40 -0700 (PDT)
Message-ID: <5610de7f-5a28-288a-b6bc-9ad7a36e27be@redhat.com>
Date:   Wed, 13 Jul 2022 09:27:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [GIT PULL] KVM/riscv fixes for 5.19, take #2
Content-Language: en-US
To:     Anup Patel <anup@brainfault.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Atish Patra <atishp@atishpatra.org>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>
References: <CAAhSdy1CAtr=mAVFtduTcED_Sjp2=4duQwgL5syxZ-sYM6SoWQ@mail.gmail.com>
 <01ec025d-fbde-5e58-2221-a368d4e1bb3a@redhat.com>
 <CAAhSdy2gR3dtBHO0Q7+1xgMCytYkJgmuT6xiQ+WQiorQPMRUXA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAAhSdy2gR3dtBHO0Q7+1xgMCytYkJgmuT6xiQ+WQiorQPMRUXA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/13/22 09:17, Anup Patel wrote:
> On Wed, Jul 13, 2022 at 11:30 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 7/13/22 07:47, Anup Patel wrote:
>>> Hi Paolo,
>>>
>>> We have two more fixes for 5.19 which were discovered recently:
>>> 1) Fix missing PAGE_PFN_MASK
>>> 2) Fix SRCU deadlock caused by kvm_riscv_check_vcpu_requests()
>>
>> Pulled, thanks.
>>
>> For the latter, my suggestion is to remove KVM_REQ_SLEEP completely and
>> key the waiting on kvm_arch_vcpu_runnable using kvm_vcpu_halt or
>> kvm_vcpu_block.
> 
> We are using KVM_REQ_SLEEP for VCPU hotplug. The secondary
> VCPUs will block until woken-up by using an SBI call from other VCPU.
> This is different from blocking on WFI where VCPU will wake-up upon
> any interrupt.

Yes, I understand.  The idea is to have something like

	if (kvm_arch_vcpu_runnable())
		vcpu_enter_guest(vcpu);
	else
		kvm_vcpu_block(vcpu);

instead of using KVM_REQ_SLEEP to enter the blocking loop.  This works 
for both WFI and hotplug, the only difference between the two cases is 
the event that changes kvm_arch_vcpu_runnable() to true.

Paolo

> I agree with your suggestion, we should definitely use kvm_vcpu_block()
> here.
> 
>>
>> Also, I only had a quick look but it seems like vcpu->arch.pause is
>> never written?
> 
> Yes, the vcpu->arch.pause is redundant. I will remove it.
> 
>>
>> Paolo
>>
> 
> Thanks,
> Anup
> 

