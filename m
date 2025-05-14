Return-Path: <kvm+bounces-46412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 009F0AB6138
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 05:30:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 82AF41B44F84
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 03:30:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3C9215199A;
	Wed, 14 May 2025 03:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BLqh14AK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D3B1F0E20
	for <kvm@vger.kernel.org>; Wed, 14 May 2025 03:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747193406; cv=none; b=kBw6k368vOEdG7K4h6j/WPmeltVg559HVr0SahzL3jqO4SITpoe+8cHI9QZD5wAXhut2Ehuur7ieUAuS2mTlT27sh8bBgbHXITM9ungwB2T4rdgiuRVN5cl2hCw7GO+wpnLaG/Qp5lmYwBGXMj8NK9FI7BSkrWF4nXZZd4EM+zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747193406; c=relaxed/simple;
	bh=xe+r7aUNbKYL48IaCa6f/vynWducxTozNskiWKlpSl0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oXBLfG/0tz/IsFl4yiLl3xvuF2xe3XllEVRh6MiMtSOPeSapP0o8tOkDjiM58kHUqtjgkrtxwFtVsxUub3Fa3RwTL6V+4QI5hP/IgVfue8AIl7QDDp+Scft4TckmR/FaU096rQjkwIZzsMLsqy6CdQnqObnwPrsCWKbMr6GbsUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BLqh14AK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747193403;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zPNj1R9ALDGy4ZhAvSAe9nUoPzbthadZcf4T/oJDS44=;
	b=BLqh14AK3i7yq/SIhFdIqLoMtEscnaCcni++vjELUvuo9ccaUuNG2PsuvRAzWtKck4lnwI
	R2978GwDIgjes9m5so8sPcCpaEpVDmYdNs7Q867VAmHwlgvCVjTK1SR+cDKBQzJmIhvOTu
	iTk9sAxY4VXFDq+i+orSXwd7SHR2Y5Q=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-616-LLa-MH3MO9CK84JXdtBCiA-1; Tue, 13 May 2025 23:30:02 -0400
X-MC-Unique: LLa-MH3MO9CK84JXdtBCiA-1
X-Mimecast-MFC-AGG-ID: LLa-MH3MO9CK84JXdtBCiA_1747193402
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-742849f4155so464375b3a.1
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 20:30:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747193402; x=1747798202;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zPNj1R9ALDGy4ZhAvSAe9nUoPzbthadZcf4T/oJDS44=;
        b=n5SPU3XLARj2nM5+KrGC//sIT/gUMVeQvTy+hQYQvMfbA/9K2lyezEiJZ7RnXK8zaR
         5yCTqmJzi3QPYbXx+8BFtoLgVwqhzqHIUpmVOec4jN8yPmPzq7GXRiiJD+ygFKZDC/RI
         dgJJsTKUQBgk0a6Byo3KvJIWq0b0sK9sPh8fLkoKwq2KDmWPR1Snq4ZqaDb7gS4x4ktJ
         D2ua+6S8o7ldXvzXxImWEyOOY/mZxXpSlcU78iSGz3gd/Z7h2KC1VpVrGiHs+j4n2pz4
         BzMHZzCmdR8BvQ9Go4I5hV8N/XcFT0Erm7Kl2HNlt7W46fsAudDRowUmRAiWAP4sREjU
         IPTA==
X-Gm-Message-State: AOJu0YwOeW/WzIXOm+MsIWMdYHN0HbjUmlqE787q8wxY9T3x36kqgOVi
	8GZWB1GONH3cvfvQ1qnQcmnCMqCco6xD2DaeCYuJoBfTiHZMojb68cpXMUsG4X2mcBfoicqSxQP
	DQ6pZOeg1sT5Hn2IyefmagE3c1gfnf/CZKl5gNpr+3Wjvbi7+9g==
X-Gm-Gg: ASbGnctZ3qTP99fNtG22wmq1CMYEWMBISDhvwEe+1/GvavdvFKco48vXm5pWzm6Zou0
	VEfk/lXnI3rN5Zw7tac92gZELiFfwnDPQZuWDPXLAm7Znx+cejr3+rF3JfTUgPIHvBejjjg3fJ/
	cNPO0+PC/hDIo0VqY6cSBdwah79hBCMTZ2tJIf9ivmyJksYkqnQMPBLmeVJuw+IvdzXgacsbEKj
	NvtjlekXcJTg9unrigH8A8vADSPFmHvi955ba39xRYrzVttagyLGhnmJKiX2iSVWCUnrObf/Fme
	/Crf1LktZfCNQ1hs
X-Received: by 2002:a05:6a00:849:b0:73e:2367:c914 with SMTP id d2e1a72fcca58-7428907dbbemr2608214b3a.7.1747193401134;
        Tue, 13 May 2025 20:30:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE4NfRMilmo0WhS6bonXckoq6ayKF8QYGypn6TRZn6O1csy9tmwHCGt4njEOo+8VL50NM6NRQ==
X-Received: by 2002:a05:6a00:849:b0:73e:2367:c914 with SMTP id d2e1a72fcca58-7428907dbbemr2608173b3a.7.1747193400666;
        Tue, 13 May 2025 20:30:00 -0700 (PDT)
Received: from [10.72.116.125] ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74237a8a3adsm8406109b3a.158.2025.05.13.20.29.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 20:30:00 -0700 (PDT)
Message-ID: <54b5bb37-5304-4e73-afc8-bf2a23e6490b@redhat.com>
Date: Wed, 14 May 2025 11:29:51 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v3 04/16] run_tests.sh: Document
 --probe-maxsmp argument
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
 <20250507151256.167769-5-alexandru.elisei@arm.com>
Content-Language: en-US
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20250507151256.167769-5-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/7/25 11:12 PM, Alexandru Elisei wrote:
> Commit 5dd20ec76ea63 ("runtime: Update MAX_SMP probe") added the
> --probe-maxmp argument, but the help message for run_tests.sh wasn't
> updated. Document --probe-maxsmp.
> 
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Reviewed-by: Shaoqin Huang <shahuang@redhat.com>

> ---
>   run_tests.sh | 17 +++++++++--------
>   1 file changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/run_tests.sh b/run_tests.sh
> index 152323ffc8a2..f30b6dbd131c 100755
> --- a/run_tests.sh
> +++ b/run_tests.sh
> @@ -17,14 +17,15 @@ cat <<EOF
>   
>   Usage: $0 [-h] [-v] [-a] [-g group] [-j NUM-TASKS] [-t] [-l]
>   
> -    -h, --help      Output this help text
> -    -v, --verbose   Enables verbose mode
> -    -a, --all       Run all tests, including those flagged as 'nodefault'
> -                    and those guarded by errata.
> -    -g, --group     Only execute tests in the given group
> -    -j, --parallel  Execute tests in parallel
> -    -t, --tap13     Output test results in TAP format
> -    -l, --list      Only output all tests list
> +    -h, --help          Output this help text
> +    -v, --verbose       Enables verbose mode
> +    -a, --all           Run all tests, including those flagged as 'nodefault'
> +                        and those guarded by errata.
> +    -g, --group         Only execute tests in the given group
> +    -j, --parallel      Execute tests in parallel
> +    -t, --tap13         Output test results in TAP format
> +    -l, --list          Only output all tests list
> +        --probe-maxsmp  Update the maximum number of VCPUs supported by host
>   
>   Set the environment variable QEMU=/path/to/qemu-system-ARCH to
>   specify the appropriate qemu binary for ARCH-run.

-- 
Shaoqin


