Return-Path: <kvm+bounces-36162-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E9E7A18280
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 18:05:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC8643A28C2
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 17:05:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5ABE1F4E40;
	Tue, 21 Jan 2025 17:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ekgm5za4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD561922FB;
	Tue, 21 Jan 2025 17:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737479137; cv=none; b=fcdA2ZG1Oce4qBSW9BviqxOMMvXO2YOR1DhgEYHETBrHFJWkmjN8Z6vxIgFGgBp0BrTBnvoPNbReiPedOHjfcHRFzH39to12pIcpT+f7tKBK0y7InFOhOHefWFBVlRZDq4tuipYEWda7aC4h2+Z48jHV4oWKswfuyIGDxDDb168=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737479137; c=relaxed/simple;
	bh=7Wnl9oSRTR0U9afAlbrFumWrAKFW9AV1mVaZgNK4C1Q=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=j3Cu7+cYNLWvNEsN93WzDMUt/1RsGckF+z2Sx8VsnxcmZYkTs9zf19tJ1Dme6i7wz76LCGK7aWENdhAJkBT+J9uDw7Fi+xVU6Df5V/SH4ibvhsjMNJX2IuifxXlA9Vh6jEMrluEEngWkud3y86N4V7qYyHN7H/N9JgMyZdsjruU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ekgm5za4; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-43675b1155bso68075135e9.2;
        Tue, 21 Jan 2025 09:05:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737479134; x=1738083934; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LjJHSXbQesT/9Ft4jUdfkWoFqW+2359bV+wDEaGzyKE=;
        b=Ekgm5za4ix7yj/HJ8r8gp2kC85lULAaNYEm/p2iFLcOBFzMgdMwLRDSwi5xkOYniig
         p/NcrdhrkVb6XpP5q20UytwzTTPU1yV1Cayccc0DZZeLrYHLHvAOSaR4eWN6WjKhRKjP
         RbUMs3czRjfqRetj0Kcl7gGZAH3Q0ZynR3lBG56U6quNNQCbdMdUf5omKtJaXr9mVsd2
         N/Y3V2UHZjA866NgrSYGTwT/VP6yd9WIU0Ak73HP9R6HtTsRj9hSfvRbQthvYvmqIxvU
         z1nS91Xi44I4xILcktZdG+hEdTrfZ+J2NwSAhiIZd7rvTH5UmBLQivlPqVA5NL2ZLJcP
         NA6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737479134; x=1738083934;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LjJHSXbQesT/9Ft4jUdfkWoFqW+2359bV+wDEaGzyKE=;
        b=LZCNcFQuoglIwMeOn9URIZxqit2AC3j62oXWuRoCVHkqwHMpG59aYq4ab8vs+flHri
         KAN8Jl/S0uCPuRXY50Bzq0mkSreso7RUr5DZ64QdzWXcSzx4dAasSLfxeYmaekwzpoGZ
         Qe5V6lkkwfPxmcfHkLYE/5/AZ5SwB4DfD/MWKcMLDmjEwA4JofehnT4cggdvGdgzdw0j
         ovc+6mGakgrphq2SRvGVX5XKbIRFYhJuWImYt3+bGG8cTs2woSCUoHFvmEyZaQQVSWfB
         NGdjo7GuWa6aJyPp3AVoPRnAsIreVvvgqXFXrxPzIarrX56T0bvX4VSxbAQXn1RY/U2h
         7LBA==
X-Forwarded-Encrypted: i=1; AJvYcCUdOnf4GearR+FDD1M8P+zpZvInXsqk71Deh1gMGBKviT6Q27NiP3UNmRmSmEc4KaKRAOSw+lO6x2MYCsU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyhKU/E7kzDJ/2wVt92dMfVV1N7DEna7nikbSwH50+IkhA2pA7H
	KPj6lvrGfvX5ZcZ2PyXx9SDH+Ue2we9kxsluJtXcFos7CfgNbbDLvBBWM55ieno=
X-Gm-Gg: ASbGncvpdNOVBDCDYasYn9VRDlIBH45Q/IkGat+O111/oFoQciQyVJCtNm/4bdWvFU2
	isK0CeYti8WemyiYLP41lbF7tXJDd9vcSPzd0wdEsozVNetZMckE3JABJFUW911dg7/WDmclNWX
	ZPxJJsH4WeWiRWEAvxkDgx+KFneuqVo0RMf5UmtiBveJ4JJepmEnWqfdSXHqqrgkbUSRW5nEUL8
	dnixPj3HW5iOz38LJ5ZdPTdbm0gVBpy4dxWiwiAhAYYwq08nfOc0qNuGZRRT3KrHiauGUP1bUwR
	hotSYQMMqBk1TxhWKbbCiRXGiQ==
X-Google-Smtp-Source: AGHT+IEJ4vSshdSFEYbS9I4Tl309UZvuIfRwjAYHTQ0xPfLSEwsXpnBeE7DX2nMEouOupZ40/2yGhg==
X-Received: by 2002:a05:600c:4e14:b0:436:fa4f:a1cf with SMTP id 5b1f17b1804b1-43891431697mr172803815e9.29.1737479133507;
        Tue, 21 Jan 2025 09:05:33 -0800 (PST)
Received: from [192.168.19.15] (54-240-197-233.amazon.com. [54.240.197.233])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43890468480sm186826515e9.33.2025.01.21.09.05.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2025 09:05:33 -0800 (PST)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <11b2a5ac-0e7a-430b-badc-23dd9907bf03@xen.org>
Date: Tue, 21 Jan 2025 17:05:32 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH 10/10] KVM: x86: Override TSC_STABLE flag for Xen PV
 clocks in kvm_guest_time_update()
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, David Woodhouse <dwmw2@infradead.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+352e553a86e0d75f5120@syzkaller.appspotmail.com,
 Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20250118005552.2626804-1-seanjc@google.com>
 <20250118005552.2626804-11-seanjc@google.com>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <20250118005552.2626804-11-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18/01/2025 00:55, Sean Christopherson wrote:
> When updating PV clocks, handle the Xen-specific UNSTABLE_TSC override in
> the main kvm_guest_time_update() by simply clearing PVCLOCK_TSC_STABLE_BIT
> in the flags of the reference pvclock structure.  Expand the comment to
> (hopefully) make it obvious that Xen clocks need to be processed after all
> clocks that care about the TSC_STABLE flag.
> 
> No functional change intended.
> 
> Cc: Paul Durrant <pdurrant@amazon.com>
> Cc: David Woodhouse <dwmw@amazon.co.uk>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/x86.c | 35 +++++++++++++++--------------------
>   1 file changed, 15 insertions(+), 20 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>

