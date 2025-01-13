Return-Path: <kvm+bounces-35337-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EAD7A0C520
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 00:07:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 466E13A7D12
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 23:06:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFCB61F8933;
	Mon, 13 Jan 2025 23:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fGN55zD+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586071D47A6
	for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 23:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736809612; cv=none; b=iBIAJkpozLICnrFDcEKiL7x82T+2ubqhAhvTwNP7yG2h2e2Z6yINaoxzXuz3Y7dedVsD5eIqUMxCxMOC5YyG9AYbvtqyDlg7lIRreZktI43rGHkkv5uNJfaMjN2/qIvhSYjZcBHZuTu7q1q1P1Vz5Nf2TENcKrBqNs8nufJQz50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736809612; c=relaxed/simple;
	bh=FY3CAUHnUAGPlAvnTqBwytKqjfIe0H96ZK2+kvt3Gpo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tkFvY+qh31bxC8nQnbrn9pleK3CDiYr276xlPITrDcEDYI1JI6wKYgGnOubIMOdKIUH3adWjAXX9F/ksu7cnuOh2KBEAzC5wBRQkLreOUQHmKqSperVOYOreoWqW+QIkL0jByBgNOEyqNyuYcPaV2U6l8fh31LzCHAyc7lo/IDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fGN55zD+; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-844e6d1283aso190304139f.1
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 15:06:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1736809600; x=1737414400; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=t98L05cLqoN9QlNAdFWwtAB2uSyAKNpsq0R3tlTJnx4=;
        b=fGN55zD+QPKLTIC1ERc58hM9umFVkrs3t9SSVj3jKPYQaee3iswV/0spT0NsKCUget
         JEyaj3elRNTisN9FN7FtU5LE4NLRwVksQ6Iqm7IzCO96TvYeJpyB84YBTzrg3KQtZIFP
         uHobzoMZG9AS9FwjzAsqrxgm2ABSeadHkVotc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736809600; x=1737414400;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t98L05cLqoN9QlNAdFWwtAB2uSyAKNpsq0R3tlTJnx4=;
        b=cpkEX0SfOBvRoU3m3PHlSby+4Y+gp4QMqPcDiJugGqBIdC4lZLa+Kez+YeMVKVchrZ
         PWa0mPbeRlLBE6fZ2Ukwy9eGBGxGNwvgky2tX3ab8IXqmZWFnn/nOiA+c6Ln4bKheDNM
         qJXNbTnpvaYJi6BXFqDoRko/1OsGN/xwyhZhF2nTu4x5RSZk3mcP/vylkBbiRoch+sHd
         lNrHV1TniV3eLikzEtJj5IjHtiLiDsnfGE+FhmknnzkbL1muZTFSGQLAU5FnKKuQmW1C
         JAvKapBJjk97Ru4Y08Vu53QiAtSuYGA6rXyITTVqriMC2zXeuivqxe7QuydSsKjwETEM
         /6Gg==
X-Forwarded-Encrypted: i=1; AJvYcCVZJmoVNvbrbld08OfvagoWBESEMmZphBl/YjDBVdtwzQpvuTbobh5G45t+uiDOVOQ04yY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/3A6mDLmQYSjdomD+XVaOc2ZBie8CFRnOUEmutoe4nwMqHcnL
	4V/iD6H2QfTganDqxq65xIonFDshT7JARN0d4OAVbcgz2ImZR2qzOezkbqZYlmScjTwBqxYLxYH
	6
X-Gm-Gg: ASbGncvs2l8WigyCVZ2W/JGy7pPiAWTxRxK4PU8E+IrVW+w0iBjAD5D/QU77z3uDWVG
	qJhZKxF8YCRt5TyIVfTY8CmjShAx9cv1CBbZsKEX6FP96KmzdC8gCl87FdZP/PdtTMm416UKcan
	dPFfgfOJ2Wt3PovAXlWPq0GlRxEeZG9ePDvnm543++9XTqDpz/GGOZwJMPPOdzniYRCAnISxfWM
	ih5FogP3+9FiM7evgD7uwBAYYj27sTP8Cqu8thzZpP4d3BDWID5InAwJ41nCCToG8c=
X-Google-Smtp-Source: AGHT+IH8D8/WA3nsz270K68ibq75FwpYAmp8r79kGSFWGw5muQ30GDD6Uv2Knph7vskIzmqScVtI3A==
X-Received: by 2002:a05:6e02:1a8f:b0:3cd:c260:9f55 with SMTP id e9e14a558f8ab-3ce47570cd3mr131591595ab.4.1736809600570;
        Mon, 13 Jan 2025 15:06:40 -0800 (PST)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea1b717838sm3014196173.102.2025.01.13.15.06.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jan 2025 15:06:40 -0800 (PST)
Message-ID: <15339541-8912-4a1f-b5ca-26dd825dfb88@linuxfoundation.org>
Date: Mon, 13 Jan 2025 16:06:39 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/rseq: Fix rseq for cases without glibc support
To: Raghavendra Rao Ananta <rananta@google.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, stable@vger.kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241210224435.15206-1-rananta@google.com>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241210224435.15206-1-rananta@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/10/24 15:44, Raghavendra Rao Ananta wrote:
> Currently the rseq constructor, rseq_init(), assumes that glibc always
> has the support for rseq symbols (__rseq_size for instance). However,
> glibc supports rseq from version 2.35 onwards. As a result, for the
> systems that run glibc less than 2.35, the global rseq_size remains
> initialized to -1U. When a thread then tries to register for rseq,
> get_rseq_min_alloc_size() would end up returning -1U, which is
> incorrect. Hence, initialize rseq_size for the cases where glibc doesn't
> have the support for rseq symbols.
> 
> Cc: stable@vger.kernel.org
> Fixes: 73a4f5a704a2 ("selftests/rseq: Fix mm_cid test failure")
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---

Applied to linux_kselftest next for Linux 6.14-rc1 after fixing the
commit if for Fixes tag

thanks,
-- Shuah

