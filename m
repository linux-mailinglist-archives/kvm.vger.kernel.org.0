Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0A32A4E16
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 19:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729295AbgKCSO4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 13:14:56 -0500
Received: from foss.arm.com ([217.140.110.172]:53768 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729202AbgKCSO4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Nov 2020 13:14:56 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 758211474;
        Tue,  3 Nov 2020 10:14:55 -0800 (PST)
Received: from C02W217MHV2R.local (unknown [10.57.19.65])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 88AB83F718;
        Tue,  3 Nov 2020 10:14:54 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 2/2] arm64: Check if the configured
 translation granule is supported
To:     Andrew Jones <drjones@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, mark.rutland@arm.com, jade.alglave@arm.com,
        luc.maranget@inria.fr, andre.przywara@arm.com
References: <20201102113444.103536-1-nikos.nikoleris@arm.com>
 <20201102113444.103536-3-nikos.nikoleris@arm.com>
 <20201103100222.dpryytbkdjaryehr@kamzik.brq.redhat.com>
 <f9ea19cc-b325-2a7f-1b7c-e7da3d99bfca@arm.com>
 <20201103173604.az5ymaw576uz6645@kamzik.brq.redhat.com>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
Message-ID: <cdfbfe16-ac54-aba0-4aa3-4933759175dc@arm.com>
Date:   Tue, 3 Nov 2020 18:14:53 +0000
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201103173604.az5ymaw576uz6645@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/11/2020 17:36, Andrew Jones wrote:
> On Tue, Nov 03, 2020 at 05:03:15PM +0000, Alexandru Elisei wrote:
>>> +}
>>> +
>>> +static inline bool system_supports_granule(size_t granule)
>>> +{
>>> +	u64 mmfr0 = get_id_aa64mmfr0_el1();
>>> +
>>> +	return ((granule == SZ_4K && ((mmfr0 >> 28) & 0xf) == 0) ||
>>> +		(granule == SZ_64K && ((mmfr0 >> 24) & 0xf) == 0) ||
>>> +		(granule == SZ_16K && ((mmfr0 >> 20) & 0xf) == 1));
>>> +}
>>
>> Or we can turn it into a switch statement and keep all the field defines. Either
>> way looks good to me (funny how tgran16 stands out).
>>
> 
> Keeping the defines is probably a good idea. Whether the function uses
> a switch or an expression like above doesn't matter to me much. Keeping
> LOC down in the lib/ code is a goal of kvm-unit-tests, but so is
> readabilty. If the switch looks better, then let's go that way.
> 

I liked Drew's version in that it was very concise. The new version will 
be much longer. If you think it's more readable I'll use that instead.

diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
index 02665b8..430ded3 100644
--- a/lib/arm64/asm/processor.h
+++ b/lib/arm64/asm/processor.h
@@ -117,5 +117,38 @@ static inline u64 get_ctr(void)

  extern u32 dcache_line_size;

+static inline unsigned long get_id_aa64mmfr0_el1(void)
+{
+       return read_sysreg(id_aa64mmfr0_el1);
+}
+
+#define ID_AA64MMFR0_TGRAN4_SHIFT      28
+#define ID_AA64MMFR0_TGRAN64_SHIFT     24
+#define ID_AA64MMFR0_TGRAN16_SHIFT     20
+
+#define ID_AA64MMFR0_TGRAN4_SUPPORTED  0x0
+#define ID_AA64MMFR0_TGRAN64_SUPPORTED 0x0
+#define ID_AA64MMFR0_TGRAN16_SUPPORTED 0x1
+
+static inline bool system_supports_granule(size_t granule)
+{
+       u32 shift;
+       u32 val;
+       u64 mmfr0 = get_id_aa64mmfr0_el1();
+       if (granule == SZ_4K) {
+               shift = ID_AA64MMFR0_TGRAN4_SHIFT;
+               val = ID_AA64MMFR0_TGRAN4_SUPPORTED;
+       } else if (granule == SZ_16K) {
+               shift = ID_AA64MMFR0_TGRAN16_SHIFT;
+               val = ID_AA64MMFR0_TGRAN16_SUPPORTED;
+       } else {
+               assert(granule == SZ_64K);
+               shift = ID_AA64MMFR0_TGRAN64_SHIFT;
+               val = ID_AA64MMFR0_TGRAN64_SUPPORTED;
+       }
+
+       return ((mmfr0 >> shift) & 0xf) == val;
+}
+
  #endif /* !__ASSEMBLY__ */
  #endif /* _ASMARM64_PROCESSOR_H_ */

Thanks,

Nikos

> Thanks,
> drew
> 
