Return-Path: <kvm+bounces-34562-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EAB01A0191C
	for <lists+kvm@lfdr.de>; Sun,  5 Jan 2025 11:58:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 85A717A1928
	for <lists+kvm@lfdr.de>; Sun,  5 Jan 2025 10:58:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60CC8148838;
	Sun,  5 Jan 2025 10:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YOF8v26H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E586F38FA3;
	Sun,  5 Jan 2025 10:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736074698; cv=none; b=tkvVJNxp9tMM64lN+GUh50SDx/+8YQFsvfe7GJucKaL8Psc1yuWUu5coOky5W6rVK16DYP9pXEL0c71/v8RukgCB0WtSlarE9k0MmEm3sPO6mm5cNqFuG9ZV5KnNCo33+5rZb0zJ3iemVQ955KSEGmj4xYoeyDM1EgrZ7HzvRhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736074698; c=relaxed/simple;
	bh=thY6qBcnz0/aOpTP9HEMSpnX7Bs9bmVdw/Dh7SnaVEs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:Content-Type:
	 MIME-Version; b=B+LQ9oVxIs905uHB1jS9X1m3MEzzSOYJ21KgQJe/Ja8xsOZFMEfz4Q9gbXv5dShzGFqEf7ee0eDr+oM9HUH/84yKHC4RKWLKHFTWp8tcpUilZCFbbzaCarKG3twAji3PTW7vGzoAAE7t1/8EzabtJX9k1ssrJUMEVCANwpQwRV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YOF8v26H; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-aa66ead88b3so145743166b.0;
        Sun, 05 Jan 2025 02:58:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736074695; x=1736679495; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pRUAU8Isybg8EugaxlOUMgNz1vyzWwhBr4xEC/ijKTc=;
        b=YOF8v26HazRUe7N/ptIOSNo6yotp7o4fhogUalwjr3BSzGzeiR2TFUp+j1MOrgM5Iz
         R4DUV/sKb1mV/Fe+mmunCXP4SIavL0t5bO73VRjI88RJnqTbdZMTs/q+unmwsMTraY9j
         xLSA68V31XOy/12lL5/+ZpGPjfNGBytkpUNlj1sTySSECM6CRQTljSW8QPIQuqRUI/vM
         1ZVvUODkfdJ6YanGv1tZ7VCRR326EbNbQ7Y5bdcDlypJYF3nYjtBgcFEPlY1G8VyZ7MV
         7FcyrxymhFKp3LQeZG45gLx8UsCiHmfQ07uSTnsxfkS06CWo9fa98obIEQNIpSVZv1N3
         fY/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736074695; x=1736679495;
        h=mime-version:user-agent:content-transfer-encoding:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pRUAU8Isybg8EugaxlOUMgNz1vyzWwhBr4xEC/ijKTc=;
        b=Q4l3w2xpgWmHUzInZc+rCBv/YIvORQqs/rEiozDjVFmUkLJEIAjRgI50ESjs5SxH+B
         xaDLoiFtNBzqYa3njkeHs4gURNFn8hhQR7bPE98RCIO8/sa9nucDT03X4mLjtNovXq/6
         gDUhfKrfmZCrTpfePm7NherDbojT9CfFGPOVp1S7Uu/LGBX22AU6Z47ziKvm/Q8rhayZ
         +lQIMydN21reMazFGDxwPgXKBZXW6H6Lcvs1zJ5EG8Vjc6rpBrkUiJNPyO0APFPTn6qh
         acLzw9XN1AUzqt5H75OW15nZIAobJE++OUY4mTd8u3doqhbX4uEw2OSWdeapg4wXhqaJ
         3Cgg==
X-Forwarded-Encrypted: i=1; AJvYcCUjIKWzTSl3dDhgTVzV3y1f0R23gaip53MIhH96TExsDpnt5jl67IWzkd1XReBGlD2wScpmclU3E/UobQVO@vger.kernel.org, AJvYcCVTTlg5lQyoXDr+IBLjgDtN094GuCFvBc32+h5Kbo15F0iiCeGkQsW3moLJwY4ePLLrxd8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3JS2q3MHTWvP15oCahcWa9VmX8mAI6AUwuTSKvONFlTh1qhFR
	aoLDUQ5kYeDr2A5IWIJahimBiflNgbz9XtyBNw0o0HQFeOeF4Dqt
X-Gm-Gg: ASbGncs/uybMUHsnou8HxsxGATsxH2uNogVRBwa8YS28V8tyQkwKdldLwkx0YhZ91DZ
	/p4VO23vowCGKqUNG3NnMNS7hDUaMWMAMZHvSRn/5AHpT361RUWemk42xX7XE5QQgTZb5bmWaPz
	NWgAZ2StCii+I1BkWAIpi7J8DHdi1vMuzVDQ4c6T4OhXgo1sVH6WhOpjy/Ho8qIVfjV4bZLHVdM
	v0KgK+jxMOOqzolbWjsgSzJBtew67UhzHRm7So5wuSq32GePDm6W47/Dpx0fUX3aC0FCvyeBrq6
	hqnPZVYtYip6UO9exCEI/x75A8sKGRZsREz5nQ==
X-Google-Smtp-Source: AGHT+IGm03C0p4x/F/DGp6iAzbrF656SnOAA1fiwYBkAJ9A7GAYoeeMf56+RYUAyjRq82amdefAO/g==
X-Received: by 2002:a17:907:360b:b0:a99:f6ee:1ee3 with SMTP id a640c23a62f3a-aac334f624amr6071985466b.43.1736074694906;
        Sun, 05 Jan 2025 02:58:14 -0800 (PST)
Received: from ?IPv6:2001:b07:5d29:f42d:5671:db52:9943:44cb? ([2001:b07:5d29:f42d:5671:db52:9943:44cb])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0e82ed65sm2096634866b.33.2025.01.05.02.58.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jan 2025 02:58:14 -0800 (PST)
Message-ID: <23ea8b82982950e171572615cd563da05dfa4f27.camel@gmail.com>
Subject: Re: [PATCH v2 11/25] KVM: TDX: Add placeholders for TDX VM/vCPU
 structures
From: Francesco Lavra <francescolavra.fl@gmail.com>
To: rick.p.edgecombe@intel.com
Cc: isaku.yamahata@gmail.com, isaku.yamahata@intel.com, kai.huang@intel.com,
  kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, 
 reinette.chatre@intel.com, seanjc@google.com,
 tony.lindgren@linux.intel.com,  xiaoyao.li@intel.com, yan.y.zhao@intel.com
Date: Sun, 05 Jan 2025 11:58:12 +0100
In-Reply-To: <20241030190039.77971-12-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On 2024-10-30 at 19:00, Rick Edgecombe wrote:
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index 766a6121f670..e6a232d58e6a 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -4,9 +4,58 @@
>  #ifdef CONFIG_INTEL_TDX_HOST
>  void tdx_bringup(void);
>  void tdx_cleanup(void);
> +
> +extern bool enable_tdx;
> +
> +struct kvm_tdx {
> +	struct kvm kvm;
> +	/* TDX specific members follow. */
> +};
> +
> +struct vcpu_tdx {
> +	struct kvm_vcpu	vcpu;
> +	/* TDX specific members follow. */
> +};
> +
> +static inline bool is_td(struct kvm *kvm)
> +{
> +	return kvm->arch.vm_type =3D=3D KVM_X86_TDX_VM;
> +}
> +
> +static inline bool is_td_vcpu(struct kvm_vcpu *vcpu)
> +{
> +	return is_td(vcpu->kvm);
> +}
> +
> +static __always_inline struct kvm_tdx *to_kvm_tdx(struct kvm *kvm)
> +{
> +	return container_of(kvm, struct kvm_tdx, kvm);
> +}
> +
> +static __always_inline struct vcpu_tdx *to_tdx(struct kvm_vcpu
> *vcpu)
> +{
> +	return container_of(vcpu, struct vcpu_tdx, vcpu);
> +}
> +
>  #else
>  static inline void tdx_bringup(void) {}
>  static inline void tdx_cleanup(void) {}
> +
> +#define enable_tdx	0
> +
> +struct kvm_tdx {
> +	struct kvm kvm;
> +};
> +
> +struct vcpu_tdx {
> +	struct kvm_vcpu	vcpu;
> +};
> +
> +static inline bool is_td(struct kvm *kvm) { return false; }
> +static inline bool is_td_vcpu(struct kvm_vcpu *vcpu) { return false;
> }
> +static inline struct kvm_tdx *to_kvm_tdx(struct kvm *kvm) { return
> NULL; }
> +static inline struct vcpu_tdx *to_tdx(struct kvm_vcpu *vcpu) {
> return NULL; }

IMO the definitions of to_kvm_tdx() and to_tdx() shouldn't be there
when CONFIG_INTEL_TDX_HOST is not defined: they are (and should be)
only used in CONFIG_INTEL_TDX_HOST code.

