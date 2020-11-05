Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55A7C2A8A64
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 00:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732295AbgKEXGc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 5 Nov 2020 18:06:32 -0500
Received: from 4.mo51.mail-out.ovh.net ([188.165.42.229]:57606 "EHLO
        4.mo51.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731694AbgKEXGc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Nov 2020 18:06:32 -0500
X-Greylist: delayed 12600 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Nov 2020 18:06:31 EST
Received: from mxplan5.mail.ovh.net (unknown [10.109.138.84])
        by mo51.mail-out.ovh.net (Postfix) with ESMTPS id 2CB2B22F3CE;
        Thu,  5 Nov 2020 18:41:28 +0100 (CET)
Received: from kaod.org (37.59.142.99) by DAG8EX1.mxp5.local (172.16.2.71)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Thu, 5 Nov 2020
 18:41:25 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-99G00370b8c64a-0543-4c6f-baee-68c0635e8757,
                    5D04B6D4EAACA18D9EDEF493C42F41A1D3896549) smtp.auth=groug@kaod.org
Date:   Thu, 5 Nov 2020 18:41:22 +0100
From:   Greg Kurz <groug@kaod.org>
To:     =?UTF-8?B?Q8OpZHJpYw==?= Le Goater <clg@kaod.org>
CC:     Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        <kvm-ppc@vger.kernel.org>, <kvm@vger.kernel.org>,
        Gustavo Romero <gromero@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH] KVM: PPC: Book3S HV: XIVE: Fix possible oops when
 accessing ESB page
Message-ID: <20201105184122.160ed034@bahia.lan>
In-Reply-To: <20201105134713.656160-1-clg@kaod.org>
References: <20201105134713.656160-1-clg@kaod.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [37.59.142.99]
X-ClientProxiedBy: DAG8EX2.mxp5.local (172.16.2.72) To DAG8EX1.mxp5.local
 (172.16.2.71)
X-Ovh-Tracer-GUID: 31c7ae4c-40fe-4882-9e1a-da44c7c997e6
X-Ovh-Tracer-Id: 4127549060043741548
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedujedruddtjedguddtgecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpeffhffvuffkjghfofggtgfgihesthhqredtredtjeenucfhrhhomhepifhrvghgucfmuhhriicuoehgrhhouhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnhepveelhfdtudffhfeiveehhfelgeellefgteffteekudegheejfffghefhfeeuudffnecukfhppedtrddtrddtrddtpdefjedrheelrddugedvrdelleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehmgihplhgrnhehrdhmrghilhdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomhepghhrohhugheskhgrohgurdhorhhgpdhrtghpthhtoheptghlgheskhgrohgurdhorhhg
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 5 Nov 2020 14:47:13 +0100
Cédric Le Goater <clg@kaod.org> wrote:

> When accessing the ESB page of a source interrupt, the fault handler
> will retrieve the page address from the XIVE interrupt 'xive_irq_data'
> structure. If the associated KVM XIVE interrupt is not valid, that is
> not allocated at the HW level for some reason, the fault handler will
> dereference a NULL pointer leading to the oops below :
> 
>     WARNING: CPU: 40 PID: 59101 at arch/powerpc/kvm/book3s_xive_native.c:259 xive_native_esb_fault+0xe4/0x240 [kvm]
>     CPU: 40 PID: 59101 Comm: qemu-system-ppc Kdump: loaded Tainted: G        W        --------- -  - 4.18.0-240.el8.ppc64le #1
>     NIP:  c00800000e949fac LR: c00000000044b164 CTR: c00800000e949ec8
>     REGS: c000001f69617840 TRAP: 0700   Tainted: G        W        --------- -  -  (4.18.0-240.el8.ppc64le)
>     MSR:  9000000000029033 <SF,HV,EE,ME,IR,DR,RI,LE>  CR: 44044282  XER: 00000000
>     CFAR: c00000000044b160 IRQMASK: 0
>     GPR00: c00000000044b164 c000001f69617ac0 c00800000e96e000 c000001f69617c10
>     GPR04: 05faa2b21e000080 0000000000000000 0000000000000005 ffffffffffffffff
>     GPR08: 0000000000000000 0000000000000001 0000000000000000 0000000000000001
>     GPR12: c00800000e949ec8 c000001ffffd3400 0000000000000000 0000000000000000
>     GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
>     GPR20: 0000000000000000 0000000000000000 c000001f5c065160 c000000001c76f90
>     GPR24: c000001f06f20000 c000001f5c065100 0000000000000008 c000001f0eb98c78
>     GPR28: c000001dcab40000 c000001dcab403d8 c000001f69617c10 0000000000000011
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
>     40c2fff0 7c2004ac 2fa90000 409e0118 73e90001 41820080 e8bd0008 7c2004ac
>     7ca90074 39400000 915c0000 7929d182 <0b090000> 2fa50000 419e0080 e89e0018
>     ---[ end trace 66c6ff034c53f64f ]---
>     xive-kvm: xive_native_esb_fault: accessing invalid ESB page for source 8 !
> 
> Fix that by checking the validity of the KVM XIVE interrupt structure.
> 
> Reported-by: Greg Kurz <groug@kaod.org>
> Signed-off-by: Cédric Le Goater <clg@kaod.org>
> ---

Looks sane to me. QEMU still crashes on SIGBUS but no more oops at least.

Tested-by: Greg Kurz <groug@kaod.org>

>  arch/powerpc/kvm/book3s_xive_native.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/powerpc/kvm/book3s_xive_native.c b/arch/powerpc/kvm/book3s_xive_native.c
> index d0c2db0e07fa..a59a94f02733 100644
> --- a/arch/powerpc/kvm/book3s_xive_native.c
> +++ b/arch/powerpc/kvm/book3s_xive_native.c
> @@ -251,6 +251,13 @@ static vm_fault_t xive_native_esb_fault(struct vm_fault *vmf)
>  	}
>  
>  	state = &sb->irq_state[src];
> +
> +	/* Some sanity checking */
> +	if (!state->valid) {
> +		pr_devel("%s: source %lx invalid !\n", __func__, irq);
> +		return VM_FAULT_SIGBUS;
> +	}
> +
>  	kvmppc_xive_select_irq(state, &hw_num, &xd);
>  
>  	arch_spin_lock(&sb->lock);

