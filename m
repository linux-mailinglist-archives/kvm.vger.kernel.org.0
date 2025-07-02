Return-Path: <kvm+bounces-51298-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D0DD0AF5AA3
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 16:11:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 20C201C4097F
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 14:10:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0B9C286426;
	Wed,  2 Jul 2025 14:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XId41UTg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334A3219A8D
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 14:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751465408; cv=none; b=Aeqy3P66pvd7JfRc0luPnxb3jJ4k8wIT9g90MJAfR6ZP6BUvPY/kuVj3NxlGiKTk/870yQIfUAQXKv3Obhjm3Dq17XTdH+f2rTUhooYQqD3S3YTmIWA63VN2uHt3Z8+Nz+U7NYIwkuwMmGqx5dzxDlwRcSeUOkRUbNuPuBpvk2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751465408; c=relaxed/simple;
	bh=UUBdzAZ3c9ouEkqzG/IpqaN+2UX9mqsjR40U3uwz+0o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cDedVj/VsFNiL2ihBMdpmkhx0BEfT7BpC6u2IosuxBlIqEzD5MvIGKLXseEiIEbKB9R2LTxtaZoloAWHdupPtlqAc+UFjyj5etKv5TYKOhiVwx2E3gKVOXnfpKxZwvOzEH+tHLHmj3/Ieh/D7nsp6hWiNFSTadvYFnN5mseK0V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XId41UTg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751465406;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=TgZwYQY/6//7Y1IiL72sIvHhk7c1rsqVRlKePVxyg/g=;
	b=XId41UTgFG2m8aM2hiqC98De0w8e7iaGitmLuKdhhI5xeJifYi7cgG3jv8+KJAH5rDMnSh
	7zkhIynV0xYrcAe4DTgpQ/M8y5cgdxWM8n9VxO7QsFaWZNUqSnaR9QarnJF3642c/hSruG
	5bCEadorrkK0oWtTlOQ3R9GzT59I090=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-62-l-pV9WK9N8S5t-dkyRNTFw-1; Wed, 02 Jul 2025 10:10:05 -0400
X-MC-Unique: l-pV9WK9N8S5t-dkyRNTFw-1
X-Mimecast-MFC-AGG-ID: l-pV9WK9N8S5t-dkyRNTFw_1751465404
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3a4eb6fcd88so3385884f8f.1
        for <kvm@vger.kernel.org>; Wed, 02 Jul 2025 07:10:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751465404; x=1752070204;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TgZwYQY/6//7Y1IiL72sIvHhk7c1rsqVRlKePVxyg/g=;
        b=OneeDSqwPS/3wExThUBN03Cl1oCk7kwqMtHjzoOn8wjUTelpYr1kR/oix+n4Zy4lKQ
         +Xrt0REwIipnTyO5Fg1XF4u2zzk54S4wBWAri/zbCf+pWMwCKcG6DR+6un8KyiV1fE0R
         93Qwhfsn/ay3GkY3b0N6sWwLHbz8fzRHu3YYnmUpRuAQIUbv7ES+Glcf3gU1EeCFdKan
         AZquBITwlSBAO1hChojkWPUmNkG0BjnmNh7LP0TgL5V8bUr+s3pokhXKNNUjzfr1QExh
         ZV1n1WZJOC2sheq5xFpXlHnt99KPo259HVENvAgwZUx8oFISntHwtZs2lddhB2bKZkBH
         5uSQ==
X-Forwarded-Encrypted: i=1; AJvYcCUIVe2uAvf1nKwn7XSJb5WR9xFbsMPlhfwpcKToXCcs9YGKFbJCgg3ePoDKpsyzOaqmgmM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzu/dzDUmkdBJnAWSPaEsd1J77LpyxPkBs2eTcsFRY52S1/xwQq
	4ZrS5fJPJPLYbLYhB4bXaJS/61UHQ19l/jknu8aZsQwF+5/fOZibxTk33vAVP+M6RVxgJ7nS7uF
	e/L5tas59WrhDjaCgbwv64fXBgC/thJIW0zCd8oW8gsAxULORk0zhRA==
X-Gm-Gg: ASbGncvcqNQ4GdEGLtze1+6NzeGp+GZv6P4yIMCiNGEuMJoJ2yakVSEMN05HXqxaJEV
	DGjJfaiXT9IY1FNGiFGonw63bVw/sC5a9clonR4tmqb/yct+JykNySRoWGLN6Sbw0r0r1oxp2N0
	YGDMP6spJLTVERr2p7pw/ny3e5S84QGztIvF61XySO/Xh9IFQBw+prcYcc/vZqcRHWx8HsJDetu
	X0bsW/JhNHKNoVsUQGBGEKa9R3L3Y05Zxh4040nYtsZ6fqX7u52Tj5Mig+wKKdC/QZoEYUOF6Jq
	e/A1gpxK6rG16ZBhghsndgvQ2xMtAjxfOHCeE+DlvnglyDnmFrUCZykvrziXiA==
X-Received: by 2002:a05:6000:18a5:b0:3a3:5f36:33ee with SMTP id ffacd0b85a97d-3b20048e6acmr2349178f8f.32.1751465402221;
        Wed, 02 Jul 2025 07:10:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHTHkYd/ujfN4fgDDxoyAu+QvDaaEzPHy6fqG+fLvYE5NiiLRk5DOmUub4YoMfZz682a8//Nw==
X-Received: by 2002:a05:6000:18a5:b0:3a3:5f36:33ee with SMTP id ffacd0b85a97d-3b20048e6acmr2349116f8f.32.1751465401643;
        Wed, 02 Jul 2025 07:10:01 -0700 (PDT)
Received: from [192.168.0.6] (ltea-047-064-114-041.pools.arcor-ip.net. [47.64.114.41])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-453823c57d7sm240986715e9.40.2025.07.02.07.10.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Jul 2025 07:10:01 -0700 (PDT)
Message-ID: <627b4dd5-b08c-41b4-a3cb-99d522fc2063@redhat.com>
Date: Wed, 2 Jul 2025 16:09:59 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 2/2] scripts: Add 'test_args' test
 definition parameter
To: Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
 andrew.jones@linux.dev, lvivier@redhat.com, frankja@linux.ibm.com,
 imbrenda@linux.ibm.com, nrb@linux.ibm.com, pbonzini@redhat.com,
 eric.auger@redhat.com, kvmarm@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
 david@redhat.com, linux-s390@vger.kernel.org
Cc: Shaoqin Huang <shahuang@redhat.com>
References: <20250625154354.27015-1-alexandru.elisei@arm.com>
 <20250625154354.27015-3-alexandru.elisei@arm.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20250625154354.27015-3-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 25/06/2025 17.43, Alexandru Elisei wrote:
> kvm-unit-tests, on arm and arm64, is getting ready to support running all
> the test automatically under kvmtool. Even though kvmtool has a different
> syntax for configuring and running a virtual machine, kvmtool and qemu have
> in common the test arguments that are passed to the main() function.
> 
> Add a new test definition parameter, 'test_args', that contains only the
> VMM-independent arguments that are passed to the main() function, with the
> intention for the parameter to be used by both qemu and kvmtool, when
> support for kvmtool is added.
> 
> Suggested-by: Andrew Jones <andrew.jones@linux.dev>
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
> Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>   arm/unittests.cfg     | 94 ++++++++++++++++++++++++++-----------------
>   docs/unittests.txt    | 17 ++++++--
>   powerpc/unittests.cfg | 19 +++++----
>   riscv/unittests.cfg   |  2 +-
>   s390x/unittests.cfg   | 13 +++---
>   scripts/common.bash   |  8 +++-
>   scripts/runtime.bash  | 18 ++++++---
>   x86/unittests.cfg     | 92 ++++++++++++++++++++++++++----------------
>   8 files changed, 164 insertions(+), 99 deletions(-)

FWIW,
Acked-by: Thomas Huth <thuth@redhat.com>


