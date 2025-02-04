Return-Path: <kvm+bounces-37204-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C7C1FA269D7
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 02:30:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D56F3A5082
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 01:30:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67656132117;
	Tue,  4 Feb 2025 01:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NNhV7x5e"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A003278F30
	for <kvm@vger.kernel.org>; Tue,  4 Feb 2025 01:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738632620; cv=none; b=dQJcKytL/FJnP5JlqC+kxSQ+3e0y83VsxiI9dzvPLj6bN3CCkAKk/CmZA6IfT2WXm6pXR1e8iqzeWSaMnjKgFTU9c/bVyeBtpkITF2TLfaCvpU9Rgqy25XL+TOh0pOMFABr+Yjr/tpXDmZxxfxo6fQY/SzucdHrH4YV0R3cG8GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738632620; c=relaxed/simple;
	bh=N6TvDM0nH2INUzLNGVXaAxn7onjgXAPxe6GC5SoRom8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XM8nSnvCkh0RKyDBEfFlrNtg3gUldFtEczgMR2GLs0w4N0HJfaDY96J6EidwqGyJIBvMBYFkZhvgQq543S/KL/F6eyZXpFKwUar4K2RB5YIC1f1PVRUCWpj7e2W2IEO86K0pAl0UE+q1S9I50ypVcuxozVe7Ew+hUcpg2f/5Sjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NNhV7x5e; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738632617;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kEtPGmySAsT90Cn4z+YrK/aQ/5zLEgEGFrzIckWzW40=;
	b=NNhV7x5e1Rev6wqcL0ia0PdViqOX4adLiRgWZ7ft32WvqwBu2x9FIknDlH6QVIE32e3DgP
	ZbqVoz8zKhRsbtiHr5p2O/Wa5QcKE5UkWefn5ERRhPAHydosKXrx3u6rRAFzrwrUvcHUq6
	5NJocy5Mkb9+H1zyD/UkXzPMPW5ymdI=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-524-AwiESx__NkexG2CFgko14Q-1; Mon, 03 Feb 2025 20:30:15 -0500
X-MC-Unique: AwiESx__NkexG2CFgko14Q-1
X-Mimecast-MFC-AGG-ID: AwiESx__NkexG2CFgko14Q
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-7b6f1595887so814636085a.1
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2025 17:30:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738632615; x=1739237415;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kEtPGmySAsT90Cn4z+YrK/aQ/5zLEgEGFrzIckWzW40=;
        b=WaBXPAhfox9di0sErYZRKzOzKEuuo99W/8Pi78iACaQ0FYan24+jrqb2X4pEluRiGS
         5KDW4saN5fQN2S4T97skcZKBwEcuyq7D4R6POdzhKXWJnXZm5/P1o0+e/4fbbNqSyFYj
         NNDwCYnSHLjOMRFUBmaTAl0u+IwY5KrWNmqYAlzAF5kDpCCKHAxuAas/oIxJozYnI8a3
         LLGhKgv4hHGk8GYTsdyfdzNbYTnE3Di6J0uT1hixn+beWEmuyetIcL+IeHyVv8tvjTGC
         LPEb5po8F63i1sG87f4J7ITEQEfOUSmfcY+B9PBJl4Jq7AvSFJW7gNk2kw5e4LoluvPQ
         sCsQ==
X-Forwarded-Encrypted: i=1; AJvYcCVvxOro5WXTq8/oDRKBofxG2qRRtBgxnQF1KATaVnqnClmSzHbXmoUOR3XSoI03lKFeTSE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZB5cvW+gDHExBE5tfGMJen70iu/04ZFri4w4jQJ83K8+Lgduz
	7q0AP3YvBb9LwZcn4cXNNj5Ze3ofH0q2eLeHN7xV63Jb5EmUymCb9L6iE/MLh9Pzx07+vp52vyM
	rFf4UoXBqdGZs4NK+OllKvm5eHfHHB8CV569MtGTEEzt6mckLNAh4uRMzuw==
X-Gm-Gg: ASbGncug6/6EQ5Cq0tfi5JvpvC/MgrKBT2VrCRd8HsEFf79h4VF17Fp4Hv6BLwk/R2X
	C9ZCB1Vc8V3uWkL3iqlbxuu0zoVm0i3l4U5qbqy2eAGHDiVvuHtNO2EnXgFLdKVjNzRHeNoJpLS
	hMPWa2Mc2qKVw5IPguwpTj8xisd1v9YObcsHVxQOvKvucnZbSoumt48ayivqpp2orSuR3ZmXpXk
	bwkb08LSRAAzphBQUJE/jjonwu+RSmVfLANRpEUAZq8Et+bGzRi98GMXecEwAvDteZG2Vy4FjR4
	xFKj
X-Received: by 2002:a05:620a:d8d:b0:7b6:d026:293 with SMTP id af79cd13be357-7bffccc5cf2mr3294138985a.9.1738632615177;
        Mon, 03 Feb 2025 17:30:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGlYIWzD9OzwmupzIB0M8wCq/FE/w99pzSNI+Y/G8BzsEVGCc3Nn2YWiDO+Q8F6Zyh0IV6L/g==
X-Received: by 2002:a05:620a:d8d:b0:7b6:d026:293 with SMTP id af79cd13be357-7bffccc5cf2mr3294135585a.9.1738632614765;
        Mon, 03 Feb 2025 17:30:14 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c00a9205f4sm588926385a.114.2025.02.03.17.30.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2025 17:30:14 -0800 (PST)
Message-ID: <dc784d6e4f6c4478fc18e0bc2d5df56af40d0019.camel@redhat.com>
Subject: Re: [PATCH 1/3] KVM: x86: hyper-v: Convert synic_auto_eoi_used to
 an atomic
From: Maxim Levitsky <mlevitsk@redhat.com>
To: "Naveen N Rao (AMD)" <naveen@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  Suravee Suthikulpanit
 <suravee.suthikulpanit@amd.com>, Vasant Hegde <vasant.hegde@amd.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
Date: Mon, 03 Feb 2025 20:30:13 -0500
In-Reply-To: <3d8ed6be41358c7635bd4e09ecdfd1bc77ce83df.1738595289.git.naveen@kernel.org>
References: <cover.1738595289.git.naveen@kernel.org>
	 <3d8ed6be41358c7635bd4e09ecdfd1bc77ce83df.1738595289.git.naveen@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Mon, 2025-02-03 at 22:33 +0530, Naveen N Rao (AMD) wrote:
> apicv_update_lock is primarily meant for protecting updates to the apicv
> state, and is not necessary for guarding updates to synic_auto_eoi_used.
> Convert synic_auto_eoi_used to an atomic and use
> kvm_set_or_clear_apicv_inhibit() helper to simplify the logic.
> 
> Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
> ---
>  arch/x86/include/asm/kvm_host.h |  7 ++-----
>  arch/x86/kvm/hyperv.c           | 17 +++++------------
>  2 files changed, 7 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 5193c3dfbce1..fb93563714c2 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1150,11 +1150,8 @@ struct kvm_hv {
>  	/* How many vCPUs have VP index != vCPU index */
>  	atomic_t num_mismatched_vp_indexes;
>  
> -	/*
> -	 * How many SynICs use 'AutoEOI' feature
> -	 * (protected by arch.apicv_update_lock)
> -	 */
> -	unsigned int synic_auto_eoi_used;
> +	/* How many SynICs use 'AutoEOI' feature */
> +	atomic_t synic_auto_eoi_used;
>  
>  	struct kvm_hv_syndbg hv_syndbg;
>  
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 6a6dd5a84f22..7a4554ea1d16 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -131,25 +131,18 @@ static void synic_update_vector(struct kvm_vcpu_hv_synic *synic,
>  	if (auto_eoi_old == auto_eoi_new)
>  		return;
>  
> -	if (!enable_apicv)
> -		return;
> -
> -	down_write(&vcpu->kvm->arch.apicv_update_lock);
> -
>  	if (auto_eoi_new)
> -		hv->synic_auto_eoi_used++;
> +		atomic_inc(&hv->synic_auto_eoi_used);
>  	else
> -		hv->synic_auto_eoi_used--;
> +		atomic_dec(&hv->synic_auto_eoi_used);
>  
>  	/*
>  	 * Inhibit APICv if any vCPU is using SynIC's AutoEOI, which relies on
>  	 * the hypervisor to manually inject IRQs.
>  	 */
> -	__kvm_set_or_clear_apicv_inhibit(vcpu->kvm,
> -					 APICV_INHIBIT_REASON_HYPERV,
> -					 !!hv->synic_auto_eoi_used);
> -
> -	up_write(&vcpu->kvm->arch.apicv_update_lock);
> +	kvm_set_or_clear_apicv_inhibit(vcpu->kvm,
> +				       APICV_INHIBIT_REASON_HYPERV,
> +				       !!atomic_read(&hv->synic_auto_eoi_used));

Hi,

This introduces a race, because there is a race window between
the moment we read hv->synic_auto_eoi_used, and decide to set/clear the inhibit.

After we read hv->synic_auto_eoi_used, but before we call the kvm_set_or_clear_apicv_inhibit,
other core might also run synic_update_vector and change hv->synic_auto_eoi_used, 
finish setting the inhibit in kvm_set_or_clear_apicv_inhibit,
and only then we will call kvm_set_or_clear_apicv_inhibit with the stale value of hv->synic_auto_eoi_used and clear it.

IMHO, knowing that this code is mostly a precaution and that modern windows doesn't use AutoEOI
(at least when AutoEOI deprecation bit is set), instead of counting, we can unconditionally
inhibit the APICv when the guest attempts to use AutoEOI once.
But as usual I won't be surprised that this breaks *some* old and/or odd windows versions.

Best regards,
	Maxim Levitsky





>  }
>  
>  static int synic_set_sint(struct kvm_vcpu_hv_synic *synic, int sint,





