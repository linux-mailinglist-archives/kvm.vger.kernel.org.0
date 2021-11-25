Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49B0945D304
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 03:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbhKYCPc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 21:15:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbhKYCN1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 21:13:27 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD1DC06173E
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:55:15 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id m24so3327797pls.10
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:55:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=c6JAlrZHfEjkcfiYPHPoUF5Sz3yt7SCN1Z5kI93GJfA=;
        b=LUxcfNNzvDpzSvbqDZXVol5gajSAppzPjwydHI3cHD5x6j1VTUX3wiN1fouxMcLxNd
         ER23oTlHk9cRRqZjZb6EZJmEi0fy+qbj8/n/VTpYHBOjNKqPjAX+OLt7X54fTKgofIRM
         9t87TR/iRYetbEPgcUty35RZ5i38pmePgecZ8N9IWReKxmGU36ykt7KRMjfXma2X+7w1
         buAlPQJ6StMAtg4Upr42Hjv5F+S8TY1M7TN/xheOvOTbuBhEoRvmluf4fwA3qR3x7lrN
         NKj3s94AeepRMWBJ9YsTXI35DhArkE2HH4zbofZCuLn44KtNmPXX/67sy2Ix6wzmPZbi
         IFTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=c6JAlrZHfEjkcfiYPHPoUF5Sz3yt7SCN1Z5kI93GJfA=;
        b=sirLvi/oeNLeoc8FFqDVQhqo9MyusM06yMCqczwWOW0iQ6DbcVpG2kR7ig5I/z+L8f
         fUgu7F09heAgbz099dW2fRZOr2QFreGXIVDkVGL645JyS6VB9Qa62sDWb+oaKKn21GOa
         vcsKpydKDNzJGiDHcUi/ZCMLeIbBYKbM6WjafzSooyT6MdtgRJjgwOPdA9ZOnVdUNTF1
         DWDQEV/QaexK3TZtlhq6N4GpZpM9ytpW943jSACsnwepQBy+JUsafrzkxUY5ce9rbZfE
         xP8UxBzuSMRRSmyQhkkZGytaI6GwqhzESxhoAm/C9GiHRfhwkqWArqUlmVqv3Iz8R/+o
         HTTA==
X-Gm-Message-State: AOAM530I80lIlau25PmzDH3n9bKE/JygjAtIvPrqU1+rAw89A6ds98wO
        8p0OaMocJtPRLs1/Ibr8Sbu0GrMikVotiQ==
X-Google-Smtp-Source: ABdhPJwB7t1ABtFFgKue35rS8q/aX1FW34F5h96gFuTw5nPMllIGBJgfpruJneGLXCGEeBa3Sw4yUg==
X-Received: by 2002:a17:90b:4c03:: with SMTP id na3mr2465064pjb.62.1637805315282;
        Wed, 24 Nov 2021 17:55:15 -0800 (PST)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id h22sm698106pgl.79.2021.11.24.17.55.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 17:55:14 -0800 (PST)
Date:   Wed, 24 Nov 2021 17:55:11 -0800
From:   Ricardo Koller <ricarkol@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, eric.auger@redhat.com,
        alexandru.elisei@arm.com, Paolo Bonzini <pbonzini@redhat.com>,
        oupton@google.com, james.morse@arm.com, suzuki.poulose@arm.com,
        shuah@kernel.org, jingzhangos@google.com, pshier@google.com,
        rananta@google.com, reijiw@google.com
Subject: Re: [PATCH 02/17] KVM: selftests: aarch64: add function for
 accessing GICv3 dist and redist registers
Message-ID: <YZ7s/xeQ1IviLQfp@google.com>
References: <20211109023906.1091208-1-ricarkol@google.com>
 <20211109023906.1091208-3-ricarkol@google.com>
 <87h7c2di8v.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h7c2di8v.wl-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 23, 2021 at 03:06:08PM +0000, Marc Zyngier wrote:
> On Tue, 09 Nov 2021 02:38:51 +0000,
> Ricardo Koller <ricarkol@google.com> wrote:
> > 
> > Add a generic library function for reading and writing GICv3 distributor
> > and redistributor registers. Then adapt some functions to use it; more
> > will come and use it in the next commit.
> > 
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  .../selftests/kvm/lib/aarch64/gic_v3.c        | 124 ++++++++++++++----
> >  1 file changed, 101 insertions(+), 23 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
> > index 2dbf3339b62e..00e944fd8148 100644
> > --- a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
> > +++ b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
> > @@ -19,7 +19,8 @@ struct gicv3_data {
> >  	unsigned int nr_spis;
> >  };
> >  
> > -#define sgi_base_from_redist(redist_base) (redist_base + SZ_64K)
> > +#define sgi_base_from_redist(redist_base) 	(redist_base + SZ_64K)
> > +#define DIST_BIT				(1U << 31)
> >  
> >  enum gicv3_intid_range {
> >  	SGI_RANGE,
> > @@ -50,6 +51,14 @@ static void gicv3_gicr_wait_for_rwp(void *redist_base)
> >  	}
> >  }
> >  
> > +static void gicv3_wait_for_rwp(uint32_t cpu_or_dist)
> > +{
> > +	if (cpu_or_dist & DIST_BIT)
> > +		gicv3_gicd_wait_for_rwp();
> > +	else
> > +		gicv3_gicr_wait_for_rwp(gicv3_data.redist_base[cpu_or_dist]);
> > +}
> > +
> >  static enum gicv3_intid_range get_intid_range(unsigned int intid)
> >  {
> >  	switch (intid) {
> > @@ -81,39 +90,108 @@ static void gicv3_write_eoir(uint32_t irq)
> >  	isb();
> >  }
> >  
> > -static void
> > -gicv3_config_irq(unsigned int intid, unsigned int offset)
> > +uint32_t gicv3_reg_readl(uint32_t cpu_or_dist, uint64_t offset)
> > +{
> > +	void *base = cpu_or_dist & DIST_BIT ? gicv3_data.dist_base
> > +		: sgi_base_from_redist(gicv3_data.redist_base[cpu_or_dist]);
> > +	return readl(base + offset);
> > +}
> > +
> > +void gicv3_reg_writel(uint32_t cpu_or_dist, uint64_t offset, uint32_t reg_val)
> > +{
> > +	void *base = cpu_or_dist & DIST_BIT ? gicv3_data.dist_base
> > +		: sgi_base_from_redist(gicv3_data.redist_base[cpu_or_dist]);
> > +	writel(reg_val, base + offset);
> > +}
> > +
> > +uint32_t gicv3_getl_fields(uint32_t cpu_or_dist, uint64_t offset, uint32_t mask)
> > +{
> > +	return gicv3_reg_readl(cpu_or_dist, offset) & mask;
> > +}
> > +
> > +void gicv3_setl_fields(uint32_t cpu_or_dist, uint64_t offset,
> > +		uint32_t mask, uint32_t reg_val)
> > +{
> > +	uint32_t tmp = gicv3_reg_readl(cpu_or_dist, offset) & ~mask;
> > +
> > +	tmp |= (reg_val & mask);
> > +	gicv3_reg_writel(cpu_or_dist, offset, tmp);
> > +}
> > +
> > +/*
> > + * We use a single offset for the distributor and redistributor maps as they
> > + * have the same value in both. The only exceptions are registers that only
> > + * exist in one and not the other, like GICR_WAKER that doesn't exist in the
> > + * distributor map. Such registers are conveniently marked as reserved in the
> > + * map that doesn't implement it; like GICR_WAKER's offset of 0x0014 being
> > + * marked as "Reserved" in the Distributor map.
> > + */
> > +static void gicv3_access_reg(uint32_t intid, uint64_t offset,
> > +		uint32_t reg_bits, uint32_t bits_per_field,
> > +		bool write, uint32_t *val)
> >  {
> >  	uint32_t cpu = guest_get_vcpuid();
> > -	uint32_t mask = 1 << (intid % 32);
> >  	enum gicv3_intid_range intid_range = get_intid_range(intid);
> > -	void *reg;
> > -
> > -	/* We care about 'cpu' only for SGIs or PPIs */
> > -	if (intid_range == SGI_RANGE || intid_range == PPI_RANGE) {
> > -		GUEST_ASSERT(cpu < gicv3_data.nr_cpus);
> > -
> > -		reg = sgi_base_from_redist(gicv3_data.redist_base[cpu]) +
> > -			offset;
> > -		writel(mask, reg);
> > -		gicv3_gicr_wait_for_rwp(gicv3_data.redist_base[cpu]);
> > -	} else if (intid_range == SPI_RANGE) {
> > -		reg = gicv3_data.dist_base + offset + (intid / 32) * 4;
> > -		writel(mask, reg);
> > -		gicv3_gicd_wait_for_rwp();
> > -	} else {
> > -		GUEST_ASSERT(0);
> > -	}
> > +	uint32_t fields_per_reg, index, mask, shift;
> > +	uint32_t cpu_or_dist;
> > +
> > +	GUEST_ASSERT(bits_per_field <= reg_bits);
> > +	GUEST_ASSERT(*val < (1U << bits_per_field));
> > +	/* Some registers like IROUTER are 64 bit long. Those are currently not
> > +	 * supported by readl nor writel, so just asserting here until then.
> > +	 */
> > +	GUEST_ASSERT(reg_bits == 32);
> 
> IROUTER *does* support 32bit accesses. There are no 64bit MMIO
> registers in the GIC architecture that do not support 32bit accesses,
> if only because there is no guarantee about the width of the MMIO bus
> itself (not to mention the existence of 32bit CPUs!).
> 
> See 12.1.3 ("GIC memory-mapped register access") in the GICv3 arch
> spec.

I see, thanks for the pointer. Will update the comment in v2. Although I
might keep the assert as this function doesn't support 64bit accesses
(yet).

Thanks,
Ricardo

> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
