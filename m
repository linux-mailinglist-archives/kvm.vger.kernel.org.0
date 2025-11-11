Return-Path: <kvm+bounces-62729-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41A62C4C5DC
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 09:23:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F87E42333D
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 08:15:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A47A2FBDE3;
	Tue, 11 Nov 2025 08:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SGbssLNl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D62B2F4A0A
	for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 08:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762848859; cv=none; b=c504QAbEH3M1IL5Civy9r0KSqD0ASey4KxmmRdbVFkIS2tbuu3VjuknBucK8y6KOA1PUBDOyVESh75TAdlPhbY9yMbsdCJBb/9i5o2X2LgJPNkic65eHD7hFMXCdEF4QN2+2mExvuA1lnrmhZHCMUvg7YruAANn35toGXV4Sr4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762848859; c=relaxed/simple;
	bh=PIVbeP4t8n8Ng4FTu7PKo/Y/zpdVBL6TpuyK0ff+Htc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FAm/ZgLY7tN+3KkKQ8UgbHcvBgz1aXZ6NrINNBgG3R4IYxIwJyA8IyT2vNhBQ30gZ+lZdzGsM/MIbhkbLwOfJsvbVnL7qsS3iKAt429vr8Wn4emf5EA7ZVheIxM3msPhpOIAPyKi+QUSgBEqHovalG8TguIO0upOpLUOtdctAME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SGbssLNl; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-29558061c68so47784875ad.0
        for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 00:14:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762848857; x=1763453657; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ki+EdCwrqCwLTvI7nFeDEfQqruCfE/WB29n1X4H7FwI=;
        b=SGbssLNljTTVs9BPX0os//BvFsZvRp573bHZR1dVSS2OZltDQN/qkXmIqMcTdKC10Y
         Bj46z5hUUIydOkTZ6MQNW1NCwR5HsKvBX0T1X8m/CRYSCr2io82y8XJ0nRJEw+KwGjJ/
         DFX40/nSzZHIF9NoLbd+fFIlrJzCrF/96AG0VhtqZolz4wNlmadJFcukRqR3zSgLuKj8
         uRN2LivYbZcgkqdIXphEqSpfAIFujd3i40C4jF8KznaUYMIFb8vjVFxrfRGRFbFpQ0Qr
         mPD/v32qVgMI6TvcwCkuEwkDct6Ln0ZM+T5wmB5QOjNqmS6bHP+LeBJcfLpbz7jkMVZZ
         djuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762848857; x=1763453657;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ki+EdCwrqCwLTvI7nFeDEfQqruCfE/WB29n1X4H7FwI=;
        b=XjRU9VVllVh8eBNH0PzQmuqEjvPtJavVzOo6wCfEQILZbx4UtDoeudQpnVx+aQWEiS
         uG6NCvfIEDFuErnA3JW5wRu/uYCuw2uYNnI24SVNlDIjD2Abqw3ofR1LKcS1MsMT+aqn
         VM40zoabQZIdcp64RsOjVNmi1eBqwXSNOP6EvYAoGrRa9nU5/+iT+tK2G/cEkZNxZyZq
         j4ilzguKVZs7wREP633Y1qrw+HtJIRrEiOGkXSQ+blw86lcAS76moMhNnl6n778iIKom
         2j3uocvZI5XkWal5sqW1ffUR6cTjMokbLYb88LtTVY4i6mx4k+Rabb8qp28U6fC5yR7D
         GsDw==
X-Forwarded-Encrypted: i=1; AJvYcCUbzq2+tIsM/hLhV3ccirmfz5bOnvTKOanT5GljAL+4vprtIP6YeTm5XvHqrfB5jfY2f+A=@vger.kernel.org
X-Gm-Message-State: AOJu0YwwH8dCYmsxENtQ/IxyA7UBry8ng8vp6xOCdg/6IygOEAedQCB1
	SdCQ/+874SKdeDu1gactPG3u7e5qOALMz6zQ5VnwvFp5M8ZwA0v3Cf7Q
X-Gm-Gg: ASbGncvBOCPpLq2lct5QdATpqd+M6Gjn/rZoqJIo08oq97BnKYXyHpvR0YMS46warON
	zlCKOG6HesRkevTpqgSeYoShmIhZf1LsHLYhwOAD26oPkesx/jZIAQ4WoyzBGFLvpLRQ9eqi7Ew
	tR+7qQrl6AdGuo6vQJ8UUD9XgzOz0Xq4mSQGtGFFHpSrvpAhdE11I9DuYCJ1Rb1nOrZxc3JlMus
	/7oHItqhEHlqnISgm9NcwETdQtymuUma31+jKbaj5EblFgxep2ssV7yZjMtaIxSeOTlGThd3bMa
	XxJYqL3PXmhXHV/Yebq8eRn5ncqPsmLpz7m/gzbKs6qtOHnTwf8jbUFBCA4SQiD4bzM6Hq8K3qk
	s6i3YUMLtD4MCwUzZ/o3Oue5NJMaqRFJ6KcKM3aSztd5gyqc3MT0EHnA2ESUysZIl8I8otHShUg
	LR3ro=
X-Google-Smtp-Source: AGHT+IEXbokiRMdzLwroLqxNwuaDg7sJCWR9XTrjrkrTQw3iwww5gG1R9bB24Xe5cDdIPIMJyxNYQA==
X-Received: by 2002:a17:903:2f86:b0:295:596f:84ef with SMTP id d9443c01a7336-297e56be204mr131918645ad.31.1762848857508;
        Tue, 11 Nov 2025 00:14:17 -0800 (PST)
Received: from [10.253.64.201] ([47.82.114.92])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29651c8f07csm176195655ad.78.2025.11.11.00.14.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Nov 2025 00:14:16 -0800 (PST)
Message-ID: <da38c720-02df-4e3e-ab50-8fe84bdccf5d@gmail.com>
Date: Tue, 11 Nov 2025 16:14:12 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/1] KVM: x86: fix some kvm period timer BUG
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner
 <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
 "H . Peter Anvin" <hpa@zytor.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, yu chen
 <33988979@163.com>, dongxu zhang <xu910121@sina.com>
References: <20251107034802.39763-1-fuqiang.wng@gmail.com>
 <aRKDLo_SFJxyQWG5@google.com>
From: fuqiang wang <fuqiang.wng@gmail.com>
In-Reply-To: <aRKDLo_SFJxyQWG5@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11/11/25 8:28 AM, Sean Christopherson wrote:
> On Fri, Nov 07, 2025, fuqiang wang wrote:
>> =================================
>> Fix both issues in a single patch
>> =================================
>>
>> In versions v2 and v3, I split these two issues into two separate patches
>> for fixing. However, this caused patch 2 to revert some of the changes made
>> by patch 1.
> 
> FWIW, my initial reaction was that I liked splitting this into two patches better,
> but after digging through all the angles of this for a few hours, I agree that it's
> better to skip the "don't let the delta go negative" patch, because that patch
> really only addresses a symptom that shouldn't happen in the first place.
> 
>> In patch 4, I attempted to merge the two patches into one and tried to
>> describe both issues in the commit message, but I did not do it well. In
>> this version, I have included more details in the commit message and the
>> cover letter.

Yes, the reason why I issued the “don’t let the delta go negative” patch
separately in v1 was that I hadn’t yet identified the root cause of the
hardlockup at that time...

