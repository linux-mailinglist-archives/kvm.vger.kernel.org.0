Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46C6511EE53
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2019 00:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbfLMXO4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 18:14:56 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40472 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725818AbfLMXOz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Dec 2019 18:14:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576278893;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SdHXowt6Xzsk+tZz1HAWekszbuLQcKwnX92bxBXyzTQ=;
        b=L/5ZFOGLeStjXz31Xi0cObuOMayTJ+iE9exEk9g1tPv59Vp+CXc7z5ixCZbX5RgU/8e9rZ
        knpsV+yGFGDDX7bZ9uvXQ8OeYTNRSx+uUNTBJVnRoZp6M+DrpvlcOtEb2VX2yb3VfE3WX+
        Eraj4AobEomQc3n4tfkONeAq7J21Mk8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-fzfq2RdhNgiK0v4vaSf3rA-1; Fri, 13 Dec 2019 18:14:52 -0500
X-MC-Unique: fzfq2RdhNgiK0v4vaSf3rA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 17C488017DF;
        Fri, 13 Dec 2019 23:14:51 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-16.bne.redhat.com [10.64.54.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DB2C11CB;
        Fri, 13 Dec 2019 23:14:45 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH 3/3] kvm/arm: Standardize kvm exit reason field
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com,
        paulus@ozlabs.org, jhogan@kernel.org, drjones@redhat.com,
        vkuznets@redhat.com
References: <20191212024512.39930-4-gshan@redhat.com>
 <2e960d77afc7ac75f1be73a56a9aca66@www.loen.fr>
 <f101e4a6-bebf-d30f-3dfe-99ded0644836@redhat.com>
 <30c0da369a898143246106205cb3af59@www.loen.fr>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <b7b6b18c-1d51-b0c2-32df-95e0b7a7c1e5@redhat.com>
Date:   Sat, 14 Dec 2019 10:14:42 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <30c0da369a898143246106205cb3af59@www.loen.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/13/19 8:47 PM, Marc Zyngier wrote:
> On 2019-12-13 00:50, Gavin Shan wrote:
>> On 12/12/19 8:23 PM, Marc Zyngier wrote:
>>> On 2019-12-12 02:45, Gavin Shan wrote:
>>>> This standardizes kvm exit reason field name by replacing "esr_ec"
>>>> with "exit_reason".
>>>>
>>>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>>>> ---
>>>> =C2=A0virt/kvm/arm/trace.h | 14 ++++++++------
>>>> =C2=A01 file changed, 8 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/virt/kvm/arm/trace.h b/virt/kvm/arm/trace.h
>>>> index 204d210d01c2..0ac774fd324d 100644
>>>> --- a/virt/kvm/arm/trace.h
>>>> +++ b/virt/kvm/arm/trace.h
>>>> @@ -27,25 +27,27 @@ TRACE_EVENT(kvm_entry,
>>>> =C2=A0);
>>>>
>>>> =C2=A0TRACE_EVENT(kvm_exit,
>>>> -=C2=A0=C2=A0=C2=A0 TP_PROTO(int ret, unsigned int esr_ec, unsigned =
long vcpu_pc),
>>>> -=C2=A0=C2=A0=C2=A0 TP_ARGS(ret, esr_ec, vcpu_pc),
>>>> +=C2=A0=C2=A0=C2=A0 TP_PROTO(int ret, unsigned int exit_reason, unsi=
gned long vcpu_pc),
>>>> +=C2=A0=C2=A0=C2=A0 TP_ARGS(ret, exit_reason, vcpu_pc),
>>>>
>>>> =C2=A0=C2=A0=C2=A0=C2=A0 TP_STRUCT__entry(
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __field(=C2=A0=C2=A0=
=C2=A0 int,=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 )
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __field(=C2=A0=C2=A0=C2=A0=
 unsigned int,=C2=A0=C2=A0=C2=A0 esr_ec=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 )
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __field(=C2=A0=C2=A0=C2=A0=
 unsigned int,=C2=A0=C2=A0=C2=A0 exit_reason=C2=A0=C2=A0=C2=A0 )
>>> I don't think the two are the same thing. The exit reason should be
>>> exactly that: why has the guest exited (exception, host interrupt, tr=
ap).
>>> What we're reporting here is the exception class, which doesn't apply=
 to
>>> interrupts, for example (hence the 0 down below, which we treat as a
>>> catch-all).
>>>
>>
>> Marc, thanks a lot for your reply. Yeah, the combination (ret and esr_=
ec) is
>> complete to indicate the exit reasons if I'm understanding correctly.
>>
>> The exit reasons seen by kvm_stat is exactly the ESR_EL1[EC]. It's dec=
lared
>> by marcro AARCH64_EXIT_REASONS in tools/kvm/kvm_stat/kvm_stat. So
>> it's precise
>> and complete from perspective of kvm_stat.
>>
>> For the patch itself, it standardizes the filter name by renaming "esr=
_ec"
>> to "exit_reason", no functional changes introduced and I think it woul=
d be
>> fine.
>=20
> It may not be a functional change, but it is a semantic change. To me,
> 'exit_reason' means something, and esr_ec something entirely different.
>=20
> But the real blocker is below.
>=20

Agree.

>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __field(=C2=A0=C2=A0=
=C2=A0 unsigned long,=C2=A0=C2=A0=C2=A0 vcpu_pc=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 )
>>>> =C2=A0=C2=A0=C2=A0=C2=A0 ),
>>>>
>>>> =C2=A0=C2=A0=C2=A0=C2=A0 TP_fast_assign(
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __entry->ret=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D ARM_EXCEPTI=
ON_CODE(ret);
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __entry->esr_ec =3D ARM_=
EXCEPTION_IS_TRAP(ret) ? esr_ec : 0;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __entry->exit_reason =3D
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
ARM_EXCEPTION_IS_TRAP(ret) ? exit_reason: 0;
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __entry->vcpu_pc=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D vcpu_pc;
>>>> =C2=A0=C2=A0=C2=A0=C2=A0 ),
>>>>
>>>> =C2=A0=C2=A0=C2=A0=C2=A0 TP_printk("%s: HSR_EC: 0x%04x (%s), PC: 0x%=
08lx",
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __print=
_symbolic(__entry->ret, kvm_arm_exception_type),
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __entry->esr=
_ec,
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __print_symb=
olic(__entry->esr_ec, kvm_arm_exception_class),
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __entry->exi=
t_reason,
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __print_symb=
olic(__entry->exit_reason,
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kvm_arm_exception_class),
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __entry=
->vcpu_pc)
>>>> =C2=A0);
>>> The last thing is whether such a change is an ABI change or not. I've=
 been very
>>> reluctant to change any of this for that reason.
>>>
>>
>> Yeah, I think it is ABI change unfortunately, but I'm not sure how
>> many applications are using this filter.
>=20
> Nobody can tell. The problem is that someone will write a script that
> parses this trace point based on an older kernel release (such as
> what the distros are shipping today), and two years from now will
> shout at you (and me) for having broken their toy.
>=20

Ah, it's not good :)

>> However, the fixed filter name ("exit_reason") is beneficial in long r=
un.
>> The application needn't distinguish architects to provide different
>> tracepoint filters at least.
>=20
> Well, you certainly need to understand the actual semantic behind the
> fields if you want to draw any meaningful conclusion. Otherwise, all
> you need is to measure the frequency of such event.
>=20

Well, I would like to receive Vitaly's comments here. Vitaly, it seems it=
's
more realistic to fix the issue from kvm_stat side according to the comme=
nts
given by Marc?

Thanks,
Gavin

