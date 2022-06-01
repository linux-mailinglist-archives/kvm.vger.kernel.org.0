Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D36A539FE3
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 10:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350917AbiFAIyU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 04:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237064AbiFAIyS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 04:54:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A499365406
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 01:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654073656;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LOlu3mepJdx7Wf6vk2GNDsoaWQTiVkUMcr9IDdeUKvQ=;
        b=St02Dl7TuC1Zqihg8F4tjZSQ1xjY8fH316r6AXsVY0OKbzp7+tfNvpDersJbIaKkyAgrqp
        lBQBw/3pkKtA5fD8Se6QcbEX7n/MxfLHwV29w7i3XgZg2kj/ndbmirxTMRYRgIh5e/cNPt
        h0Qb7V6cPVjOa2IsrV4NBX8lBmARwWs=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-513-ohDdA4zPNcKxf-lon0Fcow-1; Wed, 01 Jun 2022 04:54:15 -0400
X-MC-Unique: ohDdA4zPNcKxf-lon0Fcow-1
Received: by mail-ej1-f70.google.com with SMTP id gs6-20020a170906f18600b006fe7a9ffacbso604884ejb.3
        for <kvm@vger.kernel.org>; Wed, 01 Jun 2022 01:54:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LOlu3mepJdx7Wf6vk2GNDsoaWQTiVkUMcr9IDdeUKvQ=;
        b=5X5xFh0Sp3SsX2ywLfpcw6bHEx6EqqRBr2S+p5KlsEoU5QHlRO2KnE0pelGvzqU+gl
         qgPHoNFcK/a2aUyPMTMgC/qIRGuJif+UXKU+qodZPDDrPdlqv6GzHv5/TWoXK4zoFIv+
         qz76sArt4C1s1fFh8H0vBxrhqoreIpoindMDNKJ8MtGdLfdyAgGzrmNO+4cMtEHY5qmi
         EBr2WxIYIc4zhbB6BqZNibSf6X11bQKeXbPh4zc5HC4VG+BkBlHVCHM0rtD36bPgvoBP
         bAt8HWMV3BARGLpMkhtOPnqAfhOeS4H1JYRl4iLxeHxvOp6TA5F2W9NF48WdBTlpptuG
         8vGA==
X-Gm-Message-State: AOAM5305RcS+08qLL2pnhyA3tA+/vK+ATUlmjv9hR+E25nX4j7bRcfEr
        GX2A+hEr0fRa4lm9il7u1pNNyrnnEHx5Alfn+kIgXy5wAdhDUN4YpODVEzEmEoZ1zvBQqpFU5mW
        xGfSH2JDvNgJ0
X-Received: by 2002:a17:907:162a:b0:6fe:c691:47f5 with SMTP id hb42-20020a170907162a00b006fec69147f5mr5234902ejc.289.1654073654326;
        Wed, 01 Jun 2022 01:54:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzUd8lcyszMcB8ocabW8xLa9jXoH+xjNMpG4v9dw6i4KceyMi+eG7g0nhlauX9AQpKgumjrwg==
X-Received: by 2002:a17:907:162a:b0:6fe:c691:47f5 with SMTP id hb42-20020a170907162a00b006fec69147f5mr5234888ejc.289.1654073654108;
        Wed, 01 Jun 2022 01:54:14 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id g23-20020a170906595700b006f3ef214d9fsm456978ejr.5.2022.06.01.01.54.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jun 2022 01:54:13 -0700 (PDT)
Message-ID: <4b59b1c0-112b-5e07-e613-607220c3b597@redhat.com>
Date:   Wed, 1 Jun 2022 10:54:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 1/2] KVM: vmx, pmu: accept 0 for absent MSRs when
 host-initiated
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        likexu@tencent.com, Yang Weijiang <weijiang.yang@intel.com>
References: <20220531175450.295552-1-pbonzini@redhat.com>
 <20220531175450.295552-2-pbonzini@redhat.com> <YpZgU+vfjkRuHZZR@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YpZgU+vfjkRuHZZR@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/31/22 20:37, Sean Christopherson wrote:
>> +
>>   		/*
>>   		 * Writing depth MSR from guest could either setting the
>>   		 * MSR or resetting the LBR records with the side-effect.
>> @@ -535,6 +542,8 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>   	case MSR_ARCH_LBR_CTL:
>>   		if (!arch_lbr_ctl_is_valid(vcpu, data))
>>   			break;
>> +		if (!guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))
>> +			return 0;
> 
> Similar bug here.
> 
> Can we just punt this out of kvm/queue until its been properly reviewed?

Yes, I agree.  I have started making some changes and pushed the result 
to kvm/arch-lbr-for-weijiang.

Most of the MSR handling is rewritten (and untested).

The nested VMX handling was also completely broken so I just removed it. 
  Instead, KVM should be adjusted so that it does not whine.

Paolo

