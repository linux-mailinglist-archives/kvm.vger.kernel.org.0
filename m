Return-Path: <kvm+bounces-65748-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BAFCACB571C
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 11:07:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6BFB030213F7
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 10:07:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AEAF2FDC4E;
	Thu, 11 Dec 2025 10:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UvSGGtnl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F3B2FD67F
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 10:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765447619; cv=none; b=YLJUJHO9HP4h+4lRWX6KgAenWL02giqnc0ODX08zPJ00tB0wC75PYDkRESuVo3lXJidU2EC4IzFMHnTdMZeBj80SrGm7+m5NlB2CM0qYuZNNBtPuUfWmYRTDlB+FK6DPUhTZqRGBIlGOM+p+UZACIDdDRG4w2F6j1oKp2El/O4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765447619; c=relaxed/simple;
	bh=DtOlpz4lbdR+7MJWd3t6nr4hxlPgEs56kZJXEW76USs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IyIjUToGn5SKxQwuyi6iQzDljKCSQBwTUzN0aTIvOlHh+Fj32wyDiIEuQUMZg9LjxCm0I/FUVUd361Xjl6rHQ9n4Gj68hC15VRTvNJH2ZgbkjyJLfVGc7dyq5FouiFYU7fVpeWc/TP8vE4Yw7/8K4wRCnJlYSRuj7R2DRMdeQt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UvSGGtnl; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-64162c04f90so1588895a12.0
        for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 02:06:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765447614; x=1766052414; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=3/6pRatQqJ0w6vnE88SPDkw5bjFgNIJw3ooe7teRKNg=;
        b=UvSGGtnlHMovPW2SulSVTzZShGKKWLaRMr9wyoGGKLrhg35EL5bhUQ7TFZfehIkflC
         gmKazW53rRJWkXmxIqacqL4f/ZE6xuB08PHHcCBDsvThyrCb/EuWyxgaA6v7zLu9SMty
         TYoglwoAkLSNEeJO2zYfWqQjN/qpI1EZHV7yRwCd7WzS/z/Lm4SQzquFW2eCsmxg4NKU
         MfcZuaq2Xf+grELVxFz9RH4FTnyTNPAEZ7FoaP6kkN8NJZik6n+2NBDGRH1jasEnpEqP
         /N4c1VXEYkfArF0FQa1mE3XTNuXifVyxzKD61nFr21EEAt85q3IsgJzQKTvBhgMUW3+t
         OpNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765447614; x=1766052414;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3/6pRatQqJ0w6vnE88SPDkw5bjFgNIJw3ooe7teRKNg=;
        b=kMvaTyUujXJexRj47H9CyUbcPp1Ck+Kb+vpM3ImfYfWVflECLC50os9c8B5Nd9SAmH
         FABXh9Oen/efZ4bpkU3a6HeKJYyN97w8B2MNQbEjxj0fc6ozQ/TTyEmLJrsQHM6uwTQ9
         1sz/0ablzpz9t/qXfoFxkaeSgVHPfN9uMZw15ZZ8ZXlliaaCmA55YD5OG9Q9ANrUD3qL
         AYgiUMPqN1u+EO/A/hwqsiLbw+Gl/XfAYRcBkY0ishhnQmhP4GaFodiI6Oy/MJQ2BANv
         TrZhP2eo6Km937SYFEezfGGbUTz5DENKpPCPy1lhF2bFz+SH7siqrrf4B0mx+wxAQRyG
         tfJQ==
X-Forwarded-Encrypted: i=1; AJvYcCVvvVOTkUPQRdiOmpzWElBbIKvkhogpSP6qPorN000o2zW0fU/2tXytteUaSiT1xMn/+e0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzoQcdbEhUVZ/GSCH8H12VNvGTi4/nUGos4WHkaXizew/tDPKzX
	y872BgM5uVQ28lGzRFasl7/jTyhE2ruiDX3n2oetKMMu7QAF0+TkUmqKmUxZxPqfa0w=
X-Gm-Gg: AY/fxX6MBTtp85uv9Mk/ykoLNWyKEHq4aThvJssAj8rk5RT5HZqSXKVS01uSIAaqydW
	8nOP3VFc3+m4sxuYiWc9awtZc4y2zi+eGakFJgfqRfBS6l7IGZh0JFStNfJzgob/XCGdxP3yx8d
	ZRzTQZcgckkkQR/5S8mv/C4p4MHyb2Yd4GUtzO5ux6wZGp+jOoL0CUoTNk/d3WMdlgo4ChKvW6G
	QGh9pgLQVlPAeno2Tog26lQXnQk431ZeTZjEt6bryu0sS3GjQus+wvrmL1iX9D82mE3czZosKpL
	fhFhGwWZowWYuC9fpMCyJ3YcQ2T3b862HSkK09jJ2ZqPt6JqhOzt8GLII8UPWVLFLgRWB7xVLZJ
	A2ZGAz0Ax4jC1QpBvkAvc8O+BW1q4vxCBX0ZvFzcIJ9tDOh9jvrpHxc4SAotw6DD44d97XRiZnm
	JZ/w6vDjoBU2tCww==
X-Google-Smtp-Source: AGHT+IEp+HKejFPtSoY9ulAxBwx4JBx4P8oLNfw24nw3WAxkeWvEe1ux7mn4NmddgqPUSiMahNQVew==
X-Received: by 2002:a05:6402:46d0:b0:649:81ed:76e4 with SMTP id 4fb4d7f45d1cf-64981ed7916mr2159875a12.2.1765447614337;
        Thu, 11 Dec 2025 02:06:54 -0800 (PST)
Received: from [192.168.0.20] ([212.21.133.30])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-649820f7851sm2075720a12.22.2025.12.11.02.06.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Dec 2025 02:06:53 -0800 (PST)
Message-ID: <245abc4d-2d38-490b-8844-9866d934bcf4@suse.com>
Date: Thu, 11 Dec 2025 12:06:52 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 6/9] x86/vmscape: Use static_call() for predictor flush
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org,
 David Kaplan <david.kaplan@amd.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Josh Poimboeuf <jpoimboe@kernel.org>, Sean Christopherson
 <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Asit Mallick <asit.k.mallick@intel.com>, Tao Zhang <tao1.zhang@intel.com>
References: <20251201-vmscape-bhb-v6-0-d610dd515714@linux.intel.com>
 <20251201-vmscape-bhb-v6-6-d610dd515714@linux.intel.com>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
Autocrypt: addr=nik.borisov@suse.com; keydata=
 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
In-Reply-To: <20251201-vmscape-bhb-v6-6-d610dd515714@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2.12.25 г. 8:20 ч., Pawan Gupta wrote:
> Adding more mitigation options at exit-to-userspace for VMSCAPE would
> usually require a series of checks to decide which mitigation to use. In
> this case, the mitigation is done by calling a function, which is decided
> at boot. So, adding more feature flags and multiple checks can be avoided
> by using static_call() to the mitigating function.
> 
> Replace the flag-based mitigation selector with a static_call(). This also
> frees the existing X86_FEATURE_IBPB_EXIT_TO_USER.
> 
> Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>

