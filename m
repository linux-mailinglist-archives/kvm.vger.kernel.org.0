Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0F962185A5
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 13:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728828AbgGHLKJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 07:10:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60328 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728655AbgGHLKI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 07:10:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594206607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=14f1mTpd7HVDpOyXYxD6GElv4scdvE+XkzizMQMoy8M=;
        b=JBWuSHlDHc6tlqTDU9X4CaPApIaLAIzczwe7ZqgY0DTzN6hwDHD1nkOVuPcLi+BNNSO5j3
        A9dhUlM5EECF61MS3AXqDzBEvAAKa2Rx5k6lMe4KNLVIws5HzHsrTGqls/AxPx26Y4ygbO
        npScT5N33loz6wqxDRdblYF7+AeUtmA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-113-ODcGdN1VOvKSeguBLKifIQ-1; Wed, 08 Jul 2020 07:10:05 -0400
X-MC-Unique: ODcGdN1VOvKSeguBLKifIQ-1
Received: by mail-wm1-f70.google.com with SMTP id t18so2525068wmj.5
        for <kvm@vger.kernel.org>; Wed, 08 Jul 2020 04:10:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=14f1mTpd7HVDpOyXYxD6GElv4scdvE+XkzizMQMoy8M=;
        b=Vg0qvuwxk31iMLR4X9gjlqqnIM5VN0uqhIhRlVYh22gV2HaRwyPk7tNxddURGqRuwV
         tzKq/aTDGr9/sDVQ8qZnhsQKlXhAfYk/QlqCeFso/YhL8fdcc1n8s8c3wPM1/SqBqCG5
         9ow4CA0zus3PjKYKV/2ccJm+EvRG4RASDnVKzYb7Bfny1nclfqf+YmAnBaaY30d7WofA
         gl74PFLcpICr0yRFeYr+vDDBWeHdlsPbRVIYlIcE2geITtjAWNLBq+SXmSsmNuqjLwJ0
         ysEwAY2/3XV//PlZPP/n/j7fV5U1QUIsKP6U8POFvAmQfF+JP6MrZUnKZrNVztLGwEc+
         UFmg==
X-Gm-Message-State: AOAM532V2j+Pgtj7/DeeaskLvIDgEinCS8K2eiEtRcNvtTi9vdKnKk6r
        u/hU8X/u6fBl+Af0xw4IhAttWqqPaEOkYwJsbbmU2hoNk2CPaVA6uirWMy1myRGhc+lv27D56JG
        K000CE9RCNHAq
X-Received: by 2002:a05:6000:10c4:: with SMTP id b4mr54529521wrx.50.1594206604361;
        Wed, 08 Jul 2020 04:10:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyS9IXWXY8AsLX9C3rrryHKZ4q/47XveQNN7O/2+yEMRnuw24+Agts1i9nEHB/Ycwubh37ATw==
X-Received: by 2002:a05:6000:10c4:: with SMTP id b4mr54529504wrx.50.1594206604189;
        Wed, 08 Jul 2020 04:10:04 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id j6sm5766924wma.25.2020.07.08.04.10.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 04:10:03 -0700 (PDT)
Subject: Re: [PATCH 1/2] KVM: SVM: avoid infinite loop on NPF from bad address
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "# v3 . 10+" <stable@vger.kernel.org>
References: <20200417163843.71624-1-pbonzini@redhat.com>
 <20200417163843.71624-2-pbonzini@redhat.com>
 <CANRm+CyWKbSU9FZkGoPx2nff-Se3Qcfn1TXXw8exy-6nuZrirg@mail.gmail.com>
 <57a405b3-6836-83f0-ed97-79f637f7b456@redhat.com>
 <CANRm+CzpFt5SwnQzJjRGp3T_Q=Ws3OWBx4FPmMK79qOx1v3NBQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7507de6a-799e-4f71-012d-ddaa39178284@redhat.com>
Date:   Wed, 8 Jul 2020 13:10:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CANRm+CzpFt5SwnQzJjRGp3T_Q=Ws3OWBx4FPmMK79qOx1v3NBQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/07/20 11:08, Wanpeng Li wrote:
>>>> +EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_memslot);
>>> This commit incurs the linux guest fails to boot once add --overcommit
>>> cpu-pm=on or not intercept hlt instruction, any thoughts?
>> Can you write a selftest?
> Actually I don't know what's happening here(why not intercept hlt
> instruction has associated with this commit), otherwise, it has
> already been fixed. :)

I don't understand, what has been fixed and where?

Paolo

