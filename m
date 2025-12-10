Return-Path: <kvm+bounces-65660-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DC52CB374E
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 17:22:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6288D301874A
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 16:21:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DAD83246F1;
	Wed, 10 Dec 2025 16:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OZxF5Rqw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B63B2D877E
	for <kvm@vger.kernel.org>; Wed, 10 Dec 2025 16:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765383340; cv=none; b=Q5w9TuUVYqKKZ4EMkAeYxACOgOZgDGt5k59zbcKs6itLxJDGj3HRMTMyMyVnjR1P4zaBzU6oO3weL3RDwxZ5HbFKisva7BTnYr+A3Poy1vNsj/RRRGzPodSbZ5jYBmOVsHb5+YqZTf3jAY2OWnl/WDlSEUGpet774qyuSuJn3T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765383340; c=relaxed/simple;
	bh=TilihsIKCbWSgki61h3SD0miFyFrYgbwB78+aV3dNmc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XyEHrY94w7sYOJiZlcdAvgcWo175CcjqTVYxZT0E3vE3s0zi64BKPO/MAMJRrtYqCwJ4qZQ3d7QCtb0yUUXW7IhLBZ/CsMLeXzwC5drjbK2Cnn27SEOs1Z3x54TgYCVMAoaQZPC520x1X4jkAgsQ7EYt5huqeQQOkiY0ZKm1ihs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OZxF5Rqw; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b7277324204so1283601166b.0
        for <kvm@vger.kernel.org>; Wed, 10 Dec 2025 08:15:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765383336; x=1765988136; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ZIHb9Cdp71lSCzBIrfPV/k+FGCA9AVwTxQelmzuj13A=;
        b=OZxF5RqwRW1SjwjY3ENlm6A3L63A7UXjLNxv5mkKRsM5F9OylvNtH9jHPUDZijiX3K
         cuFLaWJQm6Bt1TQXPiISYmmp/avyZdP8QkLmYtWWC7zRgXOQcswT7TmfRaEWtlkzfTBE
         W7lTVe0+3nDHx/u2j2RgqozDff5Mq/VW7aQT98Hrfk0F9hYDR8of5FGASohqMjLeQQVh
         PQJaJ2yhLRLI6xXT/SuiyrHtd2eAEUmvXQBPAPIK7hRd4WsQ4RmYz2FxKCE3yTXlXf4s
         573Hc1O5ZEwO7mOlffNjb0kZr0Z1tptAvjXb5mqWktLoSLCtiBzyv2oWl/hz8izf5N9T
         f2fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765383336; x=1765988136;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZIHb9Cdp71lSCzBIrfPV/k+FGCA9AVwTxQelmzuj13A=;
        b=jQ5NeUdQ2eKL0+MZxD4WWurpD1Mimxmqg0o6+M0H8jEB4SwllVJ+qu0Cn2kZEQ887r
         psTAoUOfeylQDWph6Ndmc1U2y7yo8tLktGZ+N58qYuaP31Fo/UoOAPzdotkMnL6I2FW3
         IVBpmlBokArBfuASN2Xoxz5PYSMmNScBqdGD5EkFxzwDArmWN17eMgCeLUy8+r4Y4a2e
         zH3epTYCMn2HtsXhpU7URJLbLcy9ob9g13W25WwN2JkkG1qAA8uzzRV8F+4Q+H4SGPHX
         p1smWxlXEkUlL0mxboJxpDdrnCI+wjT3SXdp20Rr0YXE/eMJOVDjnAXQWdr8kbl/+v/H
         +wMg==
X-Forwarded-Encrypted: i=1; AJvYcCUg4NYYB/5rkSJbl1MN9HjPE14ZEqp8y9JmSnYI9gHvMuLz57OERgBReJcTTKvNn2rewPc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLEknfA5uOMaFsZyW/kavzJjS5AauKQhcaUgVHFd0XEqdBPffD
	WflWAPJkzoC+AyUQZrHdFC9LBN4kmm/2bxYG/gyFSqabXgcjqrF2s5L6d2tuDqJOrp0=
X-Gm-Gg: AY/fxX7iKezKXf4f1lCUKQtaz5BBM1b/FXoFn5no+/UVSQ01LYC4i2mY2DtFrH/PdSg
	FT+XFxJvawkTFSORWvewwaK3h2xt7GXWYQoy1DBYIRtjEseANuKXlJUuGENdLNKlDLyumwGQNRR
	76vYht9/0A8Mjftfph0CJr+JHRSZrJrXWmd7G6Dm1hR+T8Fq/6qWn3FPIhZOQa+Q3OkNdEerNEZ
	HO7ju12agZfKNd9OX7y4RnK7agijWdP68SNLfiLiIgbaEXFHZIEpRgZGrtnb3uAwDq2Q+O3YMf5
	P9ogdlVds7d3heYJqANsJR6O98y7l02l+2c/sD3qbHbEREGQJrMytTjKeDTVMTXKdfyIO+35lyU
	KXnEmUd0S3wNLo6Ssa7zrATSnhoYpfli9wHNpzK/sl9D+e8latdisbhuKNN/IVCYnzEK1VwFUbR
	vyeLpRwly1SykJq49KpcaXxope
X-Google-Smtp-Source: AGHT+IGgpzONJnLtHsFNpViE0NYJfj4mbiX1WYPUdoxI85UFoY1QQK7NayeTmZnvHEjwPtFQFND3ig==
X-Received: by 2002:a17:906:b84e:b0:b79:ff8c:d9a6 with SMTP id a640c23a62f3a-b7ce84d62b7mr223609366b.33.1765383336404;
        Wed, 10 Dec 2025 08:15:36 -0800 (PST)
Received: from [192.168.0.20] ([212.21.133.30])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b79f4977ecdsm1762608866b.41.2025.12.10.08.15.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Dec 2025 08:15:36 -0800 (PST)
Message-ID: <70e467b9-0e28-48e9-91a3-f5a85d3f7c1d@suse.com>
Date: Wed, 10 Dec 2025 18:15:34 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 4/9] x86/vmscape: Move mitigation selection to a
 switch()
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org,
 David Kaplan <david.kaplan@amd.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Josh Poimboeuf <jpoimboe@kernel.org>, Sean Christopherson
 <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Asit Mallick <asit.k.mallick@intel.com>, Tao Zhang <tao1.zhang@intel.com>
References: <20251201-vmscape-bhb-v6-0-d610dd515714@linux.intel.com>
 <20251201-vmscape-bhb-v6-4-d610dd515714@linux.intel.com>
Content-Language: en-US
From: Nikolay Borisov <nik.borisov@suse.com>
Autocrypt: addr=nik.borisov@suse.com; keydata=
 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
In-Reply-To: <20251201-vmscape-bhb-v6-4-d610dd515714@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2.12.25 г. 8:19 ч., Pawan Gupta wrote:
> This ensures that all mitigation modes are explicitly handled, while
> keeping the mitigation selection for each mode together. This also prepares
> for adding BHB-clearing mitigation mode for VMSCAPE.
> 
> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>

