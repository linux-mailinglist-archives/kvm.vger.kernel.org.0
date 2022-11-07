Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4B261FCE2
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 19:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231734AbiKGSJx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 13:09:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232667AbiKGSJh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 13:09:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F78524BE2
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 10:04:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667844287;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BERLrqzoMhvkSHmGJ/W4Pvsqg1w8fBN4W9l/TXLwuX4=;
        b=Bp/zpKnfQeriBuh33nMj9ZCBWYSBK7BeUwzFcngqQdcJ9Rgmal15qC5JTDSUty3BwHsBIW
        ZRn4GAIGO9zeyl6W2Af9m13vRw/dno3gXlqGYdS+7qIYoxyyJC3tfByrn0BVLD/Gj90UG2
        vfWRlcI48XnlGw1VgW2OfSKg27D7Aeg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-28-iHa4tFWrMnS69rN-UoDAvA-1; Mon, 07 Nov 2022 13:04:46 -0500
X-MC-Unique: iHa4tFWrMnS69rN-UoDAvA-1
Received: by mail-wm1-f69.google.com with SMTP id m34-20020a05600c3b2200b003cf549cb32bso8792458wms.1
        for <kvm@vger.kernel.org>; Mon, 07 Nov 2022 10:04:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BERLrqzoMhvkSHmGJ/W4Pvsqg1w8fBN4W9l/TXLwuX4=;
        b=rq0DgR7GaWSccB0HAWZWSLM/xnA+zoP8ybdVi6qAxzVeu4e8Ax4ldCzaJI25Iqe/KV
         TSs9bxatQFo+Dj28lGeHeqVxnDR7/XinF3UVn/BWW0nyneO5X1zR6MIUFh/vK3GcMx0b
         2SnjSwltBqi+cwcQoWSzkfMSOgtvFWfTPdoQiQS27YPLOwDW5yNkpSFgqD2lXGs6AewS
         1T3ldLfjVwogRWBRuenQyC7LpuycxxIMubI8LWMZj5/7EnnIt9B+hA1FUzYw0QLPffev
         Fydi0PU5rBZ1akg4XQ/HU9O7Kt1AwzGycaupmfoXx/YefuJGlhgO1SFkwYzmBzT4JnAr
         73EA==
X-Gm-Message-State: ANoB5pnkb1HMlxbm1lxUmVmvg5vGcxRpcxxQHLMuyX10Lk1s1c+rjo2x
        JFSE9RTBL8hYquOu0WRACSlhvdPqCS1ZAfc+LWDetRJpv3IbgqDHPrZLaX/ffh81WOpq0ilfShv
        EO7aJmonbiW1b
X-Received: by 2002:a05:6000:3cf:b0:23a:cdf5:3655 with SMTP id b15-20020a05600003cf00b0023acdf53655mr11528454wrg.444.1667844284932;
        Mon, 07 Nov 2022 10:04:44 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6tAOxKmuugPRRrOAVpUuk0PVNxtGKOK7Kmu/xTdJPnrrvhUD8J+oWcEtkViCt486Xa+7kM5A==
X-Received: by 2002:a05:6000:3cf:b0:23a:cdf5:3655 with SMTP id b15-20020a05600003cf00b0023acdf53655mr11528438wrg.444.1667844284698;
        Mon, 07 Nov 2022 10:04:44 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id i2-20020a05600c354200b003c71358a42dsm16312447wmq.18.2022.11.07.10.04.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Nov 2022 10:04:44 -0800 (PST)
Message-ID: <bb7ae6ed-0666-023c-c956-e5f5956c34ed@redhat.com>
Date:   Mon, 7 Nov 2022 19:04:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v3 1/3] KVM: x86/pmu: Stop adding speculative Intel GP
 PMCs that don't exist yet
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220919091008.60695-1-likexu@tencent.com>
 <Y0CAHch5UR2Lp0tU@google.com>
 <a90c28df-eb54-f20a-13a5-9ee4172f870e@gmail.com>
 <Y0mL3g2Eamp4bMHD@google.com>
 <524f23fa-b069-1468-dfc6-fa342c11cb7f@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <524f23fa-b069-1468-dfc6-fa342c11cb7f@gmail.com>
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

On 11/7/22 08:26, Like Xu wrote:
> On 15/10/2022 12:18 am, Sean Christopherson wrote:
>> On Fri, Oct 14, 2022, Like Xu wrote:
>>> On 8/10/2022 3:38 am, Sean Christopherson wrote:
>>>> Does this need Cc:stable@vger.kernel.org?  Or is this benign enough 
>>>> that we don't
>>>> care?
>>>
>>> Considering stable kernel may access IA32_OVERCLOCKING_STATUS as well,
>>> cc stable list helps to remove the illusion of pmu msr scope for 
>>> stable tree
>>> maintainers.
>>
>> Is that a "yes, this should be Cc'd stable" or "no, don't bother"?
> 
> Oops, I missed this one. "Yes, this should be Cc'd" as I have received a 
> few complaints on this.
> 
> Please let me know if I need to post a new version of this minor patch 
> set, considering the previous
> comment "No need for a v4, the above nits can be handled when applying. "

Queued, thanks.

Paolo

