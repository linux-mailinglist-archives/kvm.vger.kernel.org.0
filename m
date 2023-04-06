Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C73FF6D94A6
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 13:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233391AbjDFLEp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 07:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236569AbjDFLEn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 07:04:43 -0400
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89D6A8A7D;
        Thu,  6 Apr 2023 04:04:23 -0700 (PDT)
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-946a769ae5cso101055066b.1;
        Thu, 06 Apr 2023 04:04:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680779062; x=1683371062;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KITffEh21kVUliy1VoMjvw87Ra13t1dF1yglnrdIiXg=;
        b=usylqcl/wK/WcBMCB9Hu/nARTEaCavpn8np7neoYl7ECcd2EtGYteDhzELH2v9HJdP
         V3I2ZjeSUTpSM4HERKvvKyFhczrc+FgRxhfZXxpvPSQk4Yhln+TLijlhXraBs72Ykg6f
         i7+21elxMtSS/J8WejMVs4oIhQ4PlxquPYUdhsTlXP69CLHvNPh5jmYKjTQSp0sLXLIk
         VRj+rF+IGLVr3Q6eLbvFeGUl4OMUDsB5lCEXfAlZiFfhIykixbDWahp8GhdGaCMP5JNA
         Tjrv+xiZRUdm5mUyjWfbuX7Br+eh53wz5xgwBQvcHT4NcF4afCmIWVP4pJryGxPCMkPq
         gg8Q==
X-Gm-Message-State: AAQBX9fQ6AXFIes6LE7BHc+miCJBUGyUASVOZ8h/dg8U+sp51LaiA/LK
        jZvco0tkeGx7tkfmdUGEYfk=
X-Google-Smtp-Source: AKy350bPuWpFa8lsTNUvA8+kwvxRwcrPzqvVF0WOgFdBH+8jM2uv4ltcv5/bo9+HatYAa9uEjqf0mA==
X-Received: by 2002:aa7:de8e:0:b0:4fb:395a:6aa4 with SMTP id j14-20020aa7de8e000000b004fb395a6aa4mr4899183edv.31.1680779061830;
        Thu, 06 Apr 2023 04:04:21 -0700 (PDT)
Received: from [192.168.1.49] (185-219-167-24-static.vivo.cz. [185.219.167.24])
        by smtp.gmail.com with ESMTPSA id 23-20020a508e17000000b00501dac14d7asm617927edw.3.2023.04.06.04.04.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Apr 2023 04:04:21 -0700 (PDT)
Message-ID: <be836a4f-fc0f-bbcd-636d-4766fdd33c81@kernel.org>
Date:   Thu, 6 Apr 2023 13:04:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Dave Hansen <dave.hansen@intel.com>,
        linux-kernel@vger.kernel.org,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Andy Lutomirski <luto@kernel.org>,
        Asit Mallick <asit.k.mallick@intel.com>,
        Cfir Cohen <cfir@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        David Kaplan <David.Kaplan@amd.com>,
        David Rientjes <rientjes@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Joerg Roedel <joro@8bytes.org>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Kuppuswamy Sathyanarayanan <knsathya@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Stunes <mstunes@vmware.com>,
        Raj Ashok <ashok.raj@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, x86@kernel.org
References: <20230403140605.540512-1-jiangshanlai@gmail.com>
 <19035c40-e756-6efd-1c02-b09109fb44c1@intel.com>
 <CAJhGHyBHmC=UXr88GsykO9eUeqJZp59jrCH3ngkFiCxVBW2F3g@mail.gmail.com>
 <3591487f-96ae-3ab7-6ce7-e524a070c9e7@redhat.com>
 <20230406101254.GI386572@hirez.programming.kicks-ass.net>
 <26be2c81-9431-6b43-e3e9-52d7d184750e@kernel.org>
 <20230406104750.GA392176@hirez.programming.kicks-ass.net>
Content-Language: en-US
From:   Jiri Slaby <jirislaby@kernel.org>
Subject: Re: [RFC PATCH 0/7] x86/entry: Atomic statck switching for IST
In-Reply-To: <20230406104750.GA392176@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06. 04. 23, 12:47, Peter Zijlstra wrote:
> On Thu, Apr 06, 2023 at 12:35:24PM +0200, Jiri Slaby wrote:
>> On 06. 04. 23, 12:12, Peter Zijlstra wrote:
>>> On Tue, Apr 04, 2023 at 07:03:45PM +0200, Paolo Bonzini wrote:
>>>> On 4/4/23 05:17, Lai Jiangshan wrote:
>>>>> The cover letter has 800+ lines of comments.  About 100-300 lines
>>>>> of comments will be moved into the code which would make the diffstat
>>>>> not so appealing.
>>>>
>>>> Removing assembly from arch/x86/entry/ and adding English to Documentation/?
>>>> That's _even more_ appealing. :)
>>>
>>> I *much* prefer in-code comments to random gibberish that's instantly
>>> out of date squirreled away somewhere in an unreadable format in
>>> Documentation/
>>
>> +1 as one can link comments in the code to Documentation easily nowadays.
>> They are sourced and end up in the generated Documentation [1] then. One
>> only needs to type the kernel-doc properly.
> 
> Urgh, so that kernel doc stuff can defeat its purpose too. Some of that
> is so heavily formatted it is unreadable gibberish just like
> Documentation/ :/

Definitely it _can_ defeat the purpose and be heavily formatted.But it 
doesn't have to. It's like programming in perl.

What I had in mind was e.g. "DOC: TTY Struct Flags":
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/linux/tty.h#n261

Resulting in:
https://www.kernel.org/doc/html/latest/driver-api/tty/tty_struct.html#tty-struct-flags

Both the source and the result are quite readable, IMO. And the markup 
in the source is not mandatory, it's only for emphasizing and hyperlinks.

As I wrote, you can link the comment in the code. But definitely you 
don't have to, if you don't want. I like the linking in Documentation as 
I can put the pieces from various sources/headers together to one place 
and build a bigger picture.

> I really detest that whole RST thing, and my solution is to explicitly
> not write kerneldoc, that way the doc generation stuff doesn't complain
> and I don't get random drive by patches wrecking the perfectly readable
> comment.

Sure. Rst _sources_ are not readable, IMO. Only generated man pages or 
html are.

thanks,
-- 
js

