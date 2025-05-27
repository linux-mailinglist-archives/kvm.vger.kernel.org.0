Return-Path: <kvm+bounces-47751-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 408FEAC47AF
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 07:39:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E16353B8F3A
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 05:39:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23AD91D63F2;
	Tue, 27 May 2025 05:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="Q+hZRb0q"
X-Original-To: kvm@vger.kernel.org
Received: from out162-62-57-87.mail.qq.com (out162-62-57-87.mail.qq.com [162.62.57.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BE5288DB;
	Tue, 27 May 2025 05:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748324387; cv=none; b=IUdgvlIW5C3JuM48QhlSJLTxApn3fWzSVHVFlwaTFrckM5Ivm0KhmBje4AUvbvxCGiXnqx5sA4SrtH+sHNoLm1QvSJYQ1ovfi67G8i+GIT7G+J/GvjgwQW35T3kDqjalJsg049CX4YLCu7w7uYUnjNdASAVlt6hnx48Z3LxRCUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748324387; c=relaxed/simple;
	bh=JCFELZchaFfcJLufSBNxjnOuDrNJRz/rxss5QU+zBKo=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=KlTAlzLQqOzfhfssZpptimVia1/9uscaiOJbIKmAOS0MWIwOQghDbSjj97okJTGskU9fiodYvmVK/lGgWjeB1mMfqQ3efeUCuVF0Op4k2kVZ5yx9GQ/QJ+ArDfGxJO2nxJRyilKyGVyOYLRr6jipNt8IAxNwhthHZbnH0IFUUXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=Q+hZRb0q; arc=none smtp.client-ip=162.62.57.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1748324361; bh=XRx5croEO105UnrtvQ18h1ZACkdqJq5uSEbMB1ZkDsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q+hZRb0q+iESdQwX0RaKZc/J2gplMb5TyzLsCD+muqbeolvRqQxf0VFGVBoVEoXVL
	 XJU5uDS0UszBEYg18Q548Is3kJml/wvUjW432BEHVBWPmB8TQ0CaYf0ZKOTazK2AGb
	 XZjH2INEXtG3ynYuEoK6aeYF/MlKiPVgq8eQSYz4=
Received: from pek-lxu-l1.corp.ad.wrs.com ([111.198.228.63])
	by newxmesmtplogicsvrszgpua8-0.qq.com (NewEsmtp) with SMTP
	id 9D214897; Tue, 27 May 2025 13:39:18 +0800
X-QQ-mid: xmsmtpt1748324358tpjxhpn9g
Message-ID: <tencent_69BAA5BB0A332E9E391B034B761B7425E608@qq.com>
X-QQ-XMAILINFO: NsLYjltVP0elzjyx2d9ngApaBBXjuj/fhJHAl+KxYOzpPDLzZSrSjmCfDFhcDc
	 1z4Xm4z3DtdN1suqGH4lVhtHasVKc4Ylk/30eE8M0XXWuFLXi66K9StjQJlZaLZaFdHXoR82VeqE
	 7XT8pvQo7Cue5UD4lPU27xcxL0ucAkTMGMbmiZeYTM/bXWdTz4mMKqCcyXX9W2cH3VgMAVS/cafa
	 9mkOXaiOHxFruJH74lBjq5Y6DdGjHtP6N4E6jBm1WVB4lQew+8kbbUA+XZM3ODmFORutKJH6aHoQ
	 q4agaokpzwOFkIPzn2gpg9AREsZXGi1l3j2EhIwrYGvtUp29gOZcZ3CWDvqKRtJWzf/DtXIzRsq9
	 yiJwQuHDcitq3Jo/dGC+EtiClpa1HM+hgITzjB7IuhgoV+ZjGyiT+EO8YGDptfFyHJwEkrJHLy8r
	 woGyVgmIXN3qyqBqY8HeHKkykRT7HKcFaRkbqBRs7pDtC5fGSj4l5X6T4K4RYcPHZjDtuHeYKAcO
	 SBpkBobtrPuw5FkLNY62y1mJz/4Xhu7SEz5EXRlRxgKkRjRZUHQ5cF6En/CN9PYuJphunTAG9OYs
	 GXBdTwDphU5sTLfyJ8IoNxoE3oW/lk9v8/tAe5YvH/zsu0Q+f0XS6ezkNB4edXDvTN0Bb/HkGCTz
	 GNkR4WQbifJJe1KAd+G54kQSjZM4EXyo9UwkV/CZWCL/VjUTVNCYbOEDrqtyNbBkuQMpvYVv1c74
	 8ePp82+v0+4dkxRjRLUUzAuPeBtO6KxB+zjPIuvfSwVaF513CmpTrys2E7X+s6+YiHJTox+lzJsK
	 WingFI04HcbO9tNm3WMR9DGBuIc2Hidu+slx5fgRfyvAOq6pXoHcH3OFh7rkWEw7t+ybJ9LcMRT9
	 /H7WEC6kNxkPMpSGU9iCub/C3xG2Eh9paV3+mv9rwwVW/bJSH3Lu23uUlCy5g95R7v/vyekZbiRN
	 lhnFPR9s0czP+DOD1Qb9G0c1iRKuAeIgROCdj1mO8=
X-QQ-XMRINFO: NS+P29fieYNw95Bth2bWPxk=
From: Edward Adam Davis <eadavis@qq.com>
To: binbin.wu@linux.intel.com
Cc: bp@alien8.de,
	dave.hansen@linux.intel.com,
	eadavis@qq.com,
	hpa@zytor.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mingo@redhat.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	tglx@linutronix.de,
	x86@kernel.org
Subject: Re: [PATCH next] KVM: VMX: add noinstr for is_td_vcpu and is_td
Date: Tue, 27 May 2025 13:39:05 +0800
X-OQ-MSGID: <20250527053904.1669268-2-eadavis@qq.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <58339ba1-d7ac-45dd-9d62-1a023d528f50@linux.intel.com>
References: <58339ba1-d7ac-45dd-9d62-1a023d528f50@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 27 May 2025 13:31:12 +0800, Binbin Wu wrote:
> noinstr is not needed when the functions are __always_inline.
Right.
> 
> >   
> >   #else
> >   
> > -static inline bool is_td(struct kvm *kvm) { return false; }
> > -static inline bool is_td_vcpu(struct kvm_vcpu *vcpu) { return false; }
> > +static noinstr bool is_td(struct kvm *kvm) { return false; }
> > +static noinstr bool is_td_vcpu(struct kvm_vcpu *vcpu) { return false; }
> 
> Oops, overlooked the !CONFIG_KVM_INTEL_TDX case.
> 
> How about:
> 
> diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
> index 8f46a06e2c44..a0c5e8781c33 100644
> --- a/arch/x86/kvm/vmx/common.h
> +++ b/arch/x86/kvm/vmx/common.h
> @@ -71,8 +71,8 @@ static __always_inline bool is_td_vcpu(struct kvm_vcpu *vcpu)
> 
>   #else
> 
> -static inline bool is_td(struct kvm *kvm) { return false; }
> -static inline bool is_td_vcpu(struct kvm_vcpu *vcpu) { return false; }
> +static __always_inline bool is_td(struct kvm *kvm) { return false; }
> +static __always_inline bool is_td_vcpu(struct kvm_vcpu *vcpu) { return false; }
Looks good.


