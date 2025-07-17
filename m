Return-Path: <kvm+bounces-52708-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 05A42B085C7
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 09:01:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0CCCE1C23529
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 07:00:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4405E21CA13;
	Thu, 17 Jul 2025 06:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="CJL8bEWu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885B42185AC
	for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 06:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752735597; cv=none; b=jP6mwyISP+ez96pA/z/xUwa4IfLy9kH5XDeEgJ7WbK3etsc3BNu7AhLI+vYlys0z9nJtFqh8NDqB50sAa1zltF/iXtYmswnF+nJDaOdcXmSprLZitxpICidWgiV5Py8/kye4wznEt2gWDwKrK7pVC19upcATt8RC/sQgnLNTJto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752735597; c=relaxed/simple;
	bh=Q3m3STGaAGQImRO1mAS4/C4kAlq0ECEIMqTvXtU3iaM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NW5E6kR+XBdB1HWQq5lUhBOx+SP3cq9buKXHigBuaSiTuY8uq11rDveNftV2yvs0cSK0aiWJF1w/XGtiD7FXBiw/z8p34kjuBZu7x3/g9I9K6jc8kQ2LHIqGEXpng4SwBwc10aL1PPwik0PzRqlxeH5t9lqPWK/XaGY0mXTxRBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=CJL8bEWu; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4538bc52a8dso4388375e9.2
        for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 23:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1752735594; x=1753340394; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=7sm/BKnQ8dptUdOe/NwHY/QfbOT5uaRlkVYhFHFgiyk=;
        b=CJL8bEWuf3m3FeG6nyctw7Nwi4MSHwwfH6xOeB1bQll8pmRgOGBO9nql+Yub/Jp1Ad
         21aDW9evI+rZfOa8Ezcy5X6hWsY6kT1KEVL0G2HX4j583X6rUOx9/HwKjeTM94i9bcgI
         sPHQzh8ihOtr12K8lgjRClWlsXGB3YlIipD9h+nP3a4RyVNDeFwtfAroXK/yVoE9CAmY
         Jfd/G6marhjxmnUEChPE9+i/EwlCQZEdt9g5uKz3Spub0X3jaUnT+++9ALmWkGRNmphJ
         XY9tdjbJjmXzHby8mvOiohOYAWzYyLnsBkSAy64EKhHqUDHtGC25705L6Sl/VJkGqO1M
         42hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752735594; x=1753340394;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7sm/BKnQ8dptUdOe/NwHY/QfbOT5uaRlkVYhFHFgiyk=;
        b=fVTqc1UvBrEuQ7tva12NkpOiKy/THo4XXP8vWA+LiztUnOTZmFXkFvC4BaI4TUZotC
         b0YvZ3DY0B4WIxEYqvk2sVAzTsq+IlgNOemlPcRMaDjeXeES+I3PNTQ4MJbLI94Euk6v
         eB+KkVOY5cGkr7L4Vp2s/h9pfSQoEN9+/fcweesJRdWDngasMWd4U9yi1veawlVB8mpg
         oOUfIf7CI6B+ZlxuNVDX0shayZ17RqvEZszZ0xyxavcdVuV3bTnFcUSX6FLZUhBmTzbT
         3DtokW32lUL41z7T3sgTaLwdhPq+dueS2kw9Q9Y15HvP3ON+6IDtBMry2bLl0sA841qC
         STng==
X-Forwarded-Encrypted: i=1; AJvYcCWu7XksAVP+nmKPgYiPQcY9kjyEQHQXA5RbBfNR3ubDCo68O1lox6asFrowkgm1XRrPBq0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8doYxf15rgUEkt7mUTCJCVFZ3BYtSNEqaPcv9MBLqjJLvdCji
	pNKexlFL8J7w2H37FILfv4xIdWyY/9OnN6PHFZGhKfZUT9mZkYLZuHKClrDS2LYmGGo=
X-Gm-Gg: ASbGncsKSNuuDIHSiUuMDp+0V7QXVrAzhq0g9u7EqRoHb1CjLkwWGPcAoeTl5R+Yw7L
	Z4YyKcMYjN3vCunYC/eP6YYRa5/sqt0fv6RPT1H5ICzxNVrgxRuUZBjPD/7xUGISCegtLcLhW79
	EgnJRBzfGdTKnqnSkd17mV73vUUywuuM0NzKdxsd0nqB1YtOVhy/vYQJJhOgnXSf4l6Ou3e6goJ
	QcvlK7s5IIwJ3ahZB7UTuHjDhKJEP4c9KTa9ViiqDuWSt+cywGqpX7bF7kwQMvArcxvILlpVv1N
	L5X1HxeXD/U2wygHCqKzDSpRwDHbIRQV31ER4236D38ayUE8xdUgMMTjNPaX7AqGNDjXx2GDmNE
	/GG58Hie4yc+mf9PPalkgIsf6ATWWOdcDXqjnICzI1hDKn3o9fkNeXCFcRVglaBSllPt44qmpCw
	5NIor2xzyzFcX9H5ptTPUxw65FeMagIpF9nLwTxZWdceMGRFzJIZ/nakw=
X-Google-Smtp-Source: AGHT+IG1HadWvybhRZ1ckXq/8YSVpErsnzffbgEJMA67zutfkfFm6/01vHeWnGfRDKCh2X38vxB6KQ==
X-Received: by 2002:a05:600c:3b8f:b0:456:8eb:a36a with SMTP id 5b1f17b1804b1-4562e04736dmr55273065e9.13.1752735593746;
        Wed, 16 Jul 2025 23:59:53 -0700 (PDT)
Received: from ?IPV6:2003:fa:af22:cf00:2208:a86d:dff:5ae9? (p200300faaf22cf002208a86d0dff5ae9.dip0.t-ipconnect.de. [2003:fa:af22:cf00:2208:a86d:dff:5ae9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45634f6bc51sm12965085e9.17.2025.07.16.23.59.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jul 2025 23:59:53 -0700 (PDT)
Message-ID: <faf246f5-70a7-41d5-bd69-ba76dfbf4784@grsecurity.net>
Date: Thu, 17 Jul 2025 09:00:04 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 00/23] Enable CET Virtualization
To: John Allen <john.allen@amd.com>, Chao Gao <chao.gao@intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, x86@kernel.org, seanjc@google.com,
 pbonzini@redhat.com, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
 mlevitsk@redhat.com, weijiang.yang@intel.com, xin@zytor.com,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>
References: <20250704085027.182163-1-chao.gao@intel.com>
 <88443d81-78ac-45ad-b359-b328b9db5829@intel.com> <aGsjtapc5igIjng+@intel.com>
 <aHgNSC4D2+Kb3Qyv@AUSJOHALLEN.amd.com>
Content-Language: en-US, de-DE
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <aHgNSC4D2+Kb3Qyv@AUSJOHALLEN.amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 16.07.25 22:36, John Allen wrote:
> On Mon, Jul 07, 2025 at 09:32:37AM +0800, Chao Gao wrote:
>> On Mon, Jul 07, 2025 at 12:51:14AM +0800, Xiaoyao Li wrote:
>>> Hi Chao,
>>>
>>> On 7/4/2025 4:49 PM, Chao Gao wrote:
>>>> Tests:
>>>> ======================
>>>> This series passed basic CET user shadow stack test and kernel IBT test in L1
>>>> and L2 guest.
>>>> The patch series_has_ impact to existing vmx test cases in KVM-unit-tests,the
>>>> failures have been fixed here[1].
>>>> One new selftest app[2] is introduced for testing CET MSRs accessibilities.
>>>>
>>>> Note, this series hasn't been tested on AMD platform yet.
>>>>
>>>> To run user SHSTK test and kernel IBT test in guest, an CET capable platform
>>>> is required, e.g., Sapphire Rapids server, and follow below steps to build
>>>> the binaries:
>>>>
>>>> 1. Host kernel: Apply this series to mainline kernel (>= v6.6) and build.
>>>>
>>>> 2. Guest kernel: Pull kernel (>= v6.6), opt-in CONFIG_X86_KERNEL_IBT
>>>> and CONFIG_X86_USER_SHADOW_STACK options. Build with CET enabled gcc versions
>>>> (>= 8.5.0).
>>>>
>>>> 3. Apply CET QEMU patches[3] before build mainline QEMU.
>>>
>>> You forgot to provide the links of [1][2][3].
>>
>> Oops, thanks for catching this.
>>
>> Here are the links:
>>
>> [1]: KVM-unit-tests fixup:
>> https://lore.kernel.org/all/20230913235006.74172-1-weijiang.yang@intel.com/
>> [2]: Selftest for CET MSRs:
>> https://lore.kernel.org/all/20230914064201.85605-1-weijiang.yang@intel.com/
>> [3]: QEMU patch:
>> https://lore.kernel.org/all/20230720111445.99509-1-weijiang.yang@intel.com/
>>
>> Please note that [1] has already been merged. And [3] is an older version of
>> CET for QEMU; I plan to post a new version for QEMU after the KVM series is
>> merged.
> 
> Do you happen to have a branch with the in-progress qemu patches you are
> testing with? I'm working on testing on AMD and I'm having issues
> getting this old version of the series to work properly.

For me the old patches worked by changing the #define of
MSR_KVM_GUEST_SSP from 0x4b564d09 to 0x4b564dff -- on top of QEMU 9.0.1,
that is.

Thanks,
Mathias

