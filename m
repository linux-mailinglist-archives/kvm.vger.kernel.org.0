Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB9692A4EB9
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 19:23:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729274AbgKCSXp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 13:23:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38516 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727688AbgKCSXo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Nov 2020 13:23:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604427822;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BFHudL6OLidfzJcRhC7GlWDAd+F1m07auxCfvMR6q6s=;
        b=AQ/zNuFjUrkb5c23E/e0b2hgld+GiLmdNGTOEWi48qk3/K3wMP75NnAc7iMlAO+Ku/oLFA
        fYVuwCk60GUs4ECd2ResOg0bT5cogo/vX8K/gaQDHE3zDHSQ91tH9c2RxT/AzUj0sitFl4
        KkN9sSz3egUw63dFT+cctfkJT40Hi0A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-508-BrEHcywZPT-GjTVbzNyT7w-1; Tue, 03 Nov 2020 13:23:38 -0500
X-MC-Unique: BrEHcywZPT-GjTVbzNyT7w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 425B564151;
        Tue,  3 Nov 2020 18:23:37 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.252])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 661915C1D0;
        Tue,  3 Nov 2020 18:23:33 +0000 (UTC)
Date:   Tue, 3 Nov 2020 19:23:29 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        mark.rutland@arm.com, jade.alglave@arm.com, luc.maranget@inria.fr,
        andre.przywara@arm.com
Subject: Re: [kvm-unit-tests PATCH 2/2] arm64: Check if the configured
 translation granule is supported
Message-ID: <20201103182329.643z44ny2szp6hfn@kamzik.brq.redhat.com>
References: <20201102113444.103536-1-nikos.nikoleris@arm.com>
 <20201102113444.103536-3-nikos.nikoleris@arm.com>
 <20201103100222.dpryytbkdjaryehr@kamzik.brq.redhat.com>
 <f9ea19cc-b325-2a7f-1b7c-e7da3d99bfca@arm.com>
 <20201103173604.az5ymaw576uz6645@kamzik.brq.redhat.com>
 <cdfbfe16-ac54-aba0-4aa3-4933759175dc@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cdfbfe16-ac54-aba0-4aa3-4933759175dc@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 03, 2020 at 06:14:53PM +0000, Nikos Nikoleris wrote:
> On 03/11/2020 17:36, Andrew Jones wrote:
> > On Tue, Nov 03, 2020 at 05:03:15PM +0000, Alexandru Elisei wrote:
> > > > +}
> > > > +
> > > > +static inline bool system_supports_granule(size_t granule)
> > > > +{
> > > > +	u64 mmfr0 = get_id_aa64mmfr0_el1();
> > > > +
> > > > +	return ((granule == SZ_4K && ((mmfr0 >> 28) & 0xf) == 0) ||
> > > > +		(granule == SZ_64K && ((mmfr0 >> 24) & 0xf) == 0) ||
> > > > +		(granule == SZ_16K && ((mmfr0 >> 20) & 0xf) == 1));
> > > > +}
> > > 
> > > Or we can turn it into a switch statement and keep all the field defines. Either
> > > way looks good to me (funny how tgran16 stands out).
> > > 
> > 
> > Keeping the defines is probably a good idea. Whether the function uses
> > a switch or an expression like above doesn't matter to me much. Keeping
> > LOC down in the lib/ code is a goal of kvm-unit-tests, but so is
> > readabilty. If the switch looks better, then let's go that way.
> > 
> 
> I liked Drew's version in that it was very concise. The new version will be
> much longer. If you think it's more readable I'll use that instead.
> 
> diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
> index 02665b8..430ded3 100644
> --- a/lib/arm64/asm/processor.h
> +++ b/lib/arm64/asm/processor.h
> @@ -117,5 +117,38 @@ static inline u64 get_ctr(void)
> 
>  extern u32 dcache_line_size;
> 
> +static inline unsigned long get_id_aa64mmfr0_el1(void)
> +{
> +       return read_sysreg(id_aa64mmfr0_el1);
> +}
> +
> +#define ID_AA64MMFR0_TGRAN4_SHIFT      28
> +#define ID_AA64MMFR0_TGRAN64_SHIFT     24
> +#define ID_AA64MMFR0_TGRAN16_SHIFT     20
> +
> +#define ID_AA64MMFR0_TGRAN4_SUPPORTED  0x0
> +#define ID_AA64MMFR0_TGRAN64_SUPPORTED 0x0
> +#define ID_AA64MMFR0_TGRAN16_SUPPORTED 0x1
> +
> +static inline bool system_supports_granule(size_t granule)
> +{
> +       u32 shift;
> +       u32 val;
> +       u64 mmfr0 = get_id_aa64mmfr0_el1();
> +       if (granule == SZ_4K) {
> +               shift = ID_AA64MMFR0_TGRAN4_SHIFT;
> +               val = ID_AA64MMFR0_TGRAN4_SUPPORTED;
> +       } else if (granule == SZ_16K) {
> +               shift = ID_AA64MMFR0_TGRAN16_SHIFT;
> +               val = ID_AA64MMFR0_TGRAN16_SUPPORTED;
> +       } else {
> +               assert(granule == SZ_64K);
> +               shift = ID_AA64MMFR0_TGRAN64_SHIFT;
> +               val = ID_AA64MMFR0_TGRAN64_SUPPORTED;
> +       }
> +
> +       return ((mmfr0 >> shift) & 0xf) == val;
> +}
> +
>  #endif /* !__ASSEMBLY__ */
>  #endif /* _ASMARM64_PROCESSOR_H_ */
>

I'm happy with it either way.

Thanks,
drew 

