Return-Path: <kvm+bounces-46155-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B16BAB33BB
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 11:35:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 75DEA189FBB9
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 09:33:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ADDB25C80B;
	Mon, 12 May 2025 09:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fYy0luue"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B7C25D526;
	Mon, 12 May 2025 09:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747042173; cv=none; b=VKgZZIyNZv77E9qlxz0gOSQMqvag2pBsH1i45i51vykafou/o17DsRLSei0TZaaQOlaGztskGshrtNfCpQNWaptIAxMz7brjM1TxevRm7avuJriGssVBhwOp8HoUXNMtejWIT5LPbnVTzL8PNJ5ugQax2SVVdbDireC2QE7Focs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747042173; c=relaxed/simple;
	bh=uA/bjrzzQG7eMN/hwUZQzo6cKMvMjHSVAhAY1sOfp7Y=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=qqX1CqLVgY4duSs8ROhfgwyvpahmyXwoIeuMSuZuibpR8345SYDHq5JmyxUcGh33pDcN1LVNzpslp3QB1y7DUqvarQjiHl3UlyCUp8UJsDfSwQWUSwcRaYb81lOrwujmj/KLeXOAreKwyxo0Ufv/ifQmNinPLwhOuG+Ni/0X2O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fYy0luue; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-442e9c00bf4so637665e9.3;
        Mon, 12 May 2025 02:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747042170; x=1747646970; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Nd8TTTPpuhPv6JEY+T0EMF/g2hoFO/+rGDPodo/b3cE=;
        b=fYy0luueK8rU0XzqR8cnMP6jN3o61sqzjmkY0i3KROLpDvGxbmWxkqVQfzgT+xpqNh
         8nyHhXAZb34HtUstMmWo1hutuwQ74RfiKBhuwJYVycXDLrieW7ZiJw+cfvHSal7ey86a
         oDCX98K71Y41PfdnfivEEjxw6KpH9UulmSfqZOXI+DKcEObciYwvCT3TFD6cA82K98uo
         XzrTU/WRhOVfCF/UalKsTySzxy3+WfMZS7yllek0bMzyoFAv+7A9s6eyeOAGa3TKrdAt
         hu3gZtvzB+zPk7GbZjwNC+EKGdcpAmO8R+LX20ikXbRtjQLCXkWhrXVTLy6TtAwCLMWX
         5i1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747042170; x=1747646970;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nd8TTTPpuhPv6JEY+T0EMF/g2hoFO/+rGDPodo/b3cE=;
        b=D2j4IwyjoWpfcwW6F8eMPyuHmDlbPsPSYAckepJsMNSx+SKRGv6y+YMz5i3yB0t2AG
         A0HCoK0v3vdoHmoShtok6PPJs0ZHTkIomLaxY/ixAvH+cxHUYOsLLVJp/ZEC+rOyoveY
         WqHOnHlgGz0/5VJZDn+KWCKza6tBXBFgTLbWH74XmbGXefWCA5zZEMHvRT4WHfb+aoFk
         uABGgfYt4fXLnbzp4X4Pnu8mwZMNfa+8/cZy/+5OezumrBxsYl3Jpe1CyfZTIfi+F/Q4
         boQVfkWU/JLNp++5JnvCyp3iOKekDIa7aYk7qZwGdnZYXQ4p3/MGIbdpoCSJ3IMmrzM4
         kHYg==
X-Forwarded-Encrypted: i=1; AJvYcCUTJ129713dlc/7fXAgbDuTQ0Q8sd+Nxo/cd/z4dMKs289s906yY3IzMF/dBAeIxtDcbds=@vger.kernel.org, AJvYcCUee9PZC8pUq/7GefWAm6tZtH2prkpIGYcFP3A8KlS5QD/4z8pEHf+V3KkWnovWkcZOYCw59nHYGL1l6nws@vger.kernel.org
X-Gm-Message-State: AOJu0YyvGz4+lbYkixVQNPw2fH7utawQgsvQ9JZb4hvqTE7XVbW8+vlW
	RXdIHTykuxLQ20FWQYiV+/n/i/+rGfEw9f144hNb5P94IZX/Xwtf
X-Gm-Gg: ASbGnct+FpZJ0kdlW01HtMLI4u6ujUrtPZ1cJhSWlJf1TnX+tUGQFgaLk/Zo/wGBY6Q
	679wZLyHrxn2mBPLANWGXoNDQtq8R/pIuYSnDzJvhsNS+ja3INhJl6i4AimHr+qKu3e9r8pllOy
	MT3aY1R40o3pEs3pv6IV4gCwV1WViGzWDjuqqvxvndhYEGG/nFru6jeFzqP8SHcMEtZ7j1SAFjf
	FoP//zwYHzKmUUfedjG3XUxlAD5h50nPfdVFFe7tI+wF5UHHyqbkAewGx9Rq+2VsbjreyDP18Vm
	vS7LGigN2mtutYotexWV9nwE442NA1g/fxYTxgEKa9UKSfXCcJ/X38V0iIfcXgbyEE5xPlmNRRV
	sDGdwkWI=
X-Google-Smtp-Source: AGHT+IFHhb80V8vUQZEwb04PyfWMfXMEuVgvCMYP1AjbTd4plf7jZskkeNy6rkNelRjoUUpdJNmCnA==
X-Received: by 2002:a05:600c:681b:b0:43d:47e:3205 with SMTP id 5b1f17b1804b1-442d6d44d27mr96631565e9.11.1747042169128;
        Mon, 12 May 2025 02:29:29 -0700 (PDT)
Received: from [192.168.8.119] (54-240-197-238.amazon.com. [54.240.197.238])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442d14e6d74sm151355005e9.21.2025.05.12.02.29.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 May 2025 02:29:28 -0700 (PDT)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <7fedbeac-300f-48a3-9860-e05b6d286cd1@xen.org>
Date: Mon, 12 May 2025 10:29:26 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: KVM: x86/xen: Allow 'out of range' event channel ports in IRQ
 routing table.
To: David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
 Sean Christopherson <seanjc@google.com>, "Orlov, Ivan" <iorlov@amazon.co.uk>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner
 <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 linux-kernel@vger.kernel.org
References: <e489252745ac4b53f1f7f50570b03fb416aa2065.camel@infradead.org>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <e489252745ac4b53f1f7f50570b03fb416aa2065.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 08/05/2025 21:30, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> To avoid imposing an ordering constraint on userspace, allow 'invalid'
> event channel targets to be configured in the IRQ routing table.
> 
> This is the same as accepting interrupts targeted at vCPUs which don't
> exist yet, which is already the case for both Xen event channels *and*
> for MSIs (which don't do any filtering of permitted APIC ID targets at
> all).
> 
> If userspace actually *triggers* an IRQ with an invalid target, that
> will fail cleanly, as kvm_xen_set_evtchn_fast() also does the same range
> check.
> 
> If KVM enforced that the IRQ target must be valid at the time it is
> *configured*, that would force userspace to create all vCPUs and do
> various other parts of setup (in this case, setting the Xen long_mode)
> before restoring the IRQ table.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   arch/x86/kvm/xen.c | 14 ++++++++++++--
>   1 file changed, 12 insertions(+), 2 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>

