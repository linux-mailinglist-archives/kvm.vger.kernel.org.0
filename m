Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5945C5481D1
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 10:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239648AbiFMINJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 04:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239860AbiFMIMV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 04:12:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 079AC1EAC4
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 01:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655107933;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zylh1uwH3+G7KCcoxsL8sX4hSmvWfJyfd8skUX3SqY0=;
        b=axQK7uuju7sP5HSR22bEUsIqoPHvFMW4uPxKTyKDaDwLXo8/7kKmqDTxKCuOe8uxvjvi7u
        ono7Y2nsgEPnGyIdgdDEx4Uo3suCfWYdrNyqv58JTaKhth2HESvjOkQTXMhbDCgAFs0KJa
        NKNK5ryneGb/PJkum1jxfJBpfKiW+3w=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-96-4UN9UBGQOJGsD3WyJodglA-1; Mon, 13 Jun 2022 04:12:12 -0400
X-MC-Unique: 4UN9UBGQOJGsD3WyJodglA-1
Received: by mail-qv1-f70.google.com with SMTP id q36-20020a0c9127000000b00461e3828064so3397675qvq.12
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 01:12:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zylh1uwH3+G7KCcoxsL8sX4hSmvWfJyfd8skUX3SqY0=;
        b=diair3EYT5f7ujcjBXHw11gr5QzpO/AGxJCevn2MUwIJ02oS23CwcJ4aQmWhWsF6Fy
         W48wGQHJyJiUWdp62EgHpMIh/jAiQdqhNd9QgPi4CjjstZPQV7e8RRgtCKUwa42e8Ygl
         n3UwxCKrwIZnPeRP9jeLcycvyqGwt7QGDR9YMwY5Of64ilyq+7ru3Z1FywfgIE/Izjbj
         nE98S8cweWZRx3PM2yPTFh772k6ANRkkR/ffVcmSh92i+1F7CW+JGqJ/z1RrOXFQv3sS
         hrYyrfuFZ6ftqfgN+BAcFY9kcMVFyvb5SEUflNqefN94Xnq1nT8fuxjEOUG7Fjm0NI7x
         t5LQ==
X-Gm-Message-State: AOAM532PyYPAEIfcf98QgyOawjCOPZ/y+n/wkGowosBlFB2sPY0kd6VG
        zalMBHTluGeNYIAlo1DTEpQhmYqj3I6uFxH2DXRifRXZ7yhdPw9LSTaQJNjrm+q1/y2kAOHm4XH
        Gb6sHblOWD9/O
X-Received: by 2002:a05:622a:1829:b0:304:ef78:8385 with SMTP id t41-20020a05622a182900b00304ef788385mr29662309qtc.251.1655107931898;
        Mon, 13 Jun 2022 01:12:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxjLbgha+Atbwd2/672pHZ9TBWRG8nE6aGEjsg4713GAJdcGUXYTIFRS5oET6rQnKiNs5SleA==
X-Received: by 2002:a05:622a:1829:b0:304:ef78:8385 with SMTP id t41-20020a05622a182900b00304ef788385mr29662298qtc.251.1655107931645;
        Mon, 13 Jun 2022 01:12:11 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-42-115-130.web.vodafone.de. [109.42.115.130])
        by smtp.gmail.com with ESMTPSA id j1-20020a05620a410100b006a65c58db99sm6390714qko.64.2022.06.13.01.12.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jun 2022 01:12:11 -0700 (PDT)
Message-ID: <2d8bcbb1-ee9d-8e88-b01d-88b80da86f13@redhat.com>
Date:   Mon, 13 Jun 2022 10:12:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 000/144] KVM: selftests: Overhaul APIs, purge VCPU_ID
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Anup Patel <anup@brainfault.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        KVM General <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Marc Zyngier <maz@kernel.org>,
        Cornelia Huck <cohuck@redhat.com>
References: <20220603004331.1523888-1-seanjc@google.com>
 <21570ac1-e684-7983-be00-ba8b3f43a9ee@redhat.com>
 <CAAhSdy0_50KshS1rAcOjtFBUu=R7a0uXYa76vNibD_n7s=q6XA@mail.gmail.com>
 <CAAhSdy1N9vwX1aXkdVEvO=MLV7TEWKMB2jxpNNfzT2LUQ-Q01A@mail.gmail.com>
 <YqIKYOtQTvrGpmPV@google.com> <YqKRrK7SwO0lz/6e@google.com>
 <YqKXExV4BOVRbOVc@google.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <YqKXExV4BOVRbOVc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/06/2022 02.57, Sean Christopherson wrote:
> +s390 folks...
> 
> On Fri, Jun 10, 2022, Sean Christopherson wrote:
>> On Thu, Jun 09, 2022, Sean Christopherson wrote:
>>> On Thu, Jun 09, 2022, Anup Patel wrote:
>>>> On Wed, Jun 8, 2022 at 9:26 PM Anup Patel <anup@brainfault.org> wrote:
>>>>>
>>>>> On Tue, Jun 7, 2022 at 8:57 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>>>>>
>>>>>> Marc, Christian, Anup, can you please give this a go?
>>>>>
>>>>> Sure, I will try this series.
>>>>
>>>> I tried to apply this series on top of kvm/next and kvm/queue but
>>>> I always get conflicts. It seems this series is dependent on other
>>>> in-flight patches.
>>>
>>> Hrm, that's odd, it's based directly on kvm/queue, commit 55371f1d0c01 ("KVM: ...).
>>
>> Duh, Paolo updated kvm/queue.  Where's Captain Obvious when you need him...
>>
>>>> Is there a branch somewhere in a public repo ?
>>>
>>> https://github.com/sean-jc/linux/tree/x86/selftests_overhaul
>>
>> I pushed a new version that's based on the current kvm/queue, commit 5e9402ac128b.
>> arm and x86 look good (though I've yet to test on AMD).
>>
>> Thomas,
>> If you get a chance, could you rerun the s390 tests?  The recent refactorings to
>> use TAP generated some fun conflicts.

Still works fine!
Tested-by: Thomas Huth <thuth@redhat.com>

>> Speaking of TAP, I added a patch to convert __TEST_REQUIRE to use ksft_exit_skip()
>> instead of KVM's custom print_skip().  The s390 tests are being converted to use
>> TAP output, I couldn't see any advantage of KVM's arbitrary "skipping test" over
>> TAP-friendly output, and converting everything is far easier than special casing s390.

Sounds like a good idea to me. I already considered starting to convert some 
x86 tests, too 
(https://lore.kernel.org/linux-kselftest/20220429071149.488114-1-thuth@redhat.com 
), but didn't get much feedback there yet, but anyway, we'll be better 
prepared with your change for that now.

  Thomas

