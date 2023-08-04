Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4DD770B04
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 23:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbjHDVdG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 17:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjHDVdF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 17:33:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0B71106
        for <kvm@vger.kernel.org>; Fri,  4 Aug 2023 14:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691184726;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jsp+Oyf0Baezc7axDt6/bPm0q6CNC13RmuEqpircFIc=;
        b=eQ1CN1+hlyxE0Z392I/FBq/NtQxfjnoVaDAv9Gp0stNsM3xEAKTsbbdgN4DHrPbFd2L6gZ
        hJs3xxovktIyB1wC6PzkFr7oi1zG39tJhkyxpvztUvP6B56sjV/b2LiNYYX32jI2/0a14F
        5EVQK2iZRBlRudzSh+F0UygXpW/uipw=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-61-V_e-ZD9TMlmDQ9wtU87ktA-1; Fri, 04 Aug 2023 17:32:05 -0400
X-MC-Unique: V_e-ZD9TMlmDQ9wtU87ktA-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-99c20561244so164278666b.0
        for <kvm@vger.kernel.org>; Fri, 04 Aug 2023 14:32:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691184724; x=1691789524;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jsp+Oyf0Baezc7axDt6/bPm0q6CNC13RmuEqpircFIc=;
        b=eNHGO8jl3owWg4c9SaUNBoxWqTdww0BMClJjJKZFz+43sgq5rnHSb+/nrmISPzDMnG
         rC1854bDJrfNNQiEfQRhqq5i5nuJj+jbkO6aXq3sa3sveydHlWXcLoi2GOC8I4cviPdQ
         FLIjRypEb0tSJby2AewCJ37H6Z/DdsMUKGhORXI8HjjugZkUwIjfAmljF/DneqIJCAqd
         V3UwpvfkeiOJE2jpbdvlmIKn4FQpqCmvk1k+BW/KAqqlfoPRXz96L6zWFtYW+NyCkU46
         AjOL3ILXg4469SlRTJPW4Tm0D3WmHgnvUhROWJL+tRmATgH5WfN2shGlKAQ/FMte6VUk
         w1Ug==
X-Gm-Message-State: AOJu0YyAyHb0PNsRet6hYOWIxzifeV25vmmCinzYsPJXG/HViGZevvB9
        2DDMxDhWu2vD/jUdzLjtde8+h3fdJBip4le4cYuU5iO1rMcINaHdq4/r76u9yTsKBU5ISRT1F4i
        Y1yeCgwryXpPD
X-Received: by 2002:a17:907:7889:b0:99b:e9f7:b073 with SMTP id ku9-20020a170907788900b0099be9f7b073mr2575445ejc.14.1691184724516;
        Fri, 04 Aug 2023 14:32:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEWt2syOHlzHD6ARM4KUNFAe32BTGiIlpiMe8fKvmzqTN1a2R95tNA2BXWBnrckbYiLw5ywLA==
X-Received: by 2002:a17:907:7889:b0:99b:e9f7:b073 with SMTP id ku9-20020a170907788900b0099be9f7b073mr2575433ejc.14.1691184724194;
        Fri, 04 Aug 2023 14:32:04 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id lr4-20020a170906fb8400b0098748422178sm1811787ejb.56.2023.08.04.14.32.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Aug 2023 14:32:03 -0700 (PDT)
Message-ID: <cf97cfba-941a-5a77-6591-fa84ef6fe8d1@redhat.com>
Date:   Fri, 4 Aug 2023 23:32:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Weijiang Yang <weijiang.yang@intel.com>
Cc:     Chao Gao <chao.gao@intel.com>, peterz@infradead.org,
        john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rick.p.edgecombe@intel.com,
        binbin.wu@linux.intel.com
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-10-weijiang.yang@intel.com>
 <ZMuMN/8Qa1sjJR/n@chao-email>
 <bfc0b3cb-c17a-0ad6-6378-0c4e38f23024@intel.com>
 <ZM1jV3UPL0AMpVDI@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v5 09/19] KVM:x86: Make guest supervisor states as
 non-XSAVE managed
In-Reply-To: <ZM1jV3UPL0AMpVDI@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/4/23 22:45, Sean Christopherson wrote:
>>>> +void save_cet_supervisor_ssp(struct kvm_vcpu *vcpu)
>>>> +{
>>>> +	if (unlikely(guest_can_use(vcpu, X86_FEATURE_SHSTK))) {
> Drop the unlikely, KVM should not speculate on the guest configuration or underlying
> hardware.

In general unlikely() can still be a good idea if you have a fast path 
vs. a slow path; the extra cost of a branch will be much more visible on 
the fast path.  That said the compiler should already be doing that.

>  the Pros:
>   - Super easy to implement for KVM.
>   - Automatically avoids saving and restoring this data when the vmexit
>     is handled within KVM.
>
>  the Cons:
>   - Unnecessarily restores XFEATURE_CET_KERNEL when switching to
>     non-KVM task's userspace.
>   - Forces allocating space for this state on all tasks, whether or not
>     they use KVM, and with likely zero users today and the near future.
>   - Complicates the FPU optimization thinking by including things that
>     can have no affect on userspace in the FPU

I'm not sure if Linux will ever use XFEATURE_CET_KERNEL.  Linux does not 
use MSR_IA32_PL{1,2}_SSP; MSR_IA32_PL0_SSP probably would be per-CPU but 
it is not used while in ring 0 (except for SETSSBSY) and the restore can 
be delayed until return to userspace.  It is not unlike the SYSCALL MSRs.

So I would treat the bit similar to the dynamic features even if it's 
not guarded by XFD, for example

#define XFEATURE_MASK_USER_DYNAMIC XFEATURE_MASK_XTILE_DATA
#define XFEATURE_MASK_USER_OPTIONAL \
	(XFEATURE_MASK_DYNAMIC | XFEATURE_MASK_CET_KERNEL)

where XFEATURE_MASK_USER_DYNAMIC is used for xfd-related tasks but 
everything else uses XFEATURE_MASK_USER_OPTIONAL.

Then you'd enable the feature by hand when allocating the guest fpstate.

> Especially because another big negative is that not utilizing XSTATE bleeds into
> KVM's ABI.  Userspace has to be told to manually save+restore MSRs instead of just
> letting KVM_{G,S}ET_XSAVE handle the state.  And that will create a bit of a
> snafu if Linux does gain support for SSS.

I don't think this matters, we don't have any MSRs in KVM_GET/SET_XSAVE 
and in fact we can't even add them since the uABI uses the non-compacted 
format.  MSRs should be retrieved and set via KVM_GET/SET_MSR and 
userspace will learn about the index automatically via 
KVM_GET_MSR_INDEX_LIST.

Paolo

