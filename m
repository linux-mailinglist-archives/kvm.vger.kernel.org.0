Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEE97FB46C
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 16:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbfKMP54 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 10:57:56 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41912 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727001AbfKMP54 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 10:57:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573660671;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vIMSaui5PJY4A9zBb7bu2Zk3HkKIPPMmC18Cc/X8cPI=;
        b=B14shQo5t4NHrkwdexu0dV0xZTRCaoew0ydFyWdj/JvQRjDQI70sx/c8gwdH2PCPk8A0F4
        r6URC4BGgd/A1CveLf/Q4Q7PZQUfJG/oIScog3UCV1pyfV2gDCa2GOSOaecD8vBzPeG634
        uevuKdhll04ReZ68rgrdr1/OTM2Q7W0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-KTnOgB2nNJyu-wO8PUYlTg-1; Wed, 13 Nov 2019 10:57:50 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DBC09477
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 15:57:49 +0000 (UTC)
Received: from localhost.localdomain (ovpn-122-119.rdu2.redhat.com [10.10.122.119])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9A411101E58D;
        Wed, 13 Nov 2019 15:57:49 +0000 (UTC)
Subject: Re: [PATCH kvm-unit-tests] svm: run tests with host IF=1
From:   Cathy Avery <cavery@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <1573660209-26331-1-git-send-email-pbonzini@redhat.com>
 <afcc073a-15cc-7ac5-4b26-48667e546cf4@redhat.com>
Message-ID: <b963905f-3a73-1e29-a543-fb34ed196151@redhat.com>
Date:   Wed, 13 Nov 2019 10:57:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <afcc073a-15cc-7ac5-4b26-48667e546cf4@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: KTnOgB2nNJyu-wO8PUYlTg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/13/19 10:55 AM, Cathy Avery wrote:
> On 11/13/19 10:50 AM, Paolo Bonzini wrote:
>> Tests should in general call VMRUN with EFLAGS.IF=3D1 (if there are
>> exceptions in the future we can add a cmp/jz in test_run).=A0 This is
>> because currently interrupts are masked during all of VMRUN, while
>> we usually want interrupts during a test to cause a vmexit.
>> This is similar to how PIN_EXTINT and PIN_NMI are included by
>> default in the VMCS used by vmx.flat.
>>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>> =A0 x86/svm.c | 5 ++++-
>> =A0 1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/x86/svm.c b/x86/svm.c
>> index 4ddfaa4..097a296 100644
>> --- a/x86/svm.c
>> +++ b/x86/svm.c
>> @@ -254,6 +254,7 @@ static void test_run(struct test *test, struct=20
>> vmcb *vmcb)
>> =A0=A0=A0=A0=A0 u64 vmcb_phys =3D virt_to_phys(vmcb);
>> =A0=A0=A0=A0=A0 u64 guest_stack[10000];
>> =A0 +=A0=A0=A0 irq_disable();
>> =A0=A0=A0=A0=A0 test->vmcb =3D vmcb;
>> =A0=A0=A0=A0=A0 test->prepare(test);
>> =A0=A0=A0=A0=A0 vmcb->save.rip =3D (ulong)test_thunk;
>> @@ -269,7 +270,9 @@ static void test_run(struct test *test, struct=20
>> vmcb *vmcb)
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "mov regs, %%r15\n\t"=A0=A0=A0=
=A0=A0=A0 // rax
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "mov %%r15, 0x1f8(%0)\n\t"
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 LOAD_GPR_C
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "sti \n\t"=A0=A0=A0=A0=A0=A0=A0 // on=
ly used if V_INTR_MASKING=3D1
>
> I thought sti was going to be conditional
>
> // entered with IF=3D0
> =A0=A0=A0 clgi
> =A0=A0=A0 cmp=A0=A0=A0 $0, test_host_if
> =A0=A0=A0 jz=A0=A0=A0 1f
> =A0=A0=A0 sti
OK missed the comment above.
>
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "vmrun \n\t"
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "cli \n\t"
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 SAVE_GPR_C
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "mov 0x170(%0), %%r15\n\t"=A0 //=
 rflags
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "mov %%r15, regs+0x80\n\t"
>> @@ -284,6 +287,7 @@ static void test_run(struct test *test, struct=20
>> vmcb *vmcb)
>> =A0=A0=A0=A0=A0 tsc_end =3D rdtsc();
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 ++test->exits;
>> =A0=A0=A0=A0=A0 } while (!test->finished(test));
>> +=A0=A0=A0 irq_enable();
>> =A0 =A0=A0=A0=A0=A0 report("%s", test->succeeded(test), test->name);
>> =A0 }
>> @@ -301,7 +305,6 @@ static bool default_supported(void)
>> =A0 static void default_prepare(struct test *test)
>> =A0 {
>> =A0=A0=A0=A0=A0 vmcb_ident(test->vmcb);
>> -=A0=A0=A0 cli();
>> =A0 }
>> =A0 =A0 static bool default_finished(struct test *test)
>
>

