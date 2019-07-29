Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 144627880B
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2019 11:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbfG2JK1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jul 2019 05:10:27 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46901 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfG2JK0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jul 2019 05:10:26 -0400
Received: by mail-wr1-f68.google.com with SMTP id z1so60923097wru.13
        for <kvm@vger.kernel.org>; Mon, 29 Jul 2019 02:10:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zV+bTIgChlMbStRhEz4HmI17F1bLOP/P0h9cutKjnuk=;
        b=sZqhgBAUVWlkQ/olBC24mjfBF21QLCDvO5YDiBj2dr8GtnnbUs/iHcNLEGuqLHmM/X
         UZ93HtM9wZakgDJQ6fuXCKuvg8G/zLfbE53Xwc9CRkdps0xRqOsIVmLQS8jz069xuYOj
         5bbX6JAyC3UveWGuJRI4bSJCypHJc/cpxCEPUUXQTVay+7kCvwAVWZn3J3JxIviLIsPL
         oxdCk1zJk29AlCFpR6bH9KMDSdr4TinAdozXH5N61p8amEuRD/rc9yzAJTGTucnhYhuI
         R9X9zUTk47WR4nG4GUaSD1Zawt3Kv+3f8yN0f8sG60xtLlVV9qo1kIYzgmRrfSYq99uy
         +haw==
X-Gm-Message-State: APjAAAU5wwP/T7KgOp9T4y/EJ1PzhBodUW+Bn+oLOPK8vdBgM6Ttr6Lr
        hAyL3E9moX8vSZzfvujI9lYNjg==
X-Google-Smtp-Source: APXvYqwu+iJxG0Nnx1LAgpMTW4dJUcSifVyQWlGLBgiZPy7xi6UkywxpJxOjNTGIQL6gbv5Vi6t8kA==
X-Received: by 2002:a5d:4e8a:: with SMTP id e10mr38159080wru.26.1564391424671;
        Mon, 29 Jul 2019 02:10:24 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id e6sm57983191wrw.23.2019.07.29.02.10.23
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 02:10:23 -0700 (PDT)
Subject: Re: [PATCH stable-4.19 1/2] KVM: nVMX: do not use dangling shadow
 VMCS after guest reset
To:     Jack Wang <jack.wang.usish@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     stable@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
References: <20190725104645.30642-1-vkuznets@redhat.com>
 <20190725104645.30642-2-vkuznets@redhat.com>
 <CA+res+RfqpT=g1QbCqr3OkHVzFFSAt3cfCYNcwqiemWmOifFxg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <2ea5d588-8573-6653-b848-0b06d1f98310@redhat.com>
Date:   Mon, 29 Jul 2019 11:10:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CA+res+RfqpT=g1QbCqr3OkHVzFFSAt3cfCYNcwqiemWmOifFxg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/07/19 10:58, Jack Wang wrote:
> Vitaly Kuznetsov <vkuznets@redhat.com> 于2019年7月25日周四 下午3:29写道：
>>
>> From: Paolo Bonzini <pbonzini@redhat.com>
>>
>> [ Upstream commit 88dddc11a8d6b09201b4db9d255b3394d9bc9e57 ]
>>
>> If a KVM guest is reset while running a nested guest, free_nested will
>> disable the shadow VMCS execution control in the vmcs01.  However,
>> on the next KVM_RUN vmx_vcpu_run would nevertheless try to sync
>> the VMCS12 to the shadow VMCS which has since been freed.
>>
>> This causes a vmptrld of a NULL pointer on my machime, but Jan reports
>> the host to hang altogether.  Let's see how much this trivial patch fixes.
>>
>> Reported-by: Jan Kiszka <jan.kiszka@siemens.com>
>> Cc: Liran Alon <liran.alon@oracle.com>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> Hi all,
> 
> Do we need to backport the fix also to stable 4.14?  It applies
> cleanly and compiles fine.

The reproducer required newer kernels that support KVM_GET_NESTED_STATE
and KVM_SET_NESTED_STATE, so it would be hard to test it.  However, the
patch itself should be safe.

Paolo
