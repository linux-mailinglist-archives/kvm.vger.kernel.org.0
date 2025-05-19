Return-Path: <kvm+bounces-46966-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ED0A8ABB6DC
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 10:14:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4BAC3164F28
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 08:14:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A2B1269AE6;
	Mon, 19 May 2025 08:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S55i6/Eg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D93B226981F
	for <kvm@vger.kernel.org>; Mon, 19 May 2025 08:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747642432; cv=none; b=RhIskCwC0BHa1IEc254N7J3naztfP/GNzARiJH0tmjUgZDqgn8MayesKcJeEH5ceVAdxay4CIzN333rD+QpdSUTbk8rkRdnWAr3YkNwa/l9CWiI2yQP7kSgZtjMPVvDs6ZGtkvCj0OkmNWBulPKL0YKprQB94aslAiXRGLSX7Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747642432; c=relaxed/simple;
	bh=Eu3W+hohQyyMEX725mTcqUwWoPBTenrR9qpK8mDWlr8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TUUy0MCXJXZi1aL9wYcKOBSOFFEX0z3GvTbqneCZxBtxz26oa7x6NB7YimSEplBJpsNuWO1ePI53sWRUMQyd5MQM88GXuvDdjXkCAB+jRF3utT2MuckjUR2sRlbvFxlBfCU7mSuR+PjkC0pGDzFdmLSrSOvI0mJBrlTcFVlkQhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S55i6/Eg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747642430;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=81MSjO1sHE2YfuqWDok69M/T/8z7rZ6g9u0DZWkIwK4=;
	b=S55i6/EgY/wztwyXBTrLyszqyicv050CD7UqZxWX1qghacuQMcodbUyt7ciWUAWfPcrtI5
	iQCcfq28Fc2DvenJBh4KUmO8s9hh7Nl75i6AAr1/zPA3Gz4pgxBiw2Y10JH0waeDKvdv3w
	GPTYup47bQO7rwdnenC4dpUkc1soal8=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-483-DRjZ6qyvOPSj5dnfogXELw-1; Mon, 19 May 2025 04:13:48 -0400
X-MC-Unique: DRjZ6qyvOPSj5dnfogXELw-1
X-Mimecast-MFC-AGG-ID: DRjZ6qyvOPSj5dnfogXELw_1747642427
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-7375e2642b4so3040951b3a.2
        for <kvm@vger.kernel.org>; Mon, 19 May 2025 01:13:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747642427; x=1748247227;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=81MSjO1sHE2YfuqWDok69M/T/8z7rZ6g9u0DZWkIwK4=;
        b=Qb0l6UZjxF2ec93qElZQ0oHEn5ar+2wv1CoXs51Uog0+XwKVqgr53/7We/LdBwe9bR
         vIShyWv4rnFv8ycOlOzJhULAz5EUrmkYYs6enXS7jGNk/ESSKsJcC4uSBXA4ia76UpjB
         ddUjNK1kSXEuyah2MSxx0eyyon3tjn99t7n9kdLZrMbzhQ6F8+h1Tva4ZRQpCSgxweB6
         9pPp1lHRh7Y9dwUeIVze2lKlFbw12ky0eT7FosxgRghSlMcCDIyKMTcqLipdCWi1tD56
         Nq1nZpojQ9RJaIJ3NG4H5pmtLjkwyyTeuAbEbwIlWumWkCa3uOBdcxrtbkEaszRBmIcJ
         xnBw==
X-Gm-Message-State: AOJu0YxPlGSxAfWEX0Hs8xQIqflJVuJ75jZIxH+VcIV0CVzJ+ABLoCeB
	1Luuz6Ruszy9BbZuxgA1fFj9qKHCPUo2f0YGHc7jgt7AuvtUDFL2MjSlHS27q+mYq69p4zBywwj
	l9xC0aXFQa+B0Ds1xZwuJdP/WeRZQndDn9M31nOAJSPhI3IhWAkvcpg==
X-Gm-Gg: ASbGncsP3/lGSZJJDjfJrdQFNUGJMIziYTjm7F1MK2MeyGlsA5i1ceJlBQc5DxGgozt
	EWEOAX8TQPWA84r6hAywZ3CMW54/bm7PLEXYIE3np1k64tNi3huYNw81G8nKV0oOZNvv6GVEwFV
	ofRGxZyE3C0bShXexUESjWAxosjgSXlPoZCSfvq5dufuBxTvNNInjuHp6SJnyKtcBMzcy8TDEF0
	VnFiQSNO+jp0lHeajkBL/Jd0nm/X74tNwPtAp0l7O9qTQY21dY/Z9Pp6kP8ZviVyD+L/niWS61o
	1K+aNYSyS17mBLWR
X-Received: by 2002:a05:6a21:7e86:b0:218:bbb:c13d with SMTP id adf61e73a8af0-2180bbbc1b0mr13502992637.13.1747642427003;
        Mon, 19 May 2025 01:13:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFKS9dBCdoBJSd2fsnxqZtqXXkuCdfx1TMqH+JdIVWuZzC6jtmWsd4CbKxNWoE3TDYRsqvBDg==
X-Received: by 2002:a05:6a21:7e86:b0:218:bbb:c13d with SMTP id adf61e73a8af0-2180bbbc1b0mr13502979637.13.1747642426697;
        Mon, 19 May 2025 01:13:46 -0700 (PDT)
Received: from [10.72.116.146] ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-742a970b9c7sm5585368b3a.48.2025.05.19.01.13.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 May 2025 01:13:46 -0700 (PDT)
Message-ID: <e90c3221-4a31-4c53-afb9-c2fcf09ae358@redhat.com>
Date: Mon, 19 May 2025 16:13:35 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v3 11/16] scripts: Add KVMTOOL environment
 variable for kvmtool binary path
To: Alexandru Elisei <alexandru.elisei@arm.com>, andrew.jones@linux.dev,
 eric.auger@redhat.com, lvivier@redhat.com, thuth@redhat.com,
 frankja@linux.ibm.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com,
 david@redhat.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, will@kernel.org, julien.thierry.kdev@gmail.com,
 maz@kernel.org, oliver.upton@linux.dev, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, joey.gouly@arm.com, andre.przywara@arm.com
References: <20250507151256.167769-1-alexandru.elisei@arm.com>
 <20250507151256.167769-12-alexandru.elisei@arm.com>
Content-Language: en-US
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20250507151256.167769-12-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/7/25 11:12 PM, Alexandru Elisei wrote:
> kvmtool is often used for prototyping new features, and a developer might
> not want to install it system-wide. Add a KVMTOOL environment variable to
> make it easier for tests to use a binary not in $PATH.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Reviewed-by: Shaoqin Huang <shahuang@redhat.com>

> ---
>   run_tests.sh          | 1 +
>   scripts/arch-run.bash | 3 ++-
>   2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/run_tests.sh b/run_tests.sh
> index dd9d27377905..150a06a91064 100755
> --- a/run_tests.sh
> +++ b/run_tests.sh
> @@ -36,6 +36,7 @@ The following environment variables are used:
>       TIMEOUT         Timeout duration for the timeout(1) command
>       CHECK           Overwrites the 'check' unit test parameter (see
>                       docs/unittests.txt)
> +    KVMTOOL         Path to kvmtool binary for ARCH-run
>   EOF
>   }
>   
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index 8cf67e4f3b51..d4fc7116abbe 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -372,7 +372,7 @@ search_kvmtool_binary ()
>   {
>   	local kvmtoolcmd kvmtool
>   
> -	for kvmtoolcmd in lkvm vm lkvm-static; do
> +	for kvmtoolcmd in ${KVMTOOL:-lkvm vm lkvm-static}; do
>   		if "$kvmtoolcmd" --help 2>/dev/null| grep -q 'The most commonly used'; then
>   			kvmtool="$kvmtoolcmd"
>   			break
> @@ -381,6 +381,7 @@ search_kvmtool_binary ()
>   
>   	if [ -z "$kvmtool" ]; then
>   		echo "A kvmtool binary was not found." >&2
> +		echo "You can set a custom location by using the KVMTOOL=<path> environment variable." >&2
>   		return 2
>   	fi
>   

-- 
Shaoqin


