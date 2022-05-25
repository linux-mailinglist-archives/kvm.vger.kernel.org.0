Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9383853378D
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 09:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbiEYHli (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 03:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbiEYHlh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 03:41:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 806C240A28
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 00:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653464495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yDTXC0gnSBOVU41srsVBvW5WU8IbqJsBF/wjVa/MY7I=;
        b=UfcYWcwvhGn2XricvMFlfgJwMj4bHB7SYH389pOYvfHrTh2Kjc+RdXPfEKD2ZlzkuhRgxP
        DNQF7pBfVVA22OF6Que6+oHTHJrzO61f3fNchThzr0/31uJ9+cmna+KIFxGnOPqaIyHfn7
        NSMi/lvZ/ofbcjaikn1U5YddJk11qDw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-398-NBNipQj3NayvcPCEHtbdtg-1; Wed, 25 May 2022 03:41:34 -0400
X-MC-Unique: NBNipQj3NayvcPCEHtbdtg-1
Received: by mail-wm1-f72.google.com with SMTP id m9-20020a05600c4f4900b0039746692dc2so3991289wmq.6
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 00:41:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yDTXC0gnSBOVU41srsVBvW5WU8IbqJsBF/wjVa/MY7I=;
        b=wrm02y5XcczahdZY3uONdbyBQ/aDMAle2OPEZKgXkZcwnO/7HFLUHaR0Rwx2NmUzY/
         lUfQUlwyco0N8lIyoEF7DeqxbC+h5dK5Y/2SfX5EzmuIOA2j4ElnJouaaaxA7XWA2jXe
         2UenKaxSfZ11lPcNCW3Ij4QToEXPozdZZJNnHN7mtoN6bRsVQJ8zFVj9BRSD37X72MpE
         JdhmyX+1th8uzGx9q2F3/+bArY21LGa+SVsf9ChgkozaqXNaSZo5wbsN99SzmAPm54kQ
         9ERkWl/QfxchX7BWXbIZ1NSWab9ntnLZSiyLKSoH0Oxez1DTvwaheHB7yf5IHGy18FPR
         a2hw==
X-Gm-Message-State: AOAM533+TS5HtCdpZkUWUJJ5VycLLwrWxuimzJUPTuavbfzDF3l7Utrl
        1fYRFI010M5vgrwcW/LJptDo6DxaMTtq1JoG52TMOGbkr1SRx00CpQgvwQB6BKGCyxsQRG7VZi2
        vCx8Q9NE4R6b/
X-Received: by 2002:a05:600c:4f15:b0:394:8ea0:bb45 with SMTP id l21-20020a05600c4f1500b003948ea0bb45mr6891887wmq.206.1653464493212;
        Wed, 25 May 2022 00:41:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyauLKDZK4OAR+SfVlqB47PwYS0V6SCTHPAoofye4Wsu/laN26/4tnh07bsTwz2Gf9LgakFbQ==
X-Received: by 2002:a05:600c:4f15:b0:394:8ea0:bb45 with SMTP id l21-20020a05600c4f1500b003948ea0bb45mr6891871wmq.206.1653464493007;
        Wed, 25 May 2022 00:41:33 -0700 (PDT)
Received: from [192.168.0.2] (ip-109-43-179-69.web.vodafone.de. [109.43.179.69])
        by smtp.gmail.com with ESMTPSA id r67-20020a1c2b46000000b0039482d95ab7sm1334578wmr.24.2022.05.25.00.41.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 May 2022 00:41:32 -0700 (PDT)
Message-ID: <42929631-06eb-a8f9-5f9f-0fd1df0a05e8@redhat.com>
Date:   Wed, 25 May 2022 09:41:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 2/2] kvm-unit-tests: configure changes for illumos.
Content-Language: en-US
To:     Dan Cross <cross@oxidecomputer.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>
References: <Yn2ErGvi4XKJuQjI@google.com>
 <20220513010740.8544-1-cross@oxidecomputer.com>
 <20220513010740.8544-3-cross@oxidecomputer.com> <Yn5skgiL8SenOHWy@google.com>
 <5d48ad3f-a93a-0989-3872-cdff0bc6eb92@redhat.com>
 <CAA9fzEEYMGjPEUAZEzFHDkq3CRod7_eHeEBzD4JoTNL7TrUnjA@mail.gmail.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <CAA9fzEEYMGjPEUAZEzFHDkq3CRod7_eHeEBzD4JoTNL7TrUnjA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/05/2022 23.20, Dan Cross wrote:
> On Thu, May 19, 2022 at 5:53 AM Thomas Huth <thuth@redhat.com> wrote:
>> On 13/05/2022 16.34, Sean Christopherson wrote:
>>> [snip]
>>
>> According to https://illumos.org/man/1/getopt :
>>
>>    NOTES
>>
>>          getopt will not be supported in the next major release.
>>          ...
>>
>> So even if we apply this fix now, this will likely break soon again. Is
>> there another solution to this problem?
> 
> I wouldn't put too much stock into that; that note came from Solaris
> and has been in the man page for 30 years or more [*].

:-)

> I think there
> are too many shell scripts in the wild using `getopt` for it to ever be
> removed. Indeed, if anything this highlights something to clean up
> on the illumos side by removing that from the man page.

Yup, cleaning up that man page sounds like a good idea then, indeed.

  Thomas


