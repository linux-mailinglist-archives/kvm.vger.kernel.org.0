Return-Path: <kvm+bounces-59371-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 051E3BB1C38
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 23:06:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5B24719206C9
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 21:07:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70BA7312822;
	Wed,  1 Oct 2025 21:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yKwuyWt/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9894B311C27
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 21:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759352650; cv=none; b=EwwskMQJj7EbSiYbJbqpcmdK6kbTbpcz5rFR0qpuMagrBqh4RGeA9r6txAlagIVYfEPMd7irn3suXCV0fix+sqK4QIblZ+GX+5qFg/kxYQfBl4X84ASojaDf1kdTPTESzemJ9aKv+bZied3NKh+zRcZ33VtlMXTOUsqZT4TdvHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759352650; c=relaxed/simple;
	bh=0NNPh6nN+DvOBnHOxRGWsfvGhR3YhcnkCwFxoDQBtOY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kM5T1kwRZT89sD01wTzUymNXOfSl5sGOcgWMHkmwKP2Ng23Bc6y7cUuJ1Ob2TGR3/gveNk7+8ec0PV0K7VbLmdZyq5Ou2vSzwQn37hzVbgPla6Jkb8WPHmj295bSE2u+vDgNPYZT7OYjFoatKNCsOJUDZx1mphkjxw8a42DoXAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=yKwuyWt/; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-77f5d497692so574694b3a.1
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 14:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759352647; x=1759957447; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W9XFCxpFTs5n3pKyc3+ovsnuFiQyiP+5TOIkYE21+Yk=;
        b=yKwuyWt/V0oZdqCfnX2szpikkCOeoWT6O2PgaiXr5jHPCPovfqYEwfPtIhqB3PQvaG
         YxxYvoKZURs5mHUgQDiiSH2kyKUhgqzfTrTPDP78NJrTWg2K4emfql9FBU/GLE5IWoiL
         5y+kkk4tEWg3upRH+iAS6aCDn5a7OTbnqu2Q3MH+x6tp2vzM0LW6K12085WZ/ffGVFjc
         BeFjFuXlBf1riBv1hHno0brAOQgIkfVqm+tZgxoIj7mWSmZBVkvjiqES5/N6pQvNCqUX
         Atgpt9S26silAySCsS6DHNeAAXnb6lvifxhK47kqv2MZm8LRwG5iVX65X0ACXQlR3ug4
         +emw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759352647; x=1759957447;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W9XFCxpFTs5n3pKyc3+ovsnuFiQyiP+5TOIkYE21+Yk=;
        b=ioCLP31Jt2XibmOuZFyQC9nSmX9jY7LXxxafWv+G5ScSN9ATCvHiFPxtlVgKFQslvf
         00nVbal5FiQX5Zw3r+lstuN2U91LC85OLamS/jDWp6ocfTGnSw7CzhT/McoDpn3mbtsr
         G1Dj2Fu59q0PHCtrLw42byZ2cr9Je8q6E7SNmWmdaeNetzsEN2oyP7rYff5fVAoZKvxh
         a8/r2PqRNhictPqeOzEZDbelnZWpm8eM9aEMTKcSJN4ZvRunCTco9zyBIEYWU2xqrz87
         7xu99LoXprxSiZue2A+P4mHLGN+5sBXDoipeNiR4e2y5P21mELonr7wqLOEaYg3Fsw3X
         4xnw==
X-Forwarded-Encrypted: i=1; AJvYcCWfO8AJCSFxMWD2X5V1NrhuL1cdgXwYo6ONt4Ev+dGjZ6xvmIslvCFtwGbU88HjRKXwD50=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywm3oMRrbR1Sk3HnrTXfAeO/Wtq8lrfYKDxmqi5sZMPay44ZvGI
	28VX/1XRxwjFSgw0TJ8GQIlVfccbYdkaQUe7XtAlUaSszCCOsEcysZA1EKjAric+oK8u7MRuvdM
	9e+twuVY=
X-Gm-Gg: ASbGncvhzL5SZ9nhZ0DTwShWDY+wkEhrmC6Ch/eaIxz/M93NC6eVN0haFfvp/8j0YQM
	97GpFLj/vEKF7Rr4NObSkAWI8JBIjZI3RKMQ9Yft8g4FxEoqoGhThaWg5y+4N6A2/ZaUyAWcms3
	qewT9nEAfgGPIvDrgp+Ry+BeTqxqyNMJiwHICk1Sl5uDryRIpiCcxPf5cYXKB+sW1VTcrg8WRVm
	c2Y6iH5QMMEEbYewNf+zoJP2wArjlb2pg2F0e2nGnaYdzJaCT0nd1adkRmls5IjskXbbhSVf8ad
	BcgMOsVyh2O8nBhkYFnJNYNqCiVnZxTthDp2HsM9dPzSzt2XrO3/GFGXJz5UrCKuCmU3BU2xpoY
	d52Hg1pPJKjgRD0Edxe41ws6HvvVPt0Ri8p7/eKtHMus1Haf0nA0MLVS5th6is+1isAE5uVQ=
X-Google-Smtp-Source: AGHT+IFZi9hBFX4bMDuQM4hhXPrcVQWZ09HiVl5GCehsB3MjmubtNU4WWWEcHQzhy9ryEbc5P1Q8dA==
X-Received: by 2002:aa7:8893:0:b0:77f:3db0:630f with SMTP id d2e1a72fcca58-78af425d26dmr5363134b3a.28.1759352646769;
        Wed, 01 Oct 2025 14:04:06 -0700 (PDT)
Received: from [192.168.0.4] ([71.212.157.132])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-78b01f9cd56sm594019b3a.2.2025.10.01.14.04.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Oct 2025 14:04:06 -0700 (PDT)
Message-ID: <c37880dc-1d27-4213-aa31-19068b437a98@linaro.org>
Date: Wed, 1 Oct 2025 14:04:04 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/6] system/ramblock: Move ram_block_discard_*_range()
 declarations
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 Peter Xu <peterx@redhat.com>,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Fabiano Rosas <farosas@suse.de>,
 David Hildenbrand <david@redhat.com>
References: <20251001164456.3230-1-philmd@linaro.org>
 <20251001164456.3230-4-philmd@linaro.org>
From: Richard Henderson <richard.henderson@linaro.org>
Content-Language: en-US
In-Reply-To: <20251001164456.3230-4-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/1/25 09:44, Philippe Mathieu-Daudé wrote:
> Keep RAM blocks API in the same header: "system/ramblock.h".
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   include/exec/cpu-common.h                 | 3 ---
>   include/system/ramblock.h                 | 4 ++++
>   accel/kvm/kvm-all.c                       | 1 +
>   hw/hyperv/hv-balloon-our_range_memslots.c | 1 +
>   hw/virtio/virtio-balloon.c                | 1 +
>   hw/virtio/virtio-mem.c                    | 1 +
>   6 files changed, 8 insertions(+), 3 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

