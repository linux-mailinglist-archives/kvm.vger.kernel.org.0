Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47AF422B1E2
	for <lists+kvm@lfdr.de>; Thu, 23 Jul 2020 16:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728006AbgGWO4O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jul 2020 10:56:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:43782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726761AbgGWO4N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jul 2020 10:56:13 -0400
Received: from quaco.ghostprotocols.net (unknown [179.97.37.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DCA320709;
        Thu, 23 Jul 2020 14:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595516172;
        bh=MJwanw1l04V+4CiNL7u14VGrVPqIzUSPAIdSoymWJsw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ytXGxAsa/LweSZOz7scwtmkxDeU9q5WHzzv5+X22qClMMj1QtBtuXnqKALEuV58j9
         t4og3adhIVt2SiXBbGBKe5s6TZjBPtMp/HCZYFtRH4FuBv/nkADAN42mx59TxJpocr
         3FGILt8x701yXQ76jEyLvSr+aKjSPmu6mUfw533A=
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 4F39C404B1; Thu, 23 Jul 2020 11:56:09 -0300 (-03)
Date:   Thu, 23 Jul 2020 11:56:09 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     kajoljain <kjain@linux.ibm.com>
Cc:     Athira Rajeev <atrajeev@linux.vnet.ibm.com>, mpe@ellerman.id.au,
        jolsa@kernel.org, ego@linux.vnet.ibm.com, mikey@neuling.org,
        maddy@linux.vnet.ibm.com, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, svaidyan@in.ibm.com,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [v3 12/15] powerpc/perf: Add support for outputting extended
 regs in perf intr_regs
Message-ID: <20200723145609.GA1943963@kernel.org>
References: <1594996707-3727-1-git-send-email-atrajeev@linux.vnet.ibm.com>
 <1594996707-3727-13-git-send-email-atrajeev@linux.vnet.ibm.com>
 <1dded891-e5c2-ae1a-301c-4a3806aec3a0@linux.ibm.com>
 <489dcd01-5570-bfd4-8b46-10cf15c1e3ab@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <489dcd01-5570-bfd4-8b46-10cf15c1e3ab@linux.ibm.com>
X-Url:  http://acmel.wordpress.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Em Thu, Jul 23, 2020 at 11:14:16AM +0530, kajoljain escreveu:
> 
> 
> On 7/21/20 11:32 AM, kajoljain wrote:
> > 
> > 
> > On 7/17/20 8:08 PM, Athira Rajeev wrote:
> >> From: Anju T Sudhakar <anju@linux.vnet.ibm.com>
> >>
> >> Add support for perf extended register capability in powerpc.
> >> The capability flag PERF_PMU_CAP_EXTENDED_REGS, is used to indicate the
> >> PMU which support extended registers. The generic code define the mask
> >> of extended registers as 0 for non supported architectures.
> >>
> >> Patch adds extended regs support for power9 platform by
> >> exposing MMCR0, MMCR1 and MMCR2 registers.
> >>
> >> REG_RESERVED mask needs update to include extended regs.
> >> `PERF_REG_EXTENDED_MASK`, contains mask value of the supported registers,
> >> is defined at runtime in the kernel based on platform since the supported
> >> registers may differ from one processor version to another and hence the
> >> MASK value.
> >>
> >> with patch
> >> ----------
> >>
> >> available registers: r0 r1 r2 r3 r4 r5 r6 r7 r8 r9 r10 r11
> >> r12 r13 r14 r15 r16 r17 r18 r19 r20 r21 r22 r23 r24 r25 r26
> >> r27 r28 r29 r30 r31 nip msr orig_r3 ctr link xer ccr softe
> >> trap dar dsisr sier mmcra mmcr0 mmcr1 mmcr2
> >>
> >> PERF_RECORD_SAMPLE(IP, 0x1): 4784/4784: 0 period: 1 addr: 0
> >> ... intr regs: mask 0xffffffffffff ABI 64-bit
> >> .... r0    0xc00000000012b77c
> >> .... r1    0xc000003fe5e03930
> >> .... r2    0xc000000001b0e000
> >> .... r3    0xc000003fdcddf800
> >> .... r4    0xc000003fc7880000
> >> .... r5    0x9c422724be
> >> .... r6    0xc000003fe5e03908
> >> .... r7    0xffffff63bddc8706
> >> .... r8    0x9e4
> >> .... r9    0x0
> >> .... r10   0x1
> >> .... r11   0x0
> >> .... r12   0xc0000000001299c0
> >> .... r13   0xc000003ffffc4800
> >> .... r14   0x0
> >> .... r15   0x7fffdd8b8b00
> >> .... r16   0x0
> >> .... r17   0x7fffdd8be6b8
> >> .... r18   0x7e7076607730
> >> .... r19   0x2f
> >> .... r20   0xc00000001fc26c68
> >> .... r21   0xc0002041e4227e00
> >> .... r22   0xc00000002018fb60
> >> .... r23   0x1
> >> .... r24   0xc000003ffec4d900
> >> .... r25   0x80000000
> >> .... r26   0x0
> >> .... r27   0x1
> >> .... r28   0x1
> >> .... r29   0xc000000001be1260
> >> .... r30   0x6008010
> >> .... r31   0xc000003ffebb7218
> >> .... nip   0xc00000000012b910
> >> .... msr   0x9000000000009033
> >> .... orig_r3 0xc00000000012b86c
> >> .... ctr   0xc0000000001299c0
> >> .... link  0xc00000000012b77c
> >> .... xer   0x0
> >> .... ccr   0x28002222
> >> .... softe 0x1
> >> .... trap  0xf00
> >> .... dar   0x0
> >> .... dsisr 0x80000000000
> >> .... sier  0x0
> >> .... mmcra 0x80000000000
> >> .... mmcr0 0x82008090
> >> .... mmcr1 0x1e000000
> >> .... mmcr2 0x0
> >>  ... thread: perf:4784
> >>
> >> Signed-off-by: Anju T Sudhakar <anju@linux.vnet.ibm.com>
> >> [Defined PERF_REG_EXTENDED_MASK at run time to add support for different platforms ]
> >> Signed-off-by: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
> >> Reviewed-by: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
> >> ---
> > 
> > Patch looks good to me.
> > 
> > Reviewed-by: Kajol Jain <kjain@linux.ibm.com>
> 
> Hi Arnaldo and Jiri,
> 	 Please let me know if you have any comments on these patches. Can you pull/ack these
> patches if they seems fine to you.

Can you please clarify something here, I think I saw a kernel build bot
complaint followed by a fix, in these cases I think, for reviewer's
sake, that this would entail a v4 patchkit? One that has no such build
issues?

Or have I got something wrong?

- Arnaldo
