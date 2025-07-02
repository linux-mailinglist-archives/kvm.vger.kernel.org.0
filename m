Return-Path: <kvm+bounces-51297-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 87AC1AF5A94
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 16:09:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 684E31C27356
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 14:09:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8BA8287266;
	Wed,  2 Jul 2025 14:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="izoqjNnF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204ED79F5
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 14:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751465270; cv=none; b=jAxc0VE1geklLAA+FWZJsvo+QyqMT2qe7rne3iwinTxdC3CQKtLjN9vP//vIBX7mo3fd/sGxc8TKvXi+BfuEG1Zymj8gLo8HKOj5oGeunPWxGOQxJmGGQfj/qMpCUGyMQbpq7yvi3CWUN/zhUzfz4TWtWwtO/xkE+4IvB7PaLM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751465270; c=relaxed/simple;
	bh=JgM6uQPOSTPbn7vlABRvzmnevYaSVFtfopF3IcRPT3s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UVWFIhoRUTQbVKlO70fQ4dhVjKSCH04X8aW+YWE4yY6rKdUZJrXOL4O1NtnCy645Ohy5PGECB6uJObqdN7fVEvYFiH6xtCRuQ/8gZWgJL0L4BmGFMfKE674oLKlBhDHJpka4Xpm1FbwyB2GdMhIKldHVD6lE3LiU4Sbo3HCAHZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=izoqjNnF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751465268;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=QtugXBwpmof8PtjrVGSF5iQiiRq53WoQXJVBl10e0QY=;
	b=izoqjNnFrEmxjv1H1fTUEQBFjg7DfRN7E4cr0fEKyRAO0DjzuKlgZVDfiNmUnnhCb2yyNp
	yINowRJdQp3k8ZA6Ro3dcQg/eA48Dd9bWEvz1kR6QRnBO+lzn0vhdON8gFHIym/S50FMWB
	WfoXDupEI7kj6yeY4CgkBw6kaDOe/Bw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-454-hEEmhqV_PKCwYXFhiGfBWA-1; Wed, 02 Jul 2025 10:07:44 -0400
X-MC-Unique: hEEmhqV_PKCwYXFhiGfBWA-1
X-Mimecast-MFC-AGG-ID: hEEmhqV_PKCwYXFhiGfBWA_1751465263
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-450d64026baso37578375e9.1
        for <kvm@vger.kernel.org>; Wed, 02 Jul 2025 07:07:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751465263; x=1752070063;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QtugXBwpmof8PtjrVGSF5iQiiRq53WoQXJVBl10e0QY=;
        b=B180Cl1artzayNuBrxYqlp+iT6iFe7mHsZZGJ/P1KCmbYZMCaA1nnaSJax4NHrMQvt
         TM7cRMdNNqJHs98ftvO6489Kd/YU0dNqe9iVHjzdoz4mUleYMU5HwpYzAwMS8LGR8FQ0
         D4E5O6gOFjfiY6RV5hcxCLiJWLxTcCMRNWNtG0peTqyjsuaXAqr90gEnkZ2BldfxoLqb
         4JvY0/FpRd5gCXhHulJMwqYdVaDuqq2pIFBjjF09wGBnqDKWt6GMsONnI+ZdFkjKg+B3
         bSFTC/poDQx627HWh7f8CJKszTEgiuO6cN50nz6vo6Ih9fr8c3NOiBLXvq4Y1Fy2cSpw
         SL9A==
X-Forwarded-Encrypted: i=1; AJvYcCW9cm6xVYRTeWYiTuxeFtwum7mq876xx/1NNgwd9e0kNxw3SsizWTFKPNCGZ9nxFvReEcg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yww7AS7UlbD8SXgW8u5yKa+W/DyXZluK4vFx8S/ZWmg9u4Xca7t
	+3kw+I733HlYjtBQ4LG/tEg+CSlkUE0r1zdW+54E86GQopGH9BztBe0kVIbdyituOzfiSTm2ou3
	5k39NwUDCUVMzdap06K8s5avgwxu4/3GKqfZO7cc1JWDBuNnGiumQzQ==
X-Gm-Gg: ASbGnctsyIbby1Qv5qYMZ0EGT27VZx/WeU/LBHsZO1JNfXedQTmq+dZLRasQrtRHdSv
	or2cwnKkdyLevIf3DYe/2A5xCuhfon3tLOxANs8dl8zySA4T+qfxxKdUyLQlLwMZZSNk8Xjw8YF
	/ysDvytW8VOvCBtCxG8rOr6jDc/pwn39Lf0Wdeqwn9+TtBURvHYXsm42MY5V19pn+DCEC9AgnHL
	OlF5DNnqrWulGDMq0OQwiM2TIUM1R/wXXwCXNP6zFoAedq4jVNBUA9FH4UXm295tlMsk5N6P65q
	FfWbBEN/Ey5hE04pNqTjJTwFyGPnvlzPuL1d2moWZfw4qhpNeO8vB20mKZ+AJw==
X-Received: by 2002:a05:600c:3b01:b0:453:99f:b1b0 with SMTP id 5b1f17b1804b1-454a3706e45mr28815165e9.20.1751465263162;
        Wed, 02 Jul 2025 07:07:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF5YuCq5rpUy6RMv0jfgdQbgLyOb/XAUKuoXtz40yFdPi0MgOsaJG33C7l4K2KM2eHAFCoDsQ==
X-Received: by 2002:a05:600c:3b01:b0:453:99f:b1b0 with SMTP id 5b1f17b1804b1-454a3706e45mr28812865e9.20.1751465261164;
        Wed, 02 Jul 2025 07:07:41 -0700 (PDT)
Received: from [192.168.0.6] (ltea-047-064-114-041.pools.arcor-ip.net. [47.64.114.41])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-453a85b3d44sm36303505e9.0.2025.07.02.07.07.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Jul 2025 07:07:40 -0700 (PDT)
Message-ID: <69c1b5df-2b49-4a3c-811c-ad6141a22dbe@redhat.com>
Date: Wed, 2 Jul 2025 16:07:39 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 1/2] scripts: unittests.cfg: Rename
 'extra_params' to 'qemu_params'
To: Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
 andrew.jones@linux.dev, lvivier@redhat.com, frankja@linux.ibm.com,
 imbrenda@linux.ibm.com, nrb@linux.ibm.com, pbonzini@redhat.com,
 eric.auger@redhat.com, kvmarm@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
 david@redhat.com, linux-s390@vger.kernel.org
Cc: Shaoqin Huang <shahuang@redhat.com>
References: <20250625154354.27015-1-alexandru.elisei@arm.com>
 <20250625154354.27015-2-alexandru.elisei@arm.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20250625154354.27015-2-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 25/06/2025 17.43, Alexandru Elisei wrote:
> The arm and arm64 architectures can also be run with kvmtool, and work is
> under way to have it supported by the run_tests.sh test runner. Not
> suprisingly, kvmtool's syntax for running a virtual machine is different to
> qemu's.
> 
> Add a new unittest parameter, 'qemu_params', with the goal to add a similar
> parameter for kvmtool, when that's supported.
> 
> 'extra_params' has been kept in the scripts as an alias for 'qemu_params'
> to preserve compatibility with custom test definition, but it is expected
> that going forward new tests will use 'qemu_params'.
> 
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
> Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
...
> diff --git a/docs/unittests.txt b/docs/unittests.txt
> index c4269f6230c8..3d19fd70953f 100644
> --- a/docs/unittests.txt
> +++ b/docs/unittests.txt
> @@ -24,9 +24,9 @@ param = value format.
>   
>   Available parameters
>   ====================
> -Note! Some parameters like smp and extra_params modify how a test is run,
> -while others like arch and accel restrict the configurations in which the
> -test is run.
> +Note! Some parameters like smp and qemu_params/extra_params modify how a
> +test is run, while others like arch and accel restrict the configurations
> +in which the test is run.
>   
>   file
>   ----
> @@ -56,13 +56,18 @@ smp = <number>
>  Optional, the number of processors created in the machine to run the test.
>  Defaults to 1. $MAX_SMP can be used to specify the maximum supported.
>   
> -extra_params
> +qemu_params
>  ------------

Please adjust the length of the "---" line now, too.

With that nit fixed:
Acked-by: Thomas Huth <thuth@redhat.com>


