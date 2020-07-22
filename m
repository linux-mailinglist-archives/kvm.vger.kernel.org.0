Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 968892297D3
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 14:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727948AbgGVMDZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 08:03:25 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:47687 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726161AbgGVMDZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jul 2020 08:03:25 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4BBYyM02F6z9sPf;
        Wed, 22 Jul 2020 22:03:22 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1595419403;
        bh=ZYxAwsh+3V5ye+dbkADhu2jHGiIvpQV3pkw5+1n3oQ4=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=pbJKuaAbmKMnTeSJtpm/DmRD0ObL6TwDoH5YKVdk177dIMEO3tiudGi2nfK4T1nGC
         IEGLosv3KFMK582kcIoHGZqOsxpq5V3/V5oTOHNL4VtyaEflh9c1+1O2OuQqi+ShRA
         1dzO0TPYEYCY2av4+fsq9esViJWyOfQCgEIa5yrWoBiui7Haa8VR16wV3Lg0tmOUts
         o8KQyfOsD11S8kQ2m+UsCIjtXAYzZ5tm8MItxsKIPAgCT3QZuKwVwNxi6HCk3iS1fe
         SOpwGxc75kco5+vnZgaymlIE4J7sKjzeMd/N15WclBfP+E/vOZN+lZzvtpDPFLGmya
         rS+fUezpswXXQ==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Jordan Niethe <jniethe5@gmail.com>,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc:     Gautham R Shenoy <ego@linux.vnet.ibm.com>, mikey@neuling.org,
        maddy@linux.vnet.ibm.com, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, svaidyan@in.ibm.com, acme@kernel.org,
        jolsa@kernel.org, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [v3 04/15] powerpc/perf: Add support for ISA3.1 PMU SPRs
In-Reply-To: <CACzsE9r9fy22hScRm7yz5OeZH9jXA+97hEfAOo-Nk_EPwW-_Dw@mail.gmail.com>
References: <1594996707-3727-1-git-send-email-atrajeev@linux.vnet.ibm.com> <1594996707-3727-5-git-send-email-atrajeev@linux.vnet.ibm.com> <CACzsE9r9fy22hScRm7yz5OeZH9jXA+97hEfAOo-Nk_EPwW-_Dw@mail.gmail.com>
Date:   Wed, 22 Jul 2020 22:03:19 +1000
Message-ID: <87d04nrc3c.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jordan Niethe <jniethe5@gmail.com> writes:
> On Sat, Jul 18, 2020 at 1:02 AM Athira Rajeev <atrajeev@linux.vnet.ibm.com> wrote:
>> From: Madhavan Srinivasan <maddy@linux.ibm.com>
>>
>> PowerISA v3.1 includes new performance monitoring unit(PMU)
>> special purpose registers (SPRs). They are
...
>>
>> diff --git a/arch/powerpc/include/asm/perf_event_server.h b/arch/powerpc/include/asm/perf_event_server.h
>> index 14b8dc1..832450a 100644
>> --- a/arch/powerpc/include/asm/perf_event_server.h
>> +++ b/arch/powerpc/include/asm/perf_event_server.h
>> @@ -75,6 +76,7 @@ struct power_pmu {
>>  #define PPMU_HAS_SIER          0x00000040 /* Has SIER */
>>  #define PPMU_ARCH_207S         0x00000080 /* PMC is architecture v2.07S */
>>  #define PPMU_NO_SIAR           0x00000100 /* Do not use SIAR */
>> +#define PPMU_ARCH_310S         0x00000200 /* Has MMCR3, SIER2 and SIER3 */

> We elsewhere have CPU_FTR_ARCH_31, so should this be PPMU_ARCH_31S to
> be consistent.

The "S" is no longer needed as there's no Book S vs Book E distinction
in ISA v3.1.

So I changed it to PPMU_ARCH_31.

>> diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
>> index f4d07b5..ca32fc0 100644
>> --- a/arch/powerpc/perf/core-book3s.c
>> +++ b/arch/powerpc/perf/core-book3s.c
>> @@ -581,6 +589,11 @@ static void ebb_switch_out(unsigned long mmcr0)
>>         current->thread.sdar  = mfspr(SPRN_SDAR);
>>         current->thread.mmcr0 = mmcr0 & MMCR0_USER_MASK;
>>         current->thread.mmcr2 = mfspr(SPRN_MMCR2) & MMCR2_USER_MASK;
>> +       if (ppmu->flags & PPMU_ARCH_310S) {
>> +               current->thread.mmcr3 = mfspr(SPRN_MMCR3);

> Like MMCR0_USER_MASK and MMCR2_USER_MASK do we need a MMCR3_USER_MASK
> here, or is there no need?

mmcr0 and mmcr2 are visible via ptrace, so masking them here means we
don't expose any bits to userspace via ptrace that aren't also visible
by reading the register.

So at least while mmcr3 is not exposed via ptrace it's safe to not mask
it, if there are even any sensitive bits in it.

cheers
