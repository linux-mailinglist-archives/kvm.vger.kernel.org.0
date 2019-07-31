Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A565D7BC93
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 11:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728417AbfGaJFd convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 31 Jul 2019 05:05:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37228 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726666AbfGaJFa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 05:05:30 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 97F51550CF;
        Wed, 31 Jul 2019 09:05:28 +0000 (UTC)
Received: from ptitpuce (ovpn-116-130.ams2.redhat.com [10.36.116.130])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4423F60852;
        Wed, 31 Jul 2019 09:05:21 +0000 (UTC)
References: <1564502498-805893-1-git-send-email-andrey.shinkevich@virtuozzo.com> <1564502498-805893-4-git-send-email-andrey.shinkevich@virtuozzo.com> <7a78ef04-4120-20d9-d5f4-6572c5676344@redhat.com> <dc9c2e70-c2a6-838e-f191-1c2787e244f5@de.ibm.com>
User-agent: mu4e 1.3.2; emacs 26.2
From:   Christophe de Dinechin <dinechin@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Andrey Shinkevich <andrey.shinkevich@virtuozzo.com>,
        qemu-block@nongnu.org, vsementsov@virtuozzo.com, berto@igalia.com,
        ehabkost@redhat.com, kvm@vger.kernel.org, mtosatti@redhat.com,
        mdroth@linux.vnet.ibm.com, armbru@redhat.com, pbonzini@redhat.com,
        den@openvz.org, rth@twiddle.net
Subject: Re: [Qemu-devel] [PATCH 3/3] i386/kvm: initialize struct at full before ioctl call
In-reply-to: <dc9c2e70-c2a6-838e-f191-1c2787e244f5@de.ibm.com>
Date:   Wed, 31 Jul 2019 11:05:19 +0200
Message-ID: <m136imo9ps.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Wed, 31 Jul 2019 09:05:29 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Christian Borntraeger writes:

> On 30.07.19 18:44, Philippe Mathieu-Daudé wrote:
>> On 7/30/19 6:01 PM, Andrey Shinkevich wrote:
>>> Not the whole structure is initialized before passing it to the KVM.
>>> Reduce the number of Valgrind reports.
>>>
>>> Signed-off-by: Andrey Shinkevich <andrey.shinkevich@virtuozzo.com>
>>> ---
>>>  target/i386/kvm.c | 3 +++
>>>  1 file changed, 3 insertions(+)
>>>
>>> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
>>> index dbbb137..ed57e31 100644
>>> --- a/target/i386/kvm.c
>>> +++ b/target/i386/kvm.c
>>> @@ -190,6 +190,7 @@ static int kvm_get_tsc(CPUState *cs)
>>>          return 0;
>>>      }
>>>
>>> +    memset(&msr_data, 0, sizeof(msr_data));
>>
>> I wonder the overhead of this one...
>
> Cant we use designated initializers like in
>
> commit bdfc8480c50a53d91aa9a513d23a84de0d5fbc86
> Author:     Christian Borntraeger <borntraeger@de.ibm.com>
> AuthorDate: Thu Oct 30 09:23:41 2014 +0100
> Commit:     Paolo Bonzini <pbonzini@redhat.com>
> CommitDate: Mon Dec 15 12:21:01 2014 +0100
>
>     valgrind/i386: avoid false positives on KVM_SET_XCRS ioctl
>
> and others?
>
> This should minimize the impact.

Oh, when you talked about using designated initializers, I thought you
were talking about fully initializing the struct, like so:

diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index dbbb13772a..3533870c43 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -180,19 +180,20 @@ static int kvm_get_tsc(CPUState *cs)
 {
     X86CPU *cpu = X86_CPU(cs);
     CPUX86State *env = &cpu->env;
-    struct {
-        struct kvm_msrs info;
-        struct kvm_msr_entry entries[1];
-    } msr_data;
     int ret;

     if (env->tsc_valid) {
         return 0;
     }

-    msr_data.info.nmsrs = 1;
-    msr_data.entries[0].index = MSR_IA32_TSC;
-    env->tsc_valid = !runstate_is_running();
+    struct {
+        struct kvm_msrs info;
+        struct kvm_msr_entry entries[1];
+    } msr_data = {
+        .info = { .nmsrs =  1 },
+        .entries = { [0] = { .index = MSR_IA32_TSC } }
+    };
+     env->tsc_valid = !runstate_is_running();

     ret = kvm_vcpu_ioctl(CPU(cpu), KVM_GET_MSRS, &msr_data);
     if (ret < 0) {


This gives the compiler maximum opportunities to flag mistakes like
initializing the same thing twice, and make it easier (read no smart
optimizations) to initialize in one go. Moving the declaration past the
'if' also addresses Philippe's concern.

>>
>>>      msr_data.info.nmsrs = 1;
>>>      msr_data.entries[0].index = MSR_IA32_TSC;
>>>      env->tsc_valid = !runstate_is_running();
>>> @@ -1706,6 +1707,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
>>>
>>>      if (has_xsave) {
>>>          env->xsave_buf = qemu_memalign(4096, sizeof(struct kvm_xsave));
>>> +        memset(env->xsave_buf, 0, sizeof(struct kvm_xsave));
>>
>> OK
>>
>>>      }
>>>
>>>      max_nested_state_len = kvm_max_nested_state_length();
>>> @@ -3477,6 +3479,7 @@ static int kvm_put_debugregs(X86CPU *cpu)
>>>          return 0;
>>>      }
>>>
>>> +    memset(&dbgregs, 0, sizeof(dbgregs));
>>
>> OK
>>
>>>      for (i = 0; i < 4; i++) {
>>>          dbgregs.db[i] = env->dr[i];
>>>      }
>>
>> We could remove 'dbgregs.flags = 0;'
>>
>> Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>
>>


--
Cheers,
Christophe de Dinechin (IRC c3d)
