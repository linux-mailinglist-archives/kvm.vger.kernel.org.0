Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D753F9567
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 17:18:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbfKLQSC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 11:18:02 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:53805 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726388AbfKLQSC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Nov 2019 11:18:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573575481;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XX5t35I7sbj+CcgcVDbYVEUjVF3D5OrIan777i+SG4o=;
        b=ZkuiHSqQsv3xBWAc3ou6oqjSRZSnqB/H8iTwdn60uEkBFBMRprreIZj4+OGCSQ13AXJvU9
        RBxGKoXge7S/k2BLXXlJbpXgkF2fYMgILmzDhbFZUOeVwz0AWMs1sGVDf3456Zr9udbeuU
        RC0rDi1pAD6oRpf8EcSa7c3cE3dlfPw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-362-zVbD4R8FNaeDYxnhq53V0Q-1; Tue, 12 Nov 2019 11:17:58 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4961D107ACC8;
        Tue, 12 Nov 2019 16:17:57 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-124.ams2.redhat.com [10.36.116.124])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B0A786016E;
        Tue, 12 Nov 2019 16:17:52 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 3/3] s390x: Load reset psw on diag308
 reset
To:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org
References: <20191111153345.22505-1-frankja@linux.ibm.com>
 <20191111153345.22505-4-frankja@linux.ibm.com>
 <7683adc7-2cd0-1103-d231-8a1577f1e673@redhat.com>
 <a22f8407-efb1-ab0e-eaf6-77d0b853c6de@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <f3be87c4-135e-dd42-b9b4-aadc0d0c90ca@redhat.com>
Date:   Tue, 12 Nov 2019 17:17:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <a22f8407-efb1-ab0e-eaf6-77d0b853c6de@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: zVbD4R8FNaeDYxnhq53V0Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/11/2019 14.42, Janosch Frank wrote:
> On 11/12/19 1:09 PM, David Hildenbrand wrote:
>> On 11.11.19 16:33, Janosch Frank wrote:
>>> On a diag308 subcode 0 CRs will be reset, so we need a PSW mask
>>> without DAT. Also we need to set the short psw indication to be
>>> compliant with the architecture.
>>>
>>> Let's therefore define a reset PSW mask with 64 bit addressing and
>>> short PSW indication that is compliant with architecture and use it.
>>>
>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>> ---
>>>  lib/s390x/asm-offsets.c  |  1 +
>>>  lib/s390x/asm/arch_def.h |  3 ++-
>>>  s390x/cstart64.S         | 24 +++++++++++++++++-------
>>>  3 files changed, 20 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/lib/s390x/asm-offsets.c b/lib/s390x/asm-offsets.c
>>> index 4b213f8..61d2658 100644
>>> --- a/lib/s390x/asm-offsets.c
>>> +++ b/lib/s390x/asm-offsets.c
>>> @@ -58,6 +58,7 @@ int main(void)
>>>  =09OFFSET(GEN_LC_SW_INT_FPRS, lowcore, sw_int_fprs);
>>>  =09OFFSET(GEN_LC_SW_INT_FPC, lowcore, sw_int_fpc);
>>>  =09OFFSET(GEN_LC_SW_INT_CRS, lowcore, sw_int_crs);
>>> +=09OFFSET(GEN_LC_SW_INT_PSW, lowcore, sw_int_psw);
>>>  =09OFFSET(GEN_LC_MCCK_EXT_SA_ADDR, lowcore, mcck_ext_sa_addr);
>>>  =09OFFSET(GEN_LC_FPRS_SA, lowcore, fprs_sa);
>>>  =09OFFSET(GEN_LC_GRS_SA, lowcore, grs_sa);
>>> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
>>> index 07d4e5e..7d25e4f 100644
>>> --- a/lib/s390x/asm/arch_def.h
>>> +++ b/lib/s390x/asm/arch_def.h
>>> @@ -79,7 +79,8 @@ struct lowcore {
>>>  =09uint32_t=09sw_int_fpc;=09=09=09/* 0x0300 */
>>>  =09uint8_t=09=09pad_0x0304[0x0308 - 0x0304];=09/* 0x0304 */
>>>  =09uint64_t=09sw_int_crs[16];=09=09=09/* 0x0308 */
>>> -=09uint8_t=09=09pad_0x0310[0x11b0 - 0x0388];=09/* 0x0388 */
>>> +=09struct psw=09sw_int_psw;=09=09=09/* 0x0388 */
>>> +=09uint8_t=09=09pad_0x0310[0x11b0 - 0x0390];=09/* 0x0390 */
>>>  =09uint64_t=09mcck_ext_sa_addr;=09=09/* 0x11b0 */
>>>  =09uint8_t=09=09pad_0x11b8[0x1200 - 0x11b8];=09/* 0x11b8 */
>>>  =09uint64_t=09fprs_sa[16];=09=09=09/* 0x1200 */
[...]
>> This patch breaks the smp test under TCG (no clue and no time to look
>> into the details :) ):
>=20
> I forgot to fixup the offset calculation at the top of the patch once
> again...

Maybe add a

_Static_assert(sizeof(struct lowcore) =3D=3D xyz)

after the struct definitions, to avoid that this happens again?

 Thomas

