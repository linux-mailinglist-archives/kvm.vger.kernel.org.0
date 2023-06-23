Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DCEA73BC4A
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 18:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbjFWQEV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 12:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232148AbjFWQES (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 12:04:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F101B2129
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 09:03:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687536212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yGvZEb4xaeTCLlMZCHf/6JLvoihCjh5MngBavGT5bMs=;
        b=hebThoFVssVWal5BmTqgX2CadqGwV5AYWB94KAYQfy6yeRKZNk3oXOgKQUXxRJRIBero0I
        vPj60snqmHpkRWhlndrAunUD9QzaPj3kpznAESLU6l4aCzfdaMj4wul+y/0JXKif4GUMal
        polxFw6Bf08hipuy0fCtqsIBST60LDk=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-22-fry1v29TM7OrYJ1JZAIZ5w-1; Fri, 23 Jun 2023 12:03:30 -0400
X-MC-Unique: fry1v29TM7OrYJ1JZAIZ5w-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-4f863fcc56aso613305e87.1
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 09:03:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687536207; x=1690128207;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yGvZEb4xaeTCLlMZCHf/6JLvoihCjh5MngBavGT5bMs=;
        b=InU7Nm66YTTBZkemRNMKwqJewNtSWt9rpLyqswmDLL3voK05mOq9QV0d+Ah00CQGuL
         tpfLY1JZuMQl7RrTMaJ2GO2Pp5Yi9AYy4ydIcmZXkKPGF/W5cJEIpbBs/wW+jNud7XO5
         GGSLhazqnAmMDa/qhP5IoTyIpR047BReNJ1Riq7nLlyuaevbRqNCaF+rcyIkOGEQJprW
         horEOS7XuNlSz8A4pymsz2kOnlM2qkjcY/VBi88K5BYly7oyJJ1tb7GplmFvFXHloEH2
         4IQTQ8OR7hIsrkf4UG1ZfzM6K2zfy07Swadpg7PVtWMknH3rjNcHap4UuFy1VxAv1bAl
         50kQ==
X-Gm-Message-State: AC+VfDy4aqfRCRpKZEdp37ECMoo/GEBjLD/dvJApkUSAEcozg947USJM
        P2/Tex4gUJPl345me1oeaKAhqnLL95GbDSzIhfqlxmVypesNqW6oL/+cV15aWR8IbwgVzZiWUv6
        bMnncvERNUrRh
X-Received: by 2002:a19:6601:0:b0:4f6:6037:128e with SMTP id a1-20020a196601000000b004f66037128emr13950322lfc.57.1687536207034;
        Fri, 23 Jun 2023 09:03:27 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4FhNowTVfmy0Vku7MNzLc5bMuiBYL6uHFIN/glgac8uc/9qkhgwWZMHcPVOfP2JGnHjumDqA==
X-Received: by 2002:a19:6601:0:b0:4f6:6037:128e with SMTP id a1-20020a196601000000b004f66037128emr13950297lfc.57.1687536206687;
        Fri, 23 Jun 2023 09:03:26 -0700 (PDT)
Received: from [192.168.8.100] (tmo-099-170.customers.d1-online.com. [80.187.99.170])
        by smtp.gmail.com with ESMTPSA id f2-20020a056402004200b0051bde3e1e48sm3461571edu.96.2023.06.23.09.03.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jun 2023 09:03:25 -0700 (PDT)
Message-ID: <fc70263c-b7af-d8e0-14f4-4ffcde67aa3e@redhat.com>
Date:   Fri, 23 Jun 2023 18:03:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [kvm-unit-tests PATCH 2/2] Link with "-z noexecstack" to avoid
 warning from newer versions of ld
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Nico_B=c3=b6hr?= <nrb@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Andrew Jones <andrew.jones@linux.dev>, kvmarm@lists.linux.dev,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>
References: <20230623125416.481755-1-thuth@redhat.com>
 <20230623125416.481755-3-thuth@redhat.com> <ZJWrKtnflTrskPkX@google.com>
Content-Language: en-US
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <ZJWrKtnflTrskPkX@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/06/2023 16.24, Sean Christopherson wrote:
> On Fri, Jun 23, 2023, Thomas Huth wrote:
>> Newer versions of ld (from binutils 2.40) complain on s390x and x86:
>>
>>   ld: warning: s390x/cpu.o: missing .note.GNU-stack section implies
>>                executable stack
>>   ld: NOTE: This behaviour is deprecated and will be removed in a
>>             future version of the linker
>>
>> We can silence these warnings by using "-z noexecstack" for linking
>> (which should not have any real influence on the kvm-unit-tests since
>> the information from the ELF header is not used here anyway, so it's
>> just cosmetics).
>>
>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>> ---
>>   Makefile | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/Makefile b/Makefile
>> index 0e5d85a1..20f7137c 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -96,7 +96,7 @@ CFLAGS += -Woverride-init -Wmissing-prototypes -Wstrict-prototypes
>>   
>>   autodepend-flags = -MMD -MF $(dir $*).$(notdir $*).d
>>   
>> -LDFLAGS += -nostdlib
>> +LDFLAGS += -nostdlib -z noexecstack
> 
> Drat, the pull request[1] I sent to Paolo yesterday only fixes x86[2].

Oops, sorry, I did not notice that patch in my overcrowded mailboxes (or 
forgot about it during KVM forum...) :-/

> Paolo, want me to redo the pull request to drop the x86-specific patch?

I can also respin my patch on top of your series later ... the problem 
currently also only seems to happen on x86 and s390x, on ppc64 and aarch64, 
the linker does not complain ... so maybe it's even better to do it 
per-architecture only anyway? Opinions?

  Thomas

