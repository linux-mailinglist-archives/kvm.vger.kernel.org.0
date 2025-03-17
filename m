Return-Path: <kvm+bounces-41173-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 88B52A64502
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 09:19:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81A933B1ED3
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 08:19:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1418421CC79;
	Mon, 17 Mar 2025 08:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JwyVRTCX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3267421B9DB
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 08:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742199557; cv=none; b=t2+2ZzNe7dRiZoT6NC1s1Fhhejzk5Z3srFxtQ4B1SlLxGpZh+j2ASv9cR/pb6GgXYoEfP5LWMsNJH1SMxuaXHeMNV21FN86WnnmbcAH9+jyjmzDQqC0oafxV039bOeeXPiWaovqZvPGLbNxgImhSjnuimyBmu6EFj4q6R7p4PrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742199557; c=relaxed/simple;
	bh=qxYH/w/AG28+kJrAB1ECYDC3YrKaGk2Z29z95bv0URc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z1ifAE2PsefORqOc820EzZS9ZUVVbuUvkKo6I8Ugr9fkkaHBXAc9h78DD3EoscBlge/jhGrpl4BL9gBJiy7cAoRTA26CXHfsXVFy1Iz3pG65bLvBkhiXtM515nRSYSYLcQxRqkAxMnJP5/vYbHz3dU4jYSOvcLgOv/q9hq1jn1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JwyVRTCX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742199554;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0nejHxLLnivIrRTuFTd2M1TZx73UJZS8r5WGx9tsowI=;
	b=JwyVRTCXAgF44QJlxxCqSEdykoTOOVceRarNhUr21+spVD6rzNDUs+LSmZ/tH1ZrpTyk37
	B3RBKl3OJnuXcPUZ5Dzf3pDVkfeGKdYW6i8iT27MXSU7OeYc8UvkSBDyq/GB/+iuADfrwW
	Zsb/vywtd+BTgcBNG0d6fY29idhbTzo=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-79-GTj4cxSKMQqp7LFUncCgNQ-1; Mon, 17 Mar 2025 04:19:12 -0400
X-MC-Unique: GTj4cxSKMQqp7LFUncCgNQ-1
X-Mimecast-MFC-AGG-ID: GTj4cxSKMQqp7LFUncCgNQ_1742199551
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3ce843b51c3so118276955ab.0
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 01:19:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742199551; x=1742804351;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0nejHxLLnivIrRTuFTd2M1TZx73UJZS8r5WGx9tsowI=;
        b=TWTitX31MVNyXYNsdmRFjJPtRlFyd504Pdr9yTiObeAdoCV8byvzfDNr4SR1dw8Dro
         Wmb/H7exn28+lL28rAEJ+W9TxZVKqxScUnR7eAAD33yq6ZdYGlDC51NktaaZi0MBBOmn
         +zVnhGMV2WO4B8vbsreVerxkYZDrfzG/Pi67w96nV7cSXVOfj63ftPgyPc5M1VaIIXHY
         uNqglhMkt/r8NBpl9nqJ+CfxJoOa1i/Rln6LD6qO0hRqmUfaikjHcPkUGOeHXA5f3rl8
         AnTEYW7WVXqzu1S69RksSDEZ+HFg02E0mNqya/kLHEvgfzWXu7QLOgx7S4YhBV3Q8lol
         MYIg==
X-Forwarded-Encrypted: i=1; AJvYcCX0XiWPEeMtxc80xPk/RRjzEmjnDPye3YPg/dXxC/O49LYuRITmjhV/d7F1kYnr4YWbTD8=@vger.kernel.org
X-Gm-Message-State: AOJu0YywhwoxvjjL3Gkw48mH+STcTsHsZ/kH1P/RgECx3iiET4NV91pY
	1fp7YNwvn4VewBlzULph+WtKJ/jz8QqS1QaQ0lB8+jneOUmX3c3wDhknq/GwGPv4nO/LO69QVJ+
	fwxcrkUUzSAx/nCYGDe++XdsCkhISve5iC7xd7JlM+/Wzfh849w==
X-Gm-Gg: ASbGncuVEiE5dSAS6TQF9R/nd8LdlhtW0LQJeprRqJghJ5VWqXFJNa3GYzVyXUIcsLz
	ArBX5Z+wfGzmRNACY08zMjodKlPh25b5pYDEbPLStbHEhndWLk1v5zLkrvSNDtXSig8EkLPJZ+K
	5KV8eL6J97CO6uFy9fQZ9sWmS6kJcR2hDnuiSsGA7/dsTjMYpq2O8ScNo+lxSL1wDF4MVWd/2rb
	wWLJNVpEgfMbhB5mi9MKFhpimrg9R9Wwid2YaAhFg5a8lBF3yZSfNKfMZDPCOuQ/n//aDBdkE/E
	zbF5WemffRH4x2XmuUj8vdibiCBNIZu03s68HK97G4C5zI4OYEGj7nV0teeuwoI=
X-Received: by 2002:a05:6e02:214d:b0:3d4:6e2f:b493 with SMTP id e9e14a558f8ab-3d483a1a038mr100733405ab.11.1742199551364;
        Mon, 17 Mar 2025 01:19:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGsEkTjItCn+3c/1exaejxjUCNrW349jWciioJ8unsR3OwQFSF90QFz+g/WpvO1aQ2salG17A==
X-Received: by 2002:a05:6e02:214d:b0:3d4:6e2f:b493 with SMTP id e9e14a558f8ab-3d483a1a038mr100733315ab.11.1742199551067;
        Mon, 17 Mar 2025 01:19:11 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f26372760asm2145612173.67.2025.03.17.01.19.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Mar 2025 01:19:10 -0700 (PDT)
Message-ID: <1b0233dc-b303-4317-a65d-572cc3582b8a@redhat.com>
Date: Mon, 17 Mar 2025 09:19:06 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 1/5] configure: arm64: Don't display
 'aarch64' as the default architecture
Content-Language: en-US
To: Jean-Philippe Brucker <jean-philippe@linaro.org>, andrew.jones@linux.dev,
 alexandru.elisei@arm.com
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, vladimir.murzin@arm.com
References: <20250314154904.3946484-2-jean-philippe@linaro.org>
 <20250314154904.3946484-3-jean-philippe@linaro.org>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250314154904.3946484-3-jean-philippe@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Jean-Philippe,


On 3/14/25 4:49 PM, Jean-Philippe Brucker wrote:
> From: Alexandru Elisei <alexandru.elisei@arm.com>
>
> --arch=aarch64, intentional or not, has been supported since the initial
> arm64 support, commit 39ac3f8494be ("arm64: initial drop"). However,
> "aarch64" does not show up in the list of supported architectures, but
> it's displayed as the default architecture if doing ./configure --help
> on an arm64 machine.
>
> Keep everything consistent and make sure that the default value for
> $arch is "arm64", but still allow --arch=aarch64, in case they are users
there
> that use this configuration for kvm-unit-tests.
>
> The help text for --arch changes from:
>
>    --arch=ARCH            architecture to compile for (aarch64). ARCH can be one of:
>                            arm, arm64, i386, ppc64, riscv32, riscv64, s390x, x86_64
>
> to:
>
>     --arch=ARCH            architecture to compile for (arm64). ARCH can be one of:
>                            arm, arm64, i386, ppc64, riscv32, riscv64, s390x, x86_64
>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  configure | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/configure b/configure
> index 06532a89..dc3413fc 100755
> --- a/configure
> +++ b/configure
> @@ -15,8 +15,9 @@ objdump=objdump
>  readelf=readelf
>  ar=ar
>  addr2line=addr2line
> -arch=$(uname -m | sed -e 's/i.86/i386/;s/arm64/aarch64/;s/arm.*/arm/;s/ppc64.*/ppc64/')
> -host=$arch
> +host=$(uname -m | sed -e 's/i.86/i386/;s/arm64/aarch64/;s/arm.*/arm/;s/ppc64.*/ppc64/')
> +arch=$host
> +[ "$arch" = "aarch64" ] && arch="arm64"
Looks the same it done again below

arch_name=$arch
[ "$arch" = "aarch64" ] && arch="arm64"
[ "$arch_name" = "arm64" ] && arch_name="aarch64" <---
arch_libdir=$arch

maybe we could move all arch settings at the same location so that it
becomes clearer?

Thanks

Eric

>  cross_prefix=
>  endian=""
>  pretty_print_stacks=yes


