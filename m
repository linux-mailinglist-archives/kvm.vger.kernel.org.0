Return-Path: <kvm+bounces-41178-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B9A7A645AE
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 09:35:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C44D218894B0
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 08:35:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8364021E091;
	Mon, 17 Mar 2025 08:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f6XHa0oQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB3B219A9E
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 08:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742200496; cv=none; b=J2OgiLGBmmvrswb7FDYx37FCDgJ8Mdz/0SdmQq1ye3KSWWYpWDzIQ/p8EMOWRODlM7yAsKIGeeawtQd6Hjw1O/9K/ThMyUsVzXXBSORw4+coUSKl2J8bsrnwUoF1ym5vz6hFzjfg+tktmH/x7BLPMDBPxJwCn1Oi1PQKOjkIftY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742200496; c=relaxed/simple;
	bh=8JgS+u2cAzs4Co0pwnNJuP6j1MhdRfZk5OsrHuRYFt8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TY+sKcD63+ttUI6lyXY9j8Ons1NwfN+ns+37K0liHQisFl7Ysx+IUbPwNHtfPrVGRVQZiaOW73nimRbZTVHhTfF2cDtFuILN39dPgJgRn6aELxNIm04/9VhRUlsBoz3HRQkryUqWP1xGs1sRDWk5jX1tr0ripFzSlmFvRZcXipM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f6XHa0oQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742200493;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/Nm+DfMNs1ddAyATqlb7pZj2Xsa+iVIwiCGiBBFTXtU=;
	b=f6XHa0oQD2YV8gVg1TNLmRUKX36C/gQzD579lndRRECdAkw4OJFyPVd06iuYkgbV4vA2FZ
	mQHkvRYku2k/8oYpR6UuIWMVj4faZbr249giGmH5qRTzYLvcMNpMbXaO7v2N9qAkKy+918
	o/T2sACn8oX2adGr5NxzbltOPxvkiwg=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-575-GLjFydlqPoCytkywKi6GVA-1; Mon, 17 Mar 2025 04:34:51 -0400
X-MC-Unique: GLjFydlqPoCytkywKi6GVA-1
X-Mimecast-MFC-AGG-ID: GLjFydlqPoCytkywKi6GVA_1742200491
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-85b3a62e3e5so802046439f.1
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 01:34:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742200491; x=1742805291;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/Nm+DfMNs1ddAyATqlb7pZj2Xsa+iVIwiCGiBBFTXtU=;
        b=ewTcaQ6MBXYtUnkiqSij5FKd2w8ma8QWxk2m8A6zJggR8S3x7m3O8teHYaps44VmNE
         GlQcwcV79ewzTiRwoZVoVKML+NXbU+mroL4uzLr6+YCzyXzto57DVyVqidijnEMI5yAf
         1YPbY3Ao8wTiPaGXjQHwfNgV4JW3jNRbb+4cis/ZCAZxfiyLuEG69StlZiI+l19A1At4
         41qyVBfCaqFq/UlbvmbB/mCXbPnbzp55MR1Z5vKob2tD5yLbYSYGJZBBugxli+briW+9
         32pZET9fsPAhdvEHevUdt/tp9hzkDXYr/2fkXhU2m77xovUmJXpbYQTKav9Nr61Y+EM5
         Ap3g==
X-Forwarded-Encrypted: i=1; AJvYcCW0KmQTPc/bxnFh4ldmKnRknfLZihe7Nn9kw/9Do30RagKeDYIi8Ndt1DC7Tp3xZDvJR4g=@vger.kernel.org
X-Gm-Message-State: AOJu0YzIpzj5MSz/UDVcXq5qIj7bYuJsSBB3WKbk/VtdOWx7gPu2SR+W
	NT61d8/iVfn4QL1Ts9kbItwRXDl8exhAd86mmU1urWG7FM/f3G151DPOp/gLJg5JcrxZq/S1xHX
	bc9+nAvgk4xI9Fye7VjunUtUZbqTEQOPZtOGZWvipnme268oufg==
X-Gm-Gg: ASbGncvYMm4xVsNyh7Vifjnw5naaYbKf/2/wsWJ1tdKyZUeB1r4RGAs1pbRgruWjL5j
	FnJP8q51BTGtRXkp+FJI2FG01nyaZCUysweDcYt8mvWRZ3zTOePv9AaMkkiVgscQg9jcuYgedVW
	MGlM7Ef53RHOR17gvxkBW32PAWPjUGwqNd994wZHcJSX5JPhjEXAOPhEFpeoV2WLQjxykvLc3Ne
	Ia1vELdzjJRAoXMp2RNhQBmM3br7/ujRvs9ZAc1I82Ku2HDAqw1GNGfbYN6Hc7rrX9x3tj0BzU7
	N4cl7GnVIssotKkKuXO9peWYG3F0dNMWvlKkwo/1995K6fK8yE4HIL/dBds2vU4=
X-Received: by 2002:a05:6e02:1a26:b0:3d4:3556:741 with SMTP id e9e14a558f8ab-3d483a636e0mr118980595ab.17.1742200491120;
        Mon, 17 Mar 2025 01:34:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGXeeNMofiOfDClXrxvr5QBbj3fKlOQKb5SMWlRsPSseOxhMX7fmpLthdjxkcqMtcHa1MAfRA==
X-Received: by 2002:a05:6e02:1a26:b0:3d4:3556:741 with SMTP id e9e14a558f8ab-3d483a636e0mr118980485ab.17.1742200490827;
        Mon, 17 Mar 2025 01:34:50 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d47a83817dsm25926785ab.61.2025.03.17.01.34.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Mar 2025 01:34:49 -0700 (PDT)
Message-ID: <eedd9e34-7c9a-4379-818e-3420cc8177d0@redhat.com>
Date: Mon, 17 Mar 2025 09:34:46 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 3/5] arm64: Implement the ./configure
 --processor option
Content-Language: en-US
To: Jean-Philippe Brucker <jean-philippe@linaro.org>, andrew.jones@linux.dev,
 alexandru.elisei@arm.com
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, vladimir.murzin@arm.com
References: <20250314154904.3946484-2-jean-philippe@linaro.org>
 <20250314154904.3946484-5-jean-philippe@linaro.org>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250314154904.3946484-5-jean-philippe@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit




On 3/14/25 4:49 PM, Jean-Philippe Brucker wrote:
> From: Alexandru Elisei <alexandru.elisei@arm.com>
>
> The help text for the ./configure --processor option says:
>
>     --processor=PROCESSOR  processor to compile for (cortex-a57)
>
> but, unlike arm, the build system does not pass a -mcpu argument to the
> compiler. Fix it, and bring arm64 at parity with arm.
>
> Note that this introduces a regression, which is also present on arm: if
> the --processor argument is something that the compiler doesn't understand,
> but qemu does (like 'max'), then compilation fails. This will be fixed in a
> following patch; another fix is to specify a CPU model that gcc implements
> by using --cflags=-mcpu=<cpu>.
>
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  arm/Makefile.arm    | 1 -
>  arm/Makefile.common | 1 +
>  2 files changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arm/Makefile.arm b/arm/Makefile.arm
> index 7fd39f3a..d6250b7f 100644
> --- a/arm/Makefile.arm
> +++ b/arm/Makefile.arm
> @@ -12,7 +12,6 @@ $(error Cannot build arm32 tests as EFI apps)
>  endif
>  
>  CFLAGS += $(machine)
> -CFLAGS += -mcpu=$(PROCESSOR)
>  CFLAGS += -mno-unaligned-access
>  
>  ifeq ($(TARGET),qemu)
> diff --git a/arm/Makefile.common b/arm/Makefile.common
> index f828dbe0..a5d97bcf 100644
> --- a/arm/Makefile.common
> +++ b/arm/Makefile.common
> @@ -25,6 +25,7 @@ AUXFLAGS ?= 0x0
>  # stack.o relies on frame pointers.
>  KEEP_FRAME_POINTER := y
>  
> +CFLAGS += -mcpu=$(PROCESSOR)
>  CFLAGS += -std=gnu99
>  CFLAGS += -ffreestanding
>  CFLAGS += -O2


