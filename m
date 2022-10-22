Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7641608D06
	for <lists+kvm@lfdr.de>; Sat, 22 Oct 2022 13:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbiJVLxx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Oct 2022 07:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiJVLxv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Oct 2022 07:53:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B42BE59E87
        for <kvm@vger.kernel.org>; Sat, 22 Oct 2022 04:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666439630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KPmvOeY7znrhinzMDTYzlhkvZyG6kRL1anJ+HPXl5ug=;
        b=KhULDQrH1lsfDM/IxswWKtVQIDxZ1UMPNIzaryVj6XDMKQUpR/vF6PluSrfQ8e9ksI9GQb
        WbwbyR1q221yDMQylh3sYG/YCH690eRmKP8voOli/4mod71Wht52U2E9Zt1D1xfaDVucI+
        0qAP4Z5VfsJi7xQV3okT+tzjojJqhA0=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-549-J6G8DzcOM_GeFUl8k7gYjQ-1; Sat, 22 Oct 2022 07:53:48 -0400
X-MC-Unique: J6G8DzcOM_GeFUl8k7gYjQ-1
Received: by mail-ed1-f69.google.com with SMTP id x19-20020a05640226d300b0045dc858ce29so5112512edd.7
        for <kvm@vger.kernel.org>; Sat, 22 Oct 2022 04:53:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KPmvOeY7znrhinzMDTYzlhkvZyG6kRL1anJ+HPXl5ug=;
        b=KXkXnK2Y0XVrsf7dXSEvOUCA+ng489NM6TXIYinV8ZdnoZA4ljuEvwGg82U6qZhwB8
         Mju3LfzTOF0GHDeXnPozx1Za/m9ePA1tidqmVp1QzBBoPTJw7zOTxXLGUQ4sSdqfbv7n
         vpPgQMBFNqwLABckdU3Trvungd9b5r2kxXwwQORg71XKhdsllV5tjJEk72P1SnDP3Cvn
         Y0EsTuSjZVvYSJkdOjSGUo7tbDwRm+M8YEWlSWQ+3hQT6d63J68R138bSyJ5UjJeozDS
         q3AMFs3M6FtczaTzPf0Hj7Ib3Qjkh225G15YDIRjT+LkLWFENSQo+5dZrb7d7El+Ve8b
         ctsw==
X-Gm-Message-State: ACrzQf1aqKTCH+xsOH5BDkeQwCA0TJ5C6LcmcxvcFztNoz4lCITOg0ml
        bUTUJUrFv4qw0WRIaC0Y2KRcQJ7tBnsZpa9zSGbeHv5f55yYpx0s6GA6Q+E7Lc7YwwQ4CNU8Qzt
        zCgWN5Q0D1wE6
X-Received: by 2002:a17:907:16a7:b0:79e:9eed:8f6 with SMTP id hc39-20020a17090716a700b0079e9eed08f6mr4603475ejc.731.1666439626787;
        Sat, 22 Oct 2022 04:53:46 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7L4myOJ/0NIdAr5ZVQ+QtDR8RDZxDn9M+eafRx+6P9t9XZmCfx8weClDwmUUZOtYPytHfyTw==
X-Received: by 2002:a17:907:16a7:b0:79e:9eed:8f6 with SMTP id hc39-20020a17090716a700b0079e9eed08f6mr4603462ejc.731.1666439626502;
        Sat, 22 Oct 2022 04:53:46 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:2f4b:62da:3159:e077? ([2001:b07:6468:f312:2f4b:62da:3159:e077])
        by smtp.googlemail.com with ESMTPSA id y16-20020a056402171000b0044e937ddcabsm18323edu.77.2022.10.22.04.53.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Oct 2022 04:53:46 -0700 (PDT)
Message-ID: <e436fc94-6bd7-989d-a1bb-5cd08a7d10c3@redhat.com>
Date:   Sat, 22 Oct 2022 13:53:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH] tools: include: sync include/api/linux/kvm.h
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20221022114423.1741799-1-pbonzini@redhat.com>
 <87bkq4gjwc.wl-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <87bkq4gjwc.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/22/22 13:47, Marc Zyngier wrote:
>> Provide a definition of KVM_CAP_DIRTY_LOG_RING_ACQ_REL.
>>
>> Fixes: 4b3402f1f4d9 ("KVM: selftests: dirty-log: Use KVM_CAP_DIRTY_LOG_RING_ACQ_REL if available")
>> Cc: Marc Zyngier<maz@kernel.org>
>> Signed-off-by: Paolo Bonzini<pbonzini@redhat.com>
>> ---
>>   tools/include/uapi/linux/kvm.h | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
>> index eed0315a77a6..0d5d4419139a 100644
>> --- a/tools/include/uapi/linux/kvm.h
>> +++ b/tools/include/uapi/linux/kvm.h
>> @@ -1177,6 +1177,7 @@ struct kvm_ppc_resize_hpt {
>>   #define KVM_CAP_VM_DISABLE_NX_HUGE_PAGES 220
>>   #define KVM_CAP_S390_ZPCI_OP 221
>>   #define KVM_CAP_S390_CPU_TOPOLOGY 222
>> +#define KVM_CAP_DIRTY_LOG_RING_ACQ_REL 223
>>   
>>   #ifdef KVM_CAP_IRQ_ROUTING
>>   
> Huh, I wonder how I missed that one, as the test were compiling here.
> 
> Acked-by: Marc Zyngier<maz@kernel.org>

5 minutes later -- The tests do not use that file, they use usr/include/ 
in the build tree.  So the right Fixes tag is 17601bfed909 ("KVM: Add 
KVM_CAP_DIRTY_LOG_RING_ACQ_REL capability and config option").

Paolo

