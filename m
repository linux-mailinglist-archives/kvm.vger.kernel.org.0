Return-Path: <kvm+bounces-8409-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F375F84F161
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 09:32:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 24FBF1C22597
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 08:32:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE56256B90;
	Fri,  9 Feb 2024 08:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W57+KA6h"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C202EB14
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 08:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707467550; cv=none; b=Mq1NILSkmvshRrvpwoGfqoW7xgmP1B977cKRKT/xyCr7Y6vV11pDaES1wdV9nkRMkS6Py07FQsOlQX9qMiOzvwo6YUw9AcEFYF20h0Q9y0LiBYlO2Yg+RsxRD+QclPkPNnNwFaeRyhWVjdmbQG8Gl3n/7EuzxMptKGc755ctLf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707467550; c=relaxed/simple;
	bh=SNAFyvRV8ArvpSELs8/L7OL/I+4zB3EQAnWaBFE1nKA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P/mzw1DYkoCm28IVJwoIQ+kFEe4fi+KI+Dx0XOyc0amhLNvcyflgeNSe9qmGNXEa7xii1Avn4qGbIL/aOyuX9ChuXyLo8DtnjO7RG3w72gv3n353tAqfgBpeNvJacLDda35Ar+/4NIpep5xZxr1BEe3Fmu1CwtR91Hhu1JW0SIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W57+KA6h; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707467547;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=n1+bf0Nx8c8mDk6BEeuFlVUau/1lVtJgwfFu+gol4dA=;
	b=W57+KA6hTJE8h8wKY87cCMBgXYn87w7z7v6Zd46TmRJ8qqqOQ/B94Ticq4vxbk2HVnFTrc
	lTbpdWxlm0QUojPGZhTvxA1K8FlKTSXFv7AUH2DIRCUTcVmgPXUSlt8ubo0fJW3ge1NwxK
	K7/ageT1e9zwz6XAe44dsB6ESzaTveA=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650-zokdq9QbMx6j9bJqzOJJyg-1; Fri, 09 Feb 2024 03:32:26 -0500
X-MC-Unique: zokdq9QbMx6j9bJqzOJJyg-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a382663cfa1so37704466b.3
        for <kvm@vger.kernel.org>; Fri, 09 Feb 2024 00:32:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707467545; x=1708072345;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n1+bf0Nx8c8mDk6BEeuFlVUau/1lVtJgwfFu+gol4dA=;
        b=mZ/LPQJjE7Qz/QNd0sFhTyBAtjZDSKlmtoyss0AB4MQUiwk5ZUxSf7lseGKlpE12pG
         KPTtN/CHHGKAl6F1cy2kcmWY4z11LxuvG5uTUSaYsOdEqJHFtYsKN65hx+8QnQNtfwqs
         Q569L6CC9zZfMI/WmYRRXsd3aDD+Xb2a/VSe/uDxrcNR3qi4nqpzyJe27wYGx+f8iaBX
         UJVBabmCKOfbdKktA7A+GUVpJRxukO1WZhXPS4g1dPyIsS8sTKh6w3AXWE6F48ABrMRL
         Omz0UJXqv8Vb8fvn3lhGm8BmMWi/8qlkmUJMHV0nUTS5QT/7BohAdau/jNbgQsmmPfdR
         Uv0A==
X-Gm-Message-State: AOJu0Ywl+RUvKxeABn84FxFV3ir4/0fmTAM0YbFyNm8gaQFyxD4L1N5R
	e2Mz6cbbqHP6eQAjvFisw07cT70NV4sTtOakYZyogzN22tqitzh1J1ghl0Kxat+PZM99M+0EdfW
	j8luZyK1wBclzSlr9GJUbABpSKbK4C9b2XJrcbiTFpTik7+sKbA==
X-Received: by 2002:a17:906:f25a:b0:a38:7541:36f6 with SMTP id gy26-20020a170906f25a00b00a38754136f6mr534604ejb.21.1707467545427;
        Fri, 09 Feb 2024 00:32:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE/T6YYLfzbp3yhYxtgIsbBvBi9OmPusrYwMtKL4j3WI45fIZaoPgiu1tQyIJoywazyiWjlKA==
X-Received: by 2002:a17:906:f25a:b0:a38:7541:36f6 with SMTP id gy26-20020a170906f25a00b00a38754136f6mr534582ejb.21.1707467545120;
        Fri, 09 Feb 2024 00:32:25 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWXiUg04J0xyZA2xGb9Fu4y0ntNnaZfu5u3wCECya3Mj6SWlZwp5ICs3/Ov2/qiL9su432EHDvLiVJ0KuNjkJ9dA+qBka4y8ssadh6OiEJ5wpy1En3Fx6anCAdFa7L7MQ/5WVXwqd08bOmyybu5k7Qp1UMvIypUKIMPgtveVcd/GscsLTNJxkC7CaS/yJcLRXIRobE2cKHHIHL5sNoJ059E+mN1EgspRqxG1jLZpHKIRYudg+rhDdl4OtfFPow7/DAAcE/0UIo+I6M8OqxAw4LzeRm++4M4N032W3p0NvaLAdALIWIF/bz89lF45wQXVnsgVCFvipJxUOfJqVQ+tLKDf7Dm8rNEogN2oEb+qJl5xCTmAsxN0sSXNr0ar2u0ZxLikYF3QyLVUj9CsgOiEbIs2k7zhC71oFP6Eq0BDU/dVGAP0Ip74uqtYXDZDXYkmdNY01V18wx696yEfj1s7ZfgIstsNWb5OHSzpU25dubiYvEDA39m6AxMqZD8gr65Yuhuq60pdfoXeVeQ9K7ds7G3+Qqc
Received: from [192.168.0.9] (ip-109-43-177-145.web.vodafone.de. [109.43.177.145])
        by smtp.gmail.com with ESMTPSA id tb5-20020a1709078b8500b00a35e3202d81sm519996ejc.122.2024.02.09.00.32.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Feb 2024 00:32:24 -0800 (PST)
Message-ID: <32a940e0-2b6d-489d-b987-41d640d04dd0@redhat.com>
Date: Fri, 9 Feb 2024 09:32:23 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v3 8/8] migration: add a migration selftest
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
References: <20240209070141.421569-1-npiggin@gmail.com>
 <20240209070141.421569-9-npiggin@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240209070141.421569-9-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09/02/2024 08.01, Nicholas Piggin wrote:
> Add a selftest for migration support in  guest library and test harness
> code. It performs migrations a tight loop to irritate races and bugs in

"*in* a tight loop" ?

> the test harness code.
> 
> Include the test in arm, s390, powerpc.
> 
> Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com> (s390x)
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
> This has flushed out several bugs in developing the multi migration test
> harness code already.
> 
> Thanks,
> Nick
> 
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
> index fe601cbb..1ffd9a82 100644
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
> +
> +arch = arm64

Please swap the last two lines!

>   # Test PCI emulation
>   [pci-test]
>   file = pci-test.flat

With the nits fixed:
Reviewed-by: Thomas Huth <thuth@redhat.com>


