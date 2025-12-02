Return-Path: <kvm+bounces-65104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 188FDC9B6B3
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 13:03:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 6F9D1348BF6
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 12:03:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E02413115AE;
	Tue,  2 Dec 2025 12:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hlUdJ+OS";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="RBkC4VRd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 466C830FC0D
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 12:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764676980; cv=none; b=F3iZ2DRpFRULyQE9M3eK2QoHWAVvXCfwcrfat5g8HIGEflPrStvMQ2MBEF7Kpwm90HUV5CYXdoq5LuLX9AuC3fRfZonL5XpxbTJW1VTK9GrSWcdAnTzp1nIOot0BqSI7sGb6tIsBS8q2pp2oLbs/hNsHT5MqmezBGOeqOu/iaq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764676980; c=relaxed/simple;
	bh=/KPEMqnDEiAGSaN5O+8OYfieXumAwbKpkHyzDT2lSxo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LI1GmZ6iHEyg9Q7TV1TCWmSMITqd4udUsYpgaUf/7Od7A91NgeGUbGI1eEqTFxFMIARHAuG1GV93N32bbAvG4bvFwrmesZLQYkPCI5zwUTOkNLI0SIYJZcXiIvGQsW4Wj67PfEJIhz6aVhVHYxVH6MRY0zT+2gfHin6b0iGDMvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hlUdJ+OS; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=RBkC4VRd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764676977;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GGyHUUPhdZ5uvSSHXO1KoXFKVeTdFZEjpoTb5RrxTK4=;
	b=hlUdJ+OSQeMAf7I/k1CrjjFEU9X/ERrFiL1mFejVHwGlxQfwpW4y5hxwC4uleCMtnbIFQG
	AQSFVFNXmsKbk/FoTixGYsJihy6ZbhBRjVRa6dYXc8Eju5PWxJDuCTCQq25W3V2cGvnPFS
	ynlnxHVZTB9iZ/m/HYKW+TZJr8+2xLc=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-137-EM9hInsnPe2faENiG-duGg-1; Tue, 02 Dec 2025 07:02:55 -0500
X-MC-Unique: EM9hInsnPe2faENiG-duGg-1
X-Mimecast-MFC-AGG-ID: EM9hInsnPe2faENiG-duGg_1764676974
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-6417b2fae83so6048473a12.1
        for <kvm@vger.kernel.org>; Tue, 02 Dec 2025 04:02:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764676974; x=1765281774; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GGyHUUPhdZ5uvSSHXO1KoXFKVeTdFZEjpoTb5RrxTK4=;
        b=RBkC4VRdmgj9rgElWXyYlhuqSDf2W3dpKzD2sLh5wYCNARbAZBA2OBMDJSoDRY3UVf
         A2q+TvFQItX+4ABs4v833HxQLMsX+TKJLRqM0tmPFkHCoo5idoVU+UWWMlX9ixZCmtd7
         C9PzT5MtOOKqdLRHOQKfh0jT6FUW0ZmMYpseEvrqpXwyru1wk8ndgSkk4Y4PkeuThQ/8
         PQ5sujFr61XsP4gl4qGODKObEcuhP43Xp6ns62IkNMGcEPgvHVl+ZvqRTlewBQyKKx9+
         z6uULVPlh/gUrmMZVrPEwl5StYBt8+3sFMdHA+lzahmBVW5PWB/cKU8engrlnIQqORcW
         OHOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764676974; x=1765281774;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GGyHUUPhdZ5uvSSHXO1KoXFKVeTdFZEjpoTb5RrxTK4=;
        b=GPpVBWsn2DEyilGqvOmyKBFY486MqjGxmSnMDwV3BD9XOg6+MDZo4aAMvWxJDCcPbK
         /eiBZfBKk+WZR51O4Y8Wm4r4EMULXWO+USPE4n8R6RzrqTfaSoZoKrCcbb1+ielJAq/h
         I1Jzr0c7DcN+gphlwck994wy2sGxWfbH5RSkf/RAxX/Zfj/X9ErxL5i+ioPRR3LdiAML
         8odLktL73MWADoMD4KfPKrvCPD9nRY/1YcTMQvGXR3h0FlfpR7xWimGZNgHgmEJdF1DQ
         ttUxFcY0UyMLBb1RrWGbcuzVGc3CQBf2mMDQGwFCGwzkB8rjwm+ilT5V0iAHukMEH7pg
         BUJg==
X-Forwarded-Encrypted: i=1; AJvYcCWnpduHKBnOUJ3ZC5/LbVtE+q1MtVBoSVJksUGiy2EOoDjzge7l1xKkBa3G4pFBXXg2yPY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9Dgn2855j6uyf4xsaDggIcgG96bWZD5FriFXSmbpQ9j/ZEdBc
	XhTwPGe6Ct1w4P5RQw+8QPR8aJOFiohxQqfMZzNlFP6i3LX5MVvWZcFm/8GIwMqXwIz5i6I8TTk
	EolUhDen9d4P8ZZQCpnlDLRi5HE2ZRoS3NHl0cgPQ/p0ozS/Y7kwPP3Afo6jRuA==
X-Gm-Gg: ASbGnctC0m8vHCnb445TQE3QtsfGMHk2GI7kBirmQd6pqCF3+Qknk7GtOQpK76UXj1i
	xxxG1bl99FAls3ICMhNYsPeA07Ka6XpaPpsnNm0+a9nqHolfPGAX/0QQR45ztT9eOz75kk2QM72
	qW6gCYtN4uPvjA8CLNEu67tgvkdd2IpQtWeQHyVcZfMGv4X9a3xUB/93Qqym2Y6sMAz8uBy4a6S
	SmSVAVlwzrFFcP9HJF80jUzDYaWcLIopCg+XtjO5m7+YR2EKFS+qgGpueFVUE0QpuQsIUPrD55p
	3tRItCZwfOWmLgHJBj0+7tIFnIyj5oc3gVij1C46R7TfI5sHIOgs4IRjLtEtf+v9aRqXeA==
X-Received: by 2002:a05:6402:2116:b0:640:bd21:242f with SMTP id 4fb4d7f45d1cf-64554442222mr37519690a12.1.1764676974104;
        Tue, 02 Dec 2025 04:02:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFIxXTIn/JqfgO673hNmcnsCE5++mQ0b34IFuJh1hndg1oxOZzpSsOjIje7OERrDqbfDJ8rcw==
X-Received: by 2002:a05:6402:2116:b0:640:bd21:242f with SMTP id 4fb4d7f45d1cf-64554442222mr37519668a12.1.1764676973652;
        Tue, 02 Dec 2025 04:02:53 -0800 (PST)
Received: from imammedo ([213.175.46.86])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-64751061e14sm17134647a12.31.2025.12.02.04.02.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 04:02:52 -0800 (PST)
Date: Tue, 2 Dec 2025 13:02:52 +0100
From: Igor Mammedov <imammedo@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: x86: Apply runtime updates to current CPUID
 during KVM_SET_CPUID{,2}
Message-ID: <20251202130252.1f799692@imammedo>
In-Reply-To: <20251202015049.1167490-2-seanjc@google.com>
References: <20251202015049.1167490-1-seanjc@google.com>
	<20251202015049.1167490-2-seanjc@google.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon,  1 Dec 2025 17:50:48 -0800
Sean Christopherson <seanjc@google.com> wrote:

> When handling KVM_SET_CPUID{,2}, do runtime CPUID updates on the vCPU's
> current CPUID (and caps) prior to swapping in the incoming CPUID state so
> that KVM doesn't lose pending updates if the incoming CPUID is rejected,
> and to prevent a false failure on the equality check.
> 
> Note, runtime updates are unconditionally performed on the incoming/new
> CPUID (and associated caps), i.e. clearing the dirty flag won't negatively
> affect the new CPUID.
> 
> Fixes: 93da6af3ae56 ("KVM: x86: Defer runtime updates of dynamic CPUID bits until CPUID emulation")
> Reported-by: Igor Mammedov <imammedo@redhat.com>
> Closes: https://lore.kernel.org/all/20251128123202.68424a95@imammedo
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Acked-by: Igor Mammedov <imammedo@redhat.com>
Tested-by: Igor Mammedov <imammedo@redhat.com>

> ---
>  arch/x86/kvm/cpuid.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index d563a948318b..88a5426674a1 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -509,11 +509,18 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
>  	u32 vcpu_caps[NR_KVM_CPU_CAPS];
>  	int r;
>  
> +	/*
> +	 * Apply pending runtime CPUID updates to the current CPUID entries to
> +	 * avoid false positives due to mismatches on KVM-owned feature flags.
> +	 */
> +	if (vcpu->arch.cpuid_dynamic_bits_dirty)
> +		kvm_update_cpuid_runtime(vcpu);
> +
>  	/*
>  	 * Swap the existing (old) entries with the incoming (new) entries in
>  	 * order to massage the new entries, e.g. to account for dynamic bits
> -	 * that KVM controls, without clobbering the current guest CPUID, which
> -	 * KVM needs to preserve in order to unwind on failure.
> +	 * that KVM controls, without losing the current guest CPUID, which KVM
> +	 * needs to preserve in order to unwind on failure.
>  	 *
>  	 * Similarly, save the vCPU's current cpu_caps so that the capabilities
>  	 * can be updated alongside the CPUID entries when performing runtime


