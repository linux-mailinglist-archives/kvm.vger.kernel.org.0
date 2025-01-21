Return-Path: <kvm+bounces-36157-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DC67A18253
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 17:54:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 241613A2772
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 16:54:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F82E1F4E32;
	Tue, 21 Jan 2025 16:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DWTshiM3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2D7192D70;
	Tue, 21 Jan 2025 16:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737478454; cv=none; b=Sh0uwQx8ZiWujcorNG0PMdP0DjM+v5vAHrIQT8Hd/WiHyL/jJ+w75qA2m5v5XiXWCUNxvF7uJWLW/fmgZkcHj8uvr/GtckZbSeSeMQWL4keFiWngRPxujTCZDN8qSzeMXSpSoAoUD6DKfolmMc79NiFtW5NboP9WjJlyphqRlN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737478454; c=relaxed/simple;
	bh=kg/kBkGNkFYhiKJ2nHd5EYKfnPTPudIvwmBCWw4IOTk=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=oJjrbg4tHF1SXfw0LyHw33zHnvdwklMQNKVh2FnupwCtmtQr8hFCg6/yoz2xkuOimFQ5Q/kQ4xNdBfo9vC/7bINh23r1et+Bep9XdLpZ/KDlwyM+V84gs0LNqFZXtJ1GEzI/9E5h2u5pvHCzcysPE7JSPSUiykkbHeIbpzdjDhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DWTshiM3; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-436326dcb1cso41608955e9.0;
        Tue, 21 Jan 2025 08:54:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737478451; x=1738083251; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ArjOxIvlgsTQl/WUuSIjkR5VJvFPG+rZLqQWDeFweCc=;
        b=DWTshiM3OGACDLS1/yyCzHEb/olnVOY+Tcuf6tA/ZNrRQHrkXiKErK2nik2h+5+CGl
         FFxg0LjdK3wkkxKzaSZInignTuhInlHNs6lu5h3j+g8e79oOLdEQ/UEPKcpGXKDSbgJh
         LZPyJPvQFFv9i6DQJKUacQjV4ObaWmryvPnHLRErGDspdBoyRIjCpOuEY3/nl94nTNSw
         ogoGmRFgYEIkh4btduDu0GcC0H2c7hlNMza2eQjrZHRdmZbKWa4SZ45mC5b0NcAWv/Rz
         jXDeyWfbAhyl/1V64FNgqtCwqZ0vCfzi+fsmEulN87sxBE/LfVnsqD9xlR+XOSoMU2Iw
         Xd6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737478451; x=1738083251;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ArjOxIvlgsTQl/WUuSIjkR5VJvFPG+rZLqQWDeFweCc=;
        b=O7WJ+THjdRem10IAD8L5jVz+mqEBLl1u1gTKnYRWtCOdsptcgwFfWLKN45QobWdTdq
         A56eyKmYd2uluiZEANnomDD0629UoUwzv2Q4qdaxeA1hkUhvSVmSGSzr1P94VbX2b1Md
         YpKdnVtS+FczdgZNEGVGnQjkKUlKkpfJ1b/6GMD9f1lRcWABqUtiY4KeVqJ5e0aeEGun
         PdtxFUUWH0SstWI6JimYe9PaEaAH72v2nKCRvrZ6yy+cBv2NATL2husnjuEKYXK/kCkl
         WGRD0IcPDJiVTEOGmvSna8J1zlImjaocMnrK8PQDwusi06gWYSJ8v9QVqwvESUDnrChF
         dOQA==
X-Forwarded-Encrypted: i=1; AJvYcCX3c3g8Z0EnKF3Nw6SF57bnCeF6tbm3WNNPeE6ipo2feNm57bbie1yC64FWp47j6ckAPCxCc9PPykSfy4s=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywd44KWEPz3xVVCqaoyuAWhnZnQqPXCw6EDWynLYR7Z07PKg5Xw
	ItMNl0tHH3CuUEho/yaekhcxRYbimmvqzV6qEJSA6yob/Iv7Bw+2
X-Gm-Gg: ASbGncs5JiWT+L0MmBGsJjpbSKerae+SsUIzSxBbYtb+5viKlwPT5AxG3FQ6IIATdvW
	nTGT0/g8cPQSVgHIul7ub1+B0nvyRq7AQat+p5t1SwgffKQZPcj7Xk9ZmNnLf4Tn0XgBGbR0Z9u
	9yeMjZFL4/C0lg3ifaOcr9R5qLHwZa4PHdCKj8koRbleZTcU/vxI/vVKQMTfJFeBiKfqvI7/X2Y
	1IluR/8xQbeaQzH61pFNyTMSP7mwS0VUEe/pAaossFxQcjJmowduzjoSRxSvxhN+6kOjHUsdVeC
	mZyKK/Ybg+aQuZCQ8AkoFyvemg==
X-Google-Smtp-Source: AGHT+IECnAhL6lLvWH7fE+GOxM01sNgcJ12kcjcE+1Qpm8wXiLUyFXBKxxWzTOqkT0hH5GDmP9FFIA==
X-Received: by 2002:a05:600c:1ca7:b0:431:44fe:fd9f with SMTP id 5b1f17b1804b1-4389142776dmr164985895e9.23.1737478451020;
        Tue, 21 Jan 2025 08:54:11 -0800 (PST)
Received: from [192.168.19.15] (54-240-197-233.amazon.com. [54.240.197.233])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-437c74c4751sm242672905e9.19.2025.01.21.08.54.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2025 08:54:10 -0800 (PST)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <30fb80cb-7f4b-4abe-8095-c9b029013923@xen.org>
Date: Tue, 21 Jan 2025 16:54:09 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH 05/10] KVM: x86: Don't bleed PVCLOCK_GUEST_STOPPED across
 PV clocks
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, David Woodhouse <dwmw2@infradead.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+352e553a86e0d75f5120@syzkaller.appspotmail.com,
 Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20250118005552.2626804-1-seanjc@google.com>
 <20250118005552.2626804-6-seanjc@google.com>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <20250118005552.2626804-6-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18/01/2025 00:55, Sean Christopherson wrote:
> When updating a specific PV clock, make a full copy of KVM's reference
> copy/cache so that PVCLOCK_GUEST_STOPPED doesn't bleed across clocks.
> E.g. in the unlikely scenario the guest has enabled both kvmclock and Xen
> PV clock, a dangling GUEST_STOPPED in kvmclock would bleed into Xen PV
> clock.

... but the line I queried in the previous patch squashes the flag 
before the Xen PV clock is set up, so no bleed?

> 
> Using a local copy of the pvclock structure also sets the stage for
> eliminating the per-vCPU copy/cache (only the TSC frequency information
> actually "needs" to be cached/persisted).
> 
> Fixes: aa096aa0a05f ("KVM: x86/xen: setup pvclock updates")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/x86.c | 13 ++++++++-----
>   1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3c4d210e8a9e..5f3ad13a8ac7 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3123,8 +3123,11 @@ static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
>   {
>   	struct kvm_vcpu_arch *vcpu = &v->arch;
>   	struct pvclock_vcpu_time_info *guest_hv_clock;
> +	struct pvclock_vcpu_time_info hv_clock;
>   	unsigned long flags;
>   
> +	memcpy(&hv_clock, &vcpu->hv_clock, sizeof(hv_clock));
> +
>   	read_lock_irqsave(&gpc->lock, flags);
>   	while (!kvm_gpc_check(gpc, offset + sizeof(*guest_hv_clock))) {
>   		read_unlock_irqrestore(&gpc->lock, flags);
> @@ -3144,25 +3147,25 @@ static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
>   	 * it is consistent.
>   	 */
>   
> -	guest_hv_clock->version = vcpu->hv_clock.version = (guest_hv_clock->version + 1) | 1;
> +	guest_hv_clock->version = hv_clock.version = (guest_hv_clock->version + 1) | 1;
>   	smp_wmb();
>   
>   	/* retain PVCLOCK_GUEST_STOPPED if set in guest copy */
> -	vcpu->hv_clock.flags |= (guest_hv_clock->flags & PVCLOCK_GUEST_STOPPED);
> +	hv_clock.flags |= (guest_hv_clock->flags & PVCLOCK_GUEST_STOPPED);
>   
> -	memcpy(guest_hv_clock, &vcpu->hv_clock, sizeof(*guest_hv_clock));
> +	memcpy(guest_hv_clock, &hv_clock, sizeof(*guest_hv_clock));
>   
>   	if (force_tsc_unstable)
>   		guest_hv_clock->flags &= ~PVCLOCK_TSC_STABLE_BIT;
>   
>   	smp_wmb();
>   
> -	guest_hv_clock->version = ++vcpu->hv_clock.version;
> +	guest_hv_clock->version = ++hv_clock.version;
>   
>   	kvm_gpc_mark_dirty_in_slot(gpc);
>   	read_unlock_irqrestore(&gpc->lock, flags);
>   
> -	trace_kvm_pvclock_update(v->vcpu_id, &vcpu->hv_clock);
> +	trace_kvm_pvclock_update(v->vcpu_id, &hv_clock);
>   }
>   
>   static int kvm_guest_time_update(struct kvm_vcpu *v)


