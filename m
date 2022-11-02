Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8DD3616B4B
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 18:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbiKBRzX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 13:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiKBRzU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 13:55:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2B0A44D
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 10:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667411667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qsy9PInY+W27+gffMySXvFWm04u28ouULp0IKJ8CX94=;
        b=VraqMsxYX4A5ybuJMTyt4i7wssZh+7RS4FKwnzwlj7cSlvsdAc68ZT7765vREU3GD90R1n
        Oys4kwHuL3rYsE+7P2r427XFRUwHZddxb/R3h7YpJIM2xPjx7BsbKwHPTaZQUdG3rWgsqJ
        wB3tAhm7lS+tud6XLKk381XnPrgDjkY=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-230-jIUn3MzkPVOuJsxOZZrVng-1; Wed, 02 Nov 2022 13:54:26 -0400
X-MC-Unique: jIUn3MzkPVOuJsxOZZrVng-1
Received: by mail-ej1-f69.google.com with SMTP id qb12-20020a1709077e8c00b007a6c5a23a30so10347800ejc.12
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 10:54:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qsy9PInY+W27+gffMySXvFWm04u28ouULp0IKJ8CX94=;
        b=53ow7N3LjjMwMQK1RyL3sYaW3ksRYo/+QtTqVxVed2XDX5eNdxQKk93nwKaNCYMEJX
         RkQuBASo1NKDhGWkvZK53E+VH51qPUIVcw+Tgbn8w3FIw9rq3C2xDMIFNwQ6YNx3/qHz
         RlCRA5Qbogna0qZ/wE5mzRSFlVmAmfPtNex3Q9GGuYO82gK1irKIVTQEUaEqWg6tnYJz
         6TSAg48ghYu/9pGv7MaXcXmDuDKg6384HNnUQSBHECkKTeZ0Cmto8s500hHRltzyftjZ
         wYhefPyJi3aRCTIxhgRwXqUCt2VRcLmzKhqLDqWYPTg6d704/O16LKbOtFWpoSlqwoeK
         MLXQ==
X-Gm-Message-State: ACrzQf2RONJvjMBrEKARDsk1WndW+o/dNyhOOAaAjoJF7nOc+Nzt/KE3
        T3ZkKFm4Y5K+uSXCmtf3XKCJbMjVvV9VgrmO/s5vu5csbMtm6wqOxOUas4ox2bpMun3DRdOjNN/
        xROPFtpKqnL9Z
X-Received: by 2002:a17:907:31c7:b0:740:e3e5:c025 with SMTP id xf7-20020a17090731c700b00740e3e5c025mr25445521ejb.341.1667411665339;
        Wed, 02 Nov 2022 10:54:25 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7i9P8a3KaukAAmvuzA0kYKoaG+hzHr8RgD2JCBtxz5ORS+iIp13DTtPPB6cRp+bA7bWvgRQg==
X-Received: by 2002:a17:907:31c7:b0:740:e3e5:c025 with SMTP id xf7-20020a17090731c700b00740e3e5c025mr25445499ejb.341.1667411665122;
        Wed, 02 Nov 2022 10:54:25 -0700 (PDT)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id dy14-20020a05640231ee00b00461621cae1fsm6046687edb.16.2022.11.02.10.54.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Nov 2022 10:54:24 -0700 (PDT)
Message-ID: <47ae788b-c19d-3a1f-8ac2-b6674770e79f@redhat.com>
Date:   Wed, 2 Nov 2022 18:54:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     Gaosheng Cui <cuigaosheng1@huawei.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org
References: <20221031113638.4182263-1-cuigaosheng1@huawei.com>
 <Y2AJIFQlF5C0ozoU@google.com>
 <Y2A2HmJxTdoWm1vf@hirez.programming.kicks-ass.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: x86: fix undefined behavior in bit shift for
 __feature_bit
In-Reply-To: <Y2A2HmJxTdoWm1vf@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/31/22 21:54, Peter Zijlstra wrote:
>> PeterZ is contending that this isn't actually undefined behavior given how the
>> kernel is compiled[*].  That said, I would be in favor of replacing the open-coded
>> shift with BIT() to make the code a bit more self-documenting, and that would
>> naturally fix this maybe-undefined-behavior issue.
>>
>> [*]https://lore.kernel.org/all/Y1%2FAaJOcgIc%2FINtv@hirez.programming.kicks-ass.net
> I'm definitely in favour of updating this code; both your suggestion and
> hpa's suggestion look like sane changes. But I do feel that whatever
> UBSAN thing generated this warning needs to be fixed too.
> 
> I'm fine with the compiler warning about this code -- but it must not
> claim undefined behaviour given the compiler flags we use.

Yes, the compiler is buggy here (see old bug report for GCC, now fixed, 
at https://gcc.gnu.org/bugzilla/show_bug.cgi?id=68418).

I cannot even reproduce the problem with the simple userspace testcase

#include <stdlib.h>
int main(int argc) {
	int i = argc << 31;
	exit(i < 0);
}

on either GCC 12 or clang 15.

Paolo

