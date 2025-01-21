Return-Path: <kvm+bounces-36138-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 986E4A181A5
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 17:03:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD5933A898D
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 16:03:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 332641F4275;
	Tue, 21 Jan 2025 16:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G/TUt45k"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA611C36;
	Tue, 21 Jan 2025 16:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737475422; cv=none; b=fj4DsD5wUdueckJHqgrz/VKPvIHRk8W6kQLLO3FXgTtu0R8jJqyUuihoLT6N77jVwLspoNmkWEuQfgUfca/1V87v1xPwuFVnqEM3WDi5V389xNGhku4NexfC7KpejoN2r2BCsZlGKL5zo0MKprCWI18E/zg5C127r73amkmxrqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737475422; c=relaxed/simple;
	bh=pCUhpHMxWEADIKWObCTToTntdMVJXDGHz/mAcj03pLU=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=YszWmASdcFvA1n9F8z37TyCSlyEWgsXgL6NSJdnJV6AjyIiSNmYPY4pzwP0p7PsxLe/lR34WOjXCL+pg+uFQVZ5a6+OUEjCiLNMmOzImq438Tw0UkpYXVTVE+Zr1TsYIqrdE1K+/wTQ52bvMClNwavRCUhNLPDphj+1/yFW+YzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G/TUt45k; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-385de9f789cso4424760f8f.2;
        Tue, 21 Jan 2025 08:03:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737475419; x=1738080219; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JLgeh8AxopgEzecr0gh+CvLSZQrF5+knuOoixuGw/iI=;
        b=G/TUt45kxmeY2A1m8teDpeCVcHDkSUpswaCE7Ai/ONoZ3W/0sssebDqBTfMP4SKsm6
         UzLCiWxECgKwpdi3V8VNav+6Ok0J6MaIDeti7GTJhwOhGEFvJYjp8A309WNRo/m6YOpI
         HpXetTPDd/1nY0/wEUwV20mngr7ufZ1OvNAUHQb7j0/VDAFX0+J1p0z2VKcN8/Bwhjrz
         sKF/piEABOfooogLA5tBA5MVP9JepC1l2aNca533Kf5f7gZdeHzw+q/N8cgLPG0wEjjL
         WBcjpsqtaMkyeKwmEUcpCMenA06QxEEY17CZ0KSHGcKfTx0QPSyoDAsYbkef88x6yFgj
         BPjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737475419; x=1738080219;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JLgeh8AxopgEzecr0gh+CvLSZQrF5+knuOoixuGw/iI=;
        b=SMjktTWoEOD0auEP5mjn0fMROJljQE8I7QSrQg+IkwTlVXGBn5jj56/4dwgPGywOW2
         fzuZhNNhuQNXD79a5vAYi9xrUvJAG9pojnUZ6R9TNPmC+OiFdLix59CurooxS3DHaBRI
         FgqD9InX+4gZwt29fhPLKWgpTMeVtvKOM3+nYYmVZXEXX143QEvIZ4IDA3N7qz24j1Pc
         9Wpw3WiPGQZrLWw8xQcDc7/5A0neibFjMv9zKlt5bnAnSKs5SdLgzBIue0XB8zIuH85V
         E4SHf1i5fR51b6hggAXI2MmVsjB0i/bIMAq/bsksnbG6KHhMFWiZVnRP94AAnl6Pw4nm
         d0fg==
X-Forwarded-Encrypted: i=1; AJvYcCU+qeISz9ODiDtJ0uqEHqmw1DZA2Xd+PKR69zS5BurMZTZknyrka1psYIUPVQpDTffx1CpjcqLAdijI1fc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+eRQbCnMl+mxer0M5QkOJz7lYgCVphGcBEQbkakDgLR4y5hb9
	bEMY8tB6D2PyTD0fsSxhlzODfvvkipjTQucV4Itjd2+VprBXrfgA
X-Gm-Gg: ASbGnct/3AqvVqxmNOYkqCRyiXui02r1Ow3OHP9itfKvagK7qGGkiXihm8PtH8pTH41
	nSMC0pj21uKxcriP6pZxdeb1TGbZAP4d86D4wFePWEeiayT7VJcxHjtEDmj6XcRoyPI+48WPPAU
	0qzxSP0SxutedrRVP8Qi6p2AJcG/o1M/KmU9qj28pF5bQpwrNL2lz1EBfl1VlB+8vfVOchwu8G8
	CoU8EERPlKNITXkVWO5HB3KzWbGeenQCClx91+ZRuPGRkptxVcjUM1TLpQh+igrHbzEcJkFe8Kj
	MQBLyAeEch7IkfN084UB+mChGg==
X-Google-Smtp-Source: AGHT+IEkkOYDbrQdD4gka/7t51F+FzUy1Tk2FBaKcbHygOcVgsWxCk6UGr7WFA0d4qDSBc84m34wNQ==
X-Received: by 2002:a5d:6d88:0:b0:385:fae7:fe50 with SMTP id ffacd0b85a97d-38bf57b8085mr13767684f8f.42.1737475418568;
        Tue, 21 Jan 2025 08:03:38 -0800 (PST)
Received: from [192.168.19.15] (54-240-197-233.amazon.com. [54.240.197.233])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf327e1fdsm13943927f8f.94.2025.01.21.08.03.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2025 08:03:38 -0800 (PST)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <9d2576ce-7155-4158-bcd6-f2bd7f70b141@xen.org>
Date: Tue, 21 Jan 2025 16:03:36 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH 02/10] KVM: x86: Eliminate "handling" of impossible errors
 during SUSPEND
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, David Woodhouse <dwmw2@infradead.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+352e553a86e0d75f5120@syzkaller.appspotmail.com,
 Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20250118005552.2626804-1-seanjc@google.com>
 <20250118005552.2626804-3-seanjc@google.com>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <20250118005552.2626804-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18/01/2025 00:55, Sean Christopherson wrote:
> Drop KVM's handling of kvm_set_guest_paused() failure when reacting to a
> SUSPEND notification, as kvm_set_guest_paused() only "fails" if the vCPU
> isn't using kvmclock, and KVM's notifier callback pre-checks that kvmclock
> is active.  I.e. barring some bizarre edge case that shouldn't be treated
> as an error in the first place, kvm_arch_suspend_notifier() can't fail.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/x86.c | 20 +++++++-------------
>   1 file changed, 7 insertions(+), 13 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>

