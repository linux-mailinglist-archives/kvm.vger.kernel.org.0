Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4FDC131607
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2020 17:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbgAFQ2q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jan 2020 11:28:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27271 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726448AbgAFQ2q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jan 2020 11:28:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578328125;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ct+NaHUfh9EMxOViGYWfdetML64MGlCyQ3Pbwz6ugF8=;
        b=RiqUDQaxsPbpWg4cDmlq0xzsm/cBTwpg13QEzradY3bjHFIOviJ26OoMFtsVKoxmIvn9nK
        oeY9xhWs399CQbDekXC8wbSPH7sKrp2re/z5YXQGw6HWK/wy0GkWlAgqoi6E8gwle9NcYg
        gkpGdsEAel7C42xIvlc26MA16C8EsXI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-134-niK809vFNkCKRBw-ZdGDjg-1; Mon, 06 Jan 2020 11:28:42 -0500
X-MC-Unique: niK809vFNkCKRBw-ZdGDjg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A8F2C100CE9D;
        Mon,  6 Jan 2020 16:28:40 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A4E2D7C3A2;
        Mon,  6 Jan 2020 16:28:38 +0000 (UTC)
Date:   Mon, 6 Jan 2020 17:28:35 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Andre Przywara <andre.przywara@arm.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, maz@kernel.org, vladimir.murzin@arm.com,
        mark.rutland@arm.com
Subject: Re: [kvm-unit-tests PATCH v3 15/18] arm/arm64: Perform dcache clean
 + invalidate after turning MMU off
Message-ID: <20200106162835.odxhbyi4y5ggoaoy@kamzik.brq.redhat.com>
References: <1577808589-31892-1-git-send-email-alexandru.elisei@arm.com>
 <1577808589-31892-16-git-send-email-alexandru.elisei@arm.com>
 <20200103164903.07cf0c56@donnerap.cambridge.arm.com>
 <3b57190f-d179-b494-6cfa-4254c7a8a276@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b57190f-d179-b494-6cfa-4254c7a8a276@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 06, 2020 at 02:27:31PM +0000, Alexandru Elisei wrote:
> Hi,
> 
> On 1/3/20 4:49 PM, Andre Przywara wrote:
> > On Tue, 31 Dec 2019 16:09:46 +0000
> > Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> >
> > Hi,
> >
> >> When the MMU is off, data accesses are to Device nGnRnE memory on arm64 [1]
> >> or to Strongly-Ordered memory on arm [2]. This means that the accesses are
> >> non-cacheable.
> >>
> >> Perform a dcache clean to PoC so we can read the newer values from the
> >> cache after we turn the MMU off, instead of the stale values from memory.
> > Wow, did we really not do this before?
> >  
> >> Perform an invalidation so we can access the data written to memory after
> >> we turn the MMU back on. This prevents reading back the stale values we
> >> cleaned from the cache when we turned the MMU off.
> >>
> >> Data caches are PIPT and the VAs are translated using the current
> >> translation tables, or an identity mapping (what Arm calls a "flat
> >> mapping") when the MMU is off [1, 2]. Do the clean + invalidate when the
> >> MMU is off so we don't depend on the current translation tables and we can
> >> make sure that the operation applies to the entire physical memory.
> > The intention of the patch is very much valid, I am just wondering if there is any reason why you do the cache line size determination in (quite some lines of) C?
> > Given that you only use that in asm, wouldn't it be much easier to read the CTR register there, just before you actually use it? The actual CTR read is (inline) assembly anyway, so you just need the mask/shift/add in asm as well. You could draw inspiration from here, for instance:
> > https://gitlab.denx.de/u-boot/u-boot/blob/master/arch/arm/cpu/armv8/cache.S#L132
> 
> Computing the dcache line size in assembly is how Linux does it as well. I chose
> to do it in C because I like to avoid using assembly as much as possible. But I
> have no strong preference in keeping it in C. Andrew, what do you think? Should
> the cache line size be computed in C or in assembly, in asm_mmu_disable?

I also prefer to minimize the amount of assembly and to minimize the
amount of code in general. For something like this I probably wouldn't
have introduced the macros, unless there's reason to believe unit tests
will also make use of them. Instead, I would just introduce get_ctr()
to avoid #ifdef's and then put the calculation directly into cpu_init()
like below. However I don't have a strong opinion here, so whatever
makes you guys happy :-)

Thanks,
drew


diff --git a/lib/arm/asm/processor.h b/lib/arm/asm/processor.h
index a8c4628da818..ae7e3816e676 100644
--- a/lib/arm/asm/processor.h
+++ b/lib/arm/asm/processor.h
@@ -64,6 +64,7 @@ extern bool is_user(void);
 
 #define CNTVCT		__ACCESS_CP15_64(1, c14)
 #define CNTFRQ		__ACCESS_CP15(c14, 0, c0, 0)
+#define CTR		__ACCESS_CP15(c0, 0, c0, 1)
 
 static inline u64 get_cntvct(void)
 {
@@ -76,4 +77,11 @@ static inline u32 get_cntfrq(void)
 	return read_sysreg(CNTFRQ);
 }
 
+static inline u32 get_ctr(void)
+{
+	return read_sysreg(CTR);
+}
+
+extern u32 dcache_line_size;
+
 #endif /* _ASMARM_PROCESSOR_H_ */
diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 4f02fca85607..11b9cc9602ea 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -35,6 +35,8 @@ int nr_cpus;
 struct mem_region mem_regions[NR_MEM_REGIONS];
 phys_addr_t __phys_offset, __phys_end;
 
+u32 dcache_line_size;
+
 int mpidr_to_cpu(uint64_t mpidr)
 {
 	int i;
@@ -59,6 +61,8 @@ static void cpu_init(void)
 {
 	int ret;
 
+	dcache_line_size = 4 << ((get_ctr() >> 16) & 0xf);
+
 	nr_cpus = 0;
 	ret = dt_for_each_cpu_node(cpu_set, NULL);
 	assert(ret == 0);
diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
index 1d9223f728a5..5cba1591eda7 100644
--- a/lib/arm64/asm/processor.h
+++ b/lib/arm64/asm/processor.h
@@ -105,5 +105,12 @@ static inline u32 get_cntfrq(void)
 	return read_sysreg(cntfrq_el0);
 }
 
+static inline u32 get_ctr(void)
+{
+	return read_sysreg(ctr_el0);
+}
+
+extern u32 dcache_line_size;
+
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASMARM64_PROCESSOR_H_ */

