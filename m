Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 036612B43C1
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 13:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728695AbgKPM3h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 07:29:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727895AbgKPM3h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 07:29:37 -0500
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BB23C0613CF;
        Mon, 16 Nov 2020 04:29:37 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4CZT0Z6L5sz9sPB;
        Mon, 16 Nov 2020 23:29:34 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1605529774;
        bh=9E6JzyfDdjUQLEqbF7UI53b0Chv12+R9IYyhrZU8bFM=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=rmPfVp13hL1v/7EmT4rYsbfw1Am6SIA3S7arhMzW29Rq7yowZG9hEgpOTnST9xzXP
         mD+QiCcDuS2Ec1TRyCZBYMzBNtyilemUsWAKEtNjrAqme3gFYURjQvVBLjOhzxWEJu
         R5uDld+LWjx6LLmxKBl7SX3ZT0XfWnhT0p+ES46dswu1tUD+qKsuXoea4jOpWMrnUg
         dbNZdxmVdtPfs6KF3WeWlGoBNWxvZZxO3PV3lAMwsx6RyfqKv12hBG3Vaxhf2oikob
         0aMVyN6DmzjvcO/+Vr5HV1G+AU7Cz24jt3YIK66K9z64Z5bSzvd616oDy4Tb5BORwa
         IUhr6jS+/0ZUg==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     =?utf-8?Q?C=C3=A9dric?= Le Goater <clg@kaod.org>,
        Paul Mackerras <paulus@samba.org>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, Greg Kurz <groug@kaod.org>,
        Gustavo Romero <gromero@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH] KVM: PPC: Book3S HV: XIVE: Fix possible oops when accessing ESB page
In-Reply-To: <1270ada4-e2a9-6a1a-52a9-b5c3479c05ea@kaod.org>
References: <20201105134713.656160-1-clg@kaod.org> <878sbftbnt.fsf@mpe.ellerman.id.au> <1270ada4-e2a9-6a1a-52a9-b5c3479c05ea@kaod.org>
Date:   Mon, 16 Nov 2020 23:29:33 +1100
Message-ID: <875z654h8y.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

C=C3=A9dric Le Goater <clg@kaod.org> writes:
> On 11/6/20 4:19 AM, Michael Ellerman wrote:
>> C=C3=A9dric Le Goater <clg@kaod.org> writes:
>>> When accessing the ESB page of a source interrupt, the fault handler
>>> will retrieve the page address from the XIVE interrupt 'xive_irq_data'
>>> structure. If the associated KVM XIVE interrupt is not valid, that is
>>> not allocated at the HW level for some reason, the fault handler will
>>> dereference a NULL pointer leading to the oops below :
>>>
>>>     WARNING: CPU: 40 PID: 59101 at arch/powerpc/kvm/book3s_xive_native.=
c:259 xive_native_esb_fault+0xe4/0x240 [kvm]
>>>     CPU: 40 PID: 59101 Comm: qemu-system-ppc Kdump: loaded Tainted: G  =
      W        --------- -  - 4.18.0-240.el8.ppc64le #1
>>>     NIP:  c00800000e949fac LR: c00000000044b164 CTR: c00800000e949ec8
>>>     REGS: c000001f69617840 TRAP: 0700   Tainted: G        W        ----=
----- -  -  (4.18.0-240.el8.ppc64le)
>>>     MSR:  9000000000029033 <SF,HV,EE,ME,IR,DR,RI,LE>  CR: 44044282  XER=
: 00000000
>>>     CFAR: c00000000044b160 IRQMASK: 0
>>>     GPR00: c00000000044b164 c000001f69617ac0 c00800000e96e000 c000001f6=
9617c10
>>>     GPR04: 05faa2b21e000080 0000000000000000 0000000000000005 fffffffff=
fffffff
>>>     GPR08: 0000000000000000 0000000000000001 0000000000000000 000000000=
0000001
>>>     GPR12: c00800000e949ec8 c000001ffffd3400 0000000000000000 000000000=
0000000
>>>     GPR16: 0000000000000000 0000000000000000 0000000000000000 000000000=
0000000
>>>     GPR20: 0000000000000000 0000000000000000 c000001f5c065160 c00000000=
1c76f90
>>>     GPR24: c000001f06f20000 c000001f5c065100 0000000000000008 c000001f0=
eb98c78
>>>     GPR28: c000001dcab40000 c000001dcab403d8 c000001f69617c10 000000000=
0000011
>>>     NIP [c00800000e949fac] xive_native_esb_fault+0xe4/0x240 [kvm]
>>>     LR [c00000000044b164] __do_fault+0x64/0x220
>>>     Call Trace:
>>>     [c000001f69617ac0] [0000000137a5dc20] 0x137a5dc20 (unreliable)
>>>     [c000001f69617b50] [c00000000044b164] __do_fault+0x64/0x220
>>>     [c000001f69617b90] [c000000000453838] do_fault+0x218/0x930
>>>     [c000001f69617bf0] [c000000000456f50] __handle_mm_fault+0x350/0xdf0
>>>     [c000001f69617cd0] [c000000000457b1c] handle_mm_fault+0x12c/0x310
>>>     [c000001f69617d10] [c00000000007ef44] __do_page_fault+0x264/0xbb0
>>>     [c000001f69617df0] [c00000000007f8c8] do_page_fault+0x38/0xd0
>>>     [c000001f69617e30] [c00000000000a714] handle_page_fault+0x18/0x38
>>>     Instruction dump:
>>>     40c2fff0 7c2004ac 2fa90000 409e0118 73e90001 41820080 e8bd0008 7c20=
04ac
>>>     7ca90074 39400000 915c0000 7929d182 <0b090000> 2fa50000 419e0080 e8=
9e0018
>>>     ---[ end trace 66c6ff034c53f64f ]---
>>>     xive-kvm: xive_native_esb_fault: accessing invalid ESB page for sou=
rce 8 !
>>>
>>> Fix that by checking the validity of the KVM XIVE interrupt structure.
>>>
>>> Reported-by: Greg Kurz <groug@kaod.org>
>>> Signed-off-by: C=C3=A9dric Le Goater <clg@kaod.org>
>>=20
>> Fixes ?
>
> Ah yes :/=20=20
>
> Cc: stable@vger.kernel.org # v5.2+
> Fixes: 6520ca64cde7 ("KVM: PPC: Book3S HV: XIVE: Add a mapping for the so=
urce ESB pages")
>
> Since my provider changed its imap servers, my email filters are really s=
crewed=20
> up and I miss emails.=20
>
> Sorry about that,

No worries.

It doesn't look like Paul has grabbed this, so I'll take it.

cheers
