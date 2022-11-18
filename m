Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DEAF62FC4B
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 19:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242561AbiKRSRd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 13:17:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242557AbiKRSRc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 13:17:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3595287552
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 10:16:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668795395;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=He7KaN/D9HK9g87/+Mt/xAsVhTgokNO4h0yf9aoy/GY=;
        b=Y5CltPQk2w0EyDmerQqsDSjhPAKnPqErbn5ooqP7q/al0I6qU0Gh5B7EqKZPzJGqyMn/gC
        In63KP0c3IK+E0qygsFhM0zpUQft6L3Jaa2oMIgz96lCP/YU3Nn8lnkB9s19DkchlPzVxe
        00S2lty3U8/OHj7HBMZm14gMBElujlA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-663-OLwzk0-TNx6Qu7GC41DOAQ-1; Fri, 18 Nov 2022 13:16:34 -0500
X-MC-Unique: OLwzk0-TNx6Qu7GC41DOAQ-1
Received: by mail-wm1-f72.google.com with SMTP id z15-20020a1c4c0f000000b003cf6f80007cso1346365wmf.3
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 10:16:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=He7KaN/D9HK9g87/+Mt/xAsVhTgokNO4h0yf9aoy/GY=;
        b=QOqTIAzhC31O39Yz6ILUBl7hnUBA9jQ1mQ6+V7tCK8AbgQ8nJtuTrKtbYyiPUIzG7j
         WVgn2L2a5Jhxm0bb5H/dkWDhTM70xYfGI+yo1g1Tf/kpN62yFAdMCDPeVYpSkFW0T94n
         egXL/Rm91txBoxDOqIRnqGF91x66+L0cXXol/JGcK2vnhFoouFNwUHNupkCXnknYjSbb
         Bq7tG51fkJWkR/S0yLL3yhU8cDN+f5F7jkBAtZh6OCjnehZwOdRDBa21bRwplUxkzqZf
         lb2gUmwgNBzXtLB3F91guXbI71R0IurynJR0hBVD3peqgaDEuCMvZwbZMpN3AnGJzZeV
         UoMA==
X-Gm-Message-State: ANoB5pn22GJ+7OGgagCBXm+7aAp4LUn04gkuvUBIW5mgVy32Hk9Zq18O
        5opnNXotW/yfAbQRt9NAg9gZl7WEsvDHDW5zwFcEqHeICKodLS0JWvk9k4HktVGStJ8c7pyggDT
        U6y6nGtcDNQRV
X-Received: by 2002:a5d:4f85:0:b0:22e:35f4:9182 with SMTP id d5-20020a5d4f85000000b0022e35f49182mr4868365wru.121.1668795392880;
        Fri, 18 Nov 2022 10:16:32 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7OA1XS2f6Trqui/9ejpEZL5kbR8dXUyqmf/ItYLlQ7PW8vFgiBB9/csUaH3GBlOF/v81qpBQ==
X-Received: by 2002:a5d:4f85:0:b0:22e:35f4:9182 with SMTP id d5-20020a5d4f85000000b0022e35f49182mr4868356wru.121.1668795392648;
        Fri, 18 Nov 2022 10:16:32 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id v1-20020a5d6101000000b002365cd93d05sm3984823wrt.102.2022.11.18.10.16.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Nov 2022 10:16:31 -0800 (PST)
Message-ID: <01da30b6-4716-c346-70d2-9557bf4b09d5@redhat.com>
Date:   Fri, 18 Nov 2022 19:16:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH v13 00/48] KVM: x86: hyper-v: Fine-grained TLB flush + L2
 TLB flush features
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221101145426.251680-1-vkuznets@redhat.com>
 <Y2E5chB/9pZcRWi6@google.com> <878rkuskoj.fsf@ovpn-194-149.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <878rkuskoj.fsf@ovpn-194-149.brq.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/1/22 17:29, Vitaly Kuznetsov wrote:
>> Applies cleanly to e18d6152ff0f ("Merge tag 'kvm-riscv-6.1-1' of
>> https://github.com/kvm-riscv/linux  into HEAD") and then rebases to kvm/queue without
>> needing human assistance.
> The miracle of git 😄

Some more work was needed to apply these, but that at least forced me to 
go through them. :)

I'll push them shortly to queue.

Paolo

