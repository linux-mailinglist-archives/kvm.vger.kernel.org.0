Return-Path: <kvm+bounces-37212-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 99C83A26E0D
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 10:20:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1D689165B87
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 09:20:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3B38207A33;
	Tue,  4 Feb 2025 09:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cZrKfSLG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2280C205E26;
	Tue,  4 Feb 2025 09:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738660803; cv=none; b=BoOyrQHv1OrXX8vA1TdfGLuUXxJKl3dYEIg54ZsryFMtBcgDHfN7zIthqZM9uoyGlPRa5kMAgTxOIwpeId7DTp7s8iWQaEBVTXZ905totezrlBiaxJWHa9GqermsIDQVLrsVGb69hPxEXJ3On5gHH/bWx4su6NIvmZRt1jDxwZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738660803; c=relaxed/simple;
	bh=SVDDG3SoH5jvl3YPhLa/GjlbC4VVi5RFTjffna0TPdQ=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=Ji8wNNNQa8H87aQ496Vu/dh3xbYSGZmBgS/BiUoa3WpkJ8qHTVNkdCGAtw+W6kCKZ22g2J5gGbI6fRB48Lc32nvne98l1y9xyDslpgp5ZN0EzcBinHf6fYYfNWifckTMAP9aIlPp/lmULFCX+UoagqwpGzSsaZtO3i/ZeT8stqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cZrKfSLG; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5dca451f922so3949587a12.2;
        Tue, 04 Feb 2025 01:20:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738660800; x=1739265600; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=N/dQwnwJeVpC/wcrli/EX5K6+901Md4XabfvKhD3sb8=;
        b=cZrKfSLGTB9uq/usfCMRWdCwvL0zJDW/85Pb/0hM4BWdf+zJOh79UeoWC1pD1TtzXJ
         Pz8LSagQyexsjkabD39q+ZAxKeXfR2Nw7QKWKl/ij6molZQOY12TeOXEHQsgTpaQKVGy
         XSW9Ygk63yGGi9F+5t4FS64KCLrLtsJsrBNxaEqQ3cnYCe48lZisKeDsFf0fl51NK1FT
         hfvRdqWsL2u4ZRQoJC6BpzHKvM0RDz1eaJna5iFyMSxn5VoFc0mDsmRmTaNTglSrmjAe
         LUmNkZySV+rYrc44Qh3Syo04P4pbevD69GylVEYCiDYPd4KO1vdGL33jby84tAmYZQV3
         EN1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738660800; x=1739265600;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N/dQwnwJeVpC/wcrli/EX5K6+901Md4XabfvKhD3sb8=;
        b=QieyWAi47tsCayQ6jjvlwDqThChfFF/SUdJdJ7Ti0zpg8Y6XTkiSkWOc9J/MfmnPGM
         1NOhubpdYJn7DdIF/exH9Ka1L10lvj9cJoOABuPBVHHtvrWU56n2fJrS4HCl6Larampx
         pjUhWWRpdGTBDEFA38utUKcvplcrx37jx31VAKOwRZnWHuPzz3pjtYGHNrDflUVMCevM
         LHO53PAUAeHFColn2EaN3xq8Q6kZZH2AGaoS5+R/lU2nfNzwyfUwbm9caUFBWM1jwNbs
         u7kMPzBizc1Dw2KPny1cFqoF42LtrK+v/dw48Zfz5K+FTmF7qOnMxMzzixN6TBKHUB5c
         iuHA==
X-Forwarded-Encrypted: i=1; AJvYcCUglrdpwuRmRG6BN3OTE3HoI30aNTjMExMHBjV2yLxWvRqoL/idz1lar/OTh5RiOHsuSiucFiUmtm5uwtE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzl/rfqLmAWvimA8lDUwUiSA7C/kRaA6yhYXiurmesDsY18y+vo
	bGixtpE2Blnx40+6cCS/ITeyu9rsQSpu56CIuBSxrLmxQv95zx6d
X-Gm-Gg: ASbGncv5ZiFDUd9g0GVbs1VP8wPHLyKrTAnxwz8bE0N+UB5gJgBlOK0OoHyhHcZEmGY
	h3RtCkknLIb9Oubtd6lDy+ZJWWqctxvx9CuWJvkZ7h/L3o47O3E4gPkEu6MH6qXzqW/Xd+NKJMZ
	+JrBkV1e69QpIlTU72E8yW8OFsTBvjLSKP2JI+t/d9II+Ydgl72Yy5Xfxr+6bvAKXngIhj9M2p+
	mWlzBA/Yh0se5/lIgQ5koamH9ytV09SJG0UouOCkL2+LHq6mA/CjtxPvsnh6GK8ePp0J29dI9x2
	HEx5zH1yW0GzCUeGzfdm5T4Id/qyhs1y8c51Wezlmv8eGyM=
X-Google-Smtp-Source: AGHT+IF6McnbQh6wFqQPXvb9uNHh9QHuoOtiZLei8IsNNZp+7cCLLk3SZmZx7mzv3d0IIQfqMl399A==
X-Received: by 2002:a17:907:9726:b0:aa6:b473:8500 with SMTP id a640c23a62f3a-ab6cfda4249mr2785776666b.42.1738660799938;
        Tue, 04 Feb 2025 01:19:59 -0800 (PST)
Received: from [192.168.20.51] (54-240-197-238.amazon.com. [54.240.197.238])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab6e47cf9desm904470966b.55.2025.02.04.01.19.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Feb 2025 01:19:59 -0800 (PST)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <acc56a9b-2313-43f8-8acf-9ec39a8538e8@xen.org>
Date: Tue, 4 Feb 2025 09:19:58 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v2 04/11] KVM: x86: Process "guest stopped request" once
 per guest time update
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, David Woodhouse <dwmw2@infradead.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+352e553a86e0d75f5120@syzkaller.appspotmail.com,
 Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20250201013827.680235-1-seanjc@google.com>
 <20250201013827.680235-5-seanjc@google.com>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <20250201013827.680235-5-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 01/02/2025 01:38, Sean Christopherson wrote:
> Handle "guest stopped" requests once per guest time update in preparation
> of restoring KVM's historical behavior of setting PVCLOCK_GUEST_STOPPED
> for kvmclock and only kvmclock.  For now, simply move the code to minimize
> the probability of an unintentional change in functionally.
> 
> Note, in practice, all clocks are guaranteed to see the request (or not)
> even though each PV clock processes the request individual, as KVM holds
> vcpu->mutex (blocks KVM_KVMCLOCK_CTRL) and it should be impossible for
> KVM's suspend notifier to run while KVM is handling requests.  And because
> the helper updates the reference flags, all subsequent PV clock updates
> will pick up PVCLOCK_GUEST_STOPPED.
> 
> Note #2, once PVCLOCK_GUEST_STOPPED is restricted to kvmclock, the
> horrific #ifdef will go away.
> 

:-)

> Cc: Paul Durrant <pdurrant@amazon.com>
> Cc: David Woodhouse <dwmw@amazon.co.uk>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/x86.c | 17 ++++++++++++-----
>   1 file changed, 12 insertions(+), 5 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>

