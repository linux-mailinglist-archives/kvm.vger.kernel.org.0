Return-Path: <kvm+bounces-51988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BF51BAFF07E
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 20:08:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8D1771896D4C
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 18:09:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEB0D238173;
	Wed,  9 Jul 2025 18:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FSKbYKng"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368376BFCE
	for <kvm@vger.kernel.org>; Wed,  9 Jul 2025 18:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752084528; cv=none; b=lpsyPmpi582zVm/ZKlv+46jDxgNiFslShXly/i4eWYKoFbnb8qCl7Z6bK4i9pVGEq7ZQ1C5MllRuiiv60cbpa57W0SIl0+ofRq6NXd6cF9RfD18SKATnMabBD4iSGQCckekG+uqM9M7HVSFIda5YnMfPhvKBimjXHRUgTRSyOeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752084528; c=relaxed/simple;
	bh=NXywK+mmTCoC0aABwmr6OWQXb1nFsypL1uvzFH6uyJ8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GSZr95zBdmMHIvqUUi/jREOumY7/7Vs5okYHuf4oMnrSxMzKMssDEGMA9OMe0i5bxu6CsBwug4Kz1gBkj0F6nrhVkB6cZpJZDuC/Q9wdVAsAGrtjKSaglnFyAM7oiDE7jJ2qto0owbxH6EWcYQRpp5sgKtpbAp5azJJ2sfL+WlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FSKbYKng; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752084525;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ti4LPRIkFOCBWTQGffTOlaGCCCvOPm5j4OoCEyc4FiI=;
	b=FSKbYKngY37bGFQiPjZeYFlI5t0CdKUCJVnZf8jL5Kuh5qCLqKLHi1JjqgOztjdjUIktPg
	IPYnnxwcAI84ZRiFXjOp1gnIL+H785SB+XvxKTCa6HQq8wRkxKmyI9+vr7/1idX1kQb3WV
	hDkubBWig9DIZF0aLo24jh2acXalKNk=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-617-l-GX5thPMEy93vZQQxMzqA-1; Wed, 09 Jul 2025 14:08:44 -0400
X-MC-Unique: l-GX5thPMEy93vZQQxMzqA-1
X-Mimecast-MFC-AGG-ID: l-GX5thPMEy93vZQQxMzqA_1752084523
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6fad8b4c92cso4540326d6.0
        for <kvm@vger.kernel.org>; Wed, 09 Jul 2025 11:08:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752084523; x=1752689323;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ti4LPRIkFOCBWTQGffTOlaGCCCvOPm5j4OoCEyc4FiI=;
        b=A4JOl5FX+YWIrmJ1P8iGHQkzYSLTozozY6qaQU0+8A5BDAfUI7C3A4F3DpSpHJN710
         X9xVQFR/B7NBgrSGHGuFV0sVmOC8LefdcV6M8P71yKeL1YQR7OETmglZlHBHpgsEbDsp
         ggv7rdKh5zK7cldBfs1D67JtE91/BXGWc2gedJNS0MI+Y1/Gi04Y5aoY8isYwKTlRAEt
         jUir8ggggwH5arqFonvTQzciZiPEJ6A8aQpAf0mBtBseDIg5crsY1VKXhmPWC+O2CEKP
         X/xFEYgR90lFHpFA4Omv4fFo7Y2g5g2sx8BDd7C84igRcVh9BIZ6B4sPFjMB5mImTq6t
         8NEg==
X-Forwarded-Encrypted: i=1; AJvYcCWcPIsvN51HKYO4eG9pd6nenjg18S9mAqbwmhPvmhWruBnHot9nFvX8OMhbcugsLxghiME=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWrQ3EYYNAcinf1jSufiV6N8jHnyZNsaTIIcveVENw4NXNVqjZ
	XO8Gujy2IH4ajGYllEO1tz6kzSCFlDuggbHk/S8NGSSx/qJ5lLL+u9AXkccodlSqMEq2PnQX4Pp
	CCbhbh9uDBSupFvq4Jk79j5JreXuQQwnK/BGNx4Gcfb76PdhYuXG56Q==
X-Gm-Gg: ASbGncuDO3c281baWsUNVr+tUznbSxwXhGebQDop9AHwi8NZd8J40S3ZG0or7gbMTxw
	A0Xlq8/pKLoE0i63xvvM7Nay2uRM8voQBYABC1ZZrQ9E6oMU9/DzZ8KQk1ud1487LTGpEaLWzZi
	rQSK4IOHry/Wizjwfr3YNtegoiiXPc8Fe/Wnqqn2b7NALk5fYHcMOdArNVc9Mt+sqvE7Wvljvz/
	EC3U+2HZbLlrnmevEsRdtuK6oU2mixCh/8GKKqIrBJyKMMitq4S/d8E8+63mnq4iei1zMFxBAVV
	uepJRbaeW6UDnlki18Qgb7gmx3HykFDc2tGhfK5awW8KNjcUyIneDhWmkklpjDMMSbxZ7w==
X-Received: by 2002:a05:6214:5348:b0:6f5:38a2:52dd with SMTP id 6a1803df08f44-70494fc0484mr15861416d6.31.1752084523541;
        Wed, 09 Jul 2025 11:08:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHdeh1IV3HqtvPQTQBkoZdbTuvrxmYPDkFZPidpfSSKad4eN0FUqT4oCVisBNXt8dFjIl6NnQ==
X-Received: by 2002:a05:6214:5348:b0:6f5:38a2:52dd with SMTP id 6a1803df08f44-70494fc0484mr15860996d6.31.1752084523176;
        Wed, 09 Jul 2025 11:08:43 -0700 (PDT)
Received: from ?IPv6:2607:fea8:fc01:8d8d:5c3d:ce6:f389:cd38? ([2607:fea8:fc01:8d8d:5c3d:ce6:f389:cd38])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7d5dbd950a4sm975443185a.24.2025.07.09.11.08.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jul 2025 11:08:42 -0700 (PDT)
Message-ID: <dfd970bb10235adfa2b2b545ea26bffba1ea3a66.camel@redhat.com>
Subject: Re: [PATCH] KVM: x86: avoid underflow when scaling TSC frequency
From: mlevitsk@redhat.com
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Cc: Yuntao Liu <liuyuntao12@huawei.com>, Sean Christopherson
 <seanjc@google.com>
Date: Wed, 09 Jul 2025 14:08:42 -0400
In-Reply-To: <20250709175303.228675-1-pbonzini@redhat.com>
References: <20250709175303.228675-1-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 (3.52.4-2.fc40) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2025-07-09 at 13:53 -0400, Paolo Bonzini wrote:
> In function kvm_guest_time_update(), __scale_tsc() is used to calculate
> a TSC *frequency* rather than a TSC value.=C2=A0 With low-enough ratios,
> a TSC value that is less than 1 would underflow to 0 and to an infinite
> while loop in kvm_get_time_scale():
>=20
> =C2=A0 kvm_guest_time_update(struct kvm_vcpu *v)
> =C2=A0=C2=A0=C2=A0 if (kvm_caps.has_tsc_control)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 tgt_tsc_khz =3D kvm_scale_tsc(tgt_tsc_khz,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 v->arch.l1_tsc_scaling_=
ratio);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __scale_tsc(u64 ratio, u64 tsc=
)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ratio=3D122380531,=
 tsc=3D2299998, N=3D48
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ratio*tsc >> N =3D=
 0.999... -> 0
>=20
> Later in the function:
>=20
> =C2=A0 Call Trace:
> =C2=A0=C2=A0 <TASK>
> =C2=A0=C2=A0 kvm_get_time_scale arch/x86/kvm/x86.c:2458 [inline]
> =C2=A0=C2=A0 kvm_guest_time_update+0x926/0xb00 arch/x86/kvm/x86.c:3268
> =C2=A0=C2=A0 vcpu_enter_guest.constprop.0+0x1e70/0x3cf0 arch/x86/kvm/x86.=
c:10678
> =C2=A0=C2=A0 vcpu_run+0x129/0x8d0 arch/x86/kvm/x86.c:11126
> =C2=A0=C2=A0 kvm_arch_vcpu_ioctl_run+0x37a/0x13d0 arch/x86/kvm/x86.c:1135=
2
> =C2=A0=C2=A0 kvm_vcpu_ioctl+0x56b/0xe60 virt/kvm/kvm_main.c:4188
> =C2=A0=C2=A0 vfs_ioctl fs/ioctl.c:51 [inline]
> =C2=A0=C2=A0 __do_sys_ioctl fs/ioctl.c:871 [inline]
> =C2=A0=C2=A0 __se_sys_ioctl+0x12d/0x190 fs/ioctl.c:857
> =C2=A0=C2=A0 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
> =C2=A0=C2=A0 do_syscall_64+0x59/0x110 arch/x86/entry/common.c:81
> =C2=A0=C2=A0 entry_SYSCALL_64_after_hwframe+0x78/0xe2
>=20
> This can really happen only when fuzzing, since the TSC frequency
> would have to be nonsensically low.
>=20
> Fixes: 35181e86df97 ("KVM: x86: Add a common TSC scaling function")
> Reported-by: Yuntao Liu <liuyuntao12@huawei.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
> =C2=A0arch/x86/kvm/x86.c | 4 +++-
> =C2=A01 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b58a74c1722d..de51dbd85a58 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3258,9 +3258,11 @@ int kvm_guest_time_update(struct kvm_vcpu *v)
> =C2=A0
> =C2=A0	/* With all the info we got, fill in the values */
> =C2=A0
> -	if (kvm_caps.has_tsc_control)
> +	if (kvm_caps.has_tsc_control) {
> =C2=A0		tgt_tsc_khz =3D kvm_scale_tsc(tgt_tsc_khz,
> =C2=A0					=C2=A0=C2=A0=C2=A0 v->arch.l1_tsc_scaling_ratio);
> +		tgt_tsc_khz =3D tgt_tsc_khz ? : 1;
> +	}
> =C2=A0
> =C2=A0	if (unlikely(vcpu->hw_tsc_khz !=3D tgt_tsc_khz)) {
> =C2=A0		kvm_get_time_scale(NSEC_PER_SEC, tgt_tsc_khz * 1000LL,

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


