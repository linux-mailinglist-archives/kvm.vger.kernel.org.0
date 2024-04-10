Return-Path: <kvm+bounces-14117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 277B589F28A
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 14:44:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 86224B24842
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 12:43:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25B0715D5D7;
	Wed, 10 Apr 2024 12:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Np/w1Nmi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C052912EBEF;
	Wed, 10 Apr 2024 12:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712753011; cv=none; b=NdTenrI6Y2LyaDsEZGd2mP2/J3hbV57QHNrYaKEMgSvZRQGY1CTmXYQaEl5J1o3KtnxW2N0EtJsLmp0yK5Ba00p7UMEweea1PQGHX+Rsc0s4caWeWvw0aNgjsfdbPLLB2HNVkHiTp3/93yJJ9IWsUBJX1otnsnpBT9ZqRC//ops=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712753011; c=relaxed/simple;
	bh=ZIAOmvrnl59E0qA8D129ku06QXp/t0U+yZH7OIQvevA=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=KwXu6epO1LlSL7VqUZUZk73pX537lJcF3DZud60UWpgOfX1tA0VGvxFkPa7RwARuGoJd9l3Qy1e+myyVYn06najZ0FUYe9VtwkFkwNM0hSsQErIZWuAbgQfhVwqTaT7QjQFTSbQKI5OEvWg4dcN/Zul4gtKSONwj35MdwQzZg/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Np/w1Nmi; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4166d6dab3dso23328025e9.0;
        Wed, 10 Apr 2024 05:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712753008; x=1713357808; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=s6W3q2bOeGE0BrRwL1fG865Gcw8RNsxpT6lmBauL/5w=;
        b=Np/w1NmirFF4XcdCjJTrl8BuE1EdJXqSEaXVeczwbIjKJcbdHTm/E9RSXswwqi3qCm
         RL18G3TKu0ntrPGZbKgpEet/RrZ3p+v8ja/juMHKx4njL2TsXnOAvvtpcGUM7GIbZwtf
         7nq0RYshnvYftaRuUy4zTZ4X7iRBX9N0x22rD4tuWahJ82390wknPcMSjj+vGDBP9jCT
         ueIwvL8xcdclm/i1Po9R8aC932VIETd5tg3CGpoWpMEAd0TYssxazcskL/L+XrslCB5l
         +HXMSiJ/54EM8EBKxWAxFRh9802HLj0a94iAzZTrUTw0crUkYx0OQbC/F/52CnrCTSAD
         eJeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712753008; x=1713357808;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s6W3q2bOeGE0BrRwL1fG865Gcw8RNsxpT6lmBauL/5w=;
        b=nSVe2+T3aHMlO2b2mWeCZWCJQw+C5gLLzYXmILzHHJ6vXotoOrFXU6jShq/+jogclD
         vw+IaUQoDMsggkvtI5phGOWTGcTV+unaDUatyQpdhZUTPhjcpKe3z/K2LGt0XwEqmSJK
         xQNzgw6+nYY6PNqN9CKRlgUI6SbPHjSlGf3xBzS4gD00A4QQP7IfAg5NV5Yn7LMJoYFo
         Ffz388bLToszsaChNac99e1iIy/SyCACI+RACpXMWefdNcCvI/H2yQdF93pSNkPrl06q
         vEVzNNhUGNfUcEqyUziYon2q2umlOztmwL7cPSt0dS+MZRmCtbzAAA2+l1t7337wzlOO
         JTSw==
X-Forwarded-Encrypted: i=1; AJvYcCU3cNxS7QwEkgey7RsRzAIL6eYtP4c12E7MwUbgb41ZZaYb74ltrfadVj4x0eqKU1OOnGGRHugfg3wSfriG5tk59x+Av6+7QaSBsqU384ln2GB/+5qSrjBU9Gs9N/9wpr8ridF/b+jwANhb6UxpD+F2Ws9W/3Yh1vI3i/bX
X-Gm-Message-State: AOJu0YzUtKPTB4rv5KVCWRgOwnvzuk6X7XN9I7KC8aFV1QQeVyFSOxhB
	eGZL5JmvumgvwceoqAnPdWB4pa1OhiPQMyluIYrXXViN5LholQoN
X-Google-Smtp-Source: AGHT+IHcugzE8vzXE8HPH/lzuP1bY5ylrSJUYCanSNtur6lnkBf2UVBphkiKUJzhXqy7mwr2gZBryg==
X-Received: by 2002:a05:600c:4e88:b0:414:93df:bef1 with SMTP id f8-20020a05600c4e8800b0041493dfbef1mr1751654wmq.39.1712753007855;
        Wed, 10 Apr 2024 05:43:27 -0700 (PDT)
Received: from [192.168.12.203] (54-240-197-228.amazon.com. [54.240.197.228])
        by smtp.gmail.com with ESMTPSA id n15-20020a05600c500f00b00417c0fa4b82sm729506wmr.25.2024.04.10.05.43.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Apr 2024 05:43:27 -0700 (PDT)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <26bfe5ec-e583-458d-8e43-e5ecdc5883cc@xen.org>
Date: Wed, 10 Apr 2024 13:43:25 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v2 1/2] KVM: x86: Add KVM_[GS]ET_CLOCK_GUEST for accurate
 KVM clock migration
To: David Woodhouse <dwmw2@infradead.org>, Paul Durrant
 <xadimgnik@gmail.com>, Jack Allister <jalliste@amazon.com>
Cc: bp@alien8.de, corbet@lwn.net, dave.hansen@linux.intel.com, hpa@zytor.com,
 kvm@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com,
 seanjc@google.com, tglx@linutronix.de, x86@kernel.org,
 Dongli Zhang <dongli.zhang@oracle.com>
References: <20240408220705.7637-1-jalliste@amazon.com>
 <20240410095244.77109-1-jalliste@amazon.com>
 <20240410095244.77109-2-jalliste@amazon.com>
 <005911c5-7f9d-4397-8145-a1ad4494484d@xen.org>
 <ED45576F-F1F4-452F-80CF-AACC723BFE7E@infradead.org>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <ED45576F-F1F4-452F-80CF-AACC723BFE7E@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/04/2024 13:09, David Woodhouse wrote:
> On 10 April 2024 11:29:13 BST, Paul Durrant <xadimgnik@gmail.com> wrote:
>> On 10/04/2024 10:52, Jack Allister wrote:
>>> +	 * It's possible that this vCPU doesn't have a HVCLOCK configured
>>> +	 * but the other vCPUs may. If this is the case calculate based
>>> +	 * upon the time gathered in the seqcount but do not update the
>>> +	 * vCPU specific PVTI. If we have one, then use that.
>>
>> Given this is a per-vCPU ioctl, why not fail in the case the vCPU doesn't have HVCLOCK configured? Or is your intention that a GET/SET should always work if TSC is stable?
> 
> It definitely needs to work for SET even when the vCPU hasn't been run yet (and doesn't have a hvclock in vcpu->arch.hv_clock).

So would it make sense to set up hvclock earlier?


