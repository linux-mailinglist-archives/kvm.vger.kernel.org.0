Return-Path: <kvm+bounces-54935-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D910B2B551
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 02:31:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 607752A3AB2
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 00:31:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2DD416F288;
	Tue, 19 Aug 2025 00:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="jwPZHbEC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171DE3451CC
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 00:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755563449; cv=none; b=jeAfTzq5yeThhZxT6hkQj/Xm4wGQJoNKE+TFtxtvaXJnWB3HPNWE0lj82eULkLDk72d30KtJBAlZs09nrPCzy1pURn8Le1pNZ88Gi7QRnsd2sU0rUA0QWy8Wp5hHDVo3tfk4fcvY5sv2MnK5wYhz6F/H02PmcFRaggZCEcDhoyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755563449; c=relaxed/simple;
	bh=7cSAwm8Mpm474gJFqJTDSfYjShfJlHAUKQHNp9cO/CU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sIii+KmMs+KJgXYnZoiwG0e8FHD3QDi9gl6384Z670C5o31c953ub18iLA7E8vZe+CqZ9SAP+Pttj2awsu7MWIbvEtA/vZaEf7UrVml+XpwRf23oC4fnhf5D1NDPUgah8HXierlDQ1a/VtfhN1nGvHSLXswUmW01r/JR3R1nyq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=jwPZHbEC; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4b134aa13f5so22288981cf.1
        for <kvm@vger.kernel.org>; Mon, 18 Aug 2025 17:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1755563446; x=1756168246; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hLw3Ly5lBpwG37igk8nIXvrjC9WRvilq8gEy55nQz4Q=;
        b=jwPZHbECeV+xOkYEcU+z1HIZtR6xcdUSyjRWedKpftrEJFHr41eUThABrxS2BmG+EE
         0HQIz2xY/Vx4O95K2ZGsU9pkOL1ONpTXqZdOY2kCgknY0cHgifEsXZ+Do9zeM/dGLevg
         LbQFFFTKxyBRLP4VvDwd2RWmsWptbxsD23B3RKzx/0YHOZm9aSoYsVj9Z/wuhIwTB8at
         2cUTJAV/H/HOD7TilX7at3nETQ+dDaizDMTuRqqhEIEy6gQ+Liv1xk6bIfZVFJlWovT2
         tGFOgFYgkp4SP/QOG7O1eQLUOthO47spiTiV7YYb2nVdYsJsTrN7vJWgXjUj3DQlpteP
         yvyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755563446; x=1756168246;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hLw3Ly5lBpwG37igk8nIXvrjC9WRvilq8gEy55nQz4Q=;
        b=GUF4a2ND2WIzDYAI0W6P6BjN+td1a7V4yI7Y1AUp73oL9q5C5B95EY2APeI7jBY3Tj
         p1UF4iyjvWQOjE8+7H1t2PJsOTQqyiKQbOQR69MiWDi9tchllz5UcJkaYrvnF6DwBEI9
         f2Y73i5pPYg6e/Trtd8VN2RtzothzM3zrTtgJN/gsB7N70bAFGjriFvanqw+6QH97lRz
         yuQKDVYoVLPCXIat8hgDuUTnDAXfOyIlJevJfWAacGWZa8Vw2lcuELwC/vIGo4S7YbGC
         mzO/Gw0D7vKd0YH9Pe88gA7hV4U5cNHVqm3HF7LJOcGOdFLcUMSix/XwL+bBYkqCmXz2
         MGHQ==
X-Forwarded-Encrypted: i=1; AJvYcCXYVzBn5xI0NGzDmboYrPLAivjMYWep7505P1qDyawfBlAFRRgQt9Q8qG2qzCA1AGpulE0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMZJILIQlWbDBzUzsWC4PiAu0Xnl4mUhr4RNGwzIZmCngnFsO5
	bpVrgAHF7rKT6NRz44b4yj98YkvErGxX2FC3U8gxxBWjgTDhGdwcASWLd9oPhIExg9U=
X-Gm-Gg: ASbGnctW6EGdSj+4Z2EYlSNLxQwrTnTVj/qUDJqe/hnr1nsEZLsDA+SbZEoiblGbgAK
	jwhm9zosB8YtWG5wM5p4PmNy0jbc7GIu73bCRdw4cMLkBqa7Rb3DmoALVhsylzsQoaID3NCODy5
	oji5NS8utv7uO43MsK2XMfdDpseeJHw1CEj0t/fKX7eEOm0/jt39rYoKgyEakdVvxYxE9Ca4e8S
	k5AC6Qwdo3B2Wc0dpMT3ZS9A34O+lml0H0fiXzaUECEmPit+Z/c7W1QoN/egCGz+eddMg4lB+qY
	go3hHwqdVsQFhW/9ZQxYSHEHLjQw6akrZ6fixIWSibgRReBwaTfo2gLfuBzJcxj/9UfodbAqKkY
	P5tEXm/HjILN9a25rjpYakK8=
X-Google-Smtp-Source: AGHT+IGBQbFzX0nYDgxxHDXJuUpwrISyNXTFy2dbw5LSBC5tG74mcZCK5FKwm3AQdhXjEGg8m2Q7VA==
X-Received: by 2002:a05:622a:312:b0:4ae:f1c4:98fe with SMTP id d75a77b69052e-4b286e216edmr8455701cf.34.1755563445791;
        Mon, 18 Aug 2025 17:30:45 -0700 (PDT)
Received: from localhost ([173.23.183.85])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b11dc584c3sm58679171cf.17.2025.08.18.17.30.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 17:30:45 -0700 (PDT)
Date: Mon, 18 Aug 2025 19:30:44 -0500
From: Andrew Jones <ajones@ventanamicro.com>
To: Bibo Mao <maobibo@loongson.cn>
Cc: Dong Yang <dayss1224@gmail.com>, pbonzini@redhat.com, shuah@kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	chenhaucai@kernel.org, Quan Zhou <zhouquan@iscas.ac.cn>
Subject: Re: [PATCH] KVM: loongarch: selftests: Remove common tests built by
 TEST_GEN_PROGS_COMMON
Message-ID: <20250818-2e6cf1b89c738f0fb1264811@orel>
References: <20250811082453.1167448-1-dayss1224@gmail.com>
 <11d1992d-baf0-fc2f-19d7-b263d15cf64d@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <11d1992d-baf0-fc2f-19d7-b263d15cf64d@loongson.cn>

On Mon, Aug 11, 2025 at 06:49:07PM +0800, Bibo Mao wrote:
> Hi Dong,
> 
> Thanks for you patch.
> 
> On 2025/8/11 下午4:24, Dong Yang wrote:
> > Remove the common KVM test cases already added to TEST_GEN_PROGS_COMMON
> >   as following:
> > 
> > 	demand_paging_test
> > 	dirty_log_test
> > 	guest_print_test
> > 	kvm_binary_stats_test
> > 	kvm_create_max_vcpus
> > 	kvm_page_table_test
> > 	set_memory_region_test
> > 
> > Fixes: a867688c8cbb ("KVM: selftests: Add supported test cases for LoongArch")
> > Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
> > Signed-off-by: Dong Yang <dayss1224@gmail.com>
> > ---
> >   tools/testing/selftests/kvm/Makefile.kvm | 7 -------
> >   1 file changed, 7 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
> > index 38b95998e1e6..d2ad85a8839f 100644
> > --- a/tools/testing/selftests/kvm/Makefile.kvm
> > +++ b/tools/testing/selftests/kvm/Makefile.kvm
> > @@ -199,17 +199,10 @@ TEST_GEN_PROGS_riscv += get-reg-list
> >   TEST_GEN_PROGS_riscv += steal_time
> TEST_GEN_PROGS_loongarch = $(TEST_GEN_PROGS_COMMON) is missing.
> 
> BTW irqfd_test in TEST_GEN_PROGS_COMMON fails to run on LoongArch, does this
> test case pass to run on Riscv?

It appears to. It outputs the vm mode created and then exits with a zero
exit code.

Thanks,
drew

> 
> Regards
> Bibo Mao
> >   TEST_GEN_PROGS_loongarch += coalesced_io_test
> > -TEST_GEN_PROGS_loongarch += demand_paging_test
> >   TEST_GEN_PROGS_loongarch += dirty_log_perf_test
> > -TEST_GEN_PROGS_loongarch += dirty_log_test
> > -TEST_GEN_PROGS_loongarch += guest_print_test
> >   TEST_GEN_PROGS_loongarch += hardware_disable_test
> > -TEST_GEN_PROGS_loongarch += kvm_binary_stats_test
> > -TEST_GEN_PROGS_loongarch += kvm_create_max_vcpus
> > -TEST_GEN_PROGS_loongarch += kvm_page_table_test
> >   TEST_GEN_PROGS_loongarch += memslot_modification_stress_test
> >   TEST_GEN_PROGS_loongarch += memslot_perf_test
> > -TEST_GEN_PROGS_loongarch += set_memory_region_test
> >   SPLIT_TESTS += arch_timer
> >   SPLIT_TESTS += get-reg-list
> > 
> 

