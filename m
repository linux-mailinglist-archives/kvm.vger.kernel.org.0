Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D50A602777
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 10:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbiJRItC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 04:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbiJRIs6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 04:48:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84AFC2ED41
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 01:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666082936;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I71EikHKgf+Cumvg3ZhyuGvJzSPCx8y69uStaChXwig=;
        b=dkZJl8VMDh2Tdjy6s4WN4FR3jgw+HD1SwKsSwcby91IcDrMVgtdDpfdbEYJslBEP2O+f+N
        aj/rDfWYZcJw3wCHh1y/toqLfT0SDmUntOnoDR49J/nChfFbEdAYJVZ+2b5QlyBQxm8Kv2
        HADv/tlOfqkcaV9TMlsuaFQ1Gu1lV+M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-576-EOXjjTozOO6CtfRjlIgsIw-1; Tue, 18 Oct 2022 04:48:53 -0400
X-MC-Unique: EOXjjTozOO6CtfRjlIgsIw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 97229857FAB;
        Tue, 18 Oct 2022 08:48:52 +0000 (UTC)
Received: from [10.64.54.70] (vpn2-54-70.bne.redhat.com [10.64.54.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D4A1F2166B41;
        Tue, 18 Oct 2022 08:48:43 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH 5/6] KVM: selftests: memslot_perf_test: Consolidate memory
 sizes
To:     Oliver Upton <oliver.upton@linux.dev>,
        Sean Christopherson <seanjc@google.com>
Cc:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        ajones@ventanamicro.com, pbonzini@redhat.com, maz@kernel.org,
        shuah@kernel.org, peterx@redhat.com, ricarkol@google.com,
        zhenyzha@redhat.com, shan.gavin@gmail.com
References: <20221014071914.227134-1-gshan@redhat.com>
 <20221014071914.227134-6-gshan@redhat.com>
 <cebafa0d-a2dc-c3f7-64c8-2637a254e3d0@maciej.szmigiero.name>
 <Y03ScGUUCA1KwlLF@google.com> <Y05aCJH+BBo+Y+nh@google.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <2aa1e089-7af1-24f8-e33c-b123f094f4c3@redhat.com>
Date:   Tue, 18 Oct 2022 16:48:40 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <Y05aCJH+BBo+Y+nh@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/18/22 3:47 PM, Oliver Upton wrote:
> On Mon, Oct 17, 2022 at 10:08:48PM +0000, Sean Christopherson wrote:
>> On Mon, Oct 17, 2022, Maciej S. Szmigiero wrote:
>>>> +#define MEM_EXTRA_SIZE		0x10000
>>>
>>> Also, an expression like "(64 << 10)" is more readable than a "1"
>>> with a tail of zeroes (it's easy to add one zero too many or be one
>>> zero short).
>>
>> +1 to not open coding raw numbers.
>>
>> I think it's high time KVM selftests add #defines for the common sizes, e.g. SIZE_4KB,
>> 16KB, 64K, 2MB, 1GB, etc...
>>
>> Alternatively (or in addition), just #define 1KB, 1MB, 1GB, and 1TB, and then do
>> math off of those.
> 
> I mean I love boilerplate as much as the next guy, but we can just use
> tools/include/linux/sizes.h
> 

Nice point, I didn't realize we already had 'tools/include/linux/sizes.h'.
The suggested macros (KiB, MiB, GiB, TiB and their variants) have been added
to PATCH[v2 5/6]. I think it's reasonable to use 'tools/include/linux/sizes.h'
directly instead of reinventing the wheel.

I will go ahead to use 'tools/include/linux/sizes.h' directly in v3 if nobody
objects. I would like to receive comments on v2 before I'm going to post v3.

Thanks,
Gavin

