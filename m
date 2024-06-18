Return-Path: <kvm+bounces-19869-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D7D3890D6DE
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 17:15:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8F7351F22B88
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 15:15:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 785B8143898;
	Tue, 18 Jun 2024 15:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XTSKyQpx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD45E22F11
	for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 15:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718723539; cv=none; b=lX8AcO5uF0iBRm7AfViqHPxUzbK6d0mLF19+85iXdNxdQKcHeeJV6CUhrOom5NnBMxIR62AnVLzDdp64MtIRwPeSoojdWZWaWj67w/DaGiDA/2qMjhzL2QkkN+eeAYS8SCiFiKPD2aElmE1VSQNNMikNs1YjoflOCYjND7MkK64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718723539; c=relaxed/simple;
	bh=k6l3TQ4MXgrNxiL1bUyoqnmaoZN0afZoN1L/ohLrSX8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uX3oSUnbTsDAkoMOHLIxWHPK6TSAK6fjnNUINQdqhzhRdM1T6yCY9+CHv9PeKasxfHqbMn3XkiQUuG/oCdZi1wlP0uYihFX6fPXZ4sEth0S2r8ifLv456lTRYCokcMVQTAcpCbZMUqMRd9Y4+g3ecp/b2N+OiyaQsOtPQxbw2EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XTSKyQpx; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4217a96de38so40387145e9.1
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 08:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1718723535; x=1719328335; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zktM13vzE16WFMh5/Cr5Qz12DI4f5rptllhEcUwb5wU=;
        b=XTSKyQpxUBEjWnc/9jcslQnzYjjWMbTYomTFYO+LYcq588cadf6wSFdeS2dA0lCa6d
         VivL3oguQzlS94oYmfS0g9IbpAvXWB7H6lNJRP3zqRyjTplxfWmXI2fM6uQbDmt79w1N
         jffL5L6rC8yO8asJfNktEc+uxv+No38P4EvBzyeN30SSDKtw4jfhOeDoYQ/wW4XCSZbu
         iWAaQtjiihf3wPlaTk/L0A2xHO21c+YAOLnyJA/LHa3kuvlNDFvXIzTwuFFifROrzTOx
         EGq7b6JOVUNsjN8cd+cuHVqDKXd2EcWaSNL0QnC7pX20u+rObjlrEJ6Hp/95Ik2FcI3s
         HyVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718723535; x=1719328335;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zktM13vzE16WFMh5/Cr5Qz12DI4f5rptllhEcUwb5wU=;
        b=L2g/ExMVHmA5xMoCVenbP6rBoYfPfpdIZOvZ/yKDd7ZhPI0Ekm8g6r4cHG1+oXFA/B
         m5CunZhHpwrONN/cdo6+aOoGdxoUvriFZh5WJUZvioBLq3DLsQOLyibqPJRRRAlXU/Vv
         CrjQkF+yQ64Cw8I2GEU8/wAJjgfEjZOKJ92bS/YFOsdXNmLJ5mK9fzKTu8HX76VbYaSi
         fuxYtcLbxa7u85bPOt/Qlqs+hOKAl7jOKf9lvF5bs8AnBqNYsHR7RXL6Q9xDGA0Fg5cr
         K4r1FHLoj/BVwti13PwkOFbWooshzjf+FiJyxPN0kVt3ALS1gzMmuja8qvv7Cez004M9
         /YmQ==
X-Forwarded-Encrypted: i=1; AJvYcCUa46Ks66OR0IhmwICubAnb9YM0/Ij+XYBTo3r+wnKfffTyxzzrwnNA70xY/PS2t/GG9csDEVMgPOq87s/cUwjuoRoo
X-Gm-Message-State: AOJu0YxP1xv3uoQRgny2pVbiJQYhuUrCEpWIwVMJt4byihhBdT7hMvQ7
	BsBrjzra6vr6WMgYW1hPJ97Kudcbv6p01F6MrYlLE2aP0hbJn34YFp5DDnBmEws=
X-Google-Smtp-Source: AGHT+IG96jprIRpe2giPfPgMSPu759yfEY2E+LThuHU3LLVf+jK2d0vhVUkcHLs7aRCIT6x8Cb1v2g==
X-Received: by 2002:a05:600c:4586:b0:421:2711:cde9 with SMTP id 5b1f17b1804b1-42304824f0dmr111067575e9.22.1718723535254;
        Tue, 18 Jun 2024 08:12:15 -0700 (PDT)
Received: from ?IPV6:2a10:bac0:b000:7579:7285:c2ff:fedd:7e3a? ([2a10:bac0:b000:7579:7285:c2ff:fedd:7e3a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4229c60f758sm212680845e9.20.2024.06.18.08.12.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jun 2024 08:12:15 -0700 (PDT)
Message-ID: <8524dec4-be7a-4423-8d02-92cc1bb4bf3c@suse.com>
Date: Tue, 18 Jun 2024 18:12:13 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 9/9] x86/virt/tdx: Don't initialize module that doesn't
 support NO_RBP_MOD feature
To: Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org
Cc: x86@kernel.org, dave.hansen@intel.com, dan.j.williams@intel.com,
 kirill.shutemov@linux.intel.com, rick.p.edgecombe@intel.com,
 peterz@infradead.org, tglx@linutronix.de, bp@alien8.de, mingo@redhat.com,
 hpa@zytor.com, seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
 isaku.yamahata@intel.com, binbin.wu@linux.intel.com
References: <cover.1718538552.git.kai.huang@intel.com>
 <909d809d0a37e51babfe28f88c7fd1fdefa53e88.1718538552.git.kai.huang@intel.com>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
In-Reply-To: <909d809d0a37e51babfe28f88c7fd1fdefa53e88.1718538552.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 16.06.24 г. 15:01 ч., Kai Huang wrote:
> Old TDX modules can clobber RBP in the TDH.VP.ENTER SEAMCALL.  However
> RBP is used as frame pointer in the x86_64 calling convention, and
> clobbering RBP could result in bad things like being unable to unwind
> the stack if any non-maskable exceptions (NMI, #MC etc) happens in that
> gap.
> 
> A new "NO_RBP_MOD" feature was introduced to more recent TDX modules to
> not clobber RBP.  This feature is reported in the TDX_FEATURES0 global
> metadata field via bit 18.
> 
> Don't initialize the TDX module if this feature is not supported [1].
> 
> Link: https://lore.kernel.org/all/c0067319-2653-4cbd-8fee-1ccf21b1e646@suse.com/T/#mef98469c51e2382ead2c537ea189752360bd2bef [1]
> Signed-off-by: Kai Huang <kai.huang@intel.com>

Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>

