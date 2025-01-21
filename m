Return-Path: <kvm+bounces-36159-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 207E8A18267
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 18:00:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 716AF16B60F
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 17:00:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F2701F4E46;
	Tue, 21 Jan 2025 17:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iXsXEzXV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF331BC2A;
	Tue, 21 Jan 2025 17:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737478812; cv=none; b=EgB1xb22GZ13uhwym+gcEAB33558Ks4aw83ucmqa7iMRYnNxvAtnpC/yxlZWZDM3dQ/LVFIJYpmsdvYitIihUUHyRuvnwQs6+wckxjKdvfDHAnN0aGnoC1tsPF/LvyeLF9yOeJA+YdWmNg2i1qVMN87RdqFgF1Q3czpAOBsJI+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737478812; c=relaxed/simple;
	bh=RLWMy3fb8mN2m6BGlWJsgW2cgAu48xtE167aXqPp4I4=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=rORqv35/9hY2DFQDHWSzqmkbxAQr0wzd9YJn5CxWhho8YxpSCEYMr2N7jjqsghOO3JC1bsDqvOKXun9ShQqB0FbsCIW+t2aZhJq+J/EHEXVgtez0+dWV6tmJiX0nDxM6vQCgnvWvh23s9fkHXGgTxJ16p5DRtdAwy0y+TQXBHb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iXsXEzXV; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4368a293339so67977375e9.3;
        Tue, 21 Jan 2025 09:00:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737478809; x=1738083609; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ahwy4GTEsJVC5MLC6+SEEv3iykhyPUsMQsNt3C6V8u0=;
        b=iXsXEzXVDScWGOuAW6RdRD/7qfDouhK+IN2pdHwEzoKzihppK9Nq9bytbfCYrjCUhN
         DwhIbQILHV00Gbfuyj+2sXtiVqej8z8OPE3inO21ONwv8zv5vI5JKB4HeMAVDm0AE0jD
         KeFLgAPxjr57IjhwGK2rRC4qBZ/UfwvAhUAcZwXjXClloYyE1dn6h1CS/dJaaYfjzxiA
         kE50ywAcs2ZmNlOTeqj3axF+M3Bp21YyVxqOU0L3wfIkKdy02biXEJ7nEyh0JrLoFBeC
         Pgdh0XOEPsJTGgRhpZeS0hR+2pst2zop2GPtTvC1vMP2j7w7Snb6lJUepNGk24hXpkNN
         K24A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737478809; x=1738083609;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ahwy4GTEsJVC5MLC6+SEEv3iykhyPUsMQsNt3C6V8u0=;
        b=P8Xsn78maHFtZj4jJFT4/iRK7PAXFrMyY21u40E3CEsCLqU9rqsPcE1sWOVP0uLP6a
         DGkd0b7Mx5xOt7ItOAy3VB65CxZx27iPH5VC3b3rfvr1GKKlcmBO3IN3yQ78kAPnjG0P
         xvoNMPZ2hj4EXmYUQuUB2UJvfh0w1Z5p3EJ2kBQVu4ck7EI6d6yYVZ/8O2daRm9/6gc9
         7mAqHUokcKFf1Z0RgZqtMxvARK+waD5EU/dkDsQFTJYROM+Z9FSEUuM5SzdCcdYkmyMN
         qyYNVy/MCiCAMb71SdPSqnFoRr2dKn9NAXlSHKUI79XnRt3qTyzZ3GiuP1GOfNq9Ih4r
         TbtQ==
X-Forwarded-Encrypted: i=1; AJvYcCUv4wePYHVTqXQ1G2Eqz4fJjohEJ80dyQTqH8kgyjadPBFwknK9ZOYya8TXzJyMZCPyLwJ9/crG7FeO5S4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXrW7ICZZOAz/WkHCLa5jBkbM4lyUmaOOyw8NYhwJfhq95R0ue
	nsLb8WNt5vNf6MraaIkuUFAAD6qnoDYwrYKxGdVfyjmhEJ2JM6Aa+v5fT7mijtk=
X-Gm-Gg: ASbGncsSpNO4HWQxO8VKHr31lINonYIjPAiXAY88LjJbmf048Wx0xvBjKpueqBqV/+Z
	31ahVhd29oPBwP2HkYyOtdXM/5sSwc8oqLMumJUpyepMYlHmkif8FkQ9Us1gFx4irmNZ4rWHOfC
	WLq5j5oe10A4obbSlKYbAJHFw+KJU8xcPDUyqzbWTwSkGzxqhnPy2zbkbBor57D706XU5RsyBjp
	MOuO1XkzMJcJ6qOCbJxkl0mFbARNCuh6C4SDv1a+V6tjfVOA4uMyJk+RwvH/luahQfP+b2feIqW
	lAmgiXoGhBURgHoWEJahGILmCA==
X-Google-Smtp-Source: AGHT+IEg+kYJkmJ8URVQIflQyX2zzeqQPtWV1Vx60P1iX5Dz7n3IiKa+WukeYr5As3URH+MR72SsRQ==
X-Received: by 2002:a05:600c:1da1:b0:434:a202:7a0d with SMTP id 5b1f17b1804b1-4389141c227mr150512065e9.22.1737478809335;
        Tue, 21 Jan 2025 09:00:09 -0800 (PST)
Received: from [192.168.19.15] (54-240-197-233.amazon.com. [54.240.197.233])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf322ace8sm13989057f8f.53.2025.01.21.09.00.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2025 09:00:08 -0800 (PST)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <49a96fbb-429a-4f0d-b904-bbdc2ad4a668@xen.org>
Date: Tue, 21 Jan 2025 17:00:07 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH 07/10] KVM: x86: Pass reference pvclock as a param to
 kvm_setup_guest_pvclock()
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, David Woodhouse <dwmw2@infradead.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+352e553a86e0d75f5120@syzkaller.appspotmail.com,
 Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20250118005552.2626804-1-seanjc@google.com>
 <20250118005552.2626804-8-seanjc@google.com>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <20250118005552.2626804-8-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18/01/2025 00:55, Sean Christopherson wrote:
> Pass the reference pvclock structure that's used to setup each individual
> pvclock as a parameter to kvm_setup_guest_pvclock() as a preparatory step
> toward removing kvm_vcpu_arch.hv_clock.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/x86.c | 14 +++++++-------
>   1 file changed, 7 insertions(+), 7 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>

