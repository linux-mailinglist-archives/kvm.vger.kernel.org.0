Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8176A6D764A
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 10:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237308AbjDEIGo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 04:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237322AbjDEIGm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 04:06:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B19AA4C17
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 01:05:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680681938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jtyP2HJ2MI10GZPZtyh9yO+D0mamLiYV4IGTudd6x9k=;
        b=Lhgn1n5CRVSreyjF3yEzgotwo4A9ZMk1fYjk7QZxqLftXYOohchwxCtAf8QfzhcVLId735
        DoV0WIy26dfP9H/DyM8R+PlhYbnGLuWs/79hBzq3W0YbbbGjahFcOvc8SQ2QE257p5H3Ir
        w26YUcFaCuqLQLqDRGhYfpvr/RkYNwA=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-638-oyeO1ZXrOHiWPRnIymeoAQ-1; Wed, 05 Apr 2023 04:05:37 -0400
X-MC-Unique: oyeO1ZXrOHiWPRnIymeoAQ-1
Received: by mail-qt1-f200.google.com with SMTP id v10-20020a05622a130a00b003e4ee70e001so17685558qtk.6
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 01:05:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680681937;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jtyP2HJ2MI10GZPZtyh9yO+D0mamLiYV4IGTudd6x9k=;
        b=kPEDi16bRbk0OVLseJxmc0j3Fw5aHWXSwInD9gv8pAUhoweVYZ+Lqj0mOTrbDFnf2X
         asNtqrg0K7QEwHzziTieTgwXFSFXp/crnTbtc3OIr7Fv3pIobkOub8WOF8LMlVxC8xOQ
         GwE4gkXt5n27uWTiz3LYkGtd7zJT2dVOOlRQ+q1WxPcpKaoH6mdKffoa5kRukq3W8WMw
         fBj4cotZoXwXBS9iaKonS7V6d5jbziN4YnfdyFTcJCcGSbb3mSN+tt1DIhgYWirCyw5F
         Kewe1pHOHa5h/Qcek/YceZJsOaOLPv0RDix7ACUZGNKAxH1O5lcd4i4y/73d1MQLuObx
         VcYQ==
X-Gm-Message-State: AAQBX9fBHE4Xn6mQJTnB+Q0SELWmCoKcdFOBwm//cjahpDLHS87a51fp
        Fs4jGcBF2VVm+OyvhzvvvLgo3fTThwacnsCuAfdkLlXLqSmH2PWPCBWfCwhJHwU+qc4ZhN1DkKW
        qQ4SwMqtQJdbS
X-Received: by 2002:a05:6214:5081:b0:5df:8661:567f with SMTP id kk1-20020a056214508100b005df8661567fmr7876744qvb.24.1680681937246;
        Wed, 05 Apr 2023 01:05:37 -0700 (PDT)
X-Google-Smtp-Source: AKy350ag+hZEXnDAofxPnplypvshHaeG50C6Ge7/36WtAPNY9S98hVHDQMr2jYmHokelN0jGjmjP2Q==
X-Received: by 2002:a05:6214:5081:b0:5df:8661:567f with SMTP id kk1-20020a056214508100b005df8661567fmr7876724qvb.24.1680681936995;
        Wed, 05 Apr 2023 01:05:36 -0700 (PDT)
Received: from [192.168.8.101] (tmo-066-157.customers.d1-online.com. [80.187.66.157])
        by smtp.gmail.com with ESMTPSA id u7-20020a05621411a700b005dd8b9345ccsm3958869qvv.100.2023.04.05.01.05.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Apr 2023 01:05:36 -0700 (PDT)
Message-ID: <63b56fa9-de91-40df-61ad-654d362f8d12@redhat.com>
Date:   Wed, 5 Apr 2023 10:05:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests GIT PULL v2 11/14] s390x: Add tests for
 execute-type instructions
Content-Language: en-US
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, andrew.jones@linux.dev,
        pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
References: <20230404113639.37544-1-nrb@linux.ibm.com>
 <20230404113639.37544-12-nrb@linux.ibm.com>
 <65075e9f-0d32-fc63-0200-3a3ec0c9bf63@redhat.com>
 <06fd3ebc7770d1327be90cee10d12251cca76dd3.camel@linux.ibm.com>
 <bf0f892e-7b7d-5806-b038-8392144da644@redhat.com>
 <168062836004.37806.6096327013940193626@t14-nrb>
 <5098eca038dfbd3e394e75d44ca061d64f9446f5.camel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <5098eca038dfbd3e394e75d44ca061d64f9446f5.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/04/2023 20.06, Nina Schoetterl-Glausch wrote:
> On Tue, 2023-04-04 at 19:12 +0200, Nico Boehr wrote:
>> Quoting Thomas Huth (2023-04-04 17:05:02)
>> [...]
>>>>> FWIW, this is failing with Clang 15 for me:
>>>>>
>>>>> s390x/ex.c:81:4: error: expected absolute expression
>>>>>                    "       .if (1b - 0b) != (3b - 2b)\n"
>>>>>                     ^
>>>>> <inline asm>:12:6: note: instantiated into assembly here
>>>>>            .if (1b - 0b) != (3b - 2b)
>>>>
>>>> Seems gcc is smarter here than clang.
>>>
>>> Yeah, the assembler from clang is quite a bit behind on s390x ... in the
>>> past I was only able to compile the k-u-t with Clang when using the
>>> "-no-integrated-as" option ... but at least in the most recent version it
>>> seems to have caught up now enough to be very close to compile it with the
>>> built-in assembler, so it would be great to get this problem here fixed
>>> somehow, too...
>>
>> Bringing up another option: Can we maybe guard this section from Clang so we still have the assertion when compiling with GCC?
> 
> I considered this, but only from the asm, where I don't think it's possible.
> But putting #ifndef __clang__ around it works. Until you compile with gcc and assemble with clang.
> Not something we need to care about IMO.

Right. So if the #ifndef works, let's go with that! Nico, could you fix it 
up in the pull request?

  Thanks,
   Thomas

