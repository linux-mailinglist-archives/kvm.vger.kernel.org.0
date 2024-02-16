Return-Path: <kvm+bounces-8869-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C141857EAE
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 15:07:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2AEB228B21C
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 14:07:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B806012CD8C;
	Fri, 16 Feb 2024 14:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BSmS83nm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5CE12C809
	for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 14:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708092323; cv=none; b=J43QjRfRGUZsPecUT3OE9LRD6Cx+va9fNXjrNruu7lkuPuHM7Ra/zCf9ebIpMZ47hsKge8hDQY9cwxBQjh/xHDtnKW2xUGy5t0kEInY1T8uQ94ujud9mx0u7Um5cbzLA/VwDpLCj/zKRnGuesJklzMZ469IyyWcuAOHTa9/mKiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708092323; c=relaxed/simple;
	bh=3/UywGEmfDq8guBuOVIFPW7ddYbA+MZVny/rOXkoC/0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AzPQBxz5vPZoKSBp3Lu3b1laQCHp+uUCT8q/RhGp0yGjOHXNYyWi90dKQ+VnQGH6yxWJjjcQUXnKceZU5ojyhg1QQuGpKiNa54tnFg0/LQJ8vQXaAHt0Tc5WtNcxrvyTRfbmuBHKQQs0eKkeSxnJOmXb5exDs6IXcNfZJncD1oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BSmS83nm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708092320;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lwzLOSSNOTOlXVVos2KmnfPtZGho1mkmqO1WiYK8IAA=;
	b=BSmS83nmmJmvv21vuPHj0GbVo8VIOxJyugzfZ61+IY05hVvDIRLZH+ve6vc72e00M8E3sj
	MCQjrcSN4djyvvXZ0jw5kEIoX/I5ND5+SL0wC+RY9WJ7rGBeSN51LVbMojnWZnuuxIxbBi
	WoEB4XaSSpb1Uv2HoUNsJidVZlWyU70=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-168-42GVhRMyMVmFK7Z9l-k4RQ-1; Fri, 16 Feb 2024 09:05:18 -0500
X-MC-Unique: 42GVhRMyMVmFK7Z9l-k4RQ-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7871806122dso202423385a.2
        for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 06:05:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708092318; x=1708697118;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lwzLOSSNOTOlXVVos2KmnfPtZGho1mkmqO1WiYK8IAA=;
        b=R7tpqzIsh4YAQk9e7dn1Ou0S6OpKsoKy8xBODchEwSVZX5yv1sYZkNCfevfJQ/D85d
         +78Mb+qOKI6bffIrAe8wP8pEknC/gt+Fyd2l4LFZLUPZmc258Tqr9aNhWyo51Dze8CLS
         2lkfXLpG6h424Dw7P/mDU+/v+pMDI9W2uZCDHqasHI51PD7vcW1amWosEG5Gbr1e029L
         iwdpuW/Tn/gXGKG0jK5jAT9+4zKXdLd0A4iREq1N4nL75Ul7EqtKsVeMluybLWRIglO9
         0GmzZvTdRwMw7621bFIPdivc9P+4Cbq6Uf8Ju3rdU9LP5hK6K1wD5nrbP9zJSYCMdOMf
         +akQ==
X-Gm-Message-State: AOJu0Ywrf/YUA9qlU6YOL5/4MLDBlP88tIJO7Q9UfxyyB5KG9EyKvdcd
	E+oJc26AOQID9c4Vl0yHG8gWiiu3CBy4GiJCY10pI/B+rhR76XvYquKN7Hu/VPFKMuyCP+B5WyR
	tRpYUfnwEUgDbdExucIjAfOdi1JLLtCdt5/P4bCCLDb4+BaftEA==
X-Received: by 2002:a05:622a:170b:b0:42d:e765:38c0 with SMTP id h11-20020a05622a170b00b0042de76538c0mr722319qtk.61.1708092318149;
        Fri, 16 Feb 2024 06:05:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGmAgWinSKipDH0Yvn4QXXyIIpV54zWweCnN0Xl+mWnKvc+2T7YM5cZKuTrYuaeWjkXmCKLJw==
X-Received: by 2002:a05:622a:170b:b0:42d:e765:38c0 with SMTP id h11-20020a05622a170b00b0042de76538c0mr722276qtk.61.1708092317827;
        Fri, 16 Feb 2024 06:05:17 -0800 (PST)
Received: from [192.168.0.9] (ip-109-43-177-178.web.vodafone.de. [109.43.177.178])
        by smtp.gmail.com with ESMTPSA id qm18-20020a056214569200b0068d137664e3sm1774065qvb.134.2024.02.16.06.05.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Feb 2024 06:05:17 -0800 (PST)
Message-ID: <77d8fd0d-e2a9-42f7-9a76-08868ab95cb9@redhat.com>
Date: Fri, 16 Feb 2024 15:05:12 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v4 8/8] migration: add a migration selftest
Content-Language: en-US
To: Nicholas Piggin <npiggin@gmail.com>
Cc: kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
 Shaoqin Huang <shahuang@redhat.com>, Andrew Jones <andrew.jones@linux.dev>,
 Nico Boehr <nrb@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Eric Auger <eric.auger@redhat.com>, Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>, Marc Hartmayer
 <mhartmay@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
 linux-s390@vger.kernel.org, kvmarm@lists.linux.dev,
 kvm-riscv@lists.infradead.org
References: <20240209091134.600228-1-npiggin@gmail.com>
 <20240209091134.600228-9-npiggin@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240209091134.600228-9-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09/02/2024 10.11, Nicholas Piggin wrote:
> Add a selftest for migration support in  guest library and test harness
> code. It performs migrations in a tight loop to irritate races and bugs
> in the test harness code.
> 
> Include the test in arm, s390, powerpc.
> 
> Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com> (s390x)
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   arm/Makefile.common          |  1 +
>   arm/selftest-migration.c     |  1 +
>   arm/unittests.cfg            |  6 ++++++
>   common/selftest-migration.c  | 34 ++++++++++++++++++++++++++++++++++
>   powerpc/Makefile.common      |  1 +
>   powerpc/selftest-migration.c |  1 +
>   powerpc/unittests.cfg        |  4 ++++
>   s390x/Makefile               |  1 +
>   s390x/selftest-migration.c   |  1 +
>   s390x/unittests.cfg          |  4 ++++
>   10 files changed, 54 insertions(+)
>   create mode 120000 arm/selftest-migration.c
>   create mode 100644 common/selftest-migration.c
>   create mode 120000 powerpc/selftest-migration.c
>   create mode 120000 s390x/selftest-migration.c
> 
> diff --git a/arm/Makefile.common b/arm/Makefile.common
> index f828dbe0..f107c478 100644
> --- a/arm/Makefile.common
> +++ b/arm/Makefile.common
> @@ -5,6 +5,7 @@
>   #
>   
>   tests-common  = $(TEST_DIR)/selftest.$(exe)
> +tests-common += $(TEST_DIR)/selftest-migration.$(exe)
>   tests-common += $(TEST_DIR)/spinlock-test.$(exe)
>   tests-common += $(TEST_DIR)/pci-test.$(exe)
>   tests-common += $(TEST_DIR)/pmu.$(exe)
> diff --git a/arm/selftest-migration.c b/arm/selftest-migration.c
> new file mode 120000
> index 00000000..bd1eb266
> --- /dev/null
> +++ b/arm/selftest-migration.c
> @@ -0,0 +1 @@
> +../common/selftest-migration.c
> \ No newline at end of file
> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> index fe601cbb..db0e4c9b 100644
> --- a/arm/unittests.cfg
> +++ b/arm/unittests.cfg
> @@ -55,6 +55,12 @@ smp = $MAX_SMP
>   extra_params = -append 'smp'
>   groups = selftest
>   
> +# Test migration
> +[selftest-migration]
> +file = selftest-migration.flat
> +groups = selftest migration
> +arch = arm64
> +
>   # Test PCI emulation
>   [pci-test]
>   file = pci-test.flat
> diff --git a/common/selftest-migration.c b/common/selftest-migration.c
> new file mode 100644
> index 00000000..f70c505f
> --- /dev/null
> +++ b/common/selftest-migration.c
> @@ -0,0 +1,34 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Machine independent migration tests
> + *
> + * This is just a very simple test that is intended to stress the migration
> + * support in the test harness. This could be expanded to test more guest
> + * library code, but architecture-specific tests should be used to test
> + * migration of tricky machine state.
> + */
> +#include <libcflat.h>
> +#include <migrate.h>
> +
> +#if defined(__arm__) || defined(__aarch64__)
> +/* arm can only call getchar 15 times */
> +#define NR_MIGRATIONS 15
> +#else
> +#define NR_MIGRATIONS 100
> +#endif

FYI, I just wrote a patch that will hopefully fix the limitation to 15 times 
on arm:

  https://lore.kernel.org/kvm/20240216140210.70280-1-thuth@redhat.com/T/#u

  Thomas


