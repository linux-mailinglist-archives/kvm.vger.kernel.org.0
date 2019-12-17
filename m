Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FEFC1221CC
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 03:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbfLQCDh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 21:03:37 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22065 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726133AbfLQCDh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 21:03:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576548216;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qb6ycg9Jtpm1pqllR4//ECH2Vy7q4wB/WHbESoK19Iw=;
        b=PT/ghdEYFnuHE3TtEKVkqQlv5NnmiFI0kqEsWx0RX8/TaKNxIqMxM06jmknf46SvzNxURV
        Iv9kl2pinlx7hmp13S0PY35zsgBm6F/Xe9F7TMH7vBC9AM2I7GA0qSwtQ+8nut5HNU+jNo
        aOcxyiivmW43GSEPjD+LVJSh5HkFo1c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-111-icpkRlrsNmKi_MMD9N3NPQ-1; Mon, 16 Dec 2019 21:03:33 -0500
X-MC-Unique: icpkRlrsNmKi_MMD9N3NPQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D99D800D41;
        Tue, 17 Dec 2019 02:03:32 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-16.bne.redhat.com [10.64.54.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1A9356135E;
        Tue, 17 Dec 2019 02:03:26 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH 3/3] kvm/arm: Standardize kvm exit reason field
To:     Marc Zyngier <maz@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com,
        paulus@ozlabs.org, jhogan@kernel.org, drjones@redhat.com
References: <20191212024512.39930-4-gshan@redhat.com>
 <2e960d77afc7ac75f1be73a56a9aca66@www.loen.fr>
 <f101e4a6-bebf-d30f-3dfe-99ded0644836@redhat.com>
 <30c0da369a898143246106205cb3af59@www.loen.fr>
 <b7b6b18c-1d51-b0c2-32df-95e0b7a7c1e5@redhat.com>
 <87r214aazb.fsf@vitty.brq.redhat.com>
 <e1765768e2cd51f28211335e96fa3a31@www.loen.fr>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <08c46c6b-cba7-66c9-797e-baa2107ae434@redhat.com>
Date:   Tue, 17 Dec 2019 13:03:23 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <e1765768e2cd51f28211335e96fa3a31@www.loen.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/16/19 8:35 PM, Marc Zyngier wrote:
> On 2019-12-16 09:14, Vitaly Kuznetsov wrote:
>> Gavin Shan <gshan@redhat.com> writes:
>>
>>> On 12/13/19 8:47 PM, Marc Zyngier wrote:
>>>> On 2019-12-13 00:50, Gavin Shan wrote:
>>>>>
>>>>> Yeah, I think it is ABI change unfortunately, but I'm not sure how
>>>>> many applications are using this filter.
>>>>
>>>> Nobody can tell. The problem is that someone will write a script tha=
t
>>>> parses this trace point based on an older kernel release (such as
>>>> what the distros are shipping today), and two years from now will
>>>> shout at you (and me) for having broken their toy.
>>>>
>>>
>>> Well, I would like to receive Vitaly's comments here. Vitaly, it seem=
s it's
>>> more realistic to fix the issue from kvm_stat side according to the c=
omments
>>> given by Marc?
>>>
>>
>> Sure, if we decide to treat tracepoints as ABI then fixing users is
>> likely the way to go. Personally, I think that we should have certain
>> freedom with them and consider only tools which live in linux.git when
>> making changes (and changing the tool to match in the same patch serie=
s
>> is OK from this PoV, no need to support all possible versions of the
>> tool).
>=20
> So far, the approach has been a pretty conservative one, and there was
> countless discussions (including a pretty heated one at KS two years ag=
o,
> see [1] which did set the tone for the whole of the discussion).
>=20
> So as far as I have something to say about this, we're not renaming fie=
lds
> in existing tracepoints.
>=20
>> Also, we can be a bit more conservative and in this particular case
>> instead of renaming fields just add 'exit_reason' to all architectures
>> where it's missing. For ARM, 'esr_ec' will then stay with what it is a=
nd
>> 'exit_reason' may contain something different (like the information wh=
y
>> the guest exited actually). But I don't know much about ARM specifics
>> and I'm not sure how feasible the suggestion would be.
>=20
> It should be possible to /extend/ tracepoints without breaking compatib=
ility,
> and I don't have any issue with that. This could either report the unmo=
dified
> 'ret' value, or something more synthetic. It really depends on what you=
 want
> this information for.
>=20
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 M.
>=20
> [1] https://lwn.net/Articles/737532/
>

The extension means to add a new field "exit_reason" for aarch64. We can'=
t
delete or rename the existing fields in order to keep the compatibility.
Also, the newly added field ("exit_reason") will carry duplicated informa=
tion
that have been carried by "ret" and "esr_ec". I guess it's going to make =
the
interface ugly. So I personally prefer to fix the issue from "kvm_stat" a=
nd
I'm going to post a v2 patch for this shortly.

Thanks again to Vitaly and Marc for your comments :)

Regards,
Gavin

