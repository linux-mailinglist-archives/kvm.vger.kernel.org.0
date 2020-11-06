Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4752A8D74
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 04:19:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbgKFDTY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 22:19:24 -0500
Received: from ozlabs.org ([203.11.71.1]:41857 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725616AbgKFDTY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Nov 2020 22:19:24 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4CS5GJ6P5lz9sTL;
        Fri,  6 Nov 2020 14:19:20 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1604632760;
        bh=upB+OdOPptkZca4A0vHRjVHuCP8hzlwSbqMBClaLicM=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=qJ8hiAz0METpeZ3963yRt0Jzb0PBu0YXO4oq9ZFKs18InriLjt/82cRLcpaoqmC1Q
         /M/kxadPXmuQkrJVqHAldTcVHF58IwH3DqSRhFwxYTG86r8nj2xy3pHwKlnkmC0WkK
         b9njvJYrUrX9o/bQvNCJ1i0akW/l6vq08+eo77Fq2IDUK4B7ECofYF6uhjLLJ9DGSJ
         EeGmy7ggp7v1atpe+cjCJTQLYuNR9fhX+LOeS4p4YqphwGGlyor7SZZsv883iuwvXO
         syrIEbcwFzqSnGQECQc2w57OR9d87j9dj2wKvOmWZXSJMV2bMSRr0usGE6/LG7fqfg
         AVYD0RHXDLs9A==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     =?utf-8?Q?C=C3=A9dric?= Le Goater <clg@kaod.org>,
        Paul Mackerras <paulus@samba.org>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, Greg Kurz <groug@kaod.org>,
        Gustavo Romero <gromero@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?utf-8?Q?C=C3=A9dric?= Le Goater <clg@kaod.org>
Subject: Re: [PATCH] KVM: PPC: Book3S HV: XIVE: Fix possible oops when accessing ESB page
In-Reply-To: <20201105134713.656160-1-clg@kaod.org>
References: <20201105134713.656160-1-clg@kaod.org>
Date:   Fri, 06 Nov 2020 14:19:18 +1100
Message-ID: <878sbftbnt.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

C=C3=A9dric Le Goater <clg@kaod.org> writes:
> When accessing the ESB page of a source interrupt, the fault handler
> will retrieve the page address from the XIVE interrupt 'xive_irq_data'
> structure. If the associated KVM XIVE interrupt is not valid, that is
> not allocated at the HW level for some reason, the fault handler will
> dereference a NULL pointer leading to the oops below :
>
>     WARNING: CPU: 40 PID: 59101 at arch/powerpc/kvm/book3s_xive_native.c:=
259 xive_native_esb_fault+0xe4/0x240 [kvm]
>     CPU: 40 PID: 59101 Comm: qemu-system-ppc Kdump: loaded Tainted: G    =
    W        --------- -  - 4.18.0-240.el8.ppc64le #1
>     NIP:  c00800000e949fac LR: c00000000044b164 CTR: c00800000e949ec8
>     REGS: c000001f69617840 TRAP: 0700   Tainted: G        W        ------=
--- -  -  (4.18.0-240.el8.ppc64le)
>     MSR:  9000000000029033 <SF,HV,EE,ME,IR,DR,RI,LE>  CR: 44044282  XER: =
00000000
>     CFAR: c00000000044b160 IRQMASK: 0
>     GPR00: c00000000044b164 c000001f69617ac0 c00800000e96e000 c000001f696=
17c10
>     GPR04: 05faa2b21e000080 0000000000000000 0000000000000005 fffffffffff=
fffff
>     GPR08: 0000000000000000 0000000000000001 0000000000000000 00000000000=
00001
>     GPR12: c00800000e949ec8 c000001ffffd3400 0000000000000000 00000000000=
00000
>     GPR16: 0000000000000000 0000000000000000 0000000000000000 00000000000=
00000
>     GPR20: 0000000000000000 0000000000000000 c000001f5c065160 c000000001c=
76f90
>     GPR24: c000001f06f20000 c000001f5c065100 0000000000000008 c000001f0eb=
98c78
>     GPR28: c000001dcab40000 c000001dcab403d8 c000001f69617c10 00000000000=
00011
>     NIP [c00800000e949fac] xive_native_esb_fault+0xe4/0x240 [kvm]
>     LR [c00000000044b164] __do_fault+0x64/0x220
>     Call Trace:
>     [c000001f69617ac0] [0000000137a5dc20] 0x137a5dc20 (unreliable)
>     [c000001f69617b50] [c00000000044b164] __do_fault+0x64/0x220
>     [c000001f69617b90] [c000000000453838] do_fault+0x218/0x930
>     [c000001f69617bf0] [c000000000456f50] __handle_mm_fault+0x350/0xdf0
>     [c000001f69617cd0] [c000000000457b1c] handle_mm_fault+0x12c/0x310
>     [c000001f69617d10] [c00000000007ef44] __do_page_fault+0x264/0xbb0
>     [c000001f69617df0] [c00000000007f8c8] do_page_fault+0x38/0xd0
>     [c000001f69617e30] [c00000000000a714] handle_page_fault+0x18/0x38
>     Instruction dump:
>     40c2fff0 7c2004ac 2fa90000 409e0118 73e90001 41820080 e8bd0008 7c2004=
ac
>     7ca90074 39400000 915c0000 7929d182 <0b090000> 2fa50000 419e0080 e89e=
0018
>     ---[ end trace 66c6ff034c53f64f ]---
>     xive-kvm: xive_native_esb_fault: accessing invalid ESB page for sourc=
e 8 !
>
> Fix that by checking the validity of the KVM XIVE interrupt structure.
>
> Reported-by: Greg Kurz <groug@kaod.org>
> Signed-off-by: C=C3=A9dric Le Goater <clg@kaod.org>

Fixes ?

cheers
