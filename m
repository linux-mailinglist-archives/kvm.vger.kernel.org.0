Return-Path: <kvm+bounces-35134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 925DBA09EAD
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 00:25:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B0F23A99B1
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 23:24:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA480221DB4;
	Fri, 10 Jan 2025 23:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="lUpNRonY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838F224B24E
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 23:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736551495; cv=none; b=d+cUVIhighH/L8o2F/P5+3kyLTcgfO3RzFNG6+RHEvDzqKQ4bYAWUEmUyaEHgzujOSnT71AqoUGJptyQ5nuDcg2rCIAIGkAMWzn+FgFiNS219Wu7lMN1Ytbdm0esOz38a3SDZP6j1WFkowJbddXFr0Q3fwwC/sfeHps0h7KTWtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736551495; c=relaxed/simple;
	bh=qAr81ET+iQtu1o7iYsFa/Szv4BtauC/GZicqabQa9GY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=OtWX94wsUgqCRKtlcT9WrYBzdrGIGRpxtWWdP1w2P33vz+kwBHLbO32qs0HW3/3cVD4Lf0ly/usvtaS86Wqkf3dVd+o+BM8Qv9FyqzbIE/ZQoP4M/0BdCPA+ypUS3QwUB12tG/+WuKfGD5gPx7lqGg4yXnFL1IPBPS7JU7Bib0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=lUpNRonY; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-844e161a8b4so86037039f.0
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 15:24:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1736551491; x=1737156291; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:cc:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+SjCp51VyP6GzGq5teBicdgUcduwA5OqOX8nMmSrGMM=;
        b=lUpNRonY0bmhdRv/aq5XLZQo0pRITjXQevsfcJErwqj+K/FJvxUQ5hiSnIYUA4k7gA
         9krUWix/gqo5RytvtON7NS764QX17Ji5ZTcmylk4HEsC9Uy7/e+5aaKFw9hEg2ZDCJC+
         /fYi8on4wCEP6wUuw8mJ7v5u9K7rrmh0kgA5LMOC2jXNoSvhmCcwsl5bpiMy4se/Lkm0
         jAZuHXzuVKytL2g4K5tpqNXedOWLtshUEwRvHZXf0RM+JqgKehp3SjKRPVIUPempHChQ
         bsAoIaIxgThfQY191NNQ48Y8tQ2l1ZyX9MKtL5s2z3Q+oYnuVOiEAiwRDRWxEDZCjbhW
         08hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736551491; x=1737156291;
        h=content-transfer-encoding:in-reply-to:cc:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+SjCp51VyP6GzGq5teBicdgUcduwA5OqOX8nMmSrGMM=;
        b=aJ1zrFrfD/mOXGVsKG6a/pxSU27oMKogBe4WZqcjJKA33VVcj798LNf0KS477x0TNG
         w0celTBWJltIMH+kt9dHg1juwppsRAN7d4obergflWUzgQVNAowwgUJfDDMy8c5qmKsV
         naqgeIzN+hqP3Py/m06ZVNtNUAGXhwZ7fx0NQpwpUmOuWwsXrzA52hQuGJSjo/xBa8+l
         G0dR5GxEx22zio0FMisDbztmIFClBXJiRORxmuWPIPuNI8BpkoYW8EmgJ3Kv6N4zM/EZ
         a/ndfFRTtKMKeWzWol1pGCslcrsjE6Fx4EwE4LzCIJILK5gEaD6sHb6F3egsMYGnjd3p
         31LA==
X-Forwarded-Encrypted: i=1; AJvYcCU1GexKX7w/Mj6hzF4Sgi2X2awNKQGZqDf9+tqWgk0OE3VQiN1b+gC9Y4rKodEoy73gZ0o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2ido+ASFPXNWD1jKmRw0t6us0zbgnH2UpMr01bTbV055nHOl/
	aF4O0lOleMKc2SdCm5S62lY62pyMqn8RbV/r4t0EDLykrppKotDY/1l9Kzrvdf171wa8+42xlrm
	m
X-Gm-Gg: ASbGnct1jjQwuCUNJEepvITvOoZRGIYlqG8Q2ed0+2vR4iXdr3HsQyHZH+eVRgPe9Im
	xeQ/tRrl8mNfmqZOSTa+KfrLzWr+OCztzUMM++73xabJv+mC8tUipePfLvK5VGMShPCDSfNxQ5Z
	ZzNL7e4EEKVta4o2zwSzYMc7MuWNfFwb+b9E66QVXBGU6QvDDKyxWUtV9deyCx6gXYAMAyw5/E9
	lph0cLiKxhn3+ZLuAUNZbvEwET23shCsF2MH1xvCc+j+9YC6lhp7Z3gB++ouPAdUS6T4NmnpupW
	vAD7
X-Google-Smtp-Source: AGHT+IFnLUyPrnYBBe92X4rwhtK25h1zVqhYbmHNT0fZHuKmBld5PyaTYcos/pwpc7H1OLYSIEgaZw==
X-Received: by 2002:a05:6602:36c8:b0:84c:b404:f21f with SMTP id ca18e2360f4ac-84ce018d1a7mr1065030139f.13.1736551491667;
        Fri, 10 Jan 2025 15:24:51 -0800 (PST)
Received: from [100.64.0.1] ([165.188.116.9])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea1b718a36sm1132519173.108.2025.01.10.15.24.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jan 2025 15:24:51 -0800 (PST)
Message-ID: <69426339-fb89-49d8-b23c-764f953428be@sifive.com>
Date: Fri, 10 Jan 2025 17:24:49 -0600
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] riscv: add Firmware Feature (FWFT) SBI extensions
 definitions
To: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
References: <20250106154847.1100344-1-cleger@rivosinc.com>
 <20250106154847.1100344-2-cleger@rivosinc.com>
Content-Language: en-US
From: Samuel Holland <samuel.holland@sifive.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Anup Patel <anup@brainfault.org>,
 Atish Patra <atishp@atishpatra.org>, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org
In-Reply-To: <20250106154847.1100344-2-cleger@rivosinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2025-01-06 9:48 AM, Clément Léger wrote:
> The Firmware Features extension (FWFT) was added as part of the SBI 3.0
> specification. Add SBI definitions to use this extension.
> 
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> ---
>  arch/riscv/include/asm/sbi.h | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)

Reviewed-by: Samuel Holland <samuel.holland@sifive.com>
Tested-by: Samuel Holland <samuel.holland@sifive.com>


