Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA2F5EDBF4
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 13:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233581AbiI1Ll6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 07:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233571AbiI1Lly (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 07:41:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B3A32047
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 04:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664365312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XC67SJ3XDTOlROMlv59qhDGypCtFKH7Px8QsqpEz0sM=;
        b=bbmsEgGEYVUVPoc3IVGjgNjFF7HSznzlxlpqPgYdxE0pDn4X4zzcnqBtSSqYXRAjv4Ed05
        QTw/gzR1dm5G/FILbT9UyjVvpqCEgXPwgimWixydwgFJDOw1XHvvsuswXVu+hGrelUjwHJ
        pCuWfJeeNVnHuproqWDTS5efI9aTCYM=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-563-Pb4SEeHwPQGZbPEdYihUZA-1; Wed, 28 Sep 2022 07:41:51 -0400
X-MC-Unique: Pb4SEeHwPQGZbPEdYihUZA-1
Received: by mail-ej1-f71.google.com with SMTP id hr29-20020a1709073f9d00b0078333782c48so4389783ejc.10
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 04:41:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=XC67SJ3XDTOlROMlv59qhDGypCtFKH7Px8QsqpEz0sM=;
        b=4NikULibB8LLV54tn30R9r4CPQyom1Gj6LM2whbgld2AAzdmS7gnBIdTpwmyjvBSVb
         TlaasioH+QZE3w1aEsIpC5xSi0rNk8RmfvC9iuB8JSIawqitRW88L6nhylVPpAQfHlx6
         EFPtN3OAdsUqzdHHOYw54qEPEPfTlUSu1K2NHcJhO+hFH6UnBTy1BROVjcTdsqgBxQ4s
         y9dk5q9YMCs2bXBMordsNL/zLx2PQUmZITDoOShiEGQAhtPEnjeY+387BNRSFgBmsmh9
         33Q3UjentUSmJYzWCrszs7lViah2JD9UuYVBtd6Jv3QqR+IoRDcUUuENZBdWMoCG8fl1
         z6hA==
X-Gm-Message-State: ACrzQf1+RdazEqfeRnEsNwPK8OtQdfYMLyviqUyEbDfqhc4HRmouAiW0
        QxPYQhxLfTYyyCz+zwh6h9dNKR32YdZYk8PnAa6I9P2eGQ3cVWrk7DfEOjOFDuhvnmAZWBhVCHP
        eLu9ZQUlsfFV1
X-Received: by 2002:a17:907:9807:b0:781:feee:f87c with SMTP id ji7-20020a170907980700b00781feeef87cmr27477175ejc.101.1664365309437;
        Wed, 28 Sep 2022 04:41:49 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM68sNi9SdtuWqttYMynS5Szr9EoGEJaZpf4gaxO8d/kIpewfaCdOMKBYdCWPnt+ufOi8mpHlw==
X-Received: by 2002:a17:907:9807:b0:781:feee:f87c with SMTP id ji7-20020a170907980700b00781feeef87cmr27477157ejc.101.1664365309143;
        Wed, 28 Sep 2022 04:41:49 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:2f4b:62da:3159:e077? ([2001:b07:6468:f312:2f4b:62da:3159:e077])
        by smtp.googlemail.com with ESMTPSA id gh30-20020a1709073c1e00b0077a11b79b9bsm2236165ejc.133.2022.09.28.04.41.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 04:41:48 -0700 (PDT)
Message-ID: <f708d769-5d93-351f-ea24-8fa7deb9f689@redhat.com>
Date:   Wed, 28 Sep 2022 13:41:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20220927152241.194900-1-pbonzini@redhat.com>
 <YzM55hqavzENQq7I@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: allow compiling out SMM support
In-Reply-To: <YzM55hqavzENQq7I@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/27/22 19:59, Sean Christopherson wrote:
>> 	The patch isn't pretty.  I could skip all the changes to add WARNs
>> 	to called functions, but the point of adding the config symbol is
>> 	to make sure that those functions, and all the baggage they bring,
>> 	are dead.
> 
> I would much rather we go even further and completely kill off those functions
> at compile time.

Ok, but then we should go all the way and move as much as possible to a 
separate file.  This also means moving the out-of-SMM flow away from the 
emulator, which in turn enables using ctxt only for the GPRs and not for 
ctxt->ops.

I have already done all that and it's quite a bit nicer; I'll send it 
once I've tested it with more than just smm_test.  I left a couple stubs 
behind where the balance seemed to be better that way (mostly for use in 
kvm_vcpu_ioctl_x86_set_vcpu_events), but most of the code is compiled out.

> There are side effects that should also be eliminated, e.g. x86 should not define
> __KVM_VCPU_MULTIPLE_ADDRESS_SPACE so that usersepace can't create memslots for
> SMM.  Dropping the functions entirely wrapping those #defines in #ifdef as well,
> and so makes it all but impossible for KVM to do anything SMM related.
> 
> Eliminating those at compile time requires a bit more #ifdeffery, but it's not
> awful, and IMO it's better than sprinkling WARNs in a bunch of paths.  KVM_REQ_SMI
> in particular might be going too far, but even for that one I vote to kill it.

Sounds good, though of course some of the various cleanups are best done 
in separate patches.

>>  static int kvm_vcpu_ioctl_smi(struct kvm_vcpu *vcpu)
>>  {
>> -	kvm_make_request(KVM_REQ_SMI, vcpu);
>> -
>> +	if (IS_ENABLED(CONFIG_KVM_SMM))
>> +		kvm_make_request(KVM_REQ_SMI, vcpu);
>>  	return 0;
> 
> This should return -EINVAL, not 0.

I'm a bit wary of changing this in case userspace is relying on it not 
failing, because the paths that lead to the failing ioctl are most 
likely controlled by the guest.

Paolo

