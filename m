Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0993B2440
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 02:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbhFXA1s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 20:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbhFXA1s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 20:27:48 -0400
Received: from forward101j.mail.yandex.net (forward101j.mail.yandex.net [IPv6:2a02:6b8:0:801:2::101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BAEFC061574
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 17:25:29 -0700 (PDT)
Received: from forward102q.mail.yandex.net (forward102q.mail.yandex.net [IPv6:2a02:6b8:c0e:1ba:0:640:516:4e7d])
        by forward101j.mail.yandex.net (Yandex) with ESMTP id A7E411BE12B1;
        Thu, 24 Jun 2021 03:25:27 +0300 (MSK)
Received: from vla5-6f6229c3d3e6.qloud-c.yandex.net (vla5-6f6229c3d3e6.qloud-c.yandex.net [IPv6:2a02:6b8:c18:3513:0:640:6f62:29c3])
        by forward102q.mail.yandex.net (Yandex) with ESMTP id A0BB93A2000D;
        Thu, 24 Jun 2021 03:25:27 +0300 (MSK)
Received: from vla1-62318bfe5573.qloud-c.yandex.net (vla1-62318bfe5573.qloud-c.yandex.net [2a02:6b8:c0d:3819:0:640:6231:8bfe])
        by vla5-6f6229c3d3e6.qloud-c.yandex.net (mxback/Yandex) with ESMTP id bpfDsz3VMW-PRI8ctZD;
        Thu, 24 Jun 2021 03:25:27 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1624494327;
        bh=DzMelJkWJ5KLV1y/Aoeemfg/ep0BFkWIoyZnq6+ImTA=;
        h=In-Reply-To:To:From:Subject:Message-ID:Cc:Date:References;
        b=v837z4oW0W83E0xYZtg/eaWmOpwI7AG1BUigCgsluJi+laV+iX5Hk3Vr770eetAzF
         ubTYfi0v2Zs+6zvdHfQl81k+Du0fL+Vkk4hiRgu7v59m0HQa1xzk7Gk5CPACMJ9JFB
         bRbr7WpJdpm+qlDusvmcMJOjbDOzBx+LK86d/8lk=
Authentication-Results: vla5-6f6229c3d3e6.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by vla1-62318bfe5573.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id 78ruqLhkSE-PRDOpWMq;
        Thu, 24 Jun 2021 03:25:27 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: exception vs SIGALRM race (with test-case now!)
From:   stsp <stsp2@yandex.ru>
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
References: <bd4a2d30-5fb4-3612-c855-946d97068b9a@yandex.ru>
 <YMeMov42fihXptQm@google.com>
 <73f1f90e-f952-45a4-184e-1aafb3e4a8fd@yandex.ru>
 <YMtfQHGJL7XP/0Rq@google.com>
 <23b00d8a-1732-0b0b-cd8d-e802f7aca87c@yandex.ru>
 <CALMp9eSpJ8=O=6YExpOtdnA=gQkWfQJ+oz0bBcV4gOPFdnciVA@mail.gmail.com>
 <d5bf20f4-9aef-8e7e-8a8f-47d10510724e@yandex.ru>
 <CALMp9eQANi7SPAvue5VQazG7A0=b_2vkUxYK+GMLbzNkxbXM5w@mail.gmail.com>
 <4f40a6e8-07ce-ba12-b3e6-5975ad19a2ff@yandex.ru>
 <cbaa0b83-fc3a-5732-4246-386a0a0ff9b8@yandex.ru>
Message-ID: <60ae8b9f-89af-e8b3-13c4-99ddea1ced90@yandex.ru>
Date:   Thu, 24 Jun 2021 03:25:25 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <cbaa0b83-fc3a-5732-4246-386a0a0ff9b8@yandex.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

24.06.2021 03:11, stsp пишет:
> 24.06.2021 02:38, stsp пишет:
>> The test-case:
>> https://github.com/dosemu2/dosemu2/issues/1500#issuecomment-867215291 
> URL was off 1 comment.
> The right one is:
> https://github.com/dosemu2/dosemu2/issues/1500#issuecomment-867214782
>
> Direct link to the test-case:
> https://github.com/dosemu2/dosemu2/files/6705274/a.exe.gz

What does this test-case do?
It provokes the PF by writing to
the NULL pointer. The PF handler
checks if PF is coming from the
right place, or from the nearby
IRQ8 timer handler. If PF is coming
from the very first instruction of
the timer handler, then we got
that nasty SIGALRM race and
KVM exited to user-space with
the pending PF exception.

How to replicate the buggy setup?
Just install dosemu2 on your
favourite distro using the pre-built packages:
https://github.com/dosemu2/dosemu2/blob/devel/README

How to run the test-case?
On the PC with Intel Core2 CPU,
run this command:
|dosemu -K ./a.exe -T -I 'ignore_djgpp_null_derefs off'|

|After a few seconds it will say
"Race DETECTED" and exit.
If it just keeps printing dots
forever, then your setup is not buggy,
press Ctrl-c to finish test.
|

