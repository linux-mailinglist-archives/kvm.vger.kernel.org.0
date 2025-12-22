Return-Path: <kvm+bounces-66525-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FA3ACD745E
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 23:22:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 89A0C30A1175
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 22:18:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E67A32D0D0;
	Mon, 22 Dec 2025 22:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wy/mV6/l";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="dDTpbnnq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25EB43314C0
	for <kvm@vger.kernel.org>; Mon, 22 Dec 2025 22:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766441920; cv=none; b=AVMYO6q7noVvfOjYZ6pv8YxGgvigo93mZIMIT+8mOetha6hkZ6gP5fA5MGB/fKfvFymej6HfLnVNs/+8mBtxcCrvwZ6OH8YhrT+QZhsFe0kKSntSXB6kt5MDhaA+m05yRypB6/KP3EwrmAq5gdmFj1FYoKAykL2/IJZSX/FAOr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766441920; c=relaxed/simple;
	bh=ShsKrVUs0Qp4gdJKeq50wOl6XsfINIYaPaJYi6O5DM8=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=RQXXnES2U/jdUU+OjewFaQtaKBTI0/xe3KF28nLO0Nhxge8l2WjWUmXpNzgHHaE/cx+Hc9rqoEVigiFrGcABwA32Fsn89CFq214tBgJcPHPFXqDQRXdNi+xKjhl1tFBHAWLe89C3AgZAS1hb4RxRQOJF5o4DJ6jNILxXv4IiXsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Wy/mV6/l; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=dDTpbnnq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766441917;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LqteH3CgwCBLCmhAVjYH1gHY89FitVyyDc6ltkR1c6M=;
	b=Wy/mV6/lE4TqADSRppWEoccSaKhJE+fT2hw+/J6bTj5UaftJt+sQEYmSUCJ23BcMAtmpZ6
	Zuy+Xel6x3wTMxBqkJPm3r1H18/ekW1YsXoVLrm65AqtaewES6AshsQaZHBLHcunrqCZbc
	vRXUwL+HXBR5dD73xWO0gOclHBMKJcY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-460-ELhZJtkwMkSu8_Ud69b3HA-1; Mon, 22 Dec 2025 17:18:35 -0500
X-MC-Unique: ELhZJtkwMkSu8_Ud69b3HA-1
X-Mimecast-MFC-AGG-ID: ELhZJtkwMkSu8_Ud69b3HA_1766441914
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4788112ec09so41629155e9.3
        for <kvm@vger.kernel.org>; Mon, 22 Dec 2025 14:18:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766441914; x=1767046714; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:to:from:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LqteH3CgwCBLCmhAVjYH1gHY89FitVyyDc6ltkR1c6M=;
        b=dDTpbnnq6dBpzknqJwoY6RRL3C4cRLvjixqRZCvL9MshcAE5fA45oznllsYtlRfsxB
         Bu84Zx/JIUoxYfMwZLiN/acteeXvbIPremKkFQ3m/KcrcdGVb+1imIhltiPARQo79OlS
         EYUrhsfsg7zI73nB/+DuUuAZ23jNPK3ChSgO46BwlS9GNKeniZwtntdpf8s/i1f+saQT
         LHN/NQhmFr9mJ5DIYhxRluAXzFHTPs9ncQQzYkaRxrK/afScf/xvKr3/hbWJ9MKjjUyN
         Tvifo98py2bi2lhwVmbWwNRos/tK0qpG+N1XRBcVCqP/shsWqfXwRDhtRRpuxLjTnFbh
         0SLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766441914; x=1767046714;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LqteH3CgwCBLCmhAVjYH1gHY89FitVyyDc6ltkR1c6M=;
        b=DS2le8is8FhtRsyRnnHPFXCPCJBiyoMrRJLZyXAoutwm1UdPU4tC3UvAHar7Y3zDsv
         QEItBKfvf0QL834qu/KJKfetlt8xh0cb9K5ChtYmjNKNUbfisaK7WRCBicc8bMP3j/WG
         Xf7uvNsIaqowuDLJLDSUBUHzY0TL3VFjCBmPZzo28dqSw1ebBVSBc/oAknA27KhlmAIL
         tf2FYbeQaOSdIc+5kHABHc1B+Waamgze1tQ+U0IND/RUyHXwtQnO42ZbqEoo9MGWCI0H
         bpGcI2CLg5ir3dUuviaIABvdrJxl4hnpc3Gyv8mJJ9jWBRVhgvOtC1Etx67UyYPP1C9l
         5zAA==
X-Forwarded-Encrypted: i=1; AJvYcCXZYAlT/Xpf63fo48gMOcN6wgpeV5h2ux928a81oxIg9GU0Pgakl8qp6Of9AxOYDGxwrTY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPY1+1LCGtRUR0WQd8Y6ihL0V+vima/jCGfal5uwa9zDurul7U
	Y/xAcXNsi9Zkz8+H9XGYDhYZiC+EUvm4Kcse2ivDcey4ja0VJDM+ATrwKMEB+nR+eh7ZrUlZD6Q
	/uEoqrNe7oWuX6X3hXTU0euWkHEJPTPMymCzou+qmC50Di5t09h/t0g==
X-Gm-Gg: AY/fxX79UkKpTKxk29miohFac1NV9eN87UzK9NW70XDkW9290V7dsLHePJ5j/jqySNx
	w8fM+hX48Fl+KuFeZ16S6lhkTMda+iWKDkWQdwqF4y6yq5lvCk926WWpZqiju5pbsmaIkj/NHwF
	nmmjM1AISQzeAwk/4qwLzPxE730MtfA5aSeyHfCc1BpXGbtubnQn3hUBvBmtSzLX/NE7bScjHTc
	0Yn/a2C2Oc6EPz7cuzGpztJxAD7ZYeU/9ppvUNtDyTN9BreERBDHUpd1pAbiOQm5D5AucMCHMM0
	KyYVtYtiR4Y19JDUoekekkJLOXRmqgrAw67NjKhsuOwTs+wst5XRBWt/fF+oru0y28KheqrP4zZ
	V5B8uqPpHcKZ5F0Qb2dlf/P/PuL6H8ylKtEWfJH4X3zEaHu4yuTP7qf9SHk/bzbfi/tI8Ig0nyu
	FimGOstfFzLcpoSVg=
X-Received: by 2002:a05:600c:1ca0:b0:477:af07:dd22 with SMTP id 5b1f17b1804b1-47d195900b5mr130628195e9.28.1766441914165;
        Mon, 22 Dec 2025 14:18:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH59DzfBwKVcXwaeR0wnV+iw2v4ovL2zSMRFSbAd8cXre+qxGMxndv87s+VMoQEFSt4WPWrHg==
X-Received: by 2002:a05:600c:1ca0:b0:477:af07:dd22 with SMTP id 5b1f17b1804b1-47d195900b5mr130628045e9.28.1766441913732;
        Mon, 22 Dec 2025 14:18:33 -0800 (PST)
Received: from [192.168.10.48] ([151.95.145.106])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-47be27b28a7sm268521705e9.12.2025.12.22.14.18.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Dec 2025 14:18:33 -0800 (PST)
Message-ID: <9b01758f-4441-4f4a-9803-400a94a48e5f@redhat.com>
Date: Mon, 22 Dec 2025 23:18:32 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: kvm_fpu_get() is fpregs_lock_and_load()
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20251222213303.842810-1-pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20251222213303.842810-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/22/25 22:33, Paolo Bonzini wrote:
> The only difference is usage of switch_fpu_return() vs.
> fpregs_restore_userregs().  In turn, these are only different
> if there is no FPU at all, but KVM requires one.  Therefore use the
> pre-made export---the code is simpler and there is no functional change.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kernel/fpu/core.c | 2 +-
>   arch/x86/kvm/fpu.h         | 6 +-----
>   2 files changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
> index 3ab27fb86618..8ded41b023a2 100644
> --- a/arch/x86/kernel/fpu/core.c
> +++ b/arch/x86/kernel/fpu/core.c
> @@ -858,7 +858,6 @@ void switch_fpu_return(void)
>   
>   	fpregs_restore_userregs();
>   }
> -EXPORT_SYMBOL_FOR_KVM(switch_fpu_return);

Oops, unlike in my tree (patch to be sent tomorrow after I write a 
testcase) there's still an occurrence of switch_fpu_return() in 
vcpu_enter_guest().

Paolo

>   void fpregs_lock_and_load(void)
>   {
> @@ -877,6 +876,7 @@ void fpregs_lock_and_load(void)
>   
>   	fpregs_assert_state_consistent();
>   }
> +EXPORT_SYMBOL_FOR_KVM(fpregs_lock_and_load);
>   
>   #ifdef CONFIG_X86_DEBUG_FPU
>   /*
> diff --git a/arch/x86/kvm/fpu.h b/arch/x86/kvm/fpu.h
> index f898781b6a06..b6a03d8fa8af 100644
> --- a/arch/x86/kvm/fpu.h
> +++ b/arch/x86/kvm/fpu.h
> @@ -149,11 +149,7 @@ static inline void _kvm_write_mmx_reg(int reg, const u64 *data)
>   
>   static inline void kvm_fpu_get(void)
>   {
> -	fpregs_lock();
> -
> -	fpregs_assert_state_consistent();
> -	if (test_thread_flag(TIF_NEED_FPU_LOAD))
> -		switch_fpu_return();
> +	fpregs_lock_and_load();
>   }
>   
>   static inline void kvm_fpu_put(void)


