Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7D8F2AE29C
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 23:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731654AbgKJWKW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 17:10:22 -0500
Received: from smtpout1.mo529.mail-out.ovh.net ([178.32.125.2]:51097 "EHLO
        smtpout1.mo529.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726467AbgKJWKW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Nov 2020 17:10:22 -0500
X-Greylist: delayed 347 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Nov 2020 17:10:21 EST
Received: from mxplan5.mail.ovh.net (unknown [10.108.20.7])
        by mo529.mail-out.ovh.net (Postfix) with ESMTPS id F0CC76B9553E;
        Tue, 10 Nov 2020 23:04:32 +0100 (CET)
Received: from kaod.org (37.59.142.99) by DAG4EX1.mxp5.local (172.16.2.31)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Tue, 10 Nov
 2020 23:04:31 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-99G003bc792778-fc7e-40f1-8439-94edc17bb2ab,
                    BF55E036A69FA8A58606F388C5C835316A6FE4B9) smtp.auth=clg@kaod.org
Subject: Re: [PATCH] KVM: PPC: Book3S HV: XIVE: Fix possible oops when
 accessing ESB page
To:     Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>
CC:     <linuxppc-dev@lists.ozlabs.org>, <kvm-ppc@vger.kernel.org>,
        <kvm@vger.kernel.org>, Greg Kurz <groug@kaod.org>,
        Gustavo Romero <gromero@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>
References: <20201105134713.656160-1-clg@kaod.org>
 <878sbftbnt.fsf@mpe.ellerman.id.au>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Message-ID: <1270ada4-e2a9-6a1a-52a9-b5c3479c05ea@kaod.org>
Date:   Tue, 10 Nov 2020 23:04:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <878sbftbnt.fsf@mpe.ellerman.id.au>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [37.59.142.99]
X-ClientProxiedBy: DAG8EX1.mxp5.local (172.16.2.71) To DAG4EX1.mxp5.local
 (172.16.2.31)
X-Ovh-Tracer-GUID: 49ff0c72-0c37-4ed2-93ee-8126ad6004f8
X-Ovh-Tracer-Id: 1040331516666481516
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedujedruddujedgudehjecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefuvfhfhffkffgfgggjtgfgihesthekredttdefjeenucfhrhhomhepveorughrihgtpgfnvggpifhorghtvghruceotghlgheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpeejkeduueduveelgeduueegkeelffevledujeetffeivdelvdfgkeeufeduheehfeenucfkpheptddrtddrtddrtddpfeejrdehledrudegvddrleelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpqdhouhhtpdhhvghlohepmhigphhlrghnhedrmhgrihhlrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpegtlhhgsehkrghougdrohhrghdprhgtphhtthhopehgrhhouhhgsehkrghougdrohhrgh
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/6/20 4:19 AM, Michael Ellerman wrote:
> Cédric Le Goater <clg@kaod.org> writes:
>> When accessing the ESB page of a source interrupt, the fault handler
>> will retrieve the page address from the XIVE interrupt 'xive_irq_data'
>> structure. If the associated KVM XIVE interrupt is not valid, that is
>> not allocated at the HW level for some reason, the fault handler will
>> dereference a NULL pointer leading to the oops below :
>>
>>     WARNING: CPU: 40 PID: 59101 at arch/powerpc/kvm/book3s_xive_native.c:259 xive_native_esb_fault+0xe4/0x240 [kvm]
>>     CPU: 40 PID: 59101 Comm: qemu-system-ppc Kdump: loaded Tainted: G        W        --------- -  - 4.18.0-240.el8.ppc64le #1
>>     NIP:  c00800000e949fac LR: c00000000044b164 CTR: c00800000e949ec8
>>     REGS: c000001f69617840 TRAP: 0700   Tainted: G        W        --------- -  -  (4.18.0-240.el8.ppc64le)
>>     MSR:  9000000000029033 <SF,HV,EE,ME,IR,DR,RI,LE>  CR: 44044282  XER: 00000000
>>     CFAR: c00000000044b160 IRQMASK: 0
>>     GPR00: c00000000044b164 c000001f69617ac0 c00800000e96e000 c000001f69617c10
>>     GPR04: 05faa2b21e000080 0000000000000000 0000000000000005 ffffffffffffffff
>>     GPR08: 0000000000000000 0000000000000001 0000000000000000 0000000000000001
>>     GPR12: c00800000e949ec8 c000001ffffd3400 0000000000000000 0000000000000000
>>     GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
>>     GPR20: 0000000000000000 0000000000000000 c000001f5c065160 c000000001c76f90
>>     GPR24: c000001f06f20000 c000001f5c065100 0000000000000008 c000001f0eb98c78
>>     GPR28: c000001dcab40000 c000001dcab403d8 c000001f69617c10 0000000000000011
>>     NIP [c00800000e949fac] xive_native_esb_fault+0xe4/0x240 [kvm]
>>     LR [c00000000044b164] __do_fault+0x64/0x220
>>     Call Trace:
>>     [c000001f69617ac0] [0000000137a5dc20] 0x137a5dc20 (unreliable)
>>     [c000001f69617b50] [c00000000044b164] __do_fault+0x64/0x220
>>     [c000001f69617b90] [c000000000453838] do_fault+0x218/0x930
>>     [c000001f69617bf0] [c000000000456f50] __handle_mm_fault+0x350/0xdf0
>>     [c000001f69617cd0] [c000000000457b1c] handle_mm_fault+0x12c/0x310
>>     [c000001f69617d10] [c00000000007ef44] __do_page_fault+0x264/0xbb0
>>     [c000001f69617df0] [c00000000007f8c8] do_page_fault+0x38/0xd0
>>     [c000001f69617e30] [c00000000000a714] handle_page_fault+0x18/0x38
>>     Instruction dump:
>>     40c2fff0 7c2004ac 2fa90000 409e0118 73e90001 41820080 e8bd0008 7c2004ac
>>     7ca90074 39400000 915c0000 7929d182 <0b090000> 2fa50000 419e0080 e89e0018
>>     ---[ end trace 66c6ff034c53f64f ]---
>>     xive-kvm: xive_native_esb_fault: accessing invalid ESB page for source 8 !
>>
>> Fix that by checking the validity of the KVM XIVE interrupt structure.
>>
>> Reported-by: Greg Kurz <groug@kaod.org>
>> Signed-off-by: Cédric Le Goater <clg@kaod.org>
> 
> Fixes ?

Ah yes :/  

Cc: stable@vger.kernel.org # v5.2+
Fixes: 6520ca64cde7 ("KVM: PPC: Book3S HV: XIVE: Add a mapping for the source ESB pages")

Since my provider changed its imap servers, my email filters are really screwed 
up and I miss emails. 

Sorry about that,

C.
