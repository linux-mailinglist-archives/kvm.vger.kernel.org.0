Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7C9B2A4115
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 11:03:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728035AbgKCKCd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 05:02:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50297 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726126AbgKCKCc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Nov 2020 05:02:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604397751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E2u9Gld41iv74YcsFrSdqEmYyDWO7zXQUm9H4zwLEn0=;
        b=Y0kK552qmBIPAt/NkZ5TmTTRzYDfaacBZT3Zus1DWUdyKi6A5cZpZuOfHlKPNoi8OTdwWV
        anuC907JQZl7J1Z636p9RCeTl11fv7+yqrJWN4lbcB1oceDV9iZn7wTB+biud+mU+gKrru
        zpJqDT2+0DLIRWBFWBTmguRcHdRzHqA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-537-Rex_nOVyPcaF033FDLHTWQ-1; Tue, 03 Nov 2020 05:02:29 -0500
X-MC-Unique: Rex_nOVyPcaF033FDLHTWQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B69D664152;
        Tue,  3 Nov 2020 10:02:27 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.252])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7901C6EF5D;
        Tue,  3 Nov 2020 10:02:25 +0000 (UTC)
Date:   Tue, 3 Nov 2020 11:02:22 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, mark.rutland@arm.com, jade.alglave@arm.com,
        luc.maranget@inria.fr, andre.przywara@arm.com,
        alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH 2/2] arm64: Check if the configured
 translation granule is supported
Message-ID: <20201103100222.dpryytbkdjaryehr@kamzik.brq.redhat.com>
References: <20201102113444.103536-1-nikos.nikoleris@arm.com>
 <20201102113444.103536-3-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201102113444.103536-3-nikos.nikoleris@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 02, 2020 at 11:34:44AM +0000, Nikos Nikoleris wrote:
> Now that we can change the translation granule at will, and since
> arm64 implementations can support a subset of the architecturally
> defined granules, we need to check and warn the user if the configured
> granule is not supported.

nit: it'd be better for this patch to come before the last patch.

> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> ---
>  lib/arm64/asm/processor.h | 65 +++++++++++++++++++++++++++++++++++++++
>  lib/arm/mmu.c             |  3 ++
>  2 files changed, 68 insertions(+)
> 
> diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
> index 02665b8..0eac928 100644
> --- a/lib/arm64/asm/processor.h
> +++ b/lib/arm64/asm/processor.h
> @@ -117,5 +117,70 @@ static inline u64 get_ctr(void)
>  
>  extern u32 dcache_line_size;
>  
> +static inline unsigned long get_id_aa64mmfr0_el1(void)
> +{
> +	unsigned long mmfr0;
> +	asm volatile("mrs %0, id_aa64mmfr0_el1" : "=r" (mmfr0));
> +	return mmfr0;
> +}
> +
> +/* From arch/arm64/include/asm/cpufeature.h */
> +static inline unsigned int
> +cpuid_feature_extract_unsigned_field_width(u64 features, int field, int width)
> +{
> +	return (u64)(features << (64 - width - field)) >> (64 - width);
> +}
> +
> +#define ID_AA64MMFR0_TGRAN4_SHIFT	28
> +#define ID_AA64MMFR0_TGRAN64_SHIFT	24
> +#define ID_AA64MMFR0_TGRAN16_SHIFT	20
> +#define ID_AA64MMFR0_TGRAN4_SUPPORTED	0x0
> +#define ID_AA64MMFR0_TGRAN64_SUPPORTED	0x0
> +#define ID_AA64MMFR0_TGRAN16_SUPPORTED	0x1
> +
> +static inline bool system_supports_64kb_granule(void)
> +{
> +	u64 mmfr0;
> +	u32 val;
> +
> +	mmfr0 = get_id_aa64mmfr0_el1();
> +	val = cpuid_feature_extract_unsigned_field_width(
> +		mmfr0, ID_AA64MMFR0_TGRAN4_SHIFT,4);
> +
> +	return val == ID_AA64MMFR0_TGRAN64_SUPPORTED;
> +}
> +
> +static inline bool system_supports_16kb_granule(void)
> +{
> +	u64 mmfr0;
> +	u32 val;
> +
> +	mmfr0 = get_id_aa64mmfr0_el1();
> +	val = cpuid_feature_extract_unsigned_field_width(
> +		mmfr0, ID_AA64MMFR0_TGRAN16_SHIFT, 4);
> +
> +	return val == ID_AA64MMFR0_TGRAN16_SUPPORTED;
> +}
> +
> +static inline bool system_supports_4kb_granule(void)
> +{
> +	u64 mmfr0;
> +	u32 val;
> +
> +	mmfr0 = get_id_aa64mmfr0_el1();
> +	val = cpuid_feature_extract_unsigned_field_width(
> +		mmfr0, ID_AA64MMFR0_TGRAN4_SHIFT, 4);
> +
> +	return val == ID_AA64MMFR0_TGRAN4_SUPPORTED;
> +}
> +
> +#if PAGE_SIZE == 65536
> +#define system_supports_configured_granule system_supports_64kb_granule
> +#elif PAGE_SIZE == 16384
> +#define system_supports_configured_granule system_supports_16kb_granule
> +#elif PAGE_SIZE == 4096
> +#define system_supports_configured_granule system_supports_4kb_granule
> +#endif
> +
>  #endif /* !__ASSEMBLY__ */
>  #endif /* _ASMARM64_PROCESSOR_H_ */
> diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
> index 6d1c75b..51fa745 100644
> --- a/lib/arm/mmu.c
> +++ b/lib/arm/mmu.c
> @@ -163,6 +163,9 @@ void *setup_mmu(phys_addr_t phys_end)
>  
>  #ifdef __aarch64__
>  	init_alloc_vpage((void*)(4ul << 30));
> +
> +	assert_msg(system_supports_configured_granule(),
> +		   "Unsupported translation granule %d\n", PAGE_SIZE);
                                                     ^
                                              needs '%ld' to compile
>  #endif
>  
>  	mmu_idmap = alloc_page();
> -- 
> 2.17.1
>

I don't think we need the three separate functions. How about just
doing the following diff?

Thanks,
drew


diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index 540a1e842d5b..fef62f5a9866 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -160,6 +160,9 @@ void *setup_mmu(phys_addr_t phys_end)
 
 #ifdef __aarch64__
 	init_alloc_vpage((void*)(4ul << 30));
+
+	assert_msg(system_supports_granule(PAGE_SIZE),
+		   "Unsupported translation granule: %ld\n", PAGE_SIZE);
 #endif
 
 	mmu_idmap = alloc_page();
diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
index 02665b84cc7e..dc493d1686bc 100644
--- a/lib/arm64/asm/processor.h
+++ b/lib/arm64/asm/processor.h
@@ -117,5 +117,21 @@ static inline u64 get_ctr(void)
 
 extern u32 dcache_line_size;
 
+static inline unsigned long get_id_aa64mmfr0_el1(void)
+{
+	unsigned long mmfr0;
+	asm volatile("mrs %0, id_aa64mmfr0_el1" : "=r" (mmfr0));
+	return mmfr0;
+}
+
+static inline bool system_supports_granule(size_t granule)
+{
+	u64 mmfr0 = get_id_aa64mmfr0_el1();
+
+	return ((granule == SZ_4K && ((mmfr0 >> 28) & 0xf) == 0) ||
+		(granule == SZ_64K && ((mmfr0 >> 24) & 0xf) == 0) ||
+		(granule == SZ_16K && ((mmfr0 >> 20) & 0xf) == 1));
+}
+
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASMARM64_PROCESSOR_H_ */

