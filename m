Return-Path: <kvm+bounces-65016-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BF103C986D7
	for <lists+kvm@lfdr.de>; Mon, 01 Dec 2025 18:10:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 881593A4481
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 17:10:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 711303358CD;
	Mon,  1 Dec 2025 17:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Am5nZMOC";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="QTN0QmYl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B05830E0D4
	for <kvm@vger.kernel.org>; Mon,  1 Dec 2025 17:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764609036; cv=none; b=G80OZgfGCBlHJY5TMsY5j6TWTMbRW+ilATvIaRmqtdlUMVxP1q0AFVFBEMjOhNX47+kbvS2cHBEvw2NQ+q/AgbPtsWDYQoyhpbujO1adQDKLlHtcBole/NP7bt1haewueLxH5bBD/LiNiGYptyM7OgrnZOnfIGxdWYWsbzw/Usk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764609036; c=relaxed/simple;
	bh=aW+3JOlwACoGkVOYP7Bk+hIX5AKi4VEVstb6PkUHeHQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mNHJxvuK+pEPcC36xNO4N43f8nucI2MUajFoiqDUz3Y9KNAy26davtK48kv3Tlm9Up0O1rPldae1VFL05DwM5uYQyYfUyJMmM+HJkvVSKu+FHVS9jHSpeD+mhgnTYx2FoFnzYqyYJdXlEyN4bMjiC8TJCG2CbDNugERhSy1A/FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Am5nZMOC; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=QTN0QmYl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764609032;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=049HCOlcqn8l6MRkFi6tMcLlTFYa5Nd38LY4dhJJJtA=;
	b=Am5nZMOCyLS8+DjBk+lwIhTOOiX1b64uSUE++65p8wcX5wJI2vDMhtFSBotLRwPoO5ZyFA
	F80rlIfaOjRZR0aT3bNyt368qP0dQZiwxfxBbotNiO/NVs9vVjBvjvmZr4nsRT4xjpO683
	pwu1PG3HzO6uV3Paqr3IzKUfh/5Aqck=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-418-YMiM0WVQMii56uJeDiE2Ew-1; Mon, 01 Dec 2025 12:10:30 -0500
X-MC-Unique: YMiM0WVQMii56uJeDiE2Ew-1
X-Mimecast-MFC-AGG-ID: YMiM0WVQMii56uJeDiE2Ew_1764609030
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6409cea8137so10390124a12.1
        for <kvm@vger.kernel.org>; Mon, 01 Dec 2025 09:10:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764609029; x=1765213829; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=049HCOlcqn8l6MRkFi6tMcLlTFYa5Nd38LY4dhJJJtA=;
        b=QTN0QmYl2Ki0ImZwnwx3SDjgVhljpxghvYdi9wsbHrzxrP9v5rMOa+p1FSMK6q+Dht
         QOVYUuTk9vLGzTR6qUpZSLN4l8yXEjkJAFZMRmedfU3nISG1RyloH8Ri3fFS8afNr1y+
         PUhLnE2Dumw3ZZsRW1mCGGrFg37DawJSt8whO3GJR5ZE3WIlgzoO9w5XlUNxPsldLQHx
         a9AIv4tSaMdoBs+SWAbdzeRJlipGpa8FaiNkn5Qo7BDnZb7H7Xdn+j0zqJ/+BGleU737
         bbd8mthcufPfRY82HXh5rGkcM4DPs1MebUOrhkwiA6/oLsWSw2NVdBvS8UV7cW2ydOWm
         A1+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764609029; x=1765213829;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=049HCOlcqn8l6MRkFi6tMcLlTFYa5Nd38LY4dhJJJtA=;
        b=WInaHeyL+KIE+goaNHsm4EEsAAEWpLUEThT4EGI9HsjZC0nS9njKWoOWwADrstM8k2
         XUNSkEs9t1V4k0/vNBVfi+XGnM4NGRfGP5rLwcc14LyEZj9CujI9pZnaif3uf76ABPkd
         xnA73oKe00KL1YYrYHN+yuXT1I3vo+wthZDwRc6vIO2PH6C4SDHeYMq8W9NI7wUiu9qt
         OL7UqsJPelJk6lubrLN3e5PfRGxeJLRJxZzWT0rY1QPVzOU+Pv+oJ0lzPr+A80VedE5e
         zsptQupO1KIv4mu0eD0JyZJl7J6gmT3WrQgnWHUyuGudC97u5wmJnjtAw/CDN+Ba0+Br
         ciMA==
X-Forwarded-Encrypted: i=1; AJvYcCV0UDbLuVztDGxBTZHj9OrOhHdKAlz+pRujPBUXAOAIQ+UI4hiBMeUOQYSoKDmGPfkYy2Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YwL5piokEofrmsuykIFFy81E4I6NIH+Qw4UnjyTi2WGQjxCedff
	kcl3OoDGr2Qv9HokUZZi8qjvShWOBpjJ1PtRf2dxLrvH9UCKLlr5SiSJHXuaSYJlcxIDHLl2Cfb
	eiRcpTZIDdT925+N1OU4pTg3ORDjEVGlJIlJ1vwVcUQ3PYSo5bQDDnQ==
X-Gm-Gg: ASbGncuOm8qs3iy2ocRAQPN+I2wiBQpKfKbHdZTxrcZwn5la8t3MiPwnjdz47JcKZBL
	5ef3wwbloluMut56ZdScOXjp6BowxQeDvGsMUilbed1av3DOoAgq9Q4SOJqresj7ObgmwmloIMt
	FpHG750amWWYhVCcJXiZTbDkWs/Bd+E1o2PXRBnDqoNdyucNLSqwPtwZfRcwIrYSLGYgik4XxI4
	chTeDmUghLC1pRP9h2sBiFsVak5iZ7Aamaoa6borX027OCPUBIowa0xvsdLv+JmNIhVxHeGas/m
	qqcq096rlkOJpmZ60bOGmzPBhAtZRl66OU6xCzUWoBEiT+LM8rl2ZZYjB3agb31HEBwR1v2JjRw
	UzBz+v6pdiJcEYPFuMHgbI+QzDJD8DNwP+Om5KPoBO7lv055hl9B/5/rzF+kb0VyB3mCCZrz7jn
	lC5AIcNgoNsOoynsk=
X-Received: by 2002:aa7:d4ce:0:b0:640:931e:ccac with SMTP id 4fb4d7f45d1cf-64539658323mr30518283a12.7.1764609029423;
        Mon, 01 Dec 2025 09:10:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG825a9s9QjawjSVp0EkZVzuqoxFupItG+Wu6ES3CcuXyJDm66RSSs6PpefN/rP+bl8yPkP8g==
X-Received: by 2002:aa7:d4ce:0:b0:640:931e:ccac with SMTP id 4fb4d7f45d1cf-64539658323mr30518259a12.7.1764609028989;
        Mon, 01 Dec 2025 09:10:28 -0800 (PST)
Received: from [192.168.10.48] ([176.206.119.13])
        by smtp.googlemail.com with ESMTPSA id 4fb4d7f45d1cf-647509896d1sm13397667a12.0.2025.12.01.09.10.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Dec 2025 09:10:28 -0800 (PST)
Message-ID: <11859fd9-3731-409c-b3ca-01dd6f25bc1a@redhat.com>
Date: Mon, 1 Dec 2025 18:10:25 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/23] i386: Support CET for KVM
To: Zhao Liu <zhao1.liu@intel.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, Chao Gao
 <chao.gao@intel.com>, Xin Li <xin@zytor.com>, John Allen
 <john.allen@amd.com>, Babu Moger <babu.moger@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, Dapeng Mi <dapeng1.mi@intel.com>,
 Zide Chen <zide.chen@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
 Chenyi Qiang <chenyi.qiang@intel.com>, Farrah Chen <farrah.chen@intel.com>
References: <20251118034231.704240-1-zhao1.liu@intel.com>
Content-Language: en-US
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20251118034231.704240-1-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/18/25 04:42, Zhao Liu wrote:
> Hi,
> 
> This the v4 series to support CET (CET-SHSTK & CET-IBT) in QEMU, which
> is based on the master branch at the commit 9febfa94b69b ("Merge tag
> 'for-upstream' of https://repo.or.cz/qemu/kevin into staging"). And you
> can also find the code here:
> 
> https://gitlab.com/zhao.liu/qemu/-/tree/i386-all-for-dmr-v1.1-11-17-2025
> 
> Compared to v3 [1], v4 mainly considers pl0 SSP MSR for FRED, and fixes
> migratable_flags for FEAT_XSAVE_XSS_LO. More details, pls refer Change
> Log in the following.
> 
> Thanks for your review!

Just very few comments, thanks to everyone who helped reviewing so far.

The bigger comment is whether kvm_cpu_xsave_init() could be moved just 
after x86_cpu_enable_xsave_components().  I think it should be okay 
looking at the users of ExtSaveArea:

- xsave_area_size is only used from cpu_x86_cpuid

- x86_cpu_feature_name does not check size or offset

- cpu_x86_cpuid only runs from kvm_x86_build_cpuid

- x86_cpu_reset_hold is only for user-mode emulation and anyway runs 
afterwards

Thanks,

Paolo

> Overview
> ========
> 
> Control-flow enforcement technology includes 2 x86-architectural
> features:
>   - CET shadow stack (CET-SHSTK or CET-SS).
>   - CET indirect branch tracking (CET-IBT).
> 
> Intel has implemented both 2 features since Sapphire Rapids (P-core) &
> Sierra Forest (E-core).
> 
> AMD also implemented shadow stack since Zen3 [2] - this series has
> considerred only-shstk case and is supposed to work on AMD platform, but
> I hasn't tested this on AMD.
> 
> The basic CET support (patch 12-20) includes:
>   * CET-S & CET-U supervisor xstates support.
>   * CET CPUIDs enumeration.
>   * CET MSRs save & load.
>   * CET guest SSP register (KVM treats this as a special internal
>     register - KVM_REG_GUEST_SSP) save & load.
>   * Vmstates for MSRs & guest SSP.
> 
> But before CET support, there's a lot of cleanup work needed for
> supervisor xstate.
> 
> Before CET-S/CET-U, QEMU has already supports arch lbr as the 1st
> supervisor xstate. Although arch LBR has not yet been merged into KVM
> (still planned), this series cleans up supervisor state-related support
> and avoids breaking the current arch LBR in QEMU - that's what patch
> 2-11 are doing.
> 
> Additionally, besides KVM, this series also supports CET for TDX.
> 
> Change Log
> ==========
> 
> Changes Since v3:
>   - Fill CPUID 0xD subleaves from KVM CPUID instead of host CPUID for
>     non-dynamic xstates (i.e., except AMX xstates for now).
>   - Save/restore/migrate MSR_IA32_PL0_SSP for FRED.
>   - Fix migratable_flags for FEAT_XSAVE_XSS_LO.
>   - Refine commit message for CET TDX support.
> 
> [1]: https://lore.kernel.org/qemu-devel/20251024065632.1448606-1-zhao1.liu@intel.com/
> [2]: https://lore.kernel.org/all/20250908201750.98824-1-john.allen@amd.com/
> 
> Thanks and Best Regards,
> Zhao
> ---
> Chao Gao (1):
>    i386/cpu: Fix supervisor xstate initialization
> 
> Chenyi Qiang (1):
>    i386/tdx: Add CET SHSTK/IBT into the supported CPUID by XFAM
> 
> Xin Li (Intel) (2):
>    i386/cpu: Save/restore SSP0 MSR for FRED
>    i386/cpu: Migrate MSR_IA32_PL0_SSP for FRED and CET-SHSTK
> 
> Yang Weijiang (5):
>    i386/cpu: Enable xsave support for CET states
>    i386/kvm: Add save/restore support for CET MSRs
>    i386/kvm: Add save/restore support for KVM_REG_GUEST_SSP
>    i386/machine: Add vmstate for cet-shstk and cet-ibt
>    i386/cpu: Advertise CET related flags in feature words
> 
> Zhao Liu (14):
>    i386/cpu: Clean up indent style of x86_ext_save_areas[]
>    i386/cpu: Clean up arch lbr xsave struct and comment
>    i386/cpu: Reorganize arch lbr structure definitions
>    i386/cpu: Make ExtSaveArea store an array of dependencies
>    i386/cpu: Add avx10 dependency for Opmask/ZMM_Hi256/Hi16_ZMM
>    i386/kvm: Initialize x86_ext_save_areas[] based on KVM support
>    i386/cpu: Use x86_ext_save_areas[] for CPUID.0XD subleaves
>    i386/cpu: Reorganize dependency check for arch lbr state
>    i386/cpu: Drop pmu check in CPUID 0x1C encoding
>    i386/cpu: Add missing migratable xsave features
>    i386/cpu: Add CET support in CR4
>    i386/cpu: Mark cet-u & cet-s xstates as migratable
>    i386/cpu: Enable cet-ss & cet-ibt for supported CPU models
>    i386/tdx: Fix missing spaces in tdx_xfam_deps[]
> 
>   target/i386/cpu.c         | 256 +++++++++++++++++++++++++++-----------
>   target/i386/cpu.h         | 110 ++++++++++++----
>   target/i386/helper.c      |  12 ++
>   target/i386/kvm/kvm-cpu.c |  23 +++-
>   target/i386/kvm/kvm.c     | 117 +++++++++++++++++
>   target/i386/kvm/tdx.c     |  20 +--
>   target/i386/machine.c     |  78 ++++++++++++
>   7 files changed, 501 insertions(+), 115 deletions(-)
> 


