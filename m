Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBAC713B49A
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2020 22:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbgANVqs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jan 2020 16:46:48 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59142 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726491AbgANVqs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jan 2020 16:46:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579038406;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0xtlsaPLjAl7tvVqVQdTzazGfWkgCUX/G+W6Mu7T220=;
        b=i+jHnAxnE+gwE+nDONVkaJYQbBe3XlWuA8Z5MtyZxojK9PkyYidYIY0hrhsVvBoJFTokBY
        wEuWKgYSspFdkVD7mfpT5YWBCmQW4bzK7CRFh9rsKaLsmhCZB5sipaD3VT5VzLf0znvL8x
        SKq++qCJejA7+x1PekIHrNdhKkAMq7I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-380-cJYXOS4TMs6dnhtgxCx1Pg-1; Tue, 14 Jan 2020 16:46:45 -0500
X-MC-Unique: cJYXOS4TMs6dnhtgxCx1Pg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F1D1B1883520;
        Tue, 14 Jan 2020 21:46:43 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-21.bne.redhat.com [10.64.54.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A76B05C1D6;
        Tue, 14 Jan 2020 21:46:39 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v2] tools/kvm_stat: Fix kvm_exit filter name
From:   Gavin Shan <gshan@redhat.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com,
        vkuznets@redhat.com, maz@kernel.org
References: <20191217020600.10268-1-gshan@redhat.com>
 <20191218084538.qnnnla6rqcnoeeah@kamzik.brq.redhat.com>
 <6aa080d0-05a3-cbfc-ada0-4482be152fc2@redhat.com>
Message-ID: <22583235-4e37-105b-df0e-ba5888498ae2@redhat.com>
Date:   Wed, 15 Jan 2020 08:46:35 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <6aa080d0-05a3-cbfc-ada0-4482be152fc2@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/19/19 2:33 PM, Gavin Shan wrote:
> On 12/18/19 7:45 PM, Andrew Jones wrote:
>> On Tue, Dec 17, 2019 at 01:06:00PM +1100, Gavin Shan wrote:
>>> The filter name is fixed to "exit_reason" for some kvm_exit events, n=
o
>>> matter what architect we have. Actually, the filter name ("exit_reaso=
n")
>>> is only applicable to x86, meaning it's broken on other architects
>>> including aarch64.
>>>
>>> This fixes the issue by providing various kvm_exit filter names, depe=
nding
>>> on architect we're on. Afterwards, the variable filter name is picked=
 and
>>> applied by ioctl(fd, SET_FILTER).
>>>
>>> Reported-by: Andrew Jones <drjones@redhat.com>
>>
>> This wasn't reported by me - I was just the middleman. Credit should g=
o
>> to Jeff Bastian <jbastian@redhat.com>
>>
>=20
> Sure. Paolo, please let me know if I need post a v3 to fix it up :)
>=20

Ping, Paolo :)

>>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>>> ---
>>> v2: Rename exit_field to exit_reason_field
>>> =C2=A0=C2=A0=C2=A0=C2=A0 Fix the name to esr_ec for aarch64
>>> ---
>>> =C2=A0 tools/kvm/kvm_stat/kvm_stat | 8 ++++++--
>>> =C2=A0 1 file changed, 6 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/tools/kvm/kvm_stat/kvm_stat b/tools/kvm/kvm_stat/kvm_sta=
t
>>> index ad1b9e646c49..4cf93110c259 100755
>>> --- a/tools/kvm/kvm_stat/kvm_stat
>>> +++ b/tools/kvm/kvm_stat/kvm_stat
>>> @@ -270,6 +270,7 @@ class ArchX86(Arch):
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 def __init__(self, exit_reasons):
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.sc_perf_e=
vt_open =3D 298
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.ioctl_num=
bers =3D IOCTL_NUMBERS
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.exit_reason_field =3D=
 'exit_reason'
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.exit_reas=
ons =3D exit_reasons
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 def debugfs_is_child(self, field):
>>> @@ -289,6 +290,7 @@ class ArchPPC(Arch):
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 # numbers depe=
nd on the wordsize.
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 char_ptr_size =
=3D ctypes.sizeof(ctypes.c_char_p)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.ioctl_num=
bers['SET_FILTER'] =3D 0x80002406 | char_ptr_size << 16
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.exit_reason_field =3D=
 'exit_nr'
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.exit_reas=
ons =3D {}
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 def debugfs_is_child(self, field):
>>> @@ -300,6 +302,7 @@ class ArchA64(Arch):
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 def __init__(self):
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.sc_perf_e=
vt_open =3D 241
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.ioctl_num=
bers =3D IOCTL_NUMBERS
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.exit_reason_field =3D=
 'esr_ec'
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.exit_reas=
ons =3D AARCH64_EXIT_REASONS
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 def debugfs_is_child(self, field):
>>> @@ -311,6 +314,7 @@ class ArchS390(Arch):
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 def __init__(self):
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.sc_perf_e=
vt_open =3D 331
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.ioctl_num=
bers =3D IOCTL_NUMBERS
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.exit_reason_field =3D=
 None
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 self.exit_reas=
ons =3D None
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 def debugfs_is_child(self, field):
>>> @@ -541,8 +545,8 @@ class TracepointProvider(Provider):
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 """
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 filters =3D {}
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 filters['kvm_u=
serspace_exit'] =3D ('reason', USERSPACE_EXIT_REASONS)
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if ARCH.exit_reasons:
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 f=
ilters['kvm_exit'] =3D ('exit_reason', ARCH.exit_reasons)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if ARCH.exit_reason_field=
 and ARCH.exit_reasons:
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 f=
ilters['kvm_exit'] =3D (ARCH.exit_reason_field, ARCH.exit_reasons)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return filters
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 def _get_available_fields(self):
>>> --=20
>>> 2.23.0
>>>
>>
>> Looks like a reasonable fix to me.
>>
>> Reviewed-by: Andrew Jones <drjones@redhat.com>
>>
>=20
> Thanks for the review and comments.
>=20
> Regards,
> Gavin
>=20

