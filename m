Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40D61255508
	for <lists+kvm@lfdr.de>; Fri, 28 Aug 2020 09:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728442AbgH1HYT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Aug 2020 03:24:19 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:51438 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726825AbgH1HYS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 28 Aug 2020 03:24:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598599457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D08Gt3rzsthLcT7FAo8R0SE10TwpO6VLHPCLceYlpfE=;
        b=IfbenY3l59GACtdtCSZ7dW6bdNsfwRH5FoRYlOV7FFAu/mDVfJ+0cbxcdGL5TEQuswNtDR
        vWptDWZtSYWeu6wRb+lwwtlUjYeKHP/uJk0rO9Eqr6boXH5HfKeDXelybEuBAucOTH08Sf
        N9Ct63y5NEZtfJzLBqDr8NjMpEF8mxY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-CQtE9oI7P76sD8DftaRcQA-1; Fri, 28 Aug 2020 03:24:13 -0400
X-MC-Unique: CQtE9oI7P76sD8DftaRcQA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 224DB801ADA;
        Fri, 28 Aug 2020 07:24:12 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-79.ams2.redhat.com [10.36.112.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 446435C1C2;
        Fri, 28 Aug 2020 07:24:11 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 1/7] x86: Makefile: Allow division on
 x86_64-elf binutils
To:     Roman Bolshakov <r.bolshakov@yadro.com>
Cc:     kvm@vger.kernel.org, Cameron Esfahani <dirty@apple.com>
References: <20200810130618.16066-1-r.bolshakov@yadro.com>
 <20200810130618.16066-2-r.bolshakov@yadro.com>
 <ee81540c-9064-4650-8784-d4531eec042c@redhat.com>
 <20200828065417.GA54274@SPB-NB-133.local>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <e3589b43-df3f-b413-a3b9-1f032da48571@redhat.com>
Date:   Fri, 28 Aug 2020 09:24:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200828065417.GA54274@SPB-NB-133.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/08/2020 08.54, Roman Bolshakov wrote:
> On Fri, Aug 28, 2020 at 07:00:19AM +0200, Thomas Huth wrote:
>> On 10/08/2020 15.06, Roman Bolshakov wrote:
>>> For compatibility with other SVR4 assemblers, '/' starts a comment on
>>> *-elf binutils target and thus division operator is not allowed [1][2].
>>> That breaks cstart64.S build:
>>>
>>>   x86/cstart64.S: Assembler messages:
>>>   x86/cstart64.S:294: Error: unbalanced parenthesis in operand 1.
>>>
>>> The option is ignored on the Linux target of GNU binutils.
>>>
>>> 1. https://sourceware.org/binutils/docs/as/i386_002dChars.html
>>> 2. https://sourceware.org/binutils/docs/as/i386_002dOptions.html#index-_002d_002ddivide-option_002c-i386
>>>
>>> Cc: Cameron Esfahani <dirty@apple.com>
>>> Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
>>> ---
>>>  x86/Makefile | 2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> diff --git a/x86/Makefile b/x86/Makefile
>>> index 8a007ab..22afbb9 100644
>>> --- a/x86/Makefile
>>> +++ b/x86/Makefile
>>> @@ -1 +1,3 @@
>>>  include $(SRCDIR)/$(TEST_DIR)/Makefile.$(ARCH)
>>> +
>>> +COMMON_CFLAGS += -Wa,--divide
>>
>> Some weeks ago, I also played with an elf cross compiler and came to the
>> same conclusion, that we need this option there. Unfortunately, it does
>> not work with clang:
>>
>>  https://gitlab.com/huth/kvm-unit-tests/-/jobs/707986800#L1629
>>
>> You could try to wrap it with "cc-option" instead ... or use a proper
>> check in the configure script to detect whether it's needed or not.
>>
> 
> Hi Thomas,
> 
> Thanks for reviewing the series. I'll look into both options and will
> test with both gcc and clang afterwards. I can also update .travis.yml
> in a new patch to test the build on macOS.

That would be great, thanks! Note that you need at least Clang v10 (the
one from Fedora 32 is fine) to compile the kvm-unit-tests.

And if it's of any help, this was the stuff that I used in .travis.yml
for my experiments (might still be incomplete, though):

    - os: osx
      osx_image: xcode12
      addons:
        homebrew:
          packages:
            - bash
            - coreutils
            - qemu
            - x86_64-elf-gcc
      env:
      - CONFIG="--cross-prefix=x86_64-elf-"
      - BUILD_DIR="build"
      - TESTS="umip"
      - ACCEL="tcg"

    - os: osx
      osx_image: xcode12
      addons:
        homebrew:
          packages:
            - bash
            - coreutils
            - qemu
            - i386-elf-gcc
      env:
      - CONFIG="--arch=i386 --cross-prefix=x86_64-elf-"
      - BUILD_DIR="build"
      - TESTS="umip"
      - ACCEL="tcg"

 Thomas

