Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3214BBF3D
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 19:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239041AbiBRSOx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 13:14:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236027AbiBRSOw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 13:14:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B9A1835DFC
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 10:14:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645208074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vy/IK4V/mhCajFQx2hxF7UpJtAMmgdBhiWBJ5HepLmw=;
        b=WR306p2sejaUHoOBn6uO0b05al75EtNq7P5v0mkEBemV3RS60bbznuPS70B+ZYf/dUY/BV
        tfYxyu6BqcSC84QdXlLylHTLtx+MLs6yCfg4A6IgULIpTQLPwvfttDyZVCnEKQbCqpXJ05
        LKpo3v2U7XTWALH6QPdn3fgmlTv8SgM=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-387-nh5FMVzMMhGgTP-VU0PScg-1; Fri, 18 Feb 2022 13:14:33 -0500
X-MC-Unique: nh5FMVzMMhGgTP-VU0PScg-1
Received: by mail-ed1-f71.google.com with SMTP id j10-20020a05640211ca00b004090fd8a936so5951287edw.23
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 10:14:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Vy/IK4V/mhCajFQx2hxF7UpJtAMmgdBhiWBJ5HepLmw=;
        b=lHWj4uDgYdOac75vHm9JgYGyRM5IM8aLpEp9mGHe9KT7Yvuie92aKaVlOOb21W3Ylw
         LS3ijIKMtp/mYT12RUHRSAORAIM/ffU8MO152fICUY6t/BtubM3iTUbZR25psofmb9dN
         GL2zyomwDzOMwgHVSwIaetXrCkjpU0R+GRXflyOBVkNB+efJ3FnkzA6SKVM4+NU168yz
         KY7bv9Eniesty3CTczMtBmyCq0V03qY89Zohaagct6rQ5xlPWIzj1WXe1evaBIa9F+gC
         XCrL7ybwUN+Zn0SXwxSIHnGI/ERIPp91sPioWXkucdYHh3z3+Qk4y8vquWYDDNG1GSSe
         +BSw==
X-Gm-Message-State: AOAM530C40Ke1/UHuz75UyPMvFiylGyLYmVnGjupNNxE/a16Wjug9ini
        u2oyi/vCAMUZZIJ8sEhYczlYy/FfxqXi90c4gEFffZ3X6gxukspsB/THUVFlL8SOulqWLNcjfTR
        sKRUX3HU51A6s
X-Received: by 2002:a17:907:766e:b0:6cf:d1d1:db1d with SMTP id kk14-20020a170907766e00b006cfd1d1db1dmr7451162ejc.503.1645208072323;
        Fri, 18 Feb 2022 10:14:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyfPFU//Xg7klZt6Vb3buhqfNO6wio3MC0ppqJeKT7OkOn6q8yF9jxxvxKpgWHMVWAuWGmmzg==
X-Received: by 2002:a17:907:766e:b0:6cf:d1d1:db1d with SMTP id kk14-20020a170907766e00b006cfd1d1db1dmr7451145ejc.503.1645208072096;
        Fri, 18 Feb 2022 10:14:32 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id w4sm5090427edc.73.2022.02.18.10.14.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Feb 2022 10:14:31 -0800 (PST)
Message-ID: <6cef7c8a-10d3-9fc6-f68d-220fdfc079c1@redhat.com>
Date:   Fri, 18 Feb 2022 19:14:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] KVM: x86: Forcibly leave nested virt when SMM state is
 toggled
Content-Language: en-US
To:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+8112db3ab20e70d50c31@syzkaller.appspotmail.com
References: <20220125220358.2091737-1-seanjc@google.com>
 <db8a9edd-533e-3502-aed1-e084d6b55e48@linaro.org>
 <Yg/QKgxotNyZbYAI@google.com>
 <3561688b-b52c-8858-3da2-afda7c3e681f@linaro.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <3561688b-b52c-8858-3da2-afda7c3e681f@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/18/22 18:22, Tadeusz Struk wrote:
> On 2/18/22 08:58, Sean Christopherson wrote:
>> This SMM-specific patch fixes something different, the bug that you 
>> are still
>> hitting is the FNAME(cmpxchg_gpte) mess.  The uaccess CMPXCHG 
>> series[*] that
>> properly fixes that issue hasn't been merged yet.
>>
>>    ==================================================================
>>    BUG: KASAN: use-after-free in ept_cmpxchg_gpte.constprop.0+0x3c3/0x590
>>    Write of size 8 at addr ffff888010000000 by task repro/5633
>>
>> [*]https://lore.kernel.org/all/20220202004945.2540433-1-seanjc@google.com
>>
> 
> Ok, that's good. I will keep an eye on it and give it a try then.

I'll poke PeterZ for a review next week.

Paolo

